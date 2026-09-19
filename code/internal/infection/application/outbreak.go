package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// OpenOutbreakInput starts a cluster investigation (SRS-IPC-005).
type OpenOutbreakInput struct {
	Reference      string
	Organism       string
	CaseDefinition string
	Locations      []string
	WindowFrom     time.Time
	WindowTo       time.Time
}

// OpenOutbreak starts a cluster investigation (SRS-IPC-005).
func (s *Service) OpenOutbreak(ctx context.Context, in OpenOutbreakInput) (
	domain.Outbreak, error) {

	session, scope, err := s.authorize(ctx, PermOutbreak)
	if err != nil {
		return domain.Outbreak{}, err
	}
	now := s.clock.Now()

	outbreak, err := domain.OpenOutbreak(s.ids.NewID(), session.TenantID,
		domain.NewOutbreakInput{
			Reference: in.Reference, Organism: in.Organism,
			CaseDefinition: in.CaseDefinition, Locations: in.Locations,
			WindowFrom: in.WindowFrom, WindowTo: in.WindowTo,
		}, session.SubjectID, now)
	if err != nil {
		return domain.Outbreak{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.outbreaks.InsertOutbreak(ctx, scope,
			outbreak); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "infection.outbreak.opened", ResourceType: "ipc_outbreak",
			ResourceID: outbreak.ID, Outcome: audit.OutcomeSuccess,
			Reason: "opened a cluster investigation",
		}, now)
	})
	if err != nil {
		return domain.Outbreak{}, infectionError(err)
	}
	return outbreak, nil
}

// AdvanceOutbreak moves an investigation along (SRS-IPC-005).
//
// Declaring one escalates. A cluster the hospital has declared is not
// something that waits for somebody to open a screen, and the notice carries
// the organism and the locations rather than any patient.
func (s *Service) AdvanceOutbreak(ctx context.Context, outbreakID string,
	to domain.OutbreakState, reason string) (domain.Outbreak, error) {

	session, scope, err := s.authorize(ctx, PermOutbreak)
	if err != nil {
		return domain.Outbreak{}, err
	}
	now := s.clock.Now()

	var advanced domain.Outbreak
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outbreak, err := s.outbreaks.Outbreak(ctx, scope, outbreakID)
		if err != nil {
			return err
		}
		version := outbreak.Version
		if err := outbreak.Advance(to, reason, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.outbreaks.UpdateOutbreak(ctx, scope, outbreak,
			version); err != nil {
			return err
		}
		advanced = outbreak

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.outbreak.advanced",
			ResourceType: "ipc_outbreak", ResourceID: outbreak.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{"state": string(to)}),
			Reason:  reason,
		}, now); err != nil {
			return err
		}
		if to != domain.OutbreakDeclared {
			return nil
		}
		if err := s.appendEvent(ctx, session, EventOutbreakDeclared,
			"ipc_outbreak", outbreak.ID, map[string]any{
				"organism":  outbreak.Organism,
				"locations": outbreak.Locations,
			}, now); err != nil {
			return err
		}
		return s.escalate(ctx, session, scope, ports.Notice{
			Kind: EscalationOutbreak, Subject: outbreak.ID,
			Summary: "outbreak declared: " + outbreak.Organism,
		}, now)
	})
	if err != nil {
		return domain.Outbreak{}, infectionError(err)
	}
	return advanced, nil
}

// CloseOutbreak signs an investigation off (SRS-IPC-005).
//
// controlMeasures and actionIDs are what the hospital changed. The domain
// refuses a declared outbreak closing with neither: a cluster investigated
// and closed having changed nothing is either an investigation that found
// nothing — which is what "refuted" is for — or one whose conclusions went
// nowhere.
func (s *Service) CloseOutbreak(ctx context.Context, outbreakID, findings,
	reason string, controlMeasures, actionIDs []string) (
	domain.Outbreak, error) {

	session, scope, err := s.authorize(ctx, PermOutbreak)
	if err != nil {
		return domain.Outbreak{}, err
	}
	now := s.clock.Now()

	var closed domain.Outbreak
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outbreak, err := s.outbreaks.Outbreak(ctx, scope, outbreakID)
		if err != nil {
			return err
		}
		version := outbreak.Version
		outbreak.ControlMeasures = controlMeasures
		outbreak.ActionIDs = actionIDs
		if err := outbreak.CloseOutbreak(findings, reason,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.outbreaks.UpdateOutbreak(ctx, scope, outbreak,
			version); err != nil {
			return err
		}
		closed = outbreak

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.outbreak.closed",
			ResourceType: "ipc_outbreak", ResourceID: outbreak.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventOutbreakClosed,
			"ipc_outbreak", outbreak.ID, map[string]any{
				"organism":         outbreak.Organism,
				"control_measures": len(outbreak.ControlMeasures),
				"actions":          len(outbreak.ActionIDs),
			}, now)
	})
	if err != nil {
		return domain.Outbreak{}, infectionError(err)
	}
	return closed, nil
}

// AddOutbreakMember records a membership decision (SRS-IPC-005).
//
// Whether the case meets the definition is computed from the investigation
// rather than asserted by the caller, so adding a case that does not and
// removing one that does both have to say why.
func (s *Service) AddOutbreakMember(ctx context.Context, outbreakID,
	caseID string, reason domain.MembershipReason, note string) (
	domain.Membership, error) {

	session, scope, err := s.authorize(ctx, PermOutbreak)
	if err != nil {
		return domain.Membership{}, err
	}
	now := s.clock.Now()

	var member domain.Membership
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outbreak, err := s.outbreaks.Outbreak(ctx, scope, outbreakID)
		if err != nil {
			return err
		}
		one, err := s.cases.Case(ctx, scope, caseID)
		if err != nil {
			return err
		}
		member, err = domain.AddMember(s.ids.NewID(), session.TenantID,
			outbreakID, caseID, one.PatientID, reason, note,
			outbreak.Matches(one), session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.outbreaks.AddMember(ctx, scope, member); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.outbreak.member_decided",
			ResourceType: "ipc_outbreak", ResourceID: outbreakID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"case_id": caseID, "reason": string(reason),
			}),
			Reason: note,
		}, now)
	})
	if err != nil {
		return domain.Membership{}, infectionError(err)
	}
	return member, nil
}

// OutbreakCluster describes an investigation's size and shape (SRS-IPC-005,
// SRS-IPC-010).
func (s *Service) OutbreakCluster(ctx context.Context, outbreakID string) (
	domain.ClusterSummary, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.ClusterSummary{}, err
	}

	outbreak, err := s.outbreaks.Outbreak(ctx, scope, outbreakID)
	if err != nil {
		return domain.ClusterSummary{}, err
	}
	members, err := s.outbreaks.Members(ctx, scope, outbreakID)
	if err != nil {
		return domain.ClusterSummary{}, err
	}

	cases := map[string]domain.SurveillanceCase{}
	for _, member := range members {
		if member.CaseID == "" {
			continue
		}
		one, err := s.cases.Case(ctx, scope, member.CaseID)
		if err != nil {
			// A membership whose case has gone is still a decision somebody
			// made, and the summary counts it rather than failing.
			continue
		}
		cases[member.CaseID] = one
	}
	return domain.Summarise(outbreak, members, cases), nil
}

// Outbreaks lists investigations (SRS-IPC-005).
func (s *Service) Outbreaks(ctx context.Context, state string, openOnly bool,
	limit int32) ([]domain.Outbreak, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.outbreaks.Outbreaks(ctx, scope, state, openOnly,
		clampPageSize(limit))
}
