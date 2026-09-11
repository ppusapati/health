package audit_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
)

func valid() audit.Record {
	return audit.Record{
		AuditID:       "aud-1",
		TenantID:      "tenant-a",
		ActorID:       "user-1",
		Action:        "organization.facility.create",
		ResourceType:  "facility",
		ResourceID:    "facility-1",
		Outcome:       audit.OutcomeSuccess,
		CorrelationID: "corr-1",
		OccurredAt:    time.Now().UTC(),
	}
}

func TestValidRecordPasses(t *testing.T) {
	if err := valid().Validate(); err != nil {
		t.Fatalf("valid record rejected: %v", err)
	}
}

func TestMandatoryFieldsRejected(t *testing.T) {
	cases := map[string]func(*audit.Record){
		"audit_id":       func(r *audit.Record) { r.AuditID = "" },
		"tenant_id":      func(r *audit.Record) { r.TenantID = "" },
		"actor_id":       func(r *audit.Record) { r.ActorID = "" },
		"action":         func(r *audit.Record) { r.Action = "" },
		"outcome":        func(r *audit.Record) { r.Outcome = "" },
		"correlation_id": func(r *audit.Record) { r.CorrelationID = "" },
		"occurred_at":    func(r *audit.Record) { r.OccurredAt = time.Time{} },
	}
	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			r := valid()
			mutate(&r)
			if err := r.Validate(); !errors.Is(err, audit.ErrInvalidRecord) {
				t.Fatalf("missing %s accepted", name)
			}
		})
	}
}

// A denial is an auditable event in its own right, so a record with no
// resource ID and a denied outcome must still validate.
func TestDeniedAttemptIsAuditable(t *testing.T) {
	r := valid()
	r.Outcome = audit.OutcomeDenied
	r.Reason = "CROSS_TENANT_DENIED"
	r.ResourceID = ""
	if err := r.Validate(); err != nil {
		t.Fatalf("denied record rejected: %v", err)
	}
}
