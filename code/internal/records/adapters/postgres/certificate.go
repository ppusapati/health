package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// InsertForm stores a statutory form and its fields (SRS-MRD-007).
func (r *Repository) InsertForm(ctx context.Context,
	scope authctx.TenantScope, f domain.CertificateForm) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	formID, err := uuid.Parse(f.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_FORM_ID_INVALID", "form id must be a UUID")
	}

	queries := r.queries(ctx)
	if err := queries.InsertRecordsCertificateForm(ctx,
		sqlcgen.InsertRecordsCertificateFormParams{
			FormID: formID, TenantID: tenantID, Code: f.Code, Name: f.Name,
			Revision: int32(f.Revision), Kind: string(f.Kind),
			Jurisdiction: f.Jurisdiction, IssuerRole: f.IssuerRole,
			EffectiveFrom: stamp(f.EffectiveFrom),
			CreatedAt:     stamp(f.CreatedAt), CreatedBy: f.CreatedBy,
		}); err != nil {
		return err
	}

	for ordinal, field := range f.Fields {
		if err := queries.InsertRecordsCertificateField(ctx,
			sqlcgen.InsertRecordsCertificateFieldParams{
				FieldID: uuid.New(), TenantID: tenantID, FormID: formID,
				Code: field.Code, Label: field.Label,
				Required: field.Required, SourcePath: field.SourcePath,
				Ordinal: int32(ordinal),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Form reads one statutory form and its fields.
func (r *Repository) Form(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.CertificateForm, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CertificateForm{}, err
	}
	formID, err := uuid.Parse(id)
	if err != nil {
		return domain.CertificateForm{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsCertificateForm(ctx,
		sqlcgen.GetRecordsCertificateFormParams{
			TenantID: tenantID, FormID: formID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CertificateForm{}, notFound()
	}
	if err != nil {
		return domain.CertificateForm{}, err
	}

	form := formFrom(row)
	fields, err := r.formFields(ctx, tenantID, formID)
	if err != nil {
		return domain.CertificateForm{}, err
	}
	form.Fields = fields
	return form, nil
}

func (r *Repository) formFields(ctx context.Context, tenantID,
	formID uuid.UUID) ([]domain.CertificateField, error) {

	rows, err := r.queries(ctx).ListRecordsCertificateFields(ctx,
		sqlcgen.ListRecordsCertificateFieldsParams{
			TenantID: tenantID, FormID: formID,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.CertificateField, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.CertificateField{
			Code: row.Code, Label: row.Label, Required: row.Required,
			SourcePath: row.SourcePath,
		})
	}
	return out, nil
}

// ApproveForm puts a statutory form in force.
func (r *Repository) ApproveForm(ctx context.Context,
	scope authctx.TenantScope, f domain.CertificateForm) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	formID, err := uuid.Parse(f.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveRecordsCertificateForm(ctx,
		sqlcgen.ApproveRecordsCertificateFormParams{
			ApprovedBy: f.ApprovedBy, ApprovedAt: stamp(f.ApprovedAt),
			EffectiveFrom: stamp(f.EffectiveFrom),
			TenantID:      tenantID, FormID: formID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("MRD_FORM_ALREADY_APPROVED",
			"this form is already approved")
	}
	return nil
}

// SupersedeEarlierForms closes off every earlier revision of a form code.
func (r *Repository) SupersedeEarlierForms(ctx context.Context,
	scope authctx.TenantScope, code string, revision int,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).SupersedeRecordsCertificateForm(ctx,
		sqlcgen.SupersedeRecordsCertificateFormParams{
			SupersededAt: stamp(at), TenantID: tenantID, Code: code,
			Revision: int32(revision),
		})
	return err
}

// Forms lists statutory forms with their fields.
func (r *Repository) Forms(ctx context.Context, scope authctx.TenantScope,
	kind domain.CertificateKind, jurisdiction string, liveAt time.Time) (
	[]domain.CertificateForm, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	at := liveAt
	if at.IsZero() {
		at = epoch
	}

	rows, err := r.queries(ctx).ListRecordsCertificateForms(ctx,
		sqlcgen.ListRecordsCertificateFormsParams{
			TenantID: tenantID, Kind: string(kind),
			Jurisdiction: jurisdiction,
			LiveOnly:     !liveAt.IsZero(), At: stamp(at),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.CertificateForm, 0, len(rows))
	for _, row := range rows {
		form := formFrom(row)
		fields, err := r.formFields(ctx, tenantID, row.FormID)
		if err != nil {
			return nil, err
		}
		form.Fields = fields
		out = append(out, form)
	}
	return out, nil
}

func formFrom(row sqlcgen.RecordsCertificateForm) domain.CertificateForm {
	return domain.CertificateForm{
		ID: row.FormID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		Kind:         domain.CertificateKind(row.Kind),
		Jurisdiction: row.Jurisdiction, IssuerRole: row.IssuerRole,
		Approved: row.Approved, ApprovedBy: row.ApprovedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
	}
}

// InsertCertificate issues a statutory document and its first version
// (SRS-MRD-007).
func (r *Repository) InsertCertificate(ctx context.Context,
	scope authctx.TenantScope, c domain.StatutoryCertificate) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	certificateID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_CERTIFICATE_ID_INVALID",
			"certificate id must be a UUID")
	}

	queries := r.queries(ctx)
	if err := queries.InsertRecordsCertificate(ctx,
		sqlcgen.InsertRecordsCertificateParams{
			CertificateID: certificateID, TenantID: tenantID,
			Kind: string(c.Kind), FormCode: c.FormCode,
			FormRevision: int32(c.FormRevision),
			Jurisdiction: c.Jurisdiction, PatientID: c.PatientID,
			EncounterID: c.EncounterID, SerialNumber: currentSerial(c),
			State: string(c.State), CreatedAt: stamp(c.CreatedAt),
		}); err != nil {
		return err
	}

	for _, version := range c.Versions {
		if err := r.insertVersion(ctx, tenantID, certificateID,
			version); err != nil {
			return err
		}
	}
	return nil
}

func (r *Repository) insertVersion(ctx context.Context, tenantID,
	certificateID uuid.UUID, version domain.CertificateVersion) error {

	values, err := json.Marshal(nonNil(version.Values))
	if err != nil {
		return rpcerr.Internal("MRD_CERTIFICATE_ENCODE_FAILED",
			"could not encode certificate values").WithCause(err)
	}
	refs, err := json.Marshal(nonNil(version.SourceRefs))
	if err != nil {
		return rpcerr.Internal("MRD_CERTIFICATE_ENCODE_FAILED",
			"could not encode certificate sources").WithCause(err)
	}

	return r.queries(ctx).InsertRecordsCertificateVersion(ctx,
		sqlcgen.InsertRecordsCertificateVersionParams{
			VersionID: uuid.New(), TenantID: tenantID,
			CertificateID: certificateID, Version: int32(version.Version),
			Values: values, SourceRefs: refs, Reason: version.Reason,
			IssuerID: version.IssuerID, IssuerName: version.IssuerName,
			IssuerRole:   version.IssuerRole,
			IssuedAt:     stamp(version.IssuedAt),
			SerialNumber: version.SerialNumber,
		})
}

func nonNil(in map[string]string) map[string]string {
	if in == nil {
		return map[string]string{}
	}
	return in
}

// Certificate reads one certificate and every version of it.
func (r *Repository) Certificate(ctx context.Context,
	scope authctx.TenantScope, id string) (
	domain.StatutoryCertificate, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.StatutoryCertificate{}, err
	}
	certificateID, err := uuid.Parse(id)
	if err != nil {
		return domain.StatutoryCertificate{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsCertificate(ctx,
		sqlcgen.GetRecordsCertificateParams{
			TenantID: tenantID, CertificateID: certificateID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.StatutoryCertificate{}, notFound()
	}
	if err != nil {
		return domain.StatutoryCertificate{}, err
	}

	certificate := certificateFrom(row)
	versions, err := r.queries(ctx).ListRecordsCertificateVersions(ctx,
		sqlcgen.ListRecordsCertificateVersionsParams{
			TenantID: tenantID, CertificateID: certificateID,
		})
	if err != nil {
		return domain.StatutoryCertificate{}, err
	}
	for _, version := range versions {
		decoded, err := versionFrom(version)
		if err != nil {
			return domain.StatutoryCertificate{}, err
		}
		certificate.Versions = append(certificate.Versions, decoded)
	}
	return certificate, nil
}

func versionFrom(row sqlcgen.RecordsCertificateVersion) (
	domain.CertificateVersion, error) {

	values := map[string]string{}
	if len(row.Values) > 0 {
		if err := json.Unmarshal(row.Values, &values); err != nil {
			return domain.CertificateVersion{}, rpcerr.Internal(
				"MRD_CERTIFICATE_DECODE_FAILED",
				"could not decode certificate values").WithCause(err)
		}
	}
	refs := map[string]string{}
	if len(row.SourceRefs) > 0 {
		if err := json.Unmarshal(row.SourceRefs, &refs); err != nil {
			return domain.CertificateVersion{}, rpcerr.Internal(
				"MRD_CERTIFICATE_DECODE_FAILED",
				"could not decode certificate sources").WithCause(err)
		}
	}

	return domain.CertificateVersion{
		Version: int(row.Version), Values: values, SourceRefs: refs,
		Reason: row.Reason, IssuerID: row.IssuerID,
		IssuerName: row.IssuerName, IssuerRole: row.IssuerRole,
		IssuedAt: timeOf(row.IssuedAt), SerialNumber: row.SerialNumber,
	}, nil
}

// AppendVersion adds a corrected version (SRS-MRD-007).
//
// Append-only: there is no method here that edits one. The first version went
// to a family and to a registrar.
func (r *Repository) AppendVersion(ctx context.Context,
	scope authctx.TenantScope, c domain.StatutoryCertificate,
	version domain.CertificateVersion, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	certificateID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	// The serial follows the version being appended: a correction issued on
	// a new serial moves the number the registrar holds, and the unique
	// index then refuses a second certificate claiming it.
	serial := version.SerialNumber
	if serial == "" {
		serial = currentSerial(c)
	}

	rows, err := r.queries(ctx).UpdateRecordsCertificate(ctx,
		sqlcgen.UpdateRecordsCertificateParams{
			State: string(c.State), FormCode: c.FormCode,
			FormRevision: int32(c.FormRevision), SerialNumber: serial,
			VoidReason: c.VoidReason, VoidedBy: c.VoidedBy,
			VoidedAt: stamp(c.VoidedAt),
			TenantID: tenantID, CertificateID: certificateID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if err := conflict(rows); err != nil {
		return err
	}
	return r.insertVersion(ctx, tenantID, certificateID, version)
}

// UpdateCertificate records a withdrawal. The versions stay.
func (r *Repository) UpdateCertificate(ctx context.Context,
	scope authctx.TenantScope, c domain.StatutoryCertificate,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	certificateID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateRecordsCertificate(ctx,
		sqlcgen.UpdateRecordsCertificateParams{
			State: string(c.State), FormCode: c.FormCode,
			FormRevision: int32(c.FormRevision),
			SerialNumber: currentSerial(c),
			VoidReason:   c.VoidReason, VoidedBy: c.VoidedBy,
			VoidedAt: stamp(c.VoidedAt),
			TenantID: tenantID, CertificateID: certificateID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// currentSerial is the statutory number this certificate stands under.
func currentSerial(c domain.StatutoryCertificate) string {
	current, ok := c.Current()
	if !ok {
		return ""
	}
	return current.SerialNumber
}

// Certificates lists issued certificates.
func (r *Repository) Certificates(ctx context.Context,
	scope authctx.TenantScope, f ports.CertificateFilter) (
	[]domain.StatutoryCertificate, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListRecordsCertificates(ctx,
		sqlcgen.ListRecordsCertificatesParams{
			TenantID: tenantID, PatientID: f.PatientID,
			Kind: string(f.Kind), State: f.State,
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.StatutoryCertificate, 0, len(rows))
	for _, row := range rows {
		out = append(out, certificateFrom(row))
	}
	return out, nil
}

func certificateFrom(
	row sqlcgen.RecordsCertificate) domain.StatutoryCertificate {

	return domain.StatutoryCertificate{
		ID: row.CertificateID.String(), TenantID: row.TenantID.String(),
		Kind: domain.CertificateKind(row.Kind), FormCode: row.FormCode,
		FormRevision: int(row.FormRevision), Jurisdiction: row.Jurisdiction,
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		State:      domain.CertificateState(row.State),
		VoidReason: row.VoidReason, VoidedBy: row.VoidedBy,
		VoidedAt:  timeOf(row.VoidedAt),
		CreatedAt: timeOf(row.CreatedAt), Version: row.Version,
	}
}

// Compile-time proof that this adapter satisfies every port it claims.
var (
	_ ports.ChecklistRepository   = (*Repository)(nil)
	_ ports.DeficiencyRepository  = (*Repository)(nil)
	_ ports.CodingRepository      = (*Repository)(nil)
	_ ports.ReleaseRepository     = (*Repository)(nil)
	_ ports.RetentionRepository   = (*Repository)(nil)
	_ ports.PhysicalRepository    = (*Repository)(nil)
	_ ports.CertificateRepository = (*Repository)(nil)
	_ ports.RecordInventory       = (*Repository)(nil)
)
