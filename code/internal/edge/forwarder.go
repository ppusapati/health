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
	// retention is how long an acknowledged operation's payload stays on the
	// ward machine. See Queue.Purge.
	retention time.Duration
	now       func() time.Time
}

// DefaultBatchSize is the default drain size.
const DefaultBatchSize = 50

// NewForwarder constructs a Forwarder.
func NewForwarder(queue *Queue, uplink Uplink, batchSize int) *Forwarder {
	if batchSize <= 0 {
		batchSize = DefaultBatchSize
	}
	return &Forwarder{
		queue: queue, uplink: uplink, batchSize: batchSize,
		retention: DefaultRetention,
		now:       func() time.Time { return time.Now().UTC() },
	}
}

// WithRetention overrides how long acknowledged operations are kept locally.
//
// A site with a regulatory reason to keep more, or a node in a less physically
// secure place that should keep less, sets it here. Zero or negative disables
// purging, which is a deliberate choice a deployment has to make rather than a
// default it can drift into.
func (f *Forwarder) WithRetention(d time.Duration) *Forwarder {
	f.retention = d
	return f
}

// WithClock injects time, so a retention test need not sleep.
func (f *Forwarder) WithClock(now func() time.Time) *Forwarder {
	if now != nil {
		f.now = now
	}
	return f
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
			if err := f.queue.MarkForwarded(ctx, op.ID, f.now()); err != nil {
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

// PurgeExpired removes acknowledged operations past the retention window.
//
// Deleting a payload the cloud already holds is not data loss; leaving it is
// exposure. The edge box is the least physically protected thing in the
// deployment and its queue is not encrypted at rest.
func (f *Forwarder) PurgeExpired(ctx context.Context) error {
	if f.retention <= 0 {
		return nil
	}
	removed, err := f.queue.Purge(ctx, f.now().Add(-f.retention))
	if err != nil {
		return err
	}
	if removed > 0 {
		slog.LogAttrs(ctx, slog.LevelInfo, "edge retention sweep",
			slog.Int64("removed", removed))
	}
	return nil
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
			// Retention runs on the same tick as the drain rather than on its
			// own schedule: the rows it removes are the ones the drain just
			// acknowledged, and a separate timer is one more thing that can be
			// left unstarted.
			if err := f.PurgeExpired(ctx); err != nil {
				slog.LogAttrs(ctx, slog.LevelError, "edge retention sweep failed",
					slog.String("error", err.Error()))
			}
		}
	}
}
