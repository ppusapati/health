package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// NewAssessmentInput records a nutrition assessment (SRS-DIET-001).
type NewAssessmentInput struct {
	PatientID     string
	EncounterID   string
	FacilityID    string
	Anthropometry domain.Anthropometry
	IntakeSummary string
	DiagnosisCode string
	Diagnosis     string
	Requirement   domain.Requirement
	RiskTool      string
	RiskScore     int
}

// RecordAssessment writes a nutrition assessment (SRS-DIET-001).
//
// The allergies the dietitian saw are pinned onto it from the clinical record
// rather than typed. A later question about an assessment is then answered
// against what was known at the time, which is the only defensible answer: the
// list changes, and the one that matters is the one in front of the person
// who made the decision.
func (s *Service) RecordAssessment(ctx context.Context,
	in NewAssessmentInput) (domain.NutritionAssessment, error) {

	session, scope, err := s.authorize(ctx, PermCreate)
	if err != nil {
		return domain.NutritionAssessment{}, err
	}
	now := s.clock.Now()

	allergens, err := s.allergensFor(ctx, scope, in.PatientID)
	if err != nil {
		return domain.NutritionAssessment{}, err
	}
	refs := make([]string, 0, len(allergens))
	for _, allergen := range allergens {
		refs = append(refs, allergen.Ref)
	}

	assessment, err := domain.NewAssessment(s.ids.NewID(), session.TenantID,
		domain.NewAssessmentInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			FacilityID: in.FacilityID, Anthropometry: in.Anthropometry,
			IntakeSummary: in.IntakeSummary,
			DiagnosisCode: in.DiagnosisCode, Diagnosis: in.Diagnosis,
			AllergyRefs: refs, Requirement: in.Requirement,
			RiskTool: in.RiskTool, RiskScore: in.RiskScore,
		}, session.SubjectID, now)
	if err != nil {
		return domain.NutritionAssessment{}, dieteticsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.assessments.InsertAssessment(ctx, scope,
			assessment); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.assessment.recorded",
			ResourceType: "diet_assessment", ResourceID: assessment.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"encounter_id": assessment.EncounterID,
				"bmi_tenths":   itoa(assessment.Anthropometry.BMITenths()),
				"risk_tool":    assessment.RiskTool,
			}),
			Reason: "recorded a nutrition assessment",
		}, now)
	})
	if err != nil {
		return domain.NutritionAssessment{}, dieteticsError(err)
	}
	return assessment, nil
}

// SignAssessment makes an assessment the record (SRS-DIET-001).
func (s *Service) SignAssessment(ctx context.Context, assessmentID string) (
	domain.NutritionAssessment, error) {

	session, scope, err := s.authorize(ctx, PermCreate)
	if err != nil {
		return domain.NutritionAssessment{}, err
	}
	now := s.clock.Now()

	var signed domain.NutritionAssessment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		assessment, err := s.assessments.Assessment(ctx, scope, assessmentID)
		if err != nil {
			return err
		}
		expected := assessment.Version
		if err := assessment.Sign(session.SubjectID, now); err != nil {
			return err
		}
		if err := s.assessments.SignAssessment(ctx, scope, assessment,
			expected); err != nil {
			return err
		}
		signed = assessment
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.assessment.signed",
			ResourceType: "diet_assessment", ResourceID: assessment.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "signed a nutrition assessment",
		}, now)
	})
	if err != nil {
		return domain.NutritionAssessment{}, dieteticsError(err)
	}
	return signed, nil
}

// Assessments lists nutrition assessments (SRS-DIET-001).
func (s *Service) Assessments(ctx context.Context,
	filter ports.AssessmentFilter) ([]domain.NutritionAssessment, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.assessments.Assessments(ctx, scope, filter)
}

// NewCarePlanInput opens a nutrition care plan (SRS-DIET-004).
type NewCarePlanInput struct {
	PatientID    string
	EncounterID  string
	AssessmentID string
	Goals        []domain.NutritionGoal
	Plan         string
	ReviewDue    time.Time
}

// OpenCarePlan writes a nutrition care plan (SRS-DIET-004).
func (s *Service) OpenCarePlan(ctx context.Context, in NewCarePlanInput) (
	domain.CarePlan, error) {

	session, scope, err := s.authorize(ctx, PermCreate)
	if err != nil {
		return domain.CarePlan{}, err
	}
	now := s.clock.Now()

	plan, err := domain.NewCarePlan(s.ids.NewID(), session.TenantID,
		domain.NewCarePlanInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			AssessmentID: in.AssessmentID, Goals: in.Goals,
			Plan: in.Plan, ReviewDue: in.ReviewDue,
		}, session.SubjectID, now)
	if err != nil {
		return domain.CarePlan{}, dieteticsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The assessment is read first so a plan cannot name one that does
		// not exist. A plan whose reasoning cannot be produced is one nobody
		// can review, and reviewing it is the whole of the follow-up.
		if _, err := s.assessments.Assessment(ctx, scope,
			in.AssessmentID); err != nil {
			return err
		}
		if err := s.plans.InsertCarePlan(ctx, scope, plan); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.care_plan.opened",
			ResourceType: "diet_care_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"assessment_id": plan.AssessmentID,
				"goals":         itoa(len(plan.Goals)),
			}),
			Reason: "opened a nutrition care plan",
		}, now)
	})
	if err != nil {
		return domain.CarePlan{}, dieteticsError(err)
	}
	return plan, nil
}

// RecordProgress measures a care plan goal (SRS-DIET-004).
func (s *Service) RecordProgress(ctx context.Context, planID, goalCode string,
	value int, note string, measuredAt time.Time) (domain.Progress, error) {

	session, scope, err := s.authorize(ctx, PermCreate)
	if err != nil {
		return domain.Progress{}, err
	}
	now := s.clock.Now()

	var progress domain.Progress
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.plans.CarePlan(ctx, scope, planID)
		if err != nil {
			return err
		}
		progress, err = plan.RecordProgress(s.ids.NewID(), goalCode, value,
			note, session.SubjectID, measuredAt, now)
		if err != nil {
			return err
		}
		if err := s.plans.AppendProgress(ctx, scope, progress); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.progress.recorded",
			ResourceType: "diet_care_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"goal": progress.GoalCode, "value": itoa(progress.Value),
				"unit": progress.Unit,
			}),
			Reason: "measured a nutrition goal",
		}, now)
	})
	if err != nil {
		return domain.Progress{}, dieteticsError(err)
	}
	return progress, nil
}

// CloseCarePlan finishes a nutrition care plan (SRS-DIET-004).
func (s *Service) CloseCarePlan(ctx context.Context, planID, note string) (
	domain.CarePlan, error) {

	session, scope, err := s.authorize(ctx, PermCreate)
	if err != nil {
		return domain.CarePlan{}, err
	}
	now := s.clock.Now()

	var closed domain.CarePlan
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.plans.CarePlan(ctx, scope, planID)
		if err != nil {
			return err
		}
		expected := plan.Version
		if err := plan.Close(note, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.plans.CloseCarePlan(ctx, scope, plan,
			expected); err != nil {
			return err
		}
		closed = plan
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "dietetics.care_plan.closed",
			ResourceType: "diet_care_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess, Reason: note,
		}, now)
	})
	if err != nil {
		return domain.CarePlan{}, dieteticsError(err)
	}
	return closed, nil
}

// CarePlans lists nutrition care plans (SRS-DIET-004).
func (s *Service) CarePlans(ctx context.Context,
	filter ports.CarePlanFilter) ([]domain.CarePlan, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.plans.CarePlans(ctx, scope, filter)
}

// GoalTrend reports a goal's measurements over time (SRS-DIET-004).
func (s *Service) GoalTrend(ctx context.Context, planID, goalCode string) (
	domain.Trend, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Trend{}, err
	}

	plan, err := s.plans.CarePlan(ctx, scope, planID)
	if err != nil {
		return domain.Trend{}, err
	}
	measured, err := s.plans.Progress(ctx, scope, planID, goalCode)
	if err != nil {
		return domain.Trend{}, err
	}
	trend, found := domain.TrendFor(plan, measured, goalCode)
	if !found {
		return domain.Trend{}, rpcerr.NotFound("DIET_NO_GOAL",
			"this plan has no goal "+goalCode)
	}
	return trend, nil
}

// allergensFor reads what the patient is documented as reacting to
// (SRS-DIET-003).
//
// Refused rather than answered empty when the seam is not wired. A patient
// with no allergy adapter and a patient with no allergies look identical, and
// reporting the second when the truth is the first puts a peanut supplement
// on the tray of somebody who is anaphylactic to it.
func (s *Service) allergensFor(ctx context.Context, scope authctx.TenantScope,
	patientID string) ([]domain.Allergen, error) {

	if s.allergies == nil {
		return nil, rpcerr.FailedPrecondition("DIET_NO_ALLERGY_SOURCE",
			"this deployment has no allergy source wired, so a diet cannot "+
				"be checked against what the patient reacts to")
	}
	return s.allergies.ForPatient(ctx, scope, patientID)
}
