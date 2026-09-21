package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// ConfigureItem records something the kitchen can put on a tray, and what is
// in it (SRS-DIET-003, SRS-DIET-008).
//
// The allergen codes live here rather than on the allergy. The clinical
// record says what the patient reacts to; this says what the food contains,
// and the conflict check matches the two on codes. An item configured without
// them is an item the check cannot see through, which is why this permission
// is separate from the one that places orders.
func (s *Service) ConfigureItem(ctx context.Context, item domain.DietItem,
	kind string) error {

	session, scope, err := s.authorize(ctx, PermMenuManage)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	switch kind {
	case "ingredient", "supplement", "dish":
	default:
		return rpcerr.Invalid("DIET_UNKNOWN_ITEM_KIND",
			"an item is an ingredient, a supplement or a dish, not "+kind)
	}

	return dieteticsError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.menu.InsertItem(ctx, scope, item, kind); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.item.configured", ResourceType: "diet_item",
			ResourceID: item.Code, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind": kind, "allergens": itoa(len(item.AllergenCodes)),
			}),
			Reason: "configured a kitchen item",
		}, now)
	}))
}

// ConfigureRecipe records a dish and what it takes (SRS-DIET-008).
func (s *Service) ConfigureRecipe(ctx context.Context,
	recipe domain.Recipe) error {

	session, scope, err := s.authorize(ctx, PermMenuManage)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return dieteticsError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.menu.InsertRecipe(ctx, scope, recipe); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.recipe.configured",
			ResourceType: "diet_recipe", ResourceID: recipe.Code,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"ingredients": itoa(len(recipe.Ingredients)),
			}),
			Reason: "configured a recipe",
		}, now)
	}))
}

// ConfigureMenuItem puts a recipe on the menu for a cycle and a texture
// (SRS-DIET-008).
//
// Keyed on texture, because a pureed lunch and a normal lunch are different
// dishes with different ingredients, and a forecast that ignored texture
// would order the wrong things for the patients least able to eat them.
func (s *Service) ConfigureMenuItem(ctx context.Context,
	item domain.MenuItem) error {

	session, scope, err := s.authorize(ctx, PermMenuManage)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return dieteticsError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.menu.InsertMenuItem(ctx, scope, item); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.menu.configured",
			ResourceType: "diet_menu_item", ResourceID: item.Recipe.Code,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"cycle": string(item.Cycle), "texture": item.TextureCode,
			}),
			Reason: "put a recipe on the menu",
		}, now)
	}))
}

// Menu lists the recipes a cycle carries (SRS-DIET-008).
func (s *Service) Menu(ctx context.Context, cycle domain.MealCycle) (
	[]domain.MenuItem, error) {

	_, scope, err := s.authorize(ctx, PermServiceRead)
	if err != nil {
		return nil, err
	}
	return s.menu.Menu(ctx, scope, cycle)
}

// RecordConsumption counts what the kitchen actually used (SRS-DIET-008).
func (s *Service) RecordConsumption(ctx context.Context, censusID,
	ingredientCode string, actualG int, note string) (domain.Consumption,
	error) {

	session, scope, err := s.authorize(ctx, PermCountRecord)
	if err != nil {
		return domain.Consumption{}, err
	}
	now := s.clock.Now()

	count, err := domain.RecordConsumption(s.ids.NewID(), session.TenantID,
		censusID, ingredientCode, actualG, note, session.SubjectID, now)
	if err != nil {
		return domain.Consumption{}, dieteticsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.menu.AppendConsumption(ctx, scope, count); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.consumption.recorded",
			ResourceType: "diet_census", ResourceID: censusID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"ingredient": count.IngredientCode,
				"actual_g":   itoa(count.ActualG),
			}),
			Reason: "counted what a service used",
		}, now)
	})
	if err != nil {
		return domain.Consumption{}, dieteticsError(err)
	}
	return count, nil
}

// IngredientForecast reports what a service was expected to consume and what
// it did (SRS-DIET-008).
//
// Two numbers, never one. A single variance figure cannot say whether the
// kitchen over-ordered or over-served, and those are different problems with
// different fixes.
func (s *Service) IngredientForecast(ctx context.Context, censusID string) (
	domain.Forecast, error) {

	_, scope, err := s.authorize(ctx, PermServiceRead)
	if err != nil {
		return domain.Forecast{}, err
	}

	census, err := s.censuses.Census(ctx, scope, censusID)
	if err != nil {
		return domain.Forecast{}, err
	}
	menu, err := s.menu.Menu(ctx, scope, census.Cycle)
	if err != nil {
		return domain.Forecast{}, err
	}
	forecast, err := domain.ForecastIngredients(census, menu)
	if err != nil {
		return domain.Forecast{}, dieteticsError(err)
	}
	counts, err := s.menu.Consumption(ctx, scope, censusID)
	if err != nil {
		return domain.Forecast{}, err
	}
	return domain.ApplyConsumption(forecast, counts), nil
}
