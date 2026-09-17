package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/emergency/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// ArriveInput books a patient into the department (SRS-ER-001).
type ArriveInput struct {
	EncounterID    string
	PatientID      string
	FacilityID     string
	ArrivalMode    domain.ArrivalMode
	ChiefComplaint string
	ArrivedAt      time.Time
	Unidentified   bool
	TemporaryName  string
	MedicoLegal    bool
	MedicoLegalRef string
	Location       string
}

// Arrive records an arrival and opens the department's clocks (SRS-ER-001).
//
// The arrival event is written in the same transaction as the visit, because
// every interval in SRS-ER-006 is measured from it: a visit whose arrival
// event did not commit is a visit with no door-to-anything, and the gap would
// be invisible until somebody looked at the dashboard a week later.
func (s *Service) Arrive(ctx context.Context, in ArriveInput) (domain.Visit, error) {
	session, scope, err := s.authorize(ctx, PermEmergencyWrite)
	if err != nil {
		return domain.Visit{}, err
	}

	now := s.clock.Now()
	var out domain.Visit

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patientID, err := s.requireWritableEncounter(ctx, scope, in.EncounterID)
		if err != nil {
			return err
		}

		visit, err := domain.NewVisit(s.ids.NewID(), scope.TenantID(),
			domain.NewVisitInput{
				EncounterID: in.EncounterID,
				// The encounter is authoritative for the patient. A department
				// that took the caller's word could open a visit against
				// somebody else's encounter.
				PatientID:      trimmed(patientID, in.PatientID),
				FacilityID:     trimmed(in.FacilityID, session.ActiveFacilityID),
				ArrivalMode:    in.ArrivalMode,
				ChiefComplaint: in.ChiefComplaint,
				ArrivedAt:      in.ArrivedAt,
				Unidentified:   in.Unidentified,
				TemporaryName:  in.TemporaryName,
				MedicoLegal:    in.MedicoLegal,
				MedicoLegalRef: in.MedicoLegalRef,
				Location:       in.Location,
			}, session.SubjectID, now)
		if err != nil {
			return emergencyError(err)
		}

		if err := s.visits.InsertVisit(ctx, scope, visit); err != nil {
			return err
		}

		arrival, err := domain.NewEvent(s.ids.NewID(), scope.TenantID(),
			domain.NewEventInput{
				VisitID: visit.ID, Kind: domain.EventArrival,
				Detail: string(visit.ArrivalMode), OccurredAt: visit.ArrivedAt,
			}, session.SubjectID, now)
		if err != nil {
			return emergencyError(err)
		}
		if err := s.visits.InsertEvent(ctx, scope, arrival); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventVisitArrived,
			"emergency_visit", visit.ID, map[string]any{
				"visit_id":     visit.ID,
				"encounter_id": visit.EncounterID,
				"patient_id":   visit.PatientID,
				"facility_id":  visit.FacilityID,
				"arrival_mode": string(visit.ArrivalMode),
				// The complaint does not travel. It is the patient's
				// presenting problem in their own words, and a broker is read
				// by more systems under fewer controls than the chart.
				"unidentified": visit.Unidentified,
				"arrived_at":   visit.ArrivedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = visit
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEmergencyWrite,
			ResourceType: "emergency_visit", ResourceID: visit.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "emergency arrival, " + string(visit.ArrivalMode),
		}, now)
	})
	if err != nil {
		return domain.Visit{}, err
	}
	return out, nil
}

// Visit reads one visit.
func (s *Service) Visit(ctx context.Context, visitID string) (domain.Visit, error) {
	_, scope, err := s.authorize(ctx, PermEmergencyRead)
	if err != nil {
		return domain.Visit{}, err
	}
	return s.visits.GetVisit(ctx, scope, visitID)
}

// IdentifyInput attaches a real patient to an unidentified visit.
type IdentifyInput struct {
	VisitID   string
	PatientID string
}

// Identify reconciles an unidentified emergency patient (SRS-ER-004).
//
// "Merge retains chronology" is the criterion, and it is satisfied by leaving
// everything alone: the timeline already hangs off the visit, the temporary
// name stays, and nothing that was written under it is rewritten.
func (s *Service) Identify(ctx context.Context, in IdentifyInput) (domain.Visit, error) {
	session, scope, err := s.authorize(ctx, PermEmergencyWrite)
	if err != nil {
		return domain.Visit{}, err
	}

	now := s.clock.Now()
	var out domain.Visit

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.GetVisit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}
		expected := visit.Version
		if err := visit.Identify(in.PatientID, now); err != nil {
			return emergencyError(err)
		}
		if err := s.visits.UpdateVisit(ctx, scope, visit, expected); err != nil {
			return emergencyError(err)
		}

		out = visit
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEmergencyWrite,
			ResourceType: "emergency_visit", ResourceID: visit.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "unidentified emergency patient reconciled to a record",
		}, now)
	})
	if err != nil {
		return domain.Visit{}, err
	}
	return out, nil
}

// ObserveInput starts an ED observation stay (SRS-ER-014).
type ObserveInput struct {
	VisitID  string
	ReviewAt time.Time
	Location string
}

// Observe puts a patient in an ED observation bed (SRS-ER-014).
//
// Not an admission, and deliberately a different call from one: an observation
// bed recorded as an admission inflates the department's admission rate and
// empties its observation reporting, and both numbers are ones a hospital is
// measured on.
func (s *Service) Observe(ctx context.Context, in ObserveInput) (domain.Visit, error) {
	session, scope, err := s.authorize(ctx, PermEmergencyWrite)
	if err != nil {
		return domain.Visit{}, err
	}

	now := s.clock.Now()
	var out domain.Visit

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.GetVisit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}
		expected := visit.Version
		if err := visit.StartObservation(in.ReviewAt, now); err != nil {
			return emergencyError(err)
		}
		if location := trimmed(in.Location); location != "" {
			visit.Location = location
		}
		if err := s.visits.UpdateVisit(ctx, scope, visit, expected); err != nil {
			return emergencyError(err)
		}

		out = visit
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEmergencyWrite,
			ResourceType: "emergency_visit", ResourceID: visit.ID,
			Outcome: audit.OutcomeSuccess, Reason: "ED observation stay started",
		}, now)
	})
	if err != nil {
		return domain.Visit{}, err
	}
	return out, nil
}

// DisposeInput decides where the patient goes (SRS-ER-013).
type DisposeInput struct {
	VisitID          string
	Disposition      domain.Disposition
	Note             string
	ReceivingService string
	// SummarySigned is the caller's assertion that the discharge summary is
	// signed (SRS-ER-015). Passed in rather than inferred because the summary
	// is a clinical document owned by SRS-CLN, and a department that decided
	// for itself whether one was signed would be a second authority on it.
	SummarySigned bool
}

// DispositionRefused reports a disposition the department may not set yet.
//
// A typed refusal rather than an error string, because the caller has to
// render every reason at once: a clinician told one missing thing at a time
// makes three attempts at the same screen while a patient waits in a corridor.
type DispositionRefused struct {
	Refusals []domain.DispositionRefusal
}

func (e DispositionRefused) Error() string {
	reasons := make([]string, 0, len(e.Refusals))
	for _, refusal := range e.Refusals {
		reasons = append(reasons, refusal.Explain())
	}
	return "this disposition is not ready: " + joinSentences(reasons)
}

func joinSentences(in []string) string {
	out := ""
	for i, s := range in {
		if i > 0 {
			out += " "
		}
		out += s
	}
	return out
}

// Dispose sets where the patient went (SRS-ER-013).
func (s *Service) Dispose(ctx context.Context, in DisposeInput) (domain.Visit, error) {
	session, scope, err := s.authorize(ctx, PermDispose)
	if err != nil {
		return domain.Visit{}, err
	}

	now := s.clock.Now()
	var out domain.Visit

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.GetVisit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}
		_, triaged, err := s.visits.LatestTriage(ctx, scope, visit.ID)
		if err != nil {
			return err
		}

		expected := visit.Version
		refusals, err := visit.Dispose(in.Disposition, in.Note, in.ReceivingService,
			s.config.requirements(in.Disposition),
			domain.DispositionEvidence{
				Triaged: triaged, SummarySigned: in.SummarySigned,
			}, now)
		if err != nil {
			return emergencyError(err)
		}
		if len(refusals) > 0 {
			return rpcerr.FailedPrecondition("ER_DISPOSITION_NOT_READY",
				DispositionRefused{Refusals: refusals}.Error())
		}

		if err := s.visits.UpdateVisit(ctx, scope, visit, expected); err != nil {
			return emergencyError(err)
		}

		// The disposition event closes the door-to-disposition clock, and is
		// written in the same transaction for the same reason the arrival
		// event is.
		disposed, err := domain.NewEvent(s.ids.NewID(), scope.TenantID(),
			domain.NewEventInput{
				VisitID: visit.ID, Kind: domain.EventDisposition,
				Detail: string(visit.Disposition), OccurredAt: now,
			}, session.SubjectID, now)
		if err != nil {
			return emergencyError(err)
		}
		if err := s.visits.InsertEvent(ctx, scope, disposed); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventVisitDisposed,
			"emergency_visit", visit.ID, map[string]any{
				"visit_id":     visit.ID,
				"encounter_id": visit.EncounterID,
				"patient_id":   visit.PatientID,
				"disposition":  string(visit.Disposition),
				// The receiving service travels because the receiving service
				// is the system that needs to know.
				"receiving_service": visit.ReceivingService,
				"disposed_at":       visit.DisposedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = visit
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDispose,
			ResourceType: "emergency_visit", ResourceID: visit.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "disposition " + string(visit.Disposition),
		}, now)
	})
	if err != nil {
		return domain.Visit{}, err
	}
	return out, nil
}
