package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// Collections, washes and issues (SRS-LND-002 … 005).

// RecordCollectionInput records soiled linen leaving a unit.
type RecordCollectionInput struct {
	domain.NewCollectionInput
}

// RecordCollection records soiled linen taken from a unit (SRS-LND-002,
// SRS-LND-005).
func (s *Service) RecordCollection(ctx context.Context,
	in RecordCollectionInput) (domain.Collection, error) {

	session, scope, err := s.authorize(ctx, PermCollect)
	if err != nil {
		return domain.Collection{}, err
	}
	now := s.clock.Now()

	if err := s.checkUnit(ctx, scope, in.UnitID); err != nil {
		return domain.Collection{}, err
	}

	collection, err := domain.RecordCollection(s.ids.NewID(),
		session.TenantID, in.NewCollectionInput, session.SubjectID, now)
	if err != nil {
		return domain.Collection{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.collections.InsertCollection(ctx, scope,
			collection); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventCollectionRecorded,
			"linen_collection", collection.ID, map[string]any{
				"unit_id":    collection.UnitID,
				"soil_class": string(collection.SoilClass),
				"bags":       collection.BagCount,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "laundry.collection.recorded",
			ResourceType: "linen_collection", ResourceID: collection.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"unit_id":    collection.UnitID,
				"soil_class": string(collection.SoilClass),
			}),
		}, now)
	})
	if err != nil {
		return domain.Collection{}, err
	}
	return collection, nil
}

// RecountCollection corrects a source unit's declared counts (SRS-LND-002).
//
// The domain refuses it for a sealed class, which is SRS-LND-005: re-counting
// infected linen means opening the bag, and the declaration made at the
// bedside is the only count anybody is going to get.
func (s *Service) RecountCollection(ctx context.Context, collectionID string,
	lines []domain.CollectionLine) (domain.Collection, error) {

	session, scope, err := s.authorize(ctx, PermCollect)
	if err != nil {
		return domain.Collection{}, err
	}
	now := s.clock.Now()

	collection, err := s.collections.Collection(ctx, scope, collectionID)
	if err != nil {
		return domain.Collection{}, err
	}
	version := collection.Version
	if err := collection.Recount(lines, session.SubjectID, now); err != nil {
		return domain.Collection{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.collections.UpdateCollection(ctx, scope, collection,
			version); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "laundry.collection.recounted",
			ResourceType: "linen_collection", ResourceID: collection.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"pieces": itoa(collection.DeclaredPieces()),
			}),
		}, now)
	})
	if err != nil {
		return domain.Collection{}, err
	}
	return collection, nil
}

// CancelCollection abandons a collection recorded in error (SRS-LND-002).
func (s *Service) CancelCollection(ctx context.Context, collectionID,
	reason string) (domain.Collection, error) {

	session, scope, err := s.authorize(ctx, PermCollect)
	if err != nil {
		return domain.Collection{}, err
	}
	now := s.clock.Now()

	collection, err := s.collections.Collection(ctx, scope, collectionID)
	if err != nil {
		return domain.Collection{}, err
	}
	version := collection.Version
	if err := collection.Cancel(reason, session.SubjectID, now); err != nil {
		return domain.Collection{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.collections.UpdateCollection(ctx, scope, collection,
			version); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "laundry.collection.cancelled",
			ResourceType: "linen_collection", ResourceID: collection.ID,
			Outcome: audit.OutcomeSuccess, Reason: collection.CancelReason,
		}, now)
	})
	if err != nil {
		return domain.Collection{}, err
	}
	return collection, nil
}

// ListCollectionsInput narrows a collection read.
type ListCollectionsInput struct {
	FacilityID  string
	UnitID      string
	SoilClass   string
	States      []string
	BatchID     string
	PendingOnly bool
	From        time.Time
	To          time.Time
	PageSize    int32
	Offset      int32
}

// ListCollections reads the wash queue (SRS-LND-002, SRS-LND-005).
//
// The pending read comes back with infected linen first, which is the
// domain's ordering rather than this one's: it is the load nobody wants
// sitting in a corridor, and a worklist in arrival order leaves it there
// behind a trolley of towels.
func (s *Service) ListCollections(ctx context.Context,
	in ListCollectionsInput) ([]domain.Collection, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	found, err := s.collections.Collections(ctx, scope,
		ports.CollectionFilter{
			FacilityID: in.FacilityID, UnitID: in.UnitID,
			SoilClass: in.SoilClass, States: in.States,
			BatchID: in.BatchID, PendingOnly: in.PendingOnly,
			From: in.From, To: in.To,
			Limit: clampPageSize(in.PageSize), Offset: in.Offset,
		})
	if err != nil {
		return nil, err
	}
	if in.PendingOnly {
		return domain.PendingCollections(found), nil
	}
	return found, nil
}

// CheckCollectionWeight reconciles a declared count against what it weighed
// (SRS-LND-002).
//
// The one honest cross-check on a bag nobody opens. A finding rather than a
// refusal: linen is wet, and the tolerance a hospital sets is a hospital's to
// set.
func (s *Service) CheckCollectionWeight(ctx context.Context,
	collectionID string) (domain.WeightCheck, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.WeightCheck{}, err
	}
	collection, err := s.collections.Collection(ctx, scope, collectionID)
	if err != nil {
		return domain.WeightCheck{}, err
	}
	items, err := s.items.Items(ctx, scope, ports.ItemFilter{
		Limit: facilityPageSize,
	})
	if err != nil {
		return domain.WeightCheck{}, err
	}
	weights := make(map[string]int, len(items))
	for _, item := range items {
		weights[item.Code] = item.UnitWeightG
	}
	return domain.CheckWeight(collection, weights), nil
}

// OpenBatch opens an empty wash batch (SRS-LND-003).
func (s *Service) OpenBatch(ctx context.Context, in domain.NewBatchInput) (
	domain.Batch, error) {

	session, scope, err := s.authorize(ctx, PermWash)
	if err != nil {
		return domain.Batch{}, err
	}
	now := s.clock.Now()

	batch, err := domain.OpenBatch(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.Batch{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.batches.InsertBatch(ctx, scope, batch); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.batch.opened", ResourceType: "wash_batch",
			ResourceID: batch.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"cycle": string(batch.Cycle), "machine": batch.MachineID,
			}),
		}, now)
	})
	if err != nil {
		return domain.Batch{}, err
	}
	return batch, nil
}

// LoadBatch puts a collection into a wash batch (SRS-LND-002, SRS-LND-003,
// SRS-LND-005).
//
// One transaction, because the batch and the collection each hold half of the
// chain and a half-written link is a trolley in two places. The domain
// refuses infected linen into anything but a barrier cycle; the database
// refuses the row for the same reason, through a composite key.
func (s *Service) LoadBatch(ctx context.Context, batchID,
	collectionID string) (domain.Batch, error) {

	session, scope, err := s.authorize(ctx, PermWash)
	if err != nil {
		return domain.Batch{}, err
	}
	now := s.clock.Now()

	batch, err := s.batches.Batch(ctx, scope, batchID)
	if err != nil {
		return domain.Batch{}, err
	}
	collection, err := s.collections.Collection(ctx, scope, collectionID)
	if err != nil {
		return domain.Batch{}, err
	}
	batchVersion, collectionVersion := batch.Version, collection.Version
	if err := batch.Load(&collection, now); err != nil {
		return domain.Batch{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.batches.UpdateBatch(ctx, scope, batch,
			batchVersion); err != nil {
			return laundryError(err)
		}
		if err := s.collections.UpdateCollection(ctx, scope, collection,
			collectionVersion); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.batch.loaded", ResourceType: "wash_batch",
			ResourceID: batch.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"collection_id": collection.ID,
				"soil_class":    string(collection.SoilClass),
			}),
		}, now)
	})
	if err != nil {
		return domain.Batch{}, err
	}
	return batch, nil
}

// StartBatch begins the wash (SRS-LND-003).
func (s *Service) StartBatch(ctx context.Context, batchID string) (
	domain.Batch, error) {

	session, scope, err := s.authorize(ctx, PermWash)
	if err != nil {
		return domain.Batch{}, err
	}
	now := s.clock.Now()

	batch, err := s.batches.Batch(ctx, scope, batchID)
	if err != nil {
		return domain.Batch{}, err
	}
	version := batch.Version
	if err := batch.Start(session.SubjectID, now); err != nil {
		return domain.Batch{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.batches.UpdateBatch(ctx, scope, batch,
			version); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.batch.started", ResourceType: "wash_batch",
			ResourceID: batch.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.Batch{}, err
	}
	return batch, nil
}

// CompleteBatch records the outcome of a wash (SRS-LND-003).
//
// A failure escalates, naming the units whose linen was in it. That is why
// the chain is worth retaining: a batch that failed is linen that may already
// be on its way back, and the answer to "whose" has to be immediate.
func (s *Service) CompleteBatch(ctx context.Context, batchID string,
	in domain.CompleteInput) (domain.Batch, error) {

	session, scope, err := s.authorize(ctx, PermWash)
	if err != nil {
		return domain.Batch{}, err
	}
	now := s.clock.Now()

	batch, err := s.batches.Batch(ctx, scope, batchID)
	if err != nil {
		return domain.Batch{}, err
	}
	version := batch.Version
	if err := batch.Complete(in, session.SubjectID, now); err != nil {
		return domain.Batch{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.batches.UpdateBatch(ctx, scope, batch,
			version); err != nil {
			return laundryError(err)
		}

		event := EventBatchPassed
		if !batch.Issuable() {
			event = EventBatchFailed
		}
		if err := s.appendEvent(ctx, session, event, "wash_batch", batch.ID,
			map[string]any{
				"cycle": string(batch.Cycle), "machine": batch.MachineID,
				"infected":   batch.Infected,
				"exceptions": len(batch.Exceptions),
			}, now); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.batch.completed", ResourceType: "wash_batch",
			ResourceID: batch.ID, Outcome: audit.OutcomeSuccess,
			Reason: batch.Outcome,
			Context: auditContext(map[string]string{
				"state":      string(batch.State),
				"peak_c":     itoa(batch.PeakTemperatureC),
				"exceptions": itoa(len(batch.Exceptions)),
			}),
		}, now); err != nil {
			return err
		}

		if batch.Issuable() {
			return nil
		}
		loaded, err := s.collections.ForBatch(ctx, scope, batch.ID)
		if err != nil {
			return err
		}
		units := domain.FailedBatchUnits(batch, loaded)
		return s.escalate(ctx, session, scope, ports.Notice{
			Kind: EscalationFailedWash, Subject: batch.ID,
			FacilityID: batch.FacilityID,
			Summary: "wash " + batch.Reference + " failed in " +
				batch.MachineID + "; " + itoa(len(units)) +
				" unit(s) affected",
		}, now)
	})
	if err != nil {
		return domain.Batch{}, err
	}
	return batch, nil
}

// RewashBatch sends a failed load back through (SRS-LND-003).
//
// The failure stays on the record. A hospital that could turn a failed batch
// into a passed one by washing it again would have no way of noticing that
// one machine fails every third load.
func (s *Service) RewashBatch(ctx context.Context, failedID,
	intoID string) (domain.Batch, error) {

	session, scope, err := s.authorize(ctx, PermWash)
	if err != nil {
		return domain.Batch{}, err
	}
	now := s.clock.Now()

	failed, err := s.batches.Batch(ctx, scope, failedID)
	if err != nil {
		return domain.Batch{}, err
	}
	into, err := s.batches.Batch(ctx, scope, intoID)
	if err != nil {
		return domain.Batch{}, err
	}
	failedVersion, intoVersion := failed.Version, into.Version
	if err := failed.Rewash(&into, now); err != nil {
		return domain.Batch{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.batches.UpdateBatch(ctx, scope, failed,
			failedVersion); err != nil {
			return laundryError(err)
		}
		if err := s.batches.UpdateBatch(ctx, scope, into,
			intoVersion); err != nil {
			return laundryError(err)
		}
		// The collections move with the load, so the chain points at the
		// wash that actually cleaned them.
		loaded, err := s.collections.ForBatch(ctx, scope, failed.ID)
		if err != nil {
			return err
		}
		for _, collection := range loaded {
			version := collection.Version
			collection.BatchID = into.ID
			if err := s.collections.UpdateCollection(ctx, scope, collection,
				version); err != nil {
				return laundryError(err)
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.batch.rewashed", ResourceType: "wash_batch",
			ResourceID: failed.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"into": into.ID, "collections": itoa(len(loaded)),
			}),
		}, now)
	})
	if err != nil {
		return domain.Batch{}, err
	}
	return into, nil
}

// ListBatchesInput narrows a wash read.
type ListBatchesInput struct {
	FacilityID string
	MachineID  string
	Cycle      string
	States     []string
	From       time.Time
	To         time.Time
	PageSize   int32
	Offset     int32
}

// ListBatches reads the wash record (SRS-LND-003).
func (s *Service) ListBatches(ctx context.Context, in ListBatchesInput) (
	[]domain.Batch, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.batches.Batches(ctx, scope, ports.BatchFilter{
		FacilityID: in.FacilityID, MachineID: in.MachineID,
		Cycle: in.Cycle, States: in.States, From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// GetBatch reads one wash (SRS-LND-003).
func (s *Service) GetBatch(ctx context.Context, batchID string) (
	domain.Batch, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Batch{}, err
	}
	return s.batches.Batch(ctx, scope, batchID)
}

// AffectedUnits names the units whose linen was in a failed wash
// (SRS-LND-002, SRS-LND-003).
func (s *Service) AffectedUnits(ctx context.Context, batchID string) (
	[]string, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	batch, err := s.batches.Batch(ctx, scope, batchID)
	if err != nil {
		return nil, err
	}
	loaded, err := s.collections.ForBatch(ctx, scope, batch.ID)
	if err != nil {
		return nil, err
	}
	return domain.FailedBatchUnits(batch, loaded), nil
}

// IssueLinenInput sends clean linen to a unit.
type IssueLinenInput struct {
	BatchID    string
	UnitID     string
	UnitName   string
	FacilityID string
	Lines      []domain.IssueLine
}

// IssueLinen sends clean linen from a wash to a unit (SRS-LND-004).
//
// The batch is read and handed to the domain, which refuses one that did not
// pass; the database refuses the row for the same reason, through a composite
// key it keeps true. Linen from a failed wash looks exactly like clean linen,
// and the ward that gets it has no way of telling.
func (s *Service) IssueLinen(ctx context.Context, in IssueLinenInput) (
	domain.Issue, error) {

	session, scope, err := s.authorize(ctx, PermIssue)
	if err != nil {
		return domain.Issue{}, err
	}
	now := s.clock.Now()

	if err := s.checkUnit(ctx, scope, in.UnitID); err != nil {
		return domain.Issue{}, err
	}
	batch, err := s.batches.Batch(ctx, scope, in.BatchID)
	if err != nil {
		return domain.Issue{}, err
	}

	issue, err := domain.IssueLinen(s.ids.NewID(), session.TenantID, batch,
		domain.NewIssueInput{
			UnitID: in.UnitID, UnitName: in.UnitName,
			FacilityID: in.FacilityID, Lines: in.Lines,
		}, session.SubjectID, now)
	if err != nil {
		return domain.Issue{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.issues.InsertIssue(ctx, scope, issue); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventLinenIssued,
			"linen_issue", issue.ID, map[string]any{
				"unit_id": issue.UnitID, "batch_id": issue.BatchID,
				"pieces": issue.Pieces(),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.linen.issued", ResourceType: "linen_issue",
			ResourceID: issue.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"unit_id": issue.UnitID, "batch_id": issue.BatchID,
				"pieces": itoa(issue.Pieces()),
			}),
		}, now)
	})
	if err != nil {
		return domain.Issue{}, err
	}
	return issue, nil
}

// ReceiveIssue records the unit signing for the linen (SRS-LND-004).
func (s *Service) ReceiveIssue(ctx context.Context, issueID string) (
	domain.Issue, error) {

	session, scope, err := s.authorize(ctx, PermReceive)
	if err != nil {
		return domain.Issue{}, err
	}
	now := s.clock.Now()

	issue, err := s.issues.Issue(ctx, scope, issueID)
	if err != nil {
		return domain.Issue{}, err
	}
	version := issue.Version
	if err := issue.Receive(session.SubjectID, now); err != nil {
		return domain.Issue{}, laundryError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.issues.ReceiveIssue(ctx, scope, issue,
			version); err != nil {
			return laundryError(err)
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.linen.received", ResourceType: "linen_issue",
			ResourceID: issue.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"unit_id": issue.UnitID,
			}),
		}, now)
	})
	if err != nil {
		return domain.Issue{}, err
	}
	return issue, nil
}

// ListIssuesInput narrows an issue read.
type ListIssuesInput struct {
	FacilityID      string
	UnitID          string
	BatchID         string
	OutstandingOnly bool
	From            time.Time
	To              time.Time
	PageSize        int32
	Offset          int32
}

// ListIssues reads clean linen deliveries (SRS-LND-004).
func (s *Service) ListIssues(ctx context.Context, in ListIssuesInput) (
	[]domain.Issue, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	found, err := s.issues.Issues(ctx, scope, ports.IssueFilter{
		FacilityID: in.FacilityID, UnitID: in.UnitID, BatchID: in.BatchID,
		OutstandingOnly: in.OutstandingOnly, From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
	if err != nil {
		return nil, err
	}
	if in.OutstandingOnly {
		return domain.OutstandingIssues(found), nil
	}
	return found, nil
}
