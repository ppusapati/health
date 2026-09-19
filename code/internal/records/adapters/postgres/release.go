package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// InsertRelease records a request for a patient's record (SRS-MRD-004).
func (r *Repository) InsertRelease(ctx context.Context,
	scope authctx.TenantScope, request domain.ReleaseRequest) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	releaseID, err := uuid.Parse(request.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_RELEASE_ID_INVALID",
			"release id must be a UUID")
	}

	return r.queries(ctx).InsertRecordsRelease(ctx,
		sqlcgen.InsertRecordsReleaseParams{
			ReleaseID: releaseID, TenantID: tenantID,
			Reference: request.Reference, PatientID: request.PatientID,
			Purpose:            request.Purpose,
			AuthorityKind:      string(request.Authorisation.Kind),
			AuthorityReference: request.Authorisation.Reference,
			AuthoritySignedBy:  request.Authorisation.SignedBy,
			AuthoritySignedAt:  stamp(request.Authorisation.SignedAt),
			AuthorityExpiresAt: stamp(request.Authorisation.ExpiresAt),
			RecipientKind:      string(request.Recipient.Kind),
			RecipientName:      request.Recipient.Name,
			RecipientReference: request.Recipient.Reference,
			DeliveryMethod:     request.Recipient.DeliveryMethod,
			ScopeFrom:          stamp(request.Scope.From),
			ScopeTo:            stamp(request.Scope.To),
			RecordClasses:      texts(request.Scope.RecordClasses),
			DocumentKinds:      texts(request.Scope.DocumentKinds),
			EncounterIds:       texts(request.Scope.EncounterIDs),
			WholeRecord:        request.Scope.WholeRecord,
			IncludeRestricted:  request.Scope.IncludeRestricted,
			State:              string(request.State),
			RequestedAt:        stamp(request.RequestedAt),
			RequestedBy:        request.RequestedBy,
		})
}

// Release reads one request and its package.
func (r *Repository) Release(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.ReleaseRequest, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ReleaseRequest{}, err
	}
	releaseID, err := uuid.Parse(id)
	if err != nil {
		return domain.ReleaseRequest{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsRelease(ctx,
		sqlcgen.GetRecordsReleaseParams{
			TenantID: tenantID, ReleaseID: releaseID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.ReleaseRequest{}, notFound()
	}
	if err != nil {
		return domain.ReleaseRequest{}, err
	}

	request := releaseFrom(row)
	items, err := r.releaseItems(ctx, tenantID, releaseID)
	if err != nil {
		return domain.ReleaseRequest{}, err
	}
	if len(items) > 0 || row.AssembledAt.Valid {
		request.Package = &domain.ReleasePackage{
			Items: items, ContentHash: row.ContentHash,
			Pages:       int(row.Pages),
			AssembledAt: timeOf(row.AssembledAt),
			AssembledBy: row.AssembledBy,
			ReleasedAt:  timeOf(row.ReleasedAt),
			ReleasedBy:  row.ReleasedBy,
		}
	}
	return request, nil
}

func (r *Repository) releaseItems(ctx context.Context,
	tenantID, releaseID uuid.UUID) ([]domain.ReleaseItem, error) {

	rows, err := r.queries(ctx).ListRecordsReleaseItems(ctx,
		sqlcgen.ListRecordsReleaseItemsParams{
			TenantID: tenantID, ReleaseID: releaseID,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.ReleaseItem, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.ReleaseItem{
			DocumentID: row.DocumentID, EncounterID: row.EncounterID,
			Kind: row.DocumentKind, RecordClass: row.RecordClass,
			OccurredAt: timeOf(row.OccurredAt), Restricted: row.Restricted,
			Pages: int(row.Pages),
		})
	}
	return out, nil
}

// UpdateRelease writes the request and, where one has been assembled, its
// package (SRS-MRD-004).
//
// The items are written on the transition into 'assembled' and never
// rewritten afterwards: a release record whose manifest changed after the
// package went cannot answer "what did we release".
func (r *Repository) UpdateRelease(ctx context.Context,
	scope authctx.TenantScope, request domain.ReleaseRequest,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	releaseID, err := uuid.Parse(request.ID)
	if err != nil {
		return notFound()
	}

	pack := request.Package
	if pack == nil {
		pack = &domain.ReleasePackage{}
	}

	queries := r.queries(ctx)
	rows, err := queries.UpdateRecordsRelease(ctx,
		sqlcgen.UpdateRecordsReleaseParams{
			State:         string(request.State),
			RefusalReason: request.RefusalReason,
			ApprovedAt:    stamp(request.ApprovedAt),
			ApprovedBy:    request.ApprovedBy,
			ContentHash:   pack.ContentHash, Pages: int32(pack.Pages),
			AssembledAt: stamp(pack.AssembledAt),
			AssembledBy: pack.AssembledBy,
			ReleasedAt:  stamp(pack.ReleasedAt),
			ReleasedBy:  pack.ReleasedBy,
			TenantID:    tenantID, ReleaseID: releaseID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if err := conflict(rows); err != nil {
		return err
	}

	if request.State != domain.ReleaseAssembled {
		return nil
	}
	for _, item := range pack.Items {
		if err := queries.InsertRecordsReleaseItem(ctx,
			sqlcgen.InsertRecordsReleaseItemParams{
				ItemID: uuid.New(), TenantID: tenantID,
				ReleaseID: releaseID, DocumentID: item.DocumentID,
				EncounterID: item.EncounterID, DocumentKind: item.Kind,
				RecordClass: item.RecordClass,
				OccurredAt:  stamp(item.OccurredAt),
				Restricted:  item.Restricted, Pages: int32(item.Pages),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Releases lists requests.
func (r *Repository) Releases(ctx context.Context,
	scope authctx.TenantScope, f ports.ReleaseFilter) (
	[]domain.ReleaseRequest, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListRecordsReleases(ctx,
		sqlcgen.ListRecordsReleasesParams{
			TenantID: tenantID, PatientID: f.PatientID, State: f.State,
			OpenOnly:      f.OpenOnly,
			RequestedFrom: stamp(from), RequestedTo: stamp(to),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.ReleaseRequest, 0, len(rows))
	for _, row := range rows {
		out = append(out, releaseFrom(row))
	}
	return out, nil
}

func releaseFrom(row sqlcgen.RecordsReleaseRequest) domain.ReleaseRequest {
	return domain.ReleaseRequest{
		ID: row.ReleaseID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, PatientID: row.PatientID,
		Purpose: row.Purpose,
		Authorisation: domain.Authorisation{
			Kind:      domain.AuthorityKind(row.AuthorityKind),
			Reference: row.AuthorityReference,
			SignedBy:  row.AuthoritySignedBy,
			SignedAt:  timeOf(row.AuthoritySignedAt),
			ExpiresAt: timeOf(row.AuthorityExpiresAt),
		},
		Recipient: domain.Recipient{
			Kind:           domain.RecipientKind(row.RecipientKind),
			Name:           row.RecipientName,
			Reference:      row.RecipientReference,
			DeliveryMethod: row.DeliveryMethod,
		},
		Scope: domain.ReleaseScope{
			From: timeOf(row.ScopeFrom), To: timeOf(row.ScopeTo),
			RecordClasses:     row.RecordClasses,
			DocumentKinds:     row.DocumentKinds,
			EncounterIDs:      row.EncounterIds,
			WholeRecord:       row.WholeRecord,
			IncludeRestricted: row.IncludeRestricted,
		},
		State:         domain.ReleaseState(row.State),
		RefusalReason: row.RefusalReason,
		RequestedAt:   timeOf(row.RequestedAt),
		RequestedBy:   row.RequestedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		ApprovedBy:    row.ApprovedBy,
		Version:       row.Version,
	}
}

// InsertDisclosure notes a record leaving (SRS-MRD-010).
func (r *Repository) InsertDisclosure(ctx context.Context,
	scope authctx.TenantScope, d domain.Disclosure) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	disclosureID, err := uuid.Parse(d.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_DISCLOSURE_ID_INVALID",
			"disclosure id must be a UUID")
	}

	return r.queries(ctx).InsertRecordsDisclosure(ctx,
		sqlcgen.InsertRecordsDisclosureParams{
			DisclosureID: disclosureID, TenantID: tenantID,
			PatientID: d.PatientID, Kind: string(d.Kind),
			ReleaseID: optionalUUID(d.ReleaseID), ActorID: d.ActorID,
			Purpose: d.Purpose, ScopeSummary: d.ScopeSummary,
			RecipientReference: d.RecipientReference,
			RecipientName:      d.RecipientName,
			Items:              int32(d.Items), Pages: int32(d.Pages),
			OccurredAt: stamp(d.OccurredAt),
		})
}

// Disclosures answers "who has seen my record" (SRS-MRD-010).
func (r *Repository) Disclosures(ctx context.Context,
	scope authctx.TenantScope, f ports.DisclosureFilter) (
	[]domain.Disclosure, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListRecordsDisclosures(ctx,
		sqlcgen.ListRecordsDisclosuresParams{
			TenantID: tenantID, PatientID: f.PatientID, ActorID: f.ActorID,
			OccurredFrom: stamp(from), OccurredTo: stamp(to),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Disclosure, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Disclosure{
			ID: row.DisclosureID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID,
			Kind:      domain.DisclosureKind(row.Kind),
			ReleaseID: uuidString(row.ReleaseID), ActorID: row.ActorID,
			Purpose: row.Purpose, ScopeSummary: row.ScopeSummary,
			RecipientReference: row.RecipientReference,
			RecipientName:      row.RecipientName,
			Items:              int(row.Items), Pages: int(row.Pages),
			OccurredAt: timeOf(row.OccurredAt),
		})
	}
	return out, nil
}
