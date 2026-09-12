package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
)

// Problems, allergies, observations, procedures, plans, consents, calculators,
// decision support, consults and registries
// (SRS-CLN-001, 003 … 007, 010 … 014, 017, 020 … 023).

func code(system, c, display string) domain.Coding {
	return domain.Coding{System: system, Version: "2019", Code: c, Display: display}
}

// SRS-CLN-003: "resolved problem remains historical".
//
// A problem list that forgot a resolved myocardial infarction would hide the
// single most important fact about the patient in front of you.
func TestAResolvedProblemStaysOnTheList(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	p, err := domain.NewProblem("pr-1", "t-1", "p-1", "e-1",
		code("icd-10", "I21.9", "Acute myocardial infarction"), "",
		domain.ProblemActive, at(2020, time.June, 1, 0),
		domain.ConfidentialityNormal, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewProblem: %v", err)
	}

	if err := p.Resolve(at(2020, time.July, 1, 0), "doctor-1", now); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if p.Status != domain.ProblemResolved || p.ResolvedAt.IsZero() {
		t.Fatalf("problem = %+v, want resolved with a date", p)
	}
	if p.Code.Code != "I21.9" {
		t.Fatal("resolving the problem erased what it was")
	}

	// It drops off the active list and stays in the record.
	list := domain.ProblemList{p}
	if len(list.Active()) != 0 {
		t.Fatal("a resolved problem is still shown as active")
	}
	if len(list) != 1 {
		t.Fatal("the resolved problem was dropped from the list entirely")
	}
}

func TestAProblemCannotResolveBeforeItBegan(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	p, err := domain.NewProblem("pr-1", "t-1", "p-1", "e-1",
		code("icd-10", "E11", "Type 2 diabetes"), "", domain.ProblemActive,
		at(2020, time.June, 1, 0), domain.ConfidentialityNormal, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewProblem: %v", err)
	}
	if err := p.Resolve(at(2019, time.June, 1, 0), "doctor-1", now); err == nil {
		t.Fatal("a problem resolved a year before it began")
	}
}

// SRS-CLN-004: "allergy is available to medication decision support
// immediately after commit" — which means coded, because free text cannot be
// checked against a prescription.
func TestAnAllergySubstanceMustBeCoded(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	_, err := domain.NewAllergy("al-1", "t-1", "p-1", "e-1",
		domain.Coding{Display: "penicillin"}, domain.AllergyTrue,
		domain.CriticalityHigh, domain.VerificationUnconfirmed, nil,
		time.Time{}, "", "nurse-1", now)
	if err == nil {
		t.Fatal("an allergy was recorded with an uncoded substance, so decision " +
			"support cannot check a prescription against it")
	}
}

// A patient who says they are allergic to penicillin is a patient who should
// not be given penicillin. A system that only warned on confirmed allergies
// would be silent for most of the ones it knows about.
func TestAnUnconfirmedAllergyStillWarns(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	a, err := domain.NewAllergy("al-1", "t-1", "p-1", "e-1",
		code("snomed-ct", "373270004", "Penicillin"), domain.AllergyTrue,
		domain.CriticalityHigh, domain.VerificationUnconfirmed,
		[]domain.Reaction{{Manifestation: code("snomed-ct", "39579001", "Anaphylaxis")}},
		time.Time{}, "patient reports", "nurse-1", now)
	if err != nil {
		t.Fatalf("NewAllergy: %v", err)
	}
	if !a.Active() {
		t.Fatal("an unconfirmed allergy does not warn a prescriber")
	}

	// A refuted one does not: somebody investigated and settled it.
	if err := a.SetVerification(domain.VerificationRefuted, "doctor-1", now); err != nil {
		t.Fatalf("SetVerification: %v", err)
	}
	if a.Active() {
		t.Fatal("an investigated and refuted allergy still warns")
	}
	// And it stays in the record, so the next clinician does not ask the
	// patient again and get the same wrong answer.
	if a.Substance.Code != "373270004" {
		t.Fatal("refuting the allergy erased what it was")
	}
}

// "Nobody has assessed this" is not the same as "this is mild".
func TestAnUnassessedAllergyOutranksAnIntolerance(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	build := func(id, display string, criticality domain.AllergyCriticality) domain.Allergy {
		a, err := domain.NewAllergy(id, "t-1", "p-1", "e-1",
			code("snomed-ct", id, display), domain.AllergyTrue, criticality,
			domain.VerificationUnconfirmed, nil, time.Time{}, "", "nurse-1", now)
		if err != nil {
			t.Fatalf("NewAllergy: %v", err)
		}
		return a
	}

	list := domain.AllergyList{
		build("a", "Codeine", domain.CriticalityLow),
		build("b", "Contrast media", domain.CriticalityUnableToAssess),
		build("c", "Penicillin", domain.CriticalityHigh),
	}

	active := list.Active()
	if active[0].Criticality != domain.CriticalityHigh {
		t.Fatal("the allergy that could kill is not listed first")
	}
	if active[1].Criticality != domain.CriticalityUnableToAssess {
		t.Fatal("an unassessed allergy was buried under the intolerances")
	}
	if !list.HasHighCriticality() {
		t.Fatal("a high-criticality allergy is not reported for the banner")
	}
}

// SRS-CLN-005: "trend query retains original unit/source".
func TestAMeasuredValueNeedsItsUnit(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	_, err := domain.NewObservation("ob-1", "t-1", domain.NewObservationInput{
		PatientID: "p-1", EncounterID: "e-1",
		Code:                 code("loinc", "2823-3", "Potassium"),
		Value:                domain.Quantity{Value: 6.1},
		Status:               domain.ObservationFinal,
		Interpretation:       domain.InterpretationCriticalHigh,
		InterpretationSource: "central laboratory",
	}, "lab-1", now)
	if err == nil {
		t.Fatal("a potassium of 6.1 was stored with no unit")
	}
	if !strings.Contains(err.Error(), "mmol/L") {
		t.Fatalf("the refusal does not explain why the unit matters: %v", err)
	}
}

// SRS-CLN-011: "UI must not infer criticality independently; flag provenance
// visible".
func TestAnInterpretationMustNameItsSource(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	_, err := domain.NewObservation("ob-1", "t-1", domain.NewObservationInput{
		PatientID: "p-1", EncounterID: "e-1",
		Code:           code("loinc", "2823-3", "Potassium"),
		Value:          domain.Quantity{Value: 6.1, Unit: "mmol/L"},
		Status:         domain.ObservationFinal,
		Interpretation: domain.InterpretationCriticalHigh,
	}, "lab-1", now)
	if err == nil {
		t.Fatal("a result was flagged critical with nobody named as having decided it")
	}
}

// "Nobody said" and "it is fine" are different claims.
func TestAnUnknownInterpretationIsNotNormal(t *testing.T) {
	if domain.InterpretationUnknown.Abnormal() {
		t.Fatal("an unassessed result is reported as abnormal")
	}
	if domain.InterpretationNormal.Abnormal() {
		t.Fatal("a normal result is reported as abnormal")
	}
	if !domain.InterpretationCriticalHigh.Critical() {
		t.Fatal("a critical high is not reported as critical")
	}
	if domain.InterpretationHigh.Critical() {
		t.Fatal("a merely high result is reported as critical")
	}
}

// A trend is read left to right.
func TestATrendIsOldestFirstAndKeepsItsSource(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	build := func(id string, value float64, at time.Time, source string) domain.Observation {
		o, err := domain.NewObservation(id, "t-1", domain.NewObservationInput{
			PatientID: "p-1", EncounterID: "e-1",
			Code:                 code("loinc", "2823-3", "Potassium"),
			Value:                domain.Quantity{Value: value, Unit: "mmol/L"},
			Status:               domain.ObservationFinal,
			Interpretation:       domain.InterpretationNormal,
			InterpretationSource: "central laboratory",
			EffectiveAt:          at, SourceSystem: source,
		}, "lab-1", now)
		if err != nil {
			t.Fatalf("NewObservation: %v", err)
		}
		return o
	}

	list := domain.ObservationList{
		build("ob-3", 4.5, at(2026, time.March, 3, 8), ""),
		build("ob-1", 5.9, at(2026, time.March, 1, 8), "regional exchange"),
		build("ob-2", 5.1, at(2026, time.March, 2, 8), ""),
	}

	trend := list.Trend("loinc", "2823-3")
	if len(trend) != 3 {
		t.Fatalf("%d results in the trend, want 3", len(trend))
	}
	for i := 1; i < len(trend); i++ {
		if trend[i].EffectiveAt.Before(trend[i-1].EffectiveAt) {
			t.Fatal("the trend is not oldest-first")
		}
	}
	// SRS-CLN-010: external data stays distinguishable from local.
	if !trend[0].External() {
		t.Fatal("a result imported from another organisation is indistinguishable " +
			"from one this laboratory produced")
	}
	if trend[1].External() {
		t.Fatal("a locally produced result is reported as external")
	}
	// Unit and source survive the trend.
	if trend[0].Value.Unit != "mmol/L" {
		t.Fatal("the trend lost the original unit")
	}
}

// SRS-CLN-012: "acknowledge ... with timestamp and action/comment".
//
// "Seen" is not a clinical response to a potassium of 6.9.
func TestAcknowledgingACriticalResultNeedsTheActionTaken(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	notified := now.Add(-20 * time.Minute)

	if _, err := domain.NewCriticalAcknowledgement("ack-1", "t-1", "ob-1", "p-1",
		"doctor-1", "seen", notified, now); err == nil {
		t.Fatal("a critical result was acknowledged with a bare click")
	}

	ack, err := domain.NewCriticalAcknowledgement("ack-1", "t-1", "ob-1", "p-1",
		"doctor-1", "calcium gluconate and insulin-dextrose given, repeat sent",
		notified, now)
	if err != nil {
		t.Fatalf("NewCriticalAcknowledgement: %v", err)
	}

	// The gap between notification and acknowledgement is the number a safety
	// review wants.
	delay, known := ack.Delay()
	if !known || delay != 20*time.Minute {
		t.Fatalf("delay = %v (known %v), want 20m", delay, known)
	}
}

// A policy measured in hours has already failed for a potassium of 7.
func TestAnUnacknowledgedCriticalResultEscalates(t *testing.T) {
	policy := domain.DefaultEscalationPolicy()
	notified := at(2026, time.March, 3, 9)

	if n := policy.DueEscalations(notified, notified.Add(5*time.Minute)); n != 0 {
		t.Fatalf("%d escalations after five minutes, want 0", n)
	}
	if n := policy.DueEscalations(notified, notified.Add(16*time.Minute)); n != 1 {
		t.Fatalf("%d escalations after sixteen minutes, want 1", n)
	}
	if n := policy.DueEscalations(notified, notified.Add(50*time.Minute)); n != 3 {
		t.Fatalf("%d escalations after fifty minutes, want 3", n)
	}
	// Unbounded escalation ends at the chief executive's phone at 3am for a
	// result somebody is already acting on.
	if n := policy.DueEscalations(notified, notified.Add(24*time.Hour)); n != 3 {
		t.Fatalf("%d escalations after a day, want the configured maximum of 3", n)
	}
}

// SRS-CLN-006: a completed procedure names who did it.
func TestACompletedProcedureNamesItsPerformer(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	_, err := domain.NewProcedure("proc-1", "t-1", domain.NewProcedureInput{
		PatientID: "p-1", EncounterID: "e-1",
		Code:   code("snomed-ct", "80146002", "Appendicectomy"),
		Status: domain.ProcedureCompleted, Laterality: domain.LateralityNotApplicable,
	}, "doctor-1", now)
	if err == nil {
		t.Fatal("a completed operation was recorded with nobody attached to it")
	}
}

// Wrong-side surgery is a never-event, and the only defence a record offers is
// that the side was stated unambiguously.
func TestALateralityIsStatedRatherThanAssumed(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	p, err := domain.NewProcedure("proc-1", "t-1", domain.NewProcedureInput{
		PatientID: "p-1", EncounterID: "e-1",
		Code:       code("snomed-ct", "112724006", "Total knee replacement"),
		Status:     domain.ProcedureCompleted,
		Performers: []domain.Performer{{SubjectID: "doctor-1", Role: "surgeon"}},
		BodySite:   code("snomed-ct", "72696002", "Knee"),
		Laterality: domain.LateralityUnspecified,
	}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewProcedure: %v", err)
	}
	// Unspecified is recorded as unspecified rather than silently becoming
	// "not applicable": an omission must not look like a decision.
	if p.Laterality != domain.LateralityUnspecified {
		t.Fatalf("laterality = %q, want the omission preserved", p.Laterality)
	}

	if _, err := domain.NewProcedure("proc-2", "t-1", domain.NewProcedureInput{
		PatientID: "p-1", EncounterID: "e-1",
		Code:       code("snomed-ct", "112724006", "Total knee replacement"),
		Status:     domain.ProcedureCompleted,
		Performers: []domain.Performer{{SubjectID: "doctor-1", Role: "surgeon"}},
		Laterality: "sideways",
	}, "doctor-1", now); err == nil {
		t.Fatal("a procedure was recorded with an unrecognised laterality")
	}
}

// A complication in free text is a complication that never reaches a quality
// report.
func TestAComplicationIsCoded(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	p, err := domain.NewProcedure("proc-1", "t-1", domain.NewProcedureInput{
		PatientID: "p-1", EncounterID: "e-1",
		Code:       code("snomed-ct", "80146002", "Appendicectomy"),
		Status:     domain.ProcedureCompleted,
		Performers: []domain.Performer{{SubjectID: "doctor-1", Role: "surgeon"}},
		Laterality: domain.LateralityNotApplicable,
		Complications: []domain.Coding{
			code("snomed-ct", "213231002", "Intraoperative haemorrhage"),
		},
	}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewProcedure: %v", err)
	}
	if !p.Complicated() {
		t.Fatal("a procedure with a recorded complication is not counted as complicated")
	}
}

// SRS-CLN-007: "tasks can link to care-plan activity", and a plan nobody owns
// is a list of things everybody assumes somebody else is doing.
func TestACarePlanNeedsAnOwnerAndOrdersItsWork(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewCarePlan("cp-1", "t-1", "p-1", "e-1", "Diabetes management",
		nil, nil, nil, "", time.Time{}, time.Time{}, "doctor-1", now); err == nil {
		t.Fatal("a care plan was created with nobody accountable for it")
	}

	plan, err := domain.NewCarePlan("cp-1", "t-1", "p-1", "e-1", "Diabetes management",
		[]string{"pr-1"},
		[]domain.Goal{{ID: "g-1", Description: "HbA1c below 58", Status: domain.GoalActive}},
		[]domain.Activity{
			{ID: "a-1", Description: "Dietitian review", Status: domain.ActivityScheduled,
				OwnerID: "dietitian-1", ScheduledFor: now.Add(48 * time.Hour), TaskID: "task-1"},
			{ID: "a-2", Description: "Foot check", Status: domain.ActivityScheduled,
				OwnerID: "nurse-1", ScheduledFor: now.Add(2 * time.Hour)},
			{ID: "a-3", Description: "Annual retinal screening",
				Status: domain.ActivityNotStarted, OwnerID: "nurse-1"},
			{ID: "a-4", Description: "Initial assessment", Status: domain.ActivityCompleted,
				OwnerID: "doctor-1"},
		}, "doctor-1", now, time.Time{}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewCarePlan: %v", err)
	}

	outstanding := plan.OutstandingActivities()
	if len(outstanding) != 3 {
		t.Fatalf("%d outstanding activities, want the completed one excluded",
			len(outstanding))
	}
	if outstanding[0].ID != "a-2" {
		t.Fatalf("the worklist leads with %q, want the soonest", outstanding[0].ID)
	}
	// An undated activity is not urgent, and putting it at the top of a
	// worklist buries the ones that are.
	if outstanding[len(outstanding)-1].ID != "a-3" {
		t.Fatal("an undated activity sorted above dated ones")
	}
	// The activity links to the task that carries it out, so the worklist and
	// the plan do not drift.
	if outstanding[1].TaskID != "task-1" {
		t.Fatal("a care-plan activity lost its link to the task")
	}
}

// SRS-CLN-010: external data is distinguishable, with the organisation named.
func TestProvenanceNamesWhereDataCameFrom(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewProvenance("pv-1", "t-1", "observation", "ob-1",
		domain.ProvenanceInput{SourceSystem: "some interface"}, now); err == nil {
		t.Fatal("provenance was recorded without naming the organisation")
	}

	pv, err := domain.NewProvenance("pv-1", "t-1", "observation", "ob-1",
		domain.ProvenanceInput{
			SourceOrganization: "St Mary's Hospital", SourceSystem: "Sunquest",
			SourceRecordID: "LAB-88421",
			AuthoredAt:     at(2026, time.March, 1, 9), AuthoredBy: "Dr A Khan",
		}, now)
	if err != nil {
		t.Fatalf("NewProvenance: %v", err)
	}
	// When it was true of the patient and when it arrived here are both kept:
	// a result from March that arrived in September was not available to the
	// clinician who saw the patient in June.
	if pv.AuthoredAt.Equal(pv.IngestedAt) {
		t.Fatal("the authored and ingested times were collapsed into one")
	}
}

// SRS-CLN-014: "attachment access follows parent record and classification" —
// so the attachment carries its own class.
func TestAnAttachmentCarriesItsOwnConfidentiality(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	a, err := domain.NewAttachment("att-1", "t-1", domain.NewAttachmentInput{
		ParentType: "document", ParentID: "doc-1", PatientID: "p-1",
		Kind: domain.AttachmentImage, ContentType: "image/jpeg",
		StorageKey: "t-1/att-1", SizeBytes: 204_800,
		Description: "Injury photograph",
		// Tighter than the ordinary note it hangs from.
		Confidentiality: domain.ConfidentialityRestricted,
	}, "nurse-1", now)
	if err != nil {
		t.Fatalf("NewAttachment: %v", err)
	}
	if !a.Confidentiality.Restricted() {
		t.Fatal("a restricted attachment does not report itself as restricted")
	}

	if _, err := domain.NewAttachment("att-2", "t-1", domain.NewAttachmentInput{
		ParentType: "document", ParentID: "doc-1", PatientID: "p-1",
		Kind: domain.AttachmentImage, ContentType: "image/jpeg",
		StorageKey: "t-1/att-2", SizeBytes: 0,
		Confidentiality: domain.ConfidentialityNormal,
	}, "nurse-1", now); err == nil {
		t.Fatal("an empty attachment was accepted")
	}
}

// SRS-CLN-013: a clinical consent is not a privacy consent, and a consent for
// "a procedure" is not a consent for any procedure.
func TestAProcedureConsentNamesTheProcedure(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewClinicalConsent("cc-1", "t-1", domain.NewConsentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.ConsentProcedure,
		Status: domain.ConsentGiven, GivenBy: domain.GivenByPatient,
	}, "doctor-1", now); err == nil {
		t.Fatal("a consent for an unnamed procedure was accepted")
	}

	appendicectomy := code("snomed-ct", "80146002", "Appendicectomy")
	consent, err := domain.NewClinicalConsent("cc-1", "t-1", domain.NewConsentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.ConsentProcedure,
		ProcedureCode: appendicectomy, Status: domain.ConsentGiven,
		GivenBy: domain.GivenByPatient, ValidFrom: now,
		ValidUntil: now.Add(30 * 24 * time.Hour),
	}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewClinicalConsent: %v", err)
	}

	set := domain.ConsentSet{consent}
	if !set.Permits(domain.ConsentProcedure, appendicectomy, now.Add(time.Hour)) {
		t.Fatal("the consent does not permit the procedure it names")
	}
	// Consent for one operation is not consent for another.
	if set.Permits(domain.ConsentProcedure,
		code("snomed-ct", "112724006", "Total knee replacement"), now) {
		t.Fatal("a consent for an appendicectomy permitted a knee replacement")
	}
	// And it expires.
	if set.Permits(domain.ConsentProcedure, appendicectomy, now.Add(60*24*time.Hour)) {
		t.Fatal("a consent given a month ago still permits the operation")
	}
}

// A consent given on somebody's behalf must name who gave it.
func TestAConsentGivenOnSomebodysBehalfNamesTheGiver(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewClinicalConsent("cc-1", "t-1", domain.NewConsentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.ConsentTreatment,
		Status: domain.ConsentGiven, GivenBy: domain.GivenByParent,
	}, "doctor-1", now); err == nil {
		t.Fatal("a consent was recorded as given by an unnamed parent")
	}
}

// Deny by default: an absent consent means nobody asked, and a refusal is a
// different fact a UI must be able to show.
func TestAnAbsentConsentIsNotAConsentAndARefusalIsVisible(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	empty := domain.ConsentSet{}
	if empty.Permits(domain.ConsentTransfusion, domain.Coding{}, now) {
		t.Fatal("an act proceeded on a consent nobody recorded")
	}

	refused, err := domain.NewClinicalConsent("cc-1", "t-1", domain.NewConsentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.ConsentTransfusion,
		Status: domain.ConsentRefused, GivenBy: domain.GivenByPatient,
	}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewClinicalConsent: %v", err)
	}
	set := domain.ConsentSet{refused}
	if set.Permits(domain.ConsentTransfusion, domain.Coding{}, now) {
		t.Fatal("a refused consent permitted the act")
	}
	if !set.Refused(domain.ConsentTransfusion, now) {
		t.Fatal("a recorded refusal is indistinguishable from nobody having asked")
	}
}

// SRS-CLN-001: a banner with fifteen alerts is a banner nobody reads.
func TestTheBannerLeadsWithWhatCouldKill(t *testing.T) {
	alerts := []domain.Alert{
		{Severity: domain.AlertInfo, Kind: "note", Text: "Interpreter needed"},
		{Severity: domain.AlertWarning, Kind: "infection_control", Text: "MRSA"},
		{Severity: domain.AlertInfo, Kind: "note", Text: "Hard of hearing"},
		{Severity: domain.AlertInfo, Kind: "note", Text: "Prefers morning appointments"},
		{Severity: domain.AlertInfo, Kind: "note", Text: "Wheelchair user"},
		{Severity: domain.AlertCritical, Kind: "allergy", Text: "Penicillin — anaphylaxis"},
		{Severity: domain.AlertInfo, Kind: "note", Text: "Dietary requirement"},
	}

	banner := domain.BuildBanner("p-1", "Meera Iyer", "42y", "female",
		[]domain.BannerIdentifier{{System: "mrn", Value: "MAIN-0000001", Label: "MRN"}},
		alerts, "Ward 4, inpatient, day 3", false)

	if len(banner.Alerts) > domain.MaxBannerAlerts {
		t.Fatalf("%d alerts on the banner, want at most %d",
			len(banner.Alerts), domain.MaxBannerAlerts)
	}
	if banner.Alerts[0].Severity != domain.AlertCritical {
		t.Fatal("the alert that could kill the patient is not first; it would be " +
			"the one that scrolled off")
	}
	if banner.EncounterContext == "" {
		t.Fatal("the banner does not say which visit the screen is in")
	}
}

// An intolerance belongs in the chart. On the banner it would crowd out the
// anaphylaxis.
func TestOnlyDangerousAllergiesReachTheBanner(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	build := func(id, display string, criticality domain.AllergyCriticality) domain.Allergy {
		a, err := domain.NewAllergy(id, "t-1", "p-1", "e-1",
			code("snomed-ct", id, display), domain.AllergyTrue, criticality,
			domain.VerificationConfirmed, nil, time.Time{}, "", "nurse-1", now)
		if err != nil {
			t.Fatalf("NewAllergy: %v", err)
		}
		return a
	}

	alerts := domain.AlertsFromAllergies(domain.AllergyList{
		build("a", "Codeine — nausea", domain.CriticalityLow),
		build("b", "Penicillin", domain.CriticalityHigh),
	})
	if len(alerts) != 1 {
		t.Fatalf("%d banner alerts, want only the dangerous one", len(alerts))
	}
	if alerts[0].Severity != domain.AlertCritical {
		t.Fatal("an anaphylaxis-grade allergy is not a critical banner alert")
	}
}

// SRS-CLN-017: four charts open, the wrong tab in front, a prescription for
// the patient in the next bed.
func TestThePatientContextLockCatchesTheWrongChart(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	ctx := domain.PatientContext{PatientID: "p-1", EncounterID: "e-1", OpenedAt: now}

	if err := ctx.Check("p-1", "e-1", "prescribing", now.Add(time.Minute)); err != nil {
		t.Fatalf("an action in the right chart was refused: %v", err)
	}

	err := ctx.Check("p-2", "e-9", "prescribing", now.Add(time.Minute))
	if err == nil {
		t.Fatal("a prescription landed on a different patient from the one on screen")
	}
	var mismatch domain.ErrPatientContextMismatch
	if !errors.As(err, &mismatch) {
		t.Fatalf("the refusal is not a context mismatch: %v", err)
	}
	if !strings.Contains(err.Error(), "prescribing") {
		t.Fatalf("the refusal does not name the action: %v", err)
	}
	// The message must not leak the other patient's identifier onto a screen
	// belonging to this one.
	if strings.Contains(err.Error(), "p-2") {
		t.Fatalf("the refusal leaks the other patient's identifier: %v", err)
	}
}

// A screen left open overnight is a screen the next clinician inherits with
// somebody else's patient in it.
func TestAStalePatientContextIsRefused(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	ctx := domain.PatientContext{PatientID: "p-1", OpenedAt: now}

	if err := ctx.Check("p-1", "", "prescribing",
		now.Add(domain.MaxContextAge+time.Minute)); err == nil {
		t.Fatal("an action was taken in a chart opened a shift ago")
	}
}

// A caller that asserted no context is not blocked: this is a lock a client
// opts into, not one the server can impose on batch imports.
func TestNoAssertedContextIsNotAMismatch(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	var unset domain.PatientContext
	if err := unset.Check("p-1", "e-1", "importing", now); err != nil {
		t.Fatalf("an integration call with no asserted context was refused: %v", err)
	}
}

// SRS-CLN-020: "recalculation with new formula never overwrites historical
// result", which starts with storing the inputs and the version.
func TestACalculationStoresItsInputsAndFormulaVersion(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewCalculatorResult("calc-1", "t-1",
		domain.NewCalculatorResultInput{
			PatientID: "p-1", CalculatorID: "cha2ds2-vasc", Name: "CHA2DS2-VASc",
			Inputs: []domain.CalculatorInput{{Name: "age", Value: "78"}},
			Value:  3,
		}, "doctor-1", now); err == nil {
		t.Fatal("a score was stored with no formula version, so it becomes ambiguous " +
			"the first time somebody corrects a coefficient")
	}

	if _, err := domain.NewCalculatorResult("calc-1", "t-1",
		domain.NewCalculatorResultInput{
			PatientID: "p-1", CalculatorID: "cha2ds2-vasc", Version: "2019.1",
			Name: "CHA2DS2-VASc", Value: 3,
		}, "doctor-1", now); err == nil {
		t.Fatal("a score was stored with no inputs, so nobody can check it when it " +
			"looks wrong")
	}

	result, err := domain.NewCalculatorResult("calc-1", "t-1",
		domain.NewCalculatorResultInput{
			PatientID: "p-1", CalculatorID: "cha2ds2-vasc", Version: "2019.1",
			Name: "CHA2DS2-VASc",
			Inputs: []domain.CalculatorInput{
				{Name: "age", Value: "78", Unit: "a"},
				{Name: "hypertension", Value: "true", SourceID: "pr-1"},
			},
			Value: 3, Interpretation: "high risk",
		}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewCalculatorResult: %v", err)
	}
	if !result.Live() {
		t.Fatal("a fresh calculation is not live")
	}
	if result.Inputs[1].SourceID != "pr-1" {
		t.Fatal("the calculation lost which record an input came from")
	}
}

// SRS-CLN-021: "CDS alerts must identify triggering rule/version and allow
// configured override reason; override is stored and reportable".
func TestACDSAlertNamesItsRuleVersionAndRecordsTheOverride(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewCDSAlert("cds-1", "t-1", domain.NewCDSAlertInput{
		PatientID: "p-1", RuleID: "allergy-check", Level: domain.AlertLevelHard,
		Message: "Patient has a recorded anaphylaxis to penicillin",
	}, now); err == nil {
		t.Fatal("an alert fired with no rule version, so an override report cannot " +
			"tell a tuning change from a behaviour change")
	}

	alert, err := domain.NewCDSAlert("cds-1", "t-1", domain.NewCDSAlertInput{
		PatientID: "p-1", EncounterID: "e-1", RuleID: "allergy-check",
		RuleVersion: "4", Level: domain.AlertLevelHard,
		Message:     "Patient has a recorded anaphylaxis to penicillin",
		ContextType: "prescription", ContextID: "rx-1",
	}, now)
	if err != nil {
		t.Fatalf("NewCDSAlert: %v", err)
	}
	if !alert.Blocking() {
		t.Fatal("a pending hard alert does not block the action")
	}

	// "ok" is not a reason for proceeding against a hard clinical alert.
	if err := alert.Respond(domain.CDSOverridden, "", "ok", "doctor-1", now); err == nil {
		t.Fatal("a hard alert was overridden with a two-character reason")
	}

	if err := alert.Respond(domain.CDSOverridden, "documented-tolerance",
		"patient has tolerated this agent since, documented in 2024 clinic letter",
		"doctor-1", now); err != nil {
		t.Fatalf("Respond: %v", err)
	}
	if alert.Blocking() {
		t.Fatal("an answered alert still blocks")
	}
	// A chosen code is what makes overrides reportable rather than a pile of
	// free text.
	if alert.OverrideCode != "documented-tolerance" {
		t.Fatal("the chosen override reason was not stored")
	}

	// Answering twice would let a second click rewrite the first clinician's
	// stated reason.
	if err := alert.Respond(domain.CDSAccepted, "", "", "doctor-2", now); err == nil {
		t.Fatal("an answered alert was answered again")
	}
}

// A soft alert warns and lets the clinician proceed: a system where everything
// is a hard stop is a system where clinicians learn to dismiss hard stops.
func TestASoftAlertDoesNotBlock(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	alert, err := domain.NewCDSAlert("cds-1", "t-1", domain.NewCDSAlertInput{
		PatientID: "p-1", RuleID: "duplicate-therapy", RuleVersion: "2",
		Level: domain.AlertLevelSoft, Message: "Similar agent already prescribed",
	}, now)
	if err != nil {
		t.Fatalf("NewCDSAlert: %v", err)
	}
	if alert.Blocking() {
		t.Fatal("a soft alert blocks the action")
	}
	if err := alert.Respond(domain.CDSAccepted, "", "", "doctor-1", now); err != nil {
		t.Fatalf("accepting a soft alert was refused: %v", err)
	}
}

// SRS-CLN-022: "consult response closes loop and remains linked".
func TestAConsultStatesItsQuestionAndCloseTheLoop(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	// A consult with background but no question produces an opinion that
	// answers something else.
	if _, err := domain.NewConsult("con-1", "t-1", "p-1", "e-1", "cardiology",
		domain.UrgencyUrgent, "78-year-old with chest pain", "", "doctor-1",
		now); err == nil {
		t.Fatal("a consult was raised with no stated question")
	}

	consult, err := domain.NewConsult("con-1", "t-1", "p-1", "e-1", "cardiology",
		domain.UrgencyUrgent, "78-year-old with chest pain, troponin 45",
		"Does this need angiography before discharge?", "doctor-1", now)
	if err != nil {
		t.Fatalf("NewConsult: %v", err)
	}
	if !consult.Open() {
		t.Fatal("a new consult is not open")
	}

	if err := consult.Accept("cardiologist-1", now.Add(time.Hour)); err != nil {
		t.Fatalf("Accept: %v", err)
	}
	if err := consult.Answer("cardiologist-1",
		"No. Medical management, outpatient CT coronary angiogram arranged.",
		"doc-9", now.Add(2*time.Hour)); err != nil {
		t.Fatalf("Answer: %v", err)
	}

	if consult.Open() {
		t.Fatal("an answered consult is still open")
	}
	// The answer lands on the request rather than becoming a free-floating
	// note: a requester who has to search the chart for the reply will not
	// find it.
	if consult.ResponseDocumentID != "doc-9" || consult.Response == "" {
		t.Fatalf("consult = %+v, want the response linked to the request", consult)
	}
	if consult.RespondedAt.IsZero() {
		t.Fatal("the response has no time")
	}

	// Answering twice would overwrite the first opinion.
	if err := consult.Answer("cardiologist-2", "Actually yes.", "", now); err == nil {
		t.Fatal("an answered consult was answered again")
	}
}

// A declined consult with no reason leaves the requester waiting for an answer
// that is never coming.
func TestDecliningAConsultNeedsAReason(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	consult, err := domain.NewConsult("con-1", "t-1", "p-1", "e-1", "cardiology",
		domain.UrgencyRoutine, "background", "question?", "doctor-1", now)
	if err != nil {
		t.Fatalf("NewConsult: %v", err)
	}

	if err := consult.Decline("cardiologist-1", "", now); err == nil {
		t.Fatal("a consult was declined with no reason")
	}
	if err := consult.Decline("cardiologist-1",
		"please refer to the general medical team first", now); err != nil {
		t.Fatalf("Decline: %v", err)
	}
	if consult.Open() {
		t.Fatal("a declined consult is still open")
	}
	// Recorded rather than deleted: a declined consult is the fact a requester
	// most needs.
	if consult.DeclineReason == "" {
		t.Fatal("the decline reason was not kept")
	}
}

// SRS-CLN-023: "registry membership points to canonical clinical facts".
func TestARegistryMembershipPointsAtSomething(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewRegistryMembership("rm-1", "t-1", "p-1", "diabetes",
		"", "", now, true, "nurse-1", now); err == nil {
		t.Fatal("a registry membership was created resting on nothing, so it cannot " +
			"be re-derived or defended")
	}

	m, err := domain.NewRegistryMembership("rm-1", "t-1", "p-1", "diabetes",
		"pr-1", "", now, true, "nurse-1", now)
	if err != nil {
		t.Fatalf("NewRegistryMembership: %v", err)
	}
	if !m.Current(now.Add(time.Hour)) {
		t.Fatal("a fresh membership is not current")
	}

	if err := m.Exit(now.Add(24*time.Hour), "", now); err == nil {
		t.Fatal("a patient left a registry with no reason")
	}
	if err := m.Exit(now.Add(24*time.Hour), "moved to another region", now); err != nil {
		t.Fatalf("Exit: %v", err)
	}
	if m.Current(now.Add(48 * time.Hour)) {
		t.Fatal("a membership that ended yesterday is still current")
	}
}
