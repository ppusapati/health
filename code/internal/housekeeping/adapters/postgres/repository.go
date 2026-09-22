// Package postgres is the housekeeping persistence adapter.
//
// It is the only package permitted to issue SQL against the housekeeping
// schema (FIT-02). Every method takes an authctx.TenantScope, so the tenant
// predicate is always present and always comes from verified credentials
// (FIT-03).
//
// There is no delete anywhere in this package, and no update at all against
// housekeeping.location_scan. A cancelled task is a decision somebody made, a
// superseded cleaning standard is what a completed clean was judged against,
// an overridden bed hold is a bed that went back into service uncleaned, and
// a scan is evidence about a moment somebody was in a room. All four answer a
// question somebody asks afterwards, and none of them is safe to edit.
package postgres

import (
	"context"
	"errors"
	"sort"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the housekeeping repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("HKP_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("HKP_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe
// cannot confirm that an id exists in another tenant by the shape of the
// refusal.
func notFound() error {
	return rpcerr.NotFound("HKP_NOT_FOUND", "no such record")
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

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as
// a NULL timestamp and excludes every row, which reads as "nothing has been
// cleaned here" — an answer an audit report must never give by accident.
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
// as NULL and cardinality(NULL) is NULL, so the "no filter" branch of the
// list query would never fire and a worklist would come back empty.
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

// ------------------------------------------------- locations (SRS-HKP-001)

var _ ports.LocationRepository = (*Repository)(nil)

// InsertLocation implements ports.LocationRepository.
//
// The configuration and its checklist land together. A standard whose
// checklist arrived afterwards would be one a task could be raised against
// with nothing to answer.
func (r *Repository) InsertLocation(ctx context.Context,
	scope authctx.TenantScope, l domain.CleanableLocation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertCleanableLocation(ctx,
		sqlcgen.InsertCleanableLocationParams{
			LocationID: id, TenantID: tenantID,
			Code: l.Code, Name: l.Name, Revision: int32(l.Revision),
			FacilityID: l.FacilityID, Zone: l.Zone, BedID: l.BedID,
			RiskClass:          string(l.RiskClass),
			RoutineEveryHours:  int32(l.RoutineEveryHours),
			RoutineSlaMinutes:  int32(l.RoutineSLAMinutes),
			TerminalSlaMinutes: int32(l.TerminalSLAMinutes),
			ScanCode:           l.ScanCode,
			Approved:           l.Approved, ApprovedBy: l.ApprovedBy,
			ApprovedAt:    stamp(l.ApprovedAt),
			EffectiveFrom: stamp(l.EffectiveFrom),
			SupersededAt:  stamp(l.SupersededAt),
			CreatedAt:     stamp(l.CreatedAt), CreatedBy: l.CreatedBy,
			Version: l.Version,
		}); err != nil {
		return err
	}

	for i, item := range l.Checklist {
		if err := q.InsertLocationChecklistItem(ctx,
			sqlcgen.InsertLocationChecklistItemParams{
				LocationID: id, ItemCode: item.Code, Label: item.Label,
				Required: item.Required, Position: int32(i),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Location implements ports.LocationRepository.
func (r *Repository) Location(ctx context.Context, scope authctx.TenantScope,
	locationID string) (domain.CleanableLocation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	id, err := uuid.Parse(locationID)
	if err != nil {
		return domain.CleanableLocation{}, notFound()
	}

	row, err := r.queries(ctx).GetCleanableLocation(ctx,
		sqlcgen.GetCleanableLocationParams{TenantID: tenantID, LocationID: id})
	if isNoRows(err) {
		return domain.CleanableLocation{}, notFound()
	}
	if err != nil {
		return domain.CleanableLocation{}, err
	}

	out, err := r.withChecklists(ctx, []sqlcgen.HousekeepingCleanableLocation{row})
	if err != nil {
		return domain.CleanableLocation{}, err
	}
	return out[0], nil
}

// ApproveLocation implements ports.LocationRepository.
func (r *Repository) ApproveLocation(ctx context.Context,
	scope authctx.TenantScope, l domain.CleanableLocation,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveCleanableLocation(ctx,
		sqlcgen.ApproveCleanableLocationParams{
			ApprovedBy: l.ApprovedBy, ApprovedAt: stamp(l.ApprovedAt),
			EffectiveFrom: stamp(l.EffectiveFrom),
			TenantID:      tenantID, LocationID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// SupersedeLocation implements ports.LocationRepository.
func (r *Repository) SupersedeLocation(ctx context.Context,
	scope authctx.TenantScope, locationID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(locationID)
	if err != nil {
		return notFound()
	}

	_, err = r.queries(ctx).SupersedeCleanableLocation(ctx,
		sqlcgen.SupersedeCleanableLocationParams{
			SupersededAt: stamp(at), TenantID: tenantID, LocationID: id,
		})
	return err
}

// Locations implements ports.LocationRepository.
func (r *Repository) Locations(ctx context.Context, scope authctx.TenantScope,
	f ports.LocationFilter) ([]domain.CleanableLocation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	asOf := f.At
	if asOf.IsZero() {
		asOf = time.Now().UTC()
	}

	rows, err := r.queries(ctx).ListCleanableLocations(ctx,
		sqlcgen.ListCleanableLocationsParams{
			TenantID: tenantID, FacilityID: f.FacilityID, Zone: f.Zone,
			RiskClass: f.RiskClass, LiveOnly: f.LiveOnly, At: stamp(asOf),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	return r.withChecklists(ctx, rows)
}

// RevisionsOf implements ports.LocationRepository.
func (r *Repository) RevisionsOf(ctx context.Context,
	scope authctx.TenantScope, code string) ([]domain.CleanableLocation,
	error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListLocationRevisions(ctx,
		sqlcgen.ListLocationRevisionsParams{TenantID: tenantID, Code: code})
	if err != nil {
		return nil, err
	}
	return r.withChecklists(ctx, rows)
}

// withChecklists attaches each location's checklist in one further query
// rather than one per location, because a facility read is a few hundred
// rooms and a query each would be a few hundred round trips.
func (r *Repository) withChecklists(ctx context.Context,
	rows []sqlcgen.HousekeepingCleanableLocation) (
	[]domain.CleanableLocation, error) {

	out := make([]domain.CleanableLocation, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, locationFrom(row))
		ids = append(ids, row.LocationID)
	}
	if len(ids) == 0 {
		return out, nil
	}

	items, err := r.queries(ctx).ListLocationChecklistItems(ctx, ids)
	if err != nil {
		return nil, err
	}
	byLocation := map[string][]domain.ChecklistItem{}
	for _, item := range items {
		byLocation[item.LocationID.String()] = append(
			byLocation[item.LocationID.String()],
			domain.ChecklistItem{
				Code: item.ItemCode, Label: item.Label,
				Required: item.Required,
			})
	}
	for i := range out {
		out[i].Checklist = byLocation[out[i].ID]
	}
	return out, nil
}

func locationFrom(
	row sqlcgen.HousekeepingCleanableLocation) domain.CleanableLocation {

	return domain.CleanableLocation{
		ID: row.LocationID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		FacilityID: row.FacilityID, Zone: row.Zone, BedID: row.BedID,
		RiskClass:          domain.RiskClass(row.RiskClass),
		RoutineEveryHours:  int(row.RoutineEveryHours),
		RoutineSLAMinutes:  int(row.RoutineSlaMinutes),
		TerminalSLAMinutes: int(row.TerminalSlaMinutes),
		ScanCode:           row.ScanCode,
		Approved:           row.Approved, ApprovedBy: row.ApprovedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// ----------------------------------------------------- tasks (SRS-HKP-002)

var _ ports.TaskRepository = (*Repository)(nil)

// InsertTask implements ports.TaskRepository.
func (r *Repository) InsertTask(ctx context.Context,
	scope authctx.TenantScope, t domain.CleaningTask) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertCleaningTask(ctx, sqlcgen.InsertCleaningTaskParams{
		TaskID: id, TenantID: tenantID, Kind: string(t.Kind),
		LocationCode: t.LocationCode, LocationName: t.LocationName,
		FacilityID: t.FacilityID, Zone: t.Zone, BedID: t.BedID,
		RiskClass:        string(t.RiskClass),
		LocationRevision: int32(t.LocationRevision),
		ScanCode:         t.ScanCode, Restricted: t.Restricted,
		IncidentRef: t.IncidentRef, Detail: t.Detail,
		AssigneeID: t.AssigneeID, DueBy: stamp(t.DueBy),
		State:     string(t.State),
		StartedAt: stamp(t.StartedAt), StartedBy: t.StartedBy,
		CompletedAt: stamp(t.CompletedAt), CompletedBy: t.CompletedBy,
		VerifiedAt: stamp(t.VerifiedAt), VerifiedBy: t.VerifiedBy,
		VerifyNote: t.VerifyNote, CancelReason: t.CancelReason,
		EscalatedAt: stamp(t.EscalatedAt),
		RaisedAt:    stamp(t.RaisedAt), RaisedBy: t.RaisedBy,
		Version: t.Version,
	}); err != nil {
		return err
	}

	answers := answersByCode(t.Answers)
	for i, item := range t.Checklist {
		answer, answered := answers[strings.ToLower(item.Code)]
		if err := q.InsertTaskChecklistItem(ctx,
			sqlcgen.InsertTaskChecklistItemParams{
				TaskID: id, ItemCode: item.Code, Label: item.Label,
				Required: item.Required, Position: int32(i),
				Answered: answered, Done: answer.Done,
				Exception: answer.Exception,
			}); err != nil {
			return err
		}
	}
	return nil
}

// Task implements ports.TaskRepository.
func (r *Repository) Task(ctx context.Context, scope authctx.TenantScope,
	taskID string) (domain.CleaningTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CleaningTask{}, err
	}
	id, err := uuid.Parse(taskID)
	if err != nil {
		return domain.CleaningTask{}, notFound()
	}

	row, err := r.queries(ctx).GetCleaningTask(ctx,
		sqlcgen.GetCleaningTaskParams{TenantID: tenantID, TaskID: id})
	if isNoRows(err) {
		return domain.CleaningTask{}, notFound()
	}
	if err != nil {
		return domain.CleaningTask{}, err
	}

	out, err := r.hydrate(ctx, tenantID,
		[]sqlcgen.HousekeepingCleaningTask{row})
	if err != nil {
		return domain.CleaningTask{}, err
	}
	return out[0], nil
}

// UpdateTask implements ports.TaskRepository.
//
// The task and its checklist answers move together. A completed task whose
// answers landed afterwards would be a clean that reads as signed off with
// nothing behind it.
func (r *Repository) UpdateTask(ctx context.Context,
	scope authctx.TenantScope, t domain.CleaningTask,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	rows, err := q.UpdateCleaningTask(ctx, sqlcgen.UpdateCleaningTaskParams{
		AssigneeID: t.AssigneeID, State: string(t.State),
		StartedAt: stamp(t.StartedAt), StartedBy: t.StartedBy,
		CompletedAt: stamp(t.CompletedAt), CompletedBy: t.CompletedBy,
		VerifiedAt: stamp(t.VerifiedAt), VerifiedBy: t.VerifiedBy,
		VerifyNote: t.VerifyNote, CancelReason: t.CancelReason,
		EscalatedAt: stamp(t.EscalatedAt),
		TenantID:    tenantID, TaskID: id,
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if err := conflict(rows); err != nil {
		return err
	}

	for _, answer := range t.Answers {
		if _, err := q.AnswerTaskChecklistItem(ctx,
			sqlcgen.AnswerTaskChecklistItemParams{
				Answered: true, Done: answer.Done,
				Exception: answer.Exception,
				TaskID:    id, ItemCode: answer.Code,
			}); err != nil {
			return err
		}
	}
	return nil
}

// Tasks implements ports.TaskRepository.
func (r *Repository) Tasks(ctx context.Context, scope authctx.TenantScope,
	f ports.TaskFilter) ([]domain.CleaningTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	from, to := window(f.From, f.To)

	rows, err := r.queries(ctx).ListCleaningTasks(ctx,
		sqlcgen.ListCleaningTasksParams{
			TenantID: tenantID, FacilityID: f.FacilityID, Zone: f.Zone,
			LocationCode: f.LocationCode, BedID: f.BedID, Kind: f.Kind,
			AssigneeID: f.AssigneeID, States: states(f.States),
			OpenOnly: f.OpenOnly,
			FromTime: stamp(from), ToTime: stamp(to),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	return r.hydrate(ctx, tenantID, rows)
}

// OverdueCritical implements ports.TaskRepository.
func (r *Repository) OverdueCritical(ctx context.Context,
	scope authctx.TenantScope, facilityID string, at time.Time,
	limit int32) ([]domain.CleaningTask, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	bounded, _ := page(limit, 0)

	rows, err := r.queries(ctx).ListOverdueCriticalTasks(ctx,
		sqlcgen.ListOverdueCriticalTasksParams{
			TenantID: tenantID, FacilityID: facilityID, At: stamp(at),
			PageLimit: bounded,
		})
	if err != nil {
		return nil, err
	}
	return r.hydrate(ctx, tenantID, rows)
}

// LastCleanedByLocation implements ports.TaskRepository.
func (r *Repository) LastCleanedByLocation(ctx context.Context,
	scope authctx.TenantScope, facilityID string) (map[string]time.Time,
	error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).LastCleanedByLocation(ctx,
		sqlcgen.LastCleanedByLocationParams{
			TenantID: tenantID, FacilityID: facilityID,
		})
	if err != nil {
		return nil, err
	}
	out := make(map[string]time.Time, len(rows))
	for _, row := range rows {
		out[row.LocationCode] = timeOf(row.LastCleanedAt)
	}
	return out, nil
}

// hydrate attaches each task's checklist and scans in two further queries
// rather than two per task.
func (r *Repository) hydrate(ctx context.Context, tenantID uuid.UUID,
	rows []sqlcgen.HousekeepingCleaningTask) ([]domain.CleaningTask, error) {

	out := make([]domain.CleaningTask, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, taskFrom(row))
		ids = append(ids, row.TaskID)
	}
	if len(ids) == 0 {
		return out, nil
	}

	q := r.queries(ctx)
	items, err := q.ListTaskChecklistItems(ctx, ids)
	if err != nil {
		return nil, err
	}
	checklist := map[string][]domain.ChecklistItem{}
	answers := map[string][]domain.ChecklistAnswer{}
	for _, item := range items {
		key := item.TaskID.String()
		checklist[key] = append(checklist[key], domain.ChecklistItem{
			Code: item.ItemCode, Label: item.Label, Required: item.Required,
		})
		if item.Answered {
			answers[key] = append(answers[key], domain.ChecklistAnswer{
				Code: item.ItemCode, Done: item.Done,
				Exception: item.Exception,
			})
		}
	}

	scanRows, err := q.ListLocationScans(ctx, sqlcgen.ListLocationScansParams{
		TenantID: tenantID, TaskIds: ids,
	})
	if err != nil {
		return nil, err
	}
	scans := map[string][]domain.LocationScan{}
	for _, row := range scanRows {
		key := row.TaskID.String()
		scans[key] = append(scans[key], domain.LocationScan{
			ScannedCode: row.ScannedCode, Matched: row.Matched,
			ScannedBy: row.ScannedBy, ScannedAt: timeOf(row.ScannedAt),
		})
	}

	for i := range out {
		out[i].Checklist = checklist[out[i].ID]
		out[i].Answers = answers[out[i].ID]
		out[i].Scans = scans[out[i].ID]
	}
	return out, nil
}

func taskFrom(row sqlcgen.HousekeepingCleaningTask) domain.CleaningTask {
	return domain.CleaningTask{
		ID: row.TaskID.String(), TenantID: row.TenantID.String(),
		Kind:         domain.TaskKind(row.Kind),
		LocationCode: row.LocationCode, LocationName: row.LocationName,
		FacilityID: row.FacilityID, Zone: row.Zone, BedID: row.BedID,
		RiskClass:        domain.RiskClass(row.RiskClass),
		LocationRevision: int(row.LocationRevision),
		ScanCode:         row.ScanCode, Restricted: row.Restricted,
		IncidentRef: row.IncidentRef, Detail: row.Detail,
		AssigneeID: row.AssigneeID, DueBy: timeOf(row.DueBy),
		State:     domain.TaskState(row.State),
		StartedAt: timeOf(row.StartedAt), StartedBy: row.StartedBy,
		CompletedAt: timeOf(row.CompletedAt), CompletedBy: row.CompletedBy,
		VerifiedAt: timeOf(row.VerifiedAt), VerifiedBy: row.VerifiedBy,
		VerifyNote: row.VerifyNote, CancelReason: row.CancelReason,
		EscalatedAt: timeOf(row.EscalatedAt),
		RaisedAt:    timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		Version: row.Version,
	}
}

func answersByCode(
	answers []domain.ChecklistAnswer) map[string]domain.ChecklistAnswer {

	out := make(map[string]domain.ChecklistAnswer, len(answers))
	for _, answer := range answers {
		out[strings.ToLower(answer.Code)] = answer
	}
	return out
}

// ----------------------------------------------------- scans (SRS-HKP-007)

var _ ports.ScanRepository = (*Repository)(nil)

// AppendScan implements ports.ScanRepository.
//
// Append only. There is no update here and no query that would let one, which
// is the whole of why a scan is worth recording.
func (r *Repository) AppendScan(ctx context.Context,
	scope authctx.TenantScope, taskID string, s domain.LocationScan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(taskID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).AppendLocationScan(ctx,
		sqlcgen.AppendLocationScanParams{
			ScanID: uuid.New(), TenantID: tenantID, TaskID: id,
			ScannedCode: s.ScannedCode, Matched: s.Matched,
			ScannedBy: s.ScannedBy, ScannedAt: stamp(s.ScannedAt),
		})
}

// ScansForTask implements ports.ScanRepository.
func (r *Repository) ScansForTask(ctx context.Context,
	scope authctx.TenantScope, taskID string) ([]domain.LocationScan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(taskID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListLocationScans(ctx,
		sqlcgen.ListLocationScansParams{
			TenantID: tenantID, TaskIds: []uuid.UUID{id},
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.LocationScan, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.LocationScan{
			ScannedCode: row.ScannedCode, Matched: row.Matched,
			ScannedBy: row.ScannedBy, ScannedAt: timeOf(row.ScannedAt),
		})
	}
	sort.SliceStable(out, func(a, b int) bool {
		return out[a].ScannedAt.Before(out[b].ScannedAt)
	})
	return out, nil
}
