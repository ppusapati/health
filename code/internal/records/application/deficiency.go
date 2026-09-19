package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// RaiseDeficiencies turns a chart's gaps into a worklist (SRS-MRD-002).
//
// Derived from the checklist in force rather than typed, and idempotent
// against what is already open: running the sweep twice on a chart nobody has
// touched raises nothing the second time. A worklist that doubles every time
// a job runs is one the clinicians it is sent to stop reading.
func (s *Service) RaiseDeficiencies(ctx context.Context, encounterID string) (
	[]domain.Deficiency, error) {

	session, scope, err := s.authorize(ctx, PermDeficiencyManage)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	status, facts, err := s.chartStatus(ctx, scope, encounterID, now)
	if err != nil {
		return nil, err
	}

	var raised []domain.Deficiency
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		open, err := s.deficiencies.Deficiencies(ctx, scope,
			ports.DeficiencyFilter{
				EncounterID: encounterID, OpenOnly: true,
				Limit: sweepPageSize,
			})
		if err != nil {
			return err
		}
		already := map[string]bool{}
		for _, deficiency := range open {
			already[deficiency.DocumentKind] = true
		}

		for _, gap := range status.Gaps {
			if already[gap.Kind] {
				continue
			}
			kind := domain.DeficiencyUnsigned
			owner := gap.OwnerID
			if gap.Missing {
				kind = domain.DeficiencyMissing
				// Nobody wrote it, so the gap names nobody. It is owed by
				// whoever the encounter made responsible; a deficiency
				// raised against nobody goes into a worklist nobody reads.
				owner = facts.AttendingProviderID
			}
			deficiency, err := domain.RaiseDeficiency(s.ids.NewID(),
				session.TenantID, domain.NewDeficiencyInput{
					PatientID: facts.PatientID, EncounterID: encounterID,
					FacilityID: facts.FacilityID, Kind: kind,
					DocumentKind: gap.Kind, Label: gap.Label,
					DocumentID: gap.DocumentID, OwnerID: owner,
					ChecklistCode:     status.ChecklistCode,
					ChecklistRevision: status.ChecklistRevision,
					DueBy:             gap.DueBy,
				}, session.SubjectID, now)
			if err != nil {
				return err
			}
			if err := s.deficiencies.InsertDeficiency(ctx, scope,
				deficiency); err != nil {
				return err
			}
			if err := s.appendEvent(ctx, session, EventDeficiencyRaised,
				"mrd_deficiency", deficiency.ID, map[string]any{
					"encounter_id":  encounterID,
					"kind":          string(deficiency.Kind),
					"document_kind": deficiency.DocumentKind,
					"owner_id":      deficiency.OwnerID,
				}, now); err != nil {
				return err
			}
			raised = append(raised, deficiency)
		}

		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.deficiencies.raised",
			ResourceType: "mrd_chart", ResourceID: encounterID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"raised": itoa(len(raised)), "gaps": itoa(len(status.Gaps)),
				"checklist": status.ChecklistCode,
			}),
			Reason: "raised chart deficiencies from the checklist in force",
		}, now)
	})
	if err != nil {
		return nil, recordsError(err)
	}
	return raised, nil
}

// RaiseCodingQuery sends a coder's question to the clinician (SRS-MRD-003,
// SRS-MRD-008).
//
// A deficiency rather than an edit. The whole of SRS-MRD-008 is that a
// question about signed history is answered by the person who signed it, and
// the way to mean that here is that the only thing coding can create is a
// question.
func (s *Service) RaiseCodingQuery(ctx context.Context, encounterID,
	documentID, ownerID, detail string, dueBy time.Time) (
	domain.Deficiency, error) {

	session, scope, err := s.authorize(ctx, PermCodingQuery)
	if err != nil {
		return domain.Deficiency{}, err
	}
	now := s.clock.Now()

	facts, _, err := s.chartInputs(ctx, scope, encounterID)
	if err != nil {
		return domain.Deficiency{}, err
	}

	deficiency, err := domain.RaiseDeficiency(s.ids.NewID(),
		session.TenantID, domain.NewDeficiencyInput{
			PatientID: facts.PatientID, EncounterID: encounterID,
			FacilityID: facts.FacilityID, Kind: domain.DeficiencyCoding,
			DocumentKind: "coding_query", Label: "Coding query",
			DocumentID: documentID, Detail: detail, OwnerID: ownerID,
			DueBy: dueBy,
		}, session.SubjectID, now)
	if err != nil {
		return domain.Deficiency{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.deficiencies.InsertDeficiency(ctx, scope,
			deficiency); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventDeficiencyRaised,
			"mrd_deficiency", deficiency.ID, map[string]any{
				"encounter_id": encounterID, "kind": "coding_query",
				"owner_id": ownerID,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.coding_query.raised",
			ResourceType: "mrd_deficiency", ResourceID: deficiency.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"encounter_id": encounterID, "owner_id": ownerID,
			}),
			Reason: "sent a coding query back to the clinician",
		}, now)
	})
	if err != nil {
		return domain.Deficiency{}, recordsError(err)
	}
	return deficiency, nil
}

// ResolveDeficiency answers a deficiency with a document (SRS-MRD-002,
// SRS-MRD-008).
//
// The answering document is named, and for an inadequate document it has to
// be a different one: the domain refuses a resolution that points back at the
// document complained about. That is SRS-MRD-008's "without altering signed
// history" made structural — an addendum answers it, an edit cannot, and
// there is no port here that could make the edit anyway.
func (s *Service) ResolveDeficiency(ctx context.Context, deficiencyID,
	documentID string) (domain.Deficiency, error) {

	session, scope, err := s.authorize(ctx, PermDeficiencyResolve)
	if err != nil {
		return domain.Deficiency{}, err
	}
	now := s.clock.Now()

	var resolved domain.Deficiency
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		deficiency, err := s.deficiencies.Deficiency(ctx, scope, deficiencyID)
		if err != nil {
			return err
		}
		expected := deficiency.Version
		if err := deficiency.Resolve(documentID, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.deficiencies.UpdateDeficiency(ctx, scope, deficiency,
			expected); err != nil {
			return err
		}
		resolved = deficiency
		if err := s.appendEvent(ctx, session, EventDeficiencyResolved,
			"mrd_deficiency", deficiency.ID, map[string]any{
				"encounter_id": deficiency.EncounterID,
				"kind":         string(deficiency.Kind),
			}, now); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "records.deficiency.resolved",
			ResourceType: "mrd_deficiency", ResourceID: deficiency.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"answered_by_document": documentID,
			}),
			Reason: "answered a chart deficiency",
		}, now); err != nil {
			return err
		}
		return s.announceIfComplete(ctx, session, scope,
			deficiency.EncounterID, now)
	})
	if err != nil {
		return domain.Deficiency{}, recordsError(err)
	}
	return resolved, nil
}

// WaiveDeficiency writes a deficiency off (SRS-MRD-002).
//
// Its own permission and its own reason, because this is the one way a chart
// leaves the worklist without the document ever arriving. The encounter is
// then reported as incompletable rather than complete: a hospital that counts
// waivers as completions can reach a hundred per cent by waiving.
func (s *Service) WaiveDeficiency(ctx context.Context, deficiencyID,
	reason string) (domain.Deficiency, error) {

	session, scope, err := s.authorize(ctx, PermDeficiencyWaive)
	if err != nil {
		return domain.Deficiency{}, err
	}
	now := s.clock.Now()

	var waived domain.Deficiency
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		deficiency, err := s.deficiencies.Deficiency(ctx, scope, deficiencyID)
		if err != nil {
			return err
		}
		expected := deficiency.Version
		if err := deficiency.Waive(reason, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.deficiencies.UpdateDeficiency(ctx, scope, deficiency,
			expected); err != nil {
			return err
		}
		waived = deficiency
		if err := s.appendEvent(ctx, session, EventDeficiencyWaived,
			"mrd_deficiency", deficiency.ID, map[string]any{
				"encounter_id": deficiency.EncounterID,
				"kind":         string(deficiency.Kind),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.deficiency.waived",
			ResourceType: "mrd_deficiency", ResourceID: deficiency.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Deficiency{}, recordsError(err)
	}
	return waived, nil
}

// ReassignDeficiency moves a deficiency to another clinician (SRS-MRD-002).
//
// The age does not reset. A deficiency passed between three registrars is
// three weeks old, not new, and an aging report that said otherwise would
// make passing it on the fastest way to clear a worklist.
func (s *Service) ReassignDeficiency(ctx context.Context, deficiencyID,
	ownerID, reason string) (domain.Deficiency, error) {

	session, scope, err := s.authorize(ctx, PermDeficiencyManage)
	if err != nil {
		return domain.Deficiency{}, err
	}
	now := s.clock.Now()

	var reassigned domain.Deficiency
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		deficiency, err := s.deficiencies.Deficiency(ctx, scope, deficiencyID)
		if err != nil {
			return err
		}
		expected := deficiency.Version
		was := deficiency.OwnerID
		if err := deficiency.Reassign(ownerID, reason, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.deficiencies.UpdateDeficiency(ctx, scope, deficiency,
			expected); err != nil {
			return err
		}
		reassigned = deficiency
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.deficiency.reassigned",
			ResourceType: "mrd_deficiency", ResourceID: deficiency.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"was": was, "now": deficiency.OwnerID,
			}),
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Deficiency{}, recordsError(err)
	}
	return reassigned, nil
}

// Deficiencies lists a worklist (SRS-MRD-002).
func (s *Service) Deficiencies(ctx context.Context,
	filter ports.DeficiencyFilter) ([]domain.Deficiency, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.deficiencies.Deficiencies(ctx, scope, filter)
}

// AgingReport bands the open deficiencies by age (SRS-MRD-002).
func (s *Service) AgingReport(ctx context.Context,
	filter ports.DeficiencyFilter) ([]domain.AgeBucket, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	filter.OpenOnly = true
	filter.Limit = sweepPageSize
	deficiencies, err := s.deficiencies.Deficiencies(ctx, scope, filter)
	if err != nil {
		return nil, err
	}
	return domain.AgingReport(deficiencies, s.config.AgingBands, now), nil
}

// CompletionSummary reports how many charts are complete (SRS-MRD-002).
func (s *Service) CompletionSummary(ctx context.Context,
	encounterIDs []string) (domain.CompletionSummary, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.CompletionSummary{}, err
	}
	now := s.clock.Now()

	var all []domain.Deficiency
	for _, encounterID := range encounterIDs {
		found, err := s.deficiencies.Deficiencies(ctx, scope,
			ports.DeficiencyFilter{
				EncounterID: encounterID, Limit: sweepPageSize,
			})
		if err != nil {
			return domain.CompletionSummary{}, err
		}
		all = append(all, found...)
	}
	return domain.SummariseCompletion(encounterIDs, all, now), nil
}

// EscalateOverdueDeficiencies raises the ones that have run past their date
// and their grace period (SRS-MRD-002).
//
// Once each. A deficiency that escalated yesterday and is still open is still
// a problem and does not produce a second notice: a channel that repeats is
// one people filter.
func (s *Service) EscalateOverdueDeficiencies(ctx context.Context) (int, error) {
	session, scope, err := s.authorize(ctx, PermDeficiencyManage)
	if err != nil {
		return 0, err
	}
	now := s.clock.Now()

	raised := 0
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		candidates, err := s.deficiencies.EscalationCandidates(ctx, scope,
			now.Add(-s.config.DeficiencyGrace), sweepPageSize)
		if err != nil {
			return err
		}
		for _, deficiency := range domain.EscalationCandidates(candidates,
			s.config.DeficiencyGrace, now) {

			expected := deficiency.Version
			deficiency.MarkEscalated(now)
			if err := s.deficiencies.UpdateDeficiency(ctx, scope, deficiency,
				expected); err != nil {
				return err
			}
			if err := s.escalate(ctx, session, scope, ports.Notice{
				Kind: EscalationDeficiency, Subject: deficiency.ID,
				FacilityID: deficiency.FacilityID,
				Summary: deficiency.Label + " is " +
					itoa(deficiency.AgeDays(now)) + " days overdue",
			}, now); err != nil {
				return err
			}
			raised++
		}
		return nil
	})
	if err != nil {
		return 0, recordsError(err)
	}
	return raised, nil
}

// announceIfComplete publishes a chart's completion once nothing is open
// (SRS-MRD-002).
//
// An event rather than a stored flag, and only for a chart with nothing
// outstanding at all: a waiver leaves the encounter incompletable, and
// announcing that as complete would be the same lie as counting it.
func (s *Service) announceIfComplete(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope, encounterID string,
	now time.Time) error {

	open, err := s.deficiencies.Deficiencies(ctx, scope,
		ports.DeficiencyFilter{
			EncounterID: encounterID, OpenOnly: true, Limit: sweepPageSize,
		})
	if err != nil {
		return err
	}
	if len(open) > 0 {
		return nil
	}
	all, err := s.deficiencies.Deficiencies(ctx, scope,
		ports.DeficiencyFilter{EncounterID: encounterID, Limit: sweepPageSize})
	if err != nil {
		return err
	}
	summary := domain.SummariseCompletion([]string{encounterID}, all, now)
	if summary.Complete != 1 {
		return nil
	}
	return s.appendEvent(ctx, session, EventChartComplete, "mrd_chart",
		encounterID, map[string]any{
			"encounter_id": encounterID,
			"deficiencies": len(all),
		}, now)
}
