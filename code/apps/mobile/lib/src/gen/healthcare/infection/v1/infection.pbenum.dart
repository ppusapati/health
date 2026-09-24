// This is a generated file - do not edit.
//
// Generated from healthcare/infection/v1/infection.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Whether an infection was acquired here (SRS-IPC-001).
class Onset extends $pb.ProtobufEnum {
  static const Onset ONSET_UNSPECIFIED =
      Onset._(0, _omitEnumNames ? '' : 'ONSET_UNSPECIFIED');

  /// Present or incubating on admission.
  static const Onset ONSET_COMMUNITY_ACQUIRED =
      Onset._(1, _omitEnumNames ? '' : 'ONSET_COMMUNITY_ACQUIRED');

  /// Appeared after the surveillance window, so the hospital owns it.
  static const Onset ONSET_HEALTHCARE_ASSOCIATED =
      Onset._(2, _omitEnumNames ? '' : 'ONSET_HEALTHCARE_ASSOCIATED');

  /// Cannot be decided from the dates available. Named rather than forced
  /// either way, because guessing biases the rate in whichever direction the
  /// default happens to fall.
  static const Onset ONSET_INDETERMINATE =
      Onset._(3, _omitEnumNames ? '' : 'ONSET_INDETERMINATE');

  static const $core.List<Onset> values = <Onset>[
    ONSET_UNSPECIFIED,
    ONSET_COMMUNITY_ACQUIRED,
    ONSET_HEALTHCARE_ASSOCIATED,
    ONSET_INDETERMINATE,
  ];

  static final $core.List<Onset?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Onset? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Onset._(super.value, super.name);
}

/// Where the infection is (SRS-IPC-001, SRS-IPC-002).
class InfectionSite extends $pb.ProtobufEnum {
  static const InfectionSite INFECTION_SITE_UNSPECIFIED =
      InfectionSite._(0, _omitEnumNames ? '' : 'INFECTION_SITE_UNSPECIFIED');

  /// The four device-associated sites are named individually because each has
  /// its own denominator.
  static const InfectionSite INFECTION_SITE_VENTILATOR_ASSOCIATED_PNEUMONIA =
      InfectionSite._(
          1,
          _omitEnumNames
              ? ''
              : 'INFECTION_SITE_VENTILATOR_ASSOCIATED_PNEUMONIA');
  static const InfectionSite INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM =
      InfectionSite._(
          2, _omitEnumNames ? '' : 'INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM');
  static const InfectionSite INFECTION_SITE_CATHETER_ASSOCIATED_URINARY =
      InfectionSite._(3,
          _omitEnumNames ? '' : 'INFECTION_SITE_CATHETER_ASSOCIATED_URINARY');
  static const InfectionSite INFECTION_SITE_SURGICAL_SITE =
      InfectionSite._(4, _omitEnumNames ? '' : 'INFECTION_SITE_SURGICAL_SITE');
  static const InfectionSite INFECTION_SITE_BLOODSTREAM =
      InfectionSite._(5, _omitEnumNames ? '' : 'INFECTION_SITE_BLOODSTREAM');
  static const InfectionSite INFECTION_SITE_RESPIRATORY =
      InfectionSite._(6, _omitEnumNames ? '' : 'INFECTION_SITE_RESPIRATORY');
  static const InfectionSite INFECTION_SITE_URINARY =
      InfectionSite._(7, _omitEnumNames ? '' : 'INFECTION_SITE_URINARY');
  static const InfectionSite INFECTION_SITE_SKIN_SOFT_TISSUE = InfectionSite._(
      8, _omitEnumNames ? '' : 'INFECTION_SITE_SKIN_SOFT_TISSUE');
  static const InfectionSite INFECTION_SITE_GASTROINTESTINAL = InfectionSite._(
      9, _omitEnumNames ? '' : 'INFECTION_SITE_GASTROINTESTINAL');
  static const InfectionSite INFECTION_SITE_OTHER =
      InfectionSite._(10, _omitEnumNames ? '' : 'INFECTION_SITE_OTHER');

  static const $core.List<InfectionSite> values = <InfectionSite>[
    INFECTION_SITE_UNSPECIFIED,
    INFECTION_SITE_VENTILATOR_ASSOCIATED_PNEUMONIA,
    INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM,
    INFECTION_SITE_CATHETER_ASSOCIATED_URINARY,
    INFECTION_SITE_SURGICAL_SITE,
    INFECTION_SITE_BLOODSTREAM,
    INFECTION_SITE_RESPIRATORY,
    INFECTION_SITE_URINARY,
    INFECTION_SITE_SKIN_SOFT_TISSUE,
    INFECTION_SITE_GASTROINTESTINAL,
    INFECTION_SITE_OTHER,
  ];

  static final $core.List<InfectionSite?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static InfectionSite? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const InfectionSite._(super.value, super.name);
}

/// The device a site's denominator counts (SRS-IPC-002).
class DeviceKind extends $pb.ProtobufEnum {
  static const DeviceKind DEVICE_KIND_UNSPECIFIED =
      DeviceKind._(0, _omitEnumNames ? '' : 'DEVICE_KIND_UNSPECIFIED');
  static const DeviceKind DEVICE_KIND_VENTILATOR =
      DeviceKind._(1, _omitEnumNames ? '' : 'DEVICE_KIND_VENTILATOR');
  static const DeviceKind DEVICE_KIND_CENTRAL_LINE =
      DeviceKind._(2, _omitEnumNames ? '' : 'DEVICE_KIND_CENTRAL_LINE');
  static const DeviceKind DEVICE_KIND_URINARY_CATHETER =
      DeviceKind._(3, _omitEnumNames ? '' : 'DEVICE_KIND_URINARY_CATHETER');

  static const $core.List<DeviceKind> values = <DeviceKind>[
    DEVICE_KIND_UNSPECIFIED,
    DEVICE_KIND_VENTILATOR,
    DEVICE_KIND_CENTRAL_LINE,
    DEVICE_KIND_URINARY_CATHETER,
  ];

  static final $core.List<DeviceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DeviceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeviceKind._(super.value, super.name);
}

/// Where a surveillance case stands (SRS-IPC-001).
class CaseState extends $pb.ProtobufEnum {
  static const CaseState CASE_STATE_UNSPECIFIED =
      CaseState._(0, _omitEnumNames ? '' : 'CASE_STATE_UNSPECIFIED');
  static const CaseState CASE_STATE_SUSPECTED =
      CaseState._(1, _omitEnumNames ? '' : 'CASE_STATE_SUSPECTED');
  static const CaseState CASE_STATE_CONFIRMED =
      CaseState._(2, _omitEnumNames ? '' : 'CASE_STATE_CONFIRMED');

  /// Kept rather than deleted: a case the reviewer rejected is evidence about
  /// the definition as much as about the patient.
  static const CaseState CASE_STATE_REFUTED =
      CaseState._(3, _omitEnumNames ? '' : 'CASE_STATE_REFUTED');
  static const CaseState CASE_STATE_CLOSED =
      CaseState._(4, _omitEnumNames ? '' : 'CASE_STATE_CLOSED');

  static const $core.List<CaseState> values = <CaseState>[
    CASE_STATE_UNSPECIFIED,
    CASE_STATE_SUSPECTED,
    CASE_STATE_CONFIRMED,
    CASE_STATE_REFUTED,
    CASE_STATE_CLOSED,
  ];

  static final $core.List<CaseState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CaseState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CaseState._(super.value, super.name);
}

/// What a ward has to do (SRS-IPC-003).
class Precaution extends $pb.ProtobufEnum {
  static const Precaution PRECAUTION_UNSPECIFIED =
      Precaution._(0, _omitEnumNames ? '' : 'PRECAUTION_UNSPECIFIED');
  static const Precaution PRECAUTION_STANDARD =
      Precaution._(1, _omitEnumNames ? '' : 'PRECAUTION_STANDARD');
  static const Precaution PRECAUTION_CONTACT =
      Precaution._(2, _omitEnumNames ? '' : 'PRECAUTION_CONTACT');
  static const Precaution PRECAUTION_DROPLET =
      Precaution._(3, _omitEnumNames ? '' : 'PRECAUTION_DROPLET');
  static const Precaution PRECAUTION_AIRBORNE =
      Precaution._(4, _omitEnumNames ? '' : 'PRECAUTION_AIRBORNE');

  /// Protecting the patient from the ward rather than the ward from the
  /// patient.
  static const Precaution PRECAUTION_PROTECTIVE =
      Precaution._(5, _omitEnumNames ? '' : 'PRECAUTION_PROTECTIVE');

  static const $core.List<Precaution> values = <Precaution>[
    PRECAUTION_UNSPECIFIED,
    PRECAUTION_STANDARD,
    PRECAUTION_CONTACT,
    PRECAUTION_DROPLET,
    PRECAUTION_AIRBORNE,
    PRECAUTION_PROTECTIVE,
  ];

  static final $core.List<Precaution?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Precaution? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Precaution._(super.value, super.name);
}

/// Where a cluster investigation stands (SRS-IPC-005).
class OutbreakState extends $pb.ProtobufEnum {
  static const OutbreakState OUTBREAK_STATE_UNSPECIFIED =
      OutbreakState._(0, _omitEnumNames ? '' : 'OUTBREAK_STATE_UNSPECIFIED');
  static const OutbreakState OUTBREAK_STATE_SUSPECTED =
      OutbreakState._(1, _omitEnumNames ? '' : 'OUTBREAK_STATE_SUSPECTED');
  static const OutbreakState OUTBREAK_STATE_DECLARED =
      OutbreakState._(2, _omitEnumNames ? '' : 'OUTBREAK_STATE_DECLARED');
  static const OutbreakState OUTBREAK_STATE_CONTAINED =
      OutbreakState._(3, _omitEnumNames ? '' : 'OUTBREAK_STATE_CONTAINED');
  static const OutbreakState OUTBREAK_STATE_CLOSED =
      OutbreakState._(4, _omitEnumNames ? '' : 'OUTBREAK_STATE_CLOSED');

  /// Investigated and found not to be a cluster.
  static const OutbreakState OUTBREAK_STATE_REFUTED =
      OutbreakState._(5, _omitEnumNames ? '' : 'OUTBREAK_STATE_REFUTED');

  static const $core.List<OutbreakState> values = <OutbreakState>[
    OUTBREAK_STATE_UNSPECIFIED,
    OUTBREAK_STATE_SUSPECTED,
    OUTBREAK_STATE_DECLARED,
    OUTBREAK_STATE_CONTAINED,
    OUTBREAK_STATE_CLOSED,
    OUTBREAK_STATE_REFUTED,
  ];

  static final $core.List<OutbreakState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static OutbreakState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OutbreakState._(super.value, super.name);
}

/// Why a case is or is not part of a cluster (SRS-IPC-005).
class MembershipReason extends $pb.ProtobufEnum {
  static const MembershipReason MEMBERSHIP_REASON_UNSPECIFIED =
      MembershipReason._(
          0, _omitEnumNames ? '' : 'MEMBERSHIP_REASON_UNSPECIFIED');
  static const MembershipReason MEMBERSHIP_REASON_MEETS_DEFINITION =
      MembershipReason._(
          1, _omitEnumNames ? '' : 'MEMBERSHIP_REASON_MEETS_DEFINITION');

  /// Outside the window or location and linked anyway — a contact, a transfer.
  static const MembershipReason MEMBERSHIP_REASON_EPIDEMIOLOGICAL_LINK =
      MembershipReason._(
          2, _omitEnumNames ? '' : 'MEMBERSHIP_REASON_EPIDEMIOLOGICAL_LINK');
  static const MembershipReason MEMBERSHIP_REASON_EXCLUDED =
      MembershipReason._(3, _omitEnumNames ? '' : 'MEMBERSHIP_REASON_EXCLUDED');

  static const $core.List<MembershipReason> values = <MembershipReason>[
    MEMBERSHIP_REASON_UNSPECIFIED,
    MEMBERSHIP_REASON_MEETS_DEFINITION,
    MEMBERSHIP_REASON_EPIDEMIOLOGICAL_LINK,
    MEMBERSHIP_REASON_EXCLUDED,
  ];

  static final $core.List<MembershipReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MembershipReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MembershipReason._(super.value, super.name);
}

/// The professional group observed (SRS-IPC-006). A category and never a
/// person.
class Discipline extends $pb.ProtobufEnum {
  static const Discipline DISCIPLINE_UNSPECIFIED =
      Discipline._(0, _omitEnumNames ? '' : 'DISCIPLINE_UNSPECIFIED');
  static const Discipline DISCIPLINE_DOCTOR =
      Discipline._(1, _omitEnumNames ? '' : 'DISCIPLINE_DOCTOR');
  static const Discipline DISCIPLINE_NURSE =
      Discipline._(2, _omitEnumNames ? '' : 'DISCIPLINE_NURSE');
  static const Discipline DISCIPLINE_ALLIED_HEALTH =
      Discipline._(3, _omitEnumNames ? '' : 'DISCIPLINE_ALLIED_HEALTH');
  static const Discipline DISCIPLINE_SUPPORT_STAFF =
      Discipline._(4, _omitEnumNames ? '' : 'DISCIPLINE_SUPPORT_STAFF');
  static const Discipline DISCIPLINE_STUDENT =
      Discipline._(5, _omitEnumNames ? '' : 'DISCIPLINE_STUDENT');
  static const Discipline DISCIPLINE_VISITOR =
      Discipline._(6, _omitEnumNames ? '' : 'DISCIPLINE_VISITOR');

  static const $core.List<Discipline> values = <Discipline>[
    DISCIPLINE_UNSPECIFIED,
    DISCIPLINE_DOCTOR,
    DISCIPLINE_NURSE,
    DISCIPLINE_ALLIED_HEALTH,
    DISCIPLINE_SUPPORT_STAFF,
    DISCIPLINE_STUDENT,
    DISCIPLINE_VISITOR,
  ];

  static final $core.List<Discipline?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static Discipline? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Discipline._(super.value, super.name);
}

/// One of the five occasions hand hygiene is expected (SRS-IPC-006).
class Moment extends $pb.ProtobufEnum {
  static const Moment MOMENT_UNSPECIFIED =
      Moment._(0, _omitEnumNames ? '' : 'MOMENT_UNSPECIFIED');
  static const Moment MOMENT_BEFORE_PATIENT_CONTACT =
      Moment._(1, _omitEnumNames ? '' : 'MOMENT_BEFORE_PATIENT_CONTACT');
  static const Moment MOMENT_BEFORE_ASEPTIC_PROCEDURE =
      Moment._(2, _omitEnumNames ? '' : 'MOMENT_BEFORE_ASEPTIC_PROCEDURE');
  static const Moment MOMENT_AFTER_BODY_FLUID_EXPOSURE =
      Moment._(3, _omitEnumNames ? '' : 'MOMENT_AFTER_BODY_FLUID_EXPOSURE');
  static const Moment MOMENT_AFTER_PATIENT_CONTACT =
      Moment._(4, _omitEnumNames ? '' : 'MOMENT_AFTER_PATIENT_CONTACT');
  static const Moment MOMENT_AFTER_PATIENT_SURROUNDINGS =
      Moment._(5, _omitEnumNames ? '' : 'MOMENT_AFTER_PATIENT_SURROUNDINGS');

  static const $core.List<Moment> values = <Moment>[
    MOMENT_UNSPECIFIED,
    MOMENT_BEFORE_PATIENT_CONTACT,
    MOMENT_BEFORE_ASEPTIC_PROCEDURE,
    MOMENT_AFTER_BODY_FLUID_EXPOSURE,
    MOMENT_AFTER_PATIENT_CONTACT,
    MOMENT_AFTER_PATIENT_SURROUNDINGS,
  ];

  static final $core.List<Moment?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static Moment? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Moment._(super.value, super.name);
}

/// What the observer saw (SRS-IPC-006).
class HygieneAction extends $pb.ProtobufEnum {
  static const HygieneAction HYGIENE_ACTION_UNSPECIFIED =
      HygieneAction._(0, _omitEnumNames ? '' : 'HYGIENE_ACTION_UNSPECIFIED');
  static const HygieneAction HYGIENE_ACTION_ALCOHOL_RUB =
      HygieneAction._(1, _omitEnumNames ? '' : 'HYGIENE_ACTION_ALCOHOL_RUB');
  static const HygieneAction HYGIENE_ACTION_SOAP_AND_WATER =
      HygieneAction._(2, _omitEnumNames ? '' : 'HYGIENE_ACTION_SOAP_AND_WATER');
  static const HygieneAction HYGIENE_ACTION_MISSED =
      HygieneAction._(3, _omitEnumNames ? '' : 'HYGIENE_ACTION_MISSED');

  /// Wearing gloves instead of cleaning hands: its own failure, and the
  /// commonest one. Folded into "missed" it would be invisible, and the
  /// training that fixes it is different.
  static const HygieneAction HYGIENE_ACTION_GLOVES_ONLY =
      HygieneAction._(4, _omitEnumNames ? '' : 'HYGIENE_ACTION_GLOVES_ONLY');

  static const $core.List<HygieneAction> values = <HygieneAction>[
    HYGIENE_ACTION_UNSPECIFIED,
    HYGIENE_ACTION_ALCOHOL_RUB,
    HYGIENE_ACTION_SOAP_AND_WATER,
    HYGIENE_ACTION_MISSED,
    HYGIENE_ACTION_GLOVES_ONLY,
  ];

  static final $core.List<HygieneAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static HygieneAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HygieneAction._(super.value, super.name);
}

/// How a member of staff was exposed (SRS-IPC-007).
class ExposureKind extends $pb.ProtobufEnum {
  static const ExposureKind EXPOSURE_KIND_UNSPECIFIED =
      ExposureKind._(0, _omitEnumNames ? '' : 'EXPOSURE_KIND_UNSPECIFIED');
  static const ExposureKind EXPOSURE_KIND_NEEDLESTICK =
      ExposureKind._(1, _omitEnumNames ? '' : 'EXPOSURE_KIND_NEEDLESTICK');
  static const ExposureKind EXPOSURE_KIND_SHARPS =
      ExposureKind._(2, _omitEnumNames ? '' : 'EXPOSURE_KIND_SHARPS');
  static const ExposureKind EXPOSURE_KIND_MUCOCUTANEOUS_SPLASH = ExposureKind._(
      3, _omitEnumNames ? '' : 'EXPOSURE_KIND_MUCOCUTANEOUS_SPLASH');
  static const ExposureKind EXPOSURE_KIND_BITE =
      ExposureKind._(4, _omitEnumNames ? '' : 'EXPOSURE_KIND_BITE');
  static const ExposureKind EXPOSURE_KIND_AIRBORNE_CONTACT =
      ExposureKind._(5, _omitEnumNames ? '' : 'EXPOSURE_KIND_AIRBORNE_CONTACT');

  static const $core.List<ExposureKind> values = <ExposureKind>[
    EXPOSURE_KIND_UNSPECIFIED,
    EXPOSURE_KIND_NEEDLESTICK,
    EXPOSURE_KIND_SHARPS,
    EXPOSURE_KIND_MUCOCUTANEOUS_SPLASH,
    EXPOSURE_KIND_BITE,
    EXPOSURE_KIND_AIRBORNE_CONTACT,
  ];

  static final $core.List<ExposureKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ExposureKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExposureKind._(super.value, super.name);
}

/// Where one time-sensitive step stands (SRS-IPC-007).
class TaskState extends $pb.ProtobufEnum {
  static const TaskState TASK_STATE_UNSPECIFIED =
      TaskState._(0, _omitEnumNames ? '' : 'TASK_STATE_UNSPECIFIED');
  static const TaskState TASK_STATE_DUE =
      TaskState._(1, _omitEnumNames ? '' : 'TASK_STATE_DUE');
  static const TaskState TASK_STATE_DONE =
      TaskState._(2, _omitEnumNames ? '' : 'TASK_STATE_DONE');
  static const TaskState TASK_STATE_DECLINED =
      TaskState._(3, _omitEnumNames ? '' : 'TASK_STATE_DECLINED');

  /// Ruled out by the assessment: a source known negative, a member of staff
  /// already immune.
  static const TaskState TASK_STATE_NOT_APPLICABLE =
      TaskState._(4, _omitEnumNames ? '' : 'TASK_STATE_NOT_APPLICABLE');

  static const $core.List<TaskState> values = <TaskState>[
    TASK_STATE_UNSPECIFIED,
    TASK_STATE_DUE,
    TASK_STATE_DONE,
    TASK_STATE_DECLINED,
    TASK_STATE_NOT_APPLICABLE,
  ];

  static final $core.List<TaskState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TaskState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskState._(super.value, super.name);
}

/// Why a stewardship review was raised (SRS-IPC-008). Each is a question, and
/// none of them is an instruction.
class TriggerKind extends $pb.ProtobufEnum {
  static const TriggerKind TRIGGER_KIND_UNSPECIFIED =
      TriggerKind._(0, _omitEnumNames ? '' : 'TRIGGER_KIND_UNSPECIFIED');
  static const TriggerKind TRIGGER_KIND_RESTRICTED_AGENT =
      TriggerKind._(1, _omitEnumNames ? '' : 'TRIGGER_KIND_RESTRICTED_AGENT');
  static const TriggerKind TRIGGER_KIND_DURATION =
      TriggerKind._(2, _omitEnumNames ? '' : 'TRIGGER_KIND_DURATION');
  static const TriggerKind TRIGGER_KIND_BUG_DRUG_MISMATCH =
      TriggerKind._(3, _omitEnumNames ? '' : 'TRIGGER_KIND_BUG_DRUG_MISMATCH');
  static const TriggerKind TRIGGER_KIND_DE_ESCALATION =
      TriggerKind._(4, _omitEnumNames ? '' : 'TRIGGER_KIND_DE_ESCALATION');
  static const TriggerKind TRIGGER_KIND_IV_TO_ORAL =
      TriggerKind._(5, _omitEnumNames ? '' : 'TRIGGER_KIND_IV_TO_ORAL');
  static const TriggerKind TRIGGER_KIND_REDUNDANT_COVER =
      TriggerKind._(6, _omitEnumNames ? '' : 'TRIGGER_KIND_REDUNDANT_COVER');

  static const $core.List<TriggerKind> values = <TriggerKind>[
    TRIGGER_KIND_UNSPECIFIED,
    TRIGGER_KIND_RESTRICTED_AGENT,
    TRIGGER_KIND_DURATION,
    TRIGGER_KIND_BUG_DRUG_MISMATCH,
    TRIGGER_KIND_DE_ESCALATION,
    TRIGGER_KIND_IV_TO_ORAL,
    TRIGGER_KIND_REDUNDANT_COVER,
  ];

  static final $core.List<TriggerKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static TriggerKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TriggerKind._(super.value, super.name);
}

/// Where a stewardship review stands (SRS-IPC-008).
class ReviewState extends $pb.ProtobufEnum {
  static const ReviewState REVIEW_STATE_UNSPECIFIED =
      ReviewState._(0, _omitEnumNames ? '' : 'REVIEW_STATE_UNSPECIFIED');
  static const ReviewState REVIEW_STATE_OPEN =
      ReviewState._(1, _omitEnumNames ? '' : 'REVIEW_STATE_OPEN');

  /// Answered by the reviewer. The prescription is unchanged at this point,
  /// always.
  static const ReviewState REVIEW_STATE_ADVISED =
      ReviewState._(2, _omitEnumNames ? '' : 'REVIEW_STATE_ADVISED');
  static const ReviewState REVIEW_STATE_CLOSED =
      ReviewState._(3, _omitEnumNames ? '' : 'REVIEW_STATE_CLOSED');
  static const ReviewState REVIEW_STATE_WITHDRAWN =
      ReviewState._(4, _omitEnumNames ? '' : 'REVIEW_STATE_WITHDRAWN');

  static const $core.List<ReviewState> values = <ReviewState>[
    REVIEW_STATE_UNSPECIFIED,
    REVIEW_STATE_OPEN,
    REVIEW_STATE_ADVISED,
    REVIEW_STATE_CLOSED,
    REVIEW_STATE_WITHDRAWN,
  ];

  static final $core.List<ReviewState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReviewState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReviewState._(super.value, super.name);
}

/// What the reviewer advises (SRS-IPC-008).
class Recommendation extends $pb.ProtobufEnum {
  static const Recommendation RECOMMENDATION_UNSPECIFIED =
      Recommendation._(0, _omitEnumNames ? '' : 'RECOMMENDATION_UNSPECIFIED');
  static const Recommendation RECOMMENDATION_CONTINUE =
      Recommendation._(1, _omitEnumNames ? '' : 'RECOMMENDATION_CONTINUE');
  static const Recommendation RECOMMENDATION_STOP =
      Recommendation._(2, _omitEnumNames ? '' : 'RECOMMENDATION_STOP');
  static const Recommendation RECOMMENDATION_NARROW_SPECTRUM = Recommendation._(
      3, _omitEnumNames ? '' : 'RECOMMENDATION_NARROW_SPECTRUM');
  static const Recommendation RECOMMENDATION_SWITCH_TO_ORAL = Recommendation._(
      4, _omitEnumNames ? '' : 'RECOMMENDATION_SWITCH_TO_ORAL');
  static const Recommendation RECOMMENDATION_CHANGE_DOSE =
      Recommendation._(5, _omitEnumNames ? '' : 'RECOMMENDATION_CHANGE_DOSE');
  static const Recommendation RECOMMENDATION_SEND_CULTURES =
      Recommendation._(6, _omitEnumNames ? '' : 'RECOMMENDATION_SEND_CULTURES');
  static const Recommendation RECOMMENDATION_REFER_TO_INFECTION_SPECIALIST =
      Recommendation._(7,
          _omitEnumNames ? '' : 'RECOMMENDATION_REFER_TO_INFECTION_SPECIALIST');

  static const $core.List<Recommendation> values = <Recommendation>[
    RECOMMENDATION_UNSPECIFIED,
    RECOMMENDATION_CONTINUE,
    RECOMMENDATION_STOP,
    RECOMMENDATION_NARROW_SPECTRUM,
    RECOMMENDATION_SWITCH_TO_ORAL,
    RECOMMENDATION_CHANGE_DOSE,
    RECOMMENDATION_SEND_CULTURES,
    RECOMMENDATION_REFER_TO_INFECTION_SPECIALIST,
  ];

  static final $core.List<Recommendation?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static Recommendation? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Recommendation._(super.value, super.name);
}

/// What the prescriber did about the advice (SRS-IPC-008).
class Response extends $pb.ProtobufEnum {
  static const Response RESPONSE_UNSPECIFIED =
      Response._(0, _omitEnumNames ? '' : 'RESPONSE_UNSPECIFIED');
  static const Response RESPONSE_ACCEPTED =
      Response._(1, _omitEnumNames ? '' : 'RESPONSE_ACCEPTED');
  static const Response RESPONSE_DECLINED =
      Response._(2, _omitEnumNames ? '' : 'RESPONSE_DECLINED');

  /// Taken in part. Counted apart from accepted, because a programme
  /// reporting ninety per cent acceptance where half of it was "we did
  /// something else" is reporting a number that is not true.
  static const Response RESPONSE_MODIFIED =
      Response._(3, _omitEnumNames ? '' : 'RESPONSE_MODIFIED');

  static const $core.List<Response> values = <Response>[
    RESPONSE_UNSPECIFIED,
    RESPONSE_ACCEPTED,
    RESPONSE_DECLINED,
    RESPONSE_MODIFIED,
  ];

  static final $core.List<Response?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Response? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Response._(super.value, super.name);
}

/// What was tested (SRS-IPC-009).
class SampleKind extends $pb.ProtobufEnum {
  static const SampleKind SAMPLE_KIND_UNSPECIFIED =
      SampleKind._(0, _omitEnumNames ? '' : 'SAMPLE_KIND_UNSPECIFIED');
  static const SampleKind SAMPLE_KIND_WATER =
      SampleKind._(1, _omitEnumNames ? '' : 'SAMPLE_KIND_WATER');
  static const SampleKind SAMPLE_KIND_DIALYSIS_WATER =
      SampleKind._(2, _omitEnumNames ? '' : 'SAMPLE_KIND_DIALYSIS_WATER');
  static const SampleKind SAMPLE_KIND_ICE =
      SampleKind._(3, _omitEnumNames ? '' : 'SAMPLE_KIND_ICE');
  static const SampleKind SAMPLE_KIND_AIR_SETTLE_PLATE =
      SampleKind._(4, _omitEnumNames ? '' : 'SAMPLE_KIND_AIR_SETTLE_PLATE');
  static const SampleKind SAMPLE_KIND_AIR_PARTICLE_COUNT =
      SampleKind._(5, _omitEnumNames ? '' : 'SAMPLE_KIND_AIR_PARTICLE_COUNT');
  static const SampleKind SAMPLE_KIND_SURFACE_SWAB =
      SampleKind._(6, _omitEnumNames ? '' : 'SAMPLE_KIND_SURFACE_SWAB');
  static const SampleKind SAMPLE_KIND_ENDOSCOPE_RINSE =
      SampleKind._(7, _omitEnumNames ? '' : 'SAMPLE_KIND_ENDOSCOPE_RINSE');
  static const SampleKind SAMPLE_KIND_VENTILATION_PRESSURE =
      SampleKind._(8, _omitEnumNames ? '' : 'SAMPLE_KIND_VENTILATION_PRESSURE');

  static const $core.List<SampleKind> values = <SampleKind>[
    SAMPLE_KIND_UNSPECIFIED,
    SAMPLE_KIND_WATER,
    SAMPLE_KIND_DIALYSIS_WATER,
    SAMPLE_KIND_ICE,
    SAMPLE_KIND_AIR_SETTLE_PLATE,
    SAMPLE_KIND_AIR_PARTICLE_COUNT,
    SAMPLE_KIND_SURFACE_SWAB,
    SAMPLE_KIND_ENDOSCOPE_RINSE,
    SAMPLE_KIND_VENTILATION_PRESSURE,
  ];

  static final $core.List<SampleKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static SampleKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SampleKind._(super.value, super.name);
}

/// How a result stands against its limit (SRS-IPC-009). Derived from the
/// limit, never supplied.
class Outcome extends $pb.ProtobufEnum {
  static const Outcome OUTCOME_UNSPECIFIED =
      Outcome._(0, _omitEnumNames ? '' : 'OUTCOME_UNSPECIFIED');
  static const Outcome OUTCOME_PASS =
      Outcome._(1, _omitEnumNames ? '' : 'OUTCOME_PASS');

  /// Above the action level and below failure: the point at which a hospital
  /// does something before it has a problem.
  static const Outcome OUTCOME_ACTION_LEVEL =
      Outcome._(2, _omitEnumNames ? '' : 'OUTCOME_ACTION_LEVEL');
  static const Outcome OUTCOME_FAIL =
      Outcome._(3, _omitEnumNames ? '' : 'OUTCOME_FAIL');

  /// No live limit to judge it by. Named rather than passed: a sample nobody
  /// can judge is not a sample that passed.
  static const Outcome OUTCOME_UNASSESSABLE =
      Outcome._(4, _omitEnumNames ? '' : 'OUTCOME_UNASSESSABLE');

  static const $core.List<Outcome> values = <Outcome>[
    OUTCOME_UNSPECIFIED,
    OUTCOME_PASS,
    OUTCOME_ACTION_LEVEL,
    OUTCOME_FAIL,
    OUTCOME_UNASSESSABLE,
  ];

  static final $core.List<Outcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Outcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Outcome._(super.value, super.name);
}

/// Where an environmental sample stands (SRS-IPC-009).
class SampleState extends $pb.ProtobufEnum {
  static const SampleState SAMPLE_STATE_UNSPECIFIED =
      SampleState._(0, _omitEnumNames ? '' : 'SAMPLE_STATE_UNSPECIFIED');
  static const SampleState SAMPLE_STATE_COLLECTED =
      SampleState._(1, _omitEnumNames ? '' : 'SAMPLE_STATE_COLLECTED');
  static const SampleState SAMPLE_STATE_RESULTED =
      SampleState._(2, _omitEnumNames ? '' : 'SAMPLE_STATE_RESULTED');
  static const SampleState SAMPLE_STATE_CLOSED =
      SampleState._(3, _omitEnumNames ? '' : 'SAMPLE_STATE_CLOSED');

  static const $core.List<SampleState> values = <SampleState>[
    SAMPLE_STATE_UNSPECIFIED,
    SAMPLE_STATE_COLLECTED,
    SAMPLE_STATE_RESULTED,
    SAMPLE_STATE_CLOSED,
  ];

  static final $core.List<SampleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SampleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SampleState._(super.value, super.name);
}

/// Where a corrective action stands (SRS-IPC-009).
class ActionState extends $pb.ProtobufEnum {
  static const ActionState ACTION_STATE_UNSPECIFIED =
      ActionState._(0, _omitEnumNames ? '' : 'ACTION_STATE_UNSPECIFIED');
  static const ActionState ACTION_STATE_OPEN =
      ActionState._(1, _omitEnumNames ? '' : 'ACTION_STATE_OPEN');
  static const ActionState ACTION_STATE_DONE =
      ActionState._(2, _omitEnumNames ? '' : 'ACTION_STATE_DONE');

  /// Closed against a repeat sample that passed, not against somebody saying
  /// the tap was flushed.
  static const ActionState ACTION_STATE_VERIFIED =
      ActionState._(3, _omitEnumNames ? '' : 'ACTION_STATE_VERIFIED');

  static const $core.List<ActionState> values = <ActionState>[
    ACTION_STATE_UNSPECIFIED,
    ACTION_STATE_OPEN,
    ACTION_STATE_DONE,
    ACTION_STATE_VERIFIED,
  ];

  static final $core.List<ActionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ActionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ActionState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
