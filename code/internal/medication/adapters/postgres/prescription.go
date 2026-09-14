package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

var _ ports.PrescriptionRepository = (*Repository)(nil)

// Insert stores a prescription with its segments and its screen findings
// (SRS-MED-001).
//
// One act. A prescription whose dose segments landed after its status did would
// be visible to the pharmacy with no dose, and the pharmacy worklist is read
// every few seconds.
func (r *Repository) Insert(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	prescriptionID, err := mustUUID(p.ID)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(p.OrderID)
	if err != nil {
		return err
	}
	patientID, err := lookupUUID(p.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := lookupUUID(p.EncounterID)
	if err != nil {
		return err
	}
	facilityID, err := lookupUUID(p.FacilityID)
	if err != nil {
		return err
	}
	maxTotal, err := optionalNumeric(p.PRN.MaxDoseTotal.Value)
	if err != nil {
		return err
	}

	q := r.queries(ctx)
	if err := q.InsertPrescription(ctx, sqlcgen.InsertPrescriptionParams{
		PrescriptionID: prescriptionID, TenantID: tenantID,
		OrderID: orderID, OrderNumber: p.OrderNumber,
		PatientID: patientID, EncounterID: encounterID, FacilityID: facilityID,
		PrescriberID: p.PrescriberID, EnteredByID: p.EnteredByID,

		IngredientSystem: p.Ingredient.System, IngredientCode: p.Ingredient.Code,
		IngredientDisplay: p.Ingredient.Display, IngredientVersion: p.Ingredient.Version,
		ProductSystem: p.Product.System, ProductCode: p.Product.Code,
		ProductDisplay: p.Product.Display,

		Route: p.Route, StartsAt: timestamptz(p.StartsAt),
		StopKind: string(p.Stop.Kind), StopAt: timestamptz(p.Stop.At),
		StopDoses: int32(p.Stop.Doses), StopText: p.Stop.Text,

		Indication: p.Indication, IndicationSystem: p.IndicationCode.System,
		IndicationCode: p.IndicationCode.Code, IndicationDisplay: p.IndicationCode.Display,
		Instructions: p.Instructions,

		Prn: p.PRNScheduled(), PrnIndication: p.PRN.Indication,
		PrnMinInterval:   interval(p.PRN.MinInterval),
		PrnMaxDoses:      int32(p.PRN.MaxDoses),
		PrnMaxTotalValue: maxTotal, PrnMaxTotalUnit: p.PRN.MaxDoseTotal.Unit,
		PrnPeriod: interval(p.PRN.Period),

		TherapyStatus: string(p.Status), EffectiveStop: timestamptz(p.EffectiveStop()),

		VerifiedBy: p.Verification.By, VerifiedAt: timestamptz(p.Verification.At),
		VerificationNote: p.Verification.Note,

		FormularyStatus: formularyStatusOrUnknown(p.Formulary.Status),
		FormularyScope:  string(p.Formulary.Scope), FormularyScopeID: p.Formulary.ScopeID,
		FormularyRestriction:  p.Formulary.Restriction,
		FormularyApprovalPath: p.Formulary.ApprovalPath,

		ScreenedAt: timestamptz(p.Screen.ScreenedAt),
		CreatedAt:  timestamptz(p.CreatedAt), UpdatedAt: timestamptz(p.UpdatedAt),
		Version: p.Version,
	}); err != nil {
		return err
	}

	if err := r.writeSegments(ctx, q, tenantID, prescriptionID, p); err != nil {
		return err
	}
	for _, f := range p.Screen.Findings {
		if err := r.writeFinding(ctx, q, tenantID, prescriptionID, f); err != nil {
			return err
		}
	}
	for _, c := range p.Changes {
		if err := r.writeChange(ctx, q, tenantID, prescriptionID, c); err != nil {
			return err
		}
	}
	return nil
}

func (r *Repository) writeSegments(ctx context.Context, q *sqlcgen.Queries,
	tenantID, prescriptionID uuid.UUID, p *domain.Prescription) error {

	for _, seg := range p.Segments {
		dose, err := optionalNumeric(seg.Dose.Value)
		if err != nil {
			return err
		}
		days := make([]int32, 0, len(seg.Timing.DaysOfWeek))
		for _, d := range seg.Timing.DaysOfWeek {
			days = append(days, int32(d))
		}
		if err := q.InsertDoseSegment(ctx, sqlcgen.InsertDoseSegmentParams{
			TenantID: tenantID, PrescriptionID: prescriptionID,
			Sequence:  int32(seg.Sequence),
			DoseValue: dose, DoseUnit: seg.Dose.Unit, FreeTextDose: seg.FreeTextDose,
			FrequencyText:  seg.Timing.FrequencyText,
			IntervalPeriod: interval(seg.Timing.Interval),
			TimesOfDay:     orEmptyInt32(seg.Timing.TimesOfDay),
			DaysOfWeek:     orEmptyInt32(days),
			Prn:            seg.Timing.PRN,
			DoseDuration:   interval(seg.Timing.Duration),
			StartsAt:       timestamptz(seg.StartsAt),
			EndsAt:         timestamptz(seg.EndsAt),
			Note:           seg.Note, Version: p.Version,
		}); err != nil {
			return err
		}
	}
	return nil
}

func (r *Repository) writeFinding(ctx context.Context, q *sqlcgen.Queries,
	tenantID, prescriptionID uuid.UUID, f domain.SafetyFinding) error {

	subjects, err := toJSON(f.Subjects)
	if err != nil {
		return err
	}
	inputs, err := toJSON(f.Inputs)
	if err != nil {
		return err
	}

	params := sqlcgen.InsertSafetyFindingParams{
		FindingID: uuid.New(), TenantID: tenantID, PrescriptionID: prescriptionID,
		Kind: string(f.Kind), Severity: string(f.Severity),
		RuleID: f.RuleID, RuleVersion: f.RuleVersion, Summary: f.Summary,
		Subjects: subjects, Inputs: inputs,
	}
	if f.Override != nil {
		params.OverrideBy = f.Override.By
		params.OverrideAt = timestamptz(f.Override.At)
		params.OverrideReason = f.Override.Reason
	}
	return q.InsertSafetyFinding(ctx, params)
}

func (r *Repository) writeChange(ctx context.Context, q *sqlcgen.Queries,
	tenantID, prescriptionID uuid.UUID, c domain.TherapyChange) error {

	return q.InsertTherapyChange(ctx, sqlcgen.InsertTherapyChangeParams{
		ChangeID: uuid.New(), TenantID: tenantID, PrescriptionID: prescriptionID,
		FromStatus: string(c.From), ToStatus: string(c.To),
		EffectiveAt: timestamptz(c.EffectiveAt), RecordedAt: timestamptz(c.RecordedAt),
		ChangedBy: c.By, Reason: c.Reason,
	})
}

func formularyStatusOrUnknown(s domain.FormularyStatus) string {
	if s == "" {
		return string(domain.FormularyUnknown)
	}
	return string(s)
}

// Get reads one prescription with everything hung off it.
func (r *Repository) Get(ctx context.Context, scope authctx.TenantScope,
	prescriptionID string) (*domain.Prescription, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(prescriptionID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetPrescription(ctx, sqlcgen.GetPrescriptionParams{
		TenantID: tenantID, PrescriptionID: id,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return r.hydrate(ctx, tenantID, row)
}

// GetByOrder reads the prescription behind a medication order.
func (r *Repository) GetByOrder(ctx context.Context, scope authctx.TenantScope,
	orderID string) (*domain.Prescription, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(orderID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetPrescriptionByOrder(ctx,
		sqlcgen.GetPrescriptionByOrderParams{TenantID: tenantID, OrderID: id})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return r.hydrate(ctx, tenantID, row)
}

func (r *Repository) hydrate(ctx context.Context, tenantID uuid.UUID,
	row sqlcgen.MedicationPrescription) (*domain.Prescription, error) {

	p, err := prescriptionFromRow(row)
	if err != nil {
		return nil, err
	}
	q := r.queries(ctx)

	segments, err := q.ListDoseSegments(ctx, sqlcgen.ListDoseSegmentsParams{
		TenantID: tenantID, PrescriptionID: row.PrescriptionID,
	})
	if err != nil {
		return nil, err
	}
	for _, s := range segments {
		seg, err := segmentFromRow(s)
		if err != nil {
			return nil, err
		}
		p.Segments = append(p.Segments, seg)
	}

	findings, err := q.ListPrescriptionSafetyFindings(ctx,
		sqlcgen.ListPrescriptionSafetyFindingsParams{
			TenantID: tenantID, PrescriptionID: row.PrescriptionID,
		})
	if err != nil {
		return nil, err
	}
	for _, f := range findings {
		finding, err := findingFromRow(f)
		if err != nil {
			return nil, err
		}
		p.Screen.Findings = append(p.Screen.Findings, finding)
	}

	changes, err := q.ListTherapyChanges(ctx, sqlcgen.ListTherapyChangesParams{
		TenantID: tenantID, PrescriptionID: row.PrescriptionID,
	})
	if err != nil {
		return nil, err
	}
	for _, c := range changes {
		p.Changes = append(p.Changes, domain.TherapyChange{
			From: domain.TherapyStatus(c.FromStatus), To: domain.TherapyStatus(c.ToStatus),
			EffectiveAt: timeOrZero(c.EffectiveAt), RecordedAt: timeOrZero(c.RecordedAt),
			By: c.ChangedBy, Reason: c.Reason,
		})
	}
	return p, nil
}

func prescriptionFromRow(row sqlcgen.MedicationPrescription) (*domain.Prescription, error) {
	maxTotal, err := numericOrZero(row.PrnMaxTotalValue)
	if err != nil {
		return nil, err
	}

	p := &domain.Prescription{
		ID: row.PrescriptionID.String(), TenantID: row.TenantID.String(),
		OrderID: row.OrderID.String(), OrderNumber: row.OrderNumber,
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		FacilityID:   row.FacilityID.String(),
		PrescriberID: row.PrescriberID, EnteredByID: row.EnteredByID,

		Ingredient: domain.Coding{
			System: row.IngredientSystem, Code: row.IngredientCode,
			Display: row.IngredientDisplay, Version: row.IngredientVersion,
		},
		Route: row.Route,

		StartsAt: timeOrZero(row.StartsAt),
		Stop: domain.StopCondition{
			Kind: domain.StopConditionKind(row.StopKind),
			At:   timeOrZero(row.StopAt), Doses: int(row.StopDoses), Text: row.StopText,
		},

		Indication:   row.Indication,
		Instructions: row.Instructions,

		Status: domain.TherapyStatus(row.TherapyStatus),

		Formulary: domain.FormularyDecision{
			Status:      domain.FormularyStatus(row.FormularyStatus),
			Scope:       domain.FormularyScopeKind(row.FormularyScope),
			ScopeID:     row.FormularyScopeID,
			Restriction: row.FormularyRestriction, ApprovalPath: row.FormularyApprovalPath,
		},
		Screen: domain.ScreenResult{ScreenedAt: timeOrZero(row.ScreenedAt)},

		CreatedAt: timeOrZero(row.CreatedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	}

	if row.ProductCode != "" {
		p.Product = domain.Coding{
			System: row.ProductSystem, Code: row.ProductCode, Display: row.ProductDisplay,
		}
	}
	if row.IndicationCode != "" {
		p.IndicationCode = domain.Coding{
			System: row.IndicationSystem, Code: row.IndicationCode,
			Display: row.IndicationDisplay,
		}
	}
	if row.Prn {
		p.PRN = domain.PRNConstraint{
			Indication:  row.PrnIndication,
			MinInterval: durationOrZero(row.PrnMinInterval),
			MaxDoses:    int(row.PrnMaxDoses),
			Period:      durationOrZero(row.PrnPeriod),
		}
		if maxTotal > 0 {
			p.PRN.MaxDoseTotal = domain.Quantity{Value: maxTotal, Unit: row.PrnMaxTotalUnit}
		}
	}
	if row.VerifiedBy != "" {
		p.Verification = domain.Verification{
			By: row.VerifiedBy, At: timeOrZero(row.VerifiedAt), Note: row.VerificationNote,
		}
	}
	return p, nil
}

func segmentFromRow(row sqlcgen.MedicationDoseSegment) (domain.DoseSegment, error) {
	dose, err := numericOrZero(row.DoseValue)
	if err != nil {
		return domain.DoseSegment{}, err
	}
	days := make([]time.Weekday, 0, len(row.DaysOfWeek))
	for _, d := range row.DaysOfWeek {
		days = append(days, time.Weekday(d))
	}

	seg := domain.DoseSegment{
		Sequence:     int(row.Sequence),
		FreeTextDose: row.FreeTextDose,
		Timing: domain.Timing{
			FrequencyText: row.FrequencyText,
			Interval:      durationOrZero(row.IntervalPeriod),
			TimesOfDay:    row.TimesOfDay,
			PRN:           row.Prn,
			Duration:      durationOrZero(row.DoseDuration),
		},
		StartsAt: timeOrZero(row.StartsAt),
		EndsAt:   timeOrZero(row.EndsAt),
		Note:     row.Note,
	}
	if len(days) > 0 {
		seg.Timing.DaysOfWeek = days
	}
	if dose > 0 {
		seg.Dose = domain.Quantity{Value: dose, Unit: row.DoseUnit}
	}
	return seg, nil
}

func findingFromRow(row sqlcgen.MedicationSafetyFinding) (domain.SafetyFinding, error) {
	f := domain.SafetyFinding{
		Kind: domain.FindingKind(row.Kind), Severity: domain.Severity(row.Severity),
		RuleID: row.RuleID, RuleVersion: row.RuleVersion, Summary: row.Summary,
	}
	if err := fromJSON(row.Subjects, &f.Subjects); err != nil {
		return domain.SafetyFinding{}, err
	}
	if err := fromJSON(row.Inputs, &f.Inputs); err != nil {
		return domain.SafetyFinding{}, err
	}
	if row.OverrideBy != "" {
		f.Override = &domain.Override{
			By: row.OverrideBy, At: timeOrZero(row.OverrideAt), Reason: row.OverrideReason,
		}
	}
	return f, nil
}

// ChangeTherapy records a status change and its ledger entry together
// (SRS-MED-013).
func (r *Repository) ChangeTherapy(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription, change domain.TherapyChange, expectedVersion int64,
	expectedStatus domain.TherapyStatus) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	prescriptionID, err := mustUUID(p.ID)
	if err != nil {
		return err
	}

	q := r.queries(ctx)
	affected, err := q.UpdateTherapyStatus(ctx, sqlcgen.UpdateTherapyStatusParams{
		TherapyStatus: string(p.Status),
		EffectiveStop: timestamptz(p.EffectiveStop()),
		UpdatedAt:     timestamptz(p.UpdatedAt), Version: p.Version,
		TenantID: tenantID, PrescriptionID: prescriptionID,
		ExpectedVersion: expectedVersion, ExpectedStatus: string(expectedStatus),
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return r.writeChange(ctx, q, tenantID, prescriptionID, change)
}

// Verify records the pharmacist's check (SRS-MED-006).
func (r *Repository) Verify(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	prescriptionID, err := mustUUID(p.ID)
	if err != nil {
		return err
	}

	affected, err := r.queries(ctx).VerifyPrescription(ctx, sqlcgen.VerifyPrescriptionParams{
		VerifiedBy: p.Verification.By, VerifiedAt: timestamptz(p.Verification.At),
		VerificationNote: p.Verification.Note,
		UpdatedAt:        timestamptz(p.UpdatedAt), Version: p.Version,
		TenantID: tenantID, PrescriptionID: prescriptionID,
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// RecordOverride answers one safety finding (SRS-MED-003).
//
// Matched by rule and subject rather than by a finding identifier the caller
// supplies, because the screen is re-run between the warning being shown and
// the override coming back: the patient's medication list moves, and an
// override applied to whatever row was in that position would answer a
// different warning.
func (r *Repository) RecordOverride(ctx context.Context, scope authctx.TenantScope,
	prescriptionID, ruleID string, subject domain.Coding, o domain.Override) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(prescriptionID)
	if err != nil {
		return err
	}

	q := r.queries(ctx)
	rows, err := q.ListPrescriptionSafetyFindings(ctx,
		sqlcgen.ListPrescriptionSafetyFindingsParams{TenantID: tenantID, PrescriptionID: id})
	if err != nil {
		return err
	}

	matched := false
	for _, row := range rows {
		if row.RuleID != ruleID {
			continue
		}
		if !subject.Empty() {
			finding, err := findingFromRow(row)
			if err != nil {
				return err
			}
			if !subjectMatches(finding.Subjects, subject) {
				continue
			}
		}
		affected, err := q.RecordSafetyOverride(ctx, sqlcgen.RecordSafetyOverrideParams{
			OverrideBy: o.By, OverrideAt: timestamptz(o.At), OverrideReason: o.Reason,
			TenantID: tenantID, FindingID: row.FindingID,
		})
		if err != nil {
			return err
		}
		if affected > 0 {
			matched = true
		}
	}
	if !matched {
		return notFound()
	}
	return nil
}

func subjectMatches(subjects []domain.Coding, want domain.Coding) bool {
	for _, s := range subjects {
		if s.Key() == want.Key() {
			return true
		}
	}
	return false
}

// ForEncounter lists a visit's prescriptions.
func (r *Repository) ForEncounter(ctx context.Context, scope authctx.TenantScope,
	encounterID string, liveOnly bool, limit int32) ([]*domain.Prescription, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListPrescriptionsForEncounter(ctx,
		sqlcgen.ListPrescriptionsForEncounterParams{
			TenantID: tenantID, EncounterID: id,
			LiveOnly: liveOnly, RowLimit: capLimit(limit),
		})
	if err != nil {
		return nil, err
	}
	return r.hydrateAll(ctx, tenantID, rows)
}

// LiveForPatient is what the interaction and duplicate-therapy screens read
// (SRS-MED-003).
func (r *Repository) LiveForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string, limit int32) ([]*domain.Prescription, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(patientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListLivePrescriptionsForPatient(ctx,
		sqlcgen.ListLivePrescriptionsForPatientParams{
			TenantID: tenantID, PatientID: id, RowLimit: capLimit(limit),
		})
	if err != nil {
		return nil, err
	}
	return r.hydrateAll(ctx, tenantID, rows)
}

// AwaitingVerification is the pharmacy worklist (SRS-MED-006).
func (r *Repository) AwaitingVerification(ctx context.Context, scope authctx.TenantScope,
	facilityID string, limit int32) ([]*domain.Prescription, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(facilityID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListPrescriptionsAwaitingVerification(ctx,
		sqlcgen.ListPrescriptionsAwaitingVerificationParams{
			TenantID: tenantID, FacilityID: id, RowLimit: capLimit(limit),
		})
	if err != nil {
		return nil, err
	}
	return r.hydrateAll(ctx, tenantID, rows)
}

func (r *Repository) hydrateAll(ctx context.Context, tenantID uuid.UUID,
	rows []sqlcgen.MedicationPrescription) ([]*domain.Prescription, error) {

	out := make([]*domain.Prescription, 0, len(rows))
	for _, row := range rows {
		p, err := r.hydrate(ctx, tenantID, row)
		if err != nil {
			return nil, err
		}
		out = append(out, p)
	}
	return out, nil
}

// DefaultLimit bounds a list a caller did not bound.
const DefaultLimit = 100

// MaxLimit is the ceiling, so a caller cannot ask for the whole tenant.
const MaxLimit = 500

func capLimit(limit int32) int32 {
	switch {
	case limit <= 0:
		return DefaultLimit
	case limit > MaxLimit:
		return MaxLimit
	}
	return limit
}
