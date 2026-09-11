// Package postgres is the security platform's persistence adapter.
//
// It is the only package permitted to issue SQL against the security_platform
// schema (FIT-02).
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/security/domain"
)

// Repository implements the security platform ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func tenantUUID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.Nil, rpcerr.Internal("SEC_TENANT_SCOPE_MISSING", "tenant scope is required")
	}
	id, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.Nil, rpcerr.Internal("SEC_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	return id, nil
}

// Append links a security event to the tenant's chain.
//
// Sequence allocation, previous-hash lookup and the insert all happen inside
// one transaction. Without that, two concurrent appends would read the same
// previous hash and both claim the same sequence — the unique index would
// reject the loser, but only after the chain had already been computed wrong.
func (r *Repository) Append(ctx context.Context, scope authctx.TenantScope, e domain.SecurityEvent) (domain.SecurityEvent, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return domain.SecurityEvent{}, err
	}

	var linked domain.SecurityEvent
	err = r.tx.WithinTx(ctx, func(ctx context.Context) error {
		q := r.queries(ctx)

		sequence, err := q.NextSecurityEventSequence(ctx, tenant)
		if err != nil {
			return err
		}

		previousHash, err := q.GetLastSecurityEventHash(ctx, tenant)
		if errors.Is(err, pgx.ErrNoRows) {
			previousHash = domain.GenesisHash
		} else if err != nil {
			return err
		}

		e.TenantID = scope.TenantID()
		e.Sequence = int64(sequence)

		linked, err = domain.NewSecurityEvent(e, previousHash)
		if err != nil {
			return rpcerr.Internal("SEC_EVENT_INVALID", "security event is invalid").WithCause(err)
		}

		eventID, err := uuid.Parse(linked.EventID)
		if err != nil {
			return rpcerr.Internal("SEC_EVENT_ID_INVALID", "event_id must be a UUID").WithCause(err)
		}

		return q.InsertSecurityEvent(ctx, sqlcgen.InsertSecurityEventParams{
			EventID:       eventID,
			TenantID:      tenant,
			Sequence:      linked.Sequence,
			EventClass:    linked.Class,
			Severity:      string(linked.Severity),
			ActorID:       linked.ActorID,
			ResourceType:  linked.ResourceType,
			ResourceID:    linked.ResourceID,
			Outcome:       string(linked.Outcome),
			Detail:        linked.Detail,
			CorrelationID: linked.CorrelationID,
			OccurredAt:    timestamptz(linked.OccurredAt),
			EntryHash:     linked.EntryHash,
			PreviousHash:  linked.PreviousHash,
		})
	})
	if err != nil {
		return domain.SecurityEvent{}, err
	}
	return linked, nil
}

// List returns the tenant's whole chain in order, for verification.
func (r *Repository) List(ctx context.Context, scope authctx.TenantScope) ([]domain.SecurityEvent, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListSecurityEvents(ctx, tenant)
	if err != nil {
		return nil, err
	}

	out := make([]domain.SecurityEvent, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.SecurityEvent{
			EventID:       row.EventID.String(),
			TenantID:      row.TenantID.String(),
			Sequence:      row.Sequence,
			Class:         row.EventClass,
			Severity:      domain.Severity(row.Severity),
			ActorID:       row.ActorID,
			ResourceType:  row.ResourceType,
			ResourceID:    row.ResourceID,
			Outcome:       domain.Outcome(row.Outcome),
			Detail:        json.RawMessage(row.Detail),
			CorrelationID: row.CorrelationID,
			OccurredAt:    row.OccurredAt.Time,
			EntryHash:     row.EntryHash,
			PreviousHash:  row.PreviousHash,
		})
	}
	return out, nil
}

// PlaceHold records a legal hold. It reports false when an active hold already
// exists, which is not an error: the resource is held either way.
func (r *Repository) Place(ctx context.Context, scope authctx.TenantScope, h domain.LegalHold) (bool, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return false, err
	}
	holdID, err := uuid.Parse(h.ID)
	if err != nil {
		return false, rpcerr.Internal("SEC_HOLD_ID_INVALID", "hold_id must be a UUID").WithCause(err)
	}

	rows, err := r.queries(ctx).PlaceLegalHold(ctx, sqlcgen.PlaceLegalHoldParams{
		HoldID:       holdID,
		TenantID:     tenant,
		ResourceType: h.ResourceType,
		ResourceID:   h.ResourceID,
		Reason:       h.Reason,
		PlacedBy:     h.PlacedBy,
		PlacedAt:     timestamptz(h.PlacedAt),
	})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// Release lifts an active hold.
func (r *Repository) Release(ctx context.Context, scope authctx.TenantScope, resourceType, resourceID, releasedBy string, at time.Time) (bool, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return false, err
	}

	rows, err := r.queries(ctx).ReleaseLegalHold(ctx, sqlcgen.ReleaseLegalHoldParams{
		ReleasedBy:   releasedBy,
		ReleasedAt:   timestamptz(at),
		TenantID:     tenant,
		ResourceType: resourceType,
		ResourceID:   resourceID,
	})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// IsHeld reports whether a resource is under an active hold.
func (r *Repository) IsHeld(ctx context.Context, scope authctx.TenantScope, resourceType, resourceID string) (bool, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return false, err
	}
	return r.queries(ctx).IsUnderLegalHold(ctx, sqlcgen.IsUnderLegalHoldParams{
		TenantID:     tenant,
		ResourceType: resourceType,
		ResourceID:   resourceID,
	})
}

// HeldResourceIDs lists every held resource of a type, so a deletion job can
// exclude them in one query rather than asking per row.
func (r *Repository) HeldResourceIDs(ctx context.Context, scope authctx.TenantScope, resourceType string) ([]string, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return nil, err
	}
	return r.queries(ctx).ListHeldResourceIDs(ctx, sqlcgen.ListHeldResourceIDsParams{
		TenantID:     tenant,
		ResourceType: resourceType,
	})
}
