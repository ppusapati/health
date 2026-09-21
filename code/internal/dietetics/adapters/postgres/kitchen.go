package postgres

import (
	"context"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ---------------------------------------------- meal census (SRS-DIET-005)

// InsertCensus implements ports.CensusRepository.
//
// The census and its lines go in together. A census whose lines arrived
// separately is a count that was briefly wrong, and the kitchen reads it
// continuously up to the cutoff.
func (r *Repository) InsertCensus(ctx context.Context,
	scope authctx.TenantScope, c domain.MealCensus) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	queries := r.queries(ctx)

	if err := queries.InsertDietCensus(ctx, sqlcgen.InsertDietCensusParams{
		CensusID: id, TenantID: tenantID, FacilityID: c.FacilityID,
		WardID: c.WardID, Cycle: string(c.Cycle),
		ServiceDate: stamp(c.ServiceDate), CutoffAt: stamp(c.CutoffAt),
		State: string(c.State), CensusVersion: int32(c.Version),
		SupersedesID: optionalUUID(c.SupersedesID),
		FrozenAt:     stamp(c.FrozenAt), FrozenBy: c.FrozenBy,
		BuiltAt: stamp(c.BuiltAt), BuiltBy: c.BuiltBy,
	}); err != nil {
		return err
	}

	for _, line := range c.Lines {
		orderID, err := uuid.Parse(line.OrderID)
		if err != nil {
			return notFound()
		}
		if err := queries.InsertDietCensusLine(ctx,
			sqlcgen.InsertDietCensusLineParams{
				LineID: uuid.New(), TenantID: tenantID, CensusID: id,
				PatientID: line.PatientID, EncounterID: line.EncounterID,
				WardID: line.WardID, BedID: line.BedID, OrderID: orderID,
				Route: string(line.Route), TextureCode: line.TextureCode,
				TextureLabel: line.TextureLabel, FluidCode: line.FluidCode,
				Restrictions: texts(line.Restrictions),
				Supplements:  texts(line.Supplements),
				Instruction:  line.Instruction,
			}); err != nil {
			return err
		}
	}
	return nil
}

// Census implements ports.CensusRepository.
func (r *Repository) Census(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.MealCensus, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.MealCensus{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.MealCensus{}, notFound()
	}

	queries := r.queries(ctx)
	row, err := queries.GetDietCensus(ctx, sqlcgen.GetDietCensusParams{
		TenantID: tenantID, CensusID: parsed,
	})
	if isNoRows(err) {
		return domain.MealCensus{}, notFound()
	}
	if err != nil {
		return domain.MealCensus{}, err
	}
	lines, err := queries.ListDietCensusLines(ctx,
		sqlcgen.ListDietCensusLinesParams{
			TenantID: tenantID, CensusID: parsed,
		})
	if err != nil {
		return domain.MealCensus{}, err
	}
	return censusFromRow(row, lines), nil
}

// FreezeCensus implements ports.CensusRepository.
func (r *Repository) FreezeCensus(ctx context.Context,
	scope authctx.TenantScope, c domain.MealCensus) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).FreezeDietCensus(ctx,
		sqlcgen.FreezeDietCensusParams{
			TenantID: tenantID, CensusID: id,
			FrozenAt: stamp(c.FrozenAt), FrozenBy: c.FrozenBy,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// SupersedeCensus implements ports.CensusRepository.
//
// The frozen census stays readable. It is what the kitchen cooked to, and the
// question after a wrong tray is always what the count said at the time.
func (r *Repository) SupersedeCensus(ctx context.Context,
	scope authctx.TenantScope, id string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return notFound()
	}

	_, err = r.queries(ctx).SupersedeDietCensus(ctx,
		sqlcgen.SupersedeDietCensusParams{
			TenantID: tenantID, CensusID: parsed,
		})
	return err
}

// Censuses implements ports.CensusRepository.
func (r *Repository) Censuses(ctx context.Context,
	scope authctx.TenantScope, f ports.CensusFilter) (
	[]domain.MealCensus, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	from, to := window(f.From, f.To)

	queries := r.queries(ctx)
	rows, err := queries.ListDietCensuses(ctx,
		sqlcgen.ListDietCensusesParams{
			TenantID: tenantID, WardID: f.WardID, Cycle: string(f.Cycle),
			FromDate: stamp(from), ToDate: stamp(to),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.MealCensus, 0, len(rows))
	for _, row := range rows {
		lines, err := queries.ListDietCensusLines(ctx,
			sqlcgen.ListDietCensusLinesParams{
				TenantID: tenantID, CensusID: row.CensusID,
			})
		if err != nil {
			return nil, err
		}
		out = append(out, censusFromRow(row, lines))
	}
	return out, nil
}

func censusFromRow(row sqlcgen.HospitalOpsDietMealCensus,
	lines []sqlcgen.HospitalOpsDietCensusLine) domain.MealCensus {

	out := domain.MealCensus{
		ID: row.CensusID.String(), TenantID: row.TenantID.String(),
		FacilityID: row.FacilityID, WardID: row.WardID,
		Cycle:        domain.MealCycle(row.Cycle),
		ServiceDate:  timeOf(row.ServiceDate),
		CutoffAt:     timeOf(row.CutoffAt),
		State:        domain.CensusState(row.State),
		Version:      int(row.CensusVersion),
		SupersedesID: uuidString(row.SupersedesID),
		FrozenAt:     timeOf(row.FrozenAt), FrozenBy: row.FrozenBy,
		BuiltAt: timeOf(row.BuiltAt), BuiltBy: row.BuiltBy,
	}
	for _, line := range lines {
		out.Lines = append(out.Lines, domain.CensusLine{
			PatientID: line.PatientID, EncounterID: line.EncounterID,
			WardID: line.WardID, BedID: line.BedID,
			OrderID:      line.OrderID.String(),
			Route:        domain.Route(line.Route),
			TextureCode:  line.TextureCode,
			TextureLabel: line.TextureLabel, FluidCode: line.FluidCode,
			Restrictions: line.Restrictions, Supplements: line.Supplements,
			Instruction: line.Instruction,
		})
	}
	return out
}

// ---------------------------------------------------- trays (SRS-DIET-006)

// InsertTray implements ports.TrayRepository.
func (r *Repository) InsertTray(ctx context.Context,
	scope authctx.TenantScope, t domain.Tray) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	censusID, err := uuid.Parse(t.CensusID)
	if err != nil {
		return notFound()
	}
	orderID, err := uuid.Parse(t.OrderID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertDietTray(ctx, sqlcgen.InsertDietTrayParams{
		TrayID: id, TenantID: tenantID, CensusID: censusID,
		PatientID: t.PatientID, WardID: t.WardID, BedID: t.BedID,
		Cycle: string(t.Cycle), OrderID: orderID, State: string(t.State),
		DueBy: stamp(t.DueBy),
	})
}

// Tray implements ports.TrayRepository.
func (r *Repository) Tray(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Tray, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Tray{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Tray{}, notFound()
	}

	row, err := r.queries(ctx).GetDietTray(ctx, sqlcgen.GetDietTrayParams{
		TenantID: tenantID, TrayID: parsed,
	})
	if isNoRows(err) {
		return domain.Tray{}, notFound()
	}
	if err != nil {
		return domain.Tray{}, err
	}
	return trayFromRow(row), nil
}

// UpdateTray implements ports.TrayRepository.
func (r *Repository) UpdateTray(ctx context.Context,
	scope authctx.TenantScope, t domain.Tray, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateDietTray(ctx,
		sqlcgen.UpdateDietTrayParams{
			TenantID: tenantID, TrayID: id, State: string(t.State),
			Reason:     t.Reason,
			PreparedAt: stamp(t.PreparedAt), PreparedBy: t.PreparedBy,
			DispatchedAt:    stamp(t.DispatchedAt),
			DispatchedBy:    t.DispatchedBy,
			DeliveredAt:     stamp(t.DeliveredAt),
			DeliveredBy:     t.DeliveredBy,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Trays implements ports.TrayRepository.
func (r *Repository) Trays(ctx context.Context, scope authctx.TenantScope,
	f ports.TrayFilter) ([]domain.Tray, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	censusID := uuid.Nil
	if f.CensusID != "" {
		parsed, err := uuid.Parse(f.CensusID)
		if err != nil {
			return nil, notFound()
		}
		censusID = parsed
	}

	rows, err := r.queries(ctx).ListDietTrays(ctx,
		sqlcgen.ListDietTraysParams{
			TenantID: tenantID, CensusID: censusID, WardID: f.WardID,
			State: f.State, PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Tray, 0, len(rows))
	for _, row := range rows {
		out = append(out, trayFromRow(row))
	}
	return out, nil
}

func trayFromRow(row sqlcgen.HospitalOpsDietMealTray) domain.Tray {
	return domain.Tray{
		ID: row.TrayID.String(), TenantID: row.TenantID.String(),
		CensusID: row.CensusID.String(), PatientID: row.PatientID,
		WardID: row.WardID, BedID: row.BedID,
		Cycle: domain.MealCycle(row.Cycle), OrderID: row.OrderID.String(),
		State: domain.TrayState(row.State), Reason: row.Reason,
		PreparedAt: timeOf(row.PreparedAt), PreparedBy: row.PreparedBy,
		DispatchedAt: timeOf(row.DispatchedAt),
		DispatchedBy: row.DispatchedBy,
		DeliveredAt:  timeOf(row.DeliveredAt),
		DeliveredBy:  row.DeliveredBy,
		DueBy:        timeOf(row.DueBy), Version: row.Version,
	}
}

// ------------------------------- recipes, menu and counts (SRS-DIET-008)

// InsertItem implements ports.MenuRepository.
func (r *Repository) InsertItem(ctx context.Context,
	scope authctx.TenantScope, item domain.DietItem, kind string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return r.queries(ctx).InsertDietItem(ctx, sqlcgen.InsertDietItemParams{
		ItemID: uuid.New(), TenantID: tenantID, Code: item.Code,
		Name: item.Name, Kind: kind,
		AllergenCodes: texts(item.AllergenCodes),
	})
}

// InsertRecipe implements ports.MenuRepository.
func (r *Repository) InsertRecipe(ctx context.Context,
	scope authctx.TenantScope, recipe domain.Recipe) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	queries := r.queries(ctx)
	recipeID := uuid.New()

	if err := queries.InsertDietRecipe(ctx, sqlcgen.InsertDietRecipeParams{
		RecipeID: recipeID, TenantID: tenantID,
		Code: recipe.Code, Name: recipe.Name,
	}); err != nil {
		return err
	}
	for _, ingredient := range recipe.Ingredients {
		if err := queries.InsertDietRecipeIngredient(ctx,
			sqlcgen.InsertDietRecipeIngredientParams{
				IngredientID: uuid.New(), TenantID: tenantID,
				RecipeID: recipeID, Code: ingredient.Code,
				Name: ingredient.Name, Grams: int32(ingredient.Grams),
			}); err != nil {
			return err
		}
	}
	return nil
}

// InsertMenuItem implements ports.MenuRepository.
func (r *Repository) InsertMenuItem(ctx context.Context,
	scope authctx.TenantScope, item domain.MenuItem) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	queries := r.queries(ctx)

	recipes, err := queries.ListDietMenu(ctx, sqlcgen.ListDietMenuParams{
		TenantID: tenantID, Cycle: "",
	})
	if err != nil {
		return err
	}
	recipeID := uuid.Nil
	for _, row := range recipes {
		if row.RecipeCode == item.Recipe.Code {
			recipeID = row.RecipeID
			break
		}
	}
	if recipeID == uuid.Nil {
		// The recipe has to exist before the menu can put it on a tray. A
		// menu item pointing at nothing is a forecast that silently omits a
		// dish the kitchen will still cook.
		found, err := r.recipeIDByCode(ctx, tenantID, item.Recipe.Code)
		if err != nil {
			return err
		}
		recipeID = found
	}

	return queries.InsertDietMenuItem(ctx, sqlcgen.InsertDietMenuItemParams{
		MenuItemID: uuid.New(), TenantID: tenantID, RecipeID: recipeID,
		Cycle: string(item.Cycle), TextureCode: item.TextureCode,
		Portions: int32(item.Portions),
	})
}

func (r *Repository) recipeIDByCode(ctx context.Context, tenantID uuid.UUID,
	code string) (uuid.UUID, error) {

	row := r.tx.Querier(ctx).QueryRow(ctx,
		`SELECT recipe_id FROM hospital_ops_diet.recipe
		 WHERE tenant_id = $1 AND lower(code) = lower($2)`, tenantID, code)
	var id uuid.UUID
	if err := row.Scan(&id); err != nil {
		return uuid.Nil, notFound()
	}
	return id, nil
}

// Menu implements ports.MenuRepository.
func (r *Repository) Menu(ctx context.Context, scope authctx.TenantScope,
	cycle domain.MealCycle) ([]domain.MenuItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	queries := r.queries(ctx)

	rows, err := queries.ListDietMenu(ctx, sqlcgen.ListDietMenuParams{
		TenantID: tenantID, Cycle: string(cycle),
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.MenuItem, 0, len(rows))
	for _, row := range rows {
		ingredients, err := queries.ListDietRecipeIngredients(ctx,
			sqlcgen.ListDietRecipeIngredientsParams{
				TenantID: tenantID, RecipeID: row.RecipeID,
			})
		if err != nil {
			return nil, err
		}
		recipe := domain.Recipe{Code: row.RecipeCode, Name: row.RecipeName}
		for _, ingredient := range ingredients {
			recipe.Ingredients = append(recipe.Ingredients,
				domain.IngredientQuantity{
					Code: ingredient.Code, Name: ingredient.Name,
					Grams: int(ingredient.Grams),
				})
		}
		out = append(out, domain.MenuItem{
			Cycle:       domain.MealCycle(row.Cycle),
			TextureCode: row.TextureCode, Recipe: recipe,
			Portions: int(row.Portions),
		})
	}
	return out, nil
}

// ItemsForOrder implements ports.MenuRepository (SRS-DIET-003).
func (r *Repository) ItemsForOrder(ctx context.Context,
	scope authctx.TenantScope, textureCode string, supplements []string) (
	[]domain.DietItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListDietItemsForOrder(ctx,
		sqlcgen.ListDietItemsForOrderParams{
			TenantID: tenantID, Supplements: texts(supplements),
			TextureCode: textureCode,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.DietItem, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.DietItem{
			Code: row.Code, Name: row.Name,
			AllergenCodes: row.AllergenCodes,
		})
	}
	return out, nil
}

// AppendConsumption implements ports.MenuRepository.
func (r *Repository) AppendConsumption(ctx context.Context,
	scope authctx.TenantScope, c domain.Consumption) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	censusID, err := uuid.Parse(c.CensusID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertDietConsumption(ctx,
		sqlcgen.InsertDietConsumptionParams{
			ConsumptionID: id, TenantID: tenantID, CensusID: censusID,
			IngredientCode: c.IngredientCode, ActualG: int32(c.ActualG),
			Note: c.Note, RecordedAt: stamp(c.RecordedAt),
			RecordedBy: c.RecordedBy,
		})
}

// Consumption implements ports.MenuRepository.
func (r *Repository) Consumption(ctx context.Context,
	scope authctx.TenantScope, censusID string) (
	[]domain.Consumption, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(censusID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListDietConsumption(ctx,
		sqlcgen.ListDietConsumptionParams{
			TenantID: tenantID, CensusID: parsed,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Consumption, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Consumption{
			ID: row.ConsumptionID.String(), TenantID: row.TenantID.String(),
			CensusID:       row.CensusID.String(),
			IngredientCode: row.IngredientCode,
			ActualG:        int(row.ActualG), Note: row.Note,
			RecordedAt: timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

var _ ports.CensusRepository = (*Repository)(nil)
var _ ports.TrayRepository = (*Repository)(nil)
var _ ports.MenuRepository = (*Repository)(nil)
