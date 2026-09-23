package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RegisterVehicleInput adds an ambulance to the fleet (SRS-AMB-002).
type RegisterVehicleInput struct {
	Registration string
	CallSign     string
	Kind         string
	FacilityID   string
	BaseID       string
	Capabilities []string
}

// RegisterVehicle adds a vehicle, off the run (SRS-AMB-002).
func (s *Service) RegisterVehicle(ctx context.Context,
	in RegisterVehicleInput) (domain.Vehicle, error) {

	session, scope, err := s.authorize(ctx, PermFleetManage)
	if err != nil {
		return domain.Vehicle{}, err
	}
	now := s.clock.Now()

	var out domain.Vehicle
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.checkFacility(ctx, scope, in.FacilityID); err != nil {
			return err
		}
		vehicle, err := domain.NewVehicle(s.ids.NewID(), session.TenantID,
			domain.NewVehicleInput{
				Registration: in.Registration, CallSign: in.CallSign,
				Kind:       domain.VehicleKind(in.Kind),
				FacilityID: in.FacilityID, BaseID: in.BaseID,
				Capabilities: in.Capabilities,
			}, session.SubjectID, now)
		if err != nil {
			return ambulanceError(err)
		}
		if err := s.vehicles.InsertVehicle(ctx, scope, vehicle); err != nil {
			return err
		}
		out = vehicle
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.vehicle.registered",
			ResourceType: "ambulance.vehicle", ResourceID: vehicle.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind": string(vehicle.Kind),
			}),
		}, now)
	})
	if err != nil {
		return domain.Vehicle{}, err
	}
	return out, nil
}

// SetVehicleStateInput moves a vehicle on or off the run (SRS-AMB-002).
type SetVehicleStateInput struct {
	VehicleID string
	// State is one of available, out_of_service or retired. Going
	// available needs a check; the other two need a reason.
	State string
	// CheckID is the passed readiness check a vehicle goes on the run
	// behind. Required for available.
	CheckID string
	Reason  string
	Version int64
}

// SetVehicleState moves a vehicle between fleet states (SRS-AMB-002,
// SRS-AMB-006).
//
// Going available reads the check back rather than trusting a flag on the
// call: a vehicle marked available by somebody who did not look in it is the
// whole of what SRS-AMB-006 exists to prevent.
func (s *Service) SetVehicleState(ctx context.Context,
	in SetVehicleStateInput) (domain.Vehicle, error) {

	session, scope, err := s.authorize(ctx, PermFleetManage)
	if err != nil {
		return domain.Vehicle{}, err
	}
	now := s.clock.Now()

	var out domain.Vehicle
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		vehicle, err := s.vehicles.Vehicle(ctx, scope, in.VehicleID)
		if err != nil {
			return err
		}
		switch domain.VehicleState(in.State) {
		case domain.VehicleAvailable:
			check, err := s.readiness.Check(ctx, scope, in.CheckID)
			if err != nil {
				return err
			}
			if err := vehicle.GoAvailable(check, now); err != nil {
				return ambulanceError(err)
			}
		case domain.VehicleOutOfService:
			if err := vehicle.GoOutOfService(in.Reason); err != nil {
				return ambulanceError(err)
			}
		case domain.VehicleRetired:
			if err := vehicle.Retire(in.Reason); err != nil {
				return ambulanceError(err)
			}
		default:
			return rpcerr.Invalid("AMB_INVALID",
				"a vehicle is set available, out_of_service or retired")
		}

		if err := s.vehicles.UpdateVehicle(ctx, scope, vehicle,
			in.Version); err != nil {
			return ambulanceError(err)
		}
		vehicle.Version = in.Version + 1
		out = vehicle
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.vehicle." + in.State,
			ResourceType: "ambulance.vehicle", ResourceID: vehicle.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reason,
		}, now)
	})
	if err != nil {
		return domain.Vehicle{}, err
	}
	return out, nil
}

// Vehicle reads one vehicle (SRS-AMB-002).
func (s *Service) Vehicle(ctx context.Context, id string) (
	domain.Vehicle, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Vehicle{}, err
	}
	return s.vehicles.Vehicle(ctx, scope, id)
}

// ListVehiclesInput narrows a fleet list.
type ListVehiclesInput struct {
	States     []string
	Kinds      []string
	FacilityID string
	PageSize   int32
	Offset     int32
}

// ListVehicles reads the fleet (SRS-AMB-002).
func (s *Service) ListVehicles(ctx context.Context, in ListVehiclesInput) (
	[]domain.Vehicle, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	states := make([]domain.VehicleState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.VehicleState(state))
	}
	kinds := make([]domain.VehicleKind, 0, len(in.Kinds))
	for _, kind := range in.Kinds {
		kinds = append(kinds, domain.VehicleKind(kind))
	}
	return s.vehicles.Vehicles(ctx, scope, ports.VehicleFilter{
		States: states, Kinds: kinds, FacilityID: in.FacilityID,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// RosterShiftInput puts a crew on a vehicle for a period (SRS-AMB-002).
type RosterShiftInput struct {
	VehicleID  string
	FacilityID string
	Crew       []CrewMemberInput
	StartsAt   time.Time
	EndsAt     time.Time
}

// CrewMemberInput is one person on the crew.
type CrewMemberInput struct {
	SubjectID          string
	Name               string
	Role               string
	RegistrationNumber string
}

// RosterShift plans a crew shift (SRS-AMB-002).
func (s *Service) RosterShift(ctx context.Context, in RosterShiftInput) (
	domain.Shift, error) {

	session, scope, err := s.authorize(ctx, PermFleetManage)
	if err != nil {
		return domain.Shift{}, err
	}
	now := s.clock.Now()

	crew := make([]domain.CrewMember, 0, len(in.Crew))
	for _, member := range in.Crew {
		crew = append(crew, domain.CrewMember{
			SubjectID: member.SubjectID, Name: member.Name,
			Role:               domain.CrewRole(member.Role),
			RegistrationNumber: member.RegistrationNumber,
		})
	}

	var out domain.Shift
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The vehicle is read back rather than taken on trust: a shift
		// rostered to a vehicle that is not there is a crew nobody can
		// find.
		if _, err := s.vehicles.Vehicle(ctx, scope, in.VehicleID); err != nil {
			return err
		}
		shift, err := domain.NewShift(s.ids.NewID(), session.TenantID,
			domain.NewShiftInput{
				VehicleID: in.VehicleID, FacilityID: in.FacilityID,
				Crew: crew, StartsAt: in.StartsAt, EndsAt: in.EndsAt,
			}, session.SubjectID, now)
		if err != nil {
			return ambulanceError(err)
		}
		if err := s.shifts.InsertShift(ctx, scope, shift); err != nil {
			return err
		}
		out = shift
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.shift.rostered",
			ResourceType: "ambulance.shift", ResourceID: shift.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"vehicle_id": shift.VehicleID,
				"crew_size":  itoa(len(shift.Crew)),
			}),
		}, now)
	})
	if err != nil {
		return domain.Shift{}, err
	}
	return out, nil
}

// SetShiftStateInput starts or ends a shift.
type SetShiftStateInput struct {
	ShiftID string
	// State is on_duty or ended.
	State   string
	Version int64
}

// SetShiftState books a crew on or off (SRS-AMB-002).
func (s *Service) SetShiftState(ctx context.Context,
	in SetShiftStateInput) (domain.Shift, error) {

	session, scope, err := s.authorize(ctx, PermFleetManage)
	if err != nil {
		return domain.Shift{}, err
	}
	now := s.clock.Now()

	var out domain.Shift
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		shift, err := s.shifts.Shift(ctx, scope, in.ShiftID)
		if err != nil {
			return err
		}
		switch domain.ShiftState(in.State) {
		case domain.ShiftOnDuty:
			if err := shift.Start(now); err != nil {
				return ambulanceError(err)
			}
		case domain.ShiftEnded:
			if err := shift.End(now); err != nil {
				return ambulanceError(err)
			}
		default:
			return rpcerr.Invalid("AMB_INVALID",
				"a shift is set on_duty or ended")
		}
		if err := s.shifts.UpdateShift(ctx, scope, shift,
			in.Version); err != nil {
			return ambulanceError(err)
		}
		shift.Version = in.Version + 1
		out = shift
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.shift." + in.State,
			ResourceType: "ambulance.shift", ResourceID: shift.ID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.Shift{}, err
	}
	return out, nil
}

// Shift reads one shift (SRS-AMB-002).
func (s *Service) Shift(ctx context.Context, id string) (
	domain.Shift, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Shift{}, err
	}
	return s.shifts.Shift(ctx, scope, id)
}

// ListShiftsInput narrows a roster list.
type ListShiftsInput struct {
	VehicleID  string
	FacilityID string
	States     []string
	From       time.Time
	To         time.Time
	PageSize   int32
	Offset     int32
}

// ListShifts reads the roster (SRS-AMB-002).
func (s *Service) ListShifts(ctx context.Context, in ListShiftsInput) (
	[]domain.Shift, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	states := make([]domain.ShiftState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.ShiftState(state))
	}
	return s.shifts.Shifts(ctx, scope, ports.ShiftFilter{
		VehicleID: in.VehicleID, FacilityID: in.FacilityID,
		States: states, From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// RecordCheckInput is a readiness check made against a vehicle
// (SRS-AMB-006).
type RecordCheckInput struct {
	VehicleID        string
	ShiftID          string
	FacilityID       string
	Items            []ChecklistItemInput
	Outcomes         []ItemOutcomeInput
	OxygenBar        int
	OxygenMinimumBar int
	ValidFor         time.Duration
}

// ChecklistItemInput is one thing the check asks about.
type ChecklistItemInput struct {
	Code     string
	Label    string
	Critical bool
}

// ItemOutcomeInput is the answer.
type ItemOutcomeInput struct {
	Code    string
	Present bool
	Note    string
}

// RecordCheck records a readiness check (SRS-AMB-006).
//
// A failed check produces an event, because a vehicle that is not fit is
// something a fleet manager needs to see without opening a screen for each
// vehicle in turn.
func (s *Service) RecordCheck(ctx context.Context, in RecordCheckInput) (
	domain.ReadinessCheck, error) {

	session, scope, err := s.authorize(ctx, PermCheck)
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	now := s.clock.Now()

	items := make([]domain.ReadinessItem, 0, len(in.Items))
	for _, item := range in.Items {
		items = append(items, domain.ReadinessItem{
			Code: item.Code, Label: item.Label, Critical: item.Critical,
		})
	}
	outcomes := make([]domain.ItemOutcome, 0, len(in.Outcomes))
	for _, outcome := range in.Outcomes {
		outcomes = append(outcomes, domain.ItemOutcome{
			Code: outcome.Code, Present: outcome.Present,
			Note: outcome.Note,
		})
	}

	var out domain.ReadinessCheck
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if _, err := s.vehicles.Vehicle(ctx, scope,
			in.VehicleID); err != nil {
			return err
		}
		check, err := domain.RecordCheck(s.ids.NewID(), session.TenantID,
			domain.NewCheckInput{
				VehicleID: in.VehicleID, ShiftID: in.ShiftID,
				FacilityID: in.FacilityID, Items: items,
				Outcomes: outcomes, OxygenBar: in.OxygenBar,
				OxygenMinimumBar: in.OxygenMinimumBar,
				ValidFor:         in.ValidFor,
			}, session.SubjectID, now)
		if err != nil {
			return ambulanceError(err)
		}
		if err := s.readiness.InsertCheck(ctx, scope, check); err != nil {
			return err
		}
		out = check

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.readiness.recorded",
			ResourceType: "ambulance.readiness_check",
			ResourceID:   check.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"vehicle_id": check.VehicleID,
				"state":      string(check.State),
				"missing":    itoa(len(check.Missing)),
			}),
		}, now); err != nil {
			return err
		}
		if check.State != domain.CheckFailed {
			return nil
		}
		return s.appendEvent(ctx, session, EventReadinessFailed,
			"ambulance.readiness_check", check.ID, map[string]any{
				"vehicle_id": check.VehicleID,
				"missing":    check.Missing,
			}, now)
	})
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	return out, nil
}

// OverrideCheckInput waves a failed check through (SRS-AMB-006).
type OverrideCheckInput struct {
	CheckID string
	Reason  string
	Version int64
}

// OverrideCheck records a second person putting a failed vehicle on the run
// (SRS-AMB-006).
//
// The domain refuses whoever made the check, so holding the permission is
// still not enough to wave your own findings through.
func (s *Service) OverrideCheck(ctx context.Context,
	in OverrideCheckInput) (domain.ReadinessCheck, error) {

	session, scope, err := s.authorize(ctx, PermCheckOverride)
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	now := s.clock.Now()

	var out domain.ReadinessCheck
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		check, err := s.readiness.Check(ctx, scope, in.CheckID)
		if err != nil {
			return err
		}
		if err := check.Override(in.Reason, session.SubjectID,
			now); err != nil {
			return ambulanceError(err)
		}
		if err := s.readiness.UpdateOverride(ctx, scope, check,
			in.Version); err != nil {
			return ambulanceError(err)
		}
		check.Version = in.Version + 1
		out = check
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.readiness.overridden",
			ResourceType: "ambulance.readiness_check",
			ResourceID:   check.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Reason,
			Context: auditContext(map[string]string{
				"vehicle_id": check.VehicleID,
				"missing":    itoa(len(check.Missing)),
			}),
		}, now)
	})
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	return out, nil
}

// Check reads one readiness check (SRS-AMB-006).
func (s *Service) Check(ctx context.Context, id string) (
	domain.ReadinessCheck, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.ReadinessCheck{}, err
	}
	return s.readiness.Check(ctx, scope, id)
}

// ListChecksInput narrows a readiness list.
type ListChecksInput struct {
	VehicleID  string
	FacilityID string
	States     []string
	From       time.Time
	To         time.Time
	PageSize   int32
	Offset     int32
}

// ListChecks reads readiness checks (SRS-AMB-006).
func (s *Service) ListChecks(ctx context.Context, in ListChecksInput) (
	[]domain.ReadinessCheck, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	states := make([]domain.CheckState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.CheckState(state))
	}
	return s.readiness.Checks(ctx, scope, ports.CheckFilter{
		VehicleID: in.VehicleID, FacilityID: in.FacilityID,
		States: states, From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// ReadinessSummary reports how the fleet is doing its checks (SRS-AMB-006).
func (s *Service) ReadinessSummary(ctx context.Context,
	in ListChecksInput) (domain.ReadinessSummary, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return domain.ReadinessSummary{}, err
	}
	states := make([]domain.CheckState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.CheckState(state))
	}
	checks, err := s.readiness.Checks(ctx, scope, ports.CheckFilter{
		VehicleID: in.VehicleID, FacilityID: in.FacilityID,
		States: states, From: in.From, To: in.To,
		Limit: reportPageSize,
	})
	if err != nil {
		return domain.ReadinessSummary{}, err
	}
	return domain.SummariseReadiness(checks), nil
}
