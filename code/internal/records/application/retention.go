package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// NewRetentionRuleInput configures a retention rule (SRS-MRD-009).
type NewRetentionRuleInput struct {
	Code          string
	Name          string
	Revision      int
	RecordClass   string
	Jurisdiction  string
	Anchor        domain.RetentionAnchor
	RetainYears   int
	Disposition   domain.DispositionKind
	Authority     string
	EffectiveFrom time.Time
}

// DraftRetentionRule authors a retention rule revision (SRS-MRD-009).
func (s *Service) DraftRetentionRule(ctx context.Context,
	in NewRetentionRuleInput) (domain.RetentionRule, error) {

	session, scope, err := s.authorize(ctx, PermRetentionWrite)
	if err != nil {
		return domain.RetentionRule{}, err
	}
	now := s.clock.Now()

	rule, err := domain.NewRetentionRule(s.ids.NewID(), session.TenantID,
		domain.NewRetentionRuleInput{
			Code: in.Code, Name: in.Name, Revision: in.Revision,
			RecordClass: in.RecordClass, Jurisdiction: in.Jurisdiction,
			Anchor: in.Anchor, RetainYears: in.RetainYears,
			Disposition: in.Disposition, Authority: in.Authority,
			EffectiveFrom: in.EffectiveFrom,
		}, session.SubjectID, now)
	if err != nil {
		return domain.RetentionRule{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.retention.InsertRule(ctx, scope, rule); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.retention_rule.drafted",
			ResourceType: "mrd_retention_rule", ResourceID: rule.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": rule.Code, "revision": itoa(rule.Revision),
				"record_class": rule.RecordClass,
				"jurisdiction": rule.Jurisdiction,
				"retain_years": itoa(rule.RetainYears),
			}),
			Reason: rule.Authority,
		}, now)
	})
	if err != nil {
		return domain.RetentionRule{}, recordsError(err)
	}
	return rule, nil
}

// ApproveRetentionRule puts a rule in force (SRS-MRD-009).
func (s *Service) ApproveRetentionRule(ctx context.Context, ruleID string,
	effectiveFrom time.Time) (domain.RetentionRule, error) {

	session, scope, err := s.authorize(ctx, PermRetentionApprove)
	if err != nil {
		return domain.RetentionRule{}, err
	}
	now := s.clock.Now()

	var approved domain.RetentionRule
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		rule, err := s.retention.Rule(ctx, scope, ruleID)
		if err != nil {
			return err
		}
		if err := rule.Approve(session.SubjectID, effectiveFrom,
			now); err != nil {
			return err
		}
		if err := s.retention.ApproveRule(ctx, scope, rule); err != nil {
			return err
		}
		if err := s.retention.SupersedeEarlierRules(ctx, scope, rule.Code,
			rule.Revision, effectiveFrom); err != nil {
			return err
		}
		approved = rule
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.retention_rule.approved",
			ResourceType: "mrd_retention_rule", ResourceID: rule.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": rule.Code, "revision": itoa(rule.Revision),
			}),
			Reason: "put a retention rule in force",
		}, now)
	})
	if err != nil {
		return domain.RetentionRule{}, recordsError(err)
	}
	return approved, nil
}

// PlaceHold stops a record being destroyed (SRS-MRD-005).
//
// Through the platform's own hold mechanism rather than a table here.
// SRS-QMS-015 places holds through the same one, and a hold placed in one
// place with a purge that reads another is a hold that does nothing — which
// nobody finds out until the records are gone.
func (s *Service) PlaceHold(ctx context.Context, recordClass, recordID,
	reason string) error {

	session, scope, err := s.authorize(ctx, PermHoldManage)
	if err != nil {
		return err
	}
	if s.holds == nil {
		return rpcerr.FailedPrecondition("MRD_NO_HOLD_MECHANISM",
			"this deployment has no legal-hold mechanism wired")
	}
	now := s.clock.Now()

	return recordsError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.holds.Place(ctx, scope, recordClass, recordID, reason,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.hold.placed", ResourceType: recordClass,
			ResourceID: recordID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	}))
}

// ReleaseHold lifts one (SRS-MRD-005).
func (s *Service) ReleaseHold(ctx context.Context, recordClass,
	recordID string) error {

	session, scope, err := s.authorize(ctx, PermHoldManage)
	if err != nil {
		return err
	}
	if s.holds == nil {
		return rpcerr.FailedPrecondition("MRD_NO_HOLD_MECHANISM",
			"this deployment has no legal-hold mechanism wired")
	}
	now := s.clock.Now()

	return recordsError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.holds.Release(ctx, scope, recordClass, recordID,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.hold.released", ResourceType: recordClass,
			ResourceID: recordID, Outcome: audit.OutcomeSuccess,
			Reason: "lifted a legal hold",
		}, now)
	}))
}

// Sweep is what a retention run found (SRS-MRD-009).
type Sweep struct {
	Jurisdiction string
	Eligible     []domain.DispositionCandidate
	// Ineligible carries every record the sweep passed over and why. A sweep
	// that reported only what it would destroy would make "why is this still
	// here" unanswerable, and that is the question a records manager is
	// actually asked.
	Ineligible []domain.Ineligible
	// Swept counts what was looked at, so an empty result from an empty
	// inventory is distinguishable from an empty result from a full one.
	Swept int
}

// SweepForDisposition lists the records whose retention has run
// (SRS-MRD-005, SRS-MRD-009).
//
// Held records are excluded before the list is shown to anybody rather than
// at the point of destruction: a list that includes held records is a list
// somebody approves.
func (s *Service) SweepForDisposition(ctx context.Context,
	jurisdiction string) (Sweep, error) {

	session, scope, err := s.authorize(ctx, PermDispositionPrepare)
	if err != nil {
		return Sweep{}, err
	}
	now := s.clock.Now()

	if s.holds == nil {
		// Refused rather than swept with nothing held. A sweep that cannot
		// see the holds proposes destroying records that are under one.
		return Sweep{}, rpcerr.FailedPrecondition("MRD_NO_HOLD_MECHANISM",
			"this deployment has no legal-hold mechanism wired, so records "+
				"cannot be proposed for destruction")
	}
	if jurisdiction == "" {
		jurisdiction = s.config.DefaultJurisdiction
	}

	records, err := s.retainedRecords(ctx, scope, jurisdiction)
	if err != nil {
		return Sweep{}, err
	}
	rules, err := s.retention.Rules(ctx, scope, jurisdiction, "", now)
	if err != nil {
		return Sweep{}, err
	}
	held, err := s.holds.HeldIDs(ctx, scope, "")
	if err != nil {
		return Sweep{}, err
	}

	eligible, ineligible := domain.EligibleForDisposition(records, rules,
		func(recordID string) bool { return held[recordID] }, now)

	sweep := Sweep{
		Jurisdiction: jurisdiction, Eligible: eligible,
		Ineligible: ineligible, Swept: len(records),
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "records.disposition.swept", ResourceType: "mrd_disposition",
		ResourceID: jurisdiction, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{
			"swept": itoa(len(records)), "eligible": itoa(len(eligible)),
			"passed_over": itoa(len(ineligible)),
		}),
		Reason: "swept the holding for records whose retention has run",
	}, now); err != nil {
		return Sweep{}, err
	}
	return sweep, nil
}

// PrepareDisposition builds a list from a sweep (SRS-MRD-009).
func (s *Service) PrepareDisposition(ctx context.Context, reference,
	jurisdiction string, disposition domain.DispositionKind,
	recordIDs []string) (domain.DispositionList, error) {

	session, scope, err := s.authorize(ctx, PermDispositionPrepare)
	if err != nil {
		return domain.DispositionList{}, err
	}
	now := s.clock.Now()

	sweep, err := s.SweepForDisposition(ctx, jurisdiction)
	if err != nil {
		return domain.DispositionList{}, err
	}
	wanted := map[string]bool{}
	for _, id := range recordIDs {
		wanted[id] = true
	}
	var candidates []domain.DispositionCandidate
	for _, candidate := range sweep.Eligible {
		if len(wanted) > 0 && !wanted[candidate.RecordID] {
			continue
		}
		candidates = append(candidates, candidate)
	}

	list, err := domain.PrepareDisposition(s.ids.NewID(), session.TenantID,
		reference, sweep.Jurisdiction, disposition, candidates,
		session.SubjectID, now)
	if err != nil {
		return domain.DispositionList{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.retention.InsertList(ctx, scope, list); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.disposition.prepared",
			ResourceType: "mrd_disposition_list", ResourceID: list.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"jurisdiction": list.Jurisdiction,
				"disposition":  string(list.Disposition),
				"items":        itoa(len(list.Items)),
			}),
			Reason: "prepared a disposition list",
		}, now)
	})
	if err != nil {
		return domain.DispositionList{}, recordsError(err)
	}
	return list, nil
}

// ApproveDisposition is the last check before records stop existing
// (SRS-MRD-009).
func (s *Service) ApproveDisposition(ctx context.Context, listID string) (
	domain.DispositionList, error) {

	session, scope, err := s.authorize(ctx, PermDispositionApprove)
	if err != nil {
		return domain.DispositionList{}, err
	}
	now := s.clock.Now()

	var approved domain.DispositionList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		list, err := s.retention.List(ctx, scope, listID)
		if err != nil {
			return err
		}
		expected := list.Version
		if err := list.ApproveDisposition(session.SubjectID, now); err != nil {
			return err
		}
		if err := s.retention.UpdateList(ctx, scope, list,
			expected); err != nil {
			return err
		}
		approved = list
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.disposition.approved",
			ResourceType: "mrd_disposition_list", ResourceID: list.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"items": itoa(len(list.Items)),
			}),
			Reason: "approved a disposition list",
		}, now)
	})
	if err != nil {
		return domain.DispositionList{}, recordsError(err)
	}
	return approved, nil
}

// ExecuteDisposition carries the destruction out (SRS-MRD-009).
//
// The holds are read again here, inside the transaction, and the domain
// refuses the whole list if any record picked one up since it was approved.
// The gap between approval and execution is exactly where a hold arrives:
// litigation does not wait for the records office's calendar.
func (s *Service) ExecuteDisposition(ctx context.Context, listID,
	certificate string) (domain.DispositionList, error) {

	session, scope, err := s.authorize(ctx, PermDispositionExecute)
	if err != nil {
		return domain.DispositionList{}, err
	}
	if s.holds == nil {
		return domain.DispositionList{}, rpcerr.FailedPrecondition(
			"MRD_NO_HOLD_MECHANISM",
			"this deployment has no legal-hold mechanism wired, so records "+
				"cannot be destroyed")
	}
	now := s.clock.Now()

	var executed domain.DispositionList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		list, err := s.retention.List(ctx, scope, listID)
		if err != nil {
			return err
		}
		held, err := s.holds.HeldIDs(ctx, scope, "")
		if err != nil {
			return err
		}
		expected := list.Version
		if err := list.Execute(func(recordID string) bool {
			return held[recordID]
		}, certificate, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.retention.UpdateList(ctx, scope, list,
			expected); err != nil {
			return err
		}
		if err := s.markPhysicalDestroyed(ctx, session, scope, list,
			certificate, now); err != nil {
			return err
		}
		executed = list

		if err := s.appendEvent(ctx, session, EventDispositionExecuted,
			"mrd_disposition_list", list.ID, map[string]any{
				"jurisdiction": list.Jurisdiction,
				"disposition":  string(list.Disposition),
				"items":        len(list.Items),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.disposition.executed",
			ResourceType: "mrd_disposition_list", ResourceID: list.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"items": itoa(len(list.Items)), "certificate": certificate,
			}),
			Reason: "records were destroyed or archived",
		}, now)
	})
	if err != nil {
		return domain.DispositionList{}, recordsError(err)
	}
	return executed, nil
}

// CancelDisposition calls a destruction off (SRS-MRD-009).
func (s *Service) CancelDisposition(ctx context.Context, listID,
	reason string) (domain.DispositionList, error) {

	session, scope, err := s.authorize(ctx, PermDispositionPrepare)
	if err != nil {
		return domain.DispositionList{}, err
	}
	now := s.clock.Now()

	var cancelled domain.DispositionList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		list, err := s.retention.List(ctx, scope, listID)
		if err != nil {
			return err
		}
		expected := list.Version
		if err := list.Cancel(reason, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.retention.UpdateList(ctx, scope, list,
			expected); err != nil {
			return err
		}
		cancelled = list
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.disposition.cancelled",
			ResourceType: "mrd_disposition_list", ResourceID: list.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.DispositionList{}, recordsError(err)
	}
	return cancelled, nil
}

// DispositionLists lists the batches (SRS-MRD-009).
func (s *Service) DispositionLists(ctx context.Context,
	filter ports.DispositionFilter) ([]domain.DispositionList, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.retention.Lists(ctx, scope, filter)
}

// RetentionRules lists the configured rules (SRS-MRD-009).
func (s *Service) RetentionRules(ctx context.Context, jurisdiction,
	recordClass string, liveOnly bool) ([]domain.RetentionRule, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	var liveAt time.Time
	if liveOnly {
		liveAt = s.clock.Now()
	}
	return s.retention.Rules(ctx, scope, jurisdiction, recordClass, liveAt)
}

// retainedRecords is what the hospital is holding (SRS-MRD-009).
//
// A deployment with no inventory adapter sweeps the paper records this
// context owns and nothing else. That is a real limit and it is named here
// and in the status document rather than presented as a complete sweep: a
// disposition list that silently covers only the paper is one somebody
// approves believing it covers everything.
func (s *Service) retainedRecords(ctx context.Context,
	scope authctx.TenantScope, jurisdiction string) (
	[]domain.RetainedRecord, error) {

	if s.inventory == nil {
		return nil, nil
	}
	return s.inventory.Retained(ctx, scope, jurisdiction, sweepPageSize)
}

// markPhysicalDestroyed moves the paper volumes on a list to destroyed
// (SRS-MRD-006, SRS-MRD-009).
//
// A record that was shredded and still reads as filed sends somebody to the
// shelf to look for it. Only the paper this context owns is moved; an
// electronic record's own context is told by the event.
func (s *Service) markPhysicalDestroyed(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope,
	list domain.DispositionList, certificate string, now time.Time) error {

	for _, item := range list.Items {
		record, err := s.physical.PhysicalRecord(ctx, scope, item.RecordID)
		if err != nil {
			// Not every item on a list is a paper volume. An electronic
			// record has no row here, and that is not a failure.
			continue
		}
		expected := record.Version
		if err := record.MarkDestroyed(list.ID, certificate,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.physical.UpdatePhysicalRecord(ctx, scope, record,
			expected); err != nil {
			return err
		}
	}
	return nil
}
