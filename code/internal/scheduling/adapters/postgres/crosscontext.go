package postgres

import (
	"context"
	"time"

	empidomain "github.com/ppusapati/health/code/internal/empi/domain"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Seams onto the contexts scheduling depends on.
//
// Adapters rather than shared tables or shared repositories. Whether the
// hospital is shut on 2 October is the organization context's fact, and whether
// a patient may be given a routine appointment is the patient index's; a
// scheduling copy of either would be a second answer that drifts from the
// first, and the drift would show up as a patient turning up to a closed
// building.

// Calendar adapts the organization context's facility calendar.
type Calendar struct {
	calendars  orgports.CalendarRepository
	facilities orgports.FacilityRepository
}

// NewCalendar constructs the adapter.
func NewCalendar(calendars orgports.CalendarRepository,
	facilities orgports.FacilityRepository) Calendar {
	return Calendar{calendars: calendars, facilities: facilities}
}

var _ ports.FacilityCalendar = Calendar{}

// ClosedDates returns the local dates a facility is shut.
//
// Walks the range a day at a time rather than asking for an interval, because
// the organization port answers per date and a range query here would be a
// second implementation of "is this date inside that entry" — the kind of
// duplicate that agrees until a boundary case.
func (c Calendar) ClosedDates(ctx context.Context, scope authctx.TenantScope,
	facilityID string, from, until time.Time) (map[string]bool, error) {

	out := map[string]bool{}
	for day := from; day.Before(until); day = day.AddDate(0, 0, 1) {
		entries, err := c.calendars.CalendarEntriesOn(ctx, scope, facilityID, day)
		if err != nil {
			return nil, err
		}
		for _, entry := range entries {
			// Reduced hours and special openings change the shape of the day
			// rather than removing it; a roster narrower than the opening
			// hours is the ordinary case and not something to model twice.
			if entry.Type == orgdomain.EntryHoliday || entry.Type == orgdomain.EntryClosure {
				out[day.Format("2006-01-02")] = true
			}
		}
	}
	return out, nil
}

// Active reports whether the facility can be booked at all (SRS-SCH-014).
func (c Calendar) Active(ctx context.Context, scope authctx.TenantScope,
	facilityID string) (bool, error) {

	facility, err := c.facilities.GetByID(ctx, scope, facilityID)
	if err != nil {
		return false, err
	}
	return facility.Status == orgdomain.FacilityActive, nil
}

// Patients adapts the patient index.
//
// Deliberately narrow: scheduling asks one question and receives one boolean.
// A wider seam would put demographics in a diary far more people can see than
// can see the patient record.
type Patients struct {
	patients empiports.PatientRepository
}

// NewPatients constructs the adapter.
func NewPatients(patients empiports.PatientRepository) Patients {
	return Patients{patients: patients}
}

var _ ports.PatientDirectory = Patients{}

// AcceptsRoutineScheduling answers the factual half SRS-EMPI-008 leaves to the
// identity context.
//
// The identity context says whether the patient is fit to receive a routine
// appointment; scheduling decides what to do about it. That split is why this
// returns a boolean rather than a refusal: a hospital that wants to warn rather
// than block can, and the decision lives in one place either way.
func (p Patients) AcceptsRoutineScheduling(ctx context.Context, scope authctx.TenantScope,
	patientID string) (bool, error) {

	patient, err := p.patients.GetByID(ctx, scope, patientID)
	if err != nil {
		// Not-found propagates: booking an appointment for a patient who is
		// not in this tenant must fail, and must fail without confirming
		// whether the identifier exists elsewhere.
		return false, err
	}
	if patient.Status == empidomain.StatusMerged {
		// The losing side of a merge is the record nothing reads. An
		// appointment against it would be invisible on the survivor's chart.
		return false, nil
	}
	return patient.AcceptsRoutineScheduling(), nil
}

// IdentityConfirmed reports whether identity was positively established.
//
// Active rather than candidate: a candidate record is one created before
// identity was confirmed, which is exactly the state SRS-EMPI-010's evidence
// rule moves a patient out of.
func (p Patients) IdentityConfirmed(ctx context.Context, scope authctx.TenantScope,
	patientID string) (bool, error) {

	patient, err := p.patients.GetByID(ctx, scope, patientID)
	if err != nil {
		return false, err
	}
	return patient.Status == empidomain.StatusActive, nil
}

// Contacts adapts the patient index's communication preferences (SRS-SCH-012).
//
// A seam rather than a copy, because SRS-EMPI-013 holds the answer per channel
// *and* per purpose, and a scheduling copy would be a second record of what a
// patient agreed to — which is exactly the record somebody would forget to
// update when the patient changed their mind.
type Contacts struct {
	preferences empiports.HistoryRepository
	clock       func() time.Time
}

// NewContacts constructs the adapter.
func NewContacts(preferences empiports.HistoryRepository, now func() time.Time) Contacts {
	return Contacts{preferences: preferences, clock: now}
}

var _ ports.PatientContact = Contacts{}

// preferredChannelOrder is the order appointment messages are tried in.
//
// SMS first because an appointment reminder is short, timely and read on a
// phone; post last because a message that arrives after the appointment is not
// a reminder. Phone is absent deliberately: a call is a person's time, not a
// channel this context can commit somebody to.
var preferredChannelOrder = []empidomain.CommunicationChannel{
	empidomain.ChannelSMS, empidomain.ChannelEmail, empidomain.ChannelPost,
}

// PreferredChannel returns the channel this patient agreed to for appointment
// messages.
//
// Deny by default. An absent preference means nobody asked, and sending anyway
// on the grounds that the patient never said no is how an optional
// communication reaches somebody who did not want it.
func (c Contacts) PreferredChannel(ctx context.Context, scope authctx.TenantScope,
	patientID string) (string, bool, error) {

	preferences, err := c.preferences.Preferences(ctx, scope, patientID)
	if err != nil {
		return "", false, err
	}

	at := c.clock()
	for _, channel := range preferredChannelOrder {
		if preferences.Permits(channel, empidomain.PurposeAppointmentReminder, at) {
			return string(channel), true, nil
		}
	}
	return "", false, nil
}
