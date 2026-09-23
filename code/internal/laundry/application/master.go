package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The linen item master and unit par levels (SRS-LND-001).

// ConfigureItem registers a linen item (SRS-LND-001).
func (s *Service) ConfigureItem(ctx context.Context,
	in domain.NewItemInput) (domain.LinenItem, error) {

	session, scope, err := s.authorize(ctx, PermMasterManage)
	if err != nil {
		return domain.LinenItem{}, err
	}
	now := s.clock.Now()

	item, err := domain.NewItem(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.LinenItem{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.items.InsertItem(ctx, scope, item); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.item.configured", ResourceType: "linen_item",
			ResourceID: item.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": item.Code, "category": string(item.Category),
			}),
		}, now)
	})
	if err != nil {
		return domain.LinenItem{}, err
	}
	return item, nil
}

// RetireItem stops an item being issued (SRS-LND-001).
func (s *Service) RetireItem(ctx context.Context, itemID string) (
	domain.LinenItem, error) {

	session, scope, err := s.authorize(ctx, PermMasterManage)
	if err != nil {
		return domain.LinenItem{}, err
	}
	now := s.clock.Now()

	item, err := s.items.Item(ctx, scope, itemID)
	if err != nil {
		return domain.LinenItem{}, err
	}
	version := item.Version
	if err := item.Retire(now); err != nil {
		return domain.LinenItem{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.items.UpdateItem(ctx, scope, item, version); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.item.retired", ResourceType: "linen_item",
			ResourceID: item.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{"code": item.Code}),
		}, now)
	})
	if err != nil {
		return domain.LinenItem{}, err
	}
	return item, nil
}

// ListItemsInput narrows a master read.
type ListItemsInput struct {
	Category    string
	TrackedOnly bool
	ActiveOnly  bool
	PageSize    int32
	Offset      int32
}

// ListItems reads the linen item master (SRS-LND-001).
func (s *Service) ListItems(ctx context.Context, in ListItemsInput) (
	[]domain.LinenItem, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.items.Items(ctx, scope, ports.ItemFilter{
		Category: in.Category, TrackedOnly: in.TrackedOnly,
		ActiveOnly: in.ActiveOnly,
		Limit:      clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// SetParInput drafts a unit's par level.
type SetParInput struct {
	UnitID     string
	UnitName   string
	FacilityID string
	Lines      []domain.ParLine
}

// SetPar drafts a unit's linen par (SRS-LND-001).
//
// A draft, not a par in force. No ward is held to it and no shortfall is
// computed against it until somebody other than its author approves it.
func (s *Service) SetPar(ctx context.Context, in SetParInput) (
	domain.ParLevel, error) {

	session, scope, err := s.authorize(ctx, PermMasterManage)
	if err != nil {
		return domain.ParLevel{}, err
	}
	now := s.clock.Now()

	if err := s.checkUnit(ctx, scope, in.UnitID); err != nil {
		return domain.ParLevel{}, err
	}

	// The revision is derived rather than supplied: two people setting the
	// same ward's par at once would otherwise both write revision three.
	existing, err := s.pars.RevisionsOf(ctx, scope, in.UnitID)
	if err != nil {
		return domain.ParLevel{}, err
	}

	par, err := domain.NewParLevel(s.ids.NewID(), session.TenantID,
		domain.NewParInput{
			UnitID: in.UnitID, UnitName: in.UnitName,
			FacilityID: in.FacilityID, Revision: nextRevision(existing),
			Lines: in.Lines,
		}, session.SubjectID, now)
	if err != nil {
		return domain.ParLevel{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.pars.InsertPar(ctx, scope, par); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.par.drafted", ResourceType: "par_level",
			ResourceID: par.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"unit_id": par.UnitID, "revision": itoa(par.Revision),
				"lines": itoa(len(par.Lines)),
			}),
		}, now)
	})
	if err != nil {
		return domain.ParLevel{}, err
	}
	return par, nil
}

func nextRevision(existing []domain.ParLevel) int {
	highest := 0
	for _, level := range existing {
		if level.Revision > highest {
			highest = level.Revision
		}
	}
	return highest + 1
}

// ApprovePar puts a unit's par in force (SRS-LND-001).
//
// The predecessor is superseded in the same transaction. Two live pars for
// one ward is a ward stocked to whichever the reader opened, and the window
// in which both were live is the window nobody can reconstruct.
func (s *Service) ApprovePar(ctx context.Context, parID string,
	effectiveFrom time.Time) (domain.ParLevel, error) {

	session, scope, err := s.authorize(ctx, PermParApprove)
	if err != nil {
		return domain.ParLevel{}, err
	}
	now := s.clock.Now()
	if effectiveFrom.IsZero() {
		effectiveFrom = now
	}

	par, err := s.pars.Par(ctx, scope, parID)
	if err != nil {
		return domain.ParLevel{}, err
	}
	version := par.Version
	if err := par.Approve(session.SubjectID, effectiveFrom,
		now); err != nil {
		return domain.ParLevel{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.pars.ApprovePar(ctx, scope, par, version); err != nil {
			return laundryError(err)
		}
		revisions, err := s.pars.RevisionsOf(ctx, scope, par.UnitID)
		if err != nil {
			return err
		}
		for _, other := range revisions {
			if other.ID == par.ID || !other.Approved ||
				!other.SupersededAt.IsZero() {
				continue
			}
			if err := s.pars.SupersedePar(ctx, scope, other.ID,
				effectiveFrom); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.par.approved", ResourceType: "par_level",
			ResourceID: par.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"unit_id": par.UnitID, "revision": itoa(par.Revision),
			}),
		}, now)
	})
	if err != nil {
		return domain.ParLevel{}, err
	}
	return par, nil
}

// ParInForce answers what a unit is held to right now (SRS-LND-001).
func (s *Service) ParInForce(ctx context.Context, unitID string) (
	domain.ParLevel, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.ParLevel{}, err
	}
	return s.inForce(ctx, scope, unitID, s.clock.Now())
}

func (s *Service) inForce(ctx context.Context, scope authctx.TenantScope,
	unitID string, at time.Time) (domain.ParLevel, error) {

	revisions, err := s.pars.RevisionsOf(ctx, scope, unitID)
	if err != nil {
		return domain.ParLevel{}, err
	}
	par, ok := domain.ParInForce(revisions, unitID, at)
	if !ok {
		return domain.ParLevel{}, rpcerr.FailedPrecondition(
			"LND_NO_PAR_IN_FORCE",
			"no approved par level is in force for "+unitID)
	}
	return par, nil
}

// ListParsInput narrows a par read.
type ListParsInput struct {
	FacilityID string
	UnitID     string
	LiveOnly   bool
	PageSize   int32
	Offset     int32
}

// ListPars reads unit par levels (SRS-LND-001).
func (s *Service) ListPars(ctx context.Context, in ListParsInput) (
	[]domain.ParLevel, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.pars.Pars(ctx, scope, ports.ParFilter{
		FacilityID: in.FacilityID, UnitID: in.UnitID,
		LiveOnly: in.LiveOnly, At: s.clock.Now(),
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}
