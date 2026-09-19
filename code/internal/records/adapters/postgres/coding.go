package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/records/domain"
)

// InsertEpisode opens an episode for coding (SRS-MRD-003).
func (r *Repository) InsertEpisode(ctx context.Context,
	scope authctx.TenantScope, e domain.CodedEpisode) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	episodeID, err := uuid.Parse(e.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_EPISODE_ID_INVALID",
			"episode id must be a UUID")
	}

	return r.queries(ctx).InsertRecordsCodedEpisode(ctx,
		sqlcgen.InsertRecordsCodedEpisodeParams{
			EpisodeID: episodeID, TenantID: tenantID,
			PatientID: e.PatientID, EncounterID: e.EncounterID,
			FacilityID: e.FacilityID,
			CreatedAt:  stamp(e.CreatedAt), CreatedBy: e.CreatedBy,
		})
}

// Episode loads an episode with every revision and every code.
func (r *Repository) Episode(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.CodedEpisode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	episodeID, err := uuid.Parse(id)
	if err != nil {
		return domain.CodedEpisode{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsCodedEpisode(ctx,
		sqlcgen.GetRecordsCodedEpisodeParams{
			TenantID: tenantID, EpisodeID: episodeID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CodedEpisode{}, notFound()
	}
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	return r.loadEpisode(ctx, tenantID, row)
}

// EpisodeForEncounter is how a coder reaches an encounter's coding. False
// rather than an error where there is none: an encounter nobody has started
// coding is the ordinary case.
func (r *Repository) EpisodeForEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID string) (
	domain.CodedEpisode, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CodedEpisode{}, false, err
	}

	row, err := r.queries(ctx).GetRecordsCodedEpisodeByEncounter(ctx,
		sqlcgen.GetRecordsCodedEpisodeByEncounterParams{
			TenantID: tenantID, EncounterID: encounterID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CodedEpisode{}, false, nil
	}
	if err != nil {
		return domain.CodedEpisode{}, false, err
	}
	episode, err := r.loadEpisode(ctx, tenantID, row)
	return episode, err == nil, err
}

func (r *Repository) loadEpisode(ctx context.Context, tenantID uuid.UUID,
	row sqlcgen.RecordsCodedEpisode) (domain.CodedEpisode, error) {

	episode := domain.CodedEpisode{
		ID: row.EpisodeID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		FacilityID: row.FacilityID,
		CreatedAt:  timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}

	revisions, err := r.queries(ctx).ListRecordsCodingRevisions(ctx,
		sqlcgen.ListRecordsCodingRevisionsParams{
			TenantID: tenantID, EpisodeID: row.EpisodeID,
		})
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	codes, err := r.queries(ctx).ListRecordsAssignedCodes(ctx,
		sqlcgen.ListRecordsAssignedCodesParams{
			TenantID: tenantID, EpisodeID: row.EpisodeID,
		})
	if err != nil {
		return domain.CodedEpisode{}, err
	}

	byRevision := map[uuid.UUID][]domain.AssignedCode{}
	for _, code := range codes {
		byRevision[code.RevisionID] = append(byRevision[code.RevisionID],
			domain.AssignedCode{
				System: code.CodeSystem, Version: code.CodeVersion,
				Code: code.CodeValue, Display: code.Display,
				Role: domain.CodeRole(code.Role), Sequence: int(code.Sequence),
				POA:              domain.PresentOnAdmission(code.PresentOnAdmission),
				SourceDocumentID: code.SourceDocumentID,
			})
	}

	for _, revision := range revisions {
		// The domain's order, not the query's. Ordering by code value would
		// put a secondary diagnosis ahead of the principal one whenever it
		// sorted earlier alphabetically, and a grouper reads position.
		assigned := byRevision[revision.RevisionID]
		domain.SortCodes(assigned)
		episode.Revisions = append(episode.Revisions, domain.CodingRevision{
			Revision: int(revision.Revision), Codes: assigned,
			Reason:  revision.Reason,
			CodedBy: revision.CodedBy, CodedAt: timeOf(revision.CodedAt),
			State:      domain.CodingState(revision.State),
			ReviewedBy: revision.ReviewedBy,
			ReviewedAt: timeOf(revision.ReviewedAt),
		})
	}
	return episode, nil
}

// AppendRevision adds a revision and its codes (SRS-MRD-003).
//
// Append-only: the previous revision's rows are untouched, which is what lets
// a hospital answer "what did we bill under last quarter". The episode's
// version is bumped in the same transaction, so two coders racing to re-code
// the same episode do not both win.
func (r *Repository) AppendRevision(ctx context.Context,
	scope authctx.TenantScope, episode domain.CodedEpisode,
	revision domain.CodingRevision, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	episodeID, err := uuid.Parse(episode.ID)
	if err != nil {
		return notFound()
	}

	queries := r.queries(ctx)
	bumped, err := queries.BumpRecordsCodedEpisode(ctx,
		sqlcgen.BumpRecordsCodedEpisodeParams{
			TenantID: tenantID, EpisodeID: episodeID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if err := conflict(bumped); err != nil {
		return err
	}

	revisionID := uuid.New()
	if err := queries.InsertRecordsCodingRevision(ctx,
		sqlcgen.InsertRecordsCodingRevisionParams{
			RevisionID: revisionID, TenantID: tenantID,
			EpisodeID: episodeID, Revision: int32(revision.Revision),
			Reason: revision.Reason, State: string(revision.State),
			CodedBy: revision.CodedBy, CodedAt: stamp(revision.CodedAt),
			ReviewedBy: revision.ReviewedBy,
			ReviewedAt: stamp(revision.ReviewedAt),
		}); err != nil {
		return err
	}

	for _, code := range revision.Codes {
		if err := queries.InsertRecordsAssignedCode(ctx,
			sqlcgen.InsertRecordsAssignedCodeParams{
				CodeID: uuid.New(), TenantID: tenantID,
				RevisionID: revisionID, CodeSystem: code.System,
				CodeVersion: code.Version, CodeValue: code.Code,
				Display: code.Display, Role: string(code.Role),
				Sequence:           int32(code.Sequence),
				PresentOnAdmission: string(code.POA),
				SourceDocumentID:   code.SourceDocumentID,
			}); err != nil {
			return err
		}
	}
	return nil
}

// SetRevisionState records a second read or a query on the current revision.
func (r *Repository) SetRevisionState(ctx context.Context,
	scope authctx.TenantScope, episodeID string,
	revision domain.CodingRevision) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ListRecordsCodingRevisions(ctx,
		sqlcgen.ListRecordsCodingRevisionsParams{
			TenantID: tenantID, EpisodeID: id,
		})
	if err != nil {
		return err
	}
	for _, row := range rows {
		if int(row.Revision) != revision.Revision {
			continue
		}
		affected, err := r.queries(ctx).UpdateRecordsCodingRevision(ctx,
			sqlcgen.UpdateRecordsCodingRevisionParams{
				State:      string(revision.State),
				ReviewedBy: revision.ReviewedBy,
				ReviewedAt: stamp(revision.ReviewedAt),
				TenantID:   tenantID, RevisionID: row.RevisionID,
			})
		if err != nil {
			return err
		}
		if affected == 0 {
			return notFound()
		}
		return nil
	}
	return notFound()
}
