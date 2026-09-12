// Package transport serves healthcare.scheduling.v1.AppointmentService.
package transport

import (
	"time"

	schedulingv1 "github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var resourceTypeToProto = map[domain.ResourceType]schedulingv1.ResourceType{
	domain.ResourcePractitioner: schedulingv1.ResourceType_RESOURCE_TYPE_PRACTITIONER,
	domain.ResourceRoom:         schedulingv1.ResourceType_RESOURCE_TYPE_ROOM,
	domain.ResourceEquipment:    schedulingv1.ResourceType_RESOURCE_TYPE_EQUIPMENT,
}

var resourceTypeFromProto = map[schedulingv1.ResourceType]domain.ResourceType{
	schedulingv1.ResourceType_RESOURCE_TYPE_PRACTITIONER: domain.ResourcePractitioner,
	schedulingv1.ResourceType_RESOURCE_TYPE_ROOM:         domain.ResourceRoom,
	schedulingv1.ResourceType_RESOURCE_TYPE_EQUIPMENT:    domain.ResourceEquipment,
}

var resourceStatusToProto = map[domain.ResourceStatus]schedulingv1.ResourceStatus{
	domain.ResourceActive:   schedulingv1.ResourceStatus_RESOURCE_STATUS_ACTIVE,
	domain.ResourceInactive: schedulingv1.ResourceStatus_RESOURCE_STATUS_INACTIVE,
}

var resourceStatusFromProto = map[schedulingv1.ResourceStatus]domain.ResourceStatus{
	schedulingv1.ResourceStatus_RESOURCE_STATUS_ACTIVE:   domain.ResourceActive,
	schedulingv1.ResourceStatus_RESOURCE_STATUS_INACTIVE: domain.ResourceInactive,
}

var visitTypeToProto = map[domain.VisitType]schedulingv1.VisitType{
	domain.VisitNew:         schedulingv1.VisitType_VISIT_TYPE_NEW,
	domain.VisitFollowUp:    schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
	domain.VisitProcedure:   schedulingv1.VisitType_VISIT_TYPE_PROCEDURE,
	domain.VisitTeleconsult: schedulingv1.VisitType_VISIT_TYPE_TELECONSULT,
	domain.VisitWalkIn:      schedulingv1.VisitType_VISIT_TYPE_WALK_IN,
}

var visitTypeFromProto = map[schedulingv1.VisitType]domain.VisitType{
	schedulingv1.VisitType_VISIT_TYPE_NEW:         domain.VisitNew,
	schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP:   domain.VisitFollowUp,
	schedulingv1.VisitType_VISIT_TYPE_PROCEDURE:   domain.VisitProcedure,
	schedulingv1.VisitType_VISIT_TYPE_TELECONSULT: domain.VisitTeleconsult,
	schedulingv1.VisitType_VISIT_TYPE_WALK_IN:     domain.VisitWalkIn,
}

var visitModeToProto = map[domain.VisitMode]schedulingv1.VisitMode{
	domain.ModeInPerson:    schedulingv1.VisitMode_VISIT_MODE_IN_PERSON,
	domain.ModeTeleconsult: schedulingv1.VisitMode_VISIT_MODE_TELECONSULT,
}

var visitModeFromProto = map[schedulingv1.VisitMode]domain.VisitMode{
	schedulingv1.VisitMode_VISIT_MODE_IN_PERSON:   domain.ModeInPerson,
	schedulingv1.VisitMode_VISIT_MODE_TELECONSULT: domain.ModeTeleconsult,
}

var exceptionKindToProto = map[domain.ExceptionKind]schedulingv1.ExceptionKind{
	domain.ExceptionLeave:     schedulingv1.ExceptionKind_EXCEPTION_KIND_LEAVE,
	domain.ExceptionBlock:     schedulingv1.ExceptionKind_EXCEPTION_KIND_BLOCK,
	domain.ExceptionMeeting:   schedulingv1.ExceptionKind_EXCEPTION_KIND_MEETING,
	domain.ExceptionTheatre:   schedulingv1.ExceptionKind_EXCEPTION_KIND_THEATRE,
	domain.ExceptionProcedure: schedulingv1.ExceptionKind_EXCEPTION_KIND_PROCEDURE,
}

var exceptionKindFromProto = map[schedulingv1.ExceptionKind]domain.ExceptionKind{
	schedulingv1.ExceptionKind_EXCEPTION_KIND_LEAVE:     domain.ExceptionLeave,
	schedulingv1.ExceptionKind_EXCEPTION_KIND_BLOCK:     domain.ExceptionBlock,
	schedulingv1.ExceptionKind_EXCEPTION_KIND_MEETING:   domain.ExceptionMeeting,
	schedulingv1.ExceptionKind_EXCEPTION_KIND_THEATRE:   domain.ExceptionTheatre,
	schedulingv1.ExceptionKind_EXCEPTION_KIND_PROCEDURE: domain.ExceptionProcedure,
}

var statusToProto = map[domain.Status]schedulingv1.AppointmentStatus{
	domain.StatusScheduled:        schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_SCHEDULED,
	domain.StatusArrived:          schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_ARRIVED,
	domain.StatusTriaged:          schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_TRIAGED,
	domain.StatusWaitingClinician: schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_WAITING_CLINICIAN,
	domain.StatusInConsultation:   schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_IN_CONSULTATION,
	domain.StatusPostConsultation: schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_POST_CONSULTATION,
	domain.StatusCompleted:        schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_COMPLETED,
	domain.StatusNoShow:           schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_NO_SHOW,
	domain.StatusCancelled:        schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_CANCELLED,
}

var statusFromProto = map[schedulingv1.AppointmentStatus]domain.Status{
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_SCHEDULED:         domain.StatusScheduled,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_ARRIVED:           domain.StatusArrived,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_TRIAGED:           domain.StatusTriaged,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_WAITING_CLINICIAN: domain.StatusWaitingClinician,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_IN_CONSULTATION:   domain.StatusInConsultation,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_POST_CONSULTATION: domain.StatusPostConsultation,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_COMPLETED:         domain.StatusCompleted,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_NO_SHOW:           domain.StatusNoShow,
	schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_CANCELLED:         domain.StatusCancelled,
}

func timestamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t)
}

func fromTimestamp(p *timestamppb.Timestamp) time.Time {
	if p == nil {
		return time.Time{}
	}
	return p.AsTime()
}

func resourceToProto(r domain.Resource) *schedulingv1.Resource {
	if r.ID == "" {
		return nil
	}
	return &schedulingv1.Resource{
		ResourceId: r.ID, FacilityId: r.FacilityID, OrgUnitId: r.OrgUnitID,
		Type: resourceTypeToProto[r.Type], SubjectId: r.SubjectID,
		DisplayName: r.DisplayName, Status: resourceStatusToProto[r.Status],
		TimeZone: r.TimeZone,
	}
}

func scheduleToProto(s domain.Schedule) *schedulingv1.Schedule {
	if s.ID == "" {
		return nil
	}
	return &schedulingv1.Schedule{
		ScheduleId: s.ID, ResourceId: s.ResourceID, FacilityId: s.FacilityID,
		VisitType: visitTypeToProto[s.VisitType], VisitMode: visitModeToProto[s.VisitMode],
		Weekday:     int32(s.Weekday),
		StartMinute: int32(s.StartMinute), EndMinute: int32(s.EndMinute),
		SlotMinutes: int32(s.SlotMinutes), Capacity: int32(s.Capacity),
		EffectiveFrom: timestamp(s.EffectiveFrom), EffectiveUntil: timestamp(s.EffectiveUntil),
	}
}

func exceptionToProto(e domain.Exception) *schedulingv1.ScheduleException {
	if e.ID == "" {
		return nil
	}
	return &schedulingv1.ScheduleException{
		ExceptionId: e.ID, ResourceId: e.ResourceID,
		Kind:     exceptionKindToProto[e.Kind],
		StartsAt: timestamp(e.StartsAt), EndsAt: timestamp(e.EndsAt),
		Reason: e.Reason, Overridable: e.Overridable, CreatedBy: e.CreatedBy,
	}
}

func slotsToProto(in []domain.Slot) []*schedulingv1.Slot {
	out := make([]*schedulingv1.Slot, 0, len(in))
	for _, s := range in {
		out = append(out, &schedulingv1.Slot{
			ResourceId: s.ResourceID, FacilityId: s.FacilityID, OrgUnitId: s.OrgUnitID,
			VisitType: visitTypeToProto[s.VisitType], VisitMode: visitModeToProto[s.VisitMode],
			StartsAt: timestamp(s.StartsAt), EndsAt: timestamp(s.EndsAt),
			Capacity: int32(s.Capacity), Booked: int32(s.Booked),
			Remaining: int32(s.Remaining()),
			Blocked:   s.Blocked, BlockedReason: s.BlockedReason,
			BlockedKind: exceptionKindToProto[s.BlockedKind],
		})
	}
	return out
}

func appointmentToProto(a *domain.Appointment) *schedulingv1.Appointment {
	if a == nil {
		return nil
	}
	out := &schedulingv1.Appointment{
		AppointmentId: a.ID(), FacilityId: a.FacilityID, ResourceId: a.ResourceID,
		OrgUnitId: a.OrgUnitID, PatientId: a.PatientID,
		VisitType: visitTypeToProto[a.VisitType], VisitMode: visitModeToProto[a.VisitMode],
		StartsAt: timestamp(a.StartsAt), EndsAt: timestamp(a.EndsAt),
		Status: statusToProto[a.Status], BookedBy: a.BookedBy, Reason: a.Reason,
		RescheduledFromId: a.RescheduledFromID, Version: a.Version,
		SeriesId: a.SeriesID, Occurrence: int32(a.Occurrence),
		RescheduleCount: int32(a.RescheduleCount), JoinUrl: a.JoinURL,
		Token:          a.Token,
		ArrivalMode:    arrivalModeToProto[a.ArrivalMode],
		Priority:       priorityToProto[a.Priority],
		PriorityReason: a.PriorityReason,
	}
	if a.CheckedInAt != nil {
		out.CheckedInAt = timestamp(*a.CheckedInAt)
	}
	for _, change := range a.History {
		out.History = append(out.History, &schedulingv1.StatusChange{
			From: statusToProto[change.From], To: statusToProto[change.To],
			At: timestamp(change.At), By: change.By,
			Reason: change.Reason, Corrected: change.Corrected,
		})
	}
	return out
}

func appointmentsToProto(in []*domain.Appointment) []*schedulingv1.Appointment {
	out := make([]*schedulingv1.Appointment, 0, len(in))
	for _, a := range in {
		out = append(out, appointmentToProto(a))
	}
	return out
}

// Lifecycle, series and waitlist (SRS-SCH-005/006/013/015).

var seriesScopeFromProto = map[schedulingv1.SeriesScope]domain.SeriesScope{
	schedulingv1.SeriesScope_SERIES_SCOPE_THIS_OCCURRENCE:    domain.ScopeThisOccurrence,
	schedulingv1.SeriesScope_SERIES_SCOPE_FUTURE_OCCURRENCES: domain.ScopeFutureOccurrences,
}

var waitlistStatusToProto = map[domain.WaitlistStatus]schedulingv1.WaitlistStatus{
	domain.WaitlistWaiting:   schedulingv1.WaitlistStatus_WAITLIST_STATUS_WAITING,
	domain.WaitlistOffered:   schedulingv1.WaitlistStatus_WAITLIST_STATUS_OFFERED,
	domain.WaitlistAccepted:  schedulingv1.WaitlistStatus_WAITLIST_STATUS_ACCEPTED,
	domain.WaitlistDeclined:  schedulingv1.WaitlistStatus_WAITLIST_STATUS_DECLINED,
	domain.WaitlistExpired:   schedulingv1.WaitlistStatus_WAITLIST_STATUS_EXPIRED,
	domain.WaitlistWithdrawn: schedulingv1.WaitlistStatus_WAITLIST_STATUS_WITHDRAWN,
}

func outcomeToProto(o domain.CancellationOutcome) *schedulingv1.PolicyOutcome {
	return &schedulingv1.PolicyOutcome{
		Timely:                o.Timely,
		NoticeGivenMinutes:    int32(o.NoticeGiven.Minutes()),
		NoticeRequiredMinutes: int32(o.NoticeRequired.Minutes()),
		Chargeable:            o.Chargeable,
	}
}

func waitlistToProto(w domain.WaitlistEntry) *schedulingv1.WaitlistEntry {
	if w.ID == "" {
		return nil
	}
	return &schedulingv1.WaitlistEntry{
		WaitlistId: w.ID, PatientId: w.PatientID,
		ResourceId: w.ResourceID, FacilityId: w.FacilityID, OrgUnitId: w.OrgUnitID,
		VisitType: visitTypeToProto[w.VisitType],
		NotBefore: timestamp(w.NotBefore), NotAfter: timestamp(w.NotAfter),
		AppointmentId: w.AppointmentID, Status: waitlistStatusToProto[w.Status],
		OfferedSlotAt: timestamp(w.OfferedSlotAt), OfferExpiresAt: timestamp(w.OfferExpiresAt),
	}
}

func waitlistsToProto(in []domain.WaitlistEntry) []*schedulingv1.WaitlistEntry {
	out := make([]*schedulingv1.WaitlistEntry, 0, len(in))
	for _, w := range in {
		out = append(out, waitlistToProto(w))
	}
	return out
}

func policyFromProto(p *schedulingv1.SchedulingPolicy) domain.SchedulingPolicy {
	if p == nil {
		return domain.DefaultSchedulingPolicy()
	}

	visitTypes := make([]domain.VisitType, 0, len(p.GetTeleconsultVisitTypes()))
	for _, v := range p.GetTeleconsultVisitTypes() {
		if mapped, ok := visitTypeFromProto[v]; ok {
			visitTypes = append(visitTypes, mapped)
		}
	}

	enabled := make(map[domain.NotificationKind]bool, len(p.GetNotificationKinds()))
	for _, k := range p.GetNotificationKinds() {
		if mapped, ok := notificationKindFromProto[k]; ok {
			enabled[mapped] = true
		}
	}

	return domain.SchedulingPolicy{
		Cancellation: domain.CancellationPolicy{
			NoticeHours:           int(p.GetNoticeHours()),
			RescheduleNoticeHours: int(p.GetRescheduleNoticeHours()),
			MaxReschedules:        int(p.GetMaxReschedules()),
			ChargeableWhenLate:    p.GetChargeableWhenLate(),
		},
		Teleconsult: domain.TeleconsultPolicy{
			Enabled:                  p.GetTeleconsultEnabled(),
			AllowedVisitTypes:        visitTypes,
			RequireConfirmedIdentity: p.GetTeleconsultRequiresConfirmedIdentity(),
		},
		Notification: domain.NotificationPolicy{
			Enabled:             enabled,
			ReminderHoursBefore: int(p.GetReminderHoursBefore()),
		},
	}
}

func timestamps(in []time.Time) []*timestamppb.Timestamp {
	out := make([]*timestamppb.Timestamp, 0, len(in))
	for _, t := range in {
		out = append(out, timestamp(t))
	}
	return out
}

// The queue and notifications (SRS-SCH-007 … SRS-SCH-012).

var arrivalModeToProto = map[domain.ArrivalMode]schedulingv1.ArrivalMode{
	domain.ArrivalWalkIn:     schedulingv1.ArrivalMode_ARRIVAL_MODE_WALK_IN,
	domain.ArrivalScheduled:  schedulingv1.ArrivalMode_ARRIVAL_MODE_SCHEDULED,
	domain.ArrivalAmbulance:  schedulingv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE,
	domain.ArrivalReferral:   schedulingv1.ArrivalMode_ARRIVAL_MODE_REFERRAL,
	domain.ArrivalTelehealth: schedulingv1.ArrivalMode_ARRIVAL_MODE_TELEHEALTH,
}

var arrivalModeFromProto = map[schedulingv1.ArrivalMode]domain.ArrivalMode{
	schedulingv1.ArrivalMode_ARRIVAL_MODE_WALK_IN:    domain.ArrivalWalkIn,
	schedulingv1.ArrivalMode_ARRIVAL_MODE_SCHEDULED:  domain.ArrivalScheduled,
	schedulingv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE:  domain.ArrivalAmbulance,
	schedulingv1.ArrivalMode_ARRIVAL_MODE_REFERRAL:   domain.ArrivalReferral,
	schedulingv1.ArrivalMode_ARRIVAL_MODE_TELEHEALTH: domain.ArrivalTelehealth,
}

var priorityToProto = map[domain.Priority]schedulingv1.Priority{
	domain.PriorityImmediate:  schedulingv1.Priority_PRIORITY_IMMEDIATE,
	domain.PriorityVeryUrgent: schedulingv1.Priority_PRIORITY_VERY_URGENT,
	domain.PriorityUrgent:     schedulingv1.Priority_PRIORITY_URGENT,
	domain.PriorityStandard:   schedulingv1.Priority_PRIORITY_STANDARD,
	domain.PriorityNonUrgent:  schedulingv1.Priority_PRIORITY_NON_URGENT,
}

var priorityFromProto = map[schedulingv1.Priority]domain.Priority{
	schedulingv1.Priority_PRIORITY_IMMEDIATE:   domain.PriorityImmediate,
	schedulingv1.Priority_PRIORITY_VERY_URGENT: domain.PriorityVeryUrgent,
	schedulingv1.Priority_PRIORITY_URGENT:      domain.PriorityUrgent,
	schedulingv1.Priority_PRIORITY_STANDARD:    domain.PriorityStandard,
	schedulingv1.Priority_PRIORITY_NON_URGENT:  domain.PriorityNonUrgent,
}

var notificationKindToProto = map[domain.NotificationKind]schedulingv1.NotificationKind{
	domain.NotifyBooked:        schedulingv1.NotificationKind_NOTIFICATION_KIND_BOOKED,
	domain.NotifyReminder:      schedulingv1.NotificationKind_NOTIFICATION_KIND_REMINDER,
	domain.NotifyRescheduled:   schedulingv1.NotificationKind_NOTIFICATION_KIND_RESCHEDULED,
	domain.NotifyCancelled:     schedulingv1.NotificationKind_NOTIFICATION_KIND_CANCELLED,
	domain.NotifyWaitlistOffer: schedulingv1.NotificationKind_NOTIFICATION_KIND_WAITLIST_OFFER,
}

var notificationKindFromProto = map[schedulingv1.NotificationKind]domain.NotificationKind{
	schedulingv1.NotificationKind_NOTIFICATION_KIND_BOOKED:         domain.NotifyBooked,
	schedulingv1.NotificationKind_NOTIFICATION_KIND_REMINDER:       domain.NotifyReminder,
	schedulingv1.NotificationKind_NOTIFICATION_KIND_RESCHEDULED:    domain.NotifyRescheduled,
	schedulingv1.NotificationKind_NOTIFICATION_KIND_CANCELLED:      domain.NotifyCancelled,
	schedulingv1.NotificationKind_NOTIFICATION_KIND_WAITLIST_OFFER: domain.NotifyWaitlistOffer,
}

var deliveryOutcomeToProto = map[domain.DeliveryOutcome]schedulingv1.DeliveryOutcome{
	domain.DeliveryPending:    schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_PENDING,
	domain.DeliverySent:       schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_SENT,
	domain.DeliveryDelivered:  schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_DELIVERED,
	domain.DeliveryFailed:     schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_FAILED,
	domain.DeliverySuppressed: schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_SUPPRESSED,
}

var deliveryOutcomeFromProto = map[schedulingv1.DeliveryOutcome]domain.DeliveryOutcome{
	schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_PENDING:    domain.DeliveryPending,
	schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_SENT:       domain.DeliverySent,
	schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_DELIVERED:  domain.DeliveryDelivered,
	schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_FAILED:     domain.DeliveryFailed,
	schedulingv1.DeliveryOutcome_DELIVERY_OUTCOME_SUPPRESSED: domain.DeliverySuppressed,
}

func queuePositionsToProto(in []domain.QueuePosition) []*schedulingv1.QueuePosition {
	out := make([]*schedulingv1.QueuePosition, 0, len(in))
	for _, p := range in {
		out = append(out, &schedulingv1.QueuePosition{
			Appointment: appointmentToProto(p.Appointment),
			Position:    int32(p.Position),
			// Seconds rather than a duration message: a board renders minutes,
			// and an estimate carried to the nanosecond would read as a promise.
			EstimatedWaitSeconds: int64(p.EstimatedWait.Seconds()),
		})
	}
	return out
}

func queueEstimateToProto(e domain.QueueEstimate) *schedulingv1.QueueEstimate {
	return &schedulingv1.QueueEstimate{
		ServiceMinutes:   e.ServiceMinutes,
		Observed:         e.Observed,
		ActiveClinicians: int32(e.ActiveClinicians),
	}
}

func notificationToProto(n domain.Notification) *schedulingv1.Notification {
	return &schedulingv1.Notification{
		NotificationId: n.ID, AppointmentId: n.AppointmentID,
		WaitlistId: n.WaitlistID, PatientId: n.PatientID,
		Kind: notificationKindToProto[n.Kind], Channel: n.Channel,
		Outcome: deliveryOutcomeToProto[n.Outcome], Detail: n.Detail,
		SendAfter: timestamp(n.SendAfter),
		CreatedAt: timestamp(n.CreatedAt), UpdatedAt: timestamp(n.UpdatedAt),
	}
}

func notificationsToProto(in []domain.Notification) []*schedulingv1.Notification {
	out := make([]*schedulingv1.Notification, 0, len(in))
	for _, n := range in {
		out = append(out, notificationToProto(n))
	}
	return out
}
