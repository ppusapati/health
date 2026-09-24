package transport

import (
	"context"

	"connectrpc.com/connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/internal/organization/application"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// The bed and room master (SRS-PLT-006).

var genderToProto = map[domain.GenderPolicy]organizationv1.GenderPolicy{
	domain.GenderAny:    organizationv1.GenderPolicy_GENDER_POLICY_ANY,
	domain.GenderMale:   organizationv1.GenderPolicy_GENDER_POLICY_MALE_ONLY,
	domain.GenderFemale: organizationv1.GenderPolicy_GENDER_POLICY_FEMALE_ONLY,
}

var genderFromProto = map[organizationv1.GenderPolicy]domain.GenderPolicy{
	organizationv1.GenderPolicy_GENDER_POLICY_ANY:         domain.GenderAny,
	organizationv1.GenderPolicy_GENDER_POLICY_MALE_ONLY:   domain.GenderMale,
	organizationv1.GenderPolicy_GENDER_POLICY_FEMALE_ONLY: domain.GenderFemale,
}

var isolationToProto = map[domain.IsolationCapability]organizationv1.IsolationCapability{
	domain.IsolationNone:     organizationv1.IsolationCapability_ISOLATION_CAPABILITY_NONE,
	domain.IsolationContact:  organizationv1.IsolationCapability_ISOLATION_CAPABILITY_CONTACT,
	domain.IsolationDroplet:  organizationv1.IsolationCapability_ISOLATION_CAPABILITY_DROPLET,
	domain.IsolationAirborne: organizationv1.IsolationCapability_ISOLATION_CAPABILITY_AIRBORNE,
}

var isolationFromProto = map[organizationv1.IsolationCapability]domain.IsolationCapability{
	organizationv1.IsolationCapability_ISOLATION_CAPABILITY_NONE:     domain.IsolationNone,
	organizationv1.IsolationCapability_ISOLATION_CAPABILITY_CONTACT:  domain.IsolationContact,
	organizationv1.IsolationCapability_ISOLATION_CAPABILITY_DROPLET:  domain.IsolationDroplet,
	organizationv1.IsolationCapability_ISOLATION_CAPABILITY_AIRBORNE: domain.IsolationAirborne,
}

var availabilityToProto = map[domain.BedAvailability]organizationv1.BedAvailability{
	domain.BedAvailable:    organizationv1.BedAvailability_BED_AVAILABILITY_AVAILABLE,
	domain.BedOccupied:     organizationv1.BedAvailability_BED_AVAILABILITY_OCCUPIED,
	domain.BedCleaning:     organizationv1.BedAvailability_BED_AVAILABILITY_CLEANING,
	domain.BedBlocked:      organizationv1.BedAvailability_BED_AVAILABILITY_BLOCKED,
	domain.BedOutOfService: organizationv1.BedAvailability_BED_AVAILABILITY_OUT_OF_SERVICE,
}

// availabilityFromProto leaves an unspecified value empty rather than
// defaulting it. The domain refuses an unknown state, which is the answer a
// caller who forgot the field should get — a default would silently make a bed
// available.
var availabilityFromProto = map[organizationv1.BedAvailability]domain.BedAvailability{
	organizationv1.BedAvailability_BED_AVAILABILITY_AVAILABLE:      domain.BedAvailable,
	organizationv1.BedAvailability_BED_AVAILABILITY_OCCUPIED:       domain.BedOccupied,
	organizationv1.BedAvailability_BED_AVAILABILITY_CLEANING:       domain.BedCleaning,
	organizationv1.BedAvailability_BED_AVAILABILITY_BLOCKED:        domain.BedBlocked,
	organizationv1.BedAvailability_BED_AVAILABILITY_OUT_OF_SERVICE: domain.BedOutOfService,
}

func classToProto(c domain.BedClass) *organizationv1.BedClass {
	return &organizationv1.BedClass{
		ClassId: c.ID, Code: c.Code, DisplayName: c.DisplayName,
		ChargeCode: c.ChargeCode, Status: string(c.Status), Version: c.Version,
	}
}

func roomToProto(r domain.Room) *organizationv1.Room {
	return &organizationv1.Room{
		RoomId: r.ID, FacilityId: r.FacilityID, UnitId: r.UnitID,
		Code: r.Code, DisplayName: r.DisplayName, ClassCode: r.ClassCode,
		GenderPolicy: genderToProto[r.GenderPolicy],
		Isolation:    isolationToProto[r.Isolation],
		Status:       string(r.Status), Version: r.Version,
	}
}

func bedToProto(b domain.Bed) *organizationv1.Bed {
	return &organizationv1.Bed{
		BedId: b.ID, RoomId: b.RoomID, FacilityId: b.FacilityID,
		Code: b.Code, DisplayName: b.DisplayName,
		Status:            string(b.Status),
		Availability:      availabilityToProto[b.Availability],
		UnavailableReason: b.UnavailableReason,
		Version:           b.Version,
		// Derived here rather than stored, so the wire cannot carry a usable
		// flag that disagrees with the two fields it is computed from.
		Usable: b.Usable(),
	}
}

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(
		err, platformtransport.CorrelationIDFromContext(ctx))
}

// DefineBedClass adds an accommodation class (SRS-PLT-006).
func (h *Handler) DefineBedClass(
	ctx context.Context,
	req *connect.Request[organizationv1.DefineBedClassRequest],
) (*connect.Response[organizationv1.DefineBedClassResponse], error) {
	msg := req.Msg
	class, err := h.svc.DefineBedClass(ctx, application.DefineBedClassInput{
		Code: msg.GetCode(), DisplayName: msg.GetDisplayName(),
		ChargeCode: msg.GetChargeCode(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&organizationv1.DefineBedClassResponse{
		Class: classToProto(class),
	}), nil
}

// ListBedClasses returns the catalogue (SRS-PLT-006).
func (h *Handler) ListBedClasses(
	ctx context.Context,
	req *connect.Request[organizationv1.ListBedClassesRequest],
) (*connect.Response[organizationv1.ListBedClassesResponse], error) {
	classes, err := h.svc.BedClasses(ctx)
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*organizationv1.BedClass, 0, len(classes))
	for _, c := range classes {
		out = append(out, classToProto(c))
	}
	return connect.NewResponse(&organizationv1.ListBedClassesResponse{
		Classes: out,
	}), nil
}

// CommissionRoom adds a room (SRS-PLT-002, SRS-PLT-006).
func (h *Handler) CommissionRoom(
	ctx context.Context,
	req *connect.Request[organizationv1.CommissionRoomRequest],
) (*connect.Response[organizationv1.CommissionRoomResponse], error) {
	msg := req.Msg
	room, err := h.svc.CommissionRoom(ctx, application.CommissionRoomInput{
		FacilityID: msg.GetFacilityId(), UnitID: msg.GetUnitId(),
		Code: msg.GetCode(), DisplayName: msg.GetDisplayName(),
		ClassCode:    msg.GetClassCode(),
		GenderPolicy: genderFromProto[msg.GetGenderPolicy()],
		Isolation:    isolationFromProto[msg.GetIsolation()],
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&organizationv1.CommissionRoomResponse{
		Room: roomToProto(room),
	}), nil
}

// CommissionBed adds a bed to a room (SRS-PLT-006).
func (h *Handler) CommissionBed(
	ctx context.Context,
	req *connect.Request[organizationv1.CommissionBedRequest],
) (*connect.Response[organizationv1.CommissionBedResponse], error) {
	msg := req.Msg
	bed, err := h.svc.CommissionBed(ctx, application.CommissionBedInput{
		RoomID: msg.GetRoomId(), Code: msg.GetCode(),
		DisplayName: msg.GetDisplayName(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&organizationv1.CommissionBedResponse{
		Bed: bedToProto(bed),
	}), nil
}

// SetBedAvailability moves a bed in or out of use (SRS-PLT-006).
func (h *Handler) SetBedAvailability(
	ctx context.Context,
	req *connect.Request[organizationv1.SetBedAvailabilityRequest],
) (*connect.Response[organizationv1.SetBedAvailabilityResponse], error) {
	msg := req.Msg
	bed, err := h.svc.SetBedAvailability(ctx, application.SetBedAvailabilityInput{
		BedID:           msg.GetBedId(),
		Availability:    availabilityFromProto[msg.GetAvailability()],
		Reason:          msg.GetReason(),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&organizationv1.SetBedAvailabilityResponse{
		Bed: bedToProto(bed),
	}), nil
}

// RetireBed removes a bed from the estate (SRS-PLT-006, SRS-PLT-015).
func (h *Handler) RetireBed(
	ctx context.Context,
	req *connect.Request[organizationv1.RetireBedRequest],
) (*connect.Response[organizationv1.RetireBedResponse], error) {
	msg := req.Msg
	bed, err := h.svc.RetireBed(ctx, application.RetireBedInput{
		BedID: msg.GetBedId(), ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&organizationv1.RetireBedResponse{
		Bed: bedToProto(bed),
	}), nil
}

// BedBoard is the ward's view (SRS-PLT-006).
func (h *Handler) BedBoard(
	ctx context.Context,
	req *connect.Request[organizationv1.BedBoardRequest],
) (*connect.Response[organizationv1.BedBoardResponse], error) {
	msg := req.Msg
	places, err := h.svc.BedBoard(ctx, ports.BedBoardFilter{
		FacilityID: msg.GetFacilityId(), UnitID: msg.GetUnitId(),
		PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*organizationv1.BedPlace, 0, len(places))
	for _, p := range places {
		out = append(out, &organizationv1.BedPlace{
			Bed: bedToProto(p.Bed), Room: roomToProto(p.Room),
			Class: classToProto(p.Class),
		})
	}
	return connect.NewResponse(&organizationv1.BedBoardResponse{
		Places: out,
	}), nil
}

// CommissionOrgUnit creates the ward a room hangs from (SRS-PLT-005).
func (h *Handler) CommissionOrgUnit(
	ctx context.Context,
	req *connect.Request[organizationv1.CommissionOrgUnitRequest],
) (*connect.Response[organizationv1.CommissionOrgUnitResponse], error) {
	if h.masterData.Units == nil {
		return nil, fail(ctx, rpcerr.FailedPrecondition(
			"ORG_MASTER_DATA_NOT_WIRED",
			"this deployment does not serve organizational master data"))
	}

	msg := req.Msg
	in := application.CreateOrgUnitInput{
		FacilityID: msg.GetFacilityId(),
		Type:       domain.UnitType(msg.GetUnitType()),
		Code:       msg.GetCode(), DisplayName: msg.GetDisplayName(),
		ParentUnitID: msg.GetParentUnitId(),
	}
	if from := msg.GetEffectiveFrom(); from != nil {
		in.EffectiveFrom = from.AsTime()
	}
	if until := msg.GetEffectiveUntil(); until != nil {
		in.EffectiveUntil = until.AsTime()
	}

	unit, err := h.svc.CreateOrgUnit(ctx, h.masterData, in)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&organizationv1.CommissionOrgUnitResponse{
		UnitId: unit.ID, Code: unit.Code, DisplayName: unit.DisplayName,
	}), nil
}
