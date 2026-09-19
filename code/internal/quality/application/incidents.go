package application

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// ReportIncident records an event or a near miss (SRS-QMS-001, SRS-QMS-002).
//
// The escalation happens in the same transaction as the record. A sentinel
// event written now and swept later is a window in which the hospital has been
// told and nobody has been called, and that window is what SRS-QMS-005 exists
// to close.
func (s *Service) ReportIncident(ctx context.Context,
	in domain.NewIncidentInput) (domain.Incident, error) {

	session, scope, err := s.authorize(ctx, PermReport)
	if err != nil {
		return domain.Incident{}, err
	}
	now := s.clock.Now()

	// The hospital's own sentinel list, applied before the domain sees it. A
	// death is a sentinel event whatever anybody configures; these are the
	// categories this hospital has added to that.
	for _, category := range s.config.SentinelCategories {
		if strings.EqualFold(category, in.Category) {
			in.Sentinel = true
			break
		}
	}

	incident, err := domain.ReportIncident(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.Incident{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.incidents.InsertIncident(ctx, scope, incident); err != nil {
			return err
		}

		// The audit trail knows who reported it even when the record does
		// not. Anonymous reporting is a hole in the record for the reader's
		// benefit, not a hole in the trail.
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.incident.report", ResourceType: "qms_incident",
			ResourceID: incident.ID, Outcome: audit.OutcomeSuccess,
			Reason: incident.Category + " (" + string(incident.Reach) + ")",
		}, now); err != nil {
			return err
		}

		// Category and band, never the narrative. An incident stream carrying
		// narratives would be the widest-read copy of the most sensitive text
		// in the hospital.
		if err := s.appendEvent(ctx, session, EventIncidentReported,
			"qms_incident", incident.ID, map[string]any{
				"incident_id": incident.ID,
				"reference":   incident.Reference,
				"category":    incident.Category,
				"reach":       string(incident.Reach),
				"risk_band":   string(incident.Risk.Band),
				"sentinel":    incident.Sentinel,
				"department":  incident.Department,
				"facility_id": incident.FacilityID,
			}, now); err != nil {
			return err
		}

		return s.escalateIncident(ctx, session, scope, incident, now)
	})
	if err != nil {
		return domain.Incident{}, qualityError(err)
	}
	return incident, nil
}

// escalateIncident raises the notices an incident produces (SRS-QMS-002,
// SRS-QMS-005).
//
// A sentinel event always escalates; a scored incident escalates at or above
// the configured band. Both, where both apply: they go to different people,
// and collapsing them would mean the executive hears about a sentinel event
// through the departmental risk queue.
func (s *Service) escalateIncident(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope,
	incident domain.Incident, now time.Time) error {

	if s.escalations == nil {
		return nil
	}

	raise := func(kind, summary string) error {
		_, err := s.escalations.Raise(ctx, scope, ports.Notice{
			Kind: kind,
			// The reference, never the narrative and never the patient. A
			// notice travels further and under fewer controls than the record
			// it points at.
			Subject:    incident.Reference,
			FacilityID: incident.FacilityID,
			Summary:    summary,
		}, now)
		return err
	}

	if incident.Sentinel {
		if err := raise(EscalationSentinel,
			"sentinel event in "+incident.Department+
				": "+incident.Category); err != nil {
			return err
		}
	}
	if s.config.EscalateAtBand != "" &&
		bandRank(incident.Risk.Band) >= bandRank(s.config.EscalateAtBand) {
		if err := raise(EscalationHighRisk,
			string(incident.Risk.Band)+" risk incident in "+
				incident.Department+": "+incident.Category); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventIncidentEscalated,
			"qms_incident", incident.ID, map[string]any{
				"incident_id": incident.ID,
				"risk_band":   string(incident.Risk.Band),
				"sentinel":    incident.Sentinel,
			}, now); err != nil {
			return err
		}
	}
	return nil
}

// Incident reads one report (SRS-QMS-001, SRS-QMS-012).
//
// A restricted record is redacted for a caller without the restricted-read
// permission rather than refused. The ward needs to know that something
// happened in it; what it must not have is the narrative, the patient and the
// people.
func (s *Service) Incident(ctx context.Context, id string) (
	domain.Incident, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Incident{}, err
	}
	now := s.clock.Now()

	incident, err := s.incidents.Incident(ctx, scope, id)
	if err != nil {
		return domain.Incident{}, qualityError(err)
	}

	var out domain.Incident
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		mayRead, err := s.readRestricted(ctx, session, incident.Restricted,
			"qms_incident", incident.ID, now)
		if err != nil {
			return err
		}
		if mayRead {
			out = incident
		} else {
			out = incident.Redacted()
		}
		return nil
	})
	if err != nil {
		return domain.Incident{}, qualityError(err)
	}
	return out, nil
}

// Incidents lists reports, redacting the restricted ones the caller may not
// read in full (SRS-QMS-001).
func (s *Service) Incidents(ctx context.Context, f ports.IncidentFilter) (
	[]domain.Incident, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	f.Limit = clampPageSize(f.Limit)

	incidents, err := s.incidents.Incidents(ctx, scope, f)
	if err != nil {
		return nil, qualityError(err)
	}

	// One audit line for the list rather than one per restricted row. A list
	// read is one access; a record per row would bury the trail under the
	// screen somebody left open.
	restricted := 0
	mayRead := session.HasPermission(PermRestricted)
	out := make([]domain.Incident, 0, len(incidents))
	for _, incident := range incidents {
		if incident.Restricted {
			restricted++
			if !mayRead {
				out = append(out, incident.Redacted())
				continue
			}
		}
		out = append(out, incident)
	}

	if restricted > 0 && mayRead {
		now := s.clock.Now()
		err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
			return s.appendAudit(ctx, session, audit.Record{
				Action:       "quality.restricted.list",
				ResourceType: "qms_incident",
				Outcome:      audit.OutcomeSuccess,
				Reason:       itoa(restricted) + " restricted incident(s) read",
			}, now)
		})
		if err != nil {
			return nil, qualityError(err)
		}
	}
	return out, nil
}

// RescoreInput re-runs a risk assessment.
type RescoreInput struct {
	IncidentID      string
	Consequence     domain.Consequence
	Likelihood      domain.Likelihood
	ExpectedVersion int64
}

// Rescore re-runs the risk assessment (SRS-QMS-002).
//
// A reviewer who knows more than the reporter did is the point of the review.
// The escalation runs again on the new band, because an incident re-scored
// upwards is an incident somebody now has to be told about.
func (s *Service) Rescore(ctx context.Context, in RescoreInput) (
	domain.Incident, error) {

	session, scope, err := s.authorize(ctx, PermReview)
	if err != nil {
		return domain.Incident{}, err
	}
	now := s.clock.Now()

	var updated domain.Incident
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		incident, err := s.incidents.Incident(ctx, scope, in.IncidentID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordIncident,
			incident.ID); err != nil {
			return err
		}
		was := incident.Risk.Band

		if err := incident.Rescore(in.Consequence, in.Likelihood,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.incidents.UpdateIncident(ctx, scope, incident,
			in.ExpectedVersion); err != nil {
			return err
		}
		incident.Version = in.ExpectedVersion + 1
		updated = incident

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.incident.rescore", ResourceType: "qms_incident",
			ResourceID: incident.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(was) + " -> " + string(incident.Risk.Band),
		}, now); err != nil {
			return err
		}

		// Only on the way up. Re-escalating an incident somebody downgraded
		// would train people to ignore the queue.
		if bandRank(incident.Risk.Band) > bandRank(was) {
			return s.escalateIncident(ctx, session, scope, incident, now)
		}
		return nil
	})
	if err != nil {
		return domain.Incident{}, qualityError(err)
	}
	return updated, nil
}

// AdvanceIncidentInput moves a report through review.
type AdvanceIncidentInput struct {
	IncidentID      string
	To              domain.IncidentState
	Reason          string
	ExpectedVersion int64
}

// AdvanceIncident moves a report through review (SRS-QMS-001).
//
// Closing an incident that a hospital's own policy says needs an analysis is
// allowed and reported, not refused. An incident log that will not let you
// close anything until somebody has done a root cause analysis is a log work
// goes into and never comes out of, and the backlog hides the real ones.
func (s *Service) AdvanceIncident(ctx context.Context,
	in AdvanceIncidentInput) (domain.Incident, []string, error) {

	session, scope, err := s.authorize(ctx, PermReview)
	if err != nil {
		return domain.Incident{}, nil, err
	}
	now := s.clock.Now()

	var updated domain.Incident
	var concerns []string
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		incident, err := s.incidents.Incident(ctx, scope, in.IncidentID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordIncident,
			incident.ID); err != nil {
			return err
		}

		if in.To == domain.IncidentClosed {
			concerns, err = s.closureConcerns(ctx, scope, incident)
			if err != nil {
				return err
			}
		}

		if err := incident.Advance(in.To, in.Reason, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.incidents.UpdateIncident(ctx, scope, incident,
			in.ExpectedVersion); err != nil {
			return err
		}
		incident.Version = in.ExpectedVersion + 1
		updated = incident

		reason := in.Reason
		if len(concerns) > 0 {
			reason += " [closed with: " + strings.Join(concerns, "; ") + "]"
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.incident.advance", ResourceType: "qms_incident",
			ResourceID: incident.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(in.To) + ": " + reason,
		}, now); err != nil {
			return err
		}

		if in.To == domain.IncidentClosed || in.To == domain.IncidentRejected {
			return s.appendEvent(ctx, session, EventIncidentClosed,
				"qms_incident", incident.ID, map[string]any{
					"incident_id": incident.ID,
					"reference":   incident.Reference,
					"state":       string(incident.State),
					"category":    incident.Category,
					"risk_band":   string(incident.Risk.Band),
					"concerns":    concerns,
				}, now)
		}
		return nil
	})
	if err != nil {
		return domain.Incident{}, nil, qualityError(err)
	}
	return updated, concerns, nil
}

// closureConcerns names what a closure is leaving behind (SRS-QMS-003).
//
// Returned to the caller and written to the trail rather than refused, so the
// decision to close anyway is a recorded decision by a named person instead of
// a queue nobody can clear.
func (s *Service) closureConcerns(ctx context.Context,
	scope authctx.TenantScope, incident domain.Incident) ([]string, error) {

	var concerns []string

	if s.config.RCARequiredAtBand != "" &&
		bandRank(incident.Risk.Band) >= bandRank(s.config.RCARequiredAtBand) {
		_, found, err := s.investigations.RCAForIncident(ctx, scope,
			incident.ID)
		if err != nil {
			return nil, err
		}
		if !found {
			concerns = append(concerns,
				"no root cause analysis, which this risk band calls for")
		}
	}

	count, err := s.actions.CountForSource(ctx, scope,
		string(domain.SourceIncident), incident.ID)
	if err != nil {
		return nil, err
	}
	if count == 0 && incident.Reach == domain.ReachHarm {
		concerns = append(concerns,
			"a patient was harmed and no corrective action was raised")
	}
	return concerns, nil
}

// SetRestrictionInput opens or closes a record to ordinary readers.
type SetRestrictionInput struct {
	IncidentID      string
	Restricted      bool
	Reason          string
	ExpectedVersion int64
}

// SetRestriction limits or reopens access to an incident (SRS-QMS-001).
func (s *Service) SetRestriction(ctx context.Context, in SetRestrictionInput) (
	domain.Incident, error) {

	session, scope, err := s.authorize(ctx, PermRestricted)
	if err != nil {
		return domain.Incident{}, err
	}
	now := s.clock.Now()

	var updated domain.Incident
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		incident, err := s.incidents.Incident(ctx, scope, in.IncidentID)
		if err != nil {
			return err
		}
		if in.Restricted {
			err = incident.Restrict(in.Reason)
		} else {
			err = incident.Unrestrict()
		}
		if err != nil {
			return err
		}
		if err := s.incidents.UpdateIncident(ctx, scope, incident,
			in.ExpectedVersion); err != nil {
			return err
		}
		incident.Version = in.ExpectedVersion + 1
		updated = incident

		// Lifting a restriction is the one that needs finding later.
		action := "quality.incident.restrict"
		if !in.Restricted {
			action = "quality.incident.unrestrict"
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "qms_incident",
			ResourceID: incident.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Reason,
		}, now)
	})
	if err != nil {
		return domain.Incident{}, qualityError(err)
	}
	return updated, nil
}

// Trends summarises the incident pattern (SRS-QMS-002).
//
// Over the unredacted records, because a count is not a disclosure: the
// caller learns that the hospital had eleven medication incidents, not what
// any of them said.
func (s *Service) Trends(ctx context.Context, from, to time.Time) (
	[]domain.Trend, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	incidents, err := s.incidents.Incidents(ctx, scope, ports.IncidentFilter{
		From: from, To: to, Limit: reportPageSize,
	})
	if err != nil {
		return nil, qualityError(err)
	}
	return domain.Trends(incidents), nil
}

// PlaceHoldInput puts a record beyond deletion.
type PlaceHoldInput struct {
	RecordClass string
	RecordID    string
	Reason      string
}

// PlaceHold stops a record being destroyed or changed (SRS-QMS-015).
func (s *Service) PlaceHold(ctx context.Context, in PlaceHoldInput) error {
	session, scope, err := s.authorize(ctx, PermHold)
	if err != nil {
		return err
	}
	if !knownRecordClass(in.RecordClass) {
		return rpcerr.Invalid("QMS_UNKNOWN_RECORD_CLASS",
			"a hold names a record class this context holds")
	}
	if s.holds == nil {
		return rpcerr.FailedPrecondition("QMS_NO_HOLD_STORE",
			"this deployment has no legal hold mechanism configured")
	}
	now := s.clock.Now()

	return qualityError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.holds.Place(ctx, scope, in.RecordClass, in.RecordID,
			in.Reason, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.record.hold", ResourceType: in.RecordClass,
			ResourceID: in.RecordID, Outcome: audit.OutcomeSuccess,
			Reason: in.Reason,
		}, now)
	}))
}

// ReleaseHold lifts a hold (SRS-QMS-015).
func (s *Service) ReleaseHold(ctx context.Context, recordClass,
	recordID, reason string) error {

	session, scope, err := s.authorize(ctx, PermHold)
	if err != nil {
		return err
	}
	if s.holds == nil {
		return rpcerr.FailedPrecondition("QMS_NO_HOLD_STORE",
			"this deployment has no legal hold mechanism configured")
	}
	now := s.clock.Now()

	return qualityError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.holds.Release(ctx, scope, recordClass, recordID,
			session.SubjectID, now); err != nil {
			return err
		}
		// The lift is what an inspection asks about, so it is recorded with
		// its reason rather than as the absence of a hold.
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.record.release_hold", ResourceType: recordClass,
			ResourceID: recordID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	}))
}

func knownRecordClass(class string) bool {
	for _, known := range domain.RecordClasses() {
		if known == class {
			return true
		}
	}
	return false
}
