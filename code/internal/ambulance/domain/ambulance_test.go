package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
)

// The ambulance and fleet rules.
//
// Every refusal below is a rule somebody could otherwise remove, so each is
// tested by weakening it: the assertion is that the domain says no, and the
// comment says what happens on a road when it says yes.

var at = time.Date(2026, 9, 23, 6, 0, 0, 0, time.UTC)

func refused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

// ----------------------------------------------------- fleet (SRS-AMB-002)

func vehicleInput() domain.NewVehicleInput {
	return domain.NewVehicleInput{
		Registration: "KA-01-AB-1234", CallSign: "Alpha 1",
		Kind: domain.VehicleALS, FacilityID: "f1", BaseID: "base-1",
		Capabilities: []string{"ventilator", "monitor"},
	}
}

func vehicle(t *testing.T, id string,
	mutate func(*domain.NewVehicleInput)) domain.Vehicle {

	t.Helper()
	in := vehicleInput()
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.NewVehicle(id, "t1", in, "fleet-1", at)
	if err != nil {
		t.Fatalf("NewVehicle: %v", err)
	}
	return out
}

func TestAVehicleStartsOffTheRunAndNamesWhatItIs(t *testing.T) {
	// A vehicle that appeared as available the moment somebody typed its
	// plate is one a dispatcher can send before anybody looked inside it.
	registered := vehicle(t, "v1", nil)
	if registered.State != domain.VehicleOutOfService ||
		registered.Ready(at) {
		t.Fatalf("a new vehicle is on the run: %+v", registered)
	}

	in := vehicleInput()
	in.Kind = "minibus"
	_, err := domain.NewVehicle("v1", "t1", in, "fleet-1", at)
	refused(t, err, "unknown vehicle kind")

	in = vehicleInput()
	in.Registration = " "
	_, err = domain.NewVehicle("v1", "t1", in, "fleet-1", at)
	refused(t, err, "needs its registration")

	_, err = domain.NewVehicle("v1", "t1", vehicleInput(), "", at)
	refused(t, err, "names who registered it")

	_, err = domain.NewVehicle("", "t1", vehicleInput(), "fleet-1", at)
	refused(t, err, "needs an id")

	// A vehicle off the run for no recorded reason is one nobody can chase
	// back on.
	refused(t, registered.GoOutOfService(""), "say why")
	refused(t, registered.Retire(""), "say why")

	// A vehicle out on a job is not retired out from underneath the crew
	// using it: the trip it is on would have no vehicle behind it.
	onTrip := vehicle(t, "v2", nil)
	onTrip.State = domain.VehicleOnTrip
	refused(t, onTrip.Retire("sold"), "out on a trip")

	if err := registered.Retire("sold"); err != nil {
		t.Fatalf("Retire: %v", err)
	}
	refused(t, registered.Retire("again"), "already retired")
	refused(t, registered.GoOutOfService("repair"), "is retired")

	// And a vehicle that was sold does not come back on the board because
	// somebody ran a readiness check against its old record.
	refused(t, registered.GoAvailable(check(t, "c9", nil), at),
		"is retired")
}

func checkInput() domain.NewCheckInput {
	return domain.NewCheckInput{
		VehicleID: "v1", ShiftID: "s1", FacilityID: "f1",
		Items: []domain.ReadinessItem{
			{Code: "defib", Label: "Defibrillator", Critical: true},
			{Code: "oxygen-cylinder", Label: "Oxygen", Critical: true},
			{Code: "blankets", Label: "Blankets"},
		},
		Outcomes: []domain.ItemOutcome{
			{Code: "defib", Present: true},
			{Code: "oxygen-cylinder", Present: true},
			{Code: "blankets", Present: true},
		},
		OxygenBar: 180, OxygenMinimumBar: 100,
		ValidFor: 12 * time.Hour,
	}
}

func check(t *testing.T, id string,
	mutate func(*domain.NewCheckInput)) domain.ReadinessCheck {

	t.Helper()
	in := checkInput()
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.RecordCheck(id, "t1", in, "crew-1", at)
	if err != nil {
		t.Fatalf("RecordCheck: %v", err)
	}
	return out
}

func TestAVehicleGoesOnTheRunOnAPassedCheckAndNothingElse(t *testing.T) {
	registered := vehicle(t, "v1", nil)

	// A vehicle marked available by somebody who did not look in it is the
	// whole of what SRS-AMB-006 exists to prevent.
	failed := check(t, "c1", func(in *domain.NewCheckInput) {
		in.Outcomes[0] = domain.ItemOutcome{
			Code: "defib", Present: false, Note: "away for service",
		}
	})
	if failed.State != domain.CheckFailed || len(failed.Missing) != 1 ||
		failed.Passed() {
		t.Fatalf("a missing defibrillator passed: %+v", failed)
	}
	refused(t, registered.GoAvailable(failed, at), "on a passed check")

	// A check for somebody else's vehicle is not a check on this one.
	other := check(t, "c2", func(in *domain.NewCheckInput) {
		in.VehicleID = "v9"
	})
	refused(t, registered.GoAvailable(other, at), "is for vehicle v9")

	passed := check(t, "c3", nil)
	if err := registered.GoAvailable(passed, at); err != nil {
		t.Fatalf("GoAvailable: %v", err)
	}
	if !registered.State.Assignable() || !registered.Ready(at) {
		t.Fatalf("the vehicle is not on the run: %+v", registered)
	}

	// A check that lapsed overnight makes the vehicle unready without
	// anybody remembering to say so.
	if registered.Ready(at.Add(13 * time.Hour)) {
		t.Fatal("an expired check still reads as ready")
	}
	refused(t, registered.GoAvailable(passed, at.Add(13*time.Hour)),
		"has expired")

	// And a vehicle out on a job is not put back on the board underneath
	// the crew using it.
	registered.State = domain.VehicleOnTrip
	refused(t, registered.GoAvailable(passed, at), "out on a trip")
}

func shiftInput() domain.NewShiftInput {
	return domain.NewShiftInput{
		VehicleID: "v1", FacilityID: "f1",
		Crew: []domain.CrewMember{
			{SubjectID: "crew-1", Name: "A Driver",
				Role: domain.CrewDriver},
			{SubjectID: "crew-2", Name: "A Paramedic",
				Role: domain.CrewParamedic, RegistrationNumber: "P-1"},
		},
		StartsAt: at.Add(-time.Hour), EndsAt: at.Add(11 * time.Hour),
	}
}

func shift(t *testing.T, id string,
	mutate func(*domain.NewShiftInput)) domain.Shift {

	t.Helper()
	in := shiftInput()
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.NewShift(id, "t1", in, "fleet-1", at)
	if err != nil {
		t.Fatalf("NewShift: %v", err)
	}
	return out
}

func onDutyShift(t *testing.T, id string) domain.Shift {
	t.Helper()
	out := shift(t, id, nil)
	if err := out.Start(at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	return out
}

func TestAShiftNamesACrewAndOnlyOneCrewIsOnAVehicle(t *testing.T) {
	// A vehicle with nobody on it is a vehicle a dispatcher can send.
	in := shiftInput()
	in.Crew = nil
	_, err := domain.NewShift("s1", "t1", in, "fleet-1", at)
	refused(t, err, "names its crew")

	// One person twice is a crew of two that is really a crew of one.
	in = shiftInput()
	in.Crew = append(in.Crew, domain.CrewMember{
		SubjectID: "crew-1", Role: domain.CrewEMT,
	})
	_, err = domain.NewShift("s1", "t1", in, "fleet-1", at)
	refused(t, err, "appears on the crew twice")

	in = shiftInput()
	in.Crew[0].Role = "porter"
	_, err = domain.NewShift("s1", "t1", in, "fleet-1", at)
	refused(t, err, "unknown crew role")

	in = shiftInput()
	in.Crew[0].SubjectID = ""
	_, err = domain.NewShift("s1", "t1", in, "fleet-1", at)
	refused(t, err, "a crew member needs an id")

	in = shiftInput()
	in.EndsAt = in.StartsAt
	_, err = domain.NewShift("s1", "t1", in, "fleet-1", at)
	refused(t, err, "ends after it starts")

	in = shiftInput()
	in.StartsAt = time.Time{}
	_, err = domain.NewShift("s1", "t1", in, "fleet-1", at)
	refused(t, err, "says when it runs")

	in = shiftInput()
	in.VehicleID = ""
	_, err = domain.NewShift("s1", "t1", in, "fleet-1", at)
	refused(t, err, "names its vehicle")

	_, err = domain.NewShift("", "t1", shiftInput(), "fleet-1", at)
	refused(t, err, "needs an id")

	rostered := shift(t, "s1", nil)
	if rostered.OnDuty(at) {
		t.Fatal("a planned shift is on duty")
	}
	if err := rostered.Start(at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	refused(t, rostered.Start(at), "this shift is on_duty")
	if !rostered.OnDuty(at) || rostered.OnDuty(at.Add(12*time.Hour)) {
		t.Fatalf("the shift is not on duty exactly when rostered: %+v",
			rostered)
	}

	// A driver is not a clinician here. Not about competence: the record
	// has to name somebody the service says may give the drug.
	if _, ok := rostered.Clinician("crew-1"); ok {
		t.Fatal("a driver came back as a clinician")
	}
	if _, ok := rostered.Clinician("crew-2"); !ok {
		t.Fatal("a paramedic did not come back as a clinician")
	}

	// Two crews on one ambulance is a vehicle whose record names whichever
	// the reader opened.
	later := shift(t, "s2", func(in *domain.NewShiftInput) {
		in.StartsAt, in.EndsAt = at.Add(-time.Minute), at.Add(8*time.Hour)
	})
	if err := later.Start(at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	got, ok := domain.ShiftForVehicle([]domain.Shift{rostered, later},
		"v1", at)
	if !ok || got.ID != "s2" {
		t.Fatalf("want the latest on-duty shift, got %+v %v", got, ok)
	}
	if _, ok := domain.ShiftForVehicle([]domain.Shift{rostered}, "v9",
		at); ok {
		t.Fatal("a vehicle with no shift has one")
	}

	if err := rostered.End(at.Add(time.Hour)); err != nil {
		t.Fatalf("End: %v", err)
	}
	refused(t, rostered.End(at), "this shift is ended")
}

// ------------------------------------------------- readiness (SRS-AMB-006)

func TestACheckSaysWhatWasCheckedAndHowLongItHolds(t *testing.T) {
	// A check with no items is a vehicle that passes by having nothing
	// asked of it.
	in := checkInput()
	in.Items = nil
	_, err := domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "says what was checked")

	// A check that never lapses is a vehicle checked once in March.
	in = checkInput()
	in.ValidFor = 0
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "how long it holds for")

	// A checklist half filled in is the one a coroner reads.
	in = checkInput()
	in.Outcomes = in.Outcomes[:1]
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "has not been checked")

	// A missing item with no note is indistinguishable from one nobody
	// looked for.
	in = checkInput()
	in.Outcomes[2] = domain.ItemOutcome{Code: "blankets", Present: false}
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "say why")

	in = checkInput()
	in.Items = append(in.Items, domain.ReadinessItem{Code: "Defib"})
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "appears twice")

	in = checkInput()
	in.Items[0].Code = ""
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "a checklist item needs a code")

	in = checkInput()
	in.Outcomes[0].Code = ""
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "names its checklist item")

	in = checkInput()
	in.OxygenBar = -1
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "cannot be negative")

	in = checkInput()
	in.VehicleID = ""
	_, err = domain.RecordCheck("c1", "t1", in, "crew-1", at)
	refused(t, err, "names its vehicle")

	_, err = domain.RecordCheck("c1", "t1", checkInput(), "", at)
	refused(t, err, "names who made it")

	_, err = domain.RecordCheck("", "t1", checkInput(), "crew-1", at)
	refused(t, err, "needs an id")

	// An ordinary item missing is recorded and does not block.
	ordinary := check(t, "c2", func(in *domain.NewCheckInput) {
		in.Outcomes[2] = domain.ItemOutcome{
			Code: "blankets", Present: false, Note: "in the wash",
		}
	})
	if ordinary.State != domain.CheckPassed {
		t.Fatalf("a missing blanket blocked the vehicle: %+v", ordinary)
	}

	// Oxygen is a level rather than a tick: "present" is true of a cylinder
	// with forty bar left in it, and that cylinder will not finish a long
	// transfer.
	low := check(t, "c3", func(in *domain.NewCheckInput) {
		in.OxygenBar = 40
	})
	if low.State != domain.CheckFailed {
		t.Fatalf("a nearly empty cylinder passed: %+v", low)
	}
	found := false
	for _, item := range low.Missing {
		if item == "oxygen" {
			found = true
		}
	}
	if !found {
		t.Fatalf("the oxygen was not named as missing: %+v", low.Missing)
	}
}

func TestAnOverrideIsMadeBySomebodyOtherThanWhoeverChecked(t *testing.T) {
	failed := check(t, "c1", func(in *domain.NewCheckInput) {
		in.Outcomes[1] = domain.ItemOutcome{
			Code: "oxygen-cylinder", Present: false, Note: "empty",
		}
	})

	// Somebody who found the oxygen empty and then waved it through is one
	// person deciding both, and "or requires override" means a second pair
	// of eyes rather than a second click.
	refused(t, failed.Override("we are short", "crew-1", at),
		"other than whoever checked the vehicle")
	refused(t, failed.Override("we are short", "", at), "names who made it")
	refused(t, failed.Override("", "duty-officer", at), "say why")

	if err := failed.Override("no spare vehicle; second cylinder carried",
		"duty-officer", at); err != nil {
		t.Fatalf("Override: %v", err)
	}
	// Its own state, so a readiness report cannot count it as a pass.
	if failed.State != domain.CheckOverridden || !failed.Passed() {
		t.Fatalf("the override did not stick: %+v", failed)
	}
	refused(t, failed.Override("again", "duty-officer", at),
		"there is nothing to override")

	// And a passed check has nothing to override.
	passed := check(t, "c2", nil)
	refused(t, passed.Override("why not", "duty-officer", at),
		"there is nothing to override")

	summary := domain.SummariseReadiness([]domain.ReadinessCheck{
		passed, failed})
	// A fleet where every check is overridden reads as a fleet that passes
	// every check, unless the two are counted apart.
	if summary.Passed != 1 || summary.Overridden != 1 ||
		summary.Failed != 0 {
		t.Fatalf("an override was counted as a pass: %+v", summary)
	}
	// Which critical items were missing is the number that tells a service
	// what to buy.
	if summary.MissingByItem["oxygen-cylinder"] != 1 {
		t.Fatalf("the missing item was not counted: %+v",
			summary.MissingByItem)
	}
	if empty := domain.SummariseReadiness(nil); !empty.Unanswerable {
		t.Fatalf("an empty set is answerable: %+v", empty)
	}
}

// --------------------------------------------------- requests (SRS-AMB-001)

func requestInput() domain.NewRequestInput {
	return domain.NewRequestInput{
		Kind: domain.RequestEmergency, Priority: domain.PriorityImmediate,
		OriginName: "12 Mount Road", OriginAddress: "12 Mount Road",
		DestinationFacilityID: "f1",
		ClinicalNeed:          "chest pain, sweating",
		RequiredCapabilities:  []string{"monitor"},
	}
}

func request(t *testing.T, id string,
	mutate func(*domain.NewRequestInput)) domain.Request {

	t.Helper()
	in := requestInput()
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.RaiseRequest(id, "t1", in, "dispatch-1", at)
	if err != nil {
		t.Fatalf("RaiseRequest: %v", err)
	}
	return out
}

func TestARequestSaysWhereToGoAndWhatThePatientNeeds(t *testing.T) {
	queued := request(t, "r1", nil)
	// SRS-AMB-001's acceptance: the request enters the queue with a
	// timestamp, and it is the clock every response-time figure is
	// measured from.
	if queued.State != domain.RequestQueued ||
		!queued.RequestedAt.Equal(at) {
		t.Fatalf("the request did not enter the queue: %+v", queued)
	}

	// A crew cannot be sent to nowhere.
	in := requestInput()
	in.OriginName, in.OriginAddress, in.OriginFacilityID = "", "", ""
	_, err := domain.RaiseRequest("r1", "t1", in, "dispatch-1", at)
	refused(t, err, "says where to go")

	// The clinical need decides which vehicle goes.
	in = requestInput()
	in.ClinicalNeed = " "
	_, err = domain.RaiseRequest("r1", "t1", in, "dispatch-1", at)
	refused(t, err, "what the patient needs")

	// A request whose priority nobody set would queue behind a booked
	// discharge.
	in = requestInput()
	in.Priority = ""
	_, err = domain.RaiseRequest("r1", "t1", in, "dispatch-1", at)
	refused(t, err, "unknown priority")

	in = requestInput()
	in.Kind = "taxi"
	_, err = domain.RaiseRequest("r1", "t1", in, "dispatch-1", at)
	refused(t, err, "unknown request kind")

	_, err = domain.RaiseRequest("r1", "t1", requestInput(), "", at)
	refused(t, err, "names who raised it")

	_, err = domain.RaiseRequest("", "t1", requestInput(), "dispatch-1", at)
	refused(t, err, "needs an id")

	// SRS-AMB-007 is a transfer between two hospitals, and a handover needs
	// both ends of it named.
	in = requestInput()
	in.Kind = domain.RequestInterfacility
	in.OriginFacilityID = ""
	_, err = domain.RaiseRequest("r1", "t1", in, "dispatch-1", at)
	refused(t, err, "sending and the receiving facility")

	in = requestInput()
	in.Kind = domain.RequestInterfacility
	in.OriginFacilityID, in.DestinationFacilityID = "f1", "f1"
	_, err = domain.RaiseRequest("r1", "t1", in, "dispatch-1", at)
	refused(t, err, "goes somewhere else")

	// A call the crew already answered is not cancelled afterwards: the
	// patient was taken to hospital, and a service that can retire a
	// finished job into the cancellation column can report whatever
	// cancellation rate it likes.
	done := request(t, "r9", nil)
	done.State = domain.RequestCompleted
	refused(t, done.Cancel("tidying up", "dispatch-1", at),
		"already been completed")

	// The cancellation rate SRS-AMB-008 asks for is only useful with the
	// reasons beside it.
	refused(t, queued.Cancel("", "dispatch-1", at), "say why")
	refused(t, queued.Cancel("patient made own way", "", at),
		"names who made it")
	if err := queued.Cancel("patient made own way", "dispatch-1",
		at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	refused(t, queued.Cancel("again", "dispatch-1", at), "already cancelled")
}

func TestTheQueueTakesThePrioritiesInOrderAndThenTheOldest(t *testing.T) {
	immediate, err := domain.RaiseRequest("r1", "t1", requestInput(),
		"dispatch-1", at.Add(time.Minute))
	if err != nil {
		t.Fatalf("RaiseRequest: %v", err)
	}
	urgentOld := request(t, "r2", func(in *domain.NewRequestInput) {
		in.Priority = domain.PriorityUrgent
	})
	urgentNew, err := domain.RaiseRequest("r3", "t1",
		domain.NewRequestInput{
			Kind: domain.RequestEmergency, Priority: domain.PriorityUrgent,
			OriginName: "somewhere", ClinicalNeed: "fall",
		}, "dispatch-1", at.Add(2*time.Minute))
	if err != nil {
		t.Fatalf("RaiseRequest: %v", err)
	}
	routine := request(t, "r4", func(in *domain.NewRequestInput) {
		in.Kind, in.Priority = domain.RequestDischarge,
			domain.PriorityRoutine
	})
	cancelled := request(t, "r5", nil)
	if err := cancelled.Cancel("stood down", "dispatch-1", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}

	// A queue in arrival order sends the next vehicle to a booked discharge
	// while a cardiac arrest waits; a queue on priority alone leaves the
	// oldest urgent call there all afternoon.
	queue := domain.Queue([]domain.Request{
		routine, urgentNew, immediate, urgentOld, cancelled})
	if len(queue) != 4 {
		t.Fatalf("want four queued, got %+v", queue)
	}
	order := []string{queue[0].ID, queue[1].ID, queue[2].ID, queue[3].ID}
	want := []string{"r1", "r2", "r3", "r4"}
	for i := range want {
		if order[i] != want[i] {
			t.Fatalf("want %v, got %v", want, order)
		}
	}
}

// ------------------------------------------------------ trips (SRS-AMB-003)

func readyVehicle(t *testing.T, id string) domain.Vehicle {
	t.Helper()
	out := vehicle(t, id, nil)
	passed := check(t, "c-"+id, func(in *domain.NewCheckInput) {
		in.VehicleID = id
	})
	if err := out.GoAvailable(passed, at); err != nil {
		t.Fatalf("GoAvailable: %v", err)
	}
	return out
}

func TestAnUnavailableVehicleIsSentOnlyByNameAndReason(t *testing.T) {
	call := request(t, "r1", nil)
	ready := readyVehicle(t, "v1")
	crew := onDutyShift(t, "s1")

	// The ordinary case needs no override.
	trip, err := domain.Dispatch("t1", "t1", call, ready, crew, "", "",
		"dispatch-1", at)
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if trip.Overridden() || len(trip.CrewSubjects) != 2 {
		t.Fatalf("an ordinary dispatch was recorded as an override: %+v",
			trip)
	}

	// An unavailable vehicle, an expired check, an off-duty crew and a
	// missing capability are all blockers, and all of them are overridable
	// by one named person with one reason.
	offRun := ready
	if err := offRun.GoOutOfService("brakes"); err != nil {
		t.Fatalf("GoOutOfService: %v", err)
	}
	_, err = domain.Dispatch("t2", "t1", call, offRun, crew, "", "",
		"dispatch-1", at)
	refused(t, err, "the vehicle is out_of_service")

	_, err = domain.Dispatch("t2", "t1", call, ready, crew, "", "",
		"dispatch-1", at.Add(13*time.Hour))
	refused(t, err, "readiness check has lapsed")

	planned := shift(t, "s2", nil)
	_, err = domain.Dispatch("t2", "t1", call, ready, planned, "", "",
		"dispatch-1", at)
	refused(t, err, "crew is not on duty")

	noMonitor := readyVehicle(t, "v2")
	noMonitor.Capabilities = []string{"stretcher"}
	crewTwo := shift(t, "s3", func(in *domain.NewShiftInput) {
		in.VehicleID = "v2"
	})
	if err := crewTwo.Start(at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	_, err = domain.Dispatch("t2", "t1", call, noMonitor, crewTwo, "", "",
		"dispatch-1", at)
	refused(t, err, "does not carry monitor")

	// An override is a named person and a reason, both.
	_, err = domain.Dispatch("t2", "t1", call, offRun, crew, "duty-officer",
		"", "dispatch-1", at)
	refused(t, err, "override by name and reason")
	_, err = domain.Dispatch("t2", "t1", call, offRun, crew, "",
		"nothing else free", "dispatch-1", at)
	refused(t, err, "override by name and reason")

	overridden, err := domain.Dispatch("t2", "t1", call, offRun, crew,
		"duty-officer", "nothing else within twenty minutes",
		"dispatch-1", at)
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if !overridden.Overridden() ||
		overridden.OverrideBy != "duty-officer" {
		t.Fatalf("the override was not recorded: %+v", overridden)
	}

	// A patient transport van sent to a cardiac arrest is a van with no
	// defibrillator in it, and no override makes one appear.
	van := readyVehicle(t, "v3")
	van.Kind = domain.VehicleTransport
	vanCrew := shift(t, "s4", func(in *domain.NewShiftInput) {
		in.VehicleID = "v3"
	})
	if err := vanCrew.Start(at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	_, err = domain.Dispatch("t3", "t1", call, van, vanCrew,
		"duty-officer", "nothing else free", "dispatch-1", at)
	refused(t, err, "does not answer a immediate call")

	// A crew rostered to a different vehicle is not this vehicle's crew.
	_, err = domain.Dispatch("t3", "t1", call, ready, crewTwo, "", "",
		"dispatch-1", at)
	refused(t, err, "rostered to vehicle v2")

	_, err = domain.Dispatch("t3", "t1", call, ready, crew, "", "", "", at)
	refused(t, err, "names who made it")
	_, err = domain.Dispatch("", "t1", call, ready, crew, "", "",
		"dispatch-1", at)
	refused(t, err, "a trip needs an id")

	// And a request already answered is not answered twice.
	answered := call
	answered.State = domain.RequestAssigned
	_, err = domain.Dispatch("t3", "t1", answered, ready, crew, "", "",
		"dispatch-1", at)
	refused(t, err, "this request is assigned")
}

func dispatched(t *testing.T) domain.Trip {
	t.Helper()
	trip, err := domain.Dispatch("trip-1", "t1", request(t, "r1", nil),
		readyVehicle(t, "v1"), onDutyShift(t, "s1"), "", "",
		"dispatch-1", at)
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	return trip
}

func TestATimelineGoesForwardOnlyAndEachPointOnce(t *testing.T) {
	trip := dispatched(t)

	// A timeline that accepted "at scene" twice would have two arrival
	// times and one response figure that is whichever the report reached
	// first.
	if err := trip.RecordMilestone(domain.MilestoneMobile, "", "crew-1",
		at.Add(time.Minute)); err != nil {
		t.Fatalf("RecordMilestone: %v", err)
	}
	refused(t, trip.RecordMilestone(domain.MilestoneMobile, "", "crew-1",
		at.Add(2*time.Minute)), "has already been recorded")
	refused(t, trip.RecordMilestone(domain.MilestoneDispatched, "",
		"crew-1", at), "has already been recorded")

	if err := trip.RecordMilestone(domain.MilestoneAtScene, "", "crew-1",
		at.Add(8*time.Minute)); err != nil {
		t.Fatalf("RecordMilestone: %v", err)
	}
	// One that accepted a milestone out of order would have a crew leaving
	// the scene before it arrived there, and an on-scene time below zero.
	skipped := dispatched(t)
	if err := skipped.RecordMilestone(domain.MilestoneLeftScene, "",
		"crew-1", at.Add(20*time.Minute)); err != nil {
		t.Fatalf("RecordMilestone: %v", err)
	}
	refused(t, skipped.RecordMilestone(domain.MilestoneAtScene, "",
		"crew-1", at.Add(9*time.Minute)), "comes before left_scene")

	refused(t, trip.RecordMilestone("teleported", "", "crew-1", at),
		"unknown milestone")
	refused(t, trip.RecordMilestone(domain.MilestoneWithPatient, "", "",
		at), "names who recorded it")

	for _, milestone := range []domain.Milestone{
		domain.MilestoneWithPatient, domain.MilestoneLeftScene,
		domain.MilestoneAtDestination, domain.MilestoneHandover,
		domain.MilestoneClear,
	} {
		if err := trip.RecordMilestone(milestone, "", "crew-1",
			at.Add(30*time.Minute)); err != nil {
			t.Fatalf("RecordMilestone %s: %v", milestone, err)
		}
	}
	// Going clear finishes the trip and puts the vehicle back on the run.
	if trip.State != domain.TripCompleted || trip.EndedAt.IsZero() {
		t.Fatalf("the trip did not finish: %+v", trip.State)
	}
	refused(t, trip.RecordMilestone(domain.MilestoneClear, "", "crew-1",
		at), "this trip is completed")

	// A complete timeline has no gaps, which is what makes SRS-AMB-003's
	// "complete" checkable.
	if gaps := domain.TimelineGaps(trip); len(gaps) != 0 {
		t.Fatalf("a complete timeline reported gaps: %+v", gaps)
	}
}

func TestACorrectedTimeKeepsWhatItCorrected(t *testing.T) {
	trip := dispatched(t)
	for _, milestone := range []domain.Milestone{
		domain.MilestoneMobile, domain.MilestoneAtScene,
	} {
		if err := trip.RecordMilestone(milestone, "", "crew-1",
			at.Add(8*time.Minute)); err != nil {
			t.Fatalf("RecordMilestone: %v", err)
		}
	}

	refused(t, trip.AmendMilestone(domain.MilestoneHandover,
		at.Add(time.Hour), "typo", "crew-1", at), "has not been recorded")
	refused(t, trip.AmendMilestone(domain.MilestoneAtScene,
		at.Add(6*time.Minute), "", "crew-1", at), "say why")
	refused(t, trip.AmendMilestone(domain.MilestoneAtScene,
		at.Add(6*time.Minute), "clock wrong", "", at), "names who made it")
	refused(t, trip.AmendMilestone(domain.MilestoneAtScene, time.Time{},
		"clock wrong", "crew-1", at), "says what the time should be")
	refused(t, trip.AmendMilestone("teleported", at, "x", "crew-1", at),
		"unknown milestone")

	if err := trip.AmendMilestone(domain.MilestoneAtScene,
		at.Add(6*time.Minute), "tablet clock was two minutes fast",
		"crew-2", at.Add(time.Hour)); err != nil {
		t.Fatalf("AmendMilestone: %v", err)
	}

	// "The arrival time was changed after the complaint" is a question
	// somebody asks, and a timeline that answered it by having only one
	// value would not be auditable at all.
	corrected, found := trip.MilestoneAt(domain.MilestoneAtScene)
	if !found || !corrected.Equal(at.Add(6*time.Minute)) {
		t.Fatalf("the correction did not take: %v", corrected)
	}
	original, amended := false, false
	for _, record := range trip.Milestones {
		if record.Milestone != domain.MilestoneAtScene {
			continue
		}
		if record.AmendsAt.IsZero() &&
			record.At.Equal(at.Add(8*time.Minute)) {
			original = true
		}
		// "The arrival time was changed an hour after the job" is a
		// different question from what it was changed to, and the second
		// answer does not contain the first.
		if !record.AmendsAt.IsZero() &&
			record.AmendedAt.Equal(at.Add(time.Hour)) {
			amended = true
		}
	}
	if !original {
		t.Fatalf("the original arrival time was erased: %+v",
			trip.Milestones)
	}
	if !amended {
		t.Fatalf("the correction does not say when it was made: %+v",
			trip.Milestones)
	}

	// An amendment is not a new milestone, so the next one in sequence is
	// still accepted.
	if err := trip.RecordMilestone(domain.MilestoneWithPatient, "",
		"crew-1", at.Add(10*time.Minute)); err != nil {
		t.Fatalf("RecordMilestone: %v", err)
	}
}

func TestAnAbortedTripSaysWhyAndIsNotAskedForATimelineItNeverHad(
	t *testing.T) {

	trip := dispatched(t)
	refused(t, trip.Abort("", "dispatch-1", at), "say why")
	refused(t, trip.Abort("stood down", "", at), "names who made it")

	if err := trip.Abort("stood down en route", "dispatch-1",
		at.Add(4*time.Minute)); err != nil {
		t.Fatalf("Abort: %v", err)
	}
	refused(t, trip.Abort("again", "dispatch-1", at), "this trip is aborted")
	refused(t, trip.RecordMilestone(domain.MilestoneAtScene, "", "crew-1",
		at), "this trip is aborted")

	// A trip stood down before it arrived is not expected to have reached
	// the destination, so only the points up to where it stopped are asked
	// for.
	gaps := domain.TimelineGaps(trip)
	if len(gaps) != 1 || gaps[0] != domain.MilestoneMobile {
		t.Fatalf("want only the mobile time missing, got %+v", gaps)
	}

	// A trip that reached the hospital with no "at scene" time has a
	// response time nobody can compute, and the gap is reported rather than
	// filled in with a guess.
	incomplete := dispatched(t)
	for _, milestone := range []domain.Milestone{
		domain.MilestoneMobile, domain.MilestoneAtDestination,
		domain.MilestoneHandover, domain.MilestoneClear,
	} {
		if err := incomplete.RecordMilestone(milestone, "", "crew-1",
			at.Add(20*time.Minute)); err != nil {
			t.Fatalf("RecordMilestone: %v", err)
		}
	}
	gaps = domain.TimelineGaps(incomplete)
	if len(gaps) != 3 {
		t.Fatalf("want the three missing points, got %+v", gaps)
	}
	// And a trip still running is not asked for a timeline it has not
	// finished.
	if got := domain.TimelineGaps(dispatched(t)); got != nil {
		t.Fatalf("a running trip reported gaps: %+v", got)
	}
}

// -------------------------------------------- prehospital (SRS-AMB-004/007)

func paramedic() domain.CrewMember {
	return domain.CrewMember{
		SubjectID: "crew-2", Name: "A Paramedic",
		Role: domain.CrewParamedic, RegistrationNumber: "P-1",
	}
}

func driver() domain.CrewMember {
	return domain.CrewMember{
		SubjectID: "crew-1", Name: "A Driver", Role: domain.CrewDriver,
	}
}

func record(t *testing.T) domain.PrehospitalRecord {
	t.Helper()
	out, err := domain.OpenRecord("pr1", "t1", domain.NewRecordInput{
		TripID: "trip-1", RequestID: "r1", PatientID: "p1",
		FacilityID: "f1", PresentingComplaint: "chest pain",
	}, "crew-2", at)
	if err != nil {
		t.Fatalf("OpenRecord: %v", err)
	}
	return out
}

func TestOnlyAClinicianRecordsAPrehospitalIntervention(t *testing.T) {
	// A record with no trip behind it cannot be attributed to a crew, a
	// vehicle or a timeline.
	_, err := domain.OpenRecord("pr1", "t1", domain.NewRecordInput{},
		"crew-2", at)
	refused(t, err, "names its trip")
	_, err = domain.OpenRecord("pr1", "t1",
		domain.NewRecordInput{TripID: "trip-1"}, "", at)
	refused(t, err, "names who opened it")
	_, err = domain.OpenRecord("", "t1",
		domain.NewRecordInput{TripID: "trip-1"}, "crew-2", at)
	refused(t, err, "needs an id")

	entry := record(t)
	// A medication given by a driver is not a record of who gave it, it is
	// a record of who typed it.
	refused(t, entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "MORPH",
		DoseAmount: 5, DoseUnit: "mg", Route: "iv",
	}, driver(), at), "a driver does not record")

	refused(t, entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "MORPH",
	}, domain.CrewMember{Role: domain.CrewParamedic}, at),
		"names who recorded it")

	refused(t, entry.Record("e1", domain.NewEntryInput{Kind: "guess"},
		paramedic(), at), "unknown entry kind")
	refused(t, entry.Record("", domain.NewEntryInput{
		Kind: domain.EntryNote,
	}, paramedic(), at), "an entry needs an id")

	// A drug with no dose is a line in a record that cannot be checked
	// against anything.
	refused(t, entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "MORPH", Route: "iv",
	}, paramedic(), at), "says how much")
	refused(t, entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "MORPH",
		DoseAmount: 5, DoseUnit: "mg",
	}, paramedic(), at), "says how it was given")
	refused(t, entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryMedication, DoseAmount: 5, DoseUnit: "mg",
		Route: "iv",
	}, paramedic(), at), "names the drug")

	refused(t, entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryObservation, Value: "120/80",
	}, paramedic(), at), "says what was measured")

	// A record written up two hours later is a different thing from one
	// written at the time, and both moments are kept.
	if err := entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryObservation, Code: "BP", Value: "90/50",
		Unit: "mmHg", RecordedAt: at.Add(-20 * time.Minute),
	}, paramedic(), at); err != nil {
		t.Fatalf("Record: %v", err)
	}
	stored := entry.Entries[0]
	if !stored.RecordedAt.Equal(at.Add(-20*time.Minute)) ||
		!stored.EnteredAt.Equal(at) {
		t.Fatalf("the two times were collapsed: %+v", stored)
	}
	// A paramedic who becomes a manager next year still gave that drug as
	// a paramedic.
	if stored.RecordedRole != domain.CrewParamedic ||
		stored.RecordedBy != "crew-2" {
		t.Fatalf("the role was not pinned: %+v", stored)
	}
}

func TestAHandoverIsAcceptedBySomebodyOtherThanWhoeverGaveIt(t *testing.T) {
	entry := record(t)

	// A crew that recorded nothing at all on the way in did not assess the
	// patient, or did and wrote none of it down.
	refused(t, entry.GiveHandover("chest pain, aspirin given", "ACS",
		paramedic(), at), "carries what the crew recorded")

	if err := entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "ASP", DoseAmount: 300,
		DoseUnit: "mg", Route: "po",
	}, paramedic(), at); err != nil {
		t.Fatalf("Record: %v", err)
	}

	// A handover with nothing in it is a patient arriving with a wristband
	// and a shrug.
	refused(t, entry.GiveHandover("", "ACS", paramedic(), at),
		"says what happened")
	refused(t, entry.GiveHandover("summary", "ACS", driver(), at),
		"a driver does not give a clinical handover")
	refused(t, entry.GiveHandover("summary", "ACS",
		domain.CrewMember{Role: domain.CrewParamedic}, at),
		"names who gave it")

	// Nothing to accept until it is given.
	refused(t, entry.Accept("enc-1", "", "ed-doctor", at),
		"has not been given")

	if err := entry.GiveHandover("chest pain, 300mg aspirin, ECG shows ST "+
		"elevation", "ACS", paramedic(), at.Add(30*time.Minute)); err != nil {
		t.Fatalf("GiveHandover: %v", err)
	}
	refused(t, entry.GiveHandover("again", "ACS", paramedic(), at),
		"this handover is given")

	// A handover accepted by the person who gave it is the same claim made
	// twice, and the patient is standing between two people neither of whom
	// has taken responsibility.
	refused(t, entry.Accept("enc-1", "", "crew-2", at),
		"other than whoever gave it")
	refused(t, entry.Accept("enc-1", "", "", at), "names who made it")

	if err := entry.Accept("enc-1", "to resus", "ed-doctor",
		at.Add(35*time.Minute)); err != nil {
		t.Fatalf("Accept: %v", err)
	}
	// SRS-AMB-004: the data attaches to the emergency encounter on arrival.
	if entry.EncounterID != "enc-1" ||
		entry.State != domain.HandoverAccepted {
		t.Fatalf("the record did not attach: %+v", entry)
	}

	// Once the receiving clinician has taken the patient, a late addition
	// is an amendment to somebody else's decision.
	refused(t, entry.Record("e2", domain.NewEntryInput{
		Kind: domain.EntryNote, Narrative: "forgot to mention",
	}, paramedic(), at), "has been accepted and is not added to")
	refused(t, entry.AttachDocument("doc-9"),
		"has been accepted and is not added to")
	refused(t, entry.Accept("enc-1", "", "another-doctor", at),
		"this handover is accepted")
}

func TestTransferDocumentsAreReferencesAndTheHandoverQueueIsOldestFirst(
	t *testing.T) {

	entry := record(t)
	refused(t, entry.AttachDocument(" "), "cannot be empty")
	if err := entry.AttachDocument("referral-1"); err != nil {
		t.Fatalf("AttachDocument: %v", err)
	}
	// A second copy of a referral goes stale the first time somebody
	// corrects one, and the same reference twice is two rows for one
	// document.
	refused(t, entry.AttachDocument("REFERRAL-1"), "is already attached")

	if err := entry.Record("e1", domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "ASP", DoseAmount: 300,
		DoseUnit: "mg", Route: "po", RecordedAt: at.Add(5 * time.Minute),
	}, paramedic(), at); err != nil {
		t.Fatalf("Record: %v", err)
	}
	if err := entry.Record("e2", domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "MORPH", DoseAmount: 5,
		DoseUnit: "mg", Route: "iv", RecordedAt: at.Add(2 * time.Minute),
	}, paramedic(), at); err != nil {
		t.Fatalf("Record: %v", err)
	}
	// The question an emergency department asks in the first minute, in
	// the order the drugs were given rather than the order they were typed.
	drugs := entry.Medications()
	if len(drugs) != 2 || drugs[0].Code != "MORPH" {
		t.Fatalf("the medications are out of order: %+v", drugs)
	}

	if err := entry.GiveHandover("summary", "ACS", paramedic(),
		at.Add(30*time.Minute)); err != nil {
		t.Fatalf("GiveHandover: %v", err)
	}

	earlier := record(t)
	earlier.ID = "pr0"
	if err := earlier.Record("e3", domain.NewEntryInput{
		Kind: domain.EntryNote, Narrative: "walked to the vehicle",
	}, paramedic(), at); err != nil {
		t.Fatalf("Record: %v", err)
	}
	if err := earlier.GiveHandover("summary", "fall", paramedic(),
		at.Add(10*time.Minute)); err != nil {
		t.Fatalf("GiveHandover: %v", err)
	}

	// A crew that handed over to nobody is a patient in a corridor, and the
	// oldest one is the one to look at first.
	waiting := domain.Unaccepted([]domain.PrehospitalRecord{entry, earlier})
	if len(waiting) != 2 || waiting[0].ID != "pr0" {
		t.Fatalf("want the oldest handover first, got %+v", waiting)
	}
	if err := earlier.Accept("enc-2", "", "ed-doctor", at); err != nil {
		t.Fatalf("Accept: %v", err)
	}
	if got := domain.Unaccepted([]domain.PrehospitalRecord{
		earlier}); len(got) != 0 {
		t.Fatalf("an accepted handover is still waiting: %+v", got)
	}
}

// -------------------------------------------------- location (SRS-AMB-005)

func pingInput() domain.NewPingInput {
	return domain.NewPingInput{
		VehicleID: "v1", TripID: "trip-1",
		LatitudeMicro: 13_082_680, LongitudeMicro: 80_270_718,
		SpeedKph: 48, HeadingDegrees: 270, AccuracyMetres: 8,
		Source: "fleet-telematics",
	}
}

func TestALocationFeedIsBoundedByTheDeploymentsRetention(t *testing.T) {
	// A deployment that has not decided how long it keeps a map of where
	// its ambulances went has not decided the one thing SRS-AMB-005 asks
	// it to decide.
	_, err := domain.RecordPing("p1", "t1", pingInput(), 0, at)
	refused(t, err, "no retention period")

	in := pingInput()
	in.Source = ""
	_, err = domain.RecordPing("p1", "t1", in, time.Hour, at)
	refused(t, err, "names where it came from")

	for _, bad := range []struct {
		mutate func(*domain.NewPingInput)
		want   string
	}{
		{func(in *domain.NewPingInput) { in.LatitudeMicro = 91_000_000 },
			"latitude is out of range"},
		{func(in *domain.NewPingInput) {
			in.LongitudeMicro = -181_000_000
		}, "longitude is out of range"},
		{func(in *domain.NewPingInput) { in.SpeedKph = -1 },
			"cannot be negative"},
		{func(in *domain.NewPingInput) { in.HeadingDegrees = 360 },
			"between 0 and 359"},
		{func(in *domain.NewPingInput) { in.VehicleID = "" },
			"names its vehicle"},
	} {
		in := pingInput()
		bad.mutate(&in)
		_, err := domain.RecordPing("p1", "t1", in, time.Hour, at)
		refused(t, err, bad.want)
	}
	_, err = domain.RecordPing("", "t1", pingInput(), time.Hour, at)
	refused(t, err, "a ping needs an id")

	ping, err := domain.RecordPing("p1", "t1", pingInput(), 24*time.Hour, at)
	if err != nil {
		t.Fatalf("RecordPing: %v", err)
	}
	// The horizon is a property of the row rather than of whatever the
	// purge job was last told.
	if !ping.RetainUntil.Equal(at.Add(24 * time.Hour)) {
		t.Fatalf("the horizon was not recorded: %v", ping.RetainUntil)
	}
	if ping.Expired(at) || !ping.Expired(at.Add(25*time.Hour)) {
		t.Fatalf("the ping expires at the wrong moment: %+v", ping)
	}

	// A read that respects the horizon cannot return yesterday's trail
	// because the purge is behind.
	old, err := domain.RecordPing("p0", "t1", pingInput(), time.Hour,
		at.Add(-2*time.Hour))
	if err != nil {
		t.Fatalf("RecordPing: %v", err)
	}
	kept := domain.Retained([]domain.Ping{old, ping}, at)
	if len(kept) != 1 || kept[0].ID != "p1" {
		t.Fatalf("an expired ping reached the read: %+v", kept)
	}
}

func TestAVehiclesPositionIsTheLatestKeptPingAndNothingIsAssumed(
	t *testing.T) {

	// A vehicle with nothing in retention reports that, rather than
	// defaulting to the base — which would put an ambulance somewhere it
	// is not.
	absent := domain.Latest(nil, "v1", time.Minute, at)
	if absent.Known {
		t.Fatalf("a vehicle with no feed has a position: %+v", absent)
	}

	var pings []domain.Ping
	for i, spec := range []struct {
		id      string
		vehicle string
		at      time.Time
	}{
		{"p1", "v1", at.Add(-10 * time.Minute)},
		{"p2", "v1", at.Add(-2 * time.Minute)},
		{"p3", "v1", at.Add(-6 * time.Minute)},
		{"p4", "v2", at.Add(-time.Minute)},
	} {
		in := pingInput()
		in.VehicleID, in.At = spec.vehicle, spec.at
		in.SpeedKph = i * 10
		ping, err := domain.RecordPing(spec.id, "t1", in, 24*time.Hour, at)
		if err != nil {
			t.Fatalf("RecordPing: %v", err)
		}
		pings = append(pings, ping)
	}

	// The latest by time, not the last one written: a box that uploads a
	// backlog must not rewind where a vehicle is.
	latest := domain.Latest(pings, "v1", 5*time.Minute, at)
	if !latest.Known || latest.SpeedKph != 10 || latest.Stale {
		t.Fatalf("the position is wrong: %+v", latest)
	}
	// A dispatcher who can see the vehicle was last heard from eleven
	// minutes ago knows something a blank screen does not tell them.
	stale := domain.Latest(pings, "v1", time.Minute, at)
	if !stale.Known || !stale.Stale {
		t.Fatalf("a stale position did not say so: %+v", stale)
	}
	// And an expired feed is not a position at all.
	if got := domain.Latest(pings, "v1", time.Minute,
		at.Add(48*time.Hour)); got.Known {
		t.Fatalf("an expired feed produced a position: %+v", got)
	}
}

func TestAnEstimateNamesItsProviderAndIsNeverGuessed(t *testing.T) {
	// A road network, live traffic and a blue-light routing model are the
	// provider's job; guessing from a straight line would produce a number
	// that looks like an ETA and is not one, and a dispatcher would hold a
	// bed against it.
	_, err := domain.NewETA("v1", "trip-1", 420, 3200, "", at)
	refused(t, err, "names where it came from")
	_, err = domain.NewETA("", "trip-1", 420, 3200, "routing", at)
	refused(t, err, "names its vehicle")
	_, err = domain.NewETA("v1", "trip-1", -1, 3200, "routing", at)
	refused(t, err, "cannot be negative")

	eta, err := domain.NewETA("v1", "trip-1", 420, 3200, "routing", at)
	if err != nil {
		t.Fatalf("NewETA: %v", err)
	}
	if !eta.Known || eta.Seconds != 420 || eta.Source != "routing" {
		t.Fatalf("the estimate did not stick: %+v", eta)
	}
	// A deployment with no provider has no estimate rather than a made-up
	// one.
	if (domain.ETA{}).Known {
		t.Fatal("an absent estimate reads as known")
	}
}

// --------------------------------------------------- reporting (SRS-AMB-008)

func completedTrip(t *testing.T, id string, offsets map[domain.Milestone]int,
	skip ...domain.Milestone) domain.Trip {

	t.Helper()
	trip := dispatched(t)
	trip.ID = id
	skipped := map[domain.Milestone]bool{}
	for _, milestone := range skip {
		skipped[milestone] = true
	}
	for _, milestone := range []domain.Milestone{
		domain.MilestoneMobile, domain.MilestoneAtScene,
		domain.MilestoneWithPatient, domain.MilestoneLeftScene,
		domain.MilestoneAtDestination, domain.MilestoneHandover,
		domain.MilestoneClear,
	} {
		if skipped[milestone] {
			continue
		}
		minutes, ok := offsets[milestone]
		if !ok {
			minutes = 1
		}
		if err := trip.RecordMilestone(milestone, "", "crew-1",
			at.Add(time.Duration(minutes)*time.Minute)); err != nil {
			t.Fatalf("RecordMilestone %s: %v", milestone, err)
		}
	}
	return trip
}

func TestEveryFigureComesFromTheMilestonesAndAGapIsReportedNotGuessed(
	t *testing.T) {

	call := request(t, "r1", nil)
	fast := completedTrip(t, "trip-fast", map[domain.Milestone]int{
		domain.MilestoneMobile: 1, domain.MilestoneAtScene: 7,
		domain.MilestoneWithPatient: 9, domain.MilestoneLeftScene: 20,
		domain.MilestoneAtDestination: 35, domain.MilestoneHandover: 50,
		domain.MilestoneClear: 60,
	})
	fast.RequestID = call.ID

	metrics := domain.Measure(call, fast)
	if !metrics.Answered || metrics.ResponseSeconds != 7*60 {
		t.Fatalf("the response time is wrong: %+v", metrics)
	}
	if !metrics.OnSceneKnown || metrics.OnSceneSeconds != 13*60 {
		t.Fatalf("the on-scene time is wrong: %+v", metrics)
	}
	// The number that turns an ambulance into a corridor.
	if !metrics.HandoverKnown || metrics.HandoverSeconds != 15*60 {
		t.Fatalf("the handover time is wrong: %+v", metrics)
	}
	if !metrics.TurnaroundKnown || metrics.TurnaroundSeconds != 25*60 ||
		!metrics.TotalKnown || metrics.TotalSeconds != 60*60 {
		t.Fatalf("the turnaround is wrong: %+v", metrics)
	}

	// A trip that reached the hospital with no arrival time has a response
	// time nobody can compute, and the figure is withheld rather than
	// guessed.
	noScene := completedTrip(t, "trip-gap", nil,
		domain.MilestoneAtScene, domain.MilestoneWithPatient)
	noScene.RequestID = call.ID
	gapMetrics := domain.Measure(call, noScene)
	if gapMetrics.Answered || gapMetrics.ResponseSeconds != 0 {
		t.Fatalf("a missing arrival produced a response time: %+v",
			gapMetrics)
	}
	if len(gapMetrics.Gaps) != 2 {
		t.Fatalf("the gaps were not reported: %+v", gapMetrics.Gaps)
	}

	cancelledBefore := request(t, "r2", nil)
	if err := cancelledBefore.Cancel("caller rang back", "dispatch-1",
		at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	cancelledAfter := request(t, "r3", nil)
	if err := cancelledAfter.Cancel("patient refused", "dispatch-1",
		at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	standDown := dispatched(t)
	standDown.ID, standDown.RequestID = "trip-stood", cancelledAfter.ID
	if err := standDown.Abort("patient refused", "dispatch-1",
		at.Add(5*time.Minute)); err != nil {
		t.Fatalf("Abort: %v", err)
	}

	second := call
	second.ID = "r4"
	slow := completedTrip(t, "trip-slow", map[domain.Milestone]int{
		domain.MilestoneMobile: 2, domain.MilestoneAtScene: 22,
		domain.MilestoneWithPatient: 25, domain.MilestoneLeftScene: 40,
		domain.MilestoneAtDestination: 55, domain.MilestoneHandover: 115,
		domain.MilestoneClear: 130,
	})
	slow.RequestID = second.ID
	slow.OverrideBy = "duty-officer"

	gapRequest := call
	gapRequest.ID = "r5"
	noScene.RequestID = gapRequest.ID

	summary := domain.Summarise(
		[]domain.Request{call, second, gapRequest, cancelledBefore,
			cancelledAfter},
		[]domain.Trip{fast, slow, noScene, standDown})

	if summary.Requests != 5 || summary.Dispatched != 4 ||
		summary.Completed != 3 || summary.Aborted != 1 {
		t.Fatalf("the counts are wrong: %+v", summary)
	}
	// "We cancelled a fifth of our calls" and "a fifth of our calls stood
	// down after we arrived" are different problems.
	if summary.Cancelled != 2 || summary.CancelledAfterDispatch != 1 {
		t.Fatalf("the cancellations are wrong: %+v", summary)
	}
	if summary.Overridden != 1 {
		t.Fatalf("the override was not counted: %+v", summary)
	}
	// A service whose worst calls have incomplete timelines would otherwise
	// report the best response times in the region.
	if summary.IncompleteTimelines != 2 {
		t.Fatalf("the incomplete timelines were not counted: %+v", summary)
	}
	// Two trips have a response time; the third has a gap and is excluded
	// from that figure while still counting as a trip.
	if summary.Response.Measured != 2 ||
		summary.Response.MeanSeconds != (7*60+22*60)/2 ||
		summary.Response.LongestSeconds != 22*60 {
		t.Fatalf("the response interval is wrong: %+v", summary.Response)
	}
	// A mean handover time hides the sixty-minute wait; the centile does
	// not.
	if summary.Handover.P90Seconds != 60*60 {
		t.Fatalf("the handover centile is wrong: %+v", summary.Handover)
	}
	if summary.VehiclesSeen != 1 {
		t.Fatalf("the vehicle count is wrong: %+v", summary)
	}

	// A set with nothing measured says so rather than reporting a mean of
	// zero, which reads as a service that arrives instantly.
	empty := domain.Summarise([]domain.Request{cancelledBefore}, nil)
	if !empty.Response.Unanswerable || empty.Response.MeanSeconds != 0 {
		t.Fatalf("an empty interval is answerable: %+v", empty.Response)
	}
}
