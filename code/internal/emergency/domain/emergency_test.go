package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/emergency/domain"
)

func at(hour, minute int) time.Time {
	return time.Date(2026, time.September, 17, hour, minute, 0, 0, time.UTC)
}

func ptr[T any](v T) *T { return &v }

func arrival() domain.NewVisitInput {
	return domain.NewVisitInput{
		EncounterID: "enc-1", PatientID: "p1", FacilityID: "f1",
		ArrivalMode:    domain.ArrivalAmbulance,
		ChiefComplaint: "crushing central chest pain",
		ArrivedAt:      at(9, 0),
		Location:       "Resus 1",
	}
}

func visit(t *testing.T) domain.Visit {
	t.Helper()
	v, err := domain.NewVisit("v1", "t1", arrival(), "nurse-1", at(9, 0))
	if err != nil {
		t.Fatalf("NewVisit: %v", err)
	}
	return v
}

// ------------------------------------------------- arrival (SRS-ER-001, 004)

func TestAnArrivalRecordsHowAndWhenTheyCame(t *testing.T) {
	v := visit(t)
	if v.ArrivalMode != domain.ArrivalAmbulance {
		t.Fatalf("arrival mode %q", v.ArrivalMode)
	}
	if !v.ArrivedAt.Equal(at(9, 0)) {
		t.Fatalf("arrived at %v", v.ArrivedAt)
	}
	if v.Status != domain.StatusArrived {
		t.Fatalf("status %q, want arrived", v.Status)
	}
}

func TestAnArrivalKeepsTheWordsSomebodyUsed(t *testing.T) {
	// Not coded at the door. The first sentence is evidence, and coding it
	// loses the difference between "crushing chest pain" and "indigestion".
	v := visit(t)
	if v.ChiefComplaint != "crushing central chest pain" {
		t.Fatalf("chief complaint %q", v.ChiefComplaint)
	}
	in := arrival()
	in.ChiefComplaint = "   "
	if _, err := domain.NewVisit("v1", "t1", in, "nurse-1", at(9, 0)); !errors.Is(
		err, domain.ErrInvalidVisit) {
		t.Fatal("a visit with no complaint was accepted")
	}
}

func TestAnUnidentifiedPatientIsTreatedAnyway(t *testing.T) {
	// SRS-ER-004: "care can proceed without demographic completeness". A
	// department that refused to book in an unconscious patient would be a
	// department that treats them off the record.
	in := arrival()
	in.PatientID = ""
	in.Unidentified = true
	in.TemporaryName = "Unknown Male 47"

	v, err := domain.NewVisit("v1", "t1", in, "nurse-1", at(9, 0))
	if err != nil {
		t.Fatalf("an unidentified patient was refused: %v", err)
	}
	if !v.Unidentified || v.TemporaryName != "Unknown Male 47" {
		t.Fatalf("unidentified=%v name=%q", v.Unidentified, v.TemporaryName)
	}
}

func TestAnUnidentifiedPatientStillNeedsSomethingToBeCalled(t *testing.T) {
	// So the resuscitation record and the wristband agree.
	in := arrival()
	in.PatientID, in.Unidentified, in.TemporaryName = "", true, ""
	if _, err := domain.NewVisit("v1", "t1", in, "nurse-1", at(9, 0)); err == nil {
		t.Fatal("an unidentified patient with no temporary name was accepted")
	}
}

func TestIdentifyingKeepsTheNameTheRecordWasWrittenUnder(t *testing.T) {
	// "Merge retains chronology". A record that renamed its own history would
	// satisfy that on paper and make the resuscitation timeline refer to
	// somebody who was never there.
	in := arrival()
	in.PatientID, in.Unidentified, in.TemporaryName = "", true, "Unknown Male 47"
	v, err := domain.NewVisit("v1", "t1", in, "nurse-1", at(9, 0))
	if err != nil {
		t.Fatalf("NewVisit: %v", err)
	}

	if err := v.Identify("p-real", at(10, 30)); err != nil {
		t.Fatalf("Identify: %v", err)
	}
	if v.PatientID != "p-real" || v.Unidentified {
		t.Fatalf("patient %q unidentified=%v", v.PatientID, v.Unidentified)
	}
	if v.TemporaryName != "Unknown Male 47" {
		t.Fatalf("the temporary name was erased: %q", v.TemporaryName)
	}
	if err := v.Identify("p-other", at(11, 0)); err == nil {
		t.Fatal("an identified visit was identified again")
	}
}

func TestATransferIsNotReadAsAWalkIn(t *testing.T) {
	// A transfer misread as a walk-in is a referring hospital nobody writes
	// back to.
	if domain.KnownArrivalMode("helicopter") {
		t.Fatal("an unknown arrival mode was accepted")
	}
	in := arrival()
	in.ArrivalMode = "helicopter"
	if _, err := domain.NewVisit("v1", "t1", in, "nurse-1", at(9, 0)); err == nil {
		t.Fatal("an unknown arrival mode was stored")
	}
}

// ---------------------------------------------------------- triage (ER-002)

func triageInput(v domain.Visit) domain.NewTriageInput {
	return domain.NewTriageInput{
		VisitID: v.ID, Scale: domain.ESI(), AcuityCode: "2",
		RespiratoryRate: ptr(22), HeartRate: ptr(110), SystolicBP: ptr(95),
		OxygenSaturation: ptr(94), Consciousness: "alert",
		Mandatory: domain.DefaultMandatoryTriageFields(),
	}
}

func TestTriageKeepsItsInputsNotJustItsNumber(t *testing.T) {
	// "Acuity, inputs, author and time are retained". A score with its inputs
	// discarded cannot be reviewed.
	v := visit(t)
	tr, err := domain.NewTriage("tr1", "t1", triageInput(v), "nurse-1", at(9, 8))
	if err != nil {
		t.Fatalf("NewTriage: %v", err)
	}
	if tr.AcuityRank != 2 || tr.AcuityCode != "2" {
		t.Fatalf("acuity %q rank %d", tr.AcuityCode, tr.AcuityRank)
	}
	if tr.ScaleName != "ESI" || tr.ScaleVersion != "4" {
		t.Fatalf("scale %s %s — a level read under the wrong scale is a different patient",
			tr.ScaleName, tr.ScaleVersion)
	}
	if tr.HeartRate == nil || *tr.HeartRate != 110 {
		t.Fatal("the inputs were not retained")
	}
	if tr.AssessedBy != "nurse-1" || !tr.AssessedAt.Equal(at(9, 8)) {
		t.Fatalf("author %q at %v", tr.AssessedBy, tr.AssessedAt)
	}
}

func TestMissingTriageFieldsAreFlaggedNotRefused(t *testing.T) {
	// A triage nurse with a crashing patient does not stop for a temperature,
	// and a system that refused the assessment would get a fabricated one.
	v := visit(t)
	in := triageInput(v)
	in.HeartRate, in.SystolicBP = nil, nil

	tr, err := domain.NewTriage("tr1", "t1", in, "nurse-1", at(9, 8))
	if err != nil {
		t.Fatalf("an incomplete triage was refused: %v", err)
	}
	if tr.Complete() {
		t.Fatal("an incomplete triage reported itself complete")
	}
	if len(tr.Missing) != 2 {
		t.Fatalf("missing %v, want heart rate and systolic", tr.Missing)
	}
}

func TestAnAcuityTheScaleDoesNotDefineIsRefused(t *testing.T) {
	v := visit(t)
	in := triageInput(v)
	in.AcuityCode = "orange" // Manchester, on an ESI scale.
	if _, err := domain.NewTriage("tr1", "t1", in, "nurse-1", at(9, 8)); err == nil {
		t.Fatal("a level from another scale was accepted")
	}
}

func TestAnAnonymousTriageIsRefused(t *testing.T) {
	v := visit(t)
	if _, err := domain.NewTriage("tr1", "t1", triageInput(v), "", at(9, 8)); err == nil {
		t.Fatal("a triage with no author was accepted")
	}
}

func TestAScaleNeedsATopLevelAndUniqueRanks(t *testing.T) {
	// Two levels at one rank make the queue order depend on storage order,
	// which is to say on nothing.
	duplicate := domain.AcuityScale{
		Name: "Local", Version: "1",
		Levels: []domain.AcuityLevel{
			{Code: "a", Rank: 1}, {Code: "b", Rank: 1},
		},
	}
	if err := duplicate.Validate(); err == nil {
		t.Fatal("a scale with two rank-1 levels was accepted")
	}

	noTop := domain.AcuityScale{
		Name: "Local", Version: "1",
		Levels: []domain.AcuityLevel{{Code: "a", Rank: 2}, {Code: "b", Rank: 3}},
	}
	if err := noTop.Validate(); err == nil {
		t.Fatal("a scale with no rank 1 was accepted")
	}
	if err := domain.ESI().Validate(); err != nil {
		t.Fatalf("the default scale is invalid: %v", err)
	}
}

// ----------------------------------------------------------- queue (ER-003)

func entry(id string, rank int, arrived time.Time) domain.QueueEntry {
	return domain.QueueEntry{
		VisitID: id, Display: id, AcuityRank: rank, ScaleName: "ESI",
		ArrivedAt: arrived, Triaged: true, Status: domain.StatusTriaged,
	}
}

func TestTheQueueIsAcuityFirstAndArrivalAmongEquals(t *testing.T) {
	// "Prioritize queue by acuity and clinical override rather than arrival
	// order alone" — and arrival still decides among equals, or the quiet
	// patients at the back of a busy level-3 queue never reach the front.
	ordered := domain.OrderQueue([]domain.QueueEntry{
		entry("late-3", 3, at(9, 40)),
		entry("early-3", 3, at(9, 10)),
		entry("late-1", 1, at(9, 50)),
	})
	got := []string{ordered[0].VisitID, ordered[1].VisitID, ordered[2].VisitID}
	want := []string{"late-1", "early-3", "late-3"}
	for i := range want {
		if got[i] != want[i] {
			t.Fatalf("queue order %v, want %v", got, want)
		}
	}
}

func TestAnUntriagedPatientSortsAsMostUrgent(t *testing.T) {
	// The department does not know what is wrong with them. Sorting them last
	// is how somebody waits four hours with an infarct nobody assessed; the
	// clock that fixes it is door-to-triage, not the queue.
	untriaged := domain.QueueEntry{
		VisitID: "new", ArrivedAt: at(9, 55), Status: domain.StatusArrived,
	}
	ordered := domain.OrderQueue([]domain.QueueEntry{
		entry("triaged-2", 2, at(9, 10)), untriaged,
	})
	if ordered[0].VisitID != "new" {
		t.Fatalf("an untriaged patient sorted %s", ordered[0].VisitID)
	}
}

func TestAnOverrideMovesAPatientAndNeedsAReasonEitherWay(t *testing.T) {
	// Moving somebody down is the decision argued about afterwards, and a
	// system that only demanded a reason for upgrades would leave the harder
	// one unexplained.
	up := domain.PriorityOverride{Rank: 1, Reason: "looks awful", By: "doctor-1", At: at(9, 20)}
	if err := up.Validate(); err != nil {
		t.Fatalf("a reasoned upgrade was refused: %v", err)
	}
	down := domain.PriorityOverride{Rank: 4, By: "doctor-1", At: at(9, 20)}
	if err := down.Validate(); err == nil {
		t.Fatal("a downgrade with no reason was accepted")
	}
	anonymous := domain.PriorityOverride{Rank: 1, Reason: "unwell"}
	if err := anonymous.Validate(); err == nil {
		t.Fatal("an anonymous override was accepted")
	}

	moved := entry("slow-4", 4, at(9, 5))
	moved.Override = &up
	ordered := domain.OrderQueue([]domain.QueueEntry{entry("fast-2", 2, at(9, 30)), moved})
	if ordered[0].VisitID != "slow-4" {
		t.Fatalf("the override did not move the patient: %s first", ordered[0].VisitID)
	}
}

func TestABreachIsAgainstTheAcuityTargetAndNotTheResusCategory(t *testing.T) {
	scale := domain.ESI()
	waiting := entry("v", 3, at(9, 0)) // ESI 3 targets 30 minutes.
	if waiting.Breaching(scale, at(9, 20)) {
		t.Fatal("a twenty-minute wait at ESI 3 was called a breach")
	}
	if !waiting.Breaching(scale, at(9, 40)) {
		t.Fatal("a forty-minute wait at ESI 3 was not a breach")
	}

	// Rank 1 has no target: a resuscitation patient is being treated, or the
	// department has a problem a breach flag does not describe.
	resus := entry("r", 1, at(9, 0))
	if resus.Breaching(scale, at(11, 0)) {
		t.Fatal("the resuscitation category was reported as breaching")
	}

	// And a patient already in treatment is not waiting.
	treated := entry("v", 3, at(9, 0))
	treated.Status = domain.StatusInTreatment
	if treated.Breaching(scale, at(11, 0)) {
		t.Fatal("a patient in treatment was reported as waiting")
	}
}

// -------------------------------------------------------- timeline (ER-008)

func event(t *testing.T, kind domain.EventKind, detail string,
	occurred, recorded time.Time) domain.Event {

	t.Helper()
	e, err := domain.NewEvent("e-"+detail, "t1", domain.NewEventInput{
		VisitID: "v1", Kind: kind, Detail: detail, OccurredAt: occurred,
	}, "nurse-1", recorded)
	if err != nil {
		t.Fatalf("NewEvent(%s): %v", detail, err)
	}
	return e
}

func TestATimelineReadsInTheOrderThingsHappened(t *testing.T) {
	// A resuscitation written up afterwards arrives out of order and must
	// still read in order — the whole reason OccurredAt and RecordedAt are
	// separate fields.
	timeline := domain.Timeline{
		event(t, domain.EventDrug, "adrenaline", at(9, 12), at(9, 30)),
		event(t, domain.EventCPR, "cpr started", at(9, 10), at(9, 30)),
	}
	ordered := timeline.Ordered()
	if ordered[0].Detail != "cpr started" {
		t.Fatalf("the timeline read %q first", ordered[0].Detail)
	}
}

func TestSequenceBreaksTiesWithinAMinute(t *testing.T) {
	// A defibrillation and the rhythm check before it are frequently recorded
	// at the same minute, and their order is the clinically interesting part.
	first, err := domain.NewEvent("e1", "t1", domain.NewEventInput{
		VisitID: "v1", Kind: domain.EventObservation, Detail: "VF on the monitor",
		OccurredAt: at(9, 10), Sequence: 1,
	}, "nurse-1", at(9, 10))
	if err != nil {
		t.Fatalf("NewEvent: %v", err)
	}
	second, err := domain.NewEvent("e2", "t1", domain.NewEventInput{
		VisitID: "v1", Kind: domain.EventDefibrillation, Detail: "200J",
		OccurredAt: at(9, 10), Sequence: 2,
	}, "nurse-1", at(9, 10))
	if err != nil {
		t.Fatalf("NewEvent: %v", err)
	}

	ordered := domain.Timeline{second, first}.Ordered()
	if ordered[0].ID != "e1" {
		t.Fatalf("the rhythm check did not sort before the shock: %s", ordered[0].ID)
	}
}

func TestAnEntryWrittenUpAfterwardsIsMarkedLate(t *testing.T) {
	live := event(t, domain.EventCPR, "cpr started", at(9, 10), at(9, 12))
	if live.Late {
		t.Fatal("an entry made two minutes later was marked late")
	}
	writtenUp := event(t, domain.EventDrug, "adrenaline", at(9, 12), at(9, 40))
	if !writtenUp.Late {
		t.Fatal("an entry made half an hour later was not marked late")
	}
	if len(domain.Timeline{live, writtenUp}.LateEntries()) != 1 {
		t.Fatal("the late entries were not reported")
	}
}

func TestAnEventNamesWhoRecordedItAndWhatWasDone(t *testing.T) {
	if _, err := domain.NewEvent("e1", "t1", domain.NewEventInput{
		VisitID: "v1", Kind: domain.EventCPR, Detail: "cpr", OccurredAt: at(9, 10),
	}, "", at(9, 10)); err == nil {
		t.Fatal("an anonymous resuscitation entry was accepted")
	}
	if _, err := domain.NewEvent("e1", "t1", domain.NewEventInput{
		VisitID: "v1", Kind: domain.EventCPR, Detail: "  ", OccurredAt: at(9, 10),
	}, "nurse-1", at(9, 10)); err == nil {
		t.Fatal("an entry saying nothing was accepted")
	}
}

// --------------------------------------- pre-order administration (ER-009)

func TestADrugGivenBeforeTheOrderNeedsItsProtocol(t *testing.T) {
	// "Only under configured protocol". Without one it is an unordered
	// administration, which is the thing the exception is carved out of.
	if _, err := domain.NewEvent("e1", "t1", domain.NewEventInput{
		VisitID: "v1", Kind: domain.EventDrug, Detail: "adrenaline 1mg IV",
		OccurredAt: at(9, 12), PreOrder: true,
	}, "nurse-1", at(9, 12)); err == nil {
		t.Fatal("a pre-order administration with no protocol was accepted")
	}
}

func TestAPreOrderAdministrationOwesAnOrderUntilItIsReconciled(t *testing.T) {
	// "No silent stock/clinical gap" — this is what makes it not silent.
	given, err := domain.NewEvent("e1", "t1", domain.NewEventInput{
		VisitID: "v1", Kind: domain.EventDrug, Detail: "adrenaline 1mg IV",
		OccurredAt: at(9, 12), PreOrder: true, ProtocolID: "resus-standing-order",
	}, "nurse-1", at(9, 12))
	if err != nil {
		t.Fatalf("NewEvent: %v", err)
	}
	if !given.Outstanding() {
		t.Fatal("a pre-order administration did not report a debt")
	}
	if len(domain.Timeline{given}.Unreconciled()) != 1 {
		t.Fatal("the department's debt was not reported")
	}

	if err := given.Reconcile("ord-1"); err != nil {
		t.Fatalf("Reconcile: %v", err)
	}
	if given.Outstanding() {
		t.Fatal("a reconciled administration still reports a debt")
	}
	if err := given.Reconcile("ord-2"); err == nil {
		t.Fatal("an administration was reconciled twice")
	}
}

func TestAnOrdinaryAdministrationOwesNothing(t *testing.T) {
	// The guard: if everything reported a debt, the tests above would pass and
	// the reconciliation list would be noise.
	ordinary := event(t, domain.EventDrug, "paracetamol 1g", at(9, 30), at(9, 30))
	if ordinary.Outstanding() {
		t.Fatal("an ordered administration reported a reconciliation debt")
	}
}

// ----------------------------------------------------------- clocks (ER-006)

func TestTheDoorClocksAreDerivedFromEvents(t *testing.T) {
	timeline := domain.Timeline{
		event(t, domain.EventArrival, "ambulance", at(9, 0), at(9, 0)),
		event(t, domain.EventTriage, "ESI 2", at(9, 8), at(9, 8)),
		event(t, domain.EventClinicianSeen, "Dr Rao", at(9, 25), at(9, 25)),
		event(t, domain.EventDisposition, "admitted", at(11, 30), at(11, 30)),
	}
	clocks := timeline.Clocks()
	if clocks.DoorToTriage == nil || *clocks.DoorToTriage != 8*time.Minute {
		t.Fatalf("door to triage %v", clocks.DoorToTriage)
	}
	if clocks.DoorToClinician == nil || *clocks.DoorToClinician != 25*time.Minute {
		t.Fatalf("door to clinician %v", clocks.DoorToClinician)
	}
	if clocks.DoorToDisposition == nil || *clocks.DoorToDisposition != 150*time.Minute {
		t.Fatalf("door to disposition %v", clocks.DoorToDisposition)
	}
}

func TestAClockThatHasNotRunIsAbsentRatherThanZero(t *testing.T) {
	// A door-to-doctor of nought because nobody has seen the patient is the
	// number that makes a dashboard look best while the department is at its
	// worst.
	timeline := domain.Timeline{
		event(t, domain.EventArrival, "walk-in", at(9, 0), at(9, 0)),
		event(t, domain.EventTriage, "ESI 4", at(9, 6), at(9, 6)),
	}
	clocks := timeline.Clocks()
	if clocks.DoorToClinician != nil {
		t.Fatalf("an unseen patient has a door-to-doctor of %v", *clocks.DoorToClinician)
	}
	if clocks.DoorToTriage == nil {
		t.Fatal("door to triage did not run")
	}
}

// --------------------------------------------------------- pathways (ER-005)

func TestActivatingAPathwayRecordsWhenAndWhoAndTheTeam(t *testing.T) {
	// "Activation time, team notification and milestones are recorded" — the
	// commonest failure is not that nobody activated it, it is that the team
	// nobody called did not come.
	p, err := domain.ActivatePathway("p1", "t1", domain.NewPathwayInput{
		VisitID: "v1", Kind: domain.PathwaySTEMI, NotifiedTeam: "cardiology-on-call",
	}, "doctor-1", at(9, 15))
	if err != nil {
		t.Fatalf("ActivatePathway: %v", err)
	}
	if !p.ActivatedAt.Equal(at(9, 15)) || p.ActivatedBy != "doctor-1" {
		t.Fatalf("activated %v by %q", p.ActivatedAt, p.ActivatedBy)
	}
	if p.NotifiedTeam != "cardiology-on-call" {
		t.Fatalf("team %q", p.NotifiedTeam)
	}
	if len(p.Targets) == 0 {
		t.Fatal("a STEMI activation has no milestones")
	}
}

func TestALocalPathwayMustSayWhichOneItIs(t *testing.T) {
	if _, err := domain.ActivatePathway("p1", "t1", domain.NewPathwayInput{
		VisitID: "v1", Kind: domain.PathwayOther,
	}, "doctor-1", at(9, 15)); err == nil {
		t.Fatal("an unnamed local pathway was activated")
	}
}

func TestMilestoneProgressIsComputedFromTheTimeline(t *testing.T) {
	p, err := domain.ActivatePathway("p1", "t1", domain.NewPathwayInput{
		VisitID: "v1", Kind: domain.PathwaySTEMI,
	}, "doctor-1", at(9, 15))
	if err != nil {
		t.Fatalf("ActivatePathway: %v", err)
	}

	ecg, err := domain.NewEvent("e1", "t1", domain.NewEventInput{
		VisitID: "v1", Kind: domain.EventMilestone, Detail: "ecg",
		OccurredAt: at(9, 21), PathwayID: "p1",
	}, "nurse-1", at(9, 21))
	if err != nil {
		t.Fatalf("NewEvent: %v", err)
	}

	states := p.Progress(domain.Timeline{ecg}, at(9, 40))
	var ecgState, reperfusion domain.MilestoneState
	for _, s := range states {
		switch s.Target.Code {
		case "ecg":
			ecgState = s
		case "reperfusion":
			reperfusion = s
		}
	}
	if !ecgState.Reached || ecgState.Elapsed != 6*time.Minute {
		t.Fatalf("ecg reached=%v elapsed=%v", ecgState.Reached, ecgState.Elapsed)
	}
	// Ten-minute target, reached at six.
	if ecgState.Breached {
		t.Fatal("an ECG within target was reported as breached")
	}
	// Ninety-minute target, twenty-five minutes in and not reached.
	if reperfusion.Reached || reperfusion.Breached {
		t.Fatalf("reperfusion reached=%v breached=%v at 25 minutes",
			reperfusion.Reached, reperfusion.Breached)
	}
}

func TestAMissedMilestoneBreachesWhileItIsStillMissable(t *testing.T) {
	// A breach that only appears after the event is a breach nobody could
	// have prevented.
	p, _ := domain.ActivatePathway("p1", "t1", domain.NewPathwayInput{
		VisitID: "v1", Kind: domain.PathwaySTEMI,
	}, "doctor-1", at(9, 15))

	states := p.Progress(nil, at(9, 30)) // fifteen minutes; ECG target is ten.
	for _, s := range states {
		if s.Target.Code == "ecg" && !s.Breached {
			t.Fatal("an ECG fifteen minutes in was not reported as breaching")
		}
	}
}

func TestStandingDownStopsTheClockAndNeedsAReason(t *testing.T) {
	// A department's false-activation rate is a quality measure nobody can
	// read from a stand-down with no reason.
	p, _ := domain.ActivatePathway("p1", "t1", domain.NewPathwayInput{
		VisitID: "v1", Kind: domain.PathwaySTEMI,
	}, "doctor-1", at(9, 15))

	if err := p.StandDown("", at(9, 20)); err == nil {
		t.Fatal("a pathway was stood down with no reason")
	}
	if err := p.StandDown("ECG showed pericarditis", at(9, 20)); err != nil {
		t.Fatalf("StandDown: %v", err)
	}
	if p.Active() {
		t.Fatal("a stood-down pathway is still active")
	}

	// The clock stops, so a stand-down does not keep accruing breaches
	// against a team that was told to go home.
	states := p.Progress(nil, at(12, 0))
	for _, s := range states {
		if s.Elapsed > 5*time.Minute {
			t.Fatalf("%s kept accruing after the stand-down: %v", s.Target.Code, s.Elapsed)
		}
	}
}

// ------------------------------------------------------ disposition (ER-013)

func TestADispositionNamesEverythingMissingAtOnce(t *testing.T) {
	// A clinician told one missing thing at a time makes three attempts at the
	// same screen while a patient waits in a corridor.
	v := visit(t)
	refusals, err := v.Dispose(domain.DispositionDischarge, "", "",
		domain.DefaultDispositionRequirements(domain.DispositionDischarge),
		domain.DispositionEvidence{}, at(11, 0))
	if err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	if len(refusals) != 2 {
		t.Fatalf("refusals %v, want the missing triage and the unsigned summary", refusals)
	}
	if v.Status == domain.StatusDisposed {
		t.Fatal("a refused disposition was applied anyway")
	}
	for _, r := range refusals {
		if r.Explain() == "" {
			t.Fatalf("%q explains nothing", r)
		}
	}
}

func TestADischargeNeedsASignedSummary(t *testing.T) {
	// SRS-ER-015: only signed source data populate the final summary, and
	// SRS-ER-013 gates the disposition on it.
	v := visit(t)
	refusals, _ := v.Dispose(domain.DispositionDischarge, "", "",
		domain.DefaultDispositionRequirements(domain.DispositionDischarge),
		domain.DispositionEvidence{Triaged: true}, at(11, 0))
	if len(refusals) != 1 || refusals[0] != domain.RefusalSummaryUnsigned {
		t.Fatalf("refusals %v", refusals)
	}

	refusals, err := v.Dispose(domain.DispositionDischarge, "", "",
		domain.DefaultDispositionRequirements(domain.DispositionDischarge),
		domain.DispositionEvidence{Triaged: true, SummarySigned: true}, at(11, 0))
	if err != nil || len(refusals) != 0 {
		t.Fatalf("a complete discharge was refused: %v %v", refusals, err)
	}
	if v.Status != domain.StatusDisposed || v.Disposition != domain.DispositionDischarge {
		t.Fatalf("status %q disposition %q", v.Status, v.Disposition)
	}
}

func TestAHandoverNamesWhoAcceptedThePatient(t *testing.T) {
	v := visit(t)
	refusals, _ := v.Dispose(domain.DispositionICU, "", "",
		domain.DefaultDispositionRequirements(domain.DispositionICU),
		domain.DispositionEvidence{Triaged: true}, at(11, 0))
	if len(refusals) != 1 || refusals[0] != domain.RefusalNoReceivingService {
		t.Fatalf("refusals %v", refusals)
	}

	// And a discharge does not: nobody is receiving the patient, and requiring
	// one would leave the visit open against a service that was never going to
	// answer.
	if domain.DispositionDischarge.HandsOver() {
		t.Fatal("a discharge was treated as a handover")
	}
}

func TestLeavingAgainstAdviceAndAbscondingAreBothRecordedAndDistinct(t *testing.T) {
	// One was witnessed and counselled and the other was not, and the
	// difference is the whole of the medico-legal record.
	if domain.DispositionLeftAgainstAdvice == domain.DispositionAbsconded {
		t.Fatal("the two outcomes are the same value")
	}
	for _, d := range []domain.Disposition{
		domain.DispositionLeftAgainstAdvice,
		domain.DispositionAbsconded,
		domain.DispositionDeath,
	} {
		req := domain.DefaultDispositionRequirements(d)
		if !req.NeedsNote {
			t.Fatalf("%q does not require an explanation", d)
		}
	}
}

func TestAVisitIsNotDisposedTwice(t *testing.T) {
	v := visit(t)
	if _, err := v.Dispose(domain.DispositionDischarge, "", "",
		domain.DispositionRequirements{}, domain.DispositionEvidence{}, at(11, 0)); err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	refusals, _ := v.Dispose(domain.DispositionAdmission, "", "ward-3",
		domain.DispositionRequirements{}, domain.DispositionEvidence{}, at(12, 0))
	if len(refusals) != 1 || refusals[0] != domain.RefusalAlreadyDisposed {
		t.Fatalf("refusals %v", refusals)
	}
	if v.Disposition != domain.DispositionDischarge {
		t.Fatalf("the second disposition overwrote the first: %q", v.Disposition)
	}
}

func TestLengthOfStayIsNotReportedWhileTheClockIsRunning(t *testing.T) {
	// A running clock is not a length of stay, and reporting one as though it
	// were understates every patient still waiting.
	v := visit(t)
	if _, settled := v.LengthOfStay(); settled {
		t.Fatal("an open visit reported a length of stay")
	}
	if _, err := v.Dispose(domain.DispositionDischarge, "", "",
		domain.DispositionRequirements{}, domain.DispositionEvidence{}, at(11, 30)); err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	stay, settled := v.LengthOfStay()
	if !settled || stay != 150*time.Minute {
		t.Fatalf("length of stay %v settled=%v", stay, settled)
	}
}

// ------------------------------------------------------ observation (ER-014)

func TestAnObservationStayNeedsAReviewTime(t *testing.T) {
	// An observation with no end is an admission nobody called an admission.
	v := visit(t)
	if err := v.StartObservation(time.Time{}, at(10, 0)); err == nil {
		t.Fatal("an observation with no review time was accepted")
	}
	if err := v.StartObservation(at(9, 0), at(10, 0)); err == nil {
		t.Fatal("an observation reviewed in the past was accepted")
	}
	if err := v.StartObservation(at(14, 0), at(10, 0)); err != nil {
		t.Fatalf("StartObservation: %v", err)
	}
	if v.Status != domain.StatusObservation {
		t.Fatalf("status %q", v.Status)
	}
}

func TestAnOverdueObservationIsVisible(t *testing.T) {
	// Four hours in a corridor bed is how an observation stay becomes an
	// admission nobody decided on.
	v := visit(t)
	if err := v.StartObservation(at(14, 0), at(10, 0)); err != nil {
		t.Fatalf("StartObservation: %v", err)
	}
	if v.ObservationOverdue(at(13, 0)) {
		t.Fatal("an observation inside its review time was called overdue")
	}
	if !v.ObservationOverdue(at(14, 30)) {
		t.Fatal("an observation past its review time was not called overdue")
	}
}

// ------------------------------------------------------------ board (ER-012)

func TestTheBoardRedactsARestrictedRowWithoutHidingTheBed(t *testing.T) {
	// A board that hid the row entirely would let somebody walk past a cubicle
	// they did not know was occupied.
	mlc := visit(t)
	mlc.MedicoLegal = true
	mlc.Location = "Cubicle 4"

	entries := []domain.QueueEntry{{
		VisitID: "v1", Display: "Kumar, Anil", AcuityRank: 2, Triaged: true,
		ArrivedAt: at(9, 0), Status: domain.StatusInTreatment, Location: "Cubicle 4",
		DispositionBarrier: "awaiting police statement",
	}}
	visits := map[string]domain.Visit{"v1": mlc}

	open := domain.BuildBoard(entries, visits, nil, domain.ESI(), true, at(9, 30))
	if open.Rows[0].Display != "Kumar, Anil" || open.Restricted != 0 {
		t.Fatalf("an authorized viewer saw %+v", open.Rows[0])
	}

	closed := domain.BuildBoard(entries, visits, nil, domain.ESI(), false, at(9, 30))
	row := closed.Rows[0]
	if row.Display == "Kumar, Anil" {
		t.Fatal("an unauthorized viewer saw the patient's name")
	}
	if row.DispositionBarrier != "" {
		t.Fatalf("an unauthorized viewer saw the barrier: %q", row.DispositionBarrier)
	}
	if row.Location != "Cubicle 4" || row.AcuityRank != 2 {
		t.Fatalf("the bed and the acuity were withheld: %+v", row)
	}
	if closed.Restricted != 1 {
		t.Fatalf("the board counted %d restricted rows", closed.Restricted)
	}
}

func TestTheBoardShowsWaitingBreachAndOverdueObservation(t *testing.T) {
	v := visit(t)
	if err := v.StartObservation(at(11, 0), at(10, 0)); err != nil {
		t.Fatalf("StartObservation: %v", err)
	}
	entries := []domain.QueueEntry{
		{VisitID: "waiting", AcuityRank: 3, Triaged: true, ArrivedAt: at(9, 0),
			Status: domain.StatusTriaged},
		{VisitID: "v1", AcuityRank: 2, Triaged: true, ArrivedAt: at(8, 0),
			Status: domain.StatusObservation},
	}
	board := domain.BuildBoard(entries, map[string]domain.Visit{"v1": v},
		map[string][]domain.PathwayKind{"v1": {domain.PathwaySepsis}},
		domain.ESI(), true, at(11, 30))

	byID := map[string]domain.BoardRow{}
	for _, row := range board.Rows {
		byID[row.VisitID] = row
	}
	if !byID["waiting"].Breaching {
		t.Fatal("a two-and-a-half-hour ESI 3 wait was not shown as breaching")
	}
	if !byID["v1"].ObservationOverdue {
		t.Fatal("an overdue observation was not shown")
	}
	if len(byID["v1"].Pathways) != 1 {
		t.Fatalf("the active pathway was not shown: %v", byID["v1"].Pathways)
	}
	if byID["waiting"].Waiting != 150*time.Minute {
		t.Fatalf("waiting %v", byID["waiting"].Waiting)
	}
}

func TestAStoredValueThisBuildCannotReadIsNotGuessedAt(t *testing.T) {
	for _, known := range []func(string) bool{
		domain.KnownArrivalMode, domain.KnownVisitStatus,
		domain.KnownDisposition, domain.KnownEventKind, domain.KnownPathwayKind,
	} {
		if known("something_new") {
			t.Fatal("an unknown stored value was accepted")
		}
	}
	// And each family has a member for exactly that case, so a reader has
	// somewhere to put it rather than dropping the row.
	if !domain.KnownArrivalMode("unspecified") ||
		!domain.KnownDisposition("unknown") ||
		!domain.KnownEventKind("unknown") ||
		!domain.KnownPathwayKind("unknown") {
		t.Fatal("a family has nowhere to put an unreadable value")
	}
}
