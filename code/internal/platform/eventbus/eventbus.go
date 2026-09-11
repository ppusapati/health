// Package eventbus delivers committed events to consumers (ADR-005).
//
// The outbox guarantees no state change without its event. This package is the
// other half: getting each event to everyone who needs it, exactly the number
// of times they can cope with, and doing something sensible when one of them
// cannot cope at all.
//
// Delivery is at-least-once, not exactly-once. Exactly-once across a process
// boundary requires the consumer's side effect and the acknowledgement to
// commit together, which is only possible when the side effect is in the same
// database — and most are not. So the contract is: a consumer may see a message
// more than once, and must be idempotent. Every consumer in this system
// deduplicates on the event id through the inbox.
//
// Ordering is per aggregate, not global. Deliveries are claimed in
// occurred_at order, but several consumer replicas drain concurrently, so two
// events for different aggregates can be processed out of order. A consumer
// that needs strict ordering for one aggregate gets it from the version on the
// event rather than from the transport — which is the honest place for it,
// because no transport preserves order through a retry.
package eventbus

import (
	"context"
	"errors"
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// Delivery is one event handed to one consumer.
type Delivery struct {
	ID       string
	EventID  string
	TenantID string
	Type     string
	// Attempt is 1 on first delivery. A handler that behaves differently on a
	// retry — skipping a notification it may already have sent, say — needs
	// this, and it is the only signal that distinguishes a redelivery from a
	// first sight.
	Attempt    int
	OccurredAt time.Time
	Event      outbox.Event
}

// Handler processes one delivery.
//
// Returning nil acknowledges. Returning an error schedules a retry, and enough
// errors dead-letter the message. A handler that panics is treated as a
// failure rather than taking the worker down: one poison message must not stop
// a consumer, and the dead-letter queue is where it ends up.
type Handler func(ctx context.Context, d Delivery) error

// Subscription describes what a consumer wants.
type Subscription struct {
	// Consumer names the group. Two processes sharing a name share the work;
	// two names each get a copy.
	Consumer string
	// EventTypes filters. Empty means everything — right for a projection
	// rebuilding an index, wrong for a targeted consumer, so it is explicit
	// rather than defaulted.
	EventTypes []string
	// TenantID scopes the subscription to one tenant. Empty means all.
	TenantID string
	// MaxAttempts before dead-lettering.
	MaxAttempts int
}

// Store is the persistence the bus needs.
type Store interface {
	EnsureSubscription(ctx context.Context, s Subscription) (subscriptionID string, err error)
	Claim(ctx context.Context, subscriptionID, workerID string, batchSize int32,
		lease time.Duration, now time.Time) ([]Delivery, error)
	Ack(ctx context.Context, deliveryID string, now time.Time) error
	Nack(ctx context.Context, deliveryID, reason string, retryAt, now time.Time) error
	PendingCount(ctx context.Context, subscriptionID string) (int64, error)
}

// Errors returned by this package.
var (
	// ErrInvalidSubscription reports a subscription that cannot be registered.
	ErrInvalidSubscription = errors.New("eventbus: invalid subscription")
	// ErrHandlerPanicked reports a handler that panicked. Surfaced as an
	// ordinary delivery failure so the message retries and eventually
	// dead-letters, rather than taking the worker process with it.
	ErrHandlerPanicked = errors.New("eventbus: handler panicked")
)

// Retry and lease tuning.
const (
	// DefaultMaxAttempts before a message is dead-lettered.
	DefaultMaxAttempts = 5
	// BaseRetryDelay is the first backoff step.
	BaseRetryDelay = time.Second
	// MaxRetryDelay caps exponential growth. Five minutes, because a consumer
	// that has failed five times is waiting on something a human will fix, and
	// backing off to an hour only delays the recovery once they do.
	MaxRetryDelay = 5 * time.Minute
	// DefaultLease is how long a claim is held before another worker may take
	// it. Long enough for a slow handler, short enough that a crashed worker's
	// messages are not stranded for minutes.
	DefaultLease = 30 * time.Second
	// DefaultBatchSize per claim.
	DefaultBatchSize = 50
	// DefaultPollInterval when nothing wakes the worker. Only the ceiling on
	// latency when a notification is missed — the notify path is what makes
	// steady-state latency short.
	DefaultPollInterval = time.Second
)

// RetryDelay computes the backoff for an attempt.
//
// Exponential with a cap, and deterministic. Jitter belongs at the caller
// rather than here so a test can assert the schedule; the worker applies it
// when scheduling, which is where a thundering herd would actually form.
func RetryDelay(attempt int) time.Duration {
	if attempt < 1 {
		attempt = 1
	}
	// Guard the shift before it happens: 1<<62 nanoseconds already exceeds any
	// sane delay, and beyond that the arithmetic wraps negative and a failed
	// message becomes immediately visible forever.
	if attempt > 20 {
		return MaxRetryDelay
	}
	delay := time.Duration(math.Pow(2, float64(attempt-1))) * BaseRetryDelay
	if delay > MaxRetryDelay || delay <= 0 {
		return MaxRetryDelay
	}
	return delay
}

// Validate refuses a subscription that would misbehave.
func (s Subscription) Validate() error {
	switch {
	case strings.TrimSpace(s.Consumer) == "":
		return fmt.Errorf("%w: a consumer name is required", ErrInvalidSubscription)
	case strings.ContainsAny(s.Consumer, " \t\n"):
		// The consumer name is a channel identifier and appears in operational
		// tooling; whitespace in it produces names nobody can type.
		return fmt.Errorf("%w: consumer name must not contain whitespace", ErrInvalidSubscription)
	case s.MaxAttempts < 0:
		return fmt.Errorf("%w: max attempts cannot be negative", ErrInvalidSubscription)
	}
	for _, t := range s.EventTypes {
		if strings.TrimSpace(t) == "" {
			// An empty string in the list would be a filter that matches
			// nothing while looking like a filter that matches something.
			return fmt.Errorf("%w: an empty event type is not a filter", ErrInvalidSubscription)
		}
	}
	return nil
}

// WithDefaults fills in what the caller left unset.
func (s Subscription) WithDefaults() Subscription {
	if s.MaxAttempts == 0 {
		s.MaxAttempts = DefaultMaxAttempts
	}
	if s.EventTypes == nil {
		// Empty rather than nil. A nil slice becomes SQL NULL, and the column
		// is NOT NULL because NULL would be a third state — neither "all
		// types" nor a filter — that every reader would have to interpret.
		s.EventTypes = []string{}
	}
	return s
}
