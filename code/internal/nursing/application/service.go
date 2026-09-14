// Package application holds the nursing use cases.
package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions (SRS-NUR, Wave-1 backlog "nur.*").
const (
	// PermNursingRead reads the nursing record.
	PermNursingRead = "nur.record.read"
	// PermNursingWrite charts observations, fluids, assessments, devices,
	// wounds, education and tasks.
	PermNursingWrite = "nur.record.write"
	// PermAdminister records a medication administration (SRS-NUR-009).
	//
	// Its own permission, and not held by the desk. Giving a drug is the act
	// the whole eMAR exists to record, and behind one write permission a ward
	// clerk could chart a dose under their own name.
	PermAdminister = "nur.medication.administer"
	// PermOverrideVerification completes an administration despite a failed or
	// absent barcode check (SRS-NUR-008).
	//
	// Separate again, so a hospital can withhold it. The control that actually
	// bites is the mandatory reason and the stored report — a permission
	// everybody holds is not a permission — but a hospital that wants the
	// override restricted to senior staff must be able to say so.
	PermOverrideVerification = "nur.medication.override"
	// PermRestrain applies or renews a restraint (SRS-NUR-013).
	PermRestrain = "nur.restraint.manage"
	// PermTransfuse starts and monitors a transfusion (SRS-NUR-014).
	PermTransfuse = "nur.transfusion.manage"
	// PermAssign assigns nurses to patients and beds (SRS-NUR-017).
	PermAssign = "nur.assignment.manage"
	// PermNursingConfigure maintains assessment templates, risk scales, the
	// administration policy and the acuity weights.
	PermNursingConfigure = "nur.record.configure"
	// PermDowntime declares and reconciles a downtime episode (SRS-NUR-018).
	PermDowntime = "nur.downtime.manage"
)

// Events.
//
// Named narrowly and carrying identifiers rather than content, for the reason
// SRS-API-009 gives: an event stream is read by more systems, by more people
// and under fewer controls than the record it describes. A payload here says a
// dose was given and which order it was against; it does not say what the drug
// was for.
const (
	EventMedicationAdministered = "medication.administered"
	// EventVerificationOverridden is what makes SRS-NUR-008's override
	// reportable outside the ward that performed it.
	EventVerificationOverridden = "medication.verification_overridden"
	EventRiskAssessed           = "nursing.risk_assessed"
	EventHandoverAcknowledged   = "nursing.handover_acknowledged"
	EventRestraintApplied       = "nursing.restraint_applied"
	// EventRestraintAuthorizationExpired is emitted rather than merely listed,
	// because SRS-NUR-013 asks for an alert and a list nobody queries is not
	// one.
	EventRestraintAuthorizationExpired = "nursing.restraint_authorization_expired"
	EventTransfusionReaction           = "nursing.transfusion_reaction"
	EventTaskEscalated                 = "nursing.task_escalated"
)

const (
	eventSchemaVersion = 1
	eventSource        = "nursing"
)

// Service is the nursing use-case façade.
type Service struct {
	uow            ports.UnitOfWork
	assessments    ports.AssessmentRepository
	risks          ports.RiskRepository
	flowsheet      ports.FlowsheetRepository
	devices        ports.DeviceRepository
	administration ports.AdministrationRepository
	orders         ports.MedicationOrders
	tasks          ports.TaskRepository
	plans          ports.CarePlanRepository
	handovers      ports.HandoverRepository
	safety         ports.SafetyRepository
	ward           ports.WardRepository
	downtime       ports.DowntimeRepository
	encounters     ports.Encounters
	consents       ports.Consents
	images         ports.ImageStore
	events         ports.EventAppender
	audits         ports.AuditAppender
	ids            ports.IDGenerator
	clock          ports.Clock
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork     ports.UnitOfWork
	Assessments    ports.AssessmentRepository
	Risks          ports.RiskRepository
	Flowsheet      ports.FlowsheetRepository
	Devices        ports.DeviceRepository
	Administration ports.AdministrationRepository
	// Orders is the medication seam (SRS-NUR-007). Nil means no order service
	// is wired, and every administration is then refused rather than accepted
	// unverified: an eMAR that cannot check verification must not pretend it
	// has.
	Orders    ports.MedicationOrders
	Tasks     ports.TaskRepository
	Plans     ports.CarePlanRepository
	Handovers ports.HandoverRepository
	Safety    ports.SafetyRepository
	Ward      ports.WardRepository
	Downtime  ports.DowntimeRepository
	// Encounters reports whether a visit still accepts content and which
	// patient it belongs to. Nil accepts everything, which is correct only
	// where no encounter context exists.
	Encounters ports.Encounters
	// Images holds wound photograph bytes (SRS-NUR-012). Nil is a valid
	// deployment and the default: one that stores no binary content refuses to
	// attach a photograph rather than recording an image pointing at nothing.
	Images ports.ImageStore

	// Consents answers whether a consent covers clinical photography
	// (SRS-NUR-012). Nil refuses every image, which is the safe direction.
	Consents ports.Consents
	Events   ports.EventAppender
	Audits   ports.AuditAppender
	IDs      ports.IDGenerator
	Clock    ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, assessments: d.Assessments, risks: d.Risks,
		flowsheet: d.Flowsheet, devices: d.Devices,
		administration: d.Administration, orders: d.Orders,
		tasks: d.Tasks, plans: d.Plans, handovers: d.Handovers,
		safety: d.Safety, ward: d.Ward, downtime: d.Downtime,
		encounters: d.Encounters, consents: d.Consents, images: d.Images,
		events: d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 50
	MaxPageSize     = 200
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
			rpcerr.PermissionDenied("NUR_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// requireOpenEncounter refuses nursing content against a visit that is closed,
// cancelled or retracted, and checks the patient the caller named is the one
// the encounter belongs to.
//
// The second half matters more here than anywhere else in the system: a set of
// observations filed against the right encounter but the wrong patient is the
// wrong-patient error every other control in this context exists to prevent.
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
			"NUR_ENCOUNTER_NOT_OPEN",
			"that encounter no longer accepts nursing content")
	}
	if patientID != "" && state.PatientID != "" && state.PatientID != patientID {
		return ports.EncounterState{}, rpcerr.Invalid(
			"NUR_PATIENT_ENCOUNTER_MISMATCH",
			"that encounter belongs to a different patient")
	}
	return state, nil
}

// appendEvent writes to the transactional outbox.
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("NUR_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}

	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
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

// nursingError maps a domain refusal onto the wire contract.
func nursingError(err error) error {
	var verification domain.ErrVerificationFailed
	if errors.As(err, &verification) {
		// FAILED_PRECONDITION rather than INVALID_ARGUMENT: the request is
		// well-formed, and what is wrong is the state at the bedside. The
		// caller's remedy is to scan again or to override, not to re-send.
		return rpcerr.FailedPrecondition("NUR_VERIFICATION_FAILED",
			verification.Error())
	}
	var duplicate domain.ErrDuplicateAdministration
	if errors.As(err, &duplicate) {
		return rpcerr.AlreadyExists("NUR_DUPLICATE_ADMINISTRATION",
			duplicate.Error())
	}
	if errors.Is(err, domain.ErrNotAllowed) {
		return rpcerr.FailedPrecondition("NUR_NOT_ALLOWED", err.Error())
	}
	if errors.Is(err, domain.ErrInvalidNursingRecord) {
		return rpcerr.Invalid("NUR_INVALID", err.Error())
	}
	return err
}

// mapConflict turns a repository version conflict into the wire contract.
func mapConflict(err error) error {
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("NUR_VERSION_CONFLICT",
			"the record changed since it was read, or is no longer in that state")
	}
	return err
}
