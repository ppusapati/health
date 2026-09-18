package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
)

var at = time.Date(2026, 9, 18, 8, 0, 0, 0, time.UTC)

func assessment(t *testing.T, mutate func(*domain.NewAssessmentInput)) domain.Assessment {
	t.Helper()

	in := domain.NewAssessmentInput{
		CaseID: "case-1", EncounterID: "enc-1", PatientID: "pat-1",
		History: "Hypertension, ex-smoker", ASAGrade: domain.ASA2,
		Airway:       domain.AirwayAssessment{Mallampati: "II", MouthOpeningMM: 45},
		Risks:        []string{"sore throat", "PONV"},
		Plan:         "GA with LMA",
		Consent:      domain.ConsentObtained,
		FitToProceed: true,
	}
	if mutate != nil {
		mutate(&in)
	}
	a, err := domain.NewAssessment("as-1", "tenant-1", in, "anaes-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	return a
}

// SRS-ANE-001. An assessment floating free of an operation is an opinion about
// a patient rather than about a procedure.
func TestAnAssessmentIsLinkedToTheProcedure(t *testing.T) {
	_, err := domain.NewAssessment("as-1", "tenant-1", domain.NewAssessmentInput{
		PatientID: "pat-1", ASAGrade: domain.ASA2, FitToProceed: true,
	}, "anaes-1", at)
	if err == nil {
		t.Fatal("an assessment with no case was accepted")
	}
}

// The ASA grade is the one number everybody downstream reads first, and the
// emergency modifier is part of it: "3" and "3E" are different patients.
func TestTheASAGradeIsRequiredAndCarriesItsModifier(t *testing.T) {
	if _, err := domain.NewAssessment("as-1", "tenant-1", domain.NewAssessmentInput{
		CaseID: "case-1", PatientID: "pat-1", FitToProceed: true,
	}, "anaes-1", at); err == nil {
		t.Fatal("an assessment with no ASA grade was accepted")
	}

	emergency := assessment(t, func(in *domain.NewAssessmentInput) {
		in.ASAGrade = domain.ASA3E
	})
	if !emergency.ASAGrade.Emergency() {
		t.Fatal("the emergency modifier was lost")
	}
	if emergency.ASAGrade == domain.ASA3 {
		t.Fatal("3E and 3 are the same value")
	}
}

// Refused consent and not-required consent are both states a review asks
// about, and neither explains itself.
func TestUnusualConsentStatesNeedAnExplanation(t *testing.T) {
	for _, status := range []domain.ConsentStatus{
		domain.ConsentRefused, domain.ConsentNotRequired,
	} {
		if _, err := domain.NewAssessment("as-1", "tenant-1",
			domain.NewAssessmentInput{
				CaseID: "case-1", PatientID: "pat-1", ASAGrade: domain.ASA2,
				Consent: status, FitToProceed: true,
			}, "anaes-1", at); err == nil {
			t.Fatalf("consent %q was recorded with no explanation", status)
		}
	}
}

// "Not fit" with nothing to do about it is a conclusion the theatre cannot act
// on: either the operation is cancelled, which is the theatre's call, or
// something has to change first.
func TestAnUnfitPatientNeedsSomethingToChange(t *testing.T) {
	if _, err := domain.NewAssessment("as-1", "tenant-1", domain.NewAssessmentInput{
		CaseID: "case-1", PatientID: "pat-1", ASAGrade: domain.ASA3,
		FitToProceed: false,
	}, "anaes-1", at); err == nil {
		t.Fatal("an unfit patient was recorded with nothing to do about it")
	}

	conditional := assessment(t, func(in *domain.NewAssessmentInput) {
		in.FitToProceed = false
		in.Conditions = []string{"optimise potassium", "echo before listing"}
	})
	if len(conditional.Conditions) != 2 {
		t.Fatalf("conditions = %v", conditional.Conditions)
	}
}

// SRS-ANE-001. A patient assessed in clinic and reassessed on the morning of
// surgery has two records, and the difference between them is frequently the
// point.
func TestAReassessmentIsANewVersion(t *testing.T) {
	clinic := assessment(t, nil)

	morning, err := clinic.Reassess("as-2", domain.NewAssessmentInput{
		ASAGrade: domain.ASA3, History: "Chest infection since clinic",
		Consent:      domain.ConsentObtained,
		FitToProceed: false,
		Conditions:   []string{"treat chest infection, reassess in two weeks"},
	}, "anaes-2", at.Add(14*24*time.Hour))
	if err != nil {
		t.Fatalf("Reassess: %v", err)
	}
	if morning.Version != 2 || morning.Supersedes != clinic.ID {
		t.Fatalf("reassessment = v%d superseding %q", morning.Version, morning.Supersedes)
	}
	// The clinic's conclusion is untouched.
	if !clinic.FitToProceed || clinic.ASAGrade != domain.ASA2 {
		t.Fatal("reassessing changed the clinic's assessment")
	}

	clinic.SupersededBy, clinic.SupersededAt = morning.ID, morning.AssessedAt
	current, ok := domain.CurrentAssessment([]domain.Assessment{clinic, morning})
	if !ok || current.ID != morning.ID {
		t.Fatalf("current = %+v, want the morning reassessment", current)
	}
}

// SRS-ANE-002. The plan is visible to the theatre's readiness checklist, which
// is what tells a theatre it needs to fetch a videolaryngoscope.
func TestReadinessProjectsWhatTheTheatreNeeds(t *testing.T) {
	fit := assessment(t, func(in *domain.NewAssessmentInput) {
		in.Airway.PredictedDifficult = true
	})
	plan, err := domain.NewPlan("plan-1", "tenant-1", domain.NewPlanInput{
		CaseID: "case-1", Technique: domain.TechniqueGeneral,
		Airway:           "videolaryngoscope, size 8 ETT",
		SpecialEquipment: []string{"videolaryngoscope", "warming blanket"},
		PostOperative:    "critical care",
	}, "anaes-1", at)
	if err != nil {
		t.Fatalf("NewPlan: %v", err)
	}

	readiness := domain.AssessReadiness([]domain.Assessment{fit}, &plan)
	if !readiness.Assessed || !readiness.Planned || !readiness.Fit {
		t.Fatalf("readiness = %+v", readiness)
	}
	if !readiness.DifficultAirway {
		t.Fatal("the difficult airway prediction did not reach the theatre")
	}
	if len(readiness.SpecialEquipment) != 2 {
		t.Fatalf("special equipment = %v", readiness.SpecialEquipment)
	}
	if readiness.PostOperative != "critical care" {
		t.Fatalf("post-operative destination = %q; a critical-care bed has to be "+
			"booked before the operation", readiness.PostOperative)
	}
	if len(readiness.Outstanding) != 0 {
		t.Fatalf("outstanding = %v on a complete assessment and plan",
			readiness.Outstanding)
	}
}

// Readiness names what is missing rather than saying a bare "not ready".
func TestReadinessNamesWhatIsMissing(t *testing.T) {
	none := domain.AssessReadiness(nil, nil)
	if len(none.Outstanding) != 2 {
		t.Fatalf("outstanding = %v, want the assessment and the plan",
			none.Outstanding)
	}

	pending := assessment(t, func(in *domain.NewAssessmentInput) {
		in.Consent = domain.ConsentPending
	})
	readiness := domain.AssessReadiness([]domain.Assessment{pending}, nil)
	found := false
	for _, item := range readiness.Outstanding {
		if strings.Contains(item, "consent") {
			found = true
		}
	}
	if !found {
		t.Fatalf("outstanding = %v, want the pending consent", readiness.Outstanding)
	}
}

// SRS-ANE-004. A dose in millilitres against a drug dosed in micrograms is the
// error that kills people, and it is caught by knowing which units belong
// together rather than by parsing strings.
func TestAnUnsafeUnitMismatchIsBlockedUnlessAcknowledged(t *testing.T) {
	in := domain.NewDrugInput{
		RecordID: "rec-1", DrugCode: "fentanyl", DrugDisplay: "Fentanyl",
		Dose: 2, DoseUnit: "mL", ExpectedUnit: "mcg",
	}
	if _, err := domain.RecordDrug("d-1", "tenant-1", in, "anaes-1", at); err == nil {
		t.Fatal("a volume was recorded against a drug dosed by mass")
	}

	in.AcknowledgedMismatch = true
	entry, err := domain.RecordDrug("d-1", "tenant-1", in, "anaes-1", at)
	if err != nil {
		t.Fatalf("RecordDrug with an acknowledged mismatch: %v", err)
	}
	if entry.DoseUnit != "mL" {
		t.Fatalf("unit = %q; the acknowledged entry keeps what was recorded",
			entry.DoseUnit)
	}

	// Units in the same family pass without comment.
	same := domain.NewDrugInput{
		RecordID: "rec-1", DrugCode: "fentanyl", Dose: 100, DoseUnit: "mcg",
		ExpectedUnit: "mg",
	}
	if _, err := domain.RecordDrug("d-2", "tenant-1", same, "anaes-1", at); err != nil {
		t.Fatalf("micrograms against a milligram formulary entry: %v", err)
	}
}

// A dose with no unit has recorded nothing.
func TestADoseHasAUnit(t *testing.T) {
	if _, err := domain.RecordDrug("d-1", "tenant-1", domain.NewDrugInput{
		RecordID: "rec-1", DrugCode: "propofol", Dose: 200,
	}, "anaes-1", at); err == nil {
		t.Fatal("a dose with no unit was accepted")
	}
}

// An infusion with no concentration has a rate that means nothing.
func TestAnInfusionRecordsWhatIsInTheSyringe(t *testing.T) {
	if _, err := domain.RecordDrug("d-1", "tenant-1", domain.NewDrugInput{
		RecordID: "rec-1", DrugCode: "remifentanil", Dose: 0, DoseUnit: "mcg/kg/min",
		Infusion: true, RateMLPerHour: 6,
	}, "anaes-1", at); err == nil {
		t.Fatal("an infusion with no concentration was accepted")
	}
}

// SRS-ANE-005. "Integrated data are marked by device and connection status":
// a device reading from no device is a manual entry claiming otherwise, and a
// value recorded while the monitor was disconnected is one nobody should
// trend.
func TestDeviceValuesCarryTheirDeviceAndConnectionState(t *testing.T) {
	if _, err := domain.RecordVital("v-1", "tenant-1", domain.NewVitalInput{
		RecordID: "rec-1", Code: "nibp_systolic", Value: 110,
		Source: domain.SourceDevice,
	}, "", at); err == nil {
		t.Fatal("a device value with no device was accepted")
	}

	disconnected, err := domain.RecordVital("v-1", "tenant-1", domain.NewVitalInput{
		RecordID: "rec-1", Code: "spo2", Value: 62, Unit: "%",
		Source: domain.SourceDevice,
		Device: domain.DeviceLink{DeviceID: "mon-1", Connected: false,
			MeasuredAt: at},
	}, "", at)
	if err != nil {
		t.Fatalf("RecordVital: %v", err)
	}
	if disconnected.Trustworthy() {
		t.Fatal("a value read while the monitor was disconnected is trendable")
	}

	connected, err := domain.RecordVital("v-2", "tenant-1", domain.NewVitalInput{
		RecordID: "rec-1", Code: "spo2", Value: 98, Unit: "%",
		Source: domain.SourceDevice,
		Device: domain.DeviceLink{DeviceID: "mon-1", Connected: true,
			MeasuredAt: at},
	}, "", at)
	if err != nil {
		t.Fatalf("RecordVital: %v", err)
	}
	if !connected.Trustworthy() {
		t.Fatal("a connected device reading is not trendable")
	}
	// A nurse's own entry is always trustworthy: they wrote it down on
	// purpose.
	manual, err := domain.RecordVital("v-3", "tenant-1", domain.NewVitalInput{
		RecordID: "rec-1", Code: "temperature", Value: 36.4, Unit: "Cel",
	}, "anaes-1", at)
	if err != nil {
		t.Fatalf("RecordVital: %v", err)
	}
	if !manual.Trustworthy() {
		t.Fatal("a manual entry is not trustworthy")
	}
}

// SRS-ANE-006. "Difficult" is a judgement somebody can forget to tick, and a
// run of four attempts with a bougie is not something the record should need
// reminding about.
func TestADifficultAirwayIsDerivedFromWhatHappened(t *testing.T) {
	easy := []domain.AirwayEvent{
		mustAirway(t, "aw-1", domain.NewAirwayInput{
			RecordID: "rec-1", Device: "Macintosh 3", Attempt: 1,
			Successful: true,
		}),
	}
	if domain.SummariseAirway(easy).Difficult {
		t.Fatal("a first-pass intubation was called difficult")
	}

	hard := []domain.AirwayEvent{
		mustAirway(t, "aw-1", domain.NewAirwayInput{
			RecordID: "rec-1", Device: "Macintosh 3", Attempt: 1,
			Difficulty: "grade 3 view",
		}),
		mustAirway(t, "aw-2", domain.NewAirwayInput{
			RecordID: "rec-1", Device: "Macintosh 4", Attempt: 2,
			Adjuncts: []string{"bougie"},
		}),
		mustAirway(t, "aw-3", domain.NewAirwayInput{
			RecordID: "rec-1", Device: "videolaryngoscope", Attempt: 3,
			Successful: true, Complications: []string{"lip trauma"},
		}),
	}
	summary := domain.SummariseAirway(hard)
	if !summary.Difficult {
		t.Fatal("three attempts with a bougie was not called difficult")
	}
	if summary.Attempts != 3 {
		t.Fatalf("attempts = %d", summary.Attempts)
	}
	if summary.FinalDevice != "videolaryngoscope" {
		t.Fatalf("final device = %q; it is what the next anaesthetist starts from",
			summary.FinalDevice)
	}
	if len(summary.Complications) != 1 {
		t.Fatalf("complications = %v", summary.Complications)
	}

	// A first-pass success that needed a videolaryngoscope is still difficult.
	adjunct := []domain.AirwayEvent{
		mustAirway(t, "aw-1", domain.NewAirwayInput{
			RecordID: "rec-1", Device: "videolaryngoscope", Attempt: 1,
			Adjuncts: []string{"videolaryngoscope"}, Successful: true,
		}),
	}
	if !domain.SummariseAirway(adjunct).Difficult {
		t.Fatal("a first-pass success needing an adjunct was called easy")
	}
}

func mustAirway(t *testing.T, id string, in domain.NewAirwayInput) domain.AirwayEvent {
	t.Helper()
	event, err := domain.RecordAirway(id, "tenant-1", in, "anaes-1", at)
	if err != nil {
		t.Fatalf("RecordAirway(%s): %v", id, err)
	}
	return event
}

// Attempts count from one: a zeroth attempt would make the count the next
// anaesthetist reads wrong.
func TestAirwayAttemptsCountFromOne(t *testing.T) {
	if _, err := domain.RecordAirway("aw-1", "tenant-1", domain.NewAirwayInput{
		RecordID: "rec-1", Device: "Macintosh 3", Attempt: 0,
	}, "anaes-1", at); err == nil {
		t.Fatal("a zeroth airway attempt was accepted")
	}
}

// SRS-ANE-007. Blood loss and transfusion are called out separately because
// they are the two numbers the surgeon and the transfusion service ask for.
func TestTheFluidBalanceCallsOutBloodLossAndTransfusion(t *testing.T) {
	entries := []domain.FluidEntry{
		mustFluid(t, "f-1", domain.NewFluidInput{
			RecordID: "rec-1", Direction: domain.FluidIn, Kind: "crystalloid",
			Label: "Hartmann's", VolumeML: 1000,
		}),
		mustFluid(t, "f-2", domain.NewFluidInput{
			RecordID: "rec-1", Direction: domain.FluidIn,
			Kind: domain.KindTransfusion, Label: "Red cells",
			VolumeML: 280, ProductID: "unit-1",
		}),
		mustFluid(t, "f-3", domain.NewFluidInput{
			RecordID: "rec-1", Direction: domain.FluidOut,
			Kind: domain.KindBloodLoss, VolumeML: 600,
		}),
		mustFluid(t, "f-4", domain.NewFluidInput{
			RecordID: "rec-1", Direction: domain.FluidOut,
			Kind: domain.KindUrine, VolumeML: 250,
		}),
	}

	balance := domain.Balance(entries)
	if balance.InML != 1280 || balance.OutML != 850 || balance.NetML != 430 {
		t.Fatalf("balance = %+v", balance)
	}
	if balance.BloodLossML != 600 || balance.TransfusedML != 280 ||
		balance.UrineML != 250 {
		t.Fatalf("the called-out numbers were lost: %+v", balance)
	}
}

// A transfusion with no unit identifier cannot be reconciled against the blood
// bank's issue record, which is half of every transfusion audit.
func TestATransfusionNamesTheUnit(t *testing.T) {
	if _, err := domain.RecordFluid("f-1", "tenant-1", domain.NewFluidInput{
		RecordID: "rec-1", Direction: domain.FluidIn,
		Kind: domain.KindTransfusion, VolumeML: 280,
	}, "anaes-1", at); err == nil {
		t.Fatal("a transfusion with no unit identifier was accepted")
	}
}

func mustFluid(t *testing.T, id string, in domain.NewFluidInput) domain.FluidEntry {
	t.Helper()
	entry, err := domain.RecordFluid(id, "tenant-1", in, "anaes-1", at)
	if err != nil {
		t.Fatalf("RecordFluid(%s): %v", id, err)
	}
	return entry
}

// SRS-ANE-008. A threshold above the maximum would trap every patient in
// recovery until somebody overrode it.
func TestARecoveryScaleHasAReachableThreshold(t *testing.T) {
	scale := domain.Aldrete()
	if err := scale.Validate(); err != nil {
		t.Fatalf("the Aldrete scale does not validate: %v", err)
	}

	unreachable := scale
	unreachable.DischargeAt = 11
	if err := unreachable.Validate(); err == nil {
		t.Fatal("a threshold above the maximum score was accepted")
	}

	none := scale
	none.DischargeAt = 0
	if err := none.Validate(); err == nil {
		t.Fatal("a scale with no discharge threshold was accepted")
	}
}

// A partial score is not a low one: scoring an unscored component as zero
// would trap a patient, and as full would discharge one.
func TestAnIncompleteRecoveryScoreIsIncompleteNotLow(t *testing.T) {
	scale := domain.Aldrete()
	partial, err := domain.Assess("ra-1", "tenant-1", "rec-1", scale, map[string]int{
		"activity": 2, "respiration": 2, "circulation": 2, "consciousness": 2,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("Assess: %v", err)
	}
	if partial.Complete() {
		t.Fatalf("a score missing a component reported itself complete: %v",
			partial.Missing)
	}
	if partial.MeetsThreshold() {
		t.Fatal("an incomplete score met the discharge threshold")
	}
	if partial.Total != 8 {
		t.Fatalf("total = %d, want the four components scored", partial.Total)
	}
}

// A component scored above its maximum is a typing error, not a very well
// patient.
func TestAComponentCannotScoreAboveItsMaximum(t *testing.T) {
	if _, err := domain.Assess("ra-1", "tenant-1", "rec-1", domain.Aldrete(),
		map[string]int{"activity": 5}, "nurse-1", at); err == nil {
		t.Fatal("a component scored above its maximum was accepted")
	}
}

// SRS-ANE-008. Every reason at once, so a recovery nurse is not told them one
// at a time while a trolley waits.
func TestDischargeReportsEveryReasonAtOnce(t *testing.T) {
	decision := domain.EvaluateDischarge(false, nil)
	if decision.Allowed() {
		t.Fatal("a patient nobody handed over was cleared to leave")
	}
	if len(decision.Refusals) != 2 {
		t.Fatalf("refusals = %v, want the handover and the missing score",
			decision.Refusals)
	}

	low, err := domain.Assess("ra-1", "tenant-1", "rec-1", domain.Aldrete(),
		map[string]int{
			"activity": 1, "respiration": 1, "circulation": 2,
			"consciousness": 1, "saturation": 1,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("Assess: %v", err)
	}
	below := domain.EvaluateDischarge(true, []domain.RecoveryAssessment{low})
	if below.Allowed() {
		t.Fatal("a patient below the threshold was cleared to leave")
	}
	if len(below.Refusals) != 1 || below.Refusals[0] != domain.RefusalBelowThreshold {
		t.Fatalf("refusals = %v", below.Refusals)
	}

	full, err := domain.Assess("ra-2", "tenant-1", "rec-1", domain.Aldrete(),
		map[string]int{
			"activity": 2, "respiration": 2, "circulation": 2,
			"consciousness": 2, "saturation": 2,
		}, "nurse-1", at.Add(30*time.Minute))
	if err != nil {
		t.Fatalf("Assess: %v", err)
	}
	ready := domain.EvaluateDischarge(true,
		[]domain.RecoveryAssessment{low, full})
	if !ready.Allowed() {
		t.Fatalf("refusals = %v on a full score", ready.Refusals)
	}
	if ready.Score.ID != "ra-2" {
		t.Fatalf("the decision was made on %q, want the later score", ready.Score.ID)
	}
}

// "PACU discharge requires threshold or documented override." The override is
// allowed, recorded, and not available for a patient nobody handed over.
func TestADischargeBelowThresholdNeedsADocumentedOverride(t *testing.T) {
	low, err := domain.Assess("ra-1", "tenant-1", "rec-1", domain.Aldrete(),
		map[string]int{
			"activity": 1, "respiration": 2, "circulation": 2,
			"consciousness": 2, "saturation": 1,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("Assess: %v", err)
	}
	decision := domain.EvaluateDischarge(true, []domain.RecoveryAssessment{low})

	if _, err := domain.NewDischarge("dis-1", "tenant-1", "rec-1", "critical care",
		decision, "", "anaes-1", at); err == nil {
		t.Fatal("a discharge below the threshold was accepted with no reason")
	}

	discharge, err := domain.NewDischarge("dis-1", "tenant-1", "rec-1",
		"critical care", decision,
		"going to critical care, will be monitored continuously", "anaes-1", at)
	if err != nil {
		t.Fatalf("NewDischarge: %v", err)
	}
	if !discharge.Overridden || discharge.OverrideReason == "" {
		t.Fatalf("discharge = %+v, want the override recorded", discharge)
	}
	if discharge.ScoreID != "ra-1" {
		t.Fatalf("score = %q; the record has to say what the decision was made on",
			discharge.ScoreID)
	}

	// The override does not cover a patient nobody handed over.
	nobody := domain.EvaluateDischarge(false, []domain.RecoveryAssessment{low})
	if _, err := domain.NewDischarge("dis-2", "tenant-1", "rec-1", "ward",
		nobody, "in a hurry", "anaes-1", at); err == nil {
		t.Fatal("a patient nobody handed over was discharged on an override")
	}
}

// A handover is between two people. One that names only the giver is a note
// left on a trolley.
func TestAHandoverNamesBothPeople(t *testing.T) {
	if _, err := domain.HandOver("ho-1", "tenant-1", domain.NewHandoverInput{
		RecordID: "rec-1", Summary: "Uneventful GA",
	}, "anaes-1", at); err == nil {
		t.Fatal("a handover with no recipient was accepted")
	}

	handover, err := domain.HandOver("ho-1", "tenant-1", domain.NewHandoverInput{
		RecordID: "rec-1", ToClinician: "nurse-1",
		Summary:        "Uneventful GA, LMA, no complications",
		Concerns:       []string{"history of PONV"},
		AnalgesiaGiven: []string{"paracetamol 1g", "fentanyl 100 mcg"},
	}, "anaes-1", at)
	if err != nil {
		t.Fatalf("HandOver: %v", err)
	}
	if handover.FromClinician != "anaes-1" || handover.ToClinician != "nurse-1" {
		t.Fatalf("handover = %+v", handover)
	}
	if len(handover.AnalgesiaGiven) != 2 {
		t.Fatal("what was given in theatre was lost; recovery needs it before " +
			"giving more")
	}
}

// SRS-ANE-009. A pain plan with no escalation is one a ward nurse cannot act
// on at three in the morning.
func TestAPainPlanSaysWhatToWatchAndWhoToCall(t *testing.T) {
	base := domain.NewPainOrderInput{
		RecordID: "rec-1", PatientID: "pat-1", Modality: "PCA morphine",
		TargetScore: "≤3 at rest",
	}

	noMonitoring := base
	noMonitoring.Escalation = "call the acute pain team"
	if _, err := domain.NewPainOrder("po-1", "tenant-1", noMonitoring,
		"anaes-1", at); err == nil {
		t.Fatal("a pain plan with nothing to observe was accepted")
	}

	noEscalation := base
	noEscalation.Monitoring = []string{"respiratory rate hourly"}
	if _, err := domain.NewPainOrder("po-1", "tenant-1", noEscalation,
		"anaes-1", at); err == nil {
		t.Fatal("a pain plan with no escalation was accepted")
	}

	complete := base
	complete.Monitoring = []string{"respiratory rate hourly", "sedation score hourly"}
	complete.Escalation = "respiratory rate under 10: stop the PCA and call 2222"
	complete.ReviewBy = at.Add(12 * time.Hour)
	order, err := domain.NewPainOrder("po-1", "tenant-1", complete, "anaes-1", at)
	if err != nil {
		t.Fatalf("NewPainOrder: %v", err)
	}
	if !order.Running() {
		t.Fatal("a fresh pain plan is not running")
	}
	if !order.ReviewOverdue(at.Add(13 * time.Hour)) {
		t.Fatal("a pain plan past its review time is not overdue")
	}
}

// SRS-ANE-010. A summary that quietly omitted the recovery score would read as
// a patient who was never scored.
func TestTheSummaryNamesWhatItCouldNotBeBuiltFrom(t *testing.T) {
	record, err := domain.NewRecord("rec-1", "tenant-1", domain.NewRecordInput{
		CaseID: "case-1", PatientID: "pat-1", Technique: domain.TechniqueGeneral,
		StartedAt: at,
	}, "anaes-1", at)
	if err != nil {
		t.Fatalf("NewRecord: %v", err)
	}

	bare := domain.BuildSummary(record, nil, nil, nil, nil, nil, nil, nil)
	if len(bare.Incomplete) != 4 {
		t.Fatalf("incomplete = %v, want the assessment, the score, the discharge "+
			"and the end of anaesthesia", bare.Incomplete)
	}

	assessed := assessment(t, nil)
	if err := record.End(at.Add(2 * time.Hour)); err != nil {
		t.Fatalf("End: %v", err)
	}
	score, err := domain.Assess("ra-1", "tenant-1", record.ID, domain.Aldrete(),
		map[string]int{
			"activity": 2, "respiration": 2, "circulation": 2,
			"consciousness": 2, "saturation": 2,
		}, "nurse-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("Assess: %v", err)
	}
	discharge := domain.Discharge{
		ID: "dis-1", RecordID: record.ID, Destination: "ward",
		Overridden: true, OverrideReason: "clinically ready, score limited by pain",
	}

	full := domain.BuildSummary(record, &assessed,
		[]domain.AirwayEvent{mustAirway(t, "aw-1", domain.NewAirwayInput{
			RecordID: record.ID, Device: "LMA 4", Attempt: 1, Successful: true,
		})}, nil, nil, []string{"uneventful"},
		[]domain.RecoveryAssessment{score}, &discharge)

	if len(full.Incomplete) != 0 {
		t.Fatalf("incomplete = %v on a complete record", full.Incomplete)
	}
	if full.ASAGrade != domain.ASA2 {
		t.Fatalf("ASA = %q", full.ASAGrade)
	}
	// The override is the one thing a summary reader must not have to dig for.
	if !full.DischargeOverridden || full.OverrideReason == "" {
		t.Fatal("the recovery discharge override is not on the summary")
	}
	if full.Airway.FinalDevice != "LMA 4" {
		t.Fatalf("airway = %+v", full.Airway)
	}
}

// SRS-ANE-011. A reconstructed record that did not say so would read as a
// contemporaneous one.
func TestAnImportedRecordSaysWhereItCameFrom(t *testing.T) {
	if _, err := domain.NewRecord("rec-1", "tenant-1", domain.NewRecordInput{
		CaseID: "case-1", PatientID: "pat-1", Technique: domain.TechniqueGeneral,
		Origin: domain.SourceImported,
	}, "anaes-1", at); err == nil {
		t.Fatal("an imported record was accepted with no provenance")
	}

	imported, err := domain.NewRecord("rec-1", "tenant-1", domain.NewRecordInput{
		CaseID: "case-1", PatientID: "pat-1", Technique: domain.TechniqueGeneral,
		StartedAt: at.Add(-6 * time.Hour),
		Origin:    domain.SourceImported,
		ImportNote: "paper record made during the downtime of 17 September, " +
			"transcribed from the original which is filed in the notes",
	}, "anaes-2", at)
	if err != nil {
		t.Fatalf("NewRecord: %v", err)
	}
	if imported.Origin != domain.SourceImported {
		t.Fatalf("origin = %q", imported.Origin)
	}
	if imported.ImportedBy != "anaes-2" || imported.ImportedAt.IsZero() {
		t.Fatalf("the import is not audit-linked: %+v", imported)
	}
	// The anaesthetic started six hours ago and the import happened now: the
	// gap is what says this is a reconstruction.
	if !imported.StartedAt.Before(imported.ImportedAt) {
		t.Fatal("an imported record has no gap between the case and the transcription")
	}
}

// The anaesthetic ends when the anaesthetist says so, which is not when the
// operation ended: emergence takes time and it is theirs.
func TestARecordEndsAndClosesInOrder(t *testing.T) {
	record, err := domain.NewRecord("rec-1", "tenant-1", domain.NewRecordInput{
		CaseID: "case-1", PatientID: "pat-1", Technique: domain.TechniqueGeneral,
		StartedAt: at,
	}, "anaes-1", at)
	if err != nil {
		t.Fatalf("NewRecord: %v", err)
	}

	if _, ok := record.Duration(); ok {
		t.Fatal("a running anaesthetic reported a duration")
	}
	if err := record.Close(at.Add(time.Hour)); err == nil {
		t.Fatal("a record was closed before the anaesthetic ended")
	}
	if err := record.End(at.Add(-time.Hour)); err == nil {
		t.Fatal("an anaesthetic ended before it started")
	}

	if err := record.End(at.Add(2 * time.Hour)); err != nil {
		t.Fatalf("End: %v", err)
	}
	if duration, ok := record.Duration(); !ok || duration != 2*time.Hour {
		t.Fatalf("duration = %v (%v)", duration, ok)
	}
	if record.Status != domain.RecordInRecovery {
		t.Fatalf("status = %q after the anaesthetic ended", record.Status)
	}
	if err := record.End(at.Add(3 * time.Hour)); err == nil {
		t.Fatal("an anaesthetic ended twice")
	}
	if err := record.Close(at.Add(4 * time.Hour)); err != nil {
		t.Fatalf("Close: %v", err)
	}
}
