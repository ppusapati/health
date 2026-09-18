package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
)

// IssuePack sends a sterile pack out (SRS-CSSD-008, SRS-CSSD-009).
//
// The release and expiry checks run here, from the row read here. A client
// that had read the shelf a minute ago cannot issue a pack that expired since,
// and a label printed earlier is not evidence of anything.
func (s *Service) IssuePack(ctx context.Context, in domain.NewIssueInput) (
	domain.Issue, error) {

	session, scope, err := s.authorize(ctx, PermIssue)
	if err != nil {
		return domain.Issue{}, err
	}
	now := s.clock.Now()

	var out domain.Issue
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		run, err := s.runs.Run(ctx, scope, in.RunID)
		if err != nil {
			return err
		}
		issue, err := domain.IssuePack(
			s.ids.NewID(), session.TenantID, in, run, session.SubjectID, now)
		if err != nil {
			return sterileError(err)
		}
		if err := s.distribution.InsertIssue(ctx, scope, issue); err != nil {
			return err
		}
		out = issue

		if err := s.appendEvent(ctx, session, EventPackIssued,
			"sterile_run", run.ID, map[string]any{
				"set_code":    run.SetCode,
				"cycle_id":    run.CycleID,
				"destination": issue.Destination,
				"expires_at":  run.ExpiresAt,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIssue,
			ResourceType: "sterile_issue", ResourceID: issue.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  run.SetCode + " issued to " + issue.Destination,
		}, now)
	})
	if err != nil {
		return domain.Issue{}, err
	}
	return out, nil
}

// MarkUsed records a pack opened for a case (SRS-CSSD-009, SRS-CSSD-010).
//
// This is the link the case trace runs along, so the case has to be one the
// theatre knows: a trace built on an identifier nobody can resolve reaches no
// patient.
func (s *Service) MarkUsed(ctx context.Context, issueID, caseID string) (
	domain.Issue, error) {

	session, scope, err := s.authorize(ctx, PermIssue)
	if err != nil {
		return domain.Issue{}, err
	}
	now := s.clock.Now()

	if err := s.knownCase(ctx, scope, caseID); err != nil {
		return domain.Issue{}, err
	}

	var out domain.Issue
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		issue, err := s.distribution.Issue(ctx, scope, issueID)
		if err != nil {
			return err
		}
		if err := issue.MarkUsed(caseID, session.SubjectID, now); err != nil {
			return sterileError(err)
		}
		if err := s.distribution.UpdateIssue(ctx, scope, issue); err != nil {
			return err
		}
		out = issue

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIssue,
			ResourceType: "sterile_issue", ResourceID: issue.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  issue.SetCode + " opened for case " + caseID,
		}, now)
	})
	if err != nil {
		return domain.Issue{}, err
	}
	return out, nil
}

// ReturnResult is what a return produced.
type ReturnResult struct {
	Issue domain.Issue
	// Short names the codes that came back in fewer numbers than the list
	// expects. The moment a set is counted back is the last moment anybody can
	// say where a missing instrument was.
	Short []string
}

// ReturnPack records a pack coming back unopened (SRS-CSSD-009).
func (s *Service) ReturnPack(ctx context.Context, issueID string,
	counted map[string]int, note string) (ReturnResult, error) {

	session, scope, err := s.authorize(ctx, PermIssue)
	if err != nil {
		return ReturnResult{}, err
	}
	now := s.clock.Now()

	var out ReturnResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		issue, err := s.distribution.Issue(ctx, scope, issueID)
		if err != nil {
			return err
		}
		run, err := s.runs.Run(ctx, scope, issue.RunID)
		if err != nil {
			return err
		}
		// The version the pack was assembled against, not whatever is
		// current: a revision published since would make the count wrong.
		set, err := s.master.Set(ctx, scope, run.SetID)
		if err != nil {
			return err
		}

		short, err := issue.Return(
			counted, note, session.SubjectID, set, now)
		if err != nil {
			return sterileError(err)
		}
		if err := s.distribution.UpdateIssue(ctx, scope, issue); err != nil {
			return err
		}
		out = ReturnResult{Issue: issue, Short: short}

		reason := issue.SetCode + " returned from " + issue.Destination
		if len(short) > 0 {
			reason += "; short: " + join(short)
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIssue,
			ResourceType: "sterile_issue", ResourceID: issue.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return ReturnResult{}, err
	}
	return out, nil
}

// Outstanding reads what is out, so a recall knows where to go
// (SRS-CSSD-009).
func (s *Service) Outstanding(ctx context.Context, destination string,
	limit int32) ([]domain.Issue, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.distribution.Outstanding(
		ctx, scope, destination, clampPageSize(limit))
}

// TraceCase assembles everything a patient's operation touched
// (SRS-CSSD-010).
//
// Its own permission and audited: the answer names every set and every
// sterilizer cycle a patient was exposed to, which is a different kind of read
// from looking at a shelf.
func (s *Service) TraceCase(ctx context.Context, caseID string) (
	domain.CaseTrace, error) {

	session, scope, err := s.authorize(ctx, PermTrace)
	if err != nil {
		return domain.CaseTrace{}, err
	}
	now := s.clock.Now()

	issues, err := s.distribution.IssuesForCase(ctx, scope, caseID)
	if err != nil {
		return domain.CaseTrace{}, err
	}

	runs := map[string]domain.Run{}
	cycles := map[string]domain.Cycle{}
	for _, issue := range issues {
		if _, seen := runs[issue.RunID]; seen {
			continue
		}
		run, err := s.runs.Run(ctx, scope, issue.RunID)
		if err != nil {
			// A pack whose run has gone is a gap the trace names rather than a
			// failure: the other sets in the case still have to be reported.
			continue
		}
		runs[run.ID] = run
		if run.CycleID == "" {
			continue
		}
		if _, seen := cycles[run.CycleID]; seen {
			continue
		}
		if cycle, err := s.cycles.Cycle(ctx, scope, run.CycleID); err == nil {
			cycles[cycle.ID] = cycle
		}
	}

	trace := domain.BuildCaseTrace(caseID, issues, runs, cycles)

	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermTrace,
		ResourceType: "theatre_case", ResourceID: caseID,
		Outcome: audit.OutcomeSuccess,
		Reason:  "case trace reached " + itoa(len(trace.Sets)) + " set(s)",
	}, now); err != nil {
		return domain.CaseTrace{}, err
	}
	return trace, nil
}

// RecallScope reports what a load reaches, without raising anything
// (SRS-CSSD-011).
func (s *Service) RecallScope(ctx context.Context, cycleID string) (
	domain.RecallScope, error) {

	_, scope, err := s.authorize(ctx, PermTrace)
	if err != nil {
		return domain.RecallScope{}, err
	}
	return s.buildScope(ctx, scope, cycleID, "")
}

func (s *Service) buildScope(ctx context.Context, scope authctx.TenantScope,
	cycleID, reason string) (domain.RecallScope, error) {

	cycle, err := s.cycles.Cycle(ctx, scope, cycleID)
	if err != nil {
		return domain.RecallScope{}, err
	}
	runs, err := s.runs.RunsForCycle(ctx, scope, cycle.ID)
	if err != nil {
		return domain.RecallScope{}, err
	}
	issues, err := s.distribution.IssuesForCycle(ctx, scope, cycle.ID)
	if err != nil {
		return domain.RecallScope{}, err
	}

	byRun := map[string][]domain.Issue{}
	for _, issue := range issues {
		byRun[issue.RunID] = append(byRun[issue.RunID], issue)
	}
	return domain.BuildRecall(cycle, reason, runs, byRun), nil
}

// RaiseRecall pulls a load back (SRS-CSSD-011).
//
// Every pack in the load is recalled, including the ones already opened. Those
// cannot come back — they went into a patient — but the case list is the
// reason the recall exists, and removing them would be the one thing it must
// not do.
func (s *Service) RaiseRecall(ctx context.Context, cycleID, reason string) (
	ports.Recall, domain.RecallScope, error) {

	session, scope, err := s.authorize(ctx, PermRecall)
	if err != nil {
		return ports.Recall{}, domain.RecallScope{}, err
	}
	now := s.clock.Now()

	if reason == "" {
		return ports.Recall{}, domain.RecallScope{}, rpcerr.Invalid(
			"CSSD_INVALID", "a recall records why it was raised")
	}

	var recall ports.Recall
	var built domain.RecallScope

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		built, err = s.buildScope(ctx, scope, cycleID, reason)
		if err != nil {
			return err
		}

		issues, err := s.distribution.IssuesForCycle(ctx, scope, cycleID)
		if err != nil {
			return err
		}
		for _, issue := range issues {
			if issue.State == domain.IssueRecalled {
				continue
			}
			if err := issue.Recall(session.SubjectID, now); err != nil {
				return sterileError(err)
			}
			if err := s.distribution.UpdateIssue(ctx, scope, issue); err != nil {
				return err
			}
		}

		recall = ports.Recall{
			ID: s.ids.NewID(), TenantID: session.TenantID, CycleID: cycleID,
			Reason: reason,
			// Frozen here, because the packs move afterwards and a recall
			// report has to say what it found.
			PacksAffected: len(built.Packs),
			CasesAffected: len(built.Cases),
			RaisedAt:      now, RaisedBy: session.SubjectID,
		}
		if err := s.distribution.InsertRecall(ctx, scope, recall); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventRecallRaised,
			"sterile_cycle", cycleID, map[string]any{
				"load_number": built.LoadNumber,
				"reason":      reason,
				"packs":       len(built.Packs),
				"cases":       len(built.Cases),
				"locations":   built.Locations,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRecall,
			ResourceType: "sterile_cycle", ResourceID: cycleID,
			Outcome: audit.OutcomeSuccess,
			Reason: "recall of load " + built.LoadNumber + ": " + reason +
				"; " + itoa(len(built.Packs)) + " pack(s), " +
				itoa(len(built.Cases)) + " case(s)",
		}, now)
	})
	if err != nil {
		return ports.Recall{}, domain.RecallScope{}, err
	}

	// Raised outside the transaction that wrote it, so that a failure to page
	// cannot roll the recall back: the record of what was pulled is worth more
	// than the notice, and losing both is the worst outcome.
	if err := s.escalateRecall(ctx, scope, built, now); err != nil {
		return ports.Recall{}, domain.RecallScope{}, err
	}
	return recall, built, nil
}

// escalateRecall tells the wards and infection control (SRS-CSSD-011).
func (s *Service) escalateRecall(ctx context.Context, scope authctx.TenantScope,
	built domain.RecallScope, now time.Time) error {

	if s.escalations == nil {
		return nil
	}
	summary := "Sterile load " + built.LoadNumber + " recalled: " +
		built.Reason + ". " + itoa(len(built.Packs)) + " pack(s) affected, " +
		itoa(len(built.Cases)) + " case(s) already exposed."
	if len(built.Locations) > 0 {
		summary += " Packs are at: " + join(built.Locations) + "."
	}

	_, err := s.escalations.Raise(ctx, scope, ports.Notice{
		Kind:    EscalationKind,
		Subject: "load " + built.LoadNumber,
		Summary: summary,
	}, now)
	return err
}

// CloseRecall ends a recall (SRS-CSSD-011).
func (s *Service) CloseRecall(ctx context.Context, recallID, note string) error {
	session, scope, err := s.authorize(ctx, PermRecall)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		closed, err := s.distribution.CloseRecall(
			ctx, scope, recallID, note, session.SubjectID, now)
		if err != nil {
			return err
		}
		if !closed {
			return rpcerr.FailedPrecondition("CSSD_RECALL_CLOSED",
				"this recall is already closed")
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRecall,
			ResourceType: "sterile_recall", ResourceID: recallID,
			Outcome: audit.OutcomeSuccess, Reason: "recall closed: " + note,
		}, now)
	})
}

// OpenRecalls is the department's outstanding list (SRS-CSSD-011).
func (s *Service) OpenRecalls(ctx context.Context, limit int32) (
	[]ports.Recall, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.distribution.OpenRecalls(ctx, scope, clampPageSize(limit))
}
