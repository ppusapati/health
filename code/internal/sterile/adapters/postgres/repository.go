// Package postgres is the sterile services persistence adapter.
//
// It is the only package permitted to issue SQL against the sterile schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
)

// Repository implements the sterile services repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("CSSD_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("CSSD_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("CSSD_NOT_FOUND", "no such sterile services record")
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

func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
		return pgtype.UUID{}, notFound()
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func uuidOrEmpty(value pgtype.UUID) string {
	if !value.Valid {
		return ""
	}
	return uuid.UUID(value.Bytes).String()
}

// strings0 turns a nil slice into an empty one.
//
// The array columns here are NOT NULL, and an empty list in Go is a nil slice.
// Empty and absent are the same thing for both of them — a pack missing
// nothing and a pack whose missing list was never set are one state — and
// writing a NULL would make the read side distinguish two the domain does not
// have.
func strings0(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// counts0 encodes a count map, never as NULL.
func counts0(in map[string]int) ([]byte, error) {
	if in == nil {
		in = map[string]int{}
	}
	return json.Marshal(in)
}

func countsFrom(raw []byte) (map[string]int, error) {
	out := map[string]int{}
	if len(raw) == 0 {
		return out, nil
	}
	if err := json.Unmarshal(raw, &out); err != nil {
		return nil, err
	}
	return out, nil
}

// MasterRepo implements ports.MasterRepository.
type MasterRepo struct{ *Repository }

var _ ports.MasterRepository = MasterRepo{}

// InsertInstrument registers an instrument.
func (r MasterRepo) InsertInstrument(ctx context.Context,
	scope authctx.TenantScope, i domain.Instrument) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	instrumentID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertInstrument(ctx, sqlcgen.InsertInstrumentParams{
		InstrumentID: instrumentID, TenantID: tenantID,
		Code: i.Code, Display: i.Display, SerialNumber: i.SerialNumber,
		Status: string(i.Status), Location: i.Location,
		AcquiredOn: stampDate(i.AcquiredOn), Notes: i.Notes,
		CreatedAt: stamp(i.CreatedAt), CreatedBy: i.CreatedBy,
	})
}

// Instrument reads one instrument.
func (r MasterRepo) Instrument(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Instrument, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Instrument{}, err
	}
	instrumentID, err := uuid.Parse(id)
	if err != nil {
		return domain.Instrument{}, notFound()
	}

	row, err := r.queries(ctx).GetInstrument(ctx, sqlcgen.GetInstrumentParams{
		TenantID: tenantID, InstrumentID: instrumentID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Instrument{}, notFound()
	}
	if err != nil {
		return domain.Instrument{}, err
	}
	return instrumentFrom(row), nil
}

// UpdateInstrument moves an instrument between states.
func (r MasterRepo) UpdateInstrument(ctx context.Context,
	scope authctx.TenantScope, i domain.Instrument,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	instrumentID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInstrumentStatus(ctx,
		sqlcgen.UpdateInstrumentStatusParams{
			TenantID: tenantID, InstrumentID: instrumentID,
			Status: string(i.Status), Location: i.Location, Notes: i.Notes,
			RetiredOn: stamp(i.RetiredOn), ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Instruments lists the master, optionally narrowed to one code.
func (r MasterRepo) Instruments(ctx context.Context, scope authctx.TenantScope,
	code string, limit int32) ([]domain.Instrument, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListInstruments(ctx, sqlcgen.ListInstrumentsParams{
		TenantID: tenantID, Code: code, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return instrumentsFrom(rows), nil
}

// OutOfService is the lifecycle worklist.
func (r MasterRepo) OutOfService(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.Instrument, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListInstrumentsOutOfService(ctx,
		sqlcgen.ListInstrumentsOutOfServiceParams{
			TenantID: tenantID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return instrumentsFrom(rows), nil
}

func instrumentsFrom(rows []sqlcgen.SterileInstrument) []domain.Instrument {
	out := make([]domain.Instrument, 0, len(rows))
	for _, row := range rows {
		out = append(out, instrumentFrom(row))
	}
	return out
}

func instrumentFrom(row sqlcgen.SterileInstrument) domain.Instrument {
	return domain.Instrument{
		ID: row.InstrumentID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Display: row.Display, SerialNumber: row.SerialNumber,
		Status: domain.InstrumentStatus(row.Status), Location: row.Location,
		AcquiredOn: dateOf(row.AcquiredOn), RetiredOn: timeOf(row.RetiredOn),
		Notes:     row.Notes,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

func (r MasterRepo) insertSet(ctx context.Context, tenantID uuid.UUID,
	s domain.TraySet) error {

	setID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	supersedes, err := optionalUUID(s.Supersedes)
	if err != nil {
		return err
	}
	items, err := json.Marshal(s.Items)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertTraySet(ctx, sqlcgen.InsertTraySetParams{
		SetID: setID, TenantID: tenantID,
		Code: s.Code, Display: s.Display, Kind: s.Kind,
		SetVersion: int32(s.Version), Supersedes: supersedes,
		Items:            items,
		ShelfLifeSeconds: int64(s.ShelfLife / time.Second),
		CreatedAt:        stamp(s.CreatedAt), CreatedBy: s.CreatedBy,
	})
}

// InsertSet writes a first version of a tray.
func (r MasterRepo) InsertSet(ctx context.Context, scope authctx.TenantScope,
	s domain.TraySet) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return r.insertSet(ctx, tenantID, s)
}

// Supersede closes a version and opens its replacement.
//
// Both statements in one transaction, and in this order: the database holds
// "at most one current version per code" as a partial unique index, so the old
// row has to stop being current before the new one exists.
func (r MasterRepo) Supersede(ctx context.Context, scope authctx.TenantScope,
	next domain.TraySet, previousID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	previous, err := uuid.Parse(previousID)
	if err != nil {
		return notFound()
	}

	return r.tx.WithinTx(ctx, func(ctx context.Context) error {
		rows, err := r.queries(ctx).SupersedeTraySet(ctx,
			sqlcgen.SupersedeTraySetParams{
				TenantID: tenantID, SetID: previous, SupersededAt: stamp(at),
			})
		if err != nil {
			return err
		}
		if rows == 0 {
			// Somebody superseded it first. Re-read and decide again rather
			// than writing a second live version.
			return ports.ErrVersionConflict
		}
		return r.insertSet(ctx, tenantID, next)
	})
}

// Set reads one version.
func (r MasterRepo) Set(ctx context.Context, scope authctx.TenantScope,
	setID string) (domain.TraySet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.TraySet{}, err
	}
	id, err := uuid.Parse(setID)
	if err != nil {
		return domain.TraySet{}, notFound()
	}

	row, err := r.queries(ctx).GetTraySet(ctx, sqlcgen.GetTraySetParams{
		TenantID: tenantID, SetID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.TraySet{}, notFound()
	}
	if err != nil {
		return domain.TraySet{}, err
	}
	return setFrom(row)
}

// CurrentSet is the version in force for a code.
func (r MasterRepo) CurrentSet(ctx context.Context, scope authctx.TenantScope,
	code string) (domain.TraySet, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.TraySet{}, false, err
	}
	row, err := r.queries(ctx).GetCurrentTraySet(ctx,
		sqlcgen.GetCurrentTraySetParams{TenantID: tenantID, Code: code})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.TraySet{}, false, nil
	}
	if err != nil {
		return domain.TraySet{}, false, err
	}
	set, err := setFrom(row)
	return set, err == nil, err
}

// SetVersions reads a set's history, oldest first.
func (r MasterRepo) SetVersions(ctx context.Context, scope authctx.TenantScope,
	code string) ([]domain.TraySet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTraySetVersions(ctx,
		sqlcgen.ListTraySetVersionsParams{TenantID: tenantID, Code: code})
	if err != nil {
		return nil, err
	}
	return setsFrom(rows)
}

// Sets lists the current version of every tray.
func (r MasterRepo) Sets(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.TraySet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTraySets(ctx, sqlcgen.ListTraySetsParams{
		TenantID: tenantID, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return setsFrom(rows)
}

func setsFrom(rows []sqlcgen.SterileTraySet) ([]domain.TraySet, error) {
	out := make([]domain.TraySet, 0, len(rows))
	for _, row := range rows {
		set, err := setFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, set)
	}
	return out, nil
}

func setFrom(row sqlcgen.SterileTraySet) (domain.TraySet, error) {
	var items []domain.PackingItem
	if len(row.Items) > 0 {
		if err := json.Unmarshal(row.Items, &items); err != nil {
			return domain.TraySet{}, err
		}
	}
	return domain.TraySet{
		ID: row.SetID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Display: row.Display, Kind: row.Kind,
		Version: int(row.SetVersion), Supersedes: uuidOrEmpty(row.Supersedes),
		Items:     items,
		ShelfLife: time.Duration(row.ShelfLifeSeconds) * time.Second,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		SupersededAt: timeOf(row.SupersededAt),
	}, nil
}
