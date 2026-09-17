package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The flowsheet (SRS-ICU-002), device provenance (SRS-ICU-003) and the fluid
// balance (SRS-ICU-007).

// ChartInput is one flowsheet value.
type ChartInput struct {
	EpisodeID  string
	CodeSystem string
	Code       string
	Display    string
	Dimension  domain.Dimension
	Value      float64
	Unit       string
	Source     domain.SourceKind
	Device     domain.DeviceSource
	ObservedAt time.Time
}

// Chart records one flowsheet value (SRS-ICU-002, SRS-ICU-003).
//
// Device readings and nurse entries go through the same call. A separate
// ingest path would be a second place for the normalisation and the
// provenance rules to live, and the second one is where they drift.
func (s *Service) Chart(ctx context.Context, in ChartInput) (domain.Observation, error) {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Observation{}, err
	}

	now := s.clock.Now()
	var out domain.Observation

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		recordedBy := session.SubjectID
		if in.Source == domain.SourceDevice {
			// A device reading is attributed to the device, not to whatever
			// service account happened to deliver it. "Source-attributed" is
			// the requirement, and a monitor's reading signed by a nurse who
			// never saw it is the opposite.
			recordedBy = ""
		}

		observation, err := domain.NewObservation(s.ids.NewID(), scope.TenantID(),
			domain.NewObservationInput{
				EpisodeID: episode.ID, CodeSystem: in.CodeSystem, Code: in.Code,
				Display: in.Display, Dimension: in.Dimension,
				Value: in.Value, Unit: in.Unit,
				Source: in.Source, Device: in.Device, ObservedAt: in.ObservedAt,
			}, recordedBy, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.flowsheet.InsertObservation(ctx, scope, observation); err != nil {
			return err
		}

		out = observation
		// No audit entry per charted value, and no event. A critical-care
		// flowsheet takes thousands of values a day per bed; auditing each one
		// would produce a trail nobody can read and a table larger than the
		// chart it describes. What is audited is the act that changes what the
		// chart means — validating a device reading, below.
		return nil
	})
	if err != nil {
		return domain.Observation{}, err
	}
	return out, nil
}

// DecideInput confirms or rejects a device reading.
type DecideInput struct {
	ObservationID string
	Accept        bool
	Note          string
}

// Decide validates a device reading into the chart, or rejects it as artefact
// (SRS-ICU-003).
//
// Its own permission, because a confirmed artefact becomes a fact: the trend
// and the score are computed from chartable values, and a saturation of 60%
// from a probe off the finger confirmed by mistake is a hypoxia that never
// happened.
func (s *Service) Decide(ctx context.Context, in DecideInput) (domain.Observation, error) {
	session, scope, err := s.authorize(ctx, PermValidate)
	if err != nil {
		return domain.Observation{}, err
	}

	now := s.clock.Now()
	var out domain.Observation

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		observation, err := s.flowsheet.GetObservation(ctx, scope, in.ObservationID)
		if err != nil {
			return err
		}

		if in.Accept {
			err = observation.Confirm(session.SubjectID, in.Note, now)
		} else {
			err = observation.Reject(session.SubjectID, in.Note, now)
		}
		if err != nil {
			return icuError(err)
		}

		decided, err := s.flowsheet.Decide(ctx, scope, observation)
		if err != nil {
			return err
		}
		if !decided {
			return rpcerr.FailedPrecondition("ICU_ALREADY_DECIDED",
				"somebody decided this reading first; re-read it")
		}

		// Only the rejection is announced. A confirmed reading is the ordinary
		// case and says nothing new; a rejected one says a device produced an
		// artefact, which is the biomedical department's business
		// (SRS-BME) and the only half of this worth a broker's attention.
		if !in.Accept {
			if err := s.appendEvent(ctx, session, EventReadingRejected,
				"icu_observation", observation.ID, map[string]any{
					"observation_id": observation.ID,
					"episode_id":     observation.EpisodeID,
					"device_id":      observation.Device.DeviceID,
					"code":           observation.Code,
					// The value does not travel. What a patient's saturation
					// was is the chart's, and the device's reliability is what
					// this event is about.
					"rejected_at": now.Format(time.RFC3339),
				}, now); err != nil {
				return err
			}
		}

		out = observation
		outcome := "confirmed"
		if !in.Accept {
			outcome = "rejected as artefact"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermValidate,
			ResourceType: "icu_observation", ResourceID: observation.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "device reading " + outcome,
		}, now)
	})
	if err != nil {
		return domain.Observation{}, err
	}
	return out, nil
}

// Flowsheet reads an episode's chart.
func (s *Service) Flowsheet(ctx context.Context, episodeID string, since time.Time,
	pageSize int32) (domain.ObservationList, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	list, err := s.flowsheet.Observations(ctx, scope, episodeID, since,
		clampPageSize(pageSize))
	if err != nil {
		return nil, err
	}
	return list.Ordered(), nil
}

// PendingReadings is the nurse's validation worklist (SRS-ICU-003).
func (s *Service) PendingReadings(ctx context.Context, episodeID string,
	pageSize int32) (domain.ObservationList, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	return s.flowsheet.Pending(ctx, scope, episodeID, clampPageSize(pageSize))
}

// BalanceInput records a volume in or out.
type BalanceInput struct {
	EpisodeID  string
	Direction  domain.BalanceDirection
	Route      string
	Volume     float64
	Unit       string
	OccurredAt time.Time
	// Corrects and CorrectionReason make this entry a correction of another.
	Corrects         string
	CorrectionReason string
}

// RecordBalance records a volume, correcting an earlier entry where asked
// (SRS-ICU-007).
//
// The correction and the supersession are one transaction. A correction that
// committed without superseding its original would double the intake, and a
// supersession that committed without its correction would lose the volume
// entirely — both leave a fluid balance that no set of entries adds up to.
func (s *Service) RecordBalance(ctx context.Context, in BalanceInput) (
	domain.BalanceEntry, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.BalanceEntry{}, err
	}

	now := s.clock.Now()
	var out domain.BalanceEntry

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		entry, err := domain.NewBalanceEntry(s.ids.NewID(), scope.TenantID(),
			domain.NewBalanceEntryInput{
				EpisodeID: episode.ID, Direction: in.Direction, Route: in.Route,
				Volume: in.Volume, Unit: in.Unit, OccurredAt: in.OccurredAt,
				Corrects: in.Corrects, CorrectionReason: in.CorrectionReason,
			}, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.flowsheet.InsertBalanceEntry(ctx, scope, entry); err != nil {
			return err
		}

		if entry.Corrects != "" {
			superseded, err := s.flowsheet.Supersede(ctx, scope, entry.Corrects, entry.ID)
			if err != nil {
				return err
			}
			if !superseded {
				// Already corrected by somebody else. Refused rather than
				// silently accepted, because two corrections of one entry
				// would both count and the total would be wrong in a way
				// nobody could see.
				return rpcerr.FailedPrecondition("ICU_ALREADY_CORRECTED",
					"somebody corrected this entry first; re-read the balance")
			}
			if err := s.appendAudit(ctx, session, audit.Record{
				TenantID: session.TenantID, Action: PermIcuWrite,
				ResourceType: "icu_balance_entry", ResourceID: entry.Corrects,
				Outcome: audit.OutcomeSuccess,
				Reason:  "corrected: " + entry.CorrectionReason,
			}, now); err != nil {
				return err
			}
		}

		out = entry
		return nil
	})
	if err != nil {
		return domain.BalanceEntry{}, err
	}
	return out, nil
}

// Balance reports a period's totals (SRS-ICU-007).
//
// Recomputed from the live entries every time. Nothing stores a running total,
// so a correction cannot leave one that no set of entries adds up to.
func (s *Service) Balance(ctx context.Context, episodeID string, from, to time.Time) (
	domain.Balance, []domain.Balance, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return domain.Balance{}, nil, err
	}
	if !to.After(from) {
		return domain.Balance{}, nil, rpcerr.Invalid("ICU_BAD_PERIOD",
			"the period ends before it starts")
	}

	entries, err := s.flowsheet.BalanceEntries(ctx, scope, episodeID, from, to)
	if err != nil {
		return domain.Balance{}, nil, err
	}
	return domain.Totals(entries, from, to), domain.Hourly(entries, from, to), nil
}
