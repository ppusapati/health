package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// IngestAlarmInput is one event as a gateway reported it (SRS-FAC-005).
type IngestAlarmInput struct {
	GatewayID  string
	PointRef   string
	ExternalID string
	AssetID    string
	FacilityID string
	System     string
	Severity   string
	Message    string
	Source     string
	RaisedAt   string
}

// IngestedAlarm is what came back from ingesting an event.
type IngestedAlarm struct {
	Alarm domain.Alarm
	// WorkOrder is the ticket the configured rule raised, if one did.
	WorkOrder domain.WorkOrder
	// RaisedWork says whether a ticket was raised, which is different
	// from WorkOrder being non-zero in a way a caller should not have to
	// reason about.
	RaisedWork bool
	// Duplicate says the gateway replayed something already recorded.
	// Not an error: a gateway reconnecting after a network drop resends
	// its buffer, and the right answer is the alarm that already exists.
	Duplicate bool
}

// IngestAlarm records an event from a facility gateway (SRS-FAC-005).
//
// When a rule is configured for the system and the alarm is loud enough, it
// also raises a work order and links the two. The link is the requirement;
// the separateness is the acceptance, and it holds because nothing below
// writes both lifecycles.
func (s *Service) IngestAlarm(ctx context.Context, in IngestAlarmInput) (
	IngestedAlarm, error) {

	session, scope, err := s.authorize(ctx, PermAlarmIngest)
	if err != nil {
		return IngestedAlarm{}, err
	}
	now := s.clock.Now()

	raisedAt, err := parseTime(in.RaisedAt)
	if err != nil {
		return IngestedAlarm{}, err
	}
	if raisedAt.IsZero() {
		raisedAt = now
	}

	var out IngestedAlarm
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		existing, found, err := s.alarms.AlarmByEvent(ctx, scope,
			in.GatewayID, in.ExternalID)
		if err != nil {
			return err
		}
		if found {
			out = IngestedAlarm{Alarm: existing, Duplicate: true}
			return nil
		}

		alarm, err := domain.Ingest(s.ids.NewID(), session.TenantID,
			domain.IngestInput{
				GatewayID: in.GatewayID, PointRef: in.PointRef,
				ExternalID: in.ExternalID, AssetID: in.AssetID,
				FacilityID: in.FacilityID,
				System:     domain.System(in.System),
				Severity:   domain.Severity(in.Severity),
				Message:    in.Message,
				Source:     domain.Source(in.Source),
				RaisedAt:   raisedAt,
			}, now)
		if err != nil {
			return facilitiesError(err)
		}
		if err := s.alarms.InsertAlarm(ctx, scope, alarm); err != nil {
			return err
		}
		out.Alarm = alarm

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.alarm.ingested",
			ResourceType: "facilities.alarm", ResourceID: alarm.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"gateway_id": alarm.GatewayID,
				"point_ref":  alarm.PointRef,
				"severity":   string(alarm.Severity),
			}),
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventAlarmRaised,
			"facilities.alarm", alarm.ID, map[string]any{
				"system":      string(alarm.System),
				"severity":    string(alarm.Severity),
				"facility_id": alarm.FacilityID,
			}, now); err != nil {
			return err
		}

		// "When configured" (SRS-FAC-005). No rule, no ticket: a
		// hospital that wired every state change to a work order
		// would produce a thousand a week and read none of them.
		rules, err := s.alarms.AlarmRules(ctx, scope, alarm.System)
		if err != nil {
			return err
		}
		rule, matched := domain.RuleFor(rules, alarm)
		if !matched {
			return nil
		}

		work := domain.WorkFor(rule, alarm)
		order, err := s.raiseWithin(ctx, session, scope, RaiseWorkInput{
			FacilityID: alarm.FacilityID, AssetID: work.AssetID,
			System: string(work.System), LocationNote: alarm.PointRef,
			Fault: work.Fault, Impact: work.Impact,
			Priority: string(work.Priority), ClassCode: work.ClassCode,
			OwnerTeam: work.OwnerTeam,
		}, now)
		if err != nil {
			return err
		}

		if err := alarm.LinkWork(order.ID, session.SubjectID,
			now); err != nil {
			return facilitiesError(err)
		}
		if err := s.alarms.UpdateAlarm(ctx, scope, alarm,
			alarm.Version); err != nil {
			return facilitiesError(err)
		}
		out.Alarm = alarm
		out.WorkOrder, out.RaisedWork = order, true

		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.alarm.work_raised",
			ResourceType: "facilities.alarm", ResourceID: alarm.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"work_order_id": order.ID,
				"rule_class":    rule.ClassCode,
			}),
		}, now)
	})
	if err != nil {
		return IngestedAlarm{}, err
	}
	return out, nil
}

// ClearAlarmInput records the plant no longer asserting an alarm.
type ClearAlarmInput struct {
	AlarmID string
	Version int64
}

// ClearAlarm records the alarm clearing (SRS-FAC-005).
//
// It does not touch the work order, and there is no call here that does. A
// chiller whose alarm cleared because somebody cycled the power has not been
// repaired.
func (s *Service) ClearAlarm(ctx context.Context, in ClearAlarmInput) (
	domain.Alarm, error) {

	return s.mutateAlarm(ctx, in.AlarmID, in.Version,
		"facilities.alarm.cleared",
		func(alarm *domain.Alarm, subjectID string, now timeNow) (
			map[string]string, error) {

			if err := alarm.Clear(now); err != nil {
				return nil, facilitiesError(err)
			}
			return map[string]string{
				"point_ref": alarm.PointRef}, nil
		})
}

// AcknowledgeAlarmInput records a person seeing an alarm.
type AcknowledgeAlarmInput struct {
	AlarmID string
	Version int64
}

// AcknowledgeAlarm records a person seeing an alarm (SRS-FAC-005).
func (s *Service) AcknowledgeAlarm(ctx context.Context,
	in AcknowledgeAlarmInput) (domain.Alarm, error) {

	return s.mutateAlarm(ctx, in.AlarmID, in.Version,
		"facilities.alarm.acknowledged",
		func(alarm *domain.Alarm, subjectID string, now timeNow) (
			map[string]string, error) {

			if err := alarm.AcknowledgeAlarm(subjectID,
				now); err != nil {
				return nil, facilitiesError(err)
			}
			return map[string]string{
				"severity": string(alarm.Severity)}, nil
		})
}

// LinkAlarmWorkInput attaches an alarm to the work raised for it.
type LinkAlarmWorkInput struct {
	AlarmID     string
	WorkOrderID string
	Version     int64
}

// LinkAlarmWork attaches the work raised for an alarm (SRS-FAC-005).
func (s *Service) LinkAlarmWork(ctx context.Context,
	in LinkAlarmWorkInput) (domain.Alarm, error) {

	session, scope, err := s.authorize(ctx, PermAlarmManage)
	if err != nil {
		return domain.Alarm{}, err
	}
	now := s.clock.Now()

	var out domain.Alarm
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The order has to exist. An alarm pointing at a work order
		// nobody raised is a link that answers "what did we do about
		// this" with a dangling identifier.
		if _, err := s.work.WorkOrder(ctx, scope,
			in.WorkOrderID); err != nil {
			return err
		}
		alarm, err := s.alarms.Alarm(ctx, scope, in.AlarmID)
		if err != nil {
			return err
		}
		if err := alarm.LinkWork(in.WorkOrderID, session.SubjectID,
			now); err != nil {
			return facilitiesError(err)
		}
		versionSeen := expected(in.Version, alarm.Version)
		if err := s.alarms.UpdateAlarm(ctx, scope, alarm,
			versionSeen); err != nil {
			return facilitiesError(err)
		}
		alarm.Version = applied(versionSeen)
		out = alarm
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.alarm.linked",
			ResourceType: "facilities.alarm", ResourceID: alarm.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"work_order_id": alarm.WorkOrderID}),
		}, now)
	})
	if err != nil {
		return domain.Alarm{}, err
	}
	return out, nil
}

func (s *Service) mutateAlarm(ctx context.Context, alarmID string,
	version int64, action string,
	change func(*domain.Alarm, string, timeNow) (
		map[string]string, error)) (domain.Alarm, error) {

	session, scope, err := s.authorize(ctx, PermAlarmManage)
	if err != nil {
		return domain.Alarm{}, err
	}
	now := s.clock.Now()

	var out domain.Alarm
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		alarm, err := s.alarms.Alarm(ctx, scope, alarmID)
		if err != nil {
			return err
		}
		attributes, err := change(&alarm, session.SubjectID, now)
		if err != nil {
			return err
		}
		versionSeen := expected(version, alarm.Version)
		if err := s.alarms.UpdateAlarm(ctx, scope, alarm,
			versionSeen); err != nil {
			return facilitiesError(err)
		}
		alarm.Version = applied(versionSeen)
		out = alarm
		return s.appendAudit(ctx, session, audit.Record{
			Action:       action,
			ResourceType: "facilities.alarm", ResourceID: alarm.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(attributes),
		}, now)
	})
	if err != nil {
		return domain.Alarm{}, err
	}
	return out, nil
}

// SetAlarmRuleInput configures which alarms raise work (SRS-FAC-005).
type SetAlarmRuleInput struct {
	FacilityID  string
	System      string
	MinSeverity string
	Priority    string
	ClassCode   string
	OwnerTeam   string
	Active      bool
}

// SetAlarmRule configures an alarm-to-work rule (SRS-FAC-005).
func (s *Service) SetAlarmRule(ctx context.Context, in SetAlarmRuleInput) (
	domain.AlarmRule, error) {

	session, scope, err := s.authorize(ctx, PermMaintenanceManage)
	if err != nil {
		return domain.AlarmRule{}, err
	}
	now := s.clock.Now()

	rule := domain.AlarmRule{
		TenantID: session.TenantID, FacilityID: in.FacilityID,
		System:      domain.System(in.System),
		MinSeverity: domain.Severity(in.MinSeverity),
		Priority:    domain.Priority(in.Priority),
		ClassCode:   in.ClassCode, OwnerTeam: in.OwnerTeam,
		Active: in.Active,
	}
	if err := rule.Validate(); err != nil {
		return domain.AlarmRule{}, facilitiesError(err)
	}

	id := s.ids.NewID()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The class must exist, or every alarm that matches this rule
		// fails to raise its ticket at three in the morning.
		if _, err := s.classes.WorkClass(ctx, scope,
			rule.ClassCode); err != nil {
			return err
		}
		if err := s.alarms.InsertAlarmRule(ctx, scope, id, rule,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.alarm_rule.set",
			ResourceType: "facilities.alarm_rule", ResourceID: id,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"system":       string(rule.System),
				"min_severity": string(rule.MinSeverity),
				"owner_team":   rule.OwnerTeam,
			}),
		}, now)
	})
	if err != nil {
		return domain.AlarmRule{}, err
	}
	return rule, nil
}

// AlarmFilterInput narrows an alarm list.
type AlarmFilterInput struct {
	FacilityID     string
	System         string
	State          string
	UnansweredOnly bool
	From           string
	To             string
	PageSize       int32
}

// ListAlarms reads gateway alarms (SRS-FAC-005).
func (s *Service) ListAlarms(ctx context.Context, in AlarmFilterInput) (
	[]domain.Alarm, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	from, err := parseTime(in.From)
	if err != nil {
		return nil, err
	}
	to, err := parseTime(in.To)
	if err != nil {
		return nil, err
	}
	found, err := s.alarms.Alarms(ctx, scope, ports.AlarmFilter{
		FacilityID: in.FacilityID, System: domain.System(in.System),
		State:          domain.AlarmState(in.State),
		UnansweredOnly: in.UnansweredOnly,
		From:           from, To: to, Limit: clampPageSize(in.PageSize),
	})
	if err != nil {
		return nil, err
	}
	if in.UnansweredOnly {
		// Loudest first, and cleared alarms included: one that came and
		// went without anybody acknowledging it is the one worth
		// looking at.
		return domain.UnansweredAlarms(found), nil
	}
	return found, nil
}
