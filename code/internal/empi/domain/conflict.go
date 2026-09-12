package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Detecting a demographic conflict (SRS-EMPI-012).
//
// The requirement's verb is "detect", and the acceptance criterion is that the
// conflicting value is held rather than applied. What makes this non-trivial is
// deciding what counts as a conflict, because the wrong answer in either
// direction is costly.
//
// Too sensitive and every feed raises a worklist item for "Mohammed" versus
// "Mohammad", the queue becomes noise, and a reviewer clicking through it stops
// reading — which is how a real conflict gets accepted. Too permissive and a
// genuinely different birth date is normalised away.
//
// So: a field is in conflict when both sides have a value and the values differ
// after the normalisation the matcher already applies. A field the source does
// not carry is not a conflict — a payer file that omits the birth date is not
// asserting that the patient has none.

// FillMissing decides what an empty incoming field means.
type FillMissing bool

const (
	// ProposeOnlyConflicts ignores fields the record holds and the source does
	// not, and fields the source holds and the record does not.
	ProposeOnlyConflicts FillMissing = false
	// ProposeFillingBlanks also proposes values for fields the record leaves
	// empty. A registry offering a birth date the record lacks is filling a
	// gap rather than contradicting anything, and that is usually welcome —
	// but it is still a proposal, because "usually" is not "always".
	ProposeFillingBlanks FillMissing = true
)

// DetectConflicts compares incoming demographics against the record.
//
// Returns the fields that disagree, ready to become a Proposal. An empty result
// means the source agrees with the record, and the caller should raise nothing
// rather than an empty proposal.
//
// Both sides are normalised first, so "+91 98765 43210" and "9876543210" are
// the same phone number and do not generate a conflict a human has to dismiss.
func DetectConflicts(current, incoming Demographics, fill FillMissing) []FieldProposal {
	// Normalisation can fail on malformed input; a comparison against
	// un-normalised values is still better than none, so the error is
	// deliberately ignored here and the raw value used.
	if normalised, err := current.Normalise(); err == nil {
		current = normalised
	}
	if normalised, err := incoming.Normalise(); err == nil {
		incoming = normalised
	}

	var out []FieldProposal
	add := func(field Field, currentValue, proposedValue string) {
		currentValue = strings.TrimSpace(currentValue)
		proposedValue = strings.TrimSpace(proposedValue)

		if proposedValue == "" {
			// The source carries nothing for this field. Silence is not a
			// claim that the patient has no family name.
			return
		}
		if currentValue == proposedValue {
			return
		}
		if currentValue == "" && fill == ProposeOnlyConflicts {
			return
		}
		out = append(out, FieldProposal{
			Field: field, CurrentValue: currentValue, ProposedValue: proposedValue,
		})
	}

	add(FieldFamilyName, current.Name.Family, incoming.Name.Family)
	add(FieldGivenName, strings.Join(current.Name.Given, " "), strings.Join(incoming.Name.Given, " "))
	add(FieldBirthDate, current.BirthDate.Compare(), incoming.BirthDate.Compare())
	add(FieldSex, string(current.Sex), string(incoming.Sex))
	addContact(&out, FieldPhone, current.Phones, incoming.Phones, fill)
	addContact(&out, FieldEmail, current.Emails, incoming.Emails, fill)
	add(FieldAddress, firstAddress(current.Addresses), firstAddress(incoming.Addresses))

	sort.Slice(out, func(i, j int) bool { return out[i].Field < out[j].Field })
	return out
}

// Compare renders a birth date for comparison and for a reviewer to read.
//
// The precision travels with the value, because "1984" and "1984-03-12" are not
// the same claim: a registry holding only a year does not contradict a record
// holding a full date, and rendering both as "1984-01-01" would make it look
// as though it did.
func (b BirthDate) Compare() string {
	if b.Date.IsZero() {
		return ""
	}
	switch b.Precision {
	case PrecisionYear:
		return b.Date.Format("2006")
	case PrecisionMonth:
		return b.Date.Format("2006-01")
	case PrecisionEstimated:
		// Marked, so a reviewer never reads an estimate as a stated date.
		return b.Date.Format("2006") + " (estimated)"
	default:
		return b.Date.Format("2006-01-02")
	}
}

// addContact proposes a contact point only when the record does not already
// hold it.
//
// Set membership rather than position: a feed that returns the patient's three
// numbers in a different order is not proposing a change, and a feed returning
// a number the record already has further down the list is not either. Only a
// value the record holds nowhere is a change worth a human's attention.
func addContact(out *[]FieldProposal, field Field, current, incoming []ContactPoint,
	fill FillMissing) {

	if len(incoming) == 0 {
		// Silence from a source is not a claim that the patient has no number.
		return
	}
	proposed := strings.TrimSpace(incoming[0].Value)
	if proposed == "" {
		return
	}
	for _, held := range current {
		if SameContactValue(held.Value, proposed) {
			return
		}
	}
	if len(current) == 0 && fill == ProposeOnlyConflicts {
		return
	}

	currentValue := ""
	if len(current) > 0 {
		currentValue = current[0].Value
	}
	*out = append(*out, FieldProposal{
		Field: field, CurrentValue: currentValue, ProposedValue: proposed,
	})
}

// firstAddress renders the primary address as a single comparable line.
func firstAddress(addresses []Address) string {
	if len(addresses) == 0 {
		return ""
	}
	a := addresses[0]
	parts := make([]string, 0, len(a.Lines)+5)
	parts = append(parts, a.Lines...)
	for _, p := range []string{a.City, a.District, a.State, a.PostalCode, a.Country} {
		if strings.TrimSpace(p) != "" {
			parts = append(parts, p)
		}
	}
	return strings.Join(parts, ", ")
}

// Apply writes accepted field values onto a copy of the demographics.
//
// Returns a copy: a caller that applied in place would mutate the record it is
// still comparing against, and a failure halfway through would leave the
// aggregate holding half a proposal.
//
// Only the accepted fields move. A proposal where the reviewer took the birth
// date and refused the name must not carry the name across as a side effect.
func (d Demographics) Apply(p Proposal) (Demographics, error) {
	out := d
	for _, f := range p.Fields {
		if f.Accepted == nil || !*f.Accepted {
			continue
		}
		switch f.Field {
		case FieldFamilyName:
			out.Name.Family = f.ProposedValue
		case FieldGivenName:
			out.Name.Given = strings.Fields(f.ProposedValue)
		case FieldBirthDate:
			parsed, precision, err := parseComparableDate(f.ProposedValue)
			if err != nil {
				return Demographics{}, err
			}
			out.BirthDate = BirthDate{Date: parsed, Precision: precision}
		case FieldSex:
			out.Sex = Sex(f.ProposedValue)
		case FieldPhone:
			out.Phones = replaceFirst(out.Phones, ContactPoint{
				System: ContactPhone, Value: f.ProposedValue,
			})
		case FieldEmail:
			out.Emails = replaceFirst(out.Emails, ContactPoint{
				System: ContactEmail, Value: f.ProposedValue,
			})
		case FieldAddress:
			// An address is applied as a single line rather than parsed back
			// into components. Guessing which comma was the city is how a
			// district ends up in the postcode; a structured address change
			// goes through UpdateDemographics.
			out.Addresses = replaceFirstAddress(out.Addresses, Address{
				Lines: []string{f.ProposedValue},
			})
		}
	}
	return out, nil
}

// parseComparableDate reads back what Compare rendered.
func parseComparableDate(value string) (time.Time, DatePrecision, error) {
	value = strings.TrimSpace(value)
	if strings.HasSuffix(value, " (estimated)") {
		trimmed := strings.TrimSuffix(value, " (estimated)")
		parsed, err := time.Parse("2006", trimmed)
		if err != nil {
			return time.Time{}, "", invalidBirthDate(value)
		}
		return parsed.UTC(), PrecisionEstimated, nil
	}
	for _, form := range []struct {
		layout    string
		precision DatePrecision
	}{
		{"2006-01-02", PrecisionDay},
		{"2006-01", PrecisionMonth},
		{"2006", PrecisionYear},
	} {
		if parsed, err := time.Parse(form.layout, value); err == nil {
			return parsed.UTC(), form.precision, nil
		}
	}
	return time.Time{}, "", invalidBirthDate(value)
}

func replaceFirst(points []ContactPoint, value ContactPoint) []ContactPoint {
	if len(points) == 0 {
		return []ContactPoint{value}
	}
	out := make([]ContactPoint, len(points))
	copy(out, points)
	// The use is kept: the proposal changes the number, not whether it is the
	// mobile the patient answers.
	value.Use = out[0].Use
	out[0] = value
	return out
}

func replaceFirstAddress(addresses []Address, value Address) []Address {
	if len(addresses) == 0 {
		return []Address{value}
	}
	out := make([]Address, len(addresses))
	copy(out, addresses)
	out[0] = value
	return out
}

// invalidBirthDate reports a proposed birth date that cannot be read back.
//
// Reachable only if a proposal was stored with a value Compare did not produce,
// which means something wrote to the table without going through NewProposal.
func invalidBirthDate(value string) error {
	return fmt.Errorf("%w: %q is not a birth date this system wrote",
		ErrInvalidPatient, value)
}
