package domain

import (
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Maker/checker versioning of master data (SRS-PLT-008).
//
// The requirement's verification is "pending version does not affect
// production transactions until approved", and the way to make that true is
// structural rather than careful: a proposed change lives in its own aggregate
// and is never written into the row it would become. Storing a pending change
// in the target row means every reader has to know to filter it out, and the
// one reader that forgets applies an unapproved price to a real invoice.

// ChangeStatus is the lifecycle of a proposed master-data change.
type ChangeStatus string

const (
	ChangePendingApproval ChangeStatus = "pending_approval"
	ChangeApproved        ChangeStatus = "approved"
	ChangeRejected        ChangeStatus = "rejected"
	// ChangeSuperseded marks a proposal the entity moved on from before
	// anybody decided on it.
	ChangeSuperseded ChangeStatus = "superseded"
)

// MinChangeJustification mirrors the database CHECK. The justification is what
// the approver reads, so it has to say something.
const MinChangeJustification = 10

// MasterDataChange is a proposed change awaiting a second pair of eyes.
type MasterDataChange struct {
	ID         string
	TenantID   string
	EntityType string
	EntityID   string

	// Proposed is the whole intended state, not a field-level diff. A diff has
	// to be replayed against whatever the row looks like at approval time,
	// which may no longer be what the proposer was looking at.
	Proposed json.RawMessage
	// BaseVersion is the entity version the proposer saw, so approval can
	// detect that somebody else changed the row in between.
	BaseVersion int64

	Status        ChangeStatus
	EffectiveFrom time.Time
	Justification string

	ProposedBy string
	ProposedAt time.Time

	DecidedBy    string
	DecidedAt    time.Time
	DecisionNote string

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// Errors returned by the master-data change aggregate.
var (
	// ErrInvalidChange reports a proposal that must not be recorded.
	ErrInvalidChange = errors.New("organization: invalid master-data change")
	// ErrSelfApproval reports a change approved by its own proposer. This is
	// the control the whole aggregate exists for.
	ErrSelfApproval = errors.New("organization: a change cannot be approved by the person who proposed it")
	// ErrNotPending reports a decision on a change somebody already decided.
	ErrNotPending = errors.New("organization: change is not awaiting approval")
	// ErrStaleProposal reports a change computed against a version of the
	// entity that no longer exists.
	ErrStaleProposal = errors.New("organization: the entity changed after this was proposed")
)

// NewMasterDataChange validates and records a proposal.
//
// It always starts pending. There is no constructor that produces an approved
// change, so the four-eyes rule cannot be skipped by building the end state
// directly — which is the shape a "seed data" helper would otherwise take.
func NewMasterDataChange(id, tenantID, entityType, entityID string, proposed json.RawMessage,
	baseVersion int64, effectiveFrom time.Time, justification, proposedBy string,
	now time.Time) (MasterDataChange, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return MasterDataChange{}, fmt.Errorf("%w: id is required", ErrInvalidChange)
	case strings.TrimSpace(tenantID) == "":
		return MasterDataChange{}, fmt.Errorf("%w: tenant is required", ErrInvalidChange)
	case strings.TrimSpace(entityType) == "" || strings.TrimSpace(entityID) == "":
		return MasterDataChange{}, fmt.Errorf("%w: the entity being changed is required", ErrInvalidChange)
	case len(proposed) == 0 || !json.Valid(proposed):
		return MasterDataChange{}, fmt.Errorf("%w: proposed state must be valid JSON", ErrInvalidChange)
	case baseVersion < 0:
		return MasterDataChange{}, fmt.Errorf("%w: base version cannot be negative", ErrInvalidChange)
	case effectiveFrom.IsZero():
		return MasterDataChange{}, fmt.Errorf("%w: an effective date is required", ErrInvalidChange)
	case len(strings.TrimSpace(justification)) < MinChangeJustification:
		return MasterDataChange{}, fmt.Errorf("%w: justification must be at least %d characters",
			ErrInvalidChange, MinChangeJustification)
	case strings.TrimSpace(proposedBy) == "":
		return MasterDataChange{}, fmt.Errorf("%w: proposer is required", ErrInvalidChange)
	}

	return MasterDataChange{
		ID: id, TenantID: tenantID, EntityType: entityType, EntityID: entityID,
		Proposed: proposed, BaseVersion: baseVersion,
		Status:        ChangePendingApproval,
		EffectiveFrom: effectiveFrom.UTC(),
		Justification: justification,
		ProposedBy:    proposedBy,
		ProposedAt:    now.UTC(),
		CreatedAt:     now.UTC(),
		UpdatedAt:     now.UTC(),
		Version:       1,
	}, nil
}

// Approve accepts a proposal.
//
// currentEntityVersion is what the entity is at right now. A proposal computed
// against an older version is refused rather than applied: the proposer was
// looking at different data, and approving would silently discard whatever
// changed in between.
func (c *MasterDataChange) Approve(approvedBy, note string, currentEntityVersion int64, now time.Time) error {
	if err := c.canDecide(approvedBy); err != nil {
		return err
	}
	if currentEntityVersion != c.BaseVersion {
		return fmt.Errorf("%w: proposed against version %d, entity is now at %d",
			ErrStaleProposal, c.BaseVersion, currentEntityVersion)
	}
	c.Status = ChangeApproved
	c.decide(approvedBy, note, now)
	return nil
}

// Reject declines a proposal.
//
// A rejection needs its note as much as an approval does — more, in practice:
// the proposer has to know what to change.
func (c *MasterDataChange) Reject(rejectedBy, note string, now time.Time) error {
	if err := c.canDecide(rejectedBy); err != nil {
		return err
	}
	if len(strings.TrimSpace(note)) < MinChangeJustification {
		return fmt.Errorf("%w: a rejection must say why, so the proposer knows what to change",
			ErrInvalidChange)
	}
	c.Status = ChangeRejected
	c.decide(rejectedBy, note, now)
	return nil
}

// Supersede marks a proposal overtaken by events.
func (c *MasterDataChange) Supersede(now time.Time) error {
	if c.Status != ChangePendingApproval {
		return fmt.Errorf("%w: status is %s", ErrNotPending, c.Status)
	}
	c.Status = ChangeSuperseded
	c.UpdatedAt = now.UTC()
	return nil
}

func (c *MasterDataChange) canDecide(decidedBy string) error {
	switch {
	case c.Status != ChangePendingApproval:
		return fmt.Errorf("%w: status is %s", ErrNotPending, c.Status)
	case strings.TrimSpace(decidedBy) == "":
		return fmt.Errorf("%w: the deciding user is required", ErrInvalidChange)
	case decidedBy == c.ProposedBy:
		return ErrSelfApproval
	}
	return nil
}

func (c *MasterDataChange) decide(decidedBy, note string, now time.Time) {
	c.DecidedBy = decidedBy
	c.DecidedAt = now.UTC()
	c.DecisionNote = note
	c.UpdatedAt = now.UTC()
	c.Version++
}

// InForceAt reports whether an approved change is in force at an instant.
//
// SRS-PLT-008's verification clause has two halves and this is the second: a
// change approved today but effective next month must not affect today's
// transactions either. Approval is necessary and not sufficient.
func (c MasterDataChange) InForceAt(eventTime time.Time) bool {
	if c.Status != ChangeApproved {
		return false
	}
	return !eventTime.UTC().Before(c.EffectiveFrom)
}
