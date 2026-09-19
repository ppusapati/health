package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// InsertRule stores a retention rule revision (SRS-MRD-009).
func (r *Repository) InsertRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.RetentionRule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(rule.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_RULE_ID_INVALID", "rule id must be a UUID")
	}

	return r.queries(ctx).InsertRecordsRetentionRule(ctx,
		sqlcgen.InsertRecordsRetentionRuleParams{
			RuleID: ruleID, TenantID: tenantID, Code: rule.Code,
			Name: rule.Name, Revision: int32(rule.Revision),
			RecordClass: rule.RecordClass, Jurisdiction: rule.Jurisdiction,
			Anchor: string(rule.Anchor), RetainYears: int32(rule.RetainYears),
			Disposition: string(rule.Disposition), Authority: rule.Authority,
			EffectiveFrom: stamp(rule.EffectiveFrom),
			CreatedAt:     stamp(rule.CreatedAt), CreatedBy: rule.CreatedBy,
		})
}

// Rule reads one retention rule revision.
func (r *Repository) Rule(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.RetentionRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.RetentionRule{}, err
	}
	ruleID, err := uuid.Parse(id)
	if err != nil {
		return domain.RetentionRule{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsRetentionRule(ctx,
		sqlcgen.GetRecordsRetentionRuleParams{
			TenantID: tenantID, RuleID: ruleID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.RetentionRule{}, notFound()
	}
	if err != nil {
		return domain.RetentionRule{}, err
	}
	return retentionRuleFrom(row), nil
}

// ApproveRule puts a retention rule in force.
func (r *Repository) ApproveRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.RetentionRule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(rule.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveRecordsRetentionRule(ctx,
		sqlcgen.ApproveRecordsRetentionRuleParams{
			ApprovedBy: rule.ApprovedBy, ApprovedAt: stamp(rule.ApprovedAt),
			EffectiveFrom: stamp(rule.EffectiveFrom),
			TenantID:      tenantID, RuleID: ruleID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("MRD_RULE_ALREADY_APPROVED",
			"this retention rule is already approved")
	}
	return nil
}

// SupersedeEarlierRules closes off every earlier revision of a rule code.
func (r *Repository) SupersedeEarlierRules(ctx context.Context,
	scope authctx.TenantScope, code string, revision int,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).SupersedeRecordsRetentionRule(ctx,
		sqlcgen.SupersedeRecordsRetentionRuleParams{
			SupersededAt: stamp(at), TenantID: tenantID, Code: code,
			Revision: int32(revision),
		})
	return err
}

// Rules lists retention rules.
func (r *Repository) Rules(ctx context.Context, scope authctx.TenantScope,
	jurisdiction, recordClass string, liveAt time.Time) (
	[]domain.RetentionRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	at := liveAt
	if at.IsZero() {
		at = epoch
	}

	rows, err := r.queries(ctx).ListRecordsRetentionRules(ctx,
		sqlcgen.ListRecordsRetentionRulesParams{
			TenantID: tenantID, Jurisdiction: jurisdiction,
			RecordClass: recordClass,
			LiveOnly:    !liveAt.IsZero(), At: stamp(at),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.RetentionRule, 0, len(rows))
	for _, row := range rows {
		out = append(out, retentionRuleFrom(row))
	}
	return out, nil
}

func retentionRuleFrom(
	row sqlcgen.RecordsRetentionRule) domain.RetentionRule {

	return domain.RetentionRule{
		ID: row.RuleID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		RecordClass: row.RecordClass, Jurisdiction: row.Jurisdiction,
		Anchor:      domain.RetentionAnchor(row.Anchor),
		RetainYears: int(row.RetainYears),
		Disposition: domain.DispositionKind(row.Disposition),
		Authority:   row.Authority,
		Approved:    row.Approved, ApprovedBy: row.ApprovedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
	}
}

// InsertList stores a disposition batch and its items (SRS-MRD-009).
func (r *Repository) InsertList(ctx context.Context,
	scope authctx.TenantScope, l domain.DispositionList) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	listID, err := uuid.Parse(l.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_LIST_ID_INVALID", "list id must be a UUID")
	}

	queries := r.queries(ctx)
	if err := queries.InsertRecordsDispositionList(ctx,
		sqlcgen.InsertRecordsDispositionListParams{
			ListID: listID, TenantID: tenantID, Reference: l.Reference,
			Jurisdiction: l.Jurisdiction,
			Disposition:  string(l.Disposition), State: string(l.State),
			PreparedAt: stamp(l.PreparedAt), PreparedBy: l.PreparedBy,
		}); err != nil {
		return err
	}

	for _, item := range l.Items {
		if err := queries.InsertRecordsDispositionItem(ctx,
			sqlcgen.InsertRecordsDispositionItemParams{
				ItemID: uuid.New(), TenantID: tenantID, ListID: listID,
				RecordID: item.RecordID, PatientID: item.PatientID,
				RecordClass:  item.RecordClass,
				Description:  item.Description,
				RuleCode:     item.RuleCode,
				RuleRevision: int32(item.RuleRevision),
				Authority:    item.Authority,
				AnchorDate:   stamp(item.AnchorDate),
				EligibleFrom: stamp(item.EligibleFrom),
			}); err != nil {
			return err
		}
	}
	return nil
}

// List reads one disposition batch and its items.
func (r *Repository) List(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.DispositionList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.DispositionList{}, err
	}
	listID, err := uuid.Parse(id)
	if err != nil {
		return domain.DispositionList{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsDispositionList(ctx,
		sqlcgen.GetRecordsDispositionListParams{
			TenantID: tenantID, ListID: listID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.DispositionList{}, notFound()
	}
	if err != nil {
		return domain.DispositionList{}, err
	}

	list := dispositionListFrom(row)
	items, err := r.queries(ctx).ListRecordsDispositionItems(ctx,
		sqlcgen.ListRecordsDispositionItemsParams{
			TenantID: tenantID, ListID: listID,
		})
	if err != nil {
		return domain.DispositionList{}, err
	}
	for _, item := range items {
		list.Items = append(list.Items, domain.DispositionCandidate{
			RecordID: item.RecordID, PatientID: item.PatientID,
			RecordClass: item.RecordClass, Description: item.Description,
			RuleCode: item.RuleCode, RuleRevision: int(item.RuleRevision),
			Authority: item.Authority, Disposition: list.Disposition,
			AnchorDate:   timeOf(item.AnchorDate),
			EligibleFrom: timeOf(item.EligibleFrom),
		})
	}
	return list, nil
}

// UpdateList records an approval, an execution or a cancellation.
func (r *Repository) UpdateList(ctx context.Context,
	scope authctx.TenantScope, l domain.DispositionList,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	listID, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateRecordsDispositionList(ctx,
		sqlcgen.UpdateRecordsDispositionListParams{
			State:      string(l.State),
			ApprovedAt: stamp(l.ApprovedAt), ApprovedBy: l.ApprovedBy,
			ExecutedAt: stamp(l.ExecutedAt), ExecutedBy: l.ExecutedBy,
			Certificate:     l.Certificate,
			CancelledReason: l.CancelledReason,
			TenantID:        tenantID, ListID: listID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Lists lists disposition batches.
func (r *Repository) Lists(ctx context.Context, scope authctx.TenantScope,
	f ports.DispositionFilter) ([]domain.DispositionList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListRecordsDispositionLists(ctx,
		sqlcgen.ListRecordsDispositionListsParams{
			TenantID: tenantID, State: f.State,
			Jurisdiction: f.Jurisdiction,
			PageSize:     limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.DispositionList, 0, len(rows))
	for _, row := range rows {
		out = append(out, dispositionListFrom(row))
	}
	return out, nil
}

func dispositionListFrom(
	row sqlcgen.RecordsDispositionList) domain.DispositionList {

	return domain.DispositionList{
		ID: row.ListID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Jurisdiction: row.Jurisdiction,
		Disposition: domain.DispositionKind(row.Disposition),
		State:       domain.DispositionState(row.State),
		PreparedAt:  timeOf(row.PreparedAt), PreparedBy: row.PreparedBy,
		ApprovedAt: timeOf(row.ApprovedAt), ApprovedBy: row.ApprovedBy,
		ExecutedAt: timeOf(row.ExecutedAt), ExecutedBy: row.ExecutedBy,
		Certificate:     row.Certificate,
		CancelledReason: row.CancelledReason, Version: row.Version,
	}
}

// InsertPhysicalRecord records a paper volume (SRS-MRD-006).
func (r *Repository) InsertPhysicalRecord(ctx context.Context,
	scope authctx.TenantScope, p domain.PhysicalRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	recordID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Invalid("MRD_PHYSICAL_ID_INVALID",
			"record id must be a UUID")
	}

	return r.queries(ctx).InsertRecordsPhysicalRecord(ctx,
		sqlcgen.InsertRecordsPhysicalRecordParams{
			RecordID: recordID, TenantID: tenantID,
			Reference: p.Reference, PatientID: p.PatientID,
			Volume: int32(p.Volume), RecordClass: p.RecordClass,
			Jurisdiction: p.Jurisdiction, Description: p.Description,
			State: string(p.State), HomeLocation: p.HomeLocation,
			CurrentLocation: p.CurrentLocation,
			CreatedAt:       stamp(p.CreatedAt), CreatedBy: p.CreatedBy,
		})
}

// PhysicalRecord reads one paper volume.
func (r *Repository) PhysicalRecord(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.PhysicalRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PhysicalRecord{}, err
	}
	recordID, err := uuid.Parse(id)
	if err != nil {
		return domain.PhysicalRecord{}, notFound()
	}

	row, err := r.queries(ctx).GetRecordsPhysicalRecord(ctx,
		sqlcgen.GetRecordsPhysicalRecordParams{
			TenantID: tenantID, RecordID: recordID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PhysicalRecord{}, notFound()
	}
	if err != nil {
		return domain.PhysicalRecord{}, err
	}
	return physicalFrom(row), nil
}

// UpdatePhysicalRecord records a check-out, a check-in or a disposal.
func (r *Repository) UpdatePhysicalRecord(ctx context.Context,
	scope authctx.TenantScope, p domain.PhysicalRecord,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	recordID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateRecordsPhysicalRecord(ctx,
		sqlcgen.UpdateRecordsPhysicalRecordParams{
			State: string(p.State), HomeLocation: p.HomeLocation,
			CurrentLocation: p.CurrentLocation, Custodian: p.Custodian,
			CheckedOutAt: stamp(p.CheckedOutAt),
			CheckedOutBy: p.CheckedOutBy,
			DueBackAt:    stamp(p.DueBackAt), Purpose: p.Purpose,
			TenantID: tenantID, RecordID: recordID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// PhysicalRecords lists paper volumes.
func (r *Repository) PhysicalRecords(ctx context.Context,
	scope authctx.TenantScope, f ports.PhysicalFilter, at time.Time) (
	[]domain.PhysicalRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if at.IsZero() {
		at = farFuture
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListRecordsPhysicalRecords(ctx,
		sqlcgen.ListRecordsPhysicalRecordsParams{
			TenantID: tenantID, PatientID: f.PatientID, State: f.State,
			OutOnly: f.OutOnly, OverdueOnly: f.OverdueOnly, At: stamp(at),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.PhysicalRecord, 0, len(rows))
	for _, row := range rows {
		out = append(out, physicalFrom(row))
	}
	return out, nil
}

func physicalFrom(row sqlcgen.RecordsPhysicalRecord) domain.PhysicalRecord {
	return domain.PhysicalRecord{
		ID: row.RecordID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, PatientID: row.PatientID,
		Volume: int(row.Volume), RecordClass: row.RecordClass,
		Jurisdiction: row.Jurisdiction, Description: row.Description,
		State:           domain.PhysicalState(row.State),
		HomeLocation:    row.HomeLocation,
		CurrentLocation: row.CurrentLocation, Custodian: row.Custodian,
		CheckedOutAt: timeOf(row.CheckedOutAt),
		CheckedOutBy: row.CheckedOutBy,
		DueBackAt:    timeOf(row.DueBackAt), Purpose: row.Purpose,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// Retained lists the paper volumes this context holds, for a retention sweep
// (SRS-MRD-009).
//
// The paper records only. The electronic ones belong to every other context
// and a deployment that wants them swept supplies an adapter that knows where
// they are — which the status document names rather than this code sweeping
// half a hospital and reporting it as all of it. Records already destroyed
// or archived are excluded: a disposition list that proposed destroying a
// record twice would be approved twice.
func (r *Repository) Retained(ctx context.Context,
	scope authctx.TenantScope, jurisdiction string, limit int32) (
	[]domain.RetainedRecord, error) {

	records, err := r.PhysicalRecords(ctx, scope, ports.PhysicalFilter{
		Limit: limit,
	}, time.Time{})
	if err != nil {
		return nil, err
	}

	out := make([]domain.RetainedRecord, 0, len(records))
	for _, record := range records {
		switch record.State {
		case domain.PhysicalDestroyed, domain.PhysicalArchived:
			continue
		case domain.PhysicalOut, domain.PhysicalMissing:
			// A volume somebody has in their hands, or one nobody can find,
			// is not something to propose destroying: the destruction would
			// be refused at execution and the whole list with it, after an
			// approver had signed for every record on it.
			continue
		}
		if jurisdiction != "" && record.Jurisdiction != jurisdiction {
			continue
		}
		out = append(out, domain.RetainedRecord{
			RecordID: record.ID, PatientID: record.PatientID,
			RecordClass:  record.RecordClass,
			Jurisdiction: record.Jurisdiction,
			// The only anchor a paper folder knows about itself is when it
			// was registered here. A deployment whose rules anchor to
			// discharge or death supplies an inventory adapter that can
			// answer those; this one says what it knows rather than
			// guessing, and a rule it cannot answer reports the record as
			// having no anchor date.
			AnchorDates: map[domain.RetentionAnchor]time.Time{
				domain.AnchorCreation: record.CreatedAt,
			},
			Description: record.Reference,
		})
	}
	return out, nil
}
