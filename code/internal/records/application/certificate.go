package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// NewCertificateFormInput configures a statutory form (SRS-MRD-007).
type NewCertificateFormInput struct {
	Code          string
	Name          string
	Revision      int
	Kind          domain.CertificateKind
	Jurisdiction  string
	Fields        []domain.CertificateField
	IssuerRole    string
	EffectiveFrom time.Time
}

// DraftCertificateForm authors a form revision (SRS-MRD-007).
//
// Configured rather than modelled: the fields of a death certificate are set
// by a jurisdiction's registrar and differ between them, and a group
// operating in two states needs two forms.
func (s *Service) DraftCertificateForm(ctx context.Context,
	in NewCertificateFormInput) (domain.CertificateForm, error) {

	session, scope, err := s.authorize(ctx, PermFormWrite)
	if err != nil {
		return domain.CertificateForm{}, err
	}
	now := s.clock.Now()

	form, err := domain.NewCertificateForm(s.ids.NewID(), session.TenantID,
		domain.NewCertificateFormInput{
			Code: in.Code, Name: in.Name, Revision: in.Revision,
			Kind: in.Kind, Jurisdiction: in.Jurisdiction,
			Fields: in.Fields, IssuerRole: in.IssuerRole,
			EffectiveFrom: in.EffectiveFrom,
		}, session.SubjectID, now)
	if err != nil {
		return domain.CertificateForm{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.certificates.InsertForm(ctx, scope, form); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.certificate_form.drafted",
			ResourceType: "mrd_certificate_form", ResourceID: form.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": form.Code, "revision": itoa(form.Revision),
				"kind": string(form.Kind), "jurisdiction": form.Jurisdiction,
				"fields": itoa(len(form.Fields)),
			}),
			Reason: "authored a statutory certificate form",
		}, now)
	})
	if err != nil {
		return domain.CertificateForm{}, recordsError(err)
	}
	return form, nil
}

// ApproveCertificateForm puts a form in force (SRS-MRD-007).
func (s *Service) ApproveCertificateForm(ctx context.Context, formID string,
	effectiveFrom time.Time) (domain.CertificateForm, error) {

	session, scope, err := s.authorize(ctx, PermFormApprove)
	if err != nil {
		return domain.CertificateForm{}, err
	}
	now := s.clock.Now()

	var approved domain.CertificateForm
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		form, err := s.certificates.Form(ctx, scope, formID)
		if err != nil {
			return err
		}
		if err := form.Approve(session.SubjectID, effectiveFrom,
			now); err != nil {
			return err
		}
		if err := s.certificates.ApproveForm(ctx, scope, form); err != nil {
			return err
		}
		if err := s.certificates.SupersedeEarlierForms(ctx, scope, form.Code,
			form.Revision, effectiveFrom); err != nil {
			return err
		}
		approved = form
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.certificate_form.approved",
			ResourceType: "mrd_certificate_form", ResourceID: form.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": form.Code, "revision": itoa(form.Revision),
			}),
			Reason: "put a statutory certificate form in force",
		}, now)
	})
	if err != nil {
		return domain.CertificateForm{}, recordsError(err)
	}
	return approved, nil
}

// IssueCertificateInput issues a statutory certificate (SRS-MRD-007).
type IssueCertificateInput struct {
	Kind         domain.CertificateKind
	Jurisdiction string
	PatientID    string
	EncounterID  string
	// Values are the completed fields, checked against the form: every
	// required one present and no field the form does not have.
	Values map[string]string
	// SourceRefs say where each value came from in the hospital's records,
	// so a question about a certificate years later is answered from the
	// record rather than from memory.
	SourceRefs map[string]string
	// IssuerRole is the standing the issuer signs under. Checked against the
	// form's own issuer role: who may sign a death certificate is a statutory
	// question, and a permission grant is not an answer to it.
	IssuerRole string
	IssuerName string
	// SerialNumber is the registrar's number where the jurisdiction issues
	// one.
	SerialNumber string
}

// IssueCertificate issues one against the form in force (SRS-MRD-007).
func (s *Service) IssueCertificate(ctx context.Context,
	in IssueCertificateInput) (domain.StatutoryCertificate, error) {

	session, scope, err := s.authorize(ctx, PermCertificateIssue)
	if err != nil {
		return domain.StatutoryCertificate{}, err
	}
	now := s.clock.Now()

	jurisdiction := in.Jurisdiction
	if jurisdiction == "" {
		jurisdiction = s.config.DefaultJurisdiction
	}

	var certificate domain.StatutoryCertificate
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		form, err := s.liveForm(ctx, scope, in.Kind, jurisdiction, now)
		if err != nil {
			return err
		}
		certificate, err = domain.IssueCertificate(s.ids.NewID(),
			session.TenantID, form, in.PatientID, in.EncounterID,
			in.Values, in.SourceRefs, domain.Issuer{
				SubjectID: session.SubjectID, Name: in.IssuerName,
				Role: in.IssuerRole,
			}, in.SerialNumber, now)
		if err != nil {
			return err
		}
		if err := s.certificates.InsertCertificate(ctx, scope,
			certificate); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventCertificateIssued,
			"mrd_certificate", certificate.ID, map[string]any{
				"kind": string(certificate.Kind),
				"form": certificate.FormCode,
				// The serial is the registrar's own index and carries no
				// clinical content; the values on the certificate do, and
				// never leave this context.
				"jurisdiction": certificate.Jurisdiction,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.certificate.issued",
			ResourceType: "mrd_certificate", ResourceID: certificate.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind":          string(certificate.Kind),
				"form":          certificate.FormCode,
				"form_revision": itoa(certificate.FormRevision),
				"issuer_role":   in.IssuerRole,
			}),
			Reason: "issued a statutory certificate",
		}, now)
	})
	if err != nil {
		return domain.StatutoryCertificate{}, recordsError(err)
	}
	return certificate, nil
}

// CorrectCertificate issues a corrected version (SRS-MRD-007).
//
// A new version, never an edit. The one that was issued went to a family and
// to a registrar, and a system that could quietly change it could not answer
// what the hospital actually certified.
func (s *Service) CorrectCertificate(ctx context.Context, certificateID string,
	values, sourceRefs map[string]string, issuerRole, issuerName, reason,
	serialNumber string) (domain.StatutoryCertificate, error) {

	session, scope, err := s.authorize(ctx, PermCertificateIssue)
	if err != nil {
		return domain.StatutoryCertificate{}, err
	}
	now := s.clock.Now()

	var corrected domain.StatutoryCertificate
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		certificate, err := s.certificates.Certificate(ctx, scope,
			certificateID)
		if err != nil {
			return err
		}
		form, err := s.liveForm(ctx, scope, certificate.Kind,
			certificate.Jurisdiction, now)
		if err != nil {
			return err
		}
		expected := certificate.Version
		if err := certificate.Correct(form, values, sourceRefs,
			domain.Issuer{
				SubjectID: session.SubjectID, Name: issuerName,
				Role: issuerRole,
			}, reason, serialNumber, now); err != nil {
			return err
		}
		version, _ := certificate.Current()
		if err := s.certificates.AppendVersion(ctx, scope, certificate,
			version, expected); err != nil {
			return err
		}
		corrected = certificate
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.certificate.corrected",
			ResourceType: "mrd_certificate", ResourceID: certificate.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"version": itoa(version.Version),
			}),
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.StatutoryCertificate{}, recordsError(err)
	}
	return corrected, nil
}

// VoidCertificate withdraws one that should not have been issued
// (SRS-MRD-007).
//
// The versions stay. A voided certificate the hospital cannot produce is one
// it cannot explain, and the registrar holding a copy will ask.
func (s *Service) VoidCertificate(ctx context.Context, certificateID,
	reason string) (domain.StatutoryCertificate, error) {

	session, scope, err := s.authorize(ctx, PermCertificateVoid)
	if err != nil {
		return domain.StatutoryCertificate{}, err
	}
	now := s.clock.Now()

	var voided domain.StatutoryCertificate
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		certificate, err := s.certificates.Certificate(ctx, scope,
			certificateID)
		if err != nil {
			return err
		}
		expected := certificate.Version
		if err := certificate.Void(reason, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.certificates.UpdateCertificate(ctx, scope, certificate,
			expected); err != nil {
			return err
		}
		voided = certificate

		if err := s.appendEvent(ctx, session, EventCertificateVoided,
			"mrd_certificate", certificate.ID, map[string]any{
				"kind": string(certificate.Kind),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.certificate.voided",
			ResourceType: "mrd_certificate", ResourceID: certificate.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.StatutoryCertificate{}, recordsError(err)
	}
	return voided, nil
}

// Certificates lists issued certificates (SRS-MRD-007).
func (s *Service) Certificates(ctx context.Context,
	filter ports.CertificateFilter) ([]domain.StatutoryCertificate, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	filter.Limit = clampPageSize(filter.Limit)
	certificates, err := s.certificates.Certificates(ctx, scope, filter)
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "records.certificates.read", ResourceType: "mrd_certificate",
		ResourceID: filter.PatientID, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{
			"rows": itoa(len(certificates)),
		}),
		Reason: "read statutory certificates",
	}, now); err != nil {
		return nil, err
	}
	return certificates, nil
}

// CertificateForms lists the configured forms (SRS-MRD-007).
func (s *Service) CertificateForms(ctx context.Context,
	kind domain.CertificateKind, jurisdiction string, liveOnly bool) (
	[]domain.CertificateForm, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	var liveAt time.Time
	if liveOnly {
		liveAt = s.clock.Now()
	}
	return s.certificates.Forms(ctx, scope, kind, jurisdiction, liveAt)
}

// liveForm finds the form in force for a kind and a jurisdiction
// (SRS-MRD-007).
//
// Refused rather than defaulted when none is in force. A certificate issued
// against a form nobody approved is one whose fields the registrar did not
// ask for, and issuing it on a guess is worse than not issuing it today.
func (s *Service) liveForm(ctx context.Context,
	scope authctx.TenantScope,
	kind domain.CertificateKind, jurisdiction string, at time.Time) (
	domain.CertificateForm, error) {

	forms, err := s.certificates.Forms(ctx, scope, kind, jurisdiction, at)
	if err != nil {
		return domain.CertificateForm{}, err
	}
	form, found := domain.FormFor(forms, kind, jurisdiction, at)
	if !found {
		return domain.CertificateForm{}, rpcerr.FailedPrecondition(
			"MRD_NO_FORM",
			"no approved "+string(kind)+" form is in force for "+jurisdiction)
	}
	return form, nil
}
