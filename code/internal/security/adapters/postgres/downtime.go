package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/security/domain"
)

// Downtime episode persistence (SRS-SEC-014).

// InsertEpisode declares an outage.
//
// A second open episode for the same facility is refused by a partial unique
// index. Two concurrent declarations would split the reconciliation queue and
// a ward would work from the wrong one, entering half its forms.
func (r *Repository) InsertEpisode(ctx context.Context, scope authctx.TenantScope, e domain.DowntimeEpisode) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	episodeID, err := uuid.Parse(e.ID)
	if err != nil {
		return rpcerr.Internal("SEC_EPISODE_ID_INVALID", "episode_id must be a UUID").WithCause(err)
	}

	err = r.queries(ctx).InsertDowntimeEpisode(ctx, sqlcgen.InsertDowntimeEpisodeParams{
		EpisodeID:     episodeID,
		TenantID:      tenant,
		FacilityID:    e.FacilityID,
		Planned:       e.Planned,
		DeclaredBy:    e.DeclaredBy,
		DeclaredAt:    timestamptz(e.DeclaredAt),
		Reason:        e.Reason,
		Status:        string(e.Status),
		CorrelationID: e.CorrelationID,
	})
	if isUniqueViolation(err) {
		return rpcerr.FailedPrecondition("SEC_DOWNTIME_ALREADY_OPEN",
			"an unfinished downtime episode already exists for this facility")
	}
	return err
}

// GetEpisode reads an episode and every action recorded against it.
//
// Actions come back with the episode rather than through a separate call
// because the domain's rules — can this close, what is still outstanding —
// are all about the set, so handing back an episode without its actions
// invites a caller to answer those questions with incomplete information.
func (r *Repository) GetEpisode(ctx context.Context, scope authctx.TenantScope, episodeID string) (domain.DowntimeEpisode, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return domain.DowntimeEpisode{}, rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}

	row, err := r.queries(ctx).GetDowntimeEpisode(ctx, sqlcgen.GetDowntimeEpisodeParams{
		TenantID: tenant, EpisodeID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.DowntimeEpisode{}, rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}

	actions, err := r.queries(ctx).ListDowntimeActions(ctx, sqlcgen.ListDowntimeActionsParams{
		TenantID: tenant, EpisodeID: id,
	})
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}

	e := domain.DowntimeEpisode{
		ID:            row.EpisodeID.String(),
		TenantID:      row.TenantID.String(),
		FacilityID:    row.FacilityID,
		Planned:       row.Planned,
		DeclaredBy:    row.DeclaredBy,
		DeclaredAt:    row.DeclaredAt.Time,
		Reason:        row.Reason,
		Status:        domain.DowntimeStatus(row.Status),
		ClosedBy:      row.ClosedBy,
		CorrelationID: row.CorrelationID,
	}
	if row.RestoredAt.Valid {
		e.RestoredAt = row.RestoredAt.Time
	}
	if row.ClosedAt.Valid {
		e.ClosedAt = row.ClosedAt.Time
	}
	for _, a := range actions {
		action := domain.DowntimeAction{
			ID:           a.ActionID.String(),
			PerformedBy:  a.PerformedBy,
			PerformedAt:  a.PerformedAt.Time,
			ActionType:   a.ActionType,
			SubjectRef:   a.SubjectRef,
			Summary:      a.Summary,
			PaperFormRef: a.PaperFormRef,
			ReconciledBy: a.ReconciledBy,
			ResourceRef:  a.ResourceRef,
		}
		if a.ReconciledAt.Valid {
			action.ReconciledAt = a.ReconciledAt.Time
		}
		e.Actions = append(e.Actions, action)
	}
	return e, nil
}

// RecordAction logs something done on paper.
func (r *Repository) RecordAction(ctx context.Context, scope authctx.TenantScope, episodeID string, a domain.DowntimeAction) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	epID, err := uuid.Parse(episodeID)
	if err != nil {
		return rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}
	actionID, err := uuid.Parse(a.ID)
	if err != nil {
		return rpcerr.Internal("SEC_ACTION_ID_INVALID", "action_id must be a UUID").WithCause(err)
	}

	// Zero rows means ON CONFLICT DO NOTHING fired: the ward terminal retried.
	// That is success, not failure — the alternative is a duplicated
	// medication administration.
	_, err = r.queries(ctx).InsertDowntimeAction(ctx, sqlcgen.InsertDowntimeActionParams{
		ActionID:     actionID,
		EpisodeID:    epID,
		TenantID:     tenant,
		PerformedBy:  a.PerformedBy,
		PerformedAt:  timestamptz(a.PerformedAt),
		ActionType:   a.ActionType,
		SubjectRef:   a.SubjectRef,
		Summary:      a.Summary,
		PaperFormRef: a.PaperFormRef,
	})
	return err
}

// Restore marks the system available again.
func (r *Repository) Restore(ctx context.Context, scope authctx.TenantScope, episodeID string, at time.Time) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}

	rows, err := r.queries(ctx).RestoreDowntimeEpisode(ctx, sqlcgen.RestoreDowntimeEpisodeParams{
		RestoredAt: timestamptz(at), TenantID: tenant, EpisodeID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("SEC_DOWNTIME_NOT_OPEN", "episode is not open")
	}
	return nil
}

// ReconcileAction records that one paper action is now in the record.
func (r *Repository) ReconcileAction(ctx context.Context, scope authctx.TenantScope, episodeID, actionID, reconciledBy, resourceRef string, at time.Time) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	epID, err := uuid.Parse(episodeID)
	if err != nil {
		return rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}
	acID, err := uuid.Parse(actionID)
	if err != nil {
		return rpcerr.NotFound("SEC_ACTION_NOT_FOUND", "downtime action not found")
	}

	rows, err := r.queries(ctx).ReconcileDowntimeAction(ctx, sqlcgen.ReconcileDowntimeActionParams{
		ReconciledBy: reconciledBy,
		ReconciledAt: timestamptz(at),
		ResourceRef:  resourceRef,
		TenantID:     tenant,
		EpisodeID:    epID,
		ActionID:     acID,
	})
	if isUniqueViolation(err) {
		// The partial unique index on (episode_id, resource_ref) caught two
		// paper actions being pointed at one record entry, which would lose
		// one of them.
		return rpcerr.FailedPrecondition("SEC_RESOURCE_ALREADY_RECONCILED",
			"another action in this episode is already reconciled to that resource")
	}
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("SEC_ACTION_ALREADY_RECONCILED",
			"action is unknown or already entered into the record")
	}
	return nil
}

// CloseEpisode finishes an episode.
//
// The NOT EXISTS predicate lives in the statement, so an episode cannot be
// closed while paper is outstanding even by a caller that bypassed the domain.
// Zero rows means either "not recovering" or "still owes entries"; the message
// names both rather than guessing, because the caller can see which.
func (r *Repository) CloseEpisode(ctx context.Context, scope authctx.TenantScope, episodeID, closedBy string, at time.Time) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}

	rows, err := r.queries(ctx).CloseDowntimeEpisode(ctx, sqlcgen.CloseDowntimeEpisodeParams{
		ClosedBy: closedBy, ClosedAt: timestamptz(at), TenantID: tenant, EpisodeID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("SEC_DOWNTIME_NOT_CLOSEABLE",
			"episode is not recovering, or actions are still unreconciled")
	}
	return nil
}

// UnreconciledCount reports what an episode still owes the record.
func (r *Repository) UnreconciledCount(ctx context.Context, scope authctx.TenantScope, episodeID string) (int64, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return 0, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return 0, rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}
	return r.queries(ctx).CountUnreconciledActions(ctx, sqlcgen.CountUnreconciledActionsParams{
		TenantID: tenant, EpisodeID: id,
	})
}
