package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
)

// The blood bank rules (SRS-BLD-001 … 017).
//
// The compatibility table is asserted exhaustively rather than by example.
// Sixteen donor-recipient pairs per component class is small enough to write
// out, and a table checked by three examples is a table with thirteen untested
// entries — each of which is a patient.

var at = time.Date(2026, 9, 18, 9, 0, 0, 0, time.UTC)

func group(abo domain.ABO, rh domain.RhD) domain.Group {
	return domain.Group{ABO: abo, Rh: rh}
}

// SRS-BLD-007. Every ABO pair, both directions, for red cells.
//
// The classic table: O gives to everybody and receives only from O; AB
// receives from everybody and gives only to AB.
func TestRedCellCompatibilityIsTheWholeTable(t *testing.T) {
	groups := []domain.ABO{domain.ABOO, domain.ABOA, domain.ABOB, domain.ABOAB}
	// want[recipient][donor].
	want := map[domain.ABO]map[domain.ABO]bool{
		domain.ABOO:  {domain.ABOO: true, domain.ABOA: false, domain.ABOB: false, domain.ABOAB: false},
		domain.ABOA:  {domain.ABOO: true, domain.ABOA: true, domain.ABOB: false, domain.ABOAB: false},
		domain.ABOB:  {domain.ABOO: true, domain.ABOA: false, domain.ABOB: true, domain.ABOAB: false},
		domain.ABOAB: {domain.ABOO: true, domain.ABOA: true, domain.ABOB: true, domain.ABOAB: true},
	}

	for _, recipient := range groups {
		for _, donor := range groups {
			got := domain.CompatibleGroups(domain.ClassRedCells,
				group(donor, domain.RhPositive), group(recipient, domain.RhPositive))
			if got != want[recipient][donor] {
				t.Errorf("red cells %s -> %s = %v, want %v",
					donor, recipient, got, want[recipient][donor])
			}
		}
	}
}

// SRS-BLD-007. Plasma runs the other way, because it carries the antibodies
// rather than the antigens. A table that used one direction for both would
// give AB plasma to an O patient.
func TestPlasmaCompatibilityRunsTheOtherWay(t *testing.T) {
	groups := []domain.ABO{domain.ABOO, domain.ABOA, domain.ABOB, domain.ABOAB}
	want := map[domain.ABO]map[domain.ABO]bool{
		domain.ABOO:  {domain.ABOO: true, domain.ABOA: true, domain.ABOB: true, domain.ABOAB: true},
		domain.ABOA:  {domain.ABOO: false, domain.ABOA: true, domain.ABOB: false, domain.ABOAB: true},
		domain.ABOB:  {domain.ABOO: false, domain.ABOA: false, domain.ABOB: true, domain.ABOAB: true},
		domain.ABOAB: {domain.ABOO: false, domain.ABOA: false, domain.ABOB: false, domain.ABOAB: true},
	}

	for _, recipient := range groups {
		for _, donor := range groups {
			got := domain.CompatibleGroups(domain.ClassPlasma,
				group(donor, domain.RhPositive), group(recipient, domain.RhPositive))
			if got != want[recipient][donor] {
				t.Errorf("plasma %s -> %s = %v, want %v",
					donor, recipient, got, want[recipient][donor])
			}
		}
	}
}

// SRS-BLD-007. Rh(D) applies to the components that carry red cells, in one
// direction: an Rh-negative patient is not given Rh-positive cells.
func TestRhNegativePatientsAreNotGivenPositiveCells(t *testing.T) {
	if domain.CompatibleGroups(domain.ClassRedCells,
		group(domain.ABOO, domain.RhPositive),
		group(domain.ABOO, domain.RhNegative)) {
		t.Error("O+ cells were compatible with an O- patient")
	}
	// The other direction is fine and is the commonest substitution there is.
	if !domain.CompatibleGroups(domain.ClassRedCells,
		group(domain.ABOO, domain.RhNegative),
		group(domain.ABOO, domain.RhPositive)) {
		t.Error("O- cells were incompatible with an O+ patient")
	}
	// And Rh does not gate plasma, which carries no D antigen.
	if !domain.CompatibleGroups(domain.ClassPlasma,
		group(domain.ABOAB, domain.RhPositive),
		group(domain.ABOO, domain.RhNegative)) {
		t.Error("AB+ plasma was refused to an O- patient on Rh grounds")
	}
}

// Unknown on either side is never a match. Every other rule here depends on
// it: "we have not grouped this patient" must not read as compatible.
func TestAnUnknownGroupIsNeverCompatible(t *testing.T) {
	known := group(domain.ABOO, domain.RhNegative)
	cases := []struct {
		name             string
		donor, recipient domain.Group
	}{
		{"donor ungrouped", domain.Group{}, known},
		{"recipient ungrouped", known, domain.Group{}},
		{"donor missing Rh", domain.Group{ABO: domain.ABOO}, known},
		{"recipient missing ABO", known, domain.Group{Rh: domain.RhNegative}},
		{"both ungrouped", domain.Group{}, domain.Group{}},
	}
	for _, c := range cases {
		if domain.CompatibleGroups(domain.ClassRedCells, c.donor, c.recipient) {
			t.Errorf("%s: an unknown group matched", c.name)
		}
	}
}

// Whole blood carries both, so it is held to both tables. An A patient may
// receive O red cells, but not O whole blood: the plasma in it has anti-A.
func TestWholeBloodIsHeldToBothTables(t *testing.T) {
	if !domain.CompatibleGroups(domain.ClassRedCells,
		group(domain.ABOO, domain.RhPositive),
		group(domain.ABOA, domain.RhPositive)) {
		t.Fatal("O red cells were refused to an A patient")
	}
	if domain.CompatibleGroups(domain.ClassWholeBlood,
		group(domain.ABOO, domain.RhPositive),
		group(domain.ABOA, domain.RhPositive)) {
		t.Error("O whole blood was given to an A patient; its plasma has anti-A")
	}
}

func component(t *testing.T, mutate func(*domain.NewComponentInput)) domain.Component {
	t.Helper()

	in := domain.NewComponentInput{
		UnitNumber: "G123456", CollectionID: "coll-1", DonorID: "donor-1",
		Class:    domain.ClassRedCells,
		Group:    group(domain.ABOO, domain.RhNegative),
		VolumeML: 280, Location: "fridge 2",
		CollectedAt: at.Add(-24 * time.Hour),
		ExpiresAt:   at.Add(30 * 24 * time.Hour),
	}
	if mutate != nil {
		mutate(&in)
	}
	unit, err := domain.NewComponent("unit-1", "tenant-1", in, "scientist-1", at)
	if err != nil {
		t.Fatalf("NewComponent: %v", err)
	}
	return unit
}

// SRS-BLD-004. A unit starts quarantined. The safe state is the default rather
// than something a caller has to remember to ask for.
func TestAUnitStartsQuarantined(t *testing.T) {
	unit := component(t, nil)
	if unit.Status != domain.UnitQuarantined {
		t.Fatalf("status = %q, want quarantined", unit.Status)
	}
	if unit.Issuable(at) {
		t.Error("a unit whose testing is not recorded is issuable")
	}

	if err := unit.Release(at); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if !unit.Issuable(at) {
		t.Error("a released unit is not issuable")
	}
	// And releasing twice is refused: a second release would hide a
	// quarantine somebody applied in between.
	if err := unit.Release(at); err == nil {
		t.Error("a released unit was released again")
	}
}

// SRS-BLD-005. Expiry and status fail independently, so a check on one is not
// a check on the other.
func TestAnExpiredUnitIsNotAllocatableHoweverAvailable(t *testing.T) {
	unit := component(t, func(in *domain.NewComponentInput) {
		in.ExpiresAt = at.Add(time.Hour)
	})
	if err := unit.Release(at); err != nil {
		t.Fatalf("Release: %v", err)
	}

	if !unit.Issuable(at) {
		t.Fatal("a released, in-date unit is not issuable")
	}
	later := at.Add(2 * time.Hour)
	if unit.Status != domain.UnitAvailable {
		t.Fatalf("status = %q; the test needs it available to be meaningful",
			unit.Status)
	}
	if unit.Issuable(later) {
		t.Error("an available but expired unit is issuable; status alone is " +
			"not the check")
	}
	// Releasing an already-expired unit is refused outright.
	stale := component(t, func(in *domain.NewComponentInput) {
		in.ExpiresAt = at.Add(time.Hour)
	})
	if err := stale.Release(later); err == nil {
		t.Error("an expired unit was released from quarantine")
	}
}

// A component with no parent collection cannot be traced back to a donor.
func TestAComponentRefusesToExistWithoutItsProvenance(t *testing.T) {
	cases := []struct {
		name   string
		mutate func(*domain.NewComponentInput)
	}{
		{"no collection", func(in *domain.NewComponentInput) { in.CollectionID = "" }},
		{"no unit number", func(in *domain.NewComponentInput) { in.UnitNumber = "" }},
		{"no group", func(in *domain.NewComponentInput) { in.Group = domain.Group{} }},
		{"no expiry", func(in *domain.NewComponentInput) { in.ExpiresAt = time.Time{} }},
		{"no donor and no supplier", func(in *domain.NewComponentInput) {
			in.DonorID, in.Source = "", ""
		}},
		{"expires before it was collected", func(in *domain.NewComponentInput) {
			in.ExpiresAt = in.CollectedAt.Add(-time.Hour)
		}},
	}
	for _, c := range cases {
		in := domain.NewComponentInput{
			UnitNumber: "G1", CollectionID: "coll-1", DonorID: "donor-1",
			Class:       domain.ClassRedCells,
			Group:       group(domain.ABOO, domain.RhNegative),
			CollectedAt: at, ExpiresAt: at.Add(24 * time.Hour),
		}
		c.mutate(&in)
		if _, err := domain.NewComponent("unit-x", "tenant-1", in,
			"scientist-1", at); err == nil {
			t.Errorf("%s: accepted", c.name)
		} else if !errors.Is(err, domain.ErrInvalidUnit) {
			t.Errorf("%s: wrong error type: %v", c.name, err)
		}
	}

	// A unit received from a supplier has no donor here, and that is fine.
	bought := component(t, func(in *domain.NewComponentInput) {
		in.DonorID, in.Source = "", "Regional Blood Centre"
	})
	if bought.Source == "" {
		t.Error("the supplier was lost")
	}
}

// SRS-BLD-002. A deferred donor does not donate, and the deferral has to say
// when it ends.
func TestADeferredDonorDoesNotDonate(t *testing.T) {
	donor, err := domain.NewDonor("donor-1", "tenant-1", domain.NewDonorInput{
		DonorNumber: "D0001", Name: "Anita Rao",
		Group: group(domain.ABOO, domain.RhNegative),
	}, "clerk-1", at)
	if err != nil {
		t.Fatalf("NewDonor: %v", err)
	}

	// A temporary deferral with no end date is a permanent one nobody meant.
	if err := donor.Defer(domain.DeferralTemporary, "low_hb", "",
		time.Time{}, "nurse-1", at); err == nil {
		t.Error("a temporary deferral with no end date was accepted")
	}
	if err := donor.Defer(domain.DeferralTemporary, "", "note",
		at.Add(90*24*time.Hour), "nurse-1", at); err == nil {
		t.Error("a deferral with no reason code was accepted")
	}

	if err := donor.Defer(domain.DeferralTemporary, "low_hb", "Hb 11.2",
		at.Add(90*24*time.Hour), "nurse-1", at); err != nil {
		t.Fatalf("Defer: %v", err)
	}
	if !donor.Deferred(at) {
		t.Fatal("a just-deferred donor is not deferred")
	}
	// It lapses on its own, rather than waiting for somebody to clear it.
	if donor.Deferred(at.Add(91 * 24 * time.Hour)) {
		t.Error("a temporary deferral did not lapse on its date")
	}

	screening, err := domain.Screen("screen-1", "tenant-1",
		domain.NewScreeningInput{
			DonorID: donor.ID, Consented: true, Accepted: true,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("Screen: %v", err)
	}
	if _, err := domain.Collect("coll-1", "tenant-1",
		domain.NewCollectionInput{DonationNumber: "D24-001", VolumeML: 450},
		donor, screening, "nurse-1", at); err == nil {
		t.Fatal("a deferred donor donated")
	}

	// And a permanent deferral is not lifted here.
	if err := donor.Defer(domain.DeferralPermanent, "vcjd_risk", "",
		time.Time{}, "doctor-1", at); err != nil {
		t.Fatalf("Defer permanent: %v", err)
	}
	if err := donor.Reinstate("seems fine now", "clerk-1", at); err == nil {
		t.Error("a permanent deferral was lifted at a screening desk")
	}
	if !donor.Deferred(at.Add(10 * 365 * 24 * time.Hour)) {
		t.Error("a permanent deferral lapsed")
	}
}

// SRS-BLD-002. Accepting a donor who has not consented is the one combination
// that must not be recordable.
func TestADonorCannotBeAcceptedWithoutConsent(t *testing.T) {
	if _, err := domain.Screen("screen-1", "tenant-1",
		domain.NewScreeningInput{
			DonorID: "donor-1", Consented: false, Accepted: true,
		}, "nurse-1", at); err == nil {
		t.Fatal("an unconsented donor was accepted")
	}
	if _, err := domain.Screen("screen-2", "tenant-1",
		domain.NewScreeningInput{
			DonorID: "donor-1", Consented: true, Accepted: true,
			Deferral: domain.DeferralTemporary,
		}, "nurse-1", at); err == nil {
		t.Error("a donor was accepted and deferred at once")
	}
}

// SRS-BLD-004. A panel nobody configured releases nothing, and a reactive
// result releases nothing.
func TestReleaseNeedsEveryMandatoryTest(t *testing.T) {
	panel := domain.MandatoryTests{"hiv", "hbv", "hcv", "syphilis"}

	if decision := domain.EvaluateRelease(nil, nil); decision.Releasable {
		t.Error("an unconfigured panel released a unit")
	}

	partial := []domain.TestResult{
		{Code: "hiv", TestedAt: at}, {Code: "hbv", TestedAt: at},
	}
	decision := domain.EvaluateRelease(panel, partial)
	if decision.Releasable {
		t.Error("a half-tested collection was releasable")
	}
	if len(decision.Missing) != 2 {
		t.Errorf("missing = %v, want hcv and syphilis", decision.Missing)
	}

	complete := append(partial,
		domain.TestResult{Code: "hcv", TestedAt: at},
		domain.TestResult{Code: "syphilis", TestedAt: at})
	if decision := domain.EvaluateRelease(panel, complete); !decision.Releasable {
		t.Errorf("a fully tested collection was not releasable: %+v", decision)
	}

	reactive := append(complete,
		domain.TestResult{Code: "hcv", Reactive: true, TestedAt: at.Add(time.Hour)})
	decision = domain.EvaluateRelease(panel, reactive)
	if decision.Releasable {
		t.Error("a reactive collection was releasable")
	}
	if len(decision.Reactive) != 1 || decision.Reactive[0] != "hcv" {
		t.Errorf("reactive = %v, want [hcv]", decision.Reactive)
	}
}

// A repeat test supersedes the earlier one, which is how a reactive screen
// followed by a negative repeat is handled.
func TestTheLatestResultForATestIsTheOneThatCounts(t *testing.T) {
	panel := domain.MandatoryTests{"hiv"}
	results := []domain.TestResult{
		{Code: "hiv", Reactive: true, TestedAt: at},
		{Code: "hiv", Reactive: false, TestedAt: at.Add(2 * time.Hour)},
	}
	if decision := domain.EvaluateRelease(panel, results); !decision.Releasable {
		t.Errorf("a repeat negative did not supersede the reactive screen: %+v",
			decision)
	}
	// And the other way round: a late reactive result blocks a unit whose
	// first screen was clear.
	late := []domain.TestResult{
		{Code: "hiv", Reactive: false, TestedAt: at},
		{Code: "hiv", Reactive: true, TestedAt: at.Add(2 * time.Hour)},
	}
	if decision := domain.EvaluateRelease(panel, late); decision.Releasable {
		t.Error("a late reactive result did not block release")
	}
}

func readyUnit(t *testing.T, mutate func(*domain.NewComponentInput)) domain.Component {
	t.Helper()
	unit := component(t, mutate)
	if err := unit.Release(at); err != nil {
		t.Fatalf("Release: %v", err)
	}
	return unit
}

func request(t *testing.T, mutate func(*domain.NewRequestInput)) domain.Request {
	t.Helper()
	in := domain.NewRequestInput{
		PatientID: "patient-1", EncounterID: "enc-1",
		Class: domain.ClassRedCells, Quantity: 2,
		Indication: "symptomatic anaemia, Hb 68",
	}
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.NewRequest("req-1", "tenant-1", in, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewRequest: %v", err)
	}
	return out
}

func sample(t *testing.T, mutate func(*domain.NewSampleInput)) domain.PatientSample {
	t.Helper()
	in := domain.NewSampleInput{
		PatientID: "patient-1", SampleNumber: "S0001",
		Group: group(domain.ABOO, domain.RhNegative), CollectedAt: at,
	}
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.RecordSample("sample-1", "tenant-1", in, "scientist-1", at)
	if err != nil {
		t.Fatalf("RecordSample: %v", err)
	}
	return out
}

// SRS-BLD-006. A request with no indication cannot be reviewed afterwards.
func TestARequestRecordsWhyTheBloodIsNeeded(t *testing.T) {
	if _, err := domain.NewRequest("req-x", "tenant-1", domain.NewRequestInput{
		PatientID: "patient-1", Class: domain.ClassRedCells, Quantity: 1,
	}, "doctor-1", at); err == nil {
		t.Error("a request with no indication was accepted")
	}
	if _, err := domain.NewRequest("req-x", "tenant-1", domain.NewRequestInput{
		PatientID: "patient-1", Class: domain.ClassRedCells,
		Indication: "anaemia",
	}, "doctor-1", at); err == nil {
		t.Error("a request for no units was accepted")
	}
	// An omitted urgency is routine, never emergency.
	routine := request(t, nil)
	if routine.Urgency != domain.UrgencyRoutine {
		t.Errorf("default urgency = %q, want routine", routine.Urgency)
	}
}

// SRS-BLD-007, SRS-BLD-008. Every refusal at once, so a scientist is not sent
// back to the fridge one reason at a time.
func TestAMatchReportsEveryRefusalAtOnce(t *testing.T) {
	// An A+ platelet unit, expired, against an O- patient who needs
	// irradiated red cells.
	unit := component(t, func(in *domain.NewComponentInput) {
		in.Class = domain.ClassPlatelets
		in.Group = group(domain.ABOA, domain.RhPositive)
		in.ExpiresAt = at.Add(-time.Hour)
	})
	req := request(t, func(in *domain.NewRequestInput) {
		in.Requirements = []string{"irradiated"}
	})

	decision := domain.EvaluateMatch(unit, req, sample(t, nil), at)
	if decision.Allowed() {
		t.Fatal("an expired, wrong-type, incompatible unit matched")
	}

	want := map[domain.MatchRefusal]bool{
		domain.RefusalUnitNotAllocatable: true,
		domain.RefusalUnitExpired:        true,
		domain.RefusalWrongComponent:     true,
		domain.RefusalGroupIncompatible:  true,
		domain.RefusalMissingAttribute:   true,
	}
	got := map[domain.MatchRefusal]bool{}
	for _, refusal := range decision.Refusals {
		got[refusal] = true
	}
	for refusal := range want {
		if !got[refusal] {
			t.Errorf("refusal %q was not reported", refusal)
		}
	}
	if len(decision.Explanations) != len(decision.Refusals) {
		t.Error("the refusals and their explanations disagree in length")
	}
}

// A patient with no valid sample is reported as needing a sample, not merely
// as incompatible: the fix is another tube, not other blood.
func TestAnExpiredSampleIsReportedAsASampleProblem(t *testing.T) {
	unit := readyUnit(t, nil)
	req := request(t, nil)
	stale := sample(t, func(in *domain.NewSampleInput) {
		in.ValidFor = time.Hour
	})

	decision := domain.EvaluateMatch(unit, req, stale, at.Add(2*time.Hour))
	if decision.Allowed() {
		t.Fatal("a unit matched against an expired sample")
	}
	found := false
	for _, refusal := range decision.Refusals {
		if refusal == domain.RefusalNoSample {
			found = true
		}
	}
	if !found {
		t.Errorf("refusals = %v, want the sample named", decision.Refusals)
	}

	// The same unit and the same patient, with a fresh sample, matches.
	if decision := domain.EvaluateMatch(unit, req, sample(t, nil), at); !decision.Allowed() {
		t.Errorf("a compatible unit was refused: %v", decision.Explanations)
	}
}

// SRS-BLD-008. A reservation cannot be made by skipping the match.
func TestAReservationCannotSkipTheMatch(t *testing.T) {
	refused := domain.MatchDecision{}
	// Build a genuine refusal by matching an incompatible unit.
	unit := readyUnit(t, func(in *domain.NewComponentInput) {
		in.Group = group(domain.ABOA, domain.RhPositive)
	})
	refused = domain.EvaluateMatch(unit, request(t, nil), sample(t, nil), at)

	if _, err := domain.Reserve("res-1", "tenant-1",
		domain.NewReservationInput{
			ComponentID: unit.ID, PatientID: "patient-1",
		}, refused, "scientist-1", at); err == nil {
		t.Fatal("a refused match produced a reservation")
	}

	good := readyUnit(t, nil)
	decision := domain.EvaluateMatch(good, request(t, nil), sample(t, nil), at)
	reservation, err := domain.Reserve("res-2", "tenant-1",
		domain.NewReservationInput{
			ComponentID: good.ID, PatientID: "patient-1", Crossmatched: true,
		}, decision, "scientist-1", at)
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	if !reservation.Active(at) {
		t.Error("a new reservation is not active")
	}
	// It lapses, because blood held for a patient who did not need it is blood
	// the next patient could not have.
	if reservation.Active(at.Add(domain.DefaultReservationWindow + time.Minute)) {
		t.Error("a reservation did not expire")
	}
}

func issuedUnit(t *testing.T) (domain.Component, domain.Reservation) {
	t.Helper()
	unit := readyUnit(t, nil)
	decision := domain.EvaluateMatch(unit, request(t, nil), sample(t, nil), at)
	reservation, err := domain.Reserve("res-1", "tenant-1",
		domain.NewReservationInput{
			ComponentID: unit.ID, RequestID: "req-1",
			PatientID: "patient-1", SampleID: "sample-1", Crossmatched: true,
		}, decision, "scientist-1", at)
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	return unit, reservation
}

// SRS-BLD-009. The final check is compared against the record, not assumed.
func TestIssueChecksTheUnitAndThePatientAgainstTheRecord(t *testing.T) {
	unit, reservation := issuedUnit(t)

	base := domain.NewIssueInput{
		ComponentID: unit.ID, ReservationID: reservation.ID,
		Destination: "ward 7", IssuedTo: "porter-1",
		Check: domain.IssueCheck{
			UnitNumber: unit.UnitNumber, PatientID: "patient-1",
			CheckedBy: "scientist-1",
		},
	}

	wrongUnit := base
	wrongUnit.Check.UnitNumber = "G999999"
	if _, err := domain.IssueComponent("issue-1", "tenant-1", wrongUnit, unit,
		&reservation, "scientist-1", at); err == nil {
		t.Error("a unit was issued against a different unit number")
	}

	wrongPatient := base
	wrongPatient.Check.PatientID = "patient-2"
	if _, err := domain.IssueComponent("issue-1", "tenant-1", wrongPatient, unit,
		&reservation, "scientist-1", at); err == nil {
		t.Error("a unit reserved for one patient was issued for another")
	}

	noCheck := base
	noCheck.Check.CheckedBy = ""
	if _, err := domain.IssueComponent("issue-1", "tenant-1", noCheck, unit,
		&reservation, "scientist-1", at); err == nil {
		t.Error("a unit was issued with no recorded identity check")
	}

	noReservation := base
	if _, err := domain.IssueComponent("issue-1", "tenant-1", noReservation, unit,
		nil, "scientist-1", at); err == nil {
		t.Error("a unit was issued with no reservation and no emergency authority")
	}

	issue, err := domain.IssueComponent("issue-1", "tenant-1", base, unit,
		&reservation, "scientist-1", at)
	if err != nil {
		t.Fatalf("IssueComponent: %v", err)
	}
	if issue.PatientID != "patient-1" || issue.Destination != "ward 7" {
		t.Errorf("issue = %+v", issue)
	}
	if issue.Emergency {
		t.Error("an ordinary issue was flagged as an emergency release")
	}
}

// SRS-BLD-016. An emergency release skips the crossmatch and nothing else.
func TestAnEmergencyReleaseIsAuthorisedFlaggedAndReconciled(t *testing.T) {
	unit := readyUnit(t, nil)
	base := domain.NewIssueInput{
		ComponentID: unit.ID, Destination: "resus", Emergency: true,
		Check: domain.IssueCheck{
			UnitNumber: unit.UnitNumber, PatientID: "patient-9",
			CheckedBy: "scientist-1",
		},
	}

	noAuthoriser := base
	if _, err := domain.IssueComponent("issue-1", "tenant-1", noAuthoriser, unit,
		nil, "scientist-1", at); err == nil {
		t.Error("an emergency release with no authoriser was accepted")
	}

	noReason := base
	noReason.EmergencyAuthoriser = "consultant-1"
	if _, err := domain.IssueComponent("issue-1", "tenant-1", noReason, unit,
		nil, "scientist-1", at); err == nil {
		t.Error("an emergency release with no reason was accepted")
	}

	// And it does not reach an untested unit. This is the place where the
	// pressure to say yes is highest, so it is the place to be sure.
	quarantined := component(t, nil)
	authorised := base
	authorised.EmergencyAuthoriser = "consultant-1"
	authorised.EmergencyReason = "massive haemorrhage protocol"
	authorised.Check.UnitNumber = quarantined.UnitNumber
	if _, err := domain.IssueComponent("issue-1", "tenant-1", authorised,
		quarantined, nil, "scientist-1", at); err == nil {
		t.Fatal("an emergency release reached an untested unit; untested blood " +
			"is not safer than no blood")
	}

	authorised.Check.UnitNumber = unit.UnitNumber
	issue, err := domain.IssueComponent("issue-1", "tenant-1", authorised, unit,
		nil, "scientist-1", at)
	if err != nil {
		t.Fatalf("IssueComponent emergency: %v", err)
	}
	if !issue.Emergency || issue.Reconciled {
		t.Errorf("issue = %+v, want flagged and unreconciled", issue)
	}

	if err := issue.Reconcile("", "scientist-2", at); err == nil {
		t.Error("a reconciliation with no result was accepted")
	}
	if err := issue.Reconcile("retrospective crossmatch compatible",
		"scientist-2", at.Add(3*time.Hour)); err != nil {
		t.Fatalf("Reconcile: %v", err)
	}
	if !issue.Reconciled {
		t.Error("the release is still unreconciled")
	}
	if err := issue.Reconcile("again", "scientist-2", at); err == nil {
		t.Error("a release was reconciled twice")
	}
}

// SRS-BLD-010. The bedside check needs two people and reports every failure.
func TestTheBedsideCheckNeedsTwoPeopleAndReportsEverything(t *testing.T) {
	unit, reservation := issuedUnit(t)
	issue, err := domain.IssueComponent("issue-1", "tenant-1",
		domain.NewIssueInput{
			ComponentID: unit.ID, ReservationID: reservation.ID,
			Destination: "ward 7",
			Check: domain.IssueCheck{
				UnitNumber: unit.UnitNumber, PatientID: "patient-1",
				CheckedBy: "scientist-1",
			},
		}, unit, &reservation, "scientist-1", at)
	if err != nil {
		t.Fatalf("IssueComponent: %v", err)
	}

	good := domain.BedsideCheck{
		UnitNumber: unit.UnitNumber, PatientID: "patient-1",
		PatientGroup: unit.Group, UnitGroup: unit.Group,
		CheckedBy: "nurse-1", CheckedWith: "nurse-2",
	}
	if refusals := domain.VerifyBedside(good, unit, issue, at); len(refusals) != 0 {
		t.Fatalf("a correct bedside check was refused: %v", refusals)
	}

	solo := good
	solo.CheckedWith = ""
	if refusals := domain.VerifyBedside(solo, unit, issue, at); len(refusals) != 1 ||
		refusals[0] != domain.BedsideSoloCheck {
		t.Errorf("a solo check produced %v, want only the solo refusal", refusals)
	}

	// One person checking with themselves is a solo check spelled differently.
	sameTwice := good
	sameTwice.CheckedWith = "Nurse-1"
	if refusals := domain.VerifyBedside(sameTwice, unit, issue, at); len(refusals) == 0 {
		t.Error("one person checking twice passed as two people")
	}

	// The worst case: wrong patient, wrong unit, expired. All three reported.
	wrong := good
	wrong.PatientID = "patient-2"
	wrong.UnitNumber = "G999999"
	refusals := domain.VerifyBedside(wrong, unit, issue,
		unit.ExpiresAt.Add(time.Hour))
	if len(refusals) < 3 {
		t.Errorf("refusals = %v; a nurse at a bedside should be told all of "+
			"them at once", refusals)
	}
}

// SRS-BLD-010, SRS-BLD-011. A failed bedside check blocks the start.
func TestAFailedBedsideCheckBlocksTheTransfusion(t *testing.T) {
	refusals := []domain.BedsideRefusal{domain.BedsideWrongPatient}
	if _, err := domain.StartTransfusion("ep-1", "tenant-1",
		domain.StartTransfusionInput{
			ComponentID: "unit-1", PatientID: "patient-2",
		}, refusals, "nurse-1", at); err == nil {
		t.Fatal("a transfusion started against a failed bedside check")
	} else if !strings.Contains(err.Error(), "not the patient") {
		t.Errorf("the refusal does not say what was wrong: %v", err)
	}

	episode, err := domain.StartTransfusion("ep-1", "tenant-1",
		domain.StartTransfusionInput{
			ComponentID: "unit-1", PatientID: "patient-1",
			Baseline: map[string]float64{"temperature": 36.8, "pulse": 88},
		}, nil, "nurse-1", at)
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	if len(episode.Observations) != 1 {
		t.Fatalf("baseline observations = %d, want 1", len(episode.Observations))
	}
	if episode.Observations[0].Timing != domain.TimingBaseline {
		t.Errorf("timing = %q, want baseline", episode.Observations[0].Timing)
	}
}

// SRS-BLD-011. The episode is longitudinally visible, and the protocol sets it
// has not had are named rather than blocking.
func TestATransfusionNamesTheObservationsItHasNotHad(t *testing.T) {
	episode, err := domain.StartTransfusion("ep-1", "tenant-1",
		domain.StartTransfusionInput{
			ComponentID: "unit-1", PatientID: "patient-1",
			Baseline: map[string]float64{"temperature": 36.8},
		}, nil, "nurse-1", at)
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}

	required := []string{domain.TimingBaseline, domain.TimingFifteen,
		domain.TimingCompletion}
	missing := episode.MissingObservations(required)
	if len(missing) != 2 {
		t.Errorf("missing = %v, want the fifteen-minute and completion sets",
			missing)
	}

	if _, err := episode.Observe("obs-2", domain.TimingFifteen,
		map[string]float64{"temperature": 37.1, "pulse": 92}, "",
		"nurse-1", at.Add(15*time.Minute)); err != nil {
		t.Fatalf("Observe: %v", err)
	}
	if _, err := episode.Observe("obs-3", domain.TimingFifteen, nil, "",
		"nurse-1", at.Add(16*time.Minute)); err == nil {
		t.Error("an observation with nothing measured was accepted")
	}

	if err := episode.Interrupt("cannula tissued", at.Add(20*time.Minute)); err != nil {
		t.Fatalf("Interrupt: %v", err)
	}
	if err := episode.Complete(280, at.Add(30*time.Minute)); err != nil {
		t.Fatalf("Complete from interrupted: %v", err)
	}
	if episode.VolumeGivenML != 280 {
		t.Errorf("volume = %d, want 280", episode.VolumeGivenML)
	}
	if _, err := episode.Observe("obs-4", domain.TimingCompletion,
		map[string]float64{"temperature": 37.0}, "", "nurse-1", at); err == nil {
		t.Error("an observation was recorded on an ended transfusion")
	}
}

// A stopped transfusion records why and how much was given, because those are
// the two numbers a haemovigilance report needs.
func TestAStoppedTransfusionRecordsWhyAndHowMuch(t *testing.T) {
	episode, err := domain.StartTransfusion("ep-1", "tenant-1",
		domain.StartTransfusionInput{ComponentID: "unit-1", PatientID: "patient-1"},
		nil, "nurse-1", at)
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	if err := episode.Stop("", 50, at.Add(10*time.Minute)); err == nil {
		t.Error("a transfusion was stopped with no reason")
	}
	if err := episode.Stop("suspected reaction", 50,
		at.Add(-time.Minute)); err == nil {
		t.Error("a transfusion ended before it started")
	}
	if err := episode.Stop("suspected reaction", 50,
		at.Add(10*time.Minute)); err != nil {
		t.Fatalf("Stop: %v", err)
	}
	if episode.Status != domain.EpisodeStopped || episode.VolumeGivenML != 50 {
		t.Errorf("episode = %+v", episode)
	}
}

// SRS-BLD-012. A reaction links the patient, the component and the
// investigation.
func TestAReactionNamesTheComponentSoTheSiblingsCanBeFound(t *testing.T) {
	if _, err := domain.ReportReaction("rx-1", "tenant-1",
		domain.NewReactionInput{
			PatientID: "patient-1", Severity: domain.ReactionSevere,
			Features: []string{"rigors"},
		}, "doctor-1", at); err == nil {
		t.Fatal("a reaction was reported against no component; the other " +
			"components from that donation could not be found")
	}
	if _, err := domain.ReportReaction("rx-1", "tenant-1",
		domain.NewReactionInput{
			PatientID: "patient-1", ComponentID: "unit-1",
			Severity: domain.ReactionSevere,
		}, "doctor-1", at); err == nil {
		t.Error("a reaction with nothing observed was accepted")
	}

	reaction, err := domain.ReportReaction("rx-1", "tenant-1",
		domain.NewReactionInput{
			EpisodeID: "ep-1", ComponentID: "unit-1", PatientID: "patient-1",
			Severity: domain.ReactionSevere,
			Features: []string{"Rigors", "fever", "rigors"},
		}, "doctor-1", at)
	if err != nil {
		t.Fatalf("ReportReaction: %v", err)
	}
	if len(reaction.Features) != 2 {
		t.Errorf("features = %v; the duplicate spelling was not folded",
			reaction.Features)
	}
	if reaction.State != domain.InvestigationOpen {
		t.Errorf("state = %q, want open", reaction.State)
	}

	if err := reaction.Conclude("", "nothing found", "scientist-1", at); err == nil {
		t.Error("an investigation concluded with no classification")
	}
	if err := reaction.Conclude("febrile_non_haemolytic",
		"no serological incompatibility", "scientist-1",
		at.Add(24*time.Hour)); err != nil {
		t.Fatalf("Conclude: %v", err)
	}
	if err := reaction.Conclude("other", "", "scientist-1", at); err == nil {
		t.Error("an investigation was concluded twice")
	}
}

// SRS-BLD-014. The chain renders from the records that exist and names the
// stages that have none.
func TestTheChainNamesItsGaps(t *testing.T) {
	unit := readyUnit(t, nil)
	chain := domain.BuildChain(unit, nil, nil, nil, nil, nil, nil, nil)

	if chain.UnitNumber != unit.UnitNumber {
		t.Errorf("unit number = %q", chain.UnitNumber)
	}
	gaps := strings.Join(chain.Gaps, ",")
	for _, want := range []string{domain.StageDonor, domain.StageCollection,
		domain.StageTesting} {
		if !strings.Contains(gaps, want) {
			t.Errorf("gap %q not named; gaps = %v", want, chain.Gaps)
		}
	}

	// A unit bought in has no donor row, which is not a gap.
	bought := readyUnit(t, func(in *domain.NewComponentInput) {
		in.DonorID, in.Source = "", "Regional Blood Centre"
	})
	boughtChain := domain.BuildChain(bought, nil, nil, nil, nil, nil, nil, nil)
	for _, gap := range boughtChain.Gaps {
		if gap == domain.StageDonor {
			t.Error("a unit received from a supplier was reported as missing " +
				"its donor")
		}
	}

	// The full chain, in the order blood travels.
	donor := domain.Donor{ID: "donor-1", DonorNumber: "D0001",
		RegisteredAt: at.Add(-72 * time.Hour), RegisteredBy: "clerk-1"}
	collection := domain.Collection{ID: "coll-1", DonationNumber: "D24-001",
		CollectedAt: at.Add(-48 * time.Hour), CollectedBy: "nurse-1"}
	full := domain.BuildChain(unit, &donor, &collection,
		[]domain.TestResult{{ID: "t-1", Code: "hiv",
			TestedAt: at.Add(-36 * time.Hour), TestedBy: "scientist-1"}},
		nil,
		[]domain.Issue{{ID: "i-1", Destination: "ward 7",
			IssuedAt: at.Add(time.Hour), IssuedBy: "scientist-1"}},
		[]domain.Episode{{ID: "ep-1", PatientID: "patient-1",
			StartedAt: at.Add(2 * time.Hour), StartedBy: "nurse-2"}},
		nil)
	if len(full.Gaps) != 0 {
		t.Errorf("a complete chain reported gaps: %v", full.Gaps)
	}
	for i := 1; i < len(full.Links); i++ {
		if full.Links[i].At.Before(full.Links[i-1].At) {
			t.Fatalf("the chain is out of order at %d: %+v", i, full.Links)
		}
	}
}

// SRS-BLD-005, SRS-BLD-017. Stock counts what could actually be issued, and
// alerts only where somebody has set a threshold.
func TestStockCountsWhatCouldActuallyBeIssued(t *testing.T) {
	oNeg := group(domain.ABOO, domain.RhNegative)
	units := []domain.Component{
		{Class: domain.ClassRedCells, Group: oNeg, Status: domain.UnitAvailable,
			ExpiresAt: at.Add(30 * 24 * time.Hour)},
		{Class: domain.ClassRedCells, Group: oNeg, Status: domain.UnitAvailable,
			ExpiresAt: at.Add(24 * time.Hour)},
		{Class: domain.ClassRedCells, Group: oNeg, Status: domain.UnitQuarantined,
			ExpiresAt: at.Add(30 * 24 * time.Hour)},
		{Class: domain.ClassRedCells, Group: oNeg, Status: domain.UnitReserved,
			ExpiresAt: at.Add(30 * 24 * time.Hour)},
		{Class: domain.ClassRedCells, Group: oNeg, Status: domain.UnitAvailable,
			ExpiresAt: at.Add(-time.Hour)},
	}

	levels := domain.SummariseStock(units, 0, at)
	if len(levels) != 1 {
		t.Fatalf("levels = %d, want 1", len(levels))
	}
	level := levels[0]
	if level.Available != 2 {
		t.Errorf("available = %d, want 2; a quarantined, a reserved and an "+
			"expired unit are not blood anybody can give", level.Available)
	}
	if level.ExpiringSoon != 1 {
		t.Errorf("expiring soon = %d, want 1", level.ExpiringSoon)
	}
	if level.Quarantined != 1 || level.Reserved != 1 {
		t.Errorf("quarantined/reserved = %d/%d, want 1/1",
			level.Quarantined, level.Reserved)
	}

	// No threshold configured: expiry alerts only.
	alerts := domain.StockAlerts(levels, nil, 0)
	for _, alert := range alerts {
		if alert.Kind == domain.AlertLowStock {
			t.Error("a low-stock alert was raised for a bucket nobody configured")
		}
	}
	if len(alerts) != 1 || alerts[0].Kind != domain.AlertExpiring {
		t.Errorf("alerts = %+v, want one expiry alert", alerts)
	}

	withThreshold := domain.StockAlerts(levels, []domain.StockThreshold{
		{Class: domain.ClassRedCells, Group: oNeg, Minimum: 6},
	}, 0)
	var low *domain.StockAlert
	for i := range withThreshold {
		if withThreshold[i].Kind == domain.AlertLowStock {
			low = &withThreshold[i]
		}
	}
	if low == nil {
		t.Fatal("no low-stock alert below the configured minimum")
	}
	if low.Available != 2 || low.Minimum != 6 {
		t.Errorf("alert = %+v, want 2 available against a minimum of 6", low)
	}
	if !strings.Contains(low.Message, "O-") {
		t.Errorf("the alert does not name the group: %q", low.Message)
	}
}

// SRS-BLD-015. The report derives from the records, and a running transfusion
// is not yet a transfusion.
func TestUtilisationDerivesFromTheRecords(t *testing.T) {
	issues := []domain.Issue{
		{ID: "i-1", ComponentID: "u-1"},
		{ID: "i-2", ComponentID: "u-2"},
		{ID: "i-3", ComponentID: "u-3", Emergency: true},
		{ID: "i-4", ComponentID: "u-4", Emergency: true, Reconciled: true},
	}
	episodes := []domain.Episode{
		{ID: "e-1", ComponentID: "u-1", Status: domain.EpisodeCompleted},
		{ID: "e-2", ComponentID: "u-3", Status: domain.EpisodeStopped},
		// Still running: not yet given, and counting it would make the report
		// disagree with itself an hour later.
		{ID: "e-3", ComponentID: "u-2", Status: domain.EpisodeRunning},
	}
	reservations := []domain.Reservation{{ID: "r-1"}, {ID: "r-2"},
		{ID: "r-3"}, {ID: "r-4"}}
	indications := map[string]string{"u-1": "anaemia", "u-3": "haemorrhage"}

	report := domain.SummariseUtilisation(issues, episodes, nil,
		reservations, indications, 2)

	if report.Issued != 4 {
		t.Errorf("issued = %d, want 4", report.Issued)
	}
	if report.Transfused != 2 {
		t.Errorf("transfused = %d, want 2; a running transfusion is not one "+
			"that has happened", report.Transfused)
	}
	if report.Returned != 2 {
		t.Errorf("returned = %d, want 2 (u-2 still running, u-4 never started)",
			report.Returned)
	}
	if report.EmergencyReleases != 2 || report.UnreconciledReleases != 1 {
		t.Errorf("emergency = %d, unreconciled = %d, want 2 and 1",
			report.EmergencyReleases, report.UnreconciledReleases)
	}
	if report.CrossmatchToTransfusion != 2 {
		t.Errorf("C:T = %v, want 2", report.CrossmatchToTransfusion)
	}
	if report.ByIndication["anaemia"] != 1 || report.ByIndication["haemorrhage"] != 1 {
		t.Errorf("by indication = %v", report.ByIndication)
	}
	if report.Discarded != 2 {
		t.Errorf("discarded = %d, want 2", report.Discarded)
	}
}

// No transfusions gives a zero ratio rather than an infinity, and the
// reservation count is carried so a reader can see why.
func TestTheCrossmatchRatioIsZeroRatherThanInfiniteWithNoTransfusions(t *testing.T) {
	report := domain.SummariseUtilisation(nil, nil, nil,
		[]domain.Reservation{{ID: "r-1"}, {ID: "r-2"}}, nil, 0)
	if report.CrossmatchToTransfusion != 0 {
		t.Errorf("C:T = %v, want 0", report.CrossmatchToTransfusion)
	}
	if report.Reservations != 2 {
		t.Errorf("reservations = %d, want 2", report.Reservations)
	}
}

// SRS-BLD-013. A transfused unit is not returned, discarded or quarantined:
// the blood is in the patient, and a status saying otherwise would make every
// look-back report wrong.
func TestATransfusedUnitCannotBeUnwound(t *testing.T) {
	unit := readyUnit(t, nil)
	unit.Status = domain.UnitTransfused

	if err := unit.Discard(domain.DiscardExpired); err == nil {
		t.Error("a transfused unit was discarded")
	}
	if err := unit.Quarantine(); err == nil {
		t.Error("a transfused unit was quarantined")
	}

	available := readyUnit(t, nil)
	if err := available.Discard("melted"); err == nil {
		t.Error("an uncoded discard reason was accepted")
	}
	if err := available.Discard(domain.DiscardBreach); err != nil {
		t.Fatalf("Discard: %v", err)
	}
	if available.Status != domain.UnitDiscarded {
		t.Errorf("status = %q, want discarded", available.Status)
	}
	if available.Issuable(at) {
		t.Error("a discarded unit is issuable")
	}
}
