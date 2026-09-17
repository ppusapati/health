// Package transport serves healthcare.clinical.v1.ClinicalService.
package transport

import (
	"strings"
	"time"

	clinicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1"
	"github.com/ppusapati/health/code/internal/clinical/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Enumeration maps. Written out rather than derived, because a generated
// mapping would silently gain a value the domain has not thought about.

var confidentialityToProto = map[domain.Confidentiality]clinicalv1.Confidentiality{
	domain.ConfidentialityNormal:         clinicalv1.Confidentiality_CONFIDENTIALITY_NORMAL,
	domain.ConfidentialityRestricted:     clinicalv1.Confidentiality_CONFIDENTIALITY_RESTRICTED,
	domain.ConfidentialityVeryRestricted: clinicalv1.Confidentiality_CONFIDENTIALITY_VERY_RESTRICTED,
}

var confidentialityFromProto = map[clinicalv1.Confidentiality]domain.Confidentiality{
	clinicalv1.Confidentiality_CONFIDENTIALITY_NORMAL:          domain.ConfidentialityNormal,
	clinicalv1.Confidentiality_CONFIDENTIALITY_RESTRICTED:      domain.ConfidentialityRestricted,
	clinicalv1.Confidentiality_CONFIDENTIALITY_VERY_RESTRICTED: domain.ConfidentialityVeryRestricted,
}

var documentStatusToProto = map[domain.DocumentStatus]clinicalv1.DocumentStatus{
	domain.StatusDraft:          clinicalv1.DocumentStatus_DOCUMENT_STATUS_DRAFT,
	domain.StatusSigned:         clinicalv1.DocumentStatus_DOCUMENT_STATUS_SIGNED,
	domain.StatusAmended:        clinicalv1.DocumentStatus_DOCUMENT_STATUS_AMENDED,
	domain.StatusAddendum:       clinicalv1.DocumentStatus_DOCUMENT_STATUS_ADDENDUM,
	domain.StatusEnteredInError: clinicalv1.DocumentStatus_DOCUMENT_STATUS_ENTERED_IN_ERROR,
}

var documentKindToProto = map[domain.DocumentKind]clinicalv1.DocumentKind{
	domain.DocumentProgressNote:     clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
	domain.DocumentConsultationNote: clinicalv1.DocumentKind_DOCUMENT_KIND_CONSULTATION_NOTE,
	domain.DocumentDischargeSummary: clinicalv1.DocumentKind_DOCUMENT_KIND_DISCHARGE_SUMMARY,
	domain.DocumentOperationNote:    clinicalv1.DocumentKind_DOCUMENT_KIND_OPERATION_NOTE,
	domain.DocumentNursingNote:      clinicalv1.DocumentKind_DOCUMENT_KIND_NURSING_NOTE,
	domain.DocumentReferralLetter:   clinicalv1.DocumentKind_DOCUMENT_KIND_REFERRAL_LETTER,
	domain.DocumentProcedureReport:  clinicalv1.DocumentKind_DOCUMENT_KIND_PROCEDURE_REPORT,
}

var documentKindFromProto = map[clinicalv1.DocumentKind]domain.DocumentKind{
	clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE:     domain.DocumentProgressNote,
	clinicalv1.DocumentKind_DOCUMENT_KIND_CONSULTATION_NOTE: domain.DocumentConsultationNote,
	clinicalv1.DocumentKind_DOCUMENT_KIND_DISCHARGE_SUMMARY: domain.DocumentDischargeSummary,
	clinicalv1.DocumentKind_DOCUMENT_KIND_OPERATION_NOTE:    domain.DocumentOperationNote,
	clinicalv1.DocumentKind_DOCUMENT_KIND_NURSING_NOTE:      domain.DocumentNursingNote,
	clinicalv1.DocumentKind_DOCUMENT_KIND_REFERRAL_LETTER:   domain.DocumentReferralLetter,
	clinicalv1.DocumentKind_DOCUMENT_KIND_PROCEDURE_REPORT:  domain.DocumentProcedureReport,
}

var signatureMeaningToProto = map[domain.SignatureMeaning]clinicalv1.SignatureMeaning{
	domain.MeaningAuthor:      clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR,
	domain.MeaningVerifier:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_VERIFIER,
	domain.MeaningCosigner:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_COSIGNER,
	domain.MeaningWitness:     clinicalv1.SignatureMeaning_SIGNATURE_MEANING_WITNESS,
	domain.MeaningTranscriber: clinicalv1.SignatureMeaning_SIGNATURE_MEANING_TRANSCRIBER,
}

var signatureMeaningFromProto = map[clinicalv1.SignatureMeaning]domain.SignatureMeaning{
	clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR:      domain.MeaningAuthor,
	clinicalv1.SignatureMeaning_SIGNATURE_MEANING_VERIFIER:    domain.MeaningVerifier,
	clinicalv1.SignatureMeaning_SIGNATURE_MEANING_COSIGNER:    domain.MeaningCosigner,
	clinicalv1.SignatureMeaning_SIGNATURE_MEANING_WITNESS:     domain.MeaningWitness,
	clinicalv1.SignatureMeaning_SIGNATURE_MEANING_TRANSCRIBER: domain.MeaningTranscriber,
}

var problemStatusToProto = map[domain.ProblemStatus]clinicalv1.ProblemStatus{
	domain.ProblemActive:         clinicalv1.ProblemStatus_PROBLEM_STATUS_ACTIVE,
	domain.ProblemRemission:      clinicalv1.ProblemStatus_PROBLEM_STATUS_REMISSION,
	domain.ProblemResolved:       clinicalv1.ProblemStatus_PROBLEM_STATUS_RESOLVED,
	domain.ProblemInactive:       clinicalv1.ProblemStatus_PROBLEM_STATUS_INACTIVE,
	domain.ProblemEnteredInError: clinicalv1.ProblemStatus_PROBLEM_STATUS_ENTERED_IN_ERROR,
}

var problemStatusFromProto = map[clinicalv1.ProblemStatus]domain.ProblemStatus{
	clinicalv1.ProblemStatus_PROBLEM_STATUS_ACTIVE:           domain.ProblemActive,
	clinicalv1.ProblemStatus_PROBLEM_STATUS_REMISSION:        domain.ProblemRemission,
	clinicalv1.ProblemStatus_PROBLEM_STATUS_RESOLVED:         domain.ProblemResolved,
	clinicalv1.ProblemStatus_PROBLEM_STATUS_INACTIVE:         domain.ProblemInactive,
	clinicalv1.ProblemStatus_PROBLEM_STATUS_ENTERED_IN_ERROR: domain.ProblemEnteredInError,
}

var allergyKindToProto = map[domain.AllergyKind]clinicalv1.AllergyKind{
	domain.AllergyTrue:        clinicalv1.AllergyKind_ALLERGY_KIND_ALLERGY,
	domain.AllergyIntolerance: clinicalv1.AllergyKind_ALLERGY_KIND_INTOLERANCE,
}

var allergyKindFromProto = map[clinicalv1.AllergyKind]domain.AllergyKind{
	clinicalv1.AllergyKind_ALLERGY_KIND_ALLERGY:     domain.AllergyTrue,
	clinicalv1.AllergyKind_ALLERGY_KIND_INTOLERANCE: domain.AllergyIntolerance,
}

var criticalityToProto = map[domain.AllergyCriticality]clinicalv1.AllergyCriticality{
	domain.CriticalityLow:            clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_LOW,
	domain.CriticalityHigh:           clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_HIGH,
	domain.CriticalityUnableToAssess: clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_UNABLE_TO_ASSESS,
}

var criticalityFromProto = map[clinicalv1.AllergyCriticality]domain.AllergyCriticality{
	clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_LOW:              domain.CriticalityLow,
	clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_HIGH:             domain.CriticalityHigh,
	clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_UNABLE_TO_ASSESS: domain.CriticalityUnableToAssess,
}

var verificationToProto = map[domain.AllergyVerification]clinicalv1.AllergyVerification{
	domain.VerificationUnconfirmed:    clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_UNCONFIRMED,
	domain.VerificationConfirmed:      clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_CONFIRMED,
	domain.VerificationRefuted:        clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_REFUTED,
	domain.VerificationEnteredInError: clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_ENTERED_IN_ERROR,
}

var verificationFromProto = map[clinicalv1.AllergyVerification]domain.AllergyVerification{
	clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_UNCONFIRMED:      domain.VerificationUnconfirmed,
	clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_CONFIRMED:        domain.VerificationConfirmed,
	clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_REFUTED:          domain.VerificationRefuted,
	clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_ENTERED_IN_ERROR: domain.VerificationEnteredInError,
}

var interpretationToProto = map[domain.Interpretation]clinicalv1.Interpretation{
	domain.InterpretationNormal:       clinicalv1.Interpretation_INTERPRETATION_NORMAL,
	domain.InterpretationHigh:         clinicalv1.Interpretation_INTERPRETATION_HIGH,
	domain.InterpretationLow:          clinicalv1.Interpretation_INTERPRETATION_LOW,
	domain.InterpretationCriticalHigh: clinicalv1.Interpretation_INTERPRETATION_CRITICAL_HIGH,
	domain.InterpretationCriticalLow:  clinicalv1.Interpretation_INTERPRETATION_CRITICAL_LOW,
	domain.InterpretationAbnormal:     clinicalv1.Interpretation_INTERPRETATION_ABNORMAL,
	domain.InterpretationUnknown:      clinicalv1.Interpretation_INTERPRETATION_UNKNOWN,
}

var interpretationFromProto = map[clinicalv1.Interpretation]domain.Interpretation{
	clinicalv1.Interpretation_INTERPRETATION_NORMAL:        domain.InterpretationNormal,
	clinicalv1.Interpretation_INTERPRETATION_HIGH:          domain.InterpretationHigh,
	clinicalv1.Interpretation_INTERPRETATION_LOW:           domain.InterpretationLow,
	clinicalv1.Interpretation_INTERPRETATION_CRITICAL_HIGH: domain.InterpretationCriticalHigh,
	clinicalv1.Interpretation_INTERPRETATION_CRITICAL_LOW:  domain.InterpretationCriticalLow,
	clinicalv1.Interpretation_INTERPRETATION_ABNORMAL:      domain.InterpretationAbnormal,
	clinicalv1.Interpretation_INTERPRETATION_UNKNOWN:       domain.InterpretationUnknown,
}

var observationStatusToProto = map[domain.ObservationStatus]clinicalv1.ObservationStatus{
	domain.ObservationRegistered:     clinicalv1.ObservationStatus_OBSERVATION_STATUS_REGISTERED,
	domain.ObservationPreliminary:    clinicalv1.ObservationStatus_OBSERVATION_STATUS_PRELIMINARY,
	domain.ObservationFinal:          clinicalv1.ObservationStatus_OBSERVATION_STATUS_FINAL,
	domain.ObservationAmended:        clinicalv1.ObservationStatus_OBSERVATION_STATUS_AMENDED,
	domain.ObservationCancelled:      clinicalv1.ObservationStatus_OBSERVATION_STATUS_CANCELLED,
	domain.ObservationEnteredInError: clinicalv1.ObservationStatus_OBSERVATION_STATUS_ENTERED_IN_ERROR,
}

var observationStatusFromProto = map[clinicalv1.ObservationStatus]domain.ObservationStatus{
	clinicalv1.ObservationStatus_OBSERVATION_STATUS_REGISTERED:       domain.ObservationRegistered,
	clinicalv1.ObservationStatus_OBSERVATION_STATUS_PRELIMINARY:      domain.ObservationPreliminary,
	clinicalv1.ObservationStatus_OBSERVATION_STATUS_FINAL:            domain.ObservationFinal,
	clinicalv1.ObservationStatus_OBSERVATION_STATUS_AMENDED:          domain.ObservationAmended,
	clinicalv1.ObservationStatus_OBSERVATION_STATUS_CANCELLED:        domain.ObservationCancelled,
	clinicalv1.ObservationStatus_OBSERVATION_STATUS_ENTERED_IN_ERROR: domain.ObservationEnteredInError,
}

var procedureStatusToProto = map[domain.ProcedureStatus]clinicalv1.ProcedureStatus{
	domain.ProcedurePlanned:        clinicalv1.ProcedureStatus_PROCEDURE_STATUS_PLANNED,
	domain.ProcedureInProgress:     clinicalv1.ProcedureStatus_PROCEDURE_STATUS_IN_PROGRESS,
	domain.ProcedureCompleted:      clinicalv1.ProcedureStatus_PROCEDURE_STATUS_COMPLETED,
	domain.ProcedureStopped:        clinicalv1.ProcedureStatus_PROCEDURE_STATUS_STOPPED,
	domain.ProcedureNotDone:        clinicalv1.ProcedureStatus_PROCEDURE_STATUS_NOT_DONE,
	domain.ProcedureEnteredInError: clinicalv1.ProcedureStatus_PROCEDURE_STATUS_ENTERED_IN_ERROR,
}

var procedureStatusFromProto = map[clinicalv1.ProcedureStatus]domain.ProcedureStatus{
	clinicalv1.ProcedureStatus_PROCEDURE_STATUS_PLANNED:          domain.ProcedurePlanned,
	clinicalv1.ProcedureStatus_PROCEDURE_STATUS_IN_PROGRESS:      domain.ProcedureInProgress,
	clinicalv1.ProcedureStatus_PROCEDURE_STATUS_COMPLETED:        domain.ProcedureCompleted,
	clinicalv1.ProcedureStatus_PROCEDURE_STATUS_STOPPED:          domain.ProcedureStopped,
	clinicalv1.ProcedureStatus_PROCEDURE_STATUS_NOT_DONE:         domain.ProcedureNotDone,
	clinicalv1.ProcedureStatus_PROCEDURE_STATUS_ENTERED_IN_ERROR: domain.ProcedureEnteredInError,
}

var lateralityToProto = map[domain.Laterality]clinicalv1.Laterality{
	domain.LateralityNotApplicable: clinicalv1.Laterality_LATERALITY_NOT_APPLICABLE,
	domain.LateralityLeft:          clinicalv1.Laterality_LATERALITY_LEFT,
	domain.LateralityRight:         clinicalv1.Laterality_LATERALITY_RIGHT,
	domain.LateralityBilateral:     clinicalv1.Laterality_LATERALITY_BILATERAL,
	domain.LateralityUnspecified:   clinicalv1.Laterality_LATERALITY_UNRECORDED,
}

var lateralityFromProto = map[clinicalv1.Laterality]domain.Laterality{
	clinicalv1.Laterality_LATERALITY_NOT_APPLICABLE: domain.LateralityNotApplicable,
	clinicalv1.Laterality_LATERALITY_LEFT:           domain.LateralityLeft,
	clinicalv1.Laterality_LATERALITY_RIGHT:          domain.LateralityRight,
	clinicalv1.Laterality_LATERALITY_BILATERAL:      domain.LateralityBilateral,
	clinicalv1.Laterality_LATERALITY_UNRECORDED:     domain.LateralityUnspecified,
}

var carePlanStatusToProto = map[domain.CarePlanStatus]clinicalv1.CarePlanStatus{
	domain.CarePlanDraft:     clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_DRAFT,
	domain.CarePlanActive:    clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_ACTIVE,
	domain.CarePlanOnHold:    clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_ON_HOLD,
	domain.CarePlanCompleted: clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_COMPLETED,
	domain.CarePlanRevoked:   clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_REVOKED,
}

var carePlanStatusFromProto = map[clinicalv1.CarePlanStatus]domain.CarePlanStatus{
	clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_DRAFT:     domain.CarePlanDraft,
	clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_ACTIVE:    domain.CarePlanActive,
	clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_ON_HOLD:   domain.CarePlanOnHold,
	clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_COMPLETED: domain.CarePlanCompleted,
	clinicalv1.CarePlanStatus_CARE_PLAN_STATUS_REVOKED:   domain.CarePlanRevoked,
}

var goalStatusToProto = map[domain.GoalStatus]clinicalv1.GoalStatus{
	domain.GoalProposed:    clinicalv1.GoalStatus_GOAL_STATUS_PROPOSED,
	domain.GoalActive:      clinicalv1.GoalStatus_GOAL_STATUS_ACTIVE,
	domain.GoalAchieved:    clinicalv1.GoalStatus_GOAL_STATUS_ACHIEVED,
	domain.GoalNotAchieved: clinicalv1.GoalStatus_GOAL_STATUS_NOT_ACHIEVED,
	domain.GoalCancelled:   clinicalv1.GoalStatus_GOAL_STATUS_CANCELLED,
}

var goalStatusFromProto = map[clinicalv1.GoalStatus]domain.GoalStatus{
	clinicalv1.GoalStatus_GOAL_STATUS_PROPOSED:     domain.GoalProposed,
	clinicalv1.GoalStatus_GOAL_STATUS_ACTIVE:       domain.GoalActive,
	clinicalv1.GoalStatus_GOAL_STATUS_ACHIEVED:     domain.GoalAchieved,
	clinicalv1.GoalStatus_GOAL_STATUS_NOT_ACHIEVED: domain.GoalNotAchieved,
	clinicalv1.GoalStatus_GOAL_STATUS_CANCELLED:    domain.GoalCancelled,
}

var activityStatusToProto = map[domain.ActivityStatus]clinicalv1.ActivityStatus{
	domain.ActivityNotStarted: clinicalv1.ActivityStatus_ACTIVITY_STATUS_NOT_STARTED,
	domain.ActivityScheduled:  clinicalv1.ActivityStatus_ACTIVITY_STATUS_SCHEDULED,
	domain.ActivityInProgress: clinicalv1.ActivityStatus_ACTIVITY_STATUS_IN_PROGRESS,
	domain.ActivityCompleted:  clinicalv1.ActivityStatus_ACTIVITY_STATUS_COMPLETED,
	domain.ActivityCancelled:  clinicalv1.ActivityStatus_ACTIVITY_STATUS_CANCELLED,
}

var activityStatusFromProto = map[clinicalv1.ActivityStatus]domain.ActivityStatus{
	clinicalv1.ActivityStatus_ACTIVITY_STATUS_NOT_STARTED: domain.ActivityNotStarted,
	clinicalv1.ActivityStatus_ACTIVITY_STATUS_SCHEDULED:   domain.ActivityScheduled,
	clinicalv1.ActivityStatus_ACTIVITY_STATUS_IN_PROGRESS: domain.ActivityInProgress,
	clinicalv1.ActivityStatus_ACTIVITY_STATUS_COMPLETED:   domain.ActivityCompleted,
	clinicalv1.ActivityStatus_ACTIVITY_STATUS_CANCELLED:   domain.ActivityCancelled,
}

var attachmentKindToProto = map[domain.AttachmentKind]clinicalv1.AttachmentKind{
	domain.AttachmentImage:    clinicalv1.AttachmentKind_ATTACHMENT_KIND_IMAGE,
	domain.AttachmentDocument: clinicalv1.AttachmentKind_ATTACHMENT_KIND_DOCUMENT,
	domain.AttachmentAudio:    clinicalv1.AttachmentKind_ATTACHMENT_KIND_AUDIO,
	domain.AttachmentVideo:    clinicalv1.AttachmentKind_ATTACHMENT_KIND_VIDEO,
	domain.AttachmentWaveform: clinicalv1.AttachmentKind_ATTACHMENT_KIND_WAVEFORM,
}

var attachmentKindFromProto = map[clinicalv1.AttachmentKind]domain.AttachmentKind{
	clinicalv1.AttachmentKind_ATTACHMENT_KIND_IMAGE:    domain.AttachmentImage,
	clinicalv1.AttachmentKind_ATTACHMENT_KIND_DOCUMENT: domain.AttachmentDocument,
	clinicalv1.AttachmentKind_ATTACHMENT_KIND_AUDIO:    domain.AttachmentAudio,
	clinicalv1.AttachmentKind_ATTACHMENT_KIND_VIDEO:    domain.AttachmentVideo,
	clinicalv1.AttachmentKind_ATTACHMENT_KIND_WAVEFORM: domain.AttachmentWaveform,
}

var consentKindToProto = map[domain.ClinicalConsentKind]clinicalv1.ConsentKind{
	domain.ConsentProcedure:   clinicalv1.ConsentKind_CONSENT_KIND_PROCEDURE,
	domain.ConsentAnaesthesia: clinicalv1.ConsentKind_CONSENT_KIND_ANAESTHESIA,
	domain.ConsentTransfusion: clinicalv1.ConsentKind_CONSENT_KIND_TRANSFUSION,
	domain.ConsentPhotography: clinicalv1.ConsentKind_CONSENT_KIND_PHOTOGRAPHY,
	domain.ConsentResearch:    clinicalv1.ConsentKind_CONSENT_KIND_RESEARCH,
	domain.ConsentTreatment:   clinicalv1.ConsentKind_CONSENT_KIND_TREATMENT,
}

var consentKindFromProto = map[clinicalv1.ConsentKind]domain.ClinicalConsentKind{
	clinicalv1.ConsentKind_CONSENT_KIND_PROCEDURE:   domain.ConsentProcedure,
	clinicalv1.ConsentKind_CONSENT_KIND_ANAESTHESIA: domain.ConsentAnaesthesia,
	clinicalv1.ConsentKind_CONSENT_KIND_TRANSFUSION: domain.ConsentTransfusion,
	clinicalv1.ConsentKind_CONSENT_KIND_PHOTOGRAPHY: domain.ConsentPhotography,
	clinicalv1.ConsentKind_CONSENT_KIND_RESEARCH:    domain.ConsentResearch,
	clinicalv1.ConsentKind_CONSENT_KIND_TREATMENT:   domain.ConsentTreatment,
}

var consentStatusToProto = map[domain.ConsentStatus]clinicalv1.ConsentStatus{
	domain.ConsentGiven:     clinicalv1.ConsentStatus_CONSENT_STATUS_GIVEN,
	domain.ConsentRefused:   clinicalv1.ConsentStatus_CONSENT_STATUS_REFUSED,
	domain.ConsentWithdrawn: clinicalv1.ConsentStatus_CONSENT_STATUS_WITHDRAWN,
	domain.ConsentExpired:   clinicalv1.ConsentStatus_CONSENT_STATUS_EXPIRED,
}

var consentStatusFromProto = map[clinicalv1.ConsentStatus]domain.ConsentStatus{
	clinicalv1.ConsentStatus_CONSENT_STATUS_GIVEN:     domain.ConsentGiven,
	clinicalv1.ConsentStatus_CONSENT_STATUS_REFUSED:   domain.ConsentRefused,
	clinicalv1.ConsentStatus_CONSENT_STATUS_WITHDRAWN: domain.ConsentWithdrawn,
	clinicalv1.ConsentStatus_CONSENT_STATUS_EXPIRED:   domain.ConsentExpired,
}

var consentGiverToProto = map[domain.GivenBy]clinicalv1.ConsentGiver{
	domain.GivenByPatient:        clinicalv1.ConsentGiver_CONSENT_GIVER_PATIENT,
	domain.GivenByParent:         clinicalv1.ConsentGiver_CONSENT_GIVER_PARENT,
	domain.GivenByLegalGuardian:  clinicalv1.ConsentGiver_CONSENT_GIVER_LEGAL_GUARDIAN,
	domain.GivenByRepresentative: clinicalv1.ConsentGiver_CONSENT_GIVER_REPRESENTATIVE,
}

var consentGiverFromProto = map[clinicalv1.ConsentGiver]domain.GivenBy{
	clinicalv1.ConsentGiver_CONSENT_GIVER_PATIENT:        domain.GivenByPatient,
	clinicalv1.ConsentGiver_CONSENT_GIVER_PARENT:         domain.GivenByParent,
	clinicalv1.ConsentGiver_CONSENT_GIVER_LEGAL_GUARDIAN: domain.GivenByLegalGuardian,
	clinicalv1.ConsentGiver_CONSENT_GIVER_REPRESENTATIVE: domain.GivenByRepresentative,
}

var alertLevelToProto = map[domain.AlertSeverityLevel]clinicalv1.AlertLevel{
	domain.AlertLevelHard: clinicalv1.AlertLevel_ALERT_LEVEL_HARD,
	domain.AlertLevelSoft: clinicalv1.AlertLevel_ALERT_LEVEL_SOFT,
	domain.AlertLevelInfo: clinicalv1.AlertLevel_ALERT_LEVEL_INFO,
}

var alertLevelFromProto = map[clinicalv1.AlertLevel]domain.AlertSeverityLevel{
	clinicalv1.AlertLevel_ALERT_LEVEL_HARD: domain.AlertLevelHard,
	clinicalv1.AlertLevel_ALERT_LEVEL_SOFT: domain.AlertLevelSoft,
	clinicalv1.AlertLevel_ALERT_LEVEL_INFO: domain.AlertLevelInfo,
}

var alertOutcomeToProto = map[domain.CDSOutcome]clinicalv1.AlertOutcome{
	domain.CDSPending:       clinicalv1.AlertOutcome_ALERT_OUTCOME_PENDING,
	domain.CDSAccepted:      clinicalv1.AlertOutcome_ALERT_OUTCOME_ACCEPTED,
	domain.CDSOverridden:    clinicalv1.AlertOutcome_ALERT_OUTCOME_OVERRIDDEN,
	domain.CDSNotApplicable: clinicalv1.AlertOutcome_ALERT_OUTCOME_NOT_APPLICABLE,
}

var alertOutcomeFromProto = map[clinicalv1.AlertOutcome]domain.CDSOutcome{
	clinicalv1.AlertOutcome_ALERT_OUTCOME_PENDING:        domain.CDSPending,
	clinicalv1.AlertOutcome_ALERT_OUTCOME_ACCEPTED:       domain.CDSAccepted,
	clinicalv1.AlertOutcome_ALERT_OUTCOME_OVERRIDDEN:     domain.CDSOverridden,
	clinicalv1.AlertOutcome_ALERT_OUTCOME_NOT_APPLICABLE: domain.CDSNotApplicable,
}

var consultUrgencyToProto = map[domain.ConsultUrgency]clinicalv1.ConsultUrgency{
	domain.UrgencyEmergency: clinicalv1.ConsultUrgency_CONSULT_URGENCY_EMERGENCY,
	domain.UrgencyUrgent:    clinicalv1.ConsultUrgency_CONSULT_URGENCY_URGENT,
	domain.UrgencyRoutine:   clinicalv1.ConsultUrgency_CONSULT_URGENCY_ROUTINE,
}

var consultUrgencyFromProto = map[clinicalv1.ConsultUrgency]domain.ConsultUrgency{
	clinicalv1.ConsultUrgency_CONSULT_URGENCY_EMERGENCY: domain.UrgencyEmergency,
	clinicalv1.ConsultUrgency_CONSULT_URGENCY_URGENT:    domain.UrgencyUrgent,
	clinicalv1.ConsultUrgency_CONSULT_URGENCY_ROUTINE:   domain.UrgencyRoutine,
}

var consultStatusToProto = map[domain.ConsultStatus]clinicalv1.ConsultStatus{
	domain.ConsultRequested: clinicalv1.ConsultStatus_CONSULT_STATUS_REQUESTED,
	domain.ConsultAccepted:  clinicalv1.ConsultStatus_CONSULT_STATUS_ACCEPTED,
	domain.ConsultAnswered:  clinicalv1.ConsultStatus_CONSULT_STATUS_ANSWERED,
	domain.ConsultDeclined:  clinicalv1.ConsultStatus_CONSULT_STATUS_DECLINED,
	domain.ConsultCancelled: clinicalv1.ConsultStatus_CONSULT_STATUS_CANCELLED,
}

func timestamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t)
}

func fromTimestamp(p *timestamppb.Timestamp) time.Time {
	if p == nil {
		return time.Time{}
	}
	return p.AsTime()
}

func codingToProto(c domain.Coding) *clinicalv1.Coding {
	return &clinicalv1.Coding{
		System: c.System, Version: c.Version, Code: c.Code, Display: c.Display,
	}
}

func codingFromProto(c *clinicalv1.Coding) domain.Coding {
	if c == nil {
		return domain.Coding{}
	}
	return domain.Coding{
		System: c.GetSystem(), Version: c.GetVersion(),
		Code: c.GetCode(), Display: c.GetDisplay(),
	}
}

func codingsToProto(in []domain.Coding) []*clinicalv1.Coding {
	out := make([]*clinicalv1.Coding, 0, len(in))
	for _, c := range in {
		out = append(out, codingToProto(c))
	}
	return out
}

func codingsFromProto(in []*clinicalv1.Coding) []domain.Coding {
	out := make([]domain.Coding, 0, len(in))
	for _, c := range in {
		out = append(out, codingFromProto(c))
	}
	return out
}

func contextFromProto(c *clinicalv1.PatientContext) domain.PatientContext {
	if c == nil {
		return domain.PatientContext{}
	}
	return domain.PatientContext{
		PatientID: c.GetPatientId(), EncounterID: c.GetEncounterId(),
		OpenedAt: fromTimestamp(c.GetOpenedAt()),
	}
}

func documentToProto(d *domain.Document) *clinicalv1.Document {
	if d == nil {
		return nil
	}
	out := &clinicalv1.Document{
		DocumentId: d.ID(), PatientId: d.PatientID, EncounterId: d.EncounterID,
		Kind: documentKindToProto[d.Kind], TemplateId: d.TemplateID,
		TemplateVersion: d.TemplateVersion, Title: d.Title,
		Status:          documentStatusToProto[d.Status],
		Confidentiality: confidentialityToProto[d.Confidentiality],
		AmendsId:        d.AmendsID, AddsToId: d.AddsToID,
		ChangeReason: d.ChangeReason, RetractionReason: d.RetractionReason,
		Dictated: d.Dictated, AuthoredBy: d.AuthoredBy,
		CreatedAt: timestamp(d.CreatedAt), UpdatedAt: timestamp(d.UpdatedAt),
		Version: d.Version, Intact: d.Intact(),
	}
	for _, s := range d.Sections {
		out.Sections = append(out.Sections, &clinicalv1.Section{
			Heading: s.Heading, Text: s.Text,
		})
	}
	for _, s := range d.Signatures {
		out.Signatures = append(out.Signatures, &clinicalv1.Signature{
			SignatureId: s.ID, SubjectId: s.SubjectID,
			Meaning: signatureMeaningToProto[s.Meaning], SignedAt: timestamp(s.SignedAt),
			ContentHash: s.ContentHash, TemplateVersion: s.TemplateVersion,
		})
	}
	return out
}

func documentsToProto(in []*domain.Document) []*clinicalv1.Document {
	out := make([]*clinicalv1.Document, 0, len(in))
	for _, d := range in {
		out = append(out, documentToProto(d))
	}
	return out
}

func sectionsFromProto(in []*clinicalv1.Section) []domain.Section {
	out := make([]domain.Section, 0, len(in))
	for _, s := range in {
		out = append(out, domain.Section{Heading: s.GetHeading(), Text: s.GetText()})
	}
	return out
}

func templateToProto(t domain.Template) *clinicalv1.Template {
	return &clinicalv1.Template{
		TemplateId: t.ID, Name: t.Name, Version: t.Version,
		Kind: documentKindToProto[t.Kind], Specialty: t.Specialty,
		Sections: t.Sections, Retired: t.Retired,
	}
}

func templatesToProto(in []domain.Template) []*clinicalv1.Template {
	out := make([]*clinicalv1.Template, 0, len(in))
	for _, t := range in {
		out = append(out, templateToProto(t))
	}
	return out
}

func templateFromProto(t *clinicalv1.Template) domain.Template {
	if t == nil {
		return domain.Template{}
	}
	return domain.Template{
		ID: t.GetTemplateId(), Name: t.GetName(), Version: t.GetVersion(),
		Kind: documentKindFromProto[t.GetKind()], Specialty: t.GetSpecialty(),
		Sections: t.GetSections(), Retired: t.GetRetired(),
	}
}

func problemToProto(p domain.Problem) *clinicalv1.Problem {
	return &clinicalv1.Problem{
		ProblemId: p.ID, PatientId: p.PatientID, EncounterId: p.EncounterID,
		Code: codingToProto(p.Code), Note: p.Note,
		Status:  problemStatusToProto[p.Status],
		OnsetAt: timestamp(p.OnsetAt), ResolvedAt: timestamp(p.ResolvedAt),
		Confidentiality: confidentialityToProto[p.Confidentiality],
		RecordedBy:      p.RecordedBy, RecordedAt: timestamp(p.RecordedAt),
		Version: p.Version,
	}
}

func problemsToProto(in domain.ProblemList) []*clinicalv1.Problem {
	out := make([]*clinicalv1.Problem, 0, len(in))
	for _, p := range in {
		out = append(out, problemToProto(p))
	}
	return out
}

func allergyToProto(a domain.Allergy) *clinicalv1.Allergy {
	out := &clinicalv1.Allergy{
		AllergyId: a.ID, PatientId: a.PatientID, EncounterId: a.EncounterID,
		Substance: codingToProto(a.Substance), Kind: allergyKindToProto[a.Kind],
		Criticality:  criticalityToProto[a.Criticality],
		Verification: verificationToProto[a.Verification],
		OnsetAt:      timestamp(a.OnsetAt), Note: a.Note,
		RecordedBy: a.RecordedBy, RecordedAt: timestamp(a.RecordedAt),
		Version: a.Version,
	}
	for _, r := range a.Reactions {
		out.Reactions = append(out.Reactions, &clinicalv1.Reaction{
			Manifestation: codingToProto(r.Manifestation),
			Severity:      r.Severity, Note: r.Note,
		})
	}
	return out
}

func allergiesToProto(in domain.AllergyList) []*clinicalv1.Allergy {
	out := make([]*clinicalv1.Allergy, 0, len(in))
	for _, a := range in {
		out = append(out, allergyToProto(a))
	}
	return out
}

func reactionsFromProto(in []*clinicalv1.Reaction) []domain.Reaction {
	out := make([]domain.Reaction, 0, len(in))
	for _, r := range in {
		out = append(out, domain.Reaction{
			Manifestation: codingFromProto(r.GetManifestation()),
			Severity:      r.GetSeverity(), Note: r.GetNote(),
		})
	}
	return out
}

func observationToProto(o domain.Observation) *clinicalv1.Observation {
	out := &clinicalv1.Observation{
		ObservationId: o.ID, PatientId: o.PatientID, EncounterId: o.EncounterID,
		Code:      codingToProto(o.Code),
		Value:     &clinicalv1.Quantity{Value: o.Value.Value, Unit: o.Value.Unit},
		TextValue: o.TextValue, CodedValue: codingToProto(o.CodedValue),
		ReferenceText:        o.ReferenceText,
		Interpretation:       interpretationToProto[o.Interpretation],
		InterpretationSource: o.InterpretationSource,
		Status:               observationStatusToProto[o.Status],
		EffectiveAt:          timestamp(o.EffectiveAt), IssuedAt: timestamp(o.IssuedAt),
		PerformerId: o.PerformerID, DeviceId: o.DeviceID,
		SourceSystem: o.SourceSystem, Note: o.Note, AmendsId: o.AmendsID,
		RecordedBy: o.RecordedBy, RecordedAt: timestamp(o.RecordedAt),
		// SRS-ICU-003. Both travel, always: a client that showed a provisional
		// monitor value the way it shows a typed measurement would undo the
		// distinction these carry.
		Source: observationSourceToProto[o.Source],
		// An unmapped stored state goes out as PENDING rather than as
		// UNSPECIFIED. A client reading "unspecified" might render it as an
		// ordinary value; reading "pending" it renders it as provisional,
		// which is the safe direction for a reading nobody can classify.
		Validation:     validationOnTheWire(o.Validation),
		Device:         deviceSourceToProto(o.Device),
		ValidatedBy:    o.ValidatedBy,
		ValidatedAt:    timestamp(o.ValidatedAt),
		ValidationNote: o.ValidationNote,
	}
	if o.ReferenceLow != nil {
		out.ReferenceLow = *o.ReferenceLow
		out.HasReferenceRange = true
	}
	if o.ReferenceHigh != nil {
		out.ReferenceHigh = *o.ReferenceHigh
		out.HasReferenceRange = true
	}
	return out
}

func observationsToProto(in domain.ObservationList) []*clinicalv1.Observation {
	out := make([]*clinicalv1.Observation, 0, len(in))
	for _, o := range in {
		out = append(out, observationToProto(o))
	}
	return out
}

func procedureToProto(p domain.Procedure) *clinicalv1.Procedure {
	out := &clinicalv1.Procedure{
		ProcedureId: p.ID, PatientId: p.PatientID, EncounterId: p.EncounterID,
		Code: codingToProto(p.Code), Status: procedureStatusToProto[p.Status],
		Indication: codingToProto(p.Indication),
		BodySite:   codingToProto(p.BodySite),
		Laterality: lateralityToProto[p.Laterality], Outcome: p.Outcome,
		Complications: codingsToProto(p.Complications),
		OrderIds:      p.OrderIDs, DeviceIds: p.DeviceIDs, SpecimenIds: p.SpecimenIDs,
		PerformedStart: timestamp(p.PerformedStart),
		PerformedEnd:   timestamp(p.PerformedEnd),
		Note:           p.Note, RecordedBy: p.RecordedBy,
		RecordedAt: timestamp(p.RecordedAt),
	}
	for _, performer := range p.Performers {
		out.Performers = append(out.Performers, &clinicalv1.Performer{
			SubjectId: performer.SubjectID, Role: performer.Role,
		})
	}
	return out
}

func proceduresToProto(in []domain.Procedure) []*clinicalv1.Procedure {
	out := make([]*clinicalv1.Procedure, 0, len(in))
	for _, p := range in {
		out = append(out, procedureToProto(p))
	}
	return out
}

func performersFromProto(in []*clinicalv1.Performer) []domain.Performer {
	out := make([]domain.Performer, 0, len(in))
	for _, p := range in {
		out = append(out, domain.Performer{SubjectID: p.GetSubjectId(), Role: p.GetRole()})
	}
	return out
}

func carePlanToProto(p domain.CarePlan) *clinicalv1.CarePlan {
	out := &clinicalv1.CarePlan{
		CarePlanId: p.ID, PatientId: p.PatientID, EncounterId: p.EncounterID,
		Title: p.Title, Status: carePlanStatusToProto[p.Status],
		ProblemIds: p.ProblemIDs, OwnerId: p.OwnerID,
		StartsAt: timestamp(p.StartsAt), EndsAt: timestamp(p.EndsAt),
		Version: p.Version,
	}
	for _, g := range p.Goals {
		out.Goals = append(out.Goals, &clinicalv1.Goal{
			GoalId: g.ID, Description: g.Description,
			Status: goalStatusToProto[g.Status], TargetDate: timestamp(g.TargetDate),
			AchievedAt: timestamp(g.AchievedAt),
		})
	}
	for _, a := range p.Activities {
		out.Activities = append(out.Activities, &clinicalv1.Activity{
			ActivityId: a.ID, Description: a.Description, OwnerId: a.OwnerID,
			Status:       activityStatusToProto[a.Status],
			ScheduledFor: timestamp(a.ScheduledFor), TaskId: a.TaskID,
		})
	}
	return out
}

func carePlansToProto(in []domain.CarePlan) []*clinicalv1.CarePlan {
	out := make([]*clinicalv1.CarePlan, 0, len(in))
	for _, p := range in {
		out = append(out, carePlanToProto(p))
	}
	return out
}

func goalsFromProto(in []*clinicalv1.Goal) []domain.Goal {
	out := make([]domain.Goal, 0, len(in))
	for _, g := range in {
		out = append(out, domain.Goal{
			ID: g.GetGoalId(), Description: g.GetDescription(),
			Status:     goalStatusFromProto[g.GetStatus()],
			TargetDate: fromTimestamp(g.GetTargetDate()),
			AchievedAt: fromTimestamp(g.GetAchievedAt()),
		})
	}
	return out
}

func activitiesFromProto(in []*clinicalv1.Activity) []domain.Activity {
	out := make([]domain.Activity, 0, len(in))
	for _, a := range in {
		out = append(out, domain.Activity{
			ID: a.GetActivityId(), Description: a.GetDescription(),
			OwnerID: a.GetOwnerId(), Status: activityStatusFromProto[a.GetStatus()],
			ScheduledFor: fromTimestamp(a.GetScheduledFor()), TaskID: a.GetTaskId(),
		})
	}
	return out
}

func provenanceToProto(p domain.Provenance) *clinicalv1.Provenance {
	return &clinicalv1.Provenance{
		ProvenanceId: p.ID, RecordType: p.RecordType, RecordId: p.RecordID,
		SourceOrganization: p.SourceOrganization, SourceSystem: p.SourceSystem,
		SourceRecordId: p.SourceRecordID, IngestedAt: timestamp(p.IngestedAt),
		AuthoredAt: timestamp(p.AuthoredAt), AuthoredBy: p.AuthoredBy,
		Assertion: p.Assertion,
	}
}

func provenancesToProto(in []domain.Provenance) []*clinicalv1.Provenance {
	out := make([]*clinicalv1.Provenance, 0, len(in))
	for _, p := range in {
		out = append(out, provenanceToProto(p))
	}
	return out
}

func provenanceInputFromProto(p *clinicalv1.Provenance) *domain.ProvenanceInput {
	if p == nil || p.GetSourceOrganization() == "" {
		return nil
	}
	return &domain.ProvenanceInput{
		SourceOrganization: p.GetSourceOrganization(),
		SourceSystem:       p.GetSourceSystem(),
		SourceRecordID:     p.GetSourceRecordId(),
		IngestedAt:         fromTimestamp(p.GetIngestedAt()),
		AuthoredAt:         fromTimestamp(p.GetAuthoredAt()),
		AuthoredBy:         p.GetAuthoredBy(),
		Assertion:          p.GetAssertion(),
	}
}

func attachmentToProto(a domain.Attachment) *clinicalv1.Attachment {
	return &clinicalv1.Attachment{
		AttachmentId: a.ID, ParentType: a.ParentType, ParentId: a.ParentID,
		PatientId: a.PatientID, Kind: attachmentKindToProto[a.Kind],
		ContentType: a.ContentType, StorageKey: a.StorageKey,
		SizeBytes: a.SizeBytes, Digest: a.Digest, Description: a.Description,
		Confidentiality: confidentialityToProto[a.Confidentiality],
		CapturedAt:      timestamp(a.CapturedAt), SourceSystem: a.SourceSystem,
		UploadedBy: a.UploadedBy, UploadedAt: timestamp(a.UploadedAt),
	}
}

func attachmentsToProto(in []domain.Attachment) []*clinicalv1.Attachment {
	out := make([]*clinicalv1.Attachment, 0, len(in))
	for _, a := range in {
		out = append(out, attachmentToProto(a))
	}
	return out
}

func consentToProto(c domain.ClinicalConsent) *clinicalv1.ClinicalConsent {
	return &clinicalv1.ClinicalConsent{
		ConsentId: c.ID, PatientId: c.PatientID, EncounterId: c.EncounterID,
		Kind: consentKindToProto[c.Kind], ProcedureCode: codingToProto(c.ProcedureCode),
		Status: consentStatusToProto[c.Status], GivenBy: consentGiverToProto[c.GivenBy],
		GivenByName: c.GivenByName, DocumentId: c.DocumentID, WitnessId: c.WitnessID,
		ValidFrom: timestamp(c.ValidFrom), ValidUntil: timestamp(c.ValidUntil),
		Note: c.Note, RecordedBy: c.RecordedBy,
	}
}

func consentsToProto(in domain.ConsentSet) []*clinicalv1.ClinicalConsent {
	out := make([]*clinicalv1.ClinicalConsent, 0, len(in))
	for _, c := range in {
		out = append(out, consentToProto(c))
	}
	return out
}

func calculationToProto(r domain.CalculatorResult) *clinicalv1.CalculatorResult {
	out := &clinicalv1.CalculatorResult{
		ResultId: r.ID, PatientId: r.PatientID, EncounterId: r.EncounterID,
		CalculatorId: r.CalculatorID, FormulaVersion: r.Version, Name: r.Name,
		Value: r.Value, Unit: r.Unit, Interpretation: r.Interpretation,
		SupersededById: r.SupersededByID, CalculatedBy: r.CalculatedBy,
		CalculatedAt: timestamp(r.CalculatedAt),
	}
	for _, input := range r.Inputs {
		out.Inputs = append(out.Inputs, &clinicalv1.CalculatorInput{
			Name: input.Name, Value: input.Value, Unit: input.Unit,
			SourceId: input.SourceID,
		})
	}
	return out
}

func calculationsToProto(in []domain.CalculatorResult) []*clinicalv1.CalculatorResult {
	out := make([]*clinicalv1.CalculatorResult, 0, len(in))
	for _, r := range in {
		out = append(out, calculationToProto(r))
	}
	return out
}

func calculatorInputsFromProto(in []*clinicalv1.CalculatorInput) []domain.CalculatorInput {
	out := make([]domain.CalculatorInput, 0, len(in))
	for _, i := range in {
		out = append(out, domain.CalculatorInput{
			Name: i.GetName(), Value: i.GetValue(), Unit: i.GetUnit(),
			SourceID: i.GetSourceId(),
		})
	}
	return out
}

func alertToProto(a domain.CDSAlert) *clinicalv1.CDSAlert {
	return &clinicalv1.CDSAlert{
		AlertId: a.ID, PatientId: a.PatientID, EncounterId: a.EncounterID,
		RuleId: a.RuleID, RuleVersion: a.RuleVersion,
		Level: alertLevelToProto[a.Level], Message: a.Message,
		ContextType: a.ContextType, ContextId: a.ContextID,
		Outcome:      alertOutcomeToProto[a.Outcome],
		OverrideCode: a.OverrideCode, OverrideReason: a.OverrideReason,
		FiredAt: timestamp(a.FiredAt), RespondedBy: a.RespondedBy,
		RespondedAt: timestamp(a.RespondedAt),
	}
}

func alertsToProto(in []domain.CDSAlert) []*clinicalv1.CDSAlert {
	out := make([]*clinicalv1.CDSAlert, 0, len(in))
	for _, a := range in {
		out = append(out, alertToProto(a))
	}
	return out
}

func consultToProto(c domain.Consult) *clinicalv1.Consult {
	return &clinicalv1.Consult{
		ConsultId: c.ID, PatientId: c.PatientID, EncounterId: c.EncounterID,
		Specialty: c.Specialty, Urgency: consultUrgencyToProto[c.Urgency],
		Reason: c.Reason, Question: c.Question,
		Status:              consultStatusToProto[c.Status],
		RespondingSubjectId: c.RespondingSubjectID, Response: c.Response,
		ResponseDocumentId: c.ResponseDocumentID, DeclineReason: c.DeclineReason,
		RequestedBy: c.RequestedBy, RequestedAt: timestamp(c.RequestedAt),
		RespondedAt: timestamp(c.RespondedAt), Version: c.Version,
	}
}

func consultsToProto(in []domain.Consult) []*clinicalv1.Consult {
	out := make([]*clinicalv1.Consult, 0, len(in))
	for _, c := range in {
		out = append(out, consultToProto(c))
	}
	return out
}

func membershipToProto(m domain.RegistryMembership) *clinicalv1.RegistryMembership {
	return &clinicalv1.RegistryMembership{
		MembershipId: m.ID, PatientId: m.PatientID, RegistryId: m.RegistryID,
		ProblemId: m.ProblemID, DiagnosisId: m.DiagnosisID,
		EnrolledAt: timestamp(m.EnrolledAt), ExitedAt: timestamp(m.ExitedAt),
		ExitReason: m.ExitReason, Consented: m.Consented,
	}
}

func membershipsToProto(in []domain.RegistryMembership) []*clinicalv1.RegistryMembership {
	out := make([]*clinicalv1.RegistryMembership, 0, len(in))
	for _, m := range in {
		out = append(out, membershipToProto(m))
	}
	return out
}

func phraseToProto(p domain.SmartPhrase) *clinicalv1.SmartPhrase {
	return &clinicalv1.SmartPhrase{
		PhraseId: p.ID, OwnerId: p.OwnerID,
		Shortcut: p.Shortcut, Expansion: p.Expansion,
	}
}

func phrasesToProto(in []domain.SmartPhrase) []*clinicalv1.SmartPhrase {
	out := make([]*clinicalv1.SmartPhrase, 0, len(in))
	for _, p := range in {
		out = append(out, phraseToProto(p))
	}
	return out
}

func bannerToProto(b domain.Banner) *clinicalv1.Banner {
	out := &clinicalv1.Banner{
		PatientId: b.PatientID, DisplayName: b.DisplayName,
		AgeDisplay: b.AgeDisplay, Sex: b.Sex,
		EncounterContext: b.EncounterContext, Deceased: b.Deceased,
	}
	for _, i := range b.Identifiers {
		out.Identifiers = append(out.Identifiers, &clinicalv1.BannerIdentifier{
			System: i.System, Value: i.Value, Label: i.Label,
		})
	}
	for _, a := range b.Alerts {
		out.Alerts = append(out.Alerts, &clinicalv1.BannerAlert{
			Severity: string(a.Severity), Kind: a.Kind,
			Text: a.Text, RecordId: a.RecordID,
		})
	}
	return out
}

func domainQuantity(q *clinicalv1.Quantity) domain.Quantity {
	if q == nil {
		return domain.Quantity{}
	}
	return domain.Quantity{Value: q.GetValue(), Unit: q.GetUnit()}
}

// Device-sourced observations (SRS-ICU-003).

var observationSourceToProto = map[domain.SourceKind]clinicalv1.ObservationSource{
	domain.SourceManual:   clinicalv1.ObservationSource_OBSERVATION_SOURCE_MANUAL,
	domain.SourceDevice:   clinicalv1.ObservationSource_OBSERVATION_SOURCE_DEVICE,
	domain.SourceImported: clinicalv1.ObservationSource_OBSERVATION_SOURCE_IMPORTED,
	// SourceUnknown has no wire value on purpose. A reading this build cannot
	// classify goes out as UNSPECIFIED, which a client reads as "not stated"
	// rather than as one of the three it knows — and the validation state
	// beside it says pending, which is the answer that matters.
	domain.SourceUnknown: clinicalv1.ObservationSource_OBSERVATION_SOURCE_UNSPECIFIED,
}

var validationToProto = map[domain.Validation]clinicalv1.ValidationState{
	domain.ValidationNotRequired: clinicalv1.ValidationState_VALIDATION_STATE_NOT_REQUIRED,
	domain.ValidationPending:     clinicalv1.ValidationState_VALIDATION_STATE_PENDING,
	domain.ValidationConfirmed:   clinicalv1.ValidationState_VALIDATION_STATE_CONFIRMED,
	domain.ValidationRejected:    clinicalv1.ValidationState_VALIDATION_STATE_REJECTED,
}

func deviceSourceToProto(d domain.DeviceSource) *clinicalv1.DeviceSource {
	if strings.TrimSpace(d.DeviceID) == "" {
		return nil
	}
	return &clinicalv1.DeviceSource{
		DeviceId: d.DeviceID, Channel: d.Channel, Quality: d.Quality,
		ObservedAt: timestamp(d.ObservedAt), ReceivedAt: timestamp(d.ReceivedAt),
	}
}

func deviceSourceFromProto(in *clinicalv1.DeviceSource) domain.DeviceSource {
	if in == nil {
		return domain.DeviceSource{}
	}
	return domain.DeviceSource{
		DeviceID: in.GetDeviceId(), Channel: in.GetChannel(),
		Quality:    in.GetQuality(),
		ObservedAt: fromTimestamp(in.GetObservedAt()),
		ReceivedAt: fromTimestamp(in.GetReceivedAt()),
	}
}

// validationOnTheWire renders a validation state, defaulting to pending.
//
// Never UNSPECIFIED. A client that meets an unknown state has to render it as
// something, and "provisional" is the reading that cannot hurt anybody.
func validationOnTheWire(v domain.Validation) clinicalv1.ValidationState {
	if mapped, ok := validationToProto[v]; ok {
		return mapped
	}
	return clinicalv1.ValidationState_VALIDATION_STATE_PENDING
}
