package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// BuildCensus lists what to cook for one ward and one service
// (SRS-DIET-005).
//
// Built from the orders in force at the moment it is taken, and only the oral
// ones. Nil by mouth, enteral and parenteral produce no tray, and a kitchen
// that plates one for them is a kitchen that sends food to a patient who must
// not eat.
func (s *Service) BuildCensus(ctx context.Context, wardID, facilityID string,
	cycle domain.MealCycle, serviceDate, cutoffAt time.Time) (
	domain.MealCensus, error) {

	session, scope, err := s.authorize(ctx, PermCensusManage)
	if err != nil {
		return domain.MealCensus{}, err
	}
	now := s.clock.Now()

	orders, err := s.orders.OrdersForWard(ctx, scope, wardID, wardPageSize)
	if err != nil {
		return domain.MealCensus{}, err
	}

	census, err := domain.BuildCensus(s.ids.NewID(), session.TenantID,
		facilityID, wardID, cycle, serviceDate, cutoffAt, orders, now,
		session.SubjectID, now)
	if err != nil {
		return domain.MealCensus{}, dieteticsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.censuses.InsertCensus(ctx, scope, census); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.census.built", ResourceType: "diet_census",
			ResourceID: census.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"ward": census.WardID, "cycle": string(census.Cycle),
				"trays": itoa(len(census.Lines)),
			}),
			Reason: "built a meal census",
		}, now)
	})
	if err != nil {
		return domain.MealCensus{}, dieteticsError(err)
	}
	return census, nil
}

// FreezeCensus fixes the census at production cutoff (SRS-DIET-005).
func (s *Service) FreezeCensus(ctx context.Context, censusID string) (
	domain.MealCensus, error) {

	session, scope, err := s.authorize(ctx, PermCensusManage)
	if err != nil {
		return domain.MealCensus{}, err
	}
	now := s.clock.Now()

	var frozen domain.MealCensus
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		census, err := s.censuses.Census(ctx, scope, censusID)
		if err != nil {
			return err
		}
		if err := census.Freeze(session.SubjectID, now); err != nil {
			return err
		}
		if err := s.censuses.FreezeCensus(ctx, scope, census); err != nil {
			return err
		}
		frozen = census

		if err := s.appendEvent(ctx, session, EventCensusFrozen,
			"diet_census", census.ID, map[string]any{
				"ward_id": census.WardID, "cycle": string(census.Cycle),
				"trays": len(census.Lines), "version": census.Version,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.census.frozen", ResourceType: "diet_census",
			ResourceID: census.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"trays":   itoa(len(census.Lines)),
				"version": itoa(census.Version),
			}),
			Reason: "the kitchen's count at production cutoff",
		}, now)
	})
	if err != nil {
		return domain.MealCensus{}, dieteticsError(err)
	}
	return frozen, nil
}

// ReissueCensus builds the next version of a frozen census (SRS-DIET-005).
//
// A new census rather than an edit, and the frozen one stays readable. A ward
// that admits four patients after cutoff gets four more trays, and the
// hospital keeps both answers to what the kitchen cooked to.
func (s *Service) ReissueCensus(ctx context.Context, censusID string) (
	domain.MealCensus, error) {

	session, scope, err := s.authorize(ctx, PermCensusManage)
	if err != nil {
		return domain.MealCensus{}, err
	}
	now := s.clock.Now()

	var reissued domain.MealCensus
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		census, err := s.censuses.Census(ctx, scope, censusID)
		if err != nil {
			return err
		}
		orders, err := s.orders.OrdersForWard(ctx, scope, census.WardID,
			wardPageSize)
		if err != nil {
			return err
		}
		next, err := census.Reissue(s.ids.NewID(), orders, now,
			session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := next.Freeze(session.SubjectID, now); err != nil {
			return err
		}
		if err := s.censuses.InsertCensus(ctx, scope, next); err != nil {
			return err
		}
		if err := s.censuses.SupersedeCensus(ctx, scope,
			census.ID); err != nil {
			return err
		}
		reissued = next

		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.census.reissued",
			ResourceType: "diet_census", ResourceID: next.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"supersedes": census.ID, "version": itoa(next.Version),
				"trays": itoa(len(next.Lines)),
			}),
			Reason: "the ward changed after the production cutoff",
		}, now)
	})
	if err != nil {
		return domain.MealCensus{}, dieteticsError(err)
	}
	return reissued, nil
}

// Censuses lists meal censuses (SRS-DIET-005).
func (s *Service) Censuses(ctx context.Context, filter ports.CensusFilter) (
	[]domain.MealCensus, error) {

	_, scope, err := s.authorize(ctx, PermServiceRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.censuses.Censuses(ctx, scope, filter)
}

// PlateTrays turns a frozen census into trays (SRS-DIET-006).
func (s *Service) PlateTrays(ctx context.Context, censusID string) (
	[]domain.Tray, error) {

	session, scope, err := s.authorize(ctx, PermTrayWrite)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	var plated []domain.Tray
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		census, err := s.censuses.Census(ctx, scope, censusID)
		if err != nil {
			return err
		}
		existing, err := s.trays.Trays(ctx, scope, ports.TrayFilter{
			CensusID: censusID, Limit: wardPageSize,
		})
		if err != nil {
			return err
		}
		already := map[string]bool{}
		for _, tray := range existing {
			already[tray.PatientID] = true
		}

		for _, line := range census.Lines {
			if already[line.PatientID] {
				// Plating the same census twice is two meals counted for one
				// patient and a ward count that never reconciles.
				continue
			}
			tray, err := domain.NewTray(s.ids.NewID(), session.TenantID,
				census, line, s.dueBy(now))
			if err != nil {
				return err
			}
			if err := s.trays.InsertTray(ctx, scope, tray); err != nil {
				return err
			}
			plated = append(plated, tray)
		}

		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.trays.plated", ResourceType: "diet_census",
			ResourceID: censusID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"plated": itoa(len(plated)),
				"lines":  itoa(len(census.Lines)),
			}),
			Reason: "plated a meal service",
		}, now)
	})
	if err != nil {
		return nil, dieteticsError(err)
	}
	return plated, nil
}

// PrepareTray records a tray plated (SRS-DIET-006).
func (s *Service) PrepareTray(ctx context.Context, trayID string) (
	domain.Tray, error) {

	return s.moveTray(ctx, trayID,
		func(tray *domain.Tray, session authctx.Session,
			now time.Time) error {

			return tray.Prepare(session.SubjectID, now)
		}, "dietetics.tray.prepared", "prepared a tray")
}

// DispatchTray sends a tray to the ward, against the order in force now
// (SRS-DIET-009).
//
// The order is re-read here rather than trusted from the census, and that is
// the whole point of this method existing separately. The census was taken
// before the production cutoff and the tray leaves afterwards; in between is
// exactly where a patient is made nil by mouth for a theatre list, downgraded
// to a pureed texture after a swallow assessment, or discharged.
//
// A tray the check stops is withheld with the reason and the ward is told,
// because a meal that simply fails to arrive looks like one that went astray.
func (s *Service) DispatchTray(ctx context.Context, trayID string) (
	domain.Tray, error) {

	session, scope, err := s.authorize(ctx, PermTrayWrite)
	if err != nil {
		return domain.Tray{}, err
	}
	now := s.clock.Now()

	var dispatched domain.Tray
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		tray, err := s.trays.Tray(ctx, scope, trayID)
		if err != nil {
			return err
		}
		line, err := s.censusLine(ctx, scope, tray)
		if err != nil {
			return err
		}
		orders, err := s.orders.OrdersForPatient(ctx, scope, tray.PatientID,
			wardPageSize)
		if err != nil {
			return err
		}
		inForce, found := domain.OrderInForce(orders, now)

		expected := tray.Version
		if reason, stop := domain.WithholdReason(inForce, found,
			line); stop {

			if err := tray.Withhold(reason, session.SubjectID,
				now); err != nil {
				return err
			}
			if err := s.trays.UpdateTray(ctx, scope, tray,
				expected); err != nil {
				return err
			}
			dispatched = tray

			if err := s.appendEvent(ctx, session, EventTrayWithheld,
				"diet_tray", tray.ID, map[string]any{
					"patient_id": tray.PatientID, "ward_id": tray.WardID,
					"cycle": string(tray.Cycle), "reason": reason,
				}, now); err != nil {
				return err
			}
			if err := s.escalate(ctx, session, scope, ports.Notice{
				Kind: EscalationWithheld, Subject: tray.ID,
				Summary: "a meal was held back: " + reason,
			}, now); err != nil {
				return err
			}
			return s.appendAudit(ctx, session, audit.Record{
				Action:       "dietetics.tray.withheld",
				ResourceType: "diet_tray", ResourceID: tray.ID,
				Outcome: audit.OutcomeSuccess, Reason: reason,
			}, now)
		}

		if err := tray.Dispatch(inForce, found, line, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.trays.UpdateTray(ctx, scope, tray,
			expected); err != nil {
			return err
		}
		dispatched = tray
		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.tray.dispatched", ResourceType: "diet_tray",
			ResourceID: tray.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"order_id": inForce.ID,
			}),
			Reason: "checked against the order in force and sent",
		}, now)
	})
	if err != nil {
		return domain.Tray{}, dieteticsError(err)
	}
	return dispatched, nil
}

// DeliverTray records the meal reaching the patient (SRS-DIET-006).
func (s *Service) DeliverTray(ctx context.Context, trayID string) (
	domain.Tray, error) {

	return s.moveTray(ctx, trayID,
		func(tray *domain.Tray, session authctx.Session,
			now time.Time) error {

			return tray.Deliver(session.SubjectID, now)
		}, "dietetics.tray.delivered", "a meal reached the patient")
}

// CloseTray records a meal the patient declined or never received
// (SRS-DIET-006).
//
// A missed meal escalates once the run reaches the configured length. A
// patient who has missed three meals has not eaten for a day, which is a
// referral rather than a logistics note.
func (s *Service) CloseTray(ctx context.Context, trayID string,
	to domain.TrayState, reason string) (domain.Tray, error) {

	session, scope, err := s.authorize(ctx, PermTrayWrite)
	if err != nil {
		return domain.Tray{}, err
	}
	now := s.clock.Now()

	var closed domain.Tray
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		tray, err := s.trays.Tray(ctx, scope, trayID)
		if err != nil {
			return err
		}
		expected := tray.Version
		if err := tray.Close(to, reason, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.trays.UpdateTray(ctx, scope, tray,
			expected); err != nil {
			return err
		}
		closed = tray

		if to == domain.TrayMissed {
			if err := s.appendEvent(ctx, session, EventMealMissed,
				"diet_tray", tray.ID, map[string]any{
					"patient_id": tray.PatientID, "ward_id": tray.WardID,
					"cycle": string(tray.Cycle),
				}, now); err != nil {
				return err
			}
			if err := s.escalateMissedRun(ctx, session, scope, tray,
				now); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.tray.closed", ResourceType: "diet_tray",
			ResourceID: tray.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{"state": string(to)}),
			Reason:  reason,
		}, now)
	})
	if err != nil {
		return domain.Tray{}, dieteticsError(err)
	}
	return closed, nil
}

// Trays lists a service's trays (SRS-DIET-006).
func (s *Service) Trays(ctx context.Context, filter ports.TrayFilter) (
	[]domain.Tray, error) {

	_, scope, err := s.authorize(ctx, PermServiceRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.trays.Trays(ctx, scope, filter)
}

// MealOutcome counts what happened to a service (SRS-DIET-006).
func (s *Service) MealOutcome(ctx context.Context, censusID string) (
	domain.MealOutcome, error) {

	_, scope, err := s.authorize(ctx, PermServiceRead)
	if err != nil {
		return domain.MealOutcome{}, err
	}
	now := s.clock.Now()

	trays, err := s.trays.Trays(ctx, scope, ports.TrayFilter{
		CensusID: censusID, Limit: wardPageSize,
	})
	if err != nil {
		return domain.MealOutcome{}, err
	}
	return domain.SummariseMeals(trays, now), nil
}

// moveTray applies a one-step transition.
func (s *Service) moveTray(ctx context.Context, trayID string,
	move func(*domain.Tray, authctx.Session, time.Time) error,
	action, reason string) (domain.Tray, error) {

	session, scope, err := s.authorize(ctx, PermTrayWrite)
	if err != nil {
		return domain.Tray{}, err
	}
	now := s.clock.Now()

	var moved domain.Tray
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		tray, err := s.trays.Tray(ctx, scope, trayID)
		if err != nil {
			return err
		}
		expected := tray.Version
		if err := move(&tray, session, now); err != nil {
			return err
		}
		if err := s.trays.UpdateTray(ctx, scope, tray,
			expected); err != nil {
			return err
		}
		moved = tray
		return s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "diet_tray", ResourceID: tray.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Tray{}, dieteticsError(err)
	}
	return moved, nil
}

// censusLine finds the line a tray was plated from (SRS-DIET-009).
//
// The dispatch check compares the order in force against what was plated, so
// the line is what the comparison is made to. A tray whose line has gone is
// refused rather than dispatched against nothing.
func (s *Service) censusLine(ctx context.Context, scope authctx.TenantScope,
	tray domain.Tray) (domain.CensusLine, error) {

	census, err := s.censuses.Census(ctx, scope, tray.CensusID)
	if err != nil {
		return domain.CensusLine{}, err
	}
	for _, line := range census.Lines {
		if line.PatientID == tray.PatientID {
			return line, nil
		}
	}
	return domain.CensusLine{}, rpcerr.FailedPrecondition(
		"DIET_NO_CENSUS_LINE",
		"this tray's census line is gone, so there is nothing to check the "+
			"order in force against")
}

// dueBy is when a meal stops being this meal.
func (s *Service) dueBy(now time.Time) time.Time {
	if s.config.MealWindow <= 0 {
		return time.Time{}
	}
	return now.Add(s.config.MealWindow)
}

// escalateMissedRun raises a notice once a patient's run of missed meals
// reaches the configured length (SRS-DIET-006).
func (s *Service) escalateMissedRun(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope, tray domain.Tray,
	now time.Time) error {

	if s.config.MissedMealsBeforeEscalation <= 0 {
		return nil
	}
	missed, err := s.trays.Trays(ctx, scope, ports.TrayFilter{
		WardID: tray.WardID, State: string(domain.TrayMissed),
		Limit: wardPageSize,
	})
	if err != nil {
		return err
	}
	count := 0
	for _, one := range missed {
		if one.PatientID == tray.PatientID {
			count++
		}
	}
	if count < s.config.MissedMealsBeforeEscalation {
		return nil
	}
	return s.escalate(ctx, session, scope, ports.Notice{
		Kind: EscalationMissed, Subject: tray.PatientID,
		Summary: "this patient has missed " + itoa(count) + " meals",
	}, now)
}
