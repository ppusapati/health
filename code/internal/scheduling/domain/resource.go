// Package domain holds the scheduling rules: who can be booked, when, and what
// happens to the booking afterwards.
//
// The bounded context is "scheduling" (Master Engineering Registry). It owns
// availability, appointments and the queue; it does not own who the clinician
// is, what the encounter records, or what the visit costs. Those are
// identity_access, SRS-ENC and SRS-BIL, and the seams between them are ports
// rather than shared tables.
package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Bookable resources (SRS-SCH-001, SRS-SCH-014).
//
// A clinician and an operating theatre are the same thing to a diary: something
// with finite time that two people cannot have at once. Modelling them as one
// type is not a shortcut — a schedule that could attach only to a person could
// not express "this MRI scanner, forty minutes, one patient at a time", and a
// hospital's scarcest resources are usually not people.
//
// What this deliberately is NOT is a practitioner master. A clinician's
// registration number, credentials, privileges and employment belong to an HR
// and credentialing context that Wave 1 does not build. SubjectID is the seam:
// it names the identity the roster is for, and everything else about that
// person is somebody else's record.

// ErrInvalidResource reports a resource that must not be stored.
var ErrInvalidResource = errors.New("scheduling: invalid resource")

// ErrInvalidSchedule reports a schedule that must not be stored.
var ErrInvalidSchedule = errors.New("scheduling: invalid schedule")

// ResourceType is what kind of thing is being booked.
type ResourceType string

const (
	// ResourcePractitioner is a person who sees patients.
	ResourcePractitioner ResourceType = "practitioner"
	// ResourceRoom is a consulting room, theatre or bay.
	ResourceRoom ResourceType = "room"
	// ResourceEquipment is a scanner, a chair, a machine.
	ResourceEquipment ResourceType = "equipment"
)

var knownResourceTypes = map[ResourceType]bool{
	ResourcePractitioner: true, ResourceRoom: true, ResourceEquipment: true,
}

// ResourceStatus is whether a resource can currently be booked.
type ResourceStatus string

const (
	ResourceActive ResourceStatus = "active"
	// ResourceInactive has left, is out of service, or is not yet in service.
	// Its past appointments stay: a clinician who has retired still saw the
	// patients they saw.
	ResourceInactive ResourceStatus = "inactive"
)

// Resource is something a patient can be booked with.
type Resource struct {
	ID         string
	TenantID   string
	FacilityID string
	// OrgUnitID is the department or specialty. Used for the "search by
	// specialty" half of SRS-SCH-003, which is how a patient books without
	// knowing a clinician's name.
	OrgUnitID string
	Type      ResourceType
	// SubjectID names the identity a practitioner resource belongs to. Empty
	// for a room or a machine, which are nobody.
	SubjectID   string
	DisplayName string
	Status      ResourceStatus
	// TimeZone is the facility's, carried here so slot generation does not
	// need a second lookup per resource. A diary is written in local time and
	// nothing else makes sense to the people reading it.
	TimeZone  string
	CreatedAt time.Time
	UpdatedAt time.Time
}

const maxNameLength = 200

// NewResource validates and constructs a bookable resource.
func NewResource(id, tenantID, facilityID, orgUnitID string, t ResourceType,
	subjectID, displayName, timeZone string, now time.Time) (Resource, error) {

	displayName = strings.TrimSpace(displayName)

	switch {
	case strings.TrimSpace(id) == "":
		return Resource{}, fmt.Errorf("%w: resource id is required", ErrInvalidResource)
	case strings.TrimSpace(tenantID) == "":
		return Resource{}, fmt.Errorf("%w: a resource needs a tenant", ErrInvalidResource)
	case strings.TrimSpace(facilityID) == "":
		// A resource belongs to a building. "Available somewhere in the group"
		// is not something a patient can turn up to.
		return Resource{}, fmt.Errorf("%w: a resource needs a facility", ErrInvalidResource)
	case !knownResourceTypes[t]:
		return Resource{}, fmt.Errorf("%w: unknown resource type %q", ErrInvalidResource, t)
	case displayName == "":
		return Resource{}, fmt.Errorf("%w: a resource needs a name staff can recognise",
			ErrInvalidResource)
	case len(displayName) > maxNameLength:
		return Resource{}, fmt.Errorf("%w: the resource name is too long", ErrInvalidResource)
	case t == ResourcePractitioner && strings.TrimSpace(subjectID) == "":
		// Without it, a clinician's diary cannot be tied to the clinician, and
		// "my appointments" has no answer.
		return Resource{}, fmt.Errorf("%w: a practitioner resource must name the identity it is for",
			ErrInvalidResource)
	case t != ResourcePractitioner && strings.TrimSpace(subjectID) != "":
		// A room is nobody. Letting it carry a subject would make "my
		// appointments" return a corridor.
		return Resource{}, fmt.Errorf("%w: only a practitioner resource has a subject",
			ErrInvalidResource)
	}

	if _, err := time.LoadLocation(timeZone); err != nil {
		// Checked at construction rather than at slot generation: a roster
		// stored with an unloadable zone fails months later, on the day
		// somebody tries to book into it.
		return Resource{}, fmt.Errorf("%w: %q is not a time zone this system knows",
			ErrInvalidResource, timeZone)
	}

	return Resource{
		ID: id, TenantID: tenantID, FacilityID: facilityID, OrgUnitID: orgUnitID,
		Type: t, SubjectID: subjectID, DisplayName: displayName,
		Status: ResourceActive, TimeZone: timeZone,
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// Bookable reports whether new appointments may be made against this resource.
func (r Resource) Bookable() bool { return r.Status == ResourceActive }

// ErrNotBookable reports an attempt to book something out of service
// (SRS-SCH-014).
//
// A distinct type because the requirement asks for "a domain-specific
// unavailability error": a client that cannot tell "this clinician has left"
// from "the server is busy" retries the first forever.
type ErrNotBookable struct {
	// What is unavailable, and which one. Named so a UI can say "Dr Rao is no
	// longer taking appointments" rather than "booking failed".
	Kind string
	ID   string
	Why  string
}

func (e ErrNotBookable) Error() string {
	return fmt.Sprintf("scheduling: %s %s cannot be booked: %s", e.Kind, e.ID, e.Why)
}
