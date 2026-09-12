package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"math/big"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Merge journal and duplicate review persistence (SRS-EMPI-004/005/006).

// MergeRepo implements the merge repository port.
type MergeRepo struct{ *Repository }

var _ ports.MergeRepository = MergeRepo{}

// ErrNoStandingMerge reports that a record is not currently merged into
// anything.
var ErrNoStandingMerge = errors.New("empi: no standing merge for this record")

// RecordMerge writes the journal entry.
func (r MergeRepo) RecordMerge(ctx context.Context, scope authctx.TenantScope, m domain.MergeRecord) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	mergeID, err := uuid.Parse(m.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_MERGE_ID_INVALID", "merge_id must be a UUID").WithCause(err)
	}
	survivorID, err := uuid.Parse(m.SurvivorID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "survivor_id must be a UUID").WithCause(err)
	}
	mergedID, err := uuid.Parse(m.MergedID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "merged_id must be a UUID").WithCause(err)
	}

	moved := m.MovedIdentifiers
	if moved == nil {
		moved = []domain.MovedIdentifier{}
	}
	encoded, err := json.Marshal(moved)
	if err != nil {
		return rpcerr.Internal("EMPI_ENCODE_FAILED", "could not encode the merge journal").WithCause(err)
	}

	return r.queries(ctx).InsertMergeRecord(ctx, sqlcgen.InsertMergeRecordParams{
		MergeID: mergeID, TenantID: tenantID,
		SurvivorID: survivorID, MergedID: mergedID,
		MergedPreviousStatus: string(m.MergedPreviousStatus),
		Reason:               m.Reason, PerformedBy: m.PerformedBy,
		PerformedAt:      timestamptz(m.PerformedAt),
		MovedIdentifiers: encoded, CarriedDeceased: m.CarriedDeceased,
	})
}

// StandingMerge returns the merge currently holding a record down.
func (r MergeRepo) StandingMerge(ctx context.Context, scope authctx.TenantScope,
	mergedPatientID string) (domain.MergeRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.MergeRecord{}, err
	}
	patientID, err := uuid.Parse(mergedPatientID)
	if err != nil {
		return domain.MergeRecord{}, ErrNoStandingMerge
	}

	row, err := r.queries(ctx).GetStandingMergeForLoser(ctx, sqlcgen.GetStandingMergeForLoserParams{
		TenantID: tenantID, MergedID: patientID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.MergeRecord{}, ErrNoStandingMerge
	}
	if err != nil {
		return domain.MergeRecord{}, err
	}
	return mergeFromRow(row)
}

// LaterMergesInto counts merges into a survivor after an instant.
func (r MergeRepo) LaterMergesInto(ctx context.Context, scope authctx.TenantScope,
	survivorID string, after time.Time) (int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	id, err := uuid.Parse(survivorID)
	if err != nil {
		return 0, rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "survivor_id must be a UUID").WithCause(err)
	}

	count, err := r.queries(ctx).CountLaterMergesIntoSurvivor(ctx, sqlcgen.CountLaterMergesIntoSurvivorParams{
		TenantID: tenantID, SurvivorID: id, After: timestamptz(after),
	})
	return int(count), err
}

// MarkUndone records the reversal.
func (r MergeRepo) MarkUndone(ctx context.Context, scope authctx.TenantScope, m domain.MergeRecord) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	mergeID, err := uuid.Parse(m.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_MERGE_ID_INVALID", "merge_id must be a UUID").WithCause(err)
	}

	undoneAt := time.Time{}
	if m.UndoneAt != nil {
		undoneAt = *m.UndoneAt
	}

	rows, err := r.queries(ctx).MarkMergeUndone(ctx, sqlcgen.MarkMergeUndoneParams{
		UndoneBy: m.UndoneBy, UndoneAt: timestamptz(undoneAt), UndoReason: m.UndoReason,
		TenantID: tenantID, MergeID: mergeID,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Somebody reversed it between the read and the write. Refusing is the
		// only safe answer: the identifiers have already gone back.
		return ports.ErrVersionConflict
	}
	return nil
}

// MoveIdentifier re-points one identifier at another patient.
func (r MergeRepo) MoveIdentifier(ctx context.Context, scope authctx.TenantScope,
	identifierID, toPatientID string, status domain.IdentifierStatus,
	primary bool, reason string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(identifierID)
	if err != nil {
		return rpcerr.Internal("EMPI_IDENTIFIER_ID_INVALID", "identifier_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(toPatientID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	rows, err := r.queries(ctx).MoveIdentifierToPatient(ctx, sqlcgen.MoveIdentifierToPatientParams{
		PatientID: patientID, Status: string(status), IsPrimary: primary,
		Reason: reason, UnlinkedAt: timestamptz(at),
		TenantID: tenantID, IdentifierID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// SetMergedInto writes the losing record's new status and pointer.
func (r MergeRepo) SetMergedInto(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	patientID, err := uuid.Parse(p.ID())
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	var into pgtype.UUID
	if p.MergedIntoPatientID != "" {
		parsed, parseErr := uuid.Parse(p.MergedIntoPatientID)
		if parseErr != nil {
			return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "merged_into must be a UUID").WithCause(parseErr)
		}
		into = pgtype.UUID{Bytes: parsed, Valid: true}
	}

	rows, err := r.queries(ctx).SetPatientMergedInto(ctx, sqlcgen.SetPatientMergedIntoParams{
		Status: string(p.Status), MergedIntoPatientID: into,
		UpdatedAt: timestamptz(p.UpdatedAt), TenantID: tenantID,
		PatientID: patientID, ExpectedVersion: p.Version - 1,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// SetDeceased writes or clears a deceased record.
func (r MergeRepo) SetDeceased(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	patientID, err := uuid.Parse(p.ID())
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	params := sqlcgen.SetPatientDeceasedParams{
		UpdatedAt: timestamptz(p.UpdatedAt), TenantID: tenantID, PatientID: patientID,
	}
	if p.Deceased != nil {
		params.DeceasedPrecision = string(p.Deceased.Precision)
		params.DeceasedSource = p.Deceased.Source
		params.DeceasedRecordedBy = p.Deceased.RecordedBy
		params.DeceasedRecordedAt = timestamptz(p.Deceased.RecordedAt)
		if !p.Deceased.Date.IsZero() {
			params.DeceasedDate = pgtype.Date{Time: p.Deceased.Date.UTC(), Valid: true}
		}
	}

	rows, err := r.queries(ctx).SetPatientDeceased(ctx, params)
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// QueueCandidate records a pair for review.
func (r MergeRepo) QueueCandidate(ctx context.Context, scope authctx.TenantScope, c domain.DuplicateCandidate) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	candidateID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_CANDIDATE_ID_INVALID", "candidate_id must be a UUID").WithCause(err)
	}
	a, err := uuid.Parse(c.PatientAID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_a_id must be a UUID").WithCause(err)
	}
	b, err := uuid.Parse(c.PatientBID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_b_id must be a UUID").WithCause(err)
	}

	score, err := floatToNumeric(c.Score)
	if err != nil {
		return err
	}

	return r.queries(ctx).UpsertDuplicateCandidate(ctx, sqlcgen.UpsertDuplicateCandidateParams{
		CandidateID: candidateID, TenantID: tenantID,
		PatientAID: a, PatientBID: b,
		Score: score, Outcome: string(c.Outcome),
		DetectedBy: c.DetectedBy, DetectedAt: timestamptz(c.DetectedAt),
	})
}

// Candidate reads one review-queue entry.
func (r MergeRepo) Candidate(ctx context.Context, scope authctx.TenantScope,
	candidateID string) (domain.DuplicateCandidate, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.DuplicateCandidate{}, err
	}
	id, err := uuid.Parse(candidateID)
	if err != nil {
		return domain.DuplicateCandidate{}, candidateNotFound()
	}

	row, err := r.queries(ctx).GetDuplicateCandidate(ctx, sqlcgen.GetDuplicateCandidateParams{
		TenantID: tenantID, CandidateID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.DuplicateCandidate{}, candidateNotFound()
	}
	if err != nil {
		return domain.DuplicateCandidate{}, err
	}
	return candidateFromRow(row)
}

// OpenCandidates returns the review worklist.
func (r MergeRepo) OpenCandidates(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.DuplicateCandidate, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListOpenDuplicateCandidates(ctx, sqlcgen.ListOpenDuplicateCandidatesParams{
		TenantID: tenantID, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.DuplicateCandidate, 0, len(rows))
	for _, row := range rows {
		c, err := candidateFromRow(row)
		if err != nil {
			return nil, err
		}
		out = append(out, c)
	}
	return out, nil
}

// CloseCandidate records a decision.
func (r MergeRepo) CloseCandidate(ctx context.Context, scope authctx.TenantScope, c domain.DuplicateCandidate) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return candidateNotFound()
	}

	reviewedAt := time.Time{}
	if c.ReviewedAt != nil {
		reviewedAt = *c.ReviewedAt
	}

	rows, err := r.queries(ctx).CloseDuplicateCandidate(ctx, sqlcgen.CloseDuplicateCandidateParams{
		Status: string(c.Status), ReviewedBy: c.ReviewedBy,
		ReviewedAt: timestamptz(reviewedAt), Resolution: c.Resolution,
		TenantID: tenantID, CandidateID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Already closed by somebody else. Refusing rather than overwriting:
		// one reviewer's decision must not be quietly replaced by another's.
		return ports.ErrVersionConflict
	}
	return nil
}

func candidateNotFound() error {
	return rpcerr.NotFound("EMPI_CANDIDATE_NOT_FOUND", "duplicate candidate not found")
}

func mergeFromRow(row sqlcgen.EmpiMergeJournal) (domain.MergeRecord, error) {
	m := domain.MergeRecord{
		ID: row.MergeID.String(), TenantID: row.TenantID.String(),
		SurvivorID: row.SurvivorID.String(), MergedID: row.MergedID.String(),
		MergedPreviousStatus: domain.Status(row.MergedPreviousStatus),
		Reason:               row.Reason, PerformedBy: row.PerformedBy,
		PerformedAt:     row.PerformedAt.Time.UTC(),
		CarriedDeceased: row.CarriedDeceased,
		Undone:          row.Undone, UndoneBy: row.UndoneBy, UndoReason: row.UndoReason,
	}
	if row.UndoneAt.Valid {
		at := row.UndoneAt.Time.UTC()
		m.UndoneAt = &at
	}
	if err := json.Unmarshal(row.MovedIdentifiers, &m.MovedIdentifiers); err != nil {
		return domain.MergeRecord{}, rpcerr.Internal(
			"EMPI_DECODE_FAILED", "could not read the merge journal").WithCause(err)
	}
	return m, nil
}

func candidateFromRow(row sqlcgen.EmpiDuplicateCandidate) (domain.DuplicateCandidate, error) {
	score, err := numericToFloat(row.Score)
	if err != nil {
		return domain.DuplicateCandidate{}, err
	}

	c := domain.DuplicateCandidate{
		ID: row.CandidateID.String(), TenantID: row.TenantID.String(),
		PatientAID: row.PatientAID.String(), PatientBID: row.PatientBID.String(),
		Score: score, Outcome: domain.MatchOutcome(row.Outcome),
		Status:     domain.ReviewStatus(row.Status),
		DetectedBy: row.DetectedBy, DetectedAt: row.DetectedAt.Time.UTC(),
		ReviewedBy: row.ReviewedBy, Resolution: row.Resolution,
	}
	if row.ReviewedAt.Valid {
		at := row.ReviewedAt.Time.UTC()
		c.ReviewedAt = &at
	}
	return c, nil
}

// floatToNumeric renders a 0..1 confidence for a numeric(4,3) column.
//
// Via the decimal string rather than the float, because the column stores three
// decimal places and a binary float's nearest representation of 0.75 is not
// exactly 0.75. Round-tripping through text is what makes the value that comes
// back equal to the value that went in.
func floatToNumeric(v float64) (pgtype.Numeric, error) {
	var n pgtype.Numeric
	if err := n.Scan(big.NewFloat(v).Text('f', 3)); err != nil {
		return pgtype.Numeric{}, rpcerr.Internal(
			"EMPI_SCORE_INVALID", "could not store the match score").WithCause(err)
	}
	return n, nil
}

// MergeByID reads one journal entry.
func (r MergeRepo) MergeByID(ctx context.Context, scope authctx.TenantScope,
	mergeID string) (domain.MergeRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.MergeRecord{}, err
	}
	id, err := uuid.Parse(mergeID)
	if err != nil {
		return domain.MergeRecord{}, mergeNotFound()
	}

	row, err := r.queries(ctx).GetMergeRecord(ctx, sqlcgen.GetMergeRecordParams{
		TenantID: tenantID, MergeID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.MergeRecord{}, mergeNotFound()
	}
	if err != nil {
		return domain.MergeRecord{}, err
	}
	return mergeFromRow(row)
}

func mergeNotFound() error {
	return rpcerr.NotFound("EMPI_MERGE_NOT_FOUND", "merge not found")
}
