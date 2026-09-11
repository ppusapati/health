package eventbus

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"math/rand/v2"
	"time"
)

// Worker drains one subscription.
//
// One worker per process per subscription; run several processes and they
// compete for the same rows through SKIP LOCKED, which is how this scales
// horizontally without any coordination between them (SRS-NFR-003).
type Worker struct {
	store   Store
	sub     Subscription
	handler Handler
	id      string

	batchSize    int32
	lease        time.Duration
	pollInterval time.Duration
	now          func() time.Time
	log          *slog.Logger

	// notify wakes the worker before its poll interval elapses. Buffered depth
	// one: a notification while one is already pending is redundant, because
	// the pending one will cause a claim that sees both events.
	notify chan struct{}
}

// ackTimeout bounds how long recording a delivery outcome may take once the
// handler has finished. Short: the statement is a single primary-key update,
// and anything slower than this means the database is gone, in which case the
// lease expiring is the recovery path.
const ackTimeout = 5 * time.Second

// Options tune a worker.
type Options struct {
	BatchSize    int32
	Lease        time.Duration
	PollInterval time.Duration
	WorkerID     string
	Now          func() time.Time
	Logger       *slog.Logger
}

// NewWorker constructs a worker for a subscription.
func NewWorker(store Store, sub Subscription, handler Handler, opts Options) (*Worker, error) {
	sub = sub.WithDefaults()
	if err := sub.Validate(); err != nil {
		return nil, err
	}
	if store == nil {
		return nil, errors.New("eventbus: a store is required")
	}
	if handler == nil {
		return nil, errors.New("eventbus: a handler is required")
	}

	w := &Worker{
		store: store, sub: sub, handler: handler,
		batchSize:    opts.BatchSize,
		lease:        opts.Lease,
		pollInterval: opts.PollInterval,
		id:           opts.WorkerID,
		now:          opts.Now,
		log:          opts.Logger,
		notify:       make(chan struct{}, 1),
	}
	if w.batchSize <= 0 {
		w.batchSize = DefaultBatchSize
	}
	if w.lease <= 0 {
		w.lease = DefaultLease
	}
	if w.pollInterval <= 0 {
		w.pollInterval = DefaultPollInterval
	}
	if w.id == "" {
		w.id = fmt.Sprintf("worker-%d", rand.Int64())
	}
	if w.now == nil {
		w.now = func() time.Time { return time.Now().UTC() }
	}
	if w.log == nil {
		w.log = slog.Default()
	}
	return w, nil
}

// Notify wakes the worker.
//
// Non-blocking: a notification arriving while one is already pending is
// dropped, because the pending one will cause a claim that sees both events.
// Blocking here would let a slow consumer apply back-pressure to the publisher,
// which is the wrong direction — the publisher's transaction has already
// committed.
func (w *Worker) Notify() {
	select {
	case w.notify <- struct{}{}:
	default:
	}
}

// Run drains until the context is cancelled.
func (w *Worker) Run(ctx context.Context) error {
	subscriptionID, err := w.store.EnsureSubscription(ctx, w.sub)
	if err != nil {
		return fmt.Errorf("eventbus: register subscription %s: %w", w.sub.Consumer, err)
	}

	ticker := time.NewTicker(w.pollInterval)
	defer ticker.Stop()

	for {
		// Drain to empty before waiting again. Claiming one batch per tick
		// would make a backlog take backlog/batch ticks to clear, so a burst
		// would still be draining minutes later.
		for {
			claimed, err := w.drainOnce(ctx, subscriptionID)
			if err != nil {
				if ctx.Err() != nil {
					return ctx.Err()
				}
				// A failed claim is usually the database being briefly
				// unavailable. Log and wait for the next tick rather than
				// spinning, which would turn a blip into a load spike.
				w.log.Error("event delivery claim failed",
					slog.String("consumer", w.sub.Consumer),
					slog.String("error", err.Error()))
				break
			}
			if claimed == 0 {
				break
			}
		}

		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-w.notify:
		case <-ticker.C:
		}
	}
}

// drainOnce claims and processes one batch, returning how many were claimed.
func (w *Worker) drainOnce(ctx context.Context, subscriptionID string) (int, error) {
	now := w.now()
	deliveries, err := w.store.Claim(ctx, subscriptionID, w.id, w.batchSize, w.lease, now)
	if err != nil {
		return 0, err
	}

	for _, d := range deliveries {
		w.process(ctx, d)
	}
	return len(deliveries), nil
}

// process runs the handler and records the outcome.
func (w *Worker) process(ctx context.Context, d Delivery) {
	// The handler gets the lease as its deadline. A handler that runs past it
	// has already lost its claim — another worker may have picked the message
	// up — so continuing would risk two workers applying the same side effect
	// while both believe they hold it.
	handlerCtx, cancel := context.WithTimeout(ctx, w.lease)
	defer cancel()

	err := w.invoke(handlerCtx, d)
	now := w.now()

	// Record the outcome on a context that shutdown does not cancel. The
	// handler has already run; losing its acknowledgement because the process
	// was asked to stop turns every rolling restart into a burst of duplicate
	// deliveries. Bounded, because a shutdown must still finish.
	outcomeCtx, outcomeCancel := context.WithTimeout(context.WithoutCancel(ctx), ackTimeout)
	defer outcomeCancel()

	if err == nil {
		if ackErr := w.store.Ack(outcomeCtx, d.ID, now); ackErr != nil {
			// The side effect happened and the acknowledgement did not. The
			// message will be redelivered, which is precisely why every
			// consumer must be idempotent — this is the at-least-once
			// guarantee showing itself rather than a bug.
			w.log.Error("delivery handled but not acknowledged",
				slog.String("consumer", w.sub.Consumer),
				slog.String("event_id", d.EventID),
				slog.String("error", ackErr.Error()))
		}
		return
	}

	retryAt := now.Add(jitter(RetryDelay(d.Attempt)))
	if nackErr := w.store.Nack(outcomeCtx, d.ID, err.Error(), retryAt, now); nackErr != nil {
		w.log.Error("delivery failure not recorded",
			slog.String("consumer", w.sub.Consumer),
			slog.String("event_id", d.EventID),
			slog.String("error", nackErr.Error()))
		return
	}

	w.log.Warn("delivery failed",
		slog.String("consumer", w.sub.Consumer),
		slog.String("event_id", d.EventID),
		slog.String("event_type", d.Type),
		slog.Int("attempt", d.Attempt),
		slog.String("error", err.Error()))
}

// invoke calls the handler, converting a panic into an ordinary failure.
//
// One poison message must not stop a consumer. Without this, a nil-pointer
// dereference on one event takes the worker down, the process restarts, claims
// the same message, and crashes again — a crash loop driven by a single row.
func (w *Worker) invoke(ctx context.Context, d Delivery) (err error) {
	defer func() {
		if recovered := recover(); recovered != nil {
			err = fmt.Errorf("%w: %v", ErrHandlerPanicked, recovered)
		}
	}()
	return w.handler(ctx, d)
}

// jitter spreads retries so a batch that failed together does not return
// together. Applied here rather than in RetryDelay so the schedule stays
// assertable in a test.
func jitter(d time.Duration) time.Duration {
	if d <= 0 {
		return d
	}
	// ±20%. Enough to break up a herd; not so much that a "one second" retry
	// becomes five.
	spread := float64(d) * 0.2
	return d + time.Duration((rand.Float64()*2-1)*spread)
}
