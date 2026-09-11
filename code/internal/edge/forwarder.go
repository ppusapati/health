package edge

import (
	"context"
	"errors"
	"log/slog"
	"time"

	"github.com/ppusapati/health/code/internal/platform/obs"
)

// Uplink is the edge's view of the cloud.
//
// It is one method so the WAN-loss scenario is expressible as a test: an
// implementation that returns ErrUnreachable is exactly a severed link.
type Uplink interface {
	// Forward submits one operation. It must be idempotent on op.ID: the edge
	// retries whenever an acknowledgement is lost, which is routine on a flaky
	// hospital WAN.
	Forward(ctx context.Context, op Operation) error
}

// ErrUnreachable reports that the cloud could not be contacted. Operations stay
// queued and are retried; they are never dropped.
var ErrUnreachable = errors.New("edge: cloud is unreachable")

// PermanentRejection reports that the cloud refused an operation and will keep
// refusing it. Retrying is pointless, so the operation is parked for a human
// rather than looping forever.
type PermanentRejection struct{ Reason string }

func (p PermanentRejection) Error() string { return "edge: permanently rejected: " + p.Reason }

// Forwarder drains the local queue to the cloud.
type Forwarder struct {
	queue  *Queue
	uplink Uplink
	// batchSize bounds one drain so a long outage's backlog is worked through
	// in steady increments rather than one enormous burst on reconnection.
	batchSize int
}

// DefaultBatchSize is the default drain size.
const DefaultBatchSize = 50

// NewForwarder constructs a Forwarder.
func NewForwarder(queue *Queue, uplink Uplink, batchSize int) *Forwarder {
	if batchSize <= 0 {
		batchSize = DefaultBatchSize
	}
	return &Forwarder{queue: queue, uplink: uplink, batchSize: batchSize}
}

// DrainResult reports what one drain achieved.
type DrainResult struct {
	Forwarded int
	Rejected  int
	// Deferred counts operations left pending because the link is down.
	Deferred int
}

// Drain forwards as much of the queue as the link allows.
//
// On ErrUnreachable it stops immediately rather than walking the rest of the
// batch: if the link is down for one operation it is down for all of them, and
// hammering it inflates attempt counters for no reason.
func (f *Forwarder) Drain(ctx context.Context) (DrainResult, error) {
	pending, err := f.queue.Pending(ctx, f.batchSize)
	if err != nil {
		return DrainResult{}, err
	}

	var result DrainResult
	for _, op := range pending {
		forwardErr := f.uplink.Forward(ctx, op)

		switch {
		case forwardErr == nil:
			if err := f.queue.MarkForwarded(ctx, op.ID); err != nil {
				return result, err
			}
			result.Forwarded++

		case errors.Is(forwardErr, ErrUnreachable):
			if err := f.queue.RecordFailure(ctx, op.ID, forwardErr.Error()); err != nil {
				return result, err
			}
			result.Deferred = len(pending) - result.Forwarded - result.Rejected
			return result, nil

		default:
			var rejection PermanentRejection
			if errors.As(forwardErr, &rejection) {
				if err := f.queue.MarkRejected(ctx, op.ID, rejection.Reason); err != nil {
					return result, err
				}
				result.Rejected++

				slog.LogAttrs(ctx, slog.LevelWarn, "edge operation permanently rejected",
					append(obs.SafeAttrs{
						TenantID: op.TenantID,
						Action:   op.Type,
						Outcome:  "rejected",
					}.LogAttrs(), slog.String("reason", rejection.Reason))...)
				continue
			}

			// Unknown transient failure: keep it pending and try again later.
			if err := f.queue.RecordFailure(ctx, op.ID, forwardErr.Error()); err != nil {
				return result, err
			}
			result.Deferred++
		}
	}
	return result, nil
}

// Run drains on an interval until the context is cancelled. A real deployment
// would add jitter so a site-wide reconnection does not stampede the cloud.
func (f *Forwarder) Run(ctx context.Context, interval time.Duration) error {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-ticker.C:
			if _, err := f.Drain(ctx); err != nil {
				slog.LogAttrs(ctx, slog.LevelError, "edge drain failed",
					slog.String("error", err.Error()))
			}
		}
	}
}
