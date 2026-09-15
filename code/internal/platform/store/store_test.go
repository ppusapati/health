package store_test

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"log/slog"
	"regexp"
	"strconv"
	"strings"
	"sync"
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

// A drain that keeps failing must report the fault immediately and then stop
// repeating itself.
//
// Found by running the container against a database with no schema: the drain
// retries every 250ms and logged one identical ERROR line per attempt, with
// nothing to say when it recovered. Four lines a second per replica buries the
// diagnostics in exactly the incident whose logs somebody needs, and a stream
// that merely stops complaining looks the same as a publisher that died.
//
// The retry itself is correct and is not what changed — the outbox is durable,
// so waiting loses nothing, and a publisher that exits on a transient database
// error takes the events with it.
func TestRepeatedDrainFailureIsReportedOnceThenThrottled(t *testing.T) {
	pool := pgtest.New(t)
	ctx := context.Background()

	// The outage this reproduces is the one that was actually observed: the
	// table the drain reads is not there.
	if _, err := pool.Exec(ctx,
		`ALTER TABLE platform_data.outbox_event RENAME TO outbox_event_hidden`); err != nil {
		t.Fatalf("hide the outbox table: %v", err)
	}

	var buf lockedBuffer
	restore := slog.Default()
	slog.SetDefault(slog.New(slog.NewJSONHandler(&buf, &slog.HandlerOptions{Level: slog.LevelInfo})))
	t.Cleanup(func() { slog.SetDefault(restore) })

	s := store.New(pgtx.NewManager(pool))
	publisher := store.NewPublisher(s, &recordingBroker{}, 10)

	// Many ticks, all inside DrainFailureReportInterval, so every report after
	// the first is a repetition the throttle should swallow.
	runCtx, cancel := context.WithCancel(ctx)
	done := make(chan struct{})
	go func() {
		defer close(done)
		_ = publisher.Run(runCtx, time.Millisecond)
	}()
	time.Sleep(150 * time.Millisecond)

	if got := strings.Count(buf.String(), `"msg":"outbox drain failed"`); got != 1 {
		t.Fatalf("drain failures reported %d times over ~150 ticks, want exactly 1", got)
	}
	// The one report has to carry what an operator needs: how long, how many.
	if !strings.Contains(buf.String(), `"consecutive_failures":1`) {
		t.Fatal("the failure report does not say how many attempts have failed")
	}

	// Recovery must be announced, not merely implied by the complaints ending.
	if _, err := pool.Exec(ctx,
		`ALTER TABLE platform_data.outbox_event_hidden RENAME TO outbox_event`); err != nil {
		t.Fatalf("restore the outbox table: %v", err)
	}
	time.Sleep(150 * time.Millisecond)
	cancel()
	<-done

	out := buf.String()
	if !strings.Contains(out, `"msg":"outbox drain recovered"`) {
		t.Fatal("the drain recovered and said nothing")
	}
	if got := strings.Count(out, `"msg":"outbox drain recovered"`); got != 1 {
		t.Fatalf("recovery reported %d times, want 1 — it is an edge, not a state", got)
	}
	if got := strings.Count(out, `"msg":"outbox drain failed"`); got != 1 {
		t.Fatalf("drain failures reported %d times in total, want 1", got)
	}

	// Without this the test would also pass if the drain had simply been
	// attempted once: the point is that many attempts failed and one line was
	// written, so the recovery line has to show the attempts that were
	// swallowed.
	swallowed := regexp.MustCompile(`"msg":"outbox drain recovered","consecutive_failures":(\d+)`).
		FindStringSubmatch(out)
	if swallowed == nil {
		t.Fatal("the recovery line does not report how many attempts failed")
	}
	attempts, err := strconv.Atoi(swallowed[1])
	if err != nil {
		t.Fatalf("unreadable failure count %q: %v", swallowed[1], err)
	}
	if attempts < 10 {
		t.Fatalf("only %d attempts failed; too few to show the repetitions were throttled", attempts)
	}
}

// lockedBuffer is a bytes.Buffer safe for the publisher goroutine to write
// while the test reads it.
type lockedBuffer struct {
	mu  sync.Mutex
	buf bytes.Buffer
}

func (b *lockedBuffer) Write(p []byte) (int, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.buf.Write(p)
}

func (b *lockedBuffer) String() string {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.buf.String()
}
