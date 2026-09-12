package application

import (
	"context"
	"fmt"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
)

// Check-in, the queue, walk-ins and notifications
// (SRS-SCH-007 … SRS-SCH-012).

// CheckInInput records a patient's arrival.
type CheckInInput struct {
	AppointmentID string
	// Token is what the patient will be called by. Left empty the service
	// issues the next queue number for the facility today, which is what most
	// desks want; a clinic running its own numbering scheme supplies its own.
	Token       string
	ArrivalMode domain.ArrivalMode
	// Priority at the door. Empty means standard.
	Priority       domain.Priority
	PriorityReason string
}

// CheckIn records arrival and puts the patient in the queue (SRS-SCH-007).
func (s *Service) CheckIn(ctx context.Context, in CheckInInput) (*domain.Appointment, error) {
	session, scope, err := s.authorizeQueue(ctx, in.AppointmentID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	priority := in.Priority
	if priority == "" {
		priority = domain.PriorityStandard
	}
	arrival := in.ArrivalMode
	if arrival == "" {
		arrival = domain.ArrivalScheduled
	}

	var out *domain.Appointment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		appointment, err := s.appointments.Get(ctx, scope, in.AppointmentID)
		if err != nil {
			return err
		}

		token, err := s.issueToken(ctx, scope, appointment.FacilityID, in.Token, now)
		if err != nil {
			return err
		}

		before := appointment.Version
		if err := appointment.CheckIn(domain.CheckIn{
			Token: token, ArrivalMode: arrival, At: now,
			By: session.SubjectID, Priority: priority,
			PriorityReason: in.PriorityReason,
		}, now); err != nil {
			return scheduleError(err)
		}

		change := appointment.History[len(appointment.History)-1]
		if err := s.queue.SetCheckIn(ctx, scope, appointment, change, before); err != nil {
			return err
		}

		if err := s.emitAppointmentEvent(ctx, session, EventAppointmentCheckedIn,
			appointment, now, map[string]any{
				// The token so a board can render without a second call, and
				// the priority because a display that had to poll for it would
				// show the old order after a reprioritisation.
				"token":        appointment.Token,
				"arrival_mode": string(appointment.ArrivalMode),
				"priority":     string(appointment.Priority),
			}); err != nil {
			return err
		}

		out = appointment
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentManage,
			ResourceType: "appointment", ResourceID: appointment.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  "checked in as " + appointment.Token,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// issueToken returns the token a patient is called by.
//
// Supplied tokens are taken as given: a clinic with its own numbering scheme
// (a letter per consulting room, say) knows more about its waiting room than
// this service does. Everything else gets the next number for the facility
// today, from a counter advanced under a row lock — two clerks checking
// patients in at the same instant must not both be handed 014.
func (s *Service) issueToken(ctx context.Context, scope authctx.TenantScope,
	facilityID, supplied string, now time.Time) (string, error) {

	if supplied != "" {
		return supplied, nil
	}
	// The facility's own date. A queue number is a within-session convenience,
	// and the counter resets when the clinic's day does.
	day := now.UTC().Truncate(24 * time.Hour)
	number, err := s.queue.NextQueueNumber(ctx, scope, facilityID, day, now)
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("%03d", number), nil
}

// AdvanceAppointmentInput moves an appointment through the queue.
type AdvanceAppointmentInput struct {
	AppointmentID string
	To            domain.Status
	Reason        string
	// Correction makes a transition the machine would otherwise refuse, under
	// the "unless authorized correction" clause of SRS-SCH-008. It needs its
	// own permission: a clerk who can work the queue should not be able to
	// rewrite yesterday's attendance record.
	Correction bool
}

// AdvanceAppointment drives the queue states (SRS-SCH-008).
func (s *Service) AdvanceAppointment(ctx context.Context, in AdvanceAppointmentInput) (
	*domain.Appointment, error) {

	session, scope, err := s.authorizeQueue(ctx, in.AppointmentID)
	if err != nil {
		return nil, err
	}

	if in.Correction && !session.HasPermission(PermAppointmentCorrect) {
		// The escape hatch exists so nobody works around the state machine by
		// cancelling a real appointment and booking a new one — which destroys
		// the chronology the record exists to keep. It is still an authority of
		// its own.
		return nil, rpcerr.PermissionDenied("SCH_CORRECT_DENIED",
			"a corrected status change needs the correction permission")
	}

	now := s.clock.Now()

	var out *domain.Appointment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		appointment, err := s.appointments.Get(ctx, scope, in.AppointmentID)
		if err != nil {
			return err
		}

		before := appointment.Version
		wasStatus := appointment.Status
		if err := appointment.Transition(in.To, session.SubjectID, in.Reason,
			in.Correction, now); err != nil {
			return scheduleError(err)
		}
		if appointment.Status == wasStatus {
			// Idempotent: a double-tapped button on a busy desk is not an error
			// somebody has to interpret.
			out = appointment
			return nil
		}

		change := appointment.History[len(appointment.History)-1]
		if err := s.appointments.SetStatus(ctx, scope, appointment, change, before); err != nil {
			return err
		}

		// A no-show keeps its slot: the capacity was consumed, the patient
		// simply did not come. Releasing it would let the clinic double-book a
		// morning it has already spent.
		eventType := EventAppointmentStatusChanged
		if appointment.Status == domain.StatusNoShow {
			eventType = EventAppointmentNoShow
		}
		if err := s.emitAppointmentEvent(ctx, session, eventType, appointment, now,
			map[string]any{
				"from":      string(change.From),
				"to":        string(change.To),
				"corrected": change.Corrected,
			}); err != nil {
			return err
		}

		out = appointment
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentManage,
			ResourceType: "appointment", ResourceID: appointment.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason: fmt.Sprintf("%s to %s", change.From, change.To) +
				correctionNote(change),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

func correctionNote(c domain.StatusChange) string {
	if !c.Corrected {
		return ""
	}
	return " (correction: " + c.Reason + ")"
}

// ReprioritiseInput moves a patient's place in the queue.
type ReprioritiseInput struct {
	AppointmentID string
	Priority      domain.Priority
	// Reason is mandatory and is shown to queue users rather than buried in an
	// audit table (SRS-SCH-011).
	Reason string
}

// Reprioritise changes a waiting patient's clinical priority (SRS-SCH-011).
//
// Restricted to the queue permission rather than to booking: deciding that
// somebody must be seen sooner is a clinical judgement, and the record shows
// who made it.
func (s *Service) Reprioritise(ctx context.Context, in ReprioritiseInput) (
	*domain.Appointment, error) {

	session, scope, err := s.authorizeQueue(ctx, in.AppointmentID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var out *domain.Appointment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		appointment, err := s.appointments.Get(ctx, scope, in.AppointmentID)
		if err != nil {
			return err
		}

		before := appointment.Version
		was := appointment.Priority
		if err := appointment.Reprioritise(in.Priority, session.SubjectID,
			in.Reason, now); err != nil {
			return scheduleError(err)
		}

		if err := s.queue.SetPriority(ctx, scope, appointment, before); err != nil {
			return err
		}

		if err := s.emitAppointmentEvent(ctx, session, EventAppointmentReprioritised,
			appointment, now, map[string]any{
				"from_priority": string(was),
				"to_priority":   string(appointment.Priority),
				// The reason travels with the event because the board shows it:
				// a queue that reorders itself without saying why produces the
				// argument the reason exists to prevent.
				"priority_reason": appointment.PriorityReason,
			}); err != nil {
			return err
		}

		out = appointment
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentManage,
			ResourceType: "appointment", ResourceID: appointment.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  fmt.Sprintf("priority %s to %s: %s", was, in.Priority, in.Reason),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// GetQueueInput asks for a clinic's live queue.
type GetQueueInput struct {
	FacilityID string
	// ResourceID narrows to one clinician's queue. Empty means the facility's.
	ResourceID string
	// From and Until bound the session. Empty defaults to the current day in
	// UTC, which is the queue a board shows.
	From     time.Time
	Until    time.Time
	PageSize int32
}

// QueueView is a queue and the arithmetic behind its estimates.
type QueueView struct {
	Positions []domain.QueuePosition
	// Estimate is the service rate the waits were computed from, carried so a
	// display can say *why* — "about forty minutes, based on four ahead and ten
	// minutes each" is something a person can judge (SRS-SCH-009).
	Estimate domain.QueueEstimate
}

// GetQueue returns who is waiting, in the order they will be called, with an
// estimated wait for each (SRS-SCH-008, SRS-SCH-009).
func (s *Service) GetQueue(ctx context.Context, in GetQueueInput) (QueueView, error) {
	session, scope, err := s.authorizeRead(ctx, PermScheduleRead, "queue", in.FacilityID)
	if err != nil {
		return QueueView{}, err
	}
	if in.FacilityID == "" {
		return QueueView{}, rpcerr.Invalid("SCH_QUEUE_UNFILTERED",
			"a queue needs a facility")
	}

	now := s.clock.Now()
	from, until := in.From, in.Until
	if from.IsZero() || until.IsZero() {
		from = now.UTC().Truncate(24 * time.Hour)
		until = from.AddDate(0, 0, 1)
	}
	limit := clampPageSize(in.PageSize)

	var view QueueView
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		session := session
		appointments, err := s.queue.Queue(ctx, scope, in.FacilityID, in.ResourceID,
			from, until, limit)
		if err != nil {
			return err
		}

		// The service rate is observed from what has actually finished today,
		// not from the roster: a clinic running twenty minutes behind is
		// running twenty minutes behind whatever the diary says.
		estimate := domain.ObserveServiceRate(appointments)
		estimate.ActiveClinicians = countActiveClinicians(appointments)

		view = QueueView{
			Positions: domain.BuildQueue(appointments, estimate),
			Estimate:  estimate,
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleRead,
			ResourceType: "queue", ResourceID: in.FacilityID,
			Outcome: audit.OutcomeSuccess, Reason: "queue read",
		}, now)
	})
	if err != nil {
		return QueueView{}, err
	}
	return view, nil
}

// countActiveClinicians counts the resources actually working this session.
//
// Two clinicians running a list halve the wait, so an estimate that ignored
// them would be wrong by a factor of two on exactly the busiest days. Counted
// from the appointments in the window rather than from the roster, because a
// rostered clinician who has not arrived is not seeing anybody.
func countActiveClinicians(appointments []*domain.Appointment) int {
	seen := map[string]bool{}
	for _, a := range appointments {
		if a.ResourceID == "" {
			continue
		}
		seen[a.ResourceID] = true
	}
	if len(seen) == 0 {
		return 1
	}
	return len(seen)
}

// RegisterWalkInInput registers somebody who arrived without an appointment.
type RegisterWalkInInput struct {
	PatientID string
	// ResourceID is the clinician or room they will be seen by. Optional: a
	// busy department triages first and allocates afterwards.
	ResourceID string
	FacilityID string
	OrgUnitID  string
	Token      string
	// ArrivalMode defaults to walk-in, and is worth stating when it is not:
	// somebody brought in by ambulance is not joining the back of the queue.
	ArrivalMode    domain.ArrivalMode
	Priority       domain.Priority
	PriorityReason string
	// Reason is why they are here. Required: it is the first thing whoever
	// triages the queue needs (SRS-SCH-010).
	Reason string
}

// RegisterWalkIn creates an appointment for an unscheduled arrival
// (SRS-SCH-010).
//
// An ordinary appointment rather than a lighter parallel record, because the
// acceptance criterion is that a walk-in is linked to the same encounter
// creation flow: a second kind of record would be a second thing every
// downstream context has to know about, and the first one to forget would drop
// walk-ins from a report.
func (s *Service) RegisterWalkIn(ctx context.Context, in RegisterWalkInInput) (
	*domain.Appointment, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "appointment",
			in.PatientID, decision.Reason)
		return nil, rpcerr.PermissionDenied("SCH_BOOK_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	arrival := in.ArrivalMode
	if arrival == "" {
		arrival = domain.ArrivalWalkIn
	}
	priority := in.Priority
	if priority == "" {
		priority = domain.PriorityStandard
	}

	var out *domain.Appointment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		facilityID := in.FacilityID
		orgUnitID := in.OrgUnitID

		if in.ResourceID != "" {
			// The resource decides the facility, so a walk-in cannot be filed
			// against a clinician who works somewhere else.
			resource, err := s.resources.Get(ctx, scope, in.ResourceID)
			if err != nil {
				return err
			}
			if !resource.Bookable() {
				return scheduleError(domain.ErrNotBookable{
					Kind: "resource", ID: resource.ID, Why: "the resource is not active",
				})
			}
			facilityID, orgUnitID = resource.FacilityID, resource.OrgUnitID
		}
		if facilityID == "" {
			return rpcerr.Invalid("SCH_WALK_IN_NO_FACILITY",
				"a walk-in needs a facility or a resource")
		}

		active, err := s.calendar.Active(ctx, scope, facilityID)
		if err != nil {
			return err
		}
		if !active {
			return scheduleError(domain.ErrNotBookable{
				Kind: "facility", ID: facilityID, Why: "the facility is not active",
			})
		}

		// A walk-in is still a patient with a record. Deceased patients do not
		// walk in, and a record that refuses routine scheduling refuses this
		// too — which is how a merged-away duplicate is caught at the desk.
		accepts, err := s.patients.AcceptsRoutineScheduling(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}
		if !accepts {
			return rpcerr.FailedPrecondition("SCH_PATIENT_NOT_SCHEDULABLE",
				"this patient's record does not accept routine appointments")
		}

		token, err := s.issueToken(ctx, scope, facilityID, in.Token, now)
		if err != nil {
			return err
		}

		appointment, err := domain.NewWalkIn(s.ids.NewID(), scope.TenantID(),
			facilityID, in.ResourceID, orgUnitID, in.PatientID, domain.CheckIn{
				Token: token, ArrivalMode: arrival, At: now,
				By: session.SubjectID, Priority: priority,
				PriorityReason: in.PriorityReason,
			}, in.Reason, now)
		if err != nil {
			return scheduleError(err)
		}

		// No slot claim. A walk-in holds no rostered capacity by definition:
		// consuming a slot somebody else booked would turn an unscheduled
		// arrival into a cancelled appointment for a patient who did nothing
		// wrong.
		if err := s.appointments.Insert(ctx, scope, appointment); err != nil {
			return err
		}

		if err := s.emitAppointmentEvent(ctx, session, EventAppointmentCheckedIn,
			appointment, now, map[string]any{
				"token":        appointment.Token,
				"arrival_mode": string(appointment.ArrivalMode),
				"priority":     string(appointment.Priority),
				"walk_in":      true,
			}); err != nil {
			return err
		}

		out = appointment
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "appointment", ResourceID: appointment.ID(),
			Outcome: audit.OutcomeSuccess,
			// The token and the facility, never the stated reason: why a
			// patient came is about them, and an audit trail carrying it is a
			// second copy outside the access rules on the first.
			Reason: "walk-in registered as " + appointment.Token,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// authorizeQueue is the shared preamble for the queue write paths.
func (s *Service) authorizeQueue(ctx context.Context, appointmentID string) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentManage, "appointment",
			appointmentID, decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("SCH_QUEUE_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// Notifications (SRS-SCH-012).

// notify records that something notifiable happened to an appointment.
//
// It does not send anything: channels, templates, retries and quiet hours
// belong to a notification service, and a scheduling context that dialled out
// would be a booking screen waiting on an SMS gateway. What it does is decide
// that a message is owed, check the patient agreed to hear about it, and leave
// a record — which is the acceptance criterion, and the thing that
// distinguishes a patient who says they were never told from one who was.
//
// Called inside the caller's transaction, so a booking and the record of its
// confirmation commit together. Never fatal to the booking: a notification
// service that cannot answer must not stop a clerk booking an appointment, so
// a failure to resolve a channel is recorded as a suppression rather than
// returned.
func (s *Service) notify(ctx context.Context, session authctx.Session,
	a *domain.Appointment, kind domain.NotificationKind, now time.Time) error {

	if s.notifications == nil {
		return nil
	}

	facilityPolicy, err := s.policies.Resolve(ctx, session.TenantScope(), a.FacilityID)
	if err != nil {
		return err
	}
	if !facilityPolicy.Notification.Sends(kind) {
		// A facility that has turned this message off sends nothing and records
		// nothing: there is no outcome to report for a message nobody decided
		// to send.
		return nil
	}

	subject := domain.ForAppointment(a.ID())
	if err := s.recordNotification(ctx, session, subject, a.PatientID,
		kind, time.Time{}, now); err != nil {
		return err
	}

	// The reminder is scheduled at booking rather than found by a nightly
	// sweep over every appointment: a queue row with a due time is something an
	// operator can inspect and replay, and a sweep is something that silently
	// misses a day.
	if kind != domain.NotifyBooked && kind != domain.NotifyRescheduled {
		return nil
	}
	due, ok := facilityPolicy.Notification.ReminderDue(a.StartsAt, now)
	if !ok {
		return nil
	}
	return s.recordNotification(ctx, session, subject, a.PatientID,
		domain.NotifyReminder, due, now)
}

// notifyWaitlistOffer records the message that carries an offer (SRS-SCH-012).
//
// Its delivery outcome is the one that matters most. An offer holds a slot for
// a stated period and then expires; an offer nobody received expires against a
// patient who never had the chance to answer, and without this record nobody
// can tell that case from a patient who simply did not reply.
func (s *Service) notifyWaitlistOffer(ctx context.Context, session authctx.Session,
	entry domain.WaitlistEntry, now time.Time) error {

	if s.notifications == nil {
		return nil
	}

	facilityPolicy, err := s.policies.Resolve(ctx, session.TenantScope(), entry.FacilityID)
	if err != nil {
		return err
	}
	if !facilityPolicy.Notification.Sends(domain.NotifyWaitlistOffer) {
		return nil
	}

	return s.recordNotification(ctx, session, domain.ForWaitlistEntry(entry.ID),
		entry.PatientID, domain.NotifyWaitlistOffer, time.Time{}, now)
}

func (s *Service) recordNotification(ctx context.Context, session authctx.Session,
	subject domain.NotificationSubject, patientID string, kind domain.NotificationKind,
	sendAfter, now time.Time) error {

	scope := session.TenantScope()

	channel, agreed, err := s.contactChannel(ctx, scope, patientID)
	if err != nil {
		return err
	}

	notification, err := domain.NewNotification(s.ids.NewID(), scope.TenantID(),
		subject, patientID, kind, channel, sendAfter, now)
	if err != nil {
		return scheduleError(err)
	}

	if !agreed {
		// Recorded rather than silently skipped. "We did not tell them, and
		// here is why" is an answer a desk can give; silence is not, and a
		// patient who was never contacted looks identical to one the gateway
		// dropped (SRS-EMPI-013).
		if err := notification.Resolve(domain.DeliverySuppressed,
			"the patient has not agreed to appointment messages on any channel",
			now); err != nil {
			return scheduleError(err)
		}
	}

	return s.notifications.Insert(ctx, scope, notification)
}

// contactChannel asks the patient index how this patient agreed to be reached.
//
// Deny by default: SRS-EMPI-013 records communication preference per channel
// and per purpose, and a combination nobody recorded is a refusal rather than a
// permission. A missing contacts port is the same answer — a deployment that
// has not wired one has not recorded anybody's consent.
func (s *Service) contactChannel(ctx context.Context, scope authctx.TenantScope,
	patientID string) (string, bool, error) {

	if s.contacts == nil {
		return notificationChannelUnknown, false, nil
	}
	channel, agreed, err := s.contacts.PreferredChannel(ctx, scope, patientID)
	if err != nil {
		return "", false, err
	}
	if !agreed || channel == "" {
		return notificationChannelUnknown, false, nil
	}
	return channel, true, nil
}

// notificationChannelUnknown stands in when no channel could be resolved. The
// record still needs one — a suppressed message with no channel could not be
// told from a bug — and naming it plainly is better than an empty string that
// reads as a missing field.
const notificationChannelUnknown = "none"

// RecordDeliveryOutcomeInput reports what a channel did with a message.
type RecordDeliveryOutcomeInput struct {
	NotificationID string
	Outcome        domain.DeliveryOutcome
	// Detail explains a failure or a suppression in a sentence somebody at a
	// desk can act on.
	Detail string
}

// RecordDeliveryOutcome captures what the notification service reported back
// (SRS-SCH-012).
//
// The whole point of the requirement: a hospital that sends reminders and does
// not know which arrived cannot tell a patient who says they were never told
// from one who was.
func (s *Service) RecordDeliveryOutcome(ctx context.Context,
	in RecordDeliveryOutcomeInput) (domain.Notification, error) {

	session, scope, err := s.authorizeQueue(ctx, in.NotificationID)
	if err != nil {
		return domain.Notification{}, err
	}
	if s.notifications == nil {
		return domain.Notification{}, rpcerr.FailedPrecondition("SCH_NOTIFICATIONS_DISABLED",
			"this deployment records no notifications")
	}

	now := s.clock.Now()

	var out domain.Notification
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		notification, err := s.notifications.Get(ctx, scope, in.NotificationID)
		if err != nil {
			return err
		}
		if err := notification.Resolve(in.Outcome, in.Detail, now); err != nil {
			return scheduleError(err)
		}
		if err := s.notifications.Resolve(ctx, scope, notification); err != nil {
			return err
		}

		out = notification
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentManage,
			ResourceType: "notification", ResourceID: notification.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "delivery " + string(notification.Outcome),
		}, now)
	})
	if err != nil {
		return domain.Notification{}, err
	}
	return out, nil
}

// ListNotificationsInput asks what was sent.
type ListNotificationsInput struct {
	// AppointmentID or WaitlistID returns the messages about one booking or one
	// offer. Both empty returns the queue of messages still waiting to go out.
	AppointmentID string
	WaitlistID    string
	PageSize      int32
}

// ListNotifications returns the delivery record (SRS-SCH-012).
func (s *Service) ListNotifications(ctx context.Context, in ListNotificationsInput) (
	[]domain.Notification, error) {

	session, scope, err := s.authorizeRead(ctx, PermScheduleRead, "notification",
		in.AppointmentID)
	if err != nil {
		return nil, err
	}
	if s.notifications == nil {
		return nil, nil
	}

	now := s.clock.Now()
	limit := clampPageSize(in.PageSize)

	var out []domain.Notification
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		switch {
		case in.AppointmentID != "":
			out, err = s.notifications.ForSubject(ctx, scope,
				domain.ForAppointment(in.AppointmentID))
		case in.WaitlistID != "":
			out, err = s.notifications.ForSubject(ctx, scope,
				domain.ForWaitlistEntry(in.WaitlistID))
		default:
			out, err = s.notifications.Pending(ctx, scope, now, limit)
		}
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleRead,
			ResourceType: "notification", ResourceID: in.AppointmentID,
			Outcome: audit.OutcomeSuccess, Reason: "notification listing",
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}
