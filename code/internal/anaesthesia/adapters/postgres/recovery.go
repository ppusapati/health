package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/anaesthesia/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// RecoveryRepo implements ports.RecoveryRepository.
type RecoveryRepo struct{ *Repository }

var _ ports.RecoveryRepository = RecoveryRepo{}

// InsertAssessment records one PACU score.
func (r RecoveryRepo) InsertAssessment(ctx context.Context,
	scope authctx.TenantScope, a domain.RecoveryAssessment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assessmentID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(a.RecordID)
	if err != nil {
		return notFound()
	}

	// The component scores as recorded, so the total can be read back rather
	// than taken on trust. An empty map is an object, not a NULL: an
	// assessment with nothing scored is still an assessment, and its Missing
	// list is what says so.
	scores := a.Scores
	if scores == nil {
		scores = map[string]int{}
	}
	encoded, err := json.Marshal(scores)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRecoveryAssessment(ctx,
		sqlcgen.InsertRecoveryAssessmentParams{
			AssessmentID: assessmentID, TenantID: tenantID, RecordID: recordID,
			ScaleName: a.ScaleName, ScaleVersion: a.ScaleVersion,
			Scores: encoded, Total: int32(a.Total),
			DischargeThreshold: int32(a.DischargeThreshold),
			Missing:            strings0(a.Missing),
			AssessedAt:         stamp(a.AssessedAt), AssessedBy: a.AssessedBy,
		})
}

// Assessments reads a record's PACU scores, oldest first.
func (r RecoveryRepo) Assessments(ctx context.Context, scope authctx.TenantScope,
	recordID string) ([]domain.RecoveryAssessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListRecoveryAssessments(ctx,
		sqlcgen.ListRecoveryAssessmentsParams{TenantID: tenantID, RecordID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.RecoveryAssessment, 0, len(rows))
	for _, row := range rows {
		scores := map[string]int{}
		if len(row.Scores) > 0 {
			if err := json.Unmarshal(row.Scores, &scores); err != nil {
				return nil, err
			}
		}
		out = append(out, domain.RecoveryAssessment{
			ID: row.AssessmentID.String(), TenantID: row.TenantID.String(),
			RecordID:  row.RecordID.String(),
			ScaleName: row.ScaleName, ScaleVersion: row.ScaleVersion,
			Scores: scores, Total: int(row.Total),
			DischargeThreshold: int(row.DischargeThreshold),
			Missing:            row.Missing,
			AssessedAt:         timeOf(row.AssessedAt), AssessedBy: row.AssessedBy,
		})
	}
	return out, nil
}

// InsertDischarge records the decision to let the patient leave recovery.
func (r RecoveryRepo) InsertDischarge(ctx context.Context,
	scope authctx.TenantScope, d domain.Discharge) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	dischargeID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(d.RecordID)
	if err != nil {
		return notFound()
	}
	// The assessment the decision was made on, so a review can read back the
	// score rather than the claim about it.
	scoreID, err := optionalUUID(d.ScoreID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertAnaesthesiaDischarge(ctx,
		sqlcgen.InsertAnaesthesiaDischargeParams{
			DischargeID: dischargeID, TenantID: tenantID, RecordID: recordID,
			Destination: d.Destination, Overridden: d.Overridden,
			OverrideReason: d.OverrideReason, ScoreID: scoreID,
			DischargedAt: stamp(d.DischargedAt), DischargedBy: d.DischargedBy,
		})
}

// Discharge reads a record's recovery discharge, if it has happened.
func (r RecoveryRepo) Discharge(ctx context.Context, scope authctx.TenantScope,
	recordID string) (domain.Discharge, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Discharge{}, false, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return domain.Discharge{}, false, notFound()
	}

	row, err := r.queries(ctx).GetAnaesthesiaDischarge(ctx,
		sqlcgen.GetAnaesthesiaDischargeParams{TenantID: tenantID, RecordID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Discharge{}, false, nil
	}
	if err != nil {
		return domain.Discharge{}, false, err
	}
	return domain.Discharge{
		ID: row.DischargeID.String(), TenantID: row.TenantID.String(),
		RecordID: row.RecordID.String(), Destination: row.Destination,
		Overridden: row.Overridden, OverrideReason: row.OverrideReason,
		ScoreID:      uuidOrEmpty(row.ScoreID),
		DischargedAt: timeOf(row.DischargedAt), DischargedBy: row.DischargedBy,
	}, true, nil
}

// InsertPainOrder records a post-operative pain plan.
func (r RecoveryRepo) InsertPainOrder(ctx context.Context,
	scope authctx.TenantScope, o domain.PainOrder) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}
	recordID, err := uuid.Parse(o.RecordID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(o.PatientID)
	if err != nil {
		return notFound()
	}
	encounterID, err := optionalUUID(o.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertPainOrder(ctx, sqlcgen.InsertPainOrderParams{
		OrderID: orderID, TenantID: tenantID, RecordID: recordID,
		PatientID: patientID, EncounterID: encounterID, Modality: o.Modality,
		// The prescriptions themselves belong to SRS-MED. A second place to
		// prescribe from is how a patient gets two doses, so this names them.
		PrescriptionIds: strings0(o.PrescriptionIDs),
		TargetScore:     o.TargetScore, Monitoring: strings0(o.Monitoring),
		Escalation: o.Escalation, ReviewBy: stamp(o.ReviewBy),
		OrderedBy: o.OrderedBy, OrderedAt: stamp(o.OrderedAt),
	})
}

// PainOrder reads one pain plan.
func (r RecoveryRepo) PainOrder(ctx context.Context, scope authctx.TenantScope,
	orderID string) (domain.PainOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PainOrder{}, err
	}
	id, err := uuid.Parse(orderID)
	if err != nil {
		return domain.PainOrder{}, notFound()
	}

	row, err := r.queries(ctx).GetPainOrder(ctx,
		sqlcgen.GetPainOrderParams{TenantID: tenantID, OrderID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PainOrder{}, notFound()
	}
	if err != nil {
		return domain.PainOrder{}, err
	}
	return painOrderFrom(row), nil
}

// PainOrders reads a record's pain plans.
func (r RecoveryRepo) PainOrders(ctx context.Context, scope authctx.TenantScope,
	recordID string) ([]domain.PainOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPainOrdersForRecord(ctx,
		sqlcgen.ListPainOrdersForRecordParams{TenantID: tenantID, RecordID: id})
	if err != nil {
		return nil, err
	}
	return painOrdersFrom(rows), nil
}

// RunningPainOrders is the acute pain team's worklist, soonest review first.
func (r RecoveryRepo) RunningPainOrders(ctx context.Context,
	scope authctx.TenantScope, limit int32) ([]domain.PainOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListRunningPainOrders(ctx,
		sqlcgen.ListRunningPainOrdersParams{TenantID: tenantID, RowLimit: limit})
	if err != nil {
		return nil, err
	}
	return painOrdersFrom(rows), nil
}

// StopPainOrder ends a pain plan.
//
// False where it was already stopped, so a plan stopped on the ward and again
// by the pain team keeps the first stop time.
func (r RecoveryRepo) StopPainOrder(ctx context.Context, scope authctx.TenantScope,
	orderID, by string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(orderID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).StopPainOrder(ctx, sqlcgen.StopPainOrderParams{
		TenantID: tenantID, OrderID: id, StoppedAt: stamp(at), StoppedBy: by,
	})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

func painOrdersFrom(rows []sqlcgen.AnaesthesiaPainOrder) []domain.PainOrder {
	out := make([]domain.PainOrder, 0, len(rows))
	for _, row := range rows {
		out = append(out, painOrderFrom(row))
	}
	return out
}

func painOrderFrom(row sqlcgen.AnaesthesiaPainOrder) domain.PainOrder {
	return domain.PainOrder{
		ID: row.OrderID.String(), TenantID: row.TenantID.String(),
		RecordID: row.RecordID.String(), PatientID: row.PatientID.String(),
		EncounterID: uuidOrEmpty(row.EncounterID), Modality: row.Modality,
		PrescriptionIDs: row.PrescriptionIds, TargetScore: row.TargetScore,
		Monitoring: row.Monitoring, Escalation: row.Escalation,
		ReviewBy:  timeOf(row.ReviewBy),
		OrderedBy: row.OrderedBy, OrderedAt: timeOf(row.OrderedAt),
		StoppedAt: timeOf(row.StoppedAt), StoppedBy: row.StoppedBy,
	}
}
