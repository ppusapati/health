package transport

import (
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Enum mapping is table-driven in both directions. Proto enums and domain
// values evolve independently, and an explicit table makes an unmapped value a
// visible gap rather than a silent zero.

var facilityTypeToDomain = map[organizationv1.FacilityType]domain.FacilityType{
	organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL:          domain.FacilityHospital,
	organizationv1.FacilityType_FACILITY_TYPE_CLINIC:            domain.FacilityClinic,
	organizationv1.FacilityType_FACILITY_TYPE_LABORATORY:        domain.FacilityLaboratory,
	organizationv1.FacilityType_FACILITY_TYPE_PHARMACY:          domain.FacilityPharmacy,
	organizationv1.FacilityType_FACILITY_TYPE_COLLECTION_CENTRE: domain.FacilityCollectionCentre,
	organizationv1.FacilityType_FACILITY_TYPE_WAREHOUSE:         domain.FacilityWarehouse,
}

var facilityTypeToProto = map[domain.FacilityType]organizationv1.FacilityType{}

var facilityStatusToDomain = map[organizationv1.FacilityStatus]domain.FacilityStatus{
	organizationv1.FacilityStatus_FACILITY_STATUS_ACTIVE:   domain.FacilityActive,
	organizationv1.FacilityStatus_FACILITY_STATUS_INACTIVE: domain.FacilityInactive,
	organizationv1.FacilityStatus_FACILITY_STATUS_RETIRED:  domain.FacilityRetired,
}

var facilityStatusToProto = map[domain.FacilityStatus]organizationv1.FacilityStatus{}

var tenantStatusToProto = map[domain.TenantStatus]organizationv1.TenantStatus{
	domain.TenantProvisioning: organizationv1.TenantStatus_TENANT_STATUS_PROVISIONING,
	domain.TenantActive:       organizationv1.TenantStatus_TENANT_STATUS_ACTIVE,
	domain.TenantSuspended:    organizationv1.TenantStatus_TENANT_STATUS_SUSPENDED,
	domain.TenantOffboarding:  organizationv1.TenantStatus_TENANT_STATUS_OFFBOARDING,
	domain.TenantTerminated:   organizationv1.TenantStatus_TENANT_STATUS_TERMINATED,
}

func init() {
	for proto, dom := range facilityTypeToDomain {
		facilityTypeToProto[dom] = proto
	}
	for proto, dom := range facilityStatusToDomain {
		facilityStatusToProto[dom] = proto
	}
}

// facilityTypeFromProto returns the domain type. An unmapped value yields the
// empty type, which the domain rejects with a field violation rather than
// defaulting to something plausible.
func facilityTypeFromProto(t organizationv1.FacilityType) domain.FacilityType {
	return facilityTypeToDomain[t]
}

func facilityStatusFromProto(s organizationv1.FacilityStatus) domain.FacilityStatus {
	return facilityStatusToDomain[s]
}

func tenantToProto(t *domain.Tenant) *organizationv1.Tenant {
	if t == nil {
		return nil
	}
	return &organizationv1.Tenant{
		TenantId:          t.ID,
		DisplayName:       t.DisplayName,
		LegalJurisdiction: t.LegalJurisdiction,
		DefaultLocale:     t.DefaultLocale,
		TimeZone:          t.TimeZone,
		Status:            tenantStatusToProto[t.Status],
		CreatedAt:         timestamppb.New(t.CreatedAt),
		UpdatedAt:         timestamppb.New(t.UpdatedAt),
		Version:           t.Version,
	}
}

func facilityToProto(f *domain.Facility) *organizationv1.Facility {
	if f == nil {
		return nil
	}
	return &organizationv1.Facility{
		FacilityId:  f.ID,
		TenantId:    f.TenantID,
		Code:        f.Code,
		DisplayName: f.DisplayName,
		Type:        facilityTypeToProto[f.Type],
		Status:      facilityStatusToProto[f.Status],
		TimeZone:    f.TimeZone,
		CreatedAt:   timestamppb.New(f.CreatedAt),
		UpdatedAt:   timestamppb.New(f.UpdatedAt),
		Version:     f.Version,
	}
}
