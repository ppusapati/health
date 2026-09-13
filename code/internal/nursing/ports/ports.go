// Package ports declares what the nursing application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the record first.
var ErrVersionConflict = errors.New("nursing: record changed concurrently")

// AssessmentRepository persists nursing assessments and their templates
// (SRS-NUR-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type AssessmentRepository interface {
	InsertTemplate(ctx context.Context, scope authctx.TenantScope,
		t domain.AssessmentTemplate, createdBy string, now time.Time) error
	GetTemplate(ctx context.Context, scope authctx.TenantScope,
		templateID, version string) (domain.AssessmentTemplate, error)
	ListTemplates(ctx context.Context, scope authctx.TenantScope,
		serviceCode string, includeRetired bool, limit int32) (
		[]domain.AssessmentTemplate, error)
	RetireTemplate(ctx context.Context, scope authctx.TenantScope,
		templateID, version string) error

	Insert(ctx context.Context, scope authctx.TenantScope,
		a *domain.Assessment) error
	Get(ctx context.Context, scope authctx.TenantScope, assessmentID string) (
		*domain.Assessment, error)
	List(ctx context.Context, scope authctx.TenantScope, encounterID string,
		kind domain.AssessmentKind, limit int32) ([]*domain.Assessment, error)
}

// RiskRepository persists risk scales and scores (SRS-NUR-005).
type RiskRepository interface {
	InsertScale(ctx context.Context, scope authctx.TenantScope,
		s domain.RiskScale, createdBy string, now time.Time) error
	GetScale(ctx context.Context, scope authctx.TenantScope,
		scaleID, version string) (domain.RiskScale, error)
	ListScales(ctx context.Context, scope authctx.TenantScope,
		riskDomain domain.RiskDomain, includeRetired bool, limit int32) (
		[]domain.RiskScale, error)

	Insert(ctx context.Context, scope authctx.TenantScope,
		r *domain.RiskAssessment) error
	// Supersede marks the previous live score replaced. Separate from Insert so
	// the two happen in one transaction: a rescore that inserted without
	// superseding would leave two live scores and no way to say which the ward
	// is acting on.
	Supersede(ctx context.Context, scope authctx.TenantScope,
		riskID, supersededByID string) error
	Latest(ctx context.Context, scope authctx.TenantScope,
		patientID string, riskDomain domain.RiskDomain) (
		*domain.RiskAssessment, error)
	List(ctx context.Context, scope authctx.TenantScope, patientID string,
		riskDomain domain.RiskDomain, limit int32) ([]*domain.RiskAssessment, error)
	// Due answers SRS-NUR-005's "due reassessment appears as task".
	Due(ctx context.Context, scope authctx.TenantScope, encounterID string,
		asOf time.Time, limit int32) ([]*domain.RiskAssessment, error)
}

// FlowsheetRepository persists charted observations and fluid volumes
// (SRS-NUR-003, SRS-NUR-004).
type FlowsheetRepository interface {
	InsertEntry(ctx context.Context, scope authctx.TenantScope,
		e *domain.FlowsheetEntry) error
	SupersedeEntry(ctx context.Context, scope authctx.TenantScope,
		entryID, supersededByID string) error
	ListEntries(ctx context.Context, scope authctx.TenantScope,
		q FlowsheetQuery) ([]*domain.FlowsheetEntry, error)

	InsertFluid(ctx context.Context, scope authctx.TenantScope,
		f *domain.FluidEntry) error
	GetFluid(ctx context.Context, scope authctx.TenantScope, fluidID string) (
		*domain.FluidEntry, error)
	SupersedeFluid(ctx context.Context, scope authctx.TenantScope,
		fluidID, supersededByID string) error
	VoidFluid(ctx context.Context, scope authctx.TenantScope, fluidID,
		reason string, now time.Time) error
	ListFluid(ctx context.Context, scope authctx.TenantScope, q FluidQuery) (
		[]*domain.FluidEntry, error)
}

// FlowsheetQuery narrows a chart listing.
//
// Bounded by observation time rather than recording time, because the chart is
// a picture of the patient.
type FlowsheetQuery struct {
	EncounterID  string
	Code         string
	ObservedFrom time.Time
	ObservedTo   time.Time
	Limit        int32
}

// FluidQuery narrows a fluid listing.
type FluidQuery struct {
	EncounterID  string
	ObservedFrom time.Time
	ObservedTo   time.Time
	// IncludeSuperseded shows the amendment trail. Off for a balance, on for an
	// audit: the balance must count live entries only, and the trail must show
	// everything.
	IncludeSuperseded bool
	Limit             int32
}

// DeviceRepository persists lines, tubes, drains and catheters
// (SRS-NUR-006).
type DeviceRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, d *domain.Device) error
	Get(ctx context.Context, scope authctx.TenantScope, deviceID string) (
		*domain.Device, error)
	Remove(ctx context.Context, scope authctx.TenantScope, d *domain.Device,
		expectedVersion int64) error
	List(ctx context.Context, scope authctx.TenantScope, encounterID string,
		inPlaceOnly bool, limit int32) ([]*domain.Device, error)
	RecordCare(ctx context.Context, scope authctx.TenantScope, deviceID string,
		care domain.DeviceCare) error
	ListCare(ctx context.Context, scope authctx.TenantScope, deviceID string,
		limit int32) ([]domain.DeviceCare, error)
}

// AdministrationRepository persists the medication administration record
// (SRS-NUR-007 … SRS-NUR-009, SRS-NUR-018).
type AdministrationRepository interface {
	// Insert stores a dose. It returns domain.ErrDuplicateAdministration when
	// the scheduled-dose key already exists, which is SRS-NUR-018's guard: the
	// uniqueness is enforced by the table, because two transcriptions of one
	// paper entry can be in flight at the same moment and a check-then-insert
	// would let both through.
	Insert(ctx context.Context, scope authctx.TenantScope,
		a *domain.Administration) error
	List(ctx context.Context, scope authctx.TenantScope, encounterID,
		orderID string, limit int32) ([]*domain.Administration, error)
	// Overrides feeds the report that gets a broken scanner replaced.
	Overrides(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time, limit int32) ([]*domain.Administration, error)

	SetPolicy(ctx context.Context, scope authctx.TenantScope, facilityID string,
		p domain.AdministrationPolicy, updatedBy string, now time.Time) error
	// Policy returns the facility's policy, or the safe default where none is
	// configured: a control that has to be switched on is a control that is off
	// in the wards that most need it.
	Policy(ctx context.Context, scope authctx.TenantScope, facilityID string) (
		domain.AdministrationPolicy, error)
}

// MedicationOrders is the seam onto the medication context (SRS-NUR-007).
//
// A projection, not a copy: nursing needs to know what to give, when, and
// whether a pharmacist has verified it, and does not need the prescribing
// rationale. Sprint 5 (SRS-MED) supplies the real adapter; until then the seam
// exists so the eMAR is written against an interface rather than against a
// table it would then have to unlearn.
type MedicationOrders interface {
	// Due returns the doses scheduled in a window. The implementation is
	// responsible for returning only active, pharmacist-verified orders — the
	// nursing context checks it again at administration time, because a stale
	// worklist is exactly what a nurse would be acting on.
	Due(ctx context.Context, scope authctx.TenantScope, encounterID string,
		from, to time.Time) ([]domain.DueDose, error)
	Get(ctx context.Context, scope authctx.TenantScope, orderID string) (
		domain.MedicationOrder, error)
}

// TaskRepository persists nursing work (SRS-NUR-011).
type TaskRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope,
		t *domain.NursingTask) error
	Get(ctx context.Context, scope authctx.TenantScope, taskID string) (
		*domain.NursingTask, error)
	Close(ctx context.Context, scope authctx.TenantScope, t *domain.NursingTask,
		expectedVersion int64) error
	Escalate(ctx context.Context, scope authctx.TenantScope, taskID,
		escalatedTo string, now time.Time) error
	Worklist(ctx context.Context, scope authctx.TenantScope, q WorklistQuery) (
		[]*domain.NursingTask, error)
	NeedingEscalation(ctx context.Context, scope authctx.TenantScope,
		asOf time.Time, limit int32) ([]*domain.NursingTask, error)
}

// WorklistQuery narrows a task listing.
type WorklistQuery struct {
	EncounterID string
	AssignedTo  string
	PendingOnly bool
	Limit       int32
}

// CarePlanRepository persists nursing care plans (SRS-NUR-002).
type CarePlanRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, p *domain.CarePlan) error
	Get(ctx context.Context, scope authctx.TenantScope, planID string) (
		*domain.CarePlan, error)
	Update(ctx context.Context, scope authctx.TenantScope, p *domain.CarePlan,
		expectedVersion int64) error
	List(ctx context.Context, scope authctx.TenantScope, encounterID string,
		activeOnly bool, limit int32) ([]*domain.CarePlan, error)
}

// HandoverRepository persists shift handovers (SRS-NUR-010).
type HandoverRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, h *domain.Handover) error
	Get(ctx context.Context, scope authctx.TenantScope, handoverID string) (
		*domain.Handover, error)
	// Acknowledge is guarded on the handover still being unaccepted, so
	// responsibility cannot be shown as transferred twice.
	Acknowledge(ctx context.Context, scope authctx.TenantScope,
		h *domain.Handover) error
	List(ctx context.Context, scope authctx.TenantScope, encounterID string,
		unacknowledgedOnly bool, limit int32) ([]*domain.Handover, error)
}

// SafetyRepository persists restraints and transfusions
// (SRS-NUR-013, SRS-NUR-014).
type SafetyRepository interface {
	InsertRestraint(ctx context.Context, scope authctx.TenantScope,
		r *domain.Restraint) error
	GetRestraint(ctx context.Context, scope authctx.TenantScope,
		restraintID string) (*domain.Restraint, error)
	UpdateRestraint(ctx context.Context, scope authctx.TenantScope,
		r *domain.Restraint, expectedVersion int64) error
	ListRestraints(ctx context.Context, scope authctx.TenantScope,
		encounterID string, activeOnly bool, limit int32) (
		[]*domain.Restraint, error)
	// ExpiredAuthorizations lists live restraints whose authorization has
	// lapsed. Still active restraints: the patient is restrained, and what has
	// expired is the permission.
	ExpiredAuthorizations(ctx context.Context, scope authctx.TenantScope,
		asOf time.Time, limit int32) ([]*domain.Restraint, error)
	InsertRestraintCheck(ctx context.Context, scope authctx.TenantScope,
		restraintID string, c domain.RestraintCheck) error

	InsertTransfusion(ctx context.Context, scope authctx.TenantScope,
		t *domain.Transfusion) error
	GetTransfusion(ctx context.Context, scope authctx.TenantScope,
		transfusionID string) (*domain.Transfusion, error)
	EndTransfusion(ctx context.Context, scope authctx.TenantScope,
		t *domain.Transfusion, expectedVersion int64) error
	ListTransfusions(ctx context.Context, scope authctx.TenantScope,
		encounterID string, limit int32) ([]*domain.Transfusion, error)
	InsertTransfusionObservation(ctx context.Context, scope authctx.TenantScope,
		transfusionID string, o domain.TransfusionObservation) error
}

// WardRepository persists wound assessments, education, assignments and the
// acuity weights (SRS-NUR-012, SRS-NUR-015, SRS-NUR-016, SRS-NUR-017).
type WardRepository interface {
	InsertWound(ctx context.Context, scope authctx.TenantScope,
		w *domain.WoundAssessment) error
	GetWound(ctx context.Context, scope authctx.TenantScope,
		assessmentID string) (*domain.WoundAssessment, error)
	ListWounds(ctx context.Context, scope authctx.TenantScope, patientID,
		woundID string, limit int32) ([]*domain.WoundAssessment, error)
	InsertWoundImage(ctx context.Context, scope authctx.TenantScope,
		assessmentID string, img domain.WoundImage) error

	InsertEducation(ctx context.Context, scope authctx.TenantScope,
		e *domain.EducationRecord) error
	ListEducation(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]*domain.EducationRecord, error)

	InsertAssignment(ctx context.Context, scope authctx.TenantScope,
		a *domain.NurseAssignment) error
	EndAssignment(ctx context.Context, scope authctx.TenantScope,
		a *domain.NurseAssignment) error
	// Assignments answers "who was looking after this patient at this time".
	Assignments(ctx context.Context, scope authctx.TenantScope,
		q AssignmentQuery) ([]*domain.NurseAssignment, error)
	NursesOnDuty(ctx context.Context, scope authctx.TenantScope, unitID string,
		asOf time.Time) (int32, error)

	SetAcuityWeights(ctx context.Context, scope authctx.TenantScope,
		unitID string, w domain.AcuityWeights, updatedBy string,
		now time.Time) error
	AcuityWeights(ctx context.Context, scope authctx.TenantScope,
		unitID string) (domain.AcuityWeights, error)
}

// AssignmentQuery narrows an assignment listing to a moment.
type AssignmentQuery struct {
	UnitID    string
	PatientID string
	NurseID   string
	AsOf      time.Time
	Limit     int32
}

// DowntimeRepository persists downtime episodes (SRS-NUR-018).
type DowntimeRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope,
		e *domain.DowntimeEpisode) error
	Get(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		*domain.DowntimeEpisode, error)
	End(ctx context.Context, scope authctx.TenantScope,
		e *domain.DowntimeEpisode) error
	Reconcile(ctx context.Context, scope authctx.TenantScope,
		e *domain.DowntimeEpisode) error
	List(ctx context.Context, scope authctx.TenantScope, unitID string,
		unreconciledOnly bool, limit int32) ([]*domain.DowntimeEpisode, error)
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

// Encounters is the seam onto the encounter context.
//
// Nursing needs to know that an encounter is open and which patient it belongs
// to before it writes anything against it. It receives a projection rather than
// the encounter, for the reason the clinical seam gives: a shared aggregate
// between two bounded contexts makes them one context.
type Encounters interface {
	// Check reports whether this encounter is open and belongs to this
	// patient. It returns NOT_FOUND for an encounter in another tenant, so a
	// probe cannot confirm an identifier exists elsewhere.
	Check(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		EncounterState, error)
}

// EncounterState is what nursing needs to know about an encounter.
type EncounterState struct {
	PatientID  string
	FacilityID string
	// Open reports whether clinical content may still be written.
	Open bool
}

// Consents is the seam onto the clinical context's consent record
// (SRS-NUR-012).
//
// A photograph of a wound is a photograph of a patient, and whether a consent
// covers clinical photography is the clinical context's question to answer.
// Nursing receives a boolean and refuses the image without one.
type Consents interface {
	CoversPhotography(ctx context.Context, scope authctx.TenantScope,
		consentID, patientID string) (bool, error)
}
