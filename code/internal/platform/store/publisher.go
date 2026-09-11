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

// PendingCount reports the outbox backlog. This is a domain SLI, not a
// CPU metric: a rising backlog means facts are not reaching consumers
// (SRS-NFR-006).
func (p *Publisher) PendingCount(ctx context.Context) (int64, error) {
	return p.store.queries(ctx).CountUnpublishedEvents(ctx)
}

func strPtr(s string) *string { return &s }
