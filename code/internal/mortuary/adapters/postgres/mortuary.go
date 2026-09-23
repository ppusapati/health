package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgconn"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// uniqueViolation is PostgreSQL's SQLSTATE for a duplicate key.
const uniqueViolation = "23505"

// --------------------------------------------------- storage (SRS-MORT-002)

var _ ports.StorageRepository = (*Repository)(nil)

func locationFrom(row sqlcgen.MortuaryLocation) domain.Location {
	return domain.Location{
		ID: row.LocationID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Kind: domain.SpaceKind(row.Kind),
		FacilityID: uuidString(row.FacilityID), Zone: row.Zone,
		OutOfService:       row.OutOfService,
		OutOfServiceReason: row.OutOfServiceReason,
		CreatedAt:          timeOf(row.CreatedAt),
		CreatedBy:          row.CreatedBy, Version: row.Version,
	}
}

// InsertLocation implements ports.StorageRepository.
func (r *Repository) InsertLocation(ctx context.Context,
	scope authctx.TenantScope, l domain.Location) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertMortuaryLocation(ctx,
		sqlcgen.InsertMortuaryLocationParams{
			LocationID: id, TenantID: tenantID, Code: l.Code,
			Kind: string(l.Kind), FacilityID: optionalUUID(l.FacilityID),
			Zone: l.Zone, OutOfService: l.OutOfService,
			OutOfServiceReason: l.OutOfServiceReason,
			CreatedAt:          stamp(l.CreatedAt), CreatedBy: l.CreatedBy,
			Version: l.Version,
		})
}

// Location implements ports.StorageRepository.
func (r *Repository) Location(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Location, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Location{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Location{}, notFound()
	}

	row, err := r.queries(ctx).GetMortuaryLocation(ctx,
		sqlcgen.GetMortuaryLocationParams{
			TenantID: tenantID, LocationID: parsed,
		})
	if isNoRows(err) {
		return domain.Location{}, notFound()
	}
	if err != nil {
		return domain.Location{}, err
	}
	return locationFrom(row), nil
}

// UpdateLocation implements ports.StorageRepository.
func (r *Repository) UpdateLocation(ctx context.Context,
	scope authctx.TenantScope, l domain.Location,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateMortuaryLocation(ctx,
		sqlcgen.UpdateMortuaryLocationParams{
			TenantID: tenantID, LocationID: id,
			OutOfService:       l.OutOfService,
			OutOfServiceReason: l.OutOfServiceReason,
			ExpectedVersion:    expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Locations implements ports.StorageRepository.
func (r *Repository) Locations(ctx context.Context,
	scope authctx.TenantScope, f ports.LocationFilter) (
	[]domain.Location, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	kinds := make([]string, 0, len(f.Kinds))
	for _, kind := range f.Kinds {
		kinds = append(kinds, string(kind))
	}

	rows, err := r.queries(ctx).ListMortuaryLocations(ctx,
		sqlcgen.ListMortuaryLocationsParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			Kinds: texts(kinds), InServiceOnly: f.InServiceOnly,
			RowLimit: limit, RowOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Location, 0, len(rows))
	for _, row := range rows {
		out = append(out, locationFrom(row))
	}
	return out, nil
}

func placementFrom(row sqlcgen.MortuaryPlacement) domain.Placement {
	return domain.Placement{
		ID: row.PlacementID.String(), TenantID: row.TenantID.String(),
		CaseID: row.CaseID.String(), LocationID: row.LocationID.String(),
		StorageTag:          row.StorageTag,
		State:               domain.PlacementState(row.State),
		IdentityCheckedBy:   row.IdentityCheckedBy,
		IdentityCheckedNote: row.IdentityCheckedNote,
		PlacedAt:            timeOf(row.PlacedAt), PlacedBy: row.PlacedBy,
		EndedAt: timeOf(row.EndedAt), EndedBy: row.EndedBy,
		EndedReason: row.EndedReason,
	}
}

// InsertPlacement implements ports.StorageRepository.
func (r *Repository) InsertPlacement(ctx context.Context,
	scope authctx.TenantScope, p domain.Placement) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(p.CaseID)
	if err != nil {
		return notFound()
	}
	locationID, err := uuid.Parse(p.LocationID)
	if err != nil {
		return notFound()
	}

	// The unique indexes are the rule; this turns their violation into
	// something the person at the drawer can act on. "Internal error" tells
	// an attendant nothing, and the thing they need to know is that the
	// space or the tag is already taken.
	err = r.queries(ctx).InsertPlacement(ctx,
		sqlcgen.InsertPlacementParams{
			PlacementID: id, TenantID: tenantID, CaseID: caseID,
			LocationID: locationID, StorageTag: p.StorageTag,
			State:               string(p.State),
			IdentityCheckedBy:   p.IdentityCheckedBy,
			IdentityCheckedNote: p.IdentityCheckedNote,
			PlacedAt:            stamp(p.PlacedAt), PlacedBy: p.PlacedBy,
			EndedAt: stamp(p.EndedAt), EndedBy: p.EndedBy,
			EndedReason: p.EndedReason,
		})
	return placementConflict(err)
}

// placementConflict names which of the three "one at a time" rules a write
// broke, so the refusal says what to do rather than that something went
// wrong.
func placementConflict(err error) error {
	if err == nil {
		return nil
	}
	var violation *pgconn.PgError
	if !errors.As(err, &violation) ||
		violation.Code != uniqueViolation {
		return err
	}
	switch violation.ConstraintName {
	case "placement_one_body_per_space_idx":
		return rpcerr.FailedPrecondition("MORT_SPACE_OCCUPIED",
			"there is already a body in that space")
	case "placement_one_space_per_body_idx":
		return rpcerr.FailedPrecondition("MORT_ALREADY_PLACED",
			"this body is already in a space; move it rather than "+
				"placing it again")
	case "placement_tag_idx":
		return rpcerr.FailedPrecondition("MORT_TAG_IN_USE",
			"that storage tag is on another body")
	}
	return err
}

// CurrentPlacement implements ports.StorageRepository.
func (r *Repository) CurrentPlacement(ctx context.Context,
	scope authctx.TenantScope, caseID string) (domain.Placement, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Placement{}, err
	}
	parsed, err := uuid.Parse(caseID)
	if err != nil {
		return domain.Placement{}, notFound()
	}

	row, err := r.queries(ctx).GetCurrentPlacement(ctx,
		sqlcgen.GetCurrentPlacementParams{
			TenantID: tenantID, CaseID: parsed,
		})
	if isNoRows(err) {
		return domain.Placement{}, notFound()
	}
	if err != nil {
		return domain.Placement{}, err
	}
	return placementFrom(row), nil
}

// EndPlacement implements ports.StorageRepository.
//
// Takes no version: the row is identified by being the current one, so two
// writers closing the same placement means one of them gets no rows rather
// than a lost update.
func (r *Repository) EndPlacement(ctx context.Context,
	scope authctx.TenantScope, p domain.Placement) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).EndPlacement(ctx,
		sqlcgen.EndPlacementParams{
			TenantID: tenantID, PlacementID: id,
			EndedAt: stamp(p.EndedAt), EndedBy: p.EndedBy,
			EndedReason: p.EndedReason,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Placements implements ports.StorageRepository.
func (r *Repository) Placements(ctx context.Context,
	scope authctx.TenantScope, ids []string) ([]domain.Placement, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListPlacements(ctx,
		sqlcgen.ListPlacementsParams{
			TenantID: tenantID, CaseIds: caseIDs(ids),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Placement, 0, len(rows))
	for _, row := range rows {
		out = append(out, placementFrom(row))
	}
	return out, nil
}

// OccupiedLocations implements ports.StorageRepository.
//
// Identifiers only. A board counting free spaces does not need to know who is
// in which drawer, and a query that returned it would put that on a screen.
func (r *Repository) OccupiedLocations(ctx context.Context,
	scope authctx.TenantScope) (map[string]bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListCurrentPlacements(ctx,
		sqlcgen.ListCurrentPlacementsParams{
			TenantID: tenantID, RowLimit: 5000,
		})
	if err != nil {
		return nil, err
	}
	out := make(map[string]bool, len(rows))
	for _, row := range rows {
		out[row.LocationID.String()] = true
	}
	return out, nil
}

// ------------------------------------------------ belongings (SRS-MORT-004)

var _ ports.CustodyRepository = (*Repository)(nil)

func itemFrom(row sqlcgen.MortuaryBelonging) domain.Item {
	return domain.Item{
		ID: row.ItemID.String(), TenantID: row.TenantID.String(),
		CaseID: row.CaseID.String(), Kind: domain.ItemKind(row.Kind),
		Description: row.Description, Quantity: int(row.Quantity),
		State: domain.ItemState(row.State), SealNumber: row.SealNumber,
		ListedAt: timeOf(row.ListedAt), ListedBy: row.ListedBy,
		WitnessedBy: row.WitnessedBy,
		HandoverID:  uuidString(row.HandoverID),
	}
}

// InsertItem implements ports.CustodyRepository.
func (r *Repository) InsertItem(ctx context.Context,
	scope authctx.TenantScope, i domain.Item) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(i.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertBelonging(ctx,
		sqlcgen.InsertBelongingParams{
			ItemID: id, TenantID: tenantID, CaseID: caseID,
			Kind: string(i.Kind), Description: i.Description,
			Quantity: int32(i.Quantity), State: string(i.State),
			SealNumber: i.SealNumber,
			ListedAt:   stamp(i.ListedAt), ListedBy: i.ListedBy,
			WitnessedBy: i.WitnessedBy,
			HandoverID:  optionalUUID(i.HandoverID),
		})
}

// Item implements ports.CustodyRepository.
func (r *Repository) Item(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Item, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Item{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Item{}, notFound()
	}

	row, err := r.queries(ctx).GetBelonging(ctx,
		sqlcgen.GetBelongingParams{TenantID: tenantID, ItemID: parsed})
	if isNoRows(err) {
		return domain.Item{}, notFound()
	}
	if err != nil {
		return domain.Item{}, err
	}
	return itemFrom(row), nil
}

// UpdateItemState implements ports.CustodyRepository.
func (r *Repository) UpdateItemState(ctx context.Context,
	scope authctx.TenantScope, i domain.Item,
	expectedState domain.ItemState) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateBelongingState(ctx,
		sqlcgen.UpdateBelongingStateParams{
			TenantID: tenantID, ItemID: id, State: string(i.State),
			HandoverID:    optionalUUID(i.HandoverID),
			ExpectedState: string(expectedState),
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Items implements ports.CustodyRepository.
func (r *Repository) Items(ctx context.Context, scope authctx.TenantScope,
	ids []string) ([]domain.Item, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListBelongings(ctx,
		sqlcgen.ListBelongingsParams{
			TenantID: tenantID, CaseIds: caseIDs(ids),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Item, 0, len(rows))
	for _, row := range rows {
		out = append(out, itemFrom(row))
	}
	return out, nil
}

// InsertHandover implements ports.CustodyRepository.
func (r *Repository) InsertHandover(ctx context.Context,
	scope authctx.TenantScope, h domain.Handover) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(h.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(h.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertMortuaryHandover(ctx,
		sqlcgen.InsertMortuaryHandoverParams{
			HandoverID: id, TenantID: tenantID, CaseID: caseID,
			RecipientName:     h.RecipientName,
			RecipientRelation: h.RecipientRelation,
			RecipientIDType:   h.RecipientIDType,
			RecipientIDRef:    h.RecipientIDRef,
			SignatureRef:      h.SignatureRef,
			HandedAt:          stamp(h.HandedAt), HandedBy: h.HandedBy,
			WitnessedBy: h.WitnessedBy, Note: h.Note,
		})
}

// Handovers implements ports.CustodyRepository.
func (r *Repository) Handovers(ctx context.Context,
	scope authctx.TenantScope, caseID string) ([]domain.Handover, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListMortuaryHandovers(ctx,
		sqlcgen.ListMortuaryHandoversParams{
			TenantID: tenantID, CaseID: parsed,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Handover, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Handover{
			ID: row.HandoverID.String(), TenantID: row.TenantID.String(),
			CaseID:            row.CaseID.String(),
			RecipientName:     row.RecipientName,
			RecipientRelation: row.RecipientRelation,
			RecipientIDType:   row.RecipientIDType,
			RecipientIDRef:    row.RecipientIDRef,
			SignatureRef:      row.SignatureRef,
			HandedAt:          timeOf(row.HandedAt),
			HandedBy:          row.HandedBy,
			WitnessedBy:       row.WitnessedBy, Note: row.Note,
		})
	}
	return out, nil
}

// AppendCustody implements ports.CustodyRepository.
//
// An insert, always. There is no method that changes one (FIT-08).
func (r *Repository) AppendCustody(ctx context.Context,
	scope authctx.TenantScope, e domain.CustodyEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(e.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertCustodyEntry(ctx,
		sqlcgen.InsertCustodyEntryParams{
			EntryID: id, TenantID: tenantID, CaseID: caseID,
			Event: e.Event, Detail: e.Detail,
			FromParty: e.FromParty, ToParty: e.ToParty,
			RecordedAt: stamp(e.RecordedAt), RecordedBy: e.RecordedBy,
		})
}

// Custody implements ports.CustodyRepository.
func (r *Repository) Custody(ctx context.Context,
	scope authctx.TenantScope, caseID string) (
	[]domain.CustodyEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListCustodyEntries(ctx,
		sqlcgen.ListCustodyEntriesParams{
			TenantID: tenantID, CaseID: parsed,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.CustodyEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.CustodyEntry{
			ID: row.EntryID.String(), TenantID: row.TenantID.String(),
			CaseID: row.CaseID.String(), Event: row.Event,
			Detail: row.Detail, FromParty: row.FromParty,
			ToParty:    row.ToParty,
			RecordedAt: timeOf(row.RecordedAt),
			RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

// ------------------------------------------------ postmortem (SRS-MORT-005)

var _ ports.PostmortemRepository = (*Repository)(nil)

func postmortemFrom(row sqlcgen.MortuaryPostmortem) domain.Postmortem {
	return domain.Postmortem{
		ID: row.PostmortemID.String(), TenantID: row.TenantID.String(),
		CaseID: row.CaseID.String(),
		Kind:   domain.PostmortemKind(row.Kind), Reason: row.Reason,
		State:              domain.PostmortemState(row.State),
		Authority:          row.Authority,
		AuthorityReference: row.AuthorityReference,
		AuthorisedBy:       row.AuthorisedBy,
		AuthorisedAt:       timeOf(row.AuthorisedAt),
		PerformedBy:        row.PerformedBy,
		PerformedAt:        timeOf(row.PerformedAt),
		ReportRef:          row.ReportRef,
		ReportedAt:         timeOf(row.ReportedAt),
		DeclineReason:      row.DeclineReason,
		RequestedAt:        timeOf(row.RequestedAt),
		RequestedBy:        row.RequestedBy, Version: row.Version,
	}
}

// InsertPostmortem implements ports.PostmortemRepository.
func (r *Repository) InsertPostmortem(ctx context.Context,
	scope authctx.TenantScope, p domain.Postmortem) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(p.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertPostmortem(ctx,
		sqlcgen.InsertPostmortemParams{
			PostmortemID: id, TenantID: tenantID, CaseID: caseID,
			Kind: string(p.Kind), Reason: p.Reason,
			State: string(p.State), Authority: p.Authority,
			AuthorityReference: p.AuthorityReference,
			AuthorisedBy:       p.AuthorisedBy,
			AuthorisedAt:       stamp(p.AuthorisedAt),
			PerformedBy:        p.PerformedBy,
			PerformedAt:        stamp(p.PerformedAt),
			ReportRef:          p.ReportRef,
			ReportedAt:         stamp(p.ReportedAt),
			DeclineReason:      p.DeclineReason,
			RequestedAt:        stamp(p.RequestedAt),
			RequestedBy:        p.RequestedBy, Version: p.Version,
		})
}

// Postmortem implements ports.PostmortemRepository.
func (r *Repository) Postmortem(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Postmortem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Postmortem{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Postmortem{}, notFound()
	}

	row, err := r.queries(ctx).GetPostmortem(ctx,
		sqlcgen.GetPostmortemParams{
			TenantID: tenantID, PostmortemID: parsed,
		})
	if isNoRows(err) {
		return domain.Postmortem{}, notFound()
	}
	if err != nil {
		return domain.Postmortem{}, err
	}
	return postmortemFrom(row), nil
}

// UpdatePostmortem implements ports.PostmortemRepository.
func (r *Repository) UpdatePostmortem(ctx context.Context,
	scope authctx.TenantScope, p domain.Postmortem,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdatePostmortem(ctx,
		sqlcgen.UpdatePostmortemParams{
			TenantID: tenantID, PostmortemID: id, State: string(p.State),
			Authority:          p.Authority,
			AuthorityReference: p.AuthorityReference,
			AuthorisedBy:       p.AuthorisedBy,
			AuthorisedAt:       stamp(p.AuthorisedAt),
			PerformedBy:        p.PerformedBy,
			PerformedAt:        stamp(p.PerformedAt),
			ReportRef:          p.ReportRef,
			ReportedAt:         stamp(p.ReportedAt),
			DeclineReason:      p.DeclineReason,
			ExpectedVersion:    expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Postmortems implements ports.PostmortemRepository.
func (r *Repository) Postmortems(ctx context.Context,
	scope authctx.TenantScope, ids []string) ([]domain.Postmortem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListPostmortems(ctx,
		sqlcgen.ListPostmortemsParams{
			TenantID: tenantID, CaseIds: caseIDs(ids),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Postmortem, 0, len(rows))
	for _, row := range rows {
		out = append(out, postmortemFrom(row))
	}
	return out, nil
}

// --------------------------------------------------- release (SRS-MORT-006)

var _ ports.ReleaseRepository = (*Repository)(nil)

// InsertAuthorisation implements ports.ReleaseRepository.
func (r *Repository) InsertAuthorisation(ctx context.Context,
	scope authctx.TenantScope, id, caseID string,
	a domain.Authorisation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return notFound()
	}
	parsedCase, err := uuid.Parse(caseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAuthorisation(ctx,
		sqlcgen.InsertAuthorisationParams{
			AuthorisationID: parsed, TenantID: tenantID,
			CaseID: parsedCase, Authority: a.Authority,
			Reference:  a.Reference,
			RecordedAt: stamp(a.RecordedAt), RecordedBy: a.RecordedBy,
			Note: a.Note,
		})
}

// LatestAuthorisation implements ports.ReleaseRepository.
//
// No clearance is an answer rather than an error: it is the answer the
// release checks act on, and turning it into a failure would stop a mortuary
// seeing why a body cannot go.
func (r *Repository) LatestAuthorisation(ctx context.Context,
	scope authctx.TenantScope, caseID string) (
	domain.Authorisation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Authorisation{}, err
	}
	parsed, err := uuid.Parse(caseID)
	if err != nil {
		return domain.Authorisation{}, notFound()
	}

	row, err := r.queries(ctx).LatestAuthorisation(ctx,
		sqlcgen.LatestAuthorisationParams{
			TenantID: tenantID, CaseID: parsed,
		})
	if isNoRows(err) {
		return domain.Authorisation{}, nil
	}
	if err != nil {
		return domain.Authorisation{}, err
	}
	return domain.Authorisation{
		Authority: row.Authority, Reference: row.Reference,
		RecordedBy: row.RecordedBy, RecordedAt: timeOf(row.RecordedAt),
		Note: row.Note,
	}, nil
}

// Authorisations implements ports.ReleaseRepository.
func (r *Repository) Authorisations(ctx context.Context,
	scope authctx.TenantScope, ids []string) (
	map[string]domain.Authorisation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListAuthorisations(ctx,
		sqlcgen.ListAuthorisationsParams{
			TenantID: tenantID, CaseIds: caseIDs(ids),
		})
	if err != nil {
		return nil, err
	}
	// Ordered newest first per case, so the first one seen is the latest.
	out := map[string]domain.Authorisation{}
	for _, row := range rows {
		caseID := row.CaseID.String()
		if _, seen := out[caseID]; seen {
			continue
		}
		out[caseID] = domain.Authorisation{
			Authority: row.Authority, Reference: row.Reference,
			RecordedBy: row.RecordedBy,
			RecordedAt: timeOf(row.RecordedAt), Note: row.Note,
		}
	}
	return out, nil
}

func releaseFrom(row sqlcgen.MortuaryRelease) domain.Release {
	return domain.Release{
		ID: row.ReleaseID.String(), TenantID: row.TenantID.String(),
		CaseID:              row.CaseID.String(),
		RecipientName:       row.RecipientName,
		RecipientRelation:   row.RecipientRelation,
		RecipientIDType:     row.RecipientIDType,
		RecipientIDRef:      row.RecipientIDRef,
		VerificationNote:    row.VerificationNote,
		SignatureRef:        row.SignatureRef,
		Destination:         row.Destination,
		DeathCertificateRef: row.DeathCertificateRef,
		MedicoLegal:         row.CaseMedicoLegal,
		Authority:           row.Authority,
		AuthorityReference:  row.AuthorityReference,
		ReleasedAt:          timeOf(row.ReleasedAt),
		ReleasedBy:          row.ReleasedBy,
		WitnessedBy:         row.WitnessedBy, Note: row.Note,
	}
}

// InsertRelease implements ports.ReleaseRepository.
//
// case_medico_legal is written from the release, which the domain copies from
// the case. The composite foreign key is what checks the two agree: see the
// note at the head of migration 0045.
func (r *Repository) InsertRelease(ctx context.Context,
	scope authctx.TenantScope, rel domain.Release) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(rel.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(rel.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertRelease(ctx, sqlcgen.InsertReleaseParams{
		ReleaseID: id, TenantID: tenantID, CaseID: caseID,
		CaseMedicoLegal:     rel.MedicoLegal,
		RecipientName:       rel.RecipientName,
		RecipientRelation:   rel.RecipientRelation,
		RecipientIDType:     rel.RecipientIDType,
		RecipientIDRef:      rel.RecipientIDRef,
		VerificationNote:    rel.VerificationNote,
		SignatureRef:        rel.SignatureRef,
		Destination:         rel.Destination,
		DeathCertificateRef: rel.DeathCertificateRef,
		Authority:           rel.Authority,
		AuthorityReference:  rel.AuthorityReference,
		ReleasedAt:          stamp(rel.ReleasedAt),
		ReleasedBy:          rel.ReleasedBy,
		WitnessedBy:         rel.WitnessedBy, Note: rel.Note,
	})
}

// Release implements ports.ReleaseRepository.
func (r *Repository) Release(ctx context.Context,
	scope authctx.TenantScope, caseID string) (domain.Release, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Release{}, err
	}
	parsed, err := uuid.Parse(caseID)
	if err != nil {
		return domain.Release{}, notFound()
	}

	row, err := r.queries(ctx).GetRelease(ctx, sqlcgen.GetReleaseParams{
		TenantID: tenantID, CaseID: parsed})
	if isNoRows(err) {
		return domain.Release{}, notFound()
	}
	if err != nil {
		return domain.Release{}, err
	}
	return releaseFrom(row), nil
}

// Releases implements ports.ReleaseRepository.
func (r *Repository) Releases(ctx context.Context,
	scope authctx.TenantScope, f ports.ReleaseFilter) (
	[]domain.Release, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListReleases(ctx,
		sqlcgen.ListReleasesParams{
			TenantID: tenantID, WindowFrom: stamp(from),
			WindowTo: stamp(to), RowLimit: limit, RowOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Release, 0, len(rows))
	for _, row := range rows {
		out = append(out, releaseFrom(row))
	}
	return out, nil
}
