package application

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Bed cleaning holds (SRS-HKP-003).
//
// A bed with an open terminal clean is not available, and the only ways out
// are the clean finishing and somebody overriding it by name and reason. That
// is SRS-HKP-003's acceptance, and it is the rule that stops a patient being
// put into the bed the last one died in.

// TriggerTerminalCleanInput raises a terminal clean and holds the bed.
type TriggerTerminalCleanInput struct {
	LocationCode string
	// EncounterID is the discharge or transfer that triggered it, where
	// there was one. Carried so a ward can see which discharge a held bed
	// belongs to.
	EncounterID string
	AssigneeID  string
	Detail      string
}

// TerminalClean is the task and the hold it placed.
type TerminalClean struct {
	Task domain.CleaningTask
	Hold domain.BedHold
}

// TriggerTerminalClean raises the clean between one patient and the next and
// takes the bed out of service (SRS-HKP-003).
//
// One act. A task raised without its hold is a bed the board still calls
// free, and the next patient is in it before anybody sweeps the floor.
func (s *Service) TriggerTerminalClean(ctx context.Context,
	in TriggerTerminalCleanInput) (TerminalClean, error) {

	session, scope, err := s.authorize(ctx, PermHoldBed)
	if err != nil {
		return TerminalClean{}, err
	}
	now := s.clock.Now()

	location, err := s.inForce(ctx, scope, in.LocationCode, now)
	if err != nil {
		return TerminalClean{}, err
	}
	if err := s.checkDischarge(ctx, scope, in.EncounterID); err != nil {
		return TerminalClean{}, err
	}

	task, err := domain.RaiseTask(s.ids.NewID(), session.TenantID, location,
		domain.NewTaskInput{
			Kind: domain.TaskTerminal, Detail: in.Detail,
			AssigneeID: in.AssigneeID,
		}, session.SubjectID, now)
	if err != nil {
		return TerminalClean{}, housekeepingError(err)
	}
	hold, err := domain.PlaceBedHold(s.ids.NewID(), session.TenantID, task,
		in.EncounterID, session.SubjectID, now)
	if err != nil {
		return TerminalClean{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.tasks.InsertTask(ctx, scope, task); err != nil {
			return err
		}
		if err := s.holds.InsertHold(ctx, scope, hold); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventBedHeld, "bed_hold",
			hold.ID, map[string]any{
				"bed_id": hold.BedID, "task_id": task.ID,
				"location_code": task.LocationCode,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "housekeeping.bed.held", ResourceType: "bed_hold",
			ResourceID: hold.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"bed_id": hold.BedID, "task_id": task.ID,
			}),
		}, now)
	})
	if err != nil {
		return TerminalClean{}, err
	}
	return TerminalClean{Task: redact(session, task), Hold: hold}, nil
}

// checkDischarge refuses a terminal clean for an encounter that has not ended
// (SRS-HKP-003).
//
// A bed taken out of service with somebody still in it is a bed the ward
// stops trusting the board about, and a board nobody trusts is worse than no
// board.
func (s *Service) checkDischarge(ctx context.Context,
	scope authctx.TenantScope, encounterID string) error {

	if !s.config.RequireEndedEncounter {
		return nil
	}
	if strings.TrimSpace(encounterID) == "" {
		// A deployment that turned this on said every terminal clean names
		// its discharge. Accepting one with no encounter would make the
		// setting mean "check it when the caller happens to send one",
		// which is the check nobody can rely on.
		return rpcerr.FailedPrecondition("HKP_TERMINAL_NEEDS_ENCOUNTER",
			"this deployment requires a terminal clean to name the "+
				"discharge or transfer that triggered it")
	}
	if s.encounters == nil {
		return rpcerr.FailedPrecondition("HKP_NO_ENCOUNTER_DIRECTORY",
			"this deployment requires a terminal clean to name an ended "+
				"encounter, but no encounter directory is configured")
	}
	facts, found, err := s.encounters.Describe(ctx, scope, encounterID)
	if err != nil {
		return err
	}
	if !found {
		return rpcerr.FailedPrecondition("HKP_NO_SUCH_ENCOUNTER",
			"no encounter "+encounterID+" to raise a terminal clean for")
	}
	if !facts.Ended {
		return rpcerr.FailedPrecondition("HKP_ENCOUNTER_STILL_OPEN",
			"encounter "+encounterID+" has not ended, so the bed is still "+
				"occupied")
	}
	return nil
}

// releaseHold lifts a terminal clean's hold when the clean is done.
//
// Called inside the completing or verifying transaction. The hold is read
// back and the task passed to the domain, which checks the task is the one
// the hold names and that it is actually done: a hold released because
// somebody pressed the wrong button is a bed reported clean that is not.
func (s *Service) releaseHold(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, task domain.CleaningTask,
	now time.Time) error {

	if task.Kind != domain.TaskTerminal {
		return nil
	}
	hold, found, err := s.holds.HoldForTask(ctx, scope, task.ID)
	if err != nil {
		return err
	}
	if !found || hold.State != domain.HoldOpen {
		return nil
	}
	if s.config.RequireVerification && task.State != domain.TaskVerified {
		// The bed comes back when the supervisor says so and not when the
		// cleaner does. Not an error: the clean is still recorded, the bed
		// is simply still held.
		return nil
	}

	version := hold.Version
	if err := hold.Release(task, s.config.RequireVerification,
		session.SubjectID, now); err != nil {
		return housekeepingError(err)
	}
	if err := s.holds.UpdateHold(ctx, scope, hold, version); err != nil {
		return housekeepingError(err)
	}
	if err := s.appendEvent(ctx, session, EventBedReleased, "bed_hold",
		hold.ID, map[string]any{
			"bed_id": hold.BedID, "task_id": task.ID,
		}, now); err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "housekeeping.bed.released", ResourceType: "bed_hold",
		ResourceID: hold.ID, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{
			"bed_id": hold.BedID, "task_id": task.ID,
		}),
	}, now)
}

// OverrideHold puts a bed back into service without the clean finishing
// (SRS-HKP-003).
//
// Its own permission, its own state and its own reason, and it escalates.
// This is a bed going back into service uncleaned, which is sometimes the
// right call in a full hospital and is always a decision somebody has to be
// able to point at afterwards — and the ward admitting into it is entitled to
// know.
func (s *Service) OverrideHold(ctx context.Context, holdID, reason string) (
	domain.BedHold, error) {

	session, scope, err := s.authorize(ctx, PermOverrideHold)
	if err != nil {
		return domain.BedHold{}, err
	}
	now := s.clock.Now()

	hold, err := s.holds.Hold(ctx, scope, holdID)
	if err != nil {
		return domain.BedHold{}, err
	}
	version := hold.Version
	if err := hold.Override(reason, session.SubjectID, now); err != nil {
		return domain.BedHold{}, housekeepingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.holds.UpdateHold(ctx, scope, hold, version); err != nil {
			return housekeepingError(err)
		}
		if err := s.appendEvent(ctx, session, EventBedOverridden, "bed_hold",
			hold.ID, map[string]any{
				"bed_id": hold.BedID, "task_id": hold.TaskID,
			}, now); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "housekeeping.bed.overridden", ResourceType: "bed_hold",
			ResourceID: hold.ID, Outcome: audit.OutcomeSuccess,
			Reason: hold.OverrideReason,
			Context: auditContext(map[string]string{
				"bed_id": hold.BedID, "task_id": hold.TaskID,
			}),
		}, now); err != nil {
			return err
		}
		return s.escalate(ctx, session, scope, ports.Notice{
			Kind: EscalationOverride, Subject: hold.ID,
			FacilityID: hold.FacilityID,
			Summary: "bed " + hold.BedID + " returned to service " +
				"uncleaned: " + hold.OverrideReason,
		}, now)
	})
	if err != nil {
		return domain.BedHold{}, err
	}
	return hold, nil
}

// BedStatus answers whether a bed may be used (SRS-HKP-003).
type BedStatus struct {
	BedID string
	Clear bool
	// Hold is the open hold, when there is one.
	Hold domain.BedHold
}

// BedClear answers whether a bed may be used (SRS-HKP-003).
//
// A bed this context knows nothing about comes back clear: it only knows
// about beds somebody raised a terminal clean for, and a system that reported
// every bed in the hospital dirty would be ignored within a day.
func (s *Service) BedClear(ctx context.Context, bedID string) (BedStatus,
	error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return BedStatus{}, err
	}
	hold, found, err := s.holds.OpenHoldForBed(ctx, scope, bedID)
	if err != nil {
		return BedStatus{}, err
	}
	return BedStatus{BedID: bedID, Clear: !found, Hold: hold}, nil
}

// ListHeldBedsInput narrows a held-bed read.
type ListHeldBedsInput struct {
	FacilityID string
	Zone       string
	PageSize   int32
	Offset     int32
}

// ListHeldBeds lists the beds out of service, longest first (SRS-HKP-003).
func (s *Service) ListHeldBeds(ctx context.Context, in ListHeldBedsInput) (
	[]domain.BedHold, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	holds, err := s.holds.Holds(ctx, scope, ports.HoldFilter{
		FacilityID: in.FacilityID, Zone: in.Zone, OpenOnly: true,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
	if err != nil {
		return nil, err
	}
	return domain.HeldBeds(holds), nil
}
