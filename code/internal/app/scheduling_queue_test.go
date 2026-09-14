package app_test

import (
	"context"
	"strings"
	"testing"
	"time"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	schedulingv1 "github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1"
)

// Check-in, the queue, walk-ins and notifications
// (SRS-SCH-007 … SRS-SCH-012).
//
// The queue is the part of scheduling patients actually experience. Everything
// before it is arrangement; this is the hour they spend in a room wondering
// whether they have been forgotten.

// checkIn puts a booked patient in the queue and returns the appointment.
func (h *schedHarness) checkIn(t *testing.T, appointmentID string,
	priority schedulingv1.Priority, reason string) *schedulingv1.Appointment {
	t.Helper()

	arrived, err := h.sched.CheckIn(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.CheckInRequest{
			AppointmentId:  appointmentID,
			ArrivalMode:    schedulingv1.ArrivalMode_ARRIVAL_MODE_SCHEDULED,
			Priority:       priority,
			PriorityReason: reason,
		}))
	if err != nil {
		t.Fatalf("CheckIn: %v", err)
	}
	return arrived.Msg.GetAppointment()
}

// SRS-SCH-007: "check-in with token/queue number and arrival mode".
func TestCheckingInIssuesAQueueNumber(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, _ := h.bookFirstSlot(t, day, patient)
	if appointment.GetToken() != "" {
		t.Fatal("a booking carries a queue token before the patient has arrived")
	}

	arrived := h.checkIn(t, appointment.GetAppointmentId(),
		schedulingv1.Priority_PRIORITY_STANDARD, "")

	if arrived.GetStatus() != schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_ARRIVED {
		t.Fatalf("status = %v, want arrived", arrived.GetStatus())
	}
	if arrived.GetToken() == "" {
		t.Fatal("no token was issued, so nobody can be called across the waiting room")
	}
	if arrived.GetArrivalMode() != schedulingv1.ArrivalMode_ARRIVAL_MODE_SCHEDULED {
		t.Fatalf("arrival mode = %v, want scheduled", arrived.GetArrivalMode())
	}
	if arrived.GetCheckedInAt() == nil {
		t.Fatal("no arrival time was recorded")
	}
}

// Two patients holding "014" in the same waiting room is a call nobody can
// answer.
func TestQueueNumbersAreUniquePerFacilityPerDay(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 4)

	slots := h.searchSlots(t, h.clerkToken(), day)
	if len(slots) < 2 {
		t.Fatal("not enough slots to queue two patients")
	}

	seen := map[string]bool{}
	for i, name := range []string{"Iyer", "Nair"} {
		patient := h.registerPatient(t, name, "Meera", "987654321"+string(rune('0'+i)))
		booked, err := h.sched.BookAppointment(context.Background(),
			withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
				PatientId: patient, ResourceId: h.resource,
				StartsAt:  slots[i].GetStartsAt(),
				VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
				Reason:    "review",
			}))
		if err != nil {
			t.Fatalf("BookAppointment: %v", err)
		}

		token := h.checkIn(t, booked.Msg.GetAppointment().GetAppointmentId(),
			schedulingv1.Priority_PRIORITY_STANDARD, "").GetToken()
		if seen[token] {
			t.Fatalf("token %q was issued twice in one waiting room", token)
		}
		seen[token] = true
	}
}

// SRS-SCH-008: the nine queue states, with invalid transitions refused.
func TestTheQueueStateMachineRefusesAnImpossibleJump(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, _ := h.bookFirstSlot(t, day, patient)
	h.checkIn(t, appointment.GetAppointmentId(),
		schedulingv1.Priority_PRIORITY_STANDARD, "")

	// Arrived to completed skips the consultation entirely. Somebody marking
	// this has clicked the wrong row.
	_, err := h.sched.AdvanceAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.AdvanceAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(),
			To:            schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_COMPLETED,
		}))
	if err == nil {
		t.Fatal("an appointment went straight from arrived to completed")
	}
	if !strings.Contains(err.Error(), "cannot go from arrived to completed") {
		t.Fatalf("the refusal does not say what was refused: %v", err)
	}
}

// SRS-SCH-008's "unless authorized correction" clause. A state machine with no
// escape hatch gets worked around, and the workaround — cancelling the real
// appointment and booking a new one — destroys the chronology the record
// exists to keep.
func TestACorrectionNeedsItsOwnPermissionAndAReason(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, _ := h.bookFirstSlot(t, day, patient)
	h.checkIn(t, appointment.GetAppointmentId(),
		schedulingv1.Priority_PRIORITY_STANDARD, "")

	correct := func(token string) error {
		_, err := h.sched.AdvanceAppointment(context.Background(),
			withFacility(token, h.facility, &schedulingv1.AdvanceAppointmentRequest{
				AppointmentId: appointment.GetAppointmentId(),
				To:            schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_COMPLETED,
				Reason:        "recorded against the wrong patient this morning",
				Correction:    true,
			}))
		return err
	}

	// A clerk works the queue but does not rewrite yesterday's attendance
	// record.
	if err := correct(h.clerkToken()); err == nil {
		t.Fatal("a registration clerk made an authorised correction")
	} else if !strings.Contains(err.Error(), "correction permission") {
		t.Fatalf("the refusal does not name the missing permission: %v", err)
	}

	if err := correct(h.clinicianToken()); err != nil {
		t.Fatalf("a clinician could not make an authorised correction: %v", err)
	}

	after, err := h.sched.GetAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("GetAppointment: %v", err)
	}

	history := after.Msg.GetAppointment().GetHistory()
	last := history[len(history)-1]
	if !last.GetCorrected() {
		t.Fatal("the correction is not marked as one, so it reads as an ordinary transition")
	}
	if last.GetReason() == "" {
		t.Fatal("a correction with no reason is indistinguishable from the mistake it corrects")
	}
}

// SRS-SCH-009: "estimated wait time ... updates without changing clinical
// priority".
//
// The order is priority first, then arrival. The estimate never reorders
// anything: a queue that rearranged itself to make its own predictions come
// true would be optimising the wrong thing.
func TestTheQueueIsOrderedByPriorityThenArrival(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 4)
	slots := h.searchSlots(t, h.clerkToken(), day)
	if len(slots) < 3 {
		t.Fatal("not enough slots for three patients")
	}

	type arrival struct {
		name     string
		priority schedulingv1.Priority
		reason   string
	}
	arrivals := []arrival{
		{"Iyer", schedulingv1.Priority_PRIORITY_STANDARD, ""},
		{"Nair", schedulingv1.Priority_PRIORITY_STANDARD, ""},
		{"Rao", schedulingv1.Priority_PRIORITY_VERY_URGENT, "chest pain on arrival"},
	}

	tokens := make([]string, 0, len(arrivals))
	for i, a := range arrivals {
		patient := h.registerPatient(t, a.name, "Meera", "987654321"+string(rune('0'+i)))
		booked, err := h.sched.BookAppointment(context.Background(),
			withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
				PatientId: patient, ResourceId: h.resource,
				StartsAt:  slots[i].GetStartsAt(),
				VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
				Reason:    "review",
			}))
		if err != nil {
			t.Fatalf("BookAppointment: %v", err)
		}
		arrived := h.checkIn(t, booked.Msg.GetAppointment().GetAppointmentId(),
			a.priority, a.reason)
		tokens = append(tokens, arrived.GetToken())
	}

	queue, err := h.sched.GetQueue(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetQueueRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetQueue: %v", err)
	}

	positions := queue.Msg.GetPositions()
	if len(positions) != 3 {
		t.Fatalf("%d patients in the queue, want 3", len(positions))
	}

	// The very urgent patient arrived last and is called first.
	if positions[0].GetAppointment().GetToken() != tokens[2] {
		t.Fatalf("the queue is led by %q, want the very urgent patient %q",
			positions[0].GetAppointment().GetToken(), tokens[2])
	}
	// The two standard patients keep their arrival order behind them.
	if positions[1].GetAppointment().GetToken() != tokens[0] ||
		positions[2].GetAppointment().GetToken() != tokens[1] {
		t.Fatal("two patients of equal priority were not kept in arrival order")
	}

	// The person at the front waits for nobody; everybody behind waits longer
	// than the person in front of them.
	if positions[0].GetEstimatedWaitSeconds() != 0 {
		t.Fatalf("the patient at the front of the queue has a wait of %ds",
			positions[0].GetEstimatedWaitSeconds())
	}
	if positions[2].GetEstimatedWaitSeconds() <= positions[1].GetEstimatedWaitSeconds() {
		t.Fatal("the estimated wait does not grow down the queue")
	}

	// The arithmetic travels with the estimate, so a display can say *why*.
	estimate := queue.Msg.GetEstimate()
	if estimate.GetServiceMinutes() <= 0 {
		t.Fatal("the estimate has no service rate behind it")
	}
	if estimate.GetObserved() {
		t.Fatal("the estimate claims to be observed before any consultation has finished")
	}
	if estimate.GetActiveClinicians() < 1 {
		t.Fatal("the estimate divides the queue between no clinicians")
	}
}

// SRS-SCH-010: "walk-in registration ... linked to same encounter creation
// flow".
func TestAWalkInBecomesAnOrdinaryAppointment(t *testing.T) {
	h := newSchedHarness(t)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	walkIn, err := h.sched.RegisterWalkIn(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.RegisterWalkInRequest{
			PatientId: patient, ResourceId: h.resource,
			Reason: "persistent cough",
		}))
	if err != nil {
		t.Fatalf("RegisterWalkIn: %v", err)
	}

	appointment := walkIn.Msg.GetAppointment()
	if appointment.GetStatus() != schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_ARRIVED {
		t.Fatalf("status = %v, want arrived — a walk-in is here, not booked",
			appointment.GetStatus())
	}
	if appointment.GetVisitType() != schedulingv1.VisitType_VISIT_TYPE_WALK_IN {
		t.Fatalf("visit type = %v, want walk-in", appointment.GetVisitType())
	}
	if appointment.GetToken() == "" {
		t.Fatal("a walk-in was registered with no token, so nobody can call them")
	}

	// The same record every other context reads. A parallel lightweight record
	// would be a second thing downstream has to know about, and the first one
	// to forget would drop walk-ins from a report.
	read, err := h.sched.GetAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("a walk-in cannot be read back as an appointment: %v", err)
	}
	if read.Msg.GetAppointment().GetPatientId() != patient {
		t.Fatal("the walk-in is filed against the wrong patient")
	}

	// It appears in the same queue as everybody else.
	queue, err := h.sched.GetQueue(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetQueueRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetQueue: %v", err)
	}
	if len(queue.Msg.GetPositions()) != 1 {
		t.Fatalf("%d patients in the queue, want the walk-in",
			len(queue.Msg.GetPositions()))
	}
}

// A walk-in holds no rostered capacity: nobody set time aside. Consuming a
// slot somebody else booked would turn an unscheduled arrival into a cancelled
// appointment for a patient who did nothing wrong.
func TestAWalkInDoesNotConsumeARosteredSlot(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	before := h.searchSlots(t, h.clerkToken(), day)

	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")
	if _, err := h.sched.RegisterWalkIn(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.RegisterWalkInRequest{
			PatientId: patient, ResourceId: h.resource, Reason: "persistent cough",
		})); err != nil {
		t.Fatalf("RegisterWalkIn: %v", err)
	}

	after := h.searchSlots(t, h.clerkToken(), day)
	if len(after) != len(before) {
		t.Fatalf("a walk-in consumed %d rostered slots", len(before)-len(after))
	}
}

// SRS-SCH-010 asks for a reason. Without one nobody triaging the queue knows
// why this person is here, which is the first thing they need.
func TestAWalkInNeedsAStatedReason(t *testing.T) {
	h := newSchedHarness(t)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	_, err := h.sched.RegisterWalkIn(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.RegisterWalkInRequest{
			PatientId: patient, ResourceId: h.resource,
		}))
	if err == nil {
		t.Fatal("a walk-in was registered with no stated reason")
	}
	if !strings.Contains(err.Error(), "reason") {
		t.Fatalf("the refusal does not say what is missing: %v", err)
	}
}

// SRS-SCH-011: "reprioritisation ... requires medical reason, audited and
// visible to queue users".
//
// The second half is the one that matters at the desk: the people waiting can
// see that somebody went ahead of them, and a board that shows the move without
// the reason produces the argument the reason exists to prevent.
func TestReprioritisingNeedsAReasonAndShowsItOnTheBoard(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 2)
	slots := h.searchSlots(t, h.clerkToken(), day)

	ids := make([]string, 0, 2)
	for i, name := range []string{"Iyer", "Nair"} {
		patient := h.registerPatient(t, name, "Meera", "987654321"+string(rune('0'+i)))
		booked, err := h.sched.BookAppointment(context.Background(),
			withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
				PatientId: patient, ResourceId: h.resource,
				StartsAt:  slots[i].GetStartsAt(),
				VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
				Reason:    "review",
			}))
		if err != nil {
			t.Fatalf("BookAppointment: %v", err)
		}
		id := booked.Msg.GetAppointment().GetAppointmentId()
		h.checkIn(t, id, schedulingv1.Priority_PRIORITY_STANDARD, "")
		ids = append(ids, id)
	}

	// No reason, no move.
	if _, err := h.sched.Reprioritise(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &schedulingv1.ReprioritiseRequest{
			AppointmentId: ids[1],
			Priority:      schedulingv1.Priority_PRIORITY_IMMEDIATE,
		})); err == nil {
		t.Fatal("a patient was moved to the front of the queue with no stated reason")
	}

	const reason = "deteriorating, needs to be seen now"
	moved, err := h.sched.Reprioritise(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &schedulingv1.ReprioritiseRequest{
			AppointmentId: ids[1],
			Priority:      schedulingv1.Priority_PRIORITY_IMMEDIATE,
			Reason:        reason,
		}))
	if err != nil {
		t.Fatalf("Reprioritise: %v", err)
	}
	if moved.Msg.GetAppointment().GetPriorityReason() != reason {
		t.Fatal("the stated reason was not kept on the appointment")
	}

	queue, err := h.sched.GetQueue(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetQueueRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetQueue: %v", err)
	}
	front := queue.Msg.GetPositions()[0].GetAppointment()
	if front.GetAppointmentId() != ids[1] {
		t.Fatal("the reprioritised patient is not at the front of the queue")
	}
	// Visible to queue users, not buried in an audit table.
	if front.GetPriorityReason() != reason {
		t.Fatalf("the board shows the move without the reason: %q",
			front.GetPriorityReason())
	}

	// And audited, so the move can be traced to whoever made it.
	var actor string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT actor_id FROM platform_data.audit_record
		 WHERE resource_id = $1 AND reason LIKE 'priority %'`,
		ids[1]).Scan(&actor); err != nil {
		t.Fatalf("the reprioritisation was not audited: %v", err)
	}
	if actor != "doctor-1" {
		t.Fatalf("the audit names %q as the actor, want the clinician who moved them", actor)
	}
}

// Nobody is in the queue until they have arrived. Reprioritising a future
// booking is rearranging a diary, which is a reschedule.
func TestAPatientWhoHasNotArrivedCannotBeReprioritised(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")
	appointment, _ := h.bookFirstSlot(t, day, patient)

	_, err := h.sched.Reprioritise(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &schedulingv1.ReprioritiseRequest{
			AppointmentId: appointment.GetAppointmentId(),
			Priority:      schedulingv1.Priority_PRIORITY_URGENT,
			Reason:        "deteriorating",
		}))
	if err == nil {
		t.Fatal("a patient who has not arrived was given a place in the queue")
	}
	if !strings.Contains(err.Error(), "not checked in") {
		t.Fatalf("the refusal does not say why: %v", err)
	}
}

// SRS-SCH-012: "notification delivery outcome recorded".
//
// The criterion is the whole point. A hospital that sends reminders and does
// not know which ones arrived cannot tell a patient who says they were never
// told from one who was.
func TestBookingRecordsAConfirmationAndAReminder(t *testing.T) {
	h := newSchedHarness(t)
	// At least two days out, so the policy's 24-hour reminder lead lands in the
	// future: a reminder due before now is correctly not scheduled, and a test
	// that booked for tomorrow would be asserting the opposite of the rule.
	day := h.defineClinicIn(t, time.Tuesday, 15, 1, 2)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	// The patient agreed to hear about appointments by SMS.
	if _, err := h.patients.RecordCommunicationPreference(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RecordCommunicationPreferenceRequest{
			PatientId: patient,
			Channel:   empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_SMS,
			Purpose:   empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER,
			Allowed:   true,
		})); err != nil {
		t.Fatalf("RecordCommunicationPreference: %v", err)
	}

	appointment, _ := h.bookFirstSlot(t, day, patient)

	listed, err := h.sched.ListNotifications(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.ListNotificationsRequest{
			AppointmentId: appointment.GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("ListNotifications: %v", err)
	}

	byKind := map[schedulingv1.NotificationKind]*schedulingv1.Notification{}
	for _, n := range listed.Msg.GetNotifications() {
		byKind[n.GetKind()] = n
	}

	confirmation := byKind[schedulingv1.NotificationKind_NOTIFICATION_KIND_BOOKED]
	if confirmation == nil {
		t.Fatal("no booking confirmation was recorded")
	}
	if confirmation.GetChannel() != "sms" {
		t.Fatalf("the confirmation went by %q, want the channel the patient agreed to",
			confirmation.GetChannel())
	}
	if confirmation.GetOutcome() !=
		schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_PENDING {
		t.Fatalf("outcome = %v on creation, want pending", confirmation.GetOutcome())
	}

	reminder := byKind[schedulingv1.NotificationKind_NOTIFICATION_KIND_REMINDER]
	if reminder == nil {
		t.Fatal("no reminder was scheduled")
	}
	if reminder.GetSendAfter() == nil {
		t.Fatal("the reminder has no due time, so nothing knows when to send it")
	}
	due := reminder.GetSendAfter().AsTime()
	if want := appointment.GetStartsAt().AsTime().Add(-24 * time.Hour); !due.Equal(want) {
		t.Fatalf("the reminder is due at %v, want 24 hours before the appointment", due)
	}

	// The outcome comes back from the channel and is recorded against the
	// message somebody can later point at.
	resolved, err := h.sched.RecordDeliveryOutcome(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.RecordDeliveryOutcomeRequest{
			NotificationId: confirmation.GetNotificationId(),
			Outcome:        schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_DELIVERED,
		}))
	if err != nil {
		t.Fatalf("RecordDeliveryOutcome: %v", err)
	}
	if resolved.Msg.GetNotification().GetOutcome() !=
		schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_DELIVERED {
		t.Fatal("the delivery outcome was not recorded")
	}

	// A late callback for a message already resolved must not overwrite the
	// outcome somebody has already read.
	if _, err := h.sched.RecordDeliveryOutcome(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.RecordDeliveryOutcomeRequest{
			NotificationId: confirmation.GetNotificationId(),
			Outcome:        schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_FAILED,
			Detail:         "gateway timeout",
		})); err == nil {
		t.Fatal("a resolved message was overwritten by a late callback")
	}
}

// "We did not tell them, and here is why" is an answer a desk can give;
// silence is not. A patient who was never contacted must not look identical to
// one the gateway dropped (SRS-EMPI-013).
func TestAPatientWhoAgreedToNothingHasTheirMessagesSuppressedVisibly(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, _ := h.bookFirstSlot(t, day, patient)

	listed, err := h.sched.ListNotifications(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.ListNotificationsRequest{
			AppointmentId: appointment.GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("ListNotifications: %v", err)
	}
	if len(listed.Msg.GetNotifications()) == 0 {
		t.Fatal("nothing was recorded, so nobody can tell an unasked patient from a bug")
	}

	for _, n := range listed.Msg.GetNotifications() {
		if n.GetOutcome() != schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_SUPPRESSED {
			t.Fatalf("a %v message was sent to a patient who agreed to no channel",
				n.GetKind())
		}
		if n.GetDetail() == "" {
			t.Fatal("a suppression with no reason cannot be told from a bug")
		}
	}
}

// A facility that has turned a message off sends nothing and records nothing:
// there is no outcome to report for a message nobody decided to send.
func TestAFacilityThatSendsNothingRecordsNothing(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	if _, err := h.sched.SetSchedulingPolicy(context.Background(),
		as(tenantAdminToken(h.tenantID), &schedulingv1.SetSchedulingPolicyRequest{
			FacilityId: h.facility,
			Policy: &schedulingv1.SchedulingPolicy{
				NoticeHours: 24, RescheduleNoticeHours: 4,
				// No notification kinds at all: a clinic whose patients have no
				// phones sends nothing rather than accumulating failures.
			},
		})); err != nil {
		t.Fatalf("SetSchedulingPolicy: %v", err)
	}

	appointment, _ := h.bookFirstSlot(t, day, patient)

	listed, err := h.sched.ListNotifications(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.ListNotificationsRequest{
			AppointmentId: appointment.GetAppointmentId(),
		}))
	if err != nil {
		t.Fatalf("ListNotifications: %v", err)
	}
	if len(listed.Msg.GetNotifications()) != 0 {
		t.Fatalf("%d messages were recorded for a facility that sends none",
			len(listed.Msg.GetNotifications()))
	}
}

// SRS-SCH-016: check-in is one of the five named events. A queue display that
// had to poll would be a queue display that is wrong.
func TestCheckingInEmitsAnEvent(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Venkataraghavan", "Meera", "9876543210")

	appointment, _ := h.bookFirstSlot(t, day, patient)
	arrived := h.checkIn(t, appointment.GetAppointmentId(),
		schedulingv1.Priority_PRIORITY_STANDARD, "")

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'appointment.checked_in'`,
		appointment.GetAppointmentId()).Scan(&payload); err != nil {
		t.Fatalf("no appointment.checked_in event was written: %v", err)
	}

	if !strings.Contains(payload, arrived.GetToken()) {
		t.Fatalf("the event does not carry the token, so a board must poll for it: %s",
			payload)
	}
	// Identifiers and times, never the patient's name or stated reason.
	if strings.Contains(payload, "Venkataraghavan") {
		t.Fatalf("the event carries demographic detail: %s", payload)
	}
}

// A no-show keeps its slot: the capacity was consumed, the patient simply did
// not come. Releasing it would let the clinic double-book a morning it has
// already spent.
func TestANoShowDoesNotGiveTheSlotBack(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	appointment, slot := h.bookFirstSlot(t, day, patient)

	if _, err := h.sched.AdvanceAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.AdvanceAppointmentRequest{
			AppointmentId: appointment.GetAppointmentId(),
			To:            schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_NO_SHOW,
			Reason:        "did not attend",
		})); err != nil {
		t.Fatalf("AdvanceAppointment: %v", err)
	}

	for _, s := range h.searchSlots(t, h.clerkToken(), day) {
		if s.GetStartsAt().AsTime().Equal(slot.GetStartsAt().AsTime()) {
			t.Fatal("a no-show released its slot, so the clinic can double-book a " +
				"morning it has already spent")
		}
	}
}

// A queue cannot be read across a tenant boundary.
func TestAQueueCannotBeReachedFromAnotherTenant(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")
	appointment, _ := h.bookFirstSlot(t, day, patient)
	h.checkIn(t, appointment.GetAppointmentId(),
		schedulingv1.Priority_PRIORITY_STANDARD, "")

	other := newSchedHarness(t)
	queue, err := other.sched.GetQueue(context.Background(),
		withFacility(other.clerkToken(), other.facility,
			&schedulingv1.GetQueueRequest{FacilityId: h.facility}))
	if err != nil {
		// A refusal is the right answer too; an empty queue is the other.
		return
	}
	if len(queue.Msg.GetPositions()) != 0 {
		t.Fatal("another tenant's waiting room is visible")
	}
}

// The estimate is observed from consultations that actually finished, not from
// the roster: a clinic running twenty minutes behind is running twenty minutes
// behind whatever the diary says.
func TestTheWaitEstimateIsObservedOnceEnoughConsultationsHaveFinished(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 4)
	slots := h.searchSlots(t, h.clerkToken(), day)
	if len(slots) < 4 {
		t.Fatal("not enough slots")
	}

	advance := func(id string, to schedulingv1.AppointmentStatus) {
		t.Helper()
		if _, err := h.sched.AdvanceAppointment(context.Background(),
			withFacility(h.clerkToken(), h.facility,
				&schedulingv1.AdvanceAppointmentRequest{AppointmentId: id, To: to})); err != nil {
			t.Fatalf("AdvanceAppointment to %v: %v", to, err)
		}
	}

	// Three finished consultations is the threshold: one is an anecdote and
	// two is a coincidence.
	for i := 0; i < 3; i++ {
		patient := h.registerPatient(t, "Iyer", "Meera", "987654321"+string(rune('0'+i)))
		booked, err := h.sched.BookAppointment(context.Background(),
			withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
				PatientId: patient, ResourceId: h.resource,
				StartsAt:  slots[i].GetStartsAt(),
				VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
				Reason:    "review",
			}))
		if err != nil {
			t.Fatalf("BookAppointment: %v", err)
		}
		id := booked.Msg.GetAppointment().GetAppointmentId()
		h.checkIn(t, id, schedulingv1.Priority_PRIORITY_STANDARD, "")
		advance(id, schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_WAITING_CLINICIAN)
		advance(id, schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_IN_CONSULTATION)
		advance(id, schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_COMPLETED)
	}

	// One patient still waiting, so the queue has somebody to estimate for.
	waiting := h.registerPatient(t, "Nair", "Meera", "9876543219")
	booked, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: waiting, ResourceId: h.resource,
			StartsAt:  slots[3].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Reason:    "review",
		}))
	if err != nil {
		t.Fatalf("BookAppointment: %v", err)
	}
	h.checkIn(t, booked.Msg.GetAppointment().GetAppointmentId(),
		schedulingv1.Priority_PRIORITY_STANDARD, "")

	// The default window is today, which is when everybody checked in — the
	// clinic day is the rostered Tuesday, but the queue is the room now.
	queue, err := h.sched.GetQueue(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.GetQueueRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetQueue: %v", err)
	}
	if !queue.Msg.GetEstimate().GetObserved() {
		t.Fatal("the estimate still comes from the roster after three consultations " +
			"have finished")
	}
}
