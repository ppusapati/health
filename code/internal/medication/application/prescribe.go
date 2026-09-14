package application

import (
	"context"
	"sort"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// PrescribeInput is what writing a prescription needs (SRS-MED-001).
type PrescribeInput struct {
	PatientID   string
	EncounterID string

	Ingredient domain.Coding
	Product    domain.Coding
	Route      string

	Segments []domain.DoseSegment
	StartsAt time.Time
	Stop     domain.StopCondition

	Indication     string
	IndicationCode domain.Coding
	Instructions   string

	PRN domain.PRNConstraint

	// EnteredByID names the person at the keyboard where that differs from the
	// prescriber — a verbal order taken by a nurse.
	EnteredByID string

	// Overrides are the clinician's answers to warnings they were shown
	// (SRS-MED-003). Empty on a first attempt, which is how the screen's
	// findings reach them.
	Overrides []OverrideInput
}

// OverrideInput answers one safety finding.
//
// Keyed by rule and subject rather than by an opaque finding identifier,
// because the screen is re-run between the warning being shown and the answer
// coming back: the patient's medication list moves, and an override applied by
// position would answer whichever warning landed in that slot the second time.
type OverrideInput struct {
	RuleID  string
	Subject domain.Coding
	Reason  string
}

// PrescribeResult is what prescribing returns.
type PrescribeResult struct {
	Prescription *domain.Prescription
}

// Prescribe screens, places and records a prescription (SRS-MED-001 …
// SRS-MED-004, SRS-MED-010, SRS-MED-012).
//
// The order of the steps is the safety argument. The screen runs against the
// patient's allergy list and current medications *before* anything is written,
// so a prescription never exists in a state a ward could act on without having
// been checked; the findings and the formulary position are stored with the
// prescription rather than recomputed, so a report years later shows what the
// prescriber was actually shown; and the order is raised inside the same
// transaction, so there is no window in which a pharmacy sees a supply request
// for a prescription that is not there.
func (s *Service) Prescribe(ctx context.Context, in PrescribeInput) (
	PrescribeResult, error) {

	session, scope, err := s.authorize(ctx, PermPrescriptionWrite, "prescription", "", true)
	if err != nil {
		return PrescribeResult{}, err
	}

	state, err := s.requireOpenEncounter(ctx, scope, in.EncounterID, in.PatientID)
	if err != nil {
		return PrescribeResult{}, err
	}
	patientID := in.PatientID
	if patientID == "" {
		patientID = state.PatientID
	}

	policySet, err := s.catalogue.Policy(ctx, scope)
	if err != nil {
		return PrescribeResult{}, err
	}

	now := s.clock.Now()
	prescription, err := domain.NewPrescription(s.ids.NewID(), session.TenantID,
		domain.NewPrescriptionInput{
			PatientID: patientID, EncounterID: in.EncounterID,
			FacilityID:   state.FacilityID,
			PrescriberID: session.SubjectID, EnteredByID: in.EnteredByID,
			Ingredient: in.Ingredient, Product: in.Product, Route: in.Route,
			Segments: in.Segments, StartsAt: in.StartsAt, Stop: in.Stop,
			Indication: in.Indication, IndicationCode: in.IndicationCode,
			Instructions: in.Instructions, PRN: in.PRN,
		}, now)
	if err != nil {
		return PrescribeResult{}, medicationError(err)
	}

	profile, err := s.profileOf(ctx, scope, prescription)
	if err != nil {
		return PrescribeResult{}, err
	}

	// SRS-MED-010, before anything else that costs a round trip: a free-text
	// dose on a class the tenant has marked as requiring structure is refused
	// at submit, which is what the acceptance criterion asks for.
	if err := requireStructuredDose(prescription, profile, policySet); err != nil {
		return PrescribeResult{}, err
	}

	screen, err := s.screen(ctx, scope, prescription, profile, patientID, now)
	if err != nil {
		return PrescribeResult{}, err
	}
	prescription.Screen = screen

	if err := s.applyOverrides(ctx, session, prescription, in.Overrides, policySet, now); err != nil {
		return PrescribeResult{}, err
	}

	prescription.Formulary, err = s.formularyOf(ctx, scope, prescription, profile, state)
	if err != nil {
		return PrescribeResult{}, err
	}

	// Goes live, or comes back carrying every unanswered warning at once.
	if err := prescription.Prescribe(now); err != nil {
		return PrescribeResult{}, medicationError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		ref, err := s.placeOrder(ctx, scope, prescription, state)
		if err != nil {
			return err
		}
		prescription.OrderID, prescription.OrderNumber = ref.OrderID, ref.Number

		if err := s.prescriptions.Insert(ctx, scope, prescription); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventPrescribed, prescription.ID,
			prescriptionEventPayload(prescription), now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.prescription.write", ResourceType: "prescription",
			ResourceID: prescription.ID, Outcome: audit.OutcomeSuccess,
			Reason: overrideSummary(prescription.Screen),
		}, now)
	})
	if err != nil {
		return PrescribeResult{}, mapConflict(err)
	}
	return PrescribeResult{Prescription: prescription}, nil
}

// placeOrder raises the CPOE order this prescription is the detail of.
func (s *Service) placeOrder(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription, state ports.EncounterState) (ports.OrderRef, error) {

	if s.orders == nil {
		return ports.OrderRef{}, rpcerr.Internal("MED_NO_ORDER_SEAM",
			"this deployment cannot place medication orders")
	}

	first := p.Segments[0]
	req := ports.OrderRequest{
		PatientID: p.PatientID, EncounterID: p.EncounterID,
		FacilityID:  state.FacilityID,
		RequesterID: p.PrescriberID, EnteredByID: p.EnteredByID,
		Medication: orderMedication(p),
		// The human-readable prescription travels with the order, so the
		// pharmacy worklist and the drug chart show the same sentence. Two
		// renderings of one prescription is how a ward and a pharmacy end up
		// disagreeing about a dose.
		Detail:     p.Describe(),
		Indication: p.Indication, IndicationCode: p.IndicationCode,
		PRN:        p.PRNScheduled(),
		StartsAt:   p.StartsAt,
		TimesOfDay: first.Timing.TimesOfDay,
		DaysOfWeek: first.Timing.DaysOfWeek,
		Interval:   first.Timing.Interval,
	}
	if p.Stop.Kind == domain.StopAtTime {
		req.EndsAt = p.Stop.At
	} else if last := p.Segments[len(p.Segments)-1]; !last.EndsAt.IsZero() {
		req.EndsAt = last.EndsAt
	}
	return s.orders.Place(ctx, scope, req)
}

// orderMedication is the code the order carries.
//
// The product where one was named, and the ingredient otherwise: a pharmacy
// picking an order off a worklist needs to know which of the four brands on the
// shelf was asked for, and an order that named only the molecule would send
// them back to the prescription to find out.
func orderMedication(p *domain.Prescription) domain.Coding {
	if !p.Product.Empty() {
		return p.Product
	}
	return p.Ingredient
}

// profileOf maps the prescribed medication onto its ingredients and classes.
func (s *Service) profileOf(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription) (domain.MedicationProfile, error) {

	medication := orderMedication(p)
	if s.terminology == nil {
		// No mapping: screen on what was prescribed and nothing else. Narrower
		// than the requirement wants and never wrong, which is the right way
		// round — guessing from the display term fires on every brand pair that
		// shares a word and trains prescribers to dismiss the warnings that
		// matter.
		return domain.MedicationProfile{
			Ingredients: []domain.Coding{medication, p.Ingredient},
		}, nil
	}
	return s.terminology.Profile(ctx, scope, medication)
}

// requireStructuredDose is SRS-MED-010.
//
// The requirement is about classes a tenant has decided cannot be prescribed in
// words — insulins, anticoagulants, chemotherapy — and the reason is that a
// dose living only in free text cannot be checked against a maximum, scheduled
// by the eMAR, or totalled for a PRN ceiling. It is a tenant decision rather
// than a global rule because a hospital that switched it on for everything
// would be a hospital where "apply sparingly" cannot be prescribed.
func requireStructuredDose(p *domain.Prescription, profile domain.MedicationProfile,
	policySet ports.Policy) error {

	if len(policySet.StructuredDoseClasses) == 0 || p.Structured() {
		return nil
	}

	for _, class := range append(append([]domain.Coding{}, profile.Classes...),
		profile.Ingredients...) {
		if !policySet.StructuredDoseClasses[class.Key()] {
			continue
		}
		violations := make([]rpcerr.FieldViolation, 0, len(p.Segments))
		for _, seg := range p.Segments {
			if seg.Structured() {
				continue
			}
			violations = append(violations, rpcerr.FieldViolation{
				Field:  "dose",
				Reason: "a structured dose is required for " + class.Display,
			})
		}
		return rpcerr.Invalid("MED_DOSE_NOT_STRUCTURED",
			"this medication must be prescribed with a structured dose").
			WithViolations(violations...)
	}
	return nil
}

// screen runs the allergy, interaction, duplicate-therapy and dose-support
// rules (SRS-MED-002, SRS-MED-003, SRS-MED-004).
func (s *Service) screen(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription, profile domain.MedicationProfile, patientID string,
	now time.Time) (domain.ScreenResult, error) {

	result := domain.ScreenResult{ScreenedAt: now.UTC()}

	if s.allergies != nil {
		allergies, err := s.allergies.ForPatient(ctx, scope, patientID)
		if err != nil {
			return domain.ScreenResult{}, err
		}
		rule := domain.AllergyRule{}
		if s.terminology != nil {
			rule, err = s.terminology.AllergyRule(ctx, scope)
			if err != nil {
				return domain.ScreenResult{}, err
			}
		}
		result.Findings = append(result.Findings,
			domain.ScreenAllergies(allergies, profile, rule)...)
	}

	current, err := s.currentMedications(ctx, scope, patientID, p.ID)
	if err != nil {
		return domain.ScreenResult{}, err
	}

	rules, err := s.catalogue.InteractionRules(ctx, scope)
	if err != nil {
		return domain.ScreenResult{}, err
	}
	result.Findings = append(result.Findings,
		domain.ScreenInteractions(profile, current, rules)...)

	policySet, err := s.catalogue.Policy(ctx, scope)
	if err != nil {
		return domain.ScreenResult{}, err
	}
	result.Findings = append(result.Findings,
		domain.ScreenDuplicateTherapy(profile, current, policySet.Duplicate)...)

	if s.patients != nil {
		doseRules, err := s.catalogue.DoseRules(ctx, scope)
		if err != nil {
			return domain.ScreenResult{}, err
		}
		if len(doseRules) > 0 {
			factors, err := s.patients.Factors(ctx, scope, patientID, now)
			if err != nil {
				return domain.ScreenResult{}, err
			}
			result.Findings = append(result.Findings,
				domain.ScreenDoseSupport(profile, factors, doseRules)...)
		}
	}

	// Most serious first, so a prescriber reading down the list reads the
	// contraindication before the informational note.
	sort.SliceStable(result.Findings, func(i, j int) bool {
		return severityOrder(result.Findings[i].Severity) <
			severityOrder(result.Findings[j].Severity)
	})
	return result, nil
}

func severityOrder(s domain.Severity) int {
	switch s {
	case domain.SeverityContraindicated:
		return 0
	case domain.SeveritySevere:
		return 1
	case domain.SeverityModerate:
		return 2
	case domain.SeverityMild:
		return 3
	}
	return 4
}

// currentMedications reads what the patient is already on, with each one's
// terminology profile (SRS-MED-003).
func (s *Service) currentMedications(ctx context.Context, scope authctx.TenantScope,
	patientID, excludeID string) ([]domain.CurrentMedication, error) {

	live, err := s.prescriptions.LiveForPatient(ctx, scope, patientID,
		MaxCurrentMedications)
	if err != nil {
		return nil, err
	}

	out := make([]domain.CurrentMedication, 0, len(live))
	for _, existing := range live {
		if existing.ID == excludeID {
			continue
		}
		medication := orderMedication(existing)
		profile := domain.MedicationProfile{Ingredients: []domain.Coding{medication}}
		if s.terminology != nil {
			profile, err = s.terminology.Profile(ctx, scope, medication)
			if err != nil {
				return nil, err
			}
		}
		out = append(out, domain.CurrentMedication{
			PrescriptionID: existing.ID, Medication: medication, Profile: profile,
		})
	}
	return out, nil
}

// applyOverrides records the clinician's answers (SRS-MED-003).
func (s *Service) applyOverrides(ctx context.Context, session authctx.Session,
	p *domain.Prescription, overrides []OverrideInput, policySet ports.Policy,
	now time.Time) error {

	if len(overrides) == 0 {
		return nil
	}
	// Overriding a safety warning is its own permission. A prescriber who may
	// write a prescription but may not override a warning is a real
	// configuration — it is how a hospital keeps junior staff from clicking
	// through an interaction alert at three in the morning.
	if !session.HasPermission(PermOverrideSafety) {
		s.auditDenied(ctx, session, PermOverrideSafety, "prescription", p.ID,
			"overriding a safety warning needs "+PermOverrideSafety)
		return rpcerr.PermissionDenied("MED_OVERRIDE_DENIED",
			"answering a safety warning needs "+PermOverrideSafety)
	}

	for _, o := range overrides {
		if err := p.Screen.Answer(o.RuleID, o.Subject, domain.Override{
			By: session.SubjectID, At: now.UTC(), Reason: o.Reason,
		}, policySet.Override); err != nil {
			return medicationError(err)
		}
	}
	return nil
}

// overrideSummary is what the audit record carries about a prescription's
// warnings.
//
// The rules and versions overridden, not the reasons: the reasons are clinical
// and live on the prescription, and the audit trail's job is to say that a
// named clinician accepted a named risk. SRS-MED-003's governance question is
// "which warnings does this hospital override, and how often", and this is the
// answer to it.
func overrideSummary(screen domain.ScreenResult) string {
	var overridden []string
	for _, f := range screen.Findings {
		if f.Override == nil {
			continue
		}
		overridden = append(overridden, f.RuleID+"@"+f.RuleVersion)
	}
	if len(overridden) == 0 {
		return ""
	}
	return "overrode " + strings.Join(overridden, ", ")
}

// formularyOf resolves where the medication stands (SRS-MED-012).
func (s *Service) formularyOf(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription, profile domain.MedicationProfile,
	state ports.EncounterState) (domain.FormularyDecision, error) {

	entries, err := s.catalogue.FormularyEntries(ctx, scope)
	if err != nil {
		return domain.FormularyDecision{}, err
	}
	return domain.CheckFormulary(entries, orderMedication(p), profile,
		domain.FormularyQuery{
			FacilityID: state.FacilityID, DepartmentID: state.DepartmentID,
		}), nil
}

// Get reads one prescription.
func (s *Service) Get(ctx context.Context, prescriptionID string) (
	*domain.Prescription, error) {

	session, scope, err := s.authorize(ctx, PermPrescriptionRead, "prescription",
		prescriptionID, false)
	if err != nil {
		return nil, err
	}

	p, err := s.prescriptions.Get(ctx, scope, prescriptionID)
	if err != nil {
		return nil, err
	}
	// Reads of the drug chart are audited like any other access to the clinical
	// record: what a patient is on is as disclosing as what is wrong with them.
	_ = s.appendAudit(ctx, session, audit.Record{
		Action: "med.prescription.read", ResourceType: "prescription",
		ResourceID: p.ID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now())
	return p, nil
}

// Chart lists a visit's prescriptions.
func (s *Service) Chart(ctx context.Context, encounterID string, liveOnly bool,
	limit int32) ([]*domain.Prescription, error) {

	session, scope, err := s.authorize(ctx, PermPrescriptionRead, "prescription",
		encounterID, false)
	if err != nil {
		return nil, err
	}

	list, err := s.prescriptions.ForEncounter(ctx, scope, encounterID, liveOnly,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	_ = s.appendAudit(ctx, session, audit.Record{
		Action: "med.prescription.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now())
	return list, nil
}

// DueDoses expands a visit's live prescriptions into the doses due in a window
// (SRS-MED-007).
//
// The eligibility filter is applied here rather than left to the caller: only
// active, in-window prescriptions produce doses, and where the tenant requires
// pharmacist verification an unverified one produces none. SRS-MED-007's
// acceptance is that a discontinued order prevents future administrations after
// its effective stop time, and it holds because the schedule is computed from
// the therapy ledger rather than from a flag somebody has to remember to check.
func (s *Service) DueDoses(ctx context.Context, encounterID string,
	from, to time.Time) ([]domain.DueDose, error) {

	_, scope, err := s.authorize(ctx, PermPrescriptionRead, "prescription",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	return s.dueDoses(ctx, scope, encounterID, from, to)
}

func (s *Service) dueDoses(ctx context.Context, scope authctx.TenantScope,
	encounterID string, from, to time.Time) ([]domain.DueDose, error) {

	state, err := s.encounterState(ctx, scope, encounterID)
	if err != nil {
		return nil, err
	}
	in := facilityLocation(state.TimeZone)

	policySet, err := s.catalogue.Policy(ctx, scope)
	if err != nil {
		return nil, err
	}

	live, err := s.prescriptions.ForEncounter(ctx, scope, encounterID, true,
		MaxCurrentMedications)
	if err != nil {
		return nil, err
	}

	var out []domain.DueDose
	for _, p := range live {
		profile, err := s.profileOf(ctx, scope, p)
		if err != nil {
			return nil, err
		}
		if policySet.Verification.RequiresVerification(profile) &&
			!p.Verification.Done() {
			// An unverified prescription produces no doses at all, rather than
			// doses a nurse then finds they cannot give. A round that lists
			// work nobody may do is a round people learn to read past.
			continue
		}
		out = append(out, p.Schedule(from, to, in)...)
	}

	sort.SliceStable(out, func(i, j int) bool {
		return out[i].ScheduledAt.Before(out[j].ScheduledAt)
	})
	return out, nil
}

func (s *Service) encounterState(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterState, error) {

	if s.encounters == nil {
		return ports.EncounterState{Open: true}, nil
	}
	return s.encounters.Check(ctx, scope, encounterID)
}
