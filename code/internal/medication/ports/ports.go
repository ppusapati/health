// Package ports declares what the medication application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the record first.
var ErrVersionConflict = errors.New("medication: record changed concurrently")

// PrescriptionRepository persists prescriptions (SRS-MED-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type PrescriptionRepository interface {
	// Insert stores a prescription as it stands — its segments, its screen
	// findings and its therapy status together. One act, because a prescription
	// whose dose segments landed after its status did would be visible to the
	// pharmacy with no dose.
	Insert(ctx context.Context, scope authctx.TenantScope, p *domain.Prescription) error
	Get(ctx context.Context, scope authctx.TenantScope, prescriptionID string) (
		*domain.Prescription, error)
	GetByOrder(ctx context.Context, scope authctx.TenantScope, orderID string) (
		*domain.Prescription, error)
	// ChangeTherapy records a status change and its ledger entry together, so a
	// therapy cannot reach a state with no record of how it got there.
	ChangeTherapy(ctx context.Context, scope authctx.TenantScope, p *domain.Prescription,
		change domain.TherapyChange, expectedVersion int64,
		expectedStatus domain.TherapyStatus) error
	// Verify records the pharmacist's check (SRS-MED-006). Guarded on the
	// prescription still being unverified, so a second pharmacist arriving at
	// the same moment does not move the timestamp.
	Verify(ctx context.Context, scope authctx.TenantScope, p *domain.Prescription,
		expectedVersion int64) error
	// RecordOverride answers one safety finding (SRS-MED-003).
	RecordOverride(ctx context.Context, scope authctx.TenantScope,
		prescriptionID, ruleID string, subject domain.Coding,
		o domain.Override) error

	ForEncounter(ctx context.Context, scope authctx.TenantScope, encounterID string,
		liveOnly bool, limit int32) ([]*domain.Prescription, error)
	// LiveForPatient is what the interaction and duplicate-therapy screens read.
	LiveForPatient(ctx context.Context, scope authctx.TenantScope, patientID string,
		limit int32) ([]*domain.Prescription, error)
	AwaitingVerification(ctx context.Context, scope authctx.TenantScope,
		facilityID string, limit int32) ([]*domain.Prescription, error)
}

// ReconciliationRepository persists reconciliation (SRS-MED-005).
type ReconciliationRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, r *domain.Reconciliation) error
	Get(ctx context.Context, scope authctx.TenantScope, reconciliationID string) (
		*domain.Reconciliation, error)
	// Decide records one disposition and bumps the reconciliation's version
	// together.
	Decide(ctx context.Context, scope authctx.TenantScope, r *domain.Reconciliation,
		item domain.ReconciliationItem, expectedVersion int64) error
	// Complete closes the pass. Guarded at the table on nothing being left
	// pending, so the acceptance criterion holds even against a caller that
	// skipped the domain.
	Complete(ctx context.Context, scope authctx.TenantScope, r *domain.Reconciliation,
		expectedVersion int64) error
	ForEncounter(ctx context.Context, scope authctx.TenantScope, encounterID string,
		limit int32) ([]*domain.Reconciliation, error)
}

// SubstitutionRepository persists substitutions (SRS-MED-011).
type SubstitutionRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, s *domain.Substitution) error
	Get(ctx context.Context, scope authctx.TenantScope, substitutionID string) (
		*domain.Substitution, error)
	Update(ctx context.Context, scope authctx.TenantScope, s *domain.Substitution,
		expectedStatus domain.SubstitutionStatus) error
	ForPrescription(ctx context.Context, scope authctx.TenantScope,
		prescriptionID string) ([]*domain.Substitution, error)
}

// CatalogueRepository persists the rules a tenant configures (SRS-MED-003,
// SRS-MED-004, SRS-MED-006, SRS-MED-012).
type CatalogueRepository interface {
	UpsertFormularyEntry(ctx context.Context, scope authctx.TenantScope,
		e domain.FormularyEntry) error
	FormularyEntries(ctx context.Context, scope authctx.TenantScope) (
		[]domain.FormularyEntry, error)

	UpsertInteractionRule(ctx context.Context, scope authctx.TenantScope,
		r domain.InteractionRule, active bool, updatedBy string, now time.Time) error
	InteractionRules(ctx context.Context, scope authctx.TenantScope) (
		[]domain.InteractionRule, error)

	UpsertDoseRule(ctx context.Context, scope authctx.TenantScope, r domain.DoseRule,
		active bool, validatedBy string, updatedBy string, now time.Time) error
	// DoseRules returns only the active, validated ones: SRS-MED-004 applies
	// dose support "when configured and validated", and the filter lives in the
	// query so a caller that forgets gets no advice rather than unchecked
	// advice.
	DoseRules(ctx context.Context, scope authctx.TenantScope) ([]domain.DoseRule, error)

	SetPolicy(ctx context.Context, scope authctx.TenantScope, p Policy,
		updatedBy string, now time.Time) error
	// Policy returns the tenant's configuration merged over the domain default,
	// so a tenant that has configured nothing gets the safe starting point
	// rather than no rules at all.
	Policy(ctx context.Context, scope authctx.TenantScope) (Policy, error)
}

// Policy is everything a tenant has decided about medication.
//
// Carried together because they are read together on every prescription: a
// caller that fetched the override ceiling and the verification rule in two
// calls could act on one from before an edit and one from after it.
type Policy struct {
	Override     domain.OverridePolicy
	Verification domain.VerificationPolicy
	// StructuredDoseClasses are the classes where a free-text dose is refused
	// (SRS-MED-010). Keyed by the class coding's Key.
	StructuredDoseClasses map[string]bool
	Duplicate             domain.DuplicateTherapyRule
}

// DefaultPolicy is what a tenant that has configured nothing gets.
func DefaultPolicy() Policy {
	return Policy{
		Override:     domain.DefaultOverridePolicy(),
		Verification: domain.DefaultVerificationPolicy(),
		Duplicate:    domain.DefaultDuplicateTherapyRule(),
	}
}

// Terminology maps a medication onto its ingredients, classes and therapeutic
// moiety (SRS-MED-002).
//
// A seam rather than a table, because SRS-MED-002's "medication terminology
// mapping" is exactly the thing a hospital licenses: a deployment with a real
// drug database supplies an adapter onto it, and a deployment without one gets
// whatever its tenant has configured. What this context must not do is guess,
// which is why a profile that comes back empty screens nothing rather than
// screening on the display name.
type Terminology interface {
	Profile(ctx context.Context, scope authctx.TenantScope, medication domain.Coding) (
		domain.MedicationProfile, error)
	// AllergyRule identifies the mapping in force, so every allergy finding can
	// name the rule and version that produced it.
	AllergyRule(ctx context.Context, scope authctx.TenantScope) (domain.AllergyRule, error)
}

// Allergies is the seam onto the clinical context's allergy list (SRS-MED-002).
//
// A projection rather than the record: this context needs the substance, how
// bad the reaction was and whether anybody confirmed it. The reaction narrative
// stays in the chart, where a clinician reads it.
type Allergies interface {
	ForPatient(ctx context.Context, scope authctx.TenantScope, patientID string) (
		[]domain.AllergyRecord, error)
}

// PatientContext supplies the values dose-support rules are evaluated against
// (SRS-MED-004).
//
// Every one of them is another context's fact, and the implementation says
// which it actually found: a rule that cannot see what it needs must say
// nothing rather than something wrong.
type PatientContext interface {
	Factors(ctx context.Context, scope authctx.TenantScope, patientID string,
		at time.Time) (domain.PatientFactors, error)
}

// Encounters is the seam onto the encounter context (SRS-MED-001).
type Encounters interface {
	Check(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		EncounterState, error)
}

// EncounterState is what the medication context needs about an encounter.
type EncounterState struct {
	PatientID  string
	FacilityID string
	Open       bool
	// TimeZone is the facility's zone, which the schedule needs: a
	// four-times-daily drug computed in UTC is an hour out twice a year.
	TimeZone string
	// DepartmentID narrows the formulary check (SRS-MED-012).
	DepartmentID string
}

// Orders places the CPOE order a prescription is the clinical detail of.
//
// A seam rather than a direct call into the order context's tables: the order
// framework owns identity, numbering, routing and the order lifecycle, and this
// context asks it for those rather than keeping a second copy.
type Orders interface {
	Place(ctx context.Context, scope authctx.TenantScope, req OrderRequest) (
		OrderRef, error)
	// Cancel stops the supply request when a therapy is discontinued before
	// anything was dispensed. Best-effort by design: an order the pharmacy has
	// already acted on refuses, and the therapy stops regardless — the patient
	// not getting the drug is the part that matters, and the supply request
	// catches up through its own corrective workflow.
	Cancel(ctx context.Context, scope authctx.TenantScope, orderID, reason string) error
}

// OrderRequest is what the order context needs to place a medication order.
type OrderRequest struct {
	PatientID   string
	EncounterID string
	FacilityID  string
	RequesterID string
	EnteredByID string
	Medication  domain.Coding
	// Detail is the human-readable prescription, so the order and the pharmacy
	// worklist show the same sentence the drug chart does.
	Detail         string
	Indication     string
	IndicationCode domain.Coding
	PRN            bool
	StartsAt       time.Time
	EndsAt         time.Time
	TimesOfDay     []int32
	DaysOfWeek     []time.Weekday
	Interval       time.Duration
}

// OrderRef is the order a prescription was placed as.
type OrderRef struct {
	OrderID string
	Number  string
}

// UnitOfWork runs a use case inside one database transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(ctx context.Context) error) error
}

// EventAppender writes to the transactional outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender records reads, writes and denials.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// IDGenerator issues identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the current time.
type Clock interface{ Now() time.Time }
