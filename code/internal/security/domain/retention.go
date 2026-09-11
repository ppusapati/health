package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// RetentionClass names how long a category of data is kept (SRS-DAT-009).
type RetentionClass struct {
	ID        string
	TenantID  string
	Name      string
	DataClass string
	// RetainDays nil means indefinitely. That has to be a deliberate choice,
	// not the value that appears when nobody sets one, so the constructor
	// requires it to be stated.
	RetainDays       *int32
	ArchiveAfterDays *int32
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

// ErrInvalidRetention reports an unusable retention class.
var ErrInvalidRetention = errors.New("security: invalid retention class")

// NewRetentionClass validates and constructs a class.
func NewRetentionClass(id, tenantID, name, dataClass string,
	retainDays, archiveAfterDays *int32, now time.Time) (RetentionClass, error) {

	switch {
	case id == "" || tenantID == "":
		return RetentionClass{}, fmt.Errorf("%w: id and tenant_id are required", ErrInvalidRetention)
	case strings.TrimSpace(name) == "":
		return RetentionClass{}, fmt.Errorf("%w: name is required", ErrInvalidRetention)
	case strings.TrimSpace(dataClass) == "":
		return RetentionClass{}, fmt.Errorf("%w: data_class is required", ErrInvalidRetention)
	case retainDays != nil && *retainDays <= 0:
		return RetentionClass{}, fmt.Errorf("%w: retain_days must be positive", ErrInvalidRetention)
	case archiveAfterDays != nil && *archiveAfterDays <= 0:
		return RetentionClass{}, fmt.Errorf("%w: archive_after_days must be positive", ErrInvalidRetention)
	}

	// Archiving after the retention period would never happen.
	if retainDays != nil && archiveAfterDays != nil && *archiveAfterDays >= *retainDays {
		return RetentionClass{}, fmt.Errorf(
			"%w: archive_after_days (%d) must be less than retain_days (%d)",
			ErrInvalidRetention, *archiveAfterDays, *retainDays)
	}

	return RetentionClass{
		ID: id, TenantID: tenantID, Name: strings.TrimSpace(name), DataClass: dataClass,
		RetainDays: retainDays, ArchiveAfterDays: archiveAfterDays,
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// DueForDeletion reports whether a record created at createdAt has passed its
// retention period.
//
// This answers the retention question only. Whether the record may actually be
// deleted also depends on legal hold, which is a separate check by design — a
// deletion job that consults only the period is how held evidence gets erased.
func (c RetentionClass) DueForDeletion(createdAt, now time.Time) bool {
	if c.RetainDays == nil {
		return false
	}
	return !now.UTC().Before(createdAt.UTC().AddDate(0, 0, int(*c.RetainDays)))
}

// DueForArchive reports whether a record has passed its archive threshold.
func (c RetentionClass) DueForArchive(createdAt, now time.Time) bool {
	if c.ArchiveAfterDays == nil {
		return false
	}
	return !now.UTC().Before(createdAt.UTC().AddDate(0, 0, int(*c.ArchiveAfterDays)))
}

// LegalHold suspends deletion of a resource regardless of retention.
type LegalHold struct {
	ID           string
	TenantID     string
	ResourceType string
	ResourceID   string
	Reason       string
	PlacedBy     string
	PlacedAt     time.Time
	ReleasedBy   string
	ReleasedAt   time.Time
}

// ErrInvalidLegalHold reports an unusable hold.
var ErrInvalidLegalHold = errors.New("security: invalid legal hold")

// NewLegalHold validates and constructs a hold.
func NewLegalHold(id, tenantID, resourceType, resourceID, reason, placedBy string, now time.Time) (LegalHold, error) {
	switch {
	case id == "" || tenantID == "":
		return LegalHold{}, fmt.Errorf("%w: id and tenant_id are required", ErrInvalidLegalHold)
	case strings.TrimSpace(resourceType) == "" || strings.TrimSpace(resourceID) == "":
		return LegalHold{}, fmt.Errorf("%w: resource identity is required", ErrInvalidLegalHold)
	case strings.TrimSpace(reason) == "":
		// An unexplained hold cannot be reviewed for release.
		return LegalHold{}, fmt.Errorf("%w: reason is required", ErrInvalidLegalHold)
	case placedBy == "":
		return LegalHold{}, fmt.Errorf("%w: placed_by is required", ErrInvalidLegalHold)
	}

	return LegalHold{
		ID: id, TenantID: tenantID, ResourceType: resourceType, ResourceID: resourceID,
		Reason: strings.TrimSpace(reason), PlacedBy: placedBy, PlacedAt: now.UTC(),
	}, nil
}

// DeletionDecision is the combined answer a deletion job needs.
type DeletionDecision struct {
	MayDelete bool
	Reason    string
}

// Stable deletion reasons.
const (
	ReasonRetained   = "WITHIN_RETENTION_PERIOD"
	ReasonLegalHeld  = "UNDER_LEGAL_HOLD"
	ReasonDeletable  = "RETENTION_EXPIRED"
	ReasonIndefinite = "RETAINED_INDEFINITELY"
)

// EvaluateDeletion combines retention and legal hold.
//
// Legal hold is checked first and wins outright: a held record stays even when
// its retention period has long expired. That ordering is the whole point —
// SRS-DAT-009 requires the deletion job to skip held records.
func EvaluateDeletion(class RetentionClass, createdAt, now time.Time, underLegalHold bool) DeletionDecision {
	if underLegalHold {
		return DeletionDecision{MayDelete: false, Reason: ReasonLegalHeld}
	}
	if class.RetainDays == nil {
		return DeletionDecision{MayDelete: false, Reason: ReasonIndefinite}
	}
	if !class.DueForDeletion(createdAt, now) {
		return DeletionDecision{MayDelete: false, Reason: ReasonRetained}
	}
	return DeletionDecision{MayDelete: true, Reason: ReasonDeletable}
}
