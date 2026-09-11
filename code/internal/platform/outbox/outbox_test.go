package outbox_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/outbox"
)

func valid() outbox.Event {
	return outbox.Event{
		EventID:       "evt-1",
		EventType:     "organization.facility_created",
		SchemaVersion: 1,
		OccurredAt:    time.Now().UTC(),
		TenantID:      "tenant-a",
		Source:        "organization",
		AggregateType: "facility",
		AggregateID:   "facility-1",
		CorrelationID: "corr-1",
	}
}

func TestValidEnvelopePasses(t *testing.T) {
	if err := valid().Validate(); err != nil {
		t.Fatalf("valid envelope rejected: %v", err)
	}
}

// Each mandatory field is checked individually so a regression names the field
// it broke rather than just "invalid".
func TestMandatoryFieldsRejected(t *testing.T) {
	cases := map[string]func(*outbox.Event){
		"event_id":       func(e *outbox.Event) { e.EventID = "" },
		"event_type":     func(e *outbox.Event) { e.EventType = "" },
		"schema_version": func(e *outbox.Event) { e.SchemaVersion = 0 },
		"occurred_at":    func(e *outbox.Event) { e.OccurredAt = time.Time{} },
		"tenant_id":      func(e *outbox.Event) { e.TenantID = "" },
		"aggregate_id":   func(e *outbox.Event) { e.AggregateID = "" },
		"aggregate_type": func(e *outbox.Event) { e.AggregateType = "" },
		"correlation_id": func(e *outbox.Event) { e.CorrelationID = "" },
	}
	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			e := valid()
			mutate(&e)
			if err := e.Validate(); !errors.Is(err, outbox.ErrInvalidEvent) {
				t.Fatalf("missing %s accepted", name)
			}
		})
	}
}

// An empty payload is legitimate for a pure state transition.
func TestEmptyPayloadAllowed(t *testing.T) {
	e := valid()
	e.Payload = nil
	if err := e.Validate(); err != nil {
		t.Fatalf("empty payload rejected: %v", err)
	}
}
