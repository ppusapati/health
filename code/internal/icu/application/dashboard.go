package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// The unit dashboard (SRS-ICU-012) and the advisory worklist (SRS-ICU-013).

// DashboardInput asks for the unit as it stands.
type DashboardInput struct {
	UnitID   string
	PageSize int32
	// BalanceWindow is how far back the running fluid balance looks. Zero
	// takes twelve hours, which is a shift.
	BalanceWindow time.Duration
}

// DefaultBalanceWindow is one shift.
const DefaultBalanceWindow = 12 * time.Hour

// Dashboard assembles the unit's beds (SRS-ICU-012).
//
// Assembled per bed rather than queried as one join, for the reason the
// emergency board is: the redaction rule and the staleness rule live in the
// domain, in one place, and a SQL projection would put both somewhere a
// clinician could never read them.
//
// It is the expensive call in this service, and deliberately so. Every number
// on it carries the chart entry it came from, because SRS-ICU-012 asks for
// data "traceable to source" — and a dashboard that showed a heart rate with
// no way to open the reading behind it is one a clinician has to take on
// trust.
func (s *Service) Dashboard(ctx context.Context, in DashboardInput) (
	[]domain.DashboardRow, error) {

	session, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	window := in.BalanceWindow
	if window <= 0 {
		window = DefaultBalanceWindow
	}
	mayReadCeiling := session.HasPermission(PermReadCeiling)

	episodes, err := s.episodes.OpenEpisodes(ctx, scope,
		trimmed(in.UnitID), clampPageSize(in.PageSize))
	if err != nil {
		return nil, err
	}

	rows := make([]domain.DashboardRow, 0, len(episodes))
	for _, episode := range episodes {
		chart, err := s.flowsheet.Observations(ctx, scope, episode.ID,
			now.Add(-window), MaxPageSize)
		if err != nil {
			return nil, err
		}
		support, err := s.support.Support(ctx, scope, episode.ID)
		if err != nil {
			return nil, err
		}
		devices, err := s.support.Devices(ctx, scope, episode.ID)
		if err != nil {
			return nil, err
		}
		assessments, err := s.care.Assessments(ctx, scope, episode.ID, MaxPageSize)
		if err != nil {
			return nil, err
		}
		goals, err := s.care.Goals(ctx, scope, episode.ID)
		if err != nil {
			return nil, err
		}
		entries, err := s.flowsheet.BalanceEntries(ctx, scope, episode.ID,
			now.Add(-window), now)
		if err != nil {
			return nil, err
		}
		scores, err := s.care.Scores(ctx, scope, episode.ID, 1)
		if err != nil {
			return nil, err
		}
		ceilings, err := s.care.GoalsOfCare(ctx, scope, episode.ID)
		if err != nil {
			return nil, err
		}

		input := domain.DashboardInput{
			Episode: episode, Chart: chart, VitalCodes: s.config.vitalCodes(),
			Support: support, Devices: devices, Assessments: assessments,
			Goals:   goals,
			Balance: domain.Totals(entries, now.Add(-window), now),
			// The permission decides; the domain redacts. Keeping them apart
			// means a second caller cannot accidentally pass true.
			MayReadCeiling: mayReadCeiling,
			StaleAfter:     s.config.StaleAfter,
		}
		if len(scores) > 0 {
			input.Score = &scores[0]
		}
		if current, ok := domain.CurrentGoalsOfCare(ceilings); ok {
			input.Ceiling = &current
		}

		rows = append(rows, domain.BuildRow(input, now))
	}

	// A dashboard read that showed any ceiling of treatment is audited, for
	// the same reason reading one directly is: who saw a patient's
	// resuscitation status is the question asked afterwards. One entry for the
	// screen rather than one per bed — a per-bed trail from a board refreshed
	// every thirty seconds is one nobody can read.
	if mayReadCeiling {
		if err := s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermReadCeiling,
			ResourceType: "icu_unit", ResourceID: trimmed(in.UnitID, "all"),
			Outcome: audit.OutcomeSuccess,
			Reason:  "unit dashboard read, ceilings of treatment visible",
		}, now); err != nil {
			return nil, err
		}
	}
	return rows, nil
}

// Advisories is one bed's operational worklist (SRS-ICU-013).
//
// Derived, never stored: a line that came out resolves its own overdue-review
// entry, and a unit whose list clears itself is one that still reads it. What
// this cannot do is reach a bedside device — see domain.Alarm.
func (s *Service) Advisories(ctx context.Context, episodeID string) ([]domain.Alarm, error) {
	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	episode, err := s.episodes.GetEpisode(ctx, scope, episodeID)
	if err != nil {
		return nil, err
	}
	devices, err := s.support.Devices(ctx, scope, episode.ID)
	if err != nil {
		return nil, err
	}
	assessments, err := s.care.Assessments(ctx, scope, episode.ID, MaxPageSize)
	if err != nil {
		return nil, err
	}
	chart, err := s.flowsheet.Observations(ctx, scope, episode.ID,
		now.Add(-DefaultBalanceWindow), MaxPageSize)
	if err != nil {
		return nil, err
	}

	alarms := domain.OperationalAlarms(episode, devices, assessments, chart,
		s.config.StaleAfter, now)
	// Each derived alarm gets an id so a client can key on it, but nothing is
	// stored: the id is stable for as long as the condition is.
	for i := range alarms {
		alarms[i].TenantID = scope.TenantID()
		alarms[i].ID = alarms[i].Kind + ":" + alarms[i].EpisodeID
	}
	return alarms, nil
}

// EscalateAdvisory carries one advisory to somebody who can act on it
// (SRS-ICU-013, SRS-OPSNFR-003).
//
// A separate call from reading the list, and a deliberate one: this software
// decides nothing about when a human is needed. A nurse in charge looks at the
// worklist and escalates what matters, which is what "advisory/operational"
// means — the judgement stays with the person.
func (s *Service) EscalateAdvisory(ctx context.Context, episodeID, kind,
	summary string) (string, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return "", err
	}

	now := s.clock.Now()
	var noticeID string

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.episodes.GetEpisode(ctx, scope, episodeID)
		if err != nil {
			return err
		}
		if s.escalations == nil {
			// A unit with no chain configured records the escalation and
			// pages nobody through this software. A six-bed unit where the
			// nurse in charge can see every bed is a real arrangement.
			return s.appendAudit(ctx, session, audit.Record{
				TenantID: session.TenantID, Action: PermIcuWrite,
				ResourceType: "icu_episode", ResourceID: episode.ID,
				Outcome: audit.OutcomeSuccess,
				Reason:  "advisory escalated locally: " + kind,
			}, now)
		}

		id, err := s.escalate(ctx, scope, episode, kind, summary, now)
		if err != nil {
			return err
		}
		noticeID = id

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_episode", ResourceID: episode.ID,
			Outcome: audit.OutcomeSuccess, Reason: "advisory escalated: " + kind,
		}, now)
	})
	if err != nil {
		return "", err
	}
	return noticeID, nil
}
