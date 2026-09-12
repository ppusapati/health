package application

import (
	"context"
	"encoding/json"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Episodes, care teams, diagnoses, closure and the timeline
// (SRS-ENC-004 … SRS-ENC-011).

// OpenEpisodeInput starts a course of care.
type OpenEpisodeInput struct {
	PatientID     string
	FacilityID    string
	Type          domain.EpisodeType
	Label         string
	CareManagerID string
	StartedAt     time.Time
}

// OpenEpisode starts a course of care (SRS-ENC-004).
func (s *Service) OpenEpisode(ctx context.Context, in OpenEpisodeInput) (
	*domain.Episode, error) {

	session, scope, err := s.authorize(ctx, PermEncounterManage, "episode",
		in.PatientID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var opened *domain.Episode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.requirePatient(ctx, scope, in.PatientID); err != nil {
			return err
		}

		episode, err := domain.NewEpisode(s.ids.NewID(), scope.TenantID(), in.PatientID,
			in.FacilityID, in.Type, in.Label, in.CareManagerID, in.StartedAt,
			session.SubjectID, now)
		if err != nil {
			return encounterError(err)
		}
		if err := s.episodes.Insert(ctx, scope, episode); err != nil {
			return err
		}

		opened = episode
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterManage,
			ResourceType: "episode", ResourceID: episode.ID(),
			Outcome: audit.OutcomeSuccess,
			// The type, never the label: "left breast" is clinical, and an
			// audit trail carrying it is a second copy outside the access rules
			// on the first.
			Reason: "opened " + string(episode.Type) + " episode",
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return opened, nil
}

// SetEpisodeStatusInput moves a course of care.
type SetEpisodeStatusInput struct {
	EpisodeID string
	Status    domain.EpisodeStatus
	EndedAt   time.Time
}

// SetEpisodeStatus moves a course of care through its life.
func (s *Service) SetEpisodeStatus(ctx context.Context, in SetEpisodeStatusInput) (
	*domain.Episode, error) {

	session, scope, err := s.authorize(ctx, PermEncounterManage, "episode",
		in.EpisodeID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var out *domain.Episode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.episodes.Get(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		before := episode.Version
		if err := episode.SetStatus(in.Status, in.EndedAt, now); err != nil {
			return encounterError(err)
		}
		if err := s.episodes.SetStatus(ctx, scope, episode, before); err != nil {
			return err
		}

		out = episode
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterManage,
			ResourceType: "episode", ResourceID: episode.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "episode " + string(in.Status),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// ListEpisodes returns a patient's courses of care.
func (s *Service) ListEpisodes(ctx context.Context, patientID string, openOnly bool,
	pageSize int32) ([]*domain.Episode, error) {

	session, scope, err := s.authorize(ctx, PermEncounterRead, "episode", patientID, false)
	if err != nil {
		return nil, err
	}

	var out []*domain.Episode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.episodes.ForPatient(ctx, scope, patientID, openOnly,
			clampPageSize(pageSize))
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterRead,
			ResourceType: "episode", ResourceID: patientID,
			Outcome: audit.OutcomeSuccess, Reason: "listing",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// AssignCareTeamInput adds somebody to an encounter's care team.
type AssignCareTeamInput struct {
	EncounterID string
	SubjectID   string
	Role        domain.CareTeamRole
	From        time.Time
	Until       time.Time
}

// AssignCareTeamMember records one person's involvement (SRS-ENC-005).
func (s *Service) AssignCareTeamMember(ctx context.Context, in AssignCareTeamInput) (
	domain.CareTeamMember, error) {

	session, scope, err := s.authorize(ctx, PermEncounterManage, "care_team",
		in.EncounterID, true)
	if err != nil {
		return domain.CareTeamMember{}, err
	}

	now := s.clock.Now()

	var assigned domain.CareTeamMember
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		encounter, err := s.encounters.Get(ctx, scope, in.EncounterID)
		if err != nil {
			return err
		}
		if !encounter.AcceptsClinicalContent() {
			// Adding somebody to the care team of a cancelled encounter would
			// grant them access to a patient on the strength of a visit the
			// record says did not happen.
			return rpcerr.FailedPrecondition("ENC_NOT_OPEN",
				"that encounter is "+string(encounter.Status))
		}

		member, err := domain.NewCareTeamMember(s.ids.NewID(), scope.TenantID(),
			in.EncounterID, in.SubjectID, in.Role, in.From, in.Until,
			session.SubjectID, now)
		if err != nil {
			return encounterError(err)
		}
		if err := s.careTeams.Insert(ctx, scope, member); err != nil {
			return err
		}

		assigned = member
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterManage,
			ResourceType: "care_team", ResourceID: in.EncounterID,
			Outcome: audit.OutcomeSuccess,
			Reason:  in.SubjectID + " as " + string(in.Role),
		}, now)
	})
	if err != nil {
		return domain.CareTeamMember{}, mapConflict(err)
	}
	return assigned, nil
}

// EndCareTeamAssignment closes an involvement.
func (s *Service) EndCareTeamAssignment(ctx context.Context, careTeamID string,
	at time.Time) error {

	session, scope, err := s.authorize(ctx, PermEncounterManage, "care_team",
		careTeamID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	if at.IsZero() {
		at = now
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.careTeams.End(ctx, scope, careTeamID, at); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterManage,
			ResourceType: "care_team", ResourceID: careTeamID,
			Outcome: audit.OutcomeSuccess, Reason: "assignment ended",
		}, now)
	})
}

// GetCareTeam returns an encounter's assignments.
func (s *Service) GetCareTeam(ctx context.Context, encounterID string) (
	domain.CareTeam, error) {

	_, scope, err := s.authorize(ctx, PermEncounterRead, "care_team", encounterID, false)
	if err != nil {
		return nil, err
	}

	var out domain.CareTeam
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.careTeams.ForEncounter(ctx, scope, encounterID)
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// RecordDiagnosisInput records a condition against an encounter.
type RecordDiagnosisInput struct {
	EncounterID string
	Code        domain.Coding
	Certainty   domain.DiagnosisCertainty
	Rank        domain.DiagnosisRank
	Note        string
	OnsetAt     time.Time
	// SupersedesID names the earlier entry this one replaces, where a clinician
	// is revising rather than adding. The earlier entry is kept: a differential
	// that became a final diagnosis is a clinical reasoning trail.
	SupersedesID string
}

// RecordDiagnosis records a diagnosis (SRS-ENC-007).
func (s *Service) RecordDiagnosis(ctx context.Context, in RecordDiagnosisInput) (
	domain.Diagnosis, error) {

	session, scope, err := s.authorize(ctx, PermDiagnosisRecord, "diagnosis",
		in.EncounterID, true)
	if err != nil {
		return domain.Diagnosis{}, err
	}

	now := s.clock.Now()

	var recorded domain.Diagnosis
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		encounter, err := s.encounters.Get(ctx, scope, in.EncounterID)
		if err != nil {
			return err
		}
		if !encounter.AcceptsClinicalContent() {
			return rpcerr.FailedPrecondition("ENC_NOT_OPEN",
				"that encounter is "+string(encounter.Status)+
					"; a closed encounter is amended rather than added to")
		}

		diagnosis, err := domain.NewDiagnosis(s.ids.NewID(), scope.TenantID(),
			in.EncounterID, encounter.PatientID, in.Code, in.Certainty, in.Rank,
			in.Note, in.OnsetAt, session.SubjectID, now)
		if err != nil {
			return encounterError(err)
		}

		// A second primary supersedes the first: the rank answers "what was
		// this visit about", and two answers is no answer. Done before the
		// insert so the partial unique index never sees two live primaries.
		supersedes := in.SupersedesID
		if supersedes == "" && in.Rank == domain.RankPrimary {
			existing, err := s.diagnoses.ForEncounter(ctx, scope, in.EncounterID)
			if err != nil {
				return err
			}
			if primary, found := existing.Primary(); found {
				supersedes = primary.ID
			}
		}
		if supersedes != "" {
			if err := s.diagnoses.Supersede(ctx, scope, supersedes, diagnosis.ID); err != nil {
				return err
			}
		}

		if err := s.diagnoses.Insert(ctx, scope, diagnosis); err != nil {
			return err
		}

		if err := s.emitDiagnosisEvent(ctx, session, encounter, diagnosis, now); err != nil {
			return err
		}

		recorded = diagnosis
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDiagnosisRecord,
			ResourceType: "diagnosis", ResourceID: diagnosis.ID,
			Outcome: audit.OutcomeSuccess,
			// The certainty and rank, never the code: an audit trail that
			// carried the diagnosis would be a second copy of the patient's
			// conditions, readable by everybody who can read audit.
			Reason: string(diagnosis.Certainty) + " " + string(diagnosis.Rank),
		}, now)
	})
	if err != nil {
		return domain.Diagnosis{}, mapConflict(err)
	}
	return recorded, nil
}

// emitDiagnosisEvent writes the SRS-ENC-012 diagnosis.recorded event.
//
// The code travels, because a downstream registry or billing projection cannot
// do its job without it and the alternative is every consumer calling back for
// the one field. The clinician's note does not: that is free text about this
// patient, and an event stream is read under fewer controls than the chart.
func (s *Service) emitDiagnosisEvent(ctx context.Context, session authctx.Session,
	e *domain.Encounter, d domain.Diagnosis, now time.Time) error {

	payload := map[string]any{
		"diagnosis_id": d.ID,
		"encounter_id": d.EncounterID,
		"patient_id":   d.PatientID,
		"code_system":  d.Code.System,
		"code":         d.Code.Code,
		"certainty":    string(d.Certainty),
		"rank":         string(d.Rank),
		"recorded_at":  d.RecordedAt.Format(time.RFC3339),
		"version":      e.Version,
	}
	if d.SupersededByID != "" {
		payload["supersedes"] = d.SupersededByID
	}

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("ENC_EVENT_ENCODE_FAILED", "could not encode event").
			WithCause(err)
	}
	return s.appendEvent(ctx, session, EventDiagnosisRecorded, "encounter",
		d.EncounterID, encoded, now)
}

// RetractDiagnosisInput marks an entry that was never true of this patient.
type RetractDiagnosisInput struct {
	DiagnosisID string
	Reason      string
}

// RetractDiagnosis retracts a diagnosis recorded in error.
func (s *Service) RetractDiagnosis(ctx context.Context, in RetractDiagnosisInput) error {
	session, scope, err := s.authorize(ctx, PermDiagnosisRecord, "diagnosis",
		in.DiagnosisID, true)
	if err != nil {
		return err
	}
	if in.Reason == "" {
		return rpcerr.Invalid("ENC_RETRACTION_NEEDS_REASON",
			"retracting a diagnosis needs a reason")
	}

	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.diagnoses.Retract(ctx, scope, in.DiagnosisID, in.Reason); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDiagnosisRecord,
			ResourceType: "diagnosis", ResourceID: in.DiagnosisID,
			Outcome: audit.OutcomeSuccess, Reason: "retracted: " + in.Reason,
		}, now)
	})
}

// ListDiagnosesInput narrows a diagnosis listing.
type ListDiagnosesInput struct {
	EncounterID string
	// PatientID returns the conditions that still stand across every
	// encounter, which is what a problem list reads.
	PatientID string
	PageSize  int32
}

// ListDiagnoses returns an encounter's full trail or a patient's live
// conditions.
func (s *Service) ListDiagnoses(ctx context.Context, in ListDiagnosesInput) (
	domain.DiagnosisList, error) {

	session, scope, err := s.authorize(ctx, PermEncounterRead, "diagnosis",
		in.EncounterID, false)
	if err != nil {
		return nil, err
	}
	if in.EncounterID == "" && in.PatientID == "" {
		return nil, rpcerr.Invalid("ENC_LIST_UNFILTERED",
			"a diagnosis listing needs an encounter or a patient")
	}

	var out domain.DiagnosisList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		if in.EncounterID != "" {
			out, err = s.diagnoses.ForEncounter(ctx, scope, in.EncounterID)
		} else {
			out, err = s.diagnoses.LiveForPatient(ctx, scope, in.PatientID,
				clampPageSize(in.PageSize))
		}
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterRead,
			ResourceType: "diagnosis", ResourceID: in.EncounterID + in.PatientID,
			Outcome: audit.OutcomeSuccess, Reason: "listing",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}
