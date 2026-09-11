// Package fhir translates between FHIR R4 resources and this system's domain.
//
// SRS-API-012 keeps external standard gateways separate from internal domain
// contracts, verified by "external standard changes do not force internal DB
// model rewrite". The temptation this package exists to resist is specific:
// FHIR resources look enough like domain aggregates that storing a
// fhir.Organization directly would save writing a mapping — until the next
// FHIR release renumbers an element, and the change becomes a data migration
// across every row rather than an edit to one file.
//
// So translation is one-directional in its dependency: this package imports
// the domain, and nothing in the domain, application or adapter layers may
// import this one. A fitness test holds that (TestGatewaysAreNotImportedByTheDomain).
//
// The mapping is deliberately lossy in both directions, and saying so here
// matters more than any individual field:
//
//	Outward  FHIR has no place for several things this system tracks — the
//	         effective-date window on an organizational unit, a tenant's
//	         numbering configuration — so they simply do not appear. A
//	         consumer that needs them is not a FHIR consumer.
//	Inward   FHIR carries elements this system has no use for, and they are
//	         dropped rather than stashed in a JSON column "in case". A column
//	         of unmapped external data is a schema nobody owns.
package fhir

import (
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
)

// Errors returned by translation.
var (
	// ErrUnmappable reports a resource this gateway cannot translate. Always
	// an error rather than a partial result: a half-translated Organization
	// with a missing identifier is worse than a refusal, because it looks like
	// a record.
	ErrUnmappable = errors.New("fhir: resource cannot be translated")
	// ErrUnsupportedResource reports a resource type this gateway does not
	// handle.
	ErrUnsupportedResource = errors.New("fhir: unsupported resource type")
)

// SystemPrefix namespaces identifiers this system issues.
//
// A FHIR identifier without a system is just a string, and two systems' ids
// collide the moment anyone aggregates. Namespacing is what makes an exported
// identifier meaningful outside this deployment.
const SystemPrefix = "urn:healthcare:"

// Identifier is a FHIR Identifier.
type Identifier struct {
	System string `json:"system"`
	Value  string `json:"value"`
}

// Coding is a FHIR Coding.
type Coding struct {
	System  string `json:"system"`
	Code    string `json:"code"`
	Display string `json:"display,omitempty"`
}

// CodeableConcept is a FHIR CodeableConcept.
type CodeableConcept struct {
	Coding []Coding `json:"coding,omitempty"`
	Text   string   `json:"text,omitempty"`
}

// Reference is a FHIR Reference.
type Reference struct {
	Reference string `json:"reference,omitempty"`
	Display   string `json:"display,omitempty"`
}

// Meta is a FHIR resource's metadata.
type Meta struct {
	// VersionID carries the domain's own version, so a consumer can detect a
	// stale copy and this gateway does not need a version scheme of its own.
	VersionID   string `json:"versionId,omitempty"`
	LastUpdated string `json:"lastUpdated,omitempty"`
}

// Organization is a FHIR R4 Organization, reduced to the elements this system
// can populate honestly.
type Organization struct {
	ResourceType string            `json:"resourceType"`
	ID           string            `json:"id"`
	Meta         Meta              `json:"meta,omitempty"`
	Identifier   []Identifier      `json:"identifier,omitempty"`
	Active       bool              `json:"active"`
	Type         []CodeableConcept `json:"type,omitempty"`
	Name         string            `json:"name"`
	PartOf       *Reference        `json:"partOf,omitempty"`
}

// Location is a FHIR R4 Location.
type Location struct {
	ResourceType         string            `json:"resourceType"`
	ID                   string            `json:"id"`
	Meta                 Meta              `json:"meta,omitempty"`
	Identifier           []Identifier      `json:"identifier,omitempty"`
	Status               string            `json:"status"`
	Name                 string            `json:"name"`
	Type                 []CodeableConcept `json:"type,omitempty"`
	ManagingOrganization *Reference        `json:"managingOrganization,omitempty"`
}

// hl7OrganizationType is the HL7 value set this gateway codes against.
const hl7OrganizationType = "http://terminology.hl7.org/CodeSystem/organization-type"

// facilityTypeCoding maps every domain facility type onto that value set.
//
// A lookup table rather than string formatting, and exhaustive rather than
// best-effort: an unmapped type would silently emit an Organization with no
// type element, which a consumer reads as "unclassified" rather than as a gap.
// TestEveryFacilityTypeIsMapped fails when a new domain type is added without
// a coding, so the gap is found here rather than by a consumer.
//
// Several types collapse onto "prov". That is the value set being coarser than
// this system, not a mistake: HL7 distinguishes provider from insurer from
// government agency, and a laboratory and a hospital are both providers to it.
// The finer distinction survives in the identifier, which is namespaced to
// this system precisely so it can carry what the standard cannot.
var facilityTypeCoding = map[domain.FacilityType]Coding{
	domain.FacilityHospital:         {System: hl7OrganizationType, Code: "prov", Display: "Healthcare Provider"},
	domain.FacilityClinic:           {System: hl7OrganizationType, Code: "prov", Display: "Healthcare Provider"},
	domain.FacilityLaboratory:       {System: hl7OrganizationType, Code: "prov", Display: "Healthcare Provider"},
	domain.FacilityPharmacy:         {System: hl7OrganizationType, Code: "prov", Display: "Healthcare Provider"},
	domain.FacilityCollectionCentre: {System: hl7OrganizationType, Code: "prov", Display: "Healthcare Provider"},
	// A warehouse is not a care setting. "other" is the honest code: claiming
	// it is a healthcare provider would put a logistics site into a consumer's
	// provider directory.
	domain.FacilityWarehouse: {System: hl7OrganizationType, Code: "other", Display: "Other"},
}

// FacilityTypeCodings exposes the table so a test can hold it exhaustive.
func FacilityTypeCodings() map[domain.FacilityType]Coding {
	out := make(map[domain.FacilityType]Coding, len(facilityTypeCoding))
	for k, v := range facilityTypeCoding {
		out[k] = v
	}
	return out
}

// FromFacility renders a facility as a FHIR Organization.
//
// The domain object is the source of truth and this is a projection of it. It
// takes no pointer to anything mutable and returns a value, so a consumer
// cannot reach back through the projection into the record.
func FromFacility(f domain.Facility) (Organization, error) {
	if strings.TrimSpace(f.ID) == "" || strings.TrimSpace(f.DisplayName) == "" {
		// Refused rather than partially rendered: a resource without an
		// identifier or a name still looks like a record to a consumer.
		return Organization{}, fmt.Errorf("%w: a facility needs an id and a name", ErrUnmappable)
	}

	org := Organization{
		ResourceType: "Organization",
		ID:           f.ID,
		Meta: Meta{
			VersionID:   fmt.Sprintf("%d", f.Version),
			LastUpdated: f.UpdatedAt.UTC().Format(time.RFC3339),
		},
		Identifier: []Identifier{{
			// Namespaced, because a code without a system is a string, and two
			// hospitals' "FAC01" collide the moment anyone aggregates.
			System: SystemPrefix + "facility-code",
			Value:  f.Code,
		}},
		// FHIR's active flag is coarser than the domain's status. An
		// intentional loss: a consumer that needs to distinguish "suspended"
		// from "retired" is asking a question FHIR's Organization cannot
		// express, and inventing an extension for it would put this system's
		// lifecycle into somebody else's standard.
		Active: f.Status == domain.FacilityActive,
		Name:   f.DisplayName,
	}
	coding, mapped := facilityTypeCoding[f.Type]
	if !mapped {
		// Refused rather than emitted without a type. An Organization with no
		// type reads to a consumer as "unclassified", which is a claim, not a
		// gap — and it would be made by this gateway on the domain's behalf.
		return Organization{}, fmt.Errorf("%w: facility type %q has no FHIR coding",
			ErrUnmappable, f.Type)
	}
	org.Type = []CodeableConcept{{Coding: []Coding{coding}}}
	return org, nil
}

// FromOrgUnit renders an organizational unit as a FHIR Location.
//
// Location rather than Organization: a department is a place within a
// provider, and mapping it to Organization would make every ward look like an
// independent legal entity to a consumer.
func FromOrgUnit(u domain.OrgUnit, at time.Time) (Location, error) {
	if strings.TrimSpace(u.ID) == "" || strings.TrimSpace(u.DisplayName) == "" {
		return Location{}, fmt.Errorf("%w: a unit needs an id and a name", ErrUnmappable)
	}

	// FHIR's Location.status has no notion of an effective window, so the
	// window is evaluated here and collapsed to the flag FHIR has. Doing it at
	// the boundary is the point: the domain keeps the dates, and only the
	// projection loses them.
	status := "inactive"
	if u.ActiveAt(at) {
		status = "active"
	}

	loc := Location{
		ResourceType: "Location",
		ID:           u.ID,
		Meta: Meta{
			VersionID:   fmt.Sprintf("%d", u.Version),
			LastUpdated: u.UpdatedAt.UTC().Format(time.RFC3339),
		},
		Identifier: []Identifier{{
			System: SystemPrefix + "org-unit-code",
			Value:  u.Code,
		}},
		Status: status,
		Name:   u.DisplayName,
		Type: []CodeableConcept{{
			Coding: []Coding{{
				System: SystemPrefix + "org-unit-type",
				Code:   string(u.Type),
			}},
		}},
	}
	if u.FacilityID != "" {
		loc.ManagingOrganization = &Reference{Reference: "Organization/" + u.FacilityID}
	}
	return loc, nil
}

// OperationOutcome is FHIR's error representation.
type OperationOutcome struct {
	ResourceType string         `json:"resourceType"`
	Issue        []OutcomeIssue `json:"issue"`
}

// OutcomeIssue is one problem in an OperationOutcome.
type OutcomeIssue struct {
	Severity    string          `json:"severity"`
	Code        string          `json:"code"`
	Details     CodeableConcept `json:"details,omitempty"`
	Diagnostics string          `json:"diagnostics,omitempty"`
}

// errorCodeMapping translates this system's error categories into FHIR issue
// codes.
//
// The mapping loses detail on purpose. FHIR's issue codes are a small closed
// set, and forcing this system's richer codes through them is the price of
// speaking the standard — which is exactly why the internal code is carried
// separately in Details rather than squeezed into Code.
var errorCodeMapping = map[string]string{
	"INVALID_ARGUMENT":    "invalid",
	"UNAUTHENTICATED":     "login",
	"PERMISSION_DENIED":   "forbidden",
	"NOT_FOUND":           "not-found",
	"ALREADY_EXISTS":      "duplicate",
	"FAILED_PRECONDITION": "conflict",
	"RESOURCE_EXHAUSTED":  "throttled",
	"INTERNAL":            "exception",
}

// NewOperationOutcome renders an error as FHIR.
//
// message must already be safe to show a caller: this function does not
// sanitise, because it cannot tell PHI from a code, and a gateway that tried
// would eventually let something through while everyone assumed it had not.
func NewOperationOutcome(category, code, message string) OperationOutcome {
	issueCode, mapped := errorCodeMapping[category]
	if !mapped {
		issueCode = "processing"
	}
	return OperationOutcome{
		ResourceType: "OperationOutcome",
		Issue: []OutcomeIssue{{
			Severity: "error",
			Code:     issueCode,
			Details: CodeableConcept{
				// The internal code travels here rather than in Code, so a
				// support conversation can be precise without this gateway
				// inventing FHIR issue codes that no consumer understands.
				Coding: []Coding{{System: SystemPrefix + "error-code", Code: code}},
			},
			Diagnostics: message,
		}},
	}
}
