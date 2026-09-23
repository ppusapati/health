package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// Tagged linen and uniforms (SRS-LND-007).

// RegisterTagInput puts a tagged item into circulation.
type RegisterTagInput struct {
	domain.NewTrackedInput
}

// RegisterTag registers a tagged item (SRS-LND-007).
//
// The item is read from the master and handed to the domain, which refuses
// anything the master does not call tracked. The database refuses the row for
// the same reason, through a composite key onto (tenant, code, tracked).
func (s *Service) RegisterTag(ctx context.Context, in RegisterTagInput) (
	domain.TrackedItem, error) {

	session, scope, err := s.authorize(ctx, PermTrackManage)
	if err != nil {
		return domain.TrackedItem{}, err
	}
	now := s.clock.Now()

	item, err := s.items.ItemByCode(ctx, scope, in.ItemCode)
	if err != nil {
		return domain.TrackedItem{}, err
	}

	tracked, err := domain.RegisterTag(s.ids.NewID(), session.TenantID,
		item, in.NewTrackedInput, session.SubjectID, now)
	if err != nil {
		return domain.TrackedItem{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tracked.InsertTracked(ctx, scope, tracked); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.tag.registered", ResourceType: "tracked_item",
			ResourceID: tracked.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"item_code": tracked.ItemCode,
				"tag_kind":  string(tracked.TagKind),
			}),
		}, now)
	})
	if err != nil {
		return domain.TrackedItem{}, err
	}
	return tracked, nil
}

// RecordScanInput records a tagged item being read.
type RecordScanInput struct {
	// TagID is what came off the reader. A scan arrives as a tag, not as an
	// identifier, which is why this is the lookup rather than the id.
	TagID    string
	Location string
	HolderID string
	Note     string
}

// RecordScan appends a movement (SRS-LND-007).
//
// Append-only, and attributed to the authenticated caller rather than to the
// reader. A movement with nobody behind it is a movement anybody standing
// near the reader can create, and nothing here writes an item off because it
// stopped being scanned.
func (s *Service) RecordScan(ctx context.Context, in RecordScanInput) (
	domain.TrackedItem, error) {

	session, scope, err := s.authorize(ctx, PermTrackScan)
	if err != nil {
		return domain.TrackedItem{}, err
	}
	now := s.clock.Now()

	tracked, err := s.tracked.TrackedByTag(ctx, scope, in.TagID)
	if err != nil {
		return domain.TrackedItem{}, err
	}
	before := len(tracked.Movements)
	if err := tracked.RecordMovement(in.Location, in.HolderID, in.Note,
		session.SubjectID, now); err != nil {
		return domain.TrackedItem{}, laundryError(err)
	}
	movement := tracked.Movements[before]

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tracked.AppendMovement(ctx, scope, tracked.ID,
			movement); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.tag.scanned", ResourceType: "tracked_item",
			ResourceID: tracked.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"location": movement.Location,
			}),
		}, now)
	})
	if err != nil {
		return domain.TrackedItem{}, err
	}
	return tracked, nil
}

// RetireTag takes a tagged item out of circulation (SRS-LND-007).
func (s *Service) RetireTag(ctx context.Context, trackedID, reason string) (
	domain.TrackedItem, error) {

	session, scope, err := s.authorize(ctx, PermTrackManage)
	if err != nil {
		return domain.TrackedItem{}, err
	}
	now := s.clock.Now()

	tracked, err := s.tracked.Tracked(ctx, scope, trackedID)
	if err != nil {
		return domain.TrackedItem{}, err
	}
	version := tracked.Version
	if err := tracked.Retire(reason, session.SubjectID, now); err != nil {
		return domain.TrackedItem{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tracked.UpdateTracked(ctx, scope, tracked,
			version); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.tag.retired", ResourceType: "tracked_item",
			ResourceID: tracked.ID, Outcome: audit.OutcomeSuccess,
			Reason: tracked.RetiredReason,
		}, now)
	})
	if err != nil {
		return domain.TrackedItem{}, err
	}
	return tracked, nil
}

// Custody answers where a tagged item was last seen (SRS-LND-007).
type Custody struct {
	Item    domain.TrackedItem
	Custody domain.Custody
}

// TrackedCustody reads one tagged item and its last known custody
// (SRS-LND-007).
func (s *Service) TrackedCustody(ctx context.Context, tagID string) (Custody,
	error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return Custody{}, err
	}
	tracked, err := s.tracked.TrackedByTag(ctx, scope, tagID)
	if err != nil {
		return Custody{}, err
	}
	return Custody{Item: tracked, Custody: tracked.LastKnown()}, nil
}

// ListTrackedInput narrows a tracked item read.
type ListTrackedInput struct {
	FacilityID    string
	ItemCode      string
	AssignedTo    string
	InServiceOnly bool
	PageSize      int32
	Offset        int32
}

// ListTracked reads tagged linen and uniforms (SRS-LND-007).
func (s *Service) ListTracked(ctx context.Context, in ListTrackedInput) (
	[]domain.TrackedItem, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.tracked.TrackedItems(ctx, scope, ports.TrackedFilter{
		FacilityID: in.FacilityID, ItemCode: in.ItemCode,
		AssignedTo: in.AssignedTo, InServiceOnly: in.InServiceOnly,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// StaleTracked lists tagged items nobody has scanned recently
// (SRS-LND-007).
//
// A report and nothing else. A uniform nobody has scanned for a month is
// usually a uniform somebody wore past a reader that was switched off, and
// nothing here writes one off.
func (s *Service) StaleTracked(ctx context.Context, facilityID string) (
	[]domain.Stale, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return nil, err
	}
	items, err := s.tracked.TrackedItems(ctx, scope, ports.TrackedFilter{
		FacilityID: facilityID, InServiceOnly: true,
		Limit: reportPageSize,
	})
	if err != nil {
		return nil, err
	}
	return domain.StaleItems(items, s.config.StaleTrackedAfter,
		s.clock.Now()), nil
}
