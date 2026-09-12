package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Opening, running and reading encounters
// (SRS-ENC-001, SRS-ENC-002, SRS-ENC-003, SRS-ENC-006, SRS-ENC-010).

// OpenEncounterInput opens a new encounter.
type OpenEncounterInput struct {
	PatientID           string
	FacilityID          string
	OrgUnitID           string
	Class               domain.Class
	VisitType           string
	AttendingProviderID string
	// AppointmentID links the plan to what happened, where there was a plan.
	// Empty is not an error: SRS-ENC-003 requires the two to be separately
	// auditable, and a walk-in has no appointment at all.
	AppointmentID string
	EpisodeID     string
	ReferralID    string
	Reason        string
	// StartImmediately begins the encounter in the same call, which is what a
	// consultation actually looks like: the clinician calls the patient in and
	// the visit starts. A planned encounter is the exception — a scheduled
	// admission days ahead.
	StartImmediately bool
	// StartedAt records when the patient was actually seen, for a late entry.
	StartedAt time.Time
}

// OpenEncounter creates an encounter (SRS-ENC-001).
func (s *Service) OpenEncounter(ctx context.Context, in OpenEncounterInput) (
	*domain.Encounter, error) {

	session, scope, err := s.authorize(ctx, PermEncounterManage, "encounter",
		in.PatientID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var opened *domain.Encounter
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The patient must be in this tenant. Without the check an encounter
		// could be opened against an identifier from somewhere else, and every
		// clinical record written into it would be unreachable from the chart
		// it belongs to.
		if err := s.requirePatient(ctx, scope, in.PatientID); err != nil {
			return err
		}

		if in.EpisodeID != "" {
			if err := s.requireOpenEpisode(ctx, scope, in.EpisodeID, in.PatientID); err != nil {
				return err
			}
		}

		// A claimed appointment must be this patient's, or an encounter could
		// be filed against somebody else's booking and the diary would close
		// the wrong loop.
		if in.AppointmentID != "" && s.appointments != nil {
			belongs, err := s.appointments.BelongsToPatient(ctx, scope,
				in.AppointmentID, in.PatientID)
			if err != nil {
				return err
			}
			if !belongs {
				return rpcerr.Invalid("ENC_APPOINTMENT_MISMATCH",
					"that appointment belongs to a different patient")
			}
		}

		encounter, err := domain.NewEncounter(s.ids.NewID(), scope.TenantID(),
			domain.NewEncounterInput{
				PatientID: in.PatientID, FacilityID: in.FacilityID,
				OrgUnitID: in.OrgUnitID, Class: in.Class, VisitType: in.VisitType,
				AttendingProviderID: in.AttendingProviderID,
				AppointmentID:       in.AppointmentID, EpisodeID: in.EpisodeID,
				ReferralID: in.ReferralID, Reason: in.Reason,
			}, session.SubjectID, now)
		if err != nil {
			return encounterError(err)
		}

		if in.StartImmediately {
			if err := encounter.Start(in.StartedAt, session.SubjectID, now); err != nil {
				return encounterError(err)
			}
		}

		if err := s.encounters.Insert(ctx, scope, encounter); err != nil {
			return err
		}

		// The attending clinician joins their own care team on the way in.
		// Without it, authorization asking "is this clinician looking after
		// this patient" would answer no for the person responsible for them
		// (SRS-ENC-005).
		if encounter.AttendingProviderID != "" {
			member, err := domain.NewCareTeamMember(s.ids.NewID(), scope.TenantID(),
				encounter.ID(), encounter.AttendingProviderID, domain.RoleAttending,
				now, time.Time{}, session.SubjectID, now)
			if err != nil {
				return encounterError(err)
			}
			if err := s.careTeams.Insert(ctx, scope, member); err != nil {
				return err
			}
		}

		if in.StartImmediately {
			if err := s.emitEncounterEvent(ctx, session, EventEncounterStarted,
				encounter, now, nil); err != nil {
				return err
			}
		}

		opened = encounter
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterManage,
			ResourceType: "encounter", ResourceID: encounter.ID(),
			Outcome: audit.OutcomeSuccess,
			// The class and the facility, never the stated reason: why a
			// patient came is about them, and an audit trail carrying it is a
			// second copy outside the access rules on the first.
			Reason: "opened " + string(encounter.Class) + " encounter",
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return opened, nil
}

// requirePatient refuses an encounter against a patient this tenant does not
// hold.
func (s *Service) requirePatient(ctx context.Context, scope authctx.TenantScope,
	patientID string) error {

	if s.patients == nil {
		return nil
	}
	exists, err := s.patients.Exists(ctx, scope, patientID)
	if err != nil {
		// Not-found propagates unchanged: a probe must not be able to tell a
		// patient in another tenant from one that does not exist.
		return err
	}
	if !exists {
		return rpcerr.NotFound("ENC_PATIENT_NOT_FOUND", "no such patient")
	}
	return nil
}

// requireOpenEpisode refuses filing an encounter into a course of care that has
// finished, or into somebody else's.
func (s *Service) requireOpenEpisode(ctx context.Context, scope authctx.TenantScope,
	episodeID, patientID string) error {

	episode, err := s.episodes.Get(ctx, scope, episodeID)
	if err != nil {
		return err
	}
	if episode.PatientID != patientID {
		// Not-found rather than a mismatch message: the caller has named
		// somebody else's episode, and confirming it exists would leak that a
		// patient is under a course of oncology care.
		return rpcerr.NotFound("ENC_EPISODE_NOT_FOUND", "no such episode")
	}
	if !episode.Accepts() {
		return rpcerr.FailedPrecondition("ENC_EPISODE_CLOSED",
			"that course of care is no longer open")
	}
	return nil
}

// StartEncounterInput begins a planned encounter.
type StartEncounterInput struct {
	EncounterID string
	// StartedAt is when the patient was actually seen. Empty means now.
	StartedAt time.Time
}

// StartEncounter begins the clinical encounter (SRS-ENC-003).
func (s *Service) StartEncounter(ctx context.Context, in StartEncounterInput) (
	*domain.Encounter, error) {

	return s.changeState(ctx, in.EncounterID, PermEncounterManage,
		func(e *domain.Encounter, session authctx.Session, now time.Time) (string, error) {
			if err := e.Start(in.StartedAt, session.SubjectID, now); err != nil {
				return "", err
			}
			return EventEncounterStarted, nil
		})
}

// EndEncounterInput finishes the clinical encounter.
type EndEncounterInput struct {
	EncounterID string
	EndedAt     time.Time
}

// EndEncounter finishes the clinical encounter, leaving documentation
// outstanding (SRS-ENC-003).
//
// Distinct from closing it. Ending is a clinical fact — the consultation is
// over — and closing is an administrative one that waits on the record being
// complete. Collapsing them would mean either that a clinician cannot leave the
// room until they have typed everything, or that encounters are closed with
// nothing in them.
func (s *Service) EndEncounter(ctx context.Context, in EndEncounterInput) (
	*domain.Encounter, error) {

	return s.changeState(ctx, in.EncounterID, PermEncounterManage,
		func(e *domain.Encounter, session authctx.Session, now time.Time) (string, error) {
			if err := e.End(in.EndedAt, session.SubjectID, now); err != nil {
				return "", err
			}
			return EventEncounterCompleted, nil
		})
}

// CancelEncounterInput records an encounter that did not happen.
type CancelEncounterInput struct {
	EncounterID string
	Reason      string
	// EnteredInError marks a record that should never have existed — opened
	// against the wrong patient — rather than a visit that did not take place.
	// Two different facts, and a report that counted them together would say
	// patients are cancelling when in fact clerks are misclicking.
	EnteredInError bool
}

// CancelEncounter cancels or retracts an encounter (SRS-ENC-006).
func (s *Service) CancelEncounter(ctx context.Context, in CancelEncounterInput) (
	*domain.Encounter, error) {

	return s.changeState(ctx, in.EncounterID, PermEncounterManage,
		func(e *domain.Encounter, session authctx.Session, now time.Time) (string, error) {
			if in.EnteredInError {
				if err := e.MarkEnteredInError(session.SubjectID, in.Reason, now); err != nil {
					return "", err
				}
				return EventEncounterEnteredInError, nil
			}
			if err := e.Cancel(session.SubjectID, in.Reason, now); err != nil {
				return "", err
			}
			return EventEncounterCancelled, nil
		})
}

// ReopenEncounterInput continues a finished encounter.
type ReopenEncounterInput struct {
	EncounterID string
	Reason      string
}

// ReopenEncounter returns a finished encounter to in-progress.
func (s *Service) ReopenEncounter(ctx context.Context, in ReopenEncounterInput) (
	*domain.Encounter, error) {

	return s.changeState(ctx, in.EncounterID, PermEncounterManage,
		func(e *domain.Encounter, session authctx.Session, now time.Time) (string, error) {
			if err := e.Reopen(session.SubjectID, in.Reason, now); err != nil {
				return "", err
			}
			return EventEncounterStarted, nil
		})
}

// SetEncounterLeaveInput moves an inpatient to or from leave.
type SetEncounterLeaveInput struct {
	EncounterID string
	Reason      string
	// Returning brings the patient back from leave.
	Returning bool
}

// SetEncounterLeave records an inpatient temporarily away and their return.
func (s *Service) SetEncounterLeave(ctx context.Context, in SetEncounterLeaveInput) (
	*domain.Encounter, error) {

	return s.changeState(ctx, in.EncounterID, PermEncounterManage,
		func(e *domain.Encounter, session authctx.Session, now time.Time) (string, error) {
			if in.Returning {
				if err := e.Reopen(session.SubjectID, in.Reason, now); err != nil {
					return "", err
				}
				return "", nil
			}
			if err := e.GoOnLeave(session.SubjectID, in.Reason, now); err != nil {
				return "", err
			}
			// No SRS-ENC-012 event: leave is a bed movement rather than a
			// change in whether the encounter is happening, and a consumer told
			// "completed" every time a patient went home for a weekend would
			// close its projection four times an admission.
			return "", nil
		})
}

// changeState is the shared body of every status transition.
//
// One transaction, one optimistic-concurrency guard, one audit entry and at
// most one event. Written once because the alternative — six near-identical
// use cases — is six places for the guard to be forgotten, and the one that
// forgets it is the one where two clinicians close an encounter at once.
func (s *Service) changeState(ctx context.Context, encounterID, permission string,
	apply func(*domain.Encounter, authctx.Session, time.Time) (string, error)) (
	*domain.Encounter, error) {

	session, scope, err := s.authorize(ctx, permission, "encounter", encounterID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var out *domain.Encounter
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		encounter, err := s.encounters.Get(ctx, scope, encounterID)
		if err != nil {
			return err
		}

		before := encounter.Version
		wasStatus := encounter.Status

		eventType, err := apply(encounter, session, now)
		if err != nil {
			return encounterError(err)
		}
		if encounter.Status == wasStatus {
			// Idempotent: a double-tapped button on a ward terminal should not
			// produce a failure somebody has to interpret.
			out = encounter
			return nil
		}

		change := encounter.History[len(encounter.History)-1]
		if err := s.encounters.SetState(ctx, scope, encounter, change, before); err != nil {
			return err
		}

		if eventType != "" {
			if err := s.emitEncounterEvent(ctx, session, eventType, encounter, now,
				map[string]any{"from": string(change.From)}); err != nil {
				return err
			}
		}

		out = encounter
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "encounter", ResourceID: encounter.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  string(change.From) + " to " + string(change.To),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// GetEncounter reads one encounter with its status history.
func (s *Service) GetEncounter(ctx context.Context, encounterID string) (
	*domain.Encounter, error) {

	session, scope, err := s.authorize(ctx, PermEncounterRead, "encounter",
		encounterID, false)
	if err != nil {
		return nil, err
	}

	var out *domain.Encounter
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		encounter, err := s.encounters.Get(ctx, scope, encounterID)
		if err != nil {
			return err
		}
		out = encounter
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterRead,
			ResourceType: "encounter", ResourceID: encounterID,
			Outcome: audit.OutcomeSuccess,
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// ListEncountersInput narrows a listing.
type ListEncountersInput struct {
	PatientID string
	// FacilityID returns the encounters still under way — the ward round.
	// Mutually exclusive with PatientID.
	FacilityID       string
	EpisodeID        string
	Class            domain.Class
	IncludeRetracted bool
	PageSize         int32
}

// ListEncounters serves both a patient's chronology and a facility's ward
// round.
func (s *Service) ListEncounters(ctx context.Context, in ListEncountersInput) (
	[]*domain.Encounter, error) {

	session, scope, err := s.authorize(ctx, PermEncounterRead, "encounter",
		in.PatientID, false)
	if err != nil {
		return nil, err
	}
	if in.PatientID == "" && in.FacilityID == "" {
		return nil, rpcerr.Invalid("ENC_LIST_UNFILTERED",
			"a listing needs a patient or a facility")
	}

	limit := clampPageSize(in.PageSize)

	var out []*domain.Encounter
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		if in.PatientID != "" {
			out, err = s.encounters.ForPatient(ctx, scope, ports.PatientQuery{
				PatientID: in.PatientID, EpisodeID: in.EpisodeID, Class: in.Class,
				IncludeRetracted: in.IncludeRetracted, Limit: limit,
			})
		} else {
			out, err = s.encounters.Open(ctx, scope, in.FacilityID, in.Class, limit)
		}
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterRead,
			ResourceType: "encounter", ResourceID: in.PatientID,
			Outcome: audit.OutcomeSuccess, Reason: "listing",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}
