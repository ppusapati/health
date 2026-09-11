// Package store implements the platform-owned persistence adapters: the
// transactional outbox, the consumer inbox and the audit trail.
//
// These tables live in the platform_data schema, and this package is the only
// one permitted to issue SQL against it (FIT-02).
package store

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Store adapts the platform ports onto PostgreSQL.
type Store struct {
	tx *pgtx.Manager
}

// New constructs a Store.
func New(tx *pgtx.Manager) *Store { return &Store{tx: tx} }

func (s *Store) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(s.tx.Querier(ctx))
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

// Append writes an outbox event.
//
// It insists on an open transaction: an event appended outside one could be
// committed while the aggregate write it describes is rolled back, which is the
// exact failure the outbox pattern exists to prevent (SRS-API-008).
func (s *Store) Append(ctx context.Context, e outbox.Event) error {
	if err := e.Validate(); err != nil {
		return rpcerr.Internal("PLATFORM_EVENT_INVALID", "event envelope is invalid").WithCause(err)
	}
	if _, err := pgtx.RequireTx(ctx); err != nil {
		return rpcerr.Internal("PLATFORM_EVENT_NOT_TRANSACTIONAL",
			"outbox append must run inside a transaction").WithCause(err)
	}

	eventID, err := uuid.Parse(e.EventID)
	if err != nil {
		return rpcerr.Internal("PLATFORM_EVENT_INVALID", "event_id must be a UUID").WithCause(err)
	}
	tenantID, err := uuid.Parse(e.TenantID)
	if err != nil {
		return rpcerr.Internal("PLATFORM_EVENT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	payload := e.Payload
	if len(payload) == 0 {
		payload = []byte(`{}`)
	}

	return s.queries(ctx).InsertOutboxEvent(ctx, sqlcgen.InsertOutboxEventParams{
		EventID:       eventID,
		EventType:     e.EventType,
		SchemaVersion: e.SchemaVersion,
		OccurredAt:    timestamptz(e.OccurredAt),
		TenantID:      tenantID,
		Source:        e.Source,
		AggregateType: e.AggregateType,
		AggregateID:   e.AggregateID,
		CorrelationID: e.CorrelationID,
		CausationID:   e.CausationID,
		Actor:         e.Actor,
		Payload:       payload,
	})
}

// AppendAudit writes an audit record. Unlike the outbox it tolerates running
// outside a transaction, because a denied attempt must survive the rollback of
// the transaction it was refused in.
func (s *Store) AppendAudit(ctx context.Context, r audit.Record) error {
	if err := r.Validate(); err != nil {
		return rpcerr.Internal("PLATFORM_AUDIT_INVALID", "audit record is invalid").WithCause(err)
	}

	auditID, err := uuid.Parse(r.AuditID)
	if err != nil {
		return rpcerr.Internal("PLATFORM_AUDIT_INVALID", "audit_id must be a UUID").WithCause(err)
	}
	tenantID, err := uuid.Parse(r.TenantID)
	if err != nil {
		return rpcerr.Internal("PLATFORM_AUDIT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	context_ := r.Context
	if len(context_) == 0 {
		context_ = []byte(`{}`)
	}

	return s.queries(ctx).InsertAuditRecord(ctx, sqlcgen.InsertAuditRecordParams{
		AuditID:       auditID,
		TenantID:      tenantID,
		ActorID:       r.ActorID,
		Action:        r.Action,
		ResourceType:  r.ResourceType,
		ResourceID:    r.ResourceID,
		Outcome:       string(r.Outcome),
		Reason:        r.Reason,
		PurposeOfUse:  r.PurposeOfUse,
		BreakGlass:    r.BreakGlass,
		CorrelationID: r.CorrelationID,
		RequestID:     r.RequestID,
		OccurredAt:    timestamptz(r.OccurredAt),
		Context:       context_,
	})
}

// TryConsume records that a consumer has handled an event. It returns false on
// redelivery so the caller can skip the side effect (Domain/Data spec §8.2).
func (s *Store) TryConsume(ctx context.Context, consumer, eventID, tenantID string, at time.Time) (bool, error) {
	evt, err := uuid.Parse(eventID)
	if err != nil {
		return false, rpcerr.Internal("PLATFORM_INBOX_INVALID", "event_id must be a UUID").WithCause(err)
	}
	tn, err := uuid.Parse(tenantID)
	if err != nil {
		return false, rpcerr.Internal("PLATFORM_INBOX_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	rows, err := s.queries(ctx).TryConsumeInbox(ctx, sqlcgen.TryConsumeInboxParams{
		Consumer:    consumer,
		EventID:     evt,
		TenantID:    tn,
		ProcessedAt: timestamptz(at),
	})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// AuditAppenderFunc adapts AppendAudit to the organization context's
// ports.AuditAppender interface without that package importing this one.
type AuditAppenderFunc func(context.Context, audit.Record) error

// Append implements the audit port.
func (f AuditAppenderFunc) Append(ctx context.Context, r audit.Record) error { return f(ctx, r) }
