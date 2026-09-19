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

// ComplaintRepo implements ports.ComplaintRepository.
type ComplaintRepo struct{ *Repository }

var _ ports.ComplaintRepository = ComplaintRepo{}

// InsertComplaint records a grievance (SRS-QMS-011).
func (r ComplaintRepo) InsertComplaint(ctx context.Context,
	scope authctx.TenantScope, c domain.Complaint) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	complaintID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityComplaint(ctx,
		sqlcgen.InsertQualityComplaintParams{
			ComplaintID: complaintID, TenantID: tenantID,
			Reference: c.Reference, Kind: string(c.Kind),
			ComplainantRef: c.ComplainantRef, PatientID: c.PatientID,
			EncounterID: c.EncounterID, Category: c.Category,
			Department: c.Department, FacilityID: c.FacilityID,
			Channel: c.Channel, Detail: c.Detail,
			AcknowledgeBy: stamp(c.AcknowledgeBy),
			ResolveBy:     stamp(c.ResolveBy),
			State:         string(c.State),
			ReceivedAt:    stamp(c.ReceivedAt), ReceivedBy: c.ReceivedBy,
		})
}

// Complaint reads one.
func (r ComplaintRepo) Complaint(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Complaint, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Complaint{}, err
	}
	complaintID, err := uuid.Parse(id)
	if err != nil {
		return domain.Complaint{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityComplaint(ctx,
		sqlcgen.GetQualityComplaintParams{
			TenantID: tenantID, ComplaintID: complaintID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Complaint{}, notFound()
	}
	if err != nil {
		return domain.Complaint{}, err
	}
	return complaintFrom(row), nil
}

// UpdateComplaint writes an acknowledgement, a resolution or a closure.
func (r ComplaintRepo) UpdateComplaint(ctx context.Context,
	scope authctx.TenantScope, c domain.Complaint,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	complaintID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityComplaint(ctx,
		sqlcgen.UpdateQualityComplaintParams{
			TenantID: tenantID, ComplaintID: complaintID,
			AcknowledgedAt: stamp(c.AcknowledgedAt),
			AcknowledgedBy: c.AcknowledgedBy,
			State:          string(c.State), Outcome: string(c.Outcome),
			Resolution: c.Resolution, ClosureReason: c.ClosureReason,
			Escalated: c.Escalated, EscalatedAt: stamp(c.EscalatedAt),
			ClosedAt: stamp(c.ClosedAt), ClosedBy: c.ClosedBy,
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

// Complaints lists grievances.
func (r ComplaintRepo) Complaints(ctx context.Context,
	scope authctx.TenantScope, category string, openOnly bool,
	limit int32) ([]domain.Complaint, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityComplaints(ctx,
		sqlcgen.ListQualityComplaintsParams{
			TenantID: tenantID, Category: category,
			OpenOnly: openOnly, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Complaint, 0, len(rows))
	for _, row := range rows {
		out = append(out, complaintFrom(row))
	}
	return out, nil
}

func complaintFrom(row sqlcgen.QualityComplaint) domain.Complaint {
	return domain.Complaint{
		ID: row.ComplaintID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Kind: domain.ComplainantKind(row.Kind),
		ComplainantRef: row.ComplainantRef, PatientID: row.PatientID,
		EncounterID: row.EncounterID, Category: row.Category,
		Department: row.Department, FacilityID: row.FacilityID,
		Channel: row.Channel, Detail: row.Detail,
		AcknowledgeBy:  timeOf(row.AcknowledgeBy),
		AcknowledgedAt: timeOf(row.AcknowledgedAt),
		AcknowledgedBy: row.AcknowledgedBy,
		ResolveBy:      timeOf(row.ResolveBy),
		State:          domain.ComplaintState(row.State),
		Outcome:        domain.Outcome(row.Outcome),
		Resolution:     row.Resolution, ClosureReason: row.ClosureReason,
		Escalated: row.Escalated, EscalatedAt: timeOf(row.EscalatedAt),
		ReceivedAt: timeOf(row.ReceivedAt), ReceivedBy: row.ReceivedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		Version: row.Version,
	}
}

// PeerReviewRepo implements ports.PeerReviewRepository.
type PeerReviewRepo struct{ *Repository }

var _ ports.PeerReviewRepository = PeerReviewRepo{}

// InsertReview opens a mortality review (SRS-QMS-012).
func (r PeerReviewRepo) InsertReview(ctx context.Context,
	scope authctx.TenantScope, m domain.MortalityReview) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	reviewID, err := uuid.Parse(m.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityMortalityReview(ctx,
		sqlcgen.InsertQualityMortalityReviewParams{
			ReviewID: reviewID, TenantID: tenantID,
			PatientID: m.PatientID, EncounterID: m.EncounterID,
			DiedAt:      stamp(m.DiedAt),
			CommitteeID: optionalUUID(m.CommitteeID),
			State:       string(m.State),
			OpenedAt:    stamp(m.OpenedAt), OpenedBy: m.OpenedBy,
		})
}

// Review reads one.
func (r PeerReviewRepo) Review(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.MortalityReview, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.MortalityReview{}, err
	}
	reviewID, err := uuid.Parse(id)
	if err != nil {
		return domain.MortalityReview{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityMortalityReview(ctx,
		sqlcgen.GetQualityMortalityReviewParams{
			TenantID: tenantID, ReviewID: reviewID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.MortalityReview{}, notFound()
	}
	if err != nil {
		return domain.MortalityReview{}, err
	}
	return reviewFrom(row), nil
}

// UpdateReview writes the committee's verdict.
func (r PeerReviewRepo) UpdateReview(ctx context.Context,
	scope authctx.TenantScope, m domain.MortalityReview,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	reviewID, err := uuid.Parse(m.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityMortalityReview(ctx,
		sqlcgen.UpdateQualityMortalityReviewParams{
			TenantID: tenantID, ReviewID: reviewID,
			MeetingID:      optionalUUID(m.MeetingID),
			Classification: string(m.Classification),
			Findings:       m.Findings, LearningPoints: m.LearningPoints,
			CapaIds: parseUUIDs(m.CAPAIDs), State: string(m.State),
			CompletedAt: stamp(m.CompletedAt), CompletedBy: m.CompletedBy,
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

// Reviews lists peer reviews over a period.
func (r PeerReviewRepo) Reviews(ctx context.Context,
	scope authctx.TenantScope, openOnly bool, from, to time.Time,
	limit int32) ([]domain.MortalityReview, error) {

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

	rows, err := r.queries(ctx).ListQualityMortalityReviews(ctx,
		sqlcgen.ListQualityMortalityReviewsParams{
			TenantID: tenantID, OpenOnly: openOnly,
			FromAt: stamp(from), ToAt: stamp(to), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.MortalityReview, 0, len(rows))
	for _, row := range rows {
		out = append(out, reviewFrom(row))
	}
	return out, nil
}

func reviewFrom(row sqlcgen.QualityMortalityReview) domain.MortalityReview {
	return domain.MortalityReview{
		ID: row.ReviewID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		DiedAt:         timeOf(row.DiedAt),
		CommitteeID:    uuidString(row.CommitteeID),
		MeetingID:      uuidString(row.MeetingID),
		Classification: domain.DeathClassification(row.Classification),
		Findings:       row.Findings, LearningPoints: row.LearningPoints,
		CAPAIDs:  uuidStrings(row.CapaIds),
		State:    domain.RCAState(row.State),
		OpenedAt: timeOf(row.OpenedAt), OpenedBy: row.OpenedBy,
		CompletedAt: timeOf(row.CompletedAt), CompletedBy: row.CompletedBy,
		Version: row.Version,
	}
}
