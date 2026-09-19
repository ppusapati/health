package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// StartIsolationInput places a patient under precautions (SRS-IPC-003).
type StartIsolationInput struct {
	PatientID   string
	EncounterID string
	FacilityID  string
	LocationID  string
	BedID       string
	Precaution  domain.Precaution
	Reason      string
	CaseID      string
	StartedAt   time.Time
}

// StartIsolation places a patient under precautions (SRS-IPC-003).
func (s *Service) StartIsolation(ctx context.Context,
	in StartIsolationInput) (domain.Isolation, error) {

	session, scope, err := s.authorize(ctx, PermIsolation)
	if err != nil {
		return domain.Isolation{}, err
	}
	now := s.clock.Now()

	isolation, err := domain.StartIsolation(s.ids.NewID(), session.TenantID,
		domain.NewIsolationInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			FacilityID: in.FacilityID, LocationID: in.LocationID,
			BedID: in.BedID, Precaution: in.Precaution, Reason: in.Reason,
			CaseID: in.CaseID, StartedAt: in.StartedAt,
		}, s.config.IsolationReviewAfter, session.SubjectID, now)
	if err != nil {
		return domain.Isolation{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.isolations.InsertIsolation(ctx, scope,
			isolation); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.isolation.started",
			ResourceType: "ipc_isolation", ResourceID: isolation.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "placed a patient under precautions",
		}, now); err != nil {
			return err
		}
		// The precaution and the place, never the reason. An event stream is
		// read more widely than the record, and the reason is a diagnosis.
		return s.appendEvent(ctx, session, EventIsolationStarted,
			"ipc_isolation", isolation.ID, map[string]any{
				"precaution":  string(isolation.Precaution),
				"location_id": isolation.LocationID,
				"side_room":   isolation.Precaution.RequiresSideRoom(),
			}, now)
	})
	if err != nil {
		return domain.Isolation{}, infectionError(err)
	}
	return isolation, nil
}

// ExtendIsolation pushes the review date out after somebody reconsidered
// (SRS-IPC-003).
func (s *Service) ExtendIsolation(ctx context.Context, isolationID string) (
	domain.Isolation, error) {

	session, scope, err := s.authorize(ctx, PermIsolation)
	if err != nil {
		return domain.Isolation{}, err
	}
	now := s.clock.Now()

	var extended domain.Isolation
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		isolation, err := s.isolations.Isolation(ctx, scope, isolationID)
		if err != nil {
			return err
		}
		version := isolation.Version
		if err := isolation.Extend(s.config.IsolationReviewAfter,
			now); err != nil {
			return err
		}
		if err := s.isolations.UpdateIsolation(ctx, scope, isolation,
			version); err != nil {
			return err
		}
		extended = isolation
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.isolation.reviewed",
			ResourceType: "ipc_isolation", ResourceID: isolation.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "reconsidered precautions and extended them",
		}, now)
	})
	if err != nil {
		return domain.Isolation{}, infectionError(err)
	}
	return extended, nil
}

// EndIsolation lifts precautions (SRS-IPC-003).
func (s *Service) EndIsolation(ctx context.Context, isolationID,
	reason string) (domain.Isolation, error) {

	session, scope, err := s.authorize(ctx, PermIsolation)
	if err != nil {
		return domain.Isolation{}, err
	}
	now := s.clock.Now()

	var ended domain.Isolation
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		isolation, err := s.isolations.Isolation(ctx, scope, isolationID)
		if err != nil {
			return err
		}
		version := isolation.Version
		if err := isolation.EndIsolation(reason, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.isolations.UpdateIsolation(ctx, scope, isolation,
			version); err != nil {
			return err
		}
		ended = isolation

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.isolation.ended",
			ResourceType: "ipc_isolation", ResourceID: isolation.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventIsolationEnded,
			"ipc_isolation", isolation.ID, map[string]any{
				"precaution":  string(isolation.Precaution),
				"location_id": isolation.LocationID,
			}, now)
	})
	if err != nil {
		return domain.Isolation{}, infectionError(err)
	}
	return ended, nil
}

// Board renders a ward's precautions (SRS-IPC-003).
//
// Under its own permission, held far more widely than PermRead, and returning
// a value that structurally cannot carry the reason. A nurse walking onto a
// bay needs to know what to wear; nothing about that requires the diagnosis,
// and a board on a wall is read by visitors and contractors too.
func (s *Service) Board(ctx context.Context, locationID string) (
	[]domain.BoardEntry, error) {

	_, scope, err := s.authorize(ctx, PermBoard)
	if err != nil {
		return nil, err
	}
	isolations, err := s.isolations.Isolations(ctx, scope,
		ports.IsolationFilter{
			LocationID: locationID, ActiveOnly: true, Limit: reportPageSize,
		})
	if err != nil {
		return nil, err
	}
	return domain.Board(isolations, locationID, s.clock.Now()), nil
}

// NewAlertRuleInput configures a multidrug-resistant organism rule
// (SRS-IPC-004).
type NewAlertRuleInput struct {
	Code         string
	Name         string
	Revision     int
	Organisms    []string
	LookbackDays int
	Precaution   domain.Precaution
	Advice       string
}

// DraftAlertRule authors a rule revision (SRS-IPC-004).
//
// Drafted and approved separately, by different people, because a rule
// decides what every ward is told about every patient.
func (s *Service) DraftAlertRule(ctx context.Context, in NewAlertRuleInput) (
	domain.AlertRule, error) {

	session, scope, err := s.authorize(ctx, PermRuleWrite)
	if err != nil {
		return domain.AlertRule{}, err
	}
	now := s.clock.Now()

	rule, err := domain.NewAlertRule(s.ids.NewID(), session.TenantID,
		domain.NewRuleInput{
			Code: in.Code, Name: in.Name, Revision: in.Revision,
			Organisms: in.Organisms, LookbackDays: in.LookbackDays,
			Precaution: in.Precaution, Advice: in.Advice,
		}, session.SubjectID, now)
	if err != nil {
		return domain.AlertRule{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.alerts.InsertRule(ctx, scope, rule); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.alert_rule.drafted",
			ResourceType: "ipc_alert_rule", ResourceID: rule.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": rule.Code, "revision": itoa(rule.Revision),
			}),
			Reason: "authored an alert rule revision",
		}, now)
	})
	if err != nil {
		return domain.AlertRule{}, infectionError(err)
	}
	return rule, nil
}

// ApproveAlertRule puts a rule in force and supersedes the revisions before
// it (SRS-IPC-004).
func (s *Service) ApproveAlertRule(ctx context.Context, ruleID string,
	effectiveFrom time.Time) (domain.AlertRule, error) {

	session, scope, err := s.authorize(ctx, PermRuleApprove)
	if err != nil {
		return domain.AlertRule{}, err
	}
	now := s.clock.Now()

	var approved domain.AlertRule
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		rule, err := s.alerts.Rule(ctx, scope, ruleID)
		if err != nil {
			return err
		}
		if err := rule.Approve(session.SubjectID, effectiveFrom,
			now); err != nil {
			return err
		}
		if err := s.alerts.ApproveRule(ctx, scope, rule); err != nil {
			return err
		}
		// Two revisions live at once would mean two answers to "which rule
		// fired", and the alert only records one.
		if err := s.alerts.SupersedeEarlier(ctx, scope, rule.Code,
			rule.Revision, effectiveFrom); err != nil {
			return err
		}
		approved = rule
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.alert_rule.approved",
			ResourceType: "ipc_alert_rule", ResourceID: rule.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": rule.Code, "revision": itoa(rule.Revision),
			}),
			Reason: "put an alert rule in force",
		}, now)
	})
	if err != nil {
		return domain.AlertRule{}, infectionError(err)
	}
	return approved, nil
}

// ScreenEncounter fires the live rules for a patient at an encounter
// (SRS-IPC-004).
//
// lastPositiveAt is when the patient last had the organism, which the caller
// reads from the surveillance history. A patient colonised eighteen months
// ago is a different risk from one colonised last week, and the rule's
// lookback decides which.
func (s *Service) ScreenEncounter(ctx context.Context, patientID,
	encounterID, facilityID, organism, organismCode string,
	lastPositiveAt time.Time) ([]domain.Alert, error) {

	session, scope, err := s.authorize(ctx, PermIsolation)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	rules, err := s.alerts.Rules(ctx, scope, "", now)
	if err != nil {
		return nil, err
	}

	var raised []domain.Alert
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		for _, rule := range rules {
			if !rule.Covers(organismCode) {
				continue
			}
			alert, err := domain.RaiseAlert(s.ids.NewID(), session.TenantID,
				rule, patientID, encounterID, facilityID, organism,
				organismCode, lastPositiveAt, now)
			if err != nil {
				// Outside the rule's lookback is the rule deciding not to
				// alert, not a failure of the screen.
				continue
			}
			if err := s.alerts.InsertAlert(ctx, scope, alert); err != nil {
				return err
			}
			raised = append(raised, alert)

			if err := s.appendEvent(ctx, session, EventAlertRaised,
				"ipc_alert", alert.ID, map[string]any{
					"rule_code":     alert.RuleCode,
					"rule_revision": alert.RuleRevision,
					"precaution":    string(alert.Precaution),
				}, now); err != nil {
				return err
			}
		}
		if len(raised) == 0 {
			return nil
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "infection.encounter.screened", ResourceType: "encounter",
			ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"alerts": itoa(len(raised)),
			}),
			Reason: "screened an encounter against the alert rules",
		}, now)
	})
	if err != nil {
		return nil, infectionError(err)
	}
	return raised, nil
}

// AcknowledgeAlert records somebody having seen an alert (SRS-IPC-004).
func (s *Service) AcknowledgeAlert(ctx context.Context, alertID string) (
	domain.Alert, error) {

	return s.answerAlert(ctx, alertID, "", false)
}

// OverrideAlert records somebody deciding an alert does not apply here
// (SRS-IPC-004).
//
// Audited, which is the requirement's acceptance, and it never stops the rule
// firing again at the next encounter: an override is a judgement about this
// admission, not a permanent exemption.
func (s *Service) OverrideAlert(ctx context.Context, alertID,
	reason string) (domain.Alert, error) {

	return s.answerAlert(ctx, alertID, reason, true)
}

func (s *Service) answerAlert(ctx context.Context, alertID, reason string,
	override bool) (domain.Alert, error) {

	// Acknowledging is the lighter act and belongs with reading the board:
	// the person who sees the alert is the person who confirms they have.
	// Overriding is the decision that it does not apply here, and that has
	// its own permission and its own audit entry.
	permission := PermBoard
	if override {
		permission = PermAlertOverride
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.Alert{}, err
	}
	now := s.clock.Now()

	var answered domain.Alert
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		alert, err := s.alerts.Alert(ctx, scope, alertID)
		if err != nil {
			return err
		}
		action := "infection.alert.acknowledged"
		if override {
			if err := alert.Override(reason, session.SubjectID,
				now); err != nil {
				return err
			}
			action = "infection.alert.overridden"
		} else if err := alert.Acknowledge(session.SubjectID, now); err != nil {
			return err
		}
		if err := s.alerts.UpdateAlert(ctx, scope, alert); err != nil {
			return err
		}
		answered = alert

		return s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "ipc_alert", ResourceID: alert.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"rule_code":     alert.RuleCode,
				"rule_revision": itoa(alert.RuleRevision),
			}),
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Alert{}, infectionError(err)
	}
	return answered, nil
}

// Alerts lists what fired for a patient or encounter (SRS-IPC-004).
func (s *Service) Alerts(ctx context.Context, patientID, encounterID string,
	outstandingOnly bool, limit int32) ([]domain.Alert, error) {

	_, scope, err := s.authorize(ctx, PermBoard)
	if err != nil {
		return nil, err
	}
	if patientID == "" && encounterID == "" {
		return nil, rpcerr.Invalid("IPC_INVALID",
			"name the patient or the encounter whose alerts you want")
	}
	return s.alerts.Alerts(ctx, scope, patientID, encounterID,
		outstandingOnly, clampPageSize(limit))
}
