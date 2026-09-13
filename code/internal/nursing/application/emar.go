package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The medication round (SRS-NUR-007 … SRS-NUR-009, SRS-NUR-018).

// MedicationRound is what a nurse sees before giving anything.
type MedicationRound struct {
	EncounterID string
	From, To    time.Time
	Doses       []domain.DueDose
	Policy      domain.AdministrationPolicy
}

// RoundInput asks for the doses due in a window.
type RoundInput struct {
	EncounterID string
	PatientID   string
	FacilityID  string
	From, To    time.Time
}

// Round builds the medication round (SRS-NUR-007).
//
// The round shows what has already been given as well as what is outstanding,
// because a list of "due" doses with no record of what was given is how a dose
// gets given twice.
func (s *Service) Round(ctx context.Context, in RoundInput) (
	MedicationRound, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "medication_round",
		in.EncounterID, false)
	if err != nil {
		return MedicationRound{}, err
	}
	if s.orders == nil {
		return MedicationRound{}, rpcerr.FailedPrecondition("NUR_NO_ORDER_SERVICE",
			"no medication order service is configured for this deployment")
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return MedicationRound{}, err
	}

	from, to := in.From, in.To
	if from.IsZero() {
		from = s.clock.Now().Add(-4 * time.Hour)
	}
	if to.IsZero() {
		to = from.Add(12 * time.Hour)
	}

	// Only active, pharmacist-verified orders (SRS-NUR-007). The seam is
	// responsible for the filter and the domain checks it again at
	// administration time, because a stale round is exactly what a nurse would
	// be acting on.
	due, err := s.orders.Due(ctx, scope, in.EncounterID, from, to)
	if err != nil {
		return MedicationRound{}, err
	}

	given, err := s.administration.List(ctx, scope, in.EncounterID, "",
		MaxPageSize)
	if err != nil {
		return MedicationRound{}, err
	}

	byDose := map[string]*domain.Administration{}
	for _, a := range given {
		if key, ok := a.ScheduledDoseKey(); ok {
			byDose[key] = a
		}
	}
	out := make([]domain.DueDose, 0, len(due))
	for _, d := range due {
		if !d.ScheduledAt.IsZero() {
			key := d.Order.OrderID + "|" + d.ScheduledAt.UTC().Format(time.RFC3339)
			d.Given = byDose[key]
		}
		out = append(out, d)
	}

	policy, err := s.administration.Policy(ctx, scope, in.FacilityID)
	if err != nil {
		return MedicationRound{}, err
	}

	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.round.read", ResourceType: "encounter",
		ResourceID: in.EncounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return MedicationRound{}, err
	}

	return MedicationRound{
		EncounterID: in.EncounterID, From: from, To: to,
		Doses: out, Policy: policy,
	}, nil
}

// AdministerInput is what recording a dose needs.
type AdministerInput struct {
	OrderID     string
	FacilityID  string
	ScheduledAt time.Time
	GivenDose   domain.Quantity
	GivenAt     time.Time
	Route       string
	Site        string
	Outcome     domain.AdministrationOutcome
	Reason      string
	// Verification is the barcode check (SRS-NUR-008).
	Verification domain.Verification
	// OverrideReason is supplied only when the nurse has decided to proceed
	// past a failed or absent check.
	OverrideReason string
	WitnessedBy    string
	IdempotencyKey string
	// Offline marks a dose transcribed from a downtime paper chart.
	Offline bool
}

// Administer records what happened to a dose
// (SRS-NUR-008, SRS-NUR-009, SRS-NUR-018).
func (s *Service) Administer(ctx context.Context, in AdministerInput) (
	*domain.Administration, error) {

	permission := PermAdminister
	if in.OverrideReason != "" {
		// Overriding is its own permission, checked instead of the plain one:
		// a nurse who may give drugs but may not override must be refused
		// before anything is written, and must be refused for the override
		// rather than for the administration.
		permission = PermOverrideVerification
	}
	session, scope, err := s.authorize(ctx, permission, "administration",
		in.OrderID, true)
	if err != nil {
		return nil, err
	}
	if s.orders == nil {
		// An eMAR that cannot check pharmacist verification must not pretend it
		// has (SRS-NUR-007).
		return nil, rpcerr.FailedPrecondition("NUR_NO_ORDER_SERVICE",
			"no medication order service is configured for this deployment")
	}

	order, err := s.orders.Get(ctx, scope, in.OrderID)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, order.EncounterID,
		order.PatientID); err != nil {
		return nil, err
	}

	policy, err := s.administration.Policy(ctx, scope, in.FacilityID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	administration, err := domain.NewAdministration(s.ids.NewID(),
		session.TenantID, domain.NewAdministrationInput{
			Order: order, ScheduledAt: in.ScheduledAt,
			GivenDose: in.GivenDose, GivenAt: in.GivenAt,
			Route: in.Route, Site: in.Site,
			Outcome: in.Outcome, Reason: in.Reason,
			Verification: in.Verification, OverrideReason: in.OverrideReason,
			WitnessedBy: in.WitnessedBy, IdempotencyKey: in.IdempotencyKey,
			Offline: in.Offline,
		}, policy, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.administration.Insert(ctx, scope, administration); err != nil {
			return nursingError(err)
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.medication.administer", ResourceType: "administration",
			ResourceID: administration.ID, Outcome: audit.OutcomeSuccess,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventMedicationAdministered,
			"administration", administration.ID, map[string]any{
				"administration_id": administration.ID,
				"patient_id":        administration.PatientID,
				"encounter_id":      administration.EncounterID,
				"order_id":          administration.OrderID,
				// The code, not the indication: a consumer needs to know which
				// product, and does not need to know what it was for.
				"medication_code":   administration.Medication.Code,
				"medication_system": administration.Medication.System,
				"outcome":           string(administration.Outcome),
				"scheduled_at":      timeOrNil(administration.ScheduledAt),
				"given_at":          timeOrNil(administration.GivenAt),
				"overridden":        administration.Override != nil,
			}, now); err != nil {
			return err
		}
		if administration.Override == nil {
			return nil
		}
		// A separate event, so the override report can be built outside the
		// ward that performed it (SRS-NUR-008).
		return s.appendEvent(ctx, session, EventVerificationOverridden,
			"administration", administration.ID, map[string]any{
				"administration_id":   administration.ID,
				"patient_id":          administration.PatientID,
				"order_id":            administration.OrderID,
				"patient_mismatch":    administration.Override.PatientMismatch,
				"medication_mismatch": administration.Override.MedicationMismatch,
				"not_scanned":         administration.Override.NotScanned,
				"overridden_by":       administration.Override.By,
			}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return administration, nil
}

// ListAdministrations reads the MAR for an encounter.
func (s *Service) ListAdministrations(ctx context.Context, encounterID,
	patientID, orderID string, limit int32) ([]*domain.Administration, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "administration",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return nil, err
	}

	out, err := s.administration.List(ctx, scope, encounterID, orderID,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.mar.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// OverrideReport lists administrations completed past a failed check
// (SRS-NUR-008).
//
// The report, not the permission, is what makes the override a control: an
// override nobody counts changes nothing.
func (s *Service) OverrideReport(ctx context.Context, from, to time.Time,
	limit int32) ([]*domain.Administration, error) {

	session, scope, err := s.authorize(ctx, PermNursingConfigure,
		"administration", "", false)
	if err != nil {
		return nil, err
	}
	if from.IsZero() || to.IsZero() || !to.After(from) {
		return nil, rpcerr.Invalid("NUR_REPORT_WINDOW",
			"an override report needs a window that ends after it begins")
	}

	out, err := s.administration.Overrides(ctx, scope, from, to,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.override_report.read", ResourceType: "administration",
		Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// SetAdministrationPolicy configures a facility's barcode rules
// (SRS-NUR-008).
func (s *Service) SetAdministrationPolicy(ctx context.Context, facilityID string,
	p domain.AdministrationPolicy) error {

	session, scope, err := s.authorize(ctx, PermNursingConfigure,
		"administration_policy", facilityID, true)
	if err != nil {
		return err
	}
	if facilityID == "" {
		return rpcerr.Invalid("NUR_POLICY_NO_FACILITY",
			"an administration policy applies to a facility")
	}
	if p.LateAfter < 0 {
		return rpcerr.Invalid("NUR_POLICY_LATE_AFTER",
			"the late-dose window cannot be negative")
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.administration.SetPolicy(ctx, scope, facilityID, p,
			session.SubjectID, now); err != nil {
			return err
		}
		// Audited as a configuration change, because turning the barcode check
		// off is a safety decision and the record must show who made it.
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "nursing.administration_policy.set",
			ResourceType: "administration_policy", ResourceID: facilityID,
			Outcome: audit.OutcomeSuccess,
			Reason:  policyReason(p),
		}, now)
	})
}

func policyReason(p domain.AdministrationPolicy) string {
	if !p.BarcodeRequired {
		return "barcode verification disabled"
	}
	if !p.OverrideAllowed {
		return "barcode verification required, override disallowed"
	}
	return "barcode verification required"
}

// ReconcileDowntime closes out a downtime episode (SRS-NUR-018).
//
// The reconciliation itself is the transcription that has already happened:
// each paper administration was submitted through Administer, and the
// scheduled-dose key rejected the ones already recorded. This use case reports
// what that produced and marks the episode complete, so an unreconciled
// episode — one where somebody never finished typing — stays visible.
func (s *Service) ReconcileDowntime(ctx context.Context, episodeID string) (
	domain.ReconciliationReport, error) {

	session, scope, err := s.authorize(ctx, PermDowntime, "downtime_episode",
		episodeID, true)
	if err != nil {
		return domain.ReconciliationReport{}, err
	}

	episode, err := s.downtime.Get(ctx, scope, episodeID)
	if err != nil {
		return domain.ReconciliationReport{}, err
	}

	now := s.clock.Now()
	if err := episode.Reconcile(session.SubjectID, now); err != nil {
		return domain.ReconciliationReport{}, nursingError(err)
	}

	report := domain.ReconciliationReport{
		EpisodeID: episode.ID, UnitID: episode.UnitID, RunAt: now.UTC(),
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.downtime.Reconcile(ctx, scope, episode); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.downtime.reconcile", ResourceType: "downtime_episode",
			ResourceID: episode.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.ReconciliationReport{}, mapConflict(err)
	}
	return report, nil
}

// SuspectedDuplicates flags unscheduled doses close enough together to be one
// event typed twice (SRS-NUR-018).
//
// Reporting only. The scheduled-dose key refuses; this one raises an eyebrow,
// because two PRN doses an hour apart can be entirely correct and refusing them
// would be wrong.
func (s *Service) SuspectedDuplicates(ctx context.Context, encounterID,
	patientID string) ([]domain.SuspectedDuplicate, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "administration",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return nil, err
	}

	administrations, err := s.administration.List(ctx, scope, encounterID, "",
		MaxPageSize)
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.duplicate_report.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return domain.FindSuspectedDuplicates(administrations), nil
}

// requireOpenEncounterForRead checks the encounter exists in this tenant and
// belongs to the patient named, without requiring it to still be open.
//
// A closed encounter's record is still readable — that is what a record is for
// — so the open check belongs on writes only.
func (s *Service) requireOpenEncounterForRead(ctx context.Context,
	scope authctx.TenantScope, encounterID, patientID string) (
	ports.EncounterState, error) {

	if s.encounters == nil || encounterID == "" {
		return ports.EncounterState{PatientID: patientID, Open: true}, nil
	}
	state, err := s.encounters.Check(ctx, scope, encounterID)
	if err != nil {
		return ports.EncounterState{}, err
	}
	if patientID != "" && state.PatientID != "" && state.PatientID != patientID {
		return ports.EncounterState{}, rpcerr.Invalid(
			"NUR_PATIENT_ENCOUNTER_MISMATCH",
			"that encounter belongs to a different patient")
	}
	return state, nil
}

func timeOrNil(t time.Time) any {
	if t.IsZero() {
		return nil
	}
	return t.UTC().Format(time.RFC3339)
}
