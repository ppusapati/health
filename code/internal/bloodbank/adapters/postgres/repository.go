// Package postgres is the blood bank persistence adapter.
//
// It is the only package permitted to issue SQL against the bloodbank schema
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
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the blood bank repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("BLD_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("BLD_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("BLD_NOT_FOUND", "no such blood bank record")
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

func dateOf(d pgtype.Date) time.Time {
	if !d.Valid {
		return time.Time{}
	}
	return d.Time.UTC()
}

func stampDate(t time.Time) pgtype.Date {
	if t.IsZero() {
		return pgtype.Date{}
	}
	return pgtype.Date{Time: t.UTC(), Valid: true}
}

func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
		return pgtype.UUID{}, notFound()
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func uuidOrEmpty(value pgtype.UUID) string {
	if !value.Valid {
		return ""
	}
	return uuid.UUID(value.Bytes).String()
}

// strings0 turns a nil slice into an empty one.
//
// The array columns here are NOT NULL, and an empty list in Go is a nil slice.
// Empty and absent are the same thing for every one of them, and writing a
// NULL would make the read side distinguish two states the domain does not
// have.
func strings0(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// optionalText carries a nullable text column.
//
// Used only where the absence is meaningful: a donor whose group has not been
// determined, and a deferral that is not in force. Everywhere else the column
// is NOT NULL and the empty string is the absence.
func optionalText(value string) *string {
	if value == "" {
		return nil
	}
	return &value
}

func textOrEmpty(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}

// groupOf reads a group from two NOT NULL columns.
func groupOf(abo, rh string) domain.Group {
	return domain.Group{ABO: domain.ABO(abo), Rh: domain.RhD(rh)}
}

// nullableGroupOf reads a group that may not have been determined.
func nullableGroupOf(abo, rh *string) domain.Group {
	return domain.Group{
		ABO: domain.ABO(textOrEmpty(abo)), Rh: domain.RhD(textOrEmpty(rh)),
	}
}

// DonorRepo implements ports.DonorRepository.
type DonorRepo struct{ *Repository }

// InsertDonor registers a donor.
func (r DonorRepo) InsertDonor(ctx context.Context, scope authctx.TenantScope,
	d domain.Donor) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	donorID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}
	patientID, err := optionalUUID(d.PatientID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertDonor(ctx, sqlcgen.InsertDonorParams{
		DonorID: donorID, TenantID: tenantID,
		DonorNumber: d.DonorNumber, PatientID: patientID,
		DisplayName: d.Name, BirthDate: stampDate(d.BirthDate),
		ContactPhone: d.ContactPhone,
		// Null rather than empty: a donor whose group is not yet determined is
		// a real state, and an empty string would fail the CHECK.
		Abo:          optionalText(string(d.Group.ABO)),
		Rhd:          optionalText(string(d.Group.Rh)),
		RegisteredAt: stamp(d.RegisteredAt), RegisteredBy: d.RegisteredBy,
	})
}

// Donor reads one donor.
func (r DonorRepo) Donor(ctx context.Context, scope authctx.TenantScope,
	donorID string) (domain.Donor, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Donor{}, err
	}
	id, err := uuid.Parse(donorID)
	if err != nil {
		return domain.Donor{}, notFound()
	}

	row, err := r.queries(ctx).GetDonor(ctx, sqlcgen.GetDonorParams{
		TenantID: tenantID, DonorID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Donor{}, notFound()
	}
	if err != nil {
		return domain.Donor{}, err
	}
	return donorFrom(row), nil
}

// DonorByNumber reads a donor by the number on their card.
func (r DonorRepo) DonorByNumber(ctx context.Context, scope authctx.TenantScope,
	number string) (domain.Donor, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Donor{}, err
	}
	row, err := r.queries(ctx).GetDonorByNumber(ctx,
		sqlcgen.GetDonorByNumberParams{TenantID: tenantID, DonorNumber: number})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Donor{}, notFound()
	}
	if err != nil {
		return domain.Donor{}, err
	}
	return donorFrom(row), nil
}

// UpdateDeferral records a deferral or its lifting.
func (r DonorRepo) UpdateDeferral(ctx context.Context, scope authctx.TenantScope,
	d domain.Donor, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	donorID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateDonorDeferral(ctx,
		sqlcgen.UpdateDonorDeferralParams{
			TenantID: tenantID, DonorID: donorID,
			// Null clears the deferral, which is what lifting one means. An
			// empty string would fail the CHECK, so the two states cannot be
			// confused.
			Deferral:        optionalText(string(d.Deferral)),
			DeferralCode:    d.DeferralCode,
			DeferralNote:    d.DeferralNote,
			DeferredAt:      stamp(d.DeferredAt),
			DeferredBy:      d.DeferredBy,
			DeferredUntil:   stamp(d.DeferredUntil),
			Abo:             optionalText(string(d.Group.ABO)),
			Rhd:             optionalText(string(d.Group.Rh)),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Deferred lists donors who may not give.
func (r DonorRepo) Deferred(ctx context.Context, scope authctx.TenantScope,
	asOf time.Time, limit int32) ([]domain.Donor, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListDeferredDonors(ctx,
		sqlcgen.ListDeferredDonorsParams{
			TenantID: tenantID, AsOf: stamp(asOf), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Donor, 0, len(rows))
	for _, row := range rows {
		out = append(out, donorFrom(row))
	}
	return out, nil
}

func donorFrom(row sqlcgen.BloodbankDonor) domain.Donor {
	return domain.Donor{
		ID: row.DonorID.String(), TenantID: row.TenantID.String(),
		DonorNumber: row.DonorNumber, PatientID: uuidOrEmpty(row.PatientID),
		Name: row.DisplayName, BirthDate: dateOf(row.BirthDate),
		ContactPhone: row.ContactPhone,
		Group:        nullableGroupOf(row.Abo, row.Rhd),
		Deferral:     domain.DeferralKind(textOrEmpty(row.Deferral)),
		DeferralCode: row.DeferralCode, DeferralNote: row.DeferralNote,
		DeferredAt: timeOf(row.DeferredAt), DeferredBy: row.DeferredBy,
		DeferredUntil: timeOf(row.DeferredUntil),
		RegisteredAt:  timeOf(row.RegisteredAt), RegisteredBy: row.RegisteredBy,
		Version: row.Version,
	}
}

// InsertScreening records a donor screening.
func (r DonorRepo) InsertScreening(ctx context.Context,
	scope authctx.TenantScope, s domain.Screening) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	screeningID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	donorID, err := uuid.Parse(s.DonorID)
	if err != nil {
		return notFound()
	}

	answers, err := json.Marshal(nonNilAnswers(s.Answers))
	if err != nil {
		return err
	}
	measurements, err := json.Marshal(nonNilMeasurements(s.Measurements))
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertScreening(ctx, sqlcgen.InsertScreeningParams{
		ScreeningID: screeningID, TenantID: tenantID, DonorID: donorID,
		Answers: answers, Measurements: measurements,
		Consented: s.Consented, ConsentNote: s.ConsentNote,
		Accepted:     s.Accepted,
		Deferral:     optionalText(string(s.Deferral)),
		DeferralCode: s.DeferralCode,
		ScreenedAt:   stamp(s.ScreenedAt), ScreenedBy: s.ScreenedBy,
	})
}

func nonNilAnswers(in map[string]string) map[string]string {
	if in == nil {
		return map[string]string{}
	}
	return in
}

func nonNilMeasurements(in map[string]float64) map[string]float64 {
	if in == nil {
		return map[string]float64{}
	}
	return in
}

// Screening reads one screening.
func (r DonorRepo) Screening(ctx context.Context, scope authctx.TenantScope,
	screeningID string) (domain.Screening, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Screening{}, err
	}
	id, err := uuid.Parse(screeningID)
	if err != nil {
		return domain.Screening{}, notFound()
	}

	row, err := r.queries(ctx).GetScreening(ctx, sqlcgen.GetScreeningParams{
		TenantID: tenantID, ScreeningID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Screening{}, notFound()
	}
	if err != nil {
		return domain.Screening{}, err
	}
	return screeningFrom(row)
}

// Screenings lists a donor's screenings, most recent first.
func (r DonorRepo) Screenings(ctx context.Context, scope authctx.TenantScope,
	donorID string, limit int32) ([]domain.Screening, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(donorID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListDonorScreenings(ctx,
		sqlcgen.ListDonorScreeningsParams{
			TenantID: tenantID, DonorID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Screening, 0, len(rows))
	for _, row := range rows {
		screening, err := screeningFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, screening)
	}
	return out, nil
}

func screeningFrom(row sqlcgen.BloodbankScreening) (domain.Screening, error) {
	answers := map[string]string{}
	if len(row.Answers) > 0 {
		if err := json.Unmarshal(row.Answers, &answers); err != nil {
			return domain.Screening{}, err
		}
	}
	measurements := map[string]float64{}
	if len(row.Measurements) > 0 {
		if err := json.Unmarshal(row.Measurements, &measurements); err != nil {
			return domain.Screening{}, err
		}
	}
	return domain.Screening{
		ID: row.ScreeningID.String(), TenantID: row.TenantID.String(),
		DonorID: row.DonorID.String(),
		Answers: answers, Measurements: measurements,
		Consented: row.Consented, ConsentNote: row.ConsentNote,
		Accepted:     row.Accepted,
		Deferral:     domain.DeferralKind(textOrEmpty(row.Deferral)),
		DeferralCode: row.DeferralCode,
		ScreenedAt:   timeOf(row.ScreenedAt), ScreenedBy: row.ScreenedBy,
	}, nil
}

// InsertCollection records a donation.
func (r DonorRepo) InsertCollection(ctx context.Context,
	scope authctx.TenantScope, c domain.Collection) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	collectionID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	donorID, err := uuid.Parse(c.DonorID)
	if err != nil {
		return notFound()
	}
	screeningID, err := uuid.Parse(c.ScreeningID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertCollection(ctx, sqlcgen.InsertCollectionParams{
		CollectionID: collectionID, TenantID: tenantID,
		DonorID: donorID, ScreeningID: screeningID,
		DonationNumber: c.DonationNumber, Kind: c.Kind,
		VolumeMl:    int32(c.VolumeML),
		Abo:         optionalText(string(c.Group.ABO)),
		Rhd:         optionalText(string(c.Group.Rh)),
		CollectedAt: stamp(c.CollectedAt), CollectedBy: c.CollectedBy,
		AdverseEvent: c.AdverseEvent, AdverseNote: c.AdverseNote,
	})
}

// Collection reads one donation.
func (r DonorRepo) Collection(ctx context.Context, scope authctx.TenantScope,
	collectionID string) (domain.Collection, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Collection{}, err
	}
	id, err := uuid.Parse(collectionID)
	if err != nil {
		return domain.Collection{}, notFound()
	}

	row, err := r.queries(ctx).GetCollection(ctx, sqlcgen.GetCollectionParams{
		TenantID: tenantID, CollectionID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Collection{}, notFound()
	}
	if err != nil {
		return domain.Collection{}, err
	}
	return domain.Collection{
		ID: row.CollectionID.String(), TenantID: row.TenantID.String(),
		DonorID: row.DonorID.String(), ScreeningID: row.ScreeningID.String(),
		DonationNumber: row.DonationNumber, Kind: row.Kind,
		VolumeML:    int(row.VolumeMl),
		Group:       nullableGroupOf(row.Abo, row.Rhd),
		CollectedAt: timeOf(row.CollectedAt), CollectedBy: row.CollectedBy,
		AdverseEvent: row.AdverseEvent, AdverseNote: row.AdverseNote,
	}, nil
}

// InsertTestResult records one mandatory test.
func (r DonorRepo) InsertTestResult(ctx context.Context,
	scope authctx.TenantScope, result domain.TestResult) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	testID, err := uuid.Parse(result.ID)
	if err != nil {
		return notFound()
	}
	collectionID, err := uuid.Parse(result.CollectionID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTestResult(ctx, sqlcgen.InsertTestResultParams{
		TestID: testID, TenantID: tenantID, CollectionID: collectionID,
		Code: result.Code, Display: result.Display,
		Reactive: result.Reactive, Value: result.Value, Method: result.Method,
		TestedAt: stamp(result.TestedAt), TestedBy: result.TestedBy,
	})
}

// TestResults reads a collection's test results.
func (r DonorRepo) TestResults(ctx context.Context, scope authctx.TenantScope,
	collectionID string) ([]domain.TestResult, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(collectionID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTestResults(ctx, sqlcgen.ListTestResultsParams{
		TenantID: tenantID, CollectionID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.TestResult, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.TestResult{
			ID: row.TestID.String(), TenantID: row.TenantID.String(),
			CollectionID: row.CollectionID.String(),
			Code:         row.Code, Display: row.Display,
			Reactive: row.Reactive, Value: row.Value, Method: row.Method,
			TestedAt: timeOf(row.TestedAt), TestedBy: row.TestedBy,
		})
	}
	return out, nil
}

var _ ports.DonorRepository = DonorRepo{}
