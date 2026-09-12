package postgres

import (
	"context"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	empidomain "github.com/ppusapati/health/code/internal/empi/domain"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Seams onto the contexts the clinical record depends on, and the seam the
// encounter context reaches this one through.
//
// Adapters rather than shared tables. Whether a visit still accepts clinical
// content is the encounter context's fact and a patient's name is the patient
// index's; a copy of either here would be a second answer that drifts.

// Encounters adapts the encounter context (SRS-ENC).
type Encounters struct {
	encounters encounterports.EncounterRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(encounters encounterports.EncounterRepository) Encounters {
	return Encounters{encounters: encounters}
}

var _ ports.EncounterDirectory = Encounters{}

// AcceptsClinicalContent reports whether new records may be written against an
// encounter, and which patient it belongs to.
//
// The patient comes back so the caller can check the record it is about to
// write lands on the same one. A note filed against the right encounter but the
// wrong patient is the wrong-patient error SRS-CLN-017 exists to prevent, seen
// from the other side.
func (e Encounters) AcceptsClinicalContent(ctx context.Context,
	scope authctx.TenantScope, encounterID string) (string, bool, error) {

	encounter, err := e.encounters.Get(ctx, scope, encounterID)
	if err != nil {
		// Not-found propagates: a note cannot be written into an encounter this
		// tenant does not hold, and the refusal must not confirm it exists
		// elsewhere.
		return "", false, err
	}
	return encounter.PatientID, encounter.AcceptsClinicalContent(), nil
}

// Patients adapts the patient index for the banner (SRS-CLN-001).
type Patients struct {
	patients    empiports.PatientRepository
	identifiers empiports.IdentifierRepository
	clock       func() time.Time
}

// NewPatients constructs the adapter.
func NewPatients(patients empiports.PatientRepository,
	identifiers empiports.IdentifierRepository, now func() time.Time) Patients {

	return Patients{patients: patients, identifiers: identifiers, clock: now}
}

var _ ports.PatientSummary = Patients{}

// Summary returns the identity half of the patient banner.
//
// Narrow on purpose: a name, an age, a sex and the identifiers a clinician
// reads out at the bedside. The full demographic record stays in SRS-EMPI,
// where far fewer people can see it.
func (p Patients) Summary(ctx context.Context, scope authctx.TenantScope,
	patientID string) (ports.BannerFacts, error) {

	patient, err := p.patients.GetByID(ctx, scope, patientID)
	if err != nil {
		return ports.BannerFacts{}, err
	}

	facts := ports.BannerFacts{
		DisplayName: patient.Demographics.Name.Display(),
		AgeDisplay:  ageDisplay(patient.Demographics.BirthDate, p.clock()),
		Sex:         string(patient.Demographics.Sex),
		// The one fact that should stop a clinician mid-action: prescribing for
		// a deceased patient is a distinct class of error.
		Deceased: patient.Deceased != nil,
	}

	if p.identifiers == nil {
		return facts, nil
	}
	identifiers, err := p.identifiers.ForPatient(ctx, scope, patientID)
	if err != nil {
		return ports.BannerFacts{}, err
	}
	// Only the ones a clinician can read out and a patient can confirm. A
	// banner listing every identifier the system holds is a banner nobody
	// checks against the wristband.
	for _, id := range identifiers {
		if id.Status != empidomain.IdentifierActive {
			continue
		}
		facts.Identifiers = append(facts.Identifiers, domain.BannerIdentifier{
			System: id.System, Value: id.Value,
			Label: labelFor(id),
		})
	}
	return facts, nil
}

// labelFor is what a clinician sees beside the value.
//
// The assigning authority where there is one, because "MRN 0000123" is
// ambiguous in a group with four hospitals and "Main Hospital 0000123" is not.
func labelFor(id empidomain.Identifier) string {
	if id.AssigningAuthority != "" {
		return id.AssigningAuthority
	}
	return string(id.Type)
}

// ageDisplay renders an age the way a clinician needs it.
//
// Days for a neonate, months for an infant, years for everybody else. A screen
// showing "0" for a two-week-old is a dosing error waiting to happen, and a
// screen showing "0.04 years" is one nobody reads.
func ageDisplay(birth empidomain.BirthDate, now time.Time) string {
	if birth.Date.IsZero() || birth.Precision == empidomain.PrecisionNone {
		return "age unknown"
	}

	days := int(now.Sub(birth.Date).Hours() / 24)
	switch {
	case days < 0:
		return "age unknown"
	case days < 28:
		return strconv.Itoa(days) + "d"
	case days < 365:
		return strconv.Itoa(days/30) + "m"
	default:
		return strconv.Itoa(days/365) + "y"
	}
}
