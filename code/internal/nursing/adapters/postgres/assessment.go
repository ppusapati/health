package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// AssessmentRepo persists nursing assessments and their templates
// (SRS-NUR-001).
type AssessmentRepo struct{ *Repository }

var _ ports.AssessmentRepository = AssessmentRepo{}

// NewAssessments constructs the assessment adapter.
func NewAssessments(r *Repository) AssessmentRepo { return AssessmentRepo{r} }

// InsertTemplate stores a versioned assessment structure.
func (r AssessmentRepo) InsertTemplate(ctx context.Context,
	scope authctx.TenantScope, t domain.AssessmentTemplate, createdBy string,
	now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	templateID, err := mustUUID(t.TemplateID)
	if err != nil {
		return err
	}
	sections, err := toJSON(t.Sections)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertAssessmentTemplate(ctx,
		sqlcgen.InsertAssessmentTemplateParams{
			TemplateID: templateID, TenantID: tenantID,
			Version: t.Version, Name: t.Name,
			MinAgeYears: t.AppliesTo.MinAgeYears,
			MaxAgeYears: t.AppliesTo.MaxAgeYears,
			ServiceCode: t.AppliesTo.ServiceCode,
			Sections:    sections,
			CreatedBy:   createdBy, CreatedAt: timestamptz(now),
		})
}

// GetTemplate reads one version.
func (r AssessmentRepo) GetTemplate(ctx context.Context,
	scope authctx.TenantScope, templateID, version string) (
	domain.AssessmentTemplate, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.AssessmentTemplate{}, err
	}
	id, err := lookupUUID(templateID)
	if err != nil {
		return domain.AssessmentTemplate{}, err
	}

	row, err := r.queries(ctx).GetAssessmentTemplate(ctx,
		sqlcgen.GetAssessmentTemplateParams{
			TenantID: tenantID, TemplateID: id, Version: version,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.AssessmentTemplate{}, notFound()
	}
	if err != nil {
		return domain.AssessmentTemplate{}, err
	}
	return templateFromRow(sqlcgen.NursingAssessmentTemplate(row))
}

// ListTemplates lists the templates a tenant may choose from.
func (r AssessmentRepo) ListTemplates(ctx context.Context,
	scope authctx.TenantScope, serviceCode string, includeRetired bool,
	limit int32) ([]domain.AssessmentTemplate, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListAssessmentTemplates(ctx,
		sqlcgen.ListAssessmentTemplatesParams{
			TenantID: tenantID, IncludeRetired: includeRetired,
			ServiceFilter: serviceCode, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.AssessmentTemplate, 0, len(rows))
	for _, row := range rows {
		template, err := templateFromRow(sqlcgen.NursingAssessmentTemplate(row))
		if err != nil {
			return nil, err
		}
		out = append(out, template)
	}
	return out, nil
}

// RetireTemplate withdraws a template from new assessments.
//
// The assessments already answered against it stay valid and readable: they
// recorded what was asked at the time, which is the point of versioning.
func (r AssessmentRepo) RetireTemplate(ctx context.Context,
	scope authctx.TenantScope, templateID, version string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(templateID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).RetireAssessmentTemplate(ctx,
		sqlcgen.RetireAssessmentTemplateParams{
			TenantID: tenantID, TemplateID: id, Version: version,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

func templateFromRow(row sqlcgen.NursingAssessmentTemplate) (
	domain.AssessmentTemplate, error) {

	t := domain.AssessmentTemplate{
		TemplateID: row.TemplateID.String(), TenantID: row.TenantID.String(),
		Version: row.Version, Name: row.Name,
		AppliesTo: domain.Applicability{
			MinAgeYears: row.MinAgeYears, MaxAgeYears: row.MaxAgeYears,
			ServiceCode: row.ServiceCode,
		},
	}
	if err := fromJSON(row.Sections, &t.Sections); err != nil {
		return domain.AssessmentTemplate{}, err
	}
	if row.Retired {
		// The retirement time is not stored separately; what callers need is
		// whether the template may still be chosen, and a non-zero time says so.
		t.RetiredAt = timeOrZero(row.CreatedAt)
		if t.RetiredAt.IsZero() {
			t.RetiredAt = time.Unix(0, 0).UTC()
		}
	}
	return t, nil
}

// Insert stores a completed assessment.
func (r AssessmentRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	a *domain.Assessment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assessmentID, err := mustUUID(a.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(a.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(a.EncounterID)
	if err != nil {
		return err
	}
	templateID, err := mustUUID(a.TemplateID)
	if err != nil {
		return err
	}
	answers, err := toJSON(a.Answers)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertAssessment(ctx, sqlcgen.InsertAssessmentParams{
		AssessmentID: assessmentID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		Kind: string(a.Kind),
		// The version is stored rather than resolved at read time: a template
		// edited afterwards would otherwise restate what was asked.
		TemplateID: templateID, TemplateVersion: a.TemplateVersion,
		Answers:    answers,
		AssessedAt: timestamptz(a.AssessedAt),
		RecordedAt: timestamptz(a.RecordedAt),
		AssessedBy: a.AssessedBy,
	})
}

// Get reads one assessment.
func (r AssessmentRepo) Get(ctx context.Context, scope authctx.TenantScope,
	assessmentID string) (*domain.Assessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(assessmentID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetAssessment(ctx, sqlcgen.GetAssessmentParams{
		TenantID: tenantID, AssessmentID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return assessmentFromRow(sqlcgen.NursingAssessment(row))
}

// List reads an encounter's assessments.
func (r AssessmentRepo) List(ctx context.Context, scope authctx.TenantScope,
	encounterID string, kind domain.AssessmentKind, limit int32) (
	[]*domain.Assessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListAssessments(ctx, sqlcgen.ListAssessmentsParams{
		TenantID: tenantID, EncounterID: id,
		KindFilter: string(kind), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Assessment, 0, len(rows))
	for _, row := range rows {
		assessment, err := assessmentFromRow(sqlcgen.NursingAssessment(row))
		if err != nil {
			return nil, err
		}
		out = append(out, assessment)
	}
	return out, nil
}

func assessmentFromRow(row sqlcgen.NursingAssessment) (*domain.Assessment, error) {
	a := &domain.Assessment{
		ID: row.AssessmentID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Kind:            domain.AssessmentKind(row.Kind),
		TemplateID:      row.TemplateID.String(),
		TemplateVersion: row.TemplateVersion,
		AssessedAt:      timeOrZero(row.AssessedAt),
		RecordedAt:      timeOrZero(row.RecordedAt),
		AssessedBy:      row.AssessedBy, Version: row.Version,
	}
	if err := fromJSON(row.Answers, &a.Answers); err != nil {
		return nil, err
	}
	return a, nil
}

// RiskRepo persists risk scales and scores (SRS-NUR-005).
type RiskRepo struct{ *Repository }

var _ ports.RiskRepository = RiskRepo{}

// NewRisk constructs the risk adapter.
func NewRisk(r *Repository) RiskRepo { return RiskRepo{r} }

// InsertScale stores a versioned scoring instrument.
func (r RiskRepo) InsertScale(ctx context.Context, scope authctx.TenantScope,
	s domain.RiskScale, createdBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	scaleID, err := mustUUID(s.ScaleID)
	if err != nil {
		return err
	}
	inputs, err := toJSON(s.Inputs)
	if err != nil {
		return err
	}
	bands, err := toJSON(s.Bands)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRiskScale(ctx, sqlcgen.InsertRiskScaleParams{
		ScaleID: scaleID, TenantID: tenantID,
		Version: s.Version, Name: s.Name, RiskDomain: string(s.Domain),
		Inputs: inputs, Bands: bands,
		ReassessAfterSeconds: int64(s.ReassessAfter / time.Second),
		CreatedBy:            createdBy, CreatedAt: timestamptz(now),
	})
}

// GetScale reads one version.
func (r RiskRepo) GetScale(ctx context.Context, scope authctx.TenantScope,
	scaleID, version string) (domain.RiskScale, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.RiskScale{}, err
	}
	id, err := lookupUUID(scaleID)
	if err != nil {
		return domain.RiskScale{}, err
	}

	row, err := r.queries(ctx).GetRiskScale(ctx, sqlcgen.GetRiskScaleParams{
		TenantID: tenantID, ScaleID: id, Version: version,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.RiskScale{}, notFound()
	}
	if err != nil {
		return domain.RiskScale{}, err
	}
	return scaleFromRow(sqlcgen.NursingRiskScale(row))
}

// ListScales lists a tenant's instruments.
func (r RiskRepo) ListScales(ctx context.Context, scope authctx.TenantScope,
	riskDomain domain.RiskDomain, includeRetired bool, limit int32) (
	[]domain.RiskScale, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListRiskScales(ctx, sqlcgen.ListRiskScalesParams{
		TenantID: tenantID, IncludeRetired: includeRetired,
		DomainFilter: string(riskDomain), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.RiskScale, 0, len(rows))
	for _, row := range rows {
		scale, err := scaleFromRow(sqlcgen.NursingRiskScale(row))
		if err != nil {
			return nil, err
		}
		out = append(out, scale)
	}
	return out, nil
}

func scaleFromRow(row sqlcgen.NursingRiskScale) (domain.RiskScale, error) {
	s := domain.RiskScale{
		ScaleID: row.ScaleID.String(), TenantID: row.TenantID.String(),
		Version: row.Version, Name: row.Name,
		Domain:        domain.RiskDomain(row.RiskDomain),
		ReassessAfter: time.Duration(row.ReassessAfterSeconds) * time.Second,
	}
	if err := fromJSON(row.Inputs, &s.Inputs); err != nil {
		return domain.RiskScale{}, err
	}
	if err := fromJSON(row.Bands, &s.Bands); err != nil {
		return domain.RiskScale{}, err
	}
	if row.Retired {
		s.RetiredAt = timeOrZero(row.CreatedAt)
		if s.RetiredAt.IsZero() {
			s.RetiredAt = time.Unix(0, 0).UTC()
		}
	}
	return s, nil
}

// Insert stores a scored assessment.
func (r RiskRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	a *domain.RiskAssessment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	riskID, err := mustUUID(a.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(a.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(a.EncounterID)
	if err != nil {
		return err
	}
	scaleID, err := mustUUID(a.ScaleID)
	if err != nil {
		return err
	}
	inputs, err := toJSON(a.Inputs)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRiskAssessment(ctx,
		sqlcgen.InsertRiskAssessmentParams{
			RiskID: riskID, TenantID: tenantID,
			PatientID: patientID, EncounterID: encounterID,
			ScaleID: scaleID, ScaleVersion: a.ScaleVersion,
			RiskDomain: string(a.Domain),
			// The inputs travel with the total: a score on its own cannot be
			// checked, explained or recomputed (SRS-NUR-005).
			Inputs: inputs, Total: a.Total, Band: a.Band,
			// The band's escalate flag as it stood, so a retune does not rewrite
			// what the nurse was told.
			Escalate:   a.Escalate,
			AssessedAt: timestamptz(a.AssessedAt),
			RecordedAt: timestamptz(a.RecordedAt),
			AssessedBy: a.AssessedBy, DueAt: timestamptz(a.DueAt),
		})
}

// Supersede marks the previous live score replaced.
func (r RiskRepo) Supersede(ctx context.Context, scope authctx.TenantScope,
	riskID, supersededByID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(riskID)
	if err != nil {
		return err
	}
	by, err := optionalUUID(supersededByID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).SupersedeRiskAssessment(ctx,
		sqlcgen.SupersedeRiskAssessmentParams{
			TenantID: tenantID, RiskID: id, SupersededByID: by,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// Latest returns the live score for a patient in a risk domain.
func (r RiskRepo) Latest(ctx context.Context, scope authctx.TenantScope,
	patientID string, riskDomain domain.RiskDomain) (*domain.RiskAssessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(patientID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).LatestRiskAssessment(ctx,
		sqlcgen.LatestRiskAssessmentParams{
			TenantID: tenantID, PatientID: id, RiskDomain: string(riskDomain),
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return riskFromRow(sqlcgen.NursingRiskAssessment(row))
}

// List reads a patient's scores.
func (r RiskRepo) List(ctx context.Context, scope authctx.TenantScope,
	patientID string, riskDomain domain.RiskDomain, limit int32) (
	[]*domain.RiskAssessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(patientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListRiskAssessments(ctx,
		sqlcgen.ListRiskAssessmentsParams{
			TenantID: tenantID, PatientID: id,
			DomainFilter: string(riskDomain), PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.RiskAssessment, 0, len(rows))
	for _, row := range rows {
		assessment, err := riskFromRow(sqlcgen.NursingRiskAssessment(row))
		if err != nil {
			return nil, err
		}
		out = append(out, assessment)
	}
	return out, nil
}

// Due lists live scores past their reassessment time (SRS-NUR-005).
func (r RiskRepo) Due(ctx context.Context, scope authctx.TenantScope,
	encounterID string, asOf time.Time, limit int32) (
	[]*domain.RiskAssessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounter, err := optionalUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListDueRiskAssessments(ctx,
		sqlcgen.ListDueRiskAssessmentsParams{
			TenantID: tenantID, AsOf: timestamptz(asOf),
			EncounterFilter: encounter, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.RiskAssessment, 0, len(rows))
	for _, row := range rows {
		assessment, err := riskFromRow(sqlcgen.NursingRiskAssessment(row))
		if err != nil {
			return nil, err
		}
		out = append(out, assessment)
	}
	return out, nil
}

func riskFromRow(row sqlcgen.NursingRiskAssessment) (*domain.RiskAssessment, error) {
	a := &domain.RiskAssessment{
		ID: row.RiskID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		ScaleID: row.ScaleID.String(), ScaleVersion: row.ScaleVersion,
		Domain: domain.RiskDomain(row.RiskDomain),
		Total:  row.Total, Band: row.Band, Escalate: row.Escalate,
		AssessedAt: timeOrZero(row.AssessedAt),
		RecordedAt: timeOrZero(row.RecordedAt),
		AssessedBy: row.AssessedBy, DueAt: timeOrZero(row.DueAt),
		SupersededByID: uuidOrEmpty(row.SupersededByID),
		Version:        row.Version,
	}
	if err := fromJSON(row.Inputs, &a.Inputs); err != nil {
		return nil, err
	}
	return a, nil
}
