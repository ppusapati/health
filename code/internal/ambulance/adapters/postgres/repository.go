// Package postgres is the ambulance and fleet persistence adapter.
//
// It is the only package permitted to issue SQL against the ambulance schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant
// predicate is always present and always comes from verified credentials
// (FIT-03).
//
// There is one DELETE in this package: PurgeExpired, which removes location
// pings whose retention horizon has passed. That is the only data here the
// deployment has said it does not keep. Everything else stays: an aborted
// trip is a crew that was stood down, a failed readiness check is a vehicle
// that was not fit, a cancelled request is a call somebody decided not to
// answer. All three are questions asked afterwards.
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the ambulance repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("AMB_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("AMB_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe
// cannot confirm that an id exists in another tenant by the shape of the
// refusal.
func notFound() error {
	return rpcerr.NotFound("AMB_NOT_FOUND", "no such record")
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

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as
// a NULL timestamp and excludes every row, which reads as "this service ran
// no jobs today" — an answer a response-time report must never give by
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

// texts coalesces a nil slice into an empty array. A nil Go slice is written
// as NULL and cardinality(NULL) is NULL, so the "no filter" branch would
// never fire and a dispatch board would come back empty.
func texts(in []string) []string {
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

// ---------------------------------------------------- fleet (SRS-AMB-002)

var _ ports.VehicleRepository = (*Repository)(nil)

func vehicleFrom(row sqlcgen.AmbulanceVehicle) domain.Vehicle {
	return domain.Vehicle{
		ID: row.VehicleID.String(), TenantID: row.TenantID.String(),
		Registration: row.Registration, CallSign: row.CallSign,
		Kind:       domain.VehicleKind(row.Kind),
		FacilityID: uuidString(row.FacilityID), BaseID: row.BaseID,
		Capabilities:       row.Capabilities,
		State:              domain.VehicleState(row.State),
		ReadyUntil:         timeOf(row.ReadyUntil),
		OutOfServiceReason: row.OutOfServiceReason,
		CreatedAt:          timeOf(row.CreatedAt),
		CreatedBy:          row.CreatedBy, Version: row.Version,
	}
}

// InsertVehicle implements ports.VehicleRepository.
func (r *Repository) InsertVehicle(ctx context.Context,
	scope authctx.TenantScope, v domain.Vehicle) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertVehicle(ctx, sqlcgen.InsertVehicleParams{
		VehicleID: id, TenantID: tenantID,
		Registration: v.Registration, CallSign: v.CallSign,
		Kind:       string(v.Kind),
		FacilityID: optionalUUID(v.FacilityID), BaseID: v.BaseID,
		Capabilities: texts(v.Capabilities), State: string(v.State),
		ReadyUntil:         stamp(v.ReadyUntil),
		OutOfServiceReason: v.OutOfServiceReason,
		CreatedAt:          stamp(v.CreatedAt), CreatedBy: v.CreatedBy,
		Version: v.Version,
	})
}

// Vehicle implements ports.VehicleRepository.
func (r *Repository) Vehicle(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Vehicle, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Vehicle{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Vehicle{}, notFound()
	}

	row, err := r.queries(ctx).GetVehicle(ctx, sqlcgen.GetVehicleParams{
		TenantID: tenantID, VehicleID: parsed,
	})
	if isNoRows(err) {
		return domain.Vehicle{}, notFound()
	}
	if err != nil {
		return domain.Vehicle{}, err
	}
	return vehicleFrom(row), nil
}

// UpdateVehicle implements ports.VehicleRepository.
func (r *Repository) UpdateVehicle(ctx context.Context,
	scope authctx.TenantScope, v domain.Vehicle,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateVehicleState(ctx,
		sqlcgen.UpdateVehicleStateParams{
			TenantID: tenantID, VehicleID: id,
			State: string(v.State), ReadyUntil: stamp(v.ReadyUntil),
			OutOfServiceReason: v.OutOfServiceReason,
			ExpectedVersion:    expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Vehicles implements ports.VehicleRepository.
func (r *Repository) Vehicles(ctx context.Context,
	scope authctx.TenantScope, f ports.VehicleFilter) (
	[]domain.Vehicle, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	states := make([]string, 0, len(f.States))
	for _, s := range f.States {
		states = append(states, string(s))
	}
	kinds := make([]string, 0, len(f.Kinds))
	for _, k := range f.Kinds {
		kinds = append(kinds, string(k))
	}

	rows, err := r.queries(ctx).ListVehicles(ctx, sqlcgen.ListVehiclesParams{
		TenantID: tenantID, States: texts(states), Kinds: texts(kinds),
		FacilityID: f.FacilityID,
		RowLimit:   limit, RowOffset: offset,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Vehicle, 0, len(rows))
	for _, row := range rows {
		out = append(out, vehicleFrom(row))
	}
	return out, nil
}

var _ ports.ShiftRepository = (*Repository)(nil)

func shiftFrom(row sqlcgen.AmbulanceShift,
	crew []sqlcgen.AmbulanceShiftCrew) domain.Shift {

	out := domain.Shift{
		ID: row.ShiftID.String(), TenantID: row.TenantID.String(),
		VehicleID:  row.VehicleID.String(),
		FacilityID: uuidString(row.FacilityID),
		State:      domain.ShiftState(row.State),
		StartsAt:   timeOf(row.StartsAt), EndsAt: timeOf(row.EndsAt),
		StartedAt: timeOf(row.StartedAt), EndedAt: timeOf(row.EndedAt),
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
	for _, member := range crew {
		if member.ShiftID != row.ShiftID {
			continue
		}
		out.Crew = append(out.Crew, domain.CrewMember{
			SubjectID: member.SubjectID, Name: member.DisplayName,
			Role:               domain.CrewRole(member.Role),
			RegistrationNumber: member.RegistrationNumber,
		})
	}
	return out
}

// InsertShift implements ports.ShiftRepository.
func (r *Repository) InsertShift(ctx context.Context,
	scope authctx.TenantScope, s domain.Shift) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	vehicleID, err := uuid.Parse(s.VehicleID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertAmbulanceShift(ctx,
		sqlcgen.InsertAmbulanceShiftParams{
			ShiftID: id, TenantID: tenantID, VehicleID: vehicleID,
			FacilityID: optionalUUID(s.FacilityID), State: string(s.State),
			StartsAt: stamp(s.StartsAt), EndsAt: stamp(s.EndsAt),
			StartedAt: stamp(s.StartedAt), EndedAt: stamp(s.EndedAt),
			CreatedAt: stamp(s.CreatedAt), CreatedBy: s.CreatedBy,
			Version: s.Version,
		}); err != nil {
		return err
	}
	for _, member := range s.Crew {
		if err := q.InsertAmbulanceShiftCrew(ctx,
			sqlcgen.InsertAmbulanceShiftCrewParams{
				ShiftID: id, SubjectID: member.SubjectID,
				DisplayName: member.Name, Role: string(member.Role),
				RegistrationNumber: member.RegistrationNumber,
			}); err != nil {
			return err
		}
	}
	return nil
}

// Shift implements ports.ShiftRepository.
func (r *Repository) Shift(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Shift, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Shift{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Shift{}, notFound()
	}

	q := r.queries(ctx)
	row, err := q.GetAmbulanceShift(ctx, sqlcgen.GetAmbulanceShiftParams{
		TenantID: tenantID, ShiftID: parsed,
	})
	if isNoRows(err) {
		return domain.Shift{}, notFound()
	}
	if err != nil {
		return domain.Shift{}, err
	}
	crew, err := q.ListAmbulanceShiftCrew(ctx, []uuid.UUID{parsed})
	if err != nil {
		return domain.Shift{}, err
	}
	return shiftFrom(row, crew), nil
}

// UpdateShift implements ports.ShiftRepository.
func (r *Repository) UpdateShift(ctx context.Context,
	scope authctx.TenantScope, s domain.Shift, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateAmbulanceShiftState(ctx,
		sqlcgen.UpdateAmbulanceShiftStateParams{
			TenantID: tenantID, ShiftID: id, State: string(s.State),
			StartedAt: stamp(s.StartedAt), EndedAt: stamp(s.EndedAt),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Shifts implements ports.ShiftRepository.
func (r *Repository) Shifts(ctx context.Context, scope authctx.TenantScope,
	f ports.ShiftFilter) ([]domain.Shift, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	states := make([]string, 0, len(f.States))
	for _, s := range f.States {
		states = append(states, string(s))
	}

	q := r.queries(ctx)
	rows, err := q.ListAmbulanceShifts(ctx,
		sqlcgen.ListAmbulanceShiftsParams{
			TenantID: tenantID, VehicleID: f.VehicleID,
			FacilityID: f.FacilityID, States: texts(states),
			WindowFrom: stamp(from), WindowTo: stamp(to),
			RowLimit: limit, RowOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		ids = append(ids, row.ShiftID)
	}
	var crew []sqlcgen.AmbulanceShiftCrew
	if len(ids) > 0 {
		crew, err = q.ListAmbulanceShiftCrew(ctx, ids)
		if err != nil {
			return nil, err
		}
	}
	out := make([]domain.Shift, 0, len(rows))
	for _, row := range rows {
		out = append(out, shiftFrom(row, crew))
	}
	return out, nil
}

// ------------------------------------------------ readiness (SRS-AMB-006)

var _ ports.ReadinessRepository = (*Repository)(nil)

func checkFrom(row sqlcgen.AmbulanceReadinessCheck,
	outcomes []sqlcgen.AmbulanceReadinessOutcome) domain.ReadinessCheck {

	out := domain.ReadinessCheck{
		ID: row.CheckID.String(), TenantID: row.TenantID.String(),
		VehicleID:        row.VehicleID.String(),
		ShiftID:          uuidString(row.ShiftID),
		FacilityID:       uuidString(row.FacilityID),
		OxygenBar:        int(row.OxygenBar),
		OxygenMinimumBar: int(row.OxygenMinimumBar),
		State:            domain.CheckState(row.State),
		Missing:          row.Missing,
		OverrideBy:       row.OverrideBy,
		OverrideReason:   row.OverrideReason,
		OverrideAt:       timeOf(row.OverrideAt),
		ValidUntil:       timeOf(row.ValidUntil),
		CheckedAt:        timeOf(row.CheckedAt),
		CheckedBy:        row.CheckedBy, Version: row.Version,
	}
	for _, outcome := range outcomes {
		if outcome.CheckID != row.CheckID {
			continue
		}
		out.Items = append(out.Items, domain.ReadinessItem{
			Code: outcome.ItemCode, Label: outcome.Label,
			Critical: outcome.Critical,
		})
		out.Outcomes = append(out.Outcomes, domain.ItemOutcome{
			Code: outcome.ItemCode, Present: outcome.Present,
			Note: outcome.Note,
		})
	}
	return out
}

// InsertCheck implements ports.ReadinessRepository.
func (r *Repository) InsertCheck(ctx context.Context,
	scope authctx.TenantScope, c domain.ReadinessCheck) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	vehicleID, err := uuid.Parse(c.VehicleID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertReadinessCheck(ctx,
		sqlcgen.InsertReadinessCheckParams{
			CheckID: id, TenantID: tenantID, VehicleID: vehicleID,
			ShiftID:          optionalUUID(c.ShiftID),
			FacilityID:       optionalUUID(c.FacilityID),
			OxygenBar:        int32(c.OxygenBar),
			OxygenMinimumBar: int32(c.OxygenMinimumBar),
			State:            string(c.State), Missing: texts(c.Missing),
			OverrideBy: c.OverrideBy, OverrideReason: c.OverrideReason,
			OverrideAt: stamp(c.OverrideAt), CheckedBy: c.CheckedBy,
			ValidUntil: stamp(c.ValidUntil), CheckedAt: stamp(c.CheckedAt),
			Version: c.Version,
		}); err != nil {
		return err
	}

	// The checklist and its answers are one row per item: the label and
	// whether it was critical are pinned beside the answer, so a checklist
	// edited next month does not change what this check asked.
	critical := map[string]domain.ReadinessItem{}
	for _, item := range c.Items {
		critical[item.Code] = item
	}
	for _, outcome := range c.Outcomes {
		item := critical[outcome.Code]
		if err := q.InsertReadinessOutcome(ctx,
			sqlcgen.InsertReadinessOutcomeParams{
				CheckID: id, ItemCode: outcome.Code, Label: item.Label,
				Critical: item.Critical, Present: outcome.Present,
				Note: outcome.Note,
			}); err != nil {
			return err
		}
	}
	return nil
}

// checkWith reads a check's outcomes back beside it. The row was already
// fetched under the tenant predicate, so the outcomes are reached by its
// primary key.
func (r *Repository) checkWith(ctx context.Context,
	row sqlcgen.AmbulanceReadinessCheck) (domain.ReadinessCheck, error) {

	outcomes, err := r.queries(ctx).ListReadinessOutcomes(ctx,
		[]uuid.UUID{row.CheckID})
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	return checkFrom(row, outcomes), nil
}

// Check implements ports.ReadinessRepository.
func (r *Repository) Check(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.ReadinessCheck, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.ReadinessCheck{}, notFound()
	}

	row, err := r.queries(ctx).GetReadinessCheck(ctx,
		sqlcgen.GetReadinessCheckParams{TenantID: tenantID,
			CheckID: parsed})
	if isNoRows(err) {
		return domain.ReadinessCheck{}, notFound()
	}
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	return r.checkWith(ctx, row)
}

// LatestCheck implements ports.ReadinessRepository.
func (r *Repository) LatestCheck(ctx context.Context,
	scope authctx.TenantScope, vehicleID string) (
	domain.ReadinessCheck, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	parsed, err := uuid.Parse(vehicleID)
	if err != nil {
		return domain.ReadinessCheck{}, notFound()
	}

	row, err := r.queries(ctx).LatestReadinessCheck(ctx,
		sqlcgen.LatestReadinessCheckParams{TenantID: tenantID,
			VehicleID: parsed})
	if isNoRows(err) {
		return domain.ReadinessCheck{}, notFound()
	}
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	return r.checkWith(ctx, row)
}

// UpdateOverride implements ports.ReadinessRepository.
//
// The only write that touches a recorded check, and it changes the override
// columns alone: the outcomes stay as they were found.
func (r *Repository) UpdateOverride(ctx context.Context,
	scope authctx.TenantScope, c domain.ReadinessCheck,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateReadinessOverride(ctx,
		sqlcgen.UpdateReadinessOverrideParams{
			TenantID: tenantID, CheckID: id, State: string(c.State),
			OverrideBy: c.OverrideBy, OverrideReason: c.OverrideReason,
			OverrideAt:      stamp(c.OverrideAt),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Checks implements ports.ReadinessRepository.
func (r *Repository) Checks(ctx context.Context, scope authctx.TenantScope,
	f ports.CheckFilter) ([]domain.ReadinessCheck, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	states := make([]string, 0, len(f.States))
	for _, s := range f.States {
		states = append(states, string(s))
	}

	q := r.queries(ctx)
	rows, err := q.ListReadinessChecks(ctx,
		sqlcgen.ListReadinessChecksParams{
			TenantID: tenantID, VehicleID: f.VehicleID,
			FacilityID: f.FacilityID, States: texts(states),
			WindowFrom: stamp(from), WindowTo: stamp(to),
			RowLimit: limit, RowOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		ids = append(ids, row.CheckID)
	}
	var outcomes []sqlcgen.AmbulanceReadinessOutcome
	if len(ids) > 0 {
		outcomes, err = q.ListReadinessOutcomes(ctx, ids)
		if err != nil {
			return nil, err
		}
	}
	out := make([]domain.ReadinessCheck, 0, len(rows))
	for _, row := range rows {
		out = append(out, checkFrom(row, outcomes))
	}
	return out, nil
}
