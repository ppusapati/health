package transport

import (
	"time"

	medicationv1 "github.com/ppusapati/health/code/gen/go/healthcare/medication/v1"
	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Translation between the wire contract and the domain.
//
// Written out rather than generated, and in both directions, because the two
// vocabularies are deliberately not the same shape: the wire carries seconds
// where the domain carries durations, and an enum the wire does not know maps
// to the value that stops doses rather than the one that produces them.

func timestamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t.UTC())
}

func fromTimestamp(t *timestamppb.Timestamp) time.Time {
	if t == nil || !t.IsValid() {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

func codingToProto(c domain.Coding) *medicationv1.Coding {
	if c.Empty() {
		return nil
	}
	return &medicationv1.Coding{
		System: c.System, Version: c.Version, Code: c.Code, Display: c.Display,
	}
}

func codingFromProto(c *medicationv1.Coding) domain.Coding {
	if c == nil {
		return domain.Coding{}
	}
	return domain.Coding{
		System: c.GetSystem(), Version: c.GetVersion(),
		Code: c.GetCode(), Display: c.GetDisplay(),
	}
}

func codingsToProto(in []domain.Coding) []*medicationv1.Coding {
	out := make([]*medicationv1.Coding, 0, len(in))
	for _, c := range in {
		if encoded := codingToProto(c); encoded != nil {
			out = append(out, encoded)
		}
	}
	return out
}

func codingsFromProto(in []*medicationv1.Coding) []domain.Coding {
	out := make([]domain.Coding, 0, len(in))
	for _, c := range in {
		out = append(out, codingFromProto(c))
	}
	return out
}

func quantityToProto(q domain.Quantity) *medicationv1.Quantity {
	if q.Zero() {
		return nil
	}
	return &medicationv1.Quantity{Value: q.Value, Unit: q.Unit}
}

func quantityFromProto(q *medicationv1.Quantity) domain.Quantity {
	if q == nil {
		return domain.Quantity{}
	}
	return domain.Quantity{Value: q.GetValue(), Unit: q.GetUnit()}
}

var therapyStatusToProto = map[domain.TherapyStatus]medicationv1.TherapyStatus{
	domain.TherapyDraft:        medicationv1.TherapyStatus_THERAPY_STATUS_DRAFT,
	domain.TherapyActive:       medicationv1.TherapyStatus_THERAPY_STATUS_ACTIVE,
	domain.TherapyHeld:         medicationv1.TherapyStatus_THERAPY_STATUS_HELD,
	domain.TherapyDiscontinued: medicationv1.TherapyStatus_THERAPY_STATUS_DISCONTINUED,
	domain.TherapyCompleted:    medicationv1.TherapyStatus_THERAPY_STATUS_COMPLETED,
}

var stopKindToProto = map[domain.StopConditionKind]medicationv1.StopConditionKind{
	domain.StopAtTime:      medicationv1.StopConditionKind_STOP_CONDITION_KIND_AT_TIME,
	domain.StopAfterDoses:  medicationv1.StopConditionKind_STOP_CONDITION_KIND_AFTER_DOSES,
	domain.StopOnCondition: medicationv1.StopConditionKind_STOP_CONDITION_KIND_ON_CONDITION,
	domain.StopNone:        medicationv1.StopConditionKind_STOP_CONDITION_KIND_NONE,
}

var stopKindFromProto = map[medicationv1.StopConditionKind]domain.StopConditionKind{
	medicationv1.StopConditionKind_STOP_CONDITION_KIND_AT_TIME:      domain.StopAtTime,
	medicationv1.StopConditionKind_STOP_CONDITION_KIND_AFTER_DOSES:  domain.StopAfterDoses,
	medicationv1.StopConditionKind_STOP_CONDITION_KIND_ON_CONDITION: domain.StopOnCondition,
	// Unspecified means a continuing medication with no planned end, which is
	// the only safe reading: treating it as "stops at a time nobody gave" would
	// silently end every course at the zero time.
	medicationv1.StopConditionKind_STOP_CONDITION_KIND_UNSPECIFIED: domain.StopNone,
	medicationv1.StopConditionKind_STOP_CONDITION_KIND_NONE:        domain.StopNone,
}

var severityToProto = map[domain.Severity]medicationv1.Severity{
	domain.SeverityContraindicated: medicationv1.Severity_SEVERITY_CONTRAINDICATED,
	domain.SeveritySevere:          medicationv1.Severity_SEVERITY_SEVERE,
	domain.SeverityModerate:        medicationv1.Severity_SEVERITY_MODERATE,
	domain.SeverityMild:            medicationv1.Severity_SEVERITY_MILD,
	domain.SeverityInformational:   medicationv1.Severity_SEVERITY_INFORMATIONAL,
}

var severityFromProto = map[medicationv1.Severity]domain.Severity{
	medicationv1.Severity_SEVERITY_CONTRAINDICATED: domain.SeverityContraindicated,
	medicationv1.Severity_SEVERITY_SEVERE:          domain.SeveritySevere,
	medicationv1.Severity_SEVERITY_MODERATE:        domain.SeverityModerate,
	medicationv1.Severity_SEVERITY_MILD:            domain.SeverityMild,
	medicationv1.Severity_SEVERITY_INFORMATIONAL:   domain.SeverityInformational,
}

var findingKindToProto = map[domain.FindingKind]medicationv1.FindingKind{
	domain.FindingAllergy:          medicationv1.FindingKind_FINDING_KIND_ALLERGY,
	domain.FindingInteraction:      medicationv1.FindingKind_FINDING_KIND_INTERACTION,
	domain.FindingDuplicateTherapy: medicationv1.FindingKind_FINDING_KIND_DUPLICATE_THERAPY,
	domain.FindingDoseSupport:      medicationv1.FindingKind_FINDING_KIND_DOSE_SUPPORT,
}

var formularyStatusToProto = map[domain.FormularyStatus]medicationv1.FormularyStatus{
	domain.FormularyIncluded:     medicationv1.FormularyStatus_FORMULARY_STATUS_FORMULARY,
	domain.FormularyRestricted:   medicationv1.FormularyStatus_FORMULARY_STATUS_RESTRICTED,
	domain.FormularyNonFormulary: medicationv1.FormularyStatus_FORMULARY_STATUS_NON_FORMULARY,
	domain.FormularyUnknown:      medicationv1.FormularyStatus_FORMULARY_STATUS_UNKNOWN,
}

var formularyStatusFromProto = map[medicationv1.FormularyStatus]domain.FormularyStatus{
	medicationv1.FormularyStatus_FORMULARY_STATUS_FORMULARY:     domain.FormularyIncluded,
	medicationv1.FormularyStatus_FORMULARY_STATUS_RESTRICTED:    domain.FormularyRestricted,
	medicationv1.FormularyStatus_FORMULARY_STATUS_NON_FORMULARY: domain.FormularyNonFormulary,
	medicationv1.FormularyStatus_FORMULARY_STATUS_UNKNOWN:       domain.FormularyUnknown,
}

var dispositionToProto = map[domain.Disposition]medicationv1.Disposition{
	domain.DispositionPending:  medicationv1.Disposition_DISPOSITION_PENDING,
	domain.DispositionContinue: medicationv1.Disposition_DISPOSITION_CONTINUE,
	domain.DispositionStop:     medicationv1.Disposition_DISPOSITION_STOP,
	domain.DispositionChange:   medicationv1.Disposition_DISPOSITION_CHANGE,
	domain.DispositionUnknown:  medicationv1.Disposition_DISPOSITION_UNKNOWN,
}

var dispositionFromProto = map[medicationv1.Disposition]domain.Disposition{
	medicationv1.Disposition_DISPOSITION_PENDING:  domain.DispositionPending,
	medicationv1.Disposition_DISPOSITION_CONTINUE: domain.DispositionContinue,
	medicationv1.Disposition_DISPOSITION_STOP:     domain.DispositionStop,
	medicationv1.Disposition_DISPOSITION_CHANGE:   domain.DispositionChange,
	medicationv1.Disposition_DISPOSITION_UNKNOWN:  domain.DispositionUnknown,
}

var sourceToProto = map[domain.HomeMedicationSource]medicationv1.HomeMedicationSource{
	domain.SourcePatient:       medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_PATIENT,
	domain.SourceCarer:         medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_CARER,
	domain.SourceGPRecord:      medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_GP_RECORD,
	domain.SourcePharmacy:      medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_PHARMACY,
	domain.SourcePreviousStay:  medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_PREVIOUS_STAY,
	domain.SourceMedicationBag: medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_MEDICATION_BAG,
}

var sourceFromProto = map[medicationv1.HomeMedicationSource]domain.HomeMedicationSource{
	medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_PATIENT:        domain.SourcePatient,
	medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_CARER:          domain.SourceCarer,
	medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_GP_RECORD:      domain.SourceGPRecord,
	medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_PHARMACY:       domain.SourcePharmacy,
	medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_PREVIOUS_STAY:  domain.SourcePreviousStay,
	medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_MEDICATION_BAG: domain.SourceMedicationBag,
}

var reconciliationEventFromProto = map[medicationv1.ReconciliationEvent]domain.ReconciliationEvent{
	medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_ADMISSION: domain.ReconcileAdmission,
	medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_TRANSFER:  domain.ReconcileTransfer,
	medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_DISCHARGE: domain.ReconcileDischarge,
}

var reconciliationEventToProto = map[domain.ReconciliationEvent]medicationv1.ReconciliationEvent{
	domain.ReconcileAdmission: medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_ADMISSION,
	domain.ReconcileTransfer:  medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_TRANSFER,
	domain.ReconcileDischarge: medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_DISCHARGE,
}

var substitutionKindFromProto = map[medicationv1.SubstitutionKind]domain.SubstitutionKind{
	medicationv1.SubstitutionKind_SUBSTITUTION_KIND_GENERIC:     domain.SubstitutionGeneric,
	medicationv1.SubstitutionKind_SUBSTITUTION_KIND_THERAPEUTIC: domain.SubstitutionTherapeutic,
	medicationv1.SubstitutionKind_SUBSTITUTION_KIND_FORMULARY:   domain.SubstitutionFormulary,
	medicationv1.SubstitutionKind_SUBSTITUTION_KIND_STOCK:       domain.SubstitutionStock,
}

var substitutionKindToProto = map[domain.SubstitutionKind]medicationv1.SubstitutionKind{
	domain.SubstitutionGeneric:     medicationv1.SubstitutionKind_SUBSTITUTION_KIND_GENERIC,
	domain.SubstitutionTherapeutic: medicationv1.SubstitutionKind_SUBSTITUTION_KIND_THERAPEUTIC,
	domain.SubstitutionFormulary:   medicationv1.SubstitutionKind_SUBSTITUTION_KIND_FORMULARY,
	domain.SubstitutionStock:       medicationv1.SubstitutionKind_SUBSTITUTION_KIND_STOCK,
}

var substitutionStatusToProto = map[domain.SubstitutionStatus]medicationv1.SubstitutionStatus{
	domain.SubstitutionProposed:  medicationv1.SubstitutionStatus_SUBSTITUTION_STATUS_PROPOSED,
	domain.SubstitutionAccepted:  medicationv1.SubstitutionStatus_SUBSTITUTION_STATUS_ACCEPTED,
	domain.SubstitutionRejected:  medicationv1.SubstitutionStatus_SUBSTITUTION_STATUS_REJECTED,
	domain.SubstitutionDispensed: medicationv1.SubstitutionStatus_SUBSTITUTION_STATUS_DISPENSED,
}

var doseScopeFromProto = map[medicationv1.DoseRuleScope]domain.DoseRuleScope{
	medicationv1.DoseRuleScope_DOSE_RULE_SCOPE_RENAL:      domain.ScopeRenal,
	medicationv1.DoseRuleScope_DOSE_RULE_SCOPE_HEPATIC:    domain.ScopeHepatic,
	medicationv1.DoseRuleScope_DOSE_RULE_SCOPE_PAEDIATRIC: domain.ScopePaediatric,
}

var doseScopeToProto = map[domain.DoseRuleScope]medicationv1.DoseRuleScope{
	domain.ScopeRenal:      medicationv1.DoseRuleScope_DOSE_RULE_SCOPE_RENAL,
	domain.ScopeHepatic:    medicationv1.DoseRuleScope_DOSE_RULE_SCOPE_HEPATIC,
	domain.ScopePaediatric: medicationv1.DoseRuleScope_DOSE_RULE_SCOPE_PAEDIATRIC,
}

func timingToProto(t domain.Timing) *medicationv1.Timing {
	days := make([]int32, 0, len(t.DaysOfWeek))
	for _, d := range t.DaysOfWeek {
		days = append(days, int32(d))
	}
	return &medicationv1.Timing{
		FrequencyText:   t.FrequencyText,
		IntervalSeconds: int64(t.Interval / time.Second),
		TimesOfDay:      t.TimesOfDay,
		DaysOfWeek:      days,
		Prn:             t.PRN,
		DurationSeconds: int64(t.Duration / time.Second),
	}
}

func timingFromProto(t *medicationv1.Timing) domain.Timing {
	if t == nil {
		return domain.Timing{}
	}
	days := make([]time.Weekday, 0, len(t.GetDaysOfWeek()))
	for _, d := range t.GetDaysOfWeek() {
		days = append(days, time.Weekday(d))
	}
	out := domain.Timing{
		FrequencyText: t.GetFrequencyText(),
		Interval:      time.Duration(t.GetIntervalSeconds()) * time.Second,
		TimesOfDay:    t.GetTimesOfDay(),
		PRN:           t.GetPrn(),
		Duration:      time.Duration(t.GetDurationSeconds()) * time.Second,
	}
	if len(days) > 0 {
		out.DaysOfWeek = days
	}
	return out
}

func segmentToProto(s domain.DoseSegment) *medicationv1.DoseSegment {
	return &medicationv1.DoseSegment{
		Sequence: int32(s.Sequence),
		Dose:     quantityToProto(s.Dose), FreeTextDose: s.FreeTextDose,
		Timing:   timingToProto(s.Timing),
		StartsAt: timestamp(s.StartsAt), EndsAt: timestamp(s.EndsAt),
		Note: s.Note,
	}
}

func segmentsFromProto(in []*medicationv1.DoseSegment) []domain.DoseSegment {
	out := make([]domain.DoseSegment, 0, len(in))
	for _, s := range in {
		out = append(out, domain.DoseSegment{
			Sequence:     int(s.GetSequence()),
			Dose:         quantityFromProto(s.GetDose()),
			FreeTextDose: s.GetFreeTextDose(),
			Timing:       timingFromProto(s.GetTiming()),
			StartsAt:     fromTimestamp(s.GetStartsAt()),
			EndsAt:       fromTimestamp(s.GetEndsAt()),
			Note:         s.GetNote(),
		})
	}
	return out
}

func prnToProto(c domain.PRNConstraint) *medicationv1.PrnConstraint {
	if c.Indication == "" {
		return nil
	}
	return &medicationv1.PrnConstraint{
		Indication:         c.Indication,
		MinIntervalSeconds: int64(c.MinInterval / time.Second),
		MaxDoses:           int32(c.MaxDoses),
		MaxDoseTotal:       quantityToProto(c.MaxDoseTotal),
		PeriodSeconds:      int64(c.Period / time.Second),
	}
}

func prnFromProto(c *medicationv1.PrnConstraint) domain.PRNConstraint {
	if c == nil {
		return domain.PRNConstraint{}
	}
	return domain.PRNConstraint{
		Indication:   c.GetIndication(),
		MinInterval:  time.Duration(c.GetMinIntervalSeconds()) * time.Second,
		MaxDoses:     int(c.GetMaxDoses()),
		MaxDoseTotal: quantityFromProto(c.GetMaxDoseTotal()),
		Period:       time.Duration(c.GetPeriodSeconds()) * time.Second,
	}
}

func findingToProto(f domain.SafetyFinding) *medicationv1.SafetyFinding {
	out := &medicationv1.SafetyFinding{
		Kind: findingKindToProto[f.Kind], Severity: severityToProto[f.Severity],
		RuleId: f.RuleID, RuleVersion: f.RuleVersion, Summary: f.Summary,
		Subjects: codingsToProto(f.Subjects), Inputs: f.Inputs,
	}
	if f.Override != nil {
		out.Override = &medicationv1.Override{
			By: f.Override.By, At: timestamp(f.Override.At),
			Reason: f.Override.Reason,
		}
	}
	return out
}

func prescriptionToProto(p *domain.Prescription) *medicationv1.Prescription {
	if p == nil {
		return nil
	}

	segments := make([]*medicationv1.DoseSegment, 0, len(p.Segments))
	for _, s := range p.Segments {
		segments = append(segments, segmentToProto(s))
	}
	findings := make([]*medicationv1.SafetyFinding, 0, len(p.Screen.Findings))
	for _, f := range p.Screen.Findings {
		findings = append(findings, findingToProto(f))
	}
	changes := make([]*medicationv1.TherapyChange, 0, len(p.Changes))
	for _, c := range p.Changes {
		changes = append(changes, &medicationv1.TherapyChange{
			FromStatus: therapyStatusToProto[c.From], ToStatus: therapyStatusToProto[c.To],
			EffectiveAt: timestamp(c.EffectiveAt), RecordedAt: timestamp(c.RecordedAt),
			ChangedBy: c.By, Reason: c.Reason,
		})
	}

	out := &medicationv1.Prescription{
		PrescriptionId: p.ID, OrderId: p.OrderID, OrderNumber: p.OrderNumber,
		PatientId: p.PatientID, EncounterId: p.EncounterID, FacilityId: p.FacilityID,
		PrescriberId: p.PrescriberID, EnteredById: p.EnteredByID,
		Ingredient: codingToProto(p.Ingredient), Product: codingToProto(p.Product),
		Route:    p.Route,
		Segments: segments, StartsAt: timestamp(p.StartsAt),
		Stop: &medicationv1.StopCondition{
			Kind: stopKindToProto[p.Stop.Kind], At: timestamp(p.Stop.At),
			Doses: int32(p.Stop.Doses), Text: p.Stop.Text,
		},
		Indication:     p.Indication,
		IndicationCode: codingToProto(p.IndicationCode),
		Instructions:   p.Instructions,
		Prn:            prnToProto(p.PRN),
		TherapyStatus:  therapyStatusToProto[p.Status],
		Changes:        changes,
		EffectiveStop:  timestamp(p.EffectiveStop()),
		Findings:       findings,
		Formulary: &medicationv1.FormularyDecision{
			Status: formularyStatusToProto[p.Formulary.Status],
			Scope:  string(p.Formulary.Scope), ScopeId: p.Formulary.ScopeID,
			Restriction:  p.Formulary.Restriction,
			ApprovalPath: p.Formulary.ApprovalPath,
		},
		// The sentence is composed from the structure here rather than left to
		// the client, so two clients cannot render one prescription differently.
		Description: p.Describe(),
		CreatedAt:   timestamp(p.CreatedAt), UpdatedAt: timestamp(p.UpdatedAt),
		Version: p.Version,
	}
	if p.Verification.Done() {
		out.Verification = &medicationv1.Verification{
			By: p.Verification.By, At: timestamp(p.Verification.At),
			Note: p.Verification.Note,
		}
	}
	return out
}

func prescriptionsToProto(in []*domain.Prescription) []*medicationv1.Prescription {
	out := make([]*medicationv1.Prescription, 0, len(in))
	for _, p := range in {
		out = append(out, prescriptionToProto(p))
	}
	return out
}

func reconciliationToProto(r *domain.Reconciliation) *medicationv1.Reconciliation {
	if r == nil {
		return nil
	}
	items := make([]*medicationv1.ReconciliationItem, 0, len(r.Items))
	for _, item := range r.Items {
		items = append(items, &medicationv1.ReconciliationItem{
			Sequence: int32(item.Sequence), Medication: codingToProto(item.Medication),
			DoseText: item.DoseText, Route: item.Route,
			Source:                  sourceToProto[item.Source],
			Disposition:             dispositionToProto[item.Disposition],
			Rationale:               item.Rationale,
			ResultingPrescriptionId: item.ResultingPrescriptionID,
			DecidedBy:               item.DecidedBy, DecidedAt: timestamp(item.DecidedAt),
		})
	}
	return &medicationv1.Reconciliation{
		ReconciliationId: r.ID, PatientId: r.PatientID, EncounterId: r.EncounterID,
		Event: reconciliationEventToProto[r.Event], Items: items,
		StartedBy: r.StartedBy, StartedAt: timestamp(r.StartedAt),
		CompletedBy: r.CompletedBy, CompletedAt: timestamp(r.CompletedAt),
		Version: r.Version,
	}
}

func reconciliationItemsFromProto(
	in []*medicationv1.ReconciliationItem) []domain.ReconciliationItem {

	out := make([]domain.ReconciliationItem, 0, len(in))
	for _, item := range in {
		out = append(out, domain.ReconciliationItem{
			Medication: codingFromProto(item.GetMedication()),
			DoseText:   item.GetDoseText(), Route: item.GetRoute(),
			Source:      sourceFromProto[item.GetSource()],
			Disposition: dispositionFromProto[item.GetDisposition()],
			Rationale:   item.GetRationale(),
		})
	}
	return out
}

func substitutionToProto(s *domain.Substitution) *medicationv1.Substitution {
	if s == nil {
		return nil
	}
	return &medicationv1.Substitution{
		SubstitutionId: s.ID, PrescriptionId: s.PrescriptionID,
		Prescribed: codingToProto(s.Prescribed), Dispensed: codingToProto(s.Dispensed),
		Kind: substitutionKindToProto[s.Kind], Status: substitutionStatusToProto[s.Status],
		Reason:     s.Reason,
		ProposedBy: s.ProposedBy, ProposedAt: timestamp(s.ProposedAt),
		AuthorizedBy: s.AuthorizedBy, AuthorizedAt: timestamp(s.AuthorizedAt),
		DispensedAt: timestamp(s.DispensedAt),
	}
}

func interactionRuleToProto(r domain.InteractionRule) *medicationv1.InteractionRule {
	return &medicationv1.InteractionRule{
		RuleId: r.ID, Version: r.Version,
		Left: codingToProto(r.Left), Right: codingToProto(r.Right),
		Severity: severityToProto[r.Severity],
		Advice:   r.Advice, Management: r.Management, Active: true,
	}
}

func policyToProto(p ports.Policy) *medicationv1.MedicationPolicy {
	verification := make([]string, 0, len(p.Verification.RequiredForClasses))
	for key, required := range p.Verification.RequiredForClasses {
		if required {
			verification = append(verification, key)
		}
	}
	structured := make([]string, 0, len(p.StructuredDoseClasses))
	for key, required := range p.StructuredDoseClasses {
		if required {
			structured = append(structured, key)
		}
	}
	return &medicationv1.MedicationPolicy{
		MaxOverridable:        severityToProto[p.Override.MaxOverridable],
		VerificationRequired:  p.Verification.Required,
		VerificationClasses:   verification,
		StructuredDoseClasses: structured,
	}
}

func policyFromProto(p *medicationv1.MedicationPolicy) ports.Policy {
	out := ports.DefaultPolicy()
	if p == nil {
		return out
	}
	if severity, ok := severityFromProto[p.GetMaxOverridable()]; ok {
		out.Override = domain.OverridePolicy{MaxOverridable: severity}
	}
	out.Verification = domain.VerificationPolicy{Required: p.GetVerificationRequired()}
	if classes := p.GetVerificationClasses(); len(classes) > 0 {
		out.Verification.RequiredForClasses = make(map[string]bool, len(classes))
		for _, key := range classes {
			out.Verification.RequiredForClasses[key] = true
		}
	}
	if classes := p.GetStructuredDoseClasses(); len(classes) > 0 {
		out.StructuredDoseClasses = make(map[string]bool, len(classes))
		for _, key := range classes {
			out.StructuredDoseClasses[key] = true
		}
	}
	return out
}
