// Package postgres is the laundry and linen persistence adapter.
//
// It is the only package permitted to issue SQL against the laundry schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant
// predicate is always present and always comes from verified credentials
// (FIT-03).
//
// There is no delete anywhere in this package except one: the declared lines
// of a collection that is being re-counted, which are replaced inside the
// same transaction that writes the new ones. Everything else is kept. A
// cancelled collection is what a ward returned; a failed batch is the wash
// that did not work; a rejected write-off is linen somebody said was gone and
// somebody else found. All three answer a question asked afterwards.
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the laundry repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("LND_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("LND_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe
// cannot confirm that an id exists in another tenant by the shape of the
// refusal.
func notFound() error {
	return rpcerr.NotFound("LND_NOT_FOUND", "no such record")
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

// optionalText carries the denormalised cycle a collection's composite
// foreign key is checked against. Nil rather than the empty string, because
// the key is (batch_id, batch_cycle) and an unbatched collection has neither.
func optionalText(s string) *string {
	if s == "" {
		return nil
	}
	return &s
}

func textOf(s *string) string {
	if s == nil {
		return ""
	}
	return *s
}

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as
// a NULL timestamp and excludes every row, which reads as "this ward has
// returned no linen" — an answer a balance must never give by accident.
var (
	epoch     = time.Date(1970, 1, 1, 0, 0, 0, 0, time.UTC)
	farFuture = time.Date(2200, 1, 1, 0, 0, 0, 0, time.UTC)
)

func window(from, to time.Time) (time.Time, time.Time) {
	if from.IsZero() {
		from = epoch
	}
	if to.IsZero() {
		to = farFuture
	}
	return from, to
}

func page(limit, offset int32) (int32, int32) {
	if limit <= 0 {
		limit = 200
	}
	if offset < 0 {
		offset = 0
	}
	return limit, offset
}

// states coalesces a nil slice into an empty array. A nil Go slice is written
// as NULL and cardinality(NULL) is NULL, so the "no filter" branch would
// never fire and a worklist would come back empty.
func states(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

func conflict(rows int64) error {
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

func isNoRows(err error) bool { return errors.Is(err, pgx.ErrNoRows) }

// ------------------------------------------------ linen master (SRS-LND-001)

var _ ports.ItemRepository = (*Repository)(nil)

// InsertItem implements ports.ItemRepository.
func (r *Repository) InsertItem(ctx context.Context,
	scope authctx.TenantScope, i domain.LinenItem) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertLinenItem(ctx, sqlcgen.InsertLinenItemParams{
		ItemID: id, TenantID: tenantID,
		Code: i.Code, Name: i.Name, Category: string(i.Category),
		UnitWeightG:          int32(i.UnitWeightG),
		ReplacementCostMinor: int32(i.ReplacementCostMinor),
		Tracked:              i.Tracked, Active: i.Active,
		CreatedAt: stamp(i.CreatedAt), CreatedBy: i.CreatedBy,
		Version: i.Version,
	})
}

// Item implements ports.ItemRepository.
func (r *Repository) Item(ctx context.Context, scope authctx.TenantScope,
	itemID string) (domain.LinenItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.LinenItem{}, err
	}
	id, err := uuid.Parse(itemID)
	if err != nil {
		return domain.LinenItem{}, notFound()
	}

	row, err := r.queries(ctx).GetLinenItem(ctx, sqlcgen.GetLinenItemParams{
		TenantID: tenantID, ItemID: id,
	})
	if isNoRows(err) {
		return domain.LinenItem{}, notFound()
	}
	if err != nil {
		return domain.LinenItem{}, err
	}
	return itemFrom(row), nil
}

// ItemByCode implements ports.ItemRepository.
func (r *Repository) ItemByCode(ctx context.Context,
	scope authctx.TenantScope, code string) (domain.LinenItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.LinenItem{}, err
	}
	row, err := r.queries(ctx).GetLinenItemByCode(ctx,
		sqlcgen.GetLinenItemByCodeParams{TenantID: tenantID, Code: code})
	if isNoRows(err) {
		return domain.LinenItem{}, notFound()
	}
	if err != nil {
		return domain.LinenItem{}, err
	}
	return itemFrom(row), nil
}

// UpdateItem implements ports.ItemRepository.
func (r *Repository) UpdateItem(ctx context.Context,
	scope authctx.TenantScope, i domain.LinenItem,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateLinenItem(ctx,
		sqlcgen.UpdateLinenItemParams{
			Name: i.Name, Active: i.Active,
			TenantID: tenantID, ItemID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Items implements ports.ItemRepository.
func (r *Repository) Items(ctx context.Context, scope authctx.TenantScope,
	f ports.ItemFilter) ([]domain.LinenItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListLinenItems(ctx,
		sqlcgen.ListLinenItemsParams{
			TenantID: tenantID, Category: f.Category,
			TrackedOnly: f.TrackedOnly, ActiveOnly: f.ActiveOnly,
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.LinenItem, 0, len(rows))
	for _, row := range rows {
		out = append(out, itemFrom(row))
	}
	return out, nil
}

func itemFrom(row sqlcgen.LaundryLinenItem) domain.LinenItem {
	return domain.LinenItem{
		ID: row.ItemID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name,
		Category:             domain.Category(row.Category),
		UnitWeightG:          int(row.UnitWeightG),
		ReplacementCostMinor: int(row.ReplacementCostMinor),
		Tracked:              row.Tracked, Active: row.Active,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// --------------------------------------------------- par levels (SRS-LND-001)

var _ ports.ParRepository = (*Repository)(nil)

// InsertPar implements ports.ParRepository.
func (r *Repository) InsertPar(ctx context.Context,
	scope authctx.TenantScope, p domain.ParLevel) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertParLevel(ctx, sqlcgen.InsertParLevelParams{
		ParID: id, TenantID: tenantID,
		UnitID: p.UnitID, UnitName: p.UnitName, FacilityID: p.FacilityID,
		Revision: int32(p.Revision),
		Approved: p.Approved, ApprovedBy: p.ApprovedBy,
		ApprovedAt:    stamp(p.ApprovedAt),
		EffectiveFrom: stamp(p.EffectiveFrom),
		SupersededAt:  stamp(p.SupersededAt),
		CreatedAt:     stamp(p.CreatedAt), CreatedBy: p.CreatedBy,
		Version: p.Version,
	}); err != nil {
		return err
	}

	for i, line := range p.Lines {
		if err := q.InsertParLine(ctx, sqlcgen.InsertParLineParams{
			ParID: id, ItemCode: line.ItemCode,
			Quantity: int32(line.Quantity), ReorderAt: int32(line.ReorderAt),
			Position: int32(i),
		}); err != nil {
			return err
		}
	}
	return nil
}

// Par implements ports.ParRepository.
func (r *Repository) Par(ctx context.Context, scope authctx.TenantScope,
	parID string) (domain.ParLevel, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ParLevel{}, err
	}
	id, err := uuid.Parse(parID)
	if err != nil {
		return domain.ParLevel{}, notFound()
	}

	row, err := r.queries(ctx).GetParLevel(ctx, sqlcgen.GetParLevelParams{
		TenantID: tenantID, ParID: id,
	})
	if isNoRows(err) {
		return domain.ParLevel{}, notFound()
	}
	if err != nil {
		return domain.ParLevel{}, err
	}
	out, err := r.withParLines(ctx, []sqlcgen.LaundryParLevel{row})
	if err != nil {
		return domain.ParLevel{}, err
	}
	return out[0], nil
}

// ApprovePar implements ports.ParRepository.
func (r *Repository) ApprovePar(ctx context.Context,
	scope authctx.TenantScope, p domain.ParLevel,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveParLevel(ctx,
		sqlcgen.ApproveParLevelParams{
			ApprovedBy: p.ApprovedBy, ApprovedAt: stamp(p.ApprovedAt),
			EffectiveFrom: stamp(p.EffectiveFrom),
			TenantID:      tenantID, ParID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// SupersedePar implements ports.ParRepository.
func (r *Repository) SupersedePar(ctx context.Context,
	scope authctx.TenantScope, parID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(parID)
	if err != nil {
		return notFound()
	}

	_, err = r.queries(ctx).SupersedeParLevel(ctx,
		sqlcgen.SupersedeParLevelParams{
			SupersededAt: stamp(at), TenantID: tenantID, ParID: id,
		})
	return err
}

// Pars implements ports.ParRepository.
func (r *Repository) Pars(ctx context.Context, scope authctx.TenantScope,
	f ports.ParFilter) ([]domain.ParLevel, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	asOf := f.At
	if asOf.IsZero() {
		asOf = time.Now().UTC()
	}

	rows, err := r.queries(ctx).ListParLevels(ctx,
		sqlcgen.ListParLevelsParams{
			TenantID: tenantID, FacilityID: f.FacilityID, UnitID: f.UnitID,
			LiveOnly: f.LiveOnly, At: stamp(asOf),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	return r.withParLines(ctx, rows)
}

// RevisionsOf implements ports.ParRepository.
func (r *Repository) RevisionsOf(ctx context.Context,
	scope authctx.TenantScope, unitID string) ([]domain.ParLevel, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListParRevisions(ctx,
		sqlcgen.ListParRevisionsParams{TenantID: tenantID, UnitID: unitID})
	if err != nil {
		return nil, err
	}
	return r.withParLines(ctx, rows)
}

// withParLines attaches each par's lines in one further query rather than
// one per par, because a facility read is every ward at once.
func (r *Repository) withParLines(ctx context.Context,
	rows []sqlcgen.LaundryParLevel) ([]domain.ParLevel, error) {

	out := make([]domain.ParLevel, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, parFrom(row))
		ids = append(ids, row.ParID)
	}
	if len(ids) == 0 {
		return out, nil
	}

	lines, err := r.queries(ctx).ListParLines(ctx, ids)
	if err != nil {
		return nil, err
	}
	byPar := map[string][]domain.ParLine{}
	for _, line := range lines {
		byPar[line.ParID.String()] = append(byPar[line.ParID.String()],
			domain.ParLine{
				ItemCode: line.ItemCode, Quantity: int(line.Quantity),
				ReorderAt: int(line.ReorderAt),
			})
	}
	for i := range out {
		out[i].Lines = byPar[out[i].ID]
	}
	return out, nil
}

func parFrom(row sqlcgen.LaundryParLevel) domain.ParLevel {
	return domain.ParLevel{
		ID: row.ParID.String(), TenantID: row.TenantID.String(),
		UnitID: row.UnitID, UnitName: row.UnitName,
		FacilityID: row.FacilityID, Revision: int(row.Revision),
		Approved: row.Approved, ApprovedBy: row.ApprovedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}
