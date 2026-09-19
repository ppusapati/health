// Package postgres is the medical records persistence adapter.
//
// It is the only package permitted to issue SQL against the records schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant
// predicate is always present and always comes from verified credentials
// (FIT-03).
//
// There is no delete anywhere in this package. A refuted coding revision is
// evidence about the coding, a refused release is a decision somebody made,
// and a destroyed physical record keeps its row saying it was destroyed
// lawfully under a named list. The only disposal this context performs is of
// records held elsewhere, recorded here as an execution rather than issued
// from here as a DELETE.
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// Repository implements the medical records repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("MRD_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("MRD_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe
// cannot confirm that an id exists in another tenant by the shape of the
// refusal.
func notFound() error {
	return rpcerr.NotFound("MRD_NOT_FOUND", "no such record")
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

// texts coalesces a nil slice into an empty array. A nil Go slice is written
// as NULL, and every array column in this schema is NOT NULL, so a release
// scope naming only a date range would otherwise be rejected by the database
// rather than by the rule meant to catch it.
func texts(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as
// a NULL timestamp and excludes every row, which reads as "this hospital has
// no outstanding deficiencies" — the one answer a records department must
// never give by accident.
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

func conflict(rows int64) error {
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// InsertChecklist stores a checklist and its items together (SRS-MRD-001).
func (r *Repository) InsertChecklist(ctx context.Context,
	scope authctx.TenantScope, c domain.ChartChecklist) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	checklistID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_CHECKLIST_ID_INVALID",
			"checklist id must be a UUID")
	}

	queries := r.queries(ctx)
	if err := queries.InsertRecordsChecklist(ctx,
		sqlcgen.InsertRecordsChecklistParams{
			ChecklistID: checklistID, TenantID: tenantID,
			Code: c.Code, Name: c.Name, Revision: int32(c.Revision),
			EncounterClass: c.EncounterClass, Specialty: c.Specialty,
			EffectiveFrom: stamp(c.EffectiveFrom),
			CreatedAt:     stamp(c.CreatedAt), CreatedBy: c.CreatedBy,
		}); err != nil {
		return err
	}

	for _, item := range c.Items {
		if err := queries.InsertRecordsChecklistItem(ctx,
			sqlcgen.InsertRecordsChecklistItemParams{
				ItemID: uuid.New(), TenantID: tenantID,
				ChecklistID: checklistID, DocumentKind: item.Kind,
				Label: item.Label, Requirement: string(item.Requirement),
				DueWithinSeconds: int64(item.DueWithin / time.Second),
				ConditionCode:    item.ConditionCode,
			}); err != nil {
			return err
		}
	}
	return nil
}

// Checklist reads one checklist and its items.
func (r *Repository) Checklist(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.ChartChecklist, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ChartChecklist{}, err
	}
	checklistID, err := uuid.Parse(id)
	if err != nil {
		return domain.ChartChecklist{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsChecklist(ctx,
		sqlcgen.GetRecordsChecklistParams{
			TenantID: tenantID, ChecklistID: checklistID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.ChartChecklist{}, notFound()
	}
	if err != nil {
		return domain.ChartChecklist{}, err
	}

	checklist := checklistFrom(row)
	items, err := r.checklistItems(ctx, tenantID, checklistID)
	if err != nil {
		return domain.ChartChecklist{}, err
	}
	checklist.Items = items
	return checklist, nil
}

func (r *Repository) checklistItems(ctx context.Context, tenantID,
	checklistID uuid.UUID) ([]domain.ChecklistItem, error) {

	rows, err := r.queries(ctx).ListRecordsChecklistItems(ctx,
		sqlcgen.ListRecordsChecklistItemsParams{
			TenantID: tenantID, ChecklistID: checklistID,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.ChecklistItem, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.ChecklistItem{
			Kind: row.DocumentKind, Label: row.Label,
			Requirement:   domain.DocumentRequirement(row.Requirement),
			DueWithin:     time.Duration(row.DueWithinSeconds) * time.Second,
			ConditionCode: row.ConditionCode,
		})
	}
	return out, nil
}

// ApproveChecklist puts a checklist in force.
func (r *Repository) ApproveChecklist(ctx context.Context,
	scope authctx.TenantScope, c domain.ChartChecklist) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	checklistID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveRecordsChecklist(ctx,
		sqlcgen.ApproveRecordsChecklistParams{
			ApprovedBy: c.ApprovedBy, ApprovedAt: stamp(c.ApprovedAt),
			EffectiveFrom: stamp(c.EffectiveFrom),
			TenantID:      tenantID, ChecklistID: checklistID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("MRD_CHECKLIST_ALREADY_APPROVED",
			"this checklist is already approved")
	}
	return nil
}

// SupersedeEarlierChecklists closes off every earlier revision.
func (r *Repository) SupersedeEarlierChecklists(ctx context.Context,
	scope authctx.TenantScope, code string, revision int,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).SupersedeRecordsChecklist(ctx,
		sqlcgen.SupersedeRecordsChecklistParams{
			SupersededAt: stamp(at), TenantID: tenantID, Code: code,
			Revision: int32(revision),
		})
	return err
}

// Checklists lists the configured checklists with their items.
func (r *Repository) Checklists(ctx context.Context,
	scope authctx.TenantScope, encounterClass string, liveAt time.Time) (
	[]domain.ChartChecklist, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	at := liveAt
	if at.IsZero() {
		at = epoch
	}

	rows, err := r.queries(ctx).ListRecordsChecklists(ctx,
		sqlcgen.ListRecordsChecklistsParams{
			TenantID: tenantID, EncounterClass: encounterClass,
			LiveOnly: !liveAt.IsZero(), At: stamp(at),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.ChartChecklist, 0, len(rows))
	for _, row := range rows {
		checklist := checklistFrom(row)
		items, err := r.checklistItems(ctx, tenantID, row.ChecklistID)
		if err != nil {
			return nil, err
		}
		checklist.Items = items
		out = append(out, checklist)
	}
	return out, nil
}

func checklistFrom(row sqlcgen.RecordsChartChecklist) domain.ChartChecklist {
	return domain.ChartChecklist{
		ID: row.ChecklistID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		EncounterClass: row.EncounterClass, Specialty: row.Specialty,
		Approved: row.Approved, ApprovedBy: row.ApprovedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
	}
}

// InsertDeficiency records something a chart is missing (SRS-MRD-002).
func (r *Repository) InsertDeficiency(ctx context.Context,
	scope authctx.TenantScope, d domain.Deficiency) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	deficiencyID, err := uuid.Parse(d.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_DEFICIENCY_ID_INVALID",
			"deficiency id must be a UUID")
	}

	return r.queries(ctx).InsertRecordsDeficiency(ctx,
		sqlcgen.InsertRecordsDeficiencyParams{
			DeficiencyID: deficiencyID, TenantID: tenantID,
			PatientID: d.PatientID, EncounterID: d.EncounterID,
			FacilityID: d.FacilityID, Kind: string(d.Kind),
			DocumentKind: d.DocumentKind, Label: d.Label,
			DocumentID: d.DocumentID, Detail: d.Detail, OwnerID: d.OwnerID,
			ChecklistCode:     d.ChecklistCode,
			ChecklistRevision: int32(d.ChecklistRevision),
			State:             string(d.State), DueBy: stamp(d.DueBy),
			RaisedAt: stamp(d.RaisedAt), RaisedBy: d.RaisedBy,
		})
}

// Deficiency reads one deficiency.
func (r *Repository) Deficiency(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Deficiency, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Deficiency{}, err
	}
	deficiencyID, err := uuid.Parse(id)
	if err != nil {
		return domain.Deficiency{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsDeficiency(ctx,
		sqlcgen.GetRecordsDeficiencyParams{
			TenantID: tenantID, DeficiencyID: deficiencyID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Deficiency{}, notFound()
	}
	if err != nil {
		return domain.Deficiency{}, err
	}
	return deficiencyFrom(row), nil
}

// UpdateDeficiency records a resolution, a waiver, a reassignment or an
// escalation.
func (r *Repository) UpdateDeficiency(ctx context.Context,
	scope authctx.TenantScope, d domain.Deficiency,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	deficiencyID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateRecordsDeficiency(ctx,
		sqlcgen.UpdateRecordsDeficiencyParams{
			State: string(d.State), OwnerID: d.OwnerID,
			ResolvedByDocumentID: d.ResolvedByDocumentID,
			ResolvedAt:           stamp(d.ResolvedAt),
			ResolvedBy:           d.ResolvedBy,
			WaivedReason:         d.WaivedReason,
			EscalatedAt:          stamp(d.EscalatedAt),
			TenantID:             tenantID, DeficiencyID: deficiencyID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Deficiencies lists the worklist.
func (r *Repository) Deficiencies(ctx context.Context,
	scope authctx.TenantScope, f ports.DeficiencyFilter) (
	[]domain.Deficiency, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListRecordsDeficiencies(ctx,
		sqlcgen.ListRecordsDeficienciesParams{
			TenantID: tenantID, OwnerID: f.OwnerID,
			EncounterID: f.EncounterID, FacilityID: f.FacilityID,
			State: f.State, OpenOnly: f.OpenOnly,
			RaisedFrom: stamp(from), RaisedTo: stamp(to),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Deficiency, 0, len(rows))
	for _, row := range rows {
		out = append(out, deficiencyFrom(row))
	}
	return out, nil
}

// EscalationCandidates reads the sweep's worklist.
func (r *Repository) EscalationCandidates(ctx context.Context,
	scope authctx.TenantScope, before time.Time, limit int32) (
	[]domain.Deficiency, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if before.IsZero() {
		before = farFuture
	}
	size, _ := page(limit, 0)

	rows, err := r.queries(ctx).ListRecordsEscalationCandidates(ctx,
		sqlcgen.ListRecordsEscalationCandidatesParams{
			TenantID: tenantID, Before: stamp(before), PageSize: size,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Deficiency, 0, len(rows))
	for _, row := range rows {
		out = append(out, deficiencyFrom(row))
	}
	return out, nil
}

func deficiencyFrom(row sqlcgen.RecordsDeficiency) domain.Deficiency {
	return domain.Deficiency{
		ID: row.DeficiencyID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		FacilityID:   row.FacilityID,
		Kind:         domain.DeficiencyKind(row.Kind),
		DocumentKind: row.DocumentKind, Label: row.Label,
		DocumentID: row.DocumentID, Detail: row.Detail,
		OwnerID: row.OwnerID, ChecklistCode: row.ChecklistCode,
		ChecklistRevision: int(row.ChecklistRevision),
		State:             domain.DeficiencyState(row.State),
		DueBy:             timeOf(row.DueBy),
		RaisedAt:          timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		ResolvedByDocumentID: row.ResolvedByDocumentID,
		ResolvedAt:           timeOf(row.ResolvedAt),
		ResolvedBy:           row.ResolvedBy,
		WaivedReason:         row.WaivedReason,
		EscalatedAt:          timeOf(row.EscalatedAt),
		Version:              row.Version,
	}
}
