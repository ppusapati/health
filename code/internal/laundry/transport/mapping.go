// Package transport translates between the laundry contract and the domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Reverse maps are built in init() from the forward ones,
// so a value added to one direction cannot be forgotten in the other.
//
// Every default fails in the safe direction. An unrecognised soil class stays
// empty and the domain refuses it rather than defaulting to "used", which
// would send infected linen through an ordinary wash; an unrecognised cycle
// stays empty rather than becoming standard, for the same reason.
package transport

import (
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	laundryv1 "github.com/ppusapati/health/code/gen/go/healthcare/laundry/v1"
	"github.com/ppusapati/health/code/internal/laundry/domain"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on
		// the wire, and a uniform last seen in 1970 is one every screen
		// shows as lost.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var categoryFromWire = map[laundryv1.LinenCategory]domain.Category{
	laundryv1.LinenCategory_LINEN_CATEGORY_BEDDING: domain.CategoryBedding,
	laundryv1.LinenCategory_LINEN_CATEGORY_PATIENT: domain.CategoryPatient,
	laundryv1.LinenCategory_LINEN_CATEGORY_THEATRE: domain.CategoryTheatre,
	laundryv1.LinenCategory_LINEN_CATEGORY_UNIFORM: domain.CategoryUniform,
	laundryv1.LinenCategory_LINEN_CATEGORY_OTHER:   domain.CategoryOther,
}

var soilClassFromWire = map[laundryv1.SoilClass]domain.SoilClass{
	laundryv1.SoilClass_SOIL_CLASS_USED:     domain.SoilUsed,
	laundryv1.SoilClass_SOIL_CLASS_FOULED:   domain.SoilFouled,
	laundryv1.SoilClass_SOIL_CLASS_INFECTED: domain.SoilInfected,
}

var cycleFromWire = map[laundryv1.WashCycle]domain.Cycle{
	laundryv1.WashCycle_WASH_CYCLE_STANDARD: domain.CycleStandard,
	laundryv1.WashCycle_WASH_CYCLE_HOT:      domain.CycleHot,
	laundryv1.WashCycle_WASH_CYCLE_BARRIER:  domain.CycleBarrier,
	laundryv1.WashCycle_WASH_CYCLE_DELICATE: domain.CycleDelicate,
}

var collectionStateFromWire = map[laundryv1.CollectionState]domain.CollectionState{
	laundryv1.CollectionState_COLLECTION_STATE_OPEN:      domain.CollectionOpen,
	laundryv1.CollectionState_COLLECTION_STATE_BATCHED:   domain.CollectionBatched,
	laundryv1.CollectionState_COLLECTION_STATE_CANCELLED: domain.CollectionCancelled,
}

var batchStateFromWire = map[laundryv1.BatchState]domain.BatchState{
	laundryv1.BatchState_BATCH_STATE_LOADING:    domain.BatchLoading,
	laundryv1.BatchState_BATCH_STATE_PROCESSING: domain.BatchProcessing,
	laundryv1.BatchState_BATCH_STATE_PASSED:     domain.BatchPassed,
	laundryv1.BatchState_BATCH_STATE_FAILED:     domain.BatchFailed,
	laundryv1.BatchState_BATCH_STATE_REWASHED:   domain.BatchRewashed,
}

var lossKindFromWire = map[laundryv1.LossKind]domain.LossKind{
	laundryv1.LossKind_LOSS_KIND_CONDEMNED: domain.LossCondemned,
	laundryv1.LossKind_LOSS_KIND_DAMAGED:   domain.LossDamaged,
	laundryv1.LossKind_LOSS_KIND_MISSING:   domain.LossMissing,
}

var lossStateFromWire = map[laundryv1.LossState]domain.LossState{
	laundryv1.LossState_LOSS_STATE_REPORTED:  domain.LossReported,
	laundryv1.LossState_LOSS_STATE_APPROVED:  domain.LossApproved,
	laundryv1.LossState_LOSS_STATE_REJECTED:  domain.LossRejected,
	laundryv1.LossState_LOSS_STATE_RECOVERED: domain.LossRecovered,
}

var tagKindFromWire = map[laundryv1.TagKind]domain.TagKind{
	laundryv1.TagKind_TAG_KIND_RFID:    domain.TagRFID,
	laundryv1.TagKind_TAG_KIND_BARCODE: domain.TagBarcode,
}

var trackedStateFromWire = map[laundryv1.TrackedState]domain.TrackedState{
	laundryv1.TrackedState_TRACKED_STATE_IN_SERVICE: domain.TrackedInService,
	laundryv1.TrackedState_TRACKED_STATE_RETIRED:    domain.TrackedRetired,
}

var (
	categoryToWire        = map[domain.Category]laundryv1.LinenCategory{}
	soilClassToWire       = map[domain.SoilClass]laundryv1.SoilClass{}
	cycleToWire           = map[domain.Cycle]laundryv1.WashCycle{}
	collectionStateToWire = map[domain.CollectionState]laundryv1.CollectionState{}
	batchStateToWire      = map[domain.BatchState]laundryv1.BatchState{}
	lossKindToWire        = map[domain.LossKind]laundryv1.LossKind{}
	lossStateToWire       = map[domain.LossState]laundryv1.LossState{}
	tagKindToWire         = map[domain.TagKind]laundryv1.TagKind{}
	trackedStateToWire    = map[domain.TrackedState]laundryv1.TrackedState{}
)

func init() {
	for wire, value := range categoryFromWire {
		categoryToWire[value] = wire
	}
	for wire, value := range soilClassFromWire {
		soilClassToWire[value] = wire
	}
	for wire, value := range cycleFromWire {
		cycleToWire[value] = wire
	}
	for wire, value := range collectionStateFromWire {
		collectionStateToWire[value] = wire
	}
	for wire, value := range batchStateFromWire {
		batchStateToWire[value] = wire
	}
	for wire, value := range lossKindFromWire {
		lossKindToWire[value] = wire
	}
	for wire, value := range lossStateFromWire {
		lossStateToWire[value] = wire
	}
	for wire, value := range tagKindFromWire {
		tagKindToWire[value] = wire
	}
	for wire, value := range trackedStateFromWire {
		trackedStateToWire[value] = wire
	}
}

// collectionStatesFromWire and the two below it drop any value they do not
// recognise, so a request naming only unknown states comes back as no filter
// at all. That widens the read rather than narrowing it, which is the safe
// direction here: a supervisor shown more rows than they asked for notices,
// and one shown none concludes the laundry is empty.
func collectionStatesFromWire(in []laundryv1.CollectionState) []string {
	out := make([]string, 0, len(in))
	for _, state := range in {
		if mapped, ok := collectionStateFromWire[state]; ok {
			out = append(out, string(mapped))
		}
	}
	return out
}

func batchStatesFromWire(in []laundryv1.BatchState) []string {
	out := make([]string, 0, len(in))
	for _, state := range in {
		if mapped, ok := batchStateFromWire[state]; ok {
			out = append(out, string(mapped))
		}
	}
	return out
}

func lossStatesFromWire(in []laundryv1.LossState) []string {
	out := make([]string, 0, len(in))
	for _, state := range in {
		if mapped, ok := lossStateFromWire[state]; ok {
			out = append(out, string(mapped))
		}
	}
	return out
}

func parLinesFromWire(in []*laundryv1.ParLine) []domain.ParLine {
	out := make([]domain.ParLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.ParLine{
			ItemCode:  line.GetItemCode(),
			Quantity:  int(line.GetQuantity()),
			ReorderAt: int(line.GetReorderAt()),
		})
	}
	return out
}

func parLinesToWire(in []domain.ParLine) []*laundryv1.ParLine {
	out := make([]*laundryv1.ParLine, 0, len(in))
	for _, line := range in {
		out = append(out, &laundryv1.ParLine{
			ItemCode: line.ItemCode, Quantity: int32(line.Quantity),
			ReorderAt: int32(line.ReorderAt),
		})
	}
	return out
}

func collectionLinesFromWire(
	in []*laundryv1.CollectionLine) []domain.CollectionLine {

	out := make([]domain.CollectionLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.CollectionLine{
			ItemCode: line.GetItemCode(),
			Quantity: int(line.GetQuantity()),
		})
	}
	return out
}

func collectionLinesToWire(
	in []domain.CollectionLine) []*laundryv1.CollectionLine {

	out := make([]*laundryv1.CollectionLine, 0, len(in))
	for _, line := range in {
		out = append(out, &laundryv1.CollectionLine{
			ItemCode: line.ItemCode, Quantity: int32(line.Quantity),
		})
	}
	return out
}

func issueLinesFromWire(in []*laundryv1.IssueLine) []domain.IssueLine {
	out := make([]domain.IssueLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.IssueLine{
			ItemCode: line.GetItemCode(),
			Quantity: int(line.GetQuantity()),
		})
	}
	return out
}

func issueLinesToWire(in []domain.IssueLine) []*laundryv1.IssueLine {
	out := make([]*laundryv1.IssueLine, 0, len(in))
	for _, line := range in {
		out = append(out, &laundryv1.IssueLine{
			ItemCode: line.ItemCode, Quantity: int32(line.Quantity),
		})
	}
	return out
}

func exceptionsFromWire(
	in []*laundryv1.BatchException) []domain.BatchException {

	out := make([]domain.BatchException, 0, len(in))
	for _, exception := range in {
		out = append(out, domain.BatchException{
			Code: exception.GetCode(), Detail: exception.GetDetail(),
		})
	}
	return out
}

func exceptionsToWire(
	in []domain.BatchException) []*laundryv1.BatchException {

	out := make([]*laundryv1.BatchException, 0, len(in))
	for _, exception := range in {
		out = append(out, &laundryv1.BatchException{
			Code: exception.Code, Detail: exception.Detail,
		})
	}
	return out
}

func itemToWire(in domain.LinenItem) *laundryv1.LinenItem {
	return &laundryv1.LinenItem{
		ItemId: in.ID, Code: in.Code, Name: in.Name,
		Category:             categoryToWire[in.Category],
		UnitWeightG:          int32(in.UnitWeightG),
		ReplacementCostMinor: int32(in.ReplacementCostMinor),
		Tracked:              in.Tracked, Active: in.Active,
		CreatedAt: stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
}

func itemsToWire(in []domain.LinenItem) []*laundryv1.LinenItem {
	out := make([]*laundryv1.LinenItem, 0, len(in))
	for _, item := range in {
		out = append(out, itemToWire(item))
	}
	return out
}

func parToWire(in domain.ParLevel) *laundryv1.ParLevel {
	if in.ID == "" {
		return nil
	}
	return &laundryv1.ParLevel{
		ParId: in.ID, UnitId: in.UnitID, UnitName: in.UnitName,
		FacilityId: in.FacilityID, Revision: int32(in.Revision),
		Lines:    parLinesToWire(in.Lines),
		Approved: in.Approved, ApprovedBy: in.ApprovedBy,
		ApprovedAt:    stamp(in.ApprovedAt),
		EffectiveFrom: stamp(in.EffectiveFrom),
		SupersededAt:  stamp(in.SupersededAt),
		CreatedAt:     stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
}

func parsToWire(in []domain.ParLevel) []*laundryv1.ParLevel {
	out := make([]*laundryv1.ParLevel, 0, len(in))
	for _, par := range in {
		out = append(out, parToWire(par))
	}
	return out
}

func collectionToWire(in domain.Collection) *laundryv1.LinenCollection {
	return &laundryv1.LinenCollection{
		CollectionId: in.ID, UnitId: in.UnitID, UnitName: in.UnitName,
		FacilityId: in.FacilityID,
		SoilClass:  soilClassToWire[in.SoilClass],
		Handling:   in.Handling,
		BagCount:   int32(in.BagCount), WeightG: int32(in.WeightG),
		Lines: collectionLinesToWire(in.Lines),
		State: collectionStateToWire[in.State], BatchId: in.BatchID,
		CancelReason: in.CancelReason,
		CollectedAt:  stamp(in.CollectedAt), CollectedBy: in.CollectedBy,
		Version: in.Version,
	}
}

func collectionsToWire(
	in []domain.Collection) []*laundryv1.LinenCollection {

	out := make([]*laundryv1.LinenCollection, 0, len(in))
	for _, collection := range in {
		out = append(out, collectionToWire(collection))
	}
	return out
}

func batchToWire(in domain.Batch) *laundryv1.WashBatch {
	return &laundryv1.WashBatch{
		BatchId: in.ID, Reference: in.Reference,
		FacilityId: in.FacilityID, MachineId: in.MachineID,
		Cycle: cycleToWire[in.Cycle], Infected: in.Infected,
		CollectionIds: in.CollectionIDs, WeightG: int32(in.WeightG),
		State: batchStateToWire[in.State], Outcome: in.Outcome,
		Exceptions:       exceptionsToWire(in.Exceptions),
		PeakTemperatureC: int32(in.PeakTemperatureC),
		HoldMinutes:      int32(in.HoldMinutes),
		RewashBatchId:    in.RewashBatchID,
		RewashOfBatchId:  in.RewashOfBatchID,
		StartedAt:        stamp(in.StartedAt), StartedBy: in.StartedBy,
		CompletedAt: stamp(in.CompletedAt), CompletedBy: in.CompletedBy,
		CreatedAt: stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
}

func batchesToWire(in []domain.Batch) []*laundryv1.WashBatch {
	out := make([]*laundryv1.WashBatch, 0, len(in))
	for _, batch := range in {
		out = append(out, batchToWire(batch))
	}
	return out
}

func issueToWire(in domain.Issue) *laundryv1.LinenIssue {
	return &laundryv1.LinenIssue{
		IssueId: in.ID, UnitId: in.UnitID, UnitName: in.UnitName,
		FacilityId: in.FacilityID,
		BatchId:    in.BatchID, BatchReference: in.BatchReference,
		Lines:    issueLinesToWire(in.Lines),
		IssuedAt: stamp(in.IssuedAt), IssuedBy: in.IssuedBy,
		ReceivedAt: stamp(in.ReceivedAt), ReceivedBy: in.ReceivedBy,
		Version: in.Version,
	}
}

func issuesToWire(in []domain.Issue) []*laundryv1.LinenIssue {
	out := make([]*laundryv1.LinenIssue, 0, len(in))
	for _, issue := range in {
		out = append(out, issueToWire(issue))
	}
	return out
}

func lossToWire(in domain.LossRecord) *laundryv1.LossRecord {
	return &laundryv1.LossRecord{
		LossId: in.ID, UnitId: in.UnitID, FacilityId: in.FacilityID,
		ItemCode: in.ItemCode, Quantity: int32(in.Quantity),
		Kind: lossKindToWire[in.Kind], Reason: in.Reason,
		ValueMinor:       int32(in.ValueMinor),
		State:            lossStateToWire[in.State],
		ApprovalRequired: in.ApprovalRequired,
		ApprovedBy:       in.ApprovedBy, ApprovedAt: stamp(in.ApprovedAt),
		DecisionNote: in.DecisionNote,
		ReportedAt:   stamp(in.ReportedAt), ReportedBy: in.ReportedBy,
		Version: in.Version,
	}
}

func lossesToWire(in []domain.LossRecord) []*laundryv1.LossRecord {
	out := make([]*laundryv1.LossRecord, 0, len(in))
	for _, record := range in {
		out = append(out, lossToWire(record))
	}
	return out
}

func movementsToWire(
	in []domain.Movement) []*laundryv1.TrackedMovement {

	out := make([]*laundryv1.TrackedMovement, 0, len(in))
	for _, movement := range in {
		out = append(out, &laundryv1.TrackedMovement{
			Location: movement.Location, HolderId: movement.HolderID,
			Note: movement.Note, RecordedBy: movement.RecordedBy,
			OccurredAt: stamp(movement.At),
		})
	}
	return out
}

func trackedToWire(in domain.TrackedItem) *laundryv1.TrackedItem {
	return &laundryv1.TrackedItem{
		TrackedId: in.ID, TagId: in.TagID,
		TagKind: tagKindToWire[in.TagKind], ItemCode: in.ItemCode,
		AssignedTo: in.AssignedTo, FacilityId: in.FacilityID,
		State:         trackedStateToWire[in.State],
		Movements:     movementsToWire(in.Movements),
		RetiredReason: in.RetiredReason,
		RegisteredAt:  stamp(in.RegisteredAt),
		RegisteredBy:  in.RegisteredBy,
		Version:       in.Version,
	}
}

func trackedItemsToWire(in []domain.TrackedItem) []*laundryv1.TrackedItem {
	out := make([]*laundryv1.TrackedItem, 0, len(in))
	for _, item := range in {
		out = append(out, trackedToWire(item))
	}
	return out
}

func custodyToWire(in domain.Custody) *laundryv1.Custody {
	return &laundryv1.Custody{
		Location: in.Location, HolderId: in.HolderID,
		RecordedBy: in.RecordedBy, OccurredAt: stamp(in.At),
		Known: in.Known,
	}
}

func countsToWire(in map[string]int) []*laundryv1.ItemCount {
	out := make([]*laundryv1.ItemCount, 0, len(in))
	for code, quantity := range in {
		out = append(out, &laundryv1.ItemCount{
			ItemCode: code, Quantity: int32(quantity),
		})
	}
	sortCounts(out)
	return out
}

// sortCounts keeps a map read stable on the wire. Go randomises map order,
// and a delivery sheet whose lines move between two reads is one nobody
// trusts.
func sortCounts(in []*laundryv1.ItemCount) {
	for i := 1; i < len(in); i++ {
		for j := i; j > 0 && in[j].GetItemCode() < in[j-1].GetItemCode(); j-- {
			in[j], in[j-1] = in[j-1], in[j]
		}
	}
}

func shortfallsToWire(in []domain.Shortfall) []*laundryv1.Shortfall {
	out := make([]*laundryv1.Shortfall, 0, len(in))
	for _, line := range in {
		out = append(out, &laundryv1.Shortfall{
			ItemCode: line.ItemCode, Par: int32(line.Par),
			OnHand: int32(line.OnHand), Short: int32(line.Short),
		})
	}
	return out
}
