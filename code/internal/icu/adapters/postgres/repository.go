// Package postgres is the critical-care persistence adapter.
//
// It is the only package permitted to issue SQL against the icu schema
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

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the critical-care repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("ICU_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("ICU_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("ICU_NOT_FOUND", "no such critical-care record")
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

// EpisodeRepo implements ports.EpisodeRepository.
type EpisodeRepo struct{ *Repository }

var _ ports.EpisodeRepository = EpisodeRepo{}

// InsertEpisode admits a patient to critical care.
func (r EpisodeRepo) InsertEpisode(ctx context.Context, scope authctx.TenantScope,
	e domain.Episode) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	// The aggregate must belong to the scope that is writing it. A caller who
	// assembled one by hand must not be able to plant it in another tenant.
	if e.TenantID != scope.TenantID() {
		return rpcerr.Internal("ICU_SCOPE_MISMATCH",
			"this episode belongs to another tenant")
	}
	episodeID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	encounterID, err := uuid.Parse(e.EncounterID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(e.PatientID)
	if err != nil {
		return notFound()
	}
	transferredFrom, err := optionalUUID(e.TransferredFrom)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertIcuEpisode(ctx, sqlcgen.InsertIcuEpisodeParams{
		EpisodeID: episodeID, TenantID: tenantID, EncounterID: encounterID,
		PatientID: patientID, FacilityID: e.FacilityID,
		UnitID: e.UnitID, BedID: e.BedID, Source: string(e.Source),
		TransferredFrom:      transferredFrom,
		ResponsibleTeam:      e.ResponsibleTeam,
		ResponsibleClinician: e.ResponsibleClinician,
		Status:               string(e.Status),
		AdmittedAt:           stamp(e.AdmittedAt),
		CreatedBy:            e.CreatedBy,
		CreatedAt:            stamp(e.CreatedAt),
		UpdatedAt:            stamp(e.UpdatedAt),
	})
}

// GetEpisode reads one episode.
func (r EpisodeRepo) GetEpisode(ctx context.Context, scope authctx.TenantScope,
	episodeID string) (domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Episode{}, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return domain.Episode{}, notFound()
	}

	row, err := r.queries(ctx).GetIcuEpisode(ctx, sqlcgen.GetIcuEpisodeParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Episode{}, notFound()
	}
	if err != nil {
		return domain.Episode{}, err
	}
	return episodeFrom(row), nil
}

// UpdateEpisode writes an episode back, guarded on its version.
func (r EpisodeRepo) UpdateEpisode(ctx context.Context, scope authctx.TenantScope,
	e domain.Episode, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	if e.TenantID != scope.TenantID() {
		return rpcerr.Internal("ICU_SCOPE_MISMATCH",
			"this episode belongs to another tenant")
	}
	episodeID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateIcuEpisode(ctx, sqlcgen.UpdateIcuEpisodeParams{
		BedID:                e.BedID,
		ResponsibleTeam:      e.ResponsibleTeam,
		ResponsibleClinician: e.ResponsibleClinician,
		Status:               string(e.Status),
		ReadyAt:              stamp(e.ReadyAt),
		DischargedAt:         stamp(e.DischargedAt),
		Outcome:              string(e.Outcome),
		OutcomeNote:          e.OutcomeNote,
		UpdatedAt:            stamp(e.UpdatedAt),
		TenantID:             tenantID,
		EpisodeID:            episodeID,
		ExpectedVersion:      expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Either the row is gone or somebody else advanced it. Both are the
		// caller's problem to retry, and telling them apart would need a
		// second read that answers a question nobody asked.
		return ports.ErrVersionConflict
	}
	e.Version = expectedVersion + 1
	return nil
}

// OpenEpisodes is the unit as it stands.
func (r EpisodeRepo) OpenEpisodes(ctx context.Context, scope authctx.TenantScope,
	unitID string, limit int32) ([]domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListOpenIcuEpisodes(ctx, sqlcgen.ListOpenIcuEpisodesParams{
		TenantID: tenantID, UnitID: unitID, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Episode, 0, len(rows))
	for _, row := range rows {
		out = append(out, episodeFrom(row))
	}
	return out, nil
}

// EpisodesInPeriod is every episode overlapping a window.
func (r EpisodeRepo) EpisodesInPeriod(ctx context.Context, scope authctx.TenantScope,
	unitID string, from, to time.Time) ([]domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListIcuEpisodesInPeriod(ctx,
		sqlcgen.ListIcuEpisodesInPeriodParams{
			TenantID: tenantID, UnitID: unitID,
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Episode, 0, len(rows))
	for _, row := range rows {
		out = append(out, episodeFrom(row))
	}
	return out, nil
}

func episodeFrom(row sqlcgen.IcuEpisode) domain.Episode {
	return domain.Episode{
		ID: row.EpisodeID.String(), TenantID: row.TenantID.String(),
		EncounterID: row.EncounterID.String(), PatientID: row.PatientID.String(),
		FacilityID: row.FacilityID, UnitID: row.UnitID, BedID: row.BedID,
		Source:               domain.AdmissionSource(row.Source),
		TransferredFrom:      uuidOrEmpty(row.TransferredFrom),
		ResponsibleTeam:      row.ResponsibleTeam,
		ResponsibleClinician: row.ResponsibleClinician,
		Status:               domain.EpisodeStatus(row.Status),
		AdmittedAt:           timeOf(row.AdmittedAt),
		ReadyAt:              timeOf(row.ReadyAt),
		DischargedAt:         timeOf(row.DischargedAt),
		Outcome:              domain.Outcome(row.Outcome),
		OutcomeNote:          row.OutcomeNote,
		CreatedBy:            row.CreatedBy,
		CreatedAt:            timeOf(row.CreatedAt),
		UpdatedAt:            timeOf(row.UpdatedAt),
		Version:              row.Version,
	}
}
