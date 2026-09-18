package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// DeferralKind is how long a donor may not give (SRS-BLD-002).
type DeferralKind string

const (
	DeferralNone DeferralKind = ""
	// DeferralTemporary ends on a date — a recent tattoo, a low haemoglobin,
	// a trip somewhere with malaria.
	DeferralTemporary DeferralKind = "temporary"
	// DeferralPermanent does not. A donor deferred permanently who later
	// donates is the failure this whole record exists to prevent.
	DeferralPermanent DeferralKind = "permanent"
)

var knownDeferrals = map[DeferralKind]bool{
	DeferralTemporary: true, DeferralPermanent: true,
}

// Donor is somebody who gives blood (SRS-BLD-001, SRS-BLD-002).
type Donor struct {
	ID       string
	TenantID string

	// DonorNumber is the deployment's own identifier for the donor, unique
	// within its configured scope.
	DonorNumber string
	// PatientID links a donor who is also a patient here, for the autologous
	// and directed-donation cases. Empty for a volunteer who is not.
	PatientID string

	Name         string
	BirthDate    time.Time
	ContactPhone string
	Group        Group

	// Deferral is the current deferral, if any.
	Deferral     DeferralKind
	DeferralCode string
	DeferralNote string
	DeferredAt   time.Time
	DeferredBy   string
	// DeferredUntil bounds a temporary deferral. Zero on a permanent one,
	// which is what makes the two distinguishable without reading the kind.
	DeferredUntil time.Time

	RegisteredAt time.Time
	RegisteredBy string
	Version      int64
}

// NewDonorInput registers a donor.
type NewDonorInput struct {
	DonorNumber  string
	PatientID    string
	Name         string
	BirthDate    time.Time
	ContactPhone string
	Group        Group
}

// NewDonor registers a donor (SRS-BLD-001).
func NewDonor(id, tenantID string, in NewDonorInput, by string, now time.Time) (
	Donor, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Donor{}, fmt.Errorf("%w: a donor needs an id", ErrInvalidUnit)
	case strings.TrimSpace(in.DonorNumber) == "":
		return Donor{}, fmt.Errorf("%w: a donor needs a donor number", ErrInvalidUnit)
	case strings.TrimSpace(in.Name) == "":
		return Donor{}, fmt.Errorf("%w: a donor record names the donor",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Donor{}, fmt.Errorf("%w: a donor record names who registered it",
			ErrInvalidUnit)
	}

	// The group may be unknown at registration: it is determined from the
	// first donation. Unlike a component, a donor with no group is an ordinary
	// state, and every compatibility check reads the component's group rather
	// than this one.
	return Donor{
		ID: id, TenantID: tenantID,
		DonorNumber:  strings.TrimSpace(in.DonorNumber),
		PatientID:    strings.TrimSpace(in.PatientID),
		Name:         strings.TrimSpace(in.Name),
		BirthDate:    in.BirthDate.UTC(),
		ContactPhone: strings.TrimSpace(in.ContactPhone),
		Group:        in.Group,
		RegisteredAt: now.UTC(), RegisteredBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Defer records a deferral (SRS-BLD-002).
func (d *Donor) Defer(kind DeferralKind, code, note string, until time.Time,
	by string, now time.Time) error {

	switch {
	case !knownDeferrals[kind]:
		return fmt.Errorf("%w: unknown deferral %q", ErrInvalidUnit, kind)
	case strings.TrimSpace(code) == "":
		// Coded, because a deferral list nobody can group is a deferral list
		// nobody reviews — and a donor deferred in error stays deferred.
		return fmt.Errorf("%w: a deferral records a reason code", ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a deferral names who made it", ErrInvalidUnit)
	case kind == DeferralTemporary && until.IsZero():
		// A temporary deferral with no end is a permanent one nobody meant to
		// make, and the donor is lost.
		return fmt.Errorf("%w: a temporary deferral says when it ends", ErrInvalidUnit)
	case kind == DeferralTemporary && !until.After(now):
		return fmt.Errorf("%w: a temporary deferral ends in the future",
			ErrInvalidUnit)
	}

	d.Deferral, d.DeferralCode = kind, strings.TrimSpace(code)
	d.DeferralNote = strings.TrimSpace(note)
	d.DeferredAt, d.DeferredBy = now.UTC(), strings.TrimSpace(by)
	if kind == DeferralTemporary {
		d.DeferredUntil = until.UTC()
	} else {
		d.DeferredUntil = time.Time{}
	}
	return nil
}

// Deferred reports whether the donor may not give at this moment.
//
// A temporary deferral lapses on its own date rather than needing somebody to
// clear it: a donor still deferred because nobody ran a job is a donor turned
// away for no reason.
func (d Donor) Deferred(now time.Time) bool {
	switch d.Deferral {
	case DeferralPermanent:
		return true
	case DeferralTemporary:
		return now.Before(d.DeferredUntil)
	default:
		return false
	}
}

// Reinstate lifts a deferral early (SRS-BLD-002).
//
// The requirement's clause is "deferred donor cannot proceed unless
// policy-authorized correction", so this exists and is deliberately narrow: a
// permanent deferral is not lifted here. Reversing one is a medical decision
// about a donor who was told they could never give again, and a screen that
// let a receptionist do it would be used.
func (d *Donor) Reinstate(reason, by string, now time.Time) error {
	switch {
	case d.Deferral == DeferralNone:
		return fmt.Errorf("%w: this donor is not deferred", ErrInvalidUnit)
	case d.Deferral == DeferralPermanent:
		return fmt.Errorf(
			"%w: a permanent deferral is not lifted here; it is reviewed and "+
				"replaced by a new decision", ErrInvalidUnit)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: lifting a deferral records why", ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: lifting a deferral names who did it", ErrInvalidUnit)
	}

	d.Deferral, d.DeferralCode = DeferralNone, ""
	d.DeferralNote = strings.TrimSpace(reason)
	d.DeferredUntil = time.Time{}
	d.DeferredAt, d.DeferredBy = now.UTC(), strings.TrimSpace(by)
	return nil
}

// Screening is one donor screening episode (SRS-BLD-002).
type Screening struct {
	ID       string
	TenantID string
	DonorID  string

	// Answers are the questionnaire responses, kept as given rather than
	// reduced to a verdict: the verdict is what somebody decided, and the
	// answers are what the donor said.
	Answers map[string]string
	// Measurements are the bedside ones — haemoglobin, blood pressure, weight.
	Measurements map[string]float64

	// Consent is required before a collection, and its absence is not a
	// deferral: an unconsented donor is not somebody who may not give, it is
	// somebody nobody has asked.
	Consented   bool
	ConsentNote string

	// Accepted is the screener's conclusion.
	Accepted bool
	// Outcome holds the deferral the screening produced, if any, so the
	// screening record explains itself without joining to the donor.
	Deferral     DeferralKind
	DeferralCode string

	ScreenedAt time.Time
	ScreenedBy string
}

// NewScreeningInput is one screening episode.
type NewScreeningInput struct {
	DonorID      string
	Answers      map[string]string
	Measurements map[string]float64
	Consented    bool
	ConsentNote  string
	Accepted     bool
	Deferral     DeferralKind
	DeferralCode string
}

// Screen records a donor screening (SRS-BLD-002).
func Screen(id, tenantID string, in NewScreeningInput, by string,
	now time.Time) (Screening, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.DonorID) == "":
		return Screening{}, fmt.Errorf("%w: a screening belongs to a donor",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Screening{}, fmt.Errorf("%w: a screening names who made it",
			ErrInvalidUnit)
	case in.Accepted && !in.Consented:
		// Accepting an unconsented donor is the one combination that must not
		// be recordable: the collection that follows would be a procedure
		// nobody agreed to.
		return Screening{}, fmt.Errorf(
			"%w: a donor cannot be accepted without recorded consent",
			ErrInvalidUnit)
	case in.Accepted && in.Deferral != DeferralNone:
		return Screening{}, fmt.Errorf(
			"%w: a donor is accepted or deferred, not both", ErrInvalidUnit)
	case !in.Accepted && in.Deferral != DeferralNone && !knownDeferrals[in.Deferral]:
		return Screening{}, fmt.Errorf("%w: unknown deferral %q",
			ErrInvalidUnit, in.Deferral)
	}

	answers := map[string]string{}
	for key, value := range in.Answers {
		answers[key] = value
	}
	measurements := map[string]float64{}
	for key, value := range in.Measurements {
		measurements[key] = value
	}

	return Screening{
		ID: id, TenantID: tenantID, DonorID: strings.TrimSpace(in.DonorID),
		Answers: answers, Measurements: measurements,
		Consented: in.Consented, ConsentNote: strings.TrimSpace(in.ConsentNote),
		Accepted: in.Accepted,
		Deferral: in.Deferral, DeferralCode: strings.TrimSpace(in.DeferralCode),
		ScreenedAt: now.UTC(), ScreenedBy: strings.TrimSpace(by),
	}, nil
}

// Collection is one donation (SRS-BLD-003).
type Collection struct {
	ID       string
	TenantID string
	DonorID  string
	// ScreeningID is the screening that permitted it. Required, because
	// "deferred donor cannot proceed" is only enforceable if the collection
	// names the decision that let it happen.
	ScreeningID string

	// DonationNumber is the identifier the components inherit as their parent.
	DonationNumber string
	Kind           string
	VolumeML       int
	Group          Group

	CollectedAt time.Time
	CollectedBy string
	// AdverseEvent records a donor reaction — a faint, a haematoma. Free text
	// beside a flag, because the flag is what a report counts and the text is
	// what the next screener reads.
	AdverseEvent bool
	AdverseNote  string
}

// NewCollectionInput is one donation.
type NewCollectionInput struct {
	DonorID        string
	ScreeningID    string
	DonationNumber string
	Kind           string
	VolumeML       int
	Group          Group
	AdverseEvent   bool
	AdverseNote    string
}

// Collect records a donation (SRS-BLD-002, SRS-BLD-003).
//
// The donor and the screening are both passed in so the rule that matters can
// be checked here rather than in a service: a deferred donor does not donate,
// and an unaccepted screening does not authorise one.
func Collect(id, tenantID string, in NewCollectionInput, donor Donor,
	screening Screening, by string, now time.Time) (Collection, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Collection{}, fmt.Errorf("%w: a collection needs an id", ErrInvalidUnit)
	case strings.TrimSpace(in.DonationNumber) == "":
		return Collection{}, fmt.Errorf(
			"%w: a collection needs a donation number; every component made "+
				"from it inherits it", ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Collection{}, fmt.Errorf("%w: a collection names who took it",
			ErrInvalidUnit)
	case screening.DonorID != donor.ID:
		return Collection{}, fmt.Errorf(
			"%w: that screening belongs to a different donor", ErrInvalidUnit)
	case !screening.Accepted:
		return Collection{}, fmt.Errorf(
			"%w: this donor was not accepted at screening", ErrInvalidUnit)
	case !screening.Consented:
		return Collection{}, fmt.Errorf("%w: this donor did not consent",
			ErrInvalidUnit)
	case donor.Deferred(now):
		return Collection{}, fmt.Errorf("%w: this donor is deferred (%s, %s)",
			ErrInvalidUnit, donor.Deferral, donor.DeferralCode)
	case in.VolumeML <= 0:
		return Collection{}, fmt.Errorf("%w: a collection records its volume",
			ErrInvalidUnit)
	}

	group := in.Group
	if !group.Known() {
		// Fall back to the donor's known group, which is the ordinary case for
		// a repeat donor. Still allowed to be unknown for a first donation:
		// the group is determined by testing, and the components made from
		// this collection cannot be created until it is.
		group = donor.Group
	}

	return Collection{
		ID: id, TenantID: tenantID, DonorID: donor.ID,
		ScreeningID:    screening.ID,
		DonationNumber: strings.TrimSpace(in.DonationNumber),
		Kind:           strings.TrimSpace(in.Kind),
		VolumeML:       in.VolumeML, Group: group,
		CollectedAt: now.UTC(), CollectedBy: strings.TrimSpace(by),
		AdverseEvent: in.AdverseEvent,
		AdverseNote:  strings.TrimSpace(in.AdverseNote),
	}, nil
}

// TestResult is one mandatory test on a collection (SRS-BLD-004).
type TestResult struct {
	ID       string
	TenantID string
	// CollectionID rather than component: the tests are run on the donation,
	// and every component made from it inherits the outcome.
	CollectionID string

	Code    string
	Display string
	// Reactive is the result that matters. Named for what the test says rather
	// than "positive"/"negative", because a screening assay is reactive and a
	// confirmatory one is positive, and conflating them discards good blood.
	Reactive bool
	Value    string
	Method   string

	TestedAt time.Time
	TestedBy string
}

// MandatoryTests is the set a deployment requires before release.
//
// Configured rather than fixed: the mandatory panel is set by national
// regulation and differs between them. Empty means nothing is checked, which
// ReleaseDecision treats as a configuration error rather than as a pass — a
// panel nobody configured must not release every unit.
type MandatoryTests []string

// ReleaseDecision is whether a collection's components may leave quarantine
// (SRS-BLD-004).
type ReleaseDecision struct {
	Releasable bool
	// Missing are the mandatory tests with no result. Named, so a scientist
	// chasing a unit knows which assay to run rather than that "testing is
	// incomplete".
	Missing []string
	// Reactive are the tests that came back reactive. A unit with any of these
	// is not released, and the discard reason is coded to say so.
	Reactive []string
}

// EvaluateRelease decides whether a collection's components may be released
// (SRS-BLD-004).
func EvaluateRelease(panel MandatoryTests, results []TestResult) ReleaseDecision {
	out := ReleaseDecision{}

	if len(panel) == 0 {
		// A deployment that has configured no mandatory panel has not decided
		// what it tests for, and releasing everything would be the wrong
		// reading of that silence.
		out.Missing = append(out.Missing, "no mandatory test panel is configured")
		return out
	}

	latest := map[string]TestResult{}
	for _, result := range results {
		previous, seen := latest[result.Code]
		if !seen || result.TestedAt.After(previous.TestedAt) {
			latest[result.Code] = result
		}
	}

	for _, code := range panel {
		result, ok := latest[code]
		if !ok {
			out.Missing = append(out.Missing, code)
			continue
		}
		if result.Reactive {
			out.Reactive = append(out.Reactive, code)
		}
	}

	sort.Strings(out.Missing)
	sort.Strings(out.Reactive)
	out.Releasable = len(out.Missing) == 0 && len(out.Reactive) == 0
	return out
}
