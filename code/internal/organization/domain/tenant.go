// Package domain holds the organization context's aggregates and invariants.
//
// This package is pure Go by contract: it must not import SQL, HTTP, RPC or
// cloud SDK packages (Blueprint §4.1, FIT-01). Identifiers and timestamps are
// supplied by the application layer so the domain stays deterministic and
// trivially testable.
package domain

import (
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// TenantStatus is the tenant lifecycle from the Wave-0 spec §4.
type TenantStatus string

const (
	TenantProvisioning TenantStatus = "provisioning"
	TenantActive       TenantStatus = "active"
	TenantSuspended    TenantStatus = "suspended"
	TenantOffboarding  TenantStatus = "offboarding"
	TenantTerminated   TenantStatus = "terminated"
)

// tenantTransitions is the allowed-transition table. Anything absent is denied,
// which keeps the state machine closed rather than open with exceptions.
var tenantTransitions = map[TenantStatus][]TenantStatus{
	TenantProvisioning: {TenantActive, TenantTerminated},
	TenantActive:       {TenantSuspended, TenantOffboarding},
	TenantSuspended:    {TenantActive, TenantOffboarding},
	TenantOffboarding:  {TenantTerminated},
	TenantTerminated:   {},
}

// Tenant is the root of the organization hierarchy (SRS-PLT-001). ID is opaque
// and immutable; DisplayName is never a key (SRS-PLT-007).
type Tenant struct {
	ID                string
	DisplayName       string
	LegalJurisdiction string
	DefaultLocale     string
	TimeZone          string
	Status            TenantStatus
	CreatedAt         time.Time
	UpdatedAt         time.Time
	Version           int64
}

// NewTenant creates a tenant in PROVISIONING. A tenant is never born ACTIVE:
// provisioning has to complete before it can own clinical data.
func NewTenant(id, displayName, jurisdiction, locale, timeZone string, now time.Time) (*Tenant, error) {
	var violations []rpcerr.FieldViolation

	displayName = strings.TrimSpace(displayName)
	if displayName == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "display_name", Reason: "REQUIRED"})
	}
	jurisdiction = strings.ToUpper(strings.TrimSpace(jurisdiction))
	if len(jurisdiction) != 2 {
		violations = append(violations, rpcerr.FieldViolation{Field: "legal_jurisdiction", Reason: "MUST_BE_ISO_3166_ALPHA2"})
	}
	locale = strings.TrimSpace(locale)
	if locale == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "default_locale", Reason: "REQUIRED"})
	}
	timeZone = strings.TrimSpace(timeZone)
	if timeZone == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "time_zone", Reason: "REQUIRED"})
	} else if _, err := time.LoadLocation(timeZone); err != nil {
		violations = append(violations, rpcerr.FieldViolation{Field: "time_zone", Reason: "UNKNOWN_IANA_ZONE"})
	}
	if id == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "tenant_id", Reason: "REQUIRED"})
	}

	if len(violations) > 0 {
		return nil, rpcerr.Invalid("ORG_TENANT_INVALID", "tenant is not valid", violations...)
	}

	return &Tenant{
		ID:                id,
		DisplayName:       displayName,
		LegalJurisdiction: jurisdiction,
		DefaultLocale:     locale,
		TimeZone:          timeZone,
		Status:            TenantProvisioning,
		CreatedAt:         now.UTC(),
		UpdatedAt:         now.UTC(),
		Version:           1,
	}, nil
}

// TransitionTo moves the tenant through its lifecycle, rejecting any transition
// not named in the table.
func (t *Tenant) TransitionTo(next TenantStatus, now time.Time) error {
	for _, allowed := range tenantTransitions[t.Status] {
		if allowed == next {
			t.Status = next
			t.UpdatedAt = now.UTC()
			t.Version++
			return nil
		}
	}
	return rpcerr.FailedPrecondition(
		"ORG_TENANT_TRANSITION_NOT_ALLOWED",
		"tenant cannot move from "+string(t.Status)+" to "+string(next),
	)
}

// AcceptsWrites reports whether the tenant may take state changes. A suspended
// tenant stays readable so staff can still retrieve records (SRS-PLT-020).
func (t *Tenant) AcceptsWrites() bool { return t.Status == TenantActive }

// IsAccessible reports whether the tenant may be read at all.
func (t *Tenant) IsAccessible() bool {
	return t.Status != TenantTerminated
}
