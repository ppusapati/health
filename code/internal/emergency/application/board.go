package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/emergency/domain"
)

// The ED status board (SRS-ER-003, SRS-ER-012).

// BoardInput asks for the department as it stands.
type BoardInput struct {
	FacilityID string
	PageSize   int32
}

// Board assembles the status board for the calling clinician (SRS-ER-012).
//
// "Board updates near-real-time without exposing restricted data beyond role"
// is the criterion, and the two halves are answered in different places: the
// freshness is a client concern, and the redaction is here — in one function,
// so there is one place to check rather than one per caller.
//
// The queue order is assembled rather than queried. Acuity ordering needs the
// latest triage and the latest override per visit, and a SQL ORDER BY over
// three tables would put the department's priority rule somewhere a clinician
// could never read it (SRS-ER-003).
func (s *Service) Board(ctx context.Context, in BoardInput) (domain.BoardView, error) {
	session, scope, err := s.authorize(ctx, PermEmergencyRead)
	if err != nil {
		return domain.BoardView{}, err
	}

	facility := trimmed(in.FacilityID, session.ActiveFacilityID)
	visits, err := s.visits.OpenVisits(ctx, scope, facility, clampPageSize(in.PageSize))
	if err != nil {
		return domain.BoardView{}, err
	}

	byID := make(map[string]domain.Visit, len(visits))
	entries := make([]domain.QueueEntry, 0, len(visits))

	for _, visit := range visits {
		byID[visit.ID] = visit

		triage, triaged, err := s.visits.LatestTriage(ctx, scope, visit.ID)
		if err != nil {
			return domain.BoardView{}, err
		}
		entry := domain.QueueEntry{
			VisitID: visit.ID, Display: describeVisit(visit),
			ArrivedAt: visit.ArrivedAt, Status: visit.Status,
			Location: visit.Location, Triaged: triaged,
		}
		if triaged {
			entry.AcuityRank, entry.ScaleName = triage.AcuityRank, triage.ScaleName
		}

		override, overridden, err := s.visits.LatestOverride(ctx, scope, visit.ID)
		if err != nil {
			return domain.BoardView{}, err
		}
		if overridden {
			entry.Override = &override
		}
		entries = append(entries, entry)
	}

	active, err := s.visits.ActivePathways(ctx, scope, facility)
	if err != nil {
		return domain.BoardView{}, err
	}

	// The permission check is the caller's; the redaction is the domain's.
	// Keeping them apart means a second caller cannot accidentally pass true.
	return domain.BuildBoard(entries, byID, active, s.config.scale(),
		session.HasPermission(PermRestrictedRead), s.clock.Now()), nil
}

// VisitRecord is everything one visit's screen needs.
type VisitRecord struct {
	Visit     domain.Visit
	Triage    []domain.Triage
	Pathways  []domain.Pathway
	Progress  map[string][]domain.MilestoneState
	Timeline  domain.Timeline
	Intervals domain.Intervals
	// Restricted is set where this caller may not see the visit's detail
	// (SRS-ER-011). The visit is still returned, because a clinician who
	// cannot see the medico-legal documentation may still need to know the
	// patient is in Resus 2.
	Restricted bool
}

// Record assembles one visit's whole emergency record.
func (s *Service) Record(ctx context.Context, visitID string) (VisitRecord, error) {
	session, scope, err := s.authorize(ctx, PermEmergencyRead)
	if err != nil {
		return VisitRecord{}, err
	}

	visit, err := s.visits.GetVisit(ctx, scope, visitID)
	if err != nil {
		return VisitRecord{}, err
	}

	restricted := visit.MedicoLegal && !session.HasPermission(PermRestrictedRead)
	if restricted {
		// The bed and the clock, and nothing else. SRS-ER-011's restricted
		// documentation workflow is about the content, not about whether the
		// patient exists.
		return VisitRecord{
			Visit: domain.Visit{
				ID: visit.ID, TenantID: visit.TenantID,
				FacilityID: visit.FacilityID, Status: visit.Status,
				Location: visit.Location, ArrivedAt: visit.ArrivedAt,
				MedicoLegal: true,
			},
			Restricted: true,
		}, nil
	}

	triage, err := s.visits.ListTriage(ctx, scope, visit.ID)
	if err != nil {
		return VisitRecord{}, err
	}
	pathways, err := s.visits.ListPathways(ctx, scope, visit.ID)
	if err != nil {
		return VisitRecord{}, err
	}
	timeline, err := s.visits.Timeline(ctx, scope, visit.ID)
	if err != nil {
		return VisitRecord{}, err
	}
	ordered := timeline.Ordered()

	now := s.clock.Now()
	progress := make(map[string][]domain.MilestoneState, len(pathways))
	for _, pathway := range pathways {
		progress[pathway.ID] = pathway.Progress(ordered, now)
	}

	return VisitRecord{
		Visit: visit, Triage: triage, Pathways: pathways, Progress: progress,
		Timeline: ordered, Intervals: ordered.Clocks(),
	}, nil
}
