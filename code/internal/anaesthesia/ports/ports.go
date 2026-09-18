// Package ports declares what the anaesthesia application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrNotFound reports a record, plan or assessment that is not there.
var ErrNotFound = errors.New("anaesthesia: not found")

// AssessmentRepository persists pre-anaesthesia assessments and plans.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type AssessmentRepository interface {
	// InsertAssessment writes a first assessment.
	InsertAssessment(ctx context.Context, scope authctx.TenantScope,
		a domain.Assessment) error
	// Supersede writes a later version and retires the one it replaces, in one
	// transaction. Two statements rather than one because the database holds
	// "at most one current assessment per case" as an index, and a caller that
	// could write the new row without retiring the old would violate it.
	Supersede(ctx context.Context, scope authctx.TenantScope,
		next domain.Assessment, previousID string, at time.Time) error
	Assessment(ctx context.Context, scope authctx.TenantScope, assessmentID string) (
		domain.Assessment, error)
	// Assessments returns every version for a case, oldest first. The history
	// is the point: a patient assessed in clinic and reassessed on the morning
	// of surgery has two, and the difference between them is what changed.
	Assessments(ctx context.Context, scope authctx.TenantScope, caseID string) (
		[]domain.Assessment, error)
	PatientAssessments(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]domain.Assessment, error)

	SavePlan(ctx context.Context, scope authctx.TenantScope, p domain.Plan) error
	// Plan returns the plan for a case. The bool is false where none exists,
	// which is an ordinary state before the anaesthetist has seen the list.
	Plan(ctx context.Context, scope authctx.TenantScope, caseID string) (
		domain.Plan, bool, error)
}

// RecordRepository persists the intraoperative record and everything charted
// against it.
type RecordRepository interface {
	InsertRecord(ctx context.Context, scope authctx.TenantScope,
		r domain.Record) error
	Record(ctx context.Context, scope authctx.TenantScope, recordID string) (
		domain.Record, error)
	RecordForCase(ctx context.Context, scope authctx.TenantScope, caseID string) (
		domain.Record, bool, error)
	UpdateStatus(ctx context.Context, scope authctx.TenantScope, recordID string,
		status domain.RecordStatus, endedAt time.Time) error
	PatientRecords(ctx context.Context, scope authctx.TenantScope, patientID string,
		limit int32) ([]domain.Record, error)

	InsertVital(ctx context.Context, scope authctx.TenantScope,
		v domain.VitalEntry) error
	// Vitals returns the chart. An empty code returns every series, which is
	// what the record view reads; a code returns one trend.
	Vitals(ctx context.Context, scope authctx.TenantScope, recordID, code string) (
		[]domain.VitalEntry, error)

	InsertDrug(ctx context.Context, scope authctx.TenantScope,
		d domain.DrugEntry) error
	Drugs(ctx context.Context, scope authctx.TenantScope, recordID string) (
		[]domain.DrugEntry, error)
	// StopInfusion is false where the infusion was already stopped, so two
	// people stopping the same pump do not produce two stop times.
	StopInfusion(ctx context.Context, scope authctx.TenantScope, drugID string,
		at time.Time) (bool, error)

	InsertAirwayEvent(ctx context.Context, scope authctx.TenantScope,
		e domain.AirwayEvent) error
	AirwayEvents(ctx context.Context, scope authctx.TenantScope, recordID string) (
		[]domain.AirwayEvent, error)
	// PatientAirwayEvents is the difficult-airway history across admissions,
	// which is the one thing the next anaesthetist most needs and the one most
	// often lost between them.
	PatientAirwayEvents(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]domain.AirwayEvent, error)

	InsertFluid(ctx context.Context, scope authctx.TenantScope,
		f domain.FluidEntry) error
	Fluids(ctx context.Context, scope authctx.TenantScope, recordID string) (
		[]domain.FluidEntry, error)

	InsertHandover(ctx context.Context, scope authctx.TenantScope,
		h domain.Handover) error
	Handovers(ctx context.Context, scope authctx.TenantScope, recordID string) (
		[]domain.Handover, error)
}

// RecoveryRepository persists PACU scoring, discharge and pain plans.
type RecoveryRepository interface {
	InsertAssessment(ctx context.Context, scope authctx.TenantScope,
		a domain.RecoveryAssessment) error
	Assessments(ctx context.Context, scope authctx.TenantScope, recordID string) (
		[]domain.RecoveryAssessment, error)

	InsertDischarge(ctx context.Context, scope authctx.TenantScope,
		d domain.Discharge) error
	Discharge(ctx context.Context, scope authctx.TenantScope, recordID string) (
		domain.Discharge, bool, error)

	InsertPainOrder(ctx context.Context, scope authctx.TenantScope,
		o domain.PainOrder) error
	PainOrder(ctx context.Context, scope authctx.TenantScope, orderID string) (
		domain.PainOrder, error)
	PainOrders(ctx context.Context, scope authctx.TenantScope, recordID string) (
		[]domain.PainOrder, error)
	// RunningPainOrders is the acute pain team's worklist, soonest review
	// first.
	RunningPainOrders(ctx context.Context, scope authctx.TenantScope,
		limit int32) ([]domain.PainOrder, error)
	StopPainOrder(ctx context.Context, scope authctx.TenantScope, orderID, by string,
		at time.Time) (bool, error)
}

// Cases reports what the theatre knows about the operation an anaesthetic
// hangs off.
//
// A port rather than a direct dependency: the case belongs to SRS-OT, and
// anaesthesia reads it without owning it.
type Cases interface {
	// Case returns the patient and encounter the case is for, and whether it
	// is still open to charting. A closed case returns writable false.
	Case(ctx context.Context, scope authctx.TenantScope, caseID string) (
		patientID, encounterID string, writable bool, err error)
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
