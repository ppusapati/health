package domain

import (
	"fmt"
	"strings"
	"time"
)

// Notifications (SRS-SCH-012).
//
// The requirement is "configurable booking/reminder/reschedule/cancellation
// notifications" with the criterion "notification delivery outcome recorded".
// That criterion is the whole point: a hospital that sends reminders and does
// not know which ones arrived cannot tell a patient who says they were never
// told from one who was. Both conversations happen weekly, and only the record
// distinguishes them.
//
// What this context does NOT do is send anything. Channels, templates,
// retries, opt-outs and quiet hours belong to a notification service (SRS-NTF);
// scheduling decides that something notifiable happened, checks the patient
// agreed to hear about it, and records what came back.

// NotificationKind is what a message is about.
type NotificationKind string

const (
	NotifyBooked      NotificationKind = "booked"
	NotifyReminder    NotificationKind = "reminder"
	NotifyRescheduled NotificationKind = "rescheduled"
	NotifyCancelled   NotificationKind = "cancelled"
	// NotifyWaitlistOffer is the one with a deadline attached, which makes its
	// delivery outcome the one that matters most: an offer nobody received
	// expires against a patient who never had the chance to answer.
	NotifyWaitlistOffer NotificationKind = "waitlist_offer"
)

var knownNotificationKinds = map[NotificationKind]bool{
	NotifyBooked: true, NotifyReminder: true, NotifyRescheduled: true,
	NotifyCancelled: true, NotifyWaitlistOffer: true,
}

// DeliveryOutcome is what happened to a message.
type DeliveryOutcome string

const (
	// DeliveryPending has been handed to the notification service and not yet
	// resolved.
	DeliveryPending DeliveryOutcome = "pending"
	DeliverySent    DeliveryOutcome = "sent"
	// DeliveryDelivered is confirmation from the channel, where the channel
	// offers one. Distinct from sent because "we posted it" and "it arrived"
	// are different claims, and only one of them answers a patient who says
	// they never heard.
	DeliveryDelivered DeliveryOutcome = "delivered"
	DeliveryFailed    DeliveryOutcome = "failed"
	// DeliverySuppressed means the patient had not agreed to be contacted this
	// way. Recorded rather than silently skipped: "we did not tell them, and
	// here is why" is an answer; silence is not.
	DeliverySuppressed DeliveryOutcome = "suppressed"
)

var knownDeliveryOutcomes = map[DeliveryOutcome]bool{
	DeliveryPending: true, DeliverySent: true, DeliveryDelivered: true,
	DeliveryFailed: true, DeliverySuppressed: true,
}

// NotificationPolicy is which messages a facility sends (SRS-SCH-012).
type NotificationPolicy struct {
	// Enabled lists the kinds this facility sends. Empty means none, which is
	// a real configuration: a clinic whose patients have no phones sends
	// nothing rather than accumulating failures.
	Enabled map[NotificationKind]bool
	// ReminderHoursBefore is when a reminder goes out. Zero disables reminders
	// even if the kind is enabled, because "remind them at the appointment
	// time" is not a reminder.
	ReminderHoursBefore int
}

// DefaultNotificationPolicy sends booking, reschedule and cancellation
// confirmations and a reminder the day before.
//
// On by default, unlike teleconsults, because the failure modes point opposite
// ways: a teleconsult nobody decided to offer is a clinical risk, while a
// confirmation nobody decided to send is a patient who does not know when to
// come. The patient's own communication preference still governs — a facility
// policy turns a channel on, and SRS-EMPI-013's per-purpose consent decides
// whether this patient hears about it.
func DefaultNotificationPolicy() NotificationPolicy {
	return NotificationPolicy{
		Enabled: map[NotificationKind]bool{
			NotifyBooked: true, NotifyRescheduled: true,
			NotifyCancelled: true, NotifyReminder: true,
			NotifyWaitlistOffer: true,
		},
		ReminderHoursBefore: 24,
	}
}

// Sends reports whether this facility sends a kind of message.
func (p NotificationPolicy) Sends(kind NotificationKind) bool {
	if !knownNotificationKinds[kind] {
		return false
	}
	if kind == NotifyReminder && p.ReminderHoursBefore <= 0 {
		return false
	}
	return p.Enabled[kind]
}

// Notification is one message about one appointment.
type Notification struct {
	ID       string
	TenantID string
	// AppointmentID or WaitlistID, never both. A waitlist offer is about an
	// offer rather than about a booking — there is no appointment yet, and that
	// message's delivery outcome is the one that matters most: an offer nobody
	// received expires against a patient who never had the chance to answer.
	AppointmentID string
	WaitlistID    string
	PatientID     string
	Kind          NotificationKind
	// Channel is how it was sent — "sms", "email". A string rather than an
	// enum because the set is the notification service's to know, and an
	// enumeration here would need changing every time that service gains one.
	Channel string
	Outcome DeliveryOutcome
	// Detail explains a failure or a suppression in a sentence somebody at a
	// desk can act on.
	Detail string
	// SendAfter is when the message becomes due. Set for a reminder; zero for
	// anything that goes immediately.
	SendAfter time.Time
	CreatedAt time.Time
	UpdatedAt time.Time
}

// NotificationSubject is what a message is about.
//
// Exactly one of the two is set. A message about neither could not be traced
// back to the patient it concerns; one about both would be two messages.
type NotificationSubject struct {
	AppointmentID string
	WaitlistID    string
}

// ForAppointment names a booking as a message's subject.
func ForAppointment(appointmentID string) NotificationSubject {
	return NotificationSubject{AppointmentID: appointmentID}
}

// ForWaitlistEntry names a waiting-list offer as a message's subject.
func ForWaitlistEntry(waitlistID string) NotificationSubject {
	return NotificationSubject{WaitlistID: waitlistID}
}

// NewNotification validates and constructs a message record.
func NewNotification(id, tenantID string, subject NotificationSubject, patientID string,
	kind NotificationKind, channel string, sendAfter time.Time, now time.Time) (
	Notification, error) {

	hasAppointment := strings.TrimSpace(subject.AppointmentID) != ""
	hasWaitlist := strings.TrimSpace(subject.WaitlistID) != ""

	switch {
	case strings.TrimSpace(id) == "":
		return Notification{}, fmt.Errorf("%w: notification id is required", ErrInvalidAppointment)
	case hasAppointment == hasWaitlist:
		return Notification{}, fmt.Errorf(
			"%w: a notification is about exactly one appointment or one waiting-list offer",
			ErrInvalidAppointment)
	case strings.TrimSpace(patientID) == "":
		return Notification{}, fmt.Errorf("%w: a notification needs a recipient",
			ErrInvalidAppointment)
	case !knownNotificationKinds[kind]:
		return Notification{}, fmt.Errorf("%w: unknown notification kind %q",
			ErrInvalidAppointment, kind)
	case strings.TrimSpace(channel) == "":
		return Notification{}, fmt.Errorf("%w: a notification needs a channel",
			ErrInvalidAppointment)
	}

	return Notification{
		ID: id, TenantID: tenantID,
		AppointmentID: strings.TrimSpace(subject.AppointmentID),
		WaitlistID:    strings.TrimSpace(subject.WaitlistID),
		PatientID:     patientID, Kind: kind, Channel: channel,
		Outcome: DeliveryPending, SendAfter: sendAfter.UTC(),
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// Resolve records what the channel reported back.
func (n *Notification) Resolve(outcome DeliveryOutcome, detail string, now time.Time) error {
	if !knownDeliveryOutcomes[outcome] {
		return fmt.Errorf("%w: unknown delivery outcome %q", ErrInvalidAppointment, outcome)
	}
	if outcome == DeliveryPending {
		return fmt.Errorf("%w: pending is not an outcome", ErrInvalidAppointment)
	}
	if (outcome == DeliveryFailed || outcome == DeliverySuppressed) &&
		strings.TrimSpace(detail) == "" {
		// "Failed" with no reason tells a desk nothing they can act on, and
		// "suppressed" with no reason cannot be distinguished from a bug.
		return fmt.Errorf("%w: a %s outcome needs a reason", ErrInvalidAppointment, outcome)
	}

	n.Outcome = outcome
	n.Detail = strings.TrimSpace(detail)
	n.UpdatedAt = now.UTC()
	return nil
}

// Delivered reports a message that reached the patient, as far as the channel
// can tell.
func (n Notification) Delivered() bool {
	return n.Outcome == DeliverySent || n.Outcome == DeliveryDelivered
}

// ReminderDue reports when a reminder for an appointment should go out.
//
// Zero when no reminder is due — either the policy sends none, or the
// appointment is so soon that the reminder would arrive after it. Sending a
// "your appointment is tomorrow" message an hour beforehand is worse than
// sending nothing: it reads as a different appointment.
func (p NotificationPolicy) ReminderDue(startsAt, now time.Time) (time.Time, bool) {
	if !p.Sends(NotifyReminder) {
		return time.Time{}, false
	}
	due := startsAt.Add(-time.Duration(p.ReminderHoursBefore) * time.Hour)
	if !due.After(now) {
		return time.Time{}, false
	}
	return due, true
}

// MaxReminderHours bounds how far ahead a reminder may be scheduled. Thirty
// days: beyond that the message arrives before the patient has made any of the
// arrangements it is reminding them about.
const MaxReminderHours = 720

// Validate rejects a notification policy that could not be applied.
func (p NotificationPolicy) Validate() error {
	for kind := range p.Enabled {
		if !knownNotificationKinds[kind] {
			return fmt.Errorf("%w: unknown notification kind %q", ErrInvalidSchedule, kind)
		}
	}
	if p.ReminderHoursBefore < 0 || p.ReminderHoursBefore > MaxReminderHours {
		return fmt.Errorf("%w: a reminder must be between 0 and %d hours before",
			ErrInvalidSchedule, MaxReminderHours)
	}
	return nil
}

// Kinds lists the enabled kinds in a stable order, for storage and display.
func (p NotificationPolicy) Kinds() []string {
	ordered := []NotificationKind{
		NotifyBooked, NotifyReminder, NotifyRescheduled,
		NotifyCancelled, NotifyWaitlistOffer,
	}
	out := make([]string, 0, len(ordered))
	for _, kind := range ordered {
		if p.Enabled[kind] {
			out = append(out, string(kind))
		}
	}
	return out
}

// NotificationPolicyFrom rebuilds a policy from stored kind names.
func NotificationPolicyFrom(kinds []string, reminderHoursBefore int) NotificationPolicy {
	enabled := make(map[NotificationKind]bool, len(kinds))
	for _, raw := range kinds {
		kind := NotificationKind(raw)
		if knownNotificationKinds[kind] {
			// An unrecognised stored kind is dropped rather than carried: a
			// name this version does not know is a name it cannot send, and
			// keeping it would let Sends answer true for something nothing
			// handles.
			enabled[kind] = true
		}
	}
	return NotificationPolicy{Enabled: enabled, ReminderHoursBefore: reminderHoursBefore}
}

// SchedulingPolicy is everything a facility has decided about scheduling.
//
// Carried together because they are stored together and read together: a
// caller that fetched the cancellation rule and the notification rule in two
// calls could act on one from before an edit and one from after it.
type SchedulingPolicy struct {
	Cancellation CancellationPolicy
	Teleconsult  TeleconsultPolicy
	Notification NotificationPolicy
}

// DefaultSchedulingPolicy is what a tenant that has configured nothing gets.
func DefaultSchedulingPolicy() SchedulingPolicy {
	return SchedulingPolicy{
		Cancellation: DefaultCancellationPolicy(),
		Teleconsult:  DefaultTeleconsultPolicy(),
		Notification: DefaultNotificationPolicy(),
	}
}

// Validate rejects a policy set that could not be applied.
func (p SchedulingPolicy) Validate() error {
	if err := p.Cancellation.Validate(); err != nil {
		return err
	}
	return p.Notification.Validate()
}
