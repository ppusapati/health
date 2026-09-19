// Package domain holds the infection prevention and control rules
// (SRS-IPC-001 … 010).
//
// Nothing here reaches a database, a clock or a transport (FIT-01). Every
// refusal is a value a caller can act on rather than a panic.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidInfection reports a refused infection control record.
var ErrInvalidInfection = errors.New("infection: invalid")

// Onset says whether an infection was acquired here (SRS-IPC-001).
//
// The single most consequential field in this context, and the one nobody may
// type. A healthcare-associated infection reclassified as community-acquired
// does not move between reports — it disappears from the rate entirely, and
// the hospital's own surveillance stops being able to see its worst wards.
type Onset string

const (
	// OnsetCommunity was present or incubating on admission.
	OnsetCommunity Onset = "community_acquired"
	// OnsetHealthcare appeared after the surveillance window, so the
	// hospital owns it.
	OnsetHealthcare Onset = "healthcare_associated"
	// OnsetIndeterminate cannot be decided from the dates available. Named
	// rather than forced either way: a case with no admission date is a case
	// nobody can classify, and guessing would bias the rate in whichever
	// direction the default happened to fall.
	OnsetIndeterminate Onset = "indeterminate"
)

// HealthcareAssociated reports the classification that counts towards a rate.
func (o Onset) HealthcareAssociated() bool { return o == OnsetHealthcare }

// Classify derives an onset classification (SRS-IPC-001).
//
// windowHours is how long after admission an infection is still considered to
// have come in with the patient — conventionally 48 hours, and configurable
// because surveillance definitions differ by organism and by scheme.
//
// Derived here and nowhere else. The review can disagree with it, but the
// disagreement is recorded as an override with a reason rather than as the
// answer.
func Classify(admittedAt, onsetAt time.Time, windowHours int) Onset {
	if admittedAt.IsZero() || onsetAt.IsZero() || windowHours <= 0 {
		return OnsetIndeterminate
	}
	if onsetAt.Before(admittedAt) {
		// Symptoms before arrival. Not the hospital's, whatever the ward
		// thinks.
		return OnsetCommunity
	}
	if onsetAt.Before(admittedAt.Add(time.Duration(windowHours) * time.Hour)) {
		return OnsetCommunity
	}
	return OnsetHealthcare
}

// InfectionSite is where the infection is (SRS-IPC-001, SRS-IPC-002).
//
// The four device-associated sites are named individually because each has its
// own denominator: ventilator days, line days, catheter days. A site recorded
// as "other" cannot be given a rate, which is why the list is not free text.
type InfectionSite string

const (
	// SiteVAP is ventilator-associated pneumonia.
	SiteVAP InfectionSite = "ventilator_associated_pneumonia"
	// SiteCLABSI is central line-associated bloodstream infection.
	SiteCLABSI InfectionSite = "central_line_bloodstream"
	// SiteCAUTI is catheter-associated urinary tract infection.
	SiteCAUTI InfectionSite = "catheter_associated_urinary"
	// SiteSSI is surgical site infection.
	SiteSSI         InfectionSite = "surgical_site"
	SiteBloodstream InfectionSite = "bloodstream"
	SiteRespiratory InfectionSite = "respiratory"
	SiteUrinary     InfectionSite = "urinary"
	SiteSkin        InfectionSite = "skin_soft_tissue"
	SiteGastro      InfectionSite = "gastrointestinal"
	SiteOther       InfectionSite = "other"
)

var knownSite = map[InfectionSite]bool{
	SiteVAP: true, SiteCLABSI: true, SiteCAUTI: true, SiteSSI: true,
	SiteBloodstream: true, SiteRespiratory: true, SiteUrinary: true,
	SiteSkin: true, SiteGastro: true, SiteOther: true,
}

// DeviceKind is the device a site's denominator counts (SRS-IPC-002).
type DeviceKind string

const (
	DeviceVentilator      DeviceKind = "ventilator"
	DeviceCentralLine     DeviceKind = "central_line"
	DeviceUrinaryCatheter DeviceKind = "urinary_catheter"
)

var knownDevice = map[DeviceKind]bool{
	DeviceVentilator: true, DeviceCentralLine: true,
	DeviceUrinaryCatheter: true,
}

// DeviceFor names the device a site's rate is counted against, where it has
// one.
//
// A table rather than a field on the case, because the association is a
// property of the surveillance definition and not of the individual patient:
// a hospital that let each case name its own denominator would have rates
// nobody could reproduce.
func DeviceFor(site InfectionSite) (DeviceKind, bool) {
	switch site {
	case SiteVAP:
		return DeviceVentilator, true
	case SiteCLABSI:
		return DeviceCentralLine, true
	case SiteCAUTI:
		return DeviceUrinaryCatheter, true
	default:
		return "", false
	}
}

// CaseState is where a surveillance case stands.
type CaseState string

const (
	// CaseSuspected has been flagged and not yet reviewed against the
	// criteria.
	CaseSuspected CaseState = "suspected"
	// CaseConfirmed meets the surveillance definition.
	CaseConfirmed CaseState = "confirmed"
	// CaseRefuted does not. Kept rather than deleted: a case the reviewer
	// rejected is evidence about the definition as much as about the patient.
	CaseRefuted CaseState = "refuted"
	CaseClosed  CaseState = "closed"
)

var knownCaseState = map[CaseState]bool{
	CaseSuspected: true, CaseConfirmed: true,
	CaseRefuted: true, CaseClosed: true,
}

// Open reports a case still being worked.
func (s CaseState) Open() bool {
	return s == CaseSuspected || s == CaseConfirmed
}

// SurveillanceCase is one infection under surveillance (SRS-IPC-001).
type SurveillanceCase struct {
	ID       string
	TenantID string

	Reference   string
	PatientID   string
	EncounterID string
	FacilityID  string
	LocationID  string

	Organism string
	// OrganismCode is the terminology code where the hospital has one. Carried
	// beside the name because an outbreak is matched on the code and read on
	// the name.
	OrganismCode string
	Site         InfectionSite
	// MultidrugResistant marks an organism on the hospital's MDRO list
	// (SRS-IPC-004). Set from the configured list rather than typed, so a
	// hospital that adds an organism to its list does not have to re-key
	// every case.
	MultidrugResistant bool

	// Onset is derived from the dates. Override records a reviewer disagreeing
	// with the derivation, and is never the same field: a report that cannot
	// tell a derived classification from an overridden one cannot audit its
	// own rates.
	Onset             Onset
	OnsetOverride     Onset
	OnsetOverrideWhy  string
	OnsetOverriddenBy string

	AdmittedAt time.Time
	OnsetAt    time.Time
	// WindowHours is the surveillance window the classification used. Frozen
	// on the case, because the hospital may change the definition and a case
	// classified under the old one must stay reproducible.
	WindowHours int

	// Criteria is what the case was judged against, in the reviewer's words.
	// The requirement's acceptance is that the case retains its criteria and
	// reviewer, which is what makes a surveillance figure defensible.
	Criteria   string
	ReviewedBy string
	ReviewedAt time.Time

	// DeviceInSitu records that the associated device was in place. Required
	// for a device-associated site: a ventilator-associated pneumonia in a
	// patient who was never ventilated is a mis-coded case, and it inflates
	// the numerator of a rate whose denominator it never entered.
	DeviceInSitu bool
	DeviceDays   int

	State CaseState
	Notes string

	ReportedAt time.Time
	ReportedBy string
	ClosedAt   time.Time
	ClosedBy   string
	Version    int64
}

// EffectiveOnset is the classification a report should count.
//
// The override where a reviewer made one, the derivation otherwise. One
// function so that every report answers the question the same way, and the
// two fields stay distinguishable underneath.
func (c SurveillanceCase) EffectiveOnset() Onset {
	if c.OnsetOverride != "" {
		return c.OnsetOverride
	}
	return c.Onset
}

// NewCaseInput opens a surveillance case.
type NewCaseInput struct {
	Reference    string
	PatientID    string
	EncounterID  string
	FacilityID   string
	LocationID   string
	Organism     string
	OrganismCode string
	Site         InfectionSite
	AdmittedAt   time.Time
	OnsetAt      time.Time
	DeviceInSitu bool
	DeviceDays   int
	Criteria     string
	Notes        string
}

// OpenCase records a suspected infection (SRS-IPC-001).
//
// windowHours and multidrugResistant come from the deployment's configuration
// rather than the request: the surveillance window decides the classification
// and the resistance list decides the alerting, and neither is the reporter's
// to choose.
func OpenCase(id, tenantID string, in NewCaseInput, windowHours int,
	multidrugResistant bool, by string, now time.Time) (
	SurveillanceCase, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return SurveillanceCase{}, fmt.Errorf("%w: a case needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(in.PatientID) == "":
		return SurveillanceCase{}, fmt.Errorf("%w: a case names its patient",
			ErrInvalidInfection)
	case !knownSite[in.Site]:
		return SurveillanceCase{}, fmt.Errorf("%w: unknown infection site %q",
			ErrInvalidInfection, in.Site)
	case strings.TrimSpace(in.Organism) == "":
		return SurveillanceCase{}, fmt.Errorf("%w: a case names its organism",
			ErrInvalidInfection)
	case in.OnsetAt.IsZero():
		return SurveillanceCase{}, fmt.Errorf("%w: a case needs an onset date",
			ErrInvalidInfection)
	case in.OnsetAt.After(now):
		return SurveillanceCase{}, fmt.Errorf("%w: that onset is in the future",
			ErrInvalidInfection)
	case in.DeviceDays < 0:
		return SurveillanceCase{}, fmt.Errorf("%w: device days cannot be negative",
			ErrInvalidInfection)
	}

	// A device-associated infection in a patient who never had the device is
	// a mis-coded case, and it inflates a numerator whose denominator it never
	// entered.
	if _, associated := DeviceFor(in.Site); associated && !in.DeviceInSitu {
		return SurveillanceCase{}, fmt.Errorf(
			"%w: %s is device-associated and no device is recorded in situ",
			ErrInvalidInfection, in.Site)
	}

	return SurveillanceCase{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference),
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID: in.FacilityID, LocationID: in.LocationID,
		Organism:     strings.TrimSpace(in.Organism),
		OrganismCode: strings.TrimSpace(in.OrganismCode),
		Site:         in.Site, MultidrugResistant: multidrugResistant,
		Onset:      Classify(in.AdmittedAt, in.OnsetAt, windowHours),
		AdmittedAt: utcOrZero(in.AdmittedAt), OnsetAt: in.OnsetAt.UTC(),
		WindowHours:  windowHours,
		Criteria:     strings.TrimSpace(in.Criteria),
		DeviceInSitu: in.DeviceInSitu, DeviceDays: in.DeviceDays,
		State: CaseSuspected, Notes: strings.TrimSpace(in.Notes),
		ReportedAt: now.UTC(), ReportedBy: by, Version: 1,
	}, nil
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}

// Review judges a case against the surveillance definition (SRS-IPC-001).
//
// The criteria and the reviewer are both required. A confirmed case with no
// record of what it was judged against is a number in a rate that nobody can
// defend, and the first thing an accreditation surveyor asks about a rate is
// how the cases were counted.
func (c *SurveillanceCase) Review(to CaseState, criteria, by string,
	now time.Time) error {

	switch {
	case !knownCaseState[to]:
		return fmt.Errorf("%w: unknown case state %q", ErrInvalidInfection, to)
	case !c.State.Open():
		return fmt.Errorf("%w: this case is %s", ErrInvalidInfection, c.State)
	case to == CaseSuspected:
		return fmt.Errorf("%w: a case does not go back to suspected",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a review names its reviewer", ErrInvalidInfection)
	case (to == CaseConfirmed || to == CaseRefuted) &&
		strings.TrimSpace(criteria) == "":
		return fmt.Errorf("%w: say what this case was judged against",
			ErrInvalidInfection)
	}

	c.State = to
	c.ReviewedBy, c.ReviewedAt = by, now.UTC()
	if criteria != "" {
		c.Criteria = strings.TrimSpace(criteria)
	}
	if to == CaseClosed {
		c.ClosedBy, c.ClosedAt = by, now.UTC()
	}
	return nil
}

// OverrideOnset records a reviewer disagreeing with the derivation
// (SRS-IPC-001).
//
// Kept apart from the derived value, always. A reviewer may know the patient
// was transferred in with the infection already incubating, and that judgement
// belongs in the record — but a field that replaced the derivation would make
// every reclassification invisible, and reclassifying healthcare-associated
// cases as community-acquired is the single easiest way to make an infection
// rate look good.
func (c *SurveillanceCase) OverrideOnset(to Onset, reason, by string) error {
	switch {
	case to != OnsetCommunity && to != OnsetHealthcare &&
		to != OnsetIndeterminate:
		return fmt.Errorf("%w: unknown onset classification %q",
			ErrInvalidInfection, to)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf(
			"%w: say why this classification differs from the dates",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an override names who made it",
			ErrInvalidInfection)
	case to == c.Onset:
		return fmt.Errorf("%w: that is already what the dates say",
			ErrInvalidInfection)
	}
	c.OnsetOverride = to
	c.OnsetOverrideWhy = strings.TrimSpace(reason)
	c.OnsetOverriddenBy = by
	return nil
}

// DeviceDayCount is one day's device usage in one location (SRS-IPC-002).
//
// The denominator of every device-associated rate, counted daily rather than
// estimated. A rate whose denominator was estimated is a rate that moves when
// somebody changes their estimate, and the requirement's acceptance is that
// rates are reproducible.
type DeviceDayCount struct {
	ID         string
	TenantID   string
	FacilityID string
	LocationID string

	Device DeviceKind
	// On is the calendar day the census was taken. One count per device per
	// location per day, because two would double the denominator and halve
	// every rate that reads it.
	On time.Time
	// PatientDays is the ward's census that day, which is what a
	// device-utilisation ratio is over.
	PatientDays int
	// DeviceDays is how many patients had the device in place.
	DeviceDays int

	RecordedAt time.Time
	RecordedBy string
}

// NewDeviceDayCount records one day's census (SRS-IPC-002).
func NewDeviceDayCount(id, tenantID, facilityID, locationID string,
	device DeviceKind, on time.Time, patientDays, deviceDays int,
	by string, now time.Time) (DeviceDayCount, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return DeviceDayCount{}, fmt.Errorf("%w: a count needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(locationID) == "":
		return DeviceDayCount{}, fmt.Errorf("%w: a count names its location",
			ErrInvalidInfection)
	case !knownDevice[device]:
		return DeviceDayCount{}, fmt.Errorf("%w: unknown device %q",
			ErrInvalidInfection, device)
	case on.IsZero():
		return DeviceDayCount{}, fmt.Errorf("%w: a count needs its day",
			ErrInvalidInfection)
	case patientDays < 0 || deviceDays < 0:
		return DeviceDayCount{}, fmt.Errorf("%w: a census cannot be negative",
			ErrInvalidInfection)
	case deviceDays > patientDays:
		// More devices than patients is a counting mistake, and it produces a
		// utilisation ratio above one that nobody can explain.
		return DeviceDayCount{}, fmt.Errorf(
			"%w: %d device days exceeds %d patient days",
			ErrInvalidInfection, deviceDays, patientDays)
	}

	return DeviceDayCount{
		ID: id, TenantID: tenantID, FacilityID: facilityID,
		LocationID: locationID, Device: device,
		On:          on.UTC().Truncate(24 * time.Hour),
		PatientDays: patientDays, DeviceDays: deviceDays,
		RecordedAt: now.UTC(), RecordedBy: by,
	}, nil
}

// Rate is one infection rate over one period (SRS-IPC-002, SRS-IPC-010).
type Rate struct {
	Site     InfectionSite
	Device   DeviceKind
	Location string
	From, To time.Time

	// Infections is the numerator: confirmed, healthcare-associated cases at
	// this site.
	Infections int
	// DeviceDays and PatientDays are the denominators, summed from the daily
	// counts.
	DeviceDays  int
	PatientDays int

	// PerThousandDeviceDays is the rate, in tenths so that 4.7 is stored as
	// 47. Integer arithmetic throughout: a rate that reads 4.699999 in one
	// report and 4.7 in another is an argument in a committee meeting.
	PerThousandDeviceDays int
	// UtilisationPermille is device days over patient days, parts per
	// thousand. A rate falling because the ward stopped using the device is a
	// different fact from a rate falling because it got safer, and only this
	// tells them apart.
	UtilisationPermille int

	// Unanswerable marks a period with no denominator. Named rather than
	// reported as a rate of zero, because "no ventilated patients this month"
	// and "no infections among our ventilated patients" are different facts
	// and only one of them is good news.
	Unanswerable bool
}

// RateInput is what a rate is computed from.
type RateInput struct {
	Site     InfectionSite
	Location string
	From, To time.Time
	Cases    []SurveillanceCase
	Counts   []DeviceDayCount
}

// ComputeRate derives one device-associated infection rate (SRS-IPC-002).
//
// The numerator counts confirmed, healthcare-associated cases only. A
// suspected case is not an infection yet and a community-acquired one is not
// the hospital's, and counting either would make the rate measure something
// other than what it claims.
func ComputeRate(in RateInput) Rate {
	device, associated := DeviceFor(in.Site)
	out := Rate{
		Site: in.Site, Device: device, Location: in.Location,
		From: in.From.UTC(), To: in.To.UTC(),
	}

	for _, one := range in.Cases {
		switch {
		case one.Site != in.Site:
			continue
		case in.Location != "" && one.LocationID != in.Location:
			continue
		case one.State != CaseConfirmed:
			continue
		case !one.EffectiveOnset().HealthcareAssociated():
			continue
		case one.OnsetAt.Before(in.From) || !one.OnsetAt.Before(in.To):
			continue
		}
		out.Infections++
	}

	// The denominator is counted by calendar day, so the period is read by
	// calendar day too. Comparing a midnight census against a period that
	// starts at half past two drops that day's device days while keeping its
	// infections — which inflates the rate, silently, in whichever direction
	// the caller's clock happened to fall.
	fromDay := in.From.UTC().Truncate(24 * time.Hour)
	toDay := in.To.UTC().Truncate(24 * time.Hour)

	for _, count := range in.Counts {
		if associated && count.Device != device {
			continue
		}
		if in.Location != "" && count.LocationID != in.Location {
			continue
		}
		if count.On.Before(fromDay) || !count.On.Before(toDay) {
			continue
		}
		out.DeviceDays += count.DeviceDays
		out.PatientDays += count.PatientDays
	}

	if out.PatientDays > 0 {
		out.UtilisationPermille = permille(int64(out.DeviceDays),
			int64(out.PatientDays))
	}
	if out.DeviceDays == 0 {
		out.Unanswerable = true
		return out
	}
	// Per thousand device days, in tenths: infections × 10 000 / device days,
	// rounded to nearest.
	out.PerThousandDeviceDays = int(
		(int64(out.Infections)*20000 + int64(out.DeviceDays)) /
			(int64(out.DeviceDays) * 2))
	return out
}

// permille is a over b in parts per thousand, rounded to nearest.
func permille(a, b int64) int {
	if b == 0 {
		return 0
	}
	return int((a*2000 + b) / (b * 2))
}

// OnsetSummary counts how a period's cases were classified (SRS-IPC-010).
//
// Overrides are counted separately and never folded in. A month in which
// eleven healthcare-associated infections were reclassified by hand is a month
// somebody should look at, and a summary that showed only the final numbers
// would hide exactly that.
type OnsetSummary struct {
	Healthcare            int
	Community             int
	Indeterminate         int
	Overridden            int
	OverriddenToCommunity int
}

// SummariseOnset counts the classifications in a set of cases.
func SummariseOnset(cases []SurveillanceCase) OnsetSummary {
	var out OnsetSummary
	for _, one := range cases {
		switch one.EffectiveOnset() {
		case OnsetHealthcare:
			out.Healthcare++
		case OnsetCommunity:
			out.Community++
		default:
			out.Indeterminate++
		}
		if one.OnsetOverride == "" {
			continue
		}
		out.Overridden++
		// The direction that makes a rate look better.
		if one.Onset == OnsetHealthcare &&
			one.OnsetOverride == OnsetCommunity {
			out.OverriddenToCommunity++
		}
	}
	return out
}

// sortCases orders by onset, newest first, with a stable tiebreak so two
// reads of the same period agree.
func sortCases(in []SurveillanceCase) {
	sort.Slice(in, func(a, b int) bool {
		if !in[a].OnsetAt.Equal(in[b].OnsetAt) {
			return in[a].OnsetAt.After(in[b].OnsetAt)
		}
		return in[a].ID < in[b].ID
	})
}
