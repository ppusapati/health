package application

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// NewOrderInput places a diet order (SRS-DIET-002).
type NewOrderInput struct {
	PatientID     string
	EncounterID   string
	FacilityID    string
	WardID        string
	BedID         string
	Route         domain.Route
	Texture       domain.Texture
	Restrictions  []string
	Supplements   []string
	Instruction   string
	EffectiveFrom time.Time
	EffectiveTo   time.Time
}

// PlaceDietOrder records what the patient is to be given (SRS-DIET-002,
// SRS-DIET-003).
//
// The order is checked against the patient's documented allergies before it
// is written, and an order with an unresolved conflict is pending: the
// kitchen's read never returns one. SRS-DIET-003's acceptance is that a
// conflict requires authorised resolution, and an order the kitchen can
// already see is one nobody needs to resolve.
//
// Placing an order retires the patient's previous one in the same
// transaction. Two live orders for one patient is a kitchen that plates
// whichever is on top.
func (s *Service) PlaceDietOrder(ctx context.Context, in NewOrderInput) (
	domain.DietOrder, error) {

	session, scope, err := s.authorize(ctx, PermOrderWrite)
	if err != nil {
		return domain.DietOrder{}, err
	}
	now := s.clock.Now()

	allergens, err := s.allergensFor(ctx, scope, in.PatientID)
	if err != nil {
		return domain.DietOrder{}, err
	}

	var conflicts []domain.Conflict
	if in.Route.Oral() {
		// Only an oral order puts food in front of somebody. A tube feed's
		// formula is checked where the order for it lives.
		items, err := s.menu.ItemsForOrder(ctx, scope, in.Texture.Code,
			in.Supplements)
		if err != nil {
			return domain.DietOrder{}, err
		}
		conflicts = domain.CheckConflicts(items, allergens)
	}

	order, err := domain.PlaceDietOrder(s.ids.NewID(), session.TenantID,
		domain.NewOrderInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			FacilityID: in.FacilityID, WardID: in.WardID, BedID: in.BedID,
			Route: in.Route, Texture: in.Texture,
			Restrictions: in.Restrictions, Supplements: in.Supplements,
			Instruction:   in.Instruction,
			EffectiveFrom: in.EffectiveFrom, EffectiveTo: in.EffectiveTo,
		}, conflicts, session.SubjectID, now)
	if err != nil {
		return domain.DietOrder{}, dieteticsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.orders.InsertOrder(ctx, scope, order); err != nil {
			return err
		}
		if err := s.orders.SupersedeOtherOrders(ctx, scope, order.PatientID,
			order.ID, order.EffectiveFrom); err != nil {
			return err
		}

		event := EventOrderPlaced
		if order.State == domain.OrderPending {
			event = EventOrderPending
		}
		if err := s.appendEvent(ctx, session, event, "diet_order", order.ID,
			map[string]any{
				"patient_id": order.PatientID, "ward_id": order.WardID,
				"route": string(order.Route),
				// The count, never the allergen: an event stream is read by
				// more systems and under fewer controls than the record.
				"open_conflicts": len(order.OpenConflicts()),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.order.placed", ResourceType: "diet_order",
			ResourceID: order.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"route":     string(order.Route),
				"texture":   order.Texture.Code,
				"conflicts": itoa(len(order.OpenConflicts())),
			}),
			Reason: "placed a diet order",
		}, now)
	})
	if err != nil {
		return domain.DietOrder{}, dieteticsError(err)
	}
	return order, nil
}

// ResolveConflict authorises a diet item against a documented allergy
// (SRS-DIET-003).
//
// Its own permission and its own audit entry, because this is a person
// deciding that an allergy on the patient's record does not apply to this
// food. It is the decision an investigation reads first, and the note is what
// it reads.
func (s *Service) ResolveConflict(ctx context.Context, orderID, allergyRef,
	item, note string) (domain.DietOrder, error) {

	session, scope, err := s.authorize(ctx, PermResolveConflict)
	if err != nil {
		return domain.DietOrder{}, err
	}
	now := s.clock.Now()

	var resolved domain.DietOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.orders.Order(ctx, scope, orderID)
		if err != nil {
			return err
		}
		if err := order.ResolveConflict(allergyRef, item, note,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.orders.ResolveConflict(ctx, scope, order, allergyRef,
			item); err != nil {
			return err
		}
		resolved = order

		if order.State == domain.OrderActive {
			if err := s.appendEvent(ctx, session, EventConflictCleared,
				"diet_order", order.ID, map[string]any{
					"patient_id": order.PatientID,
					"ward_id":    order.WardID,
				}, now); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.conflict.resolved",
			ResourceType: "diet_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"allergy_ref": allergyRef, "item": item,
				"still_open": itoa(len(order.OpenConflicts())),
			}),
			Reason: note,
		}, now)
	})
	if err != nil {
		return domain.DietOrder{}, dieteticsError(err)
	}
	return resolved, nil
}

// CancelDietOrder stops a diet (SRS-DIET-002, SRS-DIET-009).
//
// The order stops now rather than at whatever time it was going to run to. A
// cancellation that leaves the order in force until midnight is a
// cancellation that sends supper, and the patient it sends supper to is
// usually one who has just been listed for theatre.
func (s *Service) CancelDietOrder(ctx context.Context, orderID,
	reason string) (domain.DietOrder, error) {

	session, scope, err := s.authorize(ctx, PermOrderWrite)
	if err != nil {
		return domain.DietOrder{}, err
	}
	now := s.clock.Now()

	var cancelled domain.DietOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.orders.Order(ctx, scope, orderID)
		if err != nil {
			return err
		}
		expected := order.Version
		if err := order.Cancel(reason, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.orders.UpdateOrder(ctx, scope, order,
			expected); err != nil {
			return err
		}
		cancelled = order

		if err := s.appendEvent(ctx, session, EventOrderCancelled,
			"diet_order", order.ID, map[string]any{
				"patient_id": order.PatientID, "ward_id": order.WardID,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.order.cancelled",
			ResourceType: "diet_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.DietOrder{}, dieteticsError(err)
	}
	return cancelled, nil
}

// CurrentDietOrder is what the kitchen may cook to for one patient
// (SRS-DIET-002).
//
// One order, never a list. A kitchen shown two current orders for one patient
// plates whichever is on top.
func (s *Service) CurrentDietOrder(ctx context.Context, patientID string) (
	domain.DietOrder, bool, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.DietOrder{}, false, err
	}
	now := s.clock.Now()

	orders, err := s.orders.OrdersForPatient(ctx, scope, patientID,
		wardPageSize)
	if err != nil {
		return domain.DietOrder{}, false, err
	}
	order, found := domain.OrderInForce(orders, now)
	return order, found, nil
}

// DietOrders lists a patient's orders (SRS-DIET-002).
func (s *Service) DietOrders(ctx context.Context, patientID string) (
	[]domain.DietOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.orders.OrdersForPatient(ctx, scope, patientID, wardPageSize)
}

// NewSupportPlanInput proposes nutrition support (SRS-DIET-007).
type NewSupportPlanInput struct {
	PatientID        string
	EncounterID      string
	Kind             domain.SupportKind
	FormulaCode      string
	FormulaName      string
	TargetVolumeML   int
	TargetEnergyKcal int
	TargetProteinG   int
	RampPlan         string
}

// PlanNutritionSupport proposes tube or intravenous feeding (SRS-DIET-007).
//
// A proposal and nothing more. Nothing is running until an order exists in
// the context that owns it, and this service has no way to create one.
func (s *Service) PlanNutritionSupport(ctx context.Context,
	in NewSupportPlanInput) (domain.NutritionSupportPlan, error) {

	session, scope, err := s.authorize(ctx, PermSupportPlan)
	if err != nil {
		return domain.NutritionSupportPlan{}, err
	}
	now := s.clock.Now()

	plan, err := domain.PlanNutritionSupport(s.ids.NewID(),
		session.TenantID, domain.NewSupportPlanInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			Kind: in.Kind, FormulaCode: in.FormulaCode,
			FormulaName:      in.FormulaName,
			TargetVolumeML:   in.TargetVolumeML,
			TargetEnergyKcal: in.TargetEnergyKcal,
			TargetProteinG:   in.TargetProteinG,
			RampPlan:         in.RampPlan,
		}, session.SubjectID, now)
	if err != nil {
		return domain.NutritionSupportPlan{}, dieteticsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.support.InsertSupportPlan(ctx, scope, plan); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.support.planned",
			ResourceType: "diet_support_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind": string(plan.Kind), "formula": plan.FormulaCode,
			}),
			Reason: "proposed nutrition support",
		}, now)
	})
	if err != nil {
		return domain.NutritionSupportPlan{}, dieteticsError(err)
	}
	return plan, nil
}

// LinkSupportOrder puts a support plan into force against the order carrying
// it out (SRS-DIET-007).
//
// The reference is resolved in the context that owns it before the plan goes
// active. Without that, "a plan cannot go active without an order" is
// defeated by typing anything into the field, and the pharmacy check the
// requirement exists to preserve is preserved in wording only.
func (s *Service) LinkSupportOrder(ctx context.Context, planID, ref,
	orderContext string) (domain.NutritionSupportPlan, error) {

	session, scope, err := s.authorize(ctx, PermLinkOrder)
	if err != nil {
		return domain.NutritionSupportPlan{}, err
	}
	now := s.clock.Now()

	if err := s.checkOrderContext(orderContext); err != nil {
		return domain.NutritionSupportPlan{}, err
	}

	var linked domain.NutritionSupportPlan
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.support.SupportPlan(ctx, scope, planID)
		if err != nil {
			return err
		}
		if err := s.checkOrderExists(ctx, scope, orderContext,
			ref); err != nil {
			return err
		}
		expected := plan.Version
		if err := plan.LinkOrder(ref, orderContext, now); err != nil {
			return err
		}
		if err := s.support.UpdateSupportPlan(ctx, scope, plan,
			expected); err != nil {
			return err
		}
		linked = plan

		if err := s.appendEvent(ctx, session, EventSupportActive,
			"diet_support_plan", plan.ID, map[string]any{
				"patient_id": plan.PatientID, "kind": string(plan.Kind),
				"order_context": plan.OrderContext,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.support.linked",
			ResourceType: "diet_support_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"order_ref": ref, "order_context": orderContext,
			}),
			Reason: "nutrition support is running against an order",
		}, now)
	})
	if err != nil {
		return domain.NutritionSupportPlan{}, dieteticsError(err)
	}
	return linked, nil
}

// StopSupport ends the dietetics side of nutrition support (SRS-DIET-007).
//
// Stopping the plan does not stop the feed: the order does that, in the
// context that owns it. This records the dietetics decision, and the response
// says so rather than implying the bag has been taken down.
func (s *Service) StopSupport(ctx context.Context, planID, reason string) (
	domain.NutritionSupportPlan, error) {

	session, scope, err := s.authorize(ctx, PermSupportPlan)
	if err != nil {
		return domain.NutritionSupportPlan{}, err
	}
	now := s.clock.Now()

	var stopped domain.NutritionSupportPlan
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.support.SupportPlan(ctx, scope, planID)
		if err != nil {
			return err
		}
		expected := plan.Version
		if err := plan.Stop(reason, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.support.UpdateSupportPlan(ctx, scope, plan,
			expected); err != nil {
			return err
		}
		stopped = plan
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.support.stopped",
			ResourceType: "diet_support_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"order_ref": plan.OrderRef,
			}),
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.NutritionSupportPlan{}, dieteticsError(err)
	}
	return stopped, nil
}

// SupportPlans lists nutrition support plans (SRS-DIET-007).
func (s *Service) SupportPlans(ctx context.Context,
	filter ports.SupportFilter) ([]domain.NutritionSupportPlan, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.support.SupportPlans(ctx, scope, filter)
}

// checkOrderContext refuses a context this deployment does not place orders
// in (SRS-DIET-007).
//
// Configured rather than fixed, because which context owns parenteral
// nutrition differs between hospitals. Empty accepts any, which the status
// document names as a deployment that has not decided.
func (s *Service) checkOrderContext(orderContext string) error {
	if len(s.config.SupportOrderContexts) == 0 {
		return nil
	}
	for _, allowed := range s.config.SupportOrderContexts {
		if strings.EqualFold(allowed, orderContext) {
			return nil
		}
	}
	return rpcerr.Invalid("DIET_UNKNOWN_ORDER_CONTEXT",
		"this deployment does not place nutrition orders in "+orderContext)
}

// checkOrderExists resolves the order a support plan names (SRS-DIET-007).
//
// Refused rather than trusted. A plan activated against a reference nobody
// can resolve is a feed running with no prescription behind it, and the
// pharmacy checks that would have caught a refeeding risk never happen.
func (s *Service) checkOrderExists(ctx context.Context,
	scope authctx.TenantScope, orderContext, ref string) error {

	if s.orderBook == nil {
		return rpcerr.FailedPrecondition("DIET_NO_ORDER_DIRECTORY",
			"this deployment cannot resolve the order a support plan "+
				"names, so the plan cannot be put into force")
	}
	exists, err := s.orderBook.Exists(ctx, scope, orderContext, ref)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("DIET_NO_SUCH_ORDER",
			"no order "+ref+" exists in "+orderContext)
	}
	return nil
}
