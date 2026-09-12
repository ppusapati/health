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
