package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The coded clinical record: problems, allergies, observations, procedures,
// care plans and the banner
// (SRS-CLN-001, 003 … 007, 011, 012).

// RecordProblemInput adds a condition to the problem list.
type RecordProblemInput struct {
	PatientID       string
	EncounterID     string
	Code            domain.Coding
	Note            string
	Status          domain.ProblemStatus
	OnsetAt         time.Time
	Confidentiality domain.Confidentiality
	Context         domain.PatientContext
}

// RecordProblem adds to the problem list (SRS-CLN-003).
func (s *Service) RecordProblem(ctx context.Context, in RecordProblemInput) (
	domain.Problem, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "problem",
		in.PatientID, true)
	if err != nil {
		return domain.Problem{}, err
	}

	now := s.clock.Now()
	status := in.Status
	if status == "" {
		status = domain.ProblemActive
	}
	confidentiality := in.Confidentiality
	if confidentiality == "" {
		confidentiality = domain.ConfidentialityNormal
	}

	var out domain.Problem
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := checkContext(in.Context, in.PatientID, in.EncounterID,
			"recording this problem", now); err != nil {
			return err
		}
		if err := s.requireWritableEncounter(ctx, scope, in.EncounterID,
			in.PatientID); err != nil {
			return err
		}

		problem, err := domain.NewProblem(s.ids.NewID(), scope.TenantID(),
			in.PatientID, in.EncounterID, in.Code, in.Note, status, in.OnsetAt,
			confidentiality, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.records.InsertProblem(ctx, scope, problem); err != nil {
			return err
		}
		if err := s.emitProblemEvent(ctx, session, problem, now); err != nil {
			return err
		}

		out = problem
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "problem", ResourceID: problem.ID,
			Outcome: audit.OutcomeSuccess,
			// The status, never the code: an audit trail carrying the diagnosis
			// would be a second copy of the patient's conditions, readable by
			// everybody who can read audit.
			Reason: "problem recorded as " + string(problem.Status),
		}, now)
	})
	if err != nil {
		return domain.Problem{}, mapConflict(err)
	}
	return out, nil
}

// UpdateProblemInput moves a problem on the list.
type UpdateProblemInput struct {
	ProblemID string
	Status    domain.ProblemStatus
	// ResolvedAt is when it ended, for a resolution.
	ResolvedAt time.Time
}

// UpdateProblem resolves or reclassifies a problem (SRS-CLN-003).
//
// The entry stays on the list either way: a resolved problem is history, not an
// absence.
func (s *Service) UpdateProblem(ctx context.Context, in UpdateProblemInput) (
	domain.Problem, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "problem",
		in.ProblemID, true)
	if err != nil {
		return domain.Problem{}, err
	}

	now := s.clock.Now()

	var out domain.Problem
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		problem, err := s.records.GetProblem(ctx, scope, in.ProblemID)
		if err != nil {
			return err
		}

		before := problem.Version
		if in.Status == domain.ProblemResolved {
			err = problem.Resolve(in.ResolvedAt, session.SubjectID, now)
		} else {
			err = problem.SetStatus(in.Status, session.SubjectID, now)
		}
		if err != nil {
			return clinicalError(err)
		}

		if err := s.records.UpdateProblem(ctx, scope, problem, before); err != nil {
			return err
		}
		if err := s.emitProblemEvent(ctx, session, problem, now); err != nil {
			return err
		}

		out = problem
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "problem", ResourceID: problem.ID,
			Outcome: audit.OutcomeSuccess, Reason: "problem " + string(problem.Status),
		}, now)
	})
	if err != nil {
		return domain.Problem{}, mapConflict(err)
	}
	return out, nil
}

func (s *Service) emitProblemEvent(ctx context.Context, session authctx.Session,
	p domain.Problem, now time.Time) error {

	return s.appendEvent(ctx, session, EventProblemUpdated, "problem", p.ID,
		map[string]any{
			"problem_id":  p.ID,
			"patient_id":  p.PatientID,
			"code_system": p.Code.System,
			"code":        p.Code.Code,
			"status":      string(p.Status),
			// So a consumer can tell restricted content apart without being
			// able to read it.
			"confidentiality": string(p.Confidentiality),
		}, now)
}

// ListProblems returns the problem list, resolved entries included.
func (s *Service) ListProblems(ctx context.Context, patientID string, activeOnly bool,
	pageSize int32) (domain.ProblemList, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "problem",
		patientID, false)
	if err != nil {
		return nil, err
	}

	var out domain.ProblemList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		problems, err := s.records.Problems(ctx, scope, patientID, activeOnly,
			clampPageSize(pageSize))
		if err != nil {
			return err
		}

		filtered := make(domain.ProblemList, 0, len(problems))
		for _, p := range problems {
			if visible(session, p.Confidentiality) {
				filtered = append(filtered, p)
			}
		}
		out = filtered

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "problem", ResourceID: patientID,
			Outcome: audit.OutcomeSuccess, Reason: "problem list read",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// RecordAllergyInput records an allergy or intolerance.
type RecordAllergyInput struct {
	PatientID    string
	EncounterID  string
	Substance    domain.Coding
	Kind         domain.AllergyKind
	Criticality  domain.AllergyCriticality
	Verification domain.AllergyVerification
	Reactions    []domain.Reaction
	OnsetAt      time.Time
	Note         string
	Context      domain.PatientContext
}

// RecordAllergy records an allergy (SRS-CLN-004).
//
// The acceptance criterion is that it reaches medication decision support
// "immediately after commit", which is why the substance must be coded and why
// this writes in one transaction with its event: a prescription checked between
// the insert and a later publish would be checked against a chart that does not
// yet know.
func (s *Service) RecordAllergy(ctx context.Context, in RecordAllergyInput) (
	domain.Allergy, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "allergy",
		in.PatientID, true)
	if err != nil {
		return domain.Allergy{}, err
	}

	now := s.clock.Now()
	kind := in.Kind
	if kind == "" {
		kind = domain.AllergyTrue
	}
	criticality := in.Criticality
	if criticality == "" {
		// Not "low". A system that defaulted an unassessed allergy to low would
		// tell a prescriber there is no danger when what it means is that
		// nobody has looked.
		criticality = domain.CriticalityUnableToAssess
	}
	verification := in.Verification
	if verification == "" {
		verification = domain.VerificationUnconfirmed
	}

	var out domain.Allergy
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := checkContext(in.Context, in.PatientID, in.EncounterID,
			"recording this allergy", now); err != nil {
			return err
		}
		if err := s.requireWritableEncounter(ctx, scope, in.EncounterID,
			in.PatientID); err != nil {
			return err
		}

		allergy, err := domain.NewAllergy(s.ids.NewID(), scope.TenantID(),
			in.PatientID, in.EncounterID, in.Substance, kind, criticality,
			verification, in.Reactions, in.OnsetAt, in.Note, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.records.InsertAllergy(ctx, scope, allergy); err != nil {
			return err
		}
		if err := s.emitAllergyEvent(ctx, session, allergy, now); err != nil {
			return err
		}

		out = allergy
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "allergy", ResourceID: allergy.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(allergy.Kind) + ", " + string(allergy.Criticality),
		}, now)
	})
	if err != nil {
		return domain.Allergy{}, mapConflict(err)
	}
	return out, nil
}

// VerifyAllergy records that somebody investigated an allergy (SRS-CLN-004).
func (s *Service) VerifyAllergy(ctx context.Context, allergyID string,
	verification domain.AllergyVerification) (domain.Allergy, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "allergy",
		allergyID, true)
	if err != nil {
		return domain.Allergy{}, err
	}

	now := s.clock.Now()

	var out domain.Allergy
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		allergy, err := s.records.GetAllergy(ctx, scope, allergyID)
		if err != nil {
			return err
		}

		before := allergy.Version
		if err := allergy.SetVerification(verification, session.SubjectID, now); err != nil {
			return clinicalError(err)
		}
		if err := s.records.UpdateAllergy(ctx, scope, allergy, before); err != nil {
			return err
		}
		if err := s.emitAllergyEvent(ctx, session, allergy, now); err != nil {
			return err
		}

		out = allergy
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "allergy", ResourceID: allergy.ID,
			Outcome: audit.OutcomeSuccess, Reason: "verification " + string(verification),
		}, now)
	})
	if err != nil {
		return domain.Allergy{}, mapConflict(err)
	}
	return out, nil
}

func (s *Service) emitAllergyEvent(ctx context.Context, session authctx.Session,
	a domain.Allergy, now time.Time) error {

	return s.appendEvent(ctx, session, EventAllergyUpdated, "allergy", a.ID,
		map[string]any{
			"allergy_id": a.ID,
			"patient_id": a.PatientID,
			// The substance travels: medication decision support cannot check a
			// prescription without it, and the alternative is every consumer
			// calling back for the one field it needs.
			"substance_system": a.Substance.System,
			"substance_code":   a.Substance.Code,
			"kind":             string(a.Kind),
			"criticality":      string(a.Criticality),
			"verification":     string(a.Verification),
			"active":           a.Active(),
		}, now)
}

// ListAllergies returns a patient's allergies, most dangerous first.
func (s *Service) ListAllergies(ctx context.Context, patientID string, activeOnly bool,
	pageSize int32) (domain.AllergyList, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "allergy",
		patientID, false)
	if err != nil {
		return nil, err
	}

	var out domain.AllergyList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		allergies, err := s.records.Allergies(ctx, scope, patientID, activeOnly,
			clampPageSize(pageSize))
		if err != nil {
			return err
		}
		out = allergies
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "allergy", ResourceID: patientID,
			Outcome: audit.OutcomeSuccess, Reason: "allergy list read",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// RecordObservationInput records a measurement or finding.
type RecordObservationInput struct {
	PatientID     string
	EncounterID   string
	Code          domain.Coding
	Value         domain.Quantity
	TextValue     string
	CodedValue    domain.Coding
	ReferenceLow  *float64
	ReferenceHigh *float64
	ReferenceText string
	// Interpretation and its source come from the authoritative diagnostic
	// service and are never derived here (SRS-CLN-011).
	Interpretation       domain.Interpretation
	InterpretationSource string
	Status               domain.ObservationStatus
	EffectiveAt          time.Time
	IssuedAt             time.Time
	PerformerID          string
	DeviceID             string
	// SourceSystem marks an imported result, and Provenance records where it
	// came from (SRS-CLN-010).
	SourceSystem string
	Provenance   *domain.ProvenanceInput
	Note         string
	Context      domain.PatientContext
}

// RecordObservation records a result (SRS-CLN-005, SRS-CLN-011).
func (s *Service) RecordObservation(ctx context.Context, in RecordObservationInput) (
	domain.Observation, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "observation",
		in.PatientID, true)
	if err != nil {
		return domain.Observation{}, err
	}

	now := s.clock.Now()
	status := in.Status
	if status == "" {
		status = domain.ObservationFinal
	}
	interpretation := in.Interpretation
	if interpretation == "" {
		// "Nobody said" rather than "it is fine": a chart that showed the
		// second when it meant the first would be reassuring about a result
		// nobody assessed.
		interpretation = domain.InterpretationUnknown
	}

	var out domain.Observation
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := checkContext(in.Context, in.PatientID, in.EncounterID,
			"recording this result", now); err != nil {
			return err
		}
		if err := s.requireWritableEncounter(ctx, scope, in.EncounterID,
			in.PatientID); err != nil {
			return err
		}

		observation, err := domain.NewObservation(s.ids.NewID(), scope.TenantID(),
			domain.NewObservationInput{
				PatientID: in.PatientID, EncounterID: in.EncounterID,
				Code: in.Code, Value: in.Value, TextValue: in.TextValue,
				CodedValue:   in.CodedValue,
				ReferenceLow: in.ReferenceLow, ReferenceHigh: in.ReferenceHigh,
				ReferenceText: in.ReferenceText, Interpretation: interpretation,
				InterpretationSource: in.InterpretationSource, Status: status,
				EffectiveAt: in.EffectiveAt, IssuedAt: in.IssuedAt,
				PerformerID: in.PerformerID, DeviceID: in.DeviceID,
				SourceSystem: in.SourceSystem, Note: in.Note,
			}, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.records.InsertObservation(ctx, scope, observation); err != nil {
			return err
		}

		// SRS-CLN-010: an imported result must be distinguishable from a local
		// measurement, and the provenance is written in the same transaction so
		// there is never a moment where it is not.
		if in.Provenance != nil {
			provenance, err := domain.NewProvenance(s.ids.NewID(), scope.TenantID(),
				"observation", observation.ID, *in.Provenance, now)
			if err != nil {
				return clinicalError(err)
			}
			if err := s.governance.InsertProvenance(ctx, scope, provenance); err != nil {
				return err
			}
		}

		if err := s.appendEvent(ctx, session, EventObservationRecorded, "observation",
			observation.ID, map[string]any{
				"observation_id": observation.ID,
				"patient_id":     observation.PatientID,
				"encounter_id":   observation.EncounterID,
				"code_system":    observation.Code.System,
				"code":           observation.Code.Code,
				// The interpretation travels because a downstream worklist
				// cannot triage without it. The value does not: a result value
				// on an event stream is clinical content outside the chart's
				// access rules.
				"interpretation": string(observation.Interpretation),
				"critical":       observation.Interpretation.Critical(),
				"status":         string(observation.Status),
				"effective_at":   observation.EffectiveAt.Format(time.RFC3339),
				"external":       observation.External(),
			}, now); err != nil {
			return err
		}

		// SRS-CLN-012 with SRS-OPSNFR-003. Raised inside this transaction, so
		// a crash between the result being recorded and the escalation being
		// raised cannot leave a critical result nobody was ever told about.
		// Delivery happens afterwards, driven from the row.
		//
		// A failure here fails the whole transaction on purpose. The
		// alternative -- record the result and swallow the escalation error --
		// is a critical potassium sitting in a chart with the safety net
		// silently switched off, and the ward has no way to know. A caller
		// who gets an error retries; a caller who gets silence does not.
		if s.escalations != nil && observation.NeedsAcknowledgement() {
			if err := s.escalations.RaiseCritical(ctx, scope, ports.CriticalNotice{
				ObservationID:  observation.ID,
				PatientID:      observation.PatientID,
				EncounterID:    observation.EncounterID,
				FacilityID:     session.ActiveFacilityID,
				Display:        observation.Code.Display,
				Interpretation: string(observation.Interpretation),
				At:             now,
			}); err != nil {
				return err
			}
		}

		out = observation
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "observation", ResourceID: observation.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "result recorded, " + string(observation.Interpretation),
		}, now)
	})
	if err != nil {
		return domain.Observation{}, mapConflict(err)
	}
	return out, nil
}

// ListObservations returns a patient's results, or one code's trend.
func (s *Service) ListObservations(ctx context.Context, q ports.ObservationQuery) (
	domain.ObservationList, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "observation",
		q.PatientID, false)
	if err != nil {
		return nil, err
	}
	q.Limit = clampPageSize(q.Limit)

	var out domain.ObservationList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		observations, err := s.records.Observations(ctx, scope, q)
		if err != nil {
			return err
		}
		out = observations
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "observation", ResourceID: q.PatientID,
			Outcome: audit.OutcomeSuccess, Reason: "results read",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// CriticalResult is an unacknowledged critical result and how overdue it is.
type CriticalResult struct {
	Observation domain.Observation
	// DueEscalations is how many times this should have escalated by now
	// (SRS-CLN-012). Computed rather than stored, so a policy change takes
	// effect on results already outstanding — which is the point of changing it.
	DueEscalations int
}

// ListCriticalResults returns the safety worklist (SRS-CLN-012).
func (s *Service) ListCriticalResults(ctx context.Context, pageSize int32) (
	[]CriticalResult, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "observation", "", false)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var out []CriticalResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		observations, err := s.records.UnacknowledgedCritical(ctx, scope,
			clampPageSize(pageSize))
		if err != nil {
			return err
		}

		results := make([]CriticalResult, 0, len(observations))
		for _, o := range observations {
			notified := o.IssuedAt
			if notified.IsZero() {
				notified = o.RecordedAt
			}
			results = append(results, CriticalResult{
				Observation:    o,
				DueEscalations: s.escalation.DueEscalations(notified, now),
			})
		}
		out = results

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "observation", ResourceID: "",
			Outcome: audit.OutcomeSuccess, Reason: "critical result worklist read",
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// AcknowledgeResultInput records a clinician acting on a critical result.
type AcknowledgeResultInput struct {
	ObservationID string
	// Action is what the clinician did. Mandatory: "seen" is not a clinical
	// response to a potassium of 6.9.
	Action string
}

// AcknowledgeCriticalResult records the action taken (SRS-CLN-012).
func (s *Service) AcknowledgeCriticalResult(ctx context.Context,
	in AcknowledgeResultInput) (domain.CriticalAcknowledgement, error) {

	session, scope, err := s.authorize(ctx, PermResultAcknowledge, "observation",
		in.ObservationID, true)
	if err != nil {
		return domain.CriticalAcknowledgement{}, err
	}

	now := s.clock.Now()

	var out domain.CriticalAcknowledgement
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		observation, err := s.records.GetObservation(ctx, scope, in.ObservationID)
		if err != nil {
			return err
		}
		if !observation.NeedsAcknowledgement() {
			// Acknowledging an ordinary result would fill the safety report
			// that exists to count the ones that mattered.
			return rpcerr.FailedPrecondition("CLN_NOT_CRITICAL",
				"that result is not flagged critical by the reporting service")
		}

		notified := observation.IssuedAt
		if notified.IsZero() {
			notified = observation.RecordedAt
		}

		acknowledgement, err := domain.NewCriticalAcknowledgement(s.ids.NewID(),
			scope.TenantID(), observation.ID, observation.PatientID,
			session.SubjectID, in.Action, notified, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.records.InsertAcknowledgement(ctx, scope, acknowledgement); err != nil {
			return err
		}

		payload := map[string]any{
			"observation_id":  observation.ID,
			"patient_id":      observation.PatientID,
			"acknowledged_by": session.SubjectID,
			"interpretation":  string(observation.Interpretation),
		}
		if delay, known := acknowledgement.Delay(); known {
			// The gap between notification and acknowledgement is the number a
			// safety review wants, and computing it downstream would mean
			// every consumer re-deriving it from two timestamps.
			payload["delay_seconds"] = int64(delay.Seconds())
		}
		if err := s.appendEvent(ctx, session, EventCriticalResultAcknowledged,
			"observation", observation.ID, payload, now); err != nil {
			return err
		}

		out = acknowledgement
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermResultAcknowledge,
			ResourceType: "observation", ResourceID: observation.ID,
			Outcome: audit.OutcomeSuccess,
			// The action is in the acknowledgement record, which has the access
			// rules the audit trail does not.
			Reason: "critical result acknowledged",
		}, now)
	})
	if err != nil {
		return domain.CriticalAcknowledgement{}, mapConflict(err)
	}
	return out, nil
}

// RecordProcedureInput records something done to a patient.
type RecordProcedureInput struct {
	PatientID      string
	EncounterID    string
	Code           domain.Coding
	Status         domain.ProcedureStatus
	Indication     domain.Coding
	Performers     []domain.Performer
	BodySite       domain.Coding
	Laterality     domain.Laterality
	Outcome        string
	Complications  []domain.Coding
	OrderIDs       []string
	DeviceIDs      []string
	SpecimenIDs    []string
	PerformedStart time.Time
	PerformedEnd   time.Time
	Note           string
	// RequireConsent checks that the patient consented to this procedure
	// before recording it (SRS-CLN-013).
	RequireConsent bool
	Context        domain.PatientContext
}

// RecordProcedure records a procedure (SRS-CLN-006).
func (s *Service) RecordProcedure(ctx context.Context, in RecordProcedureInput) (
	domain.Procedure, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "procedure",
		in.PatientID, true)
	if err != nil {
		return domain.Procedure{}, err
	}

	now := s.clock.Now()
	laterality := in.Laterality
	if laterality == "" {
		// Not "not applicable". An omission must not look like a decision, and
		// wrong-side surgery is a never-event.
		laterality = domain.LateralityUnspecified
	}

	var out domain.Procedure
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := checkContext(in.Context, in.PatientID, in.EncounterID,
			"recording this procedure", now); err != nil {
			return err
		}
		if err := s.requireWritableEncounter(ctx, scope, in.EncounterID,
			in.PatientID); err != nil {
			return err
		}

		// SRS-CLN-013: "clinical action checks required consent where
		// configured".
		if in.RequireConsent {
			consents, err := s.governance.Consents(ctx, scope, in.PatientID,
				domain.ConsentProcedure, MaxPageSize)
			if err != nil {
				return err
			}
			if !consents.Permits(domain.ConsentProcedure, in.Code, now) {
				code := "CLN_CONSENT_MISSING"
				message := "no valid consent is recorded for this procedure"
				if consents.Refused(domain.ConsentProcedure, now) {
					// A recorded refusal is a different fact from nobody having
					// asked, and a clerk chasing a missing form needs to know
					// which they are looking at.
					code = "CLN_CONSENT_REFUSED"
					message = "the patient has refused consent for this procedure"
				}
				return rpcerr.FailedPrecondition(code, message)
			}
		}

		procedure, err := domain.NewProcedure(s.ids.NewID(), scope.TenantID(),
			domain.NewProcedureInput{
				PatientID: in.PatientID, EncounterID: in.EncounterID,
				Code: in.Code, Status: in.Status, Indication: in.Indication,
				Performers: in.Performers, BodySite: in.BodySite,
				Laterality: laterality, Outcome: in.Outcome,
				Complications: in.Complications, OrderIDs: in.OrderIDs,
				DeviceIDs: in.DeviceIDs, SpecimenIDs: in.SpecimenIDs,
				PerformedStart: in.PerformedStart, PerformedEnd: in.PerformedEnd,
				Note: in.Note,
			}, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.records.InsertProcedure(ctx, scope, procedure); err != nil {
			return err
		}

		if procedure.Status == domain.ProcedureCompleted {
			complications := make([]string, 0, len(procedure.Complications))
			for _, c := range procedure.Complications {
				complications = append(complications, c.Code)
			}
			if err := s.appendEvent(ctx, session, EventProcedureCompleted, "procedure",
				procedure.ID, map[string]any{
					"procedure_id": procedure.ID,
					"patient_id":   procedure.PatientID,
					"encounter_id": procedure.EncounterID,
					"code_system":  procedure.Code.System,
					"code":         procedure.Code.Code,
					"laterality":   string(procedure.Laterality),
					// Coded complications so a quality projection can count
					// them without reading the operator's narrative.
					"complications": complications,
				}, now); err != nil {
				return err
			}
		}

		out = procedure
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "procedure", ResourceID: procedure.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "procedure " + string(procedure.Status),
		}, now)
	})
	if err != nil {
		return domain.Procedure{}, mapConflict(err)
	}
	return out, nil
}

// ListProcedures returns a patient's procedures.
func (s *Service) ListProcedures(ctx context.Context, patientID, encounterID string,
	pageSize int32) ([]domain.Procedure, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "procedure",
		patientID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.Procedure
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.records.Procedures(ctx, scope, patientID, encounterID,
			clampPageSize(pageSize))
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "procedure", ResourceID: patientID,
			Outcome: audit.OutcomeSuccess, Reason: "procedures read",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// CreateCarePlanInput starts a plan of care.
type CreateCarePlanInput struct {
	PatientID   string
	EncounterID string
	Title       string
	ProblemIDs  []string
	Goals       []domain.Goal
	Activities  []domain.Activity
	OwnerID     string
	StartsAt    time.Time
	EndsAt      time.Time
}

// CreateCarePlan starts a plan of care (SRS-CLN-007).
func (s *Service) CreateCarePlan(ctx context.Context, in CreateCarePlanInput) (
	domain.CarePlan, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "care_plan",
		in.PatientID, true)
	if err != nil {
		return domain.CarePlan{}, err
	}

	now := s.clock.Now()
	owner := in.OwnerID
	if owner == "" {
		// The clinician creating it, rather than nobody. A plan with no owner
		// is a list of things everybody assumes somebody else is doing.
		owner = session.SubjectID
	}

	var out domain.CarePlan
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.requireWritableEncounter(ctx, scope, in.EncounterID,
			in.PatientID); err != nil {
			return err
		}

		plan, err := domain.NewCarePlan(s.ids.NewID(), scope.TenantID(),
			in.PatientID, in.EncounterID, in.Title, in.ProblemIDs, in.Goals,
			in.Activities, owner, in.StartsAt, in.EndsAt, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.records.InsertCarePlan(ctx, scope, plan); err != nil {
			return err
		}

		out = plan
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "care_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess, Reason: "care plan created",
		}, now)
	})
	if err != nil {
		return domain.CarePlan{}, mapConflict(err)
	}
	return out, nil
}

// UpdateCarePlanInput revises a plan.
type UpdateCarePlanInput struct {
	CarePlanID string
	Status     domain.CarePlanStatus
	Goals      []domain.Goal
	Activities []domain.Activity
	ProblemIDs []string
}

// UpdateCarePlan revises a plan of care.
func (s *Service) UpdateCarePlan(ctx context.Context, in UpdateCarePlanInput) (
	domain.CarePlan, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "care_plan",
		in.CarePlanID, true)
	if err != nil {
		return domain.CarePlan{}, err
	}

	now := s.clock.Now()

	var out domain.CarePlan
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.records.GetCarePlan(ctx, scope, in.CarePlanID)
		if err != nil {
			return err
		}

		before := plan.Version
		if in.Status != "" {
			if err := plan.SetStatus(in.Status, now); err != nil {
				return clinicalError(err)
			}
		}
		if in.Goals != nil {
			plan.Goals = in.Goals
		}
		if in.Activities != nil {
			plan.Activities = in.Activities
		}
		if in.ProblemIDs != nil {
			plan.ProblemIDs = in.ProblemIDs
		}
		plan.UpdatedAt = now.UTC()

		if err := s.records.UpdateCarePlan(ctx, scope, plan, before); err != nil {
			return err
		}

		out = plan
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "care_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess, Reason: "care plan revised",
		}, now)
	})
	if err != nil {
		return domain.CarePlan{}, mapConflict(err)
	}
	return out, nil
}

// ListCarePlans returns a patient's plans.
func (s *Service) ListCarePlans(ctx context.Context, patientID string, activeOnly bool,
	pageSize int32) ([]domain.CarePlan, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "care_plan", patientID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.CarePlan
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.records.CarePlans(ctx, scope, patientID, activeOnly,
			clampPageSize(pageSize))
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// GetBanner assembles the patient banner (SRS-CLN-001).
//
// Assembled here rather than by each screen, because a banner that differs
// between screens is worse than none: a clinician who has learnt to read the
// top-left corner will read it on the screen where it means something else.
func (s *Service) GetBanner(ctx context.Context, patientID, encounterContext string) (
	domain.Banner, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "banner",
		patientID, false)
	if err != nil {
		return domain.Banner{}, err
	}

	var out domain.Banner
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var facts ports.BannerFacts
		if s.patients != nil {
			facts, err = s.patients.Summary(ctx, scope, patientID)
			if err != nil {
				return err
			}
		}

		allergies, err := s.records.Allergies(ctx, scope, patientID, true, MaxPageSize)
		if err != nil {
			return err
		}

		out = domain.BuildBanner(patientID, facts.DisplayName, facts.AgeDisplay,
			facts.Sex, facts.Identifiers, domain.AlertsFromAllergies(allergies),
			encounterContext, facts.Deceased)

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "banner", ResourceID: patientID,
			Outcome: audit.OutcomeSuccess, Reason: "banner read",
		}, s.clock.Now())
	})
	if err != nil {
		return domain.Banner{}, err
	}
	return out, nil
}
