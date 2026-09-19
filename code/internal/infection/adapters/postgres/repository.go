// Package postgres is the infection control persistence adapter.
//
// It is the only package permitted to issue SQL against the infection schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
//
// There is no delete anywhere in this package. A surveillance case the
// reviewer refuted is evidence about the definition, an overridden alert is
// the record of a judgement somebody made, and a hand hygiene observation
// removed after the fact is a compliance rate somebody edited. A surface with
// no DELETE on it is a stronger guarantee than a policy.
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the infection control repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("IPC_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("IPC_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("IPC_NOT_FOUND", "no such infection control record")
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

func day(t time.Time) pgtype.Date {
	if t.IsZero() {
		return pgtype.Date{}
	}
	return pgtype.Date{Time: t.UTC(), Valid: true}
}

func dayOf(d pgtype.Date) time.Time {
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

// texts coalesces a nil slice into an empty array. A nil Go slice is written
// as NULL, and every array column in this schema is NOT NULL, so an outbreak
// declared with no control measures yet would otherwise be rejected by the
// database rather than by the rule that is supposed to catch it.
func texts(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as a
// NULL timestamp and excludes every row, which reads as "this ward has no
// infections" — the one answer an infection control system must never give by
// accident.
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

// InsertCase records a suspected infection (SRS-IPC-001).
func (r *Repository) InsertCase(ctx context.Context,
	scope authctx.TenantScope, c domain.SurveillanceCase) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	caseID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_CASE_ID_INVALID", "case id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionCase(ctx,
		sqlcgen.InsertInfectionCaseParams{
			CaseID: caseID, TenantID: tenantID, Reference: c.Reference,
			PatientID: c.PatientID, EncounterID: c.EncounterID,
			FacilityID: c.FacilityID, LocationID: c.LocationID,
			Organism: c.Organism, OrganismCode: c.OrganismCode,
			Site:               string(c.Site),
			MultidrugResistant: c.MultidrugResistant,
			Onset:              string(c.Onset),
			AdmittedAt:         stamp(c.AdmittedAt), OnsetAt: stamp(c.OnsetAt),
			WindowHours: int32(c.WindowHours), Criteria: c.Criteria,
			DeviceInSitu: c.DeviceInSitu, DeviceDays: int32(c.DeviceDays),
			State: string(c.State), Notes: c.Notes,
			ReportedAt: stamp(c.ReportedAt), ReportedBy: c.ReportedBy,
		})
}

// Case reads one surveillance case.
func (r *Repository) Case(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.SurveillanceCase, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.SurveillanceCase{}, err
	}
	caseID, err := uuid.Parse(id)
	if err != nil {
		return domain.SurveillanceCase{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionCase(ctx,
		sqlcgen.GetInfectionCaseParams{TenantID: tenantID, CaseID: caseID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.SurveillanceCase{}, notFound()
	}
	if err != nil {
		return domain.SurveillanceCase{}, err
	}
	return caseFrom(row), nil
}

// UpdateCase writes a review, an override or a closure.
func (r *Repository) UpdateCase(ctx context.Context,
	scope authctx.TenantScope, c domain.SurveillanceCase,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	caseID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionCase(ctx,
		sqlcgen.UpdateInfectionCaseParams{
			State: string(c.State), Criteria: c.Criteria,
			ReviewedBy: c.ReviewedBy, ReviewedAt: stamp(c.ReviewedAt),
			OnsetOverride:     string(c.OnsetOverride),
			OnsetOverrideWhy:  c.OnsetOverrideWhy,
			OnsetOverriddenBy: c.OnsetOverriddenBy,
			Notes:             c.Notes,
			ClosedAt:          stamp(c.ClosedAt), ClosedBy: c.ClosedBy,
			TenantID: tenantID, CaseID: caseID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Cases lists surveillance cases.
func (r *Repository) Cases(ctx context.Context, scope authctx.TenantScope,
	f ports.CaseFilter) ([]domain.SurveillanceCase, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListInfectionCases(ctx,
		sqlcgen.ListInfectionCasesParams{
			TenantID: tenantID, PatientID: f.PatientID, State: f.State,
			Site: string(f.Site), LocationID: f.LocationID,
			OnsetFrom: stamp(from), OnsetTo: stamp(to),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.SurveillanceCase, 0, len(rows))
	for _, row := range rows {
		out = append(out, caseFrom(row))
	}
	return out, nil
}

func caseFrom(row sqlcgen.InfectionSurveillanceCase) domain.SurveillanceCase {
	return domain.SurveillanceCase{
		ID: row.CaseID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, PatientID: row.PatientID,
		EncounterID: row.EncounterID, FacilityID: row.FacilityID,
		LocationID: row.LocationID, Organism: row.Organism,
		OrganismCode:       row.OrganismCode,
		Site:               domain.InfectionSite(row.Site),
		MultidrugResistant: row.MultidrugResistant,
		Onset:              domain.Onset(row.Onset),
		OnsetOverride:      domain.Onset(row.OnsetOverride),
		OnsetOverrideWhy:   row.OnsetOverrideWhy,
		OnsetOverriddenBy:  row.OnsetOverriddenBy,
		AdmittedAt:         timeOf(row.AdmittedAt),
		OnsetAt:            timeOf(row.OnsetAt),
		WindowHours:        int(row.WindowHours),
		Criteria:           row.Criteria, ReviewedBy: row.ReviewedBy,
		ReviewedAt:   timeOf(row.ReviewedAt),
		DeviceInSitu: row.DeviceInSitu, DeviceDays: int(row.DeviceDays),
		State: domain.CaseState(row.State), Notes: row.Notes,
		ReportedAt: timeOf(row.ReportedAt), ReportedBy: row.ReportedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		Version: row.Version,
	}
}

// UpsertDeviceDays records or corrects one day's census (SRS-IPC-002).
func (r *Repository) UpsertDeviceDays(ctx context.Context,
	scope authctx.TenantScope, c domain.DeviceDayCount) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	countID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_COUNT_ID_INVALID",
			"count id must be a UUID")
	}

	return r.queries(ctx).UpsertInfectionDeviceDays(ctx,
		sqlcgen.UpsertInfectionDeviceDaysParams{
			CountID: countID, TenantID: tenantID, FacilityID: c.FacilityID,
			LocationID: c.LocationID, Device: string(c.Device),
			CountedOn:   day(c.On),
			PatientDays: int32(c.PatientDays),
			DeviceDays:  int32(c.DeviceDays),
			RecordedAt:  stamp(c.RecordedAt), RecordedBy: c.RecordedBy,
		})
}

// DeviceDays lists the denominators for a period.
func (r *Repository) DeviceDays(ctx context.Context,
	scope authctx.TenantScope, f ports.DeviceDayFilter) (
	[]domain.DeviceDayCount, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)

	rows, err := r.queries(ctx).ListInfectionDeviceDays(ctx,
		sqlcgen.ListInfectionDeviceDaysParams{
			TenantID: tenantID, Device: string(f.Device),
			LocationID:  f.LocationID,
			CountedFrom: day(from), CountedTo: day(to),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.DeviceDayCount, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.DeviceDayCount{
			ID: row.CountID.String(), TenantID: row.TenantID.String(),
			FacilityID: row.FacilityID, LocationID: row.LocationID,
			Device: domain.DeviceKind(row.Device), On: dayOf(row.CountedOn),
			PatientDays: int(row.PatientDays),
			DeviceDays:  int(row.DeviceDays),
			RecordedAt:  timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

// InsertIsolation places a patient under precautions (SRS-IPC-003).
func (r *Repository) InsertIsolation(ctx context.Context,
	scope authctx.TenantScope, i domain.Isolation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	isolationID, err := uuid.Parse(i.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_ISOLATION_ID_INVALID",
			"isolation id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionIsolation(ctx,
		sqlcgen.InsertInfectionIsolationParams{
			IsolationID: isolationID, TenantID: tenantID,
			PatientID: i.PatientID, EncounterID: i.EncounterID,
			FacilityID: i.FacilityID, LocationID: i.LocationID,
			BedID: i.BedID, Precaution: string(i.Precaution),
			Reason: i.Reason, CaseID: optionalUUID(i.CaseID),
			StartedAt: stamp(i.StartedAt), StartedBy: i.StartedBy,
			ReviewDue: stamp(i.ReviewDue),
		})
}

// Isolation reads one set of precautions.
func (r *Repository) Isolation(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Isolation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Isolation{}, err
	}
	isolationID, err := uuid.Parse(id)
	if err != nil {
		return domain.Isolation{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionIsolation(ctx,
		sqlcgen.GetInfectionIsolationParams{
			TenantID: tenantID, IsolationID: isolationID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Isolation{}, notFound()
	}
	if err != nil {
		return domain.Isolation{}, err
	}
	return isolationFrom(row), nil
}

// UpdateIsolation extends a review date or lifts precautions.
func (r *Repository) UpdateIsolation(ctx context.Context,
	scope authctx.TenantScope, i domain.Isolation,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	isolationID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionIsolation(ctx,
		sqlcgen.UpdateInfectionIsolationParams{
			ReviewDue: stamp(i.ReviewDue), EndedAt: stamp(i.EndedAt),
			EndedBy: i.EndedBy, EndReason: i.EndReason,
			TenantID: tenantID, IsolationID: isolationID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Isolations lists precautions, for a ward board or a patient's history.
func (r *Repository) Isolations(ctx context.Context,
	scope authctx.TenantScope, f ports.IsolationFilter) (
	[]domain.Isolation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListInfectionIsolations(ctx,
		sqlcgen.ListInfectionIsolationsParams{
			TenantID: tenantID, LocationID: f.LocationID,
			PatientID: f.PatientID, ActiveOnly: f.ActiveOnly,
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Isolation, 0, len(rows))
	for _, row := range rows {
		out = append(out, isolationFrom(row))
	}
	return out, nil
}

func isolationFrom(row sqlcgen.InfectionIsolation) domain.Isolation {
	return domain.Isolation{
		ID: row.IsolationID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		FacilityID: row.FacilityID, LocationID: row.LocationID,
		BedID: row.BedID, Precaution: domain.Precaution(row.Precaution),
		Reason: row.Reason, CaseID: uuidString(row.CaseID),
		StartedAt: timeOf(row.StartedAt), StartedBy: row.StartedBy,
		ReviewDue: timeOf(row.ReviewDue),
		EndedAt:   timeOf(row.EndedAt), EndedBy: row.EndedBy,
		EndReason: row.EndReason, Version: row.Version,
	}
}
