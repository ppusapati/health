// Package transport exposes the patient index over ConnectRPC.
//
// Handlers translate wire messages to and from application inputs and do
// nothing else: no validation beyond shape, no authorization, no masking
// (SRS-API-006). Masking in particular lives in the application layer, because
// a security control that only the transport applies is absent from every
// other caller.
package transport

import (
	"google.golang.org/protobuf/types/known/timestamppb"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/internal/empi/application"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/effective"
)

var sexToProto = map[domain.Sex]empiv1.Sex{
	domain.SexUnknown: empiv1.Sex_SEX_UNKNOWN,
	domain.SexFemale:  empiv1.Sex_SEX_FEMALE,
	domain.SexMale:    empiv1.Sex_SEX_MALE,
	domain.SexOther:   empiv1.Sex_SEX_OTHER,
}

var sexFromProto = map[empiv1.Sex]domain.Sex{
	empiv1.Sex_SEX_UNSPECIFIED: domain.SexUnknown,
	empiv1.Sex_SEX_UNKNOWN:     domain.SexUnknown,
	empiv1.Sex_SEX_FEMALE:      domain.SexFemale,
	empiv1.Sex_SEX_MALE:        domain.SexMale,
	empiv1.Sex_SEX_OTHER:       domain.SexOther,
}

var precisionToProto = map[domain.DatePrecision]empiv1.DatePrecision{
	domain.PrecisionNone:      empiv1.DatePrecision_DATE_PRECISION_UNSPECIFIED,
	domain.PrecisionDay:       empiv1.DatePrecision_DATE_PRECISION_DAY,
	domain.PrecisionMonth:     empiv1.DatePrecision_DATE_PRECISION_MONTH,
	domain.PrecisionYear:      empiv1.DatePrecision_DATE_PRECISION_YEAR,
	domain.PrecisionEstimated: empiv1.DatePrecision_DATE_PRECISION_ESTIMATED,
}

var precisionFromProto = map[empiv1.DatePrecision]domain.DatePrecision{
	empiv1.DatePrecision_DATE_PRECISION_UNSPECIFIED: domain.PrecisionNone,
	empiv1.DatePrecision_DATE_PRECISION_DAY:         domain.PrecisionDay,
	empiv1.DatePrecision_DATE_PRECISION_MONTH:       domain.PrecisionMonth,
	empiv1.DatePrecision_DATE_PRECISION_YEAR:        domain.PrecisionYear,
	empiv1.DatePrecision_DATE_PRECISION_ESTIMATED:   domain.PrecisionEstimated,
}

var statusToProto = map[domain.Status]empiv1.PatientStatus{
	domain.StatusCandidate: empiv1.PatientStatus_PATIENT_STATUS_CANDIDATE,
	domain.StatusActive:    empiv1.PatientStatus_PATIENT_STATUS_ACTIVE,
	domain.StatusMerged:    empiv1.PatientStatus_PATIENT_STATUS_MERGED,
	domain.StatusInactive:  empiv1.PatientStatus_PATIENT_STATUS_INACTIVE,
}

var identifierTypeToProto = map[domain.IdentifierType]empiv1.IdentifierType{
	domain.IdentifierMRN:            empiv1.IdentifierType_IDENTIFIER_TYPE_MRN,
	domain.IdentifierNationalHealth: empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
	domain.IdentifierGovernment:     empiv1.IdentifierType_IDENTIFIER_TYPE_GOVERNMENT,
	domain.IdentifierInsurance:      empiv1.IdentifierType_IDENTIFIER_TYPE_INSURANCE,
	domain.IdentifierExternal:       empiv1.IdentifierType_IDENTIFIER_TYPE_EXTERNAL,
}

var identifierTypeFromProto = map[empiv1.IdentifierType]domain.IdentifierType{
	empiv1.IdentifierType_IDENTIFIER_TYPE_MRN:             domain.IdentifierMRN,
	empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH: domain.IdentifierNationalHealth,
	empiv1.IdentifierType_IDENTIFIER_TYPE_GOVERNMENT:      domain.IdentifierGovernment,
	empiv1.IdentifierType_IDENTIFIER_TYPE_INSURANCE:       domain.IdentifierInsurance,
	empiv1.IdentifierType_IDENTIFIER_TYPE_EXTERNAL:        domain.IdentifierExternal,
}

var identifierStatusToProto = map[domain.IdentifierStatus]empiv1.IdentifierStatus{
	domain.IdentifierActive:     empiv1.IdentifierStatus_IDENTIFIER_STATUS_ACTIVE,
	domain.IdentifierSuperseded: empiv1.IdentifierStatus_IDENTIFIER_STATUS_SUPERSEDED,
	domain.IdentifierRevoked:    empiv1.IdentifierStatus_IDENTIFIER_STATUS_REVOKED,
}

var assuranceToProto = map[domain.IdentifierAssurance]empiv1.IdentifierAssurance{
	domain.AssuranceAsserted: empiv1.IdentifierAssurance_IDENTIFIER_ASSURANCE_ASSERTED,
	domain.AssuranceVerified: empiv1.IdentifierAssurance_IDENTIFIER_ASSURANCE_VERIFIED,
}

var outcomeToProto = map[domain.MatchOutcome]empiv1.MatchOutcome{
	domain.OutcomeDistinct: empiv1.MatchOutcome_MATCH_OUTCOME_DISTINCT,
	domain.OutcomeReview:   empiv1.MatchOutcome_MATCH_OUTCOME_REVIEW,
	domain.OutcomeProbable: empiv1.MatchOutcome_MATCH_OUTCOME_PROBABLE,
	domain.OutcomeConflict: empiv1.MatchOutcome_MATCH_OUTCOME_CONFLICT,
}

func partialDateToProto(b domain.BirthDate) *empiv1.PartialDate {
	if b.IsZero() {
		return nil
	}
	return &empiv1.PartialDate{
		Date:      timestamppb.New(b.Date.UTC()),
		Precision: precisionToProto[b.Precision],
	}
}

func partialDateFromProto(p *empiv1.PartialDate) domain.BirthDate {
	if p == nil || p.GetDate() == nil {
		return domain.BirthDate{}
	}
	return domain.BirthDate{
		Date:      p.GetDate().AsTime().UTC(),
		Precision: precisionFromProto[p.GetPrecision()],
	}
}

func demographicsFromProto(p *empiv1.Demographics) domain.Demographics {
	if p == nil {
		return domain.Demographics{}
	}

	d := domain.Demographics{
		Name: domain.HumanName{
			Family: p.GetName().GetFamily(),
			Given:  p.GetName().GetGiven(),
			Prefix: p.GetName().GetPrefix(),
			Suffix: p.GetName().GetSuffix(),
		},
		BirthDate: partialDateFromProto(p.GetBirthDate()),
		Sex:       sexFromProto[p.GetSex()],
	}
	for _, c := range p.GetPhones() {
		d.Phones = append(d.Phones, domain.ContactPoint{
			System: domain.ContactPhone, Value: c.GetValue(), Use: c.GetUse(),
		})
	}
	for _, c := range p.GetEmails() {
		d.Emails = append(d.Emails, domain.ContactPoint{
			System: domain.ContactEmail, Value: c.GetValue(), Use: c.GetUse(),
		})
	}
	for _, a := range p.GetAddresses() {
		d.Addresses = append(d.Addresses, domain.Address{
			Lines: a.GetLines(), City: a.GetCity(), District: a.GetDistrict(),
			State: a.GetState(), PostalCode: a.GetPostalCode(), Country: a.GetCountry(),
		})
	}
	return d
}

func demographicsToProto(d domain.Demographics) *empiv1.Demographics {
	out := &empiv1.Demographics{
		Name: &empiv1.HumanName{
			Family: d.Name.Family, Given: d.Name.Given,
			Prefix: d.Name.Prefix, Suffix: d.Name.Suffix,
		},
		BirthDate: partialDateToProto(d.BirthDate),
		Sex:       sexToProto[d.Sex],
	}
	for _, c := range d.Phones {
		out.Phones = append(out.Phones, &empiv1.ContactPoint{
			System: empiv1.ContactSystem_CONTACT_SYSTEM_PHONE, Value: c.Value, Use: c.Use,
		})
	}
	for _, c := range d.Emails {
		out.Emails = append(out.Emails, &empiv1.ContactPoint{
			System: empiv1.ContactSystem_CONTACT_SYSTEM_EMAIL, Value: c.Value, Use: c.Use,
		})
	}
	for _, a := range d.Addresses {
		out.Addresses = append(out.Addresses, &empiv1.Address{
			Lines: a.Lines, City: a.City, District: a.District,
			State: a.State, PostalCode: a.PostalCode, Country: a.Country,
		})
	}
	return out
}

func identifiersFromProto(in []*empiv1.PatientIdentifier) []domain.Identifier {
	out := make([]domain.Identifier, 0, len(in))
	for _, i := range in {
		out = append(out, domain.Identifier{
			Type:               identifierTypeFromProto[i.GetType()],
			System:             i.GetSystem(),
			Value:              i.GetValue(),
			AssigningAuthority: i.GetAssigningAuthority(),
			Source:             i.GetSource(),
		})
	}
	return out
}

// identifierToProto returns nil for the zero identifier, so an absent one is
// an unset field rather than an empty message.
func identifierToProto(i domain.Identifier) *empiv1.PatientIdentifier {
	if i.ID == "" {
		return nil
	}
	msg := &empiv1.PatientIdentifier{
		IdentifierId: i.ID, Type: identifierTypeToProto[i.Type],
		System: i.System, Value: i.Value,
		AssigningAuthority: i.AssigningAuthority,
		Status:             identifierStatusToProto[i.Status],
		Source:             i.Source, Primary: i.Primary, Reason: i.Reason,
		Assurance: assuranceToProto[i.Assurance],
	}
	if !i.LinkedAt.IsZero() {
		msg.LinkedAt = timestamppb.New(i.LinkedAt)
	}
	if i.UnlinkedAt != nil {
		msg.UnlinkedAt = timestamppb.New(*i.UnlinkedAt)
	}
	if i.VerifiedAt != nil {
		msg.VerifiedAt = timestamppb.New(*i.VerifiedAt)
	}
	return msg
}

func identifiersToProto(in domain.IdentifierSet) []*empiv1.PatientIdentifier {
	out := make([]*empiv1.PatientIdentifier, 0, len(in))
	for _, i := range in {
		out = append(out, identifierToProto(i))
	}
	return out
}

func patientToProto(p *domain.Patient, identifiers domain.IdentifierSet) *empiv1.Patient {
	if p == nil {
		return nil
	}
	out := &empiv1.Patient{
		PatientId:                p.ID(),
		RegisteredFacilityId:     p.RegisteredFacilityID,
		Status:                   statusToProto[p.Status],
		Demographics:             demographicsToProto(p.Demographics),
		Identifiers:              identifiersToProto(identifiers),
		MergedIntoPatientId:      p.MergedIntoPatientID,
		CreatedAt:                timestamppb.New(p.CreatedAt),
		UpdatedAt:                timestamppb.New(p.UpdatedAt),
		Version:                  p.Version,
		AcceptsRoutineScheduling: p.AcceptsRoutineScheduling(),
	}
	if p.Deceased != nil {
		out.Deceased = &empiv1.DeceasedRecord{
			Source:     p.Deceased.Source,
			RecordedBy: p.Deceased.RecordedBy,
		}
		if !p.Deceased.Date.IsZero() {
			out.Deceased.Date = &empiv1.PartialDate{
				Date:      timestamppb.New(p.Deceased.Date),
				Precision: precisionToProto[p.Deceased.Precision],
			}
		}
		if !p.Deceased.RecordedAt.IsZero() {
			out.Deceased.RecordedAt = timestamppb.New(p.Deceased.RecordedAt)
		}
	}
	return out
}

func matchToProto(m application.MatchedPatient) *empiv1.PatientMatch {
	out := &empiv1.PatientMatch{
		Patient:    patientToProto(m.Patient, m.Identifiers),
		Confidence: m.Match.Score,
		Outcome:    outcomeToProto[m.Match.Outcome],
		Masked:     m.Masked,
		// Unset unless the search reached this patient through a name they no
		// longer hold, so a client can present the row with the reason it is
		// there rather than as an unexplained low-scoring hit.
		MatchedFormerName: nameToProto(m.MatchedFormerName),
	}
	for _, f := range m.Match.Fields {
		out.Fields = append(out.Fields, &empiv1.MatchFieldScore{
			Field: string(f.Field), Similarity: f.Similarity,
			Weight: f.Weight, Note: f.Note,
		})
	}
	return out
}

func matchesToProto(in []application.MatchedPatient) []*empiv1.PatientMatch {
	out := make([]*empiv1.PatientMatch, 0, len(in))
	for _, m := range in {
		out = append(out, matchToProto(m))
	}
	return out
}

var reviewStatusToProto = map[domain.ReviewStatus]empiv1.ReviewStatus{
	domain.ReviewOpen:      empiv1.ReviewStatus_REVIEW_STATUS_OPEN,
	domain.ReviewMerged:    empiv1.ReviewStatus_REVIEW_STATUS_MERGED,
	domain.ReviewDismissed: empiv1.ReviewStatus_REVIEW_STATUS_DISMISSED,
}

func candidatesToProto(in []domain.DuplicateCandidate) []*empiv1.DuplicateCandidate {
	out := make([]*empiv1.DuplicateCandidate, 0, len(in))
	for _, c := range in {
		msg := &empiv1.DuplicateCandidate{
			CandidateId: c.ID,
			PatientAId:  c.PatientAID,
			PatientBId:  c.PatientBID,
			Score:       c.Score,
			Outcome:     outcomeToProto[c.Outcome],
			Status:      reviewStatusToProto[c.Status],
			DetectedBy:  c.DetectedBy,
			DetectedAt:  timestamppb.New(c.DetectedAt),
			ReviewedBy:  c.ReviewedBy,
			Resolution:  c.Resolution,
		}
		if c.ReviewedAt != nil {
			msg.ReviewedAt = timestamppb.New(*c.ReviewedAt)
		}
		out = append(out, msg)
	}
	return out
}

// Effective-dated history mappings (SRS-EMPI-007/009).

var nameKindToProto = map[domain.NameKind]empiv1.NameKind{
	domain.NameLegal:     empiv1.NameKind_NAME_KIND_LEGAL,
	domain.NamePreferred: empiv1.NameKind_NAME_KIND_PREFERRED,
	domain.NameAlias:     empiv1.NameKind_NAME_KIND_ALIAS,
}

var nameKindFromProto = map[empiv1.NameKind]domain.NameKind{
	empiv1.NameKind_NAME_KIND_UNSPECIFIED: domain.NameLegal,
	empiv1.NameKind_NAME_KIND_LEGAL:       domain.NameLegal,
	empiv1.NameKind_NAME_KIND_PREFERRED:   domain.NamePreferred,
	empiv1.NameKind_NAME_KIND_ALIAS:       domain.NameAlias,
}

var channelToProto = map[domain.CommunicationChannel]empiv1.CommunicationChannel{
	domain.ChannelSMS:   empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_SMS,
	domain.ChannelEmail: empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_EMAIL,
	domain.ChannelPhone: empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_PHONE,
	domain.ChannelPost:  empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_POST,
}

var channelFromProto = map[empiv1.CommunicationChannel]domain.CommunicationChannel{
	empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_SMS:   domain.ChannelSMS,
	empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_EMAIL: domain.ChannelEmail,
	empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_PHONE: domain.ChannelPhone,
	empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_POST:  domain.ChannelPost,
}

var communicationPurposeToProto = map[domain.CommunicationPurpose]empiv1.CommunicationPurpose{
	domain.PurposeAppointmentReminder: empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER,
	domain.PurposeResults:             empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_RESULTS,
	domain.PurposeBilling:             empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_BILLING,
	domain.PurposeHealthPromotion:     empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_HEALTH_PROMOTION,
}

var communicationPurposeFromProto = map[empiv1.CommunicationPurpose]domain.CommunicationPurpose{
	empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER: domain.PurposeAppointmentReminder,
	empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_RESULTS:              domain.PurposeResults,
	empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_BILLING:              domain.PurposeBilling,
	empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_HEALTH_PROMOTION:     domain.PurposeHealthPromotion,
}

var relationshipToProto = map[domain.RelationshipType]empiv1.RelationshipType{
	domain.RelationshipParent:           empiv1.RelationshipType_RELATIONSHIP_TYPE_PARENT,
	domain.RelationshipGuardian:         empiv1.RelationshipType_RELATIONSHIP_TYPE_GUARDIAN,
	domain.RelationshipSpouse:           empiv1.RelationshipType_RELATIONSHIP_TYPE_SPOUSE,
	domain.RelationshipChild:            empiv1.RelationshipType_RELATIONSHIP_TYPE_CHILD,
	domain.RelationshipSibling:          empiv1.RelationshipType_RELATIONSHIP_TYPE_SIBLING,
	domain.RelationshipCaregiver:        empiv1.RelationshipType_RELATIONSHIP_TYPE_CAREGIVER,
	domain.RelationshipEmergencyContact: empiv1.RelationshipType_RELATIONSHIP_TYPE_EMERGENCY_CONTACT,
}

var relationshipFromProto = map[empiv1.RelationshipType]domain.RelationshipType{
	empiv1.RelationshipType_RELATIONSHIP_TYPE_PARENT:            domain.RelationshipParent,
	empiv1.RelationshipType_RELATIONSHIP_TYPE_GUARDIAN:          domain.RelationshipGuardian,
	empiv1.RelationshipType_RELATIONSHIP_TYPE_SPOUSE:            domain.RelationshipSpouse,
	empiv1.RelationshipType_RELATIONSHIP_TYPE_CHILD:             domain.RelationshipChild,
	empiv1.RelationshipType_RELATIONSHIP_TYPE_SIBLING:           domain.RelationshipSibling,
	empiv1.RelationshipType_RELATIONSHIP_TYPE_CAREGIVER:         domain.RelationshipCaregiver,
	empiv1.RelationshipType_RELATIONSHIP_TYPE_EMERGENCY_CONTACT: domain.RelationshipEmergencyContact,
}

var authorityToProto = map[domain.Authority]empiv1.Authority{
	domain.AuthorityViewDemographics: empiv1.Authority_AUTHORITY_VIEW_DEMOGRAPHICS,
	domain.AuthorityBookAppointments: empiv1.Authority_AUTHORITY_BOOK_APPOINTMENTS,
	domain.AuthorityViewClinical:     empiv1.Authority_AUTHORITY_VIEW_CLINICAL,
	domain.AuthorityReceiveResults:   empiv1.Authority_AUTHORITY_RECEIVE_RESULTS,
	domain.AuthorityConsent:          empiv1.Authority_AUTHORITY_CONSENT,
}

var authorityFromProto = map[empiv1.Authority]domain.Authority{
	empiv1.Authority_AUTHORITY_VIEW_DEMOGRAPHICS: domain.AuthorityViewDemographics,
	empiv1.Authority_AUTHORITY_BOOK_APPOINTMENTS: domain.AuthorityBookAppointments,
	empiv1.Authority_AUTHORITY_VIEW_CLINICAL:     domain.AuthorityViewClinical,
	empiv1.Authority_AUTHORITY_RECEIVE_RESULTS:   domain.AuthorityReceiveResults,
	empiv1.Authority_AUTHORITY_CONSENT:           domain.AuthorityConsent,
}

func windowToProto(w effective.Window) *empiv1.EffectiveWindow {
	out := &empiv1.EffectiveWindow{From: timestamppb.New(w.From)}
	if !w.OpenEnded() {
		out.Until = timestamppb.New(w.Until)
	}
	return out
}

// nameToProto returns nil for the zero name, so an absent former name is an
// unset field rather than an empty message the client has to recognise.
func nameToProto(n domain.PatientName) *empiv1.PatientName {
	if n.ID == "" {
		return nil
	}
	return &empiv1.PatientName{
		NameId: n.ID, Kind: nameKindToProto[n.Kind],
		Name: &empiv1.HumanName{
			Family: n.Name.Family, Given: n.Name.Given,
			Prefix: n.Name.Prefix, Suffix: n.Name.Suffix,
		},
		Window:     windowToProto(n.Window),
		RecordedBy: n.RecordedBy, RecordedAt: timestamppb.New(n.RecordedAt),
		Source: n.Source,
	}
}

func namesToProto(in domain.NameHistory) []*empiv1.PatientName {
	out := make([]*empiv1.PatientName, 0, len(in))
	for _, n := range in {
		out = append(out, nameToProto(n))
	}
	return out
}

func preferencesToProto(in domain.PreferenceSet) []*empiv1.CommunicationPreference {
	out := make([]*empiv1.CommunicationPreference, 0, len(in))
	for _, p := range in {
		out = append(out, &empiv1.CommunicationPreference{
			PreferenceId: p.ID,
			Channel:      channelToProto[p.Channel],
			Purpose:      communicationPurposeToProto[p.Purpose],
			Allowed:      p.Allowed,
			Window:       windowToProto(p.Window),
			RecordedBy:   p.RecordedBy,
		})
	}
	return out
}

func relatedToProto(in domain.RelatedPersonSet) []*empiv1.RelatedPerson {
	out := make([]*empiv1.RelatedPerson, 0, len(in))
	for _, r := range in {
		out = append(out, relatedPersonToProto(r))
	}
	return out
}

func relatedPersonToProto(r domain.RelatedPerson) *empiv1.RelatedPerson {
	msg := &empiv1.RelatedPerson{
		RelationshipId:   r.ID,
		RelatedPatientId: r.RelatedPatientID,
		Name: &empiv1.HumanName{
			Family: r.Name.Family, Given: r.Name.Given,
			Prefix: r.Name.Prefix, Suffix: r.Name.Suffix,
		},
		Relationship:     relationshipToProto[r.Relationship],
		Window:           windowToProto(r.Window),
		VerifiedBy:       r.VerifiedBy,
		VerificationNote: r.VerificationNote,
		RecordedBy:       r.RecordedBy,
	}
	for _, c := range r.Contact {
		msg.Contact = append(msg.Contact, &empiv1.ContactPoint{
			System: empiv1.ContactSystem_CONTACT_SYSTEM_PHONE, Value: c.Value, Use: c.Use,
		})
	}
	msg.Authorities = authoritiesToProto(r.Authorities)
	if r.VerifiedAt != nil {
		msg.VerifiedAt = timestamppb.New(*r.VerifiedAt)
	}
	return msg
}

func authoritiesToProto(in []domain.Authority) []empiv1.Authority {
	out := make([]empiv1.Authority, 0, len(in))
	for _, a := range in {
		out = append(out, authorityToProto[a])
	}
	return out
}

func authoritiesFromProto(in []empiv1.Authority) []domain.Authority {
	out := make([]domain.Authority, 0, len(in))
	for _, a := range in {
		// An unrecognised authority is dropped rather than mapped to a
		// default: silently granting "view_demographics" because a client sent
		// an enum this build does not know would widen access on a version
		// skew. The domain refuses an empty grant where one was intended.
		if mapped, ok := authorityFromProto[a]; ok {
			out = append(out, mapped)
		}
	}
	return out
}

func contactsFromProto(in []*empiv1.ContactPoint) []domain.ContactPoint {
	out := make([]domain.ContactPoint, 0, len(in))
	for _, c := range in {
		out = append(out, domain.ContactPoint{
			System: domain.ContactPhone, Value: c.GetValue(), Use: c.GetUse(),
		})
	}
	return out
}

func humanNameFromProto(n *empiv1.HumanName) domain.HumanName {
	if n == nil {
		return domain.HumanName{}
	}
	return domain.HumanName{
		Family: n.GetFamily(), Given: n.GetGiven(),
		Prefix: n.GetPrefix(), Suffix: n.GetSuffix(),
	}
}
