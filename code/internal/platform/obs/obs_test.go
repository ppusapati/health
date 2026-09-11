package obs_test

import (
	"log/slog"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/obs"
)

func TestSafeAttrsOmitsEmptyValues(t *testing.T) {
	attrs := obs.SafeAttrs{TenantID: "tenant-a", Action: "create"}.LogAttrs()
	if len(attrs) != 2 {
		t.Fatalf("got %d attrs, want 2: %v", len(attrs), attrs)
	}
}

// The allowlist is the PHI control (FIT-06): it must expose identifiers only,
// so any future field addition has to be a deliberate edit here.
func TestSafeAttrsExposesOnlyIdentifiers(t *testing.T) {
	allowed := map[string]bool{
		"tenant_id": true, "subject_id": true, "correlation_id": true,
		"request_id": true, "action": true, "outcome": true,
	}
	full := obs.SafeAttrs{
		TenantID: "t", SubjectID: "s", CorrelationID: "c",
		RequestID: "r", Action: "a", Outcome: "o",
	}
	for _, a := range full.LogAttrs() {
		if !allowed[a.Key] {
			t.Fatalf("unexpected key %q in safe log attrs", a.Key)
		}
		if a.Value.Kind() != slog.KindString {
			t.Fatalf("key %q is not a plain string; structured values risk payload leakage", a.Key)
		}
	}
}

func TestSpanAttrsUseDottedNames(t *testing.T) {
	attrs := obs.SafeAttrs{TenantID: "tenant-a"}.SpanAttrs()
	if len(attrs) != 1 || string(attrs[0].Key) != "tenant.id" {
		t.Fatalf("unexpected span attrs: %v", attrs)
	}
}
