// Package postgres is the biomedical persistence adapter.
//
// It is the only package permitted to issue SQL against the biomedical schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
//
// The telemetry half has no update and no delete, and no statement in it
// touches a maintenance table. That is what makes SRS-BIO-010's "telemetry
// does not overwrite maintenance records" a property of the surface rather
// than a convention somebody could break with one UPDATE.
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the biomedical repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.UUID{}, rpcerr.Internal("BIO_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("BIO_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("BIO_NOT_FOUND", "no such equipment record")
}

func stamp(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func timeOf(t pgtype.Timestamptz) time.Time {
	if !t.Valid {
		return time.Time{}
	}
	return t.Time.UTC()
}

func stampDate(t time.Time) pgtype.Date {
	if t.IsZero() {
		return pgtype.Date{}
	}
	return pgtype.Date{Time: t.UTC(), Valid: true}
}

func dateOf(d pgtype.Date) time.Time {
	if !d.Valid {
		return time.Time{}
	}
	return d.Time.UTC()
}

func optionalUUID(id string) pgtype.UUID {
	if id == "" {
		return pgtype.UUID{}
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return pgtype.UUID{}
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}
}

func uuidString(id pgtype.UUID) string {
	if !id.Valid {
		return ""
	}
	return uuid.UUID(id.Bytes).String()
}

func encode(value any) ([]byte, error) {
	raw, err := json.Marshal(value)
	if err != nil {
		return nil, rpcerr.Internal("BIO_ENCODE_FAILED",
			"could not encode an equipment record").WithCause(err)
	}
	return raw, nil
}

func decode[T any](raw []byte, out *T) error {
	if len(raw) == 0 {
		return nil
	}
	if err := json.Unmarshal(raw, out); err != nil {
		return rpcerr.Internal("BIO_DECODE_FAILED",
			"could not decode an equipment record").WithCause(err)
	}
	return nil
}

// AssetRepo implements ports.AssetRepository.
type AssetRepo struct{ *Repository }

var _ ports.AssetRepository = AssetRepo{}

// InsertAsset registers a piece of equipment.
func (r AssetRepo) InsertAsset(ctx context.Context, scope authctx.TenantScope,
	a domain.Asset) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assetID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAsset(ctx, sqlcgen.InsertAssetParams{
		AssetID: assetID, TenantID: tenantID,
		Tag: a.Tag, Udi: a.UDI, Serial: a.Serial,
		Make: a.Make, Model: a.Model, Category: a.Category,
		Criticality: string(a.Criticality), Status: string(a.Status),
		LocationID: a.LocationID, Department: a.Department,
		Capabilities:           a.Capabilities,
		AcquiredOn:             stampDate(a.AcquiredOn),
		AcquisitionCostMinor:   a.AcquisitionCostMinor,
		ExpectedLifeYears:      int32(a.ExpectedLifeYears),
		CalibrationRequired:    a.CalibrationRequired,
		CalibrationDue:         stamp(a.CalibrationDue),
		CalibrationCertificate: a.CalibrationCertificate,
		Notes:                  a.Notes,
		CreatedAt:              stamp(a.CreatedAt), CreatedBy: a.CreatedBy,
	})
}

// Asset reads one piece of equipment.
func (r AssetRepo) Asset(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Asset, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Asset{}, err
	}
	assetID, err := uuid.Parse(id)
	if err != nil {
		return domain.Asset{}, notFound()
	}

	row, err := r.queries(ctx).GetAsset(ctx, sqlcgen.GetAssetParams{
		TenantID: tenantID, AssetID: assetID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Asset{}, notFound()
	}
	if err != nil {
		return domain.Asset{}, err
	}
	return assetFrom(row), nil
}

// AssetByTag resolves the number on the sticker.
func (r AssetRepo) AssetByTag(ctx context.Context, scope authctx.TenantScope,
	tag string) (domain.Asset, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Asset{}, false, err
	}

	row, err := r.queries(ctx).GetAssetByTag(ctx, sqlcgen.GetAssetByTagParams{
		TenantID: tenantID, Tag: tag,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Asset{}, false, nil
	}
	if err != nil {
		return domain.Asset{}, false, err
	}
	return assetFrom(row), true, nil
}

// UpdateAsset writes a status, location or calibration change.
func (r AssetRepo) UpdateAsset(ctx context.Context, scope authctx.TenantScope,
	a domain.Asset, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assetID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateAsset(ctx, sqlcgen.UpdateAssetParams{
		TenantID: tenantID, AssetID: assetID,
		Status: string(a.Status), LocationID: a.LocationID,
		Department: a.Department, Capabilities: a.Capabilities,
		Criticality:            string(a.Criticality),
		CalibrationRequired:    a.CalibrationRequired,
		CalibrationDue:         stamp(a.CalibrationDue),
		CalibrationCertificate: a.CalibrationCertificate,
		SafetyHold:             a.SafetyHold,
		SafetyHoldReason:       a.SafetyHoldReason,
		Notes:                  a.Notes,
		ExpectedVersion:        expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Assets lists the register.
func (r AssetRepo) Assets(ctx context.Context, scope authctx.TenantScope,
	category, status string, excludeRetired bool, limit int32) (
	[]domain.Asset, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListAssets(ctx, sqlcgen.ListAssetsParams{
		TenantID: tenantID, Category: category, Status: status,
		ExcludeRetired: excludeRetired, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return assetsFrom(rows), nil
}

// AtLocation is what a room's capability read runs over.
func (r AssetRepo) AtLocation(ctx context.Context, scope authctx.TenantScope,
	locationID string, limit int32) ([]domain.Asset, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListAssetsAtLocation(ctx,
		sqlcgen.ListAssetsAtLocationParams{
			TenantID: tenantID, LocationID: locationID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return assetsFrom(rows), nil
}

// ByMake narrows a safety notice's candidates before the domain matches them.
func (r AssetRepo) ByMake(ctx context.Context, scope authctx.TenantScope,
	make, udi string, limit int32) ([]domain.Asset, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListAssetsByMake(ctx,
		sqlcgen.ListAssetsByMakeParams{
			TenantID: tenantID, Make: make, Udi: udi, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return assetsFrom(rows), nil
}

func assetsFrom(rows []sqlcgen.BiomedicalAsset) []domain.Asset {
	out := make([]domain.Asset, 0, len(rows))
	for _, row := range rows {
		out = append(out, assetFrom(row))
	}
	return out
}

func assetFrom(row sqlcgen.BiomedicalAsset) domain.Asset {
	return domain.Asset{
		ID: row.AssetID.String(), TenantID: row.TenantID.String(),
		Tag: row.Tag, UDI: row.Udi, Serial: row.Serial,
		Make: row.Make, Model: row.Model, Category: row.Category,
		Criticality: domain.Criticality(row.Criticality),
		Status:      domain.AssetStatus(row.Status),
		LocationID:  row.LocationID, Department: row.Department,
		Capabilities:           row.Capabilities,
		AcquiredOn:             dateOf(row.AcquiredOn),
		AcquisitionCostMinor:   row.AcquisitionCostMinor,
		ExpectedLifeYears:      int(row.ExpectedLifeYears),
		CalibrationRequired:    row.CalibrationRequired,
		CalibrationDue:         timeOf(row.CalibrationDue),
		CalibrationCertificate: row.CalibrationCertificate,
		SafetyHold:             row.SafetyHold,
		SafetyHoldReason:       row.SafetyHoldReason,
		Notes:                  row.Notes,
		CreatedAt:              timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}
