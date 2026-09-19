// Package postgres is the quality persistence adapter.
//
// It is the only package permitted to issue SQL against the quality schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
//
// There is no delete anywhere in this package. SRS-QMS-015 requires these
// records be preserved subject to retention and legal hold, and a surface with
// no DELETE on it is a stronger guarantee than a policy somebody reads once.
// Withdrawal, revocation and obsolescence are all writes that keep the row.
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// Repository implements the quality repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("QMS_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("QMS_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("QMS_NOT_FOUND", "no such quality record")
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

// texts renders a string slice for a NOT NULL array column.
//
// A nil slice is written as NULL, not as an empty array, and every array
// column in this schema is NOT NULL — so a committee with no agenda yet, or a
// meeting nobody sent apologies for, would be refused by the database for a
// reason that has nothing to do with the record.
func texts(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

func uuidStrings(ids []uuid.UUID) []string {
	out := make([]string, 0, len(ids))
	for _, id := range ids {
		out = append(out, id.String())
	}
	return out
}

// parseUUIDs renders an id list for a NOT NULL uuid[] column, and never
// returns nil for the same reason texts does not.
func parseUUIDs(ids []string) []uuid.UUID {
	out := make([]uuid.UUID, 0, len(ids))
	for _, id := range ids {
		parsed, err := uuid.Parse(id)
		if err != nil {
			continue
		}
		out = append(out, parsed)
	}
	return out
}

func encode(value any) ([]byte, error) {
	raw, err := json.Marshal(value)
	if err != nil {
		return nil, rpcerr.Internal("QMS_ENCODE_FAILED",
			"could not encode a quality record").WithCause(err)
	}
	return raw, nil
}

func decode[T any](raw []byte, out *T) error {
	if len(raw) == 0 {
		return nil
	}
	if err := json.Unmarshal(raw, out); err != nil {
		return rpcerr.Internal("QMS_DECODE_FAILED",
			"could not decode a quality record").WithCause(err)
	}
	return nil
}

// IncidentRepo implements ports.IncidentRepository.
type IncidentRepo struct{ *Repository }

var _ ports.IncidentRepository = IncidentRepo{}

// InsertIncident records a reported event or near miss (SRS-QMS-001).
func (r IncidentRepo) InsertIncident(ctx context.Context,
	scope authctx.TenantScope, i domain.Incident) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	incidentID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityIncident(ctx,
		sqlcgen.InsertQualityIncidentParams{
			IncidentID: incidentID, TenantID: tenantID,
			Reference: i.Reference, Category: i.Category,
			Subcategory: i.Subcategory,
			Reach:       string(i.Reach), Harm: string(i.Harm),
			Consequence: string(i.Risk.Consequence),
			Likelihood:  string(i.Risk.Likelihood),
			RiskScore:   int32(i.Risk.Score), RiskBand: string(i.Risk.Band),
			PatientID: i.PatientID, EncounterID: i.EncounterID,
			AssetID: i.AssetID, LocationID: i.LocationID,
			FacilityID: i.FacilityID, Department: i.Department,
			Narrative: i.Narrative, ImmediateAction: i.ImmediateAction,
			Sentinel: i.Sentinel, Restricted: i.Restricted,
			Anonymous: i.Anonymous, State: string(i.State),
			OccurredAt: stamp(i.OccurredAt), ReportedAt: stamp(i.ReportedAt),
			ReportedBy: i.ReportedBy,
		})
}

// Incident reads one report.
func (r IncidentRepo) Incident(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Incident, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Incident{}, err
	}
	incidentID, err := uuid.Parse(id)
	if err != nil {
		return domain.Incident{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityIncident(ctx,
		sqlcgen.GetQualityIncidentParams{
			TenantID: tenantID, IncidentID: incidentID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Incident{}, notFound()
	}
	if err != nil {
		return domain.Incident{}, err
	}
	return incidentFrom(row), nil
}

// UpdateIncident writes a review decision (SRS-QMS-002).
func (r IncidentRepo) UpdateIncident(ctx context.Context,
	scope authctx.TenantScope, i domain.Incident, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	incidentID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityIncident(ctx,
		sqlcgen.UpdateQualityIncidentParams{
			TenantID: tenantID, IncidentID: incidentID,
			Consequence: string(i.Risk.Consequence),
			Likelihood:  string(i.Risk.Likelihood),
			RiskScore:   int32(i.Risk.Score), RiskBand: string(i.Risk.Band),
			Restricted: i.Restricted, Sentinel: i.Sentinel,
			State: string(i.State), ReviewedBy: i.ReviewedBy,
			ReviewedAt: stamp(i.ReviewedAt),
			ClosedBy:   i.ClosedBy, ClosedAt: stamp(i.ClosedAt),
			ClosureReason: i.ClosureReason, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Incidents lists reports.
func (r IncidentRepo) Incidents(ctx context.Context, scope authctx.TenantScope,
	f ports.IncidentFilter) ([]domain.Incident, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	from, to := f.From, f.To
	if from.IsZero() {
		from = epoch
	}
	if to.IsZero() {
		to = farFuture
	}

	rows, err := r.queries(ctx).ListQualityIncidents(ctx,
		sqlcgen.ListQualityIncidentsParams{
			TenantID: tenantID, Category: f.Category, State: f.State,
			OpenOnly: f.OpenOnly, SentinelOnly: f.SentinelOnly,
			FromAt: stamp(from), ToAt: stamp(to), RowLimit: f.Limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Incident, 0, len(rows))
	for _, row := range rows {
		out = append(out, incidentFrom(row))
	}
	return out, nil
}

// ForPatient answers what has happened to one person here.
func (r IncidentRepo) ForPatient(ctx context.Context,
	scope authctx.TenantScope, patientID string, limit int32) (
	[]domain.Incident, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityIncidentsForPatient(ctx,
		sqlcgen.ListQualityIncidentsForPatientParams{
			TenantID: tenantID, PatientID: patientID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Incident, 0, len(rows))
	for _, row := range rows {
		out = append(out, incidentFrom(row))
	}
	return out, nil
}

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as a
// NULL timestamp and excludes every row, which reads as "there are no
// incidents" — the one answer a quality system must never give by accident.
var (
	epoch     = time.Date(1970, 1, 1, 0, 0, 0, 0, time.UTC)
	farFuture = time.Date(2200, 1, 1, 0, 0, 0, 0, time.UTC)
)

func incidentFrom(row sqlcgen.QualityIncident) domain.Incident {
	return domain.Incident{
		ID: row.IncidentID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Category: row.Category,
		Subcategory: row.Subcategory,
		Reach:       domain.Reach(row.Reach), Harm: domain.Harm(row.Harm),
		Risk: domain.Risk{
			Consequence: domain.Consequence(row.Consequence),
			Likelihood:  domain.Likelihood(row.Likelihood),
			Score:       int(row.RiskScore),
			Band:        domain.RiskBand(row.RiskBand),
		},
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		AssetID: row.AssetID, LocationID: row.LocationID,
		FacilityID: row.FacilityID, Department: row.Department,
		Narrative: row.Narrative, ImmediateAction: row.ImmediateAction,
		Sentinel: row.Sentinel, Restricted: row.Restricted,
		Anonymous: row.Anonymous, State: domain.IncidentState(row.State),
		OccurredAt: timeOf(row.OccurredAt), ReportedAt: timeOf(row.ReportedAt),
		ReportedBy: row.ReportedBy,
		ReviewedBy: row.ReviewedBy, ReviewedAt: timeOf(row.ReviewedAt),
		ClosedBy: row.ClosedBy, ClosedAt: timeOf(row.ClosedAt),
		ClosureReason: row.ClosureReason,
		Version:       row.Version,
	}
}
