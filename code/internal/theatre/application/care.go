package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/theatre/domain"
)

// The pre-operative checklist (SRS-OT-006), the safety checklist
// (SRS-OT-007), movement (SRS-OT-008), delays (SRS-OT-014) and the operative
// note (SRS-OT-009).

// PreopInput answers one pre-operative item.
type PreopInput struct {
	CaseID string
	Code   string
	State  domain.PreopState
	Note   string
	// WaivedRole is the role claimed for a waiver. The domain checks it
	// against the item; this is what the caller asserts.
	WaivedRole string
}

// RecordPreop answers one pre-operative item (SRS-OT-006).
//
// Waiving needs its own permission as well as the right role. The permission
// says the caller is allowed to waive anything at all; the role says they are
// allowed to waive this. Both, because a system where every gate has a general
// override has no gates.
func (s *Service) RecordPreop(ctx context.Context, in PreopInput) (
	[]domain.Blocker, error) {

	permission := PermRecord
	if in.State == domain.PreopWaived {
		permission = PermWaive
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	var blockers []domain.Blocker

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.openCase(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		checklist, err := s.cases.PreopChecklist(ctx, scope, c.ID)
		if err != nil {
			return err
		}

		entry := domain.PreopEntry{
			Code: in.Code, State: in.State, Note: in.Note,
			WaivedBy: session.SubjectID, WaivedRole: in.WaivedRole,
			RecordedBy: session.SubjectID, RecordedAt: now,
		}
		items := s.config.preopItems()
		if err := checklist.Record(items, entry); err != nil {
			return theatreError(err)
		}
		if err := s.cases.SavePreopEntry(ctx, scope, c.ID, entry); err != nil {
			return err
		}

		blockers = checklist.Blockers(items)

		// A checklist with nothing left moves the case to ready, which is what
		// the board's "next case ready" column reads. Doing it here rather
		// than in a separate call means a theatre cannot have a clear
		// checklist and a case still marked not ready.
		if len(blockers) == 0 && c.Status == domain.CaseScheduled {
			expected := c.Version
			if err := c.MarkReady(now); err != nil {
				return theatreError(err)
			}
			if err := s.schedule.UpdateCase(ctx, scope, c, expected); err != nil {
				return theatreError(err)
			}
		}

		if in.State != domain.PreopWaived {
			return nil
		}
		// Only a waiver is audited. Every other answer is ordinary
		// preparation, and auditing each one would bury the entries that
		// matter in a trail nobody reads.
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermWaive,
			ResourceType: "theatre_case", ResourceID: c.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "waived " + in.Code + " as " + in.WaivedRole + ": " + in.Note,
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return blockers, nil
}

// Blockers is what is stopping a case (SRS-OT-006).
func (s *Service) Blockers(ctx context.Context, caseID string) (
	[]domain.Blocker, error) {

	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	checklist, err := s.cases.PreopChecklist(ctx, scope, caseID)
	if err != nil {
		return nil, err
	}
	return checklist.Blockers(s.config.preopItems()), nil
}

// SafetyInput performs one phase of the safety checklist.
type SafetyInput struct {
	CaseID       string
	Phase        domain.SafetyPhase
	Participants []string
	Answers      []domain.SafetyAnswer
}

// PerformSafety records a sign-in, time-out or sign-out (SRS-OT-007).
func (s *Service) PerformSafety(ctx context.Context, in SafetyInput) (
	domain.SafetyRecord, error) {

	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return domain.SafetyRecord{}, err
	}

	now := s.clock.Now()
	var out domain.SafetyRecord

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.openCase(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		record, err := domain.PerformSafety(s.ids.NewID(), scope.TenantID(), c.ID,
			in.Phase, s.config.safetyItems(), in.Participants, in.Answers,
			session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}
		if err := s.cases.InsertSafetyCheck(ctx, scope, record); err != nil {
			return err
		}

		out = record
		reason := string(in.Phase) + " performed"
		if exceptions := record.Exceptions(); len(exceptions) > 0 {
			reason += " with exceptions"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRecord,
			ResourceType: "theatre_case", ResourceID: c.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.SafetyRecord{}, err
	}
	return out, nil
}

// MilestoneInput times one milestone.
type MilestoneInput struct {
	CaseID     string
	Milestone  domain.Milestone
	OccurredAt time.Time
	Note       string
}

// RecordMilestone times a milestone and moves the case with it (SRS-OT-008).
//
// The state change comes with the milestone rather than as a separate call,
// because a case whose patient is in the room and whose status says scheduled
// is a case the board shows in the wrong place.
func (s *Service) RecordMilestone(ctx context.Context, in MilestoneInput) (
	domain.MilestoneRecord, error) {

	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return domain.MilestoneRecord{}, err
	}

	now := s.clock.Now()
	var out domain.MilestoneRecord

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.openCase(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		record, err := domain.RecordMilestone(s.ids.NewID(), scope.TenantID(), c.ID,
			in.Milestone, in.OccurredAt, session.SubjectID, in.Note, now)
		if err != nil {
			return theatreError(err)
		}
		if err := s.cases.InsertMilestone(ctx, scope, record); err != nil {
			return err
		}

		switch {
		case in.Milestone == domain.MilestoneTheatreIn && c.Status == domain.CaseReady:
			expected := c.Version
			if err := c.Start(now); err != nil {
				return theatreError(err)
			}
			if err := s.schedule.UpdateCase(ctx, scope, c, expected); err != nil {
				return theatreError(err)
			}
		case in.Milestone == domain.MilestoneTheatreOut && c.Status == domain.CaseInTheatre:
			expected := c.Version
			if err := c.CompleteCase(now); err != nil {
				return theatreError(err)
			}
			if err := s.schedule.UpdateCase(ctx, scope, c, expected); err != nil {
				return theatreError(err)
			}
			if err := s.appendEvent(ctx, session, EventCaseCompleted,
				"theatre_case", c.ID, map[string]any{
					"case_id":      c.ID,
					"patient_id":   c.PatientID,
					"facility_id":  c.FacilityID,
					"room_id":      c.RoomID,
					"completed_at": record.OccurredAt.Format(time.RFC3339),
				}, now); err != nil {
				return err
			}
		}

		out = record
		return nil
	})
	if err != nil {
		return domain.MilestoneRecord{}, err
	}
	return out, nil
}

// CaseTimeline is a case's movement and what it implies.
type CaseTimeline struct {
	Milestones domain.Milestones
	Intervals  domain.CaseIntervals
	// OutOfSequence names milestones timed in an order the patient could not
	// have moved in. Reported rather than refused: refusing leaves the real
	// time unrecorded, and ignoring it puts a negative operating time into the
	// theatre's reporting.
	OutOfSequence []string
}

// Timeline reads a case's movement (SRS-OT-008).
func (s *Service) Timeline(ctx context.Context, caseID string) (CaseTimeline, error) {
	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return CaseTimeline{}, err
	}

	c, err := s.schedule.Case(ctx, scope, caseID)
	if err != nil {
		return CaseTimeline{}, err
	}
	milestones, err := s.cases.Milestones(ctx, scope, caseID)
	if err != nil {
		return CaseTimeline{}, err
	}
	return CaseTimeline{
		Milestones:    milestones,
		Intervals:     milestones.Intervals(c.ScheduledStart),
		OutOfSequence: milestones.OutOfSequence(),
	}, nil
}

// DelayInput records a delay.
type DelayInput struct {
	CaseID     string
	Reason     domain.DelayReason
	Dependency string
	Minutes    int
	Note       string
}

// RecordDelay records a delay with its coded cause (SRS-OT-014).
func (s *Service) RecordDelay(ctx context.Context, in DelayInput) (domain.Delay, error) {
	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return domain.Delay{}, err
	}

	now := s.clock.Now()
	var out domain.Delay

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.schedule.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		delay, err := domain.RecordDelay(s.ids.NewID(), scope.TenantID(), c.ID,
			in.Reason, in.Dependency, in.Minutes, in.Note, session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}
		if err := s.cases.InsertDelay(ctx, scope, delay); err != nil {
			return err
		}
		out = delay
		return nil
	})
	if err != nil {
		return domain.Delay{}, err
	}
	return out, nil
}

// NoteInput writes an operative note.
type NoteInput struct {
	CaseID               string
	ProcedurePerformed   string
	Findings             string
	SpecimenIDs          []string
	ImplantIDs           []string
	Complications        []string
	EstimatedBloodLossML int
	PostOperativeOrders  string
	Narrative            string
}

// WriteNote drafts an operative note (SRS-OT-009).
func (s *Service) WriteNote(ctx context.Context, in NoteInput) (
	domain.OperativeNote, error) {

	session, scope, err := s.authorize(ctx, PermRecord)
	if err != nil {
		return domain.OperativeNote{}, err
	}

	now := s.clock.Now()
	var out domain.OperativeNote

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		c, err := s.schedule.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}

		note, err := domain.NewOperativeNote(s.ids.NewID(), scope.TenantID(),
			domain.NewNoteInput{
				CaseID: c.ID, ProcedurePerformed: in.ProcedurePerformed,
				Findings: in.Findings, SpecimenIDs: in.SpecimenIDs,
				ImplantIDs: in.ImplantIDs, Complications: in.Complications,
				EstimatedBloodLossML: in.EstimatedBloodLossML,
				PostOperativeOrders:  in.PostOperativeOrders,
				Narrative:            in.Narrative,
			}, session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}
		if err := s.cases.InsertNote(ctx, scope, note); err != nil {
			return err
		}
		out = note
		return nil
	})
	if err != nil {
		return domain.OperativeNote{}, err
	}
	return out, nil
}

// SignNote signs an operative note (SRS-OT-009).
//
// Its own permission. Signing asserts clinical responsibility for what was
// done; typing the note is data entry, and a scribe who could sign would leave
// the record saying a surgeon asserted something they never read.
func (s *Service) SignNote(ctx context.Context, caseID, noteID string) error {
	session, scope, err := s.authorize(ctx, PermSign)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		signed, err := s.cases.SignNote(ctx, scope, noteID, session.SubjectID, now)
		if err != nil {
			return err
		}
		if !signed {
			return rpcerr.FailedPrecondition("OT_NOTE_NOT_DRAFT",
				"this note is already signed, or there is no such note")
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermSign,
			ResourceType: "theatre_note", ResourceID: noteID,
			Outcome: audit.OutcomeSuccess, Reason: "operative note signed",
		}, now)
	})
}

// AmendNote produces a new version of a signed note (SRS-OT-009).
//
// The amendment and the supersession are one transaction. Either alone leaves
// a case with two current notes or none, and an operative note is the document
// read in a claim.
func (s *Service) AmendNote(ctx context.Context, caseID, noteID, reason string,
	in NoteInput) (domain.OperativeNote, error) {

	session, scope, err := s.authorize(ctx, PermSign)
	if err != nil {
		return domain.OperativeNote{}, err
	}

	now := s.clock.Now()
	var out domain.OperativeNote

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		notes, err := s.cases.Notes(ctx, scope, caseID)
		if err != nil {
			return err
		}

		var original domain.OperativeNote
		found := false
		for _, note := range notes {
			if note.ID == noteID {
				original, found = note, true
			}
		}
		if !found {
			return rpcerr.NotFound("OT_NO_SUCH_NOTE", "no such note on this case")
		}

		amended, err := original.Amend(s.ids.NewID(), domain.NewNoteInput{
			ProcedurePerformed: in.ProcedurePerformed, Findings: in.Findings,
			SpecimenIDs: in.SpecimenIDs, ImplantIDs: in.ImplantIDs,
			Complications:        in.Complications,
			EstimatedBloodLossML: in.EstimatedBloodLossML,
			PostOperativeOrders:  in.PostOperativeOrders,
			Narrative:            in.Narrative,
		}, reason, session.SubjectID, now)
		if err != nil {
			return theatreError(err)
		}

		if err := s.cases.InsertNote(ctx, scope, amended); err != nil {
			return err
		}
		superseded, err := s.cases.SupersedeNote(ctx, scope, original.ID)
		if err != nil {
			return err
		}
		if !superseded {
			return rpcerr.FailedPrecondition("OT_NOTE_ALREADY_SUPERSEDED",
				"somebody amended this note first; re-read it")
		}

		out = amended
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermSign,
			ResourceType: "theatre_note", ResourceID: amended.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "operative note amended: " + reason,
		}, now)
	})
	if err != nil {
		return domain.OperativeNote{}, err
	}
	return out, nil
}

// Notes reads a case's operative notes, every version (SRS-OT-009).
func (s *Service) Notes(ctx context.Context, caseID string) (
	[]domain.OperativeNote, error) {

	_, scope, err := s.authorize(ctx, PermTheatreRead)
	if err != nil {
		return nil, err
	}
	return s.cases.Notes(ctx, scope, caseID)
}
