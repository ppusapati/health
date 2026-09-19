package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// AuthorityKind is what makes a release lawful (SRS-MRD-004).
type AuthorityKind string

const (
	// AuthorityPatientConsent is the patient's own written authorisation.
	AuthorityPatientConsent AuthorityKind = "patient_consent"
	// AuthorityRepresentative is a parent, guardian or attorney acting for
	// them. Carried apart from the patient's own consent because the
	// representative's standing is the thing that gets checked and the thing
	// that expires.
	AuthorityRepresentative AuthorityKind = "authorised_representative"
	// AuthorityCourtOrder is a summons, a subpoena or a coroner's request.
	AuthorityCourtOrder AuthorityKind = "court_order"
	// AuthorityStatutory is a disclosure the law requires — a notifiable
	// disease, a cancer registry.
	AuthorityStatutory AuthorityKind = "statutory_requirement"
	// AuthorityCareContinuity is a transfer of care to another treating
	// clinician.
	AuthorityCareContinuity AuthorityKind = "continuity_of_care"
	// AuthorityInsurance is a claim the patient has made and authorised.
	AuthorityInsurance AuthorityKind = "insurance_claim"
)

var knownAuthority = map[AuthorityKind]bool{
	AuthorityPatientConsent: true, AuthorityRepresentative: true,
	AuthorityCourtOrder: true, AuthorityStatutory: true,
	AuthorityCareContinuity: true, AuthorityInsurance: true,
}

// Authorisation is the standing on which a record leaves the hospital
// (SRS-MRD-004).
type Authorisation struct {
	Kind AuthorityKind
	// Reference is the consent form, the order number, the statute. Required:
	// a release whose authority cannot be produced later is a release nobody
	// can defend.
	Reference string
	// SignedBy is who gave it, where a person did. Empty for a statutory
	// disclosure, which nobody signs.
	SignedBy string
	SignedAt time.Time
	// ExpiresAt is when the authority stops. Zero never expires, which is
	// correct for a court order and wrong for a consent form; the domain does
	// not guess which, and a deployment that wants consents to expire says so
	// on the form.
	ExpiresAt time.Time
}

// Valid reports an authority that still stands at a moment.
func (a Authorisation) Valid(at time.Time) bool {
	if !knownAuthority[a.Kind] || strings.TrimSpace(a.Reference) == "" {
		return false
	}
	return a.ExpiresAt.IsZero() || a.ExpiresAt.After(at)
}

// RecipientKind is who the record is going to (SRS-MRD-004, SRS-MRD-010).
type RecipientKind string

const (
	RecipientPatient     RecipientKind = "patient"
	RecipientClinician   RecipientKind = "treating_clinician"
	RecipientInstitution RecipientKind = "institution"
	RecipientInsurer     RecipientKind = "insurer"
	RecipientLegal       RecipientKind = "legal"
	RecipientGovernment  RecipientKind = "government_body"
)

var knownRecipient = map[RecipientKind]bool{
	RecipientPatient: true, RecipientClinician: true,
	RecipientInstitution: true, RecipientInsurer: true,
	RecipientLegal: true, RecipientGovernment: true,
}

// Recipient is who receives the record (SRS-MRD-004, SRS-MRD-010).
type Recipient struct {
	Kind RecipientKind
	Name string
	// Reference is the identifier a later enquiry uses — a registration
	// number, a claim number, an address on file. SRS-MRD-010's acceptance
	// requires the audit to carry a recipient reference, and a name alone is
	// not one: three hospitals are called St Mary's.
	Reference string
	// DeliveryMethod is how it went — collected, posted, secure transfer.
	DeliveryMethod string
}

// ReleaseScope is what was asked for (SRS-MRD-004).
//
// Deliberately awkward to leave empty. A scope with no dates, no record
// classes and no document kinds is a request for everything ever recorded
// about a person, and a system where that is the easiest request to make is
// one where it is the request everybody makes.
type ReleaseScope struct {
	// From and To bound the episodes of care in scope.
	From, To time.Time
	// RecordClasses are the classes of record — inpatient, imaging,
	// laboratory. Empty means every class within the other bounds.
	RecordClasses []string
	// DocumentKinds narrows further, to discharge summaries only for
	// instance.
	DocumentKinds []string
	// EncounterIDs pins specific episodes, which is the narrowest and
	// commonest real request: "the admission in March".
	EncounterIDs []string
	// WholeRecord is the deliberate, explicit request for everything. It has
	// to be asked for rather than fallen into by leaving the other fields
	// blank.
	WholeRecord bool
	// ExcludeRestricted holds back the material a hospital does not release
	// without specific authority — psychotherapy notes, third-party
	// information. Defaults to holding it back, so a request has to say it
	// wants that material rather than receiving it by omission.
	IncludeRestricted bool
}

// Bounded reports a scope that says what it wants.
func (s ReleaseScope) Bounded() bool {
	if s.WholeRecord {
		return true
	}
	return !s.From.IsZero() || !s.To.IsZero() ||
		len(s.RecordClasses) > 0 || len(s.DocumentKinds) > 0 ||
		len(s.EncounterIDs) > 0
}

// Covers reports whether an item falls inside the scope.
func (s ReleaseScope) Covers(item ReleaseItem) bool {
	if s.WholeRecord {
		return s.IncludeRestricted || !item.Restricted
	}
	if !s.IncludeRestricted && item.Restricted {
		return false
	}
	if !s.From.IsZero() && !item.OccurredAt.IsZero() &&
		item.OccurredAt.Before(s.From) {
		return false
	}
	if !s.To.IsZero() && !item.OccurredAt.IsZero() &&
		!item.OccurredAt.Before(s.To) {
		return false
	}
	if len(s.EncounterIDs) > 0 && !contains(s.EncounterIDs, item.EncounterID) {
		return false
	}
	if len(s.RecordClasses) > 0 && !contains(s.RecordClasses, item.RecordClass) {
		return false
	}
	if len(s.DocumentKinds) > 0 && !contains(s.DocumentKinds, item.Kind) {
		return false
	}
	return true
}

func contains(values []string, value string) bool {
	for _, one := range values {
		if strings.EqualFold(one, value) {
			return true
		}
	}
	return false
}

// ReleaseItem is one thing in a release package (SRS-MRD-004).
//
// A reference and its provenance, never its content. What is actually sent is
// assembled by whatever renders it; this records exactly which documents left
// the hospital, which is what a later enquiry asks.
type ReleaseItem struct {
	DocumentID  string
	EncounterID string
	Kind        string
	RecordClass string
	OccurredAt  time.Time
	// Restricted marks material a hospital holds back without specific
	// authority.
	Restricted bool
	// Pages is how much of it went, where the hospital counts pages.
	Pages int
}

// ReleaseState is where a request stands.
type ReleaseState string

const (
	ReleaseRequested ReleaseState = "requested"
	// ReleaseApproved has been checked against authority, purpose, scope and
	// recipient, and not yet assembled.
	ReleaseApproved ReleaseState = "approved"
	// ReleaseAssembled has a package and has not left yet.
	ReleaseAssembled ReleaseState = "assembled"
	ReleaseReleased  ReleaseState = "released"
	ReleaseRefused   ReleaseState = "refused"
)

// ReleaseRequest is a request for a patient's record (SRS-MRD-004).
type ReleaseRequest struct {
	ID       string
	TenantID string

	Reference string
	PatientID string

	// Purpose is why. SRS-MRD-004 names it alongside authority, scope and
	// recipient, and it is the one of the four that decides what may be held
	// back: an insurance claim does not need the psychotherapy notes.
	Purpose       string
	Authorisation Authorisation
	Recipient     Recipient
	Scope         ReleaseScope

	State         ReleaseState
	RefusalReason string

	RequestedAt time.Time
	RequestedBy string
	ApprovedAt  time.Time
	ApprovedBy  string

	// Package is what was assembled, once it has been.
	Package *ReleasePackage
	Version int64
}

// ReleasePackage is exactly what left the hospital (SRS-MRD-004).
//
// Retained, which is the requirement's acceptance. Two years later the
// question is never "did we release something" but "what did we release", and
// a release record that lists a scope rather than the items is a record that
// cannot answer it.
type ReleasePackage struct {
	Items []ReleaseItem
	// ContentHash is a digest of what was rendered, supplied by whatever
	// rendered it. Held so a copy produced later can be shown to be the copy
	// that was sent.
	ContentHash string
	Pages       int
	AssembledAt time.Time
	AssembledBy string
	ReleasedAt  time.Time
	ReleasedBy  string
}

// NewReleaseInput asks for a record.
type NewReleaseInput struct {
	Reference     string
	PatientID     string
	Purpose       string
	Authorisation Authorisation
	Recipient     Recipient
	Scope         ReleaseScope
}

// RequestRelease records a request for a patient's record (SRS-MRD-004).
//
// All four of the requirement's conditions are checked here and again at
// approval: authorisation, purpose, scope and recipient. Checking at request
// time is not enough on its own — a consent can expire between the request
// and the release — and checking only at release time means a request sits in
// a queue for three weeks before anybody notices it was never lawful.
func RequestRelease(id, tenantID string, in NewReleaseInput, by string,
	now time.Time) (ReleaseRequest, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ReleaseRequest{}, fmt.Errorf("%w: a request needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(in.PatientID) == "":
		return ReleaseRequest{}, fmt.Errorf("%w: a request names its patient",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Purpose) == "":
		return ReleaseRequest{}, fmt.Errorf(
			"%w: a request says what the record is wanted for",
			ErrInvalidRecord)
	case !knownAuthority[in.Authorisation.Kind]:
		return ReleaseRequest{}, fmt.Errorf(
			"%w: unknown authority %q", ErrInvalidRecord,
			in.Authorisation.Kind)
	case strings.TrimSpace(in.Authorisation.Reference) == "":
		// A release whose authority cannot be produced later is a release
		// nobody can defend.
		return ReleaseRequest{}, fmt.Errorf(
			"%w: name the consent, order or statute this rests on",
			ErrInvalidRecord)
	case !knownRecipient[in.Recipient.Kind]:
		return ReleaseRequest{}, fmt.Errorf("%w: unknown recipient kind %q",
			ErrInvalidRecord, in.Recipient.Kind)
	case strings.TrimSpace(in.Recipient.Name) == "":
		return ReleaseRequest{}, fmt.Errorf("%w: a request names its recipient",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Recipient.Reference) == "":
		// Three hospitals are called St Mary's.
		return ReleaseRequest{}, fmt.Errorf(
			"%w: a recipient needs a reference a later enquiry can use",
			ErrInvalidRecord)
	case !in.Scope.Bounded():
		return ReleaseRequest{}, fmt.Errorf(
			"%w: say what is wanted, or ask for the whole record explicitly",
			ErrInvalidRecord)
	}

	if !in.Scope.From.IsZero() && !in.Scope.To.IsZero() &&
		!in.Scope.To.After(in.Scope.From) {
		return ReleaseRequest{}, fmt.Errorf(
			"%w: a scope's period ends after it starts", ErrInvalidRecord)
	}

	return ReleaseRequest{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference), PatientID: in.PatientID,
		Purpose:       strings.TrimSpace(in.Purpose),
		Authorisation: in.Authorisation, Recipient: in.Recipient,
		Scope: in.Scope, State: ReleaseRequested,
		RequestedAt: now.UTC(), RequestedBy: by, Version: 1,
	}, nil
}

// Approve records the check that the release is lawful (SRS-MRD-004).
//
// Refused for the person who asked. A records officer who requested a release
// on somebody's behalf and then approved it is one person deciding that a
// patient's record leaves the hospital.
func (r *ReleaseRequest) Approve(by string, now time.Time) error {
	switch {
	case r.State != ReleaseRequested:
		return fmt.Errorf("%w: this request is already %s",
			ErrInvalidRecord, r.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidRecord)
	case by == r.RequestedBy:
		return fmt.Errorf(
			"%w: the person who raised a release cannot approve it",
			ErrInvalidRecord)
	case !r.Authorisation.Valid(now):
		// The case a request-time check alone would miss.
		return fmt.Errorf(
			"%w: the authority for this release has expired or is incomplete",
			ErrInvalidRecord)
	}
	r.State = ReleaseApproved
	r.ApprovedAt, r.ApprovedBy = now.UTC(), by
	return nil
}

// Refuse turns a request down (SRS-MRD-004).
func (r *ReleaseRequest) Refuse(reason, by string, now time.Time) error {
	switch {
	case r.State == ReleaseReleased || r.State == ReleaseRefused:
		return fmt.Errorf("%w: this request is already %s",
			ErrInvalidRecord, r.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the release was refused",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a refusal names who made it", ErrInvalidRecord)
	}
	r.State, r.RefusalReason = ReleaseRefused, strings.TrimSpace(reason)
	r.ApprovedAt, r.ApprovedBy = now.UTC(), by
	return nil
}

// Assemble records exactly what was put in the package (SRS-MRD-004).
//
// Every item is checked against the scope. An item outside it is the
// disclosure this requirement exists to prevent — a whole admission attached
// to a request for one discharge summary — and it is refused here rather than
// noticed in a complaint.
func (r *ReleaseRequest) Assemble(items []ReleaseItem, contentHash,
	by string, now time.Time) error {

	switch {
	case r.State != ReleaseApproved:
		return fmt.Errorf("%w: this request is %s and has not been approved",
			ErrInvalidRecord, r.State)
	case len(items) == 0:
		// An empty package released against a consent is a release the
		// patient was told happened and did not.
		return fmt.Errorf("%w: a package with nothing in it is not a release",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: assembly names who did it", ErrInvalidRecord)
	}

	pages := 0
	out := make([]ReleaseItem, 0, len(items))
	seen := map[string]bool{}
	for _, item := range items {
		if strings.TrimSpace(item.DocumentID) == "" {
			return fmt.Errorf("%w: every item in a package names its document",
				ErrInvalidRecord)
		}
		if seen[item.DocumentID] {
			return fmt.Errorf("%w: document %s is in the package twice",
				ErrInvalidRecord, item.DocumentID)
		}
		if !r.Scope.Covers(item) {
			return fmt.Errorf(
				"%w: document %s falls outside the scope this release was "+
					"approved for", ErrInvalidRecord, item.DocumentID)
		}
		seen[item.DocumentID] = true
		pages += item.Pages
		out = append(out, item)
	}

	sort.Slice(out, func(a, b int) bool {
		if out[a].OccurredAt.Equal(out[b].OccurredAt) {
			return out[a].DocumentID < out[b].DocumentID
		}
		return out[a].OccurredAt.Before(out[b].OccurredAt)
	})

	r.State = ReleaseAssembled
	r.Package = &ReleasePackage{
		Items: out, ContentHash: strings.TrimSpace(contentHash),
		Pages: pages, AssembledAt: now.UTC(), AssembledBy: by,
	}
	return nil
}

// Release records the package leaving the hospital (SRS-MRD-004).
//
// The authority is checked once more. A consent that expired while the
// package sat in an out-tray is a consent that expired, and the release is
// the moment the record actually goes.
func (r *ReleaseRequest) Release(by string, now time.Time) error {
	switch {
	case r.State != ReleaseAssembled:
		return fmt.Errorf("%w: this request is %s and has no package",
			ErrInvalidRecord, r.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a release names who made it", ErrInvalidRecord)
	case !r.Authorisation.Valid(now):
		return fmt.Errorf(
			"%w: the authority for this release expired before it went",
			ErrInvalidRecord)
	}
	r.State = ReleaseReleased
	r.Package.ReleasedAt, r.Package.ReleasedBy = now.UTC(), by
	return nil
}

// DisclosureKind is how a record left (SRS-MRD-010).
type DisclosureKind string

const (
	// DisclosureRelease is a formal release under SRS-MRD-004.
	DisclosureRelease DisclosureKind = "release"
	// DisclosureExport is a chart exported or downloaded by a member of
	// staff, which SRS-MRD-010 names alongside releases and which is the more
	// common way a record actually leaves.
	DisclosureExport DisclosureKind = "export"
	DisclosurePrint  DisclosureKind = "print"
)

var knownDisclosureKind = map[DisclosureKind]bool{
	DisclosureRelease: true, DisclosureExport: true, DisclosurePrint: true,
}

// Disclosure is one record of a record leaving (SRS-MRD-010).
//
// Held in this context as well as in the platform audit trail, and the
// duplication is deliberate: the audit trail is an operational record with
// its own retention, and this is the accounting of disclosures a patient is
// entitled to ask for. A patient asking "who has seen my record" is asking
// this question, and answering it by grepping an audit log is not answering
// it.
type Disclosure struct {
	ID       string
	TenantID string

	PatientID string
	Kind      DisclosureKind
	// ReleaseID links a formal release; empty for an export.
	ReleaseID string

	// The four SRS-MRD-010 names, and they are required.
	ActorID            string
	Purpose            string
	ScopeSummary       string
	RecipientReference string
	RecipientName      string

	Items      int
	Pages      int
	OccurredAt time.Time
}

// RecordDisclosure notes a record leaving (SRS-MRD-010).
func RecordDisclosure(id, tenantID, patientID string, kind DisclosureKind,
	releaseID, actorID, purpose, scopeSummary string, recipient Recipient,
	items, pages int, now time.Time) (Disclosure, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Disclosure{}, fmt.Errorf("%w: a disclosure needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(patientID) == "":
		return Disclosure{}, fmt.Errorf("%w: a disclosure names its patient",
			ErrInvalidRecord)
	case !knownDisclosureKind[kind]:
		return Disclosure{}, fmt.Errorf("%w: unknown disclosure kind %q",
			ErrInvalidRecord, kind)
	case strings.TrimSpace(actorID) == "":
		return Disclosure{}, fmt.Errorf("%w: a disclosure names who made it",
			ErrInvalidRecord)
	case strings.TrimSpace(purpose) == "":
		return Disclosure{}, fmt.Errorf("%w: a disclosure names its purpose",
			ErrInvalidRecord)
	case strings.TrimSpace(scopeSummary) == "":
		return Disclosure{}, fmt.Errorf("%w: a disclosure says what left",
			ErrInvalidRecord)
	case strings.TrimSpace(recipient.Reference) == "":
		// SRS-MRD-010's acceptance names the recipient reference
		// specifically, and it is the field a later enquiry starts from.
		return Disclosure{}, fmt.Errorf(
			"%w: a disclosure names a recipient reference", ErrInvalidRecord)
	}

	return Disclosure{
		ID: id, TenantID: tenantID, PatientID: patientID, Kind: kind,
		ReleaseID: releaseID, ActorID: actorID,
		Purpose:            strings.TrimSpace(purpose),
		ScopeSummary:       strings.TrimSpace(scopeSummary),
		RecipientReference: strings.TrimSpace(recipient.Reference),
		RecipientName:      strings.TrimSpace(recipient.Name),
		Items:              items, Pages: pages, OccurredAt: now.UTC(),
	}, nil
}

// ScopeSummary renders a scope in words, for the disclosure accounting.
//
// Words rather than the structure, because the accounting is read by a
// patient and "the admission of 3 March 2026" is an answer where a serialised
// filter is not.
func (s ReleaseScope) ScopeSummary() string {
	if s.WholeRecord {
		if s.IncludeRestricted {
			return "the whole record, including restricted material"
		}
		return "the whole record"
	}

	var parts []string
	if len(s.EncounterIDs) > 0 {
		parts = append(parts, fmt.Sprintf("%d encounter(s)",
			len(s.EncounterIDs)))
	}
	if !s.From.IsZero() || !s.To.IsZero() {
		switch {
		case s.From.IsZero():
			parts = append(parts, "up to "+s.To.Format("2 January 2006"))
		case s.To.IsZero():
			parts = append(parts, "from "+s.From.Format("2 January 2006"))
		default:
			parts = append(parts, s.From.Format("2 January 2006")+" to "+
				s.To.Format("2 January 2006"))
		}
	}
	if len(s.RecordClasses) > 0 {
		parts = append(parts, strings.Join(s.RecordClasses, ", "))
	}
	if len(s.DocumentKinds) > 0 {
		parts = append(parts, strings.Join(s.DocumentKinds, ", "))
	}
	if len(parts) == 0 {
		return "an unstated scope"
	}
	return strings.Join(parts, "; ")
}
