package domain

import (
	"fmt"
	"sort"
	"strings"
)

// Configured field-level access (SRS-EMPI-014).
//
// The requirement's operative words are "where configured". Masking a fixed set
// of fields is a reasonable default and not what was asked for: which
// demographic elements are sensitive is a jurisdiction and a facility question,
// and a system that decides it centrally is wrong somewhere.
//
// A worked example of why it cannot be hardcoded: in a clinic treating people
// whose address is the thing that endangers them — a refuge, a witness
// programme — the street address is the most restricted field on the record.
// In an ordinary outpatient department it is what the receptionist reads back
// to confirm they have the right person. Same field, opposite handling, and no
// default serves both.
//
// So the policy is data, resolved per facility with a jurisdiction fallback,
// exactly as the demographic minimum set already is.

// FieldAccessPolicy says which demographic fields are restricted and what
// reveals them.
type FieldAccessPolicy struct {
	Jurisdiction string
	// FacilityID empty means the policy applies to every facility in the
	// jurisdiction. A facility-specific policy overrides it.
	FacilityID string
	// Restricted maps a field to the permission that reveals it in full.
	//
	// A map rather than a list because different fields can sit behind
	// different permissions: a clinic may let any clinician see an address
	// while reserving the national identifier for a smaller group.
	Restricted map[Field]string
}

// DefaultFieldAccessPolicy is what applies when a tenant has configured
// nothing.
//
// The set a duplicate-review screen has to mask to stay useful: enough to tell
// two people with the same name apart, not enough to answer a security
// question or turn up at somebody's door. The name is deliberately absent —
// masking it makes the comparison screen useless, which pushes a clerk to open
// the full record instead and discloses more rather than less.
func DefaultFieldAccessPolicy(jurisdiction string) FieldAccessPolicy {
	return FieldAccessPolicy{
		Jurisdiction: jurisdiction,
		Restricted: map[Field]string{
			FieldBirthDate: PermissionReadRestricted,
			FieldPhone:     PermissionReadRestricted,
			FieldEmail:     PermissionReadRestricted,
			FieldAddress:   PermissionReadRestricted,
		},
	}
}

// PermissionReadRestricted is the default permission a restricted field sits
// behind.
//
// Declared in the domain rather than only in the application layer because a
// stored policy names a permission as a string, and a policy naming a
// permission nothing grants would silently restrict a field forever.
const PermissionReadRestricted = "empi.patient.read_restricted"

// Validate rejects a policy that could not be applied.
func (p FieldAccessPolicy) Validate() error {
	if strings.TrimSpace(p.Jurisdiction) == "" {
		return fmt.Errorf("%w: a field access policy needs a jurisdiction", ErrInvalidPatient)
	}
	for field, permission := range p.Restricted {
		if !knownFields[field] {
			return fmt.Errorf("%w: unknown demographic field %q", ErrInvalidPatient, field)
		}
		if strings.TrimSpace(permission) == "" {
			// A field restricted behind no permission is restricted from
			// everybody, forever, with nothing saying so.
			return fmt.Errorf("%w: field %q is restricted behind no permission", ErrInvalidPatient, field)
		}
	}
	return nil
}

// Hidden returns the restricted fields this caller may not see in full.
//
// holds answers whether the caller has a permission; the caller's whole
// permission set is not passed in, so a policy naming a permission this system
// has never heard of restricts the field rather than opening it.
func (p FieldAccessPolicy) Hidden(holds func(permission string) bool) []Field {
	var hidden []Field
	for field, permission := range p.Restricted {
		if !holds(permission) {
			hidden = append(hidden, field)
		}
	}
	sort.Slice(hidden, func(i, j int) bool { return hidden[i] < hidden[j] })
	return hidden
}

// Revealed returns the restricted fields this caller may see in full.
//
// SRS-EMPI-014 requires the read to be audited, and what makes that audit worth
// keeping is which restricted fields were actually disclosed — not merely that
// somebody with the permission opened a record.
func (p FieldAccessPolicy) Revealed(holds func(permission string) bool) []Field {
	var revealed []Field
	for field, permission := range p.Restricted {
		if holds(permission) {
			revealed = append(revealed, field)
		}
	}
	sort.Slice(revealed, func(i, j int) bool { return revealed[i] < revealed[j] })
	return revealed
}

// MaskFields returns the demographics with the named fields narrowed.
//
// Narrowed rather than blanked. A blank field reads as "not recorded", and a
// clerk who believes a phone number is missing asks the patient for it again —
// which is a worse outcome than showing them the last four digits. Every
// masking below keeps exactly the discriminating power a comparison needs and
// removes the part that identifies or locates a person.
func (d Demographics) MaskFields(fields []Field) Demographics {
	if len(fields) == 0 {
		return d
	}
	hide := map[Field]bool{}
	for _, f := range fields {
		hide[f] = true
	}

	out := d
	if hide[FieldFamilyName] {
		out.Name.Family = maskedMarker
	}
	if hide[FieldGivenName] {
		out.Name.Given = maskGiven(d.Name.Given)
	}
	if hide[FieldBirthDate] && !d.BirthDate.IsZero() {
		// Narrowed to the year: enough to tell two people with one name apart,
		// not enough to be an answer to a security question.
		out.BirthDate = BirthDate{Date: d.BirthDate.Date, Precision: PrecisionYear}
	}
	if hide[FieldSex] {
		out.Sex = SexUnknown
	}
	if hide[FieldPhone] {
		out.Phones = maskContacts(d.Phones, func(v string) string { return maskTail(v, 4) })
	}
	if hide[FieldEmail] {
		out.Emails = maskContacts(d.Emails, maskEmail)
	}
	if hide[FieldAddress] {
		// Narrowed to the settlement. A street address is the field most often
		// misused, and the city is what a clerk needs to ask "is this the Meera
		// Iyer from Whitefield?".
		out.Addresses = make([]Address, 0, len(d.Addresses))
		for _, a := range d.Addresses {
			out.Addresses = append(out.Addresses, Address{
				City: a.City, District: a.District, State: a.State, Country: a.Country,
			})
		}
	}
	return out
}

// maskedMarker replaces a hidden portion. Visible rather than blank, because a
// blank field reads as "not recorded".
const maskedMarker = "•••"

func maskGiven(given []string) []string {
	out := make([]string, 0, len(given))
	for _, name := range given {
		runes := []rune(name)
		if len(runes) == 0 {
			continue
		}
		out = append(out, string(runes[0])+maskedMarker)
	}
	return out
}

func maskContacts(points []ContactPoint, mask func(string) string) []ContactPoint {
	out := make([]ContactPoint, 0, len(points))
	for _, p := range points {
		out = append(out, ContactPoint{System: p.System, Use: p.Use, Value: mask(p.Value)})
	}
	return out
}

// maskTail keeps the last n characters, which is the part a person reads out to
// confirm a number they already know.
func maskTail(value string, n int) string {
	runes := []rune(value)
	if len(runes) <= n {
		return maskedMarker
	}
	return maskedMarker + string(runes[len(runes)-n:])
}

// maskEmail keeps the domain and the first character of the local part.
//
// The domain distinguishes a work address from a personal one, which is the
// comparison a clerk is making; the local part is the half that identifies the
// person.
func maskEmail(value string) string {
	at := strings.LastIndex(value, "@")
	if at <= 0 {
		return maskedMarker
	}
	return string([]rune(value[:at])[0]) + maskedMarker + value[at:]
}
