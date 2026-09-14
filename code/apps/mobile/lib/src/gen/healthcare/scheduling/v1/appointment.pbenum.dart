// This is a generated file - do not edit.
//
// Generated from healthcare/scheduling/v1/appointment.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// What kind of thing is being booked (SRS-SCH-001).
///
/// A clinician and an operating theatre are the same thing to a diary: something
/// with finite time that two people cannot have at once. A schedule that could
/// attach only to a person could not express "this scanner, forty minutes, one
/// patient at a time", and a hospital's scarcest resources are usually not
/// people.
class ResourceType extends $pb.ProtobufEnum {
  static const ResourceType RESOURCE_TYPE_UNSPECIFIED =
      ResourceType._(0, _omitEnumNames ? '' : 'RESOURCE_TYPE_UNSPECIFIED');
  static const ResourceType RESOURCE_TYPE_PRACTITIONER =
      ResourceType._(1, _omitEnumNames ? '' : 'RESOURCE_TYPE_PRACTITIONER');
  static const ResourceType RESOURCE_TYPE_ROOM =
      ResourceType._(2, _omitEnumNames ? '' : 'RESOURCE_TYPE_ROOM');
  static const ResourceType RESOURCE_TYPE_EQUIPMENT =
      ResourceType._(3, _omitEnumNames ? '' : 'RESOURCE_TYPE_EQUIPMENT');

  static const $core.List<ResourceType> values = <ResourceType>[
    RESOURCE_TYPE_UNSPECIFIED,
    RESOURCE_TYPE_PRACTITIONER,
    RESOURCE_TYPE_ROOM,
    RESOURCE_TYPE_EQUIPMENT,
  ];

  static final $core.List<ResourceType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ResourceType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResourceType._(super.value, super.name);
}

class ResourceStatus extends $pb.ProtobufEnum {
  static const ResourceStatus RESOURCE_STATUS_UNSPECIFIED =
      ResourceStatus._(0, _omitEnumNames ? '' : 'RESOURCE_STATUS_UNSPECIFIED');
  static const ResourceStatus RESOURCE_STATUS_ACTIVE =
      ResourceStatus._(1, _omitEnumNames ? '' : 'RESOURCE_STATUS_ACTIVE');

  /// Has left, is out of service, or is not yet in service. Past appointments
  /// stay: a clinician who has retired still saw the patients they saw.
  static const ResourceStatus RESOURCE_STATUS_INACTIVE =
      ResourceStatus._(2, _omitEnumNames ? '' : 'RESOURCE_STATUS_INACTIVE');

  static const $core.List<ResourceStatus> values = <ResourceStatus>[
    RESOURCE_STATUS_UNSPECIFIED,
    RESOURCE_STATUS_ACTIVE,
    RESOURCE_STATUS_INACTIVE,
  ];

  static final $core.List<ResourceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ResourceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResourceStatus._(super.value, super.name);
}

/// What kind of appointment a slot is for.
///
/// Part of the roster rather than the booking because the durations differ: a
/// new-patient assessment is forty minutes and a follow-up is ten, and a diary
/// that let either be booked into either would waste half the clinic or overrun
/// it.
class VisitType extends $pb.ProtobufEnum {
  static const VisitType VISIT_TYPE_UNSPECIFIED =
      VisitType._(0, _omitEnumNames ? '' : 'VISIT_TYPE_UNSPECIFIED');
  static const VisitType VISIT_TYPE_NEW =
      VisitType._(1, _omitEnumNames ? '' : 'VISIT_TYPE_NEW');
  static const VisitType VISIT_TYPE_FOLLOW_UP =
      VisitType._(2, _omitEnumNames ? '' : 'VISIT_TYPE_FOLLOW_UP');
  static const VisitType VISIT_TYPE_PROCEDURE =
      VisitType._(3, _omitEnumNames ? '' : 'VISIT_TYPE_PROCEDURE');
  static const VisitType VISIT_TYPE_TELECONSULT =
      VisitType._(4, _omitEnumNames ? '' : 'VISIT_TYPE_TELECONSULT');
  static const VisitType VISIT_TYPE_WALK_IN =
      VisitType._(5, _omitEnumNames ? '' : 'VISIT_TYPE_WALK_IN');

  static const $core.List<VisitType> values = <VisitType>[
    VISIT_TYPE_UNSPECIFIED,
    VISIT_TYPE_NEW,
    VISIT_TYPE_FOLLOW_UP,
    VISIT_TYPE_PROCEDURE,
    VISIT_TYPE_TELECONSULT,
    VISIT_TYPE_WALK_IN,
  ];

  static final $core.List<VisitType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static VisitType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VisitType._(super.value, super.name);
}

/// Where the appointment happens (SRS-SCH-015).
class VisitMode extends $pb.ProtobufEnum {
  static const VisitMode VISIT_MODE_UNSPECIFIED =
      VisitMode._(0, _omitEnumNames ? '' : 'VISIT_MODE_UNSPECIFIED');
  static const VisitMode VISIT_MODE_IN_PERSON =
      VisitMode._(1, _omitEnumNames ? '' : 'VISIT_MODE_IN_PERSON');
  static const VisitMode VISIT_MODE_TELECONSULT =
      VisitMode._(2, _omitEnumNames ? '' : 'VISIT_MODE_TELECONSULT');

  static const $core.List<VisitMode> values = <VisitMode>[
    VISIT_MODE_UNSPECIFIED,
    VISIT_MODE_IN_PERSON,
    VISIT_MODE_TELECONSULT,
  ];

  static final $core.List<VisitMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static VisitMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VisitMode._(super.value, super.name);
}

/// Why capacity was removed (SRS-SCH-002).
/// How the patient got here (SRS-SCH-007). Recorded because it changes what
/// happens next: somebody brought in by ambulance is not joining the back of the
/// queue, and a remote patient is not in the waiting room at all.
class ArrivalMode extends $pb.ProtobufEnum {
  static const ArrivalMode ARRIVAL_MODE_UNSPECIFIED =
      ArrivalMode._(0, _omitEnumNames ? '' : 'ARRIVAL_MODE_UNSPECIFIED');
  static const ArrivalMode ARRIVAL_MODE_WALK_IN =
      ArrivalMode._(1, _omitEnumNames ? '' : 'ARRIVAL_MODE_WALK_IN');
  static const ArrivalMode ARRIVAL_MODE_SCHEDULED =
      ArrivalMode._(2, _omitEnumNames ? '' : 'ARRIVAL_MODE_SCHEDULED');
  static const ArrivalMode ARRIVAL_MODE_AMBULANCE =
      ArrivalMode._(3, _omitEnumNames ? '' : 'ARRIVAL_MODE_AMBULANCE');
  static const ArrivalMode ARRIVAL_MODE_REFERRAL =
      ArrivalMode._(4, _omitEnumNames ? '' : 'ARRIVAL_MODE_REFERRAL');
  static const ArrivalMode ARRIVAL_MODE_TELEHEALTH =
      ArrivalMode._(5, _omitEnumNames ? '' : 'ARRIVAL_MODE_TELEHEALTH');

  static const $core.List<ArrivalMode> values = <ArrivalMode>[
    ARRIVAL_MODE_UNSPECIFIED,
    ARRIVAL_MODE_WALK_IN,
    ARRIVAL_MODE_SCHEDULED,
    ARRIVAL_MODE_AMBULANCE,
    ARRIVAL_MODE_REFERRAL,
    ARRIVAL_MODE_TELEHEALTH,
  ];

  static final $core.List<ArrivalMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ArrivalMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ArrivalMode._(super.value, super.name);
}

/// Where a patient sits in the queue (SRS-SCH-010, SRS-SCH-011).
///
/// Deliberately coarse. A five-band scale is what triage systems use and what
/// staff can hold in their heads; a numeric score invites arithmetic, and
/// arithmetic on clinical urgency is how somebody ends up behind a spreadsheet.
class Priority extends $pb.ProtobufEnum {
  static const Priority PRIORITY_UNSPECIFIED =
      Priority._(0, _omitEnumNames ? '' : 'PRIORITY_UNSPECIFIED');

  /// Cannot wait. Resuscitation.
  static const Priority PRIORITY_IMMEDIATE =
      Priority._(1, _omitEnumNames ? '' : 'PRIORITY_IMMEDIATE');
  static const Priority PRIORITY_VERY_URGENT =
      Priority._(2, _omitEnumNames ? '' : 'PRIORITY_VERY_URGENT');
  static const Priority PRIORITY_URGENT =
      Priority._(3, _omitEnumNames ? '' : 'PRIORITY_URGENT');

  /// The default and most of the list.
  static const Priority PRIORITY_STANDARD =
      Priority._(4, _omitEnumNames ? '' : 'PRIORITY_STANDARD');
  static const Priority PRIORITY_NON_URGENT =
      Priority._(5, _omitEnumNames ? '' : 'PRIORITY_NON_URGENT');

  static const $core.List<Priority> values = <Priority>[
    PRIORITY_UNSPECIFIED,
    PRIORITY_IMMEDIATE,
    PRIORITY_VERY_URGENT,
    PRIORITY_URGENT,
    PRIORITY_STANDARD,
    PRIORITY_NON_URGENT,
  ];

  static final $core.List<Priority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Priority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Priority._(super.value, super.name);
}

/// What a notification is about (SRS-SCH-012).
class NotificationKind extends $pb.ProtobufEnum {
  static const NotificationKind NOTIFICATION_KIND_UNSPECIFIED =
      NotificationKind._(
          0, _omitEnumNames ? '' : 'NOTIFICATION_KIND_UNSPECIFIED');
  static const NotificationKind NOTIFICATION_KIND_BOOKED =
      NotificationKind._(1, _omitEnumNames ? '' : 'NOTIFICATION_KIND_BOOKED');
  static const NotificationKind NOTIFICATION_KIND_REMINDER =
      NotificationKind._(2, _omitEnumNames ? '' : 'NOTIFICATION_KIND_REMINDER');
  static const NotificationKind NOTIFICATION_KIND_RESCHEDULED =
      NotificationKind._(
          3, _omitEnumNames ? '' : 'NOTIFICATION_KIND_RESCHEDULED');
  static const NotificationKind NOTIFICATION_KIND_CANCELLED =
      NotificationKind._(
          4, _omitEnumNames ? '' : 'NOTIFICATION_KIND_CANCELLED');
  static const NotificationKind NOTIFICATION_KIND_WAITLIST_OFFER =
      NotificationKind._(
          5, _omitEnumNames ? '' : 'NOTIFICATION_KIND_WAITLIST_OFFER');

  static const $core.List<NotificationKind> values = <NotificationKind>[
    NOTIFICATION_KIND_UNSPECIFIED,
    NOTIFICATION_KIND_BOOKED,
    NOTIFICATION_KIND_REMINDER,
    NOTIFICATION_KIND_RESCHEDULED,
    NOTIFICATION_KIND_CANCELLED,
    NOTIFICATION_KIND_WAITLIST_OFFER,
  ];

  static final $core.List<NotificationKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static NotificationKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotificationKind._(super.value, super.name);
}

/// What happened to a message (SRS-SCH-012).
class DeliveryOutcome extends $pb.ProtobufEnum {
  static const DeliveryOutcome DELIVERY_OUTCOME_UNSPECIFIED = DeliveryOutcome._(
      0, _omitEnumNames ? '' : 'DELIVERY_OUTCOME_UNSPECIFIED');

  /// Handed to the notification service and not yet resolved.
  static const DeliveryOutcome DELIVERY_OUTCOME_PENDING =
      DeliveryOutcome._(1, _omitEnumNames ? '' : 'DELIVERY_OUTCOME_PENDING');
  static const DeliveryOutcome DELIVERY_OUTCOME_SENT =
      DeliveryOutcome._(2, _omitEnumNames ? '' : 'DELIVERY_OUTCOME_SENT');

  /// Confirmation from the channel, where the channel offers one. Distinct from
  /// sent because "we posted it" and "it arrived" are different claims, and only
  /// one of them answers a patient who says they never heard.
  static const DeliveryOutcome DELIVERY_OUTCOME_DELIVERED =
      DeliveryOutcome._(3, _omitEnumNames ? '' : 'DELIVERY_OUTCOME_DELIVERED');
  static const DeliveryOutcome DELIVERY_OUTCOME_FAILED =
      DeliveryOutcome._(4, _omitEnumNames ? '' : 'DELIVERY_OUTCOME_FAILED');

  /// The patient had not agreed to be contacted this way. Recorded rather than
  /// silently skipped: "we did not tell them, and here is why" is an answer;
  /// silence is not.
  static const DeliveryOutcome DELIVERY_OUTCOME_SUPPRESSED =
      DeliveryOutcome._(5, _omitEnumNames ? '' : 'DELIVERY_OUTCOME_SUPPRESSED');

  static const $core.List<DeliveryOutcome> values = <DeliveryOutcome>[
    DELIVERY_OUTCOME_UNSPECIFIED,
    DELIVERY_OUTCOME_PENDING,
    DELIVERY_OUTCOME_SENT,
    DELIVERY_OUTCOME_DELIVERED,
    DELIVERY_OUTCOME_FAILED,
    DELIVERY_OUTCOME_SUPPRESSED,
  ];

  static final $core.List<DeliveryOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static DeliveryOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeliveryOutcome._(super.value, super.name);
}

class ExceptionKind extends $pb.ProtobufEnum {
  static const ExceptionKind EXCEPTION_KIND_UNSPECIFIED =
      ExceptionKind._(0, _omitEnumNames ? '' : 'EXCEPTION_KIND_UNSPECIFIED');
  static const ExceptionKind EXCEPTION_KIND_LEAVE =
      ExceptionKind._(1, _omitEnumNames ? '' : 'EXCEPTION_KIND_LEAVE');
  static const ExceptionKind EXCEPTION_KIND_BLOCK =
      ExceptionKind._(2, _omitEnumNames ? '' : 'EXCEPTION_KIND_BLOCK');
  static const ExceptionKind EXCEPTION_KIND_MEETING =
      ExceptionKind._(3, _omitEnumNames ? '' : 'EXCEPTION_KIND_MEETING');
  static const ExceptionKind EXCEPTION_KIND_THEATRE =
      ExceptionKind._(4, _omitEnumNames ? '' : 'EXCEPTION_KIND_THEATRE');
  static const ExceptionKind EXCEPTION_KIND_PROCEDURE =
      ExceptionKind._(5, _omitEnumNames ? '' : 'EXCEPTION_KIND_PROCEDURE');

  static const $core.List<ExceptionKind> values = <ExceptionKind>[
    EXCEPTION_KIND_UNSPECIFIED,
    EXCEPTION_KIND_LEAVE,
    EXCEPTION_KIND_BLOCK,
    EXCEPTION_KIND_MEETING,
    EXCEPTION_KIND_THEATRE,
    EXCEPTION_KIND_PROCEDURE,
  ];

  static final $core.List<ExceptionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ExceptionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExceptionKind._(super.value, super.name);
}

/// Where an appointment sits in its life (SRS-SCH-008).
///
/// Deliberately not a total order. Triage is skipped in an outpatient clinic and
/// mandatory in an emergency department; a patient can leave before being seen;
/// a consultation can be re-entered because the clinician stepped out for a
/// result.
class AppointmentStatus extends $pb.ProtobufEnum {
  static const AppointmentStatus APPOINTMENT_STATUS_UNSPECIFIED =
      AppointmentStatus._(
          0, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_UNSPECIFIED');
  static const AppointmentStatus APPOINTMENT_STATUS_SCHEDULED =
      AppointmentStatus._(
          1, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_SCHEDULED');
  static const AppointmentStatus APPOINTMENT_STATUS_ARRIVED =
      AppointmentStatus._(
          2, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_ARRIVED');
  static const AppointmentStatus APPOINTMENT_STATUS_TRIAGED =
      AppointmentStatus._(
          3, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_TRIAGED');
  static const AppointmentStatus APPOINTMENT_STATUS_WAITING_CLINICIAN =
      AppointmentStatus._(
          4, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_WAITING_CLINICIAN');
  static const AppointmentStatus APPOINTMENT_STATUS_IN_CONSULTATION =
      AppointmentStatus._(
          5, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_IN_CONSULTATION');
  static const AppointmentStatus APPOINTMENT_STATUS_POST_CONSULTATION =
      AppointmentStatus._(
          6, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_POST_CONSULTATION');
  static const AppointmentStatus APPOINTMENT_STATUS_COMPLETED =
      AppointmentStatus._(
          7, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_COMPLETED');
  static const AppointmentStatus APPOINTMENT_STATUS_NO_SHOW =
      AppointmentStatus._(
          8, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_NO_SHOW');
  static const AppointmentStatus APPOINTMENT_STATUS_CANCELLED =
      AppointmentStatus._(
          9, _omitEnumNames ? '' : 'APPOINTMENT_STATUS_CANCELLED');

  static const $core.List<AppointmentStatus> values = <AppointmentStatus>[
    APPOINTMENT_STATUS_UNSPECIFIED,
    APPOINTMENT_STATUS_SCHEDULED,
    APPOINTMENT_STATUS_ARRIVED,
    APPOINTMENT_STATUS_TRIAGED,
    APPOINTMENT_STATUS_WAITING_CLINICIAN,
    APPOINTMENT_STATUS_IN_CONSULTATION,
    APPOINTMENT_STATUS_POST_CONSULTATION,
    APPOINTMENT_STATUS_COMPLETED,
    APPOINTMENT_STATUS_NO_SHOW,
    APPOINTMENT_STATUS_CANCELLED,
  ];

  static final $core.List<AppointmentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static AppointmentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AppointmentStatus._(super.value, super.name);
}

/// How far a change to a recurring series reaches (SRS-SCH-013).
///
/// A physiotherapy course is twelve appointments; the patient asks to move next
/// Tuesday, or asks to move every remaining Tuesday, and those are different
/// requests. Past occurrences are never touched by either: they happened.
class SeriesScope extends $pb.ProtobufEnum {
  static const SeriesScope SERIES_SCOPE_UNSPECIFIED =
      SeriesScope._(0, _omitEnumNames ? '' : 'SERIES_SCOPE_UNSPECIFIED');
  static const SeriesScope SERIES_SCOPE_THIS_OCCURRENCE =
      SeriesScope._(1, _omitEnumNames ? '' : 'SERIES_SCOPE_THIS_OCCURRENCE');
  static const SeriesScope SERIES_SCOPE_FUTURE_OCCURRENCES =
      SeriesScope._(2, _omitEnumNames ? '' : 'SERIES_SCOPE_FUTURE_OCCURRENCES');

  static const $core.List<SeriesScope> values = <SeriesScope>[
    SERIES_SCOPE_UNSPECIFIED,
    SERIES_SCOPE_THIS_OCCURRENCE,
    SERIES_SCOPE_FUTURE_OCCURRENCES,
  ];

  static final $core.List<SeriesScope?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SeriesScope? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SeriesScope._(super.value, super.name);
}

class WaitlistStatus extends $pb.ProtobufEnum {
  static const WaitlistStatus WAITLIST_STATUS_UNSPECIFIED =
      WaitlistStatus._(0, _omitEnumNames ? '' : 'WAITLIST_STATUS_UNSPECIFIED');
  static const WaitlistStatus WAITLIST_STATUS_WAITING =
      WaitlistStatus._(1, _omitEnumNames ? '' : 'WAITLIST_STATUS_WAITING');

  /// Has been shown an earlier slot and has not answered.
  static const WaitlistStatus WAITLIST_STATUS_OFFERED =
      WaitlistStatus._(2, _omitEnumNames ? '' : 'WAITLIST_STATUS_OFFERED');
  static const WaitlistStatus WAITLIST_STATUS_ACCEPTED =
      WaitlistStatus._(3, _omitEnumNames ? '' : 'WAITLIST_STATUS_ACCEPTED');
  static const WaitlistStatus WAITLIST_STATUS_DECLINED =
      WaitlistStatus._(4, _omitEnumNames ? '' : 'WAITLIST_STATUS_DECLINED');
  static const WaitlistStatus WAITLIST_STATUS_EXPIRED =
      WaitlistStatus._(5, _omitEnumNames ? '' : 'WAITLIST_STATUS_EXPIRED');
  static const WaitlistStatus WAITLIST_STATUS_WITHDRAWN =
      WaitlistStatus._(6, _omitEnumNames ? '' : 'WAITLIST_STATUS_WITHDRAWN');

  static const $core.List<WaitlistStatus> values = <WaitlistStatus>[
    WAITLIST_STATUS_UNSPECIFIED,
    WAITLIST_STATUS_WAITING,
    WAITLIST_STATUS_OFFERED,
    WAITLIST_STATUS_ACCEPTED,
    WAITLIST_STATUS_DECLINED,
    WAITLIST_STATUS_EXPIRED,
    WAITLIST_STATUS_WITHDRAWN,
  ];

  static final $core.List<WaitlistStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static WaitlistStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WaitlistStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
