package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/quality/domain"
)

// PlanAudit schedules an internal audit (SRS-QMS-007).
//
// Refused where the auditor is auditing their own department. An audit of your
// own work is a self-assessment, and calling it an audit is how a hospital
// arrives at a survey believing it has an audit programme.
func (s *Service) PlanAudit(ctx context.Context, in domain.NewAuditInput) (
	domain.Audit, error) {

	session, scope, err := s.authorize(ctx, PermAudit)
	if err != nil {
		return domain.Audit{}, err
	}
	now := s.clock.Now()

	plan, err := domain.PlanAudit(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.Audit{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if plan.StandardID != "" {
			if _, err := s.accreditation.Standard(ctx, scope,
				plan.StandardID); err != nil {
				return err
			}
		}
		if err := s.audits.InsertAudit(ctx, scope, plan); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.audit.plan", ResourceType: "qms_audit",
			ResourceID: plan.ID, Outcome: audit.OutcomeSuccess,
			Reason: plan.Title + " over " + plan.Scope,
		}, now)
	})
	if err != nil {
		return domain.Audit{}, qualityError(err)
	}
	return plan, nil
}

// RecordFinding records what an audit found (SRS-QMS-007).
func (s *Service) RecordFinding(ctx context.Context,
	in domain.NewFindingInput) (domain.Finding, error) {

	session, scope, err := s.authorize(ctx, PermAudit)
	if err != nil {
		return domain.Finding{}, err
	}
	now := s.clock.Now()

	var finding domain.Finding
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.audits.Audit(ctx, scope, in.AuditID)
		if err != nil {
			return err
		}
		if plan.State == domain.AuditClosed ||
			plan.State == domain.AuditCancelled {
			return rpcerr.FailedPrecondition("QMS_AUDIT_CLOSED",
				"this audit is "+string(plan.State))
		}

		finding, err = domain.RecordFinding(s.ids.NewID(), session.TenantID,
			in, session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.audits.InsertFinding(ctx, scope, finding); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.audit.finding", ResourceType: "qms_audit_finding",
			ResourceID: finding.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(finding.Severity) + ": " + finding.Detail,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventFindingRaised,
			"qms_audit_finding", finding.ID, map[string]any{
				"finding_id": finding.ID,
				"audit_id":   finding.AuditID,
				"severity":   string(finding.Severity),
				"clause_id":  finding.ClauseID,
			}, now)
	})
	if err != nil {
		return domain.Finding{}, qualityError(err)
	}
	return finding, nil
}

// LinkFindingAction attaches the corrective action a finding will close
// through (SRS-QMS-007).
func (s *Service) LinkFindingAction(ctx context.Context, findingID,
	capaID string) (domain.Finding, error) {

	session, scope, err := s.authorize(ctx, PermAudit)
	if err != nil {
		return domain.Finding{}, err
	}
	now := s.clock.Now()

	var updated domain.Finding
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		finding, err := s.audits.Finding(ctx, scope, findingID)
		if err != nil {
			return err
		}
		// The action has to exist, or a non-conformity could be "linked" to
		// nothing and then closed against it.
		if _, err := s.actions.CAPA(ctx, scope, capaID); err != nil {
			return err
		}
		if err := finding.LinkAction(capaID); err != nil {
			return err
		}
		if err := s.audits.UpdateFinding(ctx, scope, finding); err != nil {
			return err
		}
		updated = finding
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.audit.link_action",
			ResourceType: "qms_audit_finding", ResourceID: finding.ID,
			Outcome: audit.OutcomeSuccess, Reason: capaID,
		}, now)
	})
	if err != nil {
		return domain.Finding{}, qualityError(err)
	}
	return updated, nil
}

// CloseFinding signs a finding off (SRS-QMS-007).
//
// The corrective action is read here rather than trusted from the request, so
// "closed through a closed action" means the action is actually closed rather
// than that the caller said it was.
func (s *Service) CloseFinding(ctx context.Context, findingID, note string) (
	domain.Finding, error) {

	session, scope, err := s.authorize(ctx, PermAudit)
	if err != nil {
		return domain.Finding{}, err
	}
	now := s.clock.Now()

	var updated domain.Finding
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		finding, err := s.audits.Finding(ctx, scope, findingID)
		if err != nil {
			return err
		}

		var action *domain.CAPA
		if finding.CAPAID != "" {
			capa, err := s.actions.CAPA(ctx, scope, finding.CAPAID)
			if err != nil {
				return err
			}
			action = &capa
		}

		if err := finding.CloseFinding(action, note, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.audits.UpdateFinding(ctx, scope, finding); err != nil {
			return err
		}
		updated = finding
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.audit.close_finding",
			ResourceType: "qms_audit_finding", ResourceID: finding.ID,
			Outcome: audit.OutcomeSuccess, Reason: note,
		}, now)
	})
	if err != nil {
		return domain.Finding{}, qualityError(err)
	}
	return updated, nil
}

// ReportAudit records the auditor's conclusion (SRS-QMS-007).
func (s *Service) ReportAudit(ctx context.Context, auditID, summary string,
	expectedVersion int64) (domain.Audit, error) {

	session, scope, err := s.authorize(ctx, PermAudit)
	if err != nil {
		return domain.Audit{}, err
	}
	now := s.clock.Now()

	var updated domain.Audit
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.audits.Audit(ctx, scope, auditID)
		if err != nil {
			return err
		}
		if err := plan.ReportAudit(summary, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.audits.UpdateAudit(ctx, scope, plan,
			expectedVersion); err != nil {
			return err
		}
		plan.Version = expectedVersion + 1
		updated = plan
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.audit.report", ResourceType: "qms_audit",
			ResourceID: plan.ID, Outcome: audit.OutcomeSuccess, Reason: summary,
		}, now)
	})
	if err != nil {
		return domain.Audit{}, qualityError(err)
	}
	return updated, nil
}

// CloseAudit signs an audit off (SRS-QMS-007).
//
// The findings are read here, so "no findings are open" means what the
// database says rather than what the caller believes.
func (s *Service) CloseAudit(ctx context.Context, auditID string,
	expectedVersion int64) (domain.Audit, error) {

	session, scope, err := s.authorize(ctx, PermAudit)
	if err != nil {
		return domain.Audit{}, err
	}
	now := s.clock.Now()

	var updated domain.Audit
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.audits.Audit(ctx, scope, auditID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordAudit,
			plan.ID); err != nil {
			return err
		}
		findings, err := s.audits.Findings(ctx, scope, plan.ID, false)
		if err != nil {
			return err
		}
		if err := plan.CloseAudit(findings, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.audits.UpdateAudit(ctx, scope, plan,
			expectedVersion); err != nil {
			return err
		}
		plan.Version = expectedVersion + 1
		updated = plan
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.audit.close", ResourceType: "qms_audit",
			ResourceID: plan.ID, Outcome: audit.OutcomeSuccess,
			Reason: itoa(len(findings)) + " finding(s), all closed",
		}, now)
	})
	if err != nil {
		return domain.Audit{}, qualityError(err)
	}
	return updated, nil
}

// Audit reads one plan.
func (s *Service) Audit(ctx context.Context, id string) (domain.Audit, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Audit{}, err
	}
	plan, err := s.audits.Audit(ctx, scope, id)
	if err != nil {
		return domain.Audit{}, qualityError(err)
	}
	return plan, nil
}

// Audits lists the programme.
func (s *Service) Audits(ctx context.Context, state string, pageSize int32) (
	[]domain.Audit, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	plans, err := s.audits.Audits(ctx, scope, state, clampPageSize(pageSize))
	if err != nil {
		return nil, qualityError(err)
	}
	return plans, nil
}

// Findings lists what an audit found, or everything still open.
func (s *Service) Findings(ctx context.Context, auditID string,
	openOnly bool) ([]domain.Finding, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	findings, err := s.audits.Findings(ctx, scope, auditID, openOnly)
	if err != nil {
		return nil, qualityError(err)
	}
	return findings, nil
}

// FormCommitteeInput registers a standing group.
type FormCommitteeInput struct {
	Code       string
	Name       string
	Terms      string
	QuorumSize int
	Restricted bool
	Members    []string
}

// FormCommittee registers a standing group (SRS-QMS-008).
func (s *Service) FormCommittee(ctx context.Context, in FormCommitteeInput) (
	domain.Committee, error) {

	session, scope, err := s.authorize(ctx, PermCommittee)
	if err != nil {
		return domain.Committee{}, err
	}
	if in.QuorumSize > len(in.Members) {
		// A quorum larger than the membership is a committee that can never
		// decide anything, which somebody will discover in a meeting.
		return domain.Committee{}, rpcerr.Invalid("QMS_QUORUM_UNREACHABLE",
			"the quorum is larger than the committee")
	}
	now := s.clock.Now()

	committee := domain.Committee{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		Code: in.Code, Name: in.Name, Terms: in.Terms,
		QuorumSize: in.QuorumSize, Restricted: in.Restricted,
		Members: in.Members, Active: true,
		CreatedAt: now.UTC(), CreatedBy: session.SubjectID, Version: 1,
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.committees.InsertCommittee(ctx, scope,
			committee); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.committee.form", ResourceType: "qms_committee",
			ResourceID: committee.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Code + ", quorum " + itoa(in.QuorumSize),
		}, now)
	})
	if err != nil {
		return domain.Committee{}, qualityError(err)
	}
	return committee, nil
}

// ScheduleMeeting books a sitting (SRS-QMS-008).
func (s *Service) ScheduleMeeting(ctx context.Context, committeeID string,
	at time.Time, agenda []string) (domain.Meeting, error) {

	session, scope, err := s.authorize(ctx, PermCommittee)
	if err != nil {
		return domain.Meeting{}, err
	}
	now := s.clock.Now()

	var meeting domain.Meeting
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		committee, err := s.committees.Committee(ctx, scope, committeeID)
		if err != nil {
			return err
		}
		meeting = domain.Meeting{
			ID: s.ids.NewID(), TenantID: session.TenantID,
			CommitteeID: committee.ID, ScheduledAt: at.UTC(),
			Agenda: agenda, State: domain.MeetingScheduled,
			// A restricted committee's minutes are restricted. Peer review
			// happens in a room, and the minutes are the room.
			Restricted: committee.Restricted,
			CreatedAt:  now.UTC(), CreatedBy: session.SubjectID, Version: 1,
		}
		if err := s.committees.InsertMeeting(ctx, scope, meeting); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.committee.schedule",
			ResourceType: "qms_committee_meeting", ResourceID: meeting.ID,
			Outcome: audit.OutcomeSuccess, Reason: committee.Code,
		}, now)
	})
	if err != nil {
		return domain.Meeting{}, qualityError(err)
	}
	return meeting, nil
}

// RecordMinutesInput writes up a sitting.
type RecordMinutesInput struct {
	MeetingID       string
	HeldAt          time.Time
	Attendees       []string
	Apologies       []string
	Minutes         string
	Decisions       []domain.Decision
	Approve         bool
	ExpectedVersion int64
}

// RecordMinutes writes up a sitting and optionally approves it
// (SRS-QMS-008).
//
// The quorum check reads the committee, so "quorate" means against the actual
// membership rather than against a number in the request.
func (s *Service) RecordMinutes(ctx context.Context, in RecordMinutesInput) (
	domain.Meeting, error) {

	session, scope, err := s.authorize(ctx, PermCommittee)
	if err != nil {
		return domain.Meeting{}, err
	}
	now := s.clock.Now()

	var updated domain.Meeting
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		meeting, err := s.committees.Meeting(ctx, scope, in.MeetingID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordMeeting,
			meeting.ID); err != nil {
			return err
		}
		committee, err := s.committees.Committee(ctx, scope,
			meeting.CommitteeID)
		if err != nil {
			return err
		}

		heldAt := in.HeldAt
		if heldAt.IsZero() {
			heldAt = now
		}
		if meeting.State == domain.MeetingScheduled {
			if err := meeting.HoldMeeting(in.Attendees, in.Apologies,
				in.Minutes, in.Decisions, heldAt); err != nil {
				return err
			}
		}
		if in.Approve {
			if err := meeting.ApproveMinutes(committee, session.SubjectID,
				now); err != nil {
				return err
			}
		}

		if err := s.committees.UpdateMeeting(ctx, scope, meeting,
			in.ExpectedVersion); err != nil {
			return err
		}
		meeting.Version = in.ExpectedVersion + 1
		updated = meeting

		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.committee.minutes",
			ResourceType: "qms_committee_meeting", ResourceID: meeting.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: itoa(len(meeting.Attendees)) + " present, " +
				itoa(len(meeting.Decisions)) + " decision(s), state " +
				string(meeting.State),
		}, now)
	})
	if err != nil {
		return domain.Meeting{}, qualityError(err)
	}
	return updated, nil
}

// Meeting reads one sitting (SRS-QMS-008, SRS-QMS-012).
func (s *Service) Meeting(ctx context.Context, id string) (domain.Meeting,
	error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Meeting{}, err
	}
	now := s.clock.Now()

	meeting, err := s.committees.Meeting(ctx, scope, id)
	if err != nil {
		return domain.Meeting{}, qualityError(err)
	}

	var out domain.Meeting
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		mayRead, err := s.readRestricted(ctx, session, meeting.Restricted,
			"qms_committee_meeting", meeting.ID, now)
		if err != nil {
			return err
		}
		if !mayRead {
			// Minutes are the discussion. There is nothing to redact to.
			return rpcerr.NotFound("QMS_NOT_FOUND", "no such meeting")
		}
		out = meeting
		return nil
	})
	if err != nil {
		return domain.Meeting{}, qualityError(err)
	}
	return out, nil
}

// Committees lists the standing groups.
func (s *Service) Committees(ctx context.Context, activeOnly bool) (
	[]domain.Committee, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	committees, err := s.committees.Committees(ctx, scope, activeOnly)
	if err != nil {
		return nil, qualityError(err)
	}
	return committees, nil
}
