package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// Condemned, damaged and missing linen (SRS-LND-006).

// ReportLossInput reports linen written off or gone missing.
type ReportLossInput struct {
	UnitID     string
	FacilityID string
	ItemCode   string
	Quantity   int
	Kind       domain.LossKind
	Reason     string
}

// ReportLoss records linen condemned, damaged or missing (SRS-LND-006).
//
// The replacement value is pinned from the item master at report time rather
// than computed on read, because a price list changed in March must not
// restate what January's losses cost.
func (s *Service) ReportLoss(ctx context.Context, in ReportLossInput) (
	domain.LossRecord, error) {

	session, scope, err := s.authorize(ctx, PermReportLoss)
	if err != nil {
		return domain.LossRecord{}, err
	}
	now := s.clock.Now()

	item, err := s.items.ItemByCode(ctx, scope, in.ItemCode)
	if err != nil {
		return domain.LossRecord{}, err
	}

	record, err := domain.ReportLoss(s.ids.NewID(), session.TenantID,
		domain.NewLossInput{
			UnitID: in.UnitID, FacilityID: in.FacilityID,
			ItemCode: item.Code, Quantity: in.Quantity, Kind: in.Kind,
			Reason: in.Reason, ValueMinor: item.ReplacementCostMinor,
			ApprovalThresholdMinor: s.config.LossApprovalThresholdMinor,
		}, session.SubjectID, now)
	if err != nil {
		return domain.LossRecord{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.losses.InsertLoss(ctx, scope, record); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.loss.reported", ResourceType: "loss_record",
			ResourceID: record.ID, Outcome: audit.OutcomeSuccess,
			Reason: record.Reason,
			Context: auditContext(map[string]string{
				"unit_id": record.UnitID, "item_code": record.ItemCode,
				"kind": string(record.Kind), "pieces": itoa(record.Quantity),
			}),
		}, now)
	})
	if err != nil {
		return domain.LossRecord{}, err
	}
	return record, nil
}

// DecideLoss approves or refuses a write-off (SRS-LND-006).
//
// Its own permission, and the domain refuses whoever reported it. A ward
// sister writing off her own ward's linen and approving it herself is the
// whole of why the requirement says "with approval where required".
func (s *Service) DecideLoss(ctx context.Context, lossID string,
	approve bool, note string) (domain.LossRecord, error) {

	session, scope, err := s.authorize(ctx, PermApproveLoss)
	if err != nil {
		return domain.LossRecord{}, err
	}
	now := s.clock.Now()

	record, err := s.losses.Loss(ctx, scope, lossID)
	if err != nil {
		return domain.LossRecord{}, err
	}
	version := record.Version
	if approve {
		err = record.Approve(note, session.SubjectID, now)
	} else {
		err = record.Reject(note, session.SubjectID, now)
	}
	if err != nil {
		return domain.LossRecord{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.losses.UpdateLoss(ctx, scope, record,
			version); err != nil {
			return laundryError(err)
		}
		if record.Counts() {
			if err := s.appendEvent(ctx, session, EventLossApproved,
				"loss_record", record.ID, map[string]any{
					"unit_id": record.UnitID, "item_code": record.ItemCode,
					"kind": string(record.Kind), "pieces": record.Quantity,
				}, now); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.loss.decided", ResourceType: "loss_record",
			ResourceID: record.ID, Outcome: audit.OutcomeSuccess,
			Reason: record.DecisionNote,
			Context: auditContext(map[string]string{
				"state": string(record.State),
				"value": itoa(record.ValueMinor * record.Quantity),
			}),
		}, now)
	})
	if err != nil {
		return domain.LossRecord{}, err
	}
	return record, nil
}

// RecoverLoss records missing linen turning up (SRS-LND-006).
//
// Its own state rather than a deletion. A hospital's loss figure has to be
// able to say "we lost four hundred sheets and found sixty of them", and a
// record somebody removed says neither number.
func (s *Service) RecoverLoss(ctx context.Context, lossID, note string) (
	domain.LossRecord, error) {

	session, scope, err := s.authorize(ctx, PermReportLoss)
	if err != nil {
		return domain.LossRecord{}, err
	}
	now := s.clock.Now()

	record, err := s.losses.Loss(ctx, scope, lossID)
	if err != nil {
		return domain.LossRecord{}, err
	}
	version := record.Version
	if err := record.Recover(note, session.SubjectID, now); err != nil {
		return domain.LossRecord{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.losses.UpdateLoss(ctx, scope, record,
			version); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.loss.recovered", ResourceType: "loss_record",
			ResourceID: record.ID, Outcome: audit.OutcomeSuccess,
			Reason: record.DecisionNote,
		}, now)
	})
	if err != nil {
		return domain.LossRecord{}, err
	}
	return record, nil
}

// ListLossesInput narrows a loss read.
type ListLossesInput struct {
	FacilityID string
	UnitID     string
	ItemCode   string
	Kind       string
	States     []string
	From       time.Time
	To         time.Time
	PageSize   int32
	Offset     int32
}

// ListLosses reads the write-off register (SRS-LND-006).
func (s *Service) ListLosses(ctx context.Context, in ListLossesInput) (
	[]domain.LossRecord, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.losses.Losses(ctx, scope, ports.LossFilter{
		FacilityID: in.FacilityID, UnitID: in.UnitID,
		ItemCode: in.ItemCode, Kind: in.Kind, States: in.States,
		From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// PendingApprovals lists write-offs somebody has to decide, largest first
// (SRS-LND-006).
func (s *Service) PendingApprovals(ctx context.Context, facilityID string) (
	[]domain.LossRecord, error) {

	_, scope, err := s.authorize(ctx, PermApproveLoss)
	if err != nil {
		return nil, err
	}
	found, err := s.losses.Losses(ctx, scope, ports.LossFilter{
		FacilityID: facilityID, States: []string{"reported"},
		Limit: reportPageSize,
	})
	if err != nil {
		return nil, err
	}
	return domain.AwaitingApproval(found), nil
}
