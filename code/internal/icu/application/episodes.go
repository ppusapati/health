package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Admission, transfer and discharge (SRS-ICU-001, SRS-ICU-016, SRS-ICU-017).

// AdmitInput admits a patient to critical care.
type AdmitInput struct {
	EncounterID          string
	PatientID            string
	FacilityID           string
	UnitID               string
	BedID                string
	Source               domain.AdmissionSource
	TransferredFrom      string
	ResponsibleTeam      string
	ResponsibleClinician string
	AdmittedAt           time.Time
}

// Admit opens a critical-care episode (SRS-ICU-001).
func (s *Service) Admit(ctx context.Context, in AdmitInput) (domain.Episode, error) {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Episode{}, err
	}

	now := s.clock.Now()
	var out domain.Episode

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patientID, err := s.requireWritableEncounter(ctx, scope, in.EncounterID)
		if err != nil {
			return err
		}

		episode, err := domain.NewEpisode(s.ids.NewID(), scope.TenantID(),
			domain.NewEpisodeInput{
				EncounterID: in.EncounterID,
				// The encounter is authoritative for the patient. A unit that
				// took the caller's word could open an episode against
				// somebody else's encounter.
				PatientID:       trimmed(patientID, in.PatientID),
				FacilityID:      trimmed(in.FacilityID, session.ActiveFacilityID),
				UnitID:          in.UnitID,
				BedID:           in.BedID,
				Source:          in.Source,
				TransferredFrom: in.TransferredFrom,
				ResponsibleTeam: in.ResponsibleTeam,
				ResponsibleClinician: trimmed(in.ResponsibleClinician,
					session.SubjectID),
				AdmittedAt: in.AdmittedAt,
			}, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}

		if err := s.episodes.InsertEpisode(ctx, scope, episode); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventEpisodeAdmitted,
			"icu_episode", episode.ID, map[string]any{
				"episode_id":   episode.ID,
				"encounter_id": episode.EncounterID,
				"patient_id":   episode.PatientID,
				"facility_id":  episode.FacilityID,
				"unit_id":      episode.UnitID,
				"bed_id":       episode.BedID,
				"source":       string(episode.Source),
				"admitted_at":  episode.AdmittedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = episode
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_episode", ResourceID: episode.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "critical-care admission from " + string(episode.Source),
		}, now)
	})
	if err != nil {
		return domain.Episode{}, err
	}
	return out, nil
}

// Episode reads one episode.
func (s *Service) Episode(ctx context.Context, episodeID string) (domain.Episode, error) {
	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return domain.Episode{}, err
	}
	return s.episodes.GetEpisode(ctx, scope, episodeID)
}

// MoveInput records a bed change within the unit.
type MoveInput struct {
	EpisodeID string
	BedID     string
}

// Move records a bed change.
func (s *Service) Move(ctx context.Context, in MoveInput) (domain.Episode, error) {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Episode{}, err
	}

	now := s.clock.Now()
	var out domain.Episode

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}
		expected := episode.Version
		if err := episode.Move(in.BedID, now); err != nil {
			return icuError(err)
		}
		if err := s.episodes.UpdateEpisode(ctx, scope, episode, expected); err != nil {
			return icuError(err)
		}

		out = episode
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_episode", ResourceID: episode.ID,
			Outcome: audit.OutcomeSuccess, Reason: "moved to bed " + episode.BedID,
		}, now)
	})
	if err != nil {
		return domain.Episode{}, err
	}
	return out, nil
}

// DeclareReady says the patient no longer needs critical care (SRS-ICU-016).
func (s *Service) DeclareReady(ctx context.Context, episodeID string) (
	domain.Episode, error) {

	session, scope, err := s.authorize(ctx, PermDischarge)
	if err != nil {
		return domain.Episode{}, err
	}

	now := s.clock.Now()
	var out domain.Episode

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, episodeID)
		if err != nil {
			return err
		}
		// A second declaration is a no-op in the domain, and must not cost a
		// write: the version bump would be a change nobody made, and the audit
		// entry would say the patient was declared ready twice.
		if episode.Status == domain.EpisodeReadyForTransfer {
			out = episode
			return nil
		}

		expected := episode.Version
		if err := episode.DeclareReady(now); err != nil {
			return icuError(err)
		}
		if err := s.episodes.UpdateEpisode(ctx, scope, episode, expected); err != nil {
			return icuError(err)
		}

		if err := s.appendEvent(ctx, session, EventEpisodeReady,
			"icu_episode", episode.ID, map[string]any{
				"episode_id":  episode.ID,
				"patient_id":  episode.PatientID,
				"unit_id":     episode.UnitID,
				"facility_id": episode.FacilityID,
				"ready_at":    episode.ReadyAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = episode
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDischarge,
			ResourceType: "icu_episode", ResourceID: episode.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "declared fit to leave critical care",
		}, now)
	})
	if err != nil {
		return domain.Episode{}, err
	}
	return out, nil
}

// DischargeInput closes an episode.
type DischargeInput struct {
	EpisodeID string
	Outcome   domain.Outcome
	Note      string
	// Evidence is the caller's assertion about the handover. Passed rather
	// than inferred: the drug chart and the task list belong to other
	// contexts, and a unit deciding for itself whether they were handed over
	// would be a second authority on them.
	Evidence domain.HandoverEvidence
}

// HandoverIncomplete reports a transfer that is not ready.
//
// A typed refusal rather than an error string, because the caller has to
// render every outstanding item at once: a nurse told one missing thing at a
// time makes four attempts at the same screen while a bed is needed.
type HandoverIncomplete struct {
	Outstanding []domain.HandoverRequirement
}

func (e HandoverIncomplete) Error() string {
	out := "this transfer is not ready:"
	for _, requirement := range e.Outstanding {
		out += " " + requirement.Explain()
	}
	return out
}

// Discharge closes the episode (SRS-ICU-016).
func (s *Service) Discharge(ctx context.Context, in DischargeInput) (
	domain.Episode, error) {

	session, scope, err := s.authorize(ctx, PermDischarge)
	if err != nil {
		return domain.Episode{}, err
	}

	now := s.clock.Now()
	var out domain.Episode

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.episodes.GetEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		expected := episode.Version
		outstanding, err := episode.Discharge(in.Outcome, in.Note, in.Evidence, now)
		if err != nil {
			return icuError(err)
		}
		if len(outstanding) > 0 {
			return rpcerr.FailedPrecondition("ICU_HANDOVER_INCOMPLETE",
				HandoverIncomplete{Outstanding: outstanding}.Error())
		}

		if err := s.episodes.UpdateEpisode(ctx, scope, episode, expected); err != nil {
			return icuError(err)
		}

		stay, _ := episode.LengthOfStay()
		if err := s.appendEvent(ctx, session, EventEpisodeDischarged,
			"icu_episode", episode.ID, map[string]any{
				"episode_id":  episode.ID,
				"patient_id":  episode.PatientID,
				"unit_id":     episode.UnitID,
				"facility_id": episode.FacilityID,
				"outcome":     string(episode.Outcome),
				// The stay in hours, because the receiving ward and the
				// hospital's reporting both ask for it and neither should
				// recompute it from timestamps of its own.
				"length_of_stay_hours": stay.Hours(),
				"discharged_at":        episode.DischargedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = episode
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDischarge,
			ResourceType: "icu_episode", ResourceID: episode.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "critical-care discharge, " + string(episode.Outcome),
		}, now)
	})
	if err != nil {
		return domain.Episode{}, err
	}
	return out, nil
}

// UnitMetrics is what SRS-ICU-017 asks a unit to be able to report.
type UnitMetrics struct {
	UnitID string
	From   time.Time
	To     time.Time

	Admissions int
	Discharges int
	Deaths     int
	// BedDays counts calendar days each episode held a bed, half-open so a
	// same-day admission and discharge counts one and an occupancy above 100%
	// is impossible.
	BedDays int
	// VentilatorDays and DeviceDays are counted the same way.
	VentilatorDays int
	DeviceDays     map[string]int
	// MeanLengthOfStayHours covers the closed episodes only. An open stay has
	// no length, and including the elapsed time would make the number change
	// every time the report is run.
	MeanLengthOfStayHours float64
	ClosedEpisodes        int
	// MeanDischargeDelayHours is how long patients waited after being declared
	// fit to leave. The number that explains a full unit better than its
	// admissions do.
	MeanDischargeDelayHours float64
	DelayedDischarges       int
}

// Metrics reports a unit's activity over a period (SRS-ICU-017).
//
// Derived from the episode and device timestamps every time rather than
// maintained as counters: "metrics reconcile to episode/device timestamps" is
// the requirement, and a stored counter is a number that can disagree with the
// rows it came from.
func (s *Service) Metrics(ctx context.Context, unitID string, from, to time.Time) (
	UnitMetrics, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return UnitMetrics{}, err
	}
	if !to.After(from) {
		return UnitMetrics{}, rpcerr.Invalid("ICU_BAD_PERIOD",
			"the period ends before it starts")
	}

	episodes, err := s.episodes.EpisodesInPeriod(ctx, scope, unitID, from, to)
	if err != nil {
		return UnitMetrics{}, err
	}

	out := UnitMetrics{
		UnitID: unitID, From: from.UTC(), To: to.UTC(),
		DeviceDays: map[string]int{},
	}

	var stayHours, delayHours float64
	for _, episode := range episodes {
		if !episode.AdmittedAt.Before(from) {
			out.Admissions++
		}
		if !episode.DischargedAt.IsZero() && episode.DischargedAt.Before(to) {
			out.Discharges++
			if episode.Outcome == domain.OutcomeDeath {
				out.Deaths++
			}
		}
		for day := from.UTC().Truncate(24 * time.Hour); day.Before(to); day = day.Add(24 * time.Hour) {
			if episode.OccupiedOn(day) {
				out.BedDays++
			}
		}
		if stay, ok := episode.LengthOfStay(); ok {
			out.ClosedEpisodes++
			stayHours += stay.Hours()
		}
		if delay, ok := episode.DischargeDelay(); ok {
			out.DelayedDischarges++
			delayHours += delay.Hours()
		}

		support, err := s.support.Support(ctx, scope, episode.ID)
		if err != nil {
			return UnitMetrics{}, err
		}
		out.VentilatorDays += domain.SupportDays(support,
			domain.SupportVentilation, to)
	}

	devices, err := s.support.DevicesInPeriod(ctx, scope, unitID, from, to)
	if err != nil {
		return UnitMetrics{}, err
	}
	kinds := map[string]struct{}{}
	for _, device := range devices {
		kinds[device.Kind] = struct{}{}
	}
	for kind := range kinds {
		out.DeviceDays[kind] = domain.DeviceDays(devices, kind, to)
	}

	if out.ClosedEpisodes > 0 {
		out.MeanLengthOfStayHours = stayHours / float64(out.ClosedEpisodes)
	}
	if out.DelayedDischarges > 0 {
		out.MeanDischargeDelayHours = delayHours / float64(out.DelayedDischarges)
	}
	return out, nil
}
