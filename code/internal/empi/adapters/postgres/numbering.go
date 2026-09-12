package postgres

import (
	"context"
	"time"

	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// MRN issuance and tenant attributes (SRS-EMPI-001).
//
// Both adapt capabilities the organization context already owns rather than
// duplicating them here. The numbering sequence in particular: its statement
// takes a row lock, which is the whole reason SRS-EMPI-016 ("prevent duplicate
// MRN assignment under concurrent registration") holds. A second implementation
// would be a second chance to get that wrong, and the way it would fail —
// duplicate MRNs under load, not under test — is the way nobody notices until a
// wristband is on the wrong arm.

// MRNIssuer adapts the platform numbering capability to the patient index.
type MRNIssuer struct {
	numbers orgports.NumberIssuer
}

// NewMRNIssuer constructs the adapter.
func NewMRNIssuer(numbers orgports.NumberIssuer) MRNIssuer {
	return MRNIssuer{numbers: numbers}
}

// IssueMRN allocates the next MRN in the registering facility's sequence.
func (m MRNIssuer) IssueMRN(ctx context.Context, scope authctx.TenantScope,
	facilityID string, now time.Time) (string, error) {

	// No period key: an MRN identifies a person for life and must not reset
	// with the year. Invoice numbers do; medical record numbers do not.
	return m.numbers.IssueNumber(ctx, scope, orgdomain.ScopeMRN, facilityID, "", now)
}

// TenantJurisdiction reads the jurisdiction that selects the demographic policy.
type TenantJurisdiction struct {
	tenants orgports.TenantRepository
}

// NewTenantJurisdiction constructs the adapter.
func NewTenantJurisdiction(tenants orgports.TenantRepository) TenantJurisdiction {
	return TenantJurisdiction{tenants: tenants}
}

// Jurisdiction returns the tenant's legal jurisdiction.
//
// Read from the tenant record rather than taken from the request, so a caller
// cannot select a laxer demographic policy by naming a different jurisdiction.
func (t TenantJurisdiction) Jurisdiction(ctx context.Context, scope authctx.TenantScope) (string, error) {
	tenant, err := t.tenants.GetByID(ctx, scope.TenantID())
	if err != nil {
		return "", err
	}
	return tenant.LegalJurisdiction, nil
}
