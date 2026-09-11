package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/security/domain"
)

// Downtime use cases (SRS-SEC-014).
//
// The shape of these differs from the emergency-access ones in a way worth
// naming: recording a paper action is deliberately permissive and closing an
// episode is deliberately strict. During an outage the priority is that
// nothing gets lost, so a ward can record freely; the control sits at the end,
// where an episode cannot close while anything is still owed to the chart.

// DeclareDowntimeInput opens an episode.
type DeclareDowntimeInput struct {
	FacilityID string
	Planned    bool
	Reason     string
}

// DeclareDowntime opens a downtime episode for a facility.
func (s *Service) DeclareDowntime(ctx context.Context, in DeclareDowntimeInput) (domain.DowntimeEpisode, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.DowntimeEpisode{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	facility := in.FacilityID
	if facility == "" {
		facility = session.ActiveFacilityID
	}
	decision := policy.Evaluate(session, policy.Request{
		Permission:         PermDowntimeDeclare,
		Mutating:           true,
		ResourceFacilityID: facility,
		// The declaration is about one ward, so the credential has to reach
		// that ward. Without this a user could declare an outage at a facility
		// they have never worked in and open a reconciliation queue there.
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return domain.DowntimeEpisode{}, rpcerr.PermissionDenied("SEC_DOWNTIME_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	episode, err := domain.NewDowntimeEpisode(s.ids.NewID(), session.TenantID, facility,
		session.SubjectID, in.Reason, session.CorrelationID, in.Planned, now)
	if errors.Is(err, domain.ErrInvalidDowntime) {
		return domain.DowntimeEpisode{}, rpcerr.Invalid("SEC_DOWNTIME_INVALID", err.Error())
	}
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}

	scope := session.TenantScope()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.downtime.InsertEpisode(ctx, scope, episode); err != nil {
			return err
		}
		detail, err := json.Marshal(map[string]any{
			"facility_id": episode.FacilityID,
			"planned":     episode.Planned,
			"reason":      episode.Reason,
		})
		if err != nil {
			return rpcerr.Internal("SEC_EVENT_ENCODE_FAILED", "could not encode security event").WithCause(err)
		}
		// High rather than critical: an unplanned outage matters, but unlike
		// break glass it is not somebody reaching past a control, and paging
		// on every planned maintenance window trains people to ignore the page.
		severity := domain.SeverityHigh
		if episode.Planned {
			severity = domain.SeverityInfo
		}
		return s.appendEvent(ctx, session, domain.SecurityEvent{
			Class:        domain.ClassConfigurationChange,
			Severity:     severity,
			ResourceType: "downtime_episode",
			ResourceID:   episode.ID,
			Outcome:      domain.OutcomeSuccess,
			Detail:       detail,
		}, now)
	})
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}
	return episode, nil
}

// RecordDowntimeActionInput is one thing done on paper.
type RecordDowntimeActionInput struct {
	EpisodeID    string
	PerformedBy  string
	PerformedAt  time.Time
	ActionType   string
	SubjectRef   string
	Summary      string
	PaperFormRef string
	// ActionID is supplied by the caller so a retry from a ward terminal that
	// lost its response is idempotent. A server-minted id would make every
	// retry a new clinical entry.
	ActionID string
}

// RecordDowntimeAction logs an action taken during an outage.
//
// PerformedBy may differ from the session subject: a ward clerk entering the
// forms afterwards is the normal case, and recording the clerk as the clinician
// would put the wrong name against a medication administration. The session
// subject is still captured, on the security event, so both facts survive.
func (s *Service) RecordDowntimeAction(ctx context.Context, in RecordDowntimeActionInput) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	scope := session.TenantScope()
	episode, err := s.downtime.GetEpisode(ctx, scope, in.EpisodeID)
	if err != nil {
		return err
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission:           PermDowntimeRecord,
		Mutating:             true,
		ResourceFacilityID:   episode.FacilityID,
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return rpcerr.PermissionDenied("SEC_DOWNTIME_RECORD_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	actionID := in.ActionID
	if actionID == "" {
		actionID = s.ids.NewID()
	}
	action := domain.DowntimeAction{
		ID:           actionID,
		PerformedBy:  in.PerformedBy,
		PerformedAt:  in.PerformedAt,
		ActionType:   in.ActionType,
		SubjectRef:   in.SubjectRef,
		Summary:      in.Summary,
		PaperFormRef: in.PaperFormRef,
	}
	// The domain validates against the episode it belongs to — an action
	// cannot predate the outage or sit in the future — and appends to the
	// in-memory copy. The store then writes only the new row.
	if err := episode.RecordAction(action, now); err != nil {
		return rpcerr.Invalid("SEC_DOWNTIME_ACTION_INVALID", err.Error())
	}
	return s.downtime.RecordAction(ctx, scope, episode.ID, action)
}

// RestoreDowntime marks the system available again for an episode.
func (s *Service) RestoreDowntime(ctx context.Context, episodeID string) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	scope := session.TenantScope()
	episode, err := s.downtime.GetEpisode(ctx, scope, episodeID)
	if err != nil {
		return err
	}
	decision := policy.Evaluate(session, policy.Request{
		Permission:           PermDowntimeDeclare,
		Mutating:             true,
		ResourceFacilityID:   episode.FacilityID,
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return rpcerr.PermissionDenied("SEC_DOWNTIME_DENIED", decision.Reason)
	}
	return s.downtime.Restore(ctx, scope, episodeID, s.clock.Now())
}

// ReconcileDowntimeActionInput enters one paper action into the record.
type ReconcileDowntimeActionInput struct {
	EpisodeID   string
	ActionID    string
	ResourceRef string
}

// ReconcileDowntimeAction records that a paper action is now in the system.
//
// ResourceRef is what the action became — the administration, the note, the
// order. It is required, so "reconciled" cannot mean "somebody ticked it off".
func (s *Service) ReconcileDowntimeAction(ctx context.Context, in ReconcileDowntimeActionInput) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	scope := session.TenantScope()
	episode, err := s.downtime.GetEpisode(ctx, scope, in.EpisodeID)
	if err != nil {
		return err
	}
	decision := policy.Evaluate(session, policy.Request{
		Permission:           PermDowntimeReconcile,
		Mutating:             true,
		ResourceFacilityID:   episode.FacilityID,
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return rpcerr.PermissionDenied("SEC_DOWNTIME_RECONCILE_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	if err := episode.Reconcile(in.ActionID, session.SubjectID, in.ResourceRef, now); err != nil {
		return rpcerr.FailedPrecondition("SEC_DOWNTIME_RECONCILE_REFUSED", err.Error())
	}
	return s.downtime.ReconcileAction(ctx, scope, in.EpisodeID, in.ActionID, session.SubjectID, in.ResourceRef, now)
}

// CloseDowntime finishes an episode.
//
// Refuses while anything is unreconciled. The store enforces the same rule in
// its statement, so this check is the one that produces a useful message and
// the statement is the one that cannot be bypassed.
func (s *Service) CloseDowntime(ctx context.Context, episodeID string) (domain.DowntimeEpisode, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.DowntimeEpisode{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	scope := session.TenantScope()
	episode, err := s.downtime.GetEpisode(ctx, scope, episodeID)
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}
	decision := policy.Evaluate(session, policy.Request{
		Permission:           PermDowntimeDeclare,
		Mutating:             true,
		ResourceFacilityID:   episode.FacilityID,
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return domain.DowntimeEpisode{}, rpcerr.PermissionDenied("SEC_DOWNTIME_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	if err := episode.Close(session.SubjectID, now); err != nil {
		if errors.Is(err, domain.ErrUnreconciled) {
			return domain.DowntimeEpisode{}, rpcerr.FailedPrecondition("SEC_DOWNTIME_UNRECONCILED", err.Error())
		}
		return domain.DowntimeEpisode{}, rpcerr.FailedPrecondition("SEC_DOWNTIME_NOT_CLOSEABLE", err.Error())
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.downtime.CloseEpisode(ctx, scope, episodeID, session.SubjectID, now); err != nil {
			return err
		}
		detail, err := json.Marshal(map[string]any{
			"facility_id":        episode.FacilityID,
			"actions_reconciled": len(episode.Actions),
			"declared_at":        episode.DeclaredAt.Format(time.RFC3339),
			"restored_at":        episode.RestoredAt.Format(time.RFC3339),
		})
		if err != nil {
			return rpcerr.Internal("SEC_EVENT_ENCODE_FAILED", "could not encode security event").WithCause(err)
		}
		return s.appendEvent(ctx, session, domain.SecurityEvent{
			Class:        domain.ClassConfigurationChange,
			Severity:     domain.SeverityInfo,
			ResourceType: "downtime_episode",
			ResourceID:   episode.ID,
			Outcome:      domain.OutcomeSuccess,
			Detail:       detail,
		}, now)
	})
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}
	return episode, nil
}

// GetDowntimeEpisode reads an episode and its reconciliation queue.
func (s *Service) GetDowntimeEpisode(ctx context.Context, episodeID string) (domain.DowntimeEpisode, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.DowntimeEpisode{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	scope := session.TenantScope()
	episode, err := s.downtime.GetEpisode(ctx, scope, episodeID)
	if err != nil {
		return domain.DowntimeEpisode{}, err
	}
	decision := policy.Evaluate(session, policy.Request{
		Permission:           PermDowntimeRecord,
		ResourceFacilityID:   episode.FacilityID,
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadOnly,
	})
	if !decision.Allowed {
		// NOT_FOUND, not PERMISSION_DENIED: the second confirms the episode
		// exists, which is the same probe the tenant-isolation tests forbid.
		return domain.DowntimeEpisode{}, rpcerr.NotFound("SEC_EPISODE_NOT_FOUND", "downtime episode not found")
	}
	return episode, nil
}
