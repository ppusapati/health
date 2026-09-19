// Package transport translates between the medical records contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Reverse maps are built in init() from the forward ones,
// so a value added to one direction cannot be forgotten in the other.
//
// Every default fails in the safe direction. An unrecognised requirement
// stays empty and the domain refuses it rather than defaulting to "present",
// which would quietly stop asking for signatures; an unrecognised
// present-on-admission stays empty rather than becoming "no", which would
// count a community infection as hospital-acquired in every rate computed
// from coded data.
package transport

import (
	"time"

	recordsv1 "github.com/ppusapati/health/code/gen/go/healthcare/records/v1"
	"github.com/ppusapati/health/code/internal/records/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on the
		// wire, and a due date in 1970 is a deficiency every worklist treats
		// as overdue.
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

var requirementFromWire = map[recordsv1.DocumentRequirement]domain.DocumentRequirement{
	recordsv1.DocumentRequirement_DOCUMENT_REQUIREMENT_SIGNED:      domain.RequirementSigned,
	recordsv1.DocumentRequirement_DOCUMENT_REQUIREMENT_PRESENT:     domain.RequirementPresent,
	recordsv1.DocumentRequirement_DOCUMENT_REQUIREMENT_CONDITIONAL: domain.RequirementConditional,
}

var deficiencyKindFromWire = map[recordsv1.DeficiencyKind]domain.DeficiencyKind{
	recordsv1.DeficiencyKind_DEFICIENCY_KIND_MISSING_DOCUMENT:    domain.DeficiencyMissing,
	recordsv1.DeficiencyKind_DEFICIENCY_KIND_UNSIGNED_DOCUMENT:   domain.DeficiencyUnsigned,
	recordsv1.DeficiencyKind_DEFICIENCY_KIND_INCOMPLETE_DOCUMENT: domain.DeficiencyIncomplete,
	recordsv1.DeficiencyKind_DEFICIENCY_KIND_CODING_QUERY:        domain.DeficiencyCoding,
}

var deficiencyStateFromWire = map[recordsv1.DeficiencyState]domain.DeficiencyState{
	recordsv1.DeficiencyState_DEFICIENCY_STATE_OPEN:     domain.DeficiencyOpen,
	recordsv1.DeficiencyState_DEFICIENCY_STATE_RESOLVED: domain.DeficiencyResolved,
	recordsv1.DeficiencyState_DEFICIENCY_STATE_WAIVED:   domain.DeficiencyWaived,
}

var codeRoleFromWire = map[recordsv1.CodeRole]domain.CodeRole{
	recordsv1.CodeRole_CODE_ROLE_PRINCIPAL_DIAGNOSIS: domain.CodePrincipalDiagnosis,
	recordsv1.CodeRole_CODE_ROLE_SECONDARY_DIAGNOSIS: domain.CodeSecondaryDiagnosis,
	recordsv1.CodeRole_CODE_ROLE_PRINCIPAL_PROCEDURE: domain.CodePrincipalProcedure,
	recordsv1.CodeRole_CODE_ROLE_SECONDARY_PROCEDURE: domain.CodeSecondaryProcedure,
	recordsv1.CodeRole_CODE_ROLE_EXTERNAL_CAUSE:      domain.CodeExternalCause,
	recordsv1.CodeRole_CODE_ROLE_MORPHOLOGY:          domain.CodeMorphology,
}

var poaFromWire = map[recordsv1.PresentOnAdmission]domain.PresentOnAdmission{
	recordsv1.PresentOnAdmission_PRESENT_ON_ADMISSION_YES:            domain.POAYes,
	recordsv1.PresentOnAdmission_PRESENT_ON_ADMISSION_NO:             domain.POANo,
	recordsv1.PresentOnAdmission_PRESENT_ON_ADMISSION_UNDETERMINED:   domain.POAUndetermined,
	recordsv1.PresentOnAdmission_PRESENT_ON_ADMISSION_NOT_APPLICABLE: domain.POANotApplicable,
}

var codingStateFromWire = map[recordsv1.CodingState]domain.CodingState{
	recordsv1.CodingState_CODING_STATE_IN_PROGRESS: domain.CodingInProgress,
	recordsv1.CodingState_CODING_STATE_CODED:       domain.CodingCoded,
	recordsv1.CodingState_CODING_STATE_FINAL:       domain.CodingFinal,
	recordsv1.CodingState_CODING_STATE_QUERIED:     domain.CodingQueried,
}

var authorityFromWire = map[recordsv1.AuthorityKind]domain.AuthorityKind{
	recordsv1.AuthorityKind_AUTHORITY_KIND_PATIENT_CONSENT:           domain.AuthorityPatientConsent,
	recordsv1.AuthorityKind_AUTHORITY_KIND_AUTHORISED_REPRESENTATIVE: domain.AuthorityRepresentative,
	recordsv1.AuthorityKind_AUTHORITY_KIND_COURT_ORDER:               domain.AuthorityCourtOrder,
	recordsv1.AuthorityKind_AUTHORITY_KIND_STATUTORY_REQUIREMENT:     domain.AuthorityStatutory,
	recordsv1.AuthorityKind_AUTHORITY_KIND_CONTINUITY_OF_CARE:        domain.AuthorityCareContinuity,
	recordsv1.AuthorityKind_AUTHORITY_KIND_INSURANCE_CLAIM:           domain.AuthorityInsurance,
}

var recipientFromWire = map[recordsv1.RecipientKind]domain.RecipientKind{
	recordsv1.RecipientKind_RECIPIENT_KIND_PATIENT:            domain.RecipientPatient,
	recordsv1.RecipientKind_RECIPIENT_KIND_TREATING_CLINICIAN: domain.RecipientClinician,
	recordsv1.RecipientKind_RECIPIENT_KIND_INSTITUTION:        domain.RecipientInstitution,
	recordsv1.RecipientKind_RECIPIENT_KIND_INSURER:            domain.RecipientInsurer,
	recordsv1.RecipientKind_RECIPIENT_KIND_LEGAL:              domain.RecipientLegal,
	recordsv1.RecipientKind_RECIPIENT_KIND_GOVERNMENT_BODY:    domain.RecipientGovernment,
}

var releaseStateFromWire = map[recordsv1.ReleaseState]domain.ReleaseState{
	recordsv1.ReleaseState_RELEASE_STATE_REQUESTED: domain.ReleaseRequested,
	recordsv1.ReleaseState_RELEASE_STATE_APPROVED:  domain.ReleaseApproved,
	recordsv1.ReleaseState_RELEASE_STATE_ASSEMBLED: domain.ReleaseAssembled,
	recordsv1.ReleaseState_RELEASE_STATE_RELEASED:  domain.ReleaseReleased,
	recordsv1.ReleaseState_RELEASE_STATE_REFUSED:   domain.ReleaseRefused,
}

var disclosureKindFromWire = map[recordsv1.DisclosureKind]domain.DisclosureKind{
	recordsv1.DisclosureKind_DISCLOSURE_KIND_RELEASE: domain.DisclosureRelease,
	recordsv1.DisclosureKind_DISCLOSURE_KIND_EXPORT:  domain.DisclosureExport,
	recordsv1.DisclosureKind_DISCLOSURE_KIND_PRINT:   domain.DisclosurePrint,
}

var anchorFromWire = map[recordsv1.RetentionAnchor]domain.RetentionAnchor{
	recordsv1.RetentionAnchor_RETENTION_ANCHOR_DISCHARGE:    domain.AnchorDischarge,
	recordsv1.RetentionAnchor_RETENTION_ANCHOR_LAST_CONTACT: domain.AnchorLastContact,
	recordsv1.RetentionAnchor_RETENTION_ANCHOR_DEATH:        domain.AnchorDeath,
	recordsv1.RetentionAnchor_RETENTION_ANCHOR_MAJORITY:     domain.AnchorMajority,
	recordsv1.RetentionAnchor_RETENTION_ANCHOR_CREATION:     domain.AnchorCreation,
}

var dispositionKindFromWire = map[recordsv1.DispositionKind]domain.DispositionKind{
	recordsv1.DispositionKind_DISPOSITION_KIND_DESTROY:   domain.DispositionDestroy,
	recordsv1.DispositionKind_DISPOSITION_KIND_ARCHIVE:   domain.DispositionArchive,
	recordsv1.DispositionKind_DISPOSITION_KIND_PERMANENT: domain.DispositionPermanent,
}

var dispositionStateFromWire = map[recordsv1.DispositionState]domain.DispositionState{
	recordsv1.DispositionState_DISPOSITION_STATE_DRAFT:     domain.DispositionDraft,
	recordsv1.DispositionState_DISPOSITION_STATE_APPROVED:  domain.DispositionApproved,
	recordsv1.DispositionState_DISPOSITION_STATE_EXECUTED:  domain.DispositionExecuted,
	recordsv1.DispositionState_DISPOSITION_STATE_CANCELLED: domain.DispositionCancelled,
}

var physicalStateFromWire = map[recordsv1.PhysicalState]domain.PhysicalState{
	recordsv1.PhysicalState_PHYSICAL_STATE_FILED:       domain.PhysicalFiled,
	recordsv1.PhysicalState_PHYSICAL_STATE_CHECKED_OUT: domain.PhysicalOut,
	recordsv1.PhysicalState_PHYSICAL_STATE_ARCHIVED:    domain.PhysicalArchived,
	recordsv1.PhysicalState_PHYSICAL_STATE_MISSING:     domain.PhysicalMissing,
	recordsv1.PhysicalState_PHYSICAL_STATE_DESTROYED:   domain.PhysicalDestroyed,
}

var certificateKindFromWire = map[recordsv1.CertificateKind]domain.CertificateKind{
	recordsv1.CertificateKind_CERTIFICATE_KIND_BIRTH:          domain.CertificateBirth,
	recordsv1.CertificateKind_CERTIFICATE_KIND_DEATH:          domain.CertificateDeath,
	recordsv1.CertificateKind_CERTIFICATE_KIND_STILLBIRTH:     domain.CertificateStillbirth,
	recordsv1.CertificateKind_CERTIFICATE_KIND_MEDICAL:        domain.CertificateMedical,
	recordsv1.CertificateKind_CERTIFICATE_KIND_CAUSE_OF_DEATH: domain.CertificateCauseOfDeath,
}

var certificateStateFromWire = map[recordsv1.CertificateState]domain.CertificateState{
	recordsv1.CertificateState_CERTIFICATE_STATE_ISSUED: domain.CertificateIssued,
	recordsv1.CertificateState_CERTIFICATE_STATE_VOIDED: domain.CertificateVoided,
}

// The reverse tables, built from the forward ones so a value added to one
// direction cannot be forgotten in the other.
var (
	requirementToWire      = map[domain.DocumentRequirement]recordsv1.DocumentRequirement{}
	deficiencyKindToWire   = map[domain.DeficiencyKind]recordsv1.DeficiencyKind{}
	deficiencyStateToWire  = map[domain.DeficiencyState]recordsv1.DeficiencyState{}
	codeRoleToWire         = map[domain.CodeRole]recordsv1.CodeRole{}
	poaToWire              = map[domain.PresentOnAdmission]recordsv1.PresentOnAdmission{}
	codingStateToWire      = map[domain.CodingState]recordsv1.CodingState{}
	authorityToWire        = map[domain.AuthorityKind]recordsv1.AuthorityKind{}
	recipientToWire        = map[domain.RecipientKind]recordsv1.RecipientKind{}
	releaseStateToWire     = map[domain.ReleaseState]recordsv1.ReleaseState{}
	disclosureKindToWire   = map[domain.DisclosureKind]recordsv1.DisclosureKind{}
	anchorToWire           = map[domain.RetentionAnchor]recordsv1.RetentionAnchor{}
	dispositionKindToWire  = map[domain.DispositionKind]recordsv1.DispositionKind{}
	dispositionStateToWire = map[domain.DispositionState]recordsv1.DispositionState{}
	physicalStateToWire    = map[domain.PhysicalState]recordsv1.PhysicalState{}
	certificateKindToWire  = map[domain.CertificateKind]recordsv1.CertificateKind{}
	certificateStateToWire = map[domain.CertificateState]recordsv1.CertificateState{}
)

func init() {
	for wire, value := range requirementFromWire {
		requirementToWire[value] = wire
	}
	for wire, value := range deficiencyKindFromWire {
		deficiencyKindToWire[value] = wire
	}
	for wire, value := range deficiencyStateFromWire {
		deficiencyStateToWire[value] = wire
	}
	for wire, value := range codeRoleFromWire {
		codeRoleToWire[value] = wire
	}
	for wire, value := range poaFromWire {
		poaToWire[value] = wire
	}
	for wire, value := range codingStateFromWire {
		codingStateToWire[value] = wire
	}
	for wire, value := range authorityFromWire {
		authorityToWire[value] = wire
	}
	for wire, value := range recipientFromWire {
		recipientToWire[value] = wire
	}
	for wire, value := range releaseStateFromWire {
		releaseStateToWire[value] = wire
	}
	for wire, value := range disclosureKindFromWire {
		disclosureKindToWire[value] = wire
	}
	for wire, value := range anchorFromWire {
		anchorToWire[value] = wire
	}
	for wire, value := range dispositionKindFromWire {
		dispositionKindToWire[value] = wire
	}
	for wire, value := range dispositionStateFromWire {
		dispositionStateToWire[value] = wire
	}
	for wire, value := range physicalStateFromWire {
		physicalStateToWire[value] = wire
	}
	for wire, value := range certificateKindFromWire {
		certificateKindToWire[value] = wire
	}
	for wire, value := range certificateStateFromWire {
		certificateStateToWire[value] = wire
	}
}

func checklistItemsFromWire(items []*recordsv1.ChecklistItem) []domain.ChecklistItem {
	out := make([]domain.ChecklistItem, 0, len(items))
	for _, item := range items {
		out = append(out, domain.ChecklistItem{
			Kind: item.GetKind(), Label: item.GetLabel(),
			Requirement: requirementFromWire[item.GetRequirement()],
			DueWithin: time.Duration(item.GetDueWithinSeconds()) *
				time.Second,
			ConditionCode: item.GetConditionCode(),
		})
	}
	return out
}

func checklistToWire(c domain.ChartChecklist) *recordsv1.ChartChecklist {
	items := make([]*recordsv1.ChecklistItem, 0, len(c.Items))
	for _, item := range c.Items {
		items = append(items, &recordsv1.ChecklistItem{
			Kind: item.Kind, Label: item.Label,
			Requirement:      requirementToWire[item.Requirement],
			DueWithinSeconds: int64(item.DueWithin / time.Second),
			ConditionCode:    item.ConditionCode,
		})
	}
	return &recordsv1.ChartChecklist{
		ChecklistId: c.ID, Code: c.Code, Name: c.Name,
		Revision: int32(c.Revision), EncounterClass: c.EncounterClass,
		Specialty: c.Specialty, Items: items,
		Approved: c.Approved, ApprovedBy: c.ApprovedBy,
		ApprovedAt: stamp(c.ApprovedAt), EffectiveFrom: stamp(c.EffectiveFrom),
		SupersededAt: stamp(c.SupersededAt), CreatedAt: stamp(c.CreatedAt),
		CreatedBy: c.CreatedBy,
	}
}

func checklistsToWire(list []domain.ChartChecklist) []*recordsv1.ChartChecklist {
	out := make([]*recordsv1.ChartChecklist, 0, len(list))
	for _, c := range list {
		out = append(out, checklistToWire(c))
	}
	return out
}

func deficiencyToWire(d domain.Deficiency) *recordsv1.Deficiency {
	return &recordsv1.Deficiency{
		DeficiencyId: d.ID, PatientId: d.PatientID,
		EncounterId: d.EncounterID, FacilityId: d.FacilityID,
		Kind: deficiencyKindToWire[d.Kind], DocumentKind: d.DocumentKind,
		Label: d.Label, DocumentId: d.DocumentID, Detail: d.Detail,
		OwnerId: d.OwnerID, ChecklistCode: d.ChecklistCode,
		ChecklistRevision: int32(d.ChecklistRevision),
		State:             deficiencyStateToWire[d.State],
		DueBy:             stamp(d.DueBy), RaisedAt: stamp(d.RaisedAt),
		RaisedBy:             d.RaisedBy,
		ResolvedByDocumentId: d.ResolvedByDocumentID,
		ResolvedAt:           stamp(d.ResolvedAt),
		ResolvedBy:           d.ResolvedBy,
		WaivedReason:         d.WaivedReason,
		EscalatedAt:          stamp(d.EscalatedAt),
		Version:              d.Version,
	}
}

func deficienciesToWire(list []domain.Deficiency) []*recordsv1.Deficiency {
	out := make([]*recordsv1.Deficiency, 0, len(list))
	for _, d := range list {
		out = append(out, deficiencyToWire(d))
	}
	return out
}

func codesFromWire(codes []*recordsv1.AssignedCode) []domain.AssignedCode {
	out := make([]domain.AssignedCode, 0, len(codes))
	for _, code := range codes {
		out = append(out, domain.AssignedCode{
			System: code.GetSystem(), Version: code.GetVersion(),
			Code: code.GetCode(), Display: code.GetDisplay(),
			Role:             codeRoleFromWire[code.GetRole()],
			Sequence:         int(code.GetSequence()),
			POA:              poaFromWire[code.GetPresentOnAdmission()],
			SourceDocumentID: code.GetSourceDocumentId(),
		})
	}
	return out
}

func codeToWire(c domain.AssignedCode) *recordsv1.AssignedCode {
	return &recordsv1.AssignedCode{
		System: c.System, Version: c.Version, Code: c.Code,
		Display: c.Display, Role: codeRoleToWire[c.Role],
		Sequence:           int32(c.Sequence),
		PresentOnAdmission: poaToWire[c.POA],
		SourceDocumentId:   c.SourceDocumentID,
	}
}

func episodeToWire(e domain.CodedEpisode) *recordsv1.CodedEpisode {
	revisions := make([]*recordsv1.CodingRevision, 0, len(e.Revisions))
	for _, revision := range e.Revisions {
		codes := make([]*recordsv1.AssignedCode, 0, len(revision.Codes))
		for _, code := range revision.Codes {
			codes = append(codes, codeToWire(code))
		}
		revisions = append(revisions, &recordsv1.CodingRevision{
			Revision: int32(revision.Revision), Codes: codes,
			Reason: revision.Reason, CodedBy: revision.CodedBy,
			CodedAt:    stamp(revision.CodedAt),
			State:      codingStateToWire[revision.State],
			ReviewedBy: revision.ReviewedBy,
			ReviewedAt: stamp(revision.ReviewedAt),
		})
	}
	return &recordsv1.CodedEpisode{
		EpisodeId: e.ID, PatientId: e.PatientID,
		EncounterId: e.EncounterID, FacilityId: e.FacilityID,
		Revisions: revisions, State: codingStateToWire[e.State()],
		CreatedAt: stamp(e.CreatedAt), CreatedBy: e.CreatedBy,
		Version: e.Version,
	}
}

func authorisationFromWire(a *recordsv1.Authorisation) domain.Authorisation {
	if a == nil {
		return domain.Authorisation{}
	}
	return domain.Authorisation{
		Kind: authorityFromWire[a.GetKind()], Reference: a.GetReference(),
		SignedBy: a.GetSignedBy(), SignedAt: timeOf(a.GetSignedAt()),
		ExpiresAt: timeOf(a.GetExpiresAt()),
	}
}

func recipientFrom(r *recordsv1.Recipient) domain.Recipient {
	if r == nil {
		return domain.Recipient{}
	}
	return domain.Recipient{
		Kind: recipientFromWire[r.GetKind()], Name: r.GetName(),
		Reference: r.GetReference(), DeliveryMethod: r.GetDeliveryMethod(),
	}
}

func scopeFromWire(s *recordsv1.ReleaseScope) domain.ReleaseScope {
	if s == nil {
		return domain.ReleaseScope{}
	}
	return domain.ReleaseScope{
		From: timeOf(s.GetFrom()), To: timeOf(s.GetTo()),
		RecordClasses:     s.GetRecordClasses(),
		DocumentKinds:     s.GetDocumentKinds(),
		EncounterIDs:      s.GetEncounterIds(),
		WholeRecord:       s.GetWholeRecord(),
		IncludeRestricted: s.GetIncludeRestricted(),
	}
}

func releaseToWire(r domain.ReleaseRequest) *recordsv1.ReleaseRequest {
	out := &recordsv1.ReleaseRequest{
		ReleaseId: r.ID, Reference: r.Reference, PatientId: r.PatientID,
		Purpose: r.Purpose,
		Authorisation: &recordsv1.Authorisation{
			Kind:      authorityToWire[r.Authorisation.Kind],
			Reference: r.Authorisation.Reference,
			SignedBy:  r.Authorisation.SignedBy,
			SignedAt:  stamp(r.Authorisation.SignedAt),
			ExpiresAt: stamp(r.Authorisation.ExpiresAt),
		},
		Recipient: &recordsv1.Recipient{
			Kind: recipientToWire[r.Recipient.Kind], Name: r.Recipient.Name,
			Reference:      r.Recipient.Reference,
			DeliveryMethod: r.Recipient.DeliveryMethod,
		},
		Scope: &recordsv1.ReleaseScope{
			From: stamp(r.Scope.From), To: stamp(r.Scope.To),
			RecordClasses:     r.Scope.RecordClasses,
			DocumentKinds:     r.Scope.DocumentKinds,
			EncounterIds:      r.Scope.EncounterIDs,
			WholeRecord:       r.Scope.WholeRecord,
			IncludeRestricted: r.Scope.IncludeRestricted,
		},
		State: releaseStateToWire[r.State], RefusalReason: r.RefusalReason,
		RequestedAt: stamp(r.RequestedAt), RequestedBy: r.RequestedBy,
		ApprovedAt: stamp(r.ApprovedAt), ApprovedBy: r.ApprovedBy,
		Version: r.Version,
	}
	if r.Package != nil {
		items := make([]*recordsv1.ReleaseItem, 0, len(r.Package.Items))
		for _, item := range r.Package.Items {
			items = append(items, &recordsv1.ReleaseItem{
				DocumentId: item.DocumentID, EncounterId: item.EncounterID,
				Kind: item.Kind, RecordClass: item.RecordClass,
				OccurredAt: stamp(item.OccurredAt),
				Restricted: item.Restricted, Pages: int32(item.Pages),
			})
		}
		out.Package = &recordsv1.ReleasePackage{
			Items: items, ContentHash: r.Package.ContentHash,
			Pages:       int32(r.Package.Pages),
			AssembledAt: stamp(r.Package.AssembledAt),
			AssembledBy: r.Package.AssembledBy,
			ReleasedAt:  stamp(r.Package.ReleasedAt),
			ReleasedBy:  r.Package.ReleasedBy,
		}
	}
	return out
}

func releasesToWire(list []domain.ReleaseRequest) []*recordsv1.ReleaseRequest {
	out := make([]*recordsv1.ReleaseRequest, 0, len(list))
	for _, r := range list {
		out = append(out, releaseToWire(r))
	}
	return out
}

func disclosureToWire(d domain.Disclosure) *recordsv1.Disclosure {
	return &recordsv1.Disclosure{
		DisclosureId: d.ID, PatientId: d.PatientID,
		Kind: disclosureKindToWire[d.Kind], ReleaseId: d.ReleaseID,
		ActorId: d.ActorID, Purpose: d.Purpose,
		ScopeSummary:       d.ScopeSummary,
		RecipientReference: d.RecipientReference,
		RecipientName:      d.RecipientName,
		Items:              int32(d.Items), Pages: int32(d.Pages),
		OccurredAt: stamp(d.OccurredAt),
	}
}

func retentionRuleToWire(r domain.RetentionRule) *recordsv1.RetentionRule {
	return &recordsv1.RetentionRule{
		RuleId: r.ID, Code: r.Code, Name: r.Name,
		Revision: int32(r.Revision), RecordClass: r.RecordClass,
		Jurisdiction: r.Jurisdiction, Anchor: anchorToWire[r.Anchor],
		RetainYears: int32(r.RetainYears),
		Disposition: dispositionKindToWire[r.Disposition],
		Authority:   r.Authority, Approved: r.Approved,
		ApprovedBy: r.ApprovedBy, ApprovedAt: stamp(r.ApprovedAt),
		EffectiveFrom: stamp(r.EffectiveFrom),
		SupersededAt:  stamp(r.SupersededAt),
		CreatedAt:     stamp(r.CreatedAt), CreatedBy: r.CreatedBy,
	}
}

func candidateToWire(c domain.DispositionCandidate) *recordsv1.DispositionCandidate {
	return &recordsv1.DispositionCandidate{
		RecordId: c.RecordID, PatientId: c.PatientID,
		RecordClass: c.RecordClass, Description: c.Description,
		RuleCode: c.RuleCode, RuleRevision: int32(c.RuleRevision),
		Authority:    c.Authority,
		Disposition:  dispositionKindToWire[c.Disposition],
		AnchorDate:   stamp(c.AnchorDate),
		EligibleFrom: stamp(c.EligibleFrom),
	}
}

func dispositionListToWire(l domain.DispositionList) *recordsv1.DispositionList {
	items := make([]*recordsv1.DispositionCandidate, 0, len(l.Items))
	for _, item := range l.Items {
		items = append(items, candidateToWire(item))
	}
	return &recordsv1.DispositionList{
		ListId: l.ID, Reference: l.Reference,
		Jurisdiction: l.Jurisdiction,
		Disposition:  dispositionKindToWire[l.Disposition],
		Items:        items, State: dispositionStateToWire[l.State],
		PreparedAt: stamp(l.PreparedAt), PreparedBy: l.PreparedBy,
		ApprovedAt: stamp(l.ApprovedAt), ApprovedBy: l.ApprovedBy,
		ExecutedAt: stamp(l.ExecutedAt), ExecutedBy: l.ExecutedBy,
		Certificate: l.Certificate, CancelledReason: l.CancelledReason,
		Version: l.Version,
	}
}

func physicalToWire(p domain.PhysicalRecord) *recordsv1.PhysicalRecord {
	return &recordsv1.PhysicalRecord{
		RecordId: p.ID, Reference: p.Reference, PatientId: p.PatientID,
		Volume: int32(p.Volume), RecordClass: p.RecordClass,
		Jurisdiction: p.Jurisdiction, Description: p.Description,
		State: physicalStateToWire[p.State], HomeLocation: p.HomeLocation,
		CurrentLocation: p.CurrentLocation, Custodian: p.Custodian,
		CheckedOutAt: stamp(p.CheckedOutAt), CheckedOutBy: p.CheckedOutBy,
		DueBackAt: stamp(p.DueBackAt), Purpose: p.Purpose,
		CreatedAt: stamp(p.CreatedAt), CreatedBy: p.CreatedBy,
		Version: p.Version,
	}
}

func certificateFieldsFromWire(
	fields []*recordsv1.CertificateField) []domain.CertificateField {

	out := make([]domain.CertificateField, 0, len(fields))
	for _, field := range fields {
		out = append(out, domain.CertificateField{
			Code: field.GetCode(), Label: field.GetLabel(),
			Required:   field.GetRequired(),
			SourcePath: field.GetSourcePath(),
		})
	}
	return out
}

func certificateFormToWire(f domain.CertificateForm) *recordsv1.CertificateForm {
	fields := make([]*recordsv1.CertificateField, 0, len(f.Fields))
	for _, field := range f.Fields {
		fields = append(fields, &recordsv1.CertificateField{
			Code: field.Code, Label: field.Label,
			Required: field.Required, SourcePath: field.SourcePath,
		})
	}
	return &recordsv1.CertificateForm{
		FormId: f.ID, Code: f.Code, Name: f.Name,
		Revision:     int32(f.Revision),
		Kind:         certificateKindToWire[f.Kind],
		Jurisdiction: f.Jurisdiction, Fields: fields,
		IssuerRole: f.IssuerRole, Approved: f.Approved,
		ApprovedBy: f.ApprovedBy, ApprovedAt: stamp(f.ApprovedAt),
		EffectiveFrom: stamp(f.EffectiveFrom),
		SupersededAt:  stamp(f.SupersededAt),
		CreatedAt:     stamp(f.CreatedAt), CreatedBy: f.CreatedBy,
	}
}

func certificateToWire(c domain.StatutoryCertificate) *recordsv1.StatutoryCertificate {
	versions := make([]*recordsv1.CertificateVersion, 0, len(c.Versions))
	for _, version := range c.Versions {
		versions = append(versions, &recordsv1.CertificateVersion{
			Version: int32(version.Version), Values: version.Values,
			SourceRefs: version.SourceRefs, Reason: version.Reason,
			IssuerId: version.IssuerID, IssuerName: version.IssuerName,
			IssuerRole:   version.IssuerRole,
			IssuedAt:     stamp(version.IssuedAt),
			SerialNumber: version.SerialNumber,
		})
	}
	return &recordsv1.StatutoryCertificate{
		CertificateId: c.ID, Kind: certificateKindToWire[c.Kind],
		FormCode: c.FormCode, FormRevision: int32(c.FormRevision),
		Jurisdiction: c.Jurisdiction, PatientId: c.PatientID,
		EncounterId: c.EncounterID, Versions: versions,
		State: certificateStateToWire[c.State], VoidReason: c.VoidReason,
		VoidedBy: c.VoidedBy, VoidedAt: stamp(c.VoidedAt),
		CreatedAt: stamp(c.CreatedAt), Version: c.Version,
	}
}
