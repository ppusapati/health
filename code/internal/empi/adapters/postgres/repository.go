// Package postgres is the patient index's persistence adapter.
//
// It is the only package permitted to issue SQL against the empi schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// uniqueViolation is the PostgreSQL SQLSTATE for a unique-constraint breach.
const uniqueViolation = "23505"

// Repository implements the patient index repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

// PatientRepo, IdentifierRepo and ConfigRepo split one Repository into the
// three ports the application declares, so a use case that only reads
// configuration cannot reach a patient write.
type PatientRepo struct{ *Repository }
type IdentifierRepo struct{ *Repository }
type ConfigRepo struct{ *Repository }

var (
	_ ports.PatientRepository    = PatientRepo{}
	_ ports.IdentifierRepository = IdentifierRepo{}
	_ ports.ConfigRepository     = ConfigRepo{}
)

// scopeTenantID extracts the tenant from a verified scope.
//
// A zero scope is an internal error rather than a permission denial: the type
// cannot be constructed without a session, so a zero one reaching here means a
// caller built it by mistake, not that somebody was refused.
func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.Nil, rpcerr.Internal("EMPI_TENANT_SCOPE_MISSING", "tenant scope is required")
	}
	id, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.Nil, rpcerr.Internal("EMPI_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	return id, nil
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func dateOrNull(b domain.BirthDate) pgtype.Date {
	if b.IsZero() {
		return pgtype.Date{}
	}
	return pgtype.Date{Time: b.Date.UTC(), Valid: true}
}

// notFound is the single answer to "no such patient", whatever the reason.
//
// A caller who names another tenant's patient gets exactly this, not
// PERMISSION_DENIED: the latter confirms the identifier exists, which is a
// probe a hospital's own staff can run against a neighbouring tenant.
func notFound() error {
	return rpcerr.NotFound("EMPI_PATIENT_NOT_FOUND", "patient not found")
}

// Insert stores a new patient.
func (r PatientRepo) Insert(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	patientID, err := uuid.Parse(p.ID())
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}
	facilityID, err := uuid.Parse(p.RegisteredFacilityID)
	if err != nil {
		return rpcerr.Internal("EMPI_FACILITY_ID_INVALID", "facility_id must be a UUID").WithCause(err)
	}

	phones, emails, addresses, err := encodeContacts(p.Demographics)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertPatient(ctx, sqlcgen.InsertPatientParams{
		PatientID: patientID, TenantID: tenantID, RegisteredFacilityID: facilityID,
		Status:             string(p.Status),
		FamilyName:         p.Demographics.Name.Family,
		GivenNames:         p.Demographics.Name.Given,
		NamePrefix:         p.Demographics.Name.Prefix,
		NameSuffix:         p.Demographics.Name.Suffix,
		BirthDate:          dateOrNull(p.Demographics.BirthDate),
		BirthDatePrecision: string(p.Demographics.BirthDate.Precision),
		Sex:                string(p.Demographics.Sex),
		Phones:             phones, Emails: emails, Addresses: addresses,
		CreatedAt: timestamptz(p.CreatedAt), UpdatedAt: timestamptz(p.UpdatedAt),
	})
}

// GetByID reads one patient.
func (r PatientRepo) GetByID(ctx context.Context, scope authctx.TenantScope, patientID string) (*domain.Patient, error) {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		// A malformed identifier is indistinguishable from an absent one, on
		// purpose: distinguishing them tells a prober which format to guess.
		return nil, notFound()
	}

	row, err := r.queries(ctx).GetPatient(ctx, sqlcgen.GetPatientParams{
		TenantID: tenantID, PatientID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return patientFromRow(row)
}

// UpdateDemographics applies a correction under optimistic concurrency.
func (r PatientRepo) UpdateDemographics(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	patientID, err := uuid.Parse(p.ID())
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	phones, emails, addresses, err := encodeContacts(p.Demographics)
	if err != nil {
		return err
	}

	// The domain bumped Version when it applied the change, so the row still
	// carries the value before it.
	rows, err := r.queries(ctx).UpdatePatientDemographics(ctx, sqlcgen.UpdatePatientDemographicsParams{
		FamilyName:         p.Demographics.Name.Family,
		GivenNames:         p.Demographics.Name.Given,
		NamePrefix:         p.Demographics.Name.Prefix,
		NameSuffix:         p.Demographics.Name.Suffix,
		BirthDate:          dateOrNull(p.Demographics.BirthDate),
		BirthDatePrecision: string(p.Demographics.BirthDate.Precision),
		Sex:                string(p.Demographics.Sex),
		Phones:             phones, Emails: emails, Addresses: addresses,
		UpdatedAt:       timestamptz(p.UpdatedAt),
		TenantID:        tenantID,
		PatientID:       patientID,
		ExpectedVersion: p.Version - 1,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// SetStatus moves the lifecycle, under the same optimistic concurrency.
func (r PatientRepo) SetStatus(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	patientID, err := uuid.Parse(p.ID())
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	rows, err := r.queries(ctx).SetPatientStatus(ctx, sqlcgen.SetPatientStatusParams{
		Status: string(p.Status), UpdatedAt: timestamptz(p.UpdatedAt),
		TenantID: tenantID, PatientID: patientID, ExpectedVersion: p.Version - 1,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Candidates returns records sharing a blocking signal with the proposal.
func (r PatientRepo) Candidates(ctx context.Context, scope authctx.TenantScope,
	b ports.BlockingKeys, limit int32) ([]*domain.Patient, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if b.IsEmpty() {
		// Nothing indexable to block on. Returning no candidates is the
		// correct answer; the alternative is a full tenant scan on every
		// sparse registration, which is exactly when the desk is busiest.
		return nil, nil
	}

	params := sqlcgen.SearchPatientCandidatesParams{TenantID: tenantID, PageLimit: limit}
	if b.BirthDate != nil {
		params.BirthDate = pgtype.Date{Time: b.BirthDate.UTC(), Valid: true}
	}
	if b.FamilyPrefix != "" {
		prefix := b.FamilyPrefix
		params.FamilyPrefix = &prefix
	}
	if b.Phone != "" {
		phone := b.Phone
		params.Phone = &phone
	}
	if b.ExcludePatientID != "" {
		if id, parseErr := uuid.Parse(b.ExcludePatientID); parseErr == nil {
			params.ExcludePatientID = pgtype.UUID{Bytes: id, Valid: true}
		}
	}

	rows, err := r.queries(ctx).SearchPatientCandidates(ctx, params)
	if err != nil {
		return nil, err
	}
	return patientsFromRows(rows)
}

// ByName is the registration desk's plain search.
func (r PatientRepo) ByName(ctx context.Context, scope authctx.TenantScope,
	prefix string, after ports.Cursor, limit int32) ([]*domain.Patient, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	// The zero UUID is the keyset's start position, so the first page needs no
	// special case.
	afterID := uuid.Nil
	if after.PatientID != "" {
		parsed, parseErr := uuid.Parse(after.PatientID)
		if parseErr != nil {
			return nil, rpcerr.Invalid("EMPI_PAGE_TOKEN_INVALID", "page token is not valid")
		}
		afterID = parsed
	}

	rows, err := r.queries(ctx).ListPatientsByName(ctx, sqlcgen.ListPatientsByNameParams{
		TenantID: tenantID, FamilyPrefix: prefix,
		AfterFamily: after.FamilyName, AfterID: afterID, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return patientsFromRows(rows)
}

// ByIdentifier resolves a value a patient quoted.
func (r PatientRepo) ByIdentifier(ctx context.Context, scope authctx.TenantScope,
	t domain.IdentifierType, system, value string, limit int32) ([]*domain.Patient, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).FindPatientByIdentifier(ctx, sqlcgen.FindPatientByIdentifierParams{
		TenantID: tenantID, IdentifierType: string(t), System: system,
		Value: value, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return patientsFromRows(rows)
}

// Link inserts an identifier, refusing a value already actively held.
func (r IdentifierRepo) Link(ctx context.Context, scope authctx.TenantScope, i domain.Identifier) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	identifierID, err := uuid.Parse(i.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_IDENTIFIER_ID_INVALID", "identifier_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(i.PatientID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	err = r.queries(ctx).InsertPatientIdentifier(ctx, sqlcgen.InsertPatientIdentifierParams{
		IdentifierID: identifierID, TenantID: tenantID, PatientID: patientID,
		IdentifierType: string(i.Type), System: i.System, Value: i.Value,
		AssigningAuthority: i.AssigningAuthority, Status: string(i.Status),
		Source: i.Source, IsPrimary: i.Primary, LinkedAt: timestamptz(i.LinkedAt),
	})

	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) && pgErr.Code == uniqueViolation {
		// The conflict comes from the index rather than from a prior read,
		// which is what makes it hold against two concurrent registrations
		// (SRS-EMPI-016). Reading the holder now is for the message only.
		holder, readErr := r.queries(ctx).FindIdentifierHolder(ctx, sqlcgen.FindIdentifierHolderParams{
			TenantID: tenantID, IdentifierType: string(i.Type),
			System: i.System, Value: i.Value,
		})
		conflict := domain.ErrIdentifierConflict{Type: i.Type, System: i.System, Value: i.Value}
		if readErr == nil {
			conflict.HeldByPatientID = holder.String()
		}
		return conflict
	}
	return err
}

// ForPatient loads one patient's identifiers.
func (r IdentifierRepo) ForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string) (domain.IdentifierSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientIdentifiers(ctx, sqlcgen.ListPatientIdentifiersParams{
		TenantID: tenantID, PatientID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make(domain.IdentifierSet, 0, len(rows))
	for _, row := range rows {
		out = append(out, identifierFromRow(row))
	}
	return out, nil
}

// ForPatients batch-loads identifiers for a page of search results.
func (r IdentifierRepo) ForPatients(ctx context.Context, scope authctx.TenantScope,
	patientIDs []string) (map[string]domain.IdentifierSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if len(patientIDs) == 0 {
		return map[string]domain.IdentifierSet{}, nil
	}

	ids := make([]uuid.UUID, 0, len(patientIDs))
	for _, raw := range patientIDs {
		parsed, parseErr := uuid.Parse(raw)
		if parseErr != nil {
			continue
		}
		ids = append(ids, parsed)
	}

	rows, err := r.queries(ctx).ListIdentifiersForPatients(ctx, sqlcgen.ListIdentifiersForPatientsParams{
		TenantID: tenantID, PatientIds: ids,
	})
	if err != nil {
		return nil, err
	}

	out := make(map[string]domain.IdentifierSet, len(patientIDs))
	for _, row := range rows {
		key := row.PatientID.String()
		out[key] = append(out[key], identifierFromRow(row))
	}
	return out, nil
}

func encodeContacts(d domain.Demographics) (phones, emails, addresses []byte, err error) {
	// Empty slices rather than nil, so the column holds `[]` and a reader does
	// not have to distinguish "no phones" from "column is null".
	if phones, err = json.Marshal(nonNilContacts(d.Phones)); err != nil {
		return nil, nil, nil, rpcerr.Internal("EMPI_ENCODE_FAILED", "could not encode contacts").WithCause(err)
	}
	if emails, err = json.Marshal(nonNilContacts(d.Emails)); err != nil {
		return nil, nil, nil, rpcerr.Internal("EMPI_ENCODE_FAILED", "could not encode contacts").WithCause(err)
	}
	list := d.Addresses
	if list == nil {
		list = []domain.Address{}
	}
	if addresses, err = json.Marshal(list); err != nil {
		return nil, nil, nil, rpcerr.Internal("EMPI_ENCODE_FAILED", "could not encode addresses").WithCause(err)
	}
	return phones, emails, addresses, nil
}

func nonNilContacts(in []domain.ContactPoint) []domain.ContactPoint {
	if in == nil {
		return []domain.ContactPoint{}
	}
	return in
}

func patientsFromRows(rows []sqlcgen.EmpiPatient) ([]*domain.Patient, error) {
	out := make([]*domain.Patient, 0, len(rows))
	for _, row := range rows {
		p, err := patientFromRow(row)
		if err != nil {
			return nil, err
		}
		out = append(out, p)
	}
	return out, nil
}

func patientFromRow(row sqlcgen.EmpiPatient) (*domain.Patient, error) {
	d := domain.Demographics{
		Name: domain.HumanName{
			Family: row.FamilyName, Given: row.GivenNames,
			Prefix: row.NamePrefix, Suffix: row.NameSuffix,
		},
		Sex: domain.Sex(row.Sex),
	}
	if row.BirthDate.Valid {
		d.BirthDate = domain.BirthDate{
			Date:      row.BirthDate.Time.UTC(),
			Precision: domain.DatePrecision(row.BirthDatePrecision),
		}
	}
	if err := json.Unmarshal(row.Phones, &d.Phones); err != nil {
		return nil, rpcerr.Internal("EMPI_DECODE_FAILED", "could not decode contacts").WithCause(err)
	}
	if err := json.Unmarshal(row.Emails, &d.Emails); err != nil {
		return nil, rpcerr.Internal("EMPI_DECODE_FAILED", "could not decode contacts").WithCause(err)
	}
	if err := json.Unmarshal(row.Addresses, &d.Addresses); err != nil {
		return nil, rpcerr.Internal("EMPI_DECODE_FAILED", "could not decode addresses").WithCause(err)
	}

	p := domain.Patient{
		TenantID:             row.TenantID.String(),
		RegisteredFacilityID: row.RegisteredFacilityID.String(),
		Status:               domain.Status(row.Status),
		Demographics:         d,
		CreatedAt:            row.CreatedAt.Time.UTC(),
		UpdatedAt:            row.UpdatedAt.Time.UTC(),
		Version:              row.Version,
	}
	if row.MergedIntoPatientID.Valid {
		p.MergedIntoPatientID = uuid.UUID(row.MergedIntoPatientID.Bytes).String()
	}
	if row.DeceasedRecordedAt.Valid {
		deceased := domain.DeceasedRecord{
			Source:     row.DeceasedSource,
			RecordedAt: row.DeceasedRecordedAt.Time.UTC(),
			RecordedBy: row.DeceasedRecordedBy,
			Precision:  domain.DatePrecision(row.DeceasedPrecision),
		}
		if row.DeceasedDate.Valid {
			deceased.Date = row.DeceasedDate.Time.UTC()
		}
		p.Deceased = &deceased
	}

	// Restore is the only way to produce a Patient with a chosen id, and it
	// lives in the domain package — so reading one back is the single path
	// that can set it.
	return domain.Restore(row.PatientID.String(), p), nil
}

func identifierFromRow(row sqlcgen.EmpiPatientIdentifier) domain.Identifier {
	i := domain.Identifier{
		ID: row.IdentifierID.String(), PatientID: row.PatientID.String(),
		Type:   domain.IdentifierType(row.IdentifierType),
		System: row.System, Value: row.Value,
		AssigningAuthority: row.AssigningAuthority,
		Status:             domain.IdentifierStatus(row.Status),
		Source:             row.Source, Primary: row.IsPrimary,
		LinkedAt: row.LinkedAt.Time.UTC(), Reason: row.Reason,
	}
	if row.UnlinkedAt.Valid {
		at := row.UnlinkedAt.Time.UTC()
		i.UnlinkedAt = &at
	}
	if row.SupersededByID.Valid {
		i.SupersededByID = uuid.UUID(row.SupersededByID.Bytes).String()
	}
	return i
}
