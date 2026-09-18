package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Scale is the recovery score this deployment discharges on (SRS-ANE-008).
//
// Exposed so the recovery screen can render the components it is about to
// collect rather than hard-coding a scale the unit may not use.
func (s *Service) Scale(ctx context.Context) (domain.RecoveryScale, error) {
	if _, _, err := s.authorize(ctx, PermRead); err != nil {
		return domain.RecoveryScale{}, err
	}
	scale := s.config.scale()
	if err := scale.Validate(); err != nil {
		// A misconfigured scale is a deployment fault, not a clinical one, and
		// silently substituting a different scale would produce scores read
		// against the wrong bar.
		return domain.RecoveryScale{}, rpcerr.Internal("ANE_SCALE_INVALID",
			"the configured recovery scale is not usable").WithCause(err)
	}
	return scale, nil
}

// AssessRecovery scores a patient in recovery (SRS-ANE-008).
//
// A component with no score is recorded as missing rather than as zero. A
// partial assessment is not a low one: scoring an unscored component as zero
// would trap a patient in recovery, and scoring it as full would discharge
// one.
func (s *Service) AssessRecovery(ctx context.Context, recordID string,
	scores map[string]int) (domain.RecoveryAssessment, error) {

	session, scope, err := s.authorize(ctx, PermRecover)
	if err != nil {
		return domain.RecoveryAssessment{}, err
	}
	now := s.clock.Now()

	record, err := s.openRecord(ctx, scope, recordID)
	if err != nil {
		return domain.RecoveryAssessment{}, err
	}

	assessment, err := domain.Assess(s.ids.NewID(), session.TenantID, record.ID,
		s.config.scale(), scores, session.SubjectID, now)
	if err != nil {
		return domain.RecoveryAssessment{}, anaesthesiaError(err)
	}
	if err := s.recovery.InsertAssessment(ctx, scope, assessment); err != nil {
		return domain.RecoveryAssessment{}, err
	}
	return assessment, nil
}

// RecoveryAssessments reads a record's PACU scores.
func (s *Service) RecoveryAssessments(ctx context.Context, recordID string) (
	[]domain.RecoveryAssessment, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.recovery.Assessments(ctx, scope, recordID)
}

// EvaluateDischarge reports whether a patient may leave recovery, and why not
// (SRS-ANE-008).
//
// Every refusal, not the first: a nurse who fixes one and is told about the
// next has been made to discover the requirements one at a time.
func (s *Service) EvaluateDischarge(ctx context.Context, recordID string) (
	domain.DischargeDecision, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.DischargeDecision{}, err
	}

	handovers, err := s.records.Handovers(ctx, scope, recordID)
	if err != nil {
		return domain.DischargeDecision{}, err
	}
	assessments, err := s.recovery.Assessments(ctx, scope, recordID)
	if err != nil {
		return domain.DischargeDecision{}, err
	}
	return domain.EvaluateDischarge(len(handovers) > 0, assessments), nil
}

// DischargeFromRecovery records a discharge from recovery (SRS-ANE-008).
//
// A discharge below the threshold needs its own permission and a reason. A
// patient nobody handed over cannot be discharged at all: the override exists
// for one who is clinically ready and scores below a bar, not for one nobody
// has taken responsibility for.
func (s *Service) DischargeFromRecovery(ctx context.Context, recordID,
	destination, overrideReason string) (domain.Discharge, error) {

	permission := PermRecover
	if overrideReason != "" {
		permission = PermOverride
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.Discharge{}, err
	}
	now := s.clock.Now()

	record, err := s.openRecord(ctx, scope, recordID)
	if err != nil {
		return domain.Discharge{}, err
	}

	var out domain.Discharge
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		handovers, err := s.records.Handovers(ctx, scope, record.ID)
		if err != nil {
			return err
		}
		assessments, err := s.recovery.Assessments(ctx, scope, record.ID)
		if err != nil {
			return err
		}
		decision := domain.EvaluateDischarge(len(handovers) > 0, assessments)

		// A caller who sent no reason and does not need one: the ordinary
		// path. A caller who sent one but does not need it is not overriding,
		// and recording an override that did not happen would make the
		// override report meaningless.
		reason := overrideReason
		if decision.Allowed() {
			reason = ""
		}

		discharge, err := domain.NewDischarge(s.ids.NewID(), session.TenantID,
			record.ID, destination, decision, reason, session.SubjectID, now)
		if err != nil {
			return anaesthesiaError(err)
		}
		if err := s.recovery.InsertDischarge(ctx, scope, discharge); err != nil {
			return err
		}
		out = discharge

		// The record closes when the patient leaves recovery, which is the
		// last thing anaesthesia does for this operation.
		closed := record
		if err := closed.Close(now); err != nil {
			return anaesthesiaError(err)
		}
		if err := s.records.UpdateStatus(
			ctx, scope, closed.ID, closed.Status, closed.EndedAt); err != nil {
			return err
		}

		eventType := EventRecoveryDischarge
		if discharge.Overridden {
			eventType = EventDischargeOverride
		}
		if err := s.appendEvent(ctx, session, eventType, "anaesthesia_record",
			record.ID, map[string]any{
				"case_id":     record.CaseID,
				"patient_id":  record.PatientID,
				"destination": discharge.Destination,
				"overridden":  discharge.Overridden,
				"score_id":    discharge.ScoreID,
			}, now); err != nil {
			return err
		}

		auditReason := "discharged to " + discharge.Destination
		if discharge.Overridden {
			auditReason = "discharged to " + discharge.Destination +
				" below the discharge threshold: " + discharge.OverrideReason
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "anaesthesia_discharge", ResourceID: discharge.ID,
			Outcome: audit.OutcomeSuccess, Reason: auditReason,
		}, now)
	})
	if err != nil {
		return domain.Discharge{}, err
	}
	return out, nil
}

// OrderPain records a post-operative pain plan (SRS-ANE-009).
//
// It names the prescriptions rather than being one. The drug chart is SRS-MED's
// and a second place to prescribe from is how a patient gets two doses; what
// this holds is the plan around it — what to watch, when to review, who to
// call at three in the morning.
func (s *Service) OrderPain(ctx context.Context, in domain.NewPainOrderInput) (
	domain.PainOrder, error) {

	session, scope, err := s.authorize(ctx, PermPrescribePain)
	if err != nil {
		return domain.PainOrder{}, err
	}
	now := s.clock.Now()

	record, err := s.records.Record(ctx, scope, in.RecordID)
	if err != nil {
		return domain.PainOrder{}, err
	}
	// The plan outlives the anaesthetic record, so a closed record is fine
	// here: the pain team reviews for days after the patient leaves recovery.
	in.PatientID, in.EncounterID = record.PatientID, record.EncounterID

	order, err := domain.NewPainOrder(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.PainOrder{}, anaesthesiaError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.recovery.InsertPainOrder(ctx, scope, order); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventPainOrdered,
			"anaesthesia_pain_order", order.ID, map[string]any{
				"record_id":  order.RecordID,
				"patient_id": order.PatientID,
				"modality":   order.Modality,
				"review_by":  order.ReviewBy,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPrescribePain,
			ResourceType: "anaesthesia_pain_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "pain plan: " + order.Modality,
		}, now)
	})
	if err != nil {
		return domain.PainOrder{}, err
	}
	return order, nil
}

// PainRound is the acute pain team's worklist, soonest review first
// (SRS-ANE-009).
//
// A plan with no review time sorts last rather than being hidden: an
// unreviewed plan is the one the round exists to find.
func (s *Service) PainRound(ctx context.Context, limit int32) (
	[]domain.PainOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.recovery.RunningPainOrders(ctx, scope, clampPageSize(limit))
}

// PainOrders reads a record's pain plans.
func (s *Service) PainOrders(ctx context.Context, recordID string) (
	[]domain.PainOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.recovery.PainOrders(ctx, scope, recordID)
}

// StopPain ends a pain plan (SRS-ANE-009).
func (s *Service) StopPain(ctx context.Context, orderID string,
	at time.Time) error {

	session, scope, err := s.authorize(ctx, PermPrescribePain)
	if err != nil {
		return err
	}
	now := s.clock.Now()
	if at.IsZero() {
		at = now
	}

	stopped, err := s.recovery.StopPainOrder(
		ctx, scope, orderID, session.SubjectID, at)
	if err != nil {
		return err
	}
	if !stopped {
		return rpcerr.FailedPrecondition("ANE_PAIN_ORDER_STOPPED",
			"this pain plan was already stopped")
	}
	return s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermPrescribePain,
		ResourceType: "anaesthesia_pain_order", ResourceID: orderID,
		Outcome: audit.OutcomeSuccess, Reason: "pain plan stopped",
	}, now)
}

// Summary derives the anaesthetic summary (SRS-ANE-010).
//
// Derived rather than written. A summary somebody typed separately is a second
// account that disagrees with the record by the time anybody reads it, and it
// is the version that reaches the ward.
func (s *Service) Summary(ctx context.Context, recordID string) (
	domain.Summary, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Summary{}, err
	}
	now := s.clock.Now()

	record, err := s.records.Record(ctx, scope, recordID)
	if err != nil {
		return domain.Summary{}, err
	}

	assessments, err := s.assessments.Assessments(ctx, scope, record.CaseID)
	if err != nil {
		return domain.Summary{}, err
	}
	var assessment *domain.Assessment
	if current, ok := domain.CurrentAssessment(assessments); ok {
		assessment = &current
	}

	airway, err := s.records.AirwayEvents(ctx, scope, record.ID)
	if err != nil {
		return domain.Summary{}, err
	}
	drugs, err := s.records.Drugs(ctx, scope, record.ID)
	if err != nil {
		return domain.Summary{}, err
	}
	fluids, err := s.records.Fluids(ctx, scope, record.ID)
	if err != nil {
		return domain.Summary{}, err
	}
	scores, err := s.recovery.Assessments(ctx, scope, record.ID)
	if err != nil {
		return domain.Summary{}, err
	}
	discharge, hasDischarge, err := s.recovery.Discharge(ctx, scope, record.ID)
	if err != nil {
		return domain.Summary{}, err
	}

	var disposal *domain.Discharge
	if hasDischarge {
		disposal = &discharge
	}

	summary := domain.BuildSummary(record, assessment, airway,
		s.selectKeyDrugs(drugs), fluids, s.summaryEvents(drugs, airway),
		scores, disposal)

	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermRead,
		ResourceType: "anaesthesia_record", ResourceID: record.ID,
		Outcome: audit.OutcomeSuccess, Reason: "anaesthetic summary generated",
	}, now); err != nil {
		return domain.Summary{}, err
	}
	return summary, nil
}

// selectKeyDrugs picks the entries a summary reader looks for.
//
// A summary of a four-hour case cannot be every drug entry, and which drugs
// matter — reversal agents, vasopressors, antibiotics — is a deployment's
// decision rather than this package's. With none configured the summary
// carries them all, which is verbose but never misleading: quietly dropping
// drugs would make a summary that reads as a case where none were given.
func (s *Service) selectKeyDrugs(all []domain.DrugEntry) []domain.DrugEntry {
	wanted := s.config.keyDrugs()
	if len(wanted) == 0 {
		return all
	}
	out := make([]domain.DrugEntry, 0, len(all))
	for _, drug := range all {
		if wanted[drug.DrugCode] {
			out = append(out, drug)
		}
	}
	return out
}

// summaryEvents names the intraoperative entries worth calling out.
//
// Not every value: a summary of a four-hour case cannot be a thousand
// readings. What is here is what somebody reading the summary afterwards has
// to know without opening the chart.
func (s *Service) summaryEvents(drugs []domain.DrugEntry,
	airway []domain.AirwayEvent) []string {

	var out []string
	if summary := domain.SummariseAirway(airway); summary.Difficult {
		out = append(out, "difficult airway: "+
			itoa(summary.Attempts)+" attempts, "+summary.FinalDevice)
	}
	for _, drug := range drugs {
		if drug.Infusion && drug.StoppedAt.IsZero() {
			// An infusion still running at the end of the case is the entry
			// recovery most needs: the pump leaves theatre with the patient.
			out = append(out, "infusion running at handover: "+drug.DrugCode)
		}
	}
	return out
}
