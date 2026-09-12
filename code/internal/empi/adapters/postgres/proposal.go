package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Proposed demographic changes (SRS-EMPI-012, SRS-EMPI-017).

// ProposalRepo implements the proposal repository port.
type ProposalRepo struct{ *Repository }

var _ ports.ProposalRepository = ProposalRepo{}

// Raise stores a proposal and its fields in the caller's transaction.
//
// Both statements together: a proposal with no fields is an empty queue item
// nobody can act on, and fields with no proposal are orphans the worklist never
// shows.
func (r ProposalRepo) Raise(ctx context.Context, scope authctx.TenantScope, p domain.Proposal) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	proposalID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_PROPOSAL_ID_INVALID", "proposal_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(p.PatientID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	q := r.queries(ctx)
	if err := q.InsertDemographicProposal(ctx, sqlcgen.InsertDemographicProposalParams{
		ProposalID: proposalID, TenantID: tenantID, PatientID: patientID,
		Origin: string(p.Origin), Source: p.Source, ProposedBy: p.ProposedBy,
		Reason: p.Reason, Status: string(p.Status),
		PatientVersion: p.PatientVersion, ProposedAt: timestamptz(p.ProposedAt),
	}); err != nil {
		return err
	}

	for _, f := range p.Fields {
		if err := q.InsertDemographicProposalField(ctx, sqlcgen.InsertDemographicProposalFieldParams{
			ProposalID: proposalID, TenantID: tenantID, Field: string(f.Field),
			CurrentValue: f.CurrentValue, ProposedValue: f.ProposedValue,
		}); err != nil {
			return err
		}
	}
	return nil
}

// Get reads one proposal with its fields.
func (r ProposalRepo) Get(ctx context.Context, scope authctx.TenantScope,
	proposalID string) (domain.Proposal, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Proposal{}, err
	}
	id, err := uuid.Parse(proposalID)
	if err != nil {
		return domain.Proposal{}, notFound()
	}

	row, err := r.queries(ctx).GetDemographicProposal(ctx, sqlcgen.GetDemographicProposalParams{
		TenantID: tenantID, ProposalID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Proposal{}, notFound()
	}
	if err != nil {
		return domain.Proposal{}, err
	}

	p := proposalFromRow(sqlcgen.EmpiDemographicProposal(row))
	fields, err := r.fieldsFor(ctx, tenantID, []uuid.UUID{id})
	if err != nil {
		return domain.Proposal{}, err
	}
	p.Fields = fields[p.ID]
	return p, nil
}

// OpenForSource returns the open proposal a source already holds, if any.
func (r ProposalRepo) OpenForSource(ctx context.Context, scope authctx.TenantScope,
	patientID, source string) (domain.Proposal, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Proposal{}, false, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return domain.Proposal{}, false, notFound()
	}

	row, err := r.queries(ctx).FindOpenProposalBySource(ctx, sqlcgen.FindOpenProposalBySourceParams{
		TenantID: tenantID, PatientID: id, Source: source,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Proposal{}, false, nil
	}
	if err != nil {
		return domain.Proposal{}, false, err
	}

	p := proposalFromRow(sqlcgen.EmpiDemographicProposal(row))
	fields, err := r.fieldsFor(ctx, tenantID, []uuid.UUID{uuid.MustParse(p.ID)})
	if err != nil {
		return domain.Proposal{}, false, err
	}
	p.Fields = fields[p.ID]
	return p, true, nil
}

// ListOpen returns the reconciliation worklist.
func (r ProposalRepo) ListOpen(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.Proposal, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListOpenDemographicProposals(ctx,
		sqlcgen.ListOpenDemographicProposalsParams{TenantID: tenantID, PageLimit: limit})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Proposal, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, proposalFromRow(sqlcgen.EmpiDemographicProposal(row)))
		ids = append(ids, row.ProposalID)
	}
	return r.attachFields(ctx, tenantID, out, ids)
}

// ForPatient returns everything ever proposed about one patient.
func (r ProposalRepo) ForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string, limit int32) ([]domain.Proposal, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListProposalsForPatient(ctx, sqlcgen.ListProposalsForPatientParams{
		TenantID: tenantID, PatientID: id, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Proposal, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, proposalFromRow(sqlcgen.EmpiDemographicProposal(row)))
		ids = append(ids, row.ProposalID)
	}
	return r.attachFields(ctx, tenantID, out, ids)
}

// Resolve records the decision and the per-field outcomes.
func (r ProposalRepo) Resolve(ctx context.Context, scope authctx.TenantScope, p domain.Proposal) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	proposalID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	// The header first, guarded on status = 'open'. Two reviewers deciding at
	// once would otherwise both write, and the second would silently replace
	// the first one's decision and note.
	rows, err := q.ResolveDemographicProposal(ctx, sqlcgen.ResolveDemographicProposalParams{
		TenantID: tenantID, ProposalID: proposalID,
		Status: string(p.Status), ResolvedAt: timestamptz(p.ResolvedAt),
		ResolvedBy: p.ResolvedBy, ResolutionNote: p.ResolutionNote,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}

	for _, f := range p.Fields {
		if f.Accepted == nil {
			continue
		}
		if err := q.SetProposalFieldDecision(ctx, sqlcgen.SetProposalFieldDecisionParams{
			TenantID: tenantID, ProposalID: proposalID,
			Field: string(f.Field), Accepted: f.Accepted,
		}); err != nil {
			return err
		}
	}
	return nil
}

// SupersedeStale closes proposals whose comparison no longer holds.
func (r ProposalRepo) SupersedeStale(ctx context.Context, scope authctx.TenantScope,
	patientID string, currentVersion int64, by string, at time.Time) (int64, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return 0, notFound()
	}

	return r.queries(ctx).SupersedeOpenProposalsForPatient(ctx,
		sqlcgen.SupersedeOpenProposalsForPatientParams{
			TenantID: tenantID, PatientID: id,
			PatientVersion: currentVersion,
			ResolvedAt:     timestamptz(at), ResolvedBy: by,
		})
}

// attachFields loads the field rows for a page of proposals in one query.
func (r ProposalRepo) attachFields(ctx context.Context, tenantID uuid.UUID,
	proposals []domain.Proposal, ids []uuid.UUID) ([]domain.Proposal, error) {

	if len(proposals) == 0 {
		return proposals, nil
	}
	fields, err := r.fieldsFor(ctx, tenantID, ids)
	if err != nil {
		return nil, err
	}
	for i := range proposals {
		proposals[i].Fields = fields[proposals[i].ID]
	}
	return proposals, nil
}

func (r ProposalRepo) fieldsFor(ctx context.Context, tenantID uuid.UUID,
	ids []uuid.UUID) (map[string][]domain.FieldProposal, error) {

	out := map[string][]domain.FieldProposal{}
	if len(ids) == 0 {
		return out, nil
	}

	rows, err := r.queries(ctx).ListProposalFields(ctx, sqlcgen.ListProposalFieldsParams{
		TenantID: tenantID, ProposalIds: ids,
	})
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		id := row.ProposalID.String()
		out[id] = append(out[id], domain.FieldProposal{
			Field:         domain.Field(row.Field),
			CurrentValue:  row.CurrentValue,
			ProposedValue: row.ProposedValue,
			Accepted:      row.Accepted,
		})
	}
	return out, nil
}

func proposalFromRow(row sqlcgen.EmpiDemographicProposal) domain.Proposal {
	p := domain.Proposal{
		ID: row.ProposalID.String(), PatientID: row.PatientID.String(),
		Origin: domain.ProposalOrigin(row.Origin), Source: row.Source,
		ProposedBy: row.ProposedBy, Reason: row.Reason,
		Status:         domain.ProposalStatus(row.Status),
		PatientVersion: row.PatientVersion,
		ProposedAt:     row.ProposedAt.Time.UTC(),
		ResolvedBy:     row.ResolvedBy, ResolutionNote: row.ResolutionNote,
	}
	if row.ResolvedAt.Valid {
		p.ResolvedAt = row.ResolvedAt.Time.UTC()
	}
	return p
}
