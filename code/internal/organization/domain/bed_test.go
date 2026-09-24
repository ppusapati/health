package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
)

var bedNow = time.Date(2026, 9, 24, 9, 0, 0, 0, time.UTC)

func bedClass(t *testing.T) domain.BedClass {
	t.Helper()
	c, err := domain.NewBedClass("class-1", "tenant-a", domain.NewBedClassInput{
		Code: "SEMI", DisplayName: "Semi-private", ChargeCode: "ACC-SEMI-DAY",
	}, bedNow)
	if err != nil {
		t.Fatalf("NewBedClass: %v", err)
	}
	return c
}

func room(t *testing.T) domain.Room {
	t.Helper()
	r, err := domain.NewRoom("room-1", "tenant-a", domain.NewRoomInput{
		FacilityID: "fac-1", UnitID: "unit-1", Code: "W7-101",
		DisplayName: "Ward 7 Room 101", ClassCode: "SEMI",
		GenderPolicy: domain.GenderFemale, Isolation: domain.IsolationDroplet,
	}, bedNow)
	if err != nil {
		t.Fatalf("NewRoom: %v", err)
	}
	return r
}

func bed(t *testing.T) domain.Bed {
	t.Helper()
	b, err := domain.NewBed("bed-1", "tenant-a", domain.NewBedInput{
		RoomID: "room-1", FacilityID: "fac-1", Code: "W7-101-A",
	}, bedNow)
	if err != nil {
		t.Fatalf("NewBed: %v", err)
	}
	return b
}

// SRS-PLT-006's charge mapping: a class that names no charge describes an
// accommodation nobody can bill for.
func TestAnAccommodationClassNamesItsCharge(t *testing.T) {
	_, err := domain.NewBedClass("class-1", "tenant-a", domain.NewBedClassInput{
		Code: "SEMI", DisplayName: "Semi-private",
	}, bedNow)
	if err == nil {
		t.Fatal("a class with no charge code was accepted; every stay in it " +
			"would be free")
	}
	if !strings.Contains(err.Error(), "charge") {
		t.Errorf("the refusal does not say what is missing: %v", err)
	}

	if got := bedClass(t).ChargeCode; got != "ACC-SEMI-DAY" {
		t.Errorf("charge code = %q", got)
	}
}

// SRS-PLT-007 again, on this master: the code is the key and the display name
// is a label.
func TestAClassCodeIsNormalisedAndTheNameIsNot(t *testing.T) {
	c, err := domain.NewBedClass("class-1", "tenant-a", domain.NewBedClassInput{
		Code: " semi ", DisplayName: "Semi-private", ChargeCode: "ACC-SEMI-DAY",
	}, bedNow)
	if err != nil {
		t.Fatalf("NewBedClass: %v", err)
	}
	if c.Code != "SEMI" {
		t.Errorf("code = %q, want SEMI", c.Code)
	}
	if c.DisplayName != "Semi-private" {
		t.Errorf("display name = %q; the label was altered", c.DisplayName)
	}

	if _, err := domain.NewBedClass("class-1", "tenant-a",
		domain.NewBedClassInput{
			Code: "semi private", DisplayName: "Semi", ChargeCode: "ACC",
		}, bedNow); err == nil {
		t.Error("a class code with a space was accepted; it appears in tariff " +
			"imports and on printed estimates")
	}
}

// SRS-PLT-002: a room sits between a ward and its beds. Without the ward, no
// ward can list what it is responsible for.
func TestARoomBelongsToAFacilityAndAWard(t *testing.T) {
	for _, missing := range []struct {
		what string
		in   domain.NewRoomInput
	}{
		{"facility", domain.NewRoomInput{UnitID: "unit-1", Code: "R1", ClassCode: "SEMI"}},
		{"ward", domain.NewRoomInput{FacilityID: "fac-1", Code: "R1", ClassCode: "SEMI"}},
		{"class", domain.NewRoomInput{FacilityID: "fac-1", UnitID: "unit-1", Code: "R1"}},
	} {
		if _, err := domain.NewRoom("room-1", "tenant-a", missing.in,
			bedNow); err == nil {
			t.Errorf("a room with no %s was accepted", missing.what)
		}
	}
}

// SRS-PLT-006: gender policy and isolation capability are properties of the
// room, and an unknown value for either is refused rather than stored.
func TestARoomsCapabilitiesAreKnownOnes(t *testing.T) {
	if _, err := domain.NewRoom("room-1", "tenant-a", domain.NewRoomInput{
		FacilityID: "fac-1", UnitID: "unit-1", Code: "R1", ClassCode: "SEMI",
		GenderPolicy: "mixed-ish",
	}, bedNow); err == nil {
		t.Error("a room with an invented gender policy was accepted")
	}
	if _, err := domain.NewRoom("room-1", "tenant-a", domain.NewRoomInput{
		FacilityID: "fac-1", UnitID: "unit-1", Code: "R1", ClassCode: "SEMI",
		Isolation: "reverse-barrier",
	}, bedNow); err == nil {
		t.Error("a room with an invented isolation capability was accepted")
	}

	// Defaults are the permissive-to-nobody ones: any gender, no isolation.
	r, err := domain.NewRoom("room-1", "tenant-a", domain.NewRoomInput{
		FacilityID: "fac-1", UnitID: "unit-1", Code: "R1", ClassCode: "SEMI",
	}, bedNow)
	if err != nil {
		t.Fatalf("NewRoom: %v", err)
	}
	if r.GenderPolicy != domain.GenderAny || r.Isolation != domain.IsolationNone {
		t.Errorf("defaults = %q/%q", r.GenderPolicy, r.Isolation)
	}
}

// Isolation capability is ordered: infection control asks where a case can go,
// and a room that can hold an airborne case can hold a droplet one.
func TestIsolationCapabilityContainsLesserPrecautions(t *testing.T) {
	airborne := domain.IsolationAirborne
	for _, needed := range []domain.IsolationCapability{
		domain.IsolationNone, domain.IsolationContact,
		domain.IsolationDroplet, domain.IsolationAirborne,
	} {
		if !airborne.Contains(needed) {
			t.Errorf("an airborne room cannot hold a %s case", needed)
		}
	}

	if room(t).Isolation.Contains(domain.IsolationAirborne) {
		t.Error("a droplet room reported itself able to hold an airborne case")
	}
	if !room(t).Isolation.Contains(domain.IsolationContact) {
		t.Error("a droplet room cannot hold a contact case")
	}
}

// SRS-PLT-006's verification clause: bed status is controlled independently of
// physical existence. This is the test that says what that means.
func TestABedsAvailabilityIsSeparateFromItsExistence(t *testing.T) {
	b := bed(t)
	if !b.Usable() {
		t.Fatal("a new bed is not usable")
	}

	// Out of service: the bed still exists, still belongs to its room, and is
	// not usable. Losing the first two is the failure this separation exists
	// to prevent.
	if err := b.SetAvailability(domain.BedOutOfService,
		"castor broken, maintenance raised", bedNow); err != nil {
		t.Fatalf("SetAvailability: %v", err)
	}
	if b.Status != domain.MasterActive {
		t.Error("taking a bed out of service removed it from the estate")
	}
	if b.RoomID != "room-1" {
		t.Error("taking a bed out of service detached it from its room")
	}
	if b.Usable() {
		t.Error("a bed out of service reported itself usable")
	}

	// And back, with the reason cleared: a bed that is available for no
	// reason should not still carry why it once was not.
	if err := b.SetAvailability(domain.BedAvailable, "", bedNow); err != nil {
		t.Fatalf("SetAvailability back: %v", err)
	}
	if !b.Usable() || b.UnavailableReason != "" {
		t.Errorf("bed = %+v; the stale reason survived", b)
	}
}

// Blocking and taking out of service are decisions, so they record why.
// Occupancy and cleaning are recorded by the systems that cause them.
func TestTakingABedOutOfUseRecordsWhy(t *testing.T) {
	for _, state := range []domain.BedAvailability{
		domain.BedBlocked, domain.BedOutOfService,
	} {
		b := bed(t)
		if err := b.SetAvailability(state, "   ", bedNow); err == nil {
			t.Errorf("a bed was moved to %s with no reason", state)
		}
	}

	b := bed(t)
	if err := b.SetAvailability(domain.BedOccupied, "", bedNow); err != nil {
		t.Errorf("occupancy needed a typed reason: %v", err)
	}
	if err := b.SetAvailability(domain.BedCleaning, "", bedNow); err != nil {
		t.Errorf("cleaning needed a typed reason: %v", err)
	}

	if err := b.SetAvailability("under-repair-ish", "typo", bedNow); err == nil {
		t.Error("an invented bed status was accepted")
	}
}

// SRS-PLT-015: retirement is terminal and deletion does not exist. A retired
// bed has no availability, because reporting one would put it back into the
// count the ward admits against.
func TestARetiredBedLeavesTheEstateAndStays(t *testing.T) {
	b := bed(t)
	if err := b.Retire(bedNow); err != nil {
		t.Fatalf("Retire: %v", err)
	}
	if b.Usable() {
		t.Error("a retired bed reported itself usable")
	}
	if err := b.Retire(bedNow); err == nil {
		t.Error("a bed was retired twice")
	}
	if err := b.SetAvailability(domain.BedAvailable, "", bedNow); err == nil {
		t.Error("a retired bed was made available again; the ward would admit " +
			"into a bed the hospital no longer has")
	}

	// Usable checks both halves rather than trusting that retirement left the
	// availability consistent. Nothing in this package can produce the pair
	// below — Retire sets the availability and SetAvailability refuses on a
	// retired bed — but a row can, and a row is what the repository hands
	// back. This is the state a bad backfill or a direct write leaves behind,
	// and the ward must not be told the bed is free.
	fromARow := domain.Bed{
		ID: "bed-9", TenantID: "tenant-a", RoomID: "room-1",
		Status: domain.MasterRetired, Availability: domain.BedAvailable,
	}
	if fromARow.Usable() {
		t.Error("a retired bed with a stale availability reported itself usable")
	}
}

// The other direction of the same separation: a bed with a patient in it is
// not one the hospital can stop having.
func TestAnOccupiedBedCannotBeRetired(t *testing.T) {
	b := bed(t)
	if err := b.SetAvailability(domain.BedOccupied, "", bedNow); err != nil {
		t.Fatalf("SetAvailability: %v", err)
	}
	if err := b.Retire(bedNow); err == nil {
		t.Fatal("a bed was retired with a patient in it")
	}

	// Discharged, cleaned, then retired: the same bed, once it is empty.
	if err := b.SetAvailability(domain.BedCleaning, "", bedNow); err != nil {
		t.Fatalf("SetAvailability: %v", err)
	}
	if err := b.Retire(bedNow); err != nil {
		t.Fatalf("Retire after the patient left: %v", err)
	}
}

// A bed belongs somewhere. An unrooted bed is one no ward can find and no
// charge can be raised for.
func TestABedBelongsToARoomAndAFacility(t *testing.T) {
	for _, missing := range []struct {
		what string
		in   domain.NewBedInput
	}{
		{"room", domain.NewBedInput{FacilityID: "fac-1", Code: "B1"}},
		{"facility", domain.NewBedInput{RoomID: "room-1", Code: "B1"}},
		{"code", domain.NewBedInput{RoomID: "room-1", FacilityID: "fac-1"}},
	} {
		if _, err := domain.NewBed("bed-1", "tenant-a", missing.in,
			bedNow); err == nil {
			t.Errorf("a bed with no %s was accepted", missing.what)
		}
	}

	// The display name falls back to the code rather than being empty: a bed
	// with no name on a board is a bed nobody can point at.
	if got := bed(t).DisplayName; got != "W7-101-A" {
		t.Errorf("display name = %q, want the code", got)
	}
}
