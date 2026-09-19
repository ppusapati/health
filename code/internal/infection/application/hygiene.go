package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// StartHygieneSession opens an observation period (SRS-IPC-006).
func (s *Service) StartHygieneSession(ctx context.Context, facilityID,
	locationID, notes string, startedAt time.Time) (
	domain.HygieneSession, error) {

	session, scope, err := s.authorize(ctx, PermHygiene)
	if err != nil {
		return domain.HygieneSession{}, err
	}
	now := s.clock.Now()

	// The observer is the caller: an audit's quality depends on who did it,
	// and two observers who disagree by thirty points is a finding about the
	// observers. The observed are never named.
	one, err := domain.NewSession(s.ids.NewID(), session.TenantID, facilityID,
		locationID, session.SubjectID, startedAt, notes, now)
	if err != nil {
		return domain.HygieneSession{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.hygiene.InsertSession(ctx, scope, one); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.hygiene_session.started",
			ResourceType: "ipc_hygiene_session", ResourceID: one.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "opened a hand hygiene observation period",
		}, now)
	})
	if err != nil {
		return domain.HygieneSession{}, infectionError(err)
	}
	return one, nil
}

// RecordObservation records one opportunity and what happened
// (SRS-IPC-006).
//
// There is no parameter here naming the person observed, and no column to put
// one in. A hand hygiene audit that names individuals becomes a disciplinary
// instrument, and the moment it does, observed compliance goes to ninety-nine
// per cent and stops meaning anything.
func (s *Service) RecordObservation(ctx context.Context, sessionID string,
	discipline domain.Discipline, moment domain.Moment, action domain.Action,
	glovesWorn bool, observedAt time.Time) (
	domain.HygieneObservation, error) {

	caller, scope, err := s.authorize(ctx, PermHygiene)
	if err != nil {
		return domain.HygieneObservation{}, err
	}
	now := s.clock.Now()
	if observedAt.IsZero() {
		observedAt = now
	}

	observation, err := domain.NewObservation(s.ids.NewID(), caller.TenantID,
		sessionID, discipline, moment, action, glovesWorn, observedAt)
	if err != nil {
		return domain.HygieneObservation{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The session has to exist and belong to this tenant, or an
		// observation could be filed against a period nobody ran.
		if _, err := s.hygiene.Session(ctx, scope, sessionID); err != nil {
			return err
		}
		return s.hygiene.InsertObservation(ctx, scope, observation)
	})
	if err != nil {
		return domain.HygieneObservation{}, infectionError(err)
	}
	return observation, nil
}

// EndHygieneSession closes an observation period (SRS-IPC-006).
func (s *Service) EndHygieneSession(ctx context.Context, sessionID,
	notes string) (domain.HygieneSession, error) {

	caller, scope, err := s.authorize(ctx, PermHygiene)
	if err != nil {
		return domain.HygieneSession{}, err
	}
	now := s.clock.Now()

	var ended domain.HygieneSession
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		one, err := s.hygiene.Session(ctx, scope, sessionID)
		if err != nil {
			return err
		}
		version := one.Version
		one.EndedAt = now.UTC()
		if notes != "" {
			one.Notes = notes
		}
		if err := s.hygiene.EndSession(ctx, scope, one, version); err != nil {
			return err
		}
		ended = one
		return s.appendAudit(ctx, caller, audit.Record{
			Action:       "infection.hygiene_session.ended",
			ResourceType: "ipc_hygiene_session", ResourceID: one.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "closed a hand hygiene observation period",
		}, now)
	})
	if err != nil {
		return domain.HygieneSession{}, infectionError(err)
	}
	return ended, nil
}

// HygieneCompliance aggregates observation into a rate (SRS-IPC-006).
//
// by is "discipline", "moment" or empty for a single total. Groups below the
// configured minimum are suppressed with their counts, because "four
// opportunities, one performed" against a night-shift category names a person
// by arithmetic.
func (s *Service) HygieneCompliance(ctx context.Context, locationID, by string,
	from, to time.Time) (HygieneReport, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return HygieneReport{}, err
	}
	now := s.clock.Now()

	observations, err := s.hygiene.Observations(ctx, scope, locationID, "",
		from, to)
	if err != nil {
		return HygieneReport{}, err
	}

	report := HygieneReport{
		Groups: domain.Compliances(domain.ComplianceInput{
			Observations: observations, By: by,
			MinimumOpportunities: s.config.MinimumHygieneObservations,
		}),
		Observations: len(observations),
		// Named rather than assumed: a deployment that has not set a
		// threshold publishes every group, including the ones small enough to
		// identify somebody.
		SuppressionThreshold: s.config.MinimumHygieneObservations,
	}

	if s.config.HandHygieneIndicator == "" || s.indicators == nil {
		return report, nil
	}
	performed, opportunities := 0, 0
	for _, observation := range observations {
		opportunities++
		if observation.Action.Compliant() {
			performed++
		}
	}
	revision, err := s.indicators.Record(ctx, scope,
		s.config.HandHygieneIndicator, from, to, performed, opportunities,
		session.SubjectID, now)
	if err != nil {
		return HygieneReport{}, err
	}
	report.IndicatorCode = s.config.HandHygieneIndicator
	report.IndicatorRevision = revision
	return report, nil
}

// HygieneReport is a compliance report and what a reader needs to judge it
// (SRS-IPC-006, SRS-IPC-010).
type HygieneReport struct {
	Groups       []domain.Compliance
	Observations int
	// SuppressionThreshold is the group size below which a figure was
	// withheld. Reported, because a report with no suppression and a report
	// where nothing was small enough to suppress look identical otherwise.
	SuppressionThreshold int
	IndicatorCode        string
	IndicatorRevision    int
}
