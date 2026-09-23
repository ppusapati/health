package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// OpenCaseInput records a body arriving (SRS-MORT-001).
type OpenCaseInput struct {
	Reference          string
	Source             string
	EncounterID        string
	PatientID          string
	ExternalSource     string
	Identity           string
	IdentificationNote string
	DisplayName        string
	MedicoLegal        bool
	MLCReference       string
	Restricted         bool
	DiedAt             time.Time
	FacilityID         string
	// ReceivedFrom is the ward, the ambulance or the police who brought
	// the body. It opens the chain of custody.
	ReceivedFrom string
}

// OpenCase records a body arriving in the mortuary's care (SRS-MORT-001).
//
// The chain of custody opens here, in the same transaction: a case whose
// chain starts at the second event is a case with a gap at the beginning,
// which is the end somebody asks about.
func (s *Service) OpenCase(ctx context.Context, in OpenCaseInput) (
	domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermCaseManage)
	if err != nil {
		return domain.Case{}, err
	}
	now := s.clock.Now()

	var out domain.Case
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.checkEncounter(ctx, scope,
			in.EncounterID); err != nil {
			return err
		}
		if err := s.checkPatient(ctx, scope, in.PatientID); err != nil {
			return err
		}

		opened, err := domain.OpenCase(s.ids.NewID(), session.TenantID,
			domain.NewCaseInput{
				Reference:   in.Reference,
				Source:      domain.Source(in.Source),
				EncounterID: in.EncounterID, PatientID: in.PatientID,
				ExternalSource:     in.ExternalSource,
				Identity:           domain.Identity(in.Identity),
				IdentificationNote: in.IdentificationNote,
				DisplayName:        in.DisplayName,
				MedicoLegal:        in.MedicoLegal,
				MLCReference:       in.MLCReference,
				Restricted:         in.Restricted,
				DiedAt:             in.DiedAt,
				FacilityID:         in.FacilityID,
			}, session.SubjectID, now)
		if err != nil {
			return mortuaryError(err)
		}
		if err := s.cases.InsertCase(ctx, scope, opened); err != nil {
			return err
		}
		out = opened

		if err := s.appendCustody(ctx, scope, opened.ID, "received",
			"body received into the mortuary", in.ReceivedFrom,
			session.SubjectID, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "mortuary.case.opened", ResourceType: "mortuary.case",
			ResourceID: opened.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"source":       string(opened.Source),
				"identity":     string(opened.Identity),
				"medico_legal": boolText(opened.MedicoLegal),
			}),
		}, now); err != nil {
			return err
		}
		// Identifiers and states. Never the name and never the cause: a
		// mortuary event naming a person is a death notice on a message
		// bus.
		return s.appendEvent(ctx, session, EventCaseOpened,
			"mortuary.case", opened.ID, map[string]any{
				"source":       string(opened.Source),
				"identity":     string(opened.Identity),
				"medico_legal": opened.MedicoLegal,
			}, now)
	})
	if err != nil {
		return domain.Case{}, err
	}
	return out, nil
}

// IdentifyInput records somebody naming the body (SRS-MORT-002).
type IdentifyInput struct {
	CaseID   string
	Identity string
	Name     string
	Note     string
	Version  int64
}

// Identify records an identification (SRS-MORT-002, SRS-MORT-006).
func (s *Service) Identify(ctx context.Context, in IdentifyInput) (
	domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermCaseManage)
	if err != nil {
		return domain.Case{}, err
	}
	now := s.clock.Now()

	var out domain.Case
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		before := found.Identity
		if err := found.Identify(domain.Identity(in.Identity), in.Name,
			in.Note, session.SubjectID, now); err != nil {
			return mortuaryError(err)
		}
		if err := s.cases.UpdateCase(ctx, scope, found,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		found.Version = in.Version + 1
		out = found

		if err := s.appendCustody(ctx, scope, found.ID, "identified",
			"identity recorded as "+string(found.Identity), "", "",
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.case.identified",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Note,
			Context: auditContext(map[string]string{
				"from": string(before), "to": string(found.Identity),
			}),
		}, now); err != nil {
			return err
		}
		if !found.Identity.Positive() {
			return nil
		}
		return s.appendEvent(ctx, session, EventBodyIdentified,
			"mortuary.case", found.ID, map[string]any{
				"identity": string(found.Identity),
			}, now)
	})
	if err != nil {
		return domain.Case{}, err
	}
	return out, nil
}

// RecordCauseInput records what the person died of (SRS-MORT-003).
type RecordCauseInput struct {
	CaseID  string
	Summary string
	Version int64
}

// RecordCause records the cause of death (SRS-MORT-003).
//
// Its own permission and its own audit line. The cause is the most sensitive
// thing this context holds, and writing it is an act a coroner's officer or a
// certifying doctor performs — not something that arrives with the body.
func (s *Service) RecordCause(ctx context.Context, in RecordCauseInput) (
	domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermCauseRecord)
	if err != nil {
		return domain.Case{}, err
	}
	now := s.clock.Now()

	var out domain.Case
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		if err := found.RecordCause(in.Summary,
			session.SubjectID); err != nil {
			return mortuaryError(err)
		}
		if err := s.cases.UpdateCase(ctx, scope, found,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		found.Version = in.Version + 1
		out = found
		// The audit line records that a cause was written and never what
		// it says: an audit trail that quoted it would be a second copy
		// of the most sensitive field, under weaker controls.
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.case.cause_recorded",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.Case{}, err
	}
	return out, nil
}

// RecordCertificateInput attaches the death certificate (SRS-MORT-006).
type RecordCertificateInput struct {
	CaseID    string
	Reference string
	Version   int64
}

// RecordCertificate attaches the certificate or registration reference
// (SRS-MORT-006).
func (s *Service) RecordCertificate(ctx context.Context,
	in RecordCertificateInput) (domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermCaseManage)
	if err != nil {
		return domain.Case{}, err
	}
	now := s.clock.Now()

	var out domain.Case
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		if err := found.RecordDeathCertificate(in.Reference,
			session.SubjectID, now); err != nil {
			return mortuaryError(err)
		}
		if err := s.cases.UpdateCase(ctx, scope, found,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		found.Version = in.Version + 1
		out = found
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.case.certificate_recorded",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.Case{}, err
	}
	return out, nil
}

// MarkMedicoLegalInput brings a case under an authority's interest
// (SRS-MORT-005, SRS-MORT-007).
type MarkMedicoLegalInput struct {
	CaseID    string
	Reference string
	Version   int64
}

// MarkMedicoLegal marks a case an authority has an interest in.
//
// There is no use case that clears it: see the note on the domain method.
func (s *Service) MarkMedicoLegal(ctx context.Context,
	in MarkMedicoLegalInput) (domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermCaseManage)
	if err != nil {
		return domain.Case{}, err
	}
	now := s.clock.Now()

	var out domain.Case
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		if err := found.MarkMedicoLegal(in.Reference,
			session.SubjectID); err != nil {
			return mortuaryError(err)
		}
		if err := s.cases.UpdateCase(ctx, scope, found,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		found.Version = in.Version + 1
		out = found

		if err := s.appendCustody(ctx, scope, found.ID, "marked",
			"case marked medico-legal", "", "", session.SubjectID,
			now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.case.medico_legal",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.Case{}, err
	}
	return out, nil
}

// Case reads one case, redacted unless the caller may read the sensitive
// detail (SRS-MORT-003).
//
// A read of the sensitive detail is audited every time, which is what
// SRS-MORT-003's "unauthorized reads are denied and audited" needs on the
// other side: the authorised ones are recorded too, or the trail only shows
// the attempts that failed.
func (s *Service) Case(ctx context.Context, id string) (domain.Case, error) {
	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Case{}, err
	}
	sensitive := session.HasPermission(PermSensitiveRead)

	found, err := s.cases.Case(ctx, scope, id)
	if err != nil {
		return domain.Case{}, err
	}
	if !sensitive || found.CauseSummary == "" {
		return redact(found, sensitive), nil
	}

	now := s.clock.Now()
	if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.case.sensitive_read",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	}); err != nil {
		return domain.Case{}, err
	}
	return found, nil
}

// CaseByReference finds a case from the number on the paperwork
// (SRS-MORT-001).
func (s *Service) CaseByReference(ctx context.Context, reference string) (
	domain.Case, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Case{}, err
	}
	found, err := s.cases.CaseByReference(ctx, scope, reference)
	if err != nil {
		return domain.Case{}, err
	}
	return redact(found, session.HasPermission(PermSensitiveRead)), nil
}

// ListCasesInput narrows a register read.
type ListCasesInput struct {
	States          []string
	Identities      []string
	FacilityID      string
	MedicoLegalOnly bool
	From            time.Time
	To              time.Time
	PageSize        int32
	Offset          int32
}

func (in ListCasesInput) filter(limit int32) ports.CaseFilter {
	states := make([]domain.CaseState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.CaseState(state))
	}
	identities := make([]domain.Identity, 0, len(in.Identities))
	for _, identity := range in.Identities {
		identities = append(identities, domain.Identity(identity))
	}
	return ports.CaseFilter{
		States: states, Identities: identities,
		FacilityID: in.FacilityID, MedicoLegalOnly: in.MedicoLegalOnly,
		From: in.From, To: in.To, Limit: limit, Offset: in.Offset,
	}
}

// ListCases reads the register, redacted unless the caller may read the
// sensitive detail (SRS-MORT-003).
//
// A list never audits per row: a register read of two hundred cases would
// produce two hundred audit entries and bury the one that matters. The
// sensitive detail is stripped from every row instead, and a caller who wants
// it reads one case at a time — which is audited.
func (s *Service) ListCases(ctx context.Context, in ListCasesInput) (
	[]domain.Case, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	found, err := s.cases.Cases(ctx, scope,
		in.filter(clampPageSize(in.PageSize)))
	if err != nil {
		return nil, err
	}
	out := make([]domain.Case, 0, len(found))
	for _, c := range found {
		out = append(out, redact(c, false))
	}
	return out, nil
}

func boolText(b bool) string {
	if b {
		return "true"
	}
	return "false"
}
