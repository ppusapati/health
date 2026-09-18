package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/theatre/domain"
)

// Rooms and blocks (SRS-OT-001), the request (SRS-OT-002), priority
// (SRS-OT-003), scheduling (SRS-OT-004) and the waiting list (SRS-OT-005).

// SaveRoomInput configures a theatre.
type SaveRoomInput struct {
	RoomID      string
	FacilityID  string
	Code        string
	Name        string
	Specialties []string
	Equipment   []string
	Active      bool
}

// SaveRoom creates or updates a theatre (SRS-OT-001).
func (s *Service) SaveRoom(ctx context.Context, in SaveRoomInput) (domain.Room, error) {
	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Room{}, err
	}
	if trimmed(in.Code) == "" {
		return domain.Room{}, rpcerr.Invalid("OT_ROOM_NEEDS_CODE",
			"a theatre has a code")
	}

	now := s.clock.Now()
	room := domain.Room{
		ID: trimmed(in.RoomID, s.ids.NewID()), TenantID: scope.TenantID(),
		FacilityID: trimmed(in.FacilityID, session.ActiveFacilityID),
		Code:       trimmed(in.Code), Name: in.Name,
		Specialties: in.Specialties, Equipment: in.Equipment, Active: in.Active,
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.schedule.SaveRoom(ctx, scope, room); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "theatre_room", ResourceID: room.ID,
			Outcome: audit.OutcomeSuccess, Reason: "theatre " + room.Code + " configured",
		}, now)
	})
	if err != nil {
		return domain.Room{}, err
	}
	return room, nil
}

// Rooms lists a facility's theatres.
func (s *Service) Rooms(ctx context.Context, facilityID string) ([]domain.Room, error) {
	session, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	return s.schedule.Rooms(ctx, scope, trimmed(facilityID, session.ActiveFacilityID))
}

// BlockInput allocates a stretch of theatre time.
type BlockInput struct {
	RoomID    string
	Kind      domain.BlockKind
	OwnerID   string
	Specialty string
	StartsAt  time.Time
	EndsAt    time.Time
	Note      string
}

// SaveBlock allocates list time or plans downtime (SRS-OT-001).
func (s *Service) SaveBlock(ctx context.Context, in BlockInput) (domain.Block, error) {
	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Block{}, err
	}
	switch {
	case trimmed(in.RoomID) == "":
		return domain.Block{}, rpcerr.Invalid("OT_BLOCK_NEEDS_ROOM",
			"a block belongs to a theatre")
	case !in.EndsAt.After(in.StartsAt):
		return domain.Block{}, rpcerr.Invalid("OT_BLOCK_ENDS_BEFORE_IT_STARTS",
			"a block ends after it starts")
	case in.Kind == domain.BlockDowntime && trimmed(in.Note) == "":
		// A closed theatre is a theatre somebody will ask about.
		return domain.Block{}, rpcerr.Invalid("OT_DOWNTIME_NEEDS_A_REASON",
			"say why the theatre is closed")
	}

	now := s.clock.Now()
	block := domain.Block{
		ID: s.ids.NewID(), TenantID: scope.TenantID(), RoomID: in.RoomID,
		Kind: in.Kind, OwnerID: in.OwnerID, Specialty: in.Specialty,
		StartsAt: in.StartsAt.UTC(), EndsAt: in.EndsAt.UTC(), Note: in.Note,
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.schedule.InsertBlock(ctx, scope, block); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "theatre_block", ResourceID: block.ID,
			Outcome: audit.OutcomeSuccess, Reason: string(block.Kind) + " block",
		}, now)
	})
	if err != nil {
		return domain.Block{}, err
	}
	return block, nil
}

// RequestInput raises a surgery request.
type RequestInput struct {
	EncounterID      string
	PatientID        string
	FacilityID       string
	ProcedureCode    string
	ProcedureDisplay string
	DiagnosisCode    string
	DiagnosisDisplay string
	Laterality       domain.Laterality
	Site             string
	Urgency          domain.Urgency
	ExpectedDuration time.Duration
	SurgeonID        string
	Team             []string
	Requirements     []string
	AnaesthesiaType  string
	SpecialNotes     string
	// SeedFromCard applies the surgeon's preference card, where one exists
	// (SRS-OT-016).
	SeedFromCard bool
}

// RequestResult is a request and what it still needs.
type RequestResult struct {
	Case domain.Case
	// Outstanding is the fields that keep it out of the schedulable state.
	// Returned rather than raised as an error: a surgeon who cannot put a
	// patient on a list at all is a surgeon keeping a paper list.
	Outstanding []string
}

// Request raises a surgery request (SRS-OT-002).
func (s *Service) Request(ctx context.Context, in RequestInput) (RequestResult, error) {
	session, scope, err := s.authorize(ctx, PermRequest)
	if err != nil {
		return RequestResult{}, err
	}

	now := s.clock.Now()
	var out RequestResult

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patientID, err := s.requireWritableEncounter(ctx, scope, in.EncounterID)
		if err != nil {
			return err
		}

		sideRequired, err := s.sideRequired(ctx, scope, in.ProcedureCode)
		if err != nil {
			return err
		}

		surgeon := trimmed(in.SurgeonID, session.SubjectID)
		c, outstanding, err := domain.NewCase(s.ids.NewID(), scope.TenantID(),
			domain.NewCaseInput{
				EncounterID: in.EncounterID,
				// The encounter is authoritative for the patient. A theatre
				// that took the caller's word could book somebody else's
				// encounter.
				PatientID:        trimmed(patientID, in.PatientID),
				FacilityID:       trimmed(in.FacilityID, session.ActiveFacilityID),
				ProcedureCode:    in.ProcedureCode,
				ProcedureDisplay: in.ProcedureDisplay,
				DiagnosisCode:    in.DiagnosisCode,
				DiagnosisDisplay: in.DiagnosisDisplay,
				Laterality:       in.Laterality,
				Site:             in.Site,
				Urgency:          in.Urgency,
				ExpectedDuration: in.ExpectedDuration,
				SurgeonID:        surgeon,
				Team:             in.Team,
				Requirements:     in.Requirements,
				AnaesthesiaType:  in.AnaesthesiaType,
				SpecialNotes:     in.SpecialNotes,
				SideRequired:     sideRequired,
			}, session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}

		if in.SeedFromCard {
			card, found, err := s.cases.Card(ctx, scope, surgeon, in.ProcedureCode)
			if err != nil {
				return err
			}
			if found {
				// Additive, and never a constraint on what is actually used.
				card.Seed(&c)
			}
		}

		if err := s.schedule.InsertCase(ctx, scope, c); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventCaseRequested,
			"theatre_case", c.ID, map[string]any{
				"case_id":        c.ID,
				"encounter_id":   c.EncounterID,
				"patient_id":     c.PatientID,
				"facility_id":    c.FacilityID,
				"procedure_code": c.ProcedureCode,
				"urgency":        string(c.Urgency),
				"requested_at":   c.RequestedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = RequestResult{Case: c, Outstanding: outstanding}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRequest,
			ResourceType: "theatre_case", ResourceID: c.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "surgery requested: " + c.ProcedureCode,
		}, now)
	})
	if err != nil {
		return RequestResult{}, err
	}
	return out, nil
}

func (s *Service) requireWritableEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID string) (string, error) {

	if s.encounters == nil {
		return "", nil
	}
	patientID, writable, err := s.encounters.Writable(ctx, scope, encounterID)
	if err != nil {
		return "", err
	}
	if !writable {
		return "", rpcerr.FailedPrecondition("OT_ENCOUNTER_CLOSED",
			"this encounter no longer accepts content")
	}
	return patientID, nil
}

// CompleteRequest fills in a request's missing fields (SRS-OT-002).
func (s *Service) CompleteRequest(ctx context.Context, caseID string,
	in RequestInput) (RequestResult, error) {

	session, scope, err := s.authorize(ctx, PermRequest)
	if err != nil {
		return RequestResult{}, err
	}

	now := s.clock.Now()
	var out RequestResult

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.openCase(ctx, scope, caseID)
		if err != nil {
			return err
		}
		sideRequired, err := s.sideRequired(ctx, scope, c.ProcedureCode)
		if err != nil {
			return err
		}

		expected := c.Version
		if err := c.Complete(domain.NewCaseInput{
			DiagnosisCode: in.DiagnosisCode, DiagnosisDisplay: in.DiagnosisDisplay,
			Laterality: in.Laterality, Site: in.Site,
			ExpectedDuration: in.ExpectedDuration, SurgeonID: in.SurgeonID,
			Team: in.Team, Requirements: in.Requirements,
		}, sideRequired, now); err != nil {
			return theatreError(err)
		}
		if err := s.schedule.UpdateCase(ctx, scope, c, expected); err != nil {
			return theatreError(err)
		}

		out = RequestResult{Case: c, Outstanding: c.Outstanding(sideRequired)}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRequest,
			ResourceType: "theatre_case", ResourceID: c.ID,
			Outcome: audit.OutcomeSuccess, Reason: "surgery request completed",
		}, now)
	})
	if err != nil {
		return RequestResult{}, err
	}
	return out, nil
}

// Case reads one case.
func (s *Service) Case(ctx context.Context, caseID string) (domain.Case, error) {
	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return domain.Case{}, err
	}
	return s.schedule.Case(ctx, scope, caseID)
}

// Reprioritise changes a case's urgency (SRS-OT-003).
func (s *Service) Reprioritise(ctx context.Context, caseID string,
	urgency domain.Urgency, reason string) (domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermReprioritise)
	if err != nil {
		return domain.Case{}, err
	}

	now := s.clock.Now()
	var out domain.Case

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.openCase(ctx, scope, caseID)
		if err != nil {
			return err
		}
		was := c.Urgency
		expected := c.Version
		if err := c.Reprioritise(urgency, reason, now); err != nil {
			return theatreError(err)
		}
		if err := s.schedule.UpdateCase(ctx, scope, c, expected); err != nil {
			return theatreError(err)
		}

		out = c
		// Audited with the reason, because "priority changes require
		// actor/reason and are audited" is the requirement's own clause and
		// the reason is what the audit is for.
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermReprioritise,
			ResourceType: "theatre_case", ResourceID: c.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "priority " + string(was) + " to " + string(urgency) +
				": " + reason,
		}, now)
	})
	if err != nil {
		return domain.Case{}, err
	}
	return out, nil
}

// ScheduleInput books a case into a room.
type ScheduleInput struct {
	CaseID string
	RoomID string
	Start  time.Time
	End    time.Time
	// Override books despite a soft conflict, and needs its own permission.
	Override bool
	// OverrideReason is required when overriding: a list that overran is
	// traced back to this decision.
	OverrideReason string
}

// ScheduleResult is a booking attempt.
type ScheduleResult struct {
	Case domain.Case
	// Conflicts is every clash, whether or not the booking went ahead.
	// Returned in both cases, so a scheduler who overrode one still sees what
	// they overrode.
	Conflicts []domain.ScheduleConflict
	Booked    bool
}

// CheckSlot reports what would stop a booking, without making one
// (SRS-OT-004).
func (s *Service) CheckSlot(ctx context.Context, in ScheduleInput) (
	[]domain.ScheduleConflict, error) {

	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}

	c, err := s.schedule.Case(ctx, scope, in.CaseID)
	if err != nil {
		return nil, err
	}
	conflicts, _, err := s.conflictsFor(ctx, scope, c, in)
	return conflicts, err
}

func (s *Service) conflictsFor(ctx context.Context, scope authctx.TenantScope,
	c domain.Case, in ScheduleInput) ([]domain.ScheduleConflict, domain.Room, error) {

	room, err := s.schedule.Room(ctx, scope, in.RoomID)
	if err != nil {
		return nil, domain.Room{}, err
	}

	// A window wide enough to catch a case that starts before this one and
	// runs into it.
	from, to := in.Start.Add(-12*time.Hour), in.End.Add(12*time.Hour)

	booked, err := s.schedule.RoomCases(ctx, scope, in.RoomID, from, to)
	if err != nil {
		return nil, domain.Room{}, err
	}
	blocks, err := s.schedule.Blocks(ctx, scope, room.FacilityID, from, to)
	if err != nil {
		return nil, domain.Room{}, err
	}

	var surgeonBusy []domain.Case
	if c.SurgeonID != "" {
		surgeonBusy, err = s.schedule.SurgeonCases(ctx, scope, c.SurgeonID, from, to)
		if err != nil {
			return nil, domain.Room{}, err
		}
	}

	conflicts := c.CheckSlot(domain.ScheduleRequest{
		RoomID: in.RoomID, Start: in.Start, End: in.End,
	}, domain.SchedulingContext{
		Room: room, Booked: booked, Blocks: blocks, SurgeonBusy: surgeonBusy,
	}, s.clock.Now())

	return conflicts, room, nil
}

// Schedule books a case into a room (SRS-OT-004).
func (s *Service) Schedule(ctx context.Context, in ScheduleInput) (
	ScheduleResult, error) {

	permission := PermSchedule
	if in.Override {
		permission = PermOverride
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return ScheduleResult{}, err
	}
	if in.Override && trimmed(in.OverrideReason) == "" {
		// A list that overran is traced back to this decision.
		return ScheduleResult{}, rpcerr.Invalid("OT_OVERRIDE_NEEDS_A_REASON",
			"overriding a scheduling conflict needs a reason")
	}

	now := s.clock.Now()
	var out ScheduleResult

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.openCase(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		conflicts, _, err := s.conflictsFor(ctx, scope, c, in)
		if err != nil {
			return err
		}
		out.Conflicts = conflicts

		expected := c.Version
		if err := c.Schedule(domain.ScheduleRequest{
			RoomID: in.RoomID, Start: in.Start, End: in.End,
		}, conflicts, in.Override, now); err != nil {
			return theatreError(err)
		}
		if err := s.schedule.UpdateCase(ctx, scope, c, expected); err != nil {
			return theatreError(err)
		}

		if err := s.appendEvent(ctx, session, EventCaseScheduled,
			"theatre_case", c.ID, map[string]any{
				"case_id":     c.ID,
				"patient_id":  c.PatientID,
				"facility_id": c.FacilityID,
				"room_id":     c.RoomID,
				"surgeon_id":  c.SurgeonID,
				"urgency":     string(c.Urgency),
				"starts_at":   c.ScheduledStart.Format(time.RFC3339),
				"ends_at":     c.ScheduledEnd.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		reason := "scheduled"
		if in.Override {
			reason = "scheduled over " + explainAll(conflicts) + ": " + in.OverrideReason
		}
		out.Case, out.Booked = c, true
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "theatre_case", ResourceID: c.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return ScheduleResult{}, err
	}
	return out, nil
}

func explainAll(conflicts []domain.ScheduleConflict) string {
	out := ""
	for i, conflict := range conflicts {
		if i > 0 {
			out += "; "
		}
		out += conflict.Explain()
	}
	if out == "" {
		return "no conflicts"
	}
	return out
}

// CloseInput takes a case off the list.
type CloseInput struct {
	CaseID string
	// Postpone rebooks later; otherwise the case is cancelled outright.
	Postpone bool
	Outcome  domain.CaseOutcome
	Reason   string
	Note     string
}

// Close postpones or cancels a case (SRS-OT-005).
func (s *Service) Close(ctx context.Context, in CloseInput) (domain.Case, error) {
	session, scope, err := s.authorize(ctx, PermCancel)
	if err != nil {
		return domain.Case{}, err
	}

	now := s.clock.Now()
	var out domain.Case

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.openCase(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		expected := c.Version
		if in.Postpone {
			err = c.Postpone(in.Outcome, in.Reason, in.Note, now)
		} else {
			err = c.Cancel(in.Outcome, in.Reason, in.Note, now)
		}
		if err != nil {
			return theatreError(err)
		}
		if err := s.schedule.UpdateCase(ctx, scope, c, expected); err != nil {
			return theatreError(err)
		}

		if err := s.appendEvent(ctx, session, EventCaseCancelled,
			"theatre_case", c.ID, map[string]any{
				"case_id":     c.ID,
				"patient_id":  c.PatientID,
				"facility_id": c.FacilityID,
				"status":      string(c.Status),
				// The coded cause travels. The specific reason does not: "no
				// critical care bed" is operational and "patient declined" is
				// the patient's, and an event stream should carry the first
				// without the second.
				"cause":       string(c.Outcome),
				"occurred_at": now.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = c
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCancel,
			ResourceType: "theatre_case", ResourceID: c.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(c.Status) + " (" + string(c.Outcome) + "): " + c.OutcomeReason,
		}, now)
	})
	if err != nil {
		return domain.Case{}, err
	}
	return out, nil
}

// Waiting is the surgical waiting list (SRS-OT-005).
func (s *Service) Waiting(ctx context.Context, facilityID string, pageSize int32) (
	[]domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	cases, err := s.schedule.Waiting(ctx, scope,
		trimmed(facilityID, session.ActiveFacilityID), clampPageSize(pageSize))
	if err != nil {
		return nil, err
	}
	// Ordered here rather than in SQL, because urgency-then-wait is the
	// department's rule and a clinician should be able to read it.
	return domain.WaitingList(cases), nil
}
