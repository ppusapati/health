package store

import (
	"context"
	"encoding/json"
	"log/slog"
	"time"

	"github.com/ppusapati/health/code/internal/platform/obs"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Broker is the transport the publisher hands events to.
//
// ADR-005 (Kafka-compatible vs NATS JetStream) is still open and blocking, so
// the domain contract is deliberately broker-neutral: nothing above this
// interface knows which product won the benchmark.
type Broker interface {
	Publish(ctx context.Context, e outbox.Event) error
}

// Publisher drains the transactional outbox.
//
// Delivery is at-least-once by design. The publisher may crash between the
// broker acknowledging an event and the row being marked published, so the same
// event can be delivered twice; every side-effecting consumer deduplicates with
// TryConsume (Domain/Data spec §8.2).
type Publisher struct {
	store     *Store
	broker    Broker
	batchSize int32
}

// DefaultBatchSize bounds one drain cycle so a large backlog is worked through
// in steady increments rather than one long transaction.
const DefaultBatchSize = 100

// NewPublisher constructs a Publisher.
func NewPublisher(store *Store, broker Broker, batchSize int32) *Publisher {
	if batchSize <= 0 {
		batchSize = DefaultBatchSize
	}
	return &Publisher{store: store, broker: broker, batchSize: batchSize}
}

// PublishBatch claims and publishes up to batchSize unpublished events and
// returns how many were published.
//
// The claim runs inside a transaction using FOR UPDATE SKIP LOCKED, so several
// publisher replicas can drain concurrently without double-claiming a row and
// without blocking one another.
func (p *Publisher) PublishBatch(ctx context.Context, now time.Time) (int, error) {
	published := 0

	err := p.store.tx.WithinTx(ctx, func(ctx context.Context) error {
		q := p.store.queries(ctx)

		rows, err := q.ClaimUnpublishedEvents(ctx, p.batchSize)
		if err != nil {
			return err
		}

		for _, row := range rows {
			event := outbox.Event{
				EventID:       row.EventID.String(),
				EventType:     row.EventType,
				SchemaVersion: row.SchemaVersion,
				OccurredAt:    row.OccurredAt.Time,
				TenantID:      row.TenantID.String(),
				Source:        row.Source,
				AggregateType: row.AggregateType,
				AggregateID:   row.AggregateID,
				CorrelationID: row.CorrelationID,
				CausationID:   row.CausationID,
				Actor:         row.Actor,
				Payload:       json.RawMessage(row.Payload),
			}

			if err := p.broker.Publish(ctx, event); err != nil {
				// One bad event must not stall the rest of the batch: record
				// the failure, leave the row unpublished, and move on. It is
				// retried on the next cycle.
				slog.LogAttrs(ctx, slog.LevelError, "outbox publish failed",
					append(obs.SafeAttrs{
						TenantID:      event.TenantID,
						CorrelationID: event.CorrelationID,
						Action:        event.EventType,
						Outcome:       "failure",
					}.LogAttrs(), slog.String("error", err.Error()))...)

				if recErr := q.RecordPublishFailure(ctx, sqlcgen.RecordPublishFailureParams{
					EventID:   row.EventID,
					LastError: strPtr(err.Error()),
				}); recErr != nil {
					return recErr
				}
				continue
			}

			if err := q.MarkEventPublished(ctx, sqlcgen.MarkEventPublishedParams{
				EventID:     row.EventID,
				PublishedAt: timestamptz(now),
			}); err != nil {
				return err
			}
			published++
		}
		return nil
	})

	return published, err
}

// DefaultPublishInterval is the ceiling on publish latency when nothing
// prompts a drain. The publisher is not notified — it is the thing doing the
// notifying — so this is a real poll, and the interval is the delay between an
// aggregate committing and its event reaching a consumer.
const DefaultPublishInterval = 250 * time.Millisecond

// Run drains the outbox until the context is cancelled.
//
// Drains to empty before waiting again, for the same reason the consumer
// workers do: one batch per tick would make a burst of 10,000 events take
// 100 ticks to clear, so the backlog would still be draining long after the
// load that caused it had gone.
//
// A failed cycle is logged and retried on the next tick rather than returned.
// The outbox is durable, so nothing is lost by waiting, and a publisher that
// exits on the first transient database error takes the events with it.
func (p *Publisher) Run(ctx context.Context, interval time.Duration) error {
	if interval <= 0 {
		interval = DefaultPublishInterval
	}

	ticker := time.NewTicker(interval)
	defer ticker.Stop()

	for {
		for {
			published, err := p.PublishBatch(ctx, time.Now().UTC())
			if err != nil {
				if ctx.Err() != nil {
					return ctx.Err()
				}
				slog.ErrorContext(ctx, "outbox drain failed", slog.String("error", err.Error()))
				break
			}
			// A short batch means the backlog is clear. Looping again would
			// be a wasted query per cycle.
			if published < int(p.batchSize) {
				break
			}
		}

		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-ticker.C:
		}
	}
}

// PendingCount reports the outbox backlog. This is a domain SLI, not a
// CPU metric: a rising backlog means facts are not reaching consumers
// (SRS-NFR-006).
func (p *Publisher) PendingCount(ctx context.Context) (int64, error) {
	return p.store.queries(ctx).CountUnpublishedEvents(ctx)
}

func strPtr(s string) *string { return &s }
