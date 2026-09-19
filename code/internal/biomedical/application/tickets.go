package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// RaiseTicket raises a breakdown or service request (SRS-BIO-005).
//
// The SLA is derived here rather than supplied: the promise that applies is
// the one the hospital bought, and a caller that could set its own response
// hours could give itself a week for an emergency.
func (s *Service) RaiseTicket(ctx context.Context, in domain.NewTicketInput) (
	domain.Ticket, error) {

	session, scope, err := s.authorize(ctx, PermRaise)
	if err != nil {
		return domain.Ticket{}, err
	}
	now := s.clock.Now()

	var ticket domain.Ticket
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		asset, err := s.assets.Asset(ctx, scope, in.AssetID)
		if err != nil {
			return err
		}
		contracts, err := s.contracts.ContractsForAsset(ctx, scope, asset.ID)
		if err != nil {
			return err
		}
		sla := domain.SLAFor(contracts, asset.ID, in.Priority, domain.SLA{
			ResponseHours:   s.config.DefaultResponseHours,
			ResolutionHours: s.config.DefaultResolutionHours,
		}, now)

		if in.Number == "" {
			in.Number = s.ids.NewID()
		}
		ticket, err = domain.RaiseTicket(s.ids.NewID(), session.TenantID, in,
			asset, sla, session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.tickets.InsertTicket(ctx, scope, ticket); err != nil {
			return err
		}

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.ticket.raise", ResourceType: "biomedical_ticket",
			ResourceID: ticket.ID, Outcome: audit.OutcomeSuccess,
			Reason: ticket.Symptom,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventTicketRaised,
			"biomedical_ticket", ticket.ID, map[string]any{
				"ticket_id":   ticket.ID,
				"number":      ticket.Number,
				"kind":        string(ticket.Kind),
				"asset_id":    ticket.AssetID,
				"tag":         ticket.AssetTag,
				"priority":    string(ticket.Priority),
				"impact":      string(ticket.Impact),
				"location_id": ticket.LocationID,
				"contract_id": ticket.ContractID,
			}, now); err != nil {
			return err
		}

		// Only a breakdown that actually stopped something. Planned work is
		// not an outage, and a hospital escalated for every scheduled service
		// stops reading the escalations.
		if ticket.Kind.Failure() &&
			(ticket.Impact == domain.ImpactServiceStopped ||
				ticket.Impact == domain.ImpactPatientAffected) {
			return s.escalateIfCritical(ctx, scope, asset,
				asset.Tag+" is out of service: "+ticket.Symptom, now)
		}
		return nil
	})
	if err != nil {
		return domain.Ticket{}, biomedicalError(err)
	}
	return ticket, nil
}

// Ticket reads one work order.
func (s *Service) Ticket(ctx context.Context, id string) (domain.Ticket, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Ticket{}, err
	}
	ticket, err := s.tickets.Ticket(ctx, scope, id)
	if err != nil {
		return domain.Ticket{}, biomedicalError(err)
	}
	return ticket, nil
}

// TicketFilter narrows the work list.
type TicketFilter struct {
	AssetID  string
	State    string
	OpenOnly bool
	PageSize int32
}

// Tickets lists work orders.
func (s *Service) Tickets(ctx context.Context, f TicketFilter) (
	[]domain.Ticket, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	tickets, err := s.tickets.Tickets(ctx, scope, f.AssetID, f.State,
		f.OpenOnly, clampPageSize(f.PageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}
	return tickets, nil
}

// mutateTicket is the shared read-modify-write for the work-order steps.
func (s *Service) mutateTicket(ctx context.Context, permission, ticketID string,
	expectedVersion int64, action string,
	apply func(*domain.Ticket, string) error) (domain.Ticket, error) {

	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.Ticket{}, err
	}
	now := s.clock.Now()

	var updated domain.Ticket
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		ticket, err := s.tickets.Ticket(ctx, scope, ticketID)
		if err != nil {
			return err
		}
		if err := apply(&ticket, session.SubjectID); err != nil {
			return err
		}
		if err := s.tickets.UpdateTicket(ctx, scope, ticket,
			expectedVersion); err != nil {
			return err
		}
		ticket.Version = expectedVersion + 1
		updated = ticket
		return s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "biomedical_ticket",
			ResourceID: ticket.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(ticket.State),
		}, now)
	})
	if err != nil {
		return domain.Ticket{}, biomedicalError(err)
	}
	return updated, nil
}

// AssignTicket gives a work order to an engineer (SRS-BIO-005).
func (s *Service) AssignTicket(ctx context.Context, ticketID, ownerID string,
	expectedVersion int64) (domain.Ticket, error) {

	now := s.clock.Now()
	return s.mutateTicket(ctx, PermService, ticketID, expectedVersion,
		"biomedical.ticket.assign",
		func(t *domain.Ticket, _ string) error {
			return t.Assign(ownerID, now)
		})
}

// StartTicket records the engineer arriving, which stops the response clock.
func (s *Service) StartTicket(ctx context.Context, ticketID string,
	expectedVersion int64) (domain.Ticket, error) {

	now := s.clock.Now()
	return s.mutateTicket(ctx, PermService, ticketID, expectedVersion,
		"biomedical.ticket.start",
		func(t *domain.Ticket, _ string) error { return t.Start(now) })
}

// AwaitParts stops the resolution clock while a part is on order
// (SRS-BIO-005).
//
// The clock stops because an SLA measures what the service provider controls,
// and a breach caused by a manufacturer's lead time is a supply problem
// reported as an engineering one.
func (s *Service) AwaitParts(ctx context.Context, ticketID, note string,
	expectedVersion int64) (domain.Ticket, error) {

	now := s.clock.Now()
	return s.mutateTicket(ctx, PermService, ticketID, expectedVersion,
		"biomedical.ticket.await_parts",
		func(t *domain.Ticket, _ string) error { return t.AwaitParts(note, now) })
}

// CancelTicket withdraws a work order that should not have been raised.
func (s *Service) CancelTicket(ctx context.Context, ticketID, reason string,
	expectedVersion int64) (domain.Ticket, error) {

	now := s.clock.Now()
	return s.mutateTicket(ctx, PermService, ticketID, expectedVersion,
		"biomedical.ticket.cancel",
		func(t *domain.Ticket, _ string) error { return t.Cancel(reason, now) })
}

// ResolveTicket records the repair (SRS-BIO-006).
func (s *Service) ResolveTicket(ctx context.Context, ticketID string,
	in domain.ResolveInput, expectedVersion int64) (domain.Ticket, error) {

	session, scope, err := s.authorize(ctx, PermService)
	if err != nil {
		return domain.Ticket{}, err
	}
	now := s.clock.Now()

	var updated domain.Ticket
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		ticket, err := s.tickets.Ticket(ctx, scope, ticketID)
		if err != nil {
			return err
		}
		if err := ticket.Resolve(in, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.tickets.UpdateTicket(ctx, scope, ticket,
			expectedVersion); err != nil {
			return err
		}
		ticket.Version = expectedVersion + 1
		updated = ticket

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "biomedical.ticket.resolve",
			ResourceType: "biomedical_ticket", ResourceID: ticket.ID,
			Outcome: audit.OutcomeSuccess, Reason: ticket.Diagnosis,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventTicketResolved,
			"biomedical_ticket", ticket.ID, map[string]any{
				"ticket_id":        ticket.ID,
				"number":           ticket.Number,
				"kind":             string(ticket.Kind),
				"asset_id":         ticket.AssetID,
				"tag":              ticket.AssetTag,
				"downtime_minutes": ticket.DowntimeMinutes(now),
				"parts":            len(ticket.Parts),
			}, now)
	})
	if err != nil {
		return domain.Ticket{}, biomedicalError(err)
	}
	return updated, nil
}

// CloseTicket validates a repair (SRS-BIO-006).
//
// Its own permission, and the domain refuses the engineer who did the work —
// two controls rather than one, because a permission grant is a configuration
// mistake away and the domain rule is not.
//
// Closing planned work also advances its plan's baseline, so PM compliance is
// counted from what was actually done rather than from what was scheduled.
func (s *Service) CloseTicket(ctx context.Context, ticketID, note string,
	expectedVersion int64) (domain.Ticket, error) {

	session, scope, err := s.authorize(ctx, PermValidate)
	if err != nil {
		return domain.Ticket{}, err
	}
	now := s.clock.Now()

	var updated domain.Ticket
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		ticket, err := s.tickets.Ticket(ctx, scope, ticketID)
		if err != nil {
			return err
		}
		if err := ticket.Close(session.SubjectID, note, now); err != nil {
			return err
		}
		if err := s.tickets.UpdateTicket(ctx, scope, ticket,
			expectedVersion); err != nil {
			return err
		}
		ticket.Version = expectedVersion + 1
		updated = ticket

		if ticket.Kind.Planned() && ticket.PlanID != "" {
			at := ticket.ResolvedAt
			if at.IsZero() {
				at = ticket.ClosedAt
			}
			if err := s.advancePlanBaseline(ctx, scope, ticket.PlanID,
				at); err != nil {
				return err
			}
		}

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.ticket.close", ResourceType: "biomedical_ticket",
			ResourceID: ticket.ID, Outcome: audit.OutcomeSuccess,
			Reason: note,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventTicketClosed,
			"biomedical_ticket", ticket.ID, map[string]any{
				"ticket_id": ticket.ID,
				"number":    ticket.Number,
				"kind":      string(ticket.Kind),
				"asset_id":  ticket.AssetID,
				"tag":       ticket.AssetTag,
				"plan_id":   ticket.PlanID,
				"closed_by": ticket.ClosedBy,
			}, now); err != nil {
			return err
		}
		// A repaired machine gives its room back what it took away.
		return s.publishCapabilities(ctx, session, scope, ticket.LocationID, now)
	})
	if err != nil {
		return domain.Ticket{}, biomedicalError(err)
	}
	return updated, nil
}

// Breach reports one ticket against the promise it was raised under.
type Breach struct {
	Ticket domain.Ticket
	// Response and Resolution are each true where that clock has been passed.
	Response   bool
	Resolution bool
}

// Breaches lists the open work that has run past its SLA (SRS-BIO-005).
func (s *Service) Breaches(ctx context.Context, pageSize int32) (
	[]Breach, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	tickets, err := s.tickets.Tickets(ctx, scope, "", "", true,
		clampPageSize(pageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}

	var out []Breach
	for _, ticket := range tickets {
		response, resolution := ticket.Breached(now)
		if response || resolution {
			out = append(out, Breach{
				Ticket: ticket, Response: response, Resolution: resolution,
			})
		}
	}
	return out, nil
}
