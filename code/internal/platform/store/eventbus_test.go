package store_test

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/eventbus"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/store"
)

// Event delivery (ADR-005). Every test here runs against a real PostgreSQL,
// because the properties being asserted — competing consumers, lease expiry,
// backoff, dead-lettering — live in SQL and a fake would confirm only that the
// Go wrapper compiles.

var busAt = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

type busFixture struct {
	store  *store.Store
	tx     *pgtx.Manager
	pool   *pgxpool.Pool
	tenant string
	scope  authctx.TenantScope
}

func newBusFixture(t *testing.T) busFixture {
	t.Helper()
	pool := pgtest.New(t)
	tx := pgtx.NewManager(pool)
	tenant := uuid.NewString()
	return busFixture{
		store:  store.New(tx),
		tx:     tx,
		pool:   pool,
		tenant: tenant,
		scope:  authctx.NewSession(authctx.Session{SubjectID: "sys", TenantID: tenant}).TenantScope(),
	}
}

// publish writes an event through the outbox and fans it out, exactly as the
// publisher does.
func (f busFixture) publish(t *testing.T, eventType string) outbox.Event {
	t.Helper()
	ctx := context.Background()

	e := outbox.Event{
		EventID: uuid.NewString(), EventType: eventType, SchemaVersion: 1,
		OccurredAt: busAt, TenantID: f.tenant, Source: "test",
		AggregateType: "thing", AggregateID: uuid.NewString(),
		CorrelationID: uuid.NewString(), Actor: "sys",
		Payload: json.RawMessage(`{}`),
	}

	err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := f.store.Append(ctx, e); err != nil {
			return err
		}
		_, err := f.store.FanOut(ctx, e, busAt)
		return err
	})
	if err != nil {
		t.Fatalf("publish: %v", err)
	}
	return e
}

func (f busFixture) subscribe(t *testing.T, sub eventbus.Subscription) string {
	t.Helper()
	id, err := f.store.EnsureSubscription(context.Background(), sub.WithDefaults())
	if err != nil {
		t.Fatalf("EnsureSubscription: %v", err)
	}
	return id
}

func TestEventReachesEverySubscription(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	// Two consumer groups. Two names means two copies, which is fan-out.
	search := f.subscribe(t, eventbus.Subscription{Consumer: "search-indexer"})
	analytics := f.subscribe(t, eventbus.Subscription{Consumer: "analytics-loader"})

	e := f.publish(t, "organization.facility_created")

	for name, id := range map[string]string{"search": search, "analytics": analytics} {
		claimed, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, busAt)
		if err != nil {
			t.Fatalf("%s claim: %v", name, err)
		}
		if len(claimed) != 1 {
			t.Fatalf("%s got %d deliveries, want 1", name, len(claimed))
		}
		if claimed[0].EventID != e.EventID {
			t.Fatalf("%s got the wrong event", name)
		}
		// The payload travels with the delivery, so a consumer does not have
		// to go and fetch it.
		if claimed[0].Event.EventType != e.EventType {
			t.Fatalf("%s: the event body did not arrive: %+v", name, claimed[0].Event)
		}
	}
}

// A targeted subscription must not receive everything.
func TestEventTypeFilterIsApplied(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	billing := f.subscribe(t, eventbus.Subscription{
		Consumer: "billing", EventTypes: []string{"organization.tenant_provisioned"},
	})
	everything := f.subscribe(t, eventbus.Subscription{Consumer: "audit-mirror"})

	f.publish(t, "organization.facility_created")
	f.publish(t, "organization.tenant_provisioned")

	billingClaims, err := f.store.Claim(ctx, billing, "w1", 10, time.Minute, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(billingClaims) != 1 || billingClaims[0].Type != "organization.tenant_provisioned" {
		t.Fatalf("the filter let the wrong events through: %+v", billingClaims)
	}

	allClaims, err := f.store.Claim(ctx, everything, "w1", 10, time.Minute, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(allClaims) != 2 {
		t.Fatalf("an unfiltered subscription got %d of 2", len(allClaims))
	}
}

// A per-tenant subscription exists for the case where one customer's data must
// not leave a region.
func TestTenantScopedSubscription(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	other := uuid.NewString()
	scoped := f.subscribe(t, eventbus.Subscription{Consumer: "regional", TenantID: other})

	f.publish(t, "organization.facility_created")

	claimed, err := f.store.Claim(ctx, scoped, "w1", 10, time.Minute, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(claimed) != 0 {
		t.Fatalf("a tenant-scoped subscription received another tenant's event: %+v", claimed)
	}
}

// Two workers sharing a consumer name share the work rather than each taking a
// copy. This is the competing-consumer property that makes the bus scale
// horizontally, and it comes from SKIP LOCKED rather than from coordination.
func TestCompetingConsumersDoNotDoubleClaim(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	id := f.subscribe(t, eventbus.Subscription{Consumer: "shared"})
	const events = 40
	for i := range events {
		f.publish(t, fmt.Sprintf("thing.happened.%d", i%3))
	}

	const workers = 6
	var wg sync.WaitGroup
	claimedBy := make([][]eventbus.Delivery, workers)
	errs := make([]error, workers)
	start := make(chan struct{})

	for i := range workers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			claimedBy[i], errs[i] = f.store.Claim(ctx, id, fmt.Sprintf("w%d", i), 20, time.Minute, busAt)
		}()
	}
	close(start)
	wg.Wait()

	seen := map[string]string{}
	total := 0
	for i, err := range errs {
		if err != nil {
			t.Fatalf("worker %d: %v", i, err)
		}
		for _, d := range claimedBy[i] {
			if owner, dup := seen[d.ID]; dup {
				t.Fatalf("delivery %s claimed by both w%s and w%d", d.ID, owner, i)
			}
			seen[d.ID] = fmt.Sprint(i)
			total++
		}
	}
	if total != events {
		t.Fatalf("%d of %d deliveries were claimed", total, events)
	}
}

// Gate A3: a consumer that crashes mid-message must not strand it, and the
// redelivery must be safe because the consumer is idempotent.
func TestACrashedConsumerReleasesItsMessage(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	id := f.subscribe(t, eventbus.Subscription{Consumer: "crasher"})
	e := f.publish(t, "thing.happened")

	// A worker claims with a short lease and then dies without acknowledging.
	claimed, err := f.store.Claim(ctx, id, "doomed-worker", 10, 5*time.Second, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(claimed) != 1 {
		t.Fatalf("claimed %d", len(claimed))
	}

	// Before the lease expires nobody else may take it, or two workers would
	// run the same side effect concurrently.
	early, err := f.store.Claim(ctx, id, "other-worker", 10, time.Minute, busAt.Add(time.Second))
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(early) != 0 {
		t.Fatalf("a leased message was claimed by a second worker: %+v", early)
	}

	// After it expires, the message comes back.
	recovered, err := f.store.Claim(ctx, id, "other-worker", 10, time.Minute, busAt.Add(10*time.Second))
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(recovered) != 1 || recovered[0].EventID != e.EventID {
		t.Fatalf("the crashed worker's message was stranded: %+v", recovered)
	}
	// The attempt counter shows this is a redelivery, which is the signal a
	// handler needs to know it may have run before.
	if recovered[0].Attempt != 2 {
		t.Fatalf("attempt %d, want 2", recovered[0].Attempt)
	}
}

// Failure schedules a retry rather than losing the message, and the retry is
// invisible until its backoff elapses.
func TestFailureBacksOffThenRetries(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	id := f.subscribe(t, eventbus.Subscription{Consumer: "flaky"})
	f.publish(t, "thing.happened")

	claimed, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}

	retryAt := busAt.Add(30 * time.Second)
	if err := f.store.Nack(ctx, claimed[0].ID, "downstream unavailable", retryAt, busAt); err != nil {
		t.Fatalf("Nack: %v", err)
	}

	// Not yet visible: a retry costs nothing while it waits.
	tooEarly, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, busAt.Add(5*time.Second))
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(tooEarly) != 0 {
		t.Fatalf("a backed-off message was claimed early: %+v", tooEarly)
	}

	// Visible once the backoff elapses.
	later, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, retryAt.Add(time.Second))
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(later) != 1 {
		t.Fatalf("the message did not come back: %+v", later)
	}
}

// A message that keeps failing is dead-lettered rather than retried forever,
// and dead-lettering it must not stop the rest of the subscription.
func TestPoisonMessageIsDeadLetteredWithoutBlockingOthers(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	const maxAttempts = 3
	id := f.subscribe(t, eventbus.Subscription{Consumer: "strict", MaxAttempts: maxAttempts})

	poison := f.publish(t, "thing.poisoned")
	healthy := f.publish(t, "thing.fine")

	now := busAt
	for attempt := 1; attempt <= maxAttempts; attempt++ {
		claimed, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, now)
		if err != nil {
			t.Fatalf("claim %d: %v", attempt, err)
		}
		for _, d := range claimed {
			if d.EventID == poison.EventID {
				if err := f.store.Nack(ctx, d.ID, "always fails", now, now); err != nil {
					t.Fatalf("Nack: %v", err)
				}
				continue
			}
			if err := f.store.Ack(ctx, d.ID, now); err != nil {
				t.Fatalf("Ack: %v", err)
			}
		}
		now = now.Add(time.Second)
	}

	// The poison message is out of the queue...
	remaining, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, now.Add(time.Hour))
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(remaining) != 0 {
		t.Fatalf("a dead-lettered message is still being delivered: %+v", remaining)
	}

	// ...and findable by an operator.
	dead, err := f.store.DeadLetters(ctx, f.tenant, 10)
	if err != nil {
		t.Fatalf("DeadLetters: %v", err)
	}
	if len(dead) != 1 || dead[0].EventID != poison.EventID {
		t.Fatalf("dead letters: %+v", dead)
	}

	// The healthy event was not held up behind it. This is the whole argument
	// for fan-out on write: head-of-line blocking would have stalled it.
	var healthyState string
	err = f.pool.QueryRow(ctx,
		`SELECT state FROM platform_data.event_delivery WHERE event_id = $1`,
		healthy.EventID).Scan(&healthyState)
	if err != nil {
		t.Fatalf("read healthy delivery: %v", err)
	}
	if healthyState != "delivered" {
		t.Fatalf("the healthy event is %s; the poison message blocked it", healthyState)
	}
}

// An operator who fixed the consumer can retry without editing rows by hand.
func TestDeadLetterCanBeReplayed(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	id := f.subscribe(t, eventbus.Subscription{Consumer: "replayer", MaxAttempts: 1})
	f.publish(t, "thing.happened")

	claimed, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if err := f.store.Nack(ctx, claimed[0].ID, "broken consumer", busAt, busAt); err != nil {
		t.Fatalf("Nack: %v", err)
	}

	dead, err := f.store.DeadLetters(ctx, "", 10)
	if err != nil {
		t.Fatalf("DeadLetters: %v", err)
	}
	if len(dead) != 1 {
		t.Fatalf("want 1 dead letter, got %d", len(dead))
	}

	if err := f.store.ReplayDeadLetter(ctx, dead[0].ID, busAt.Add(time.Hour)); err != nil {
		t.Fatalf("ReplayDeadLetter: %v", err)
	}

	back, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, busAt.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(back) != 1 {
		t.Fatal("a replayed dead letter did not return to the queue")
	}
	// Attempts reset, so the replay gets the full allowance rather than dying
	// again immediately.
	if back[0].Attempt != 1 {
		t.Fatalf("attempt %d after replay, want 1", back[0].Attempt)
	}
}

// A publisher that crashes mid-fan-out and re-runs must produce the same rows,
// not duplicates.
func TestFanOutIsIdempotent(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	id := f.subscribe(t, eventbus.Subscription{Consumer: "once"})
	e := f.publish(t, "thing.happened")

	// The publisher re-runs after a crash.
	err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
		_, err := f.store.FanOut(ctx, e, busAt)
		return err
	})
	if err != nil {
		t.Fatalf("second fan-out: %v", err)
	}

	claimed, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	if len(claimed) != 1 {
		t.Fatalf("a re-run fan-out produced %d deliveries for one event", len(claimed))
	}
}

// A process restarting must not create a second subscription that would
// double-deliver everything.
func TestSubscriptionRegistrationIsIdempotent(t *testing.T) {
	f := newBusFixture(t)

	first := f.subscribe(t, eventbus.Subscription{Consumer: "restarting"})
	second := f.subscribe(t, eventbus.Subscription{Consumer: "restarting"})
	if first != second {
		t.Fatalf("a restart produced a second subscription: %s vs %s", first, second)
	}
}

// Concurrent startup — several replicas rolling out together — must also
// converge on one subscription.
func TestConcurrentSubscriptionRegistrationConverges(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	const replicas = 8
	ids := make([]string, replicas)
	errs := make([]error, replicas)
	var wg sync.WaitGroup
	start := make(chan struct{})

	for i := range replicas {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			ids[i], errs[i] = f.store.EnsureSubscription(ctx,
				eventbus.Subscription{Consumer: "rollout"}.WithDefaults())
		}()
	}
	close(start)
	wg.Wait()

	for i, err := range errs {
		if err != nil {
			t.Fatalf("replica %d: %v", i, err)
		}
		if ids[i] != ids[0] {
			t.Fatalf("replica %d registered %s, replica 0 registered %s", i, ids[i], ids[0])
		}
	}
}

// Acknowledging a delivery whose lease expired is not an error: the side
// effect happened, and the worker that took it over is idempotent.
func TestAckAfterLeaseExpiryIsNotAnError(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	id := f.subscribe(t, eventbus.Subscription{Consumer: "slow"})
	f.publish(t, "thing.happened")

	claimed, err := f.store.Claim(ctx, id, "slow-worker", 10, time.Second, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}
	// Another worker takes it over.
	if _, err := f.store.Claim(ctx, id, "fast-worker", 10, time.Minute, busAt.Add(2*time.Second)); err != nil {
		t.Fatalf("claim: %v", err)
	}
	// The slow worker finally finishes.
	if err := f.store.Ack(ctx, claimed[0].ID, busAt.Add(3*time.Second)); err != nil {
		t.Fatalf("a late ack was an error: %v", err)
	}
}

// The stored failure text is truncated: a handler's error can contain anything
// it was given, including a patient identifier from the payload it failed on.
func TestFailureTextIsBounded(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	id := f.subscribe(t, eventbus.Subscription{Consumer: "verbose"})
	f.publish(t, "thing.happened")

	claimed, err := f.store.Claim(ctx, id, "w1", 10, time.Minute, busAt)
	if err != nil {
		t.Fatalf("claim: %v", err)
	}

	huge := make([]byte, 100_000)
	for i := range huge {
		huge[i] = 'x'
	}
	if err := f.store.Nack(ctx, claimed[0].ID, string(huge), busAt.Add(time.Minute), busAt); err != nil {
		t.Fatalf("Nack: %v", err)
	}

	var stored string
	err = f.pool.QueryRow(ctx,
		`SELECT last_error FROM platform_data.event_delivery WHERE delivery_id = $1`,
		claimed[0].ID).Scan(&stored)
	if err != nil {
		t.Fatalf("read: %v", err)
	}
	if len(stored) > 3000 {
		t.Fatalf("stored %d bytes of failure text", len(stored))
	}
}

func TestSubscriptionValidation(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	for name, sub := range map[string]eventbus.Subscription{
		"no consumer":        {},
		"whitespace in name": {Consumer: "search indexer"},
		"empty event type":   {Consumer: "x", EventTypes: []string{"a", ""}},
		"negative attempts":  {Consumer: "x", MaxAttempts: -1},
	} {
		t.Run(name, func(t *testing.T) {
			if _, err := f.store.EnsureSubscription(ctx, sub); !errors.Is(err, eventbus.ErrInvalidSubscription) {
				t.Fatalf("want ErrInvalidSubscription, got %v", err)
			}
		})
	}
}

// PgBroker: the ADR-005 transport.
//
// The notification is an optimisation and must behave like one — never a
// source of truth, never early enough to be misleading.

func TestBrokerNotifiesOnlyAfterTheTransactionCommits(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()
	f.subscribe(t, eventbus.Subscription{Consumer: "listener"})

	var (
		mu       sync.Mutex
		notified []string
		// visible records whether the delivery rows could be seen by a
		// separate connection at the moment the notification fired. A worker
		// woken before commit finds nothing and sleeps again, so an early
		// notification is worse than none: it costs a wakeup and saves
		// nothing.
		visibleAtNotify bool
	)

	broker := store.NewPgBroker(f.store, func(eventType string) {
		var n int64
		// A fresh connection from the pool, deliberately not the publisher's
		// transaction: that is what a worker in another goroutine sees.
		row := f.pool.QueryRow(ctx, `SELECT count(*) FROM platform_data.event_delivery`)
		if err := row.Scan(&n); err == nil && n > 0 {
			visibleAtNotify = true
		}
		mu.Lock()
		notified = append(notified, eventType)
		mu.Unlock()
	}, nil)

	e := outbox.Event{
		EventID: uuid.NewString(), EventType: "organization.facility_created",
		SchemaVersion: 1, OccurredAt: busAt, TenantID: f.tenant, Source: "test",
		AggregateType: "facility", AggregateID: uuid.NewString(),
		CorrelationID: uuid.NewString(), Actor: "sys", Payload: json.RawMessage(`{}`),
	}

	err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := f.store.Append(ctx, e); err != nil {
			return err
		}
		if err := broker.Publish(ctx, e); err != nil {
			return err
		}
		mu.Lock()
		defer mu.Unlock()
		if len(notified) != 0 {
			t.Error("the notification fired inside the transaction")
		}
		return nil
	})
	if err != nil {
		t.Fatalf("publish: %v", err)
	}

	mu.Lock()
	defer mu.Unlock()
	if len(notified) != 1 || notified[0] != e.EventType {
		t.Fatalf("notifications = %v, want one for %s", notified, e.EventType)
	}
	if !visibleAtNotify {
		t.Fatal("the deliveries were not visible when the notification fired")
	}
}

func TestBrokerDoesNotNotifyWhenTheTransactionRollsBack(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()
	f.subscribe(t, eventbus.Subscription{Consumer: "listener"})

	notified := 0
	broker := store.NewPgBroker(f.store, func(string) { notified++ }, nil)

	abandon := errors.New("the use case failed after publishing")
	e := outbox.Event{
		EventID: uuid.NewString(), EventType: "organization.facility_created",
		SchemaVersion: 1, OccurredAt: busAt, TenantID: f.tenant, Source: "test",
		AggregateType: "facility", AggregateID: uuid.NewString(),
		CorrelationID: uuid.NewString(), Actor: "sys", Payload: json.RawMessage(`{}`),
	}

	err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := f.store.Append(ctx, e); err != nil {
			return err
		}
		if err := broker.Publish(ctx, e); err != nil {
			return err
		}
		return abandon
	})
	if !errors.Is(err, abandon) {
		t.Fatalf("WithinTx = %v, want the abandon error", err)
	}
	if notified != 0 {
		t.Fatal("a consumer was woken for an event that was rolled back")
	}
}

// An event nobody subscribed to is published successfully and wakes nobody.
// Fan-out that failed on an unconsumed event type would make adding an event
// depend on adding a consumer first.
func TestBrokerPublishesAnEventWithNoSubscribers(t *testing.T) {
	f := newBusFixture(t)
	ctx := context.Background()

	notified := 0
	broker := store.NewPgBroker(f.store, func(string) { notified++ }, nil)

	e := outbox.Event{
		EventID: uuid.NewString(), EventType: "organization.nobody_cares",
		SchemaVersion: 1, OccurredAt: busAt, TenantID: f.tenant, Source: "test",
		AggregateType: "thing", AggregateID: uuid.NewString(),
		CorrelationID: uuid.NewString(), Actor: "sys", Payload: json.RawMessage(`{}`),
	}

	err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := f.store.Append(ctx, e); err != nil {
			return err
		}
		return broker.Publish(ctx, e)
	})
	if err != nil {
		t.Fatalf("publish: %v", err)
	}
	if notified != 0 {
		t.Fatalf("woke %d consumers for an event nobody wanted", notified)
	}
}
