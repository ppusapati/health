package store_test

import (
	"context"
	"encoding/json"
	"fmt"
	"sort"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/eventbus"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/store"
)

// ADR-005 evidence.
//
// The decision to run event delivery on PostgreSQL rather than on a dedicated
// broker is only defensible with a number attached, and the number that
// matters is not "how fast is PostgreSQL" — it is "at what point does this
// deployment's event rate stop fitting". These benchmarks measure the three
// costs that set that ceiling:
//
//   - fan-out, paid inside the publisher's transaction, which is the one that
//     makes writes slower as subscriptions are added;
//   - claim-and-acknowledge, which sets how fast a consumer can drain;
//   - end-to-end publish-to-handled latency, which is what an operator
//     notices.
//
// They are benchmarks rather than assertions on purpose. A throughput
// threshold asserted in CI measures the CI runner, and would either fail on a
// noisy afternoon or be set so low it proves nothing. The recorded numbers
// live in docs/adr/0005-event-broker.md next to the conditions they were taken
// under; re-running this file is how that record is refreshed.

func newBenchFixture(b *testing.B) busFixture {
	b.Helper()
	pool := pgtest.New(b)
	tx := pgtx.NewManager(pool)
	tenant := uuid.NewString()
	return busFixture{store: store.New(tx), tx: tx, pool: pool, tenant: tenant}
}

func (f busFixture) event(eventType string) outbox.Event {
	return outbox.Event{
		EventID: uuid.NewString(), EventType: eventType, SchemaVersion: 1,
		OccurredAt: time.Now().UTC(), TenantID: f.tenant, Source: "bench",
		AggregateType: "thing", AggregateID: uuid.NewString(),
		CorrelationID: uuid.NewString(), Actor: "sys",
		// A realistic body rather than an empty one: fan-out copies nothing,
		// but the outbox insert and every delivery read carry it, and a 2-byte
		// payload would flatter both.
		Payload: json.RawMessage(`{"facility_id":"` + uuid.NewString() +
			`","name":"Ward 4B","status":"active","effective_from":"2026-09-11T10:00:00Z"}`),
	}
}

// BenchmarkFanOut measures the cost the publisher pays per event, which grows
// with the number of subscriptions because every one gets its own row.
//
// This is the number that decides whether adding a consumer is free. On a
// network broker it is: the broker copies. Here the publisher does, inside the
// transaction that is holding the aggregate's locks.
func BenchmarkFanOut(b *testing.B) {
	for _, subs := range []int{1, 4, 16} {
		b.Run(fmt.Sprintf("subscriptions=%d", subs), func(b *testing.B) {
			f := newBenchFixture(b)
			ctx := context.Background()

			for i := range subs {
				if _, err := f.store.EnsureSubscription(ctx, eventbus.Subscription{
					Consumer: fmt.Sprintf("consumer-%d", i),
				}.WithDefaults()); err != nil {
					b.Fatalf("subscribe: %v", err)
				}
			}

			b.ResetTimer()
			for b.Loop() {
				e := f.event("organization.facility_created")
				err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
					if err := f.store.Append(ctx, e); err != nil {
						return err
					}
					_, err := f.store.FanOut(ctx, e, time.Now().UTC())
					return err
				})
				if err != nil {
					b.Fatalf("publish: %v", err)
				}
			}
			b.ReportMetric(float64(subs), "deliveries/op")
		})
	}
}

// BenchmarkClaimAck measures consumer drain throughput: one claim of a batch,
// then an acknowledgement per delivery.
//
// Reported per delivery rather than per batch, because that is the unit an
// event rate is quoted in.
func BenchmarkClaimAck(b *testing.B) {
	for _, batch := range []int32{1, 50} {
		b.Run(fmt.Sprintf("batch=%d", batch), func(b *testing.B) {
			f := newBenchFixture(b)
			ctx := context.Background()

			id, err := f.store.EnsureSubscription(ctx,
				eventbus.Subscription{Consumer: "drainer"}.WithDefaults())
			if err != nil {
				b.Fatalf("subscribe: %v", err)
			}

			// Seed enough deliveries that the benchmark never runs dry: b.N is
			// unknown until the loop runs, so seed lazily in chunks instead.
			seeded := 0
			seed := func(n int) {
				if err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
					for range n {
						e := f.event("organization.facility_created")
						if err := f.store.Append(ctx, e); err != nil {
							return err
						}
						if _, err := f.store.FanOut(ctx, e, time.Now().UTC()); err != nil {
							return err
						}
					}
					return nil
				}); err != nil {
					b.Fatalf("seed: %v", err)
				}
				seeded += n
			}

			const chunk = 500
			seed(chunk)

			handled := 0
			b.ResetTimer()
			for b.Loop() {
				if handled >= seeded {
					b.StopTimer()
					seed(chunk)
					b.StartTimer()
				}

				deliveries, err := f.store.Claim(ctx, id, "bench", batch, 30*time.Second, time.Now().UTC())
				if err != nil {
					b.Fatalf("claim: %v", err)
				}
				for _, d := range deliveries {
					if err := f.store.Ack(ctx, d.ID, time.Now().UTC()); err != nil {
						b.Fatalf("ack: %v", err)
					}
				}
				handled += len(deliveries)
			}
		})
	}
}

// BenchmarkEndToEndLatency measures publish-to-handled with a live worker,
// and reports the distribution rather than only the mean.
//
// The mean hides the thing an operator cares about. A bus whose mean is 3ms
// and whose p99 is two seconds is a bus where one request in a hundred looks
// broken, and the poll interval makes exactly that shape possible: a missed
// notification costs a full tick. So p95 and p99 are reported alongside.
func BenchmarkEndToEndLatency(b *testing.B) {
	f := newBenchFixture(b)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	var (
		mu        sync.Mutex
		latencies []time.Duration
		sent      = make(map[string]time.Time)
		done      = make(chan struct{}, 1<<16)
	)

	handler := func(_ context.Context, d eventbus.Delivery) error {
		at := time.Now()
		mu.Lock()
		if start, ok := sent[d.EventID]; ok {
			latencies = append(latencies, at.Sub(start))
		}
		mu.Unlock()
		done <- struct{}{}
		return nil
	}

	sub := eventbus.Subscription{Consumer: "latency-probe"}

	// Register before the first publish. The worker registers itself on Run,
	// but that is concurrent with the loop below, and an event published
	// before the subscription exists is correctly delivered to nobody — which
	// would make this benchmark measure a race rather than a latency.
	if _, err := f.store.EnsureSubscription(ctx, sub.WithDefaults()); err != nil {
		b.Fatalf("subscribe: %v", err)
	}

	worker, err := eventbus.NewWorker(f.store, sub, handler,
		eventbus.Options{BatchSize: 50, PollInterval: 20 * time.Millisecond})
	if err != nil {
		b.Fatalf("worker: %v", err)
	}

	broker := store.NewPgBroker(f.store, func(string) { worker.Notify() }, nil)
	publisher := store.NewPublisher(f.store, broker, 100)

	workerDone := make(chan struct{})
	go func() { defer close(workerDone); _ = worker.Run(ctx) }()

	b.ResetTimer()
	for b.Loop() {
		e := f.event("organization.facility_created")

		mu.Lock()
		sent[e.EventID] = time.Now()
		mu.Unlock()

		if err := f.tx.WithinTx(ctx, func(ctx context.Context) error {
			return f.store.Append(ctx, e)
		}); err != nil {
			b.Fatalf("append: %v", err)
		}
		if _, err := publisher.PublishBatch(ctx, time.Now().UTC()); err != nil {
			b.Fatalf("publish: %v", err)
		}

		select {
		case <-done:
		case <-time.After(30 * time.Second):
			b.Fatal("event was never handled")
		}
	}
	b.StopTimer()

	cancel()
	<-workerDone

	mu.Lock()
	defer mu.Unlock()
	if len(latencies) == 0 {
		return
	}
	sort.Slice(latencies, func(i, j int) bool { return latencies[i] < latencies[j] })
	pick := func(q float64) float64 {
		idx := int(q * float64(len(latencies)-1))
		return float64(latencies[idx].Microseconds())
	}
	b.ReportMetric(pick(0.50), "p50-us")
	b.ReportMetric(pick(0.95), "p95-us")
	b.ReportMetric(pick(0.99), "p99-us")
}
