package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RecordAssessment records a pre-anaesthesia assessment (SRS-ANE-001).
//
// A second assessment for the same case supersedes the first rather than
// replacing it. A patient assessed in clinic and reassessed on the morning of
// surgery has two records, and the difference between them — a chest infection
// that appeared in the fortnight between — is frequently the point.
func (s *Service) RecordAssessment(ctx context.Context, in domain.NewAssessmentInput) (
	domain.Assessment, error) {

	session, scope, err := s.authorize(ctx, PermAssess)
	if err != nil {
		return domain.Assessment{}, err
	}
	now := s.clock.Now()

	patientID, encounterID, err := s.openCase(ctx, scope, in.CaseID,
		in.PatientID, in.EncounterID)
	if err != nil {
		return domain.Assessment{}, err
	}
	in.PatientID, in.EncounterID = patientID, encounterID

	var out domain.Assessment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		existing, err := s.assessments.Assessments(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		current, hasCurrent := domain.CurrentAssessment(existing)

		if hasCurrent {
			next, err := current.Reassess(s.ids.NewID(), in, session.SubjectID, now)
			if err != nil {
				return anaesthesiaError(err)
			}
			if err := s.assessments.Supersede(
				ctx, scope, next, current.ID, now); err != nil {
				return err
			}
			out = next
		} else {
			first, err := domain.NewAssessment(
				s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
			if err != nil {
				return anaesthesiaError(err)
			}
			if err := s.assessments.InsertAssessment(ctx, scope, first); err != nil {
				return err
			}
			out = first
		}

		if err := s.appendEvent(ctx, session, EventAssessmentRecorded,
			"anaesthesia_assessment", out.ID, map[string]any{
				"case_id":    out.CaseID,
				"patient_id": out.PatientID,
				"version":    out.Version,
				// The grade, the fitness conclusion and the airway prediction:
				// what a theatre needs to prepare, and nothing about why.
				"asa_grade":           string(out.ASAGrade),
				"fit_to_proceed":      out.FitToProceed,
				"predicted_difficult": out.Airway.PredictedDifficult,
			}, now); err != nil {
			return err
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAssess,
			ResourceType: "anaesthesia_assessment", ResourceID: out.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "ASA " + string(out.ASAGrade) + ", version " + itoa(out.Version),
		}, now)
	})
	if err != nil {
		return domain.Assessment{}, err
	}
	return out, nil
}

// Assessments returns every version for a case, oldest first (SRS-ANE-001).
func (s *Service) Assessments(ctx context.Context, caseID string) (
	[]domain.Assessment, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.assessments.Assessments(ctx, scope, caseID)
}

// PatientAssessments returns a patient's assessments across admissions.
//
// A separate permission from reading the case in front of you: this reaches
// back through every operation the patient has had.
func (s *Service) PatientAssessments(ctx context.Context, patientID string,
	limit int32) ([]domain.Assessment, error) {

	session, scope, err := s.authorize(ctx, PermHistory)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	out, err := s.assessments.PatientAssessments(
		ctx, scope, patientID, clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermHistory,
		ResourceType: "patient", ResourceID: patientID,
		Outcome: audit.OutcomeSuccess,
		Reason:  "anaesthetic history read across admissions",
	}, now); err != nil {
		return nil, err
	}
	return out, nil
}

// RecordPlan records the anaesthetic plan for a case (SRS-ANE-002).
func (s *Service) RecordPlan(ctx context.Context, in domain.NewPlanInput) (
	domain.Plan, error) {

	session, scope, err := s.authorize(ctx, PermPlan)
	if err != nil {
		return domain.Plan{}, err
	}
	now := s.clock.Now()

	if _, _, err := s.openCase(ctx, scope, in.CaseID, "", ""); err != nil {
		return domain.Plan{}, err
	}

	plan, err := domain.NewPlan(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Plan{}, anaesthesiaError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The plan is upserted on the case, so a revised plan replaces the one
		// the theatre would otherwise prepare for. Unlike the assessment, the
		// earlier version has no clinical readers: the equipment list is what
		// somebody fetches this morning, and two of them is how the wrong one
		// gets fetched.
		if err := s.assessments.SavePlan(ctx, scope, plan); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPlan,
			ResourceType: "anaesthesia_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "plan recorded: " + string(plan.Technique),
		}, now)
	})
	if err != nil {
		return domain.Plan{}, err
	}
	return plan, nil
}

// Readiness projects what the theatre's pre-operative checklist needs from
// anaesthesia (SRS-ANE-002).
//
// A projection rather than the whole record: the checklist asks whether the
// patient has been assessed, whether they are fit, what has to be ready and
// what the theatre should expect. It does not need the history, and the
// checklist is read by the whole theatre team.
func (s *Service) Readiness(ctx context.Context, caseID string) (
	domain.Readiness, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Readiness{}, err
	}

	assessments, err := s.assessments.Assessments(ctx, scope, caseID)
	if err != nil {
		return domain.Readiness{}, err
	}
	plan, hasPlan, err := s.assessments.Plan(ctx, scope, caseID)
	if err != nil {
		return domain.Readiness{}, err
	}
	if !hasPlan {
		return domain.AssessReadiness(assessments, nil), nil
	}
	return domain.AssessReadiness(assessments, &plan), nil
}

// Plan returns a case's anaesthetic plan.
func (s *Service) Plan(ctx context.Context, caseID string) (domain.Plan, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Plan{}, err
	}
	plan, ok, err := s.assessments.Plan(ctx, scope, caseID)
	if err != nil {
		return domain.Plan{}, err
	}
	if !ok {
		return domain.Plan{}, rpcerr.NotFound("ANE_NOT_FOUND",
			"this case has no anaesthetic plan yet")
	}
	return plan, nil
}
