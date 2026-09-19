package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// InvestigationRepo implements ports.InvestigationRepository.
type InvestigationRepo struct{ *Repository }

var _ ports.InvestigationRepository = InvestigationRepo{}

// InsertRCA opens an analysis (SRS-QMS-003).
func (r InvestigationRepo) InsertRCA(ctx context.Context,
	scope authctx.TenantScope, a domain.RCA) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	rcaID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}
	incidentID, err := uuid.Parse(a.IncidentID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityRCA(ctx, sqlcgen.InsertQualityRCAParams{
		RcaID: rcaID, TenantID: tenantID, IncidentID: incidentID,
		Method: a.Method, State: string(a.State), Restricted: a.Restricted,
		OpenedAt: stamp(a.OpenedAt), OpenedBy: a.OpenedBy,
	})
}

// RCA reads one analysis.
func (r InvestigationRepo) RCA(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.RCA, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.RCA{}, err
	}
	rcaID, err := uuid.Parse(id)
	if err != nil {
		return domain.RCA{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityRCA(ctx, sqlcgen.GetQualityRCAParams{
		TenantID: tenantID, RcaID: rcaID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.RCA{}, notFound()
	}
	if err != nil {
		return domain.RCA{}, err
	}
	return rcaFrom(row), nil
}

// RCAForIncident reaches the analysis from the incident.
func (r InvestigationRepo) RCAForIncident(ctx context.Context,
	scope authctx.TenantScope, incidentID string) (domain.RCA, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.RCA{}, false, err
	}
	parsed, err := uuid.Parse(incidentID)
	if err != nil {
		return domain.RCA{}, false, nil
	}

	row, err := r.queries(ctx).GetQualityRCAForIncident(ctx,
		sqlcgen.GetQualityRCAForIncidentParams{
			TenantID: tenantID, IncidentID: parsed,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.RCA{}, false, nil
	}
	if err != nil {
		return domain.RCA{}, false, err
	}
	return rcaFrom(row), true, nil
}

// UpdateRCA writes a completed analysis (SRS-QMS-003).
func (r InvestigationRepo) UpdateRCA(ctx context.Context,
	scope authctx.TenantScope, a domain.RCA, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	rcaID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityRCA(ctx,
		sqlcgen.UpdateQualityRCAParams{
			TenantID: tenantID, RcaID: rcaID,
			AccountableOwner: a.AccountableOwner, Findings: a.Findings,
			NoActionReason: a.NoActionReason, State: string(a.State),
			ClosedAt: stamp(a.ClosedAt), ClosedBy: a.ClosedBy,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// AddFactor records a contributing factor (SRS-QMS-003).
func (r InvestigationRepo) AddFactor(ctx context.Context,
	scope authctx.TenantScope, rcaID, factorID string,
	f domain.ContributingFactor) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsedRCA, err := uuid.Parse(rcaID)
	if err != nil {
		return notFound()
	}
	parsedFactor, err := uuid.Parse(factorID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityRCAFactor(ctx,
		sqlcgen.InsertQualityRCAFactorParams{
			FactorID: parsedFactor, TenantID: tenantID, RcaID: parsedRCA,
			Category: string(f.Category), Detail: f.Detail, Root: f.Root,
		})
}

// Factors lists what contributed.
func (r InvestigationRepo) Factors(ctx context.Context,
	scope authctx.TenantScope, rcaID string) ([]domain.ContributingFactor,
	error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(rcaID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListQualityRCAFactors(ctx,
		sqlcgen.ListQualityRCAFactorsParams{TenantID: tenantID, RcaID: parsed})
	if err != nil {
		return nil, err
	}

	out := make([]domain.ContributingFactor, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.ContributingFactor{
			Category: domain.FactorCategory(row.Category),
			Detail:   row.Detail, Root: row.Root,
		})
	}
	return out, nil
}

func rcaFrom(row sqlcgen.QualityRca) domain.RCA {
	return domain.RCA{
		ID: row.RcaID.String(), TenantID: row.TenantID.String(),
		IncidentID: row.IncidentID.String(), Method: row.Method,
		AccountableOwner: row.AccountableOwner, Findings: row.Findings,
		NoActionReason: row.NoActionReason,
		State:          domain.RCAState(row.State), Restricted: row.Restricted,
		OpenedAt: timeOf(row.OpenedAt), OpenedBy: row.OpenedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		Version: row.Version,
	}
}

// ActionRepo implements ports.ActionRepository.
type ActionRepo struct{ *Repository }

var _ ports.ActionRepository = ActionRepo{}

// InsertCAPA raises an action (SRS-QMS-004).
func (r ActionRepo) InsertCAPA(ctx context.Context, scope authctx.TenantScope,
	c domain.CAPA) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	capaID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityCAPA(ctx, sqlcgen.InsertQualityCAPAParams{
		CapaID: capaID, TenantID: tenantID, Reference: c.Reference,
		Kind: string(c.Kind), SourceKind: string(c.SourceKind),
		SourceID: c.SourceID, Action: c.Action, OwnerID: c.OwnerID,
		DueOn:              stamp(c.DueOn),
		EffectivenessDueOn: stamp(c.EffectivenessDueOn),
		State:              string(c.State), Restricted: c.Restricted,
		RaisedAt: stamp(c.RaisedAt), RaisedBy: c.RaisedBy,
	})
}

// CAPA reads one action with its checks.
func (r ActionRepo) CAPA(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.CAPA, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CAPA{}, err
	}
	capaID, err := uuid.Parse(id)
	if err != nil {
		return domain.CAPA{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityCAPA(ctx, sqlcgen.GetQualityCAPAParams{
		TenantID: tenantID, CapaID: capaID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CAPA{}, notFound()
	}
	if err != nil {
		return domain.CAPA{}, err
	}

	// The checks come with the action, always. Every rule that decides whether
	// an action may close reads them, and an action loaded without them would
	// look unchecked.
	checks, err := r.queries(ctx).ListQualityCAPAChecks(ctx,
		sqlcgen.ListQualityCAPAChecksParams{TenantID: tenantID, CapaID: capaID})
	if err != nil {
		return domain.CAPA{}, err
	}

	capa := capaFrom(row)
	for _, check := range checks {
		capa.Checks = append(capa.Checks, domain.EffectivenessCheck{
			CheckedAt: timeOf(check.CheckedAt), CheckedBy: check.CheckedBy,
			Effective: check.Effective, Evidence: check.Evidence,
		})
	}
	return capa, nil
}

// UpdateCAPA writes a state change (SRS-QMS-004).
func (r ActionRepo) UpdateCAPA(ctx context.Context, scope authctx.TenantScope,
	c domain.CAPA, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	capaID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityCAPA(ctx,
		sqlcgen.UpdateQualityCAPAParams{
			TenantID: tenantID, CapaID: capaID, State: string(c.State),
			ApprovedBy: c.ApprovedBy, ApprovedAt: stamp(c.ApprovedAt),
			ClosedBy: c.ClosedBy, ClosedAt: stamp(c.ClosedAt),
			ClosureNote: c.ClosureNote, CancelledReason: c.CancelledReason,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// CAPAs lists actions.
func (r ActionRepo) CAPAs(ctx context.Context, scope authctx.TenantScope,
	f ports.CAPAFilter) ([]domain.CAPA, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListQualityCAPAs(ctx,
		sqlcgen.ListQualityCAPAsParams{
			TenantID: tenantID, SourceKind: f.SourceKind,
			SourceID: f.SourceID, OwnerID: f.OwnerID,
			LiveOnly: f.LiveOnly, RowLimit: f.Limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.CAPA, 0, len(rows))
	for _, row := range rows {
		capa := capaFrom(row)
		// The overdue report reads Effective(), which reads the checks. A list
		// loaded without them would report every action as unchecked and
		// escalate the whole hospital.
		checks, err := r.queries(ctx).ListQualityCAPAChecks(ctx,
			sqlcgen.ListQualityCAPAChecksParams{
				TenantID: tenantID, CapaID: row.CapaID,
			})
		if err != nil {
			return nil, err
		}
		for _, check := range checks {
			capa.Checks = append(capa.Checks, domain.EffectivenessCheck{
				CheckedAt: timeOf(check.CheckedAt), CheckedBy: check.CheckedBy,
				Effective: check.Effective, Evidence: check.Evidence,
			})
		}
		out = append(out, capa)
	}
	return out, nil
}

// CountForSource is what an analysis closing checks.
func (r ActionRepo) CountForSource(ctx context.Context,
	scope authctx.TenantScope, sourceKind, sourceID string) (int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	count, err := r.queries(ctx).CountQualityLiveCAPAsForSource(ctx,
		sqlcgen.CountQualityLiveCAPAsForSourceParams{
			TenantID: tenantID, SourceKind: sourceKind, SourceID: sourceID,
		})
	if err != nil {
		return 0, err
	}
	return int(count), nil
}

// AppendCheck records an effectiveness review, including a failed one
// (SRS-QMS-004).
func (r ActionRepo) AppendCheck(ctx context.Context, scope authctx.TenantScope,
	capaID, checkID string, check domain.EffectivenessCheck) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsedCAPA, err := uuid.Parse(capaID)
	if err != nil {
		return notFound()
	}
	parsedCheck, err := uuid.Parse(checkID)
	if err != nil {
		return notFound()
	}

	at := check.CheckedAt
	if at.IsZero() {
		at = time.Now().UTC()
	}
	return r.queries(ctx).InsertQualityCAPACheck(ctx,
		sqlcgen.InsertQualityCAPACheckParams{
			CheckID: parsedCheck, TenantID: tenantID, CapaID: parsedCAPA,
			CheckedAt: stamp(at), CheckedBy: check.CheckedBy,
			Effective: check.Effective, Evidence: check.Evidence,
		})
}

func capaFrom(row sqlcgen.QualityCapa) domain.CAPA {
	return domain.CAPA{
		ID: row.CapaID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Kind: domain.ActionKind(row.Kind),
		SourceKind: domain.SourceKind(row.SourceKind), SourceID: row.SourceID,
		Action: row.Action, OwnerID: row.OwnerID,
		DueOn:              timeOf(row.DueOn),
		EffectivenessDueOn: timeOf(row.EffectivenessDueOn),
		State:              domain.CAPAState(row.State),
		ApprovedBy:         row.ApprovedBy, ApprovedAt: timeOf(row.ApprovedAt),
		ClosedBy: row.ClosedBy, ClosedAt: timeOf(row.ClosedAt),
		ClosureNote: row.ClosureNote, CancelledReason: row.CancelledReason,
		Restricted: row.Restricted,
		RaisedAt:   timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		Version: row.Version,
	}
}
