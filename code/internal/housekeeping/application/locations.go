package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Cleanable locations and the schedules derived from them (SRS-HKP-001).

// ConfigureLocationInput drafts a cleaning standard.
type ConfigureLocationInput struct {
	domain.NewLocationInput
}

// ConfigureLocation drafts a location's cleaning standard (SRS-HKP-001).
//
// A draft, not a standard in force. Nothing is cleaned to it and no task can
// be raised against it until somebody other than its author approves it.
func (s *Service) ConfigureLocation(ctx context.Context,
	in ConfigureLocationInput) (domain.CleanableLocation, error) {

	session, scope, err := s.authorize(ctx, PermLocationManage)
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	now := s.clock.Now()

	// A new revision supersedes whatever is in force for this code, so the
	// two are never live together. The revision number is derived rather
	// than supplied: two people configuring the same room at once would
	// otherwise both write revision three.
	existing, err := s.locations.RevisionsOf(ctx, scope, in.Code)
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	in.Revision = nextRevision(existing)

	location, err := domain.NewLocation(s.ids.NewID(), session.TenantID,
		in.NewLocationInput, session.SubjectID, now)
	if err != nil {
		return domain.CleanableLocation{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.locations.InsertLocation(ctx, scope, location); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "housekeeping.location.configured",
			ResourceType: "cleanable_location", ResourceID: location.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code":       location.Code,
				"revision":   itoa(location.Revision),
				"risk_class": string(location.RiskClass),
			}),
		}, now)
	})
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	return location, nil
}

func nextRevision(existing []domain.CleanableLocation) int {
	highest := 0
	for _, location := range existing {
		if location.Revision > highest {
			highest = location.Revision
		}
	}
	return highest + 1
}

// ApproveLocation puts a cleaning standard in force (SRS-HKP-001).
//
// The predecessor is superseded in the same transaction. Two live standards
// for one room is a room cleaned to whichever the reader opened, and the
// window in which both were live is the window nobody can reconstruct.
func (s *Service) ApproveLocation(ctx context.Context, locationID string,
	effectiveFrom time.Time) (domain.CleanableLocation, error) {

	session, scope, err := s.authorize(ctx, PermLocationApprove)
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	now := s.clock.Now()
	if effectiveFrom.IsZero() {
		effectiveFrom = now
	}

	location, err := s.locations.Location(ctx, scope, locationID)
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	version := location.Version
	if err := location.Approve(session.SubjectID, effectiveFrom,
		now); err != nil {
		return domain.CleanableLocation{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.locations.ApproveLocation(ctx, scope, location,
			version); err != nil {
			return housekeepingError(err)
		}
		revisions, err := s.locations.RevisionsOf(ctx, scope, location.Code)
		if err != nil {
			return err
		}
		for _, other := range revisions {
			if other.ID == location.ID || !other.Approved ||
				!other.SupersededAt.IsZero() {
				continue
			}
			if err := s.locations.SupersedeLocation(ctx, scope, other.ID,
				effectiveFrom); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "housekeeping.location.approved",
			ResourceType: "cleanable_location", ResourceID: location.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code":     location.Code,
				"revision": itoa(location.Revision),
			}),
		}, now)
	})
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	return location, nil
}

// ListLocationsInput narrows a location read.
type ListLocationsInput struct {
	FacilityID string
	Zone       string
	RiskClass  string
	LiveOnly   bool
	PageSize   int32
	Offset     int32
}

// ListLocations reads the cleanable location master (SRS-HKP-001).
func (s *Service) ListLocations(ctx context.Context, in ListLocationsInput) (
	[]domain.CleanableLocation, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.locations.Locations(ctx, scope, ports.LocationFilter{
		FacilityID: in.FacilityID, Zone: in.Zone, RiskClass: in.RiskClass,
		LiveOnly: in.LiveOnly, At: s.clock.Now(),
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// LocationInForce answers what a location is cleaned to right now
// (SRS-HKP-001).
func (s *Service) LocationInForce(ctx context.Context, code string) (
	domain.CleanableLocation, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	return s.inForce(ctx, scope, code, s.clock.Now())
}

func (s *Service) inForce(ctx context.Context, scope authctx.TenantScope,
	code string, at time.Time) (domain.CleanableLocation, error) {

	revisions, err := s.locations.RevisionsOf(ctx, scope, code)
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	location, ok := domain.LocationInForce(revisions, code, at)
	if !ok {
		return domain.CleanableLocation{}, rpcerr.FailedPrecondition(
			"HKP_NO_STANDARD_IN_FORCE",
			"no approved cleaning standard is in force for "+code)
	}
	return location, nil
}

// DueRoutineCleans lists the routine cleans that have fallen due
// (SRS-HKP-001).
//
// Derived from the configuration in force and the tasks already completed,
// never from a stored schedule. A frequency changed this morning changes what
// is due this afternoon, and nothing has to be regenerated for that to
// happen.
func (s *Service) DueRoutineCleans(ctx context.Context, facilityID string) (
	[]domain.DueRoutine, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	locations, err := s.locations.Locations(ctx, scope, ports.LocationFilter{
		FacilityID: facilityID, LiveOnly: true, At: now,
		Limit: facilityPageSize,
	})
	if err != nil {
		return nil, err
	}
	lastCleaned, err := s.tasks.LastCleanedByLocation(ctx, scope, facilityID)
	if err != nil {
		return nil, err
	}
	return domain.DueRoutineCleans(locations, lastCleaned, now), nil
}
