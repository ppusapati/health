package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// ListItemInput records one belonging (SRS-MORT-004).
type ListItemInput struct {
	CaseID      string
	Kind        string
	Description string
	Quantity    int
	SealNumber  string
	WitnessedBy string
}

// ListItem records one belonging into the mortuary's care (SRS-MORT-004).
func (s *Service) ListItem(ctx context.Context, in ListItemInput) (
	domain.Item, error) {

	session, scope, err := s.authorize(ctx, PermCustody)
	if err != nil {
		return domain.Item{}, err
	}
	now := s.clock.Now()

	var out domain.Item
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		item, err := domain.ListItem(s.ids.NewID(), session.TenantID,
			found, domain.NewItemInput{
				Kind:        domain.ItemKind(in.Kind),
				Description: in.Description, Quantity: in.Quantity,
				SealNumber: in.SealNumber, WitnessedBy: in.WitnessedBy,
			}, session.SubjectID, now)
		if err != nil {
			return mortuaryError(err)
		}
		if err := s.custody.InsertItem(ctx, scope, item); err != nil {
			return err
		}
		out = item

		if err := s.appendCustody(ctx, scope, found.ID, "listed",
			"belonging listed: "+item.Description, "", "",
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.belonging.listed",
			ResourceType: "mortuary.belonging", ResourceID: item.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"case_id": found.ID, "kind": string(item.Kind),
				"quantity": itoa(item.Quantity),
			}),
		}, now)
	})
	if err != nil {
		return domain.Item{}, err
	}
	return out, nil
}

// RetainItemInput records an authority taking a belonging (SRS-MORT-004).
type RetainItemInput struct {
	ItemID    string
	Authority string
	Reference string
}

// RetainItem records an authority taking an item (SRS-MORT-004).
//
// Its own act rather than a handover, because the family has not got it and
// telling them it was handed over would be untrue.
func (s *Service) RetainItem(ctx context.Context, in RetainItemInput) (
	domain.Item, error) {

	session, scope, err := s.authorize(ctx, PermCustody)
	if err != nil {
		return domain.Item{}, err
	}
	now := s.clock.Now()

	var out domain.Item
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		item, err := s.custody.Item(ctx, scope, in.ItemID)
		if err != nil {
			return err
		}
		before := item.State
		if err := item.Retain(in.Authority, in.Reference); err != nil {
			return mortuaryError(err)
		}
		if err := s.custody.UpdateItemState(ctx, scope, item,
			before); err != nil {
			return mortuaryError(err)
		}
		out = item

		if err := s.appendCustody(ctx, scope, item.CaseID, "retained",
			"retained by "+in.Authority, session.SubjectID, in.Authority,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.belonging.retained",
			ResourceType: "mortuary.belonging", ResourceID: item.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reference,
			Context: auditContext(map[string]string{
				"authority": in.Authority,
			}),
		}, now)
	})
	if err != nil {
		return domain.Item{}, err
	}
	return out, nil
}

// HandOverInput gives belongings to a named recipient (SRS-MORT-004).
type HandOverInput struct {
	CaseID            string
	ItemIDs           []string
	RecipientName     string
	RecipientRelation string
	RecipientIDType   string
	RecipientIDRef    string
	SignatureRef      string
	WitnessedBy       string
	Note              string
}

// HandOver gives listed belongings to somebody who signs for them
// (SRS-MORT-004).
func (s *Service) HandOver(ctx context.Context, in HandOverInput) (
	domain.Handover, error) {

	session, scope, err := s.authorize(ctx, PermHandover)
	if err != nil {
		return domain.Handover{}, err
	}
	now := s.clock.Now()

	var out domain.Handover
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		items := make([]*domain.Item, 0, len(in.ItemIDs))
		states := make([]domain.ItemState, 0, len(in.ItemIDs))
		for _, id := range in.ItemIDs {
			item, err := s.custody.Item(ctx, scope, id)
			if err != nil {
				return err
			}
			states = append(states, item.State)
			items = append(items, &item)
		}

		handover, err := domain.HandOver(s.ids.NewID(), session.TenantID,
			found, items, domain.NewHandoverInput{
				RecipientName:     in.RecipientName,
				RecipientRelation: in.RecipientRelation,
				RecipientIDType:   in.RecipientIDType,
				RecipientIDRef:    in.RecipientIDRef,
				SignatureRef:      in.SignatureRef,
				WitnessedBy:       in.WitnessedBy, Note: in.Note,
			}, session.SubjectID, now)
		if err != nil {
			return mortuaryError(err)
		}
		if err := s.custody.InsertHandover(ctx, scope,
			handover); err != nil {
			return err
		}
		for i, item := range items {
			if err := s.custody.UpdateItemState(ctx, scope, *item,
				states[i]); err != nil {
				return mortuaryError(err)
			}
		}
		out = handover

		if err := s.appendCustody(ctx, scope, found.ID,
			"belongings_handed_over",
			itoa(len(items))+" belonging(s) handed over",
			session.SubjectID, in.RecipientName, session.SubjectID,
			now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.belongings.handed_over",
			ResourceType: "mortuary.handover", ResourceID: handover.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"case_id": found.ID, "items": itoa(len(items)),
				"signature_ref": handover.SignatureRef,
			}),
		}, now)
	})
	if err != nil {
		return domain.Handover{}, err
	}
	return out, nil
}

// Belongings reads what the mortuary holds and has held (SRS-MORT-004).
func (s *Service) Belongings(ctx context.Context, caseID string) (
	[]domain.Item, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.custody.Items(ctx, scope, []string{caseID})
}

// Outstanding reads what the mortuary still holds (SRS-MORT-004).
func (s *Service) Outstanding(ctx context.Context, caseID string) (
	[]domain.Item, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	items, err := s.custody.Items(ctx, scope, []string{caseID})
	if err != nil {
		return nil, err
	}
	return domain.Outstanding(items, caseID), nil
}

// Chain reads the chain of custody (SRS-MORT-004).
func (s *Service) Chain(ctx context.Context, caseID string) (
	[]domain.CustodyEntry, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	entries, err := s.custody.Custody(ctx, scope, caseID)
	if err != nil {
		return nil, err
	}
	return domain.Chain(entries, caseID), nil
}

// Handovers reads the belongings handovers for a case (SRS-MORT-004).
func (s *Service) Handovers(ctx context.Context, caseID string) (
	[]domain.Handover, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.custody.Handovers(ctx, scope, caseID)
}
