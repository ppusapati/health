package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/emergency/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Triage, overrides, pathways and the timeline.

// InsertTriage records one assessment.
func (r VisitRepo) InsertTriage(ctx context.Context, scope authctx.TenantScope,
	t domain.Triage) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	triageID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	visitID, err := uuid.Parse(t.VisitID)
	if err != nil {
		return notFound()
	}

	flags := make([]string, 0, len(t.RedFlags))
	for _, flag := range t.RedFlags {
		flags = append(flags, string(flag))
	}

	return r.queries(ctx).InsertTriage(ctx, sqlcgen.InsertTriageParams{
		TriageID: triageID, TenantID: tenantID, VisitID: visitID,
		ScaleName: t.ScaleName, ScaleVersion: t.ScaleVersion,
		AcuityCode: t.AcuityCode, AcuityRank: int32(t.AcuityRank),
		RespiratoryRate:  intOrNull(t.RespiratoryRate),
		HeartRate:        intOrNull(t.HeartRate),
		SystolicBp:       intOrNull(t.SystolicBP),
		OxygenSaturation: intOrNull(t.OxygenSaturation),
		Temperature:      t.Temperature,
		PainScore:        intOrNull(t.PainScore),
		Consciousness:    t.Consciousness,
		RedFlags:         flags,
		// Stored rather than recomputed on read: what a department required at
		// triage is configurable and may have changed since, and a gap
		// recorded under yesterday's rules is still the gap that existed.
		MissingFields: t.Missing,
		Note:          t.Note,
		AssessedBy:    t.AssessedBy, AssessedAt: stamp(t.AssessedAt),
	})
}

func intOrNull(v *int) *int32 {
	if v == nil {
		return nil
	}
	out := int32(*v)
	return &out
}

func intOrNil(v *int32) *int {
	if v == nil {
		return nil
	}
	out := int(*v)
	return &out
}

// LatestTriage is the acuity the queue sorts on.
func (r VisitRepo) LatestTriage(ctx context.Context, scope authctx.TenantScope,
	visitID string) (domain.Triage, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Triage{}, false, err
	}
	id, err := uuid.Parse(visitID)
	if err != nil {
		return domain.Triage{}, false, notFound()
	}

	row, err := r.queries(ctx).LatestTriage(ctx, sqlcgen.LatestTriageParams{
		TenantID: tenantID, VisitID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		// Not an error. A patient nobody has assessed is the ordinary state of
		// somebody who walked in ninety seconds ago.
		return domain.Triage{}, false, nil
	}
	if err != nil {
		return domain.Triage{}, false, err
	}
	return triageFromRow(row), true, nil
}

// ListTriage returns every assessment, newest first.
func (r VisitRepo) ListTriage(ctx context.Context, scope authctx.TenantScope,
	visitID string) ([]domain.Triage, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(visitID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTriage(ctx, sqlcgen.ListTriageParams{
		TenantID: tenantID, VisitID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Triage, 0, len(rows))
	for _, row := range rows {
		out = append(out, triageFromRow(row))
	}
	return out, nil
}

func triageFromRow(row sqlcgen.EmergencyTriage) domain.Triage {
	flags := make([]domain.RedFlag, 0, len(row.RedFlags))
	for _, flag := range row.RedFlags {
		flags = append(flags, domain.RedFlag(flag))
	}
	return domain.Triage{
		ID: row.TriageID.String(), TenantID: row.TenantID.String(),
		VisitID:      row.VisitID.String(),
		ScaleName:    row.ScaleName,
		ScaleVersion: row.ScaleVersion,
		AcuityCode:   row.AcuityCode, AcuityRank: int(row.AcuityRank),
		RespiratoryRate:  intOrNil(row.RespiratoryRate),
		HeartRate:        intOrNil(row.HeartRate),
		SystolicBP:       intOrNil(row.SystolicBp),
		OxygenSaturation: intOrNil(row.OxygenSaturation),
		Temperature:      row.Temperature,
		PainScore:        intOrNil(row.PainScore),
		Consciousness:    row.Consciousness,
		RedFlags:         flags,
		Missing:          row.MissingFields,
		Note:             row.Note,
		AssessedBy:       row.AssessedBy,
		AssessedAt:       timeOf(row.AssessedAt),
	}
}

// InsertOverride records a clinician moving a patient in the queue.
func (r VisitRepo) InsertOverride(ctx context.Context, scope authctx.TenantScope,
	visitID string, o domain.PriorityOverride) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(visitID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertPriorityOverride(ctx,
		sqlcgen.InsertPriorityOverrideParams{
			OverrideID: uuid.New(), TenantID: tenantID, VisitID: id,
			AcuityRank: int32(o.Rank), Reason: o.Reason,
			OverriddenBy: o.By, OverriddenAt: stamp(o.At),
		})
}

// LatestOverride is the override the queue applies.
func (r VisitRepo) LatestOverride(ctx context.Context, scope authctx.TenantScope,
	visitID string) (domain.PriorityOverride, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PriorityOverride{}, false, err
	}
	id, err := uuid.Parse(visitID)
	if err != nil {
		return domain.PriorityOverride{}, false, notFound()
	}

	row, err := r.queries(ctx).LatestPriorityOverride(ctx,
		sqlcgen.LatestPriorityOverrideParams{TenantID: tenantID, VisitID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PriorityOverride{}, false, nil
	}
	if err != nil {
		return domain.PriorityOverride{}, false, err
	}
	return domain.PriorityOverride{
		Rank: int(row.AcuityRank), Reason: row.Reason,
		By: row.OverriddenBy, At: timeOf(row.OverriddenAt),
	}, true, nil
}

// InsertPathway records a time-critical activation and its targets.
func (r VisitRepo) InsertPathway(ctx context.Context, scope authctx.TenantScope,
	p domain.Pathway) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	pathwayID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	visitID, err := uuid.Parse(p.VisitID)
	if err != nil {
		return notFound()
	}
	noticeID, err := optionalUUID(p.EscalationNoticeID)
	if err != nil {
		return err
	}

	q := r.queries(ctx)
	if err := q.InsertPathway(ctx, sqlcgen.InsertPathwayParams{
		PathwayID: pathwayID, TenantID: tenantID, VisitID: visitID,
		Kind: string(p.Kind), Label: p.Label,
		ActivatedAt: stamp(p.ActivatedAt), ActivatedBy: p.ActivatedBy,
		NotifiedTeam: p.NotifiedTeam, EscalationNoticeID: noticeID,
	}); err != nil {
		return err
	}

	// Targets are stored per activation rather than looked up, for the reason
	// an observation's reference range is: guidelines are revised, and
	// measuring a two-year-old activation against today's target would
	// reinterpret history.
	for _, target := range p.Targets {
		if err := q.InsertPathwayTarget(ctx, sqlcgen.InsertPathwayTargetParams{
			PathwayID: pathwayID, Code: target.Code, Label: target.Label,
			WithinSeconds: int64(target.Within / time.Second),
		}); err != nil {
			return err
		}
	}
	return nil
}

// ListPathways returns a visit's activations with their targets.
func (r VisitRepo) ListPathways(ctx context.Context, scope authctx.TenantScope,
	visitID string) ([]domain.Pathway, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(visitID)
	if err != nil {
		return nil, notFound()
	}

	q := r.queries(ctx)
	rows, err := q.ListPathways(ctx, sqlcgen.ListPathwaysParams{
		TenantID: tenantID, VisitID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Pathway, 0, len(rows))
	for _, row := range rows {
		p := domain.Pathway{
			ID: row.PathwayID.String(), TenantID: row.TenantID.String(),
			VisitID: row.VisitID.String(),
			Kind:    domain.PathwayKind(row.Kind), Label: row.Label,
			ActivatedAt: timeOf(row.ActivatedAt), ActivatedBy: row.ActivatedBy,
			NotifiedTeam:       row.NotifiedTeam,
			EscalationNoticeID: uuidOrEmpty(row.EscalationNoticeID),
			StoodDownAt:        timeOf(row.StoodDownAt),
			StoodDownReason:    row.StoodDownReason,
		}
		if !domain.KnownPathwayKind(row.Kind) {
			p.Kind = domain.PathwayUnknown
		}

		targets, err := q.ListPathwayTargets(ctx, row.PathwayID)
		if err != nil {
			return nil, err
		}
		for _, target := range targets {
			p.Targets = append(p.Targets, domain.MilestoneTarget{
				Code: target.Code, Label: target.Label,
				Within: time.Duration(target.WithinSeconds) * time.Second,
			})
		}
		out = append(out, p)
	}
	return out, nil
}

// ActivePathways is what the board flashes, by visit.
func (r VisitRepo) ActivePathways(ctx context.Context, scope authctx.TenantScope,
	facilityID string) (map[string][]domain.PathwayKind, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListActivePathways(ctx, sqlcgen.ListActivePathwaysParams{
		TenantID: tenantID, FacilityFilter: facilityID,
	})
	if err != nil {
		return nil, err
	}
	out := map[string][]domain.PathwayKind{}
	for _, row := range rows {
		kind := domain.PathwayKind(row.Kind)
		if !domain.KnownPathwayKind(row.Kind) {
			kind = domain.PathwayUnknown
		}
		visitID := row.VisitID.String()
		out[visitID] = append(out[visitID], kind)
	}
	return out, nil
}

// StandDownPathway closes an activation.
func (r VisitRepo) StandDownPathway(ctx context.Context, scope authctx.TenantScope,
	pathwayID, reason string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(pathwayID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).StandDownPathway(ctx, sqlcgen.StandDownPathwayParams{
		TenantID: tenantID, PathwayID: id,
		StoodDownAt: stamp(at), StoodDownReason: reason,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// InsertEvent appends one thing that happened.
func (r VisitRepo) InsertEvent(ctx context.Context, scope authctx.TenantScope,
	e domain.Event) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	eventID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	visitID, err := uuid.Parse(e.VisitID)
	if err != nil {
		return notFound()
	}
	pathwayID, err := optionalUUID(e.PathwayID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertEmergencyEvent(ctx, sqlcgen.InsertEmergencyEventParams{
		EventID: eventID, TenantID: tenantID, VisitID: visitID,
		Kind: string(e.Kind), Detail: e.Detail,
		OccurredAt: stamp(e.OccurredAt), RecordedAt: stamp(e.RecordedAt),
		Sequence: int32(e.Sequence), ActorID: e.ActorID,
		// Stored rather than recomputed: the rule for what counts as late may
		// change, and an entry made under the old one was still made when it
		// was made.
		Late:      e.Late,
		PathwayID: pathwayID, ProtocolID: e.ProtocolID,
		NeedsReconciliation: e.NeedsReconciliation,
	})
}

// Timeline returns a visit's events in the order they happened.
func (r VisitRepo) Timeline(ctx context.Context, scope authctx.TenantScope,
	visitID string) (domain.Timeline, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(visitID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListEmergencyEvents(ctx, sqlcgen.ListEmergencyEventsParams{
		TenantID: tenantID, VisitID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make(domain.Timeline, 0, len(rows))
	for _, row := range rows {
		out = append(out, eventFromRow(row))
	}
	return out, nil
}

// ReconcileEvent discharges a pre-order administration.
func (r VisitRepo) ReconcileEvent(ctx context.Context, scope authctx.TenantScope,
	eventID, orderID string) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(eventID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).ReconcileEmergencyEvent(ctx,
		sqlcgen.ReconcileEmergencyEventParams{
			TenantID: tenantID, EventID: id, ReconciledOrderID: orderID,
		})
	if err != nil {
		return false, err
	}
	// False rather than an error when the debt was already settled: two
	// clinicians writing up the same protocol administration is a race, not a
	// mistake, and the first order is the one that stands.
	return rows > 0, nil
}

// Unreconciled is the department's debt.
func (r VisitRepo) Unreconciled(ctx context.Context, scope authctx.TenantScope,
	facilityID string, limit int32) (domain.Timeline, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if limit <= 0 {
		limit = 100
	}

	rows, err := r.queries(ctx).ListUnreconciledAdministrations(ctx,
		sqlcgen.ListUnreconciledAdministrationsParams{
			TenantID: tenantID, FacilityFilter: facilityID, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make(domain.Timeline, 0, len(rows))
	for _, row := range rows {
		out = append(out, eventFromRow(row))
	}
	return out, nil
}

func eventFromRow(row sqlcgen.EmergencyEvent) domain.Event {
	e := domain.Event{
		ID: row.EventID.String(), TenantID: row.TenantID.String(),
		VisitID: row.VisitID.String(),
		Kind:    domain.EventKind(row.Kind), Detail: row.Detail,
		OccurredAt: timeOf(row.OccurredAt), RecordedAt: timeOf(row.RecordedAt),
		Sequence: int(row.Sequence), ActorID: row.ActorID, Late: row.Late,
		PathwayID: uuidOrEmpty(row.PathwayID), ProtocolID: row.ProtocolID,
		NeedsReconciliation: row.NeedsReconciliation,
		ReconciledOrderID:   row.ReconciledOrderID,
	}
	// An event nobody can classify still happened. Kept and shown rather than
	// dropped: a timeline with a silent hole is worse than one with a question
	// mark.
	if !domain.KnownEventKind(row.Kind) {
		e.Kind = domain.EventUnknown
	}
	return e
}
