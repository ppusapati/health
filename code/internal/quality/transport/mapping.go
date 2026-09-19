// Package transport translates between the quality contract and the domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default fails in the safe direction: an
// unrecognised reach or harm level stays empty and the domain refuses it
// rather than guessing that a client meant "near miss", and an unrecognised
// verdict stays empty so a clause is not silently judged met.
package transport

import (
	"sort"
	"time"

	qualityv1 "github.com/ppusapati/health/code/gen/go/healthcare/quality/v1"
	"github.com/ppusapati/health/code/internal/quality/application"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on the
		// wire, and a policy effective in 1970 is a policy every acknowledgement
		// report treats as current.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var reachFromWire = map[qualityv1.Reach]domain.Reach{
	qualityv1.Reach_REACH_NEAR_MISS:   domain.ReachNearMiss,
	qualityv1.Reach_REACH_NO_HARM:     domain.ReachNoHarm,
	qualityv1.Reach_REACH_HARM:        domain.ReachHarm,
	qualityv1.Reach_REACH_NOT_PATIENT: domain.ReachNotPatient,
}

var reachToWire = map[domain.Reach]qualityv1.Reach{
	domain.ReachNearMiss:   qualityv1.Reach_REACH_NEAR_MISS,
	domain.ReachNoHarm:     qualityv1.Reach_REACH_NO_HARM,
	domain.ReachHarm:       qualityv1.Reach_REACH_HARM,
	domain.ReachNotPatient: qualityv1.Reach_REACH_NOT_PATIENT,
}

var harmFromWire = map[qualityv1.Harm]domain.Harm{
	qualityv1.Harm_HARM_NONE:     domain.HarmNone,
	qualityv1.Harm_HARM_MILD:     domain.HarmMild,
	qualityv1.Harm_HARM_MODERATE: domain.HarmModerate,
	qualityv1.Harm_HARM_SEVERE:   domain.HarmSevere,
	qualityv1.Harm_HARM_DEATH:    domain.HarmDeath,
}

var harmToWire = map[domain.Harm]qualityv1.Harm{
	domain.HarmNone:     qualityv1.Harm_HARM_NONE,
	domain.HarmMild:     qualityv1.Harm_HARM_MILD,
	domain.HarmModerate: qualityv1.Harm_HARM_MODERATE,
	domain.HarmSevere:   qualityv1.Harm_HARM_SEVERE,
	domain.HarmDeath:    qualityv1.Harm_HARM_DEATH,
}

var consequenceFromWire = map[qualityv1.Consequence]domain.Consequence{
	qualityv1.Consequence_CONSEQUENCE_NEGLIGIBLE:   domain.ConsequenceNegligible,
	qualityv1.Consequence_CONSEQUENCE_MINOR:        domain.ConsequenceMinor,
	qualityv1.Consequence_CONSEQUENCE_MODERATE:     domain.ConsequenceModerate,
	qualityv1.Consequence_CONSEQUENCE_MAJOR:        domain.ConsequenceMajor,
	qualityv1.Consequence_CONSEQUENCE_CATASTROPHIC: domain.ConsequenceCatastrophic,
}

var consequenceToWire = map[domain.Consequence]qualityv1.Consequence{
	domain.ConsequenceNegligible:   qualityv1.Consequence_CONSEQUENCE_NEGLIGIBLE,
	domain.ConsequenceMinor:        qualityv1.Consequence_CONSEQUENCE_MINOR,
	domain.ConsequenceModerate:     qualityv1.Consequence_CONSEQUENCE_MODERATE,
	domain.ConsequenceMajor:        qualityv1.Consequence_CONSEQUENCE_MAJOR,
	domain.ConsequenceCatastrophic: qualityv1.Consequence_CONSEQUENCE_CATASTROPHIC,
}

var likelihoodFromWire = map[qualityv1.Likelihood]domain.Likelihood{
	qualityv1.Likelihood_LIKELIHOOD_RARE:           domain.LikelihoodRare,
	qualityv1.Likelihood_LIKELIHOOD_UNLIKELY:       domain.LikelihoodUnlikely,
	qualityv1.Likelihood_LIKELIHOOD_POSSIBLE:       domain.LikelihoodPossible,
	qualityv1.Likelihood_LIKELIHOOD_LIKELY:         domain.LikelihoodLikely,
	qualityv1.Likelihood_LIKELIHOOD_ALMOST_CERTAIN: domain.LikelihoodAlmostCertain,
}

var likelihoodToWire = map[domain.Likelihood]qualityv1.Likelihood{
	domain.LikelihoodRare:          qualityv1.Likelihood_LIKELIHOOD_RARE,
	domain.LikelihoodUnlikely:      qualityv1.Likelihood_LIKELIHOOD_UNLIKELY,
	domain.LikelihoodPossible:      qualityv1.Likelihood_LIKELIHOOD_POSSIBLE,
	domain.LikelihoodLikely:        qualityv1.Likelihood_LIKELIHOOD_LIKELY,
	domain.LikelihoodAlmostCertain: qualityv1.Likelihood_LIKELIHOOD_ALMOST_CERTAIN,
}

var bandToWire = map[domain.RiskBand]qualityv1.RiskBand{
	domain.RiskLow:      qualityv1.RiskBand_RISK_BAND_LOW,
	domain.RiskModerate: qualityv1.RiskBand_RISK_BAND_MODERATE,
	domain.RiskHigh:     qualityv1.RiskBand_RISK_BAND_HIGH,
	domain.RiskExtreme:  qualityv1.RiskBand_RISK_BAND_EXTREME,
}

var incidentStateFromWire = map[qualityv1.IncidentState]domain.IncidentState{
	qualityv1.IncidentState_INCIDENT_STATE_REPORTED:     domain.IncidentReported,
	qualityv1.IncidentState_INCIDENT_STATE_UNDER_REVIEW: domain.IncidentUnderReview,
	qualityv1.IncidentState_INCIDENT_STATE_INVESTIGATED: domain.IncidentInvestigated,
	qualityv1.IncidentState_INCIDENT_STATE_CLOSED:       domain.IncidentClosed,
	qualityv1.IncidentState_INCIDENT_STATE_REJECTED:     domain.IncidentRejected,
}

var incidentStateToWire = map[domain.IncidentState]qualityv1.IncidentState{
	domain.IncidentReported:     qualityv1.IncidentState_INCIDENT_STATE_REPORTED,
	domain.IncidentUnderReview:  qualityv1.IncidentState_INCIDENT_STATE_UNDER_REVIEW,
	domain.IncidentInvestigated: qualityv1.IncidentState_INCIDENT_STATE_INVESTIGATED,
	domain.IncidentClosed:       qualityv1.IncidentState_INCIDENT_STATE_CLOSED,
	domain.IncidentRejected:     qualityv1.IncidentState_INCIDENT_STATE_REJECTED,
}

var factorFromWire = map[qualityv1.FactorCategory]domain.FactorCategory{
	qualityv1.FactorCategory_FACTOR_CATEGORY_PATIENT:        domain.FactorPatient,
	qualityv1.FactorCategory_FACTOR_CATEGORY_TASK:           domain.FactorTask,
	qualityv1.FactorCategory_FACTOR_CATEGORY_INDIVIDUAL:     domain.FactorIndividual,
	qualityv1.FactorCategory_FACTOR_CATEGORY_TEAM:           domain.FactorTeam,
	qualityv1.FactorCategory_FACTOR_CATEGORY_ENVIRONMENT:    domain.FactorEnvironment,
	qualityv1.FactorCategory_FACTOR_CATEGORY_EQUIPMENT:      domain.FactorEquipment,
	qualityv1.FactorCategory_FACTOR_CATEGORY_ORGANISATIONAL: domain.FactorOrganisational,
}

var factorToWire = map[domain.FactorCategory]qualityv1.FactorCategory{
	domain.FactorPatient:        qualityv1.FactorCategory_FACTOR_CATEGORY_PATIENT,
	domain.FactorTask:           qualityv1.FactorCategory_FACTOR_CATEGORY_TASK,
	domain.FactorIndividual:     qualityv1.FactorCategory_FACTOR_CATEGORY_INDIVIDUAL,
	domain.FactorTeam:           qualityv1.FactorCategory_FACTOR_CATEGORY_TEAM,
	domain.FactorEnvironment:    qualityv1.FactorCategory_FACTOR_CATEGORY_ENVIRONMENT,
	domain.FactorEquipment:      qualityv1.FactorCategory_FACTOR_CATEGORY_EQUIPMENT,
	domain.FactorOrganisational: qualityv1.FactorCategory_FACTOR_CATEGORY_ORGANISATIONAL,
}

var reviewStateToWire = map[domain.RCAState]qualityv1.ReviewState{
	domain.RCAOpen:     qualityv1.ReviewState_REVIEW_STATE_OPEN,
	domain.RCAComplete: qualityv1.ReviewState_REVIEW_STATE_COMPLETE,
}

var actionKindFromWire = map[qualityv1.ActionKind]domain.ActionKind{
	qualityv1.ActionKind_ACTION_KIND_CORRECTIVE: domain.ActionCorrective,
	qualityv1.ActionKind_ACTION_KIND_PREVENTIVE: domain.ActionPreventive,
}

var actionKindToWire = map[domain.ActionKind]qualityv1.ActionKind{
	domain.ActionCorrective: qualityv1.ActionKind_ACTION_KIND_CORRECTIVE,
	domain.ActionPreventive: qualityv1.ActionKind_ACTION_KIND_PREVENTIVE,
}

var sourceFromWire = map[qualityv1.ActionSource]domain.SourceKind{
	qualityv1.ActionSource_ACTION_SOURCE_INCIDENT:      domain.SourceIncident,
	qualityv1.ActionSource_ACTION_SOURCE_RCA:           domain.SourceRCA,
	qualityv1.ActionSource_ACTION_SOURCE_AUDIT_FINDING: domain.SourceAudit,
	qualityv1.ActionSource_ACTION_SOURCE_COMPLAINT:     domain.SourceComplaint,
	qualityv1.ActionSource_ACTION_SOURCE_COMMITTEE:     domain.SourceCommittee,
	qualityv1.ActionSource_ACTION_SOURCE_INSPECTION:    domain.SourceInspection,
}

var sourceToWire = map[domain.SourceKind]qualityv1.ActionSource{
	domain.SourceIncident:   qualityv1.ActionSource_ACTION_SOURCE_INCIDENT,
	domain.SourceRCA:        qualityv1.ActionSource_ACTION_SOURCE_RCA,
	domain.SourceAudit:      qualityv1.ActionSource_ACTION_SOURCE_AUDIT_FINDING,
	domain.SourceComplaint:  qualityv1.ActionSource_ACTION_SOURCE_COMPLAINT,
	domain.SourceCommittee:  qualityv1.ActionSource_ACTION_SOURCE_COMMITTEE,
	domain.SourceInspection: qualityv1.ActionSource_ACTION_SOURCE_INSPECTION,
}

var actionStateFromWire = map[qualityv1.ActionState]domain.CAPAState{
	qualityv1.ActionState_ACTION_STATE_DRAFT:                domain.CAPADraft,
	qualityv1.ActionState_ACTION_STATE_APPROVED:             domain.CAPAApproved,
	qualityv1.ActionState_ACTION_STATE_OPEN:                 domain.CAPAOpen,
	qualityv1.ActionState_ACTION_STATE_IN_PROGRESS:          domain.CAPAInProgress,
	qualityv1.ActionState_ACTION_STATE_EFFECTIVENESS_REVIEW: domain.CAPAEffectivenessDue,
	// Deliberately no mapping for CLOSED. Closing goes through its own RPC,
	// because the effectiveness check and the owner separation are checked
	// there — and the domain refuses it as a plain state change anyway.
	qualityv1.ActionState_ACTION_STATE_CANCELLED: domain.CAPACancelled,
}

var actionStateToWire = map[domain.CAPAState]qualityv1.ActionState{
	domain.CAPADraft:            qualityv1.ActionState_ACTION_STATE_DRAFT,
	domain.CAPAApproved:         qualityv1.ActionState_ACTION_STATE_APPROVED,
	domain.CAPAOpen:             qualityv1.ActionState_ACTION_STATE_OPEN,
	domain.CAPAInProgress:       qualityv1.ActionState_ACTION_STATE_IN_PROGRESS,
	domain.CAPAEffectivenessDue: qualityv1.ActionState_ACTION_STATE_EFFECTIVENESS_REVIEW,
	domain.CAPAClosed:           qualityv1.ActionState_ACTION_STATE_CLOSED,
	domain.CAPACancelled:        qualityv1.ActionState_ACTION_STATE_CANCELLED,
}

var documentKindFromWire = map[qualityv1.DocumentKind]domain.DocumentKind{
	qualityv1.DocumentKind_DOCUMENT_KIND_POLICY:    domain.DocumentPolicy,
	qualityv1.DocumentKind_DOCUMENT_KIND_SOP:       domain.DocumentSOP,
	qualityv1.DocumentKind_DOCUMENT_KIND_PROTOCOL:  domain.DocumentProtocol,
	qualityv1.DocumentKind_DOCUMENT_KIND_GUIDELINE: domain.DocumentGuideline,
	qualityv1.DocumentKind_DOCUMENT_KIND_FORM:      domain.DocumentForm,
	qualityv1.DocumentKind_DOCUMENT_KIND_MANUAL:    domain.DocumentManual,
}

var documentKindToWire = map[domain.DocumentKind]qualityv1.DocumentKind{
	domain.DocumentPolicy:    qualityv1.DocumentKind_DOCUMENT_KIND_POLICY,
	domain.DocumentSOP:       qualityv1.DocumentKind_DOCUMENT_KIND_SOP,
	domain.DocumentProtocol:  qualityv1.DocumentKind_DOCUMENT_KIND_PROTOCOL,
	domain.DocumentGuideline: qualityv1.DocumentKind_DOCUMENT_KIND_GUIDELINE,
	domain.DocumentForm:      qualityv1.DocumentKind_DOCUMENT_KIND_FORM,
	domain.DocumentManual:    qualityv1.DocumentKind_DOCUMENT_KIND_MANUAL,
}

var versionStateToWire = map[domain.VersionState]qualityv1.VersionState{
	domain.VersionDraft:     qualityv1.VersionState_VERSION_STATE_DRAFT,
	domain.VersionApproved:  qualityv1.VersionState_VERSION_STATE_APPROVED,
	domain.VersionEffective: qualityv1.VersionState_VERSION_STATE_EFFECTIVE,
	domain.VersionObsolete:  qualityv1.VersionState_VERSION_STATE_OBSOLETE,
}

var severityFromWire = map[qualityv1.FindingSeverity]domain.FindingSeverity{
	qualityv1.FindingSeverity_FINDING_SEVERITY_OBSERVATION: domain.FindingObservation,
	qualityv1.FindingSeverity_FINDING_SEVERITY_MINOR_NC:    domain.FindingMinor,
	qualityv1.FindingSeverity_FINDING_SEVERITY_MAJOR_NC:    domain.FindingMajor,
}

var severityToWire = map[domain.FindingSeverity]qualityv1.FindingSeverity{
	domain.FindingObservation: qualityv1.FindingSeverity_FINDING_SEVERITY_OBSERVATION,
	domain.FindingMinor:       qualityv1.FindingSeverity_FINDING_SEVERITY_MINOR_NC,
	domain.FindingMajor:       qualityv1.FindingSeverity_FINDING_SEVERITY_MAJOR_NC,
}

var auditStateFromWire = map[qualityv1.AuditState]domain.AuditState{
	qualityv1.AuditState_AUDIT_STATE_PLANNED:     domain.AuditPlanned,
	qualityv1.AuditState_AUDIT_STATE_IN_PROGRESS: domain.AuditInProgress,
	qualityv1.AuditState_AUDIT_STATE_REPORTED:    domain.AuditReported,
	qualityv1.AuditState_AUDIT_STATE_CLOSED:      domain.AuditClosed,
	qualityv1.AuditState_AUDIT_STATE_CANCELLED:   domain.AuditCancelled,
}

var auditStateToWire = map[domain.AuditState]qualityv1.AuditState{
	domain.AuditPlanned:    qualityv1.AuditState_AUDIT_STATE_PLANNED,
	domain.AuditInProgress: qualityv1.AuditState_AUDIT_STATE_IN_PROGRESS,
	domain.AuditReported:   qualityv1.AuditState_AUDIT_STATE_REPORTED,
	domain.AuditClosed:     qualityv1.AuditState_AUDIT_STATE_CLOSED,
	domain.AuditCancelled:  qualityv1.AuditState_AUDIT_STATE_CANCELLED,
}

var meetingStateToWire = map[domain.MeetingState]qualityv1.MeetingState{
	domain.MeetingScheduled: qualityv1.MeetingState_MEETING_STATE_SCHEDULED,
	domain.MeetingHeld:      qualityv1.MeetingState_MEETING_STATE_HELD,
	domain.MeetingApproved:  qualityv1.MeetingState_MEETING_STATE_MINUTES_APPROVED,
	domain.MeetingCancelled: qualityv1.MeetingState_MEETING_STATE_CANCELLED,
}

var evidenceKindFromWire = map[qualityv1.EvidenceKind]domain.EvidenceKind{
	qualityv1.EvidenceKind_EVIDENCE_KIND_DOCUMENT_VERSION:  domain.EvidenceDocument,
	qualityv1.EvidenceKind_EVIDENCE_KIND_AUDIT:             domain.EvidenceAudit,
	qualityv1.EvidenceKind_EVIDENCE_KIND_AUDIT_FINDING:     domain.EvidenceFinding,
	qualityv1.EvidenceKind_EVIDENCE_KIND_CAPA:              domain.EvidenceCAPA,
	qualityv1.EvidenceKind_EVIDENCE_KIND_KPI:               domain.EvidenceKPI,
	qualityv1.EvidenceKind_EVIDENCE_KIND_COMMITTEE_MEETING: domain.EvidenceMeeting,
	qualityv1.EvidenceKind_EVIDENCE_KIND_COMPETENCY:        domain.EvidenceTraining,
	qualityv1.EvidenceKind_EVIDENCE_KIND_EXTERNAL:          domain.EvidenceExternal,
}

var evidenceKindToWire = map[domain.EvidenceKind]qualityv1.EvidenceKind{
	domain.EvidenceDocument: qualityv1.EvidenceKind_EVIDENCE_KIND_DOCUMENT_VERSION,
	domain.EvidenceAudit:    qualityv1.EvidenceKind_EVIDENCE_KIND_AUDIT,
	domain.EvidenceFinding:  qualityv1.EvidenceKind_EVIDENCE_KIND_AUDIT_FINDING,
	domain.EvidenceCAPA:     qualityv1.EvidenceKind_EVIDENCE_KIND_CAPA,
	domain.EvidenceKPI:      qualityv1.EvidenceKind_EVIDENCE_KIND_KPI,
	domain.EvidenceMeeting:  qualityv1.EvidenceKind_EVIDENCE_KIND_COMMITTEE_MEETING,
	domain.EvidenceTraining: qualityv1.EvidenceKind_EVIDENCE_KIND_COMPETENCY,
	domain.EvidenceExternal: qualityv1.EvidenceKind_EVIDENCE_KIND_EXTERNAL,
}

var verdictFromWire = map[qualityv1.Verdict]domain.Verdict{
	qualityv1.Verdict_VERDICT_MET:            domain.VerdictMet,
	qualityv1.Verdict_VERDICT_PARTIALLY_MET:  domain.VerdictPartiallyMet,
	qualityv1.Verdict_VERDICT_NOT_MET:        domain.VerdictNotMet,
	qualityv1.Verdict_VERDICT_NOT_APPLICABLE: domain.VerdictNotApplicable,
}

var verdictToWire = map[domain.Verdict]qualityv1.Verdict{
	domain.VerdictUnreviewed:    qualityv1.Verdict_VERDICT_UNREVIEWED,
	domain.VerdictMet:           qualityv1.Verdict_VERDICT_MET,
	domain.VerdictPartiallyMet:  qualityv1.Verdict_VERDICT_PARTIALLY_MET,
	domain.VerdictNotMet:        qualityv1.Verdict_VERDICT_NOT_MET,
	domain.VerdictNotApplicable: qualityv1.Verdict_VERDICT_NOT_APPLICABLE,
}

var directionFromWire = map[qualityv1.Direction]domain.Direction{
	qualityv1.Direction_DIRECTION_HIGHER_IS_BETTER: domain.DirectionHigherIsBetter,
	qualityv1.Direction_DIRECTION_LOWER_IS_BETTER:  domain.DirectionLowerIsBetter,
}

var directionToWire = map[domain.Direction]qualityv1.Direction{
	domain.DirectionHigherIsBetter: qualityv1.Direction_DIRECTION_HIGHER_IS_BETTER,
	domain.DirectionLowerIsBetter:  qualityv1.Direction_DIRECTION_LOWER_IS_BETTER,
}

var frequencyFromWire = map[qualityv1.Frequency]domain.Frequency{
	qualityv1.Frequency_FREQUENCY_DAILY:     domain.FrequencyDaily,
	qualityv1.Frequency_FREQUENCY_WEEKLY:    domain.FrequencyWeekly,
	qualityv1.Frequency_FREQUENCY_MONTHLY:   domain.FrequencyMonthly,
	qualityv1.Frequency_FREQUENCY_QUARTERLY: domain.FrequencyQuarterly,
	qualityv1.Frequency_FREQUENCY_ANNUAL:    domain.FrequencyAnnual,
}

var frequencyToWire = map[domain.Frequency]qualityv1.Frequency{
	domain.FrequencyDaily:     qualityv1.Frequency_FREQUENCY_DAILY,
	domain.FrequencyWeekly:    qualityv1.Frequency_FREQUENCY_WEEKLY,
	domain.FrequencyMonthly:   qualityv1.Frequency_FREQUENCY_MONTHLY,
	domain.FrequencyQuarterly: qualityv1.Frequency_FREQUENCY_QUARTERLY,
	domain.FrequencyAnnual:    qualityv1.Frequency_FREQUENCY_ANNUAL,
}

var complainantFromWire = map[qualityv1.ComplainantKind]domain.ComplainantKind{
	qualityv1.ComplainantKind_COMPLAINANT_KIND_PATIENT:  domain.ComplainantPatient,
	qualityv1.ComplainantKind_COMPLAINANT_KIND_RELATIVE: domain.ComplainantRelative,
	qualityv1.ComplainantKind_COMPLAINANT_KIND_VISITOR:  domain.ComplainantVisitor,
	qualityv1.ComplainantKind_COMPLAINANT_KIND_STAFF:    domain.ComplainantStaff,
	qualityv1.ComplainantKind_COMPLAINANT_KIND_EXTERNAL: domain.ComplainantExternal,
}

var complainantToWire = map[domain.ComplainantKind]qualityv1.ComplainantKind{
	domain.ComplainantPatient:  qualityv1.ComplainantKind_COMPLAINANT_KIND_PATIENT,
	domain.ComplainantRelative: qualityv1.ComplainantKind_COMPLAINANT_KIND_RELATIVE,
	domain.ComplainantVisitor:  qualityv1.ComplainantKind_COMPLAINANT_KIND_VISITOR,
	domain.ComplainantStaff:    qualityv1.ComplainantKind_COMPLAINANT_KIND_STAFF,
	domain.ComplainantExternal: qualityv1.ComplainantKind_COMPLAINANT_KIND_EXTERNAL,
}

var outcomeFromWire = map[qualityv1.ComplaintOutcome]domain.Outcome{
	qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_UPHELD:           domain.OutcomeUpheld,
	qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_PARTIALLY_UPHELD: domain.OutcomePartiallyUpheld,
	qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_NOT_UPHELD:       domain.OutcomeNotUpheld,
	qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_WITHDRAWN:        domain.OutcomeWithdrawn,
}

var outcomeToWire = map[domain.Outcome]qualityv1.ComplaintOutcome{
	domain.OutcomeUpheld:          qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_UPHELD,
	domain.OutcomePartiallyUpheld: qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_PARTIALLY_UPHELD,
	domain.OutcomeNotUpheld:       qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_NOT_UPHELD,
	domain.OutcomeWithdrawn:       qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_WITHDRAWN,
}

var complaintStateToWire = map[domain.ComplaintState]qualityv1.ComplaintState{
	domain.ComplaintReceived:      qualityv1.ComplaintState_COMPLAINT_STATE_RECEIVED,
	domain.ComplaintAcknowledged:  qualityv1.ComplaintState_COMPLAINT_STATE_ACKNOWLEDGED,
	domain.ComplaintInvestigating: qualityv1.ComplaintState_COMPLAINT_STATE_INVESTIGATING,
	domain.ComplaintResolved:      qualityv1.ComplaintState_COMPLAINT_STATE_RESOLVED,
	domain.ComplaintClosed:        qualityv1.ComplaintState_COMPLAINT_STATE_CLOSED,
}

var deathFromWire = map[qualityv1.DeathClassification]domain.DeathClassification{
	qualityv1.DeathClassification_DEATH_CLASSIFICATION_EXPECTED:                domain.DeathExpected,
	qualityv1.DeathClassification_DEATH_CLASSIFICATION_UNEXPECTED:              domain.DeathUnexpected,
	qualityv1.DeathClassification_DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE: domain.DeathPotentiallyPreventable,
	qualityv1.DeathClassification_DEATH_CLASSIFICATION_PREVENTABLE:             domain.DeathPreventable,
}

var deathToWire = map[domain.DeathClassification]qualityv1.DeathClassification{
	domain.DeathExpected:               qualityv1.DeathClassification_DEATH_CLASSIFICATION_EXPECTED,
	domain.DeathUnexpected:             qualityv1.DeathClassification_DEATH_CLASSIFICATION_UNEXPECTED,
	domain.DeathPotentiallyPreventable: qualityv1.DeathClassification_DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE,
	domain.DeathPreventable:            qualityv1.DeathClassification_DEATH_CLASSIFICATION_PREVENTABLE,
}

// incidentToProto renders one report.
//
// redacted is set from the record itself: a restricted incident that comes
// back with a blank narrative has been redacted, and a client that cannot tell
// that from an incident nobody described shows the ward an empty screen and no
// explanation.
func incidentToProto(i domain.Incident) *qualityv1.Incident {
	return &qualityv1.Incident{
		IncidentId: i.ID, Reference: i.Reference,
		Category: i.Category, Subcategory: i.Subcategory,
		Reach: reachToWire[i.Reach], Harm: harmToWire[i.Harm],
		Risk: &qualityv1.Risk{
			Consequence: consequenceToWire[i.Risk.Consequence],
			Likelihood:  likelihoodToWire[i.Risk.Likelihood],
			Score:       int32(i.Risk.Score),
			Band:        bandToWire[i.Risk.Band],
		},
		PatientId: i.PatientID, EncounterId: i.EncounterID,
		AssetId: i.AssetID, LocationId: i.LocationID,
		FacilityId: i.FacilityID, Department: i.Department,
		Narrative: i.Narrative, ImmediateAction: i.ImmediateAction,
		Sentinel: i.Sentinel, Restricted: i.Restricted,
		Redacted:  i.Restricted && i.Narrative == "",
		State:     incidentStateToWire[i.State],
		Anonymous: i.Anonymous, ReportedBy: i.Reporter(),
		OccurredAt: stamp(i.OccurredAt), ReportedAt: stamp(i.ReportedAt),
		ReviewedBy: i.ReviewedBy, ReviewedAt: stamp(i.ReviewedAt),
		ClosedBy: i.ClosedBy, ClosedAt: stamp(i.ClosedAt),
		ClosureReason: i.ClosureReason, Version: i.Version,
	}
}

func factorsToProto(in []domain.ContributingFactor) []*qualityv1.ContributingFactor {
	out := make([]*qualityv1.ContributingFactor, 0, len(in))
	for _, factor := range in {
		out = append(out, &qualityv1.ContributingFactor{
			Category: factorToWire[factor.Category],
			Detail:   factor.Detail, Root: factor.Root,
		})
	}
	return out
}

func rcaToProto(r domain.RCA) *qualityv1.RootCauseAnalysis {
	return &qualityv1.RootCauseAnalysis{
		RcaId: r.ID, IncidentId: r.IncidentID, Method: r.Method,
		AccountableOwner: r.AccountableOwner,
		Factors:          factorsToProto(r.Factors),
		Findings:         r.Findings, NoActionReason: r.NoActionReason,
		State: reviewStateToWire[r.State], Restricted: r.Restricted,
		OpenedAt: stamp(r.OpenedAt), OpenedBy: r.OpenedBy,
		ClosedAt: stamp(r.ClosedAt), ClosedBy: r.ClosedBy,
		Version: r.Version,
	}
}

func actionToProto(c domain.CAPA) *qualityv1.CorrectiveAction {
	checks := make([]*qualityv1.EffectivenessCheck, 0, len(c.Checks))
	for _, check := range c.Checks {
		checks = append(checks, &qualityv1.EffectivenessCheck{
			CheckedAt: stamp(check.CheckedAt), CheckedBy: check.CheckedBy,
			Effective: check.Effective, Evidence: check.Evidence,
		})
	}
	return &qualityv1.CorrectiveAction{
		CapaId: c.ID, Reference: c.Reference,
		Kind:       actionKindToWire[c.Kind],
		SourceKind: sourceToWire[c.SourceKind], SourceId: c.SourceID,
		Action: c.Action, OwnerId: c.OwnerID,
		DueOn:              stamp(c.DueOn),
		EffectivenessDueOn: stamp(c.EffectivenessDueOn),
		State:              actionStateToWire[c.State],
		ApprovedBy:         c.ApprovedBy, ApprovedAt: stamp(c.ApprovedAt),
		Checks:   checks,
		ClosedBy: c.ClosedBy, ClosedAt: stamp(c.ClosedAt),
		ClosureNote: c.ClosureNote, CancelledReason: c.CancelledReason,
		Restricted: c.Restricted,
		RaisedAt:   stamp(c.RaisedAt), RaisedBy: c.RaisedBy,
		Version: c.Version,
	}
}

func documentToProto(d domain.ControlledDocument) *qualityv1.ControlledDocument {
	return &qualityv1.ControlledDocument{
		DocumentId: d.ID, Code: d.Code, Title: d.Title,
		Kind: documentKindToWire[d.Kind], OwnerId: d.OwnerID,
		ReviewMonths: int32(d.ReviewMonths), Department: d.Department,
		Withdrawn: d.Withdrawn, WithdrawnAt: stamp(d.WithdrawnAt),
		CreatedAt: stamp(d.CreatedAt), CreatedBy: d.CreatedBy,
		Version: d.Version,
	}
}

func versionToProto(v domain.DocumentVersion) *qualityv1.DocumentVersion {
	return &qualityv1.DocumentVersion{
		VersionId: v.ID, DocumentId: v.DocumentID,
		Label: v.Label, Ordinal: int32(v.Ordinal),
		ContentRef: v.ContentRef, ChangeSummary: v.ChangeSummary,
		State:      versionStateToWire[v.State],
		ApprovedBy: v.ApprovedBy, ApprovedAt: stamp(v.ApprovedAt),
		EffectiveFrom:           stamp(v.EffectiveFrom),
		ObsoleteFrom:            stamp(v.ObsoleteFrom),
		RequiresAcknowledgement: v.RequiresAcknowledgement,
		RequiresRetraining:      v.RequiresRetraining,
		CreatedAt:               stamp(v.CreatedAt), CreatedBy: v.CreatedBy,
		Version: v.Version,
	}
}

func auditToProto(a domain.Audit) *qualityv1.Audit {
	return &qualityv1.Audit{
		AuditId: a.ID, Reference: a.Reference, Title: a.Title,
		Scope: a.Scope, StandardId: a.StandardID,
		AuditorId: a.AuditorID, AuditeeDepartment: a.AuditeeDepartment,
		PlannedFrom: stamp(a.PlannedFrom), PlannedTo: stamp(a.PlannedTo),
		State: auditStateToWire[a.State], Summary: a.Summary,
		CreatedAt: stamp(a.CreatedAt), CreatedBy: a.CreatedBy,
		ClosedAt: stamp(a.ClosedAt), ClosedBy: a.ClosedBy,
		Version: a.Version,
	}
}

func findingToProto(f domain.Finding) *qualityv1.Finding {
	return &qualityv1.Finding{
		FindingId: f.ID, AuditId: f.AuditID, ClauseId: f.ClauseID,
		Severity: severityToWire[f.Severity],
		Detail:   f.Detail, Evidence: f.Evidence, CapaId: f.CAPAID,
		ClosedAt: stamp(f.ClosedAt), ClosedBy: f.ClosedBy,
		ClosureNote: f.ClosureNote,
		RaisedAt:    stamp(f.RaisedAt), RaisedBy: f.RaisedBy,
	}
}

func committeeToProto(c domain.Committee) *qualityv1.Committee {
	return &qualityv1.Committee{
		CommitteeId: c.ID, Code: c.Code, Name: c.Name, Terms: c.Terms,
		QuorumSize: int32(c.QuorumSize), Restricted: c.Restricted,
		Members: c.Members, Active: c.Active,
	}
}

func meetingToProto(m domain.Meeting) *qualityv1.Meeting {
	decisions := make([]*qualityv1.Decision, 0, len(m.Decisions))
	for _, decision := range m.Decisions {
		decisions = append(decisions, &qualityv1.Decision{
			Text: decision.Text, ActionIds: decision.ActionIDs,
		})
	}
	return &qualityv1.Meeting{
		MeetingId: m.ID, CommitteeId: m.CommitteeID,
		ScheduledAt: stamp(m.ScheduledAt), HeldAt: stamp(m.HeldAt),
		Agenda: m.Agenda, Attendees: m.Attendees, Apologies: m.Apologies,
		Minutes: m.Minutes, Decisions: decisions,
		State:      meetingStateToWire[m.State],
		ApprovedBy: m.ApprovedBy, ApprovedAt: stamp(m.ApprovedAt),
		Restricted: m.Restricted, Version: m.Version,
	}
}

func decisionsFromProto(in []*qualityv1.Decision) []domain.Decision {
	out := make([]domain.Decision, 0, len(in))
	for _, decision := range in {
		out = append(out, domain.Decision{
			Text: decision.GetText(), ActionIDs: decision.GetActionIds(),
		})
	}
	return out
}

func evidenceToProto(e domain.Evidence) *qualityv1.Evidence {
	return &qualityv1.Evidence{
		EvidenceId: e.ID, ClauseId: e.ClauseID,
		Kind: evidenceKindToWire[e.Kind], RefId: e.RefID,
		ExternalRef: e.ExternalRef, Description: e.Description,
		AddedAt: stamp(e.AddedAt), AddedBy: e.AddedBy,
		RemovedAt: stamp(e.RemovedAt), RemovedBy: e.RemovedBy,
		RemovedWhy: e.RemovedWhy,
	}
}

func definitionToProto(d domain.KPIDefinition) *qualityv1.IndicatorDefinition {
	return &qualityv1.IndicatorDefinition{
		DefinitionId: d.ID, Code: d.Code, Name: d.Name,
		Revision:  int32(d.Revision),
		Numerator: d.Numerator, Denominator: d.Denominator, Unit: d.Unit,
		TargetPermille: int32(d.TargetPermille),
		Direction:      directionToWire[d.Direction],
		Frequency:      frequencyToWire[d.Frequency],
		OwnerId:        d.OwnerID,
		EffectiveFrom:  stamp(d.EffectiveFrom),
		SupersededAt:   stamp(d.SupersededAt),
	}
}

func valueToProto(v domain.KPIValue) *qualityv1.IndicatorValue {
	return &qualityv1.IndicatorValue{
		ValueId: v.ID, DefinitionId: v.DefinitionID, Code: v.Code,
		Revision:   int32(v.Revision),
		PeriodFrom: stamp(v.PeriodFrom), PeriodTo: stamp(v.PeriodTo),
		Numerator: v.Numerator, Denominator: v.Denominator,
		Permille: int32(v.Permille), Unanswerable: v.Unanswerable,
		SourceNote: v.SourceNote,
		RecordedAt: stamp(v.RecordedAt), RecordedBy: v.RecordedBy,
	}
}

func complaintToProto(c domain.Complaint) *qualityv1.Complaint {
	return &qualityv1.Complaint{
		ComplaintId: c.ID, Reference: c.Reference,
		Kind: complainantToWire[c.Kind], ComplainantRef: c.ComplainantRef,
		PatientId: c.PatientID, EncounterId: c.EncounterID,
		Category: c.Category, Department: c.Department,
		FacilityId: c.FacilityID, Channel: c.Channel, Detail: c.Detail,
		AcknowledgeBy:  stamp(c.AcknowledgeBy),
		AcknowledgedAt: stamp(c.AcknowledgedAt),
		AcknowledgedBy: c.AcknowledgedBy,
		ResolveBy:      stamp(c.ResolveBy),
		State:          complaintStateToWire[c.State],
		Outcome:        outcomeToWire[c.Outcome],
		Resolution:     c.Resolution, ClosureReason: c.ClosureReason,
		Escalated: c.Escalated, EscalatedAt: stamp(c.EscalatedAt),
		ReceivedAt: stamp(c.ReceivedAt), ReceivedBy: c.ReceivedBy,
		ClosedAt: stamp(c.ClosedAt), ClosedBy: c.ClosedBy,
		Version: c.Version,
	}
}

func mortalityToProto(m domain.MortalityReview) *qualityv1.MortalityReview {
	return &qualityv1.MortalityReview{
		ReviewId: m.ID, PatientId: m.PatientID, EncounterId: m.EncounterID,
		DiedAt: stamp(m.DiedAt), CommitteeId: m.CommitteeID,
		MeetingId:      m.MeetingID,
		Classification: deathToWire[m.Classification],
		Findings:       m.Findings, LearningPoints: m.LearningPoints,
		ActionIds: m.CAPAIDs, State: reviewStateToWire[m.State],
		OpenedAt: stamp(m.OpenedAt), OpenedBy: m.OpenedBy,
		CompletedAt: stamp(m.CompletedAt), CompletedBy: m.CompletedBy,
		Version: m.Version,
	}
}

func readinessToProto(r domain.Readiness) *qualityv1.GetReadinessResponse {
	clauses := make([]*qualityv1.ClauseStatus, 0, len(r.Clauses))
	for _, clause := range r.Clauses {
		clauses = append(clauses, &qualityv1.ClauseStatus{
			ClauseId: clause.ClauseID, Reference: clause.Reference,
			Chapter: clause.Chapter, Critical: clause.Critical,
			Verdict:       verdictToWire[clause.Verdict],
			EvidenceCount: int32(clause.EvidenceCount),
			ReviewedAt:    stamp(clause.ReviewedAt),
			ReviewedBy:    clause.ReviewedBy,
			Stale:         clause.Stale, CapaId: clause.CAPAID,
		})
	}
	return &qualityv1.GetReadinessResponse{
		StandardId: r.StandardID, Total: int32(r.Total),
		Met: int32(r.Met), PartiallyMet: int32(r.PartiallyMet),
		NotMet: int32(r.NotMet), NotApplicable: int32(r.NotApplicable),
		Unreviewed:     int32(r.Unreviewed),
		CriticalGaps:   int32(r.CriticalGaps),
		StaleReviews:   int32(r.StaleReviews),
		EvidenceGaps:   int32(r.EvidenceGaps),
		OverdueActions: int32(r.OverdueActions),
		Clauses:        clauses,
	}
}

func dashboardToProto(lines []application.IndicatorLine) []*qualityv1.IndicatorLine {
	out := make([]*qualityv1.IndicatorLine, 0, len(lines))
	for _, line := range lines {
		rendered := &qualityv1.IndicatorLine{
			Definition: definitionToProto(line.Definition),
			Recorded:   line.Recorded,
			MetTarget:  line.MetTarget, Comparable: line.Comparable,
		}
		if line.Recorded {
			rendered.Latest = valueToProto(line.Latest)
		}
		out = append(out, rendered)
	}
	return out
}

// sortGaps orders by person then code, because a map's iteration order is
// random and a list that reorders between two reads of the same document looks
// like a change.
func sortGaps(in []*qualityv1.AcknowledgementGap) {
	sort.Slice(in, func(a, b int) bool {
		if in[a].GetPersonId() != in[b].GetPersonId() {
			return in[a].GetPersonId() < in[b].GetPersonId()
		}
		return in[a].GetCode() < in[b].GetCode()
	})
}
