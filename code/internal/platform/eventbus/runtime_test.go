package eventbus_test

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/eventbus"
)

// The Runtime's job is routing and lifecycle. Delivery semantics are tested
// against real PostgreSQL in internal/platform/store; what matters here is
// that a notification reaches the consumers that asked for the event type and
// nobody else, and that a consumer which cannot start stops the process rather
// than silently receiving nothing.

func noopHandler(context.Context, eventbus.Delivery) error { return nil }

func TestNotificationReachesOnlyInterestedConsumers(t *testing.T) {
	store := newMemStore()

	runtime, err := eventbus.NewRuntime(store,
		eventbus.Registration{
			Subscription: eventbus.Subscription{
				Consumer:   "medication",
				EventTypes: []string{"medication.administered"},
			},
			Handler: noopHandler,
			// A poll interval long enough that nothing drains on a tick: any
			// claim this test sees came from a notification.
			Options: eventbus.Options{PollInterval: time.Hour},
		},
		eventbus.Registration{
			Subscription: eventbus.Subscription{
				Consumer:   "billing",
				EventTypes: []string{"billing.invoice_issued"},
			},
			Handler: noopHandler,
			Options: eventbus.Options{PollInterval: time.Hour},
		},
		eventbus.Registration{
			Subscription: eventbus.Subscription{Consumer: "audit-archive"},
			Handler:      noopHandler,
			Options:      eventbus.Options{PollInterval: time.Hour},
		},
	)
	if err != nil {
		t.Fatalf("NewRuntime: %v", err)
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	done := make(chan struct{})
	go func() { defer close(done); _ = runtime.Run(ctx) }()

	// Each worker claims once on start, before it waits. Let that settle so the
	// count below measures the notification rather than the startup drain.
	waitForClaims(t, store, 3)
	baseline := store.claimCount()

	runtime.Notify("medication.administered")

	// The medication consumer and the unfiltered one wake; billing does not.
	waitForClaims(t, store, baseline+2)

	time.Sleep(50 * time.Millisecond)
	if got := store.claimCount(); got != baseline+2 {
		t.Fatalf("%d claims after one notification, want %d — billing woke for an event it never asked for",
			got-baseline, 2)
	}

	cancel()
	<-done
}

// A notification for a type nobody wants must be a no-op, not a panic. Event
// types are published long before the consumer that will want them exists.
func TestNotifyForAnUnwantedTypeIsHarmless(t *testing.T) {
	runtime, err := eventbus.NewRuntime(newMemStore(), eventbus.Registration{
		Subscription: eventbus.Subscription{
			Consumer: "medication", EventTypes: []string{"medication.administered"},
		},
		Handler: noopHandler,
	})
	if err != nil {
		t.Fatalf("NewRuntime: %v", err)
	}
	runtime.Notify("nobody.wants.this")
}

// A process that publishes but consumes nothing is a supported deployment, so
// an empty runtime must run and stop cleanly rather than return immediately.
func TestAnEmptyRuntimeRunsUntilCancelled(t *testing.T) {
	runtime, err := eventbus.NewRuntime(newMemStore())
	if err != nil {
		t.Fatalf("NewRuntime: %v", err)
	}
	if runtime.Workers() != 0 {
		t.Fatalf("Workers() = %d, want 0", runtime.Workers())
	}
	runtime.Notify("anything")

	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan error, 1)
	go func() { done <- runtime.Run(ctx) }()

	select {
	case err := <-done:
		t.Fatalf("an empty runtime exited before it was cancelled: %v", err)
	case <-time.After(50 * time.Millisecond):
	}

	cancel()
	if err := <-done; !errors.Is(err, context.Canceled) {
		t.Fatalf("Run = %v, want context.Canceled", err)
	}
}

// Two workers under one consumer name in one process would compete for the
// same rows: more claims, no more throughput. Concurrency within a consumer
// comes from running more processes.
func TestDuplicateConsumerNamesAreRefused(t *testing.T) {
	_, err := eventbus.NewRuntime(newMemStore(),
		eventbus.Registration{
			Subscription: eventbus.Subscription{Consumer: "projector"},
			Handler:      noopHandler,
		},
		eventbus.Registration{
			Subscription: eventbus.Subscription{Consumer: "projector"},
			Handler:      noopHandler,
		},
	)
	if !errors.Is(err, eventbus.ErrInvalidSubscription) {
		t.Fatalf("NewRuntime = %v, want ErrInvalidSubscription", err)
	}
}

func TestAnInvalidRegistrationIsRefusedAtConstruction(t *testing.T) {
	_, err := eventbus.NewRuntime(newMemStore(), eventbus.Registration{
		Subscription: eventbus.Subscription{Consumer: ""},
		Handler:      noopHandler,
	})
	if !errors.Is(err, eventbus.ErrInvalidSubscription) {
		t.Fatalf("NewRuntime = %v, want ErrInvalidSubscription", err)
	}
}

// One consumer failing to register stops the whole runtime. The alternative —
// the others keep running — is a process that looks healthy while one
// subscription's backlog grows without limit.
func TestOneFailedConsumerStopsTheRuntime(t *testing.T) {
	broken := newMemStore()
	broken.subError = errors.New("subscription table is gone")

	runtime, err := eventbus.NewRuntime(broken,
		eventbus.Registration{
			Subscription: eventbus.Subscription{Consumer: "a"},
			Handler:      noopHandler,
		},
		eventbus.Registration{
			Subscription: eventbus.Subscription{Consumer: "b"},
			Handler:      noopHandler,
		},
	)
	if err != nil {
		t.Fatalf("NewRuntime: %v", err)
	}

	runErr := make(chan error, 1)
	go func() { runErr <- runtime.Run(context.Background()) }()

	select {
	case err := <-runErr:
		if err == nil || errors.Is(err, context.Canceled) {
			t.Fatalf("Run = %v, want the registration failure", err)
		}
	case <-time.After(2 * time.Second):
		t.Fatal("the runtime kept running with a consumer that never registered")
	}
}

// Notify is called from the publisher's after-commit hook, which may be any
// goroutine. It must never block that caller: the transaction has already
// committed, so back-pressure from a slow consumer can achieve nothing except
// stalling the publisher.
func TestNotifyIsSafeUnderConcurrency(t *testing.T) {
	runtime, err := eventbus.NewRuntime(newMemStore(), eventbus.Registration{
		Subscription: eventbus.Subscription{Consumer: "everything"},
		Handler:      noopHandler,
		Options:      eventbus.Options{PollInterval: time.Hour},
	})
	if err != nil {
		t.Fatalf("NewRuntime: %v", err)
	}

	var wg sync.WaitGroup
	for range 64 {
		wg.Add(1)
		go func() { defer wg.Done(); runtime.Notify("organization.facility_created") }()
	}

	settled := make(chan struct{})
	go func() { wg.Wait(); close(settled) }()

	select {
	case <-settled:
	case <-time.After(2 * time.Second):
		t.Fatal("Notify blocked its caller")
	}
}

func waitForClaims(t *testing.T, store *memStore, want int) {
	t.Helper()
	deadline := time.Now().Add(2 * time.Second)
	for time.Now().Before(deadline) {
		if store.claimCount() >= want {
			return
		}
		time.Sleep(2 * time.Millisecond)
	}
	t.Fatalf("only %d claims after waiting, want %d", store.claimCount(), want)
}
