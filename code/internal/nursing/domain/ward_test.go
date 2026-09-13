package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
)

func day(d int, hour int) time.Time {
	return time.Date(2026, 3, d, hour, 0, 0, 0, time.UTC)
}

func centralLine(t *testing.T, inserted time.Time) *domain.Device {
	t.Helper()
	device, err := domain.NewDevice("device-1", "tenant-1",
		domain.NewDeviceInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.DeviceCentralLine, Site: "right internal jugular",
			Laterality: domain.LateralityRight, Size: "7Fr",
			InsertedAt: inserted,
		}, "doctor-1", inserted.Add(time.Minute))
	if err != nil {
		t.Fatalf("NewDevice: %v", err)
	}
	return device
}

// SRS-NUR-006: device-days come from the canonical dates and nothing else.
func TestDeviceDaysAreCountedFromInsertionAndRemoval(t *testing.T) {
	device := centralLine(t, day(10, 14))

	// Inserted on the 10th, still in on the 12th: the 10th, 11th and 12th.
	if got := device.DeviceDays(day(12, 9)); got != 3 {
		t.Fatalf("device-days as of the 12th is %d, want 3", got)
	}
	if err := device.Remove(day(13, 8), "no longer needed", "nurse-1",
		day(13, 9)); err != nil {
		t.Fatalf("Remove: %v", err)
	}
	if got := device.DeviceDays(day(20, 9)); got != 4 {
		t.Fatalf("device-days after removal is %d, want 4", got)
	}
}

// A line in and out the same afternoon carried a day's risk.
func TestALineInAndOutTheSameDayIsOneDeviceDay(t *testing.T) {
	device := centralLine(t, day(10, 9))
	if err := device.Remove(day(10, 17), "displaced", "nurse-1",
		day(10, 18)); err != nil {
		t.Fatalf("Remove: %v", err)
	}
	if got := device.DeviceDays(day(11, 9)); got != 1 {
		t.Fatalf("a same-day line counts %d device-days, want 1", got)
	}
}

// Documenting care must not change the denominator, because a denominator that
// falls when the ward is busy makes the infection rate rise.
func TestDocumentingCareDoesNotChangeTheDeviceDayCount(t *testing.T) {
	device := centralLine(t, day(10, 14))
	before := device.DeviceDays(day(12, 9))

	if err := device.RecordCare(domain.DeviceCare{
		ID: "care-1", Kind: "dressing change", Finding: "clean and dry",
		PerformedAt: day(11, 10), PerformedBy: "nurse-1",
	}, day(11, 11)); err != nil {
		t.Fatalf("RecordCare: %v", err)
	}
	if got := device.DeviceDays(day(12, 9)); got != before {
		t.Fatalf("documenting care changed the device-day count from %d to %d",
			before, got)
	}
}

// Dwell is to the minute, because a 72-hour cannula limit rounded to calendar
// days lets a line sit for nearly two days past it.
func TestDwellIsMeasuredToTheMinuteNotTheDay(t *testing.T) {
	device := centralLine(t, day(10, 14))
	if got := device.Dwell(day(13, 10)); got != 68*time.Hour {
		t.Fatalf("dwell is %s, want 68h", got)
	}
}

// Planned removal and removal for suspected infection are the same event to
// the chart and different events to surveillance.
func TestRemovingADeviceNeedsAReason(t *testing.T) {
	device := centralLine(t, day(10, 14))
	if err := device.Remove(day(13, 8), "", "nurse-1", day(13, 9)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a device was removed with no reason: %v", err)
	}
}

func TestADeviceCannotBeRemovedTwice(t *testing.T) {
	device := centralLine(t, day(10, 14))
	if err := device.Remove(day(13, 8), "no longer needed", "nurse-1",
		day(13, 9)); err != nil {
		t.Fatalf("Remove: %v", err)
	}
	if err := device.Remove(day(14, 8), "no longer needed", "nurse-1",
		day(14, 9)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a removed device was removed again: %v", err)
	}
}

// Defaulting the insertion time would put the one number this record exists
// for out by however long it took to chart.
func TestADeviceNeedsTheTimeItWasInserted(t *testing.T) {
	_, err := domain.NewDevice("device-1", "tenant-1",
		domain.NewDeviceInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.DeviceCentralLine, Site: "right internal jugular",
		}, "doctor-1", day(10, 14))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a device with no insertion time was accepted: %v", err)
	}
}

// The surveillance set is named here rather than left to a reporting query
// that could quietly disagree.
func TestTheSurveillanceDeviceSetIsNamed(t *testing.T) {
	if !domain.DeviceCentralLine.SurveillanceDevice() {
		t.Fatal("a central line does not count towards surveillance")
	}
	if !domain.DeviceUrinaryCatheter.SurveillanceDevice() {
		t.Fatal("a urinary catheter does not count towards surveillance")
	}
	if domain.DevicePeripheralLine.SurveillanceDevice() {
		t.Fatal("a peripheral cannula counts towards surveillance")
	}
}

func woundAssessment(t *testing.T) *domain.WoundAssessment {
	t.Helper()
	assessment, err := domain.NewWoundAssessment("wound-assess-1", "tenant-1",
		domain.NewWoundAssessmentInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			WoundID: "wound-1", Location: "sacrum",
			Kind: domain.WoundPressureInjury, Stage: "2",
			LengthMM: 40, WidthMM: 25, DepthMM: 3,
			Appearance: "shallow open ulcer, pink wound bed",
			AssessedAt: at(10, 0),
		}, "nurse-1", at(10, 15))
	if err != nil {
		t.Fatalf("NewWoundAssessment: %v", err)
	}
	return assessment
}

// SRS-NUR-012: images only where consented.
func TestAWoundPhotographNeedsAConsentThatCoversIt(t *testing.T) {
	assessment := woundAssessment(t)
	image := domain.WoundImage{
		ImageID: "image-1", StorageKey: "s3://wounds/image-1",
		ContentType: "image/jpeg", CapturedAt: at(10, 5), CapturedBy: "nurse-1",
	}

	// No consent reference at all.
	if err := assessment.AttachImage(image, true, at(10, 15)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("an unconsented photograph was attached: %v", err)
	}

	// A consent reference the caller found does not cover photography.
	image.ConsentID = "consent-1"
	if err := assessment.AttachImage(image, false, at(10, 15)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a photograph was attached under a consent that does not cover it: %v", err)
	}

	if err := assessment.AttachImage(image, true, at(10, 15)); err != nil {
		t.Fatalf("a consented photograph was refused: %v", err)
	}
	if len(assessment.Images) != 1 || assessment.Images[0].Sequence != 1 {
		t.Fatalf("the image was not attached in sequence: %+v", assessment.Images)
	}
}

// A series of images is the evidence of healing; a replaced image destroys it.
func TestWoundImagesAreAddedInSequenceAndNeverReplaced(t *testing.T) {
	assessment := woundAssessment(t)
	first := domain.WoundImage{
		ImageID: "image-1", ConsentID: "consent-1",
		StorageKey: "s3://wounds/1", CapturedAt: at(10, 5), CapturedBy: "nurse-1",
	}
	if err := assessment.AttachImage(first, true, at(10, 15)); err != nil {
		t.Fatalf("AttachImage: %v", err)
	}
	if err := assessment.AttachImage(first, true, at(10, 20)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("the same image was attached twice: %v", err)
	}

	second := first
	second.ImageID = "image-2"
	second.StorageKey = "s3://wounds/2"
	if err := assessment.AttachImage(second, true, at(10, 20)); err != nil {
		t.Fatalf("AttachImage: %v", err)
	}
	if assessment.Images[0].StorageKey != "s3://wounds/1" {
		t.Fatal("the first image was replaced")
	}
	if assessment.Images[1].Sequence != 2 {
		t.Fatalf("sequence is %d, want 2", assessment.Images[1].Sequence)
	}
}

// A pressure injury charted without a stage is a pressure injury nobody
// reports.
func TestAPressureInjuryNeedsItsStage(t *testing.T) {
	_, err := domain.NewWoundAssessment("wound-assess-1", "tenant-1",
		domain.NewWoundAssessmentInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			WoundID: "wound-1", Location: "sacrum",
			Kind:       domain.WoundPressureInjury,
			Appearance: "shallow open ulcer", AssessedAt: at(10, 0),
		}, "nurse-1", at(10, 15))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a pressure injury with no stage was accepted: %v", err)
	}
}

// Without a wound identifier, ten assessments of one wound and one each of ten
// wounds look the same.
func TestAWoundAssessmentSaysWhichWoundItIsOf(t *testing.T) {
	_, err := domain.NewWoundAssessment("wound-assess-1", "tenant-1",
		domain.NewWoundAssessmentInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Location: "sacrum", Kind: domain.WoundSurgical,
			Appearance: "clean and dry", AssessedAt: at(10, 0),
		}, "nurse-1", at(10, 15))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a wound assessment with no wound was accepted: %v", err)
	}
}

// SRS-NUR-015: teaching delivered is not teaching received.
func TestAnEducationRecordStoresWhetherItWasUnderstood(t *testing.T) {
	topic := domain.Coding{
		System: "http://snomed.info/sct", Version: "2024-03",
		Code: "410293004", Display: "Stoma care education",
	}
	record, err := domain.NewEducationRecord("edu-1", "tenant-1",
		"patient-1", "encounter-1", topic, domain.LearnerCarer, "daughter",
		"return demonstration with a spare appliance",
		domain.UnderstandingNeedsReinforcement,
		"tired; second session arranged", at(15, 0), "nurse-1", at(15, 20))
	if err != nil {
		t.Fatalf("NewEducationRecord: %v", err)
	}
	if record.Understanding != domain.UnderstandingNeedsReinforcement {
		t.Fatalf("understanding is %q", record.Understanding)
	}
	// Recording it against the patient loses who actually knows how.
	if record.LearnerName != "daughter" {
		t.Fatalf("the learner is %q", record.LearnerName)
	}
}

func TestTeachingSomebodyOtherThanThePatientMustNameThem(t *testing.T) {
	topic := domain.Coding{
		System: "http://snomed.info/sct", Version: "2024-03",
		Code: "410293004", Display: "Stoma care education",
	}
	_, err := domain.NewEducationRecord("edu-1", "tenant-1",
		"patient-1", "encounter-1", topic, domain.LearnerFamily, "",
		"discussion", domain.UnderstandingVerbalised, "", at(15, 0),
		"nurse-1", at(15, 20))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an unnamed family learner was accepted: %v", err)
	}
}

// A nurse told about one discharge blocker, who clears it and is then told
// about another, stops planning discharges in advance.
func TestDischargeReadinessListsEverythingOutstanding(t *testing.T) {
	readiness := domain.DischargeReadiness{
		Criteria: []domain.ReadinessCriterion{
			{Key: "a_mobility", Label: "Mobilising safely", Met: true},
			{Key: "b_medication", Label: "Discharge medication dispensed"},
			{Key: "c_education", Label: "Stoma care taught", Note: "second session due"},
		},
	}
	outstanding := readiness.Outstanding()
	if len(outstanding) != 2 {
		t.Fatalf("outstanding lists %d, want 2", len(outstanding))
	}
	if readiness.Ready() {
		t.Fatal("a patient with two outstanding criteria is reported ready")
	}

	for i := range readiness.Criteria {
		readiness.Criteria[i].Met = true
	}
	if !readiness.Ready() {
		t.Fatal("a patient with everything met is not reported ready")
	}
}

// SRS-NUR-017: the question is always about the past.
func TestANurseAssignmentIsAnsweredAsOfATime(t *testing.T) {
	assignment, err := domain.NewAssignment("assign-1", "tenant-1", "unit-1",
		"bed-4", "patient-1", "nurse-1", domain.RelationshipPrimary,
		at(8, 0), "charge-nurse")
	if err != nil {
		t.Fatalf("NewAssignment: %v", err)
	}
	if !assignment.Covers(at(12, 0)) {
		t.Fatal("a live assignment does not cover the middle of the shift")
	}
	if assignment.Covers(at(7, 0)) {
		t.Fatal("an assignment covers a time before it started")
	}

	if err := assignment.End(at(20, 0), "shift end"); err != nil {
		t.Fatalf("End: %v", err)
	}
	if assignment.Covers(at(21, 0)) {
		t.Fatal("an ended assignment still covers the next shift")
	}
	// The answer to "who held this patient at midday" survives the shift
	// ending.
	if !assignment.Covers(at(12, 0)) {
		t.Fatal("ending the assignment erased who held the patient at midday")
	}
}

func TestAnAssignmentCannotEndBeforeItBegan(t *testing.T) {
	assignment, err := domain.NewAssignment("assign-1", "tenant-1", "unit-1",
		"bed-4", "patient-1", "nurse-1", domain.RelationshipPrimary,
		at(8, 0), "charge-nurse")
	if err != nil {
		t.Fatalf("NewAssignment: %v", err)
	}
	if err := assignment.End(at(7, 0), "shift end"); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an assignment ended before it began: %v", err)
	}
}

// An assignment to neither a patient nor a bed means the nurse is on the ward.
func TestAnAssignmentNeedsAPatientOrABed(t *testing.T) {
	_, err := domain.NewAssignment("assign-1", "tenant-1", "unit-1",
		"", "", "nurse-1", domain.RelationshipPrimary, at(8, 0), "charge-nurse")
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an assignment to nothing was accepted: %v", err)
	}
}

// SRS-NUR-016: the weights travel with the score, so a retune does not
// silently rewrite history.
func TestAnAcuityScoreCarriesTheWeightsItWasComputedWith(t *testing.T) {
	inputs := domain.AcuityInputs{
		DependencyScore: 4, OpenTasks: 6, OverdueTasks: 2,
		Devices: 3, HighRisk: 1, Isolation: true,
	}
	weights := domain.DefaultAcuityWeights()
	acuity := domain.Acuity("patient-1", inputs, weights, at(9, 0))

	want := int32(4*3 + 6*1 + 2*2 + 3*2 + 1*4 + 5)
	if acuity.Score != want {
		t.Fatalf("score is %d, want %d", acuity.Score, want)
	}
	if acuity.Weights != weights {
		t.Fatal("the score does not carry the weights it was computed with")
	}
	// The inputs are named and stored, so the figure can be challenged.
	if acuity.Inputs.OverdueTasks != 2 {
		t.Fatal("the inputs were not stored with the score")
	}
}

// A ward with no nurses assigned is not a ward with zero workload per nurse.
func TestAUnitWithNobodyOnDutyReportsNoPerNurseFigure(t *testing.T) {
	unit := domain.SummariseUnit("unit-1", []domain.PatientAcuity{
		{PatientID: "patient-1", Score: 30},
	}, 0, at(9, 0))

	if _, ok := unit.PerNurse(); ok {
		t.Fatal("a unit with nobody on duty reported a per-nurse figure")
	}

	staffed := domain.SummariseUnit("unit-1", []domain.PatientAcuity{
		{PatientID: "patient-1", Score: 30},
		{PatientID: "patient-2", Score: 10},
	}, 2, at(9, 0))
	perNurse, ok := staffed.PerNurse()
	if !ok || perNurse != 20 {
		t.Fatalf("per-nurse is %v (ok=%v), want 20", perNurse, ok)
	}
	// The list exists to direct attention.
	if staffed.Patients[0].PatientID != "patient-1" {
		t.Fatal("the busiest patient is not first")
	}
}
