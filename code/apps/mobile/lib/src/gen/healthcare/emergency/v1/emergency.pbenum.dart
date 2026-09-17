// This is a generated file - do not edit.
//
// Generated from healthcare/emergency/v1/emergency.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How the patient reached the department (SRS-ER-001).
class ArrivalMode extends $pb.ProtobufEnum {
  static const ArrivalMode ARRIVAL_MODE_UNSPECIFIED =
      ArrivalMode._(0, _omitEnumNames ? '' : 'ARRIVAL_MODE_UNSPECIFIED');
  static const ArrivalMode ARRIVAL_MODE_WALK_IN =
      ArrivalMode._(1, _omitEnumNames ? '' : 'ARRIVAL_MODE_WALK_IN');
  static const ArrivalMode ARRIVAL_MODE_AMBULANCE =
      ArrivalMode._(2, _omitEnumNames ? '' : 'ARRIVAL_MODE_AMBULANCE');
  static const ArrivalMode ARRIVAL_MODE_REFERRAL =
      ArrivalMode._(3, _omitEnumNames ? '' : 'ARRIVAL_MODE_REFERRAL');

  /// From another facility, which carries an obligation the others do not:
  /// somebody is expecting a reply.
  static const ArrivalMode ARRIVAL_MODE_TRANSFER =
      ArrivalMode._(4, _omitEnumNames ? '' : 'ARRIVAL_MODE_TRANSFER');

  static const $core.List<ArrivalMode> values = <ArrivalMode>[
    ARRIVAL_MODE_UNSPECIFIED,
    ARRIVAL_MODE_WALK_IN,
    ARRIVAL_MODE_AMBULANCE,
    ARRIVAL_MODE_REFERRAL,
    ARRIVAL_MODE_TRANSFER,
  ];

  static final $core.List<ArrivalMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ArrivalMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ArrivalMode._(super.value, super.name);
}

/// Where the patient is in the department.
class VisitStatus extends $pb.ProtobufEnum {
  static const VisitStatus VISIT_STATUS_UNSPECIFIED =
      VisitStatus._(0, _omitEnumNames ? '' : 'VISIT_STATUS_UNSPECIFIED');

  /// Booked in and not yet triaged. The clock that matters most is running.
  static const VisitStatus VISIT_STATUS_ARRIVED =
      VisitStatus._(1, _omitEnumNames ? '' : 'VISIT_STATUS_ARRIVED');
  static const VisitStatus VISIT_STATUS_TRIAGED =
      VisitStatus._(2, _omitEnumNames ? '' : 'VISIT_STATUS_TRIAGED');
  static const VisitStatus VISIT_STATUS_IN_TREATMENT =
      VisitStatus._(3, _omitEnumNames ? '' : 'VISIT_STATUS_IN_TREATMENT');

  /// An ED observation bed (SRS-ER-014): still the department's patient, not an
  /// inpatient admission.
  static const VisitStatus VISIT_STATUS_OBSERVATION =
      VisitStatus._(4, _omitEnumNames ? '' : 'VISIT_STATUS_OBSERVATION');
  static const VisitStatus VISIT_STATUS_DISPOSED =
      VisitStatus._(5, _omitEnumNames ? '' : 'VISIT_STATUS_DISPOSED');

  static const $core.List<VisitStatus> values = <VisitStatus>[
    VISIT_STATUS_UNSPECIFIED,
    VISIT_STATUS_ARRIVED,
    VISIT_STATUS_TRIAGED,
    VISIT_STATUS_IN_TREATMENT,
    VISIT_STATUS_OBSERVATION,
    VISIT_STATUS_DISPOSED,
  ];

  static final $core.List<VisitStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static VisitStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VisitStatus._(super.value, super.name);
}

/// Where the patient goes (SRS-ER-013).
class Disposition extends $pb.ProtobufEnum {
  static const Disposition DISPOSITION_UNSPECIFIED =
      Disposition._(0, _omitEnumNames ? '' : 'DISPOSITION_UNSPECIFIED');
  static const Disposition DISPOSITION_DISCHARGE =
      Disposition._(1, _omitEnumNames ? '' : 'DISPOSITION_DISCHARGE');
  static const Disposition DISPOSITION_OBSERVATION =
      Disposition._(2, _omitEnumNames ? '' : 'DISPOSITION_OBSERVATION');
  static const Disposition DISPOSITION_ADMISSION =
      Disposition._(3, _omitEnumNames ? '' : 'DISPOSITION_ADMISSION');
  static const Disposition DISPOSITION_THEATRE =
      Disposition._(4, _omitEnumNames ? '' : 'DISPOSITION_THEATRE');
  static const Disposition DISPOSITION_ICU =
      Disposition._(5, _omitEnumNames ? '' : 'DISPOSITION_ICU');
  static const Disposition DISPOSITION_TRANSFER =
      Disposition._(6, _omitEnumNames ? '' : 'DISPOSITION_TRANSFER');

  /// A decision the patient made, witnessed and counselled. Distinct from
  /// absconded because that difference is the whole of the medico-legal record.
  static const Disposition DISPOSITION_LEFT_AGAINST_ADVICE =
      Disposition._(7, _omitEnumNames ? '' : 'DISPOSITION_LEFT_AGAINST_ADVICE');

  /// The department lost the patient. A disposition because the alternative is
  /// a visit that stays open forever and a patient nobody is looking for.
  static const Disposition DISPOSITION_ABSCONDED =
      Disposition._(8, _omitEnumNames ? '' : 'DISPOSITION_ABSCONDED');
  static const Disposition DISPOSITION_DEATH =
      Disposition._(9, _omitEnumNames ? '' : 'DISPOSITION_DEATH');
  static const Disposition DISPOSITION_REFERRAL =
      Disposition._(10, _omitEnumNames ? '' : 'DISPOSITION_REFERRAL');

  static const $core.List<Disposition> values = <Disposition>[
    DISPOSITION_UNSPECIFIED,
    DISPOSITION_DISCHARGE,
    DISPOSITION_OBSERVATION,
    DISPOSITION_ADMISSION,
    DISPOSITION_THEATRE,
    DISPOSITION_ICU,
    DISPOSITION_TRANSFER,
    DISPOSITION_LEFT_AGAINST_ADVICE,
    DISPOSITION_ABSCONDED,
    DISPOSITION_DEATH,
    DISPOSITION_REFERRAL,
  ];

  static final $core.List<Disposition?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static Disposition? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Disposition._(super.value, super.name);
}

/// A time-critical protocol (SRS-ER-005).
class PathwayKind extends $pb.ProtobufEnum {
  static const PathwayKind PATHWAY_KIND_UNSPECIFIED =
      PathwayKind._(0, _omitEnumNames ? '' : 'PATHWAY_KIND_UNSPECIFIED');
  static const PathwayKind PATHWAY_KIND_RESUSCITATION =
      PathwayKind._(1, _omitEnumNames ? '' : 'PATHWAY_KIND_RESUSCITATION');
  static const PathwayKind PATHWAY_KIND_TRAUMA =
      PathwayKind._(2, _omitEnumNames ? '' : 'PATHWAY_KIND_TRAUMA');
  static const PathwayKind PATHWAY_KIND_STROKE =
      PathwayKind._(3, _omitEnumNames ? '' : 'PATHWAY_KIND_STROKE');
  static const PathwayKind PATHWAY_KIND_STEMI =
      PathwayKind._(4, _omitEnumNames ? '' : 'PATHWAY_KIND_STEMI');
  static const PathwayKind PATHWAY_KIND_SEPSIS =
      PathwayKind._(5, _omitEnumNames ? '' : 'PATHWAY_KIND_SEPSIS');

  /// A locally defined protocol, named in `label`. Allowed because a department
  /// that has agreed a paediatric sepsis pathway should not wait for this
  /// enumeration.
  static const PathwayKind PATHWAY_KIND_OTHER =
      PathwayKind._(6, _omitEnumNames ? '' : 'PATHWAY_KIND_OTHER');

  static const $core.List<PathwayKind> values = <PathwayKind>[
    PATHWAY_KIND_UNSPECIFIED,
    PATHWAY_KIND_RESUSCITATION,
    PATHWAY_KIND_TRAUMA,
    PATHWAY_KIND_STROKE,
    PATHWAY_KIND_STEMI,
    PATHWAY_KIND_SEPSIS,
    PATHWAY_KIND_OTHER,
  ];

  static final $core.List<PathwayKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PathwayKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PathwayKind._(super.value, super.name);
}

/// What happened, on the timeline (SRS-ER-008).
class EventKind extends $pb.ProtobufEnum {
  static const EventKind EVENT_KIND_UNSPECIFIED =
      EventKind._(0, _omitEnumNames ? '' : 'EVENT_KIND_UNSPECIFIED');
  static const EventKind EVENT_KIND_ARRIVAL =
      EventKind._(1, _omitEnumNames ? '' : 'EVENT_KIND_ARRIVAL');
  static const EventKind EVENT_KIND_TRIAGE =
      EventKind._(2, _omitEnumNames ? '' : 'EVENT_KIND_TRIAGE');

  /// The end of door-to-doctor. Recorded when a clinician takes the patient,
  /// not when one is assigned: an assignment is a rota entry and the patient
  /// cannot tell the difference.
  static const EventKind EVENT_KIND_CLINICIAN_SEEN =
      EventKind._(3, _omitEnumNames ? '' : 'EVENT_KIND_CLINICIAN_SEEN');
  static const EventKind EVENT_KIND_PATHWAY_ACTIVATED =
      EventKind._(4, _omitEnumNames ? '' : 'EVENT_KIND_PATHWAY_ACTIVATED');
  static const EventKind EVENT_KIND_MILESTONE =
      EventKind._(5, _omitEnumNames ? '' : 'EVENT_KIND_MILESTONE');
  static const EventKind EVENT_KIND_AIRWAY =
      EventKind._(6, _omitEnumNames ? '' : 'EVENT_KIND_AIRWAY');
  static const EventKind EVENT_KIND_CPR =
      EventKind._(7, _omitEnumNames ? '' : 'EVENT_KIND_CPR');
  static const EventKind EVENT_KIND_DEFIBRILLATION =
      EventKind._(8, _omitEnumNames ? '' : 'EVENT_KIND_DEFIBRILLATION');
  static const EventKind EVENT_KIND_FLUID =
      EventKind._(9, _omitEnumNames ? '' : 'EVENT_KIND_FLUID');
  static const EventKind EVENT_KIND_DRUG =
      EventKind._(10, _omitEnumNames ? '' : 'EVENT_KIND_DRUG');
  static const EventKind EVENT_KIND_PROCEDURE =
      EventKind._(11, _omitEnumNames ? '' : 'EVENT_KIND_PROCEDURE');
  static const EventKind EVENT_KIND_OBSERVATION =
      EventKind._(12, _omitEnumNames ? '' : 'EVENT_KIND_OBSERVATION');
  static const EventKind EVENT_KIND_DISPOSITION =
      EventKind._(13, _omitEnumNames ? '' : 'EVENT_KIND_DISPOSITION');

  static const $core.List<EventKind> values = <EventKind>[
    EVENT_KIND_UNSPECIFIED,
    EVENT_KIND_ARRIVAL,
    EVENT_KIND_TRIAGE,
    EVENT_KIND_CLINICIAN_SEEN,
    EVENT_KIND_PATHWAY_ACTIVATED,
    EVENT_KIND_MILESTONE,
    EVENT_KIND_AIRWAY,
    EVENT_KIND_CPR,
    EVENT_KIND_DEFIBRILLATION,
    EVENT_KIND_FLUID,
    EVENT_KIND_DRUG,
    EVENT_KIND_PROCEDURE,
    EVENT_KIND_OBSERVATION,
    EVENT_KIND_DISPOSITION,
  ];

  static final $core.List<EventKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 13);
  static EventKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EventKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
