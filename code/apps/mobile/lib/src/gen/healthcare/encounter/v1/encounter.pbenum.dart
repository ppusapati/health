// This is a generated file - do not edit.
//
// Generated from healthcare/encounter/v1/encounter.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// The kind of visit (SRS-ENC-002).
///
/// One model with a class rather than seven models: everything downstream —
/// orders, results, notes, billing — attaches to an encounter and would
/// otherwise have to know about seven of them.
class EncounterClass extends $pb.ProtobufEnum {
  static const EncounterClass ENCOUNTER_CLASS_UNSPECIFIED =
      EncounterClass._(0, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_UNSPECIFIED');
  static const EncounterClass ENCOUNTER_CLASS_OUTPATIENT =
      EncounterClass._(1, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_OUTPATIENT');

  /// The class whose rules bend: it may be started for a patient nobody has
  /// identified yet, and finalised over an incomplete record under the override
  /// SRS-ENC-008 allows.
  static const EncounterClass ENCOUNTER_CLASS_EMERGENCY =
      EncounterClass._(2, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_EMERGENCY');

  /// Spans days and beds. Its start and end are an admission and a discharge,
  /// not a consultation.
  static const EncounterClass ENCOUNTER_CLASS_INPATIENT =
      EncounterClass._(3, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_INPATIENT');
  static const EncounterClass ENCOUNTER_CLASS_DAY_CARE =
      EncounterClass._(4, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_DAY_CARE');

  /// Recorded distinctly because a remote consultation has different consent,
  /// identification and prescribing rules in most jurisdictions.
  static const EncounterClass ENCOUNTER_CLASS_TELEMEDICINE =
      EncounterClass._(5, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_TELEMEDICINE');
  static const EncounterClass ENCOUNTER_CLASS_HOME_CARE =
      EncounterClass._(6, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_HOME_CARE');

  /// A visit for a test with no consultation. It exists because the alternative
  /// is a result with no encounter to hang from, and results without context are
  /// how the wrong patient's film gets reported.
  static const EncounterClass ENCOUNTER_CLASS_DIAGNOSTIC_ONLY =
      EncounterClass._(
          7, _omitEnumNames ? '' : 'ENCOUNTER_CLASS_DIAGNOSTIC_ONLY');

  static const $core.List<EncounterClass> values = <EncounterClass>[
    ENCOUNTER_CLASS_UNSPECIFIED,
    ENCOUNTER_CLASS_OUTPATIENT,
    ENCOUNTER_CLASS_EMERGENCY,
    ENCOUNTER_CLASS_INPATIENT,
    ENCOUNTER_CLASS_DAY_CARE,
    ENCOUNTER_CLASS_TELEMEDICINE,
    ENCOUNTER_CLASS_HOME_CARE,
    ENCOUNTER_CLASS_DIAGNOSTIC_ONLY,
  ];

  static final $core.List<EncounterClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static EncounterClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EncounterClass._(super.value, super.name);
}

/// Where an encounter sits in its life (SRS-ENC-006).
class EncounterStatus extends $pb.ProtobufEnum {
  static const EncounterStatus ENCOUNTER_STATUS_UNSPECIFIED = EncounterStatus._(
      0, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_UNSPECIFIED');

  /// Created but not begun. A scheduled admission is planned days ahead.
  static const EncounterStatus ENCOUNTER_STATUS_PLANNED =
      EncounterStatus._(1, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_PLANNED');
  static const EncounterStatus ENCOUNTER_STATUS_IN_PROGRESS = EncounterStatus._(
      2, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_IN_PROGRESS');

  /// An inpatient temporarily absent. Distinct from discharged because the bed
  /// is still theirs.
  static const EncounterStatus ENCOUNTER_STATUS_ON_LEAVE =
      EncounterStatus._(3, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_ON_LEAVE');

  /// Clinically complete but not yet closed: documentation may still be
  /// outstanding.
  static const EncounterStatus ENCOUNTER_STATUS_FINISHED =
      EncounterStatus._(4, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_FINISHED');

  /// Finished and documented, with a visit summary issued. Later changes are
  /// amendments (SRS-ENC-009).
  static const EncounterStatus ENCOUNTER_STATUS_CLOSED =
      EncounterStatus._(5, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_CLOSED');

  /// A visit that did not happen.
  static const EncounterStatus ENCOUNTER_STATUS_CANCELLED =
      EncounterStatus._(6, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_CANCELLED');

  /// A record that was never true — opened against the wrong patient, most
  /// often. Distinct from cancelled because counting them together would tell a
  /// quality team that patients are cancelling when in fact clerks are
  /// misclicking.
  static const EncounterStatus ENCOUNTER_STATUS_ENTERED_IN_ERROR =
      EncounterStatus._(
          7, _omitEnumNames ? '' : 'ENCOUNTER_STATUS_ENTERED_IN_ERROR');

  static const $core.List<EncounterStatus> values = <EncounterStatus>[
    ENCOUNTER_STATUS_UNSPECIFIED,
    ENCOUNTER_STATUS_PLANNED,
    ENCOUNTER_STATUS_IN_PROGRESS,
    ENCOUNTER_STATUS_ON_LEAVE,
    ENCOUNTER_STATUS_FINISHED,
    ENCOUNTER_STATUS_CLOSED,
    ENCOUNTER_STATUS_CANCELLED,
    ENCOUNTER_STATUS_ENTERED_IN_ERROR,
  ];

  static final $core.List<EncounterStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static EncounterStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EncounterStatus._(super.value, super.name);
}

/// The kind of longitudinal course an episode groups (SRS-ENC-004).
class EpisodeType extends $pb.ProtobufEnum {
  static const EpisodeType EPISODE_TYPE_UNSPECIFIED =
      EpisodeType._(0, _omitEnumNames ? '' : 'EPISODE_TYPE_UNSPECIFIED');
  static const EpisodeType EPISODE_TYPE_PREGNANCY =
      EpisodeType._(1, _omitEnumNames ? '' : 'EPISODE_TYPE_PREGNANCY');
  static const EpisodeType EPISODE_TYPE_ONCOLOGY =
      EpisodeType._(2, _omitEnumNames ? '' : 'EPISODE_TYPE_ONCOLOGY');
  static const EpisodeType EPISODE_TYPE_DIALYSIS =
      EpisodeType._(3, _omitEnumNames ? '' : 'EPISODE_TYPE_DIALYSIS');
  static const EpisodeType EPISODE_TYPE_CHRONIC_DISEASE =
      EpisodeType._(4, _omitEnumNames ? '' : 'EPISODE_TYPE_CHRONIC_DISEASE');
  static const EpisodeType EPISODE_TYPE_REHABILITATION =
      EpisodeType._(5, _omitEnumNames ? '' : 'EPISODE_TYPE_REHABILITATION');
  static const EpisodeType EPISODE_TYPE_SURGICAL_CARE =
      EpisodeType._(6, _omitEnumNames ? '' : 'EPISODE_TYPE_SURGICAL_CARE');

  /// The honest catch-all. Present because the alternative is somebody filing a
  /// course of care under "chronic disease" because there was nowhere else to
  /// put it, which produces a wrong answer rather than a missing one.
  static const EpisodeType EPISODE_TYPE_OTHER =
      EpisodeType._(7, _omitEnumNames ? '' : 'EPISODE_TYPE_OTHER');

  static const $core.List<EpisodeType> values = <EpisodeType>[
    EPISODE_TYPE_UNSPECIFIED,
    EPISODE_TYPE_PREGNANCY,
    EPISODE_TYPE_ONCOLOGY,
    EPISODE_TYPE_DIALYSIS,
    EPISODE_TYPE_CHRONIC_DISEASE,
    EPISODE_TYPE_REHABILITATION,
    EPISODE_TYPE_SURGICAL_CARE,
    EPISODE_TYPE_OTHER,
  ];

  static final $core.List<EpisodeType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static EpisodeType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EpisodeType._(super.value, super.name);
}

class EpisodeStatus extends $pb.ProtobufEnum {
  static const EpisodeStatus EPISODE_STATUS_UNSPECIFIED =
      EpisodeStatus._(0, _omitEnumNames ? '' : 'EPISODE_STATUS_UNSPECIFIED');
  static const EpisodeStatus EPISODE_STATUS_ACTIVE =
      EpisodeStatus._(1, _omitEnumNames ? '' : 'EPISODE_STATUS_ACTIVE');

  /// Paused rather than finished — a course of chemotherapy suspended while the
  /// patient recovers from an infection.
  static const EpisodeStatus EPISODE_STATUS_ON_HOLD =
      EpisodeStatus._(2, _omitEnumNames ? '' : 'EPISODE_STATUS_ON_HOLD');
  static const EpisodeStatus EPISODE_STATUS_FINISHED =
      EpisodeStatus._(3, _omitEnumNames ? '' : 'EPISODE_STATUS_FINISHED');
  static const EpisodeStatus EPISODE_STATUS_CANCELLED =
      EpisodeStatus._(4, _omitEnumNames ? '' : 'EPISODE_STATUS_CANCELLED');

  static const $core.List<EpisodeStatus> values = <EpisodeStatus>[
    EPISODE_STATUS_UNSPECIFIED,
    EPISODE_STATUS_ACTIVE,
    EPISODE_STATUS_ON_HOLD,
    EPISODE_STATUS_FINISHED,
    EPISODE_STATUS_CANCELLED,
  ];

  static final $core.List<EpisodeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EpisodeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EpisodeStatus._(super.value, super.name);
}

/// What somebody does on an encounter (SRS-ENC-005).
///
/// Coarse on purpose: authorization needs to know whether this clinician is
/// looking after this patient, not their exact job title.
class CareTeamRole extends $pb.ProtobufEnum {
  static const CareTeamRole CARE_TEAM_ROLE_UNSPECIFIED =
      CareTeamRole._(0, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_UNSPECIFIED');
  static const CareTeamRole CARE_TEAM_ROLE_ATTENDING =
      CareTeamRole._(1, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_ATTENDING');
  static const CareTeamRole CARE_TEAM_ROLE_CONSULTING =
      CareTeamRole._(2, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_CONSULTING');
  static const CareTeamRole CARE_TEAM_ROLE_NURSE =
      CareTeamRole._(3, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_NURSE');
  static const CareTeamRole CARE_TEAM_ROLE_RESIDENT =
      CareTeamRole._(4, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_RESIDENT');
  static const CareTeamRole CARE_TEAM_ROLE_THERAPIST =
      CareTeamRole._(5, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_THERAPIST');
  static const CareTeamRole CARE_TEAM_ROLE_PHARMACIST =
      CareTeamRole._(6, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_PHARMACIST');
  static const CareTeamRole CARE_TEAM_ROLE_SOCIAL_WORK =
      CareTeamRole._(7, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_SOCIAL_WORK');
  static const CareTeamRole CARE_TEAM_ROLE_ADMITTING =
      CareTeamRole._(8, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_ADMITTING');
  static const CareTeamRole CARE_TEAM_ROLE_DISCHARGING =
      CareTeamRole._(9, _omitEnumNames ? '' : 'CARE_TEAM_ROLE_DISCHARGING');

  static const $core.List<CareTeamRole> values = <CareTeamRole>[
    CARE_TEAM_ROLE_UNSPECIFIED,
    CARE_TEAM_ROLE_ATTENDING,
    CARE_TEAM_ROLE_CONSULTING,
    CARE_TEAM_ROLE_NURSE,
    CARE_TEAM_ROLE_RESIDENT,
    CARE_TEAM_ROLE_THERAPIST,
    CARE_TEAM_ROLE_PHARMACIST,
    CARE_TEAM_ROLE_SOCIAL_WORK,
    CARE_TEAM_ROLE_ADMITTING,
    CARE_TEAM_ROLE_DISCHARGING,
  ];

  static final $core.List<CareTeamRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static CareTeamRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CareTeamRole._(super.value, super.name);
}

/// How sure the clinician is (SRS-ENC-007).
class DiagnosisCertainty extends $pb.ProtobufEnum {
  static const DiagnosisCertainty DIAGNOSIS_CERTAINTY_UNSPECIFIED =
      DiagnosisCertainty._(
          0, _omitEnumNames ? '' : 'DIAGNOSIS_CERTAINTY_UNSPECIFIED');

  /// Most of what is recorded during an admission. A system that made everything
  /// final would produce a discharge summary full of conditions nobody
  /// confirmed.
  static const DiagnosisCertainty DIAGNOSIS_CERTAINTY_PROVISIONAL =
      DiagnosisCertainty._(
          1, _omitEnumNames ? '' : 'DIAGNOSIS_CERTAINTY_PROVISIONAL');
  static const DiagnosisCertainty DIAGNOSIS_CERTAINTY_DIFFERENTIAL =
      DiagnosisCertainty._(
          2, _omitEnumNames ? '' : 'DIAGNOSIS_CERTAINTY_DIFFERENTIAL');
  static const DiagnosisCertainty DIAGNOSIS_CERTAINTY_FINAL =
      DiagnosisCertainty._(
          3, _omitEnumNames ? '' : 'DIAGNOSIS_CERTAINTY_FINAL');

  /// Considered and excluded. Worth keeping: the next clinician needs to know
  /// the question was asked.
  static const DiagnosisCertainty DIAGNOSIS_CERTAINTY_RULED_OUT =
      DiagnosisCertainty._(
          4, _omitEnumNames ? '' : 'DIAGNOSIS_CERTAINTY_RULED_OUT');

  static const $core.List<DiagnosisCertainty> values = <DiagnosisCertainty>[
    DIAGNOSIS_CERTAINTY_UNSPECIFIED,
    DIAGNOSIS_CERTAINTY_PROVISIONAL,
    DIAGNOSIS_CERTAINTY_DIFFERENTIAL,
    DIAGNOSIS_CERTAINTY_FINAL,
    DIAGNOSIS_CERTAINTY_RULED_OUT,
  ];

  static final $core.List<DiagnosisCertainty?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DiagnosisCertainty? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiagnosisCertainty._(super.value, super.name);
}

/// How central a diagnosis is to this encounter (SRS-ENC-007).
class DiagnosisRank extends $pb.ProtobufEnum {
  static const DiagnosisRank DIAGNOSIS_RANK_UNSPECIFIED =
      DiagnosisRank._(0, _omitEnumNames ? '' : 'DIAGNOSIS_RANK_UNSPECIFIED');

  /// The reason the patient is here. At most one per encounter: the rank answers
  /// "what was this visit about", and two answers is no answer.
  static const DiagnosisRank DIAGNOSIS_RANK_PRIMARY =
      DiagnosisRank._(1, _omitEnumNames ? '' : 'DIAGNOSIS_RANK_PRIMARY');
  static const DiagnosisRank DIAGNOSIS_RANK_SECONDARY =
      DiagnosisRank._(2, _omitEnumNames ? '' : 'DIAGNOSIS_RANK_SECONDARY');

  /// Arose during the encounter rather than causing it. Distinguished because a
  /// complication is a quality signal and a secondary diagnosis is not, and
  /// counting them together hides harm.
  static const DiagnosisRank DIAGNOSIS_RANK_COMPLICATION =
      DiagnosisRank._(3, _omitEnumNames ? '' : 'DIAGNOSIS_RANK_COMPLICATION');
  static const DiagnosisRank DIAGNOSIS_RANK_COMORBIDITY =
      DiagnosisRank._(4, _omitEnumNames ? '' : 'DIAGNOSIS_RANK_COMORBIDITY');

  static const $core.List<DiagnosisRank> values = <DiagnosisRank>[
    DIAGNOSIS_RANK_UNSPECIFIED,
    DIAGNOSIS_RANK_PRIMARY,
    DIAGNOSIS_RANK_SECONDARY,
    DIAGNOSIS_RANK_COMPLICATION,
    DIAGNOSIS_RANK_COMORBIDITY,
  ];

  static final $core.List<DiagnosisRank?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DiagnosisRank? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiagnosisRank._(super.value, super.name);
}

/// What a timeline entry is (SRS-ENC-011, SRS-CLN-018).
class TimelineEntryKind extends $pb.ProtobufEnum {
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_UNSPECIFIED =
      TimelineEntryKind._(
          0, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_UNSPECIFIED');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_ENCOUNTER =
      TimelineEntryKind._(
          1, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_ENCOUNTER');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_DIAGNOSIS =
      TimelineEntryKind._(
          2, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_DIAGNOSIS');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_NOTE =
      TimelineEntryKind._(3, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_NOTE');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_OBSERVATION =
      TimelineEntryKind._(
          4, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_OBSERVATION');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_MEDICATION =
      TimelineEntryKind._(
          5, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_MEDICATION');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_PROCEDURE =
      TimelineEntryKind._(
          6, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_PROCEDURE');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_ORDER =
      TimelineEntryKind._(7, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_ORDER');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_DOCUMENT =
      TimelineEntryKind._(
          8, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_DOCUMENT');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_IMAGING =
      TimelineEntryKind._(
          9, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_IMAGING');
  static const TimelineEntryKind TIMELINE_ENTRY_KIND_ALLERGY =
      TimelineEntryKind._(
          10, _omitEnumNames ? '' : 'TIMELINE_ENTRY_KIND_ALLERGY');

  static const $core.List<TimelineEntryKind> values = <TimelineEntryKind>[
    TIMELINE_ENTRY_KIND_UNSPECIFIED,
    TIMELINE_ENTRY_KIND_ENCOUNTER,
    TIMELINE_ENTRY_KIND_DIAGNOSIS,
    TIMELINE_ENTRY_KIND_NOTE,
    TIMELINE_ENTRY_KIND_OBSERVATION,
    TIMELINE_ENTRY_KIND_MEDICATION,
    TIMELINE_ENTRY_KIND_PROCEDURE,
    TIMELINE_ENTRY_KIND_ORDER,
    TIMELINE_ENTRY_KIND_DOCUMENT,
    TIMELINE_ENTRY_KIND_IMAGING,
    TIMELINE_ENTRY_KIND_ALLERGY,
  ];

  static final $core.List<TimelineEntryKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static TimelineEntryKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TimelineEntryKind._(super.value, super.name);
}

/// How tightly an entry is held (SRS-CLN-019).
class Confidentiality extends $pb.ProtobufEnum {
  static const Confidentiality CONFIDENTIALITY_UNSPECIFIED =
      Confidentiality._(0, _omitEnumNames ? '' : 'CONFIDENTIALITY_UNSPECIFIED');
  static const Confidentiality CONFIDENTIALITY_NORMAL =
      Confidentiality._(1, _omitEnumNames ? '' : 'CONFIDENTIALITY_NORMAL');

  /// Needs a narrower role and purpose. Mental health, sexual health,
  /// safeguarding.
  static const Confidentiality CONFIDENTIALITY_RESTRICTED =
      Confidentiality._(2, _omitEnumNames ? '' : 'CONFIDENTIALITY_RESTRICTED');

  /// Visible only to the authoring team unless an emergency is declared and
  /// recorded.
  static const Confidentiality CONFIDENTIALITY_VERY_RESTRICTED =
      Confidentiality._(
          3, _omitEnumNames ? '' : 'CONFIDENTIALITY_VERY_RESTRICTED');

  static const $core.List<Confidentiality> values = <Confidentiality>[
    CONFIDENTIALITY_UNSPECIFIED,
    CONFIDENTIALITY_NORMAL,
    CONFIDENTIALITY_RESTRICTED,
    CONFIDENTIALITY_VERY_RESTRICTED,
  ];

  static final $core.List<Confidentiality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Confidentiality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Confidentiality._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
