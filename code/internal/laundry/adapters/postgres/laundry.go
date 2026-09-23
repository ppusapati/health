package postgres

import (
	"context"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Collections, wash batches, issues, losses and tracked items.
//
// Two of these carry a denormalised column the database keeps true through a
// composite foreign key: a collection's batch_cycle and an issue's
// batch_state. The adapter writes them from the batch it was handed, and the
// schema refuses the row if the pair does not exist — so "infected linen is
// in a barrier cycle" and "linen came out of a passed wash" are facts the
// database holds rather than facts this file remembers.

// ------------------------------------------------- collections (SRS-LND-002)

var _ ports.CollectionRepository = (*Repository)(nil)

// InsertCollection implements ports.CollectionRepository.
func (r *Repository) InsertCollection(ctx context.Context,
	scope authctx.TenantScope, c domain.Collection) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertLinenCollection(ctx,
		sqlcgen.InsertLinenCollectionParams{
			CollectionID: id, TenantID: tenantID,
			UnitID: c.UnitID, UnitName: c.UnitName,
			FacilityID: c.FacilityID,
			SoilClass:  string(c.SoilClass), Handling: c.Handling,
			BagCount: int32(c.BagCount), WeightG: int32(c.WeightG),
			State:   string(c.State),
			BatchID: optionalUUID(c.BatchID),
			// Nil for an unbatched collection: the composite key is
			// (batch_id, batch_cycle) and it has neither.
			BatchCycle:   nil,
			CancelReason: c.CancelReason,
			CollectedAt:  stamp(c.CollectedAt), CollectedBy: c.CollectedBy,
			Version: c.Version,
		}); err != nil {
		return err
	}
	return insertCollectionLines(ctx, q, id, c.Lines)
}

func insertCollectionLines(ctx context.Context, q *sqlcgen.Queries,
	id uuid.UUID, lines []domain.CollectionLine) error {

	for i, line := range lines {
		if err := q.InsertCollectionLine(ctx,
			sqlcgen.InsertCollectionLineParams{
				CollectionID: id, ItemCode: line.ItemCode,
				Quantity: int32(line.Quantity), Position: int32(i),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Collection implements ports.CollectionRepository.
func (r *Repository) Collection(ctx context.Context,
	scope authctx.TenantScope, collectionID string) (domain.Collection,
	error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Collection{}, err
	}
	id, err := uuid.Parse(collectionID)
	if err != nil {
		return domain.Collection{}, notFound()
	}

	row, err := r.queries(ctx).GetLinenCollection(ctx,
		sqlcgen.GetLinenCollectionParams{
			TenantID: tenantID, CollectionID: id,
		})
	if isNoRows(err) {
		return domain.Collection{}, notFound()
	}
	if err != nil {
		return domain.Collection{}, err
	}
	out, err := r.withCollectionLines(ctx,
		[]sqlcgen.LaundryCollection{row})
	if err != nil {
		return domain.Collection{}, err
	}
	return out[0], nil
}

// UpdateCollection implements ports.CollectionRepository.
//
// The batch's cycle has to be supplied alongside the batch, because the
// database checks the pair. The adapter cannot invent it: an unbatched
// collection writes nil for both, and a batched one writes the cycle read
// back from the batch it was loaded into.
func (r *Repository) UpdateCollection(ctx context.Context,
	scope authctx.TenantScope, c domain.Collection,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	cycle := ""
	if c.BatchID != "" {
		batch, err := q.GetWashBatch(ctx, sqlcgen.GetWashBatchParams{
			TenantID: tenantID, BatchID: uuid.MustParse(c.BatchID),
		})
		if isNoRows(err) {
			return notFound()
		}
		if err != nil {
			return err
		}
		cycle = batch.Cycle
	}

	rows, err := q.UpdateLinenCollection(ctx,
		sqlcgen.UpdateLinenCollectionParams{
			State: string(c.State), BatchID: optionalUUID(c.BatchID),
			BatchCycle: optionalText(cycle), CancelReason: c.CancelReason,
			TenantID: tenantID, CollectionID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if err := conflict(rows); err != nil {
		return err
	}

	// A recount replaces the declared lines. Inside the caller's
	// transaction, so a collection is never briefly a collection of
	// nothing.
	if err := q.DeleteCollectionLines(ctx, id); err != nil {
		return err
	}
	return insertCollectionLines(ctx, q, id, c.Lines)
}

// Collections implements ports.CollectionRepository.
func (r *Repository) Collections(ctx context.Context,
	scope authctx.TenantScope, f ports.CollectionFilter) (
	[]domain.Collection, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	from, to := window(f.From, f.To)

	rows, err := r.queries(ctx).ListLinenCollections(ctx,
		sqlcgen.ListLinenCollectionsParams{
			TenantID: tenantID, FacilityID: f.FacilityID, UnitID: f.UnitID,
			SoilClass: f.SoilClass, States: states(f.States),
			PendingOnly: f.PendingOnly,
			FromTime:    stamp(from), ToTime: stamp(to),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	return r.withCollectionLines(ctx, rows)
}

// ForBatch implements ports.CollectionRepository.
func (r *Repository) ForBatch(ctx context.Context,
	scope authctx.TenantScope, batchID string) ([]domain.Collection, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(batchID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListCollectionsForBatch(ctx,
		sqlcgen.ListCollectionsForBatchParams{
			TenantID: tenantID, BatchID: optionalUUID(id.String()),
		})
	if err != nil {
		return nil, err
	}
	return r.withCollectionLines(ctx, rows)
}

func (r *Repository) withCollectionLines(ctx context.Context,
	rows []sqlcgen.LaundryCollection) ([]domain.Collection, error) {

	out := make([]domain.Collection, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, collectionFrom(row))
		ids = append(ids, row.CollectionID)
	}
	if len(ids) == 0 {
		return out, nil
	}

	lines, err := r.queries(ctx).ListCollectionLines(ctx, ids)
	if err != nil {
		return nil, err
	}
	byCollection := map[string][]domain.CollectionLine{}
	for _, line := range lines {
		key := line.CollectionID.String()
		byCollection[key] = append(byCollection[key], domain.CollectionLine{
			ItemCode: line.ItemCode, Quantity: int(line.Quantity),
		})
	}
	for i := range out {
		out[i].Lines = byCollection[out[i].ID]
	}
	return out, nil
}

func collectionFrom(row sqlcgen.LaundryCollection) domain.Collection {
	return domain.Collection{
		ID: row.CollectionID.String(), TenantID: row.TenantID.String(),
		UnitID: row.UnitID, UnitName: row.UnitName,
		FacilityID: row.FacilityID,
		SoilClass:  domain.SoilClass(row.SoilClass),
		Handling:   row.Handling,
		BagCount:   int(row.BagCount), WeightG: int(row.WeightG),
		State:        domain.CollectionState(row.State),
		BatchID:      uuidString(row.BatchID),
		CancelReason: row.CancelReason,
		CollectedAt:  timeOf(row.CollectedAt),
		CollectedBy:  row.CollectedBy,
		Version:      row.Version,
	}
}

// ------------------------------------------------- wash batches (SRS-LND-003)

var _ ports.BatchRepository = (*Repository)(nil)

// InsertBatch implements ports.BatchRepository.
func (r *Repository) InsertBatch(ctx context.Context,
	scope authctx.TenantScope, b domain.Batch) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(b.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertWashBatch(ctx, sqlcgen.InsertWashBatchParams{
		BatchID: id, TenantID: tenantID,
		Reference: b.Reference, FacilityID: b.FacilityID,
		MachineID: b.MachineID, Cycle: string(b.Cycle),
		Infected: b.Infected, WeightG: int32(b.WeightG),
		State: string(b.State), Outcome: b.Outcome,
		PeakTemperatureC: int32(b.PeakTemperatureC),
		HoldMinutes:      int32(b.HoldMinutes),
		RewashBatchID:    optionalUUID(b.RewashBatchID),
		RewashOfBatchID:  optionalUUID(b.RewashOfBatchID),
		StartedAt:        stamp(b.StartedAt), StartedBy: b.StartedBy,
		CompletedAt: stamp(b.CompletedAt), CompletedBy: b.CompletedBy,
		CreatedAt: stamp(b.CreatedAt), CreatedBy: b.CreatedBy,
		Version: b.Version,
	}); err != nil {
		return err
	}
	return insertExceptions(ctx, q, id, b.Exceptions)
}

func insertExceptions(ctx context.Context, q *sqlcgen.Queries, id uuid.UUID,
	exceptions []domain.BatchException) error {

	for i, exception := range exceptions {
		if err := q.InsertBatchException(ctx,
			sqlcgen.InsertBatchExceptionParams{
				BatchID: id, Code: exception.Code,
				Detail: exception.Detail, Position: int32(i),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Batch implements ports.BatchRepository.
func (r *Repository) Batch(ctx context.Context, scope authctx.TenantScope,
	batchID string) (domain.Batch, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Batch{}, err
	}
	id, err := uuid.Parse(batchID)
	if err != nil {
		return domain.Batch{}, notFound()
	}

	row, err := r.queries(ctx).GetWashBatch(ctx, sqlcgen.GetWashBatchParams{
		TenantID: tenantID, BatchID: id,
	})
	if isNoRows(err) {
		return domain.Batch{}, notFound()
	}
	if err != nil {
		return domain.Batch{}, err
	}
	out, err := r.withExceptions(ctx, []sqlcgen.LaundryWashBatch{row})
	if err != nil {
		return domain.Batch{}, err
	}
	return out[0], nil
}

// UpdateBatch implements ports.BatchRepository.
//
// The batch and its exceptions move together. A failed batch whose
// exceptions landed afterwards would read, for as long as it took, as a
// failure nobody could explain.
func (r *Repository) UpdateBatch(ctx context.Context,
	scope authctx.TenantScope, b domain.Batch, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(b.ID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	rows, err := q.UpdateWashBatch(ctx, sqlcgen.UpdateWashBatchParams{
		Infected: b.Infected, WeightG: int32(b.WeightG),
		State: string(b.State), Outcome: b.Outcome,
		PeakTemperatureC: int32(b.PeakTemperatureC),
		HoldMinutes:      int32(b.HoldMinutes),
		RewashBatchID:    optionalUUID(b.RewashBatchID),
		RewashOfBatchID:  optionalUUID(b.RewashOfBatchID),
		StartedAt:        stamp(b.StartedAt), StartedBy: b.StartedBy,
		CompletedAt: stamp(b.CompletedAt), CompletedBy: b.CompletedBy,
		TenantID: tenantID, BatchID: id,
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if err := conflict(rows); err != nil {
		return err
	}
	// Exceptions are keyed on (batch, code), so re-writing the set is
	// idempotent for a batch completed once and a no-op for one that has
	// not been.
	return insertExceptionsIfNew(ctx, q, id, b.Exceptions)
}

func insertExceptionsIfNew(ctx context.Context, q *sqlcgen.Queries,
	id uuid.UUID, exceptions []domain.BatchException) error {

	if len(exceptions) == 0 {
		return nil
	}
	existing, err := q.ListBatchExceptions(ctx, []uuid.UUID{id})
	if err != nil {
		return err
	}
	seen := map[string]bool{}
	for _, row := range existing {
		seen[row.Code] = true
	}
	var fresh []domain.BatchException
	for _, exception := range exceptions {
		if !seen[exception.Code] {
			fresh = append(fresh, exception)
		}
	}
	return insertExceptions(ctx, q, id, fresh)
}

// Batches implements ports.BatchRepository.
func (r *Repository) Batches(ctx context.Context, scope authctx.TenantScope,
	f ports.BatchFilter) ([]domain.Batch, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	from, to := window(f.From, f.To)

	rows, err := r.queries(ctx).ListWashBatches(ctx,
		sqlcgen.ListWashBatchesParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			MachineID: f.MachineID, Cycle: f.Cycle,
			States:   states(f.States),
			FromTime: stamp(from), ToTime: stamp(to),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	return r.withExceptions(ctx, rows)
}

func (r *Repository) withExceptions(ctx context.Context,
	rows []sqlcgen.LaundryWashBatch) ([]domain.Batch, error) {

	out := make([]domain.Batch, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, batchFrom(row))
		ids = append(ids, row.BatchID)
	}
	if len(ids) == 0 {
		return out, nil
	}

	q := r.queries(ctx)
	exceptions, err := q.ListBatchExceptions(ctx, ids)
	if err != nil {
		return nil, err
	}
	byBatch := map[string][]domain.BatchException{}
	for _, row := range exceptions {
		key := row.BatchID.String()
		byBatch[key] = append(byBatch[key], domain.BatchException{
			Code: row.Code, Detail: row.Detail,
		})
	}

	// The chain SRS-LND-002 asks to be retained, read from the batch end.
	collections, err := q.ListCollectionsForBatches(ctx,
		sqlcgen.ListCollectionsForBatchesParams{
			TenantID: rows[0].TenantID, BatchIds: ids,
		})
	if err != nil {
		return nil, err
	}
	loaded := map[string][]string{}
	for _, row := range collections {
		key := uuidString(row.BatchID)
		loaded[key] = append(loaded[key], row.CollectionID.String())
	}

	for i := range out {
		out[i].Exceptions = byBatch[out[i].ID]
		out[i].CollectionIDs = loaded[out[i].ID]
	}
	return out, nil
}

func batchFrom(row sqlcgen.LaundryWashBatch) domain.Batch {
	return domain.Batch{
		ID: row.BatchID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, FacilityID: row.FacilityID,
		MachineID: row.MachineID, Cycle: domain.Cycle(row.Cycle),
		Infected: row.Infected, WeightG: int(row.WeightG),
		State: domain.BatchState(row.State), Outcome: row.Outcome,
		PeakTemperatureC: int(row.PeakTemperatureC),
		HoldMinutes:      int(row.HoldMinutes),
		RewashBatchID:    uuidString(row.RewashBatchID),
		RewashOfBatchID:  uuidString(row.RewashOfBatchID),
		StartedAt:        timeOf(row.StartedAt), StartedBy: row.StartedBy,
		CompletedAt: timeOf(row.CompletedAt),
		CompletedBy: row.CompletedBy,
		CreatedAt:   timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// ------------------------------------------------------ issues (SRS-LND-004)

var _ ports.IssueRepository = (*Repository)(nil)

// InsertIssue implements ports.IssueRepository.
//
// batch_state is written from the batch this issue names, and the composite
// foreign key means the pair has to exist. A caller that wrote 'passed' for a
// batch that failed would be refused by the database, not by this function.
func (r *Repository) InsertIssue(ctx context.Context,
	scope authctx.TenantScope, i domain.Issue) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	batchID, err := uuid.Parse(i.BatchID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	batch, err := q.GetWashBatch(ctx, sqlcgen.GetWashBatchParams{
		TenantID: tenantID, BatchID: batchID,
	})
	if isNoRows(err) {
		return notFound()
	}
	if err != nil {
		return err
	}

	if err := q.InsertLinenIssue(ctx, sqlcgen.InsertLinenIssueParams{
		IssueID: id, TenantID: tenantID,
		UnitID: i.UnitID, UnitName: i.UnitName, FacilityID: i.FacilityID,
		BatchID: batchID, BatchState: batch.State,
		BatchReference: i.BatchReference,
		IssuedAt:       stamp(i.IssuedAt), IssuedBy: i.IssuedBy,
		ReceivedAt: stamp(i.ReceivedAt), ReceivedBy: i.ReceivedBy,
		Version: i.Version,
	}); err != nil {
		return err
	}

	for n, line := range i.Lines {
		if err := q.InsertIssueLine(ctx, sqlcgen.InsertIssueLineParams{
			IssueID: id, ItemCode: line.ItemCode,
			Quantity: int32(line.Quantity), Position: int32(n),
		}); err != nil {
			return err
		}
	}
	return nil
}

// Issue implements ports.IssueRepository.
func (r *Repository) Issue(ctx context.Context, scope authctx.TenantScope,
	issueID string) (domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Issue{}, err
	}
	id, err := uuid.Parse(issueID)
	if err != nil {
		return domain.Issue{}, notFound()
	}

	row, err := r.queries(ctx).GetLinenIssue(ctx,
		sqlcgen.GetLinenIssueParams{TenantID: tenantID, IssueID: id})
	if isNoRows(err) {
		return domain.Issue{}, notFound()
	}
	if err != nil {
		return domain.Issue{}, err
	}
	out, err := r.withIssueLines(ctx, []sqlcgen.LaundryLinenIssue{row})
	if err != nil {
		return domain.Issue{}, err
	}
	return out[0], nil
}

// ReceiveIssue implements ports.IssueRepository.
func (r *Repository) ReceiveIssue(ctx context.Context,
	scope authctx.TenantScope, i domain.Issue, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ReceiveLinenIssue(ctx,
		sqlcgen.ReceiveLinenIssueParams{
			ReceivedAt: stamp(i.ReceivedAt), ReceivedBy: i.ReceivedBy,
			TenantID: tenantID, IssueID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Issues implements ports.IssueRepository.
func (r *Repository) Issues(ctx context.Context, scope authctx.TenantScope,
	f ports.IssueFilter) ([]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	from, to := window(f.From, f.To)

	rows, err := r.queries(ctx).ListLinenIssues(ctx,
		sqlcgen.ListLinenIssuesParams{
			TenantID: tenantID, FacilityID: f.FacilityID, UnitID: f.UnitID,
			BatchID: f.BatchID, OutstandingOnly: f.OutstandingOnly,
			FromTime: stamp(from), ToTime: stamp(to),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	return r.withIssueLines(ctx, rows)
}

func (r *Repository) withIssueLines(ctx context.Context,
	rows []sqlcgen.LaundryLinenIssue) ([]domain.Issue, error) {

	out := make([]domain.Issue, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, issueFrom(row))
		ids = append(ids, row.IssueID)
	}
	if len(ids) == 0 {
		return out, nil
	}

	lines, err := r.queries(ctx).ListIssueLines(ctx, ids)
	if err != nil {
		return nil, err
	}
	byIssue := map[string][]domain.IssueLine{}
	for _, line := range lines {
		key := line.IssueID.String()
		byIssue[key] = append(byIssue[key], domain.IssueLine{
			ItemCode: line.ItemCode, Quantity: int(line.Quantity),
		})
	}
	for i := range out {
		out[i].Lines = byIssue[out[i].ID]
	}
	return out, nil
}

func issueFrom(row sqlcgen.LaundryLinenIssue) domain.Issue {
	return domain.Issue{
		ID: row.IssueID.String(), TenantID: row.TenantID.String(),
		UnitID: row.UnitID, UnitName: row.UnitName,
		FacilityID:     row.FacilityID,
		BatchID:        row.BatchID.String(),
		BatchReference: row.BatchReference,
		IssuedAt:       timeOf(row.IssuedAt), IssuedBy: row.IssuedBy,
		ReceivedAt: timeOf(row.ReceivedAt), ReceivedBy: row.ReceivedBy,
		Version: row.Version,
	}
}

// ------------------------------------------------------ losses (SRS-LND-006)

var _ ports.LossRepository = (*Repository)(nil)

// InsertLoss implements ports.LossRepository.
func (r *Repository) InsertLoss(ctx context.Context,
	scope authctx.TenantScope, l domain.LossRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertLossRecord(ctx,
		sqlcgen.InsertLossRecordParams{
			LossID: id, TenantID: tenantID,
			UnitID: l.UnitID, FacilityID: l.FacilityID,
			ItemCode: l.ItemCode, Quantity: int32(l.Quantity),
			Kind: string(l.Kind), Reason: l.Reason,
			ValueMinor: int32(l.ValueMinor), State: string(l.State),
			ApprovalRequired: l.ApprovalRequired,
			ApprovedBy:       l.ApprovedBy, ApprovedAt: stamp(l.ApprovedAt),
			DecisionNote: l.DecisionNote,
			ReportedAt:   stamp(l.ReportedAt), ReportedBy: l.ReportedBy,
			Version: l.Version,
		})
}

// Loss implements ports.LossRepository.
func (r *Repository) Loss(ctx context.Context, scope authctx.TenantScope,
	lossID string) (domain.LossRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.LossRecord{}, err
	}
	id, err := uuid.Parse(lossID)
	if err != nil {
		return domain.LossRecord{}, notFound()
	}

	row, err := r.queries(ctx).GetLossRecord(ctx,
		sqlcgen.GetLossRecordParams{TenantID: tenantID, LossID: id})
	if isNoRows(err) {
		return domain.LossRecord{}, notFound()
	}
	if err != nil {
		return domain.LossRecord{}, err
	}
	return lossFrom(row), nil
}

// UpdateLoss implements ports.LossRepository.
func (r *Repository) UpdateLoss(ctx context.Context,
	scope authctx.TenantScope, l domain.LossRecord,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateLossRecord(ctx,
		sqlcgen.UpdateLossRecordParams{
			State: string(l.State), ApprovedBy: l.ApprovedBy,
			ApprovedAt: stamp(l.ApprovedAt), DecisionNote: l.DecisionNote,
			TenantID: tenantID, LossID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Losses implements ports.LossRepository.
func (r *Repository) Losses(ctx context.Context, scope authctx.TenantScope,
	f ports.LossFilter) ([]domain.LossRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	from, to := window(f.From, f.To)

	rows, err := r.queries(ctx).ListLossRecords(ctx,
		sqlcgen.ListLossRecordsParams{
			TenantID: tenantID, FacilityID: f.FacilityID, UnitID: f.UnitID,
			ItemCode: f.ItemCode, Kind: f.Kind, States: states(f.States),
			FromTime: stamp(from), ToTime: stamp(to),
			PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.LossRecord, 0, len(rows))
	for _, row := range rows {
		out = append(out, lossFrom(row))
	}
	return out, nil
}

func lossFrom(row sqlcgen.LaundryLossRecord) domain.LossRecord {
	return domain.LossRecord{
		ID: row.LossID.String(), TenantID: row.TenantID.String(),
		UnitID: row.UnitID, FacilityID: row.FacilityID,
		ItemCode: row.ItemCode, Quantity: int(row.Quantity),
		Kind: domain.LossKind(row.Kind), Reason: row.Reason,
		ValueMinor:       int(row.ValueMinor),
		State:            domain.LossState(row.State),
		ApprovalRequired: row.ApprovalRequired,
		ApprovedBy:       row.ApprovedBy,
		ApprovedAt:       timeOf(row.ApprovedAt),
		DecisionNote:     row.DecisionNote,
		ReportedAt:       timeOf(row.ReportedAt),
		ReportedBy:       row.ReportedBy,
		Version:          row.Version,
	}
}

// ----------------------------------------------- tracked items (SRS-LND-007)

var _ ports.TrackedRepository = (*Repository)(nil)

// InsertTracked implements ports.TrackedRepository.
func (r *Repository) InsertTracked(ctx context.Context,
	scope authctx.TenantScope, t domain.TrackedItem) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTrackedItem(ctx,
		sqlcgen.InsertTrackedItemParams{
			TrackedID: id, TenantID: tenantID,
			TagID: t.TagID, TagKind: string(t.TagKind),
			ItemCode: t.ItemCode, AssignedTo: t.AssignedTo,
			FacilityID: t.FacilityID, State: string(t.State),
			RetiredReason: t.RetiredReason,
			RegisteredAt:  stamp(t.RegisteredAt),
			RegisteredBy:  t.RegisteredBy, Version: t.Version,
		})
}

// Tracked implements ports.TrackedRepository.
func (r *Repository) Tracked(ctx context.Context, scope authctx.TenantScope,
	trackedID string) (domain.TrackedItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.TrackedItem{}, err
	}
	id, err := uuid.Parse(trackedID)
	if err != nil {
		return domain.TrackedItem{}, notFound()
	}

	row, err := r.queries(ctx).GetTrackedItem(ctx,
		sqlcgen.GetTrackedItemParams{TenantID: tenantID, TrackedID: id})
	if isNoRows(err) {
		return domain.TrackedItem{}, notFound()
	}
	if err != nil {
		return domain.TrackedItem{}, err
	}
	out, err := r.withMovements(ctx, tenantID,
		[]sqlcgen.LaundryTrackedItem{row})
	if err != nil {
		return domain.TrackedItem{}, err
	}
	return out[0], nil
}

// TrackedByTag implements ports.TrackedRepository.
func (r *Repository) TrackedByTag(ctx context.Context,
	scope authctx.TenantScope, tagID string) (domain.TrackedItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.TrackedItem{}, err
	}
	row, err := r.queries(ctx).GetTrackedItemByTag(ctx,
		sqlcgen.GetTrackedItemByTagParams{TenantID: tenantID, TagID: tagID})
	if isNoRows(err) {
		return domain.TrackedItem{}, notFound()
	}
	if err != nil {
		return domain.TrackedItem{}, err
	}
	out, err := r.withMovements(ctx, tenantID,
		[]sqlcgen.LaundryTrackedItem{row})
	if err != nil {
		return domain.TrackedItem{}, err
	}
	return out[0], nil
}

// UpdateTracked implements ports.TrackedRepository.
func (r *Repository) UpdateTracked(ctx context.Context,
	scope authctx.TenantScope, t domain.TrackedItem,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateTrackedItem(ctx,
		sqlcgen.UpdateTrackedItemParams{
			AssignedTo: t.AssignedTo, State: string(t.State),
			RetiredReason: t.RetiredReason,
			TenantID:      tenantID, TrackedID: id,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// AppendMovement implements ports.TrackedRepository.
//
// Append only. There is no update here and no query that would let one, which
// is the whole of why a custody trail is worth reading.
func (r *Repository) AppendMovement(ctx context.Context,
	scope authctx.TenantScope, trackedID string, m domain.Movement) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(trackedID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).AppendTrackedMovement(ctx,
		sqlcgen.AppendTrackedMovementParams{
			MovementID: uuid.New(), TenantID: tenantID, TrackedID: id,
			Location: m.Location, HolderID: m.HolderID, Note: m.Note,
			RecordedBy: m.RecordedBy, OccurredAt: stamp(m.At),
		})
}

// TrackedItems implements ports.TrackedRepository.
func (r *Repository) TrackedItems(ctx context.Context,
	scope authctx.TenantScope, f ports.TrackedFilter) (
	[]domain.TrackedItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListTrackedItems(ctx,
		sqlcgen.ListTrackedItemsParams{
			TenantID: tenantID, FacilityID: f.FacilityID,
			ItemCode: f.ItemCode, AssignedTo: f.AssignedTo,
			InServiceOnly: f.InServiceOnly,
			PageLimit:     limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	return r.withMovements(ctx, tenantID, rows)
}

func (r *Repository) withMovements(ctx context.Context, tenantID uuid.UUID,
	rows []sqlcgen.LaundryTrackedItem) ([]domain.TrackedItem, error) {

	out := make([]domain.TrackedItem, 0, len(rows))
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		out = append(out, trackedFrom(row))
		ids = append(ids, row.TrackedID)
	}
	if len(ids) == 0 {
		return out, nil
	}

	movements, err := r.queries(ctx).ListTrackedMovements(ctx,
		sqlcgen.ListTrackedMovementsParams{
			TenantID: tenantID, TrackedIds: ids,
		})
	if err != nil {
		return nil, err
	}
	byItem := map[string][]domain.Movement{}
	for _, row := range movements {
		key := row.TrackedID.String()
		byItem[key] = append(byItem[key], domain.Movement{
			Location: row.Location, HolderID: row.HolderID,
			Note: row.Note, RecordedBy: row.RecordedBy,
			At: timeOf(row.OccurredAt),
		})
	}
	for i := range out {
		out[i].Movements = byItem[out[i].ID]
	}
	return out, nil
}

func trackedFrom(row sqlcgen.LaundryTrackedItem) domain.TrackedItem {
	return domain.TrackedItem{
		ID: row.TrackedID.String(), TenantID: row.TenantID.String(),
		TagID: row.TagID, TagKind: domain.TagKind(row.TagKind),
		ItemCode: row.ItemCode, AssignedTo: row.AssignedTo,
		FacilityID:    row.FacilityID,
		State:         domain.TrackedState(row.State),
		RetiredReason: row.RetiredReason,
		RegisteredAt:  timeOf(row.RegisteredAt),
		RegisteredBy:  row.RegisteredBy,
		Version:       row.Version,
	}
}
