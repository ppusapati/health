package postgres_test

import (
	"context"
	"testing"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
)

// The bed and room master (SRS-PLT-006).

// seedEstate builds one facility, one ward, one class, one room and one bed,
// and returns their ids. Every test here needs the whole chain, because a bed
// with no room and no class is not a row this schema will accept.
type estate struct {
	facilityID, unitID, classCode, roomID, bedID string
}

func (f mdFixture) seedEstate(t *testing.T) estate {
	t.Helper()
	ctx := context.Background()

	facility, err := domain.NewFacility(uuid.NewString(), f.tenantID, "MAIN",
		"Main Hospital", domain.FacilityHospital, "Asia/Kolkata", at)
	if err != nil {
		t.Fatalf("NewFacility: %v", err)
	}
	if err := f.fac.Insert(ctx, f.scope, facility); err != nil {
		t.Fatalf("insert facility: %v", err)
	}

	unit, err := domain.NewOrgUnit(uuid.NewString(), f.tenantID, facility.ID,
		domain.UnitCareLocation, "W7", "Ward 7", "", at, at.AddDate(10, 0, 0),
		false, at)
	if err != nil {
		t.Fatalf("NewOrgUnit: %v", err)
	}
	if err := f.repo.InsertOrgUnit(ctx, f.scope, unit); err != nil {
		t.Fatalf("insert unit: %v", err)
	}

	class, err := domain.NewBedClass(uuid.NewString(), f.tenantID,
		domain.NewBedClassInput{
			Code: "SEMI", DisplayName: "Semi-private",
			ChargeCode: "ACC-SEMI-DAY",
		}, at)
	if err != nil {
		t.Fatalf("NewBedClass: %v", err)
	}
	if err := f.repo.InsertClass(ctx, f.scope, class); err != nil {
		t.Fatalf("InsertClass: %v", err)
	}

	room, err := domain.NewRoom(uuid.NewString(), f.tenantID, domain.NewRoomInput{
		FacilityID: facility.ID, UnitID: unit.ID, Code: "W7-101",
		DisplayName: "Ward 7 Room 101", ClassCode: class.Code,
		GenderPolicy: domain.GenderFemale, Isolation: domain.IsolationDroplet,
	}, at)
	if err != nil {
		t.Fatalf("NewRoom: %v", err)
	}
	if err := f.repo.InsertRoom(ctx, f.scope, room); err != nil {
		t.Fatalf("InsertRoom: %v", err)
	}

	bed, err := domain.NewBed(uuid.NewString(), f.tenantID, domain.NewBedInput{
		RoomID: room.ID, FacilityID: facility.ID, Code: "W7-101-A",
	}, at)
	if err != nil {
		t.Fatalf("NewBed: %v", err)
	}
	if err := f.repo.InsertBed(ctx, f.scope, bed); err != nil {
		t.Fatalf("InsertBed: %v", err)
	}

	return estate{
		facilityID: facility.ID, unitID: unit.ID, classCode: class.Code,
		roomID: room.ID, bedID: bed.ID,
	}
}

// SRS-PLT-006: the master round-trips, and the class a bed is charged at
// comes from its room rather than from the bed.
func TestTheBedMasterRoundTrips(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()
	e := f.seedEstate(t)

	bed, err := f.repo.Bed(ctx, f.scope, e.bedID)
	if err != nil {
		t.Fatalf("Bed: %v", err)
	}
	if bed.Code != "W7-101-A" || bed.RoomID != e.roomID {
		t.Errorf("bed = %+v", bed)
	}
	if !bed.Usable() {
		t.Error("a newly built bed is not usable")
	}

	room, err := f.repo.Room(ctx, f.scope, e.roomID)
	if err != nil {
		t.Fatalf("Room: %v", err)
	}
	if room.GenderPolicy != domain.GenderFemale ||
		room.Isolation != domain.IsolationDroplet {
		t.Errorf("room capabilities did not survive the round trip: %+v", room)
	}

	class, err := f.repo.ClassByCode(ctx, f.scope, e.classCode)
	if err != nil {
		t.Fatalf("ClassByCode: %v", err)
	}
	if class.ChargeCode != "ACC-SEMI-DAY" {
		t.Errorf("charge code = %q", class.ChargeCode)
	}

	classes, err := f.repo.ListClasses(ctx, f.scope)
	if err != nil {
		t.Fatalf("ListClasses: %v", err)
	}
	if len(classes) != 1 {
		t.Errorf("%d classes, want 1", len(classes))
	}
}

// SRS-PLT-006's verification clause, over a real database: taking a bed out of
// service leaves it in the estate, and retiring it does not.
func TestBedAvailabilityAndExistenceMoveSeparatelyInTheDatabase(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()
	e := f.seedEstate(t)

	bed, err := f.repo.Bed(ctx, f.scope, e.bedID)
	if err != nil {
		t.Fatalf("Bed: %v", err)
	}
	before := bed.Version
	if err := bed.SetAvailability(domain.BedOutOfService,
		"castor broken", at); err != nil {
		t.Fatalf("SetAvailability: %v", err)
	}
	if err := f.repo.UpdateBedState(ctx, f.scope, bed, before); err != nil {
		t.Fatalf("UpdateBedState: %v", err)
	}

	reread, err := f.repo.Bed(ctx, f.scope, e.bedID)
	if err != nil {
		t.Fatalf("Bed: %v", err)
	}
	if reread.Status != domain.MasterActive {
		t.Error("a bed out of service left the estate")
	}
	if reread.Usable() || reread.UnavailableReason != "castor broken" {
		t.Errorf("bed = %+v", reread)
	}
	if reread.Version != before+1 {
		t.Errorf("version = %d, want %d", reread.Version, before+1)
	}

	// A stale version loses, so two people taking the same bed out of service
	// for different reasons cannot both believe they won.
	if err := f.repo.UpdateBedState(ctx, f.scope, reread, before); err == nil {
		t.Error("a stale write was accepted")
	}
}

// The board is one read. A ward looking at it sees each bed once, with the
// room it is in and the class it is charged at.
func TestTheBedBoardCarriesTheRoomAndTheCharge(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()
	e := f.seedEstate(t)

	board, err := f.repo.Board(ctx, f.scope, ports.BedBoardFilter{
		FacilityID: e.facilityID, PageSize: 50,
	})
	if err != nil {
		t.Fatalf("Board: %v", err)
	}
	if len(board) != 1 {
		t.Fatalf("%d beds on the board, want 1", len(board))
	}
	place := board[0]
	if place.Class.ChargeCode != "ACC-SEMI-DAY" {
		t.Errorf("the board does not carry the charge: %+v", place.Class)
	}
	if place.Room.Isolation != domain.IsolationDroplet {
		t.Errorf("the board does not carry what the room can take: %+v", place.Room)
	}

	// Filtered to the ward the room is in, and to one it is not.
	same, err := f.repo.Board(ctx, f.scope, ports.BedBoardFilter{
		FacilityID: e.facilityID, UnitID: e.unitID, PageSize: 50,
	})
	if err != nil {
		t.Fatalf("Board by unit: %v", err)
	}
	if len(same) != 1 {
		t.Errorf("%d beds in the ward, want 1; the filter never matched",
			len(same))
	}
	other, err := f.repo.Board(ctx, f.scope, ports.BedBoardFilter{
		FacilityID: e.facilityID, UnitID: uuid.NewString(), PageSize: 50,
	})
	if err != nil {
		t.Fatalf("Board by another unit: %v", err)
	}
	if len(other) != 0 {
		t.Errorf("%d beds in a ward that has none", len(other))
	}

	// A retired bed is off the board: a ward that could see it would count it.
	bed, err := f.repo.Bed(ctx, f.scope, e.bedID)
	if err != nil {
		t.Fatalf("Bed: %v", err)
	}
	version := bed.Version
	if err := bed.Retire(at); err != nil {
		t.Fatalf("Retire: %v", err)
	}
	if err := f.repo.UpdateBedState(ctx, f.scope, bed, version); err != nil {
		t.Fatalf("UpdateBedState: %v", err)
	}
	after, err := f.repo.Board(ctx, f.scope, ports.BedBoardFilter{
		FacilityID: e.facilityID, PageSize: 50,
	})
	if err != nil {
		t.Fatalf("Board: %v", err)
	}
	if len(after) != 0 {
		t.Errorf("%d beds on the board after the only one was retired",
			len(after))
	}
}

// The master is tenant-scoped like everything else here.
func TestTheBedMasterIsTenantScoped(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()
	e := f.seedEstate(t)

	if _, err := f.repo.Bed(ctx, otherTenantScope(), e.bedID); err == nil {
		t.Error("another tenant read a bed")
	}
	if _, err := f.repo.Room(ctx, otherTenantScope(), e.roomID); err == nil {
		t.Error("another tenant read a room")
	}
	if _, err := f.repo.ClassByCode(ctx, otherTenantScope(), e.classCode); err == nil {
		t.Error("another tenant read an accommodation class")
	}
}

// SRS-PLT-007 on this master: codes are unique within a tenant.
func TestTwoBedsCannotShareACode(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()
	e := f.seedEstate(t)

	second, err := domain.NewBed(uuid.NewString(), f.tenantID, domain.NewBedInput{
		RoomID: e.roomID, FacilityID: e.facilityID, Code: "W7-101-A",
	}, at)
	if err != nil {
		t.Fatalf("NewBed: %v", err)
	}
	if err := f.repo.InsertBed(ctx, f.scope, second); err == nil {
		t.Fatal("two beds share a code; a scan would reach either of them")
	}
}

// The constraints below are asserted with raw SQL, because the point of each
// is that it holds against a write that did not come through the domain.
func TestTheDatabaseHoldsTheBedMastersRules(t *testing.T) {
	f := newMasterDataFixture(t)
	ctx := context.Background()
	e := f.seedEstate(t)

	// A class that maps to no charge is a stay nobody can bill.
	if _, err := f.pool.Exec(ctx, `
		INSERT INTO organization.bed_class (
		    class_id, tenant_id, code, display_name, charge_code, status,
		    created_at, updated_at, version)
		VALUES ($1, $2, 'DELUXE', 'Deluxe', '', 'active', now(), now(), 1)`,
		uuid.New(), f.tenantID); err == nil {
		t.Error("a class was recorded with no charge code")
	}

	// A bed blocked for no stated reason.
	if _, err := f.pool.Exec(ctx, `
		INSERT INTO organization.bed (
		    bed_id, tenant_id, room_id, facility_id, code, display_name,
		    status, availability, unavailable_reason,
		    created_at, updated_at, version)
		VALUES ($1, $2, $3, $4, 'W7-101-Z', 'Bed Z', 'active', 'blocked', '',
		        now(), now(), 1)`,
		uuid.New(), f.tenantID, e.roomID, e.facilityID); err == nil {
		t.Error("a bed was blocked with no reason; nobody can review it")
	}

	// A retired bed that still reads as available.
	if _, err := f.pool.Exec(ctx, `
		UPDATE organization.bed
		SET status = 'retired', availability = 'available'
		WHERE bed_id = $1`, e.bedID); err == nil {
		t.Error("a retired bed was left available; the ward would admit into " +
			"a bed the hospital no longer has")
	}

	// A bed in a different facility from its room.
	otherFacility, err := domain.NewFacility(uuid.NewString(), f.tenantID,
		"ANNEX", "Annex", domain.FacilityHospital, "Asia/Kolkata", at)
	if err != nil {
		t.Fatalf("NewFacility: %v", err)
	}
	if err := f.fac.Insert(ctx, f.scope, otherFacility); err != nil {
		t.Fatalf("insert facility: %v", err)
	}
	if _, err := f.pool.Exec(ctx, `
		INSERT INTO organization.bed (
		    bed_id, tenant_id, room_id, facility_id, code, display_name,
		    status, availability, unavailable_reason,
		    created_at, updated_at, version)
		VALUES ($1, $2, $3, $4, 'ANNEX-1', 'Bed', 'active', 'available', '',
		        now(), now(), 1)`,
		uuid.New(), f.tenantID, e.roomID, otherFacility.ID); err == nil {
		t.Error("a bed was put in a different facility from its own room")
	}

	// A room classed as something its tenant does not have.
	if _, err := f.pool.Exec(ctx, `
		INSERT INTO organization.room (
		    room_id, tenant_id, facility_id, unit_id, code, display_name,
		    class_code, gender_policy, isolation, status,
		    created_at, updated_at, version)
		VALUES ($1, $2, $3, $4, 'W7-102', 'Room 102', 'NO-SUCH-CLASS',
		        'any', 'none', 'active', now(), now(), 1)`,
		uuid.New(), f.tenantID, e.facilityID, e.unitID); err == nil {
		t.Error("a room was classed as an accommodation that does not exist")
	}
}
