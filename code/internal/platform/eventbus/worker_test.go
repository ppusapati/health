package eventbus_test

import (
	"context"
	"errors"
	"io"
	"log/slog"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/eventbus"
)

var now = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

// memStore is an in-memory eventbus.Store.
//
// The database-backed behaviours — competing consumers, lease expiry,
// dead-lettering — are tested against real PostgreSQL in internal/platform/store.
// What is tested here is the worker's own logic: drain-to-empty, panic
// containment, lease deadlines, backoff scheduling. Those are pure control
// flow, and a database would only make them slow and flaky.
type memStore struct {
	mu sync.Mutex

	queue    []eventbus.Delivery
	acked    []string
	nacked   []nackRecord
	claims   int
	claimErr error
	ackErr   error
	subError error
}

type nackRecord struct {
	id      string
	reason  string
	retryAt time.Time
}

func newMemStore(deliveries ...eventbus.Delivery) *memStore {
	return &memStore{queue: deliveries}
}

func (m *memStore) EnsureSubscription(context.Context, eventbus.Subscription) (string, error) {
	if m.subError != nil {
		return "", m.subError
	}
	return "sub-1", nil
}

func (m *memStore) Claim(_ context.Context, _, _ string, batchSize int32,
	_ time.Duration, _ time.Time) ([]eventbus.Delivery, error) {

	m.mu.Lock()
	defer m.mu.Unlock()
	m.claims++
	if m.claimErr != nil {
		return nil, m.claimErr
	}
	if len(m.queue) == 0 {
		return nil, nil
	}
	n := min(int(batchSize), len(m.queue))
	batch := m.queue[:n]
	m.queue = m.queue[n:]
	return batch, nil
}

func (m *memStore) Ack(_ context.Context, id string, _ time.Time) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	if m.ackErr != nil {
		return m.ackErr
	}
	m.acked = append(m.acked, id)
	return nil
}

func (m *memStore) Nack(_ context.Context, id, reason string, retryAt, _ time.Time) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.nacked = append(m.nacked, nackRecord{id: id, reason: reason, retryAt: retryAt})
	return nil
}

func (m *memStore) PendingCount(context.Context, string) (int64, error) { return 0, nil }

func (m *memStore) snapshot() ([]string, []nackRecord, int) {
	m.mu.Lock()
	defer m.mu.Unlock()
	return append([]string(nil), m.acked...), append([]nackRecord(nil), m.nacked...), m.claims
}

func deliveries(n int) []eventbus.Delivery {
	out := make([]eventbus.Delivery, n)
	for i := range out {
		out[i] = eventbus.Delivery{
			ID:       string(rune('a'+i%26)) + string(rune('0'+i/26)),
			EventID:  "event-" + string(rune('a'+i%26)),
			TenantID: "tenant-a", Type: "thing.happened",
			Attempt: 1, OccurredAt: now,
		}
	}
	return out
}

func quietOptions() eventbus.Options {
	return eventbus.Options{
		PollInterval: 5 * time.Millisecond,
		Now:          func() time.Time { return now },
		Logger:       slog.New(slog.NewTextHandler(io.Discard, nil)),
	}
}

// runUntil runs a worker until the condition holds or the deadline passes.
func runUntil(t *testing.T, w *eventbus.Worker, condition func() bool) {
	t.Helper()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	done := make(chan struct{})
	go func() {
		defer close(done)
		_ = w.Run(ctx)
	}()

	deadline := time.After(3 * time.Second)
	for !condition() {
		select {
		case <-deadline:
			cancel()
			<-done
			t.Fatal("the worker did not reach the expected state in time")
		case <-time.After(time.Millisecond):
		}
	}
	cancel()
	<-done
}

func TestWorkerAcknowledgesHandledDeliveries(t *testing.T) {
	store := newMemStore(deliveries(3)...)
	var handled atomic.Int64

	w, err := eventbus.NewWorker(store,
		eventbus.Subscription{Consumer: "test"},
		func(context.Context, eventbus.Delivery) error {
			handled.Add(1)
			return nil
		}, quietOptions())
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	runUntil(t, w, func() bool { return handled.Load() == 3 })

	acked, nacked, _ := store.snapshot()
	if len(acked) != 3 {
		t.Fatalf("%d acknowledged, want 3", len(acked))
	}
	if len(nacked) != 0 {
		t.Fatalf("successful deliveries were nacked: %+v", nacked)
	}
}

// One poison message must not stop a consumer. Without panic containment a
// nil-pointer dereference on one event takes the worker down, the process
// restarts, claims the same message and crashes again — a crash loop driven by
// a single row.
func TestAPanickingHandlerDoesNotKillTheWorker(t *testing.T) {
	store := newMemStore(deliveries(3)...)
	var seen atomic.Int64

	w, err := eventbus.NewWorker(store,
		eventbus.Subscription{Consumer: "test"},
		func(_ context.Context, d eventbus.Delivery) error {
			n := seen.Add(1)
			if n == 1 {
				var nilMap map[string]string
				nilMap["boom"] = "this panics" //nolint:staticcheck // deliberate
			}
			return nil
		}, quietOptions())
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	runUntil(t, w, func() bool { return seen.Load() == 3 })

	acked, nacked, _ := store.snapshot()
	// The panicking one was nacked, the other two acknowledged — the worker
	// carried on.
	if len(nacked) != 1 {
		t.Fatalf("%d nacked, want 1: %+v", len(nacked), nacked)
	}
	if len(acked) != 2 {
		t.Fatalf("%d acknowledged, want 2", len(acked))
	}
	if !errorMentions(nacked[0].reason, "panic") {
		t.Fatalf("the failure does not say it was a panic: %q", nacked[0].reason)
	}
}

func errorMentions(s, substr string) bool {
	return len(s) >= len(substr) && (s == substr || indexOf(s, substr) >= 0)
}

func indexOf(haystack, needle string) int {
	for i := 0; i+len(needle) <= len(haystack); i++ {
		if haystack[i:i+len(needle)] == needle {
			return i
		}
	}
	return -1
}

func TestFailedDeliveriesAreScheduledWithBackoff(t *testing.T) {
	store := newMemStore(deliveries(1)...)

	w, err := eventbus.NewWorker(store,
		eventbus.Subscription{Consumer: "test"},
		func(context.Context, eventbus.Delivery) error {
			return errors.New("downstream unavailable")
		}, quietOptions())
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	runUntil(t, w, func() bool {
		_, nacked, _ := store.snapshot()
		return len(nacked) == 1
	})

	_, nacked, _ := store.snapshot()
	if !nacked[0].retryAt.After(now) {
		t.Fatalf("the retry was scheduled at %s, not in the future", nacked[0].retryAt)
	}
	if nacked[0].reason != "downstream unavailable" {
		t.Fatalf("reason %q", nacked[0].reason)
	}
}

// A backlog must clear in one wake-up rather than one batch per tick, or a
// burst would still be draining minutes later.
func TestWorkerDrainsToEmptyRatherThanOneBatchPerTick(t *testing.T) {
	store := newMemStore(deliveries(25)...)
	var handled atomic.Int64

	opts := quietOptions()
	opts.BatchSize = 5
	// A poll interval long enough that a one-batch-per-tick worker could not
	// finish inside the test's own deadline.
	opts.PollInterval = 2 * time.Second

	w, err := eventbus.NewWorker(store,
		eventbus.Subscription{Consumer: "test"},
		func(context.Context, eventbus.Delivery) error {
			handled.Add(1)
			return nil
		}, opts)
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	runUntil(t, w, func() bool { return handled.Load() == 25 })
}

// A handler that runs past its lease has already lost its claim, so continuing
// would risk two workers applying the same side effect while both believe they
// hold it.
func TestTheHandlerGetsTheLeaseAsItsDeadline(t *testing.T) {
	store := newMemStore(deliveries(1)...)
	deadlineSeen := make(chan bool, 1)

	opts := quietOptions()
	opts.Lease = 50 * time.Millisecond
	// Real time, because the handler's deadline is a real timeout.
	opts.Now = func() time.Time { return time.Now().UTC() }

	w, err := eventbus.NewWorker(store,
		eventbus.Subscription{Consumer: "test"},
		func(ctx context.Context, _ eventbus.Delivery) error {
			_, ok := ctx.Deadline()
			deadlineSeen <- ok
			<-ctx.Done()
			return ctx.Err()
		}, opts)
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	runUntil(t, w, func() bool {
		_, nacked, _ := store.snapshot()
		return len(nacked) == 1
	})

	select {
	case ok := <-deadlineSeen:
		if !ok {
			t.Fatal("the handler ran with no deadline")
		}
	default:
		t.Fatal("the handler never ran")
	}
}

// A failing claim is usually the database being briefly unavailable. The
// worker must wait rather than spin, or a blip becomes a load spike.
func TestAFailingClaimDoesNotSpin(t *testing.T) {
	store := newMemStore()
	store.claimErr = errors.New("database unavailable")

	opts := quietOptions()
	opts.PollInterval = 20 * time.Millisecond

	w, err := eventbus.NewWorker(store,
		eventbus.Subscription{Consumer: "test"},
		func(context.Context, eventbus.Delivery) error { return nil }, opts)
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 200*time.Millisecond)
	defer cancel()
	_ = w.Run(ctx)

	_, _, claims := store.snapshot()
	// ~10 ticks in 200ms at a 20ms interval. A spinning worker would be in the
	// thousands.
	if claims > 40 {
		t.Fatalf("%d claim attempts in 200ms; the worker is spinning on failure", claims)
	}
	if claims == 0 {
		t.Fatal("the worker never attempted a claim")
	}
}

// Notify wakes the worker before its tick, which is what keeps steady-state
// latency short without polling aggressively.
func TestNotifyWakesTheWorkerEarly(t *testing.T) {
	store := newMemStore(deliveries(1)...)
	handled := make(chan struct{}, 1)

	opts := quietOptions()
	// Long enough that a tick cannot explain the delivery.
	opts.PollInterval = 5 * time.Second

	w, err := eventbus.NewWorker(store,
		eventbus.Subscription{Consumer: "test"},
		func(context.Context, eventbus.Delivery) error {
			select {
			case handled <- struct{}{}:
			default:
			}
			return nil
		}, opts)
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	go func() { _ = w.Run(ctx) }()

	// The first drain happens immediately on start; wait for it, then notify
	// for the second.
	select {
	case <-handled:
	case <-time.After(2 * time.Second):
		t.Fatal("the initial drain never happened")
	}

	store.mu.Lock()
	store.queue = deliveries(1)
	store.mu.Unlock()
	w.Notify()

	select {
	case <-handled:
	case <-time.After(2 * time.Second):
		t.Fatal("Notify did not wake the worker before its poll interval")
	}
}

// Notify must never block: back-pressure from a slow consumer onto a publisher
// whose transaction has already committed is the wrong direction entirely.
func TestNotifyNeverBlocks(t *testing.T) {
	w, err := eventbus.NewWorker(newMemStore(),
		eventbus.Subscription{Consumer: "test"},
		func(context.Context, eventbus.Delivery) error { return nil }, quietOptions())
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	done := make(chan struct{})
	go func() {
		defer close(done)
		for range 1000 {
			w.Notify()
		}
	}()

	select {
	case <-done:
	case <-time.After(2 * time.Second):
		t.Fatal("Notify blocked")
	}
}

func TestBackoffGrowsAndIsCapped(t *testing.T) {
	previous := time.Duration(0)
	for attempt := 1; attempt <= 8; attempt++ {
		d := eventbus.RetryDelay(attempt)
		if d <= 0 {
			t.Fatalf("attempt %d produced %v", attempt, d)
		}
		if d > eventbus.MaxRetryDelay {
			t.Fatalf("attempt %d produced %v, over the %v cap", attempt, d, eventbus.MaxRetryDelay)
		}
		if d < previous {
			t.Fatalf("attempt %d backed off less than attempt %d", attempt, attempt-1)
		}
		previous = d
	}

	// A very high attempt count must not overflow into a negative duration,
	// which would make a failed message immediately visible forever.
	for _, attempt := range []int{0, -5, 40, 1000} {
		if d := eventbus.RetryDelay(attempt); d <= 0 || d > eventbus.MaxRetryDelay {
			t.Fatalf("RetryDelay(%d) = %v", attempt, d)
		}
	}
}

func TestWorkerConstructionValidates(t *testing.T) {
	store := newMemStore()
	handler := func(context.Context, eventbus.Delivery) error { return nil }

	if _, err := eventbus.NewWorker(nil, eventbus.Subscription{Consumer: "x"}, handler, quietOptions()); err == nil {
		t.Error("a worker with no store was constructed")
	}
	if _, err := eventbus.NewWorker(store, eventbus.Subscription{Consumer: "x"}, nil, quietOptions()); err == nil {
		t.Error("a worker with no handler was constructed")
	}
	if _, err := eventbus.NewWorker(store, eventbus.Subscription{}, handler, quietOptions()); !errors.Is(err, eventbus.ErrInvalidSubscription) {
		t.Errorf("want ErrInvalidSubscription, got %v", err)
	}
}

// A subscription that cannot be registered must fail loudly at start rather
// than running a worker that drains nothing forever.
func TestRunFailsWhenTheSubscriptionCannotBeRegistered(t *testing.T) {
	store := newMemStore()
	store.subError = errors.New("database unavailable")

	w, err := eventbus.NewWorker(store, eventbus.Subscription{Consumer: "x"},
		func(context.Context, eventbus.Delivery) error { return nil }, quietOptions())
	if err != nil {
		t.Fatalf("NewWorker: %v", err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	if err := w.Run(ctx); err == nil {
		t.Fatal("Run returned no error when the subscription could not be registered")
	}
}

// claimCount reports how many times a worker has asked for work. Several tests
// use it as the observable proxy for "the worker woke up".
func (m *memStore) claimCount() int {
	m.mu.Lock()
	defer m.mu.Unlock()
	return m.claims
}
