package domain

import (
	"regexp"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// FacilityStatus. SRS-PLT-015 forbids hard deletion of referenced masters, so
// retirement is the terminal state rather than removal.
type FacilityStatus string

const (
	FacilityActive   FacilityStatus = "active"
	FacilityInactive FacilityStatus = "inactive"
	FacilityRetired  FacilityStatus = "retired"
)

var facilityTransitions = map[FacilityStatus][]FacilityStatus{
	FacilityActive:   {FacilityInactive, FacilityRetired},
	FacilityInactive: {FacilityActive, FacilityRetired},
	FacilityRetired:  {},
}

// FacilityType enumerates the care/service settings Wave 0 needs. Extending the
// list is a controlled change: it drives charge mapping and licensing.
type FacilityType string

const (
	FacilityHospital         FacilityType = "hospital"
	FacilityClinic           FacilityType = "clinic"
	FacilityLaboratory       FacilityType = "laboratory"
	FacilityPharmacy         FacilityType = "pharmacy"
	FacilityCollectionCentre FacilityType = "collection_centre"
	FacilityWarehouse        FacilityType = "warehouse"
)

var validFacilityTypes = map[FacilityType]bool{
	FacilityHospital: true, FacilityClinic: true, FacilityLaboratory: true,
	FacilityPharmacy: true, FacilityCollectionCentre: true, FacilityWarehouse: true,
}

// facilityCodePattern keeps codes stable and machine-safe: they appear in
// barcodes, document numbering and interface mappings.
var facilityCodePattern = regexp.MustCompile(`^[A-Z0-9][A-Z0-9_-]{1,31}$`)

// Facility is a care or service location within a tenant (SRS-PLT-004).
type Facility struct {
	ID          string
	TenantID    string
	Code        string
	DisplayName string
	Type        FacilityType
	Status      FacilityStatus
	TimeZone    string
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Version     int64
}

// NewFacility validates and constructs a facility in ACTIVE state.
//
// tenantID is supplied by the caller from verified session scope, never from a
// request body — the application layer is responsible for that, and the
// transport layer does not read tenant from the wire (SRS-IAM-013).
func NewFacility(id, tenantID, code, displayName string, ft FacilityType, timeZone string, now time.Time) (*Facility, error) {
	var violations []rpcerr.FieldViolation

	if id == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "facility_id", Reason: "REQUIRED"})
	}
	if tenantID == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "tenant_id", Reason: "REQUIRED"})
	}

	code = strings.ToUpper(strings.TrimSpace(code))
	if code == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "code", Reason: "REQUIRED"})
	} else if !facilityCodePattern.MatchString(code) {
		violations = append(violations, rpcerr.FieldViolation{Field: "code", Reason: "INVALID_FORMAT"})
	}

	displayName = strings.TrimSpace(displayName)
	if displayName == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "display_name", Reason: "REQUIRED"})
	}

	if !validFacilityTypes[ft] {
		violations = append(violations, rpcerr.FieldViolation{Field: "type", Reason: "UNSUPPORTED"})
	}

	timeZone = strings.TrimSpace(timeZone)
	if timeZone == "" {
		violations = append(violations, rpcerr.FieldViolation{Field: "time_zone", Reason: "REQUIRED"})
	} else if _, err := time.LoadLocation(timeZone); err != nil {
		violations = append(violations, rpcerr.FieldViolation{Field: "time_zone", Reason: "UNKNOWN_IANA_ZONE"})
	}

	if len(violations) > 0 {
		return nil, rpcerr.Invalid("ORG_FACILITY_INVALID", "facility is not valid", violations...)
	}

	return &Facility{
		ID:          id,
		TenantID:    tenantID,
		Code:        code,
		DisplayName: displayName,
		Type:        ft,
		Status:      FacilityActive,
		TimeZone:    timeZone,
		CreatedAt:   now.UTC(),
		UpdatedAt:   now.UTC(),
		Version:     1,
	}, nil
}

// Rename changes the human-readable name. The code is immutable precisely so
// that renaming cannot break references (SRS-PLT-007).
func (f *Facility) Rename(displayName string, now time.Time) error {
	displayName = strings.TrimSpace(displayName)
	if displayName == "" {
		return rpcerr.Invalid("ORG_FACILITY_INVALID", "facility is not valid",
			rpcerr.FieldViolation{Field: "display_name", Reason: "REQUIRED"})
	}
	f.DisplayName = displayName
	f.UpdatedAt = now.UTC()
	f.Version++
	return nil
}

// TransitionTo moves the facility between operational states.
func (f *Facility) TransitionTo(next FacilityStatus, now time.Time) error {
	for _, allowed := range facilityTransitions[f.Status] {
		if allowed == next {
			f.Status = next
			f.UpdatedAt = now.UTC()
			f.Version++
			return nil
		}
	}
	return rpcerr.FailedPrecondition(
		"ORG_FACILITY_TRANSITION_NOT_ALLOWED",
		"facility cannot move from "+string(f.Status)+" to "+string(next),
	)
}
