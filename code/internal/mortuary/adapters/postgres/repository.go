// Package postgres is the mortuary persistence adapter.
//
// It is the only package permitted to issue SQL against the mortuary schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant
// predicate is always present and always comes from verified credentials
// (FIT-03).
//
// There is no DELETE in this package. Nothing here is ever the sort of thing
// a mortuary should be able to remove: a case is a body it had, a placement
// is where that body was, a custody entry is somebody's account of a
// movement, and a release is where a body went and under whose authority.
// All four are read afterwards by people asking what happened.
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the mortuary repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.UUID{}, rpcerr.Internal("MORT_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("MORT_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe
// cannot confirm that an id exists in another tenant by the shape of the
// refusal.
func notFound() error {
	return rpcerr.NotFound("MORT_NOT_FOUND", "no such record")
}

func stamp(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func timeOf(t pgtype.Timestamptz) time.Time {
	if !t.Valid {
		return time.Time{}
	}
	return t.Time.UTC()
}

func optionalUUID(id string) pgtype.UUID {
	if id == "" {
		return pgtype.UUID{}
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return pgtype.UUID{}
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}
}

func uuidString(id pgtype.UUID) string {
	if !id.Valid {
		return ""
	}
	return uuid.UUID(id.Bytes).String()
}

// caseIDs parses a batch of identifiers, dropping any that are malformed.
// A caller asking about a nonsense id gets no rows for it rather than an
// error that hides the rows it asked about correctly.
func caseIDs(ids []string) []uuid.UUID {
	out := make([]uuid.UUID, 0, len(ids))
	for _, id := range ids {
		if parsed, err := uuid.Parse(id); err == nil {
			out = append(out, parsed)
		}
	}
	return out
}

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as
// a NULL timestamp and excludes every row, which reads as "this mortuary is
// empty" — an answer an occupancy board must never give by accident.
var (
	epoch     = time.Date(1970, 1, 1, 0, 0, 0, 0, time.UTC)
	farFuture = time.Date(2200, 1, 1, 0, 0, 0, 0, time.UTC)
)

func window(from, to time.Time) (time.Time, time.Time) {
	if from.IsZero() {
		from = epoch
	}
	if to.IsZero() {
		to = farFuture
	}
	return from, to
}

func page(limit, offset int32) (int32, int32) {
	if limit <= 0 {
		limit = 200
	}
	if offset < 0 {
		offset = 0
	}
	return limit, offset
}

// texts coalesces a nil slice into an empty array. A nil Go slice is written
// as NULL and cardinality(NULL) is NULL, so the "no filter" branch would
// never fire and the register would come back empty.
func texts(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

func conflict(rows int64) error {
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

func isNoRows(err error) bool { return errors.Is(err, pgx.ErrNoRows) }

// ----------------------------------------------------- cases (SRS-MORT-001)

var _ ports.CaseRepository = (*Repository)(nil)

func caseFrom(row sqlcgen.MortuaryCase) domain.Case {
	return domain.Case{
		ID: row.CaseID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Source: domain.Source(row.Source),
		EncounterID:           uuidString(row.EncounterID),
		PatientID:             uuidString(row.PatientID),
		ExternalSource:        row.ExternalSource,
		Identity:              domain.Identity(row.Identity),
		IdentifiedBy:          row.IdentifiedBy,
		IdentifiedAt:          timeOf(row.IdentifiedAt),
		IdentifiedNote:        row.IdentifiedNote,
		DisplayName:           row.DisplayName,
		MedicoLegal:           row.MedicoLegal,
		MLCReference:          row.MlcReference,
		Restricted:            row.Restricted,
		CauseSummary:          row.CauseSummary,
		DeathCertificateRef:   row.DeathCertificateRef,
		CertificateRecordedBy: row.CertificateRecordedBy,
		CertificateRecordedAt: timeOf(row.CertificateRecordedAt),
		State:                 domain.CaseState(row.State),
		LocationID:            uuidString(row.LocationID),
		StorageTag:            row.StorageTag,
		DiedAt:                timeOf(row.DiedAt),
		ReceivedAt:            timeOf(row.ReceivedAt), ReceivedBy: row.ReceivedBy,
		FacilityID: uuidString(row.FacilityID),
		CreatedAt:  timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// InsertCase implements ports.CaseRepository.
func (r *Repository) InsertCase(ctx context.Context,
	scope authctx.TenantScope, c domain.Case) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertMortuaryCase(ctx,
		sqlcgen.InsertMortuaryCaseParams{
			CaseID: id, TenantID: tenantID, Reference: c.Reference,
			Source:                string(c.Source),
			EncounterID:           optionalUUID(c.EncounterID),
			PatientID:             optionalUUID(c.PatientID),
			ExternalSource:        c.ExternalSource,
			Identity:              string(c.Identity),
			IdentifiedBy:          c.IdentifiedBy,
			IdentifiedAt:          stamp(c.IdentifiedAt),
			IdentifiedNote:        c.IdentifiedNote,
			DisplayName:           c.DisplayName,
			MedicoLegal:           c.MedicoLegal,
			MlcReference:          c.MLCReference,
			Restricted:            c.Restricted,
			CauseSummary:          c.CauseSummary,
			DeathCertificateRef:   c.DeathCertificateRef,
			CertificateRecordedBy: c.CertificateRecordedBy,
			CertificateRecordedAt: stamp(c.CertificateRecordedAt),
			State:                 string(c.State),
			LocationID:            optionalUUID(c.LocationID),
			StorageTag:            c.StorageTag,
			DiedAt:                stamp(c.DiedAt),
			ReceivedAt:            stamp(c.ReceivedAt), ReceivedBy: c.ReceivedBy,
			FacilityID: optionalUUID(c.FacilityID),
			CreatedAt:  stamp(c.CreatedAt), CreatedBy: c.CreatedBy,
			Version: c.Version,
		})
}

// Case implements ports.CaseRepository.
func (r *Repository) Case(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Case{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Case{}, notFound()
	}

	row, err := r.queries(ctx).GetMortuaryCase(ctx,
		sqlcgen.GetMortuaryCaseParams{TenantID: tenantID, CaseID: parsed})
	if isNoRows(err) {
		return domain.Case{}, notFound()
	}
	if err != nil {
		return domain.Case{}, err
	}
	return caseFrom(row), nil
}

// CaseByReference implements ports.CaseRepository.
func (r *Repository) CaseByReference(ctx context.Context,
	scope authctx.TenantScope, reference string) (domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Case{}, err
	}

	row, err := r.queries(ctx).GetMortuaryCaseByReference(ctx,
		sqlcgen.GetMortuaryCaseByReferenceParams{
			TenantID: tenantID, Reference: reference,
		})
	if isNoRows(err) {
		return domain.Case{}, notFound()
	}
	if err != nil {
		return domain.Case{}, err
	}
	return caseFrom(row), nil
}

// UpdateCase implements ports.CaseRepository.
func (r *Repository) UpdateCase(ctx context.Context,
	scope authctx.TenantScope, c domain.Case,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateMortuaryCase(ctx,
		sqlcgen.UpdateMortuaryCaseParams{
			TenantID: tenantID, CaseID: id,
			Identity:              string(c.Identity),
			IdentifiedBy:          c.IdentifiedBy,
			IdentifiedAt:          stamp(c.IdentifiedAt),
			IdentifiedNote:        c.IdentifiedNote,
			DisplayName:           c.DisplayName,
			MedicoLegal:           c.MedicoLegal,
			MlcReference:          c.MLCReference,
			Restricted:            c.Restricted,
			CauseSummary:          c.CauseSummary,
			DeathCertificateRef:   c.DeathCertificateRef,
			CertificateRecordedBy: c.CertificateRecordedBy,
			CertificateRecordedAt: stamp(c.CertificateRecordedAt),
			State:                 string(c.State),
			LocationID:            optionalUUID(c.LocationID),
			StorageTag:            c.StorageTag,
			ExpectedVersion:       expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Cases implements ports.CaseRepository.
func (r *Repository) Cases(ctx context.Context, scope authctx.TenantScope,
	f ports.CaseFilter) ([]domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	states := make([]string, 0, len(f.States))
	for _, state := range f.States {
		states = append(states, string(state))
	}
	identities := make([]string, 0, len(f.Identities))
	for _, identity := range f.Identities {
		identities = append(identities, string(identity))
	}

	rows, err := r.queries(ctx).ListMortuaryCases(ctx,
		sqlcgen.ListMortuaryCasesParams{
			TenantID: tenantID, States: texts(states),
			Identities: texts(identities), FacilityID: f.FacilityID,
			MedicoLegalOnly: f.MedicoLegalOnly,
			WindowFrom:      stamp(from), WindowTo: stamp(to),
			RowLimit: limit, RowOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Case, 0, len(rows))
	for _, row := range rows {
		out = append(out, caseFrom(row))
	}
	return out, nil
}
