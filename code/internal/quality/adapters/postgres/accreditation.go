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

// AccreditationRepo implements ports.AccreditationRepository.
type AccreditationRepo struct{ *Repository }

var _ ports.AccreditationRepository = AccreditationRepo{}

// InsertStandard registers a standard (SRS-QMS-009).
func (r AccreditationRepo) InsertStandard(ctx context.Context,
	scope authctx.TenantScope, s domain.Standard) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	standardID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityStandard(ctx,
		sqlcgen.InsertQualityStandardParams{
			StandardID: standardID, TenantID: tenantID,
			Code: s.Code, Name: s.Name, Edition: s.Edition, Active: s.Active,
			CreatedAt: stamp(s.CreatedAt), CreatedBy: s.CreatedBy,
		})
}

// Standard reads one.
func (r AccreditationRepo) Standard(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Standard, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Standard{}, err
	}
	standardID, err := uuid.Parse(id)
	if err != nil {
		return domain.Standard{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityStandard(ctx,
		sqlcgen.GetQualityStandardParams{
			TenantID: tenantID, StandardID: standardID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Standard{}, notFound()
	}
	if err != nil {
		return domain.Standard{}, err
	}
	return standardFrom(row), nil
}

// Standards lists what the hospital is assessed against.
func (r AccreditationRepo) Standards(ctx context.Context,
	scope authctx.TenantScope, activeOnly bool) ([]domain.Standard, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityStandards(ctx,
		sqlcgen.ListQualityStandardsParams{
			TenantID: tenantID, ActiveOnly: activeOnly,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Standard, 0, len(rows))
	for _, row := range rows {
		out = append(out, standardFrom(row))
	}
	return out, nil
}

// InsertClauses loads a clause set (SRS-QMS-009).
//
// A batch, because a standard arrives as a tree of several hundred clauses and
// a half-loaded standard is a readiness report that says the hospital is doing
// better than it is.
func (r AccreditationRepo) InsertClauses(ctx context.Context,
	scope authctx.TenantScope, clauses []domain.Clause) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	queries := r.queries(ctx)

	for _, clause := range clauses {
		clauseID, err := uuid.Parse(clause.ID)
		if err != nil {
			return notFound()
		}
		standardID, err := uuid.Parse(clause.StandardID)
		if err != nil {
			return notFound()
		}
		if err := queries.InsertQualityClause(ctx,
			sqlcgen.InsertQualityClauseParams{
				ClauseID: clauseID, TenantID: tenantID, StandardID: standardID,
				Reference: clause.Reference, Chapter: clause.Chapter,
				ClauseText: clause.Text, Critical: clause.Critical,
				CreatedAt: stamp(clause.CreatedAt),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Clauses lists a standard's requirements.
func (r AccreditationRepo) Clauses(ctx context.Context,
	scope authctx.TenantScope, standardID string) ([]domain.Clause, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(standardID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListQualityClauses(ctx,
		sqlcgen.ListQualityClausesParams{
			TenantID: tenantID, StandardID: parsed,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Clause, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Clause{
			ID: row.ClauseID.String(), TenantID: row.TenantID.String(),
			StandardID: row.StandardID.String(), Reference: row.Reference,
			Chapter: row.Chapter, Text: row.ClauseText,
			Critical: row.Critical, CreatedAt: timeOf(row.CreatedAt),
			Version: row.Version,
		})
	}
	return out, nil
}

// InsertEvidence files something against a clause (SRS-QMS-009).
func (r AccreditationRepo) InsertEvidence(ctx context.Context,
	scope authctx.TenantScope, e domain.Evidence) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	evidenceID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	clauseID, err := uuid.Parse(e.ClauseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityEvidence(ctx,
		sqlcgen.InsertQualityEvidenceParams{
			EvidenceID: evidenceID, TenantID: tenantID, ClauseID: clauseID,
			Kind: string(e.Kind), RefID: e.RefID,
			ExternalRef: e.ExternalRef, Description: e.Description,
			AddedAt: stamp(e.AddedAt), AddedBy: e.AddedBy,
		})
}

// WithdrawEvidence retires it without deleting it.
func (r AccreditationRepo) WithdrawEvidence(ctx context.Context,
	scope authctx.TenantScope, evidenceID, by, reason string,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := uuid.Parse(evidenceID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).WithdrawQualityEvidence(ctx,
		sqlcgen.WithdrawQualityEvidenceParams{
			TenantID: tenantID, EvidenceID: parsed,
			RemovedAt: stamp(at), RemovedBy: by, RemovedWhy: reason,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// EvidenceForStandard returns evidence keyed by clause, which is how the
// readiness view reads it.
func (r AccreditationRepo) EvidenceForStandard(ctx context.Context,
	scope authctx.TenantScope, standardID string, liveOnly bool) (
	map[string][]domain.Evidence, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(standardID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListQualityEvidenceForStandard(ctx,
		sqlcgen.ListQualityEvidenceForStandardParams{
			TenantID: tenantID, StandardID: parsed, LiveOnly: liveOnly,
		})
	if err != nil {
		return nil, err
	}

	out := map[string][]domain.Evidence{}
	for _, row := range rows {
		clause := row.ClauseID.String()
		out[clause] = append(out[clause], domain.Evidence{
			ID: row.EvidenceID.String(), TenantID: row.TenantID.String(),
			ClauseID: clause, Kind: domain.EvidenceKind(row.Kind),
			RefID: row.RefID, ExternalRef: row.ExternalRef,
			Description: row.Description,
			AddedAt:     timeOf(row.AddedAt), AddedBy: row.AddedBy,
			RemovedAt: timeOf(row.RemovedAt), RemovedBy: row.RemovedBy,
			RemovedWhy: row.RemovedWhy,
		})
	}
	return out, nil
}

// InsertClauseReview records a judgement (SRS-QMS-009).
//
// Appended, never updated: a clause reviewed three times has three judgements,
// and a survey asking what changed since last year is asking for exactly that
// history.
func (r AccreditationRepo) InsertClauseReview(ctx context.Context,
	scope authctx.TenantScope, review domain.ClauseReview) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	reviewID, err := uuid.Parse(review.ID)
	if err != nil {
		return notFound()
	}
	clauseID, err := uuid.Parse(review.ClauseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityClauseReview(ctx,
		sqlcgen.InsertQualityClauseReviewParams{
			ReviewID: reviewID, TenantID: tenantID, ClauseID: clauseID,
			Verdict: string(review.Verdict), Note: review.Note,
			CapaID:     optionalUUID(review.CAPAID),
			ReviewedAt: stamp(review.ReviewedAt), ReviewedBy: review.ReviewedBy,
		})
}

// LatestReviews is one judgement per clause, the most recent.
func (r AccreditationRepo) LatestReviews(ctx context.Context,
	scope authctx.TenantScope, standardID string) (
	map[string]domain.ClauseReview, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(standardID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListQualityLatestClauseReviews(ctx,
		sqlcgen.ListQualityLatestClauseReviewsParams{
			TenantID: tenantID, StandardID: parsed,
		})
	if err != nil {
		return nil, err
	}

	out := map[string]domain.ClauseReview{}
	for _, row := range rows {
		out[row.ClauseID.String()] = domain.ClauseReview{
			ID: row.ReviewID.String(), TenantID: row.TenantID.String(),
			ClauseID: row.ClauseID.String(),
			Verdict:  domain.Verdict(row.Verdict), Note: row.Note,
			CAPAID:     uuidString(row.CapaID),
			ReviewedAt: timeOf(row.ReviewedAt), ReviewedBy: row.ReviewedBy,
		}
	}
	return out, nil
}

func standardFrom(row sqlcgen.QualityStandard) domain.Standard {
	return domain.Standard{
		ID: row.StandardID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Edition: row.Edition,
		Active: row.Active, CreatedAt: timeOf(row.CreatedAt),
		CreatedBy: row.CreatedBy, Version: row.Version,
	}
}

// IndicatorRepo implements ports.IndicatorRepository.
type IndicatorRepo struct{ *Repository }

var _ ports.IndicatorRepository = IndicatorRepo{}

// InsertDefinition adds a dictionary revision (SRS-QMS-010).
func (r IndicatorRepo) InsertDefinition(ctx context.Context,
	scope authctx.TenantScope, d domain.KPIDefinition) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	definitionID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityKPIDefinition(ctx,
		sqlcgen.InsertQualityKPIDefinitionParams{
			DefinitionID: definitionID, TenantID: tenantID,
			Code: d.Code, Name: d.Name, Revision: int32(d.Revision),
			Numerator: d.Numerator, Denominator: d.Denominator, Unit: d.Unit,
			TargetPermille: int32(d.TargetPermille),
			Direction:      string(d.Direction), Frequency: string(d.Frequency),
			OwnerID: d.OwnerID, EffectiveFrom: stamp(d.EffectiveFrom),
			CreatedAt: stamp(d.CreatedAt), CreatedBy: d.CreatedBy,
		})
}

// Supersede marks every earlier revision as replaced.
func (r IndicatorRepo) Supersede(ctx context.Context,
	scope authctx.TenantScope, code string, revision int,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return r.queries(ctx).SupersedeQualityKPIDefinition(ctx,
		sqlcgen.SupersedeQualityKPIDefinitionParams{
			TenantID: tenantID, Code: code, Revision: int32(revision),
			SupersededAt: stamp(at),
		})
}

// Definition reads one revision.
func (r IndicatorRepo) Definition(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.KPIDefinition, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.KPIDefinition{}, err
	}
	definitionID, err := uuid.Parse(id)
	if err != nil {
		return domain.KPIDefinition{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityKPIDefinition(ctx,
		sqlcgen.GetQualityKPIDefinitionParams{
			TenantID: tenantID, DefinitionID: definitionID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.KPIDefinition{}, notFound()
	}
	if err != nil {
		return domain.KPIDefinition{}, err
	}
	return definitionFrom(row), nil
}

// CurrentDefinition is the highest revision of a code.
func (r IndicatorRepo) CurrentDefinition(ctx context.Context,
	scope authctx.TenantScope, code string) (domain.KPIDefinition, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.KPIDefinition{}, false, err
	}
	row, err := r.queries(ctx).GetQualityCurrentKPIDefinition(ctx,
		sqlcgen.GetQualityCurrentKPIDefinitionParams{
			TenantID: tenantID, Code: code,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.KPIDefinition{}, false, nil
	}
	if err != nil {
		return domain.KPIDefinition{}, false, err
	}
	return definitionFrom(row), true, nil
}

// Definitions lists the dictionary, one current entry per indicator.
func (r IndicatorRepo) Definitions(ctx context.Context,
	scope authctx.TenantScope) ([]domain.KPIDefinition, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityKPIDefinitions(ctx, tenantID)
	if err != nil {
		return nil, err
	}
	out := make([]domain.KPIDefinition, 0, len(rows))
	for _, row := range rows {
		out = append(out, definitionFrom(row))
	}
	return out, nil
}

// InsertValue records a measurement (SRS-QMS-010).
func (r IndicatorRepo) InsertValue(ctx context.Context,
	scope authctx.TenantScope, v domain.KPIValue) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	valueID, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}
	definitionID, err := uuid.Parse(v.DefinitionID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityKPIValue(ctx,
		sqlcgen.InsertQualityKPIValueParams{
			ValueID: valueID, TenantID: tenantID, DefinitionID: definitionID,
			Code: v.Code, Revision: int32(v.Revision),
			PeriodFrom: stamp(v.PeriodFrom), PeriodTo: stamp(v.PeriodTo),
			Numerator: v.Numerator, Denominator: v.Denominator,
			Permille: int32(v.Permille), Unanswerable: v.Unanswerable,
			SourceNote: v.SourceNote,
			RecordedAt: stamp(v.RecordedAt), RecordedBy: v.RecordedBy,
		})
}

// Values lists an indicator's history.
func (r IndicatorRepo) Values(ctx context.Context, scope authctx.TenantScope,
	code string, from, to time.Time) ([]domain.KPIValue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if from.IsZero() {
		from = epoch
	}
	if to.IsZero() {
		to = farFuture
	}

	rows, err := r.queries(ctx).ListQualityKPIValues(ctx,
		sqlcgen.ListQualityKPIValuesParams{
			TenantID: tenantID, Code: code,
			FromAt: stamp(from), ToAt: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.KPIValue, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.KPIValue{
			ID: row.ValueID.String(), TenantID: row.TenantID.String(),
			DefinitionID: row.DefinitionID.String(),
			Code:         row.Code, Revision: int(row.Revision),
			PeriodFrom: timeOf(row.PeriodFrom), PeriodTo: timeOf(row.PeriodTo),
			Numerator: row.Numerator, Denominator: row.Denominator,
			Permille: int(row.Permille), Unanswerable: row.Unanswerable,
			SourceNote: row.SourceNote,
			RecordedAt: timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

func definitionFrom(row sqlcgen.QualityKpiDefinition) domain.KPIDefinition {
	return domain.KPIDefinition{
		ID: row.DefinitionID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		Numerator: row.Numerator, Denominator: row.Denominator,
		Unit:           row.Unit,
		TargetPermille: int(row.TargetPermille),
		Direction:      domain.Direction(row.Direction),
		Frequency:      domain.Frequency(row.Frequency),
		OwnerID:        row.OwnerID,
		EffectiveFrom:  timeOf(row.EffectiveFrom),
		SupersededAt:   timeOf(row.SupersededAt),
		CreatedAt:      timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
	}
}
