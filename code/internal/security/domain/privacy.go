package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ProcessingPurpose is a declared reason for processing personal data
// (SRS-SEC-009).
//
// Kept separate from clinical consent on purpose. A patient withdrawing
// marketing consent must not disturb the lawful basis for keeping their medical
// record, and conflating the two is how that mistake gets made.
type ProcessingPurpose struct {
	ID          string
	TenantID    string
	Code        string
	Description string
	// Withdrawable is false where a legal or clinical obligation means the
	// subject cannot opt out — care delivery and statutory reporting.
	Withdrawable bool
	LawfulBasis  string
	CreatedAt    time.Time
}

// ErrInvalidPurpose reports an unusable processing purpose.
var ErrInvalidPurpose = errors.New("security: invalid processing purpose")

// NewProcessingPurpose validates and constructs a purpose.
func NewProcessingPurpose(id, tenantID, code, description, lawfulBasis string,
	withdrawable bool, now time.Time) (ProcessingPurpose, error) {

	switch {
	case id == "" || tenantID == "":
		return ProcessingPurpose{}, fmt.Errorf("%w: id and tenant_id are required", ErrInvalidPurpose)
	case strings.TrimSpace(code) == "":
		return ProcessingPurpose{}, fmt.Errorf("%w: code is required", ErrInvalidPurpose)
	case strings.TrimSpace(description) == "":
		return ProcessingPurpose{}, fmt.Errorf("%w: description is required", ErrInvalidPurpose)
	case strings.TrimSpace(lawfulBasis) == "":
		// Without a stated basis there is nothing to defend the processing on.
		return ProcessingPurpose{}, fmt.Errorf("%w: lawful_basis is required", ErrInvalidPurpose)
	}

	return ProcessingPurpose{
		ID: id, TenantID: tenantID, Code: strings.TrimSpace(code),
		Description: description, Withdrawable: withdrawable,
		LawfulBasis: lawfulBasis, CreatedAt: now.UTC(),
	}, nil
}

// PurposeGrant records a subject's decision about one purpose.
//
// Append-only: a withdrawal is a new row, so what the subject agreed to and
// when stays reconstructable.
type PurposeGrant struct {
	ID            string
	TenantID      string
	SubjectRef    string
	PurposeCode   string
	NoticeVersion int32
	Granted       bool
	RecordedBy    string
	OccurredAt    time.Time
}

// ErrNotWithdrawable reports an attempt to withdraw from a purpose the subject
// cannot opt out of.
var ErrNotWithdrawable = errors.New("security: purpose is not withdrawable")

// NewPurposeGrant validates and constructs a grant or withdrawal.
//
// Withdrawing from a non-withdrawable purpose is refused rather than silently
// recorded: pretending to honour it would be worse than saying no.
func NewPurposeGrant(id, tenantID, subjectRef, recordedBy string, purpose ProcessingPurpose,
	noticeVersion int32, granted bool, now time.Time) (PurposeGrant, error) {

	switch {
	case id == "" || tenantID == "":
		return PurposeGrant{}, fmt.Errorf("%w: id and tenant_id are required", ErrInvalidPurpose)
	case strings.TrimSpace(subjectRef) == "":
		return PurposeGrant{}, fmt.Errorf("%w: subject_ref is required", ErrInvalidPurpose)
	case recordedBy == "":
		return PurposeGrant{}, fmt.Errorf("%w: recorded_by is required", ErrInvalidPurpose)
	case noticeVersion <= 0:
		// Which notice the subject saw is part of what they agreed to.
		return PurposeGrant{}, fmt.Errorf("%w: notice_version is required", ErrInvalidPurpose)
	}

	if !granted && !purpose.Withdrawable {
		return PurposeGrant{}, fmt.Errorf("%w: %s", ErrNotWithdrawable, purpose.Code)
	}

	return PurposeGrant{
		ID: id, TenantID: tenantID, SubjectRef: subjectRef,
		PurposeCode: purpose.Code, NoticeVersion: noticeVersion,
		Granted: granted, RecordedBy: recordedBy, OccurredAt: now.UTC(),
	}, nil
}

// SubjectRequestType enumerates data-subject rights.
type SubjectRequestType string

const (
	RequestAccess        SubjectRequestType = "access"
	RequestRectification SubjectRequestType = "rectification"
	RequestErasure       SubjectRequestType = "erasure"
	RequestRestriction   SubjectRequestType = "restriction"
	RequestPortability   SubjectRequestType = "portability"
	RequestObjection     SubjectRequestType = "objection"
)

var validRequestTypes = map[SubjectRequestType]bool{
	RequestAccess: true, RequestRectification: true, RequestErasure: true,
	RequestRestriction: true, RequestPortability: true, RequestObjection: true,
}

// SubjectRequestStatus is the handling lifecycle.
type SubjectRequestStatus string

const (
	RequestReceived           SubjectRequestStatus = "received"
	RequestVerifying          SubjectRequestStatus = "verifying"
	RequestInReview           SubjectRequestStatus = "in_review"
	RequestFulfilled          SubjectRequestStatus = "fulfilled"
	RequestPartiallyFulfilled SubjectRequestStatus = "partially_fulfilled"
	RequestRefused            SubjectRequestStatus = "refused"
)

// DefaultResponseWindow is the statutory clock most regimes set. Configurable
// per country pack later; a default of "none" would mean nothing is ever late.
const DefaultResponseWindow = 30 * 24 * time.Hour

// SubjectRequest is one data-subject request (SRS-SEC-010).
type SubjectRequest struct {
	ID            string
	TenantID      string
	SubjectRef    string
	Type          SubjectRequestType
	Status        SubjectRequestStatus
	ReceivedAt    time.Time
	DueAt         time.Time
	Reviewer      string
	Decision      string
	DecisionBasis string
	EvidenceRef   string
	ClosedAt      time.Time
	CreatedAt     time.Time
	UpdatedAt     time.Time
	Version       int64
}

// ErrInvalidSubjectRequest reports an unusable request.
var ErrInvalidSubjectRequest = errors.New("security: invalid subject request")

// NewSubjectRequest validates and constructs a received request.
func NewSubjectRequest(id, tenantID, subjectRef string, requestType SubjectRequestType,
	now time.Time, window time.Duration) (SubjectRequest, error) {

	switch {
	case id == "" || tenantID == "":
		return SubjectRequest{}, fmt.Errorf("%w: id and tenant_id are required", ErrInvalidSubjectRequest)
	case strings.TrimSpace(subjectRef) == "":
		return SubjectRequest{}, fmt.Errorf("%w: subject_ref is required", ErrInvalidSubjectRequest)
	case !validRequestTypes[requestType]:
		return SubjectRequest{}, fmt.Errorf("%w: unknown type %q", ErrInvalidSubjectRequest, requestType)
	}

	if window <= 0 {
		window = DefaultResponseWindow
	}

	return SubjectRequest{
		ID: id, TenantID: tenantID, SubjectRef: subjectRef, Type: requestType,
		Status: RequestReceived, ReceivedAt: now.UTC(), DueAt: now.UTC().Add(window),
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// Decide records the reviewer's outcome.
//
// A refusal or partial fulfilment requires a stated basis. An erasure request
// refused because a clinical retention obligation applies is defensible; an
// unexplained refusal is not.
func (r *SubjectRequest) Decide(status SubjectRequestStatus, reviewer, decision, basis, evidenceRef string,
	now time.Time) error {

	if r.Status == RequestFulfilled || r.Status == RequestRefused {
		return fmt.Errorf("%w: request is already %s", ErrInvalidSubjectRequest, r.Status)
	}
	if reviewer == "" {
		return fmt.Errorf("%w: reviewer is required", ErrInvalidSubjectRequest)
	}

	switch status {
	case RequestRefused, RequestPartiallyFulfilled:
		if strings.TrimSpace(basis) == "" {
			return fmt.Errorf("%w: a refusal or partial fulfilment requires a stated basis",
				ErrInvalidSubjectRequest)
		}
	case RequestFulfilled:
		if strings.TrimSpace(evidenceRef) == "" {
			// SRS-SEC-010 requires evidence; "we did it" without a reference is
			// not evidence.
			return fmt.Errorf("%w: fulfilment requires an evidence reference", ErrInvalidSubjectRequest)
		}
	case RequestVerifying, RequestInReview:
		// Intermediate states need no decision yet.
	default:
		return fmt.Errorf("%w: unknown status %q", ErrInvalidSubjectRequest, status)
	}

	r.Status = status
	r.Reviewer = reviewer
	r.Decision = decision
	r.DecisionBasis = basis
	r.EvidenceRef = evidenceRef
	r.UpdatedAt = now.UTC()
	r.Version++

	if status == RequestFulfilled || status == RequestRefused || status == RequestPartiallyFulfilled {
		r.ClosedAt = now.UTC()
	}
	return nil
}

// IsOverdue reports whether the statutory window has passed unanswered.
func (r SubjectRequest) IsOverdue(now time.Time) bool {
	if r.ClosedAt.IsZero() {
		return !now.UTC().Before(r.DueAt)
	}
	return false
}
