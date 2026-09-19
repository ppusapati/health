package application

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// StartRCAInput opens an analysis.
type StartRCAInput struct {
	IncidentID string
	Method     string
}

// StartRCA opens a root cause analysis (SRS-QMS-003).
//
// The analysis inherits the incident's restriction. An analysis of a
// restricted incident that is itself readable by everybody is the restriction
// undone by the next screen.
func (s *Service) StartRCA(ctx context.Context, in StartRCAInput) (
	domain.RCA, error) {

	session, scope, err := s.authorize(ctx, PermInvestigate)
	if err != nil {
		return domain.RCA{}, err
	}
	if err := s.approvedMethod(in.Method); err != nil {
		return domain.RCA{}, err
	}
	now := s.clock.Now()

	var rca domain.RCA
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		incident, err := s.incidents.Incident(ctx, scope, in.IncidentID)
		if err != nil {
			return err
		}
		if _, found, err := s.investigations.RCAForIncident(ctx, scope,
			incident.ID); err != nil {
			return err
		} else if found {
			return rpcerr.AlreadyExists("QMS_RCA_EXISTS",
				"this incident already has an analysis")
		}

		rca, err = domain.StartRCA(s.ids.NewID(), session.TenantID,
			incident.ID, in.Method, incident.Restricted, session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.investigations.InsertRCA(ctx, scope, rca); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.rca.start", ResourceType: "qms_rca",
			ResourceID: rca.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Method,
		}, now)
	})
	if err != nil {
		return domain.RCA{}, qualityError(err)
	}
	return rca, nil
}

// approvedMethod refuses a technique the hospital has not approved
// (SRS-QMS-003).
//
// An empty configured set accepts any named method, which is a deployment that
// has not decided rather than one that has decided anything goes.
func (s *Service) approvedMethod(method string) error {
	if len(s.config.RCAMethods) == 0 {
		return nil
	}
	for _, approved := range s.config.RCAMethods {
		if strings.EqualFold(approved, method) {
			return nil
		}
	}
	return rpcerr.Invalid("QMS_METHOD_NOT_APPROVED",
		"this hospital has not approved the analysis method "+method)
}

// AddFactor records something that contributed (SRS-QMS-003).
func (s *Service) AddFactor(ctx context.Context, rcaID string,
	factor domain.ContributingFactor) (domain.RCA, error) {

	session, scope, err := s.authorize(ctx, PermInvestigate)
	if err != nil {
		return domain.RCA{}, err
	}
	now := s.clock.Now()

	var updated domain.RCA
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		rca, err := s.investigations.RCA(ctx, scope, rcaID)
		if err != nil {
			return err
		}
		// Validated by the aggregate, then written as a row: the factors live
		// apart from the analysis because they are counted across many of
		// them, and the aggregate is what decides whether one is well formed.
		if err := rca.AddFactor(factor); err != nil {
			return err
		}
		if err := s.investigations.AddFactor(ctx, scope, rca.ID,
			s.ids.NewID(), factor); err != nil {
			return err
		}
		updated = rca
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.rca.add_factor", ResourceType: "qms_rca",
			ResourceID: rca.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(factor.Category),
		}, now)
	})
	if err != nil {
		return domain.RCA{}, qualityError(err)
	}
	return updated, nil
}

// CompleteRCAInput closes an analysis.
type CompleteRCAInput struct {
	RCAID            string
	AccountableOwner string
	Findings         string
	NoActionReason   string
	ExpectedVersion  int64
}

// CompleteRCA closes an analysis (SRS-QMS-003).
//
// The count of actions raised from it is read here rather than supplied,
// because a caller that could say "three" could close an analysis that
// produced none.
func (s *Service) CompleteRCA(ctx context.Context, in CompleteRCAInput) (
	domain.RCA, error) {

	session, scope, err := s.authorize(ctx, PermInvestigate)
	if err != nil {
		return domain.RCA{}, err
	}
	now := s.clock.Now()

	var updated domain.RCA
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		rca, err := s.investigations.RCA(ctx, scope, in.RCAID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordRCA, rca.ID); err != nil {
			return err
		}

		factors, err := s.investigations.Factors(ctx, scope, rca.ID)
		if err != nil {
			return err
		}
		rca.Factors = factors
		rca.NoActionReason = strings.TrimSpace(in.NoActionReason)

		actions, err := s.actions.CountForSource(ctx, scope,
			string(domain.SourceRCA), rca.ID)
		if err != nil {
			return err
		}

		if err := rca.CompleteRCA(in.AccountableOwner, in.Findings, actions,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.investigations.UpdateRCA(ctx, scope, rca,
			in.ExpectedVersion); err != nil {
			return err
		}
		rca.Version = in.ExpectedVersion + 1
		updated = rca

		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.rca.complete", ResourceType: "qms_rca",
			ResourceID: rca.ID, Outcome: audit.OutcomeSuccess,
			Reason: itoa(len(factors)) + " factor(s), " +
				itoa(actions) + " action(s), owner " + in.AccountableOwner,
		}, now)
	})
	if err != nil {
		return domain.RCA{}, qualityError(err)
	}
	return updated, nil
}

// RCA reads one analysis with its factors (SRS-QMS-003).
func (s *Service) RCA(ctx context.Context, id string) (domain.RCA, error) {
	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.RCA{}, err
	}
	now := s.clock.Now()

	rca, err := s.investigations.RCA(ctx, scope, id)
	if err != nil {
		return domain.RCA{}, qualityError(err)
	}

	var out domain.RCA
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		mayRead, err := s.readRestricted(ctx, session, rca.Restricted,
			"qms_rca", rca.ID, now)
		if err != nil {
			return err
		}
		if !mayRead {
			// An analysis is findings and factors, which is all of it. There
			// is nothing here a reader who may not see it can usefully keep,
			// so this refuses rather than redacting.
			return rpcerr.NotFound("QMS_NOT_FOUND", "no such analysis")
		}
		factors, err := s.investigations.Factors(ctx, scope, rca.ID)
		if err != nil {
			return err
		}
		rca.Factors = factors
		out = rca
		return nil
	})
	if err != nil {
		return domain.RCA{}, qualityError(err)
	}
	return out, nil
}

// RaiseCAPA raises a corrective or preventive action (SRS-QMS-004).
func (s *Service) RaiseCAPA(ctx context.Context, in domain.NewCAPAInput) (
	domain.CAPA, error) {

	session, scope, err := s.authorize(ctx, PermAction)
	if err != nil {
		return domain.CAPA{}, err
	}
	now := s.clock.Now()

	capa, err := domain.RaiseCAPA(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.CAPA{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.actions.InsertCAPA(ctx, scope, capa); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.capa.raise", ResourceType: "qms_capa",
			ResourceID: capa.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(capa.Kind) + " from " + string(capa.SourceKind),
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventActionRaised, "qms_capa",
			capa.ID, map[string]any{
				"capa_id":     capa.ID,
				"reference":   capa.Reference,
				"kind":        string(capa.Kind),
				"source_kind": string(capa.SourceKind),
				"owner_id":    capa.OwnerID,
				"due_on":      capa.DueOn.Format(time.RFC3339),
			}, now)
	})
	if err != nil {
		return domain.CAPA{}, qualityError(err)
	}
	return capa, nil
}

// ApproveCAPA authorises an action to start (SRS-QMS-004).
func (s *Service) ApproveCAPA(ctx context.Context, capaID string,
	expectedVersion int64) (domain.CAPA, error) {

	return s.mutateCAPA(ctx, PermApproveAction, capaID, expectedVersion,
		"quality.capa.approve",
		func(c *domain.CAPA, by string, now time.Time) error {
			return c.ApproveCAPA(by, now)
		})
}

// AdvanceCAPA moves an action along (SRS-QMS-004).
func (s *Service) AdvanceCAPA(ctx context.Context, capaID string,
	to domain.CAPAState, reason string, expectedVersion int64) (
	domain.CAPA, error) {

	return s.mutateCAPA(ctx, PermAction, capaID, expectedVersion,
		"quality.capa.advance",
		func(c *domain.CAPA, _ string, now time.Time) error {
			return c.AdvanceCAPA(to, reason, now)
		})
}

// RecordCheck records an effectiveness review (SRS-QMS-004).
//
// The check is appended as its own row, including a failed one, and the action
// goes back to work when it failed. The history "fixed, checked, had not
// worked, fixed again, checked, had" is what tells a hospital whether its
// analysis was any good.
func (s *Service) RecordCheck(ctx context.Context, capaID string,
	check domain.EffectivenessCheck, expectedVersion int64) (
	domain.CAPA, error) {

	session, scope, err := s.authorize(ctx, PermAction)
	if err != nil {
		return domain.CAPA{}, err
	}
	now := s.clock.Now()
	check.CheckedBy = session.SubjectID

	var updated domain.CAPA
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		capa, err := s.actions.CAPA(ctx, scope, capaID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordCAPA, capa.ID); err != nil {
			return err
		}
		if err := capa.RecordCheck(check, now); err != nil {
			return err
		}
		if err := s.actions.AppendCheck(ctx, scope, capa.ID, s.ids.NewID(),
			capa.Checks[len(capa.Checks)-1]); err != nil {
			return err
		}
		if err := s.actions.UpdateCAPA(ctx, scope, capa,
			expectedVersion); err != nil {
			return err
		}
		capa.Version = expectedVersion + 1
		updated = capa

		outcome := "effective"
		if !check.Effective {
			outcome = "not effective, returned to work"
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.capa.check", ResourceType: "qms_capa",
			ResourceID: capa.ID, Outcome: audit.OutcomeSuccess,
			Reason: outcome + ": " + check.Evidence,
		}, now)
	})
	if err != nil {
		return domain.CAPA{}, qualityError(err)
	}
	return updated, nil
}

// CloseCAPA signs an action off (SRS-QMS-004).
//
// Its own permission and the domain's two refusals — no passing check, and the
// owner — stacked. Holding the permission is necessary and not sufficient.
func (s *Service) CloseCAPA(ctx context.Context, capaID, note string,
	expectedVersion int64) (domain.CAPA, error) {

	session, scope, err := s.authorize(ctx, PermApproveAction)
	if err != nil {
		return domain.CAPA{}, err
	}
	now := s.clock.Now()

	var updated domain.CAPA
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		capa, err := s.actions.CAPA(ctx, scope, capaID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordCAPA, capa.ID); err != nil {
			return err
		}
		if err := capa.CloseCAPA(session.SubjectID, note, now); err != nil {
			return err
		}
		if err := s.actions.UpdateCAPA(ctx, scope, capa,
			expectedVersion); err != nil {
			return err
		}
		capa.Version = expectedVersion + 1
		updated = capa

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.capa.close", ResourceType: "qms_capa",
			ResourceID: capa.ID, Outcome: audit.OutcomeSuccess, Reason: note,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventActionClosed, "qms_capa",
			capa.ID, map[string]any{
				"capa_id":     capa.ID,
				"reference":   capa.Reference,
				"kind":        string(capa.Kind),
				"source_kind": string(capa.SourceKind),
				"checks":      len(capa.Checks),
			}, now)
	})
	if err != nil {
		return domain.CAPA{}, qualityError(err)
	}
	return updated, nil
}

func (s *Service) mutateCAPA(ctx context.Context, permission, capaID string,
	expectedVersion int64, action string,
	apply func(*domain.CAPA, string, time.Time) error) (domain.CAPA, error) {

	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.CAPA{}, err
	}
	now := s.clock.Now()

	var updated domain.CAPA
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		capa, err := s.actions.CAPA(ctx, scope, capaID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordCAPA, capa.ID); err != nil {
			return err
		}
		if err := apply(&capa, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.actions.UpdateCAPA(ctx, scope, capa,
			expectedVersion); err != nil {
			return err
		}
		capa.Version = expectedVersion + 1
		updated = capa
		return s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "qms_capa", ResourceID: capa.ID,
			Outcome: audit.OutcomeSuccess, Reason: string(capa.State),
		}, now)
	})
	if err != nil {
		return domain.CAPA{}, qualityError(err)
	}
	return updated, nil
}

// CAPA reads one action with every check (SRS-QMS-004).
func (s *Service) CAPA(ctx context.Context, id string) (domain.CAPA, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.CAPA{}, err
	}
	capa, err := s.actions.CAPA(ctx, scope, id)
	if err != nil {
		return domain.CAPA{}, qualityError(err)
	}
	return capa, nil
}

// CAPAs lists actions.
func (s *Service) CAPAs(ctx context.Context, f ports.CAPAFilter) (
	[]domain.CAPA, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	f.Limit = clampPageSize(f.Limit)
	actions, err := s.actions.CAPAs(ctx, scope, f)
	if err != nil {
		return nil, qualityError(err)
	}
	return actions, nil
}

// OverdueActions lists what has run past its dates (SRS-QMS-004).
//
// Derived on read. A stored overdue flag is stale until a job runs and stays
// set after the action is done, and an escalation queue full of actions that
// were finished last week is a queue nobody reads.
func (s *Service) OverdueActions(ctx context.Context) ([]domain.Overdue,
	error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	actions, err := s.actions.CAPAs(ctx, scope, ports.CAPAFilter{
		LiveOnly: true, Limit: reportPageSize,
	})
	if err != nil {
		return nil, qualityError(err)
	}
	return domain.OverdueActions(actions, s.clock.Now()), nil
}

// EscalateOverdue raises a notice for every action past its dates
// (SRS-QMS-004).
//
// A separate call rather than a side effect of reading, because escalating is
// a decision somebody or some schedule takes and reading a report is not.
// Returns how many were raised, so a scheduled run that suddenly raises
// forty is visible as a number rather than as forty pages.
func (s *Service) EscalateOverdue(ctx context.Context) (int, error) {
	session, scope, err := s.authorize(ctx, PermAction)
	if err != nil {
		return 0, err
	}
	if s.escalations == nil {
		return 0, nil
	}
	now := s.clock.Now()

	actions, err := s.actions.CAPAs(ctx, scope, ports.CAPAFilter{
		LiveOnly: true, Limit: reportPageSize,
	})
	if err != nil {
		return 0, qualityError(err)
	}
	overdue := domain.OverdueActions(actions, now)

	raised := 0
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		for _, line := range overdue {
			what := "action overdue by " + itoa(line.ActionOverdueDays) +
				" day(s)"
			if line.ActionOverdueDays == 0 {
				what = "effectiveness check overdue by " +
					itoa(line.CheckOverdueDays) + " day(s)"
			}
			if _, err := s.escalations.Raise(ctx, scope, ports.Notice{
				Kind: EscalationOverdueAction, Subject: line.CAPA.Reference,
				Summary: what + ": " + line.CAPA.Action,
			}, now); err != nil {
				return err
			}
			raised++
		}
		if raised == 0 {
			return nil
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.capa.escalate_overdue",
			ResourceType: "qms_capa", Outcome: audit.OutcomeSuccess,
			Reason: itoa(raised) + " overdue action(s) escalated",
		}, now)
	})
	if err != nil {
		return 0, qualityError(err)
	}
	return raised, nil
}
