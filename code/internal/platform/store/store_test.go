package store_test

import (
	"context"
	"encoding/json"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/store"
)

var at = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

func newEvent(tenantID string) outbox.Event {
	return outbox.Event{
		EventID:       uuid.NewString(),
		EventType:     "organization.facility_created",
		SchemaVersion: 1,
		OccurredAt:    at,
		TenantID:      tenantID,
		Source:        "organization",
		AggregateType: "facility",
		AggregateID:   uuid.NewString(),
		CorrelationID: uuid.NewString(),
		Payload:       json.RawMessage(`{"code":"MAIN"}`),
	}
}

// recordingBroker captures what the publisher handed over.
type recordingBroker struct {
	published []outbox.Event
	failOn    map[string]error
}

func (b *recordingBroker) Publish(_ context.Context, e outbox.Event) error {
	if err, ok := b.failOn[e.EventID]; ok {
		return err
	}
	b.published = append(b.published, e)
	return nil
}

// The outbox row must be unreachable outside a transaction, otherwise the
// atomicity guarantee is only a convention.
func TestAppendRequiresTransaction(t *testing.T) {
	pool := pgtest.New(t)
	s := store.New(pgtx.NewManager(pool))

	err := s.Append(context.Background(), newEvent(uuid.NewString()))
	if err == nil {
		t.Fatal("outbox append outside a transaction succeeded")
	}
}

// The central SRS-API-008 guarantee: if the transaction rolls back, the event
// goes with it. No state change without its event, no event without its change.
func TestOutboxRollsBackWithItsTransaction(t *testing.T) {
	pool := pgtest.New(t)
	tx := pgtx.NewManager(pool)
	s := store.New(tx)
	ctx := context.Background()

	event := newEvent(uuid.NewString())
	sentinel := errors.New("business rule failed after the event was appended")

	err := tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.Append(ctx, event); err != nil {
			return err
		}
		return sentinel
	})
	if !errors.Is(err, sentinel) {
		t.Fatalf("WithinTx returned %v", err)
	}

	var count int
	if err := pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_data.outbox_event WHERE event_id = $1`,
		event.EventID).Scan(&count); err != nil {
		t.Fatalf("count: %v", err)
	}
	if count != 0 {
		t.Fatal("event survived the rollback of its own transaction")
	}
}

func TestPublisherDrainsAndMarksPublished(t *testing.T) {
	pool := pgtest.New(t)
	tx := pgtx.NewManager(pool)
	s := store.New(tx)
	ctx := context.Background()
	tenantID := uuid.NewString()

	var ids []string
	for i := 0; i < 3; i++ {
		e := newEvent(tenantID)
		ids = append(ids, e.EventID)
		if err := tx.WithinTx(ctx, func(ctx context.Context) error { return s.Append(ctx, e) }); err != nil {
			t.Fatalf("append: %v", err)
		}
	}

	broker := &recordingBroker{}
	publisher := store.NewPublisher(s, broker, 10)

	n, err := publisher.PublishBatch(ctx, at)
	if err != nil {
		t.Fatalf("PublishBatch: %v", err)
	}
	if n != 3 || len(broker.published) != 3 {
		t.Fatalf("published %d (broker saw %d), want 3", n, len(broker.published))
	}

	// The payload must survive the round trip through jsonb intact.
	if string(broker.published[0].Payload) != `{"code": "MAIN"}` &&
		string(broker.published[0].Payload) != `{"code":"MAIN"}` {
		t.Fatalf("payload = %s", broker.published[0].Payload)
	}

	// A second drain finds nothing: published rows are not re-sent.
	again, err := publisher.PublishBatch(ctx, at)
	if err != nil {
		t.Fatalf("second PublishBatch: %v", err)
	}
	if again != 0 {
		t.Fatalf("second drain republished %d events", again)
	}

	pending, err := publisher.PendingCount(ctx)
	if err != nil {
		t.Fatalf("PendingCount: %v", err)
	}
	if pending != 0 {
		t.Fatalf("PendingCount = %d, want 0", pending)
	}
	_ = ids
}

// A broker failure must not lose the event or stall the rest of the batch.
func TestPublisherRetriesFailedEventWithoutBlockingOthers(t *testing.T) {
	pool := pgtest.New(t)
	tx := pgtx.NewManager(pool)
	s := store.New(tx)
	ctx := context.Background()
	tenantID := uuid.NewString()

	bad := newEvent(tenantID)
	good := newEvent(tenantID)
	// Force ordering so the failing event is claimed first.
	bad.OccurredAt = at
	good.OccurredAt = at.Add(time.Second)

	for _, e := range []outbox.Event{bad, good} {
		e := e
		if err := tx.WithinTx(ctx, func(ctx context.Context) error { return s.Append(ctx, e) }); err != nil {
			t.Fatalf("append: %v", err)
		}
	}

	broker := &recordingBroker{failOn: map[string]error{bad.EventID: errors.New("broker unavailable")}}
	publisher := store.NewPublisher(s, broker, 10)

	n, err := publisher.PublishBatch(ctx, at)
	if err != nil {
		t.Fatalf("PublishBatch: %v", err)
	}
	if n != 1 {
		t.Fatalf("published %d, want 1 (the healthy event)", n)
	}

	var attempts int
	var lastError *string
	if err := pool.QueryRow(ctx,
		`SELECT attempts, last_error FROM platform_data.outbox_event WHERE event_id = $1`,
		bad.EventID).Scan(&attempts, &lastError); err != nil {
		t.Fatalf("read failed event: %v", err)
	}
	if attempts != 1 || lastError == nil {
		t.Fatalf("failure not recorded: attempts=%d last_error=%v", attempts, lastError)
	}

	// It is still pending, so the next cycle retries it.
	broker.failOn = nil
	retried, err := publisher.PublishBatch(ctx, at)
	if err != nil {
		t.Fatalf("retry PublishBatch: %v", err)
	}
	if retried != 1 {
		t.Fatalf("retry published %d, want 1", retried)
	}
}

// Redelivery is expected; the inbox is what makes it harmless.
func TestInboxDeduplicatesRedelivery(t *testing.T) {
	pool := pgtest.New(t)
	s := store.New(pgtx.NewManager(pool))
	ctx := context.Background()

	eventID := uuid.NewString()
	tenantID := uuid.NewString()

	first, err := s.TryConsume(ctx, "billing-projector", eventID, tenantID, at)
	if err != nil {
		t.Fatalf("first TryConsume: %v", err)
	}
	if !first {
		t.Fatal("first delivery was treated as a duplicate")
	}

	second, err := s.TryConsume(ctx, "billing-projector", eventID, tenantID, at)
	if err != nil {
		t.Fatalf("second TryConsume: %v", err)
	}
	if second {
		t.Fatal("redelivery was not deduplicated")
	}

	// Deduplication is per consumer: a different consumer must still get its
	// own first look at the same event.
	other, err := s.TryConsume(ctx, "search-indexer", eventID, tenantID, at)
	if err != nil {
		t.Fatalf("other consumer TryConsume: %v", err)
	}
	if !other {
		t.Fatal("a second consumer was blocked by another consumer's inbox row")
	}
}

// A denial must be durable even though the transaction it was refused in is
// abandoned.
func TestAuditSurvivesWithoutTransaction(t *testing.T) {
	pool := pgtest.New(t)
	s := store.New(pgtx.NewManager(pool))
	ctx := context.Background()
	tenantID := uuid.NewString()

	rec := audit.Record{
		AuditID:       uuid.NewString(),
		TenantID:      tenantID,
		ActorID:       "attacker",
		Action:        "organization.facility.create",
		Outcome:       audit.OutcomeDenied,
		Reason:        "CROSS_TENANT_DENIED",
		CorrelationID: uuid.NewString(),
		OccurredAt:    at,
	}
	if err := s.AppendAudit(ctx, rec); err != nil {
		t.Fatalf("AppendAudit: %v", err)
	}

	var outcome, reason string
	if err := pool.QueryRow(ctx,
		`SELECT outcome, reason FROM platform_data.audit_record WHERE audit_id = $1`,
		rec.AuditID).Scan(&outcome, &reason); err != nil {
		t.Fatalf("read audit: %v", err)
	}
	if outcome != "denied" || reason != "CROSS_TENANT_DENIED" {
		t.Fatalf("audit = (%s, %s)", outcome, reason)
	}
}

// A malformed envelope must be refused at the boundary rather than persisted
// and then failing at publish time.
func TestInvalidEnvelopeRejectedBeforeInsert(t *testing.T) {
	pool := pgtest.New(t)
	tx := pgtx.NewManager(pool)
	s := store.New(tx)
	ctx := context.Background()

	bad := newEvent(uuid.NewString())
	bad.CorrelationID = ""

	err := tx.WithinTx(ctx, func(ctx context.Context) error { return s.Append(ctx, bad) })
	if err == nil {
		t.Fatal("event without correlation ID was accepted")
	}
}
