package app_test

import (
	"context"
	"encoding/json"
	"errors"
	"net/http/httptest"
	"sync"
	"testing"
	"time"

	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgapp "github.com/ppusapati/health/code/internal/organization/application"
	"github.com/ppusapati/health/code/internal/platform/eventbus"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/store"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

// Gate A3: an event written by a real use case, through the real composition
// root, reaches a real consumer — and survives a consumer that crashes holding
// it.
//
// The unit tests in internal/platform/store prove each delivery property in
// isolation. This file proves the pipeline is actually wired: outbox row ->
// publisher -> fan-out -> worker -> handler. A seam that is correct but not
// connected delivers nothing, and nothing about the other tests would notice.

// busHarness is the standard stack plus a running event pipeline.
type busHarness struct {
	org      organizationv1connect.OrganizationServiceClient
	store    *store.Store
	tenantID string
	stop     func()
}

func newBusHarness(t *testing.T, registrations ...eventbus.Registration) *busHarness {
	t.Helper()

	pool := pgtest.New(t)

	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool:     pool,
		Verifier: verifier,
		Build:    platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
		},
		Consumers: registrations,
		// Short, because the test is waiting on it. Production takes the
		// default.
		PublishInterval: 20 * time.Millisecond,
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan error, 1)
	go func() { done <- built.RunBackground(ctx) }()

	stopped := false
	stop := func() {
		if stopped {
			return
		}
		stopped = true
		cancel()
		if err := <-done; err != nil && !errors.Is(err, context.Canceled) {
			t.Errorf("event pipeline failed: %v", err)
		}
	}
	t.Cleanup(stop)

	h := &harness{pool: pool, server: server,
		org: organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL)}

	return &busHarness{
		org:      h.org,
		store:    built.Store,
		tenantID: h.provisionTenant(t, "Apollo Group"),
		stop:     stop,
	}
}

func (b *busHarness) createFacility(t *testing.T, code, name string) {
	t.Helper()
	_, err := b.org.CreateFacility(context.Background(),
		as(tenantAdminToken(b.tenantID), &organizationv1.CreateFacilityRequest{
			Code: code, DisplayName: name,
			Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility(%q): %v", code, err)
	}
}

// collector records deliveries and signals each one.
type collector struct {
	mu         sync.Mutex
	deliveries []eventbus.Delivery
	signal     chan struct{}

	// failUntil makes the handler fail for the first n attempts, so a test can
	// drive the retry path.
	failUntil int
	attempts  int
}

func newCollector() *collector {
	return &collector{signal: make(chan struct{}, 256)}
}

func (c *collector) handle(_ context.Context, d eventbus.Delivery) error {
	c.mu.Lock()
	c.attempts++
	failing := c.attempts <= c.failUntil
	if !failing {
		c.deliveries = append(c.deliveries, d)
	}
	c.mu.Unlock()

	if failing {
		return errors.New("consumer is not ready")
	}
	c.signal <- struct{}{}
	return nil
}

func (c *collector) await(t *testing.T, n int, within time.Duration) []eventbus.Delivery {
	t.Helper()
	deadline := time.After(within)
	for range n {
		select {
		case <-c.signal:
		case <-deadline:
			c.mu.Lock()
			got := len(c.deliveries)
			c.mu.Unlock()
			t.Fatalf("only %d of %d events arrived within %s", got, n, within)
		}
	}
	c.mu.Lock()
	defer c.mu.Unlock()
	return append([]eventbus.Delivery(nil), c.deliveries...)
}

// The end-to-end claim: an RPC that commits a facility results in a consumer
// being handed that fact, with the tenant and the payload intact.
func TestCommittedFactReachesAConsumer(t *testing.T) {
	c := newCollector()
	h := newBusHarness(t, eventbus.Registration{
		Subscription: eventbus.Subscription{
			Consumer:   "facility-projector",
			EventTypes: []string{orgapp.EventFacilityCreated},
		},
		Handler: c.handle,
		Options: eventbus.Options{PollInterval: 20 * time.Millisecond},
	})

	h.createFacility(t, "main", "Main Hospital")

	delivered := c.await(t, 1, 30*time.Second)[0]

	if delivered.Type != orgapp.EventFacilityCreated {
		t.Fatalf("event type = %q, want %q", delivered.Type, orgapp.EventFacilityCreated)
	}
	if delivered.TenantID != h.tenantID {
		t.Fatalf("tenant = %q, want %q", delivered.TenantID, h.tenantID)
	}
	if delivered.Attempt != 1 {
		t.Fatalf("attempt = %d on a first delivery, want 1", delivered.Attempt)
	}

	// The payload travels with the delivery. A consumer that had to call back
	// for the body would see whatever the row says now, not what the event
	// says happened — which is how a projection ends up reporting a later
	// state under an earlier event.
	var payload map[string]any
	if err := json.Unmarshal(delivered.Event.Payload, &payload); err != nil {
		t.Fatalf("payload is not JSON: %v", err)
	}
	// "MAIN" rather than "main": the domain normalises the code, and the event
	// carries what was stored, not what was asked for.
	if payload["code"] != "MAIN" {
		t.Fatalf("payload does not describe the facility that was created: %v", payload)
	}
}

// A consumer that filters gets what it asked for and nothing else, through the
// whole pipeline rather than only at the SQL level.
func TestAFilteredConsumerIsNotSentEverything(t *testing.T) {
	facilities := newCollector()
	everything := newCollector()

	h := newBusHarness(t,
		eventbus.Registration{
			Subscription: eventbus.Subscription{
				Consumer:   "facility-projector",
				EventTypes: []string{orgapp.EventFacilityCreated},
			},
			Handler: facilities.handle,
			Options: eventbus.Options{PollInterval: 20 * time.Millisecond},
		},
		eventbus.Registration{
			Subscription: eventbus.Subscription{Consumer: "audit-archive"},
			Handler:      everything.handle,
			Options:      eventbus.Options{PollInterval: 20 * time.Millisecond},
		},
	)

	h.createFacility(t, "main", "Main Hospital")

	// The unfiltered consumer sees the tenant provisioning from the harness as
	// well as the facility; the filtered one sees only the facility.
	everything.await(t, 2, 30*time.Second)
	got := facilities.await(t, 1, 30*time.Second)

	if len(got) != 1 {
		t.Fatalf("the filtered consumer received %d events, want 1", len(got))
	}
	if got[0].Type != orgapp.EventFacilityCreated {
		t.Fatalf("the filtered consumer received %q", got[0].Type)
	}
}

// A consumer that fails gets the event again, and the redelivery is marked as
// one. Without the attempt count a handler cannot tell a retry from a first
// sight, which is exactly what it needs to be idempotent about.
func TestAFailedDeliveryIsRetried(t *testing.T) {
	c := newCollector()
	c.failUntil = 2

	h := newBusHarness(t, eventbus.Registration{
		Subscription: eventbus.Subscription{
			Consumer:   "flaky-projector",
			EventTypes: []string{orgapp.EventFacilityCreated},
		},
		Handler: c.handle,
		Options: eventbus.Options{PollInterval: 20 * time.Millisecond},
	})

	h.createFacility(t, "main", "Main Hospital")

	// Two failures at one and two seconds of backoff, then success.
	delivered := c.await(t, 1, 60*time.Second)[0]
	if delivered.Attempt != 3 {
		t.Fatalf("attempt = %d on the third delivery, want 3", delivered.Attempt)
	}
}

// Gate A3 at deployment level: a consumer process stops while holding an
// unacknowledged event, and its replacement picks that event up rather than
// the event being stranded.
//
// This is the rolling-restart case — SIGTERM, the handler unwinds, the
// delivery goes back to pending. The harder case, a process killed outright
// with no chance to record anything, is recovered by lease expiry and is
// tested against the database in internal/platform/store, where the lease
// clock can be controlled.
// errShutdownMidDelivery is what a handler reports when the process is going
// away with the delivery still in its hands.
var errShutdownMidDelivery = errors.New("shutting down mid-delivery")

func TestAnEventSurvivesTheConsumerRestarting(t *testing.T) {
	blocked := make(chan struct{})
	claimed := make(chan struct{}, 1)

	// The first consumer claims the delivery and then blocks until the process
	// is told to stop, so the event is in flight and unacknowledged at exactly
	// the moment the deployment replaces the pod.
	crashing := func(ctx context.Context, _ eventbus.Delivery) error {
		select {
		case claimed <- struct{}{}:
		default:
		}
		select {
		case <-blocked:
		case <-ctx.Done():
		}
		// Unconditionally unfinished. Returning ctx.Err() would be nil in the
		// race where the handler notices the stop signal before the worker's
		// context is cancelled, and the worker would acknowledge a delivery
		// nobody handled — which is exactly the stranding this test exists to
		// rule out, passed off as a success.
		return errShutdownMidDelivery
	}

	h := newBusHarness(t, eventbus.Registration{
		Subscription: eventbus.Subscription{
			Consumer:   "crash-test",
			EventTypes: []string{orgapp.EventFacilityCreated},
		},
		Handler: crashing,
		Options: eventbus.Options{
			PollInterval: 20 * time.Millisecond,
			// Short, so that if the handler somehow never unwinds the lease
			// still expires within the test's patience rather than hanging it.
			Lease: 500 * time.Millisecond,
		},
	})

	h.createFacility(t, "main", "Main Hospital")

	select {
	case <-claimed:
	case <-time.After(30 * time.Second):
		t.Fatal("the first consumer never claimed the event")
	}

	// Stop the process. The delivery is in flight, leased, unacknowledged.
	close(blocked)
	h.stop()

	// A replacement worker, exactly as a restarted pod would be. It shares the
	// consumer name, so it inherits the same subscription and the same
	// delivery rather than a fresh copy.
	recovered := newCollector()
	worker, err := eventbus.NewWorker(h.store,
		eventbus.Subscription{
			Consumer:   "crash-test",
			EventTypes: []string{orgapp.EventFacilityCreated},
		}, recovered.handle,
		eventbus.Options{PollInterval: 20 * time.Millisecond, Lease: 5 * time.Second})
	if err != nil {
		t.Fatalf("replacement worker: %v", err)
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	go func() { _ = worker.Run(ctx) }()

	delivered := recovered.await(t, 1, 30*time.Second)[0]
	if delivered.Type != orgapp.EventFacilityCreated {
		t.Fatalf("the replacement received %q", delivered.Type)
	}
	if delivered.Attempt < 1 {
		t.Fatalf("attempt = %d, want at least 1", delivered.Attempt)
	}
}

// A consumer whose name is invalid must stop the process rather than run
// without it: a subscription that never registers receives nothing, silently.
func TestABrokenConsumerRegistrationRefusesToStart(t *testing.T) {
	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{Version: "t", Commit: "t", BuiltAt: "t"},
		Consumers: []eventbus.Registration{{
			Subscription: eventbus.Subscription{Consumer: "has a space"},
			Handler:      func(context.Context, eventbus.Delivery) error { return nil },
		}},
	})

	if built.Err == nil {
		t.Fatal("a malformed consumer name was accepted")
	}
	if runErr := built.RunBackground(context.Background()); runErr == nil {
		t.Fatal("RunBackground succeeded with a broken consumer set")
	}
}
