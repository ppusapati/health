// Package transport translates between the sterile services contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts. The
// wire enum and the domain constant are allowed to diverge, and a cast would
// hide it. Each default fails in the safe direction: an unrecognised stage
// stays empty, and the domain refuses it rather than guessing which step of
// reprocessing a client meant.
package transport

import (
	"time"

	sterilev1 "github.com/ppusapati/health/code/gen/go/healthcare/sterile/v1"
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp on the wire reads as
		// 1970, and an expiry of 1970 would take a good pack off the shelf.
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

var instrumentStatusFromWire = map[sterilev1.InstrumentStatus]domain.InstrumentStatus{
	sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_SERVICE: domain.InstrumentInService,
	sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_REPAIR:  domain.InstrumentInRepair,
	sterilev1.InstrumentStatus_INSTRUMENT_STATUS_MISSING:    domain.InstrumentMissing,
	sterilev1.InstrumentStatus_INSTRUMENT_STATUS_RETIRED:    domain.InstrumentRetired,
}

var instrumentStatusToWire = map[domain.InstrumentStatus]sterilev1.InstrumentStatus{
	domain.InstrumentInService: sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_SERVICE,
	domain.InstrumentInRepair:  sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_REPAIR,
	domain.InstrumentMissing:   sterilev1.InstrumentStatus_INSTRUMENT_STATUS_MISSING,
	domain.InstrumentRetired:   sterilev1.InstrumentStatus_INSTRUMENT_STATUS_RETIRED,
}

var stageFromWire = map[sterilev1.Stage]domain.Stage{
	sterilev1.Stage_STAGE_RECEIVED:       domain.StageReceived,
	sterilev1.Stage_STAGE_DECONTAMINATED: domain.StageDecontaminated,
	sterilev1.Stage_STAGE_WASHED:         domain.StageWashed,
	sterilev1.Stage_STAGE_INSPECTED:      domain.StageInspected,
	sterilev1.Stage_STAGE_ASSEMBLED:      domain.StageAssembled,
	sterilev1.Stage_STAGE_PACKAGED:       domain.StagePackaged,
	sterilev1.Stage_STAGE_STERILISED:     domain.StageSterilised,
	sterilev1.Stage_STAGE_RELEASED:       domain.StageReleased,
}

var stageToWire = map[domain.Stage]sterilev1.Stage{
	domain.StageReceived:       sterilev1.Stage_STAGE_RECEIVED,
	domain.StageDecontaminated: sterilev1.Stage_STAGE_DECONTAMINATED,
	domain.StageWashed:         sterilev1.Stage_STAGE_WASHED,
	domain.StageInspected:      sterilev1.Stage_STAGE_INSPECTED,
	domain.StageAssembled:      sterilev1.Stage_STAGE_ASSEMBLED,
	domain.StagePackaged:       sterilev1.Stage_STAGE_PACKAGED,
	domain.StageSterilised:     sterilev1.Stage_STAGE_STERILISED,
	domain.StageReleased:       sterilev1.Stage_STAGE_RELEASED,
}

var cycleResultFromWire = map[sterilev1.CycleResult]domain.CycleResult{
	sterilev1.CycleResult_CYCLE_RESULT_RUNNING: domain.CycleRunning,
	sterilev1.CycleResult_CYCLE_RESULT_PASSED:  domain.CyclePassed,
	sterilev1.CycleResult_CYCLE_RESULT_FAILED:  domain.CycleFailed,
	sterilev1.CycleResult_CYCLE_RESULT_ABORTED: domain.CycleAborted,
}

var cycleResultToWire = map[domain.CycleResult]sterilev1.CycleResult{
	domain.CycleRunning: sterilev1.CycleResult_CYCLE_RESULT_RUNNING,
	domain.CyclePassed:  sterilev1.CycleResult_CYCLE_RESULT_PASSED,
	domain.CycleFailed:  sterilev1.CycleResult_CYCLE_RESULT_FAILED,
	domain.CycleAborted: sterilev1.CycleResult_CYCLE_RESULT_ABORTED,
}

var cycleSourceFromWire = map[sterilev1.CycleSource]domain.CycleSource{
	sterilev1.CycleSource_CYCLE_SOURCE_MANUAL:   domain.CycleManual,
	sterilev1.CycleSource_CYCLE_SOURCE_INGESTED: domain.CycleIngested,
}

var cycleSourceToWire = map[domain.CycleSource]sterilev1.CycleSource{
	domain.CycleManual:   sterilev1.CycleSource_CYCLE_SOURCE_MANUAL,
	domain.CycleIngested: sterilev1.CycleSource_CYCLE_SOURCE_INGESTED,
}

var indicatorFromWire = map[sterilev1.IndicatorKind]domain.IndicatorKind{
	sterilev1.IndicatorKind_INDICATOR_KIND_CHEMICAL:   domain.IndicatorChemical,
	sterilev1.IndicatorKind_INDICATOR_KIND_BIOLOGICAL: domain.IndicatorBiological,
}

var indicatorToWire = map[domain.IndicatorKind]sterilev1.IndicatorKind{
	domain.IndicatorChemical:   sterilev1.IndicatorKind_INDICATOR_KIND_CHEMICAL,
	domain.IndicatorBiological: sterilev1.IndicatorKind_INDICATOR_KIND_BIOLOGICAL,
}

var refusalToWire = map[domain.ReleaseRefusal]sterilev1.ReleaseRefusal{
	domain.ReleaseStillRunning:      sterilev1.ReleaseRefusal_RELEASE_REFUSAL_CYCLE_STILL_RUNNING,
	domain.ReleaseCycleFailed:       sterilev1.ReleaseRefusal_RELEASE_REFUSAL_CYCLE_DID_NOT_PASS,
	domain.ReleaseNoChemical:        sterilev1.ReleaseRefusal_RELEASE_REFUSAL_NO_CHEMICAL_INDICATOR,
	domain.ReleaseIndicatorFailed:   sterilev1.ReleaseRefusal_RELEASE_REFUSAL_INDICATOR_FAILED,
	domain.ReleaseBiologicalPending: sterilev1.ReleaseRefusal_RELEASE_REFUSAL_BIOLOGICAL_NOT_READ,
	domain.ReleaseAlreadyReleased:   sterilev1.ReleaseRefusal_RELEASE_REFUSAL_ALREADY_RELEASED,
}

var issueStateToWire = map[domain.IssueState]sterilev1.IssueState{
	domain.IssueOut:      sterilev1.IssueState_ISSUE_STATE_OUT,
	domain.IssueUsed:     sterilev1.IssueState_ISSUE_STATE_USED,
	domain.IssueReturned: sterilev1.IssueState_ISSUE_STATE_RETURNED,
	domain.IssueRecalled: sterilev1.IssueState_ISSUE_STATE_RECALLED,
}

func countsToProto(in map[string]int) map[string]int32 {
	if len(in) == 0 {
		return nil
	}
	out := make(map[string]int32, len(in))
	for code, count := range in {
		out[code] = int32(count)
	}
	return out
}

func countsFromProto(in map[string]int32) map[string]int {
	if len(in) == 0 {
		return nil
	}
	out := make(map[string]int, len(in))
	for code, count := range in {
		out[code] = int(count)
	}
	return out
}

func parametersFromProto(in map[string]float64) map[string]float64 {
	if len(in) == 0 {
		return nil
	}
	out := make(map[string]float64, len(in))
	for key, value := range in {
		out[key] = value
	}
	return out
}

func instrumentToProto(in domain.Instrument) *sterilev1.Instrument {
	return &sterilev1.Instrument{
		InstrumentId: in.ID, Code: in.Code, Display: in.Display,
		SerialNumber: in.SerialNumber,
		Status:       instrumentStatusToWire[in.Status],
		Location:     in.Location,
		AcquiredOn:   stamp(in.AcquiredOn), RetiredOn: stamp(in.RetiredOn),
		Notes: in.Notes, Version: in.Version,
		// Derived rather than left to the client: the one thing a caller
		// wants to know about an instrument is whether it may go in a tray,
		// and reimplementing the rule per client is how they diverge.
		Packable: in.Status.Packable(),
	}
}

func instrumentEventToProto(in domain.InstrumentEvent) *sterilev1.InstrumentEvent {
	return &sterilev1.InstrumentEvent{
		InstrumentEventId: in.ID, InstrumentId: in.InstrumentID,
		// The registration has no previous status, which renders as unset
		// rather than as in-service: the first row of a history is not a move.
		FromStatus: instrumentStatusToWire[in.From],
		ToStatus:   instrumentStatusToWire[in.To],
		Note:       in.Note, Location: in.Location,
		OccurredAt: stamp(in.OccurredAt), RecordedBy: in.RecordedBy,
	}
}

func instrumentEventsToProto(in []domain.InstrumentEvent) []*sterilev1.InstrumentEvent {
	out := make([]*sterilev1.InstrumentEvent, 0, len(in))
	for _, event := range in {
		out = append(out, instrumentEventToProto(event))
	}
	return out
}

func instrumentsToProto(in []domain.Instrument) []*sterilev1.Instrument {
	out := make([]*sterilev1.Instrument, 0, len(in))
	for _, instrument := range in {
		out = append(out, instrumentToProto(instrument))
	}
	return out
}

func packingItemsFromProto(in []*sterilev1.PackingItem) []domain.PackingItem {
	out := make([]domain.PackingItem, 0, len(in))
	for _, item := range in {
		out = append(out, domain.PackingItem{
			Code: item.GetCode(), Display: item.GetDisplay(),
			Quantity: int(item.GetQuantity()), Critical: item.GetCritical(),
		})
	}
	return out
}

func packingItemsToProto(in []domain.PackingItem) []*sterilev1.PackingItem {
	out := make([]*sterilev1.PackingItem, 0, len(in))
	for _, item := range in {
		out = append(out, &sterilev1.PackingItem{
			Code: item.Code, Display: item.Display,
			Quantity: int32(item.Quantity), Critical: item.Critical,
		})
	}
	return out
}

func setToProto(in domain.TraySet) *sterilev1.TraySet {
	return &sterilev1.TraySet{
		SetId: in.ID, Code: in.Code, Display: in.Display, Kind: in.Kind,
		SetVersion: int32(in.Version), Supersedes: in.Supersedes,
		Current: in.Current(), Items: packingItemsToProto(in.Items),
		ShelfLifeSeconds: int64(in.ShelfLife / time.Second),
		CreatedAt:        stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		SupersededAt: stamp(in.SupersededAt),
	}
}

func setsToProto(in []domain.TraySet) []*sterilev1.TraySet {
	out := make([]*sterilev1.TraySet, 0, len(in))
	for _, set := range in {
		out = append(out, setToProto(set))
	}
	return out
}

func stageRecordToProto(in domain.StageRecord) *sterilev1.StageRecord {
	return &sterilev1.StageRecord{
		StageRecordId: in.ID, RunId: in.RunID,
		Stage: stageToWire[in.Stage], Equipment: in.Equipment, Notes: in.Notes,
		Skipped: in.Skipped, SkipAuthorisedBy: in.SkipAuthorisedBy,
		SkipReason:  in.SkipReason,
		PerformedAt: stamp(in.PerformedAt), PerformedBy: in.PerformedBy,
	}
}

func stageRecordsToProto(in []domain.StageRecord) []*sterilev1.StageRecord {
	out := make([]*sterilev1.StageRecord, 0, len(in))
	for _, record := range in {
		out = append(out, stageRecordToProto(record))
	}
	return out
}

// runToProto renders a pack.
//
// The clock is passed in because issuable is two independent failures —
// unreleased and expired — and a client that checked only the stage would
// offer an out-of-date pack.
func runToProto(in domain.Run, now time.Time) *sterilev1.Run {
	return &sterilev1.Run{
		RunId: in.ID, SetId: in.SetID, SetVersion: int32(in.SetVersion),
		SetCode: in.SetCode, SourceUnit: in.SourceUnit,
		SourceCaseId: in.SourceCaseID,
		Stage:        stageToWire[in.Stage], Stages: stageRecordsToProto(in.Stages),
		ReceivedCount: countsToProto(in.ReceivedCount),
		PackedCount:   countsToProto(in.PackedCount),
		Missing:       in.Missing, Replaced: in.Replaced,
		CycleId: in.CycleID, PackagingMethod: in.PackagingMethod,
		IndicatorType: in.IndicatorType,
		SterilisedAt:  stamp(in.SterilisedAt), ExpiresAt: stamp(in.ExpiresAt),
		StartedAt: stamp(in.StartedAt), StartedBy: in.StartedBy,
		Version:       in.Version,
		Issuable:      in.Issuable(now),
		SkippedStages: in.SkippedStages(),
	}
}

func runsToProto(in []domain.Run, now time.Time) []*sterilev1.Run {
	out := make([]*sterilev1.Run, 0, len(in))
	for _, run := range in {
		out = append(out, runToProto(run, now))
	}
	return out
}

func indicatorToProto(in domain.IndicatorResult) *sterilev1.IndicatorResult {
	return &sterilev1.IndicatorResult{
		IndicatorId: in.ID, CycleId: in.CycleID,
		Kind: indicatorToWire[in.Kind], Lot: in.Lot, Passed: in.Passed,
		Notes: in.Notes, ReadAt: stamp(in.ReadAt), ReadBy: in.ReadBy,
	}
}

func cycleToProto(in domain.Cycle) *sterilev1.Cycle {
	indicators := make([]*sterilev1.IndicatorResult, 0, len(in.Indicators))
	for _, indicator := range in.Indicators {
		indicators = append(indicators, indicatorToProto(indicator))
	}
	return &sterilev1.Cycle{
		CycleId: in.ID, Machine: in.Machine, LoadNumber: in.LoadNumber,
		Program: in.Program, Parameters: in.Parameters,
		Source: cycleSourceToWire[in.Source],
		Result: cycleResultToWire[in.Result],
		// Released stays a field of its own: a passed cycle whose biological
		// indicator is still incubating is a load nobody may distribute yet.
		Released: in.Released, ReleasedBy: in.ReleasedBy,
		ReleasedAt: stamp(in.ReleasedAt), ReleaseNote: in.ReleaseNote,
		Indicators: indicators,
		StartedAt:  stamp(in.StartedAt), EndedAt: stamp(in.EndedAt),
		StartedBy: in.StartedBy, Version: in.Version,
	}
}

func cyclesToProto(in []domain.Cycle) []*sterilev1.Cycle {
	out := make([]*sterilev1.Cycle, 0, len(in))
	for _, cycle := range in {
		out = append(out, cycleToProto(cycle))
	}
	return out
}

func decisionToProto(in domain.ReleaseDecision) *sterilev1.ReleaseDecision {
	refusals := make([]sterilev1.ReleaseRefusal, 0, len(in.Refusals))
	for _, refusal := range in.Refusals {
		refusals = append(refusals, refusalToWire[refusal])
	}
	return &sterilev1.ReleaseDecision{
		Allowed: in.Allowed(), Refusals: refusals,
		Explanations: in.Explanations,
	}
}

func labelToProto(in domain.Label) *sterilev1.Label {
	return &sterilev1.Label{
		RunId: in.RunID, SetCode: in.SetCode, SetVersion: int32(in.SetVersion),
		CycleId: in.CycleID, LoadNumber: in.LoadNumber, Machine: in.Machine,
		SterilisedAt: stamp(in.SterilisedAt), ExpiresAt: stamp(in.ExpiresAt),
		// Carried rather than dropped: a pack whose label silently omitted its
		// cycle would look like any other.
		Incomplete: in.Incomplete,
	}
}

func issueToProto(in domain.Issue) *sterilev1.Issue {
	return &sterilev1.Issue{
		IssueId: in.ID, RunId: in.RunID, SetCode: in.SetCode,
		CycleId: in.CycleID, Destination: in.Destination, IssuedTo: in.IssuedTo,
		State: issueStateToWire[in.State], UsedCaseId: in.UsedCaseID,
		ReturnCount: countsToProto(in.ReturnCount), ReturnNote: in.ReturnNote,
		IssuedAt: stamp(in.IssuedAt), IssuedBy: in.IssuedBy,
		ClosedAt: stamp(in.ClosedAt), ClosedBy: in.ClosedBy,
	}
}

func issuesToProto(in []domain.Issue) []*sterilev1.Issue {
	out := make([]*sterilev1.Issue, 0, len(in))
	for _, issue := range in {
		out = append(out, issueToProto(issue))
	}
	return out
}

func traceToProto(in domain.CaseTrace) *sterilev1.CaseTrace {
	sets := make([]*sterilev1.TracedSet, 0, len(in.Sets))
	for _, set := range in.Sets {
		sets = append(sets, &sterilev1.TracedSet{
			RunId: set.RunID, SetCode: set.SetCode,
			SetVersion: int32(set.SetVersion), CycleId: set.CycleID,
			LoadNumber: set.LoadNumber, Machine: set.Machine,
			SkippedStages: set.SkippedStages,
			SterilisedAt:  stamp(set.SterilisedAt), UsedAt: stamp(set.UsedAt),
		})
	}
	return &sterilev1.CaseTrace{
		CaseId: in.CaseID, Sets: sets,
		// So a reader can tell "three sets" from "three sets that we know of".
		Incomplete: in.Incomplete,
	}
}

func scopeToProto(in domain.RecallScope) *sterilev1.RecallScope {
	packs := make([]*sterilev1.RecalledPack, 0, len(in.Packs))
	for _, pack := range in.Packs {
		packs = append(packs, &sterilev1.RecalledPack{
			RunId: pack.RunID, SetCode: pack.SetCode, State: pack.State,
			Location: pack.Location, UsedCaseId: pack.UsedCaseID,
		})
	}
	return &sterilev1.RecallScope{
		CycleId: in.CycleID, LoadNumber: in.LoadNumber, Reason: in.Reason,
		Packs: packs, Cases: in.Cases, Locations: in.Locations,
	}
}

func recallToProto(in ports.Recall) *sterilev1.Recall {
	return &sterilev1.Recall{
		RecallId: in.ID, CycleId: in.CycleID, Reason: in.Reason,
		PacksAffected: int32(in.PacksAffected),
		CasesAffected: int32(in.CasesAffected),
		RaisedAt:      stamp(in.RaisedAt), RaisedBy: in.RaisedBy,
		ClosedAt: stamp(in.ClosedAt), ClosedBy: in.ClosedBy,
		ClosingNote: in.ClosingNote,
	}
}

func recallsToProto(in []ports.Recall) []*sterilev1.Recall {
	out := make([]*sterilev1.Recall, 0, len(in))
	for _, recall := range in {
		out = append(out, recallToProto(recall))
	}
	return out
}
