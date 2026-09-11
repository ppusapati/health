package store

import (
	"context"
	"log/slog"
	"time"

	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// PgBroker is the ADR-005 transport: PostgreSQL itself.
//
// Publishing means fanning the event out into per-consumer delivery rows and
// waking anything that is listening. Both happen inside the publisher's
// transaction, which is the property that makes this transport worth choosing
// over a network broker at this stage:
//
//   - An event cannot be marked published without its deliveries existing. A
//     network broker acknowledges separately, so a crash between the ack and
//     the outbox update loses the event for every consumer while the outbox
//     believes it was delivered.
//   - There is no second system to be inconsistent with. The outbox row, the
//     delivery rows and the aggregate change all commit together or not at
//     all.
//
// What it does not give is what a real broker is for: throughput beyond one
// database, consumers outside this deployment, and retention independent of
// the transactional store. ADR-005 records the measured thresholds at which
// those become the binding constraint.
type PgBroker struct {
	store *Store
	// notify wakes local workers, and is called with the event type so a
	// runtime can route it to the subscriptions that asked for it.
	//
	// In-process only, and deliberately so: a notification is an optimisation,
	// and correctness must not depend on one arriving. A worker that never
	// gets one still drains on its poll interval, which is what makes a
	// multi-process deployment work without LISTEN/NOTIFY plumbing.
	notify func(eventType string)
	log    *slog.Logger
}

// NewPgBroker constructs the broker.
//
// notify may be nil, in which case workers rely on polling alone. That is a
// supported configuration rather than a degraded one: it raises steady-state
// latency to the poll interval and changes nothing about delivery.
func NewPgBroker(s *Store, notify func(eventType string), log *slog.Logger) *PgBroker {
	if log == nil {
		log = slog.Default()
	}
	return &PgBroker{store: s, notify: notify, log: log}
}

// Publish fans an event out to every interested subscription.
//
// Runs inside the publisher's transaction. A returned error leaves the event
// unpublished and the whole batch's transaction to be rolled back by the
// caller, so a fan-out failure retries rather than silently dropping.
func (b *PgBroker) Publish(ctx context.Context, e outbox.Event) error {
	delivered, err := b.store.FanOut(ctx, e, time.Now().UTC())
	if err != nil {
		return err
	}

	// Zero deliveries is normal and worth noticing. It means no subscription
	// wanted this event — correct for an event type nobody consumes yet, and a
	// misconfiguration if somebody believes they subscribed. Logged at debug
	// so it is findable without being noise.
	if delivered == 0 {
		b.log.Debug("event matched no subscription",
			slog.String("event_type", e.EventType),
			slog.String("event_id", e.EventID))
		return nil
	}

	if b.notify == nil {
		return nil
	}

	// After commit, not here. Fired inside the transaction the notification
	// would arrive before the delivery rows are visible: the woken worker
	// claims, finds nothing, and sleeps until its next poll — so the
	// notification costs a wakeup and saves nothing. Measured, that is the
	// difference between a p50 of one poll interval and a p50 of a few
	// milliseconds.
	eventType := e.EventType
	if err := pgtx.AfterCommit(ctx, func() { b.notify(eventType) }); err != nil {
		// Publishing outside a transaction is a wiring mistake, not a
		// delivery failure — the fan-out above would have failed first if the
		// rows could not be written. Notify directly so a caller that has
		// somehow got here still gets a woken worker.
		b.notify(eventType)
	}
	return nil
}
