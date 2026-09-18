package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/theatre/domain"
	"github.com/ppusapati/health/code/internal/theatre/ports"
)

// CaseRepo implements ports.CaseRepository.
type CaseRepo struct{ *Repository }

var _ ports.CaseRepository = CaseRepo{}

// SavePreopEntry records or replaces one pre-operative answer.
func (r CaseRepo) SavePreopEntry(ctx context.Context, scope authctx.TenantScope,
	caseID string, e domain.PreopEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).UpsertPreopEntry(ctx, sqlcgen.UpsertPreopEntryParams{
		CaseID: id, TenantID: tenantID, Code: e.Code, State: string(e.State),
		Note: e.Note, WaivedBy: e.WaivedBy, WaivedRole: e.WaivedRole,
		RecordedBy: e.RecordedBy, RecordedAt: stamp(e.RecordedAt),
	})
}

// PreopChecklist reads a case's readiness record.
func (r CaseRepo) PreopChecklist(ctx context.Context, scope authctx.TenantScope,
	caseID string) (domain.PreopChecklist, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PreopChecklist{}, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return domain.PreopChecklist{}, notFound()
	}

	rows, err := r.queries(ctx).ListPreopEntries(ctx, sqlcgen.ListPreopEntriesParams{
		TenantID: tenantID, CaseID: id,
	})
	if err != nil {
		return domain.PreopChecklist{}, err
	}

	out := domain.PreopChecklist{ID: caseID, TenantID: scope.TenantID(), CaseID: caseID}
	for _, row := range rows {
		entry := domain.PreopEntry{
			Code: row.Code, State: domain.PreopState(row.State), Note: row.Note,
			WaivedBy: row.WaivedBy, WaivedRole: row.WaivedRole,
			RecordedBy: row.RecordedBy, RecordedAt: timeOf(row.RecordedAt),
		}
		out.Entries = append(out.Entries, entry)
		if entry.RecordedAt.After(out.UpdatedAt) {
			out.UpdatedAt = entry.RecordedAt
		}
	}
	return out, nil
}

// InsertSafetyCheck records one phase of the safety checklist with its answers.
//
// Both, in one transaction: a phase written without its answers is a check
// that says a team stopped and cannot say what they agreed.
func (r CaseRepo) InsertSafetyCheck(ctx context.Context, scope authctx.TenantScope,
	record domain.SafetyRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	checkID, err := uuid.Parse(record.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(record.CaseID)
	if err != nil {
		return notFound()
	}

	return r.tx.WithinTx(ctx, func(ctx context.Context) error {
		queries := r.queries(ctx)
		if err := queries.InsertSafetyCheck(ctx, sqlcgen.InsertSafetyCheckParams{
			CheckID: checkID, TenantID: tenantID, CaseID: caseID,
			Phase: string(record.Phase), Participants: strings0(record.Participants),
			PerformedAt: stamp(record.PerformedAt), PerformedBy: record.PerformedBy,
		}); err != nil {
			return err
		}
		for _, answer := range record.Answers {
			if err := queries.InsertSafetyAnswer(ctx, sqlcgen.InsertSafetyAnswerParams{
				CheckID: checkID, Code: answer.Code,
				Confirmed: answer.Confirmed, Exception: answer.Exception,
			}); err != nil {
				return err
			}
		}
		return nil
	})
}

// SafetyChecks reads a case's safety checks with their answers.
func (r CaseRepo) SafetyChecks(ctx context.Context, scope authctx.TenantScope,
	caseID string) ([]domain.SafetyRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	queries := r.queries(ctx)
	rows, err := queries.ListSafetyChecks(ctx, sqlcgen.ListSafetyChecksParams{
		TenantID: tenantID, CaseID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.SafetyRecord, 0, len(rows))
	for _, row := range rows {
		record := domain.SafetyRecord{
			ID: row.CheckID.String(), TenantID: row.TenantID.String(),
			CaseID: row.CaseID.String(), Phase: domain.SafetyPhase(row.Phase),
			Participants: row.Participants,
			PerformedAt:  timeOf(row.PerformedAt), PerformedBy: row.PerformedBy,
		}
		answers, err := queries.ListSafetyAnswers(ctx, row.CheckID)
		if err != nil {
			return nil, err
		}
		for _, answer := range answers {
			record.Answers = append(record.Answers, domain.SafetyAnswer{
				Code: answer.Code, Confirmed: answer.Confirmed,
				Exception: answer.Exception,
			})
		}
		out = append(out, record)
	}
	return out, nil
}

// InsertMilestone times one milestone.
func (r CaseRepo) InsertMilestone(ctx context.Context, scope authctx.TenantScope,
	m domain.MilestoneRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	milestoneID, err := uuid.Parse(m.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(m.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTheatreMilestone(ctx,
		sqlcgen.InsertTheatreMilestoneParams{
			MilestoneID: milestoneID, TenantID: tenantID, CaseID: caseID,
			Milestone:  string(m.Milestone),
			OccurredAt: stamp(m.OccurredAt), RecordedAt: stamp(m.RecordedAt),
			RecordedBy: m.RecordedBy, Note: m.Note,
		})
}

// Milestones reads one case's movement record.
func (r CaseRepo) Milestones(ctx context.Context, scope authctx.TenantScope,
	caseID string) (domain.Milestones, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTheatreMilestones(ctx,
		sqlcgen.ListTheatreMilestonesParams{TenantID: tenantID, CaseID: id})
	if err != nil {
		return nil, err
	}
	out := make(domain.Milestones, 0, len(rows))
	for _, row := range rows {
		out = append(out, milestoneFrom(row))
	}
	return out, nil
}

// MilestonesFor reads many cases at once.
func (r CaseRepo) MilestonesFor(ctx context.Context, scope authctx.TenantScope,
	caseIDs []string) (map[string]domain.Milestones, error) {

	out := map[string]domain.Milestones{}
	if len(caseIDs) == 0 {
		return out, nil
	}
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListTheatreMilestonesForCases(ctx,
		sqlcgen.ListTheatreMilestonesForCasesParams{
			TenantID: tenantID, CaseIds: uuidList(caseIDs),
		})
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		id := row.CaseID.String()
		out[id] = append(out[id], milestoneFrom(row))
	}
	return out, nil
}

func milestoneFrom(row sqlcgen.TheatreMilestone) domain.MilestoneRecord {
	return domain.MilestoneRecord{
		ID: row.MilestoneID.String(), TenantID: row.TenantID.String(),
		CaseID: row.CaseID.String(), Milestone: domain.Milestone(row.Milestone),
		OccurredAt: timeOf(row.OccurredAt), RecordedAt: timeOf(row.RecordedAt),
		RecordedBy: row.RecordedBy, Note: row.Note,
	}
}

// InsertDelay records a delay.
func (r CaseRepo) InsertDelay(ctx context.Context, scope authctx.TenantScope,
	d domain.Delay) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	delayID, err := uuid.Parse(d.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(d.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTheatreDelay(ctx, sqlcgen.InsertTheatreDelayParams{
		DelayID: delayID, TenantID: tenantID, CaseID: caseID,
		Reason: string(d.Reason), Dependency: d.Dependency,
		Minutes: int32(d.Minutes), Note: d.Note,
		RecordedAt: stamp(d.RecordedAt), RecordedBy: d.RecordedBy,
	})
}

// DelaysFor reads delays for many cases at once.
func (r CaseRepo) DelaysFor(ctx context.Context, scope authctx.TenantScope,
	caseIDs []string) (map[string][]domain.Delay, error) {

	out := map[string][]domain.Delay{}
	if len(caseIDs) == 0 {
		return out, nil
	}
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListTheatreDelaysForCases(ctx,
		sqlcgen.ListTheatreDelaysForCasesParams{
			TenantID: tenantID, CaseIds: uuidList(caseIDs),
		})
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		id := row.CaseID.String()
		out[id] = append(out[id], domain.Delay{
			ID: row.DelayID.String(), TenantID: row.TenantID.String(),
			CaseID: id, Reason: domain.DelayReason(row.Reason),
			Dependency: row.Dependency, Minutes: int(row.Minutes), Note: row.Note,
			RecordedAt: timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

// InsertNote writes an operative note or an amendment.
func (r CaseRepo) InsertNote(ctx context.Context, scope authctx.TenantScope,
	n domain.OperativeNote) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	noteID, err := uuid.Parse(n.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(n.CaseID)
	if err != nil {
		return notFound()
	}
	supersedes, err := optionalUUID(n.Supersedes)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertOperativeNote(ctx, sqlcgen.InsertOperativeNoteParams{
		NoteID: noteID, TenantID: tenantID, CaseID: caseID,
		Version: int32(n.Version), Supersedes: supersedes,
		ProcedurePerformed: n.ProcedurePerformed, Findings: n.Findings,
		SpecimenIds: strings0(n.SpecimenIDs), ImplantIds: strings0(n.ImplantIDs),
		Complications:        strings0(n.Complications),
		EstimatedBloodLossMl: int32(n.EstimatedBloodLossML),
		PostOperativeOrders:  n.PostOperativeOrders,
		Narrative:            n.Narrative,
		Status:               string(n.Status),
		AmendmentReason:      n.AmendmentReason,
		AuthoredBy:           n.AuthoredBy,
		AuthoredAt:           stamp(n.AuthoredAt),
		SignedBy:             n.SignedBy,
		SignedAt:             stamp(n.SignedAt),
	})
}

// SignNote signs a draft. False where it was already signed.
func (r CaseRepo) SignNote(ctx context.Context, scope authctx.TenantScope,
	noteID, by string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(noteID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).SignOperativeNote(ctx, sqlcgen.SignOperativeNoteParams{
		SignedBy: by, SignedAt: stamp(at), TenantID: tenantID, NoteID: id,
	})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// SupersedeNote marks a note replaced by an amendment.
func (r CaseRepo) SupersedeNote(ctx context.Context, scope authctx.TenantScope,
	noteID string) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(noteID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).SupersedeOperativeNote(ctx,
		sqlcgen.SupersedeOperativeNoteParams{TenantID: tenantID, NoteID: id})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// Notes reads a case's operative notes, every version.
func (r CaseRepo) Notes(ctx context.Context, scope authctx.TenantScope,
	caseID string) ([]domain.OperativeNote, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListOperativeNotes(ctx, sqlcgen.ListOperativeNotesParams{
		TenantID: tenantID, CaseID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.OperativeNote, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.OperativeNote{
			ID: row.NoteID.String(), TenantID: row.TenantID.String(),
			CaseID: row.CaseID.String(), Version: int(row.Version),
			Supersedes:         uuidOrEmpty(row.Supersedes),
			ProcedurePerformed: row.ProcedurePerformed, Findings: row.Findings,
			SpecimenIDs: row.SpecimenIds, ImplantIDs: row.ImplantIds,
			Complications:        row.Complications,
			EstimatedBloodLossML: int(row.EstimatedBloodLossMl),
			PostOperativeOrders:  row.PostOperativeOrders,
			Narrative:            row.Narrative,
			Status:               domain.NoteStatus(row.Status),
			AmendmentReason:      row.AmendmentReason,
			AuthoredBy:           row.AuthoredBy, AuthoredAt: timeOf(row.AuthoredAt),
			SignedBy: row.SignedBy, SignedAt: timeOf(row.SignedAt),
		})
	}
	return out, nil
}

// InsertUsage records a consumable or implant.
func (r CaseRepo) InsertUsage(ctx context.Context, scope authctx.TenantScope,
	u domain.Usage) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	usageID, err := uuid.Parse(u.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(u.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTheatreUsage(ctx, sqlcgen.InsertTheatreUsageParams{
		UsageID: usageID, TenantID: tenantID, CaseID: caseID,
		Kind: string(u.Kind), ItemCode: u.ItemCode, ItemName: u.ItemName,
		LotNumber: u.LotNumber, SerialNumber: u.SerialNumber,
		Quantity: int32(u.Quantity), ExpiryDate: stamp(u.ExpiryDate),
		Scanned: u.Scanned, ScanData: u.ScanData,
		RecordedAt: stamp(u.RecordedAt), RecordedBy: u.RecordedBy,
	})
}

// Usage reads what a case used.
func (r CaseRepo) Usage(ctx context.Context, scope authctx.TenantScope,
	caseID string) ([]domain.Usage, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTheatreUsage(ctx, sqlcgen.ListTheatreUsageParams{
		TenantID: tenantID, CaseID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Usage, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Usage{
			ID: row.UsageID.String(), TenantID: row.TenantID.String(),
			CaseID: row.CaseID.String(), Kind: domain.UsageKind(row.Kind),
			ItemCode: row.ItemCode, ItemName: row.ItemName,
			LotNumber: row.LotNumber, SerialNumber: row.SerialNumber,
			Quantity: int(row.Quantity), ExpiryDate: timeOf(row.ExpiryDate),
			Scanned: row.Scanned, ScanData: row.ScanData,
			RecordedAt: timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

// ImplantRecipients is the direction a recall runs.
func (r CaseRepo) ImplantRecipients(ctx context.Context, scope authctx.TenantScope,
	itemCode, lotNumber string) ([]ports.Recipient, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).FindImplantUsage(ctx, sqlcgen.FindImplantUsageParams{
		TenantID: tenantID, ItemCode: itemCode, LotNumber: lotNumber,
	})
	if err != nil {
		return nil, err
	}
	out := make([]ports.Recipient, 0, len(rows))
	for _, row := range rows {
		reference := row.SerialNumber
		if reference == "" {
			reference = row.LotNumber
		}
		out = append(out, ports.Recipient{
			PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
			CaseID: row.CaseID.String(), Reference: reference,
			At: timeOf(row.RecordedAt),
		})
	}
	return out, nil
}

// InsertSpecimen records a specimen taken in theatre.
func (r CaseRepo) InsertSpecimen(ctx context.Context, scope authctx.TenantScope,
	s domain.Specimen) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	specimenID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(s.CaseID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(s.PatientID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTheatreSpecimen(ctx,
		sqlcgen.InsertTheatreSpecimenParams{
			SpecimenID: specimenID, TenantID: tenantID, CaseID: caseID,
			PatientID: patientID, Label: s.Label, Site: s.Site,
			Laterality: string(s.Laterality), Container: s.Container,
			Fixative: s.Fixative,
			TakenAt:  stamp(s.TakenAt), TakenBy: s.TakenBy,
		})
}

// Accession links a specimen to an order. False where somebody linked it first.
func (r CaseRepo) Accession(ctx context.Context, scope authctx.TenantScope,
	specimenID, orderID string) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(specimenID)
	if err != nil {
		return false, notFound()
	}
	order, err := optionalUUID(orderID)
	if err != nil {
		return false, err
	}

	rows, err := r.queries(ctx).AccessionTheatreSpecimen(ctx,
		sqlcgen.AccessionTheatreSpecimenParams{
			OrderID: order, TenantID: tenantID, SpecimenID: id,
		})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// Specimens reads a case's specimens.
func (r CaseRepo) Specimens(ctx context.Context, scope authctx.TenantScope,
	caseID string) ([]domain.Specimen, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTheatreSpecimens(ctx,
		sqlcgen.ListTheatreSpecimensParams{TenantID: tenantID, CaseID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Specimen, 0, len(rows))
	for _, row := range rows {
		out = append(out, specimenFrom(row))
	}
	return out, nil
}

// UnaccessionedSpecimens is the theatre's outstanding chain.
func (r CaseRepo) UnaccessionedSpecimens(ctx context.Context,
	scope authctx.TenantScope, facilityID string, limit int32) (
	[]domain.Specimen, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListUnaccessionedSpecimens(ctx,
		sqlcgen.ListUnaccessionedSpecimensParams{
			TenantID: tenantID, FacilityID: facilityID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Specimen, 0, len(rows))
	for _, row := range rows {
		out = append(out, specimenFrom(row))
	}
	return out, nil
}

func specimenFrom(row sqlcgen.TheatreSpecimen) domain.Specimen {
	return domain.Specimen{
		ID: row.SpecimenID.String(), TenantID: row.TenantID.String(),
		CaseID: row.CaseID.String(), PatientID: row.PatientID.String(),
		Label: row.Label, Site: row.Site,
		Laterality: domain.Laterality(row.Laterality),
		Container:  row.Container, Fixative: row.Fixative,
		OrderID: uuidOrEmpty(row.OrderID),
		TakenAt: timeOf(row.TakenAt), TakenBy: row.TakenBy,
	}
}

// InsertTrayUse records a sterile set being opened.
func (r CaseRepo) InsertTrayUse(ctx context.Context, scope authctx.TenantScope,
	t domain.TrayUse) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	trayUseID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	caseID, err := uuid.Parse(t.CaseID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTrayUse(ctx, sqlcgen.InsertTrayUseParams{
		TrayUseID: trayUseID, TenantID: tenantID, CaseID: caseID,
		TrayID: t.TrayID, TrayName: t.TrayName, CycleID: t.CycleID,
		IndicatorPassed: t.IndicatorPassed, IndicatorNote: t.IndicatorNote,
		OpenedAt: stamp(t.OpenedAt), OpenedBy: t.OpenedBy,
	})
}

// TrayUses reads a case's opened sets.
func (r CaseRepo) TrayUses(ctx context.Context, scope authctx.TenantScope,
	caseID string) ([]domain.TrayUse, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTrayUses(ctx, sqlcgen.ListTrayUsesParams{
		TenantID: tenantID, CaseID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.TrayUse, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.TrayUse{
			ID: row.TrayUseID.String(), TenantID: row.TenantID.String(),
			CaseID: row.CaseID.String(), TrayID: row.TrayID,
			TrayName: row.TrayName, CycleID: row.CycleID,
			IndicatorPassed: row.IndicatorPassed, IndicatorNote: row.IndicatorNote,
			OpenedAt: timeOf(row.OpenedAt), OpenedBy: row.OpenedBy,
		})
	}
	return out, nil
}

// CycleRecipients is the direction an infection investigation runs.
func (r CaseRepo) CycleRecipients(ctx context.Context, scope authctx.TenantScope,
	cycleID string) ([]ports.Recipient, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTrayUsesForCycle(ctx,
		sqlcgen.ListTrayUsesForCycleParams{TenantID: tenantID, CycleID: cycleID})
	if err != nil {
		return nil, err
	}
	out := make([]ports.Recipient, 0, len(rows))
	for _, row := range rows {
		out = append(out, ports.Recipient{
			PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
			CaseID: row.CaseID.String(), Reference: row.TrayID,
			At: timeOf(row.OpenedAt),
		})
	}
	return out, nil
}

// SaveCard creates or updates a preference card.
func (r CaseRepo) SaveCard(ctx context.Context, scope authctx.TenantScope,
	card domain.PreferenceCard) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	cardID, err := uuid.Parse(card.ID)
	if err != nil {
		return notFound()
	}

	consumables, err := json.Marshal(card.Consumables)
	if err != nil {
		return err
	}
	if card.Consumables == nil {
		consumables = []byte("[]")
	}

	return r.queries(ctx).UpsertPreferenceCard(ctx, sqlcgen.UpsertPreferenceCardParams{
		CardID: cardID, TenantID: tenantID,
		SurgeonID: card.SurgeonID, ProcedureCode: card.ProcedureCode,
		Name: card.Name, Equipment: strings0(card.Equipment),
		Consumables: consumables, Trays: strings0(card.Trays), Notes: card.Notes,
		UpdatedAt: stamp(card.UpdatedAt), UpdatedBy: card.UpdatedBy,
	})
}

// Card reads a surgeon's card for a procedure. False where there is none,
// which is not an error: most procedures have no card.
func (r CaseRepo) Card(ctx context.Context, scope authctx.TenantScope,
	surgeonID, procedureCode string) (domain.PreferenceCard, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PreferenceCard{}, false, err
	}

	row, err := r.queries(ctx).GetPreferenceCard(ctx, sqlcgen.GetPreferenceCardParams{
		TenantID: tenantID, SurgeonID: surgeonID, ProcedureCode: procedureCode,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PreferenceCard{}, false, nil
	}
	if err != nil {
		return domain.PreferenceCard{}, false, err
	}

	card := domain.PreferenceCard{
		ID: row.CardID.String(), TenantID: row.TenantID.String(),
		SurgeonID: row.SurgeonID, ProcedureCode: row.ProcedureCode,
		Name: row.Name, Equipment: row.Equipment, Trays: row.Trays,
		Notes: row.Notes, Version: int(row.Version),
		UpdatedAt: timeOf(row.UpdatedAt), UpdatedBy: row.UpdatedBy,
	}
	// Unreadable JSON leaves the card with no consumables rather than failing
	// the read: a card is a convenience, and a theatre that cannot open one
	// because a field is corrupt is a theatre that cannot start.
	_ = json.Unmarshal(row.Consumables, &card.Consumables)
	return card, true, nil
}
