package eventbus

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
)

// Runtime owns the consumer workers in one process.
//
// It exists for two reasons. The first is lifecycle: consumers have to start
// and stop together with the server, and a consumer that fails to register is
// a consumer that will silently receive nothing — so registration failure has
// to stop the process rather than be logged and forgotten.
//
// The second is routing. The broker knows an event's type, not which consumers
// wanted it; the subscriptions know the reverse. The Runtime is where the two
// meet, so a notification about a medication event wakes the medication
// consumer and not the seventeen others.
type Runtime struct {
	workers []*Worker

	// byType holds the workers that filter on a type; anyType holds the ones
	// that take everything. A notification goes to both.
	byType  map[string][]*Worker
	anyType []*Worker
}

// Registration is one consumer.
type Registration struct {
	Subscription Subscription
	Handler      Handler
	Options      Options
}

// NewRuntime builds the workers for a set of registrations.
//
// Every registration is validated up front. Discovering at startup that a
// consumer name is malformed is cheap; discovering it an hour later, from the
// absence of events, is not.
func NewRuntime(store Store, registrations ...Registration) (*Runtime, error) {
	r := &Runtime{byType: map[string][]*Worker{}}

	seen := map[string]bool{}
	for _, reg := range registrations {
		name := strings.TrimSpace(reg.Subscription.Consumer)
		if seen[name] {
			// Two workers in one process under one consumer name would compete
			// with each other for the same rows: more claims, no more
			// throughput, and a confusing operational picture. Concurrency
			// within a consumer comes from running more processes.
			return nil, fmt.Errorf("%w: consumer %q is registered twice", ErrInvalidSubscription, name)
		}
		seen[name] = true

		worker, err := NewWorker(store, reg.Subscription, reg.Handler, reg.Options)
		if err != nil {
			return nil, err
		}
		r.workers = append(r.workers, worker)

		if len(reg.Subscription.EventTypes) == 0 {
			r.anyType = append(r.anyType, worker)
			continue
		}
		for _, t := range reg.Subscription.EventTypes {
			r.byType[t] = append(r.byType[t], worker)
		}
	}
	return r, nil
}

// Notify wakes the workers that subscribe to an event type.
//
// Safe to call with a type nobody wants, and safe to call on a Runtime with no
// workers: a deployment that runs the publisher but no consumers is a valid
// configuration, not a misconfiguration to guard against.
func (r *Runtime) Notify(eventType string) {
	for _, w := range r.byType[eventType] {
		w.Notify()
	}
	for _, w := range r.anyType {
		w.Notify()
	}
}

// Workers reports how many consumers this runtime drives.
func (r *Runtime) Workers() int { return len(r.workers) }

// Run drives every worker until the context is cancelled.
//
// If any worker fails to start, the whole runtime stops and the error is
// returned. A half-started consumer set is the worst outcome available: the
// process looks healthy, events keep being published, and one subscription's
// backlog grows without limit until somebody notices.
func (r *Runtime) Run(ctx context.Context) error {
	if len(r.workers) == 0 {
		<-ctx.Done()
		return ctx.Err()
	}

	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	var (
		wg    sync.WaitGroup
		mu    sync.Mutex
		first error
	)

	for _, w := range r.workers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			err := w.Run(ctx)
			if err == nil || errors.Is(err, context.Canceled) {
				return
			}
			mu.Lock()
			if first == nil {
				first = err
			}
			mu.Unlock()
			cancel()
		}()
	}
	wg.Wait()

	mu.Lock()
	defer mu.Unlock()
	if first != nil {
		return first
	}
	return ctx.Err()
}
