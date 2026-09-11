package fhir_test

import (
	"encoding/json"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/gateway/fhir"
	"github.com/ppusapati/health/code/internal/organization/domain"
)

var fhirNow = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

func facility(t *testing.T, facilityType domain.FacilityType) domain.Facility {
	t.Helper()
	f, err := domain.NewFacility("fac-1", "tenant-a", "FAC01", "Main Hospital",
		facilityType, "Asia/Kolkata", fhirNow)
	if err != nil {
		t.Fatalf("NewFacility: %v", err)
	}
	return *f
}

func TestFacilityBecomesAFHIROrganization(t *testing.T) {
	f := facility(t, domain.FacilityHospital)

	org, err := fhir.FromFacility(f)
	if err != nil {
		t.Fatalf("FromFacility: %v", err)
	}
	if org.ResourceType != "Organization" || org.ID != "fac-1" || org.Name != "Main Hospital" {
		t.Fatalf("bad projection: %+v", org)
	}
	if !org.Active {
		t.Fatal("an active facility projected as inactive")
	}
	// The domain's version travels in meta, so a consumer can detect a stale
	// copy without this gateway inventing a version scheme of its own.
	if org.Meta.VersionID == "" {
		t.Fatal("no version in meta; a consumer cannot detect a stale copy")
	}
}

// A code without a system is a string, and two hospitals' "FAC01" collide the
// moment anyone aggregates.
func TestIdentifiersAreNamespaced(t *testing.T) {
	org, err := fhir.FromFacility(facility(t, domain.FacilityHospital))
	if err != nil {
		t.Fatalf("FromFacility: %v", err)
	}
	if len(org.Identifier) == 0 {
		t.Fatal("the projection carries no identifier")
	}
	if !strings.HasPrefix(org.Identifier[0].System, fhir.SystemPrefix) {
		t.Fatalf("identifier system %q is not namespaced", org.Identifier[0].System)
	}
	if org.Identifier[0].Value != "FAC01" {
		t.Fatalf("identifier value %q", org.Identifier[0].Value)
	}
}

// Adding a facility type to the domain must fail here rather than silently
// emitting an Organization with no type, which a consumer reads as
// "unclassified" — a claim, not a gap.
func TestEveryFacilityTypeIsMapped(t *testing.T) {
	every := []domain.FacilityType{
		domain.FacilityHospital, domain.FacilityClinic, domain.FacilityLaboratory,
		domain.FacilityPharmacy, domain.FacilityCollectionCentre, domain.FacilityWarehouse,
	}
	codings := fhir.FacilityTypeCodings()

	for _, ft := range every {
		if _, mapped := codings[ft]; !mapped {
			t.Errorf("facility type %q has no FHIR coding", ft)
		}
		org, err := fhir.FromFacility(facility(t, ft))
		if err != nil {
			t.Errorf("FromFacility(%s): %v", ft, err)
			continue
		}
		if len(org.Type) == 0 || len(org.Type[0].Coding) == 0 {
			t.Errorf("facility type %q projected with no type element", ft)
		}
	}

	// And an unknown type is refused rather than emitted bare.
	unknown := facility(t, domain.FacilityHospital)
	unknown.Type = domain.FacilityType("spaceport")
	if _, err := fhir.FromFacility(unknown); !errors.Is(err, fhir.ErrUnmappable) {
		t.Fatalf("an unmapped type was projected: %v", err)
	}
}

// A warehouse is not a care setting; claiming it is a provider would put a
// logistics site into a consumer's provider directory.
func TestAWarehouseIsNotCodedAsAProvider(t *testing.T) {
	org, err := fhir.FromFacility(facility(t, domain.FacilityWarehouse))
	if err != nil {
		t.Fatalf("FromFacility: %v", err)
	}
	if org.Type[0].Coding[0].Code == "prov" {
		t.Fatal("a warehouse was coded as a healthcare provider")
	}
}

// A resource without an identifier or a name still looks like a record to a
// consumer, so a partial projection is refused.
func TestIncompleteResourcesAreRefusedNotPartiallyRendered(t *testing.T) {
	f := facility(t, domain.FacilityHospital)
	f.DisplayName = ""
	if _, err := fhir.FromFacility(f); !errors.Is(err, fhir.ErrUnmappable) {
		t.Fatalf("a nameless facility was projected: %v", err)
	}

	f = facility(t, domain.FacilityHospital)
	f.ID = ""
	if _, err := fhir.FromFacility(f); !errors.Is(err, fhir.ErrUnmappable) {
		t.Fatalf("an id-less facility was projected: %v", err)
	}
}

func orgUnit(t *testing.T, from, until time.Time) domain.OrgUnit {
	t.Helper()
	u, err := domain.NewOrgUnit("unit-1", "tenant-a", "fac-1", domain.UnitDepartment,
		"CARD", "Cardiology", "", from, until, false, fhirNow)
	if err != nil {
		t.Fatalf("NewOrgUnit: %v", err)
	}
	return u
}

// A department is a place within a provider. Mapping it to Organization would
// make every ward look like an independent legal entity.
func TestOrgUnitBecomesALocationNotAnOrganization(t *testing.T) {
	u := orgUnit(t, fhirNow.Add(-24*time.Hour), time.Time{})

	loc, err := fhir.FromOrgUnit(u, fhirNow)
	if err != nil {
		t.Fatalf("FromOrgUnit: %v", err)
	}
	if loc.ResourceType != "Location" {
		t.Fatalf("resource type %q", loc.ResourceType)
	}
	if loc.ManagingOrganization == nil || loc.ManagingOrganization.Reference != "Organization/fac-1" {
		t.Fatalf("the unit is not tied to its facility: %+v", loc.ManagingOrganization)
	}
}

// FHIR's Location.status has no notion of an effective window, so the window
// is collapsed at the boundary. The domain keeps the dates; only the
// projection loses them — which is the whole point of SRS-API-012.
func TestTheEffectiveWindowIsCollapsedAtTheBoundary(t *testing.T) {
	u := orgUnit(t, fhirNow.Add(-48*time.Hour), fhirNow.Add(-24*time.Hour))

	past, err := fhir.FromOrgUnit(u, fhirNow.Add(-36*time.Hour))
	if err != nil {
		t.Fatalf("FromOrgUnit: %v", err)
	}
	if past.Status != "active" {
		t.Fatalf("the unit was inactive during its own window: %q", past.Status)
	}

	present, err := fhir.FromOrgUnit(u, fhirNow)
	if err != nil {
		t.Fatalf("FromOrgUnit: %v", err)
	}
	if present.Status != "inactive" {
		t.Fatalf("a closed unit projected as %q", present.Status)
	}

	// The domain still has the dates the projection dropped.
	if u.EffectiveUntil.IsZero() {
		t.Fatal("the projection mutated the domain object")
	}
}

func TestErrorsBecomeOperationOutcomes(t *testing.T) {
	cases := map[string]string{
		"PERMISSION_DENIED":   "forbidden",
		"NOT_FOUND":           "not-found",
		"INVALID_ARGUMENT":    "invalid",
		"FAILED_PRECONDITION": "conflict",
		"UNAUTHENTICATED":     "login",
		"INTERNAL":            "exception",
	}
	for category, wantIssue := range cases {
		outcome := fhir.NewOperationOutcome(category, "ORG_FACILITY_NOT_FOUND", "facility not found")
		if outcome.ResourceType != "OperationOutcome" {
			t.Fatalf("resource type %q", outcome.ResourceType)
		}
		if outcome.Issue[0].Code != wantIssue {
			t.Errorf("%s mapped to issue code %q, want %q", category, outcome.Issue[0].Code, wantIssue)
		}
	}

	// An unknown category degrades to "processing" rather than producing an
	// issue code no consumer understands.
	unknown := fhir.NewOperationOutcome("TEAPOT", "X", "y")
	if unknown.Issue[0].Code != "processing" {
		t.Fatalf("an unknown category mapped to %q", unknown.Issue[0].Code)
	}
}

// FHIR's issue codes are a small closed set. The internal code travels in
// Details so a support conversation can be precise without this gateway
// inventing codes nobody understands.
func TestTheInternalCodeSurvivesTranslation(t *testing.T) {
	outcome := fhir.NewOperationOutcome("NOT_FOUND", "ORG_FACILITY_NOT_FOUND", "facility not found")

	encoded, err := json.Marshal(outcome)
	if err != nil {
		t.Fatalf("marshal: %v", err)
	}
	if !strings.Contains(string(encoded), "ORG_FACILITY_NOT_FOUND") {
		t.Fatalf("the internal code was lost: %s", encoded)
	}
	if outcome.Issue[0].Details.Coding[0].System != fhir.SystemPrefix+"error-code" {
		t.Fatalf("the internal code is not namespaced: %+v", outcome.Issue[0].Details)
	}
}

// The projection must serialise as FHIR expects: resourceType present, and a
// resource a consumer's parser will accept.
func TestProjectionsSerialiseAsFHIR(t *testing.T) {
	org, err := fhir.FromFacility(facility(t, domain.FacilityHospital))
	if err != nil {
		t.Fatalf("FromFacility: %v", err)
	}
	encoded, err := json.Marshal(org)
	if err != nil {
		t.Fatalf("marshal: %v", err)
	}

	var decoded map[string]any
	if err := json.Unmarshal(encoded, &decoded); err != nil {
		t.Fatalf("unmarshal: %v", err)
	}
	if decoded["resourceType"] != "Organization" {
		t.Fatalf("resourceType is %v", decoded["resourceType"])
	}
	// Internal concepts must not leak into the wire form: a consumer parsing
	// this should see FHIR, not this system's vocabulary.
	for _, internal := range []string{"tenant_id", "TenantID", "time_zone"} {
		if strings.Contains(string(encoded), internal) {
			t.Errorf("internal field %q leaked into the FHIR resource: %s", internal, encoded)
		}
	}
}
