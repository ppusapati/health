// Package application holds the security platform's use cases.
//
// Every use case here writes to the tamper-evident chain in the same
// transaction as the change it describes (SRS-SEC-012). That coupling is the
// point: an event appended afterwards can be lost by a crash between the two
// writes, and the one record an attacker most wants missing is the record of
// what they did.
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
	"github.com/ppusapati/health/code/internal/security/ports"
)

// Permission names for the security platform.
const (
	PermEmergencyActivate = "security.emergency.activate"
	PermEmergencyReview   = "security.emergency.review"
	PermDowntimeDeclare   = "security.downtime.declare"
	PermDowntimeRecord    = "security.downtime.record"
	PermDowntimeReconcile = "security.downtime.reconcile"
	PermSecurityRead      = "security.event.read"
)

// Service is the security platform's use-case façade.
type Service struct {
	uow      ports.UnitOfWork
	events   ports.SecurityEventStore
	grants   ports.EmergencyGrantStore
	downtime ports.DowntimeStore
	ids      ports.IDGenerator
	clock    ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(
	uow ports.UnitOfWork,
	events ports.SecurityEventStore,
	grants ports.EmergencyGrantStore,
	downtime ports.DowntimeStore,
	ids ports.IDGenerator,
	clock ports.Clock,
) *Service {
	return &Service{uow: uow, events: events, grants: grants,
		downtime: downtime, ids: ids, clock: clock}
}

// ActivateEmergencyAccessInput is the break-glass command.
type ActivateEmergencyAccessInput struct {
	IncidentRef   string
	Justification string
	Permissions   []string
	TTL           time.Duration
}

// ActivateEmergencyAccess opens a break-glass grant (SRS-SEC-014, SRS-IAM-005).
//
// Three things make this safe rather than a bypass, and all three are here
// rather than in the caller:
//
//   - the requested permissions are checked against what the session already
//     holds, so the grant widens reach and never privilege;
//   - a concurrent second activation is refused by the store's unique index,
//     not by a read this method performs;
//   - the activation writes a critical security event in the same transaction,
//     so a grant cannot exist without the record of it existing.
func (s *Service) ActivateEmergencyAccess(ctx context.Context, in ActivateEmergencyAccessInput) (domain.EmergencyGrant, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.EmergencyGrant{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermEmergencyActivate,
		Mutating:   true,
		// Read-write rather than resolved from the tenant's posture: a
		// suspended tenant is exactly the situation in which somebody may
		// legitimately need emergency access to the record, and refusing it
		// would push care onto paper.
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return domain.EmergencyGrant{}, rpcerr.PermissionDenied("SEC_EMERGENCY_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	grant, err := domain.NewEmergencyGrant(
		s.ids.NewID(), session.TenantID, session.SubjectID, session.ActiveFacilityID,
		in.IncidentRef, in.Justification, session.CorrelationID,
		in.Permissions, session.Permissions, in.TTL,
		// The store's unique index is the authority on concurrent activations,
		// so nothing is claimed here; passing false lets the domain validate
		// everything else and leaves the race to the database.
		false, now)
	switch {
	case errors.Is(err, domain.ErrEscalation):
		return domain.EmergencyGrant{}, rpcerr.PermissionDenied("SEC_EMERGENCY_ESCALATION",
			"emergency access cannot grant a permission you do not already hold")
	case errors.Is(err, domain.ErrInvalidEmergencyGrant):
		return domain.EmergencyGrant{}, rpcerr.Invalid("SEC_EMERGENCY_INVALID", err.Error())
	case err != nil:
		return domain.EmergencyGrant{}, err
	}

	scope := session.TenantScope()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.grants.InsertGrant(ctx, scope, grant); err != nil {
			if errors.Is(err, domain.ErrGrantAlreadyActive) {
				return rpcerr.FailedPrecondition("SEC_EMERGENCY_ALREADY_ACTIVE",
					"an emergency grant is already active for you; close it before opening another")
			}
			return err
		}
		detail, err := json.Marshal(map[string]any{
			"incident_ref":  grant.IncidentRef,
			"justification": grant.Justification,
			"permissions":   grant.Permissions,
			"expires_at":    grant.ExpiresAt.Format(time.RFC3339),
			"facility_id":   grant.FacilityID,
		})
		if err != nil {
			return rpcerr.Internal("SEC_EVENT_ENCODE_FAILED", "could not encode security event").WithCause(err)
		}
		return s.appendEvent(ctx, session, domain.SecurityEvent{
			Class: domain.ClassBreakGlass,
			// Critical, not high: break glass is rare and legitimate, and the
			// severity is what routes it to a human the same day rather than
			// to a weekly report.
			Severity:     domain.SeverityCritical,
			ResourceType: "emergency_grant",
			ResourceID:   grant.ID,
			Outcome:      domain.OutcomeSuccess,
			Detail:       detail,
		}, now)
	})
	if err != nil {
		return domain.EmergencyGrant{}, err
	}
	return grant, nil
}

// ExerciseEmergencyAccess records that a grant was used to reach a resource.
//
// Called by whatever actually serves the record, so the review has the list of
// what was opened. It returns the grant's own refusal when the window has
// closed, which means a caller cannot treat "expired" as "allowed but
// unlogged".
func (s *Service) ExerciseEmergencyAccess(ctx context.Context, grantID, permission, resourceRef string) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	scope := session.TenantScope()
	now := s.clock.Now()

	grant, err := s.grants.GetGrant(ctx, scope, grantID)
	if err != nil {
		return err
	}
	// A grant belongs to the subject who activated it. Without this check a
	// colleague could ride someone else's declaration and the review would
	// attribute the access to the wrong person.
	if grant.SubjectID != session.SubjectID {
		return rpcerr.NotFound("SEC_GRANT_NOT_FOUND", "emergency grant not found")
	}
	if err := grant.Authorize(permission, now); err != nil {
		return rpcerr.PermissionDenied("SEC_GRANT_NOT_ACTIVE", err.Error())
	}
	return s.grants.RecordAccess(ctx, scope, grantID, resourceRef, now)
}

// CloseEmergencyAccess ends an activation early.
func (s *Service) CloseEmergencyAccess(ctx context.Context, grantID string) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	scope := session.TenantScope()
	now := s.clock.Now()

	grant, err := s.grants.GetGrant(ctx, scope, grantID)
	if err != nil {
		return err
	}
	// The subject may close their own grant; so may a reviewer. Anyone else
	// closing it would end access the clinician still needs.
	if grant.SubjectID != session.SubjectID && !session.HasPermission(PermEmergencyReview) {
		return rpcerr.PermissionDenied("SEC_EMERGENCY_CLOSE_DENIED",
			"only the subject or a reviewer may close an emergency grant")
	}
	return s.grants.CloseGrant(ctx, scope, grantID, now)
}

// ReviewEmergencyAccessInput is the post-hoc review.
type ReviewEmergencyAccessInput struct {
	GrantID string
	Note    string
	Abused  bool
}

// ReviewEmergencyAccess closes the accountability loop (SRS-SEC-014).
//
// The review is what turns break glass from a logged bypass into a controlled
// one, so a verdict of abuse is recorded as a high-severity security event
// rather than only as a status.
func (s *Service) ReviewEmergencyAccess(ctx context.Context, in ReviewEmergencyAccessInput) (domain.EmergencyGrant, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.EmergencyGrant{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermEmergencyReview,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		return domain.EmergencyGrant{}, rpcerr.PermissionDenied("SEC_EMERGENCY_REVIEW_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	grant, err := s.grants.GetGrant(ctx, scope, in.GrantID)
	if err != nil {
		return domain.EmergencyGrant{}, err
	}
	// A grant still inside its window is expired in fact but not yet in
	// status; applying the sweep locally means a reviewer working promptly
	// after expiry is not told to come back later.
	grant.Expire(now)

	if err := grant.Review(session.SubjectID, in.Note, in.Abused, now); err != nil {
		if errors.Is(err, domain.ErrSelfReview) {
			return domain.EmergencyGrant{}, rpcerr.PermissionDenied("SEC_SELF_REVIEW",
				"an emergency grant cannot be reviewed by the person who activated it")
		}
		return domain.EmergencyGrant{}, rpcerr.FailedPrecondition("SEC_GRANT_NOT_REVIEWABLE", err.Error())
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.grants.ReviewGrant(ctx, scope, grant, now); err != nil {
			return err
		}
		detail, err := json.Marshal(map[string]any{
			"incident_ref":       grant.IncidentRef,
			"subject_id":         grant.SubjectID,
			"accessed_resources": grant.AccessedResources,
			"abused":             in.Abused,
			"note":               in.Note,
		})
		if err != nil {
			return rpcerr.Internal("SEC_EVENT_ENCODE_FAILED", "could not encode security event").WithCause(err)
		}
		severity := domain.SeverityInfo
		outcome := domain.OutcomeSuccess
		if in.Abused {
			severity = domain.SeverityHigh
			outcome = domain.OutcomeFailure
		}
		return s.appendEvent(ctx, session, domain.SecurityEvent{
			Class:        domain.ClassBreakGlass,
			Severity:     severity,
			ResourceType: "emergency_grant",
			ResourceID:   grant.ID,
			Outcome:      outcome,
			Detail:       detail,
		}, now)
	})
	if err != nil {
		return domain.EmergencyGrant{}, err
	}
	return grant, nil
}

// GrantsAwaitingReview lists finished grants nobody has looked at.
func (s *Service) GrantsAwaitingReview(ctx context.Context, limit int32) ([]domain.EmergencyGrant, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	decision := policy.Evaluate(session, policy.Request{
		Permission: PermEmergencyReview,
		TenantMode: policy.TenantModeReadOnly,
	})
	if !decision.Allowed {
		return nil, rpcerr.PermissionDenied("SEC_EMERGENCY_REVIEW_DENIED", decision.Reason)
	}
	if limit <= 0 || limit > 200 {
		limit = 50
	}
	return s.grants.GrantsAwaitingReview(ctx, session.TenantScope(), limit)
}

func (s *Service) appendEvent(ctx context.Context, session authctx.Session, e domain.SecurityEvent, now time.Time) error {
	e.EventID = s.ids.NewID()
	e.TenantID = session.TenantID
	e.ActorID = session.SubjectID
	e.CorrelationID = session.CorrelationID
	e.OccurredAt = now.UTC()
	// Sequence and previous hash are resolved by the store inside this same
	// transaction; computing them here would race with a concurrent append.
	_, err := s.events.Append(ctx, session.TenantScope(), e)
	return err
}
