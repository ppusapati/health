// Package audit defines the append-only audit record.
//
// Audit is a regulated record, not a debug log (Domain/Data spec §12). Records
// are written inside the same transaction as the change they describe, so an
// applied change can never lack its audit entry.
//
// Trace: SRS-SEC-004, SRS-IAM-008, SRS-PLT-018, SRS-NFR-011.
package audit

import (
	"encoding/json"
	"errors"
	"time"
)

// Outcome records whether the attempted action succeeded. Denied attempts are
// audited too: a failed cross-tenant read is exactly what a reviewer needs.
type Outcome string

const (
	OutcomeSuccess Outcome = "success"
	OutcomeDenied  Outcome = "denied"
	OutcomeFailure Outcome = "failure"
)

// Record is one audited action.
type Record struct {
	AuditID       string
	TenantID      string
	ActorID       string
	Action        string
	ResourceType  string
	ResourceID    string
	Outcome       Outcome
	Reason        string
	PurposeOfUse  string
	BreakGlass    bool
	CorrelationID string
	RequestID     string
	OccurredAt    time.Time
	// Context holds allowlisted, non-PHI attributes only.
	Context json.RawMessage
}

// ErrInvalidRecord reports an audit record that would not be reviewable.
var ErrInvalidRecord = errors.New("audit: invalid record")

// Validate enforces the fields a reviewer needs to reconstruct who did what,
// when, in which tenant, under what correlation.
func (r Record) Validate() error {
	switch {
	case r.AuditID == "":
		return errors.Join(ErrInvalidRecord, errors.New("audit_id is required"))
	case r.TenantID == "":
		return errors.Join(ErrInvalidRecord, errors.New("tenant_id is required"))
	case r.ActorID == "":
		return errors.Join(ErrInvalidRecord, errors.New("actor_id is required"))
	case r.Action == "":
		return errors.Join(ErrInvalidRecord, errors.New("action is required"))
	case r.Outcome == "":
		return errors.Join(ErrInvalidRecord, errors.New("outcome is required"))
	case r.CorrelationID == "":
		return errors.Join(ErrInvalidRecord, errors.New("correlation_id is required"))
	case r.OccurredAt.IsZero():
		return errors.Join(ErrInvalidRecord, errors.New("occurred_at is required"))
	}
	return nil
}
