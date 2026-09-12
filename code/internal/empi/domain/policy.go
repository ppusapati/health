package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The demographic minimum set (SRS-EMPI-001).
//
// "Create a patient with demographic minimum set configured by
// jurisdiction/facility" is a requirement that cannot be satisfied by a fixed
// list of required fields, and the reason is worth stating plainly: a
// government hospital in one Indian state must capture an identifier that a
// private clinic in another is not permitted to ask for, and an emergency
// department must be able to register an unconscious patient with no name at
// all. A hard-coded NOT NULL would make one of those impossible.
//
// So the policy is data, resolved per facility with a jurisdiction fallback,
// and the domain checks against whatever is in force.

// Field names a demographic element a policy can require.
type Field string

const (
	FieldFamilyName Field = "family_name"
	FieldGivenName  Field = "given_name"
	FieldBirthDate  Field = "birth_date"
	FieldSex        Field = "sex"
	FieldPhone      Field = "phone"
	FieldEmail      Field = "email"
	FieldAddress    Field = "address"
)

var knownFields = map[Field]bool{
	FieldFamilyName: true, FieldGivenName: true, FieldBirthDate: true,
	FieldSex: true, FieldPhone: true, FieldEmail: true, FieldAddress: true,
}

// DemographicPolicy is the minimum set in force for one registration.
type DemographicPolicy struct {
	// Jurisdiction is the ISO 3166 code or sub-code the policy belongs to.
	Jurisdiction string
	// FacilityID empty means the policy applies to every facility in the
	// jurisdiction. A facility-specific policy overrides it.
	FacilityID string
	// Required lists the fields a registration must carry.
	Required []Field
	// AllowUnidentified permits the emergency registration path, where a
	// patient arrives with no usable identity at all (SRS-EMPI-015).
	//
	// A separate flag rather than an empty Required list because "this facility
	// requires nothing" and "this facility requires a name unless the patient
	// is unconscious" are different policies, and conflating them would
	// silently relax the second.
	//
	// It governs only that path. An earlier version let this flag short-circuit
	// Check entirely, which meant a hospital enabling emergency registration
	// also turned off the demographic minimum for every routine registration —
	// the opposite of what enabling it says, and invisible until the index
	// filled with records that could not be matched.
	AllowUnidentified bool
}

// DefaultPolicy is what applies when a tenant has configured nothing.
//
// A name and a sex, and nothing else. Deliberately minimal: a default that
// demanded a birth date would block the emergency registration that
// SRS-EMPI-015 requires, and a default that demanded nothing would let a
// tenant ship with an index that cannot match anybody. Sex is included because
// it is what a lab needs to pick a reference range, and "unknown" is a
// legitimate value for it — requiring the field does not require certainty.
// Emergency registration is permitted by default. A hospital that has
// configured nothing must still be able to admit an unconscious patient: the
// failure mode of refusing is that care is delayed or happens off-record, which
// is worse than the record existing. A facility that genuinely never registers
// an unidentified patient turns it off.
func DefaultPolicy(jurisdiction string) DemographicPolicy {
	return DemographicPolicy{
		Jurisdiction:      jurisdiction,
		Required:          []Field{FieldFamilyName, FieldSex},
		AllowUnidentified: true,
	}
}

// PermitsUnidentified reports whether this facility may register a patient
// whose identity is not yet known (SRS-EMPI-015).
func (p DemographicPolicy) PermitsUnidentified() bool { return p.AllowUnidentified }

// Validate rejects a policy that could not be applied.
func (p DemographicPolicy) Validate() error {
	if strings.TrimSpace(p.Jurisdiction) == "" {
		return fmt.Errorf("%w: a policy needs a jurisdiction", ErrInvalidPatient)
	}
	seen := map[Field]bool{}
	for _, f := range p.Required {
		if !knownFields[f] {
			return fmt.Errorf("%w: unknown demographic field %q", ErrInvalidPatient, f)
		}
		if seen[f] {
			return fmt.Errorf("%w: %q is required twice", ErrInvalidPatient, f)
		}
		seen[f] = true
	}
	return nil
}

// ErrDemographicsIncomplete reports demographics that do not meet the policy.
//
// Distinct from ErrInvalidPatient because the remedy is different: invalid
// means the data is malformed and the clerk must fix it, incomplete means the
// data is well-formed and this facility wants more of it. A UI shows those
// differently.
type ErrDemographicsIncomplete struct {
	Missing []Field
}

func (e ErrDemographicsIncomplete) Error() string {
	names := make([]string, 0, len(e.Missing))
	for _, f := range e.Missing {
		names = append(names, string(f))
	}
	sort.Strings(names)
	return "empi: demographics are incomplete: missing " + strings.Join(names, ", ")
}

// Check reports which required fields the demographics do not supply.
//
// Always enforced, whatever AllowUnidentified says. The emergency path skips
// this deliberately and explicitly, by being a different use case; a routine
// registration at a facility that also admits unconscious patients is still a
// routine registration.
func (p DemographicPolicy) Check(d Demographics) error {
	var missing []Field
	for _, field := range p.Required {
		if !present(d, field) {
			missing = append(missing, field)
		}
	}
	if len(missing) > 0 {
		return ErrDemographicsIncomplete{Missing: missing}
	}
	return nil
}

func present(d Demographics, field Field) bool {
	switch field {
	case FieldFamilyName:
		return strings.TrimSpace(d.Name.Family) != ""
	case FieldGivenName:
		return len(d.Name.Given) > 0
	case FieldBirthDate:
		return !d.BirthDate.IsZero()
	case FieldSex:
		// Present, not certain. "unknown" is a recorded answer; the empty
		// string is an unanswered question, and Normalise turns the latter
		// into the former — so this checks that normalisation ran rather than
		// that anybody knows.
		return d.Sex != ""
	case FieldPhone:
		return len(d.Phones) > 0
	case FieldEmail:
		return len(d.Emails) > 0
	case FieldAddress:
		return len(d.Addresses) > 0
	default:
		// An unknown field cannot be satisfied. Validate refuses to store one,
		// so reaching here means a policy row was written around the domain,
		// and treating it as satisfied would silently drop a requirement.
		return false
	}
}

// DeceasedRecord is the fact of death as this system knows it (SRS-EMPI-008).
type DeceasedRecord struct {
	// Date is when the patient died, not when it was recorded. Zero means the
	// death is known but the date is not, which happens with an external feed.
	Date time.Time
	// Precision applies to Date for the same reason it applies to a birth date.
	Precision DatePrecision
	// Source says who says so: a registrar, a clinician, a national death
	// registry feed. The distinction matters — a feed can be wrong about the
	// wrong patient, and reversing it needs to know what claimed it.
	Source string
	// RecordedAt is when this system was told.
	RecordedAt time.Time
	// RecordedBy is the actor who entered or accepted it.
	RecordedBy string
}

// Validate rejects a deceased record that could not be reviewed later.
func (d DeceasedRecord) Validate() error {
	switch {
	case strings.TrimSpace(d.Source) == "":
		// Without a source, a death cannot be challenged or reversed, and the
		// wrong-patient case is exactly the one that has to be reversible.
		return fmt.Errorf("%w: a deceased record needs a source", ErrInvalidPatient)
	case strings.TrimSpace(d.RecordedBy) == "":
		return fmt.Errorf("%w: a deceased record needs an actor", ErrInvalidPatient)
	case !d.Date.IsZero() && d.Precision == PrecisionNone:
		return fmt.Errorf("%w: a date of death needs a precision", ErrInvalidPatient)
	}
	return nil
}
