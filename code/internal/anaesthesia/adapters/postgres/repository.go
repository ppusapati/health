// Package postgres is the anaesthesia persistence adapter.
//
// It is the only package permitted to issue SQL against the anaesthesia schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/anaesthesia/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the anaesthesia repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("ANE_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("ANE_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("ANE_NOT_FOUND", "no such anaesthetic record")
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

func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
		return pgtype.UUID{}, notFound()
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func uuidOrEmpty(value pgtype.UUID) string {
	if !value.Valid {
		return ""
	}
	return uuid.UUID(value.Bytes).String()
}

// strings0 turns a nil slice into an empty one.
//
// The array columns here are NOT NULL, and an empty list in Go is a nil slice.
// Empty and absent are the same thing for every one of them, and writing a
// NULL would make the read side distinguish two states the domain does not
// have.
func strings0(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// AssessmentRepo implements ports.AssessmentRepository.
type AssessmentRepo struct{ *Repository }

var _ ports.AssessmentRepository = AssessmentRepo{}

func (r AssessmentRepo) insertAssessment(ctx context.Context, tenantID uuid.UUID,
	a domain.Assessment) error {

	assessmentID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(a.CaseID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(a.PatientID)
	if err != nil {
		return notFound()
	}
	encounterID, err := optionalUUID(a.EncounterID)
	if err != nil {
		return err
	}
	supersedes, err := optionalUUID(a.Supersedes)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertAnaesthesiaAssessment(ctx,
		sqlcgen.InsertAnaesthesiaAssessmentParams{
			AssessmentID: assessmentID, TenantID: tenantID, CaseID: caseID,
			EncounterID: encounterID, PatientID: patientID,
			Version: int32(a.Version), Supersedes: supersedes,
			History:                  a.History,
			AirwayMallampati:         a.Airway.Mallampati,
			AirwayMouthMm:            int32(a.Airway.MouthOpeningMM),
			AirwayThyromentalMm:      int32(a.Airway.ThyromentalMM),
			AirwayNeck:               a.Airway.NeckMovement,
			AirwayDentition:          a.Airway.Dentition,
			AirwayNotes:              a.Airway.Notes,
			AirwayPredictedDifficult: a.Airway.PredictedDifficult,
			AsaGrade:                 string(a.ASAGrade),
			Investigations:           strings0(a.Investigations),
			Risks:                    strings0(a.Risks),
			Plan:                     a.Plan,
			Consent:                  string(a.Consent),
			ConsentNote:              a.ConsentNote,
			FitToProceed:             a.FitToProceed,
			Conditions:               strings0(a.Conditions),
			AssessedBy:               a.AssessedBy,
			AssessedAt:               stamp(a.AssessedAt),
		})
}

// InsertAssessment writes a first pre-anaesthesia assessment.
func (r AssessmentRepo) InsertAssessment(ctx context.Context,
	scope authctx.TenantScope, a domain.Assessment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return r.insertAssessment(ctx, tenantID, a)
}

// Supersede writes a later version and retires the one it replaces.
//
// Both statements in one transaction, and in this order: the database holds
// "at most one current assessment per case" as a partial unique index, so the
// old row has to stop being current before the new one exists. The forward
// reference from old to new is DEFERRABLE, which is what makes that order
// possible at all.
func (r AssessmentRepo) Supersede(ctx context.Context, scope authctx.TenantScope,
	next domain.Assessment, previousID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	previous, err := uuid.Parse(previousID)
	if err != nil {
		return notFound()
	}
	nextID, err := uuid.Parse(next.ID)
	if err != nil {
		return notFound()
	}

	return r.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := r.queries(ctx).SupersedeAnaesthesiaAssessment(ctx,
			sqlcgen.SupersedeAnaesthesiaAssessmentParams{
				TenantID: tenantID, AssessmentID: previous,
				SupersededBy: pgtype.UUID{Bytes: nextID, Valid: true},
				SupersededAt: stamp(at),
			}); err != nil {
			return err
		}
		return r.insertAssessment(ctx, tenantID, next)
	})
}

// Assessment reads one version.
func (r AssessmentRepo) Assessment(ctx context.Context, scope authctx.TenantScope,
	assessmentID string) (domain.Assessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Assessment{}, err
	}
	id, err := uuid.Parse(assessmentID)
	if err != nil {
		return domain.Assessment{}, notFound()
	}

	row, err := r.queries(ctx).GetAnaesthesiaAssessment(ctx,
		sqlcgen.GetAnaesthesiaAssessmentParams{TenantID: tenantID, AssessmentID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Assessment{}, notFound()
	}
	if err != nil {
		return domain.Assessment{}, err
	}
	return assessmentFrom(row), nil
}

// Assessments returns every version for a case, oldest first.
func (r AssessmentRepo) Assessments(ctx context.Context, scope authctx.TenantScope,
	caseID string) ([]domain.Assessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAnaesthesiaAssessments(ctx,
		sqlcgen.ListAnaesthesiaAssessmentsParams{TenantID: tenantID, CaseID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Assessment, 0, len(rows))
	for _, row := range rows {
		out = append(out, assessmentFrom(row))
	}
	return out, nil
}

// PatientAssessments returns a patient's assessments, most recent first.
func (r AssessmentRepo) PatientAssessments(ctx context.Context,
	scope authctx.TenantScope, patientID string, limit int32) (
	[]domain.Assessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientAnaesthesiaAssessments(ctx,
		sqlcgen.ListPatientAnaesthesiaAssessmentsParams{
			TenantID: tenantID, PatientID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Assessment, 0, len(rows))
	for _, row := range rows {
		out = append(out, assessmentFrom(row))
	}
	return out, nil
}

func assessmentFrom(row sqlcgen.AnaesthesiaAssessment) domain.Assessment {
	return domain.Assessment{
		ID: row.AssessmentID.String(), TenantID: row.TenantID.String(),
		CaseID:      row.CaseID.String(),
		EncounterID: uuidOrEmpty(row.EncounterID),
		PatientID:   row.PatientID.String(),
		Version:     int(row.Version),
		Supersedes:  uuidOrEmpty(row.Supersedes),
		History:     row.History,
		Airway: domain.AirwayAssessment{
			Mallampati:         row.AirwayMallampati,
			MouthOpeningMM:     int(row.AirwayMouthMm),
			ThyromentalMM:      int(row.AirwayThyromentalMm),
			NeckMovement:       row.AirwayNeck,
			Dentition:          row.AirwayDentition,
			Notes:              row.AirwayNotes,
			PredictedDifficult: row.AirwayPredictedDifficult,
		},
		ASAGrade:       domain.ASA(row.AsaGrade),
		Investigations: row.Investigations,
		Risks:          row.Risks,
		Plan:           row.Plan,
		Consent:        domain.ConsentStatus(row.Consent),
		ConsentNote:    row.ConsentNote,
		FitToProceed:   row.FitToProceed,
		Conditions:     row.Conditions,
		AssessedBy:     row.AssessedBy,
		AssessedAt:     timeOf(row.AssessedAt),
		SupersededBy:   uuidOrEmpty(row.SupersededBy),
		SupersededAt:   timeOf(row.SupersededAt),
	}
}

// SavePlan records or replaces the anaesthetic plan for a case.
func (r AssessmentRepo) SavePlan(ctx context.Context, scope authctx.TenantScope,
	p domain.Plan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	planID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(p.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).UpsertAnaesthesiaPlan(ctx,
		sqlcgen.UpsertAnaesthesiaPlanParams{
			PlanID: planID, TenantID: tenantID, CaseID: caseID,
			Technique: string(p.Technique), Agents: strings0(p.Agents),
			Airway: p.Airway, Monitoring: strings0(p.Monitoring),
			SpecialEquipment: strings0(p.SpecialEquipment),
			PostOperative:    p.PostOperative, Notes: p.Notes,
			PlannedBy: p.PlannedBy, PlannedAt: stamp(p.PlannedAt),
		})
}

// Plan reads a case's anaesthetic plan.
//
// False rather than an error where none exists: a case with no plan yet is the
// ordinary state before the anaesthetist has seen the list, and the readiness
// projection has a place to say so.
func (r AssessmentRepo) Plan(ctx context.Context, scope authctx.TenantScope,
	caseID string) (domain.Plan, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Plan{}, false, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return domain.Plan{}, false, notFound()
	}

	row, err := r.queries(ctx).GetAnaesthesiaPlanForCase(ctx,
		sqlcgen.GetAnaesthesiaPlanForCaseParams{TenantID: tenantID, CaseID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Plan{}, false, nil
	}
	if err != nil {
		return domain.Plan{}, false, err
	}
	return domain.Plan{
		ID: row.PlanID.String(), TenantID: row.TenantID.String(),
		CaseID: row.CaseID.String(), Technique: domain.Technique(row.Technique),
		Agents: row.Agents, Airway: row.Airway, Monitoring: row.Monitoring,
		SpecialEquipment: row.SpecialEquipment, PostOperative: row.PostOperative,
		Notes: row.Notes, PlannedBy: row.PlannedBy, PlannedAt: timeOf(row.PlannedAt),
	}, true, nil
}
