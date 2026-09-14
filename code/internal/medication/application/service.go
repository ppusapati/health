// Package application holds the medication use cases.
package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions (SRS-MED, Wave-1 backlog "med.*").
const (
	// PermPrescriptionRead reads the drug chart.
	PermPrescriptionRead = "med.prescription.read"
	// PermPrescriptionWrite prescribes (SRS-MED-001).
	PermPrescriptionWrite = "med.prescription.write"
	// PermPrescriptionChange holds, restarts and discontinues (SRS-MED-013).
	//
	// Separate from prescribing, because stopping somebody else's medication is
	// an intervention in their clinical plan rather than a continuation of your
	// own. Both sit with clinicians in practice; the split is what lets a
	// hospital withhold one from a role without withholding the other.
	PermPrescriptionChange = "med.prescription.change"
	// PermOverrideSafety answers a safety warning (SRS-MED-003).
	//
	// Its own permission because SRS-MED-003 says the clinician "may override
	// only when policy permits", and policy here is two controls: the tenant's
	// severity ceiling, and who holds this at all. A permission everybody holds
	// is not a permission.
	PermOverrideSafety = "med.safety.override"
	// PermVerify is the pharmacist's check (SRS-MED-006).
	//
	// Held by pharmacists and not by prescribers, which is what makes
	// verification a second pair of eyes. The domain also refuses a
	// self-verification, so a clinician who somehow held both could still not
	// verify their own prescription.
	PermVerify = "med.prescription.verify"
	// PermSubstitute proposes and dispenses a substitution (SRS-MED-011).
	PermSubstitute = "med.substitution.record"
	// PermReconcile performs medication reconciliation (SRS-MED-005).
	PermReconcile = "med.reconciliation.perform"
	// PermConfigure maintains the formulary, the interaction and dose rules,
	// the terminology map and the policy.
	PermConfigure = "med.catalogue.configure"
)

// Events (SRS-MED-014).
//
// Four of the requirement's five. medication.administered is emitted by the
// nursing context, which is the one that witnesses the act: one producer per
// event, so a consumer reconstructing the timeline cannot receive two versions
// of the same moment from two contexts that disagree.
const (
	EventPrescribed   = "medication.prescribed"
	EventVerified     = "medication.verified"
	EventHeld         = "medication.held"
	EventDiscontinued = "medication.discontinued"
	// EventRestarted is not in the requirement's list and is emitted because a
	// timeline that records the stop and not the restart is a timeline that
	// says the patient is off a drug they are on.
	EventRestarted = "medication.restarted"
)

const (
	eventSchemaVersion = 1
	eventSource        = "medication"
)

// Service is the medication use-case façade.
type Service struct {
	uow             ports.UnitOfWork
	prescriptions   ports.PrescriptionRepository
	reconciliations ports.ReconciliationRepository
	substitutions   ports.SubstitutionRepository
	catalogue       ports.CatalogueRepository
	terminology     ports.Terminology
	allergies       ports.Allergies
	patients        ports.PatientContext
	encounters      ports.Encounters
	orders          ports.Orders
	events          ports.EventAppender
	audits          ports.AuditAppender
	ids             ports.IDGenerator
	clock           ports.Clock
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork      ports.UnitOfWork
	Prescriptions   ports.PrescriptionRepository
	Reconciliations ports.ReconciliationRepository
	Substitutions   ports.SubstitutionRepository
	Catalogue       ports.CatalogueRepository
	// Terminology maps a medication onto its ingredients and classes
	// (SRS-MED-002). Nil screens on the prescribed code alone, which catches
	// less — never nothing, and never the wrong thing.
	Terminology ports.Terminology
	// Allergies is the clinical record's list. Nil means no allergy screen at
	// all, which is correct only where no clinical context exists.
	Allergies ports.Allergies
	// Patients supplies the inputs dose rules need. Nil means no dose support,
	// which is the safe absence: SRS-MED-004's advice is advisory, and advice
	// computed from values nobody has is worse than silence.
	Patients   ports.PatientContext
	Encounters ports.Encounters
	// Orders raises the CPOE order a prescription is the detail of. Nil means
	// prescriptions are recorded and no pharmacy hears about them, so the
	// composition root always supplies one.
	Orders ports.Orders
	Events ports.EventAppender
	Audits ports.AuditAppender
	IDs    ports.IDGenerator
	Clock  ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, prescriptions: d.Prescriptions,
		reconciliations: d.Reconciliations, substitutions: d.Substitutions,
		catalogue: d.Catalogue, terminology: d.Terminology,
		allergies: d.Allergies, patients: d.Patients,
		encounters: d.Encounters, orders: d.Orders,
		events: d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 50
	MaxPageSize     = 200
	// MaxCurrentMedications bounds the list an interaction screen reads. A
	// patient on more than this is a patient whose chart needs a pharmacist
	// rather than a longer query.
	MaxCurrentMedications = 100
)

func clampPageSize(requested int32) int32 {
	switch {
	case requested <= 0:
		return DefaultPageSize
	case requested > MaxPageSize:
		return MaxPageSize
	default:
		return requested
	}
}

// authorize is the shared preamble.
func (s *Service) authorize(ctx context.Context, permission, resourceType,
	resourceID string, mutating bool) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: permission,
		Mutating:   mutating,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, permission, resourceType, resourceID,
			decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("MED_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// requireOpenEncounter is the patient/encounter validation a prescription needs.
func (s *Service) requireOpenEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID, patientID string) (
	ports.EncounterState, error) {

	if s.encounters == nil || encounterID == "" {
		return ports.EncounterState{PatientID: patientID, Open: true}, nil
	}

	state, err := s.encounters.Check(ctx, scope, encounterID)
	if err != nil {
		return ports.EncounterState{}, err
	}
	if !state.Open {
		return ports.EncounterState{}, rpcerr.FailedPrecondition(
			"MED_ENCOUNTER_NOT_OPEN",
			"that encounter no longer accepts prescriptions")
	}
	if patientID != "" && state.PatientID != "" && state.PatientID != patientID {
		return ports.EncounterState{}, rpcerr.Invalid(
			"MED_PATIENT_ENCOUNTER_MISMATCH",
			"that encounter belongs to a different patient")
	}
	return state, nil
}

// facilityLocation resolves a facility's zone for the schedule.
//
// UTC where the zone is unknown or unloadable, and visibly so: a schedule in
// the wrong zone is an hour out twice a year, and falling back loudly is better
// than refusing every prescription because a time-zone database is stale.
func facilityLocation(name string) *time.Location {
	if name == "" {
		return time.UTC
	}
	loc, err := time.LoadLocation(name)
	if err != nil {
		return time.UTC
	}
	return loc
}

// appendEvent writes to the transactional outbox.
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateID string, payload map[string]any, now time.Time) error {

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("MED_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}

	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: "prescription",
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
}

// prescriptionEventPayload is what every medication event carries.
//
// Identifiers, the drug, the status and the times. Not the indication, not the
// instructions, and not the safety findings: an event stream is read by more
// systems, by more people and under fewer controls than the record it describes
// (SRS-API-009), and "prescribed amitriptyline for neuropathic pain" says
// something about the patient that "prescribed amitriptyline" does not.
func prescriptionEventPayload(p *domain.Prescription) map[string]any {
	return map[string]any{
		"prescription_id": p.ID, "order_id": p.OrderID, "number": p.OrderNumber,
		"patient_id": p.PatientID, "encounter_id": p.EncounterID,
		"facility_id": p.FacilityID, "prescriber_id": p.PrescriberID,
		"medication_system": p.Ingredient.System, "medication_code": p.Ingredient.Code,
		"route": p.Route, "therapy_status": string(p.Status),
		"starts_at": p.StartsAt.UTC().Format(time.RFC3339),
		"version":   p.Version,
	}
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

	r.AuditID = s.ids.NewID()
	r.ActorID = session.SubjectID
	r.CorrelationID = session.CorrelationID
	r.RequestID = session.RequestID
	r.PurposeOfUse = string(session.Purpose)
	r.BreakGlass = session.BreakGlass
	r.OccurredAt = now.UTC()
	if r.TenantID == "" {
		r.TenantID = session.TenantID
	}
	return s.audits.Append(ctx, r)
}

func (s *Service) auditDenied(ctx context.Context, session authctx.Session,
	action, resourceType, resourceID, reason string) {

	// Best effort: a denial that cannot be recorded must not turn into a
	// different error for the caller, who is being refused either way.
	_ = s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: action,
		ResourceType: resourceType, ResourceID: resourceID,
		Outcome: audit.OutcomeDenied, Reason: reason,
	}, s.clock.Now())
}

// medicationError maps a domain refusal onto the wire contract.
func medicationError(err error) error {
	var refusal domain.SafetyRefusal
	if errors.As(err, &refusal) {
		// The findings travel as field violations so a client can show each
		// warning against the thing it is about, rather than concatenating them
		// into a sentence a prescriber stops reading after the first clause.
		violations := make([]rpcerr.FieldViolation, 0, len(refusal.Findings))
		for _, f := range refusal.Findings {
			violations = append(violations, rpcerr.FieldViolation{
				Field:  string(f.Kind) + ":" + f.RuleID,
				Reason: f.Summary + " [" + f.RuleID + " " + f.RuleVersion + "]",
			})
		}
		return rpcerr.FailedPrecondition("MED_SAFETY_UNANSWERED",
			refusal.Error()).WithViolations(violations...)
	}
	var incomplete domain.IncompleteReconciliation
	if errors.As(err, &incomplete) {
		violations := make([]rpcerr.FieldViolation, 0, len(incomplete.Outstanding))
		for _, item := range incomplete.Outstanding {
			violations = append(violations, rpcerr.FieldViolation{
				Field:  "home_medication",
				Reason: item.Medication.Display + " has no disposition",
			})
		}
		return rpcerr.FailedPrecondition("MED_RECONCILIATION_INCOMPLETE",
			incomplete.Error()).WithViolations(violations...)
	}
	var prn domain.PRNRefusal
	if errors.As(err, &prn) {
		return rpcerr.FailedPrecondition("MED_PRN_NOT_DUE", prn.Error())
	}
	if errors.Is(err, domain.ErrNotAllowed) {
		return rpcerr.FailedPrecondition("MED_NOT_ALLOWED", err.Error())
	}
	if errors.Is(err, domain.ErrInvalidPrescription) {
		return rpcerr.Invalid("MED_INVALID", err.Error())
	}
	return err
}

// mapConflict turns a repository version conflict into the wire contract.
func mapConflict(err error) error {
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("MED_VERSION_CONFLICT",
			"the prescription changed since it was read, or is no longer in that state")
	}
	return err
}
