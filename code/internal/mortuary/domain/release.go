package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Release (SRS-MORT-006, SRS-MORT-007).
//
// This is the act the whole context exists to control. A body leaves once,
// and everything wrong with the checks before it shows up afterwards with a
// family in it.
//
// Two things are deliberate here. The checks are computed into a list and
// returned with the refusal rather than the first one being reported and the
// rest discovered one at a time, because a mortuary told "no identity check"
// will do the identity check and come back to be told "no death certificate".
// And the policy is configuration with a floor: a deployment decides whether
// it requires a death certificate before release and how long a body may be
// held, and does not decide whether a medico-legal case needs its authority's
// clearance. "Case cannot bypass required authorization" is not a setting.

// ReleasePolicy is what a deployment has decided about releasing a body
// (SRS-MORT-007).
//
// Every field here makes the checks stricter. There is no field that makes
// them looser than the floor below, which is why the zero value is safe to
// start from: it applies the floor and nothing else.
type ReleasePolicy struct {
	// RequireDeathCertificate refuses a release until the case names the
	// certificate or registration reference. On in most places; off where
	// the certificate follows the body by days and holding it would mean
	// holding the funeral.
	RequireDeathCertificate bool
	// RequireConfirmedIdentity refuses a release on a presumed
	// identification. A hospital that turns this off is one that has
	// decided a wallet is enough, and the status document says so out
	// loud rather than this code deciding for it.
	RequireConfirmedIdentity bool
	// RequireBelongingsSettled refuses a release while the mortuary still
	// holds listed belongings. Off by default: a family collecting the
	// body today and the effects on Thursday is ordinary.
	RequireBelongingsSettled bool
	// RequireRecipientIdentification refuses a release to somebody who
	// produced no document. On in most places.
	RequireRecipientIdentification bool
}

// Authorisation is an external clearance to release (SRS-MORT-006,
// SRS-MORT-007).
//
// Named rather than a boolean, because the question asked afterwards is
// always "who authorised this and under what reference", and a boolean
// answers neither.
type Authorisation struct {
	// Authority is the coroner's court, the police station, the officer.
	Authority string
	// Reference is their own number for the clearance.
	Reference string
	// RecordedBy is the member of staff who took it, and RecordedAt when.
	RecordedBy string
	RecordedAt time.Time
	Note       string
}

// Held reports an authorisation with something in it.
func (a Authorisation) Held() bool {
	return strings.TrimSpace(a.Authority) != "" &&
		strings.TrimSpace(a.Reference) != ""
}

// ReleaseCheck is one thing standing between a case and the door.
type ReleaseCheck struct {
	// Code is stable and machine-readable, so a screen can show the right
	// button beside it rather than matching on a sentence.
	Code string
	// Detail is the sentence a mortuary attendant reads.
	Detail string
	// Mandatory marks a check no policy can switch off (SRS-MORT-007).
	Mandatory bool
}

// The check codes. Stable strings, because a client shows a different action
// for each and matching on the text would break the first time somebody
// improved the wording.
const (
	CheckIdentity         = "identity"
	CheckAuthority        = "authority"
	CheckDeathCertificate = "death_certificate"
	CheckPostmortem       = "postmortem"
	CheckBelongings       = "belongings"
	CheckRecipient        = "recipient"
	CheckAlreadyReleased  = "already_released"
)

// ReleaseInput is who is taking the body and what was checked
// (SRS-MORT-006).
type ReleaseInput struct {
	RecipientName     string
	RecipientRelation string
	RecipientIDType   string
	RecipientIDRef    string
	// VerificationNote is what the mortuary checked and against what. The
	// acceptance asks for verification, and a tick is not one.
	VerificationNote string
	// SignatureRef points at the signed register page.
	SignatureRef string
	// DeathCertificateRef is the certificate or registration number.
	DeathCertificateRef string
	// Destination is where the body is going: a named funeral director, a
	// family, another hospital.
	Destination string
	WitnessedBy string
	Note        string
}

// ReleaseChecks reports everything outstanding (SRS-MORT-006, SRS-MORT-007).
//
// Computed and returned rather than raised one at a time, so a mortuary can
// see the whole list and clear it in one pass.
func ReleaseChecks(c Case, policy ReleasePolicy, auth Authorisation,
	outstanding []Item, blocking []Postmortem,
	in ReleaseInput) []ReleaseCheck {

	var checks []ReleaseCheck

	if c.State == CaseReleased {
		checks = append(checks, ReleaseCheck{
			Code:      CheckAlreadyReleased,
			Detail:    "this case has already been released",
			Mandatory: true,
		})
		return checks
	}

	// The floor. Neither of these is a policy setting: a body an authority
	// has an interest in, and a body nobody has named, both leave only on
	// somebody's written clearance.
	if c.MedicoLegal && !auth.Held() {
		checks = append(checks, ReleaseCheck{
			Code: CheckAuthority,
			Detail: "a medico-legal case is released on the authority's " +
				"clearance, named and referenced",
			Mandatory: true,
		})
	}
	if c.Identity == IdentityUnidentified && !auth.Held() {
		checks = append(checks, ReleaseCheck{
			Code: CheckAuthority,
			Detail: "an unidentified body is released on an authority's " +
				"clearance, named and referenced",
			Mandatory: true,
		})
	}

	// A named recipient and a signature are the record of where the body
	// went, and a release without them is a body that left.
	switch {
	case strings.TrimSpace(in.RecipientName) == "":
		checks = append(checks, ReleaseCheck{
			Code: CheckRecipient, Detail: "name who is taking the body",
			Mandatory: true,
		})
	case strings.TrimSpace(in.SignatureRef) == "":
		checks = append(checks, ReleaseCheck{
			Code:      CheckRecipient,
			Detail:    "record the signature reference for the release",
			Mandatory: true,
		})
	case strings.TrimSpace(in.VerificationNote) == "":
		checks = append(checks, ReleaseCheck{
			Code:      CheckRecipient,
			Detail:    "record what was verified and against what",
			Mandatory: true,
		})
	}

	// An examination that has been asked for and not finished holds the
	// body whatever anybody else has signed.
	if len(blocking) > 0 {
		checks = append(checks, ReleaseCheck{
			Code: CheckPostmortem,
			Detail: fmt.Sprintf(
				"%d postmortem request(s) outstanding", len(blocking)),
			Mandatory: true,
		})
	}

	// And the configured checks.
	if policy.RequireConfirmedIdentity && !c.Identity.Positive() {
		checks = append(checks, ReleaseCheck{
			Code: CheckIdentity,
			Detail: "this deployment releases on a confirmed " +
				"identification; this case is " + string(c.Identity),
		})
	}
	if policy.RequireDeathCertificate &&
		strings.TrimSpace(in.DeathCertificateRef) == "" &&
		strings.TrimSpace(c.DeathCertificateRef) == "" {
		checks = append(checks, ReleaseCheck{
			Code: CheckDeathCertificate,
			Detail: "this deployment requires the death certificate or " +
				"registration reference before release",
		})
	}
	if policy.RequireBelongingsSettled && len(outstanding) > 0 {
		checks = append(checks, ReleaseCheck{
			Code: CheckBelongings,
			Detail: fmt.Sprintf(
				"%d listed belonging(s) still held", len(outstanding)),
		})
	}
	if policy.RequireRecipientIdentification &&
		(strings.TrimSpace(in.RecipientIDType) == "" ||
			strings.TrimSpace(in.RecipientIDRef) == "") {
		checks = append(checks, ReleaseCheck{
			Code: CheckRecipient,
			Detail: "this deployment requires the recipient's " +
				"identification document",
		})
	}

	sort.SliceStable(checks, func(i, j int) bool {
		// Mandatory first: a mortuary clearing the list should clear the
		// ones no policy can waive before the ones somebody might.
		return checks[i].Mandatory && !checks[j].Mandatory
	})
	return checks
}

// Release is the record of a body leaving (SRS-MORT-006).
type Release struct {
	ID       string
	TenantID string
	CaseID   string

	RecipientName     string
	RecipientRelation string
	RecipientIDType   string
	RecipientIDRef    string
	VerificationNote  string
	SignatureRef      string
	Destination       string

	DeathCertificateRef string

	// MedicoLegal is copied from the case and held against it by a
	// composite foreign key, so a release with no authority cannot be
	// written for a case that needs one. See the note at the head of
	// migration 0045.
	MedicoLegal        bool
	Authority          string
	AuthorityReference string

	ReleasedAt  time.Time
	ReleasedBy  string
	WitnessedBy string
	Note        string
}

// ReleaseBody hands the body over and closes the case (SRS-MORT-006,
// SRS-MORT-007).
//
// Every check must be clear. There is no parameter that skips one and no
// method that releases without running them: "case cannot bypass required
// authorization" is a property of there being no other door.
func ReleaseBody(id, tenantID string, c *Case, policy ReleasePolicy,
	auth Authorisation, outstanding []Item, blocking []Postmortem,
	in ReleaseInput, by string, now time.Time) (Release, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Release{}, fmt.Errorf("%w: a release needs an id",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return Release{}, fmt.Errorf("%w: a release names who made it",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.WitnessedBy) == "":
		return Release{}, fmt.Errorf(
			"%w: a release needs a second member of staff present",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.WitnessedBy) == by:
		// One person signing as both is the control not working. A body
		// leaving on one person's word is the case every mortuary
		// inquiry turns out to be about.
		return Release{}, fmt.Errorf(
			"%w: the witness to a release is somebody else",
			ErrInvalidMortuary)
	}

	if checks := ReleaseChecks(*c, policy, auth, outstanding, blocking,
		in); len(checks) > 0 {
		details := make([]string, 0, len(checks))
		for _, check := range checks {
			details = append(details, check.Detail)
		}
		return Release{}, fmt.Errorf("%w: %s", ErrInvalidMortuary,
			strings.Join(details, "; "))
	}

	c.State = CaseReleased
	c.LocationID, c.StorageTag = "", ""

	return Release{
		ID: id, TenantID: tenantID, CaseID: c.ID,
		RecipientName:     strings.TrimSpace(in.RecipientName),
		RecipientRelation: strings.TrimSpace(in.RecipientRelation),
		RecipientIDType:   strings.TrimSpace(in.RecipientIDType),
		RecipientIDRef:    strings.TrimSpace(in.RecipientIDRef),
		VerificationNote:  strings.TrimSpace(in.VerificationNote),
		SignatureRef:      strings.TrimSpace(in.SignatureRef),
		Destination:       strings.TrimSpace(in.Destination),
		DeathCertificateRef: firstNonEmpty(in.DeathCertificateRef,
			c.DeathCertificateRef),
		MedicoLegal:        c.MedicoLegal,
		Authority:          strings.TrimSpace(auth.Authority),
		AuthorityReference: strings.TrimSpace(auth.Reference),
		ReleasedAt:         now.UTC(), ReleasedBy: by,
		WitnessedBy: strings.TrimSpace(in.WitnessedBy),
		Note:        strings.TrimSpace(in.Note),
	}, nil
}

// PendingRelease reports the cases whose checks are clear and which are
// still here (SRS-MORT-008).
//
// The pending-release list the dashboard asks for, and it is computed from
// the checks rather than from a flag: a flag set when the paperwork arrived
// goes stale the moment a coroner takes an interest.
func PendingRelease(cases []Case, policy ReleasePolicy,
	auths map[string]Authorisation, outstanding map[string][]Item,
	blocking map[string][]Postmortem) map[string]bool {

	out := map[string]bool{}
	for _, c := range cases {
		if c.State == CaseReleased {
			continue
		}
		// Checked against a release whose recipient fields are filled,
		// because the question is "is anything left that the mortuary can
		// do", not "has somebody typed the family's name yet".
		checks := ReleaseChecks(c, policy, auths[c.ID], outstanding[c.ID],
			blocking[c.ID], ReleaseInput{
				RecipientName: "pending", SignatureRef: "pending",
				VerificationNote: "pending",
				RecipientIDType:  "pending",
				RecipientIDRef:   "pending",
			})
		if len(checks) == 0 {
			out[c.ID] = true
		}
	}
	return out
}

// firstNonEmpty picks the release's own certificate reference where it was
// given and the case's where it was not. The two are the same document; the
// release records which one it went out against.
func firstNonEmpty(values ...string) string {
	for _, value := range values {
		if trimmed := strings.TrimSpace(value); trimmed != "" {
			return trimmed
		}
	}
	return ""
}
