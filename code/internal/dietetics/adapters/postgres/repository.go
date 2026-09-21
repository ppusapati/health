// Package postgres is the dietetics and kitchen persistence adapter.
//
// It is the only package permitted to issue SQL against the
// hospital_ops_diet schema (FIT-02). Every method takes an
// authctx.TenantScope, so the tenant predicate is always present and always
// comes from verified credentials (FIT-03).
//
// There is no delete anywhere in this package. A cancelled diet is a decision
// somebody made, a withheld tray is the record of a patient who was about to
// be given food they must not have, and a superseded census is what the
// kitchen cooked to before the ward changed. All three answer a question
// somebody asks afterwards.
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the dietetics repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("DIET_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("DIET_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe
// cannot confirm that an id exists in another tenant by the shape of the
// refusal.
func notFound() error {
	return rpcerr.NotFound("DIET_NOT_FOUND", "no such record")
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
// as NULL, and every array column in this schema is NOT NULL, so a diet order
// with no therapeutic restrictions would otherwise be rejected by the
// database rather than accepted as the ordinary case it is.
func texts(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as
// a NULL timestamp and excludes every row, which reads as "this ward has no
// meals today" — an answer a kitchen must never give by accident.
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

func isNoRows(err error) bool { return errors.Is(err, pgx.ErrNoRows) }

// ---------------------------------------------- assessments (SRS-DIET-001)

// InsertAssessment implements ports.AssessmentRepository.
func (r *Repository) InsertAssessment(ctx context.Context,
	scope authctx.TenantScope, a domain.NutritionAssessment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertDietAssessment(ctx,
		sqlcgen.InsertDietAssessmentParams{
			AssessmentID: id, TenantID: tenantID,
			PatientID: a.PatientID, EncounterID: a.EncounterID,
			FacilityID:       a.FacilityID,
			HeightMm:         int32(a.Anthropometry.HeightMM),
			WeightG:          int32(a.Anthropometry.WeightG),
			MidUpperArmMm:    int32(a.Anthropometry.MidUpperArmMM),
			Estimated:        a.Anthropometry.Estimated,
			MeasuredAt:       stamp(a.Anthropometry.MeasuredAt),
			IntakeSummary:    a.IntakeSummary,
			DiagnosisCode:    a.DiagnosisCode,
			Diagnosis:        a.Diagnosis,
			AllergyRefs:      texts(a.AllergyRefs),
			EnergyKcal:       int32(a.Requirement.EnergyKcal),
			ProteinG:         int32(a.Requirement.ProteinG),
			FluidMl:          int32(a.Requirement.FluidML),
			RequirementBasis: a.Requirement.Basis,
			RiskTool:         a.RiskTool,
			RiskScore:        int32(a.RiskScore),
			State:            string(a.State),
			CreatedAt:        stamp(a.CreatedAt), CreatedBy: a.CreatedBy,
		})
}

// Assessment implements ports.AssessmentRepository.
func (r *Repository) Assessment(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.NutritionAssessment,
	error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.NutritionAssessment{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.NutritionAssessment{}, notFound()
	}

	row, err := r.queries(ctx).GetDietAssessment(ctx,
		sqlcgen.GetDietAssessmentParams{
			TenantID: tenantID, AssessmentID: parsed,
		})
	if isNoRows(err) {
		return domain.NutritionAssessment{}, notFound()
	}
	if err != nil {
		return domain.NutritionAssessment{}, err
	}
	return assessmentFromRow(row), nil
}

// SignAssessment implements ports.AssessmentRepository.
func (r *Repository) SignAssessment(ctx context.Context,
	scope authctx.TenantScope, a domain.NutritionAssessment,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SignDietAssessment(ctx,
		sqlcgen.SignDietAssessmentParams{
			TenantID: tenantID, AssessmentID: id,
			SignedBy: a.SignedBy, SignedAt: stamp(a.SignedAt),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Assessments implements ports.AssessmentRepository.
func (r *Repository) Assessments(ctx context.Context,
	scope authctx.TenantScope, f ports.AssessmentFilter) (
	[]domain.NutritionAssessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListDietAssessments(ctx,
		sqlcgen.ListDietAssessmentsParams{
			TenantID: tenantID, PatientID: f.PatientID,
			EncounterID: f.EncounterID, SignedOnly: f.SignedOnly,
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.NutritionAssessment, 0, len(rows))
	for _, row := range rows {
		out = append(out, assessmentFromRow(row))
	}
	return out, nil
}

func assessmentFromRow(
	row sqlcgen.HospitalOpsDietNutritionAssessment) domain.NutritionAssessment {

	return domain.NutritionAssessment{
		ID: row.AssessmentID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		FacilityID: row.FacilityID,
		Anthropometry: domain.Anthropometry{
			HeightMM: int(row.HeightMm), WeightG: int(row.WeightG),
			MidUpperArmMM: int(row.MidUpperArmMm),
			Estimated:     row.Estimated,
			MeasuredAt:    timeOf(row.MeasuredAt),
		},
		IntakeSummary: row.IntakeSummary,
		DiagnosisCode: row.DiagnosisCode, Diagnosis: row.Diagnosis,
		AllergyRefs: row.AllergyRefs,
		Requirement: domain.Requirement{
			EnergyKcal: int(row.EnergyKcal), ProteinG: int(row.ProteinG),
			FluidML: int(row.FluidMl), Basis: row.RequirementBasis,
		},
		RiskTool: row.RiskTool, RiskScore: int(row.RiskScore),
		State:    domain.AssessmentState(row.State),
		SignedBy: row.SignedBy, SignedAt: timeOf(row.SignedAt),
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}
