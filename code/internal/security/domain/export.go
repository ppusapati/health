package domain

import (
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

// ExportStatus is the bulk-export lifecycle.
type ExportStatus string

const (
	ExportPendingApproval ExportStatus = "pending_approval"
	ExportApproved        ExportStatus = "approved"
	ExportRejected        ExportStatus = "rejected"
	ExportRunning         ExportStatus = "running"
	ExportCompleted       ExportStatus = "completed"
	ExportFailed          ExportStatus = "failed"
	ExportExpired         ExportStatus = "expired"
)

// MinJustificationLength mirrors the database CHECK. A one-word justification
// is not reviewable, and the point of requiring one is that somebody can review
// it later.
const MinJustificationLength = 10

// ExportRequest is a request to extract data in bulk.
type ExportRequest struct {
	ID              string
	TenantID        string
	RequestedBy     string
	Justification   string
	DataClass       string
	Scope           json.RawMessage
	Status          ExportStatus
	StepUpReference string
	ApprovedBy      string
	ApprovedAt      time.Time
	ObjectKey       string
	ObjectSHA256    string
	Manifest        json.RawMessage
	RowCount        int64
	Watermark       string
	GrantExpiresAt  time.Time
	CreatedAt       time.Time
	UpdatedAt       time.Time
	Version         int64
}

// ErrInvalidExport reports an export request that must not be accepted.
var ErrInvalidExport = errors.New("security: invalid export request")

// NewExportRequest validates and constructs a pending request.
//
// It starts in PENDING_APPROVAL, never approved: a bulk PHI export that its own
// requester can execute has no second pair of eyes on it.
func NewExportRequest(id, tenantID, requestedBy, justification, dataClass, stepUpReference string,
	scope json.RawMessage, now time.Time) (ExportRequest, error) {

	switch {
	case id == "":
		return ExportRequest{}, fmt.Errorf("%w: id is required", ErrInvalidExport)
	case tenantID == "":
		return ExportRequest{}, fmt.Errorf("%w: tenant_id is required", ErrInvalidExport)
	case requestedBy == "":
		return ExportRequest{}, fmt.Errorf("%w: requested_by is required", ErrInvalidExport)
	case len(strings.TrimSpace(justification)) < MinJustificationLength:
		return ExportRequest{}, fmt.Errorf("%w: justification must be at least %d characters",
			ErrInvalidExport, MinJustificationLength)
	case strings.TrimSpace(dataClass) == "":
		return ExportRequest{}, fmt.Errorf("%w: data_class is required", ErrInvalidExport)
	case stepUpReference == "":
		// SRS-IAM-012: a bulk export is a high-risk action, so the step-up must
		// already have happened by the time the request is recorded.
		return ExportRequest{}, fmt.Errorf("%w: step-up authentication is required", ErrInvalidExport)
	}

	if len(scope) == 0 {
		scope = json.RawMessage(`{}`)
	}

	return ExportRequest{
		ID:              id,
		TenantID:        tenantID,
		RequestedBy:     requestedBy,
		Justification:   strings.TrimSpace(justification),
		DataClass:       dataClass,
		Scope:           scope,
		Status:          ExportPendingApproval,
		StepUpReference: stepUpReference,
		// The watermark attributes a leaked file to the person who took it.
		Watermark: fmt.Sprintf("tenant=%s subject=%s export=%s", tenantID, requestedBy, id),
		CreatedAt: now.UTC(),
		UpdatedAt: now.UTC(),
		Version:   1,
	}, nil
}

// ErrSelfApproval reports an attempt to approve one's own export.
var ErrSelfApproval = errors.New("security: an export cannot be approved by its requester")

// Approve records a second party's decision.
//
// Segregation of duties: the requester may not approve. Without this the
// approval step is paperwork rather than a control.
func (e *ExportRequest) Approve(approvedBy string, now time.Time) error {
	if e.Status != ExportPendingApproval {
		return fmt.Errorf("%w: export is %s, not pending approval", ErrInvalidExport, e.Status)
	}
	if approvedBy == "" {
		return fmt.Errorf("%w: approved_by is required", ErrInvalidExport)
	}
	if approvedBy == e.RequestedBy {
		return ErrSelfApproval
	}

	e.Status = ExportApproved
	e.ApprovedBy = approvedBy
	e.ApprovedAt = now.UTC()
	e.UpdatedAt = now.UTC()
	e.Version++
	return nil
}

// Reject records a refusal.
func (e *ExportRequest) Reject(rejectedBy string, now time.Time) error {
	if e.Status != ExportPendingApproval {
		return fmt.Errorf("%w: export is %s, not pending approval", ErrInvalidExport, e.Status)
	}
	if rejectedBy == e.RequestedBy {
		return ErrSelfApproval
	}

	e.Status = ExportRejected
	e.ApprovedBy = rejectedBy
	e.ApprovedAt = now.UTC()
	e.UpdatedAt = now.UTC()
	e.Version++
	return nil
}

// DefaultGrantTTL bounds how long a completed export can be downloaded.
const DefaultGrantTTL = 24 * time.Hour

// Complete records the produced artifact and opens a bounded download window.
//
// The checksum is mandatory: SRS-NFR-012 requires export completeness to be
// verifiable, and a manifest without a digest cannot detect a truncated file.
func (e *ExportRequest) Complete(objectKey, sha256Hex string, manifest json.RawMessage,
	rowCount int64, now time.Time, ttl time.Duration) error {

	if e.Status != ExportApproved {
		return fmt.Errorf("%w: export is %s, not approved", ErrInvalidExport, e.Status)
	}
	if objectKey == "" {
		return fmt.Errorf("%w: object_key is required", ErrInvalidExport)
	}
	if len(sha256Hex) != 64 {
		return fmt.Errorf("%w: object_sha256 must be a sha256 hex digest", ErrInvalidExport)
	}
	if ttl <= 0 {
		ttl = DefaultGrantTTL
	}
	if len(manifest) == 0 {
		manifest = json.RawMessage(`{}`)
	}

	e.Status = ExportCompleted
	e.ObjectKey = objectKey
	e.ObjectSHA256 = sha256Hex
	e.Manifest = manifest
	e.RowCount = rowCount
	e.GrantExpiresAt = now.UTC().Add(ttl)
	e.UpdatedAt = now.UTC()
	e.Version++
	return nil
}

// ErrGrantExpired reports a download attempt after the window closed.
var ErrGrantExpired = errors.New("security: export download grant has expired")

// AuthorizeDownload reports whether the export may be downloaded now.
func (e ExportRequest) AuthorizeDownload(now time.Time) error {
	if e.Status != ExportCompleted {
		return fmt.Errorf("%w: export is %s", ErrInvalidExport, e.Status)
	}
	if e.GrantExpiresAt.IsZero() || !now.UTC().Before(e.GrantExpiresAt) {
		return ErrGrantExpired
	}
	return nil
}
