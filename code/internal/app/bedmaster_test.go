package app_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// The bed and room master, end to end (SRS-PLT-006).

func nurseTokenFor(tenantID string) string {
	return tenantID + ":nurse-" + tenantID[:8] + ":nurse"
}

// estate is a commissioned ward: a facility, a class, a room and a bed.
type wardEstate struct {
	tenantID, adminToken, nurseToken  string
	facilityID, unitID, roomID, bedID string
	bedVersion                        int64
}

func commissionWard(t *testing.T, h *harness) wardEstate {
	t.Helper()
	ctx := context.Background()

	tenantID := h.provisionTenant(t, "Apollo Group")
	admin := tenantAdminToken(tenantID)

	facility, err := h.org.CreateFacility(ctx,
		as(admin, &organizationv1.CreateFacilityRequest{
			Code: "MAIN", DisplayName: "Main Hospital",
			Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	facilityID := facility.Msg.GetFacility().GetFacilityId()

	if _, err := h.org.DefineBedClass(ctx,
		as(admin, &organizationv1.DefineBedClassRequest{
			Code: "SEMI", DisplayName: "Semi-private",
			ChargeCode: "ACC-SEMI-DAY",
		})); err != nil {
		t.Fatalf("DefineBedClass: %v", err)
	}

	ward, err := h.org.CommissionOrgUnit(ctx,
		as(admin, &organizationv1.CommissionOrgUnitRequest{
			FacilityId: facilityID, UnitType: "care_location",
			Code: "W7", DisplayName: "Ward 7",
			EffectiveFrom: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
		}))
	if err != nil {
		t.Fatalf("CommissionOrgUnit: %v", err)
	}
	unitID := ward.Msg.GetUnitId()

	room, err := h.org.CommissionRoom(ctx,
		as(admin, &organizationv1.CommissionRoomRequest{
			FacilityId: facilityID, UnitId: unitID,
			Code: "W7-101", DisplayName: "Ward 7 Room 101",
			ClassCode:    "SEMI",
			GenderPolicy: organizationv1.GenderPolicy_GENDER_POLICY_FEMALE_ONLY,
			Isolation:    organizationv1.IsolationCapability_ISOLATION_CAPABILITY_DROPLET,
		}))
	if err != nil {
		t.Fatalf("CommissionRoom: %v", err)
	}

	bed, err := h.org.CommissionBed(ctx,
		as(admin, &organizationv1.CommissionBedRequest{
			RoomId: room.Msg.GetRoom().GetRoomId(), Code: "W7-101-A",
		}))
	if err != nil {
		t.Fatalf("CommissionBed: %v", err)
	}

	return wardEstate{
		tenantID: tenantID, adminToken: admin,
		nurseToken: nurseTokenFor(tenantID),
		facilityID: facilityID, unitID: unitID,
		roomID:     room.Msg.GetRoom().GetRoomId(),
		bedID:      bed.Msg.GetBed().GetBedId(),
		bedVersion: bed.Msg.GetBed().GetVersion(),
	}
}

// SRS-PLT-006's verification clause, over the whole stack: bed status is
// controlled independently of physical existence.
//
// The failure this prevents is a hospital that loses a bed permanently because
// somebody took it out of service to fix a castor.
func TestABedGoesOutOfServiceWithoutLeavingTheEstate(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	e := commissionWard(t, h)

	blocked, err := h.org.SetBedAvailability(ctx,
		as(e.nurseToken, &organizationv1.SetBedAvailabilityRequest{
			BedId:           e.bedID,
			Availability:    organizationv1.BedAvailability_BED_AVAILABILITY_OUT_OF_SERVICE,
			Reason:          "castor broken, maintenance raised",
			ExpectedVersion: e.bedVersion,
		}))
	if err != nil {
		t.Fatalf("SetBedAvailability: %v", err)
	}
	bed := blocked.Msg.GetBed()
	if bed.GetStatus() != "active" {
		t.Errorf("status = %q; the bed left the estate when it went out of "+
			"service", bed.GetStatus())
	}
	if bed.GetUsable() {
		t.Error("a bed out of service reported itself usable")
	}
	if bed.GetRoomId() != e.roomID {
		t.Error("the bed was detached from its room")
	}

	// Off the board while it is out of service, and the board still knows the
	// bed exists in a room somebody can find.
	board, err := h.org.BedBoard(ctx,
		as(e.nurseToken, &organizationv1.BedBoardRequest{
			FacilityId: e.facilityID,
		}))
	if err != nil {
		t.Fatalf("BedBoard: %v", err)
	}
	if len(board.Msg.GetPlaces()) != 1 {
		t.Fatalf("%d beds on the board, want the one that still exists",
			len(board.Msg.GetPlaces()))
	}
	if board.Msg.GetPlaces()[0].GetBed().GetUsable() {
		t.Error("the board shows an out-of-service bed as usable")
	}

	// And back into use.
	back, err := h.org.SetBedAvailability(ctx,
		as(e.nurseToken, &organizationv1.SetBedAvailabilityRequest{
			BedId:           e.bedID,
			Availability:    organizationv1.BedAvailability_BED_AVAILABILITY_AVAILABLE,
			ExpectedVersion: bed.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("SetBedAvailability back: %v", err)
	}
	if !back.Msg.GetBed().GetUsable() ||
		back.Msg.GetBed().GetUnavailableReason() != "" {
		t.Errorf("bed = %+v; the stale reason survived", back.Msg.GetBed())
	}
}

// The board carries what a ward actually needs: the room, what it can take,
// and what the bed is charged at (SRS-PLT-006's charge mapping).
func TestTheBedBoardCarriesTheChargeAndTheRoomsCapabilities(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	e := commissionWard(t, h)

	board, err := h.org.BedBoard(ctx,
		as(e.nurseToken, &organizationv1.BedBoardRequest{
			FacilityId: e.facilityID, UnitId: e.unitID,
		}))
	if err != nil {
		t.Fatalf("BedBoard: %v", err)
	}
	if len(board.Msg.GetPlaces()) != 1 {
		t.Fatalf("%d beds on the board, want 1", len(board.Msg.GetPlaces()))
	}

	place := board.Msg.GetPlaces()[0]
	if place.GetClass().GetChargeCode() != "ACC-SEMI-DAY" {
		t.Errorf("the board cannot say what the bed costs: %+v", place.GetClass())
	}
	if place.GetRoom().GetGenderPolicy() !=
		organizationv1.GenderPolicy_GENDER_POLICY_FEMALE_ONLY {
		t.Errorf("the board lost the room's gender policy: %v",
			place.GetRoom().GetGenderPolicy())
	}
	if place.GetRoom().GetIsolation() !=
		organizationv1.IsolationCapability_ISOLATION_CAPABILITY_DROPLET {
		t.Errorf("the board lost what the room can contain: %v",
			place.GetRoom().GetIsolation())
	}
}

// Blocking a bed is a decision, and a decision with no reason cannot be
// reviewed.
func TestBlockingABedRecordsWhy(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	e := commissionWard(t, h)

	_, err := h.org.SetBedAvailability(ctx,
		as(e.nurseToken, &organizationv1.SetBedAvailabilityRequest{
			BedId:           e.bedID,
			Availability:    organizationv1.BedAvailability_BED_AVAILABILITY_BLOCKED,
			ExpectedVersion: e.bedVersion,
		}))
	if err == nil {
		t.Fatal("a bed was blocked with no reason")
	}
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Errorf("code = %v, want invalid_argument", connect.CodeOf(err))
	}
}

// Estate work and ward work are different permissions, so a nurse cannot lose
// a bed by reaching for the wrong control and an administrator cannot quietly
// block one.
func TestCommissioningAndWardWorkAreDifferentPermissions(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	e := commissionWard(t, h)

	if _, err := h.org.RetireBed(ctx,
		as(e.nurseToken, &organizationv1.RetireBedRequest{
			BedId: e.bedID, ExpectedVersion: e.bedVersion,
		})); err == nil {
		t.Error("a nurse retired a bed from the estate")
	} else if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Errorf("code = %v, want permission_denied", connect.CodeOf(err))
	}

	if _, err := h.org.CommissionBed(ctx,
		as(e.nurseToken, &organizationv1.CommissionBedRequest{
			RoomId: e.roomID, Code: "W7-101-B",
		})); err == nil {
		t.Error("a nurse commissioned a bed")
	}

	if _, err := h.org.SetBedAvailability(ctx,
		as(e.adminToken, &organizationv1.SetBedAvailabilityRequest{
			BedId:           e.bedID,
			Availability:    organizationv1.BedAvailability_BED_AVAILABILITY_BLOCKED,
			Reason:          "deep clean",
			ExpectedVersion: e.bedVersion,
		})); err == nil {
		t.Error("a tenant administrator blocked a ward's bed")
	}
}

// SRS-PLT-015: a bed leaves the estate by retirement and does not come back,
// and it cannot leave with a patient in it.
func TestABedWithAPatientInItCannotBeRetired(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	e := commissionWard(t, h)

	occupied, err := h.org.SetBedAvailability(ctx,
		as(e.nurseToken, &organizationv1.SetBedAvailabilityRequest{
			BedId:           e.bedID,
			Availability:    organizationv1.BedAvailability_BED_AVAILABILITY_OCCUPIED,
			ExpectedVersion: e.bedVersion,
		}))
	if err != nil {
		t.Fatalf("SetBedAvailability: %v", err)
	}
	version := occupied.Msg.GetBed().GetVersion()

	if _, err := h.org.RetireBed(ctx,
		as(e.adminToken, &organizationv1.RetireBedRequest{
			BedId: e.bedID, ExpectedVersion: version,
		})); err == nil {
		t.Fatal("a bed was retired with a patient in it")
	}

	// Once it is empty it can go, and then it is off the board for good.
	cleaning, err := h.org.SetBedAvailability(ctx,
		as(e.nurseToken, &organizationv1.SetBedAvailabilityRequest{
			BedId:           e.bedID,
			Availability:    organizationv1.BedAvailability_BED_AVAILABILITY_CLEANING,
			ExpectedVersion: version,
		}))
	if err != nil {
		t.Fatalf("SetBedAvailability: %v", err)
	}
	retired, err := h.org.RetireBed(ctx,
		as(e.adminToken, &organizationv1.RetireBedRequest{
			BedId:           e.bedID,
			ExpectedVersion: cleaning.Msg.GetBed().GetVersion(),
		}))
	if err != nil {
		t.Fatalf("RetireBed: %v", err)
	}
	if retired.Msg.GetBed().GetStatus() != "retired" ||
		retired.Msg.GetBed().GetUsable() {
		t.Errorf("bed = %+v", retired.Msg.GetBed())
	}

	board, err := h.org.BedBoard(ctx,
		as(e.nurseToken, &organizationv1.BedBoardRequest{FacilityId: e.facilityID}))
	if err != nil {
		t.Fatalf("BedBoard: %v", err)
	}
	if len(board.Msg.GetPlaces()) != 0 {
		t.Errorf("%d beds on the board after the only one was retired",
			len(board.Msg.GetPlaces()))
	}
}

// SRS-PLT-006's charge mapping, refused at the boundary: a class that maps to
// nothing would make every stay in it free.
func TestAnAccommodationClassWithNoChargeIsRefused(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	tenantID := h.provisionTenant(t, "Apollo Group")

	_, err := h.org.DefineBedClass(ctx,
		as(tenantAdminToken(tenantID), &organizationv1.DefineBedClassRequest{
			Code: "DELUXE", DisplayName: "Deluxe",
		}))
	if err == nil {
		t.Fatal("a class was defined with no charge code")
	}
	if !strings.Contains(err.Error(), "charge") {
		t.Errorf("the refusal does not say what is missing: %v", err)
	}
}

// A room cannot be classed as an accommodation the tenant does not have, and
// the caller is told which code was wrong rather than handed a constraint.
func TestARoomCannotBeClassedAsSomethingThatDoesNotExist(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	e := commissionWard(t, h)

	_, err := h.org.CommissionRoom(ctx,
		as(e.adminToken, &organizationv1.CommissionRoomRequest{
			FacilityId: e.facilityID, UnitId: e.unitID,
			Code: "W7-102", ClassCode: "NO-SUCH-CLASS",
		}))
	if err == nil {
		t.Fatal("a room was classed as an accommodation that does not exist")
	}
	if connect.CodeOf(err) != connect.CodeNotFound {
		t.Errorf("code = %v, want not_found", connect.CodeOf(err))
	}
}
