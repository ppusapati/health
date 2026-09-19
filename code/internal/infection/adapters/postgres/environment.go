package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// InsertLimit stores a new revision of an environmental limit (SRS-IPC-009).
func (r *Repository) InsertLimit(ctx context.Context,
	scope authctx.TenantScope, l domain.EnvironmentalLimit) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	limitID, err := uuid.Parse(l.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_LIMIT_ID_INVALID",
			"limit id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionLimit(ctx,
		sqlcgen.InsertInfectionLimitParams{
			LimitID: limitID, TenantID: tenantID, Code: l.Code,
			Name: l.Name, Revision: int32(l.Revision),
			SampleKind: string(l.SampleKind), Unit: l.Unit,
			ActionLevel: l.ActionLevel, FailLevel: l.FailLevel,
			DetectionFails: l.DetectionFails,
			BelowIsFailure: l.BelowIsFailure,
			EffectiveFrom:  stamp(l.EffectiveFrom),
			CreatedAt:      stamp(l.CreatedAt), CreatedBy: l.CreatedBy,
		})
}

// Limit reads one limit revision.
func (r *Repository) Limit(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.EnvironmentalLimit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.EnvironmentalLimit{}, err
	}
	limitID, err := uuid.Parse(id)
	if err != nil {
		return domain.EnvironmentalLimit{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionLimit(ctx,
		sqlcgen.GetInfectionLimitParams{TenantID: tenantID, LimitID: limitID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.EnvironmentalLimit{}, notFound()
	}
	if err != nil {
		return domain.EnvironmentalLimit{}, err
	}
	return limitFrom(row), nil
}

// ApproveLimit signs a limit off.
func (r *Repository) ApproveLimit(ctx context.Context,
	scope authctx.TenantScope, l domain.EnvironmentalLimit) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	limitID, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveInfectionLimit(ctx,
		sqlcgen.ApproveInfectionLimitParams{
			ApprovedBy: l.ApprovedBy, ApprovedAt: stamp(l.ApprovedAt),
			EffectiveFrom: stamp(l.EffectiveFrom),
			TenantID:      tenantID, LimitID: limitID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("IPC_LIMIT_ALREADY_APPROVED",
			"this limit is already approved")
	}
	return nil
}

// SupersedeEarlierLimits closes off every earlier revision of a limit code.
func (r *Repository) SupersedeEarlierLimits(ctx context.Context,
	scope authctx.TenantScope, code string, revision int, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).SupersedeInfectionLimit(ctx,
		sqlcgen.SupersedeInfectionLimitParams{
			SupersededAt: stamp(at), TenantID: tenantID, Code: code,
			Revision: int32(revision),
		})
	return err
}

// Limits lists the versions a result is judged against.
func (r *Repository) Limits(ctx context.Context, scope authctx.TenantScope,
	kind domain.SampleKind, liveAt time.Time) (
	[]domain.EnvironmentalLimit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	at := liveAt
	if at.IsZero() {
		at = epoch
	}

	rows, err := r.queries(ctx).ListInfectionLimits(ctx,
		sqlcgen.ListInfectionLimitsParams{
			TenantID: tenantID, SampleKind: string(kind),
			LiveOnly: !liveAt.IsZero(), At: stamp(at),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.EnvironmentalLimit, 0, len(rows))
	for _, row := range rows {
		out = append(out, limitFrom(row))
	}
	return out, nil
}

func limitFrom(
	row sqlcgen.InfectionEnvironmentalLimit) domain.EnvironmentalLimit {

	return domain.EnvironmentalLimit{
		ID: row.LimitID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		SampleKind: domain.SampleKind(row.SampleKind), Unit: row.Unit,
		ActionLevel: row.ActionLevel, FailLevel: row.FailLevel,
		DetectionFails: row.DetectionFails,
		BelowIsFailure: row.BelowIsFailure,
		Approved:       row.Approved, ApprovedBy: row.ApprovedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
	}
}

// InsertPlan configures a sampling schedule (SRS-IPC-009).
func (r *Repository) InsertPlan(ctx context.Context,
	scope authctx.TenantScope, p domain.SamplingPlan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	planID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_PLAN_ID_INVALID", "plan id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionSamplingPlan(ctx,
		sqlcgen.InsertInfectionSamplingPlanParams{
			PlanID: planID, TenantID: tenantID, Code: p.Code,
			SampleKind: string(p.Kind), FacilityID: p.FacilityID,
			LocationID: p.LocationID, SamplePoint: p.SamplePoint,
			EveryDays: int32(p.EveryDays), Active: p.Active,
			StartedAt: stamp(p.StartedAt),
		})
}

// StopPlan retires a schedule. The row stays: a point that used to be
// sampled and is not any more is a decision somebody made.
func (r *Repository) StopPlan(ctx context.Context, scope authctx.TenantScope,
	planID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(planID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).StopInfectionSamplingPlan(ctx,
		sqlcgen.StopInfectionSamplingPlanParams{
			StoppedAt: stamp(at), TenantID: tenantID, PlanID: id,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// Plans lists sampling schedules.
func (r *Repository) Plans(ctx context.Context, scope authctx.TenantScope,
	locationID string, activeOnly bool) ([]domain.SamplingPlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListInfectionSamplingPlans(ctx,
		sqlcgen.ListInfectionSamplingPlansParams{
			TenantID: tenantID, LocationID: locationID,
			ActiveOnly: activeOnly,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.SamplingPlan, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.SamplingPlan{
			ID: row.PlanID.String(), TenantID: row.TenantID.String(),
			Code: row.Code, Kind: domain.SampleKind(row.SampleKind),
			FacilityID: row.FacilityID, LocationID: row.LocationID,
			SamplePoint: row.SamplePoint, EveryDays: int(row.EveryDays),
			Active:    row.Active,
			StartedAt: timeOf(row.StartedAt),
			StoppedAt: timeOf(row.StoppedAt),
		})
	}
	return out, nil
}

// InsertSample records a collection (SRS-IPC-009).
func (r *Repository) InsertSample(ctx context.Context,
	scope authctx.TenantScope, s domain.EnvironmentalSample) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	sampleID, err := uuid.Parse(s.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_SAMPLE_ID_INVALID",
			"sample id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionSample(ctx,
		sqlcgen.InsertInfectionSampleParams{
			SampleID: sampleID, TenantID: tenantID, Reference: s.Reference,
			SampleKind: string(s.Kind), FacilityID: s.FacilityID,
			LocationID: s.LocationID, SamplePoint: s.SamplePoint,
			PlanID:      optionalUUID(s.PlanID),
			OutbreakID:  optionalUUID(s.OutbreakID),
			RepeatOfID:  optionalUUID(s.RepeatOfID),
			CollectedAt: stamp(s.CollectedAt), CollectedBy: s.CollectedBy,
			Method: s.Method, State: string(s.State),
		})
}

// Sample reads one environmental sample.
func (r *Repository) Sample(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.EnvironmentalSample, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.EnvironmentalSample{}, err
	}
	sampleID, err := uuid.Parse(id)
	if err != nil {
		return domain.EnvironmentalSample{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionSample(ctx,
		sqlcgen.GetInfectionSampleParams{
			TenantID: tenantID, SampleID: sampleID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.EnvironmentalSample{}, notFound()
	}
	if err != nil {
		return domain.EnvironmentalSample{}, err
	}
	return sampleFrom(row), nil
}

// UpdateSample files a result or closes a sample.
func (r *Repository) UpdateSample(ctx context.Context,
	scope authctx.TenantScope, s domain.EnvironmentalSample,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	sampleID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionSample(ctx,
		sqlcgen.UpdateInfectionSampleParams{
			State: string(s.State), LabReference: s.LabReference,
			Value: s.Value, Unit: s.Unit, Organism: s.Organism,
			Detected:   s.Detected,
			ResultedAt: stamp(s.ResultedAt), ResultedBy: s.ResultedBy,
			Outcome: string(s.Outcome), LimitCode: s.LimitCode,
			LimitRevision: int32(s.LimitRevision),
			ClosedAt:      stamp(s.ClosedAt), ClosedBy: s.ClosedBy,
			TenantID: tenantID, SampleID: sampleID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Samples lists environmental results.
func (r *Repository) Samples(ctx context.Context, scope authctx.TenantScope,
	f ports.SampleFilter) ([]domain.EnvironmentalSample, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListInfectionSamples(ctx,
		sqlcgen.ListInfectionSamplesParams{
			TenantID: tenantID, LocationID: f.LocationID,
			SampleKind: string(f.Kind), FailingOnly: f.FailingOnly,
			CollectedFrom: stamp(from), CollectedTo: stamp(to),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.EnvironmentalSample, 0, len(rows))
	for _, row := range rows {
		out = append(out, sampleFrom(row))
	}
	return out, nil
}

func sampleFrom(
	row sqlcgen.InfectionEnvironmentalSample) domain.EnvironmentalSample {

	return domain.EnvironmentalSample{
		ID: row.SampleID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Kind: domain.SampleKind(row.SampleKind),
		FacilityID: row.FacilityID, LocationID: row.LocationID,
		SamplePoint: row.SamplePoint, PlanID: uuidString(row.PlanID),
		OutbreakID:  uuidString(row.OutbreakID),
		RepeatOfID:  uuidString(row.RepeatOfID),
		CollectedAt: timeOf(row.CollectedAt), CollectedBy: row.CollectedBy,
		Method: row.Method, State: domain.SampleState(row.State),
		LabReference: row.LabReference, Value: row.Value, Unit: row.Unit,
		Organism: row.Organism, Detected: row.Detected,
		ResultedAt: timeOf(row.ResultedAt), ResultedBy: row.ResultedBy,
		Outcome: domain.Outcome(row.Outcome), LimitCode: row.LimitCode,
		LimitRevision: int(row.LimitRevision),
		ClosedAt:      timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		Version: row.Version,
	}
}

// InsertAction opens a corrective action against a failing sample
// (SRS-IPC-009).
func (r *Repository) InsertAction(ctx context.Context,
	scope authctx.TenantScope, a domain.CorrectiveAction) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	actionID, err := uuid.Parse(a.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_ACTION_ID_INVALID",
			"action id must be a UUID")
	}
	sampleID, err := uuid.Parse(a.SampleID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertInfectionCorrectiveAction(ctx,
		sqlcgen.InsertInfectionCorrectiveActionParams{
			ActionID: actionID, TenantID: tenantID, SampleID: sampleID,
			LocationID: a.LocationID, Action: a.Action, Owner: a.Owner,
			DueBy: stamp(a.DueBy), State: string(a.State),
		})
}

// Action reads one corrective action.
func (r *Repository) Action(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.CorrectiveAction, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CorrectiveAction{}, err
	}
	actionID, err := uuid.Parse(id)
	if err != nil {
		return domain.CorrectiveAction{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionCorrectiveAction(ctx,
		sqlcgen.GetInfectionCorrectiveActionParams{
			TenantID: tenantID, ActionID: actionID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CorrectiveAction{}, notFound()
	}
	if err != nil {
		return domain.CorrectiveAction{}, err
	}
	return actionFrom(row), nil
}

// UpdateAction records the work or its verification.
func (r *Repository) UpdateAction(ctx context.Context,
	scope authctx.TenantScope, a domain.CorrectiveAction,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	actionID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionCorrectiveAction(ctx,
		sqlcgen.UpdateInfectionCorrectiveActionParams{
			State: string(a.State), DoneAt: stamp(a.DoneAt),
			DoneBy: a.DoneBy, DoneNote: a.DoneNote,
			RepeatSampleID: optionalUUID(a.RepeatSampleID),
			VerifiedAt:     stamp(a.VerifiedAt), VerifiedBy: a.VerifiedBy,
			TenantID: tenantID, ActionID: actionID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Actions lists a sample's corrective actions, or every open one.
func (r *Repository) Actions(ctx context.Context, scope authctx.TenantScope,
	sampleID string, openOnly bool) ([]domain.CorrectiveAction, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	// uuid.Nil is the "every sample" filter. A NULL parameter would make the
	// generated signature nullable and the call site's intent invisible.
	id := uuid.Nil
	if sampleID != "" {
		parsed, err := uuid.Parse(sampleID)
		if err != nil {
			return nil, notFound()
		}
		id = parsed
	}

	rows, err := r.queries(ctx).ListInfectionCorrectiveActions(ctx,
		sqlcgen.ListInfectionCorrectiveActionsParams{
			TenantID: tenantID, SampleID: id, OpenOnly: openOnly,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.CorrectiveAction, 0, len(rows))
	for _, row := range rows {
		out = append(out, actionFrom(row))
	}
	return out, nil
}

func actionFrom(
	row sqlcgen.InfectionCorrectiveAction) domain.CorrectiveAction {

	return domain.CorrectiveAction{
		ID: row.ActionID.String(), TenantID: row.TenantID.String(),
		SampleID: row.SampleID.String(), LocationID: row.LocationID,
		Action: row.Action, Owner: row.Owner, DueBy: timeOf(row.DueBy),
		State:  domain.ActionState(row.State),
		DoneAt: timeOf(row.DoneAt), DoneBy: row.DoneBy,
		DoneNote:       row.DoneNote,
		RepeatSampleID: uuidString(row.RepeatSampleID),
		VerifiedAt:     timeOf(row.VerifiedAt), VerifiedBy: row.VerifiedBy,
		Version: row.Version,
	}
}

// Compile-time proof that this adapter satisfies every port it claims.
var (
	_ ports.CaseRepository        = (*Repository)(nil)
	_ ports.DeviceDayRepository   = (*Repository)(nil)
	_ ports.IsolationRepository   = (*Repository)(nil)
	_ ports.AlertRepository       = (*Repository)(nil)
	_ ports.OutbreakRepository    = (*Repository)(nil)
	_ ports.HygieneRepository     = (*Repository)(nil)
	_ ports.ExposureRepository    = (*Repository)(nil)
	_ ports.StewardshipRepository = (*Repository)(nil)
	_ ports.EnvironmentRepository = (*Repository)(nil)
)
