package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Master-data persistence (SRS-PLT-005, 008, 011, 014, 016, 017).

// optionalUUID converts an optional identifier.
//
// An unparseable value yields SQL NULL rather than an error, which is correct
// for the one caller shape that produces it: a domain object whose optional
// facility or parent is empty. A malformed non-empty value would be caught by
// the foreign key, and treating it as NULL here would silently widen the row's
// scope — so it is rejected instead.
func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
		return pgtype.UUID{}, rpcerr.Internal("ORG_ID_INVALID", "identifier must be a UUID").WithCause(err)
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func uuidString(v pgtype.UUID) string {
	if !v.Valid {
		return ""
	}
	return uuid.UUID(v.Bytes).String()
}

func optionalTimestamptz(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func dateOf(t time.Time) pgtype.Date {
	return pgtype.Date{Time: time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, time.UTC), Valid: true}
}

// InsertOrgUnit persists an organisational unit.
func (r *Repository) InsertOrgUnit(ctx context.Context, scope authctx.TenantScope, u domain.OrgUnit) error {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	unitID, err := uuid.Parse(u.ID)
	if err != nil {
		return rpcerr.Internal("ORG_UNIT_ID_INVALID", "unit_id must be a UUID").WithCause(err)
	}
	facility, err := optionalUUID(u.FacilityID)
	if err != nil {
		return err
	}
	parent, err := optionalUUID(u.ParentUnitID)
	if err != nil {
		return err
	}

	err = r.queries(ctx).InsertOrgUnit(ctx, sqlcgen.InsertOrgUnitParams{
		UnitID: unitID, TenantID: tenant, FacilityID: facility,
		UnitType: string(u.Type), Code: u.Code, DisplayName: u.DisplayName,
		ParentUnitID:                parent,
		EffectiveFrom:               timestamptz(u.EffectiveFrom),
		EffectiveUntil:              optionalTimestamptz(u.EffectiveUntil),
		AcceptsActivityWhenInactive: u.AcceptsActivityWhenInactive,
		CreatedAt:                   timestamptz(u.CreatedAt),
		UpdatedAt:                   timestamptz(u.UpdatedAt),
	})
	if isUniqueViolation(err) {
		return rpcerr.AlreadyExists("ORG_UNIT_EXISTS", "a unit with that code already exists")
	}
	return err
}

// GetOrgUnit reads a unit within the caller's tenant.
func (r *Repository) GetOrgUnit(ctx context.Context, scope authctx.TenantScope, unitID string) (domain.OrgUnit, error) {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return domain.OrgUnit{}, err
	}
	id, err := uuid.Parse(unitID)
	if err != nil {
		// NOT_FOUND rather than INVALID_ARGUMENT: the two answers together
		// would let a caller distinguish "no such unit" from "not yours".
		return domain.OrgUnit{}, rpcerr.NotFound("ORG_UNIT_NOT_FOUND", "organizational unit not found")
	}

	row, err := r.queries(ctx).GetOrgUnit(ctx, sqlcgen.GetOrgUnitParams{TenantID: tenant, UnitID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.OrgUnit{}, rpcerr.NotFound("ORG_UNIT_NOT_FOUND", "organizational unit not found")
	}
	if err != nil {
		return domain.OrgUnit{}, err
	}
	return orgUnitFromRow(row), nil
}

// ListOrgUnits pages through units of a type using keyset pagination.
func (r *Repository) ListOrgUnits(ctx context.Context, scope authctx.TenantScope,
	unitType domain.UnitType, afterCode string, pageSize int32) ([]domain.OrgUnit, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListOrgUnits(ctx, sqlcgen.ListOrgUnitsParams{
		TenantID: tenant, UnitType: string(unitType), AfterCode: afterCode, PageSize: pageSize,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.OrgUnit, 0, len(rows))
	for _, row := range rows {
		out = append(out, orgUnitFromRow(row))
	}
	return out, nil
}

func orgUnitFromRow(row sqlcgen.OrganizationOrgUnit) domain.OrgUnit {
	u := domain.OrgUnit{
		ID:                          row.UnitID.String(),
		TenantID:                    row.TenantID.String(),
		FacilityID:                  uuidString(row.FacilityID),
		Type:                        domain.UnitType(row.UnitType),
		Code:                        row.Code,
		DisplayName:                 row.DisplayName,
		ParentUnitID:                uuidString(row.ParentUnitID),
		EffectiveFrom:               row.EffectiveFrom.Time,
		AcceptsActivityWhenInactive: row.AcceptsActivityWhenInactive,
		CreatedAt:                   row.CreatedAt.Time,
		UpdatedAt:                   row.UpdatedAt.Time,
		Version:                     row.Version,
	}
	if row.EffectiveUntil.Valid {
		u.EffectiveUntil = row.EffectiveUntil.Time
	}
	return u
}

// InsertChange records a proposed master-data change.
func (r *Repository) InsertChange(ctx context.Context, scope authctx.TenantScope, c domain.MasterDataChange) error {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	changeID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Internal("ORG_CHANGE_ID_INVALID", "change_id must be a UUID").WithCause(err)
	}
	entityID, err := uuid.Parse(c.EntityID)
	if err != nil {
		return rpcerr.Internal("ORG_ENTITY_ID_INVALID", "entity_id must be a UUID").WithCause(err)
	}

	err = r.queries(ctx).InsertMasterDataChange(ctx, sqlcgen.InsertMasterDataChangeParams{
		ChangeID: changeID, TenantID: tenant,
		EntityType: c.EntityType, EntityID: entityID,
		Proposed: c.Proposed, BaseVersion: c.BaseVersion,
		Status: string(c.Status), EffectiveFrom: timestamptz(c.EffectiveFrom),
		Justification: c.Justification, ProposedBy: c.ProposedBy,
		ProposedAt: timestamptz(c.ProposedAt),
		CreatedAt:  timestamptz(c.CreatedAt), UpdatedAt: timestamptz(c.UpdatedAt),
	})
	if isUniqueViolation(err) {
		// The partial unique index caught a second pending change against the
		// same entity. A queue of them would apply in an order nobody chose,
		// each computed against a base the next invalidates.
		return rpcerr.FailedPrecondition("ORG_CHANGE_ALREADY_PENDING",
			"a change is already awaiting approval for this entity")
	}
	return err
}

// GetChange reads a proposed change.
func (r *Repository) GetChange(ctx context.Context, scope authctx.TenantScope, changeID string) (domain.MasterDataChange, error) {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return domain.MasterDataChange{}, err
	}
	id, err := uuid.Parse(changeID)
	if err != nil {
		return domain.MasterDataChange{}, rpcerr.NotFound("ORG_CHANGE_NOT_FOUND", "change not found")
	}

	row, err := r.queries(ctx).GetMasterDataChange(ctx, sqlcgen.GetMasterDataChangeParams{
		TenantID: tenant, ChangeID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.MasterDataChange{}, rpcerr.NotFound("ORG_CHANGE_NOT_FOUND", "change not found")
	}
	if err != nil {
		return domain.MasterDataChange{}, err
	}

	c := domain.MasterDataChange{
		ID: row.ChangeID.String(), TenantID: row.TenantID.String(),
		EntityType: row.EntityType, EntityID: row.EntityID.String(),
		Proposed: row.Proposed, BaseVersion: row.BaseVersion,
		Status: domain.ChangeStatus(row.Status), EffectiveFrom: row.EffectiveFrom.Time,
		Justification: row.Justification, ProposedBy: row.ProposedBy,
		ProposedAt: row.ProposedAt.Time, DecidedBy: row.DecidedBy,
		DecisionNote: row.DecisionNote,
		CreatedAt:    row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time, Version: row.Version,
	}
	if row.DecidedAt.Valid {
		c.DecidedAt = row.DecidedAt.Time
	}
	return c, nil
}

// DecideChange records an approval or rejection.
//
// The statement refuses a decision by the proposer and a decision on a change
// that is not pending, so zero rows means one of those rather than a missing
// row — and the four-eyes rule holds even against a caller that bypassed the
// domain.
func (r *Repository) DecideChange(ctx context.Context, scope authctx.TenantScope, c domain.MasterDataChange) error {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.NotFound("ORG_CHANGE_NOT_FOUND", "change not found")
	}

	rows, err := r.queries(ctx).DecideMasterDataChange(ctx, sqlcgen.DecideMasterDataChangeParams{
		Status: string(c.Status), DecidedBy: c.DecidedBy,
		DecidedAt: timestamptz(c.DecidedAt), DecisionNote: c.DecisionNote,
		TenantID: tenant, ChangeID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("ORG_CHANGE_NOT_DECIDABLE",
			"the change is not awaiting approval, or would be decided by its own proposer")
	}
	return nil
}

// InsertEntitlement grants or withholds a module.
func (r *Repository) InsertEntitlement(ctx context.Context, scope authctx.TenantScope, e domain.Entitlement) error {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(e.ID)
	if err != nil {
		return rpcerr.Internal("ORG_ENTITLEMENT_ID_INVALID", "entitlement_id must be a UUID").WithCause(err)
	}
	facility, err := optionalUUID(e.FacilityID)
	if err != nil {
		return err
	}

	err = r.queries(ctx).InsertEntitlement(ctx, sqlcgen.InsertEntitlementParams{
		EntitlementID: id, TenantID: tenant, FacilityID: facility,
		Module: e.Module, Enabled: e.Enabled,
		EffectiveFrom: timestamptz(e.EffectiveFrom), EffectiveUntil: optionalTimestamptz(e.EffectiveUntil),
		GrantedBy: e.GrantedBy,
		CreatedAt: timestamptz(e.CreatedAt), UpdatedAt: timestamptz(e.UpdatedAt),
	})
	if isUniqueViolation(err) {
		return rpcerr.AlreadyExists("ORG_ENTITLEMENT_EXISTS",
			"an entitlement for that module and scope already starts at that instant")
	}
	return err
}

// EntitlementsForModule returns every row that could decide a module, in both
// scopes, so the domain can apply specificity.
func (r *Repository) EntitlementsForModule(ctx context.Context, scope authctx.TenantScope,
	module, facilityID string) ([]domain.Entitlement, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	facility, err := optionalUUID(facilityID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListEntitlementsForModule(ctx, sqlcgen.ListEntitlementsForModuleParams{
		TenantID: tenant, Module: module, FacilityID: facility,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Entitlement, 0, len(rows))
	for _, row := range rows {
		e := domain.Entitlement{
			ID: row.EntitlementID.String(), TenantID: row.TenantID.String(),
			FacilityID: uuidString(row.FacilityID), Module: row.Module, Enabled: row.Enabled,
			EffectiveFrom: row.EffectiveFrom.Time, GrantedBy: row.GrantedBy,
			CreatedAt: row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time, Version: row.Version,
		}
		if row.EffectiveUntil.Valid {
			e.EffectiveUntil = row.EffectiveUntil.Time
		}
		out = append(out, e)
	}
	return out, nil
}
