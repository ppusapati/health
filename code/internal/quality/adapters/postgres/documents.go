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

// DocumentRepo implements ports.DocumentRepository.
type DocumentRepo struct{ *Repository }

var _ ports.DocumentRepository = DocumentRepo{}

// InsertDocument registers a controlled document (SRS-QMS-006).
func (r DocumentRepo) InsertDocument(ctx context.Context,
	scope authctx.TenantScope, d domain.ControlledDocument) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	documentID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityDocument(ctx,
		sqlcgen.InsertQualityDocumentParams{
			DocumentID: documentID, TenantID: tenantID,
			Code: d.Code, Title: d.Title, Kind: string(d.Kind),
			OwnerID: d.OwnerID, ReviewMonths: int32(d.ReviewMonths),
			Department: d.Department,
			CreatedAt:  stamp(d.CreatedAt), CreatedBy: d.CreatedBy,
		})
}

// Document reads one.
func (r DocumentRepo) Document(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.ControlledDocument, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ControlledDocument{}, err
	}
	documentID, err := uuid.Parse(id)
	if err != nil {
		return domain.ControlledDocument{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityDocument(ctx,
		sqlcgen.GetQualityDocumentParams{
			TenantID: tenantID, DocumentID: documentID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.ControlledDocument{}, notFound()
	}
	if err != nil {
		return domain.ControlledDocument{}, err
	}
	return documentFrom(row), nil
}

// UpdateDocument writes an ownership or withdrawal change.
func (r DocumentRepo) UpdateDocument(ctx context.Context,
	scope authctx.TenantScope, d domain.ControlledDocument,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	documentID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityDocument(ctx,
		sqlcgen.UpdateQualityDocumentParams{
			TenantID: tenantID, DocumentID: documentID,
			Title: d.Title, OwnerID: d.OwnerID,
			ReviewMonths: int32(d.ReviewMonths), Department: d.Department,
			Withdrawn: d.Withdrawn, WithdrawnAt: stamp(d.WithdrawnAt),
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

// Documents lists the register.
func (r DocumentRepo) Documents(ctx context.Context, scope authctx.TenantScope,
	f ports.DocumentFilter) ([]domain.ControlledDocument, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityDocuments(ctx,
		sqlcgen.ListQualityDocumentsParams{
			TenantID: tenantID, Kind: f.Kind, Department: f.Department,
			ExcludeWithdrawn: f.ExcludeWithdrawn, RowLimit: f.Limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.ControlledDocument, 0, len(rows))
	for _, row := range rows {
		out = append(out, documentFrom(row))
	}
	return out, nil
}

// InsertVersion drafts a revision (SRS-QMS-006).
func (r DocumentRepo) InsertVersion(ctx context.Context,
	scope authctx.TenantScope, v domain.DocumentVersion) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	versionID, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}
	documentID, err := uuid.Parse(v.DocumentID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityDocumentVersion(ctx,
		sqlcgen.InsertQualityDocumentVersionParams{
			VersionID: versionID, TenantID: tenantID, DocumentID: documentID,
			Label: v.Label, Ordinal: int32(v.Ordinal),
			ContentRef: v.ContentRef, ChangeSummary: v.ChangeSummary,
			State:                   string(v.State),
			RequiresAcknowledgement: v.RequiresAcknowledgement,
			RequiresRetraining:      v.RequiresRetraining,
			CreatedAt:               stamp(v.CreatedAt), CreatedBy: v.CreatedBy,
		})
}

// Version reads one revision.
func (r DocumentRepo) Version(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.DocumentVersion, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.DocumentVersion{}, err
	}
	versionID, err := uuid.Parse(id)
	if err != nil {
		return domain.DocumentVersion{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityDocumentVersion(ctx,
		sqlcgen.GetQualityDocumentVersionParams{
			TenantID: tenantID, VersionID: versionID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.DocumentVersion{}, notFound()
	}
	if err != nil {
		return domain.DocumentVersion{}, err
	}
	return versionFrom(row), nil
}

// UpdateVersion writes an approval or an obsolescence.
func (r DocumentRepo) UpdateVersion(ctx context.Context,
	scope authctx.TenantScope, v domain.DocumentVersion,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	versionID, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityDocumentVersion(ctx,
		sqlcgen.UpdateQualityDocumentVersionParams{
			TenantID: tenantID, VersionID: versionID,
			State: string(v.State), ContentRef: v.ContentRef,
			ChangeSummary: v.ChangeSummary,
			ApprovedBy:    v.ApprovedBy, ApprovedAt: stamp(v.ApprovedAt),
			EffectiveFrom:   stamp(v.EffectiveFrom),
			ObsoleteFrom:    stamp(v.ObsoleteFrom),
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

// Versions lists every revision, which is what the current-version rule reads.
func (r DocumentRepo) Versions(ctx context.Context, scope authctx.TenantScope,
	documentID string) ([]domain.DocumentVersion, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(documentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListQualityDocumentVersions(ctx,
		sqlcgen.ListQualityDocumentVersionsParams{
			TenantID: tenantID, DocumentID: parsed,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.DocumentVersion, 0, len(rows))
	for _, row := range rows {
		out = append(out, versionFrom(row))
	}
	return out, nil
}

// Acknowledge records that somebody has read a version (SRS-QMS-006).
//
// Idempotent: the button will be pressed twice, and a second confirmation is
// not an error.
func (r DocumentRepo) Acknowledge(ctx context.Context,
	scope authctx.TenantScope, a domain.Acknowledgement) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ackID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}
	versionID, err := uuid.Parse(a.VersionID)
	if err != nil {
		return notFound()
	}
	documentID, err := uuid.Parse(a.DocumentID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityAcknowledgement(ctx,
		sqlcgen.InsertQualityAcknowledgementParams{
			AcknowledgementID: ackID, TenantID: tenantID,
			VersionID: versionID, DocumentID: documentID,
			PersonID: a.PersonID, Role: a.Role,
			AcknowledgedAt: stamp(a.AcknowledgedAt),
		})
}

// Acknowledgements lists who has read one version.
func (r DocumentRepo) Acknowledgements(ctx context.Context,
	scope authctx.TenantScope, versionID string) ([]domain.Acknowledgement,
	error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(versionID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListQualityAcknowledgements(ctx,
		sqlcgen.ListQualityAcknowledgementsParams{
			TenantID: tenantID, VersionID: parsed,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Acknowledgement, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Acknowledgement{
			ID:         row.AcknowledgementID.String(),
			TenantID:   row.TenantID.String(),
			VersionID:  row.VersionID.String(),
			DocumentID: row.DocumentID.String(),
			PersonID:   row.PersonID, Role: row.Role,
			AcknowledgedAt: timeOf(row.AcknowledgedAt),
		})
	}
	return out, nil
}

func documentFrom(row sqlcgen.QualityDocument) domain.ControlledDocument {
	return domain.ControlledDocument{
		ID: row.DocumentID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Title: row.Title,
		Kind: domain.DocumentKind(row.Kind), OwnerID: row.OwnerID,
		ReviewMonths: int(row.ReviewMonths), Department: row.Department,
		Withdrawn: row.Withdrawn, WithdrawnAt: timeOf(row.WithdrawnAt),
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

func versionFrom(row sqlcgen.QualityDocumentVersion) domain.DocumentVersion {
	return domain.DocumentVersion{
		ID: row.VersionID.String(), TenantID: row.TenantID.String(),
		DocumentID: row.DocumentID.String(),
		Label:      row.Label, Ordinal: int(row.Ordinal),
		ContentRef: row.ContentRef, ChangeSummary: row.ChangeSummary,
		State:      domain.VersionState(row.State),
		ApprovedBy: row.ApprovedBy, ApprovedAt: timeOf(row.ApprovedAt),
		EffectiveFrom:           timeOf(row.EffectiveFrom),
		ObsoleteFrom:            timeOf(row.ObsoleteFrom),
		RequiresAcknowledgement: row.RequiresAcknowledgement,
		RequiresRetraining:      row.RequiresRetraining,
		CreatedAt:               timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.RowVersion,
	}
}

// CompetencyRepo implements ports.CompetencyRepository.
type CompetencyRepo struct{ *Repository }

var _ ports.CompetencyRepository = CompetencyRepo{}

// InsertCompetency registers a skill (SRS-QMS-013).
func (r CompetencyRepo) InsertCompetency(ctx context.Context,
	scope authctx.TenantScope, c domain.Competency) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	competencyID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityCompetency(ctx,
		sqlcgen.InsertQualityCompetencyParams{
			CompetencyID: competencyID, TenantID: tenantID,
			Code: c.Code, Name: c.Name,
			DocumentID:  optionalUUID(c.DocumentID),
			ValidMonths: int32(c.ValidMonths), Active: c.Active,
			CreatedAt: stamp(c.CreatedAt), CreatedBy: c.CreatedBy,
		})
}

// Competencies lists the catalogue.
func (r CompetencyRepo) Competencies(ctx context.Context,
	scope authctx.TenantScope, activeOnly bool) ([]domain.Competency, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityCompetencies(ctx,
		sqlcgen.ListQualityCompetenciesParams{
			TenantID: tenantID, ActiveOnly: activeOnly,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Competency, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Competency{
			ID: row.CompetencyID.String(), TenantID: row.TenantID.String(),
			Code: row.Code, Name: row.Name,
			DocumentID:  uuidString(row.DocumentID),
			ValidMonths: int(row.ValidMonths), Active: row.Active,
			CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
			Version: row.Version,
		})
	}
	return out, nil
}

// RequireForRole says a role needs a competency (SRS-QMS-013).
func (r CompetencyRepo) RequireForRole(ctx context.Context,
	scope authctx.TenantScope, role, competencyID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := uuid.Parse(competencyID)
	if err != nil {
		return notFound()
	}
	return r.queries(ctx).SetQualityRoleCompetency(ctx,
		sqlcgen.SetQualityRoleCompetencyParams{
			TenantID: tenantID, Role: role, CompetencyID: parsed,
		})
}

// RoleRequirements maps each role to what it needs.
func (r CompetencyRepo) RoleRequirements(ctx context.Context,
	scope authctx.TenantScope) (map[string][]string, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityRoleCompetencies(ctx, tenantID)
	if err != nil {
		return nil, err
	}
	out := map[string][]string{}
	for _, row := range rows {
		out[row.Role] = append(out[row.Role], row.CompetencyID.String())
	}
	return out, nil
}

// InsertAward records somebody holding a competency (SRS-QMS-013).
func (r CompetencyRepo) InsertAward(ctx context.Context,
	scope authctx.TenantScope, a domain.Award) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	awardID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}
	competencyID, err := uuid.Parse(a.CompetencyID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityAward(ctx,
		sqlcgen.InsertQualityAwardParams{
			AwardID: awardID, TenantID: tenantID, CompetencyID: competencyID,
			PersonID: a.PersonID, VersionID: optionalUUID(a.VersionID),
			Evidence:  a.Evidence,
			AwardedAt: stamp(a.AwardedAt), AwardedBy: a.AwardedBy,
			ExpiresAt: stamp(a.ExpiresAt),
		})
}

// RevokeAward withdraws one. The row stays: a revocation is a fact about the
// person and about whoever assessed them.
func (r CompetencyRepo) RevokeAward(ctx context.Context,
	scope authctx.TenantScope, awardID, reason string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := uuid.Parse(awardID)
	if err != nil {
		return notFound()
	}
	rows, err := r.queries(ctx).RevokeQualityAward(ctx,
		sqlcgen.RevokeQualityAwardParams{
			TenantID: tenantID, AwardID: parsed,
			RevokedAt: stamp(at), RevokedWhy: reason,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// Awards lists what one person holds, or everybody.
func (r CompetencyRepo) Awards(ctx context.Context, scope authctx.TenantScope,
	personID string, limit int32) ([]domain.Award, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityAwards(ctx,
		sqlcgen.ListQualityAwardsParams{
			TenantID: tenantID, PersonID: personID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Award, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Award{
			ID: row.AwardID.String(), TenantID: row.TenantID.String(),
			CompetencyID: row.CompetencyID.String(), PersonID: row.PersonID,
			VersionID: uuidString(row.VersionID), Evidence: row.Evidence,
			AwardedAt: timeOf(row.AwardedAt), AwardedBy: row.AwardedBy,
			ExpiresAt: timeOf(row.ExpiresAt),
			RevokedAt: timeOf(row.RevokedAt), RevokedWhy: row.RevokedWhy,
		})
	}
	return out, nil
}
