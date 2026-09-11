// Package outbox defines the canonical domain-event envelope.
//
// The envelope shape is fixed by the Domain, Data, API, Event & Security
// Architecture Specification §8.1 and repeated in the Wave-0 spec §7. Events
// are facts in the past tense and are immutable once published.
//
// This package holds no database code: the event is a value, and the
// organization context's Postgres adapter is what commits it inside the same
// transaction as the aggregate write (SRS-API-008).
package outbox

import (
	"encoding/json"
	"errors"
	"time"
)

// Event is one committed fact awaiting publication.
type Event struct {
	EventID       string
	EventType     string
	SchemaVersion int32
	OccurredAt    time.Time
	TenantID      string
	Source        string
	AggregateType string
	AggregateID   string
	CorrelationID string
	CausationID   string
	Actor         string
	Payload       json.RawMessage
}

// ErrInvalidEvent reports an envelope that would be unpublishable or
// untraceable. Rejecting at construction keeps malformed facts out of the
// ledger entirely.
var ErrInvalidEvent = errors.New("outbox: invalid event envelope")

// Validate enforces the mandatory envelope fields. Payload may be empty for
// pure state-transition facts, but identity, tenancy and causality may not.
func (e Event) Validate() error {
	switch {
	case e.EventID == "":
		return errors.Join(ErrInvalidEvent, errors.New("event_id is required"))
	case e.EventType == "":
		return errors.Join(ErrInvalidEvent, errors.New("event_type is required"))
	case e.SchemaVersion <= 0:
		return errors.Join(ErrInvalidEvent, errors.New("schema_version must be positive"))
	case e.OccurredAt.IsZero():
		return errors.Join(ErrInvalidEvent, errors.New("occurred_at is required"))
	case e.TenantID == "":
		return errors.Join(ErrInvalidEvent, errors.New("tenant_id is required"))
	case e.AggregateType == "" || e.AggregateID == "":
		return errors.Join(ErrInvalidEvent, errors.New("aggregate identity is required"))
	case e.CorrelationID == "":
		return errors.Join(ErrInvalidEvent, errors.New("correlation_id is required"))
	}
	return nil
}
