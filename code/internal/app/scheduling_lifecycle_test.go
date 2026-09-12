package app_test

import (
	"context"
	"strings"
	"testing"
	"time"

	schedulingv1 "github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Reschedule, cancel, series and waitlist (SRS-SCH-005, 006, 013, 015).

// bookFirstSlot books the earliest slot of a rostered day and returns it.
func (h *schedHarness) bookFirstSlot(t *testing.T, day time.Time, patient string) (
	*schedulingv1.Appointment, *schedulingv1.Slot) {
	t.Helper()

	slots := h.searchSlots(t, h.clerkToken(), day)
	if len(slots) == 0 {
		t.Fatal("no slots were generated")
	}
	booked, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  slots[0].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Reason:    "review",
		}))
	if err != nil {
		t.Fatalf("BookAppointment: %v", err)
	}
	return booked.Msg.GetAppointment(), slots[0]
}

// SRS-SCH-005: the notice given and required are captured at the moment of the
// decision, so a policy changed later cannot rewrite what a cancellation was.
func TestCancellingRecordsTheNoticeAgainstThePolicyInForce(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, slot := h.bookFirstSlot(t, day, patient)

	cancelled, err := h.sched.CancelAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.CancelAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(),
			Reason:        "patient called",
		}))
	if err != nil {
		t.Fatalf("CancelAppointment: %v", err)
	}

	if cancelled.Msg.GetAppointment().GetStatus() !=
		schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_CANCELLED {
		t.Fatalf("status = %v, want cancelled", cancelled.Msg.GetAppointment().GetStatus())
	}

	outcome := cancelled.Msg.GetOutcome()
	if outcome.GetNoticeRequiredMinutes() != 24*60 {
		t.Fatalf("notice required = %d minutes, want the 24-hour default",
			outcome.GetNoticeRequiredMinutes())
	}
	if outcome.GetNoticeGivenMinutes() <= 0 {
		t.Fatalf("notice given = %d, want the actual warning recorded",
			outcome.GetNoticeGivenMinutes())
	}
	// The default policy charges nothing: billing patients on the strength of a
	// setting nobody chose would be wrong.
	if outcome.GetChargeable() {
		t.Fatal("the default policy referred a cancellation to billing")
	}

	// The history is retained, which is what a disputed attendance record needs.
	var sawScheduled, sawCancelled bool
	for _, change := range cancelled.Msg.GetAppointment().GetHistory() {
		switch change.GetTo() {
		case schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_SCHEDULED:
			sawScheduled = true
		case schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_CANCELLED:
			sawCancelled = true
			if change.GetReason() == "" {
				t.Fatal("the cancellation has no reason recorded")
			}
		}
	}
	if !sawScheduled || !sawCancelled {
		t.Fatalf("the status history does not retain the whole life of the booking: %+v",
			cancelled.Msg.GetAppointment().GetHistory())
	}

	// And the slot is free again.
	for _, s := range h.searchSlots(t, h.clerkToken(), day) {
		if s.GetStartsAt().AsTime().Equal(slot.GetStartsAt().AsTime()) {
			return
		}
	}
	t.Fatal("a cancelled appointment did not release its slot, so the clinic lost it")
}

// A late cancellation is referred to billing only where the facility said so.
func TestALateCancellationIsChargeableOnlyWhereConfigured(t *testing.T) {
	h := newSchedHarness(t)

	if _, err := h.sched.SetSchedulingPolicy(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.SetSchedulingPolicyRequest{
			FacilityId: h.facility,
			Policy: &schedulingv1.SchedulingPolicy{
				// A week's notice, which nothing booked for next Tuesday can meet.
				NoticeHours: 24 * 7, RescheduleNoticeHours: 1,
				MaxReschedules: 3, ChargeableWhenLate: true,
			},
		})); err != nil {
		t.Fatalf("SetSchedulingPolicy: %v", err)
	}

	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")
	appointment, _ := h.bookFirstSlot(t, day, patient)

	cancelled, err := h.sched.CancelAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.CancelAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(), Reason: "patient called",
		}))
	if err != nil {
		t.Fatalf("CancelAppointment: %v", err)
	}

	outcome := cancelled.Msg.GetOutcome()
	if outcome.GetTimely() {
		t.Fatal("a cancellation inside a one-week notice period was timely")
	}
	if !outcome.GetChargeable() {
		t.Fatal("a facility that configured a charge did not get one referred")
	}
}

// SRS-SCH-005: "original appointment retains status history". A reschedule is a
// new booking chained to the old one, not an edit in place.
func TestReschedulingChainsToTheOriginalAndKeepsItsHistory(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, _ := h.bookFirstSlot(t, day, patient)
	slots := h.searchSlots(t, h.clerkToken(), day)
	target := slots[0]

	moved, err := h.sched.RescheduleAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.RescheduleAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(),
			ResourceId:    h.resource,
			StartsAt:      target.GetStartsAt(),
			VisitType:     schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Reason:        "patient asked to move",
		}))
	if err != nil {
		t.Fatalf("RescheduleAppointment: %v", err)
	}

	if moved.Msg.GetPreviousAppointmentId() != appointment.GetAppointmentId() {
		t.Fatalf("the new booking does not chain to the old one: %q",
			moved.Msg.GetPreviousAppointmentId())
	}
	if moved.Msg.GetAppointment().GetRescheduledFromId() != appointment.GetAppointmentId() {
		t.Fatal("the chain is not visible on the new appointment")
	}
	if moved.Msg.GetAppointment().GetRescheduleCount() != 1 {
		t.Fatalf("reschedule count = %d, want 1",
			moved.Msg.GetAppointment().GetRescheduleCount())
	}

	// The original still exists, cancelled, with its history.
	original, err := h.sched.GetAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("GetAppointment: %v", err)
	}
	if original.Msg.GetAppointment().GetStatus() !=
		schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_CANCELLED {
		t.Fatal("the original booking was edited away rather than retired")
	}
	if len(original.Msg.GetAppointment().GetHistory()) < 2 {
		t.Fatalf("the original lost its status history: %+v",
			original.Msg.GetAppointment().GetHistory())
	}
}

// A booking moved eleven times is a patient who is not coming, and each move
// cost a slot somebody else could have used.
func TestReschedulingIsCappedByPolicy(t *testing.T) {
	h := newSchedHarness(t)

	if _, err := h.sched.SetSchedulingPolicy(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.SetSchedulingPolicyRequest{
			FacilityId: h.facility,
			Policy: &schedulingv1.SchedulingPolicy{
				NoticeHours: 24, RescheduleNoticeHours: 1, MaxReschedules: 1,
			},
		})); err != nil {
		t.Fatalf("SetSchedulingPolicy: %v", err)
	}

	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")
	appointment, _ := h.bookFirstSlot(t, day, patient)

	move := func(id string) (*schedulingv1.Appointment, error) {
		slots := h.searchSlots(t, h.clerkToken(), day)
		if len(slots) == 0 {
			t.Fatal("no free slots left to move into")
		}
		resp, err := h.sched.RescheduleAppointment(context.Background(),
			withFacility(h.clerkToken(), h.facility,
				&schedulingv1.RescheduleAppointmentRequest{
					AppointmentId: id, ResourceId: h.resource,
					StartsAt:  slots[0].GetStartsAt(),
					VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
				}))
		if err != nil {
			return nil, err
		}
		return resp.Msg.GetAppointment(), nil
	}

	first, err := move(appointment.GetAppointmentId())
	if err != nil {
		t.Fatalf("first reschedule: %v", err)
	}
	if _, err := move(first.GetAppointmentId()); err == nil {
		t.Fatal("a booking was moved past the policy's cap")
	} else if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_RESCHEDULE_LIMIT" {
		t.Fatalf("error code = %+v, want SCH_RESCHEDULE_LIMIT", detail)
	}
}

// SRS-SCH-013: a course is booked in one call, and a week that is full is
// reported rather than failing the whole referral.
func TestASeriesBooksWhatItCanAndReportsTheRest(t *testing.T) {
	h := newSchedHarness(t)

	// A Tuesday clinic with one slot an hour, capacity one.
	day := h.defineClinic(t, time.Tuesday, 60, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")
	blocker := h.registerPatient(t, "Rao", "Anil", "9876543211")

	slots := h.searchSlots(t, h.clerkToken(), day)
	start := slots[0].GetStartsAt()

	// Fill the same hour three weeks out, so occurrence 4 has nowhere to go.
	fourthWeek := start.AsTime().AddDate(0, 0, 21)
	if _, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: blocker, ResourceId: h.resource,
			StartsAt:  timestamppb.New(fourthWeek),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		})); err != nil {
		t.Fatalf("blocking booking: %v", err)
	}

	series, err := h.sched.BookSeries(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookSeriesRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:     start,
			VisitType:    schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			IntervalDays: 7, Occurrences: 5,
			Reason: "physiotherapy",
		}))
	if err != nil {
		t.Fatalf("BookSeries: %v", err)
	}

	if len(series.Msg.GetAppointments()) != 4 {
		t.Fatalf("booked %d of 5 occurrences, want 4 with one reported unavailable",
			len(series.Msg.GetAppointments()))
	}
	if len(series.Msg.GetUnavailable()) != 1 {
		t.Fatalf("reported %d unavailable occurrences, want 1",
			len(series.Msg.GetUnavailable()))
	}
	if !series.Msg.GetUnavailable()[0].AsTime().Equal(fourthWeek) {
		t.Fatalf("the unavailable occurrence is %v, want the week that was full",
			series.Msg.GetUnavailable()[0].AsTime())
	}

	for i, a := range series.Msg.GetAppointments() {
		if a.GetSeriesId() != series.Msg.GetSeriesId() {
			t.Fatalf("occurrence %d is not tied to the course", i+1)
		}
		if a.GetOccurrence() == 0 {
			t.Fatalf("occurrence %d has no position in the course", i+1)
		}
	}
}

// The acceptance criterion: a change affects one occurrence or every future
// one.
func TestCancellingASeriesRespectsTheScopeAsked(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 60, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	series, err := h.sched.BookSeries(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookSeriesRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:     slots[0].GetStartsAt(),
			VisitType:    schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			IntervalDays: 7, Occurrences: 4,
		}))
	if err != nil {
		t.Fatalf("BookSeries: %v", err)
	}
	booked := series.Msg.GetAppointments()
	if len(booked) != 4 {
		t.Fatalf("booked %d occurrences, want 4", len(booked))
	}

	// One occurrence only.
	single, err := h.sched.CancelSeries(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.CancelSeriesRequest{
			SeriesId:          series.Msg.GetSeriesId(),
			FromAppointmentId: booked[1].GetAppointmentId(),
			Scope:             schedulingv1.SeriesScope_SERIES_SCOPE_THIS_OCCURRENCE,
			Reason:            "patient away that week",
		}))
	if err != nil {
		t.Fatalf("CancelSeries (one): %v", err)
	}
	if len(single.Msg.GetCancelledAppointmentIds()) != 1 {
		t.Fatalf("a this-occurrence cancellation touched %d appointments, want 1",
			len(single.Msg.GetCancelledAppointmentIds()))
	}

	// And then every remaining one from the third.
	future, err := h.sched.CancelSeries(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.CancelSeriesRequest{
			SeriesId:          series.Msg.GetSeriesId(),
			FromAppointmentId: booked[2].GetAppointmentId(),
			Scope:             schedulingv1.SeriesScope_SERIES_SCOPE_FUTURE_OCCURRENCES,
			Reason:            "course discontinued",
		}))
	if err != nil {
		t.Fatalf("CancelSeries (future): %v", err)
	}
	if len(future.Msg.GetCancelledAppointmentIds()) != 2 {
		t.Fatalf("a future-occurrences cancellation touched %d appointments, want 2",
			len(future.Msg.GetCancelledAppointmentIds()))
	}

	// The first occurrence is untouched: it was before the pivot.
	first, err := h.sched.GetAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetAppointmentRequest{
			AppointmentId: booked[0].GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("GetAppointment: %v", err)
	}
	if first.Msg.GetAppointment().GetStatus() ==
		schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_CANCELLED {
		t.Fatal("a bulk cancellation reached an occurrence before the pivot")
	}
}

// SRS-SCH-006: an offer expires, and does not consume the slot while it stands.
func TestAWaitlistOfferExpiresAndDoesNotHoldTheSlot(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	target := slots[0]

	entry, err := h.sched.JoinWaitlist(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.JoinWaitlistRequest{
			PatientId: patient, ResourceId: h.resource, FacilityId: h.facility,
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err != nil {
		t.Fatalf("JoinWaitlist: %v", err)
	}

	offered, err := h.sched.OfferWaitlistSlot(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.OfferWaitlistSlotRequest{
			WaitlistId: entry.Msg.GetEntry().GetWaitlistId(),
			ResourceId: h.resource, StartsAt: target.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			// One minute, so the sweep below finds it expired.
			ValidForMinutes: 0,
		}))
	if err != nil {
		t.Fatalf("OfferWaitlistSlot: %v", err)
	}
	if offered.Msg.GetEntry().GetStatus() !=
		schedulingv1.WaitlistStatus_WAITLIST_STATUS_OFFERED {
		t.Fatalf("status = %v, want offered", offered.Msg.GetEntry().GetStatus())
	}
	if offered.Msg.GetEntry().GetOfferExpiresAt() == nil {
		t.Fatal("an offer was made with no expiry, so the slot is held forever")
	}

	// While the offer stands the slot is NOT consumed: capacity held for
	// somebody who has stopped reading their messages is capacity nobody can
	// use and nobody can see is gone.
	var stillOffered bool
	for _, s := range h.searchSlots(t, h.clerkToken(), day) {
		if s.GetStartsAt().AsTime().Equal(target.GetStartsAt().AsTime()) {
			stillOffered = true
		}
	}
	if !stillOffered {
		t.Fatal("an unanswered waitlist offer consumed the slot")
	}
}

// The "cannot create duplicate confirmed bookings" half: accepting an earlier
// slot reschedules the appointment the patient already holds.
func TestAcceptingAnOfferReplacesTheExistingBooking(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 60, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	if len(slots) < 2 {
		t.Fatal("need at least two slots")
	}
	earlier, later := slots[0], slots[1]

	// The patient holds the later slot.
	held, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  later.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err != nil {
		t.Fatalf("BookAppointment: %v", err)
	}

	entry, err := h.sched.JoinWaitlist(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.JoinWaitlistRequest{
			PatientId: patient, ResourceId: h.resource, FacilityId: h.facility,
			VisitType:     schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			AppointmentId: held.Msg.GetAppointment().GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("JoinWaitlist: %v", err)
	}

	if _, err := h.sched.OfferWaitlistSlot(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.OfferWaitlistSlotRequest{
			WaitlistId: entry.Msg.GetEntry().GetWaitlistId(),
			ResourceId: h.resource, StartsAt: earlier.GetStartsAt(),
			VisitType:       schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			ValidForMinutes: 60,
		})); err != nil {
		t.Fatalf("OfferWaitlistSlot: %v", err)
	}

	accepted, err := h.sched.AcceptWaitlistOffer(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.AcceptWaitlistOfferRequest{
			WaitlistId: entry.Msg.GetEntry().GetWaitlistId(),
		}))
	if err != nil {
		t.Fatalf("AcceptWaitlistOffer: %v", err)
	}

	if accepted.Msg.GetReplacedAppointmentId() != held.Msg.GetAppointment().GetAppointmentId() {
		t.Fatalf("the accepted offer did not replace the booking the patient held: %q",
			accepted.Msg.GetReplacedAppointmentId())
	}

	// Exactly one live booking for this patient.
	listed, err := h.sched.ListAppointments(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.ListAppointmentsRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("ListAppointments: %v", err)
	}
	var live int
	for _, a := range listed.Msg.GetAppointments() {
		if a.GetStatus() != schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_CANCELLED {
			live++
		}
	}
	if live != 1 {
		t.Fatalf("the patient holds %d live bookings after accepting an earlier "+
			"slot, want 1 — SRS-SCH-006 forbids duplicate confirmed bookings", live)
	}
}

// An offer of a slot later than the one the patient holds is a downgrade
// somebody would have to explain.
func TestAWaitlistWillNotOfferALaterSlot(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 60, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	earlier, later := slots[0], slots[1]

	held, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  earlier.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err != nil {
		t.Fatalf("BookAppointment: %v", err)
	}

	entry, err := h.sched.JoinWaitlist(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.JoinWaitlistRequest{
			PatientId: patient, ResourceId: h.resource, FacilityId: h.facility,
			VisitType:     schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			AppointmentId: held.Msg.GetAppointment().GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("JoinWaitlist: %v", err)
	}

	_, err = h.sched.OfferWaitlistSlot(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.OfferWaitlistSlotRequest{
			WaitlistId: entry.Msg.GetEntry().GetWaitlistId(),
			ResourceId: h.resource, StartsAt: later.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err == nil {
		t.Fatal("a patient was offered a slot later than the one they already held")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_OFFER_NOT_SUITABLE" {
		t.Fatalf("error code = %+v, want SCH_OFFER_NOT_SUITABLE", detail)
	}
}

// SRS-SCH-015: a facility that has not enabled teleconsults does not offer one.
func TestATeleconsultIsRefusedWhereNotEnabled(t *testing.T) {
	h := newSchedHarness(t)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	day := nextWeekday(time.Wednesday)
	if _, err := h.sched.DefineSchedule(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.DefineScheduleRequest{
			ResourceId:  h.resource,
			VisitType:   schedulingv1.VisitType_VISIT_TYPE_TELECONSULT,
			VisitMode:   schedulingv1.VisitMode_VISIT_MODE_TELECONSULT,
			Weekday:     int32(time.Wednesday),
			StartMinute: 9 * 60, EndMinute: 12 * 60,
			SlotMinutes: 20, Capacity: 1,
			EffectiveFrom: timestamppb.New(day.AddDate(0, 0, -1)),
		})); err != nil {
		t.Fatalf("DefineSchedule: %v", err)
	}

	found, err := h.sched.SearchSlots(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.SearchSlotsRequest{
			ResourceId: h.resource,
			From:       timestamppb.New(day), Until: timestamppb.New(day.AddDate(0, 0, 1)),
		}))
	if err != nil {
		t.Fatalf("SearchSlots: %v", err)
	}
	if len(found.Msg.GetSlots()) == 0 {
		t.Fatal("no teleconsult slots were generated")
	}

	_, err = h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  found.Msg.GetSlots()[0].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_TELECONSULT,
		}))
	if err == nil {
		t.Fatal("a teleconsult was booked at a facility that does not offer them")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_TELECONSULT_NOT_ELIGIBLE" {
		t.Fatalf("error code = %+v, want SCH_TELECONSULT_NOT_ELIGIBLE", detail)
	}

	// Enabled, and the same booking succeeds.
	if _, err := h.sched.SetSchedulingPolicy(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.SetSchedulingPolicyRequest{
			FacilityId: h.facility,
			Policy: &schedulingv1.SchedulingPolicy{
				NoticeHours: 24, RescheduleNoticeHours: 4, MaxReschedules: 3,
				TeleconsultEnabled: true,
			},
		})); err != nil {
		t.Fatalf("SetSchedulingPolicy: %v", err)
	}

	booked, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  found.Msg.GetSlots()[0].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_TELECONSULT,
		}))
	if err != nil {
		t.Fatalf("BookAppointment after enabling teleconsults: %v", err)
	}
	if booked.Msg.GetAppointment().GetVisitMode() !=
		schedulingv1.VisitMode_VISIT_MODE_TELECONSULT {
		t.Fatalf("visit mode = %v, want teleconsult",
			booked.Msg.GetAppointment().GetVisitMode())
	}
	// No meeting provider is wired in this deployment, so the link is absent
	// rather than broken — which is visible, and a broken URL is not.
	if booked.Msg.GetAppointment().GetJoinUrl() != "" {
		t.Fatalf("a join link was minted with no meeting provider configured: %q",
			booked.Msg.GetAppointment().GetJoinUrl())
	}
}

// An in-person appointment carrying a join link invites a patient to stay home.
func TestAnInPersonAppointmentCarriesNoJoinLink(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, _ := h.bookFirstSlot(t, day, patient)
	if appointment.GetJoinUrl() != "" {
		t.Fatalf("an in-person appointment carries a join link: %q", appointment.GetJoinUrl())
	}
	if appointment.GetVisitMode() != schedulingv1.VisitMode_VISIT_MODE_IN_PERSON {
		t.Fatalf("visit mode = %v, want in person", appointment.GetVisitMode())
	}
}

// Configuring what a facility charges for a late cancellation is not something
// a receptionist does.
func TestAClerkCannotSetTheCancellationPolicy(t *testing.T) {
	h := newSchedHarness(t)

	_, err := h.sched.SetSchedulingPolicy(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.SetSchedulingPolicyRequest{
			FacilityId: h.facility,
			Policy: &schedulingv1.SchedulingPolicy{
				NoticeHours: 0, ChargeableWhenLate: false,
			},
		}))
	if err == nil {
		t.Fatal("a registration clerk rewrote the cancellation policy")
	}
	if detail := errorDetail(t, err); detail == nil ||
		!strings.Contains(detail.GetCode(), "DENIED") {
		t.Fatalf("error code = %+v, want a denial", detail)
	}
}
