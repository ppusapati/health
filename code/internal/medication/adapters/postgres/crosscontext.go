package postgres

import (
	"context"
	"strings"
	"time"

	clinicaldomain "github.com/ppusapati/health/code/internal/clinical/domain"
	clinicalports "github.com/ppusapati/health/code/internal/clinical/ports"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Seams onto the contexts the medication context depends on.
//
// Adapters rather than shared tables. Whether a visit is open is the encounter
// context's fact, what a patient is allergic to is the clinical record's, and
// how old they are is the EMPI's; a copy of any of them here would be a second
// answer that drifts.

// Encounters adapts the encounter context (SRS-MED-001).
type Encounters struct {
	encounters encounterports.EncounterRepository
	facilities orgports.FacilityRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(encounters encounterports.EncounterRepository,
	facilities orgports.FacilityRepository) Encounters {

	return Encounters{encounters: encounters, facilities: facilities}
}

var _ ports.Encounters = Encounters{}

// Check reports whether an encounter accepts prescriptions and whose it is.
//
// The facility's time zone comes back with it, because the schedule needs it: a
// four-times-daily drug expanded in UTC is an hour out twice a year, which is
// how a dose lands at 01:00.
func (e Encounters) Check(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterState, error) {

	encounter, err := e.encounters.Get(ctx, scope, encounterID)
	if err != nil {
		// Not-found propagates: a prescription cannot be written into an
		// encounter this tenant does not hold, and the refusal must not confirm
		// it exists elsewhere.
		return ports.EncounterState{}, err
	}

	state := ports.EncounterState{
		PatientID: encounter.PatientID, FacilityID: encounter.FacilityID,
		Open:         encounter.AcceptsClinicalContent(),
		DepartmentID: encounter.OrgUnitID,
	}
	if e.facilities == nil {
		return state, nil
	}
	facility, err := e.facilities.GetByID(ctx, scope, encounter.FacilityID)
	if err != nil {
		return state, err
	}
	state.TimeZone = facility.TimeZone
	return state, nil
}

// Allergies adapts the clinical context's allergy list (SRS-MED-002).
type Allergies struct {
	records clinicalports.RecordRepository
}

// NewAllergies constructs the adapter.
func NewAllergies(records clinicalports.RecordRepository) Allergies {
	return Allergies{records: records}
}

var _ ports.Allergies = Allergies{}

// AllergyLimit bounds the list read for a screen.
//
// Generous, because every entry not read is a warning not shown: a patient with
// forty recorded allergies is exactly the patient the screen exists for.
const AllergyLimit = 200

// ForPatient projects the clinical allergy list into what a screen needs.
//
// A projection rather than the record: the substance, how bad the reaction was,
// and whether anybody confirmed it. The reaction narrative stays in the chart,
// where a clinician reads it, rather than travelling into a rule engine that
// cannot use it.
func (a Allergies) ForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string) ([]domain.AllergyRecord, error) {

	list, err := a.records.Allergies(ctx, scope, patientID, true, AllergyLimit)
	if err != nil {
		return nil, err
	}

	out := make([]domain.AllergyRecord, 0, len(list))
	for _, entry := range list {
		out = append(out, domain.AllergyRecord{
			Substance: domain.Coding{
				System: entry.Substance.System, Code: entry.Substance.Code,
				Display: entry.Substance.Display, Version: entry.Substance.Version,
			},
			Criticality: criticalityToSeverity(entry.Criticality),
			Confirmed:   entry.Verification == clinicaldomain.VerificationConfirmed,
			Intolerance: entry.Kind == clinicaldomain.AllergyIntolerance,
		})
	}
	return out, nil
}

// criticalityToSeverity maps the clinical record's scale onto this context's.
//
// "Unable to assess" becomes severe rather than mild, which is the whole reason
// the clinical context keeps it as a distinct value: a system that defaulted an
// unassessed allergy to low would be quietest about the patients nobody has
// been able to ask.
func criticalityToSeverity(c clinicaldomain.AllergyCriticality) domain.Severity {
	switch c {
	case clinicaldomain.CriticalityHigh:
		return domain.SeverityContraindicated
	case clinicaldomain.CriticalityLow:
		return domain.SeverityModerate
	case clinicaldomain.CriticalityUnableToAssess:
		return domain.SeveritySevere
	}
	return domain.SeveritySevere
}

// PatientFactors supplies the inputs dose-support rules need (SRS-MED-004).
type PatientFactors struct {
	patients empiports.PatientRepository
	records  clinicalports.RecordRepository
}

// NewPatientFactors constructs the adapter.
func NewPatientFactors(patients empiports.PatientRepository,
	records clinicalports.RecordRepository) PatientFactors {

	return PatientFactors{patients: patients, records: records}
}

var _ ports.PatientContext = PatientFactors{}

// Observation codes the dose-support rules read.
//
// LOINC, named here rather than configured, because a rule that could be
// pointed at an arbitrary code could be pointed at the wrong one — and a renal
// dose computed from a potassium is worse than no advice at all.
const (
	codeCreatinineClearance = "33914-3"
	codeBodyWeight          = "29463-7"
)

// Factors reads what is actually available (SRS-MED-004).
//
// The Known map is the point. A rule whose input is missing must not fire, and
// a zero-valued float cannot be told apart from a genuine zero — a creatinine
// clearance of nought is a patient in anuric renal failure, which is a real
// reading and the opposite of "nobody measured it".
func (f PatientFactors) Factors(ctx context.Context, scope authctx.TenantScope,
	patientID string, at time.Time) (domain.PatientFactors, error) {

	out := domain.PatientFactors{Known: map[string]bool{}}

	if f.patients != nil {
		patient, err := f.patients.GetByID(ctx, scope, patientID)
		if err != nil {
			return domain.PatientFactors{}, err
		}
		birth := patient.Demographics.BirthDate
		if !birth.Date.IsZero() {
			out.AgeYears = at.UTC().Sub(birth.Date.UTC()).Hours() / (24 * 365.25)
			out.Known["age_years"] = true
		}
	}

	if f.records == nil {
		return out, nil
	}

	if value, ok, err := f.latest(ctx, scope, patientID, codeCreatinineClearance); err != nil {
		return domain.PatientFactors{}, err
	} else if ok {
		out.CreatinineClearance = value
		out.Known["creatinine_clearance"] = true
	}

	if value, ok, err := f.latest(ctx, scope, patientID, codeBodyWeight); err != nil {
		return domain.PatientFactors{}, err
	} else if ok {
		out.WeightKg = value
		out.Known["weight_kg"] = true
	}

	return out, nil
}

// latest reads the most recent value of one measurement.
func (f PatientFactors) latest(ctx context.Context, scope authctx.TenantScope,
	patientID, code string) (float64, bool, error) {

	list, err := f.records.Observations(ctx, scope, clinicalports.ObservationQuery{
		PatientID: patientID, Code: code, Limit: 1,
	})
	if err != nil {
		return 0, false, err
	}
	for _, o := range list {
		if strings.TrimSpace(o.Value.Unit) == "" {
			// A number with no unit is not a measurement this can act on, for
			// the reason the clinical context stores the two together: the
			// number alone has eventually been rendered under the wrong label
			// by every system that separated them.
			continue
		}
		return o.Value.Value, true, nil
	}
	return 0, false, nil
}
