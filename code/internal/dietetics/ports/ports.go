// Package ports declares what the dietetics use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// One absence is deliberate and load-bearing. There is no port here that
// writes an order or a prescription. SRS-DIET-007's "without replacing
// medication/order controls" is a property of this interface list: a
// nutrition support plan names the order carrying it out through a reference,
// and nothing in this package can create, change or administer one.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("dietetics: version conflict")

// AssessmentFilter narrows an assessment list.
type AssessmentFilter struct {
	PatientID   string
	EncounterID string
	SignedOnly  bool
	Limit       int32
	Offset      int32
}

// AssessmentRepository persists nutrition assessments (SRS-DIET-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside
// the auth package, so reaching a row without a verified tenant does not
// compile (FIT-03).
type AssessmentRepository interface {
	InsertAssessment(ctx context.Context, scope authctx.TenantScope,
		a domain.NutritionAssessment) error
	Assessment(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.NutritionAssessment, error)
	// SignAssessment is the only update. A signed assessment is not editable
	// and there is no method here that would edit one: a dietitian who has
	// changed their mind writes another, which is how the two decisions stay
	// distinguishable.
	SignAssessment(ctx context.Context, scope authctx.TenantScope,
		a domain.NutritionAssessment, expectedVersion int64) error
	Assessments(ctx context.Context, scope authctx.TenantScope,
		f AssessmentFilter) ([]domain.NutritionAssessment, error)
}

// OrderRepository persists diet orders and their allergy conflicts
// (SRS-DIET-002, SRS-DIET-003).
type OrderRepository interface {
	// InsertOrder stores the order and its conflicts together. One act,
	// because an order whose conflicts landed after it did would be an
	// active order the kitchen could see with an unresolved peanut allergy
	// against it.
	InsertOrder(ctx context.Context, scope authctx.TenantScope,
		o domain.DietOrder) error
	Order(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.DietOrder, error)
	UpdateOrder(ctx context.Context, scope authctx.TenantScope,
		o domain.DietOrder, expectedVersion int64) error
	// SupersedeOtherOrders retires the patient's other live orders, so the
	// kitchen's read returns one.
	SupersedeOtherOrders(ctx context.Context, scope authctx.TenantScope,
		patientID, keepOrderID string, at time.Time) error
	ResolveConflict(ctx context.Context, scope authctx.TenantScope,
		o domain.DietOrder, allergyRef, item string) error
	OrdersForPatient(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]domain.DietOrder, error)
	// OrdersForWard is the kitchen's read, which the domain narrows to one
	// order per patient.
	OrdersForWard(ctx context.Context, scope authctx.TenantScope,
		wardID string, limit int32) ([]domain.DietOrder, error)
}

// CarePlanFilter narrows a care plan list.
type CarePlanFilter struct {
	PatientID string
	OpenOnly  bool
	Limit     int32
	Offset    int32
}

// CarePlanRepository persists nutrition care plans (SRS-DIET-004).
type CarePlanRepository interface {
	InsertCarePlan(ctx context.Context, scope authctx.TenantScope,
		p domain.CarePlan) error
	CarePlan(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.CarePlan, error)
	CloseCarePlan(ctx context.Context, scope authctx.TenantScope,
		p domain.CarePlan, expectedVersion int64) error
	CarePlans(ctx context.Context, scope authctx.TenantScope,
		f CarePlanFilter) ([]domain.CarePlan, error)

	// AppendProgress is append-only: there is no method that edits a
	// measurement. A trend built from numbers somebody corrected in place is
	// a trend that shows whatever the last editor believed.
	AppendProgress(ctx context.Context, scope authctx.TenantScope,
		p domain.Progress) error
	Progress(ctx context.Context, scope authctx.TenantScope,
		planID, goalCode string) ([]domain.Progress, error)
}

// CensusFilter narrows a census list.
type CensusFilter struct {
	WardID   string
	Cycle    domain.MealCycle
	From, To time.Time
	Limit    int32
	Offset   int32
}

// CensusRepository persists meal censuses (SRS-DIET-005).
type CensusRepository interface {
	// InsertCensus stores the census and its lines together, for the same
	// reason the orders do: a census whose lines arrived separately is a
	// count that was briefly wrong.
	InsertCensus(ctx context.Context, scope authctx.TenantScope,
		c domain.MealCensus) error
	Census(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.MealCensus, error)
	FreezeCensus(ctx context.Context, scope authctx.TenantScope,
		c domain.MealCensus) error
	// SupersedeCensus marks a frozen census replaced by a reissue. The
	// frozen one stays readable: it is what the kitchen cooked to.
	SupersedeCensus(ctx context.Context, scope authctx.TenantScope,
		id string) error
	Censuses(ctx context.Context, scope authctx.TenantScope,
		f CensusFilter) ([]domain.MealCensus, error)
}

// TrayFilter narrows a tray list.
type TrayFilter struct {
	CensusID string
	WardID   string
	State    string
	Limit    int32
	Offset   int32
}

// TrayRepository persists meal trays (SRS-DIET-006, SRS-DIET-009).
type TrayRepository interface {
	InsertTray(ctx context.Context, scope authctx.TenantScope,
		t domain.Tray) error
	Tray(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Tray, error)
	UpdateTray(ctx context.Context, scope authctx.TenantScope,
		t domain.Tray, expectedVersion int64) error
	Trays(ctx context.Context, scope authctx.TenantScope, f TrayFilter) (
		[]domain.Tray, error)
}

// SupportFilter narrows a support plan list.
type SupportFilter struct {
	PatientID  string
	ActiveOnly bool
	Limit      int32
	Offset     int32
}

// SupportRepository persists nutrition support plans (SRS-DIET-007).
//
// Nothing here writes an order. The plan carries the identifier of the one
// that does, in the context that owns it.
type SupportRepository interface {
	InsertSupportPlan(ctx context.Context, scope authctx.TenantScope,
		p domain.NutritionSupportPlan) error
	SupportPlan(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.NutritionSupportPlan, error)
	UpdateSupportPlan(ctx context.Context, scope authctx.TenantScope,
		p domain.NutritionSupportPlan, expectedVersion int64) error
	SupportPlans(ctx context.Context, scope authctx.TenantScope,
		f SupportFilter) ([]domain.NutritionSupportPlan, error)
}

// MenuRepository persists the kitchen's recipes, menu and counts
// (SRS-DIET-003, SRS-DIET-008).
type MenuRepository interface {
	InsertItem(ctx context.Context, scope authctx.TenantScope,
		item domain.DietItem, kind string) error
	InsertRecipe(ctx context.Context, scope authctx.TenantScope,
		r domain.Recipe) error
	InsertMenuItem(ctx context.Context, scope authctx.TenantScope,
		m domain.MenuItem) error
	Menu(ctx context.Context, scope authctx.TenantScope,
		cycle domain.MealCycle) ([]domain.MenuItem, error)
	// ItemsForOrder lists everything the kitchen could put in front of a
	// patient on this order — the dishes the menu carries at that texture,
	// whatever they are made of, and the supplements the order names.
	ItemsForOrder(ctx context.Context, scope authctx.TenantScope,
		textureCode string, supplements []string) ([]domain.DietItem, error)

	AppendConsumption(ctx context.Context, scope authctx.TenantScope,
		c domain.Consumption) error
	Consumption(ctx context.Context, scope authctx.TenantScope,
		censusID string) ([]domain.Consumption, error)
}

// Allergies reads what a patient is documented as reacting to
// (SRS-DIET-003).
//
// Read-only by construction, and that is the requirement rather than a
// convenience. What a patient is allergic to belongs to the clinical record;
// a copy here would go stale the first time somebody corrected one, and that
// is the correction that matters most.
//
// A deployment with no adapter makes this context refuse to place a diet
// order rather than place one nobody checked. An order the kitchen can see
// with an unchecked allergy list is the failure this requirement exists to
// prevent, and a hospital is better off with dietitians ringing the ward than
// with a system that quietly stopped looking.
type Allergies interface {
	ForPatient(ctx context.Context, scope authctx.TenantScope,
		patientID string) ([]domain.Allergen, error)
}

// Wards lists the beds a census is built over (SRS-DIET-005).
//
// The ward and bed on a diet order are what the tray card carries, and a
// patient who moved is a tray delivered to an empty bed. A deployment with no
// adapter builds the census from the orders alone, which is what the status
// document says it does.
type Wards interface {
	OccupiedBeds(ctx context.Context, scope authctx.TenantScope,
		wardID string) (map[string]string, error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice.
//
// Used for the one thing here that cannot wait for somebody to open a screen:
// a tray held back because the patient is nil by mouth, which the ward needs
// to know about before it goes looking for a missing meal.
type Escalator interface {
	Raise(ctx context.Context, scope authctx.TenantScope, n Notice,
		at time.Time) (string, error)
}

// EventAppender publishes domain events through the outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// UnitOfWork runs a use case in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
