package domain

import (
	"fmt"
	"regexp"
	"strings"
	"time"
)

// Demographics is the identity information the index matches on.
//
// Normalisation lives here rather than at the edge because the same rules have
// to apply to a form submission, a bulk import and an HL7 feed. A name
// normalised on one path and not another produces two records for one person,
// which is precisely the failure the index exists to prevent.

// Sex is administrative sex, recorded for identification and clinical safety.
//
// Deliberately not named Gender and deliberately a small closed set: this is
// the field a lab uses to pick a reference range, and it is not the field that
// records how a person identifies. Gender identity is a clinical observation
// with its own history and belongs in SRS-CLN, not in the identity index.
type Sex string

const (
	SexUnknown Sex = "unknown"
	SexFemale  Sex = "female"
	SexMale    Sex = "male"
	// SexOther covers intersex and non-binary administrative records where a
	// jurisdiction provides for them.
	SexOther Sex = "other"
)

var knownSexes = map[Sex]bool{
	SexUnknown: true, SexFemale: true, SexMale: true, SexOther: true,
}

// BirthDate carries the precision it was captured at.
//
// "Approximately 40 years old" is what an emergency department has for an
// unconscious patient, and storing it as 1 January of the implied year would
// be a false precision the matcher then treats as a strong signal. So the
// precision travels with the value and the matcher weights it accordingly.
type BirthDate struct {
	// Date is the value. Zero means not recorded.
	Date time.Time
	// Precision says how much of Date is real.
	Precision DatePrecision
}

// DatePrecision is how exactly a birth date is known.
type DatePrecision string

const (
	PrecisionNone  DatePrecision = ""
	PrecisionDay   DatePrecision = "day"
	PrecisionMonth DatePrecision = "month"
	PrecisionYear  DatePrecision = "year"
	// PrecisionEstimated is a date derived from a stated age. It is the
	// weakest signal a matcher can be given and must never be treated as a
	// day-precision date that happens to be round.
	PrecisionEstimated DatePrecision = "estimated"
)

// IsZero reports an unrecorded birth date.
//
// The date alone decides, deliberately. Treating a missing precision as "not
// recorded" would let a date a clerk typed disappear silently instead of being
// refused, which is the worse of the two failures: the clerk believes it was
// captured.
func (b BirthDate) IsZero() bool { return b.Date.IsZero() }

// HumanName is one name a patient is known by.
type HumanName struct {
	// Family is the surname. Some cultures record no family name at all, so
	// this is not universally required — the demographic policy decides.
	Family string
	// Given holds forenames in order.
	Given  []string
	Prefix string
	Suffix string
}

// Display renders the name for a banner or a worklist.
func (n HumanName) Display() string {
	parts := make([]string, 0, len(n.Given)+2)
	if n.Prefix != "" {
		parts = append(parts, n.Prefix)
	}
	parts = append(parts, n.Given...)
	if n.Family != "" {
		parts = append(parts, n.Family)
	}
	if n.Suffix != "" {
		parts = append(parts, n.Suffix)
	}
	return strings.Join(parts, " ")
}

// IsEmpty reports a name with nothing in it.
func (n HumanName) IsEmpty() bool {
	if strings.TrimSpace(n.Family) != "" {
		return false
	}
	for _, g := range n.Given {
		if strings.TrimSpace(g) != "" {
			return false
		}
	}
	return true
}

// ContactPoint is a phone number or email address.
type ContactPoint struct {
	System ContactSystem
	Value  string
	// Use distinguishes a mobile a patient answers from a landline at an
	// address they left, which matters both for contacting them and for
	// matching.
	Use string
}

// ContactSystem is the kind of contact point.
type ContactSystem string

const (
	ContactPhone ContactSystem = "phone"
	ContactEmail ContactSystem = "email"
)

// Address is a postal address.
type Address struct {
	Lines      []string
	City       string
	District   string
	State      string
	PostalCode string
	// Country is ISO 3166-1 alpha-2.
	Country string
}

// IsEmpty reports an address with nothing in it.
func (a Address) IsEmpty() bool {
	for _, l := range a.Lines {
		if strings.TrimSpace(l) != "" {
			return false
		}
	}
	return strings.TrimSpace(a.City) == "" && strings.TrimSpace(a.PostalCode) == ""
}

// Demographics is the identity payload.
type Demographics struct {
	Name      HumanName
	BirthDate BirthDate
	Sex       Sex
	Phones    []ContactPoint
	Emails    []ContactPoint
	Addresses []Address
}

// Limits on collection sizes. A patient with four hundred phone numbers is a
// bad import, not a well-connected person, and the matcher would compare every
// one of them.
const (
	MaxContactPoints = 10
	MaxAddresses     = 5
	MaxGivenNames    = 5
	maxFieldLength   = 200
)

var (
	// nonDigits strips formatting from a phone number. Matching on "+91 98765
	// 43210" and "09876543210" as different values is how one person becomes
	// two records.
	nonDigits = regexp.MustCompile(`\D`)
	// collapseSpace turns any run of whitespace into one space, so "John  Smith"
	// and "John Smith" are the same name.
	collapseSpace = regexp.MustCompile(`\s+`)
)

// Normalise canonicalises the demographics and rejects what cannot be stored.
//
// Returns a copy: normalising in place would let a caller observe its own input
// change under it, which is the kind of surprise that produces a bug report
// three layers away.
func (d Demographics) Normalise() (Demographics, error) {
	out := Demographics{
		Name: HumanName{
			Family: normaliseText(d.Name.Family),
			Prefix: normaliseText(d.Name.Prefix),
			Suffix: normaliseText(d.Name.Suffix),
		},
		BirthDate: d.BirthDate,
		Sex:       d.Sex,
	}

	if out.Sex == "" {
		out.Sex = SexUnknown
	}
	if !knownSexes[out.Sex] {
		return Demographics{}, fmt.Errorf("%w: unknown sex %q", ErrInvalidPatient, d.Sex)
	}

	if len(d.Name.Given) > MaxGivenNames {
		return Demographics{}, fmt.Errorf("%w: at most %d given names", ErrInvalidPatient, MaxGivenNames)
	}
	for _, g := range d.Name.Given {
		if trimmed := normaliseText(g); trimmed != "" {
			out.Name.Given = append(out.Name.Given, trimmed)
		}
	}

	if err := checkLengths(out.Name); err != nil {
		return Demographics{}, err
	}

	if !d.BirthDate.IsZero() {
		if d.BirthDate.Precision == PrecisionNone {
			return Demographics{}, fmt.Errorf("%w: a birth date needs a precision", ErrInvalidPatient)
		}
		if d.BirthDate.Date.After(time.Now().UTC().AddDate(1, 0, 0)) {
			// A birth date a year into the future is a typo — 2084 for 1984 —
			// and it would make every age calculation downstream negative.
			return Demographics{}, fmt.Errorf("%w: birth date is in the future", ErrInvalidPatient)
		}
		// Truncate to the day: a birth date carrying a time of day is an
		// artefact of whatever parsed it, and two records for one person would
		// differ by the milliseconds nobody entered.
		out.BirthDate.Date = d.BirthDate.Date.UTC().Truncate(24 * time.Hour)
	} else {
		out.BirthDate = BirthDate{}
	}

	phones, err := normaliseContacts(d.Phones, ContactPhone)
	if err != nil {
		return Demographics{}, err
	}
	emails, err := normaliseContacts(d.Emails, ContactEmail)
	if err != nil {
		return Demographics{}, err
	}
	out.Phones, out.Emails = phones, emails

	if len(d.Addresses) > MaxAddresses {
		return Demographics{}, fmt.Errorf("%w: at most %d addresses", ErrInvalidPatient, MaxAddresses)
	}
	for _, a := range d.Addresses {
		normalised := normaliseAddress(a)
		if !normalised.IsEmpty() {
			out.Addresses = append(out.Addresses, normalised)
		}
	}

	return out, nil
}

func normaliseContacts(in []ContactPoint, system ContactSystem) ([]ContactPoint, error) {
	if len(in) > MaxContactPoints {
		return nil, fmt.Errorf("%w: at most %d contact points", ErrInvalidPatient, MaxContactPoints)
	}

	seen := map[string]bool{}
	out := make([]ContactPoint, 0, len(in))
	for _, c := range in {
		value := strings.TrimSpace(c.Value)
		if value == "" {
			continue
		}
		if len(value) > maxFieldLength {
			return nil, fmt.Errorf("%w: contact value is too long", ErrInvalidPatient)
		}

		switch system {
		case ContactPhone:
			// Digits only, and the leading + is dropped: it survives neither
			// being read aloud nor half the forms it is typed into.
			value = nonDigits.ReplaceAllString(value, "")
			if value == "" {
				continue
			}
		case ContactEmail:
			value = strings.ToLower(value)
			if !strings.Contains(value, "@") {
				return nil, fmt.Errorf("%w: %q is not an email address", ErrInvalidPatient, c.Value)
			}
		}

		// Deduplicate. The same number entered twice is one way to reach the
		// patient, and two rows would double its weight in the matcher.
		if seen[value] {
			continue
		}
		seen[value] = true
		out = append(out, ContactPoint{System: system, Value: value, Use: normaliseText(c.Use)})
	}
	return out, nil
}

func normaliseAddress(a Address) Address {
	out := Address{
		City:       normaliseText(a.City),
		District:   normaliseText(a.District),
		State:      normaliseText(a.State),
		PostalCode: strings.ToUpper(strings.ReplaceAll(normaliseText(a.PostalCode), " ", "")),
		Country:    strings.ToUpper(normaliseText(a.Country)),
	}
	for _, line := range a.Lines {
		if trimmed := normaliseText(line); trimmed != "" {
			out.Lines = append(out.Lines, trimmed)
		}
	}
	return out
}

// normaliseText trims and collapses whitespace without changing case.
//
// Case is preserved because a name is displayed back to the person it belongs
// to, and upper-casing it for storage means a wristband that shouts. Matching
// does its own case folding.
func normaliseText(s string) string {
	return strings.TrimSpace(collapseSpace.ReplaceAllString(s, " "))
}

func checkLengths(n HumanName) error {
	fields := append([]string{n.Family, n.Prefix, n.Suffix}, n.Given...)
	for _, f := range fields {
		if len(f) > maxFieldLength {
			return fmt.Errorf("%w: a name part exceeds %d characters", ErrInvalidPatient, maxFieldLength)
		}
	}
	return nil
}
