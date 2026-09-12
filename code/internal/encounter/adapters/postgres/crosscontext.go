package postgres

import (
	"context"
	"errors"

	empidomain "github.com/ppusapati/health/code/internal/empi/domain"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	schedulingports "github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Seams onto the contexts the encounter context depends on.
//
// Adapters rather than shared tables or shared repositories. Whether a patient
// exists is the patient index's fact and whether an appointment is theirs is
// scheduling's; a copy of either here would be a second answer that drifts from
// the first, and the drift would show up as an encounter filed against the
// wrong chart.

// Patients adapts the patient index (SRS-EMPI).
type Patients struct {
	patients empiports.PatientRepository
}

// NewPatients constructs the adapter.
func NewPatients(patients empiports.PatientRepository) Patients {
	return Patients{patients: patients}
}

var _ ports.PatientDirectory = Patients{}

// Exists reports a patient in this tenant.
//
// Deliberately the narrowest question this context can ask. Scheduling needs to
// know whether a patient accepts routine appointments; the encounter context
// needs only that they are real and in this tenant, because a patient can be
// seen in an emergency whatever their record says. Widening this port would put
// demographics in a container far more people can see.
func (p Patients) Exists(ctx context.Context, scope authctx.TenantScope,
	patientID string) (bool, error) {

	patient, err := p.patients.GetByID(ctx, scope, patientID)
	if err != nil {
		// Not-found propagates unchanged: a probe must not be able to tell a
		// patient in another tenant from one that does not exist.
		return false, err
	}
	if patient.Status == empidomain.StatusMerged {
		// The losing side of a merge is the record nothing reads. An encounter
		// against it would be invisible on the survivor's chart, which is the
		// failure mode the merge existed to prevent.
		return false, nil
	}
	return true, nil
}

// Appointments adapts the scheduling context (SRS-SCH).
type Appointments struct {
	appointments schedulingports.AppointmentRepository
}

// NewAppointments constructs the adapter.
func NewAppointments(appointments schedulingports.AppointmentRepository) Appointments {
	return Appointments{appointments: appointments}
}

var _ ports.AppointmentDirectory = Appointments{}

// BelongsToPatient reports whether an appointment is this patient's.
//
// Checked rather than trusted from the request. An encounter filed against
// somebody else's booking would close the wrong loop in the diary, and the
// symptom is a patient marked as attended who never came.
func (a Appointments) BelongsToPatient(ctx context.Context, scope authctx.TenantScope,
	appointmentID, patientID string) (bool, error) {

	appointment, err := a.appointments.Get(ctx, scope, appointmentID)
	if err != nil {
		var platformErr *rpcerr.Error
		if errors.As(err, &platformErr) && platformErr.Category == rpcerr.CategoryNotFound {
			// An appointment this tenant does not hold is not this patient's,
			// and saying so is safer than propagating a not-found that a
			// caller would read as "the patient does not exist".
			return false, nil
		}
		return false, err
	}
	return appointment.PatientID == patientID, nil
}
