package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// InsertOrder implements ports.OrderRepository (SRS-DIET-002, SRS-DIET-003).
//
// The order and its conflicts go in together. An order whose conflicts landed
// after it did would be, for however long that took, an active order the
// kitchen could see with an unresolved peanut allergy against it.
func (r *Repository) InsertOrder(ctx context.Context,
	scope authctx.TenantScope, o domain.DietOrder) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}
	queries := r.queries(ctx)

	if err := queries.InsertDietOrder(ctx, sqlcgen.InsertDietOrderParams{
		OrderID: id, TenantID: tenantID,
		PatientID: o.PatientID, EncounterID: o.EncounterID,
		FacilityID: o.FacilityID, WardID: o.WardID, BedID: o.BedID,
		Route:         string(o.Route),
		TextureCode:   o.Texture.Code,
		TextureLabel:  o.Texture.Label,
		FluidCode:     o.Texture.FluidCode,
		Restrictions:  texts(o.Restrictions),
		Supplements:   texts(o.Supplements),
		Instruction:   o.Instruction,
		EffectiveFrom: stamp(o.EffectiveFrom),
		EffectiveTo:   stamp(o.EffectiveTo),
		State:         string(o.State),
		PlacedAt:      stamp(o.PlacedAt), PlacedBy: o.PlacedBy,
	}); err != nil {
		return err
	}

	for _, conflict := range o.Conflicts {
		if err := queries.InsertDietConflict(ctx,
			sqlcgen.InsertDietConflictParams{
				ConflictID: uuid.New(), TenantID: tenantID, OrderID: id,
				AllergyRef: conflict.AllergyRef,
				Substance:  conflict.Substance, Item: conflict.Item,
				Severity: conflict.Severity,
			}); err != nil {
			return err
		}
	}
	return nil
}

// Order implements ports.OrderRepository.
func (r *Repository) Order(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.DietOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.DietOrder{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.DietOrder{}, notFound()
	}

	queries := r.queries(ctx)
	row, err := queries.GetDietOrder(ctx, sqlcgen.GetDietOrderParams{
		TenantID: tenantID, OrderID: parsed,
	})
	if isNoRows(err) {
		return domain.DietOrder{}, notFound()
	}
	if err != nil {
		return domain.DietOrder{}, err
	}

	conflicts, err := queries.ListDietConflicts(ctx,
		sqlcgen.ListDietConflictsParams{TenantID: tenantID, OrderID: parsed})
	if err != nil {
		return domain.DietOrder{}, err
	}
	return orderFromRow(row, conflicts), nil
}

// UpdateOrder implements ports.OrderRepository.
func (r *Repository) UpdateOrder(ctx context.Context,
	scope authctx.TenantScope, o domain.DietOrder,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateDietOrder(ctx,
		sqlcgen.UpdateDietOrderParams{
			TenantID: tenantID, OrderID: id, State: string(o.State),
			EffectiveTo:     stamp(o.EffectiveTo),
			CancelledReason: o.CancelledReason,
			CancelledBy:     o.CancelledBy,
			CancelledAt:     stamp(o.CancelledAt),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// SupersedeOtherOrders implements ports.OrderRepository (SRS-DIET-002).
//
// So the kitchen's read returns one order for one patient. Two live orders is
// a kitchen that plates whichever is on top.
func (r *Repository) SupersedeOtherOrders(ctx context.Context,
	scope authctx.TenantScope, patientID, keepOrderID string,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	keep, err := uuid.Parse(keepOrderID)
	if err != nil {
		return notFound()
	}

	_, err = r.queries(ctx).SupersedeDietOrders(ctx,
		sqlcgen.SupersedeDietOrdersParams{
			TenantID: tenantID, PatientID: patientID,
			KeepOrderID: keep, At: stamp(at),
		})
	return err
}

// ResolveConflict implements ports.OrderRepository (SRS-DIET-003).
//
// The conflict rows and the order's state move together: an order that reads
// as active with an unresolved conflict still on it is the exact row the
// kitchen must never see.
func (r *Repository) ResolveConflict(ctx context.Context,
	scope authctx.TenantScope, o domain.DietOrder,
	allergyRef, item string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}

	var resolved domain.Conflict
	for _, candidate := range o.Conflicts {
		if candidate.AllergyRef == allergyRef && candidate.Resolved() {
			resolved = candidate
			break
		}
	}

	queries := r.queries(ctx)
	rows, err := queries.ResolveDietConflict(ctx,
		sqlcgen.ResolveDietConflictParams{
			TenantID: tenantID, OrderID: id, AllergyRef: allergyRef,
			Item:           item,
			ResolvedBy:     resolved.ResolvedBy,
			ResolvedAt:     stamp(resolved.ResolvedAt),
			ResolutionNote: resolved.ResolutionNote,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}

	updated, err := queries.UpdateDietOrder(ctx,
		sqlcgen.UpdateDietOrderParams{
			TenantID: tenantID, OrderID: id, State: string(o.State),
			EffectiveTo:     stamp(o.EffectiveTo),
			CancelledReason: o.CancelledReason,
			CancelledBy:     o.CancelledBy,
			CancelledAt:     stamp(o.CancelledAt),
			ExpectedVersion: o.Version,
		})
	if err != nil {
		return err
	}
	return conflict(updated)
}

// OrdersForPatient implements ports.OrderRepository.
func (r *Repository) OrdersForPatient(ctx context.Context,
	scope authctx.TenantScope, patientID string, limit int32) (
	[]domain.DietOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	bound, _ := page(limit, 0)

	queries := r.queries(ctx)
	rows, err := queries.ListDietOrdersForPatient(ctx,
		sqlcgen.ListDietOrdersForPatientParams{
			TenantID: tenantID, PatientID: patientID, PageLimit: bound,
		})
	if err != nil {
		return nil, err
	}
	return r.withConflicts(ctx, tenantID, rows)
}

// OrdersForWard implements ports.OrderRepository (SRS-DIET-005).
func (r *Repository) OrdersForWard(ctx context.Context,
	scope authctx.TenantScope, wardID string, limit int32) (
	[]domain.DietOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	bound, _ := page(limit, 0)

	queries := r.queries(ctx)
	rows, err := queries.ListDietOrdersForWard(ctx,
		sqlcgen.ListDietOrdersForWardParams{
			TenantID: tenantID, WardID: wardID, PageLimit: bound,
		})
	if err != nil {
		return nil, err
	}
	return r.withConflicts(ctx, tenantID, rows)
}

// withConflicts loads each order's conflicts.
//
// Loaded rather than left off, because an order's pending state is only
// explicable with them: a caller shown a pending order and no conflict has no
// way to find out what is holding it up.
func (r *Repository) withConflicts(ctx context.Context, tenantID uuid.UUID,
	rows []sqlcgen.HospitalOpsDietDietOrder) ([]domain.DietOrder, error) {

	queries := r.queries(ctx)
	out := make([]domain.DietOrder, 0, len(rows))
	for _, row := range rows {
		conflicts, err := queries.ListDietConflicts(ctx,
			sqlcgen.ListDietConflictsParams{
				TenantID: tenantID, OrderID: row.OrderID,
			})
		if err != nil {
			return nil, err
		}
		out = append(out, orderFromRow(row, conflicts))
	}
	return out, nil
}

func orderFromRow(row sqlcgen.HospitalOpsDietDietOrder,
	conflicts []sqlcgen.HospitalOpsDietOrderConflict) domain.DietOrder {

	out := domain.DietOrder{
		ID: row.OrderID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		FacilityID: row.FacilityID, WardID: row.WardID, BedID: row.BedID,
		Route: domain.Route(row.Route),
		Texture: domain.Texture{
			Code: row.TextureCode, Label: row.TextureLabel,
			FluidCode: row.FluidCode,
		},
		Restrictions: row.Restrictions, Supplements: row.Supplements,
		Instruction:     row.Instruction,
		EffectiveFrom:   timeOf(row.EffectiveFrom),
		EffectiveTo:     timeOf(row.EffectiveTo),
		State:           domain.OrderState(row.State),
		CancelledReason: row.CancelledReason,
		CancelledBy:     row.CancelledBy,
		CancelledAt:     timeOf(row.CancelledAt),
		PlacedAt:        timeOf(row.PlacedAt), PlacedBy: row.PlacedBy,
		Version: row.Version,
	}
	for _, conflict := range conflicts {
		out.Conflicts = append(out.Conflicts, domain.Conflict{
			AllergyRef: conflict.AllergyRef, Substance: conflict.Substance,
			Item: conflict.Item, Severity: conflict.Severity,
			ResolvedBy:     conflict.ResolvedBy,
			ResolvedAt:     timeOf(conflict.ResolvedAt),
			ResolutionNote: conflict.ResolutionNote,
		})
	}
	return out
}

var _ ports.OrderRepository = (*Repository)(nil)
var _ ports.AssessmentRepository = (*Repository)(nil)
