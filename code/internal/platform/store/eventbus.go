package store

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/eventbus"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Event delivery persistence (ADR-005).
//
// This is the eventbus.Store implementation. Every method here is a thin
// translation over one statement, because the interesting behaviour —
// competing consumers, lease expiry, backoff, dead-lettering — lives in the
// SQL rather than in Go. That is deliberate: those are the properties several
// processes have to agree on, and the only thing they all share is the
// database.

// EnsureSubscription registers a consumer, returning its id.
//
// Idempotent: a process restarting re-registers the same subscription and gets
// the same id back, so a deployment rollout does not create a second
// subscription that would double-deliver everything.
func (s *Store) EnsureSubscription(ctx context.Context, sub eventbus.Subscription) (string, error) {
	sub = sub.WithDefaults()
	if err := sub.Validate(); err != nil {
		return "", err
	}

	existing, err := s.queries(ctx).GetSubscriptionByConsumer(ctx, sub.Consumer)
	if err == nil {
		return existing.SubscriptionID.String(), nil
	}
	if !errors.Is(err, pgx.ErrNoRows) {
		return "", err
	}

	now := time.Now().UTC()
	id := uuid.New()

	var tenant pgtype.UUID
	if sub.TenantID != "" {
		parsed, parseErr := uuid.Parse(sub.TenantID)
		if parseErr != nil {
			return "", rpcerr.Internal("BUS_TENANT_INVALID", "tenant_id must be a UUID").WithCause(parseErr)
		}
		tenant = pgtype.UUID{Bytes: parsed, Valid: true}
	}

	err = s.queries(ctx).InsertSubscription(ctx, sqlcgen.InsertSubscriptionParams{
		SubscriptionID: id, Consumer: sub.Consumer,
		EventTypes: sub.EventTypes, TenantID: tenant,
		Enabled: true, MaxAttempts: int32(sub.MaxAttempts),
		CreatedAt: timestamptz(now), UpdatedAt: timestamptz(now),
	})
	if err != nil {
		// Two processes starting together both see no row and both insert.
		// The unique index rejects the loser, which then reads the winner's.
		if again, readErr := s.queries(ctx).GetSubscriptionByConsumer(ctx, sub.Consumer); readErr == nil {
			return again.SubscriptionID.String(), nil
		}
		return "", err
	}
	return id.String(), nil
}

// Claim takes a batch of deliveries for a worker.
func (s *Store) Claim(ctx context.Context, subscriptionID, workerID string,
	batchSize int32, lease time.Duration, now time.Time) ([]eventbus.Delivery, error) {

	id, err := uuid.Parse(subscriptionID)
	if err != nil {
		return nil, rpcerr.Internal("BUS_SUBSCRIPTION_INVALID", "subscription_id must be a UUID").WithCause(err)
	}

	rows, err := s.queries(ctx).ClaimDeliveries(ctx, sqlcgen.ClaimDeliveriesParams{
		LeasedUntil:    timestamptz(now.Add(lease)),
		LeasedBy:       workerID,
		Now:            timestamptz(now),
		SubscriptionID: id,
		BatchSize:      batchSize,
	})
	if err != nil {
		return nil, err
	}

	out := make([]eventbus.Delivery, 0, len(rows))
	for _, row := range rows {
		// The event body is fetched per delivery rather than joined into the
		// claim. The claim is the hot statement and runs under a row lock;
		// keeping the payload out of it means the lock is held for the
		// bookkeeping only, not for reading a jsonb column.
		event, err := s.eventByID(ctx, row.EventID)
		if err != nil {
			return nil, err
		}
		out = append(out, eventbus.Delivery{
			ID: row.DeliveryID.String(), EventID: row.EventID.String(),
			TenantID: row.TenantID.String(), Type: row.EventType,
			Attempt: int(row.Attempts), OccurredAt: row.OccurredAt.Time,
			Event: event,
		})
	}
	return out, nil
}

// Ack marks a delivery done.
func (s *Store) Ack(ctx context.Context, deliveryID string, now time.Time) error {
	id, err := uuid.Parse(deliveryID)
	if err != nil {
		return rpcerr.Internal("BUS_DELIVERY_INVALID", "delivery_id must be a UUID").WithCause(err)
	}
	rows, err := s.queries(ctx).AckDelivery(ctx, sqlcgen.AckDeliveryParams{
		Now: timestamptz(now), DeliveryID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// The lease expired and another worker took the message, or it was
		// already acknowledged. Not an error the worker can act on: the side
		// effect happened, and the other worker's idempotent handler will
		// produce the same outcome.
		return nil
	}
	return nil
}

// Nack records a failure, scheduling a retry or dead-lettering.
func (s *Store) Nack(ctx context.Context, deliveryID, reason string, retryAt, now time.Time) error {
	id, err := uuid.Parse(deliveryID)
	if err != nil {
		return rpcerr.Internal("BUS_DELIVERY_INVALID", "delivery_id must be a UUID").WithCause(err)
	}
	// The error text is stored and shown to an operator, and a handler's error
	// can contain anything it was given — including a patient identifier from
	// the payload it failed on. Truncating bounds the damage and the column.
	if len(reason) > maxDeliveryErrorBytes {
		reason = reason[:maxDeliveryErrorBytes] + "… (truncated)"
	}

	_, err = s.queries(ctx).NackDelivery(ctx, sqlcgen.NackDeliveryParams{
		RetryAt: timestamptz(retryAt), LastError: reason,
		Now: timestamptz(now), DeliveryID: id,
	})
	return err
}

// maxDeliveryErrorBytes bounds the stored failure text.
const maxDeliveryErrorBytes = 2000

// PendingCount reports outstanding work for a subscription, which is the
// number an operator watches: a consumer that is keeping up has a small,
// stable count, and one that is falling behind has a growing one.
func (s *Store) PendingCount(ctx context.Context, subscriptionID string) (int64, error) {
	id, err := uuid.Parse(subscriptionID)
	if err != nil {
		return 0, rpcerr.Internal("BUS_SUBSCRIPTION_INVALID", "subscription_id must be a UUID").WithCause(err)
	}
	return s.queries(ctx).CountPendingDeliveries(ctx, id)
}

// FanOut creates delivery rows for an event.
//
// Called inside the publisher's transaction, so an event is never marked
// published without its deliveries existing. The alternative — fan out after
// publishing — leaves a window where a crash loses the event for every
// consumer while the outbox believes it was delivered.
func (s *Store) FanOut(ctx context.Context, e outbox.Event, now time.Time) (int64, error) {
	eventID, err := uuid.Parse(e.EventID)
	if err != nil {
		return 0, rpcerr.Internal("BUS_EVENT_INVALID", "event_id must be a UUID").WithCause(err)
	}
	tenantID, err := uuid.Parse(e.TenantID)
	if err != nil {
		return 0, rpcerr.Internal("BUS_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	return s.queries(ctx).FanOutEvent(ctx, sqlcgen.FanOutEventParams{
		EventID: eventID, TenantID: tenantID, EventType: e.EventType,
		OccurredAt: timestamptz(e.OccurredAt), Now: timestamptz(now),
	})
}

// DeadLetters lists messages that exhausted their attempts.
func (s *Store) DeadLetters(ctx context.Context, tenantID string, limit int32) ([]eventbus.Delivery, error) {
	var tenant pgtype.UUID
	if tenantID != "" {
		parsed, err := uuid.Parse(tenantID)
		if err != nil {
			return nil, rpcerr.Internal("BUS_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
		}
		tenant = pgtype.UUID{Bytes: parsed, Valid: true}
	}

	rows, err := s.queries(ctx).ListDeadLetters(ctx, sqlcgen.ListDeadLettersParams{
		TenantID: tenant, PageSize: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]eventbus.Delivery, 0, len(rows))
	for _, row := range rows {
		out = append(out, eventbus.Delivery{
			ID: row.DeliveryID.String(), EventID: row.EventID.String(),
			TenantID: row.TenantID.String(), Type: row.EventType,
			Attempt: int(row.Attempts), OccurredAt: row.OccurredAt.Time,
		})
	}
	return out, nil
}

// ReplayDeadLetter returns a dead letter to the queue with a fresh attempt
// count, so an operator who fixed the consumer can retry without editing rows.
func (s *Store) ReplayDeadLetter(ctx context.Context, deliveryID string, now time.Time) error {
	id, err := uuid.Parse(deliveryID)
	if err != nil {
		return rpcerr.Internal("BUS_DELIVERY_INVALID", "delivery_id must be a UUID").WithCause(err)
	}
	rows, err := s.queries(ctx).ReplayDeadLetter(ctx, sqlcgen.ReplayDeadLetterParams{
		Now: timestamptz(now), DeliveryID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.NotFound("BUS_DEAD_LETTER_NOT_FOUND", "no dead letter with that id")
	}
	return nil
}

// eventByID reads one outbox event.
func (s *Store) eventByID(ctx context.Context, id uuid.UUID) (outbox.Event, error) {
	row, err := s.queries(ctx).GetOutboxEvent(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return outbox.Event{}, rpcerr.NotFound("BUS_EVENT_NOT_FOUND", "event not found")
	}
	if err != nil {
		return outbox.Event{}, err
	}
	return outbox.Event{
		EventID: row.EventID.String(), EventType: row.EventType,
		SchemaVersion: row.SchemaVersion, OccurredAt: row.OccurredAt.Time,
		TenantID: row.TenantID.String(), Source: row.Source,
		AggregateType: row.AggregateType, AggregateID: row.AggregateID,
		CorrelationID: row.CorrelationID, CausationID: row.CausationID,
		Actor: row.Actor, Payload: json.RawMessage(row.Payload),
	}, nil
}
