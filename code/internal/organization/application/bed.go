package application

import (
	"context"
	"encoding/json"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The bed and room master (SRS-PLT-006).
//
// Two permissions, because the two things this master does are done by
// different people at different rates. Commissioning a ward is estate work
// somebody does once; moving a bed in and out of use is ward work somebody
// does hourly. One permission covering both would mean every nurse who can
// block a bed can also invent an accommodation class and the tariff attached
// to it.
const (
	// PermBedMasterManage commissions the estate: classes, rooms and beds.
	PermBedMasterManage = "organization.bed_master.manage"
	// PermBedStateManage moves a bed in and out of use.
	PermBedStateManage = "organization.bed.state"
	// PermBedRead reads the board.
	PermBedRead = "organization.bed.read"
)

const (
	// EventBedStateChanged is emitted when a bed's availability or existence
	// moves. Housekeeping, critical care and the ward board all care, and each
	// of them currently learns by asking.
	EventBedStateChanged = "organization.bed_state_changed"
)

// authorizeBed runs the shared permission check for this master.
func (s *Service) authorizeBed(ctx context.Context, permission string,
	mutating bool) (authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}
	tenant, err := s.tenants.GetByID(ctx, session.TenantID)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{}, err
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: permission,
		Mutating:   mutating,
		TenantMode: tenantMode(tenant),
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, permission, "bed", "", decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("ORG_BED_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// DefineBedClassInput commissions an accommodation class.
type DefineBedClassInput struct {
	Code        string
	DisplayName string
	ChargeCode  string
}

// DefineBedClass adds a class to the tenant's catalogue (SRS-PLT-006).
func (s *Service) DefineBedClass(ctx context.Context, in DefineBedClassInput) (
	domain.BedClass, error) {

	session, scope, err := s.authorizeBed(ctx, PermBedMasterManage, true)
	if err != nil {
		return domain.BedClass{}, err
	}
	now := s.clock.Now()

	class, err := domain.NewBedClass(s.ids.NewID(), scope.TenantID(),
		domain.NewBedClassInput(in), now)
	if err != nil {
		return domain.BedClass{}, err
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.beds.InsertClass(ctx, scope, class); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: scope.TenantID(), Action: PermBedMasterManage,
			ResourceType: "bed_class", ResourceID: class.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "class " + class.Code + " charged as " + class.ChargeCode,
		}, now)
	})
	if err != nil {
		return domain.BedClass{}, err
	}
	return class, nil
}

// BedClasses lists the catalogue.
func (s *Service) BedClasses(ctx context.Context) ([]domain.BedClass, error) {
	_, scope, err := s.authorizeBed(ctx, PermBedRead, false)
	if err != nil {
		return nil, err
	}
	return s.beds.ListClasses(ctx, scope)
}

// CommissionRoomInput commissions a room.
type CommissionRoomInput struct {
	FacilityID   string
	UnitID       string
	Code         string
	DisplayName  string
	ClassCode    string
	GenderPolicy domain.GenderPolicy
	Isolation    domain.IsolationCapability
}

// CommissionRoom adds a room (SRS-PLT-002, SRS-PLT-006).
//
// The class is checked to exist before the room is written. The database
// carries the same rule as a foreign key, which is what actually holds it, but
// a caller who mistyped a class code deserves to be told that rather than
// handed a constraint name.
func (s *Service) CommissionRoom(ctx context.Context, in CommissionRoomInput) (
	domain.Room, error) {

	session, scope, err := s.authorizeBed(ctx, PermBedMasterManage, true)
	if err != nil {
		return domain.Room{}, err
	}
	now := s.clock.Now()

	room, err := domain.NewRoom(s.ids.NewID(), scope.TenantID(),
		domain.NewRoomInput(in), now)
	if err != nil {
		return domain.Room{}, err
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if _, err := s.beds.ClassByCode(ctx, scope, room.ClassCode); err != nil {
			return err
		}
		if err := s.beds.InsertRoom(ctx, scope, room); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: scope.TenantID(), Action: PermBedMasterManage,
			ResourceType: "room", ResourceID: room.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "room " + room.Code + " classed " + room.ClassCode,
		}, now)
	})
	if err != nil {
		return domain.Room{}, err
	}
	return room, nil
}

// CommissionBedInput commissions a bed.
type CommissionBedInput struct {
	RoomID      string
	Code        string
	DisplayName string
}

// CommissionBed adds a bed to a room (SRS-PLT-006).
//
// The facility is taken from the room rather than from the caller. It is
// denormalised onto the bed so a board can be read without a join, and a
// caller who could supply it could put a bed in a facility its room is not in
// — which the database would refuse, but only after somebody had tried.
func (s *Service) CommissionBed(ctx context.Context, in CommissionBedInput) (
	domain.Bed, error) {

	session, scope, err := s.authorizeBed(ctx, PermBedMasterManage, true)
	if err != nil {
		return domain.Bed{}, err
	}
	now := s.clock.Now()

	var out domain.Bed
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		room, err := s.beds.Room(ctx, scope, in.RoomID)
		if err != nil {
			return err
		}
		if room.Status == domain.MasterRetired {
			return rpcerr.FailedPrecondition("ORG_ROOM_RETIRED",
				"this room has been retired from the estate")
		}

		bed, err := domain.NewBed(s.ids.NewID(), scope.TenantID(),
			domain.NewBedInput{
				RoomID: room.ID, FacilityID: room.FacilityID,
				Code: in.Code, DisplayName: in.DisplayName,
			}, now)
		if err != nil {
			return err
		}
		if err := s.beds.InsertBed(ctx, scope, bed); err != nil {
			return err
		}
		out = bed
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: scope.TenantID(), Action: PermBedMasterManage,
			ResourceType: "bed", ResourceID: bed.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "bed " + bed.Code + " in room " + room.Code,
		}, now)
	})
	if err != nil {
		return domain.Bed{}, err
	}
	return out, nil
}

// SetBedAvailabilityInput moves a bed in or out of use.
type SetBedAvailabilityInput struct {
	BedID           string
	Availability    domain.BedAvailability
	Reason          string
	ExpectedVersion int64
}

// SetBedAvailability changes whether a bed can be used (SRS-PLT-006).
//
// Separate from RetireBed below, and deliberately so: this is the half that
// moves hourly and says nothing about whether the hospital has the bed.
func (s *Service) SetBedAvailability(ctx context.Context,
	in SetBedAvailabilityInput) (domain.Bed, error) {

	session, scope, err := s.authorizeBed(ctx, PermBedStateManage, true)
	if err != nil {
		return domain.Bed{}, err
	}
	now := s.clock.Now()

	var out domain.Bed
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		bed, err := s.beds.Bed(ctx, scope, in.BedID)
		if err != nil {
			return err
		}
		if err := bed.SetAvailability(in.Availability, in.Reason, now); err != nil {
			return err
		}
		if err := s.beds.UpdateBedState(
			ctx, scope, bed, in.ExpectedVersion); err != nil {
			return err
		}
		out = bed
		if err := s.publishBedState(ctx, session, scope, bed, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: scope.TenantID(), Action: PermBedStateManage,
			ResourceType: "bed", ResourceID: bed.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "bed " + bed.Code + " " + string(bed.Availability),
		}, now)
	})
	if err != nil {
		return domain.Bed{}, err
	}
	return out, nil
}

// RetireBedInput removes a bed from the estate.
type RetireBedInput struct {
	BedID           string
	ExpectedVersion int64
}

// RetireBed removes a bed from the estate (SRS-PLT-006, SRS-PLT-015).
//
// Estate work rather than ward work, so it takes the commissioning permission
// rather than the one a nurse holds. A ward that could retire a bed could lose
// one permanently by reaching for the wrong control.
func (s *Service) RetireBed(ctx context.Context, in RetireBedInput) (
	domain.Bed, error) {

	session, scope, err := s.authorizeBed(ctx, PermBedMasterManage, true)
	if err != nil {
		return domain.Bed{}, err
	}
	now := s.clock.Now()

	var out domain.Bed
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		bed, err := s.beds.Bed(ctx, scope, in.BedID)
		if err != nil {
			return err
		}
		if err := bed.Retire(now); err != nil {
			return err
		}
		if err := s.beds.UpdateBedState(
			ctx, scope, bed, in.ExpectedVersion); err != nil {
			return err
		}
		out = bed
		if err := s.publishBedState(ctx, session, scope, bed, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: scope.TenantID(), Action: PermBedMasterManage,
			ResourceType: "bed", ResourceID: bed.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "bed " + bed.Code + " retired from the estate",
		}, now)
	})
	if err != nil {
		return domain.Bed{}, err
	}
	return out, nil
}

// BedBoard is the ward's view (SRS-PLT-006).
func (s *Service) BedBoard(ctx context.Context, f ports.BedBoardFilter) (
	[]ports.BedPlace, error) {

	_, scope, err := s.authorizeBed(ctx, PermBedRead, false)
	if err != nil {
		return nil, err
	}
	f.PageSize = clampPage(f.PageSize)
	return s.beds.Board(ctx, scope, f)
}

// publishBedState tells the contexts that hold a bed_id that it moved.
//
// They cannot read this master inside their own transaction — it belongs to
// another context — so the event is how housekeeping learns a bed went out of
// service and the ward board learns it came back.
func (s *Service) publishBedState(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, bed domain.Bed, now time.Time) error {

	payload, err := json.Marshal(map[string]any{
		"bed_id":       bed.ID,
		"room_id":      bed.RoomID,
		"facility_id":  bed.FacilityID,
		"status":       string(bed.Status),
		"availability": string(bed.Availability),
		"usable":       bed.Usable(),
	})
	if err != nil {
		return rpcerr.Internal("ORG_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}
	return s.appendEvent(ctx, session, scope.TenantID(), EventBedStateChanged,
		"bed", bed.ID, payload, now)
}

// clampPage keeps one caller from pulling an entire estate in a round trip.
func clampPage(size int32) int32 {
	switch {
	case size <= 0:
		return defaultPageSize
	case size > maxPageSize:
		return maxPageSize
	default:
		return size
	}
}
