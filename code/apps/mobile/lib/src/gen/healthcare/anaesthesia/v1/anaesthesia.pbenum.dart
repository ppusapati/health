// This is a generated file - do not edit.
//
// Generated from healthcare/anaesthesia/v1/anaesthesia.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How the anaesthetic is given (SRS-ANE-002).
class Technique extends $pb.ProtobufEnum {
  static const Technique TECHNIQUE_UNSPECIFIED =
      Technique._(0, _omitEnumNames ? '' : 'TECHNIQUE_UNSPECIFIED');
  static const Technique TECHNIQUE_GENERAL =
      Technique._(1, _omitEnumNames ? '' : 'TECHNIQUE_GENERAL');
  static const Technique TECHNIQUE_REGIONAL =
      Technique._(2, _omitEnumNames ? '' : 'TECHNIQUE_REGIONAL');
  static const Technique TECHNIQUE_SPINAL =
      Technique._(3, _omitEnumNames ? '' : 'TECHNIQUE_SPINAL');
  static const Technique TECHNIQUE_EPIDURAL =
      Technique._(4, _omitEnumNames ? '' : 'TECHNIQUE_EPIDURAL');
  static const Technique TECHNIQUE_SEDATION =
      Technique._(5, _omitEnumNames ? '' : 'TECHNIQUE_SEDATION');
  static const Technique TECHNIQUE_LOCAL =
      Technique._(6, _omitEnumNames ? '' : 'TECHNIQUE_LOCAL');
  static const Technique TECHNIQUE_COMBINED =
      Technique._(7, _omitEnumNames ? '' : 'TECHNIQUE_COMBINED');

  static const $core.List<Technique> values = <Technique>[
    TECHNIQUE_UNSPECIFIED,
    TECHNIQUE_GENERAL,
    TECHNIQUE_REGIONAL,
    TECHNIQUE_SPINAL,
    TECHNIQUE_EPIDURAL,
    TECHNIQUE_SEDATION,
    TECHNIQUE_LOCAL,
    TECHNIQUE_COMBINED,
  ];

  static final $core.List<Technique?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static Technique? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Technique._(super.value, super.name);
}

/// Where anaesthetic consent has got to (SRS-ANE-001).
class ConsentStatus extends $pb.ProtobufEnum {
  static const ConsentStatus CONSENT_STATUS_UNSPECIFIED =
      ConsentStatus._(0, _omitEnumNames ? '' : 'CONSENT_STATUS_UNSPECIFIED');
  static const ConsentStatus CONSENT_STATUS_OBTAINED =
      ConsentStatus._(1, _omitEnumNames ? '' : 'CONSENT_STATUS_OBTAINED');

  /// The ordinary state of a pre-assessment done in clinic a fortnight before.
  static const ConsentStatus CONSENT_STATUS_PENDING =
      ConsentStatus._(2, _omitEnumNames ? '' : 'CONSENT_STATUS_PENDING');
  static const ConsentStatus CONSENT_STATUS_REFUSED =
      ConsentStatus._(3, _omitEnumNames ? '' : 'CONSENT_STATUS_REFUSED');

  /// An unconscious emergency, where treatment proceeds in the patient's best
  /// interests.
  static const ConsentStatus CONSENT_STATUS_NOT_REQUIRED =
      ConsentStatus._(4, _omitEnumNames ? '' : 'CONSENT_STATUS_NOT_REQUIRED');

  static const $core.List<ConsentStatus> values = <ConsentStatus>[
    CONSENT_STATUS_UNSPECIFIED,
    CONSENT_STATUS_OBTAINED,
    CONSENT_STATUS_PENDING,
    CONSENT_STATUS_REFUSED,
    CONSENT_STATUS_NOT_REQUIRED,
  ];

  static final $core.List<ConsentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ConsentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConsentStatus._(super.value, super.name);
}

/// Where an entry came from (SRS-ANE-005, SRS-ANE-011).
class EntrySource extends $pb.ProtobufEnum {
  static const EntrySource ENTRY_SOURCE_UNSPECIFIED =
      EntrySource._(0, _omitEnumNames ? '' : 'ENTRY_SOURCE_UNSPECIFIED');
  static const EntrySource ENTRY_SOURCE_MANUAL =
      EntrySource._(1, _omitEnumNames ? '' : 'ENTRY_SOURCE_MANUAL');
  static const EntrySource ENTRY_SOURCE_DEVICE =
      EntrySource._(2, _omitEnumNames ? '' : 'ENTRY_SOURCE_DEVICE');

  /// Transcribed from paper after a downtime.
  static const EntrySource ENTRY_SOURCE_IMPORTED =
      EntrySource._(3, _omitEnumNames ? '' : 'ENTRY_SOURCE_IMPORTED');

  static const $core.List<EntrySource> values = <EntrySource>[
    ENTRY_SOURCE_UNSPECIFIED,
    ENTRY_SOURCE_MANUAL,
    ENTRY_SOURCE_DEVICE,
    ENTRY_SOURCE_IMPORTED,
  ];

  static final $core.List<EntrySource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static EntrySource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntrySource._(super.value, super.name);
}

class RecordStatus extends $pb.ProtobufEnum {
  static const RecordStatus RECORD_STATUS_UNSPECIFIED =
      RecordStatus._(0, _omitEnumNames ? '' : 'RECORD_STATUS_UNSPECIFIED');
  static const RecordStatus RECORD_STATUS_OPEN =
      RecordStatus._(1, _omitEnumNames ? '' : 'RECORD_STATUS_OPEN');
  static const RecordStatus RECORD_STATUS_IN_RECOVERY =
      RecordStatus._(2, _omitEnumNames ? '' : 'RECORD_STATUS_IN_RECOVERY');
  static const RecordStatus RECORD_STATUS_CLOSED =
      RecordStatus._(3, _omitEnumNames ? '' : 'RECORD_STATUS_CLOSED');

  static const $core.List<RecordStatus> values = <RecordStatus>[
    RECORD_STATUS_UNSPECIFIED,
    RECORD_STATUS_OPEN,
    RECORD_STATUS_IN_RECOVERY,
    RECORD_STATUS_CLOSED,
  ];

  static final $core.List<RecordStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RecordStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RecordStatus._(super.value, super.name);
}

class FluidDirection extends $pb.ProtobufEnum {
  static const FluidDirection FLUID_DIRECTION_UNSPECIFIED =
      FluidDirection._(0, _omitEnumNames ? '' : 'FLUID_DIRECTION_UNSPECIFIED');
  static const FluidDirection FLUID_DIRECTION_IN =
      FluidDirection._(1, _omitEnumNames ? '' : 'FLUID_DIRECTION_IN');
  static const FluidDirection FLUID_DIRECTION_OUT =
      FluidDirection._(2, _omitEnumNames ? '' : 'FLUID_DIRECTION_OUT');

  static const $core.List<FluidDirection> values = <FluidDirection>[
    FLUID_DIRECTION_UNSPECIFIED,
    FLUID_DIRECTION_IN,
    FLUID_DIRECTION_OUT,
  ];

  static final $core.List<FluidDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static FluidDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FluidDirection._(super.value, super.name);
}

/// Why a patient may not leave recovery (SRS-ANE-008).
class DischargeRefusal extends $pb.ProtobufEnum {
  static const DischargeRefusal DISCHARGE_REFUSAL_UNSPECIFIED =
      DischargeRefusal._(
          0, _omitEnumNames ? '' : 'DISCHARGE_REFUSAL_UNSPECIFIED');

  /// Never overridable: the override exists for a patient who is clinically
  /// ready and scores below a bar, not for one nobody has handed over.
  static const DischargeRefusal DISCHARGE_REFUSAL_NOT_HANDED_OVER =
      DischargeRefusal._(
          1, _omitEnumNames ? '' : 'DISCHARGE_REFUSAL_NOT_HANDED_OVER');
  static const DischargeRefusal DISCHARGE_REFUSAL_NOT_ASSESSED =
      DischargeRefusal._(
          2, _omitEnumNames ? '' : 'DISCHARGE_REFUSAL_NOT_ASSESSED');
  static const DischargeRefusal DISCHARGE_REFUSAL_INCOMPLETE_SCORE =
      DischargeRefusal._(
          3, _omitEnumNames ? '' : 'DISCHARGE_REFUSAL_INCOMPLETE_SCORE');
  static const DischargeRefusal DISCHARGE_REFUSAL_BELOW_THRESHOLD =
      DischargeRefusal._(
          4, _omitEnumNames ? '' : 'DISCHARGE_REFUSAL_BELOW_THRESHOLD');

  static const $core.List<DischargeRefusal> values = <DischargeRefusal>[
    DISCHARGE_REFUSAL_UNSPECIFIED,
    DISCHARGE_REFUSAL_NOT_HANDED_OVER,
    DISCHARGE_REFUSAL_NOT_ASSESSED,
    DISCHARGE_REFUSAL_INCOMPLETE_SCORE,
    DISCHARGE_REFUSAL_BELOW_THRESHOLD,
  ];

  static final $core.List<DischargeRefusal?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DischargeRefusal? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DischargeRefusal._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
