// Package transport serves healthcare.encounter.v1.EncounterService.
package transport

import (
	"time"

	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/internal/encounter/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var classToProto = map[domain.Class]encounterv1.EncounterClass{
	domain.ClassOutpatient:     encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
	domain.ClassEmergency:      encounterv1.EncounterClass_ENCOUNTER_CLASS_EMERGENCY,
	domain.ClassInpatient:      encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
	domain.ClassDayCare:        encounterv1.EncounterClass_ENCOUNTER_CLASS_DAY_CARE,
	domain.ClassTelemedicine:   encounterv1.EncounterClass_ENCOUNTER_CLASS_TELEMEDICINE,
	domain.ClassHomeCare:       encounterv1.EncounterClass_ENCOUNTER_CLASS_HOME_CARE,
	domain.ClassDiagnosticOnly: encounterv1.EncounterClass_ENCOUNTER_CLASS_DIAGNOSTIC_ONLY,
}

var classFromProto = map[encounterv1.EncounterClass]domain.Class{
	encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT:      domain.ClassOutpatient,
	encounterv1.EncounterClass_ENCOUNTER_CLASS_EMERGENCY:       domain.ClassEmergency,
	encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT:       domain.ClassInpatient,
	encounterv1.EncounterClass_ENCOUNTER_CLASS_DAY_CARE:        domain.ClassDayCare,
	encounterv1.EncounterClass_ENCOUNTER_CLASS_TELEMEDICINE:    domain.ClassTelemedicine,
	encounterv1.EncounterClass_ENCOUNTER_CLASS_HOME_CARE:       domain.ClassHomeCare,
	encounterv1.EncounterClass_ENCOUNTER_CLASS_DIAGNOSTIC_ONLY: domain.ClassDiagnosticOnly,
}

var statusToProto = map[domain.Status]encounterv1.EncounterStatus{
	domain.StatusPlanned:        encounterv1.EncounterStatus_ENCOUNTER_STATUS_PLANNED,
	domain.StatusInProgress:     encounterv1.EncounterStatus_ENCOUNTER_STATUS_IN_PROGRESS,
	domain.StatusOnLeave:        encounterv1.EncounterStatus_ENCOUNTER_STATUS_ON_LEAVE,
	domain.StatusFinished:       encounterv1.EncounterStatus_ENCOUNTER_STATUS_FINISHED,
	domain.StatusClosed:         encounterv1.EncounterStatus_ENCOUNTER_STATUS_CLOSED,
	domain.StatusCancelled:      encounterv1.EncounterStatus_ENCOUNTER_STATUS_CANCELLED,
	domain.StatusEnteredInError: encounterv1.EncounterStatus_ENCOUNTER_STATUS_ENTERED_IN_ERROR,
}

var episodeTypeToProto = map[domain.EpisodeType]encounterv1.EpisodeType{
	domain.EpisodePregnancy:      encounterv1.EpisodeType_EPISODE_TYPE_PREGNANCY,
	domain.EpisodeOncology:       encounterv1.EpisodeType_EPISODE_TYPE_ONCOLOGY,
	domain.EpisodeDialysis:       encounterv1.EpisodeType_EPISODE_TYPE_DIALYSIS,
	domain.EpisodeChronicDisease: encounterv1.EpisodeType_EPISODE_TYPE_CHRONIC_DISEASE,
	domain.EpisodeRehabilitation: encounterv1.EpisodeType_EPISODE_TYPE_REHABILITATION,
	domain.EpisodeSurgicalCare:   encounterv1.EpisodeType_EPISODE_TYPE_SURGICAL_CARE,
	domain.EpisodeOther:          encounterv1.EpisodeType_EPISODE_TYPE_OTHER,
}

var episodeTypeFromProto = map[encounterv1.EpisodeType]domain.EpisodeType{
	encounterv1.EpisodeType_EPISODE_TYPE_PREGNANCY:       domain.EpisodePregnancy,
	encounterv1.EpisodeType_EPISODE_TYPE_ONCOLOGY:        domain.EpisodeOncology,
	encounterv1.EpisodeType_EPISODE_TYPE_DIALYSIS:        domain.EpisodeDialysis,
	encounterv1.EpisodeType_EPISODE_TYPE_CHRONIC_DISEASE: domain.EpisodeChronicDisease,
	encounterv1.EpisodeType_EPISODE_TYPE_REHABILITATION:  domain.EpisodeRehabilitation,
	encounterv1.EpisodeType_EPISODE_TYPE_SURGICAL_CARE:   domain.EpisodeSurgicalCare,
	encounterv1.EpisodeType_EPISODE_TYPE_OTHER:           domain.EpisodeOther,
}

var episodeStatusToProto = map[domain.EpisodeStatus]encounterv1.EpisodeStatus{
	domain.EpisodeActive:    encounterv1.EpisodeStatus_EPISODE_STATUS_ACTIVE,
	domain.EpisodeOnHold:    encounterv1.EpisodeStatus_EPISODE_STATUS_ON_HOLD,
	domain.EpisodeFinished:  encounterv1.EpisodeStatus_EPISODE_STATUS_FINISHED,
	domain.EpisodeCancelled: encounterv1.EpisodeStatus_EPISODE_STATUS_CANCELLED,
}

var episodeStatusFromProto = map[encounterv1.EpisodeStatus]domain.EpisodeStatus{
	encounterv1.EpisodeStatus_EPISODE_STATUS_ACTIVE:    domain.EpisodeActive,
	encounterv1.EpisodeStatus_EPISODE_STATUS_ON_HOLD:   domain.EpisodeOnHold,
	encounterv1.EpisodeStatus_EPISODE_STATUS_FINISHED:  domain.EpisodeFinished,
	encounterv1.EpisodeStatus_EPISODE_STATUS_CANCELLED: domain.EpisodeCancelled,
}

var careTeamRoleToProto = map[domain.CareTeamRole]encounterv1.CareTeamRole{
	domain.RoleAttending:   encounterv1.CareTeamRole_CARE_TEAM_ROLE_ATTENDING,
	domain.RoleConsulting:  encounterv1.CareTeamRole_CARE_TEAM_ROLE_CONSULTING,
	domain.RoleNurse:       encounterv1.CareTeamRole_CARE_TEAM_ROLE_NURSE,
	domain.RoleResident:    encounterv1.CareTeamRole_CARE_TEAM_ROLE_RESIDENT,
	domain.RoleTherapist:   encounterv1.CareTeamRole_CARE_TEAM_ROLE_THERAPIST,
	domain.RolePharmacist:  encounterv1.CareTeamRole_CARE_TEAM_ROLE_PHARMACIST,
	domain.RoleSocialWork:  encounterv1.CareTeamRole_CARE_TEAM_ROLE_SOCIAL_WORK,
	domain.RoleAdmitting:   encounterv1.CareTeamRole_CARE_TEAM_ROLE_ADMITTING,
	domain.RoleDischarging: encounterv1.CareTeamRole_CARE_TEAM_ROLE_DISCHARGING,
}

var careTeamRoleFromProto = map[encounterv1.CareTeamRole]domain.CareTeamRole{
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_ATTENDING:   domain.RoleAttending,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_CONSULTING:  domain.RoleConsulting,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_NURSE:       domain.RoleNurse,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_RESIDENT:    domain.RoleResident,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_THERAPIST:   domain.RoleTherapist,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_PHARMACIST:  domain.RolePharmacist,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_SOCIAL_WORK: domain.RoleSocialWork,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_ADMITTING:   domain.RoleAdmitting,
	encounterv1.CareTeamRole_CARE_TEAM_ROLE_DISCHARGING: domain.RoleDischarging,
}

var certaintyToProto = map[domain.DiagnosisCertainty]encounterv1.DiagnosisCertainty{
	domain.CertaintyProvisional:  encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_PROVISIONAL,
	domain.CertaintyDifferential: encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_DIFFERENTIAL,
	domain.CertaintyFinal:        encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
	domain.CertaintyRuledOut:     encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_RULED_OUT,
}

var certaintyFromProto = map[encounterv1.DiagnosisCertainty]domain.DiagnosisCertainty{
	encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_PROVISIONAL:  domain.CertaintyProvisional,
	encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_DIFFERENTIAL: domain.CertaintyDifferential,
	encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL:        domain.CertaintyFinal,
	encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_RULED_OUT:    domain.CertaintyRuledOut,
}

var rankToProto = map[domain.DiagnosisRank]encounterv1.DiagnosisRank{
	domain.RankPrimary:      encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY,
	domain.RankSecondary:    encounterv1.DiagnosisRank_DIAGNOSIS_RANK_SECONDARY,
	domain.RankComplication: encounterv1.DiagnosisRank_DIAGNOSIS_RANK_COMPLICATION,
	domain.RankComorbidity:  encounterv1.DiagnosisRank_DIAGNOSIS_RANK_COMORBIDITY,
}

var rankFromProto = map[encounterv1.DiagnosisRank]domain.DiagnosisRank{
	encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY:      domain.RankPrimary,
	encounterv1.DiagnosisRank_DIAGNOSIS_RANK_SECONDARY:    domain.RankSecondary,
	encounterv1.DiagnosisRank_DIAGNOSIS_RANK_COMPLICATION: domain.RankComplication,
	encounterv1.DiagnosisRank_DIAGNOSIS_RANK_COMORBIDITY:  domain.RankComorbidity,
}

var entryKindToProto = map[domain.EntryKind]encounterv1.TimelineEntryKind{
	domain.EntryEncounter:   encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_ENCOUNTER,
	domain.EntryDiagnosis:   encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_DIAGNOSIS,
	domain.EntryNote:        encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_NOTE,
	domain.EntryObservation: encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_OBSERVATION,
	domain.EntryMedication:  encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_MEDICATION,
	domain.EntryProcedure:   encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_PROCEDURE,
	domain.EntryOrder:       encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_ORDER,
	domain.EntryDocument:    encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_DOCUMENT,
	domain.EntryImaging:     encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_IMAGING,
	domain.EntryAllergy:     encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_ALLERGY,
}

var entryKindFromProto = map[encounterv1.TimelineEntryKind]domain.EntryKind{
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_ENCOUNTER:   domain.EntryEncounter,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_DIAGNOSIS:   domain.EntryDiagnosis,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_NOTE:        domain.EntryNote,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_OBSERVATION: domain.EntryObservation,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_MEDICATION:  domain.EntryMedication,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_PROCEDURE:   domain.EntryProcedure,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_ORDER:       domain.EntryOrder,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_DOCUMENT:    domain.EntryDocument,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_IMAGING:     domain.EntryImaging,
	encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_ALLERGY:     domain.EntryAllergy,
}

var confidentialityToProto = map[domain.Confidentiality]encounterv1.Confidentiality{
	domain.ConfidentialityNormal:         encounterv1.Confidentiality_CONFIDENTIALITY_NORMAL,
	domain.ConfidentialityRestricted:     encounterv1.Confidentiality_CONFIDENTIALITY_RESTRICTED,
	domain.ConfidentialityVeryRestricted: encounterv1.Confidentiality_CONFIDENTIALITY_VERY_RESTRICTED,
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

func encounterToProto(e *domain.Encounter) *encounterv1.Encounter {
	if e == nil {
		return nil
	}
	out := &encounterv1.Encounter{
		EncounterId: e.ID(), FacilityId: e.FacilityID, OrgUnitId: e.OrgUnitID,
		PatientId: e.PatientID, Class: classToProto[e.Class], VisitType: e.VisitType,
		AttendingProviderId: e.AttendingProviderID,
		AppointmentId:       e.AppointmentID, EpisodeId: e.EpisodeID,
		ReferralId: e.ReferralID, Reason: e.Reason,
		Status:    statusToProto[e.Status],
		StartedAt: timestamp(e.StartedAt), EndedAt: timestamp(e.EndedAt),
		ClosedAt:  timestamp(e.ClosedAt),
		CreatedBy: e.CreatedBy, CreatedAt: timestamp(e.CreatedAt),
		Version: e.Version,
	}
	for _, change := range e.History {
		out.History = append(out.History, &encounterv1.EncounterStatusChange{
			From: statusToProto[change.From], To: statusToProto[change.To],
			At: timestamp(change.At), By: change.By, Reason: change.Reason,
		})
	}
	return out
}

func encountersToProto(in []*domain.Encounter) []*encounterv1.Encounter {
	out := make([]*encounterv1.Encounter, 0, len(in))
	for _, e := range in {
		out = append(out, encounterToProto(e))
	}
	return out
}

func episodeToProto(e *domain.Episode) *encounterv1.Episode {
	if e == nil {
		return nil
	}
	return &encounterv1.Episode{
		EpisodeId: e.ID(), PatientId: e.PatientID, FacilityId: e.FacilityID,
		Type: episodeTypeToProto[e.Type], Label: e.Label,
		CareManagerId: e.CareManagerID, Status: episodeStatusToProto[e.Status],
		StartedAt: timestamp(e.StartedAt), EndedAt: timestamp(e.EndedAt),
		Version: e.Version,
	}
}

func episodesToProto(in []*domain.Episode) []*encounterv1.Episode {
	out := make([]*encounterv1.Episode, 0, len(in))
	for _, e := range in {
		out = append(out, episodeToProto(e))
	}
	return out
}

func careTeamMemberToProto(m domain.CareTeamMember) *encounterv1.CareTeamMember {
	return &encounterv1.CareTeamMember{
		CareTeamId: m.ID, EncounterId: m.EncounterID, SubjectId: m.SubjectID,
		Role:           careTeamRoleToProto[m.Role],
		EffectiveFrom:  timestamp(m.From),
		EffectiveUntil: timestamp(m.Until),
		AssignedBy:     m.AssignedBy,
	}
}

func careTeamToProto(in domain.CareTeam) []*encounterv1.CareTeamMember {
	out := make([]*encounterv1.CareTeamMember, 0, len(in))
	for _, m := range in {
		out = append(out, careTeamMemberToProto(m))
	}
	return out
}

func codingToProto(c domain.Coding) *encounterv1.Coding {
	return &encounterv1.Coding{
		System: c.System, Version: c.Version, Code: c.Code, Display: c.Display,
	}
}

func codingFromProto(c *encounterv1.Coding) domain.Coding {
	if c == nil {
		return domain.Coding{}
	}
	return domain.Coding{
		System: c.GetSystem(), Version: c.GetVersion(),
		Code: c.GetCode(), Display: c.GetDisplay(),
	}
}

func codingsToProto(in []domain.Coding) []*encounterv1.Coding {
	out := make([]*encounterv1.Coding, 0, len(in))
	for _, c := range in {
		out = append(out, codingToProto(c))
	}
	return out
}

func diagnosisToProto(d domain.Diagnosis) *encounterv1.Diagnosis {
	return &encounterv1.Diagnosis{
		DiagnosisId: d.ID, EncounterId: d.EncounterID, PatientId: d.PatientID,
		Code: codingToProto(d.Code), Certainty: certaintyToProto[d.Certainty],
		Rank: rankToProto[d.Rank], Note: d.Note, OnsetAt: timestamp(d.OnsetAt),
		SupersededById: d.SupersededByID, RetractedReason: d.RetractedReason,
		RecordedBy: d.RecordedBy, RecordedAt: timestamp(d.RecordedAt),
	}
}

func diagnosesToProto(in domain.DiagnosisList) []*encounterv1.Diagnosis {
	out := make([]*encounterv1.Diagnosis, 0, len(in))
	for _, d := range in {
		out = append(out, diagnosisToProto(d))
	}
	return out
}

func summaryToProto(s domain.VisitSummary) *encounterv1.VisitSummary {
	return &encounterv1.VisitSummary{
		SummaryId: s.ID, EncounterId: s.EncounterID, PatientId: s.PatientID,
		Version: int32(s.Version), SupersedesId: s.SupersedesID,
		AmendmentReason: s.AmendmentReason, Class: classToProto[s.Class],
		StartedAt: timestamp(s.StartedAt), EndedAt: timestamp(s.EndedAt),
		Diagnoses: codingsToProto(s.Diagnoses), CareTeam: s.CareTeam,
		Narrative: s.Narrative, GeneratedBy: s.GeneratedBy,
		GeneratedAt: timestamp(s.GeneratedAt),
	}
}

func summariesToProto(in []domain.VisitSummary) []*encounterv1.VisitSummary {
	out := make([]*encounterv1.VisitSummary, 0, len(in))
	for _, s := range in {
		out = append(out, summaryToProto(s))
	}
	return out
}

func timelineToProto(in []domain.Entry) []*encounterv1.TimelineEntry {
	out := make([]*encounterv1.TimelineEntry, 0, len(in))
	for _, e := range in {
		out = append(out, &encounterv1.TimelineEntry{
			EntryId: e.ID, Kind: entryKindToProto[e.Kind], At: timestamp(e.At),
			EncounterId: e.EncounterID, Title: e.Title,
			Confidentiality: confidentialityToProto[e.Confidentiality],
			Masked:          e.Masked,
		})
	}
	return out
}

func entryKindsFromProto(in []encounterv1.TimelineEntryKind) []domain.EntryKind {
	out := make([]domain.EntryKind, 0, len(in))
	for _, k := range in {
		if mapped, ok := entryKindFromProto[k]; ok {
			out = append(out, mapped)
		}
	}
	return out
}

func overridesToProto(in []domain.ClosureOverride) []*encounterv1.ClosureOverride {
	out := make([]*encounterv1.ClosureOverride, 0, len(in))
	for _, o := range in {
		missing := make([]string, 0, len(o.Missing))
		for _, item := range o.Missing {
			missing = append(missing, string(item))
		}
		out = append(out, &encounterv1.ClosureOverride{
			OverrideId: o.ID, EncounterId: o.EncounterID, MissingItems: missing,
			Reason: o.Reason, OverriddenBy: o.OverriddenBy,
			OverriddenAt: timestamp(o.OverriddenAt),
		})
	}
	return out
}

func closurePolicyToProto(p domain.ClosurePolicy) []*encounterv1.ClosurePolicyForClass {
	out := make([]*encounterv1.ClosurePolicyForClass, 0, len(p.Required))
	// A stable order, so two reads of an unchanged policy render identically.
	for _, class := range []domain.Class{
		domain.ClassOutpatient, domain.ClassEmergency, domain.ClassInpatient,
		domain.ClassDayCare, domain.ClassTelemedicine, domain.ClassHomeCare,
		domain.ClassDiagnosticOnly,
	} {
		items, configured := p.Required[class]
		if !configured {
			continue
		}
		required := make([]string, 0, len(items))
		for _, item := range items {
			required = append(required, string(item))
		}
		out = append(out, &encounterv1.ClosurePolicyForClass{
			Class: classToProto[class], RequiredItems: required,
			AllowOverride: p.AllowOverride[class],
		})
	}
	return out
}

func closurePolicyFromProto(in []*encounterv1.ClosurePolicyForClass) domain.ClosurePolicy {
	p := domain.ClosurePolicy{
		Required:      map[domain.Class][]domain.DocumentationItem{},
		AllowOverride: map[domain.Class]bool{},
	}
	for _, entry := range in {
		class, known := classFromProto[entry.GetClass()]
		if !known {
			// Left out rather than defaulted. A class this version does not
			// recognise is one whose rules it cannot apply, and silently
			// filing it under "outpatient" would configure the wrong thing.
			continue
		}
		items := make([]domain.DocumentationItem, 0, len(entry.GetRequiredItems()))
		for _, raw := range entry.GetRequiredItems() {
			items = append(items, domain.DocumentationItem(raw))
		}
		p.Required[class] = items
		p.AllowOverride[class] = entry.GetAllowOverride()
	}
	return p
}
