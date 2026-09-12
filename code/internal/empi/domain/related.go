package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/effective"
)

// Related persons and caregiver authority (SRS-EMPI-009).
//
// The verification clause is "caregiver access honors relationship scope and
// expiry", and both halves are load-bearing in a way that a boolean
// "is_caregiver" flag cannot express.
//
// Scope, because a parent bringing a child to an appointment needs to book and
// to be told the time; they do not automatically need the child's psychiatric
// notes. A relationship that grants everything is one that has to be revoked
// entirely the moment any part of it becomes inappropriate.
//
// Expiry, because the commonest caregiver relationship in a hospital ends on a
// date everybody can predict — a child turns eighteen — and the second
// commonest ends on a date nobody wants to be reminded of. A relationship with
// no end is a standing grant that nobody revisits, and the person who needed
// it in 2019 still has it.

// RelationshipType is how the related person stands to the patient.
type RelationshipType string

const (
	RelationshipParent   RelationshipType = "parent"
	RelationshipGuardian RelationshipType = "guardian"
	RelationshipSpouse   RelationshipType = "spouse"
	RelationshipChild    RelationshipType = "child"
	RelationshipSibling  RelationshipType = "sibling"
	// RelationshipCaregiver is a carer with no family tie — a care-home key
	// worker, a paid attendant.
	RelationshipCaregiver RelationshipType = "caregiver"
	// RelationshipEmergencyContact is somebody to telephone. It carries no
	// authority over the record by default, which is exactly why it is a
	// distinct type rather than a caregiver with an empty scope.
	RelationshipEmergencyContact RelationshipType = "emergency_contact"
)

var knownRelationships = map[RelationshipType]bool{
	RelationshipParent: true, RelationshipGuardian: true, RelationshipSpouse: true,
	RelationshipChild: true, RelationshipSibling: true, RelationshipCaregiver: true,
	RelationshipEmergencyContact: true,
}

// Authority is one thing a related person may do.
type Authority string

const (
	// AuthorityViewDemographics sees who the patient is and how to reach them.
	AuthorityViewDemographics Authority = "view_demographics"
	// AuthorityBookAppointments schedules and cancels on the patient's behalf.
	AuthorityBookAppointments Authority = "book_appointments"
	// AuthorityViewClinical reads the clinical record. Deliberately separate
	// from booking: the parent who brings a child to an appointment needs to
	// book it and to be told the time, and does not by that fact need the
	// child's psychiatric notes.
	AuthorityViewClinical Authority = "view_clinical"
	// AuthorityReceiveResults is sent results directly.
	AuthorityReceiveResults Authority = "receive_results"
	// AuthorityConsent gives consent for treatment. The narrowest grant there
	// is, and the one that most needs an expiry.
	AuthorityConsent Authority = "consent"
)

var knownAuthorities = map[Authority]bool{
	AuthorityViewDemographics: true, AuthorityBookAppointments: true,
	AuthorityViewClinical: true, AuthorityReceiveResults: true, AuthorityConsent: true,
}

// RelatedPerson is one relationship, effective-dated and scoped.
type RelatedPerson struct {
	ID        string
	PatientID string

	// RelatedPatientID links to another record in this index, when the related
	// person is themselves a patient — which a parent usually is.
	RelatedPatientID string
	// Name and Contact describe a related person who is not a patient here. A
	// care-home key worker will never have a record of their own, and refusing
	// to store them would push staff to write the name in a free-text note.
	Name    HumanName
	Contact []ContactPoint

	Relationship RelationshipType
	// Authorities is what this person may do. Empty is legitimate and common:
	// an emergency contact is somebody to telephone, not somebody with rights
	// over the record.
	Authorities []Authority
	Window      effective.Window

	// VerifiedBy and VerifiedAt record who checked the claim. An unverified
	// relationship carries no authority — see AuthorityAt — because "I am her
	// son" is a sentence anybody can say at a reception desk.
	VerifiedBy string
	VerifiedAt *time.Time
	// VerificationNote says what was seen: a birth certificate, a court order.
	VerificationNote string

	RecordedBy string
	RecordedAt time.Time
}

// NewRelatedPerson validates and constructs a relationship.
func NewRelatedPerson(id, patientID string, relationship RelationshipType,
	authorities []Authority, window effective.Window, recordedBy string,
	now time.Time) (RelatedPerson, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return RelatedPerson{}, fmt.Errorf("%w: id is required", ErrInvalidPatient)
	case strings.TrimSpace(patientID) == "":
		return RelatedPerson{}, fmt.Errorf("%w: a relationship needs a patient", ErrInvalidPatient)
	case !knownRelationships[relationship]:
		return RelatedPerson{}, fmt.Errorf("%w: unknown relationship %q", ErrInvalidPatient, relationship)
	case strings.TrimSpace(recordedBy) == "":
		return RelatedPerson{}, fmt.Errorf("%w: a relationship needs an actor", ErrInvalidPatient)
	}

	seen := map[Authority]bool{}
	normalised := make([]Authority, 0, len(authorities))
	for _, a := range authorities {
		if !knownAuthorities[a] {
			return RelatedPerson{}, fmt.Errorf("%w: unknown authority %q", ErrInvalidPatient, a)
		}
		if seen[a] {
			continue
		}
		seen[a] = true
		normalised = append(normalised, a)
	}
	sort.Slice(normalised, func(i, j int) bool { return normalised[i] < normalised[j] })

	// An emergency contact is somebody to telephone. Granting them authority
	// over the record means the relationship was mis-typed, and the fix is to
	// record the right one rather than to quietly widen this.
	if relationship == RelationshipEmergencyContact && len(normalised) > 0 {
		return RelatedPerson{}, fmt.Errorf(
			"%w: an emergency contact carries no authority over the record; record a guardian or caregiver instead",
			ErrInvalidPatient)
	}

	if err := window.Validate(); err != nil {
		return RelatedPerson{}, fmt.Errorf("%w: %v", ErrInvalidPatient, err)
	}

	return RelatedPerson{
		ID: id, PatientID: patientID,
		Relationship: relationship, Authorities: normalised, Window: window,
		RecordedBy: recordedBy, RecordedAt: now.UTC(),
	}, nil
}

// Identify sets who the related person is.
//
// Either a patient in this index or a name and a way to reach them. Refusing
// both is what stops a relationship row that names nobody.
func (r *RelatedPerson) Identify(relatedPatientID string, name HumanName, contact []ContactPoint) error {
	if strings.TrimSpace(relatedPatientID) == "" && name.IsEmpty() {
		return fmt.Errorf("%w: a relationship needs either a linked patient or a name", ErrInvalidPatient)
	}
	r.RelatedPatientID = strings.TrimSpace(relatedPatientID)
	r.Name = HumanName{
		Family: normaliseText(name.Family),
		Given:  normaliseGiven(name.Given),
		Prefix: normaliseText(name.Prefix),
		Suffix: normaliseText(name.Suffix),
	}

	normalised, err := Demographics{Phones: contact}.Normalise()
	if err != nil {
		return err
	}
	r.Contact = normalised.Phones
	return nil
}

// Verify records that somebody checked the claim.
func (r *RelatedPerson) Verify(by, note string, now time.Time) error {
	switch {
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: verification needs an actor", ErrInvalidPatient)
	case strings.TrimSpace(note) == "":
		// What was seen, not merely that something was. "Birth certificate" and
		// "she said so" are both verifications and only one of them holds up.
		return fmt.Errorf("%w: verification needs to say what was checked", ErrInvalidPatient)
	}
	at := now.UTC()
	r.VerifiedBy = by
	r.VerifiedAt = &at
	r.VerificationNote = normaliseText(note)
	return nil
}

// IsVerified reports whether the claim was checked.
func (r RelatedPerson) IsVerified() bool { return r.VerifiedAt != nil }

// AuthorityAt returns what this person may do at an instant.
//
// Three conditions, all required, and the first is the one most easily
// forgotten: an unverified relationship carries nothing. "I am her son" is a
// sentence anybody can say at a reception desk, and a system that grants access
// on the strength of it has no access control at all — it has a form.
func (r RelatedPerson) AuthorityAt(at time.Time) []Authority {
	if !r.IsVerified() {
		return nil
	}
	if !r.Window.Contains(at) {
		return nil
	}
	out := make([]Authority, len(r.Authorities))
	copy(out, r.Authorities)
	return out
}

// Permits reports whether this person may do one thing at an instant.
func (r RelatedPerson) Permits(a Authority, at time.Time) bool {
	for _, granted := range r.AuthorityAt(at) {
		if granted == a {
			return true
		}
	}
	return false
}

// RelatedPersonSet is a patient's relationships.
type RelatedPersonSet []RelatedPerson

// AuthorityFor returns what a related patient may do, at an instant.
//
// The union across every relationship they hold with this patient. A person can
// be both a parent and a nominated caregiver, and the narrower of the two must
// not silently cancel the wider.
func (s RelatedPersonSet) AuthorityFor(relatedPatientID string, at time.Time) []Authority {
	granted := map[Authority]bool{}
	for _, r := range s {
		if r.RelatedPatientID != relatedPatientID || relatedPatientID == "" {
			continue
		}
		for _, a := range r.AuthorityAt(at) {
			granted[a] = true
		}
	}

	out := make([]Authority, 0, len(granted))
	for a := range granted {
		out = append(out, a)
	}
	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}

// InForceAt returns the relationships that apply at an instant.
func (s RelatedPersonSet) InForceAt(at time.Time) RelatedPersonSet {
	out := make(RelatedPersonSet, 0, len(s))
	for _, r := range s {
		if r.Window.Contains(at) {
			out = append(out, r)
		}
	}
	return out
}
