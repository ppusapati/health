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

func identifiersToProto(in domain.IdentifierSet) []*empiv1.PatientIdentifier {
	out := make([]*empiv1.PatientIdentifier, 0, len(in))
	for _, i := range in {
		msg := &empiv1.PatientIdentifier{
			IdentifierId: i.ID, Type: identifierTypeToProto[i.Type],
			System: i.System, Value: i.Value,
			AssigningAuthority: i.AssigningAuthority,
			Status:             identifierStatusToProto[i.Status],
			Source:             i.Source, Primary: i.Primary, Reason: i.Reason,
		}
		if !i.LinkedAt.IsZero() {
			msg.LinkedAt = timestamppb.New(i.LinkedAt)
		}
		if i.UnlinkedAt != nil {
			msg.UnlinkedAt = timestamppb.New(*i.UnlinkedAt)
		}
		out = append(out, msg)
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
