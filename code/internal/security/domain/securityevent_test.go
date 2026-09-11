package domain_test

import (
	"encoding/json"
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/security/domain"
)

var at = time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)

func event(sequence int64) domain.SecurityEvent {
	return domain.SecurityEvent{
		EventID:       "evt-" + string(rune('0'+sequence)),
		TenantID:      "tenant-a",
		Sequence:      sequence,
		Class:         domain.ClassPrivilegeChange,
		Severity:      domain.SeverityHigh,
		ActorID:       "admin-1",
		ResourceType:  "role",
		ResourceID:    "tenant_admin",
		Outcome:       domain.OutcomeSuccess,
		Detail:        json.RawMessage(`{"added":"organization.facility.create"}`),
		CorrelationID: "corr-1",
		OccurredAt:    at.Add(time.Duration(sequence) * time.Minute),
	}
}

// buildChain links n events, each hashing over its predecessor.
func buildChain(t *testing.T, n int) []domain.SecurityEvent {
	t.Helper()

	var chain []domain.SecurityEvent
	previous := ""
	for i := 1; i <= n; i++ {
		linked, err := domain.NewSecurityEvent(event(int64(i)), previous)
		if err != nil {
			t.Fatalf("NewSecurityEvent %d: %v", i, err)
		}
		chain = append(chain, linked)
		previous = linked.EntryHash
	}
	return chain
}

func TestValidChainVerifies(t *testing.T) {
	result := domain.VerifyChain(buildChain(t, 5))
	if !result.Verified {
		t.Fatalf("valid chain failed: %+v", result)
	}
	if result.Length != 5 {
		t.Fatalf("Length = %d", result.Length)
	}
}

func TestFirstEventAnchorsToGenesis(t *testing.T) {
	chain := buildChain(t, 1)
	if chain[0].PreviousHash != domain.GenesisHash {
		t.Fatalf("PreviousHash = %q, want genesis", chain[0].PreviousHash)
	}
}

// The threat this exists for: an operator with database write access editing
// history. Changing any field must invalidate the row's own hash.
func TestEditedEventIsDetected(t *testing.T) {
	chain := buildChain(t, 5)

	// Quietly downgrade a high-severity privilege change.
	chain[2].Severity = domain.SeverityInfo

	result := domain.VerifyChain(chain)
	if result.Verified {
		t.Fatal("an edited event verified")
	}
	if result.Reason != domain.ReasonHashMismatch {
		t.Fatalf("Reason = %q, want %q", result.Reason, domain.ReasonHashMismatch)
	}
	if result.BrokenAtSequence != 3 {
		t.Fatalf("BrokenAtSequence = %d, want 3", result.BrokenAtSequence)
	}
}

// Editing the detail payload — the part an attacker most wants to rewrite — is
// covered by the hash too.
func TestEditedDetailIsDetected(t *testing.T) {
	chain := buildChain(t, 3)
	chain[1].Detail = json.RawMessage(`{"added":"nothing at all"}`)

	if domain.VerifyChain(chain).Verified {
		t.Fatal("an edited detail payload verified")
	}
}

// Deleting a row leaves a sequence gap and a broken link.
func TestDeletedEventIsDetected(t *testing.T) {
	chain := buildChain(t, 5)
	tampered := append(append([]domain.SecurityEvent{}, chain[:2]...), chain[3:]...)

	result := domain.VerifyChain(tampered)
	if result.Verified {
		t.Fatal("a chain with a deleted event verified")
	}
	if result.Reason != domain.ReasonSequenceGap {
		t.Fatalf("Reason = %q", result.Reason)
	}
}

// Reordering breaks the link even though every individual hash is intact.
func TestReorderedEventsAreDetected(t *testing.T) {
	chain := buildChain(t, 4)
	chain[1], chain[2] = chain[2], chain[1]

	if domain.VerifyChain(chain).Verified {
		t.Fatal("a reordered chain verified")
	}
}

// Truncating from the front is why the genesis anchor exists: without it a
// chain starting at any hash would look self-consistent.
func TestTruncatedFrontIsDetected(t *testing.T) {
	chain := buildChain(t, 5)

	// Renumber the survivors so the sequence looks contiguous.
	truncated := chain[2:]
	for i := range truncated {
		truncated[i].Sequence = int64(i + 1)
	}

	result := domain.VerifyChain(truncated)
	if result.Verified {
		t.Fatal("a front-truncated chain verified")
	}
	if result.Reason != domain.ReasonBadGenesis {
		t.Fatalf("Reason = %q, want %q", result.Reason, domain.ReasonBadGenesis)
	}
}

// Splicing in a well-formed event an attacker computed themselves still breaks
// the chain, because they cannot recompute every subsequent hash without the
// whole history.
func TestSplicedEventIsDetected(t *testing.T) {
	chain := buildChain(t, 5)

	forged, err := domain.NewSecurityEvent(event(3), "not-the-real-previous-hash")
	if err != nil {
		t.Fatalf("NewSecurityEvent: %v", err)
	}
	chain[2] = forged

	if domain.VerifyChain(chain).Verified {
		t.Fatal("a spliced event verified")
	}
}

func TestEmptyChainVerifies(t *testing.T) {
	if !domain.VerifyChain(nil).Verified {
		t.Fatal("an empty chain should verify")
	}
}

// The hash must cover every field, or a field it misses is freely editable.
func TestEveryFieldAffectsTheHash(t *testing.T) {
	base, err := domain.NewSecurityEvent(event(1), "")
	if err != nil {
		t.Fatalf("NewSecurityEvent: %v", err)
	}

	mutations := map[string]func(*domain.SecurityEvent){
		"event_id":       func(e *domain.SecurityEvent) { e.EventID = "other" },
		"tenant_id":      func(e *domain.SecurityEvent) { e.TenantID = "tenant-b" },
		"sequence":       func(e *domain.SecurityEvent) { e.Sequence = 99 },
		"class":          func(e *domain.SecurityEvent) { e.Class = domain.ClassBreakGlass },
		"severity":       func(e *domain.SecurityEvent) { e.Severity = domain.SeverityLow },
		"actor_id":       func(e *domain.SecurityEvent) { e.ActorID = "someone-else" },
		"resource_type":  func(e *domain.SecurityEvent) { e.ResourceType = "other" },
		"resource_id":    func(e *domain.SecurityEvent) { e.ResourceID = "other" },
		"outcome":        func(e *domain.SecurityEvent) { e.Outcome = domain.OutcomeDenied },
		"detail":         func(e *domain.SecurityEvent) { e.Detail = json.RawMessage(`{"x":1}`) },
		"correlation_id": func(e *domain.SecurityEvent) { e.CorrelationID = "corr-2" },
		"occurred_at":    func(e *domain.SecurityEvent) { e.OccurredAt = at.Add(time.Hour) },
		"previous_hash":  func(e *domain.SecurityEvent) { e.PreviousHash = domain.GenesisHash[:63] + "1" },
	}

	for name, mutate := range mutations {
		t.Run(name, func(t *testing.T) {
			mutated := base
			mutate(&mutated)
			if domain.ComputeEntryHash(mutated) == base.EntryHash {
				t.Fatalf("changing %s did not change the hash", name)
			}
		})
	}
}

// Length prefixing stops two different field splits producing one hash.
func TestFieldBoundariesCannotBeShifted(t *testing.T) {
	a, _ := domain.NewSecurityEvent(func() domain.SecurityEvent {
		e := event(1)
		e.ResourceType = "ab"
		e.ResourceID = "c"
		return e
	}(), "")

	b, _ := domain.NewSecurityEvent(func() domain.SecurityEvent {
		e := event(1)
		e.ResourceType = "a"
		e.ResourceID = "bc"
		return e
	}(), "")

	if a.EntryHash == b.EntryHash {
		t.Fatal("field boundaries are not distinguished in the hash")
	}
}

func TestMandatoryFieldsRejected(t *testing.T) {
	cases := map[string]func(*domain.SecurityEvent){
		"event_id":       func(e *domain.SecurityEvent) { e.EventID = "" },
		"tenant_id":      func(e *domain.SecurityEvent) { e.TenantID = "" },
		"sequence":       func(e *domain.SecurityEvent) { e.Sequence = 0 },
		"class":          func(e *domain.SecurityEvent) { e.Class = "  " },
		"severity":       func(e *domain.SecurityEvent) { e.Severity = "catastrophic" },
		"outcome":        func(e *domain.SecurityEvent) { e.Outcome = "maybe" },
		"actor_id":       func(e *domain.SecurityEvent) { e.ActorID = "" },
		"correlation_id": func(e *domain.SecurityEvent) { e.CorrelationID = "" },
		"occurred_at":    func(e *domain.SecurityEvent) { e.OccurredAt = time.Time{} },
	}

	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			e := event(1)
			mutate(&e)
			if _, err := domain.NewSecurityEvent(e, ""); !errors.Is(err, domain.ErrInvalidSecurityEvent) {
				t.Fatalf("invalid %s accepted", name)
			}
		})
	}
}

// PostgreSQL rewrites jsonb — reordering keys and changing whitespace — so the
// hash must depend on the document's meaning, not its formatting. Otherwise a
// chain can never verify after a read.
func TestHashSurvivesJSONReformatting(t *testing.T) {
	compact, err := domain.NewSecurityEvent(func() domain.SecurityEvent {
		e := event(1)
		e.Detail = json.RawMessage(`{"added":"x","removed":"y"}`)
		return e
	}(), "")
	if err != nil {
		t.Fatalf("NewSecurityEvent: %v", err)
	}

	// What Postgres gives back: spaces added, keys reordered.
	reformatted := compact
	reformatted.Detail = json.RawMessage(`{"removed": "y", "added": "x"}`)

	if domain.ComputeEntryHash(reformatted) != compact.EntryHash {
		t.Fatal("jsonb reformatting changed the hash; the chain could never verify after a read")
	}
}

// A genuine change to the document must still change the hash.
func TestHashStillDetectsARealDetailChange(t *testing.T) {
	base, _ := domain.NewSecurityEvent(func() domain.SecurityEvent {
		e := event(1)
		e.Detail = json.RawMessage(`{"added":"x"}`)
		return e
	}(), "")

	changed := base
	changed.Detail = json.RawMessage(`{"added":"something else"}`)

	if domain.ComputeEntryHash(changed) == base.EntryHash {
		t.Fatal("a real detail change did not change the hash")
	}
}

// timestamptz keeps microseconds. Hashing nanoseconds would mean the value read
// back never matches the value hashed on write.
func TestHashIsStableAcrossMicrosecondTruncation(t *testing.T) {
	withNanos, err := domain.NewSecurityEvent(func() domain.SecurityEvent {
		e := event(1)
		e.OccurredAt = at.Add(1234 * time.Nanosecond)
		return e
	}(), "")
	if err != nil {
		t.Fatalf("NewSecurityEvent: %v", err)
	}

	truncated := withNanos
	truncated.OccurredAt = withNanos.OccurredAt.Truncate(time.Microsecond)

	if domain.ComputeEntryHash(truncated) != withNanos.EntryHash {
		t.Fatal("microsecond truncation changed the hash")
	}
}

// A millisecond difference is a real difference and must still register.
func TestHashStillDetectsARealTimeChange(t *testing.T) {
	base, _ := domain.NewSecurityEvent(event(1), "")

	moved := base
	moved.OccurredAt = base.OccurredAt.Add(time.Millisecond)

	if domain.ComputeEntryHash(moved) == base.EntryHash {
		t.Fatal("a millisecond shift did not change the hash")
	}
}

// Malformed detail must not be silently replaced with something else.
func TestNonJSONDetailIsPassedThrough(t *testing.T) {
	a := event(1)
	a.Detail = json.RawMessage(`not json at all`)
	linked, err := domain.NewSecurityEvent(a, "")
	if err != nil {
		t.Fatalf("NewSecurityEvent: %v", err)
	}

	b := linked
	b.Detail = json.RawMessage(`also not json`)

	if domain.ComputeEntryHash(b) == linked.EntryHash {
		t.Fatal("different non-JSON details hashed identically")
	}
}
