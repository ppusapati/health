// Package domain holds the security platform's aggregates and invariants.
//
// Trace: SRS-SEC-008, SRS-SEC-009, SRS-SEC-010, SRS-SEC-012, SRS-DAT-009.
package domain

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Severity of a security event.
type Severity string

const (
	SeverityInfo     Severity = "info"
	SeverityLow      Severity = "low"
	SeverityMedium   Severity = "medium"
	SeverityHigh     Severity = "high"
	SeverityCritical Severity = "critical"
)

var validSeverities = map[Severity]bool{
	SeverityInfo: true, SeverityLow: true, SeverityMedium: true,
	SeverityHigh: true, SeverityCritical: true,
}

// Outcome of the attempted action.
type Outcome string

const (
	OutcomeSuccess Outcome = "success"
	OutcomeDenied  Outcome = "denied"
	OutcomeFailure Outcome = "failure"
)

var validOutcomes = map[Outcome]bool{
	OutcomeSuccess: true, OutcomeDenied: true, OutcomeFailure: true,
}

// Event classes that must always be recorded (SRS-SEC-012, SRS-IAM-008).
const (
	ClassPrivilegeChange     = "privilege.changed"
	ClassBreakGlass          = "access.break_glass"
	ClassStepUp              = "auth.step_up"
	ClassBulkExport          = "data.bulk_export"
	ClassExportDownload      = "data.export_download"
	ClassLegalHold           = "data.legal_hold"
	ClassRetentionChange     = "data.retention_changed"
	ClassSubjectRequest      = "privacy.subject_request"
	ClassAuthFailure         = "auth.failed"
	ClassSessionRevoked      = "auth.session_revoked"
	ClassConfigurationChange = "config.changed"
)

// GenesisHash anchors the start of a tenant's chain. A chain that begins at an
// arbitrary value could be truncated from the front without detection.
const GenesisHash = "0000000000000000000000000000000000000000000000000000000000000000"

// SecurityEvent is one link in a tenant's tamper-evident chain.
//
// An ordinary audit table records what happened; it does not detect an operator
// with database write access editing history. Chaining each row's hash to its
// predecessor means any edit, deletion or reordering invalidates every
// subsequent hash, which a verification pass detects.
type SecurityEvent struct {
	EventID       string
	TenantID      string
	Sequence      int64
	Class         string
	Severity      Severity
	ActorID       string
	ResourceType  string
	ResourceID    string
	Outcome       Outcome
	Detail        json.RawMessage
	CorrelationID string
	OccurredAt    time.Time

	EntryHash    string
	PreviousHash string
}

// ErrInvalidSecurityEvent reports an event that would not be reviewable.
var ErrInvalidSecurityEvent = errors.New("security: invalid security event")

// NewSecurityEvent builds the next link in the chain and computes its hash.
func NewSecurityEvent(e SecurityEvent, previousHash string) (SecurityEvent, error) {
	switch {
	case e.EventID == "":
		return SecurityEvent{}, fmt.Errorf("%w: event_id is required", ErrInvalidSecurityEvent)
	case e.TenantID == "":
		return SecurityEvent{}, fmt.Errorf("%w: tenant_id is required", ErrInvalidSecurityEvent)
	case e.Sequence <= 0:
		return SecurityEvent{}, fmt.Errorf("%w: sequence must be positive", ErrInvalidSecurityEvent)
	case strings.TrimSpace(e.Class) == "":
		return SecurityEvent{}, fmt.Errorf("%w: class is required", ErrInvalidSecurityEvent)
	case !validSeverities[e.Severity]:
		return SecurityEvent{}, fmt.Errorf("%w: unknown severity %q", ErrInvalidSecurityEvent, e.Severity)
	case !validOutcomes[e.Outcome]:
		return SecurityEvent{}, fmt.Errorf("%w: unknown outcome %q", ErrInvalidSecurityEvent, e.Outcome)
	case e.ActorID == "":
		return SecurityEvent{}, fmt.Errorf("%w: actor_id is required", ErrInvalidSecurityEvent)
	case e.CorrelationID == "":
		return SecurityEvent{}, fmt.Errorf("%w: correlation_id is required", ErrInvalidSecurityEvent)
	case e.OccurredAt.IsZero():
		return SecurityEvent{}, fmt.Errorf("%w: occurred_at is required", ErrInvalidSecurityEvent)
	}

	if previousHash == "" {
		previousHash = GenesisHash
	}
	if len(e.Detail) == 0 {
		e.Detail = json.RawMessage(`{}`)
	}

	e.PreviousHash = previousHash
	e.EntryHash = ComputeEntryHash(e)
	return e, nil
}

// canonicalJSON normalises a JSON document so the hash survives storage.
//
// PostgreSQL rewrites jsonb: it reorders keys and changes whitespace. Hashing
// the raw bytes would therefore produce a chain that can never verify after a
// read — the value that comes back is not the value that went in. Canonicalising
// on both sides makes the hash depend on the document's meaning rather than its
// formatting.
//
// Input that is not valid JSON is passed through unchanged: it cannot be
// normalised, and silently substituting something else would be worse.
func canonicalJSON(raw json.RawMessage) string {
	if len(raw) == 0 {
		return "{}"
	}

	var parsed any
	if err := json.Unmarshal(raw, &parsed); err != nil {
		return string(raw)
	}
	// encoding/json sorts map keys, so this is deterministic.
	normalised, err := json.Marshal(parsed)
	if err != nil {
		return string(raw)
	}
	return string(normalised)
}

// canonicalTime normalises an instant to the precision the database keeps.
//
// timestamptz stores microseconds. Hashing nanoseconds would mean the value
// read back never matches the value hashed on write.
func canonicalTime(t time.Time) string {
	return t.UTC().Truncate(time.Microsecond).Format(time.RFC3339Nano)
}

// ComputeEntryHash produces the canonical hash of an event.
//
// The serialisation is explicit and field-ordered rather than JSON marshalling
// of a struct: a field reordering or an added field would otherwise silently
// change every historical hash and make the whole chain unverifiable.
func ComputeEntryHash(e SecurityEvent) string {
	h := sha256.New()
	for _, part := range []string{
		e.PreviousHash,
		e.EventID,
		e.TenantID,
		fmt.Sprintf("%d", e.Sequence),
		e.Class,
		string(e.Severity),
		e.ActorID,
		e.ResourceType,
		e.ResourceID,
		string(e.Outcome),
		canonicalJSON(e.Detail),
		e.CorrelationID,
		canonicalTime(e.OccurredAt),
	} {
		// The length prefix stops two different field splits from producing the
		// same concatenation — "ab"+"c" and "a"+"bc" must not collide.
		fmt.Fprintf(h, "%d:%s|", len(part), part)
	}
	return hex.EncodeToString(h.Sum(nil))
}

// ChainVerification reports the result of verifying a tenant's chain.
type ChainVerification struct {
	Verified bool
	// Length is how many events were checked.
	Length int
	// BrokenAtSequence is the first event whose hash does not reconcile.
	BrokenAtSequence int64
	Reason           string
}

// Stable failure reasons.
const (
	ReasonHashMismatch = "ENTRY_HASH_MISMATCH"
	ReasonChainBroken  = "PREVIOUS_HASH_MISMATCH"
	ReasonSequenceGap  = "SEQUENCE_GAP"
	ReasonBadGenesis   = "GENESIS_HASH_MISMATCH"
)

// VerifyChain walks a tenant's events in order and checks every link.
//
// Three distinct tampering shapes are detected: an edited row (its own hash no
// longer matches its contents), a deleted row (the sequence gaps and the next
// row's previous_hash no longer matches), and a reordered or spliced row (the
// chain link breaks).
func VerifyChain(events []SecurityEvent) ChainVerification {
	result := ChainVerification{Verified: true, Length: len(events)}

	expectedPrevious := GenesisHash
	var expectedSequence int64 = 1

	for _, e := range events {
		if e.Sequence != expectedSequence {
			return ChainVerification{
				Length: len(events), BrokenAtSequence: e.Sequence, Reason: ReasonSequenceGap,
			}
		}
		if e.PreviousHash != expectedPrevious {
			reason := ReasonChainBroken
			if expectedSequence == 1 {
				reason = ReasonBadGenesis
			}
			return ChainVerification{
				Length: len(events), BrokenAtSequence: e.Sequence, Reason: reason,
			}
		}
		if ComputeEntryHash(e) != e.EntryHash {
			return ChainVerification{
				Length: len(events), BrokenAtSequence: e.Sequence, Reason: ReasonHashMismatch,
			}
		}

		expectedPrevious = e.EntryHash
		expectedSequence++
	}
	return result
}
