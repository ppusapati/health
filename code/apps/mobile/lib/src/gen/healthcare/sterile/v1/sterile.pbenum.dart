// This is a generated file - do not edit.
//
// Generated from healthcare/sterile/v1/sterile.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Where one instrument is in its life (SRS-CSSD-012).
class InstrumentStatus extends $pb.ProtobufEnum {
  static const InstrumentStatus INSTRUMENT_STATUS_UNSPECIFIED =
      InstrumentStatus._(
          0, _omitEnumNames ? '' : 'INSTRUMENT_STATUS_UNSPECIFIED');
  static const InstrumentStatus INSTRUMENT_STATUS_IN_SERVICE =
      InstrumentStatus._(
          1, _omitEnumNames ? '' : 'INSTRUMENT_STATUS_IN_SERVICE');

  /// Away being mended. It cannot be packed, and every tray it belongs to is
  /// short until it comes back.
  static const InstrumentStatus INSTRUMENT_STATUS_IN_REPAIR =
      InstrumentStatus._(
          2, _omitEnumNames ? '' : 'INSTRUMENT_STATUS_IN_REPAIR');

  /// Unaccounted for. Distinct from retired, because a missing instrument may
  /// be inside a patient.
  static const InstrumentStatus INSTRUMENT_STATUS_MISSING =
      InstrumentStatus._(3, _omitEnumNames ? '' : 'INSTRUMENT_STATUS_MISSING');
  static const InstrumentStatus INSTRUMENT_STATUS_RETIRED =
      InstrumentStatus._(4, _omitEnumNames ? '' : 'INSTRUMENT_STATUS_RETIRED');

  static const $core.List<InstrumentStatus> values = <InstrumentStatus>[
    INSTRUMENT_STATUS_UNSPECIFIED,
    INSTRUMENT_STATUS_IN_SERVICE,
    INSTRUMENT_STATUS_IN_REPAIR,
    INSTRUMENT_STATUS_MISSING,
    INSTRUMENT_STATUS_RETIRED,
  ];

  static final $core.List<InstrumentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static InstrumentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const InstrumentStatus._(super.value, super.name);
}

/// A step of reprocessing (SRS-CSSD-002 … 007). The order is the rule.
class Stage extends $pb.ProtobufEnum {
  static const Stage STAGE_UNSPECIFIED =
      Stage._(0, _omitEnumNames ? '' : 'STAGE_UNSPECIFIED');

  /// Begins the chain of custody: a dirty set arriving, scanned and counted.
  static const Stage STAGE_RECEIVED =
      Stage._(1, _omitEnumNames ? '' : 'STAGE_RECEIVED');
  static const Stage STAGE_DECONTAMINATED =
      Stage._(2, _omitEnumNames ? '' : 'STAGE_DECONTAMINATED');
  static const Stage STAGE_WASHED =
      Stage._(3, _omitEnumNames ? '' : 'STAGE_WASHED');

  /// Where a technician looks at each instrument: the step that finds the
  /// crack before it finds the patient.
  static const Stage STAGE_INSPECTED =
      Stage._(4, _omitEnumNames ? '' : 'STAGE_INSPECTED');
  static const Stage STAGE_ASSEMBLED =
      Stage._(5, _omitEnumNames ? '' : 'STAGE_ASSEMBLED');
  static const Stage STAGE_PACKAGED =
      Stage._(6, _omitEnumNames ? '' : 'STAGE_PACKAGED');
  static const Stage STAGE_STERILISED =
      Stage._(7, _omitEnumNames ? '' : 'STAGE_STERILISED');

  /// The authorisation that lets a pack leave. Separate from sterilised,
  /// because a cycle that ran is not a cycle that passed.
  static const Stage STAGE_RELEASED =
      Stage._(8, _omitEnumNames ? '' : 'STAGE_RELEASED');

  static const $core.List<Stage> values = <Stage>[
    STAGE_UNSPECIFIED,
    STAGE_RECEIVED,
    STAGE_DECONTAMINATED,
    STAGE_WASHED,
    STAGE_INSPECTED,
    STAGE_ASSEMBLED,
    STAGE_PACKAGED,
    STAGE_STERILISED,
    STAGE_RELEASED,
  ];

  static final $core.List<Stage?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static Stage? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Stage._(super.value, super.name);
}

/// What the sterilizer reported (SRS-CSSD-006).
class CycleResult extends $pb.ProtobufEnum {
  static const CycleResult CYCLE_RESULT_UNSPECIFIED =
      CycleResult._(0, _omitEnumNames ? '' : 'CYCLE_RESULT_UNSPECIFIED');

  /// A load in the machine. Not a verdict.
  static const CycleResult CYCLE_RESULT_RUNNING =
      CycleResult._(1, _omitEnumNames ? '' : 'CYCLE_RESULT_RUNNING');
  static const CycleResult CYCLE_RESULT_PASSED =
      CycleResult._(2, _omitEnumNames ? '' : 'CYCLE_RESULT_PASSED');
  static const CycleResult CYCLE_RESULT_FAILED =
      CycleResult._(3, _omitEnumNames ? '' : 'CYCLE_RESULT_FAILED');

  /// Stopped part-way: the parameters were never reached rather than missed.
  static const CycleResult CYCLE_RESULT_ABORTED =
      CycleResult._(4, _omitEnumNames ? '' : 'CYCLE_RESULT_ABORTED');

  static const $core.List<CycleResult> values = <CycleResult>[
    CYCLE_RESULT_UNSPECIFIED,
    CYCLE_RESULT_RUNNING,
    CYCLE_RESULT_PASSED,
    CYCLE_RESULT_FAILED,
    CYCLE_RESULT_ABORTED,
  ];

  static final $core.List<CycleResult?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CycleResult? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CycleResult._(super.value, super.name);
}

/// Where a cycle record came from. SRS-CSSD-006 asks for ingestion where the
/// equipment supports it, and a hand-typed record is evidence of a different
/// weight.
class CycleSource extends $pb.ProtobufEnum {
  static const CycleSource CYCLE_SOURCE_UNSPECIFIED =
      CycleSource._(0, _omitEnumNames ? '' : 'CYCLE_SOURCE_UNSPECIFIED');
  static const CycleSource CYCLE_SOURCE_MANUAL =
      CycleSource._(1, _omitEnumNames ? '' : 'CYCLE_SOURCE_MANUAL');
  static const CycleSource CYCLE_SOURCE_INGESTED =
      CycleSource._(2, _omitEnumNames ? '' : 'CYCLE_SOURCE_INGESTED');

  static const $core.List<CycleSource> values = <CycleSource>[
    CYCLE_SOURCE_UNSPECIFIED,
    CYCLE_SOURCE_MANUAL,
    CYCLE_SOURCE_INGESTED,
  ];

  static final $core.List<CycleSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static CycleSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CycleSource._(super.value, super.name);
}

/// What was used to check the load (SRS-CSSD-007).
class IndicatorKind extends $pb.ProtobufEnum {
  static const IndicatorKind INDICATOR_KIND_UNSPECIFIED =
      IndicatorKind._(0, _omitEnumNames ? '' : 'INDICATOR_KIND_UNSPECIFIED');

  /// Changes colour when the conditions were met. Read immediately, and the
  /// weaker evidence.
  static const IndicatorKind INDICATOR_KIND_CHEMICAL =
      IndicatorKind._(1, _omitEnumNames ? '' : 'INDICATOR_KIND_CHEMICAL');

  /// A spore challenge, incubated. The stronger evidence and the slower: a
  /// load released before it reads is a load released on a promise.
  static const IndicatorKind INDICATOR_KIND_BIOLOGICAL =
      IndicatorKind._(2, _omitEnumNames ? '' : 'INDICATOR_KIND_BIOLOGICAL');

  static const $core.List<IndicatorKind> values = <IndicatorKind>[
    INDICATOR_KIND_UNSPECIFIED,
    INDICATOR_KIND_CHEMICAL,
    INDICATOR_KIND_BIOLOGICAL,
  ];

  static final $core.List<IndicatorKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static IndicatorKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IndicatorKind._(super.value, super.name);
}

/// Why a load may not be distributed (SRS-CSSD-007).
class ReleaseRefusal extends $pb.ProtobufEnum {
  static const ReleaseRefusal RELEASE_REFUSAL_UNSPECIFIED =
      ReleaseRefusal._(0, _omitEnumNames ? '' : 'RELEASE_REFUSAL_UNSPECIFIED');
  static const ReleaseRefusal RELEASE_REFUSAL_CYCLE_STILL_RUNNING =
      ReleaseRefusal._(
          1, _omitEnumNames ? '' : 'RELEASE_REFUSAL_CYCLE_STILL_RUNNING');
  static const ReleaseRefusal RELEASE_REFUSAL_CYCLE_DID_NOT_PASS =
      ReleaseRefusal._(
          2, _omitEnumNames ? '' : 'RELEASE_REFUSAL_CYCLE_DID_NOT_PASS');
  static const ReleaseRefusal RELEASE_REFUSAL_NO_CHEMICAL_INDICATOR =
      ReleaseRefusal._(
          3, _omitEnumNames ? '' : 'RELEASE_REFUSAL_NO_CHEMICAL_INDICATOR');
  static const ReleaseRefusal RELEASE_REFUSAL_INDICATOR_FAILED =
      ReleaseRefusal._(
          4, _omitEnumNames ? '' : 'RELEASE_REFUSAL_INDICATOR_FAILED');
  static const ReleaseRefusal RELEASE_REFUSAL_BIOLOGICAL_NOT_READ =
      ReleaseRefusal._(
          5, _omitEnumNames ? '' : 'RELEASE_REFUSAL_BIOLOGICAL_NOT_READ');
  static const ReleaseRefusal RELEASE_REFUSAL_ALREADY_RELEASED =
      ReleaseRefusal._(
          6, _omitEnumNames ? '' : 'RELEASE_REFUSAL_ALREADY_RELEASED');

  static const $core.List<ReleaseRefusal> values = <ReleaseRefusal>[
    RELEASE_REFUSAL_UNSPECIFIED,
    RELEASE_REFUSAL_CYCLE_STILL_RUNNING,
    RELEASE_REFUSAL_CYCLE_DID_NOT_PASS,
    RELEASE_REFUSAL_NO_CHEMICAL_INDICATOR,
    RELEASE_REFUSAL_INDICATOR_FAILED,
    RELEASE_REFUSAL_BIOLOGICAL_NOT_READ,
    RELEASE_REFUSAL_ALREADY_RELEASED,
  ];

  static final $core.List<ReleaseRefusal?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ReleaseRefusal? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReleaseRefusal._(super.value, super.name);
}

/// Where an issued pack has got to (SRS-CSSD-009).
class IssueState extends $pb.ProtobufEnum {
  static const IssueState ISSUE_STATE_UNSPECIFIED =
      IssueState._(0, _omitEnumNames ? '' : 'ISSUE_STATE_UNSPECIFIED');
  static const IssueState ISSUE_STATE_OUT =
      IssueState._(1, _omitEnumNames ? '' : 'ISSUE_STATE_OUT');

  /// Opened for a case. The theatre records its own side of this
  /// (SRS-OT-012); this is the department's.
  static const IssueState ISSUE_STATE_USED =
      IssueState._(2, _omitEnumNames ? '' : 'ISSUE_STATE_USED');
  static const IssueState ISSUE_STATE_RETURNED =
      IssueState._(3, _omitEnumNames ? '' : 'ISSUE_STATE_RETURNED');

  /// Pulled back after a failed indicator or a sterilizer event. It never goes
  /// back on the shelf.
  static const IssueState ISSUE_STATE_RECALLED =
      IssueState._(4, _omitEnumNames ? '' : 'ISSUE_STATE_RECALLED');

  static const $core.List<IssueState> values = <IssueState>[
    ISSUE_STATE_UNSPECIFIED,
    ISSUE_STATE_OUT,
    ISSUE_STATE_USED,
    ISSUE_STATE_RETURNED,
    ISSUE_STATE_RECALLED,
  ];

  static final $core.List<IssueState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static IssueState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IssueState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
