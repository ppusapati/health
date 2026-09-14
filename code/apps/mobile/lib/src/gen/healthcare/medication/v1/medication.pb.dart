// This is a generated file - do not edit.
//
// Generated from healthcare/medication/v1/medication.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'medication.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'medication.pbenum.dart';

/// A coded concept from a terminology.
class Coding extends $pb.GeneratedMessage {
  factory Coding({
    $core.String? system,
    $core.String? version,
    $core.String? code,
    $core.String? display,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (version != null) result.version = version;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    return result;
  }

  Coding._();

  factory Coding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Coding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Coding',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding copyWith(void Function(Coding) updates) =>
      super.copyWith((message) => updates(message as Coding)) as Coding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Coding create() => Coding._();
  @$core.override
  Coding createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Coding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coding>(create);
  static Coding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  /// Pins the release: codes have been reassigned between revisions.
  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  /// A bare code on a screen is a screen clinicians stop reading.
  @$pb.TagNumber(4)
  $core.String get display => $_getSZ(3);
  @$pb.TagNumber(4)
  set display($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplay() => $_clearField(4);
}

/// A measured value with its unit. Inseparable: "5" is a safe dose of one drug
/// and ten times a lethal dose of another.
class Quantity extends $pb.GeneratedMessage {
  factory Quantity({
    $core.double? value,
    $core.String? unit,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    return result;
  }

  Quantity._();

  factory Quantity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Quantity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Quantity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'unit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quantity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quantity copyWith(void Function(Quantity) updates) =>
      super.copyWith((message) => updates(message as Quantity)) as Quantity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Quantity create() => Quantity._();
  @$core.override
  Quantity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Quantity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Quantity>(create);
  static Quantity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unit => $_getSZ(1);
  @$pb.TagNumber(2)
  set unit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnit() => $_clearField(2);
}

class StopCondition extends $pb.GeneratedMessage {
  factory StopCondition({
    StopConditionKind? kind,
    $0.Timestamp? at,
    $core.int? doses,
    $core.String? text,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (at != null) result.at = at;
    if (doses != null) result.doses = doses;
    if (text != null) result.text = text;
    return result;
  }

  StopCondition._();

  factory StopCondition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopCondition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopCondition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aE<StopConditionKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: StopConditionKind.values)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aI(3, _omitFieldNames ? '' : 'doses')
    ..aOS(4, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopCondition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopCondition copyWith(void Function(StopCondition) updates) =>
      super.copyWith((message) => updates(message as StopCondition))
          as StopCondition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopCondition create() => StopCondition._();
  @$core.override
  StopCondition createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopCondition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopCondition>(create);
  static StopCondition? _defaultInstance;

  @$pb.TagNumber(1)
  StopConditionKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(StopConditionKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get at => $_getN(1);
  @$pb.TagNumber(2)
  set at($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get doses => $_getIZ(2);
  @$pb.TagNumber(3)
  set doses($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDoses() => $_has(2);
  @$pb.TagNumber(3)
  void clearDoses() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);
}

/// When a dose is given (SRS-MED-001, SRS-MED-009).
class Timing extends $pb.GeneratedMessage {
  factory Timing({
    $core.String? frequencyText,
    $fixnum.Int64? intervalSeconds,
    $core.Iterable<$core.int>? timesOfDay,
    $core.Iterable<$core.int>? daysOfWeek,
    $core.bool? prn,
    $fixnum.Int64? durationSeconds,
  }) {
    final result = create();
    if (frequencyText != null) result.frequencyText = frequencyText;
    if (intervalSeconds != null) result.intervalSeconds = intervalSeconds;
    if (timesOfDay != null) result.timesOfDay.addAll(timesOfDay);
    if (daysOfWeek != null) result.daysOfWeek.addAll(daysOfWeek);
    if (prn != null) result.prn = prn;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    return result;
  }

  Timing._();

  factory Timing.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Timing.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Timing',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'frequencyText')
    ..aInt64(2, _omitFieldNames ? '' : 'intervalSeconds')
    ..p<$core.int>(3, _omitFieldNames ? '' : 'timesOfDay', $pb.PbFieldType.K3)
    ..p<$core.int>(4, _omitFieldNames ? '' : 'daysOfWeek', $pb.PbFieldType.K3)
    ..aOB(5, _omitFieldNames ? '' : 'prn')
    ..aInt64(6, _omitFieldNames ? '' : 'durationSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timing clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timing copyWith(void Function(Timing) updates) =>
      super.copyWith((message) => updates(message as Timing)) as Timing;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Timing create() => Timing._();
  @$core.override
  Timing createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Timing getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Timing>(create);
  static Timing? _defaultInstance;

  /// The prescriber's own phrase, for display. Never what a schedule is computed
  /// from: "four times daily" is read one way by a pharmacy system and another
  /// by a ward, and the two then disagree about when the patient is due.
  @$pb.TagNumber(1)
  $core.String get frequencyText => $_getSZ(0);
  @$pb.TagNumber(1)
  set frequencyText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrequencyText() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrequencyText() => $_clearField(1);

  /// How often, in seconds. Zero with no times_of_day means once.
  @$pb.TagNumber(2)
  $fixnum.Int64 get intervalSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set intervalSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIntervalSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntervalSeconds() => $_clearField(2);

  /// Minutes after midnight in the facility's zone. A four-times-daily drug is
  /// given on the ward round at 06:00, 12:00, 18:00 and 22:00, not every six
  /// hours from whenever it was prescribed.
  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get timesOfDay => $_getList(2);

  /// 0 = Sunday. Empty means every day. Methotrexate weekly is the case that
  /// makes this load-bearing: given daily it is lethal.
  @$pb.TagNumber(4)
  $pb.PbList<$core.int> get daysOfWeek => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get prn => $_getBF(4);
  @$pb.TagNumber(5)
  set prn($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrn() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrn() => $_clearField(5);

  /// How long one dose takes to give, for an infusion.
  @$pb.TagNumber(6)
  $fixnum.Int64 get durationSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDurationSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearDurationSeconds() => $_clearField(6);
}

/// One stretch of the schedule at one dose (SRS-MED-009).
///
/// A simple prescription is one segment; a taper is several. The requirement is
/// explicit that the segments are explicit: "reduce by 5mg weekly" is a sentence
/// a nurse has to compute from, and every party computing separately is how a
/// steroid taper ends up with two different doses on the same day.
class DoseSegment extends $pb.GeneratedMessage {
  factory DoseSegment({
    $core.int? sequence,
    Quantity? dose,
    $core.String? freeTextDose,
    Timing? timing,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $core.String? note,
  }) {
    final result = create();
    if (sequence != null) result.sequence = sequence;
    if (dose != null) result.dose = dose;
    if (freeTextDose != null) result.freeTextDose = freeTextDose;
    if (timing != null) result.timing = timing;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (note != null) result.note = note;
    return result;
  }

  DoseSegment._();

  factory DoseSegment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DoseSegment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DoseSegment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sequence')
    ..aOM<Quantity>(2, _omitFieldNames ? '' : 'dose',
        subBuilder: Quantity.create)
    ..aOS(3, _omitFieldNames ? '' : 'freeTextDose')
    ..aOM<Timing>(4, _omitFieldNames ? '' : 'timing', subBuilder: Timing.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoseSegment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoseSegment copyWith(void Function(DoseSegment) updates) =>
      super.copyWith((message) => updates(message as DoseSegment))
          as DoseSegment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DoseSegment create() => DoseSegment._();
  @$core.override
  DoseSegment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DoseSegment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DoseSegment>(create);
  static DoseSegment? _defaultInstance;

  /// Contiguous from 1. A gap is a step somebody meant to write and did not.
  @$pb.TagNumber(1)
  $core.int get sequence => $_getIZ(0);
  @$pb.TagNumber(1)
  set sequence($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  Quantity get dose => $_getN(1);
  @$pb.TagNumber(2)
  set dose(Quantity value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDose() => $_has(1);
  @$pb.TagNumber(2)
  void clearDose() => $_clearField(2);
  @$pb.TagNumber(2)
  Quantity ensureDose() => $_ensure(1);

  /// A dose that could not be structured — "apply sparingly", "titrate to
  /// effect". Allowed, except for classes the tenant has configured as requiring
  /// structure (SRS-MED-010).
  @$pb.TagNumber(3)
  $core.String get freeTextDose => $_getSZ(2);
  @$pb.TagNumber(3)
  set freeTextDose($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFreeTextDose() => $_has(2);
  @$pb.TagNumber(3)
  void clearFreeTextDose() => $_clearField(3);

  @$pb.TagNumber(4)
  Timing get timing => $_getN(3);
  @$pb.TagNumber(4)
  set timing(Timing value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTiming() => $_has(3);
  @$pb.TagNumber(4)
  void clearTiming() => $_clearField(4);
  @$pb.TagNumber(4)
  Timing ensureTiming() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get startsAt => $_getN(4);
  @$pb.TagNumber(5)
  set startsAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStartsAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartsAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureStartsAt() => $_ensure(4);

  /// Zero on the last segment, where the stop condition takes over.
  @$pb.TagNumber(6)
  $0.Timestamp get endsAt => $_getN(5);
  @$pb.TagNumber(6)
  set endsAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEndsAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndsAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureEndsAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);
}

/// What bounds an as-needed medication (SRS-MED-008).
///
/// Structured, because the acceptance criterion is "where structured": a PRN
/// written as "one or two as required" cannot be enforced by anything.
class PrnConstraint extends $pb.GeneratedMessage {
  factory PrnConstraint({
    $core.String? indication,
    $fixnum.Int64? minIntervalSeconds,
    $core.int? maxDoses,
    Quantity? maxDoseTotal,
    $fixnum.Int64? periodSeconds,
  }) {
    final result = create();
    if (indication != null) result.indication = indication;
    if (minIntervalSeconds != null)
      result.minIntervalSeconds = minIntervalSeconds;
    if (maxDoses != null) result.maxDoses = maxDoses;
    if (maxDoseTotal != null) result.maxDoseTotal = maxDoseTotal;
    if (periodSeconds != null) result.periodSeconds = periodSeconds;
    return result;
  }

  PrnConstraint._();

  factory PrnConstraint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrnConstraint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrnConstraint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'indication')
    ..aInt64(2, _omitFieldNames ? '' : 'minIntervalSeconds')
    ..aI(3, _omitFieldNames ? '' : 'maxDoses')
    ..aOM<Quantity>(4, _omitFieldNames ? '' : 'maxDoseTotal',
        subBuilder: Quantity.create)
    ..aInt64(5, _omitFieldNames ? '' : 'periodSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrnConstraint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrnConstraint copyWith(void Function(PrnConstraint) updates) =>
      super.copyWith((message) => updates(message as PrnConstraint))
          as PrnConstraint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrnConstraint create() => PrnConstraint._();
  @$core.override
  PrnConstraint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrnConstraint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrnConstraint>(create);
  static PrnConstraint? _defaultInstance;

  /// Why the nurse would give it. Mandatory on a PRN.
  @$pb.TagNumber(1)
  $core.String get indication => $_getSZ(0);
  @$pb.TagNumber(1)
  set indication($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndication() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndication() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get minIntervalSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set minIntervalSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinIntervalSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinIntervalSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxDoses => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxDoses($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxDoses() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxDoses() => $_clearField(3);

  /// A ceiling on the summed amount — four grams of paracetamol, whatever the
  /// number of tablets that took.
  @$pb.TagNumber(4)
  Quantity get maxDoseTotal => $_getN(3);
  @$pb.TagNumber(4)
  set maxDoseTotal(Quantity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxDoseTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxDoseTotal() => $_clearField(4);
  @$pb.TagNumber(4)
  Quantity ensureMaxDoseTotal() => $_ensure(3);

  /// What the maxima are measured over. Defaults to 24 hours.
  @$pb.TagNumber(5)
  $fixnum.Int64 get periodSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set periodSeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodSeconds() => $_clearField(5);
}

/// One thing the rules noticed (SRS-MED-002, SRS-MED-003, SRS-MED-004).
class SafetyFinding extends $pb.GeneratedMessage {
  factory SafetyFinding({
    FindingKind? kind,
    Severity? severity,
    $core.String? ruleId,
    $core.String? ruleVersion,
    $core.String? summary,
    $core.Iterable<Coding>? subjects,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? inputs,
    Override? override,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (severity != null) result.severity = severity;
    if (ruleId != null) result.ruleId = ruleId;
    if (ruleVersion != null) result.ruleVersion = ruleVersion;
    if (summary != null) result.summary = summary;
    if (subjects != null) result.subjects.addAll(subjects);
    if (inputs != null) result.inputs.addEntries(inputs);
    if (override != null) result.override = override;
    return result;
  }

  SafetyFinding._();

  factory SafetyFinding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SafetyFinding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SafetyFinding',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aE<FindingKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: FindingKind.values)
    ..aE<Severity>(2, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aOS(3, _omitFieldNames ? '' : 'ruleId')
    ..aOS(4, _omitFieldNames ? '' : 'ruleVersion')
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..pPM<Coding>(6, _omitFieldNames ? '' : 'subjects',
        subBuilder: Coding.create)
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'inputs',
        entryClassName: 'SafetyFinding.InputsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('healthcare.medication.v1'))
    ..aOM<Override>(8, _omitFieldNames ? '' : 'override',
        subBuilder: Override.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyFinding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyFinding copyWith(void Function(SafetyFinding) updates) =>
      super.copyWith((message) => updates(message as SafetyFinding))
          as SafetyFinding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SafetyFinding create() => SafetyFinding._();
  @$core.override
  SafetyFinding createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SafetyFinding getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SafetyFinding>(create);
  static SafetyFinding? _defaultInstance;

  @$pb.TagNumber(1)
  FindingKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(FindingKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  Severity get severity => $_getN(1);
  @$pb.TagNumber(2)
  set severity(Severity value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSeverity() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeverity() => $_clearField(2);

  /// Both required. A finding that cannot say which edition of which rule
  /// produced it is one nobody can reproduce, defend or retire.
  @$pb.TagNumber(3)
  $core.String get ruleId => $_getSZ(2);
  @$pb.TagNumber(3)
  set ruleId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuleId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuleId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ruleVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set ruleVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRuleVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearRuleVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get summary => $_getSZ(4);
  @$pb.TagNumber(5)
  set summary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummary() => $_clearField(5);

  /// The medications or allergens the finding is about. A warning that says a
  /// conflict exists without naming it is one nobody can act on.
  @$pb.TagNumber(6)
  $pb.PbList<Coding> get subjects => $_getList(5);

  /// What the rule was evaluated against, for SRS-MED-004's "inputs are shown":
  /// a dose recommendation computed from a creatinine clearance of 22 is a
  /// different claim from one computed from 62.
  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get inputs => $_getMap(6);

  @$pb.TagNumber(8)
  Override get override => $_getN(7);
  @$pb.TagNumber(8)
  set override(Override value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOverride() => $_has(7);
  @$pb.TagNumber(8)
  void clearOverride() => $_clearField(8);
  @$pb.TagNumber(8)
  Override ensureOverride() => $_ensure(7);
}

class Override extends $pb.GeneratedMessage {
  factory Override({
    $core.String? by,
    $0.Timestamp? at,
    $core.String? reason,
  }) {
    final result = create();
    if (by != null) result.by = by;
    if (at != null) result.at = at;
    if (reason != null) result.reason = reason;
    return result;
  }

  Override._();

  factory Override.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Override.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Override',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'by')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Override clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Override copyWith(void Function(Override) updates) =>
      super.copyWith((message) => updates(message as Override)) as Override;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Override create() => Override._();
  @$core.override
  Override createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Override getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Override>(create);
  static Override? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get by => $_getSZ(0);
  @$pb.TagNumber(1)
  set by($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBy() => $_has(0);
  @$pb.TagNumber(1)
  void clearBy() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get at => $_getN(1);
  @$pb.TagNumber(2)
  set at($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class FormularyDecision extends $pb.GeneratedMessage {
  factory FormularyDecision({
    FormularyStatus? status,
    $core.String? scope,
    $core.String? scopeId,
    $core.String? restriction,
    $core.String? approvalPath,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (scope != null) result.scope = scope;
    if (scopeId != null) result.scopeId = scopeId;
    if (restriction != null) result.restriction = restriction;
    if (approvalPath != null) result.approvalPath = approvalPath;
    return result;
  }

  FormularyDecision._();

  factory FormularyDecision.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FormularyDecision.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FormularyDecision',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aE<FormularyStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: FormularyStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'scope')
    ..aOS(3, _omitFieldNames ? '' : 'scopeId')
    ..aOS(4, _omitFieldNames ? '' : 'restriction')
    ..aOS(5, _omitFieldNames ? '' : 'approvalPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormularyDecision clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormularyDecision copyWith(void Function(FormularyDecision) updates) =>
      super.copyWith((message) => updates(message as FormularyDecision))
          as FormularyDecision;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormularyDecision create() => FormularyDecision._();
  @$core.override
  FormularyDecision createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FormularyDecision getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FormularyDecision>(create);
  static FormularyDecision? _defaultInstance;

  @$pb.TagNumber(1)
  FormularyStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(FormularyStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scope => $_getSZ(1);
  @$pb.TagNumber(2)
  set scope($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScope() => $_has(1);
  @$pb.TagNumber(2)
  void clearScope() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get restriction => $_getSZ(3);
  @$pb.TagNumber(4)
  set restriction($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRestriction() => $_has(3);
  @$pb.TagNumber(4)
  void clearRestriction() => $_clearField(4);

  /// Where the clinician goes to get this approved.
  @$pb.TagNumber(5)
  $core.String get approvalPath => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvalPath($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasApprovalPath() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovalPath() => $_clearField(5);
}

class Verification extends $pb.GeneratedMessage {
  factory Verification({
    $core.String? by,
    $0.Timestamp? at,
    $core.String? note,
  }) {
    final result = create();
    if (by != null) result.by = by;
    if (at != null) result.at = at;
    if (note != null) result.note = note;
    return result;
  }

  Verification._();

  factory Verification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Verification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Verification',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'by')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Verification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Verification copyWith(void Function(Verification) updates) =>
      super.copyWith((message) => updates(message as Verification))
          as Verification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Verification create() => Verification._();
  @$core.override
  Verification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Verification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Verification>(create);
  static Verification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get by => $_getSZ(0);
  @$pb.TagNumber(1)
  set by($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBy() => $_has(0);
  @$pb.TagNumber(1)
  void clearBy() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get at => $_getN(1);
  @$pb.TagNumber(2)
  set at($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

/// One entry in the therapy ledger (SRS-MED-013, SRS-MED-014).
class TherapyChange extends $pb.GeneratedMessage {
  factory TherapyChange({
    TherapyStatus? fromStatus,
    TherapyStatus? toStatus,
    $0.Timestamp? effectiveAt,
    $0.Timestamp? recordedAt,
    $core.String? changedBy,
    $core.String? reason,
  }) {
    final result = create();
    if (fromStatus != null) result.fromStatus = fromStatus;
    if (toStatus != null) result.toStatus = toStatus;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (changedBy != null) result.changedBy = changedBy;
    if (reason != null) result.reason = reason;
    return result;
  }

  TherapyChange._();

  factory TherapyChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TherapyChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TherapyChange',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aE<TherapyStatus>(1, _omitFieldNames ? '' : 'fromStatus',
        enumValues: TherapyStatus.values)
    ..aE<TherapyStatus>(2, _omitFieldNames ? '' : 'toStatus',
        enumValues: TherapyStatus.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'changedBy')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TherapyChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TherapyChange copyWith(void Function(TherapyChange) updates) =>
      super.copyWith((message) => updates(message as TherapyChange))
          as TherapyChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TherapyChange create() => TherapyChange._();
  @$core.override
  TherapyChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TherapyChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TherapyChange>(create);
  static TherapyChange? _defaultInstance;

  @$pb.TagNumber(1)
  TherapyStatus get fromStatus => $_getN(0);
  @$pb.TagNumber(1)
  set fromStatus(TherapyStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  TherapyStatus get toStatus => $_getN(1);
  @$pb.TagNumber(2)
  set toStatus(TherapyStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasToStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearToStatus() => $_clearField(2);

  /// When it took effect clinically, which is not when it was typed.
  @$pb.TagNumber(3)
  $0.Timestamp get effectiveAt => $_getN(2);
  @$pb.TagNumber(3)
  set effectiveAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEffectiveAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearEffectiveAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureEffectiveAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get recordedAt => $_getN(3);
  @$pb.TagNumber(4)
  set recordedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureRecordedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get changedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set changedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasChangedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearChangedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);
}

/// One medication a patient is on (SRS-MED-001).
class Prescription extends $pb.GeneratedMessage {
  factory Prescription({
    $core.String? prescriptionId,
    $core.String? orderId,
    $core.String? orderNumber,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? prescriberId,
    $core.String? enteredById,
    Coding? ingredient,
    Coding? product,
    $core.String? route,
    $core.Iterable<DoseSegment>? segments,
    $0.Timestamp? startsAt,
    StopCondition? stop,
    $core.String? indication,
    Coding? indicationCode,
    $core.String? instructions,
    PrnConstraint? prn,
    TherapyStatus? therapyStatus,
    $core.Iterable<TherapyChange>? changes,
    $0.Timestamp? effectiveStop,
    $core.Iterable<SafetyFinding>? findings,
    FormularyDecision? formulary,
    Verification? verification,
    $core.String? description,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (orderId != null) result.orderId = orderId;
    if (orderNumber != null) result.orderNumber = orderNumber;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (prescriberId != null) result.prescriberId = prescriberId;
    if (enteredById != null) result.enteredById = enteredById;
    if (ingredient != null) result.ingredient = ingredient;
    if (product != null) result.product = product;
    if (route != null) result.route = route;
    if (segments != null) result.segments.addAll(segments);
    if (startsAt != null) result.startsAt = startsAt;
    if (stop != null) result.stop = stop;
    if (indication != null) result.indication = indication;
    if (indicationCode != null) result.indicationCode = indicationCode;
    if (instructions != null) result.instructions = instructions;
    if (prn != null) result.prn = prn;
    if (therapyStatus != null) result.therapyStatus = therapyStatus;
    if (changes != null) result.changes.addAll(changes);
    if (effectiveStop != null) result.effectiveStop = effectiveStop;
    if (findings != null) result.findings.addAll(findings);
    if (formulary != null) result.formulary = formulary;
    if (verification != null) result.verification = verification;
    if (description != null) result.description = description;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    return result;
  }

  Prescription._();

  factory Prescription.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Prescription.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Prescription',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prescriptionId')
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..aOS(3, _omitFieldNames ? '' : 'orderNumber')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'encounterId')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aOS(7, _omitFieldNames ? '' : 'prescriberId')
    ..aOS(8, _omitFieldNames ? '' : 'enteredById')
    ..aOM<Coding>(9, _omitFieldNames ? '' : 'ingredient',
        subBuilder: Coding.create)
    ..aOM<Coding>(10, _omitFieldNames ? '' : 'product',
        subBuilder: Coding.create)
    ..aOS(11, _omitFieldNames ? '' : 'route')
    ..pPM<DoseSegment>(12, _omitFieldNames ? '' : 'segments',
        subBuilder: DoseSegment.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<StopCondition>(14, _omitFieldNames ? '' : 'stop',
        subBuilder: StopCondition.create)
    ..aOS(15, _omitFieldNames ? '' : 'indication')
    ..aOM<Coding>(16, _omitFieldNames ? '' : 'indicationCode',
        subBuilder: Coding.create)
    ..aOS(17, _omitFieldNames ? '' : 'instructions')
    ..aOM<PrnConstraint>(18, _omitFieldNames ? '' : 'prn',
        subBuilder: PrnConstraint.create)
    ..aE<TherapyStatus>(19, _omitFieldNames ? '' : 'therapyStatus',
        enumValues: TherapyStatus.values)
    ..pPM<TherapyChange>(20, _omitFieldNames ? '' : 'changes',
        subBuilder: TherapyChange.create)
    ..aOM<$0.Timestamp>(21, _omitFieldNames ? '' : 'effectiveStop',
        subBuilder: $0.Timestamp.create)
    ..pPM<SafetyFinding>(22, _omitFieldNames ? '' : 'findings',
        subBuilder: SafetyFinding.create)
    ..aOM<FormularyDecision>(23, _omitFieldNames ? '' : 'formulary',
        subBuilder: FormularyDecision.create)
    ..aOM<Verification>(24, _omitFieldNames ? '' : 'verification',
        subBuilder: Verification.create)
    ..aOS(25, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Timestamp>(26, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(27, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(28, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Prescription clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Prescription copyWith(void Function(Prescription) updates) =>
      super.copyWith((message) => updates(message as Prescription))
          as Prescription;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Prescription create() => Prescription._();
  @$core.override
  Prescription createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Prescription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Prescription>(create);
  static Prescription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prescriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set prescriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescriptionId() => $_clearField(1);

  /// The CPOE order this is the clinical detail of.
  @$pb.TagNumber(2)
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get encounterId => $_getSZ(4);
  @$pb.TagNumber(5)
  set encounterId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEncounterId() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncounterId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get facilityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set facilityId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFacilityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFacilityId() => $_clearField(6);

  /// Who is answerable, and who typed it. A verbal order taken by a nurse is the
  /// doctor's prescription.
  @$pb.TagNumber(7)
  $core.String get prescriberId => $_getSZ(6);
  @$pb.TagNumber(7)
  set prescriberId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPrescriberId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrescriberId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get enteredById => $_getSZ(7);
  @$pb.TagNumber(8)
  set enteredById($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEnteredById() => $_has(7);
  @$pb.TagNumber(8)
  void clearEnteredById() => $_clearField(8);

  @$pb.TagNumber(9)
  Coding get ingredient => $_getN(8);
  @$pb.TagNumber(9)
  set ingredient(Coding value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasIngredient() => $_has(8);
  @$pb.TagNumber(9)
  void clearIngredient() => $_clearField(9);
  @$pb.TagNumber(9)
  Coding ensureIngredient() => $_ensure(8);

  @$pb.TagNumber(10)
  Coding get product => $_getN(9);
  @$pb.TagNumber(10)
  set product(Coding value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasProduct() => $_has(9);
  @$pb.TagNumber(10)
  void clearProduct() => $_clearField(10);
  @$pb.TagNumber(10)
  Coding ensureProduct() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get route => $_getSZ(10);
  @$pb.TagNumber(11)
  set route($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRoute() => $_has(10);
  @$pb.TagNumber(11)
  void clearRoute() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<DoseSegment> get segments => $_getList(11);

  @$pb.TagNumber(13)
  $0.Timestamp get startsAt => $_getN(12);
  @$pb.TagNumber(13)
  set startsAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStartsAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearStartsAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureStartsAt() => $_ensure(12);

  @$pb.TagNumber(14)
  StopCondition get stop => $_getN(13);
  @$pb.TagNumber(14)
  set stop(StopCondition value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasStop() => $_has(13);
  @$pb.TagNumber(14)
  void clearStop() => $_clearField(14);
  @$pb.TagNumber(14)
  StopCondition ensureStop() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get indication => $_getSZ(14);
  @$pb.TagNumber(15)
  set indication($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIndication() => $_has(14);
  @$pb.TagNumber(15)
  void clearIndication() => $_clearField(15);

  @$pb.TagNumber(16)
  Coding get indicationCode => $_getN(15);
  @$pb.TagNumber(16)
  set indicationCode(Coding value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasIndicationCode() => $_has(15);
  @$pb.TagNumber(16)
  void clearIndicationCode() => $_clearField(16);
  @$pb.TagNumber(16)
  Coding ensureIndicationCode() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get instructions => $_getSZ(16);
  @$pb.TagNumber(17)
  set instructions($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasInstructions() => $_has(16);
  @$pb.TagNumber(17)
  void clearInstructions() => $_clearField(17);

  @$pb.TagNumber(18)
  PrnConstraint get prn => $_getN(17);
  @$pb.TagNumber(18)
  set prn(PrnConstraint value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasPrn() => $_has(17);
  @$pb.TagNumber(18)
  void clearPrn() => $_clearField(18);
  @$pb.TagNumber(18)
  PrnConstraint ensurePrn() => $_ensure(17);

  @$pb.TagNumber(19)
  TherapyStatus get therapyStatus => $_getN(18);
  @$pb.TagNumber(19)
  set therapyStatus(TherapyStatus value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasTherapyStatus() => $_has(18);
  @$pb.TagNumber(19)
  void clearTherapyStatus() => $_clearField(19);

  @$pb.TagNumber(20)
  $pb.PbList<TherapyChange> get changes => $_getList(19);

  /// The moment after which no further dose may be given (SRS-MED-007).
  @$pb.TagNumber(21)
  $0.Timestamp get effectiveStop => $_getN(20);
  @$pb.TagNumber(21)
  set effectiveStop($0.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasEffectiveStop() => $_has(20);
  @$pb.TagNumber(21)
  void clearEffectiveStop() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.Timestamp ensureEffectiveStop() => $_ensure(20);

  @$pb.TagNumber(22)
  $pb.PbList<SafetyFinding> get findings => $_getList(21);

  @$pb.TagNumber(23)
  FormularyDecision get formulary => $_getN(22);
  @$pb.TagNumber(23)
  set formulary(FormularyDecision value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasFormulary() => $_has(22);
  @$pb.TagNumber(23)
  void clearFormulary() => $_clearField(23);
  @$pb.TagNumber(23)
  FormularyDecision ensureFormulary() => $_ensure(22);

  @$pb.TagNumber(24)
  Verification get verification => $_getN(23);
  @$pb.TagNumber(24)
  set verification(Verification value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasVerification() => $_has(23);
  @$pb.TagNumber(24)
  void clearVerification() => $_clearField(24);
  @$pb.TagNumber(24)
  Verification ensureVerification() => $_ensure(23);

  /// The prescription as a sentence, composed from the structure so the two
  /// cannot disagree (SRS-MED-001). A client that composed its own would
  /// eventually render the same prescription differently from another client.
  @$pb.TagNumber(25)
  $core.String get description => $_getSZ(24);
  @$pb.TagNumber(25)
  set description($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasDescription() => $_has(24);
  @$pb.TagNumber(25)
  void clearDescription() => $_clearField(25);

  @$pb.TagNumber(26)
  $0.Timestamp get createdAt => $_getN(25);
  @$pb.TagNumber(26)
  set createdAt($0.Timestamp value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasCreatedAt() => $_has(25);
  @$pb.TagNumber(26)
  void clearCreatedAt() => $_clearField(26);
  @$pb.TagNumber(26)
  $0.Timestamp ensureCreatedAt() => $_ensure(25);

  @$pb.TagNumber(27)
  $0.Timestamp get updatedAt => $_getN(26);
  @$pb.TagNumber(27)
  set updatedAt($0.Timestamp value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasUpdatedAt() => $_has(26);
  @$pb.TagNumber(27)
  void clearUpdatedAt() => $_clearField(27);
  @$pb.TagNumber(27)
  $0.Timestamp ensureUpdatedAt() => $_ensure(26);

  @$pb.TagNumber(28)
  $fixnum.Int64 get version => $_getI64(27);
  @$pb.TagNumber(28)
  set version($fixnum.Int64 value) => $_setInt64(27, value);
  @$pb.TagNumber(28)
  $core.bool hasVersion() => $_has(27);
  @$pb.TagNumber(28)
  void clearVersion() => $_clearField(28);
}

/// The clinician's answer to one warning (SRS-MED-003).
///
/// Keyed by rule and subject rather than by an opaque finding identifier: the
/// screen is re-run between the warning being shown and the answer coming back,
/// and an override applied by position would answer whichever warning landed in
/// that slot the second time.
class OverrideAnswer extends $pb.GeneratedMessage {
  factory OverrideAnswer({
    $core.String? ruleId,
    Coding? subject,
    $core.String? reason,
  }) {
    final result = create();
    if (ruleId != null) result.ruleId = ruleId;
    if (subject != null) result.subject = subject;
    if (reason != null) result.reason = reason;
    return result;
  }

  OverrideAnswer._();

  factory OverrideAnswer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideAnswer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideAnswer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOM<Coding>(2, _omitFieldNames ? '' : 'subject',
        subBuilder: Coding.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideAnswer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideAnswer copyWith(void Function(OverrideAnswer) updates) =>
      super.copyWith((message) => updates(message as OverrideAnswer))
          as OverrideAnswer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideAnswer create() => OverrideAnswer._();
  @$core.override
  OverrideAnswer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideAnswer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideAnswer>(create);
  static OverrideAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ruleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ruleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRuleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRuleId() => $_clearField(1);

  @$pb.TagNumber(2)
  Coding get subject => $_getN(1);
  @$pb.TagNumber(2)
  set subject(Coding value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubject() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubject() => $_clearField(2);
  @$pb.TagNumber(2)
  Coding ensureSubject() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class PrescribeRequest extends $pb.GeneratedMessage {
  factory PrescribeRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? ingredient,
    Coding? product,
    $core.String? route,
    $core.Iterable<DoseSegment>? segments,
    $0.Timestamp? startsAt,
    StopCondition? stop,
    $core.String? indication,
    Coding? indicationCode,
    $core.String? instructions,
    PrnConstraint? prn,
    $core.String? enteredById,
    $core.Iterable<OverrideAnswer>? overrides,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (ingredient != null) result.ingredient = ingredient;
    if (product != null) result.product = product;
    if (route != null) result.route = route;
    if (segments != null) result.segments.addAll(segments);
    if (startsAt != null) result.startsAt = startsAt;
    if (stop != null) result.stop = stop;
    if (indication != null) result.indication = indication;
    if (indicationCode != null) result.indicationCode = indicationCode;
    if (instructions != null) result.instructions = instructions;
    if (prn != null) result.prn = prn;
    if (enteredById != null) result.enteredById = enteredById;
    if (overrides != null) result.overrides.addAll(overrides);
    return result;
  }

  PrescribeRequest._();

  factory PrescribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrescribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrescribeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'ingredient',
        subBuilder: Coding.create)
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'product',
        subBuilder: Coding.create)
    ..aOS(5, _omitFieldNames ? '' : 'route')
    ..pPM<DoseSegment>(6, _omitFieldNames ? '' : 'segments',
        subBuilder: DoseSegment.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<StopCondition>(8, _omitFieldNames ? '' : 'stop',
        subBuilder: StopCondition.create)
    ..aOS(9, _omitFieldNames ? '' : 'indication')
    ..aOM<Coding>(10, _omitFieldNames ? '' : 'indicationCode',
        subBuilder: Coding.create)
    ..aOS(11, _omitFieldNames ? '' : 'instructions')
    ..aOM<PrnConstraint>(12, _omitFieldNames ? '' : 'prn',
        subBuilder: PrnConstraint.create)
    ..aOS(13, _omitFieldNames ? '' : 'enteredById')
    ..pPM<OverrideAnswer>(14, _omitFieldNames ? '' : 'overrides',
        subBuilder: OverrideAnswer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrescribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrescribeRequest copyWith(void Function(PrescribeRequest) updates) =>
      super.copyWith((message) => updates(message as PrescribeRequest))
          as PrescribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrescribeRequest create() => PrescribeRequest._();
  @$core.override
  PrescribeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrescribeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrescribeRequest>(create);
  static PrescribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  Coding get ingredient => $_getN(2);
  @$pb.TagNumber(3)
  set ingredient(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIngredient() => $_has(2);
  @$pb.TagNumber(3)
  void clearIngredient() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureIngredient() => $_ensure(2);

  @$pb.TagNumber(4)
  Coding get product => $_getN(3);
  @$pb.TagNumber(4)
  set product(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProduct() => $_has(3);
  @$pb.TagNumber(4)
  void clearProduct() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureProduct() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get route => $_getSZ(4);
  @$pb.TagNumber(5)
  set route($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoute() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoute() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<DoseSegment> get segments => $_getList(5);

  @$pb.TagNumber(7)
  $0.Timestamp get startsAt => $_getN(6);
  @$pb.TagNumber(7)
  set startsAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStartsAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartsAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureStartsAt() => $_ensure(6);

  @$pb.TagNumber(8)
  StopCondition get stop => $_getN(7);
  @$pb.TagNumber(8)
  set stop(StopCondition value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStop() => $_has(7);
  @$pb.TagNumber(8)
  void clearStop() => $_clearField(8);
  @$pb.TagNumber(8)
  StopCondition ensureStop() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get indication => $_getSZ(8);
  @$pb.TagNumber(9)
  set indication($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIndication() => $_has(8);
  @$pb.TagNumber(9)
  void clearIndication() => $_clearField(9);

  @$pb.TagNumber(10)
  Coding get indicationCode => $_getN(9);
  @$pb.TagNumber(10)
  set indicationCode(Coding value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasIndicationCode() => $_has(9);
  @$pb.TagNumber(10)
  void clearIndicationCode() => $_clearField(10);
  @$pb.TagNumber(10)
  Coding ensureIndicationCode() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get instructions => $_getSZ(10);
  @$pb.TagNumber(11)
  set instructions($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInstructions() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstructions() => $_clearField(11);

  @$pb.TagNumber(12)
  PrnConstraint get prn => $_getN(11);
  @$pb.TagNumber(12)
  set prn(PrnConstraint value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPrn() => $_has(11);
  @$pb.TagNumber(12)
  void clearPrn() => $_clearField(12);
  @$pb.TagNumber(12)
  PrnConstraint ensurePrn() => $_ensure(11);

  /// Names the person at the keyboard where that differs from the prescriber.
  @$pb.TagNumber(13)
  $core.String get enteredById => $_getSZ(12);
  @$pb.TagNumber(13)
  set enteredById($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasEnteredById() => $_has(12);
  @$pb.TagNumber(13)
  void clearEnteredById() => $_clearField(13);

  /// Empty on a first attempt, which is how the screen's findings reach the
  /// prescriber.
  @$pb.TagNumber(14)
  $pb.PbList<OverrideAnswer> get overrides => $_getList(13);
}

class PrescribeResponse extends $pb.GeneratedMessage {
  factory PrescribeResponse({
    Prescription? prescription,
  }) {
    final result = create();
    if (prescription != null) result.prescription = prescription;
    return result;
  }

  PrescribeResponse._();

  factory PrescribeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrescribeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrescribeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Prescription>(1, _omitFieldNames ? '' : 'prescription',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrescribeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrescribeResponse copyWith(void Function(PrescribeResponse) updates) =>
      super.copyWith((message) => updates(message as PrescribeResponse))
          as PrescribeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrescribeResponse create() => PrescribeResponse._();
  @$core.override
  PrescribeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrescribeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrescribeResponse>(create);
  static PrescribeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Prescription get prescription => $_getN(0);
  @$pb.TagNumber(1)
  set prescription(Prescription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescription() => $_clearField(1);
  @$pb.TagNumber(1)
  Prescription ensurePrescription() => $_ensure(0);
}

class GetPrescriptionRequest extends $pb.GeneratedMessage {
  factory GetPrescriptionRequest({
    $core.String? prescriptionId,
  }) {
    final result = create();
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    return result;
  }

  GetPrescriptionRequest._();

  factory GetPrescriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPrescriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPrescriptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prescriptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrescriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrescriptionRequest copyWith(
          void Function(GetPrescriptionRequest) updates) =>
      super.copyWith((message) => updates(message as GetPrescriptionRequest))
          as GetPrescriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPrescriptionRequest create() => GetPrescriptionRequest._();
  @$core.override
  GetPrescriptionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPrescriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPrescriptionRequest>(create);
  static GetPrescriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prescriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set prescriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescriptionId() => $_clearField(1);
}

class GetPrescriptionResponse extends $pb.GeneratedMessage {
  factory GetPrescriptionResponse({
    Prescription? prescription,
  }) {
    final result = create();
    if (prescription != null) result.prescription = prescription;
    return result;
  }

  GetPrescriptionResponse._();

  factory GetPrescriptionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPrescriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPrescriptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Prescription>(1, _omitFieldNames ? '' : 'prescription',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrescriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrescriptionResponse copyWith(
          void Function(GetPrescriptionResponse) updates) =>
      super.copyWith((message) => updates(message as GetPrescriptionResponse))
          as GetPrescriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPrescriptionResponse create() => GetPrescriptionResponse._();
  @$core.override
  GetPrescriptionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPrescriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPrescriptionResponse>(create);
  static GetPrescriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Prescription get prescription => $_getN(0);
  @$pb.TagNumber(1)
  set prescription(Prescription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescription() => $_clearField(1);
  @$pb.TagNumber(1)
  Prescription ensurePrescription() => $_ensure(0);
}

class ListPrescriptionsRequest extends $pb.GeneratedMessage {
  factory ListPrescriptionsRequest({
    $core.String? encounterId,
    $core.bool? liveOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (liveOnly != null) result.liveOnly = liveOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPrescriptionsRequest._();

  factory ListPrescriptionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPrescriptionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPrescriptionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOB(2, _omitFieldNames ? '' : 'liveOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrescriptionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrescriptionsRequest copyWith(
          void Function(ListPrescriptionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPrescriptionsRequest))
          as ListPrescriptionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPrescriptionsRequest create() => ListPrescriptionsRequest._();
  @$core.override
  ListPrescriptionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPrescriptionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPrescriptionsRequest>(create);
  static ListPrescriptionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  /// Hides finished medication. Off by default: a chart shows what was
  /// prescribed, not only what is current.
  @$pb.TagNumber(2)
  $core.bool get liveOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set liveOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLiveOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearLiveOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListPrescriptionsResponse extends $pb.GeneratedMessage {
  factory ListPrescriptionsResponse({
    $core.Iterable<Prescription>? prescriptions,
  }) {
    final result = create();
    if (prescriptions != null) result.prescriptions.addAll(prescriptions);
    return result;
  }

  ListPrescriptionsResponse._();

  factory ListPrescriptionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPrescriptionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPrescriptionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..pPM<Prescription>(1, _omitFieldNames ? '' : 'prescriptions',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrescriptionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrescriptionsResponse copyWith(
          void Function(ListPrescriptionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPrescriptionsResponse))
          as ListPrescriptionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPrescriptionsResponse create() => ListPrescriptionsResponse._();
  @$core.override
  ListPrescriptionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPrescriptionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPrescriptionsResponse>(create);
  static ListPrescriptionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Prescription> get prescriptions => $_getList(0);
}

/// Holding, restarting or discontinuing (SRS-MED-013).
class ChangeTherapyRequest extends $pb.GeneratedMessage {
  factory ChangeTherapyRequest({
    $core.String? prescriptionId,
    $core.String? reason,
    $0.Timestamp? effectiveAt,
  }) {
    final result = create();
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (reason != null) result.reason = reason;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    return result;
  }

  ChangeTherapyRequest._();

  factory ChangeTherapyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeTherapyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeTherapyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prescriptionId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTherapyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTherapyRequest copyWith(void Function(ChangeTherapyRequest) updates) =>
      super.copyWith((message) => updates(message as ChangeTherapyRequest))
          as ChangeTherapyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeTherapyRequest create() => ChangeTherapyRequest._();
  @$core.override
  ChangeTherapyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeTherapyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeTherapyRequest>(create);
  static ChangeTherapyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prescriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set prescriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescriptionId() => $_clearField(1);

  /// Mandatory. A drug that stopped for no recorded reason is one nobody can
  /// decide whether to restart, and the person who knows has gone off shift.
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  /// When the change takes effect clinically. Zero means now. A drug stopped on
  /// the ward round at 09:00 and typed at 11:00 stopped at 09:00, and the dose
  /// at 10:00 should not have been given.
  @$pb.TagNumber(3)
  $0.Timestamp get effectiveAt => $_getN(2);
  @$pb.TagNumber(3)
  set effectiveAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEffectiveAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearEffectiveAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureEffectiveAt() => $_ensure(2);
}

class ChangeTherapyResponse extends $pb.GeneratedMessage {
  factory ChangeTherapyResponse({
    Prescription? prescription,
  }) {
    final result = create();
    if (prescription != null) result.prescription = prescription;
    return result;
  }

  ChangeTherapyResponse._();

  factory ChangeTherapyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeTherapyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeTherapyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Prescription>(1, _omitFieldNames ? '' : 'prescription',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTherapyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeTherapyResponse copyWith(
          void Function(ChangeTherapyResponse) updates) =>
      super.copyWith((message) => updates(message as ChangeTherapyResponse))
          as ChangeTherapyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeTherapyResponse create() => ChangeTherapyResponse._();
  @$core.override
  ChangeTherapyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeTherapyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeTherapyResponse>(create);
  static ChangeTherapyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Prescription get prescription => $_getN(0);
  @$pb.TagNumber(1)
  set prescription(Prescription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescription() => $_clearField(1);
  @$pb.TagNumber(1)
  Prescription ensurePrescription() => $_ensure(0);
}

/// One request and response type per RPC, which is what lets any of the three
/// gain a field later without changing the other two: holding a drug for theatre
/// and discontinuing it after a reaction are different acts, and the day one of
/// them needs something the others do not is the day a shared message becomes a
/// breaking change.
class HoldTherapyRequest extends $pb.GeneratedMessage {
  factory HoldTherapyRequest({
    ChangeTherapyRequest? change,
  }) {
    final result = create();
    if (change != null) result.change = change;
    return result;
  }

  HoldTherapyRequest._();

  factory HoldTherapyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldTherapyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldTherapyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<ChangeTherapyRequest>(1, _omitFieldNames ? '' : 'change',
        subBuilder: ChangeTherapyRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldTherapyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldTherapyRequest copyWith(void Function(HoldTherapyRequest) updates) =>
      super.copyWith((message) => updates(message as HoldTherapyRequest))
          as HoldTherapyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldTherapyRequest create() => HoldTherapyRequest._();
  @$core.override
  HoldTherapyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldTherapyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldTherapyRequest>(create);
  static HoldTherapyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChangeTherapyRequest get change => $_getN(0);
  @$pb.TagNumber(1)
  set change(ChangeTherapyRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChange() => $_has(0);
  @$pb.TagNumber(1)
  void clearChange() => $_clearField(1);
  @$pb.TagNumber(1)
  ChangeTherapyRequest ensureChange() => $_ensure(0);
}

class HoldTherapyResponse extends $pb.GeneratedMessage {
  factory HoldTherapyResponse({
    Prescription? prescription,
  }) {
    final result = create();
    if (prescription != null) result.prescription = prescription;
    return result;
  }

  HoldTherapyResponse._();

  factory HoldTherapyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldTherapyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldTherapyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Prescription>(1, _omitFieldNames ? '' : 'prescription',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldTherapyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldTherapyResponse copyWith(void Function(HoldTherapyResponse) updates) =>
      super.copyWith((message) => updates(message as HoldTherapyResponse))
          as HoldTherapyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldTherapyResponse create() => HoldTherapyResponse._();
  @$core.override
  HoldTherapyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldTherapyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldTherapyResponse>(create);
  static HoldTherapyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Prescription get prescription => $_getN(0);
  @$pb.TagNumber(1)
  set prescription(Prescription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescription() => $_clearField(1);
  @$pb.TagNumber(1)
  Prescription ensurePrescription() => $_ensure(0);
}

class RestartTherapyRequest extends $pb.GeneratedMessage {
  factory RestartTherapyRequest({
    ChangeTherapyRequest? change,
  }) {
    final result = create();
    if (change != null) result.change = change;
    return result;
  }

  RestartTherapyRequest._();

  factory RestartTherapyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestartTherapyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestartTherapyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<ChangeTherapyRequest>(1, _omitFieldNames ? '' : 'change',
        subBuilder: ChangeTherapyRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartTherapyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartTherapyRequest copyWith(
          void Function(RestartTherapyRequest) updates) =>
      super.copyWith((message) => updates(message as RestartTherapyRequest))
          as RestartTherapyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestartTherapyRequest create() => RestartTherapyRequest._();
  @$core.override
  RestartTherapyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestartTherapyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestartTherapyRequest>(create);
  static RestartTherapyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChangeTherapyRequest get change => $_getN(0);
  @$pb.TagNumber(1)
  set change(ChangeTherapyRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChange() => $_has(0);
  @$pb.TagNumber(1)
  void clearChange() => $_clearField(1);
  @$pb.TagNumber(1)
  ChangeTherapyRequest ensureChange() => $_ensure(0);
}

class RestartTherapyResponse extends $pb.GeneratedMessage {
  factory RestartTherapyResponse({
    Prescription? prescription,
  }) {
    final result = create();
    if (prescription != null) result.prescription = prescription;
    return result;
  }

  RestartTherapyResponse._();

  factory RestartTherapyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestartTherapyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestartTherapyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Prescription>(1, _omitFieldNames ? '' : 'prescription',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartTherapyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestartTherapyResponse copyWith(
          void Function(RestartTherapyResponse) updates) =>
      super.copyWith((message) => updates(message as RestartTherapyResponse))
          as RestartTherapyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestartTherapyResponse create() => RestartTherapyResponse._();
  @$core.override
  RestartTherapyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestartTherapyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestartTherapyResponse>(create);
  static RestartTherapyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Prescription get prescription => $_getN(0);
  @$pb.TagNumber(1)
  set prescription(Prescription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescription() => $_clearField(1);
  @$pb.TagNumber(1)
  Prescription ensurePrescription() => $_ensure(0);
}

class DiscontinueTherapyRequest extends $pb.GeneratedMessage {
  factory DiscontinueTherapyRequest({
    ChangeTherapyRequest? change,
  }) {
    final result = create();
    if (change != null) result.change = change;
    return result;
  }

  DiscontinueTherapyRequest._();

  factory DiscontinueTherapyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscontinueTherapyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscontinueTherapyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<ChangeTherapyRequest>(1, _omitFieldNames ? '' : 'change',
        subBuilder: ChangeTherapyRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueTherapyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueTherapyRequest copyWith(
          void Function(DiscontinueTherapyRequest) updates) =>
      super.copyWith((message) => updates(message as DiscontinueTherapyRequest))
          as DiscontinueTherapyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscontinueTherapyRequest create() => DiscontinueTherapyRequest._();
  @$core.override
  DiscontinueTherapyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscontinueTherapyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscontinueTherapyRequest>(create);
  static DiscontinueTherapyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChangeTherapyRequest get change => $_getN(0);
  @$pb.TagNumber(1)
  set change(ChangeTherapyRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChange() => $_has(0);
  @$pb.TagNumber(1)
  void clearChange() => $_clearField(1);
  @$pb.TagNumber(1)
  ChangeTherapyRequest ensureChange() => $_ensure(0);
}

class DiscontinueTherapyResponse extends $pb.GeneratedMessage {
  factory DiscontinueTherapyResponse({
    Prescription? prescription,
  }) {
    final result = create();
    if (prescription != null) result.prescription = prescription;
    return result;
  }

  DiscontinueTherapyResponse._();

  factory DiscontinueTherapyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscontinueTherapyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscontinueTherapyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Prescription>(1, _omitFieldNames ? '' : 'prescription',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueTherapyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueTherapyResponse copyWith(
          void Function(DiscontinueTherapyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DiscontinueTherapyResponse))
          as DiscontinueTherapyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscontinueTherapyResponse create() => DiscontinueTherapyResponse._();
  @$core.override
  DiscontinueTherapyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscontinueTherapyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscontinueTherapyResponse>(create);
  static DiscontinueTherapyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Prescription get prescription => $_getN(0);
  @$pb.TagNumber(1)
  set prescription(Prescription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescription() => $_clearField(1);
  @$pb.TagNumber(1)
  Prescription ensurePrescription() => $_ensure(0);
}

class VerifyPrescriptionRequest extends $pb.GeneratedMessage {
  factory VerifyPrescriptionRequest({
    $core.String? prescriptionId,
    $core.String? note,
  }) {
    final result = create();
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (note != null) result.note = note;
    return result;
  }

  VerifyPrescriptionRequest._();

  factory VerifyPrescriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyPrescriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyPrescriptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prescriptionId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPrescriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPrescriptionRequest copyWith(
          void Function(VerifyPrescriptionRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyPrescriptionRequest))
          as VerifyPrescriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyPrescriptionRequest create() => VerifyPrescriptionRequest._();
  @$core.override
  VerifyPrescriptionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyPrescriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyPrescriptionRequest>(create);
  static VerifyPrescriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prescriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set prescriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescriptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class VerifyPrescriptionResponse extends $pb.GeneratedMessage {
  factory VerifyPrescriptionResponse({
    Prescription? prescription,
  }) {
    final result = create();
    if (prescription != null) result.prescription = prescription;
    return result;
  }

  VerifyPrescriptionResponse._();

  factory VerifyPrescriptionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyPrescriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyPrescriptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Prescription>(1, _omitFieldNames ? '' : 'prescription',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPrescriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPrescriptionResponse copyWith(
          void Function(VerifyPrescriptionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyPrescriptionResponse))
          as VerifyPrescriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyPrescriptionResponse create() => VerifyPrescriptionResponse._();
  @$core.override
  VerifyPrescriptionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyPrescriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyPrescriptionResponse>(create);
  static VerifyPrescriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Prescription get prescription => $_getN(0);
  @$pb.TagNumber(1)
  set prescription(Prescription value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescription() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescription() => $_clearField(1);
  @$pb.TagNumber(1)
  Prescription ensurePrescription() => $_ensure(0);
}

class VerificationQueueRequest extends $pb.GeneratedMessage {
  factory VerificationQueueRequest({
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  VerificationQueueRequest._();

  factory VerificationQueueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerificationQueueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerificationQueueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerificationQueueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerificationQueueRequest copyWith(
          void Function(VerificationQueueRequest) updates) =>
      super.copyWith((message) => updates(message as VerificationQueueRequest))
          as VerificationQueueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationQueueRequest create() => VerificationQueueRequest._();
  @$core.override
  VerificationQueueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerificationQueueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerificationQueueRequest>(create);
  static VerificationQueueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class VerificationQueueResponse extends $pb.GeneratedMessage {
  factory VerificationQueueResponse({
    $core.Iterable<Prescription>? prescriptions,
  }) {
    final result = create();
    if (prescriptions != null) result.prescriptions.addAll(prescriptions);
    return result;
  }

  VerificationQueueResponse._();

  factory VerificationQueueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerificationQueueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerificationQueueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..pPM<Prescription>(1, _omitFieldNames ? '' : 'prescriptions',
        subBuilder: Prescription.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerificationQueueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerificationQueueResponse copyWith(
          void Function(VerificationQueueResponse) updates) =>
      super.copyWith((message) => updates(message as VerificationQueueResponse))
          as VerificationQueueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationQueueResponse create() => VerificationQueueResponse._();
  @$core.override
  VerificationQueueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerificationQueueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerificationQueueResponse>(create);
  static VerificationQueueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Prescription> get prescriptions => $_getList(0);
}

/// One scheduled dose (SRS-MED-007).
class DueDose extends $pb.GeneratedMessage {
  factory DueDose({
    $core.String? prescriptionId,
    $core.String? orderId,
    $0.Timestamp? scheduledAt,
    DoseSegment? segment,
  }) {
    final result = create();
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (orderId != null) result.orderId = orderId;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    if (segment != null) result.segment = segment;
    return result;
  }

  DueDose._();

  factory DueDose.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DueDose.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DueDose',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prescriptionId')
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<DoseSegment>(4, _omitFieldNames ? '' : 'segment',
        subBuilder: DoseSegment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDose clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDose copyWith(void Function(DueDose) updates) =>
      super.copyWith((message) => updates(message as DueDose)) as DueDose;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DueDose create() => DueDose._();
  @$core.override
  DueDose createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DueDose getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DueDose>(create);
  static DueDose? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prescriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set prescriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescriptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get scheduledAt => $_getN(2);
  @$pb.TagNumber(3)
  set scheduledAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScheduledAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearScheduledAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureScheduledAt() => $_ensure(2);

  @$pb.TagNumber(4)
  DoseSegment get segment => $_getN(3);
  @$pb.TagNumber(4)
  set segment(DoseSegment value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSegment() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegment() => $_clearField(4);
  @$pb.TagNumber(4)
  DoseSegment ensureSegment() => $_ensure(3);
}

class DueDosesRequest extends $pb.GeneratedMessage {
  factory DueDosesRequest({
    $core.String? encounterId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  DueDosesRequest._();

  factory DueDosesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DueDosesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DueDosesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDosesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDosesRequest copyWith(void Function(DueDosesRequest) updates) =>
      super.copyWith((message) => updates(message as DueDosesRequest))
          as DueDosesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DueDosesRequest create() => DueDosesRequest._();
  @$core.override
  DueDosesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DueDosesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DueDosesRequest>(create);
  static DueDosesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get from => $_getN(1);
  @$pb.TagNumber(2)
  set from($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureFrom() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get to => $_getN(2);
  @$pb.TagNumber(3)
  set to($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTo() => $_ensure(2);
}

class DueDosesResponse extends $pb.GeneratedMessage {
  factory DueDosesResponse({
    $core.Iterable<DueDose>? doses,
  }) {
    final result = create();
    if (doses != null) result.doses.addAll(doses);
    return result;
  }

  DueDosesResponse._();

  factory DueDosesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DueDosesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DueDosesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..pPM<DueDose>(1, _omitFieldNames ? '' : 'doses',
        subBuilder: DueDose.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDosesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDosesResponse copyWith(void Function(DueDosesResponse) updates) =>
      super.copyWith((message) => updates(message as DueDosesResponse))
          as DueDosesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DueDosesResponse create() => DueDosesResponse._();
  @$core.override
  DueDosesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DueDosesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DueDosesResponse>(create);
  static DueDosesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DueDose> get doses => $_getList(0);
}

class ReconciliationItem extends $pb.GeneratedMessage {
  factory ReconciliationItem({
    $core.int? sequence,
    Coding? medication,
    $core.String? doseText,
    $core.String? route,
    HomeMedicationSource? source,
    Disposition? disposition,
    $core.String? rationale,
    $core.String? resultingPrescriptionId,
    $core.String? decidedBy,
    $0.Timestamp? decidedAt,
  }) {
    final result = create();
    if (sequence != null) result.sequence = sequence;
    if (medication != null) result.medication = medication;
    if (doseText != null) result.doseText = doseText;
    if (route != null) result.route = route;
    if (source != null) result.source = source;
    if (disposition != null) result.disposition = disposition;
    if (rationale != null) result.rationale = rationale;
    if (resultingPrescriptionId != null)
      result.resultingPrescriptionId = resultingPrescriptionId;
    if (decidedBy != null) result.decidedBy = decidedBy;
    if (decidedAt != null) result.decidedAt = decidedAt;
    return result;
  }

  ReconciliationItem._();

  factory ReconciliationItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconciliationItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sequence')
    ..aOM<Coding>(2, _omitFieldNames ? '' : 'medication',
        subBuilder: Coding.create)
    ..aOS(3, _omitFieldNames ? '' : 'doseText')
    ..aOS(4, _omitFieldNames ? '' : 'route')
    ..aE<HomeMedicationSource>(5, _omitFieldNames ? '' : 'source',
        enumValues: HomeMedicationSource.values)
    ..aE<Disposition>(6, _omitFieldNames ? '' : 'disposition',
        enumValues: Disposition.values)
    ..aOS(7, _omitFieldNames ? '' : 'rationale')
    ..aOS(8, _omitFieldNames ? '' : 'resultingPrescriptionId')
    ..aOS(9, _omitFieldNames ? '' : 'decidedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'decidedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationItem copyWith(void Function(ReconciliationItem) updates) =>
      super.copyWith((message) => updates(message as ReconciliationItem))
          as ReconciliationItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconciliationItem create() => ReconciliationItem._();
  @$core.override
  ReconciliationItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconciliationItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconciliationItem>(create);
  static ReconciliationItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sequence => $_getIZ(0);
  @$pb.TagNumber(1)
  set sequence($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  Coding get medication => $_getN(1);
  @$pb.TagNumber(2)
  set medication(Coding value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMedication() => $_has(1);
  @$pb.TagNumber(2)
  void clearMedication() => $_clearField(2);
  @$pb.TagNumber(2)
  Coding ensureMedication() => $_ensure(1);

  /// The dose as reported. Free text on purpose: this is what a patient said in
  /// a corridor, and structuring it would claim a precision nobody has.
  @$pb.TagNumber(3)
  $core.String get doseText => $_getSZ(2);
  @$pb.TagNumber(3)
  set doseText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDoseText() => $_has(2);
  @$pb.TagNumber(3)
  void clearDoseText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get route => $_getSZ(3);
  @$pb.TagNumber(4)
  set route($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoute() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoute() => $_clearField(4);

  @$pb.TagNumber(5)
  HomeMedicationSource get source => $_getN(4);
  @$pb.TagNumber(5)
  set source(HomeMedicationSource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  Disposition get disposition => $_getN(5);
  @$pb.TagNumber(6)
  set disposition(Disposition value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDisposition() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisposition() => $_clearField(6);

  /// Mandatory for stop and change, because those are the two that surprise the
  /// next clinician to read the chart.
  @$pb.TagNumber(7)
  $core.String get rationale => $_getSZ(6);
  @$pb.TagNumber(7)
  set rationale($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRationale() => $_has(6);
  @$pb.TagNumber(7)
  void clearRationale() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get resultingPrescriptionId => $_getSZ(7);
  @$pb.TagNumber(8)
  set resultingPrescriptionId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasResultingPrescriptionId() => $_has(7);
  @$pb.TagNumber(8)
  void clearResultingPrescriptionId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get decidedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set decidedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDecidedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearDecidedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get decidedAt => $_getN(9);
  @$pb.TagNumber(10)
  set decidedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDecidedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearDecidedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureDecidedAt() => $_ensure(9);
}

class Reconciliation extends $pb.GeneratedMessage {
  factory Reconciliation({
    $core.String? reconciliationId,
    $core.String? patientId,
    $core.String? encounterId,
    ReconciliationEvent? event,
    $core.Iterable<ReconciliationItem>? items,
    $core.String? startedBy,
    $0.Timestamp? startedAt,
    $core.String? completedBy,
    $0.Timestamp? completedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (reconciliationId != null) result.reconciliationId = reconciliationId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (event != null) result.event = event;
    if (items != null) result.items.addAll(items);
    if (startedBy != null) result.startedBy = startedBy;
    if (startedAt != null) result.startedAt = startedAt;
    if (completedBy != null) result.completedBy = completedBy;
    if (completedAt != null) result.completedAt = completedAt;
    if (version != null) result.version = version;
    return result;
  }

  Reconciliation._();

  factory Reconciliation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reconciliation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reconciliation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reconciliationId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<ReconciliationEvent>(4, _omitFieldNames ? '' : 'event',
        enumValues: ReconciliationEvent.values)
    ..pPM<ReconciliationItem>(5, _omitFieldNames ? '' : 'items',
        subBuilder: ReconciliationItem.create)
    ..aOS(6, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'completedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reconciliation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reconciliation copyWith(void Function(Reconciliation) updates) =>
      super.copyWith((message) => updates(message as Reconciliation))
          as Reconciliation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reconciliation create() => Reconciliation._();
  @$core.override
  Reconciliation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Reconciliation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Reconciliation>(create);
  static Reconciliation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reconciliationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reconciliationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReconciliationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReconciliationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get encounterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set encounterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEncounterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncounterId() => $_clearField(3);

  @$pb.TagNumber(4)
  ReconciliationEvent get event => $_getN(3);
  @$pb.TagNumber(4)
  set event(ReconciliationEvent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEvent() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvent() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ReconciliationItem> get items => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get startedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set startedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStartedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartedBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get startedAt => $_getN(6);
  @$pb.TagNumber(7)
  set startedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStartedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureStartedAt() => $_ensure(6);

  /// Set only once every item has a disposition.
  @$pb.TagNumber(8)
  $core.String get completedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set completedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCompletedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get completedAt => $_getN(8);
  @$pb.TagNumber(9)
  set completedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCompletedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompletedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCompletedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

class StartReconciliationRequest extends $pb.GeneratedMessage {
  factory StartReconciliationRequest({
    $core.String? patientId,
    $core.String? encounterId,
    ReconciliationEvent? event,
    $core.Iterable<ReconciliationItem>? homeMedications,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (event != null) result.event = event;
    if (homeMedications != null) result.homeMedications.addAll(homeMedications);
    return result;
  }

  StartReconciliationRequest._();

  factory StartReconciliationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartReconciliationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartReconciliationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<ReconciliationEvent>(3, _omitFieldNames ? '' : 'event',
        enumValues: ReconciliationEvent.values)
    ..pPM<ReconciliationItem>(4, _omitFieldNames ? '' : 'homeMedications',
        subBuilder: ReconciliationItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartReconciliationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartReconciliationRequest copyWith(
          void Function(StartReconciliationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartReconciliationRequest))
          as StartReconciliationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartReconciliationRequest create() => StartReconciliationRequest._();
  @$core.override
  StartReconciliationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartReconciliationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartReconciliationRequest>(create);
  static StartReconciliationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  ReconciliationEvent get event => $_getN(2);
  @$pb.TagNumber(3)
  set event(ReconciliationEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ReconciliationItem> get homeMedications => $_getList(3);
}

class StartReconciliationResponse extends $pb.GeneratedMessage {
  factory StartReconciliationResponse({
    Reconciliation? reconciliation,
  }) {
    final result = create();
    if (reconciliation != null) result.reconciliation = reconciliation;
    return result;
  }

  StartReconciliationResponse._();

  factory StartReconciliationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartReconciliationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartReconciliationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Reconciliation>(1, _omitFieldNames ? '' : 'reconciliation',
        subBuilder: Reconciliation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartReconciliationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartReconciliationResponse copyWith(
          void Function(StartReconciliationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartReconciliationResponse))
          as StartReconciliationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartReconciliationResponse create() =>
      StartReconciliationResponse._();
  @$core.override
  StartReconciliationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartReconciliationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartReconciliationResponse>(create);
  static StartReconciliationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Reconciliation get reconciliation => $_getN(0);
  @$pb.TagNumber(1)
  set reconciliation(Reconciliation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReconciliation() => $_has(0);
  @$pb.TagNumber(1)
  void clearReconciliation() => $_clearField(1);
  @$pb.TagNumber(1)
  Reconciliation ensureReconciliation() => $_ensure(0);
}

class DecideReconciliationRequest extends $pb.GeneratedMessage {
  factory DecideReconciliationRequest({
    $core.String? reconciliationId,
    $core.int? sequence,
    Disposition? disposition,
    $core.String? rationale,
    $core.String? resultingPrescriptionId,
  }) {
    final result = create();
    if (reconciliationId != null) result.reconciliationId = reconciliationId;
    if (sequence != null) result.sequence = sequence;
    if (disposition != null) result.disposition = disposition;
    if (rationale != null) result.rationale = rationale;
    if (resultingPrescriptionId != null)
      result.resultingPrescriptionId = resultingPrescriptionId;
    return result;
  }

  DecideReconciliationRequest._();

  factory DecideReconciliationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideReconciliationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideReconciliationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reconciliationId')
    ..aI(2, _omitFieldNames ? '' : 'sequence')
    ..aE<Disposition>(3, _omitFieldNames ? '' : 'disposition',
        enumValues: Disposition.values)
    ..aOS(4, _omitFieldNames ? '' : 'rationale')
    ..aOS(5, _omitFieldNames ? '' : 'resultingPrescriptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReconciliationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReconciliationRequest copyWith(
          void Function(DecideReconciliationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DecideReconciliationRequest))
          as DecideReconciliationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideReconciliationRequest create() =>
      DecideReconciliationRequest._();
  @$core.override
  DecideReconciliationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideReconciliationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideReconciliationRequest>(create);
  static DecideReconciliationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reconciliationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reconciliationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReconciliationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReconciliationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get sequence => $_getIZ(1);
  @$pb.TagNumber(2)
  set sequence($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  Disposition get disposition => $_getN(2);
  @$pb.TagNumber(3)
  set disposition(Disposition value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDisposition() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisposition() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get rationale => $_getSZ(3);
  @$pb.TagNumber(4)
  set rationale($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRationale() => $_has(3);
  @$pb.TagNumber(4)
  void clearRationale() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get resultingPrescriptionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set resultingPrescriptionId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResultingPrescriptionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearResultingPrescriptionId() => $_clearField(5);
}

class DecideReconciliationResponse extends $pb.GeneratedMessage {
  factory DecideReconciliationResponse({
    Reconciliation? reconciliation,
  }) {
    final result = create();
    if (reconciliation != null) result.reconciliation = reconciliation;
    return result;
  }

  DecideReconciliationResponse._();

  factory DecideReconciliationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideReconciliationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideReconciliationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Reconciliation>(1, _omitFieldNames ? '' : 'reconciliation',
        subBuilder: Reconciliation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReconciliationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideReconciliationResponse copyWith(
          void Function(DecideReconciliationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DecideReconciliationResponse))
          as DecideReconciliationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideReconciliationResponse create() =>
      DecideReconciliationResponse._();
  @$core.override
  DecideReconciliationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideReconciliationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideReconciliationResponse>(create);
  static DecideReconciliationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Reconciliation get reconciliation => $_getN(0);
  @$pb.TagNumber(1)
  set reconciliation(Reconciliation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReconciliation() => $_has(0);
  @$pb.TagNumber(1)
  void clearReconciliation() => $_clearField(1);
  @$pb.TagNumber(1)
  Reconciliation ensureReconciliation() => $_ensure(0);
}

class CompleteReconciliationRequest extends $pb.GeneratedMessage {
  factory CompleteReconciliationRequest({
    $core.String? reconciliationId,
  }) {
    final result = create();
    if (reconciliationId != null) result.reconciliationId = reconciliationId;
    return result;
  }

  CompleteReconciliationRequest._();

  factory CompleteReconciliationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteReconciliationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteReconciliationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reconciliationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteReconciliationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteReconciliationRequest copyWith(
          void Function(CompleteReconciliationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteReconciliationRequest))
          as CompleteReconciliationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteReconciliationRequest create() =>
      CompleteReconciliationRequest._();
  @$core.override
  CompleteReconciliationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteReconciliationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteReconciliationRequest>(create);
  static CompleteReconciliationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reconciliationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reconciliationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReconciliationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReconciliationId() => $_clearField(1);
}

class CompleteReconciliationResponse extends $pb.GeneratedMessage {
  factory CompleteReconciliationResponse({
    Reconciliation? reconciliation,
  }) {
    final result = create();
    if (reconciliation != null) result.reconciliation = reconciliation;
    return result;
  }

  CompleteReconciliationResponse._();

  factory CompleteReconciliationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteReconciliationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteReconciliationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Reconciliation>(1, _omitFieldNames ? '' : 'reconciliation',
        subBuilder: Reconciliation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteReconciliationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteReconciliationResponse copyWith(
          void Function(CompleteReconciliationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteReconciliationResponse))
          as CompleteReconciliationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteReconciliationResponse create() =>
      CompleteReconciliationResponse._();
  @$core.override
  CompleteReconciliationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteReconciliationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteReconciliationResponse>(create);
  static CompleteReconciliationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Reconciliation get reconciliation => $_getN(0);
  @$pb.TagNumber(1)
  set reconciliation(Reconciliation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReconciliation() => $_has(0);
  @$pb.TagNumber(1)
  void clearReconciliation() => $_clearField(1);
  @$pb.TagNumber(1)
  Reconciliation ensureReconciliation() => $_ensure(0);
}

class ListReconciliationsRequest extends $pb.GeneratedMessage {
  factory ListReconciliationsRequest({
    $core.String? encounterId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListReconciliationsRequest._();

  factory ListReconciliationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReconciliationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReconciliationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReconciliationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReconciliationsRequest copyWith(
          void Function(ListReconciliationsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListReconciliationsRequest))
          as ListReconciliationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReconciliationsRequest create() => ListReconciliationsRequest._();
  @$core.override
  ListReconciliationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReconciliationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReconciliationsRequest>(create);
  static ListReconciliationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListReconciliationsResponse extends $pb.GeneratedMessage {
  factory ListReconciliationsResponse({
    $core.Iterable<Reconciliation>? reconciliations,
  }) {
    final result = create();
    if (reconciliations != null) result.reconciliations.addAll(reconciliations);
    return result;
  }

  ListReconciliationsResponse._();

  factory ListReconciliationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReconciliationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReconciliationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..pPM<Reconciliation>(1, _omitFieldNames ? '' : 'reconciliations',
        subBuilder: Reconciliation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReconciliationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReconciliationsResponse copyWith(
          void Function(ListReconciliationsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListReconciliationsResponse))
          as ListReconciliationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReconciliationsResponse create() =>
      ListReconciliationsResponse._();
  @$core.override
  ListReconciliationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReconciliationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReconciliationsResponse>(create);
  static ListReconciliationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Reconciliation> get reconciliations => $_getList(0);
}

/// A dispensed product that differs from the prescribed one (SRS-MED-011).
///
/// A record of its own rather than an edit to the prescription: the prescription
/// is evidence of what a named clinician decided, and a substitution written over
/// the top would leave the chart saying the prescriber chose a drug they never
/// saw.
class Substitution extends $pb.GeneratedMessage {
  factory Substitution({
    $core.String? substitutionId,
    $core.String? prescriptionId,
    Coding? prescribed,
    Coding? dispensed,
    SubstitutionKind? kind,
    SubstitutionStatus? status,
    $core.String? reason,
    $core.String? proposedBy,
    $0.Timestamp? proposedAt,
    $core.String? authorizedBy,
    $0.Timestamp? authorizedAt,
    $0.Timestamp? dispensedAt,
  }) {
    final result = create();
    if (substitutionId != null) result.substitutionId = substitutionId;
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (prescribed != null) result.prescribed = prescribed;
    if (dispensed != null) result.dispensed = dispensed;
    if (kind != null) result.kind = kind;
    if (status != null) result.status = status;
    if (reason != null) result.reason = reason;
    if (proposedBy != null) result.proposedBy = proposedBy;
    if (proposedAt != null) result.proposedAt = proposedAt;
    if (authorizedBy != null) result.authorizedBy = authorizedBy;
    if (authorizedAt != null) result.authorizedAt = authorizedAt;
    if (dispensedAt != null) result.dispensedAt = dispensedAt;
    return result;
  }

  Substitution._();

  factory Substitution.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Substitution.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Substitution',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'substitutionId')
    ..aOS(2, _omitFieldNames ? '' : 'prescriptionId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'prescribed',
        subBuilder: Coding.create)
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'dispensed',
        subBuilder: Coding.create)
    ..aE<SubstitutionKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: SubstitutionKind.values)
    ..aE<SubstitutionStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: SubstitutionStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..aOS(8, _omitFieldNames ? '' : 'proposedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'proposedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'authorizedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'authorizedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'dispensedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Substitution clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Substitution copyWith(void Function(Substitution) updates) =>
      super.copyWith((message) => updates(message as Substitution))
          as Substitution;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Substitution create() => Substitution._();
  @$core.override
  Substitution createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Substitution getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Substitution>(create);
  static Substitution? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get substitutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set substitutionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubstitutionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prescriptionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set prescriptionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrescriptionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrescriptionId() => $_clearField(2);

  @$pb.TagNumber(3)
  Coding get prescribed => $_getN(2);
  @$pb.TagNumber(3)
  set prescribed(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPrescribed() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrescribed() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensurePrescribed() => $_ensure(2);

  @$pb.TagNumber(4)
  Coding get dispensed => $_getN(3);
  @$pb.TagNumber(4)
  set dispensed(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDispensed() => $_has(3);
  @$pb.TagNumber(4)
  void clearDispensed() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureDispensed() => $_ensure(3);

  @$pb.TagNumber(5)
  SubstitutionKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(SubstitutionKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  SubstitutionStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(SubstitutionStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  /// Mandatory: "out of stock" and "cheaper" are different facts, and only one
  /// of them is a clinical governance question.
  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get proposedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set proposedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProposedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearProposedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get proposedAt => $_getN(8);
  @$pb.TagNumber(9)
  set proposedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasProposedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearProposedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureProposedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get authorizedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set authorizedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAuthorizedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearAuthorizedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get authorizedAt => $_getN(10);
  @$pb.TagNumber(11)
  set authorizedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAuthorizedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearAuthorizedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureAuthorizedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get dispensedAt => $_getN(11);
  @$pb.TagNumber(12)
  set dispensedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDispensedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDispensedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDispensedAt() => $_ensure(11);
}

class ProposeSubstitutionRequest extends $pb.GeneratedMessage {
  factory ProposeSubstitutionRequest({
    $core.String? prescriptionId,
    Coding? dispensed,
    SubstitutionKind? kind,
    $core.String? reason,
  }) {
    final result = create();
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    if (dispensed != null) result.dispensed = dispensed;
    if (kind != null) result.kind = kind;
    if (reason != null) result.reason = reason;
    return result;
  }

  ProposeSubstitutionRequest._();

  factory ProposeSubstitutionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProposeSubstitutionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProposeSubstitutionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prescriptionId')
    ..aOM<Coding>(2, _omitFieldNames ? '' : 'dispensed',
        subBuilder: Coding.create)
    ..aE<SubstitutionKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: SubstitutionKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposeSubstitutionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposeSubstitutionRequest copyWith(
          void Function(ProposeSubstitutionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProposeSubstitutionRequest))
          as ProposeSubstitutionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProposeSubstitutionRequest create() => ProposeSubstitutionRequest._();
  @$core.override
  ProposeSubstitutionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProposeSubstitutionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProposeSubstitutionRequest>(create);
  static ProposeSubstitutionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prescriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set prescriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescriptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  Coding get dispensed => $_getN(1);
  @$pb.TagNumber(2)
  set dispensed(Coding value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDispensed() => $_has(1);
  @$pb.TagNumber(2)
  void clearDispensed() => $_clearField(2);
  @$pb.TagNumber(2)
  Coding ensureDispensed() => $_ensure(1);

  @$pb.TagNumber(3)
  SubstitutionKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(SubstitutionKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class ProposeSubstitutionResponse extends $pb.GeneratedMessage {
  factory ProposeSubstitutionResponse({
    Substitution? substitution,
  }) {
    final result = create();
    if (substitution != null) result.substitution = substitution;
    return result;
  }

  ProposeSubstitutionResponse._();

  factory ProposeSubstitutionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProposeSubstitutionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProposeSubstitutionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Substitution>(1, _omitFieldNames ? '' : 'substitution',
        subBuilder: Substitution.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposeSubstitutionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposeSubstitutionResponse copyWith(
          void Function(ProposeSubstitutionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ProposeSubstitutionResponse))
          as ProposeSubstitutionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProposeSubstitutionResponse create() =>
      ProposeSubstitutionResponse._();
  @$core.override
  ProposeSubstitutionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProposeSubstitutionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProposeSubstitutionResponse>(create);
  static ProposeSubstitutionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Substitution get substitution => $_getN(0);
  @$pb.TagNumber(1)
  set substitution(Substitution value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubstitution() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubstitution() => $_clearField(1);
  @$pb.TagNumber(1)
  Substitution ensureSubstitution() => $_ensure(0);
}

class AdvanceSubstitutionRequest extends $pb.GeneratedMessage {
  factory AdvanceSubstitutionRequest({
    $core.String? substitutionId,
    $core.String? reason,
  }) {
    final result = create();
    if (substitutionId != null) result.substitutionId = substitutionId;
    if (reason != null) result.reason = reason;
    return result;
  }

  AdvanceSubstitutionRequest._();

  factory AdvanceSubstitutionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceSubstitutionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceSubstitutionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'substitutionId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceSubstitutionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceSubstitutionRequest copyWith(
          void Function(AdvanceSubstitutionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AdvanceSubstitutionRequest))
          as AdvanceSubstitutionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceSubstitutionRequest create() => AdvanceSubstitutionRequest._();
  @$core.override
  AdvanceSubstitutionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceSubstitutionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceSubstitutionRequest>(create);
  static AdvanceSubstitutionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get substitutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set substitutionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubstitutionId() => $_clearField(1);

  /// Set only on a rejection.
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class AdvanceSubstitutionResponse extends $pb.GeneratedMessage {
  factory AdvanceSubstitutionResponse({
    Substitution? substitution,
  }) {
    final result = create();
    if (substitution != null) result.substitution = substitution;
    return result;
  }

  AdvanceSubstitutionResponse._();

  factory AdvanceSubstitutionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceSubstitutionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceSubstitutionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Substitution>(1, _omitFieldNames ? '' : 'substitution',
        subBuilder: Substitution.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceSubstitutionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceSubstitutionResponse copyWith(
          void Function(AdvanceSubstitutionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AdvanceSubstitutionResponse))
          as AdvanceSubstitutionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceSubstitutionResponse create() =>
      AdvanceSubstitutionResponse._();
  @$core.override
  AdvanceSubstitutionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceSubstitutionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceSubstitutionResponse>(create);
  static AdvanceSubstitutionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Substitution get substitution => $_getN(0);
  @$pb.TagNumber(1)
  set substitution(Substitution value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubstitution() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubstitution() => $_clearField(1);
  @$pb.TagNumber(1)
  Substitution ensureSubstitution() => $_ensure(0);
}

class AuthorizeSubstitutionRequest extends $pb.GeneratedMessage {
  factory AuthorizeSubstitutionRequest({
    AdvanceSubstitutionRequest? advance,
  }) {
    final result = create();
    if (advance != null) result.advance = advance;
    return result;
  }

  AuthorizeSubstitutionRequest._();

  factory AuthorizeSubstitutionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthorizeSubstitutionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthorizeSubstitutionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<AdvanceSubstitutionRequest>(1, _omitFieldNames ? '' : 'advance',
        subBuilder: AdvanceSubstitutionRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizeSubstitutionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizeSubstitutionRequest copyWith(
          void Function(AuthorizeSubstitutionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AuthorizeSubstitutionRequest))
          as AuthorizeSubstitutionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthorizeSubstitutionRequest create() =>
      AuthorizeSubstitutionRequest._();
  @$core.override
  AuthorizeSubstitutionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthorizeSubstitutionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthorizeSubstitutionRequest>(create);
  static AuthorizeSubstitutionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AdvanceSubstitutionRequest get advance => $_getN(0);
  @$pb.TagNumber(1)
  set advance(AdvanceSubstitutionRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdvance() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdvance() => $_clearField(1);
  @$pb.TagNumber(1)
  AdvanceSubstitutionRequest ensureAdvance() => $_ensure(0);
}

class AuthorizeSubstitutionResponse extends $pb.GeneratedMessage {
  factory AuthorizeSubstitutionResponse({
    Substitution? substitution,
  }) {
    final result = create();
    if (substitution != null) result.substitution = substitution;
    return result;
  }

  AuthorizeSubstitutionResponse._();

  factory AuthorizeSubstitutionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthorizeSubstitutionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthorizeSubstitutionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Substitution>(1, _omitFieldNames ? '' : 'substitution',
        subBuilder: Substitution.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizeSubstitutionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizeSubstitutionResponse copyWith(
          void Function(AuthorizeSubstitutionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AuthorizeSubstitutionResponse))
          as AuthorizeSubstitutionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthorizeSubstitutionResponse create() =>
      AuthorizeSubstitutionResponse._();
  @$core.override
  AuthorizeSubstitutionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthorizeSubstitutionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthorizeSubstitutionResponse>(create);
  static AuthorizeSubstitutionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Substitution get substitution => $_getN(0);
  @$pb.TagNumber(1)
  set substitution(Substitution value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubstitution() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubstitution() => $_clearField(1);
  @$pb.TagNumber(1)
  Substitution ensureSubstitution() => $_ensure(0);
}

class RejectSubstitutionRequest extends $pb.GeneratedMessage {
  factory RejectSubstitutionRequest({
    AdvanceSubstitutionRequest? advance,
  }) {
    final result = create();
    if (advance != null) result.advance = advance;
    return result;
  }

  RejectSubstitutionRequest._();

  factory RejectSubstitutionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectSubstitutionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectSubstitutionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<AdvanceSubstitutionRequest>(1, _omitFieldNames ? '' : 'advance',
        subBuilder: AdvanceSubstitutionRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectSubstitutionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectSubstitutionRequest copyWith(
          void Function(RejectSubstitutionRequest) updates) =>
      super.copyWith((message) => updates(message as RejectSubstitutionRequest))
          as RejectSubstitutionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectSubstitutionRequest create() => RejectSubstitutionRequest._();
  @$core.override
  RejectSubstitutionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectSubstitutionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectSubstitutionRequest>(create);
  static RejectSubstitutionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AdvanceSubstitutionRequest get advance => $_getN(0);
  @$pb.TagNumber(1)
  set advance(AdvanceSubstitutionRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdvance() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdvance() => $_clearField(1);
  @$pb.TagNumber(1)
  AdvanceSubstitutionRequest ensureAdvance() => $_ensure(0);
}

class RejectSubstitutionResponse extends $pb.GeneratedMessage {
  factory RejectSubstitutionResponse({
    Substitution? substitution,
  }) {
    final result = create();
    if (substitution != null) result.substitution = substitution;
    return result;
  }

  RejectSubstitutionResponse._();

  factory RejectSubstitutionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectSubstitutionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectSubstitutionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Substitution>(1, _omitFieldNames ? '' : 'substitution',
        subBuilder: Substitution.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectSubstitutionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectSubstitutionResponse copyWith(
          void Function(RejectSubstitutionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RejectSubstitutionResponse))
          as RejectSubstitutionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectSubstitutionResponse create() => RejectSubstitutionResponse._();
  @$core.override
  RejectSubstitutionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectSubstitutionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectSubstitutionResponse>(create);
  static RejectSubstitutionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Substitution get substitution => $_getN(0);
  @$pb.TagNumber(1)
  set substitution(Substitution value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubstitution() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubstitution() => $_clearField(1);
  @$pb.TagNumber(1)
  Substitution ensureSubstitution() => $_ensure(0);
}

class DispenseSubstitutionRequest extends $pb.GeneratedMessage {
  factory DispenseSubstitutionRequest({
    AdvanceSubstitutionRequest? advance,
  }) {
    final result = create();
    if (advance != null) result.advance = advance;
    return result;
  }

  DispenseSubstitutionRequest._();

  factory DispenseSubstitutionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispenseSubstitutionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispenseSubstitutionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<AdvanceSubstitutionRequest>(1, _omitFieldNames ? '' : 'advance',
        subBuilder: AdvanceSubstitutionRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispenseSubstitutionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispenseSubstitutionRequest copyWith(
          void Function(DispenseSubstitutionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DispenseSubstitutionRequest))
          as DispenseSubstitutionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispenseSubstitutionRequest create() =>
      DispenseSubstitutionRequest._();
  @$core.override
  DispenseSubstitutionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispenseSubstitutionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispenseSubstitutionRequest>(create);
  static DispenseSubstitutionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AdvanceSubstitutionRequest get advance => $_getN(0);
  @$pb.TagNumber(1)
  set advance(AdvanceSubstitutionRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdvance() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdvance() => $_clearField(1);
  @$pb.TagNumber(1)
  AdvanceSubstitutionRequest ensureAdvance() => $_ensure(0);
}

class DispenseSubstitutionResponse extends $pb.GeneratedMessage {
  factory DispenseSubstitutionResponse({
    Substitution? substitution,
  }) {
    final result = create();
    if (substitution != null) result.substitution = substitution;
    return result;
  }

  DispenseSubstitutionResponse._();

  factory DispenseSubstitutionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispenseSubstitutionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispenseSubstitutionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Substitution>(1, _omitFieldNames ? '' : 'substitution',
        subBuilder: Substitution.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispenseSubstitutionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispenseSubstitutionResponse copyWith(
          void Function(DispenseSubstitutionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DispenseSubstitutionResponse))
          as DispenseSubstitutionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispenseSubstitutionResponse create() =>
      DispenseSubstitutionResponse._();
  @$core.override
  DispenseSubstitutionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispenseSubstitutionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispenseSubstitutionResponse>(create);
  static DispenseSubstitutionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Substitution get substitution => $_getN(0);
  @$pb.TagNumber(1)
  set substitution(Substitution value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubstitution() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubstitution() => $_clearField(1);
  @$pb.TagNumber(1)
  Substitution ensureSubstitution() => $_ensure(0);
}

class ListSubstitutionsRequest extends $pb.GeneratedMessage {
  factory ListSubstitutionsRequest({
    $core.String? prescriptionId,
  }) {
    final result = create();
    if (prescriptionId != null) result.prescriptionId = prescriptionId;
    return result;
  }

  ListSubstitutionsRequest._();

  factory ListSubstitutionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSubstitutionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSubstitutionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'prescriptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubstitutionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubstitutionsRequest copyWith(
          void Function(ListSubstitutionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSubstitutionsRequest))
          as ListSubstitutionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSubstitutionsRequest create() => ListSubstitutionsRequest._();
  @$core.override
  ListSubstitutionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSubstitutionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSubstitutionsRequest>(create);
  static ListSubstitutionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prescriptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set prescriptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrescriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrescriptionId() => $_clearField(1);
}

class ListSubstitutionsResponse extends $pb.GeneratedMessage {
  factory ListSubstitutionsResponse({
    $core.Iterable<Substitution>? substitutions,
  }) {
    final result = create();
    if (substitutions != null) result.substitutions.addAll(substitutions);
    return result;
  }

  ListSubstitutionsResponse._();

  factory ListSubstitutionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSubstitutionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSubstitutionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..pPM<Substitution>(1, _omitFieldNames ? '' : 'substitutions',
        subBuilder: Substitution.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubstitutionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubstitutionsResponse copyWith(
          void Function(ListSubstitutionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSubstitutionsResponse))
          as ListSubstitutionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSubstitutionsResponse create() => ListSubstitutionsResponse._();
  @$core.override
  ListSubstitutionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSubstitutionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSubstitutionsResponse>(create);
  static ListSubstitutionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Substitution> get substitutions => $_getList(0);
}

/// Configuration a tenant's pharmacy committee maintains.
class FormularyEntry extends $pb.GeneratedMessage {
  factory FormularyEntry({
    Coding? medication,
    $core.String? scope,
    $core.String? scopeId,
    FormularyStatus? status,
    $core.String? restriction,
    $core.String? approvalPath,
  }) {
    final result = create();
    if (medication != null) result.medication = medication;
    if (scope != null) result.scope = scope;
    if (scopeId != null) result.scopeId = scopeId;
    if (status != null) result.status = status;
    if (restriction != null) result.restriction = restriction;
    if (approvalPath != null) result.approvalPath = approvalPath;
    return result;
  }

  FormularyEntry._();

  factory FormularyEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FormularyEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FormularyEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Coding>(1, _omitFieldNames ? '' : 'medication',
        subBuilder: Coding.create)
    ..aOS(2, _omitFieldNames ? '' : 'scope')
    ..aOS(3, _omitFieldNames ? '' : 'scopeId')
    ..aE<FormularyStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: FormularyStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'restriction')
    ..aOS(6, _omitFieldNames ? '' : 'approvalPath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormularyEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormularyEntry copyWith(void Function(FormularyEntry) updates) =>
      super.copyWith((message) => updates(message as FormularyEntry))
          as FormularyEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormularyEntry create() => FormularyEntry._();
  @$core.override
  FormularyEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FormularyEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FormularyEntry>(create);
  static FormularyEntry? _defaultInstance;

  @$pb.TagNumber(1)
  Coding get medication => $_getN(0);
  @$pb.TagNumber(1)
  set medication(Coding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMedication() => $_has(0);
  @$pb.TagNumber(1)
  void clearMedication() => $_clearField(1);
  @$pb.TagNumber(1)
  Coding ensureMedication() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get scope => $_getSZ(1);
  @$pb.TagNumber(2)
  set scope($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScope() => $_has(1);
  @$pb.TagNumber(2)
  void clearScope() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeId() => $_clearField(3);

  @$pb.TagNumber(4)
  FormularyStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(FormularyStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get restriction => $_getSZ(4);
  @$pb.TagNumber(5)
  set restriction($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRestriction() => $_has(4);
  @$pb.TagNumber(5)
  void clearRestriction() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get approvalPath => $_getSZ(5);
  @$pb.TagNumber(6)
  set approvalPath($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasApprovalPath() => $_has(5);
  @$pb.TagNumber(6)
  void clearApprovalPath() => $_clearField(6);
}

class SetFormularyEntryRequest extends $pb.GeneratedMessage {
  factory SetFormularyEntryRequest({
    FormularyEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  SetFormularyEntryRequest._();

  factory SetFormularyEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetFormularyEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetFormularyEntryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<FormularyEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: FormularyEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFormularyEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFormularyEntryRequest copyWith(
          void Function(SetFormularyEntryRequest) updates) =>
      super.copyWith((message) => updates(message as SetFormularyEntryRequest))
          as SetFormularyEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetFormularyEntryRequest create() => SetFormularyEntryRequest._();
  @$core.override
  SetFormularyEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetFormularyEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetFormularyEntryRequest>(create);
  static SetFormularyEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  FormularyEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(FormularyEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  FormularyEntry ensureEntry() => $_ensure(0);
}

class SetFormularyEntryResponse extends $pb.GeneratedMessage {
  factory SetFormularyEntryResponse() => create();

  SetFormularyEntryResponse._();

  factory SetFormularyEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetFormularyEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetFormularyEntryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFormularyEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFormularyEntryResponse copyWith(
          void Function(SetFormularyEntryResponse) updates) =>
      super.copyWith((message) => updates(message as SetFormularyEntryResponse))
          as SetFormularyEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetFormularyEntryResponse create() => SetFormularyEntryResponse._();
  @$core.override
  SetFormularyEntryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetFormularyEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetFormularyEntryResponse>(create);
  static SetFormularyEntryResponse? _defaultInstance;
}

/// One configured drug-drug interaction (SRS-MED-003).
class InteractionRule extends $pb.GeneratedMessage {
  factory InteractionRule({
    $core.String? ruleId,
    $core.String? version,
    Coding? left,
    Coding? right,
    Severity? severity,
    $core.String? advice,
    $core.String? management,
    $core.bool? active,
  }) {
    final result = create();
    if (ruleId != null) result.ruleId = ruleId;
    if (version != null) result.version = version;
    if (left != null) result.left = left;
    if (right != null) result.right = right;
    if (severity != null) result.severity = severity;
    if (advice != null) result.advice = advice;
    if (management != null) result.management = management;
    if (active != null) result.active = active;
    return result;
  }

  InteractionRule._();

  factory InteractionRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InteractionRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InteractionRule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'left', subBuilder: Coding.create)
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'right', subBuilder: Coding.create)
    ..aE<Severity>(5, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aOS(6, _omitFieldNames ? '' : 'advice')
    ..aOS(7, _omitFieldNames ? '' : 'management')
    ..aOB(8, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractionRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractionRule copyWith(void Function(InteractionRule) updates) =>
      super.copyWith((message) => updates(message as InteractionRule))
          as InteractionRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InteractionRule create() => InteractionRule._();
  @$core.override
  InteractionRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InteractionRule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InteractionRule>(create);
  static InteractionRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ruleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ruleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRuleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRuleId() => $_clearField(1);

  /// Publishing a new version leaves the old one readable: a finding recorded
  /// last March names a version, and a version edited in place is a finding
  /// nobody can explain.
  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  Coding get left => $_getN(2);
  @$pb.TagNumber(3)
  set left(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLeft() => $_has(2);
  @$pb.TagNumber(3)
  void clearLeft() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureLeft() => $_ensure(2);

  @$pb.TagNumber(4)
  Coding get right => $_getN(3);
  @$pb.TagNumber(4)
  set right(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRight() => $_has(3);
  @$pb.TagNumber(4)
  void clearRight() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureRight() => $_ensure(3);

  @$pb.TagNumber(5)
  Severity get severity => $_getN(4);
  @$pb.TagNumber(5)
  set severity(Severity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSeverity() => $_has(4);
  @$pb.TagNumber(5)
  void clearSeverity() => $_clearField(5);

  /// A warning that names a problem and no action is one clinicians learn to
  /// dismiss.
  @$pb.TagNumber(6)
  $core.String get advice => $_getSZ(5);
  @$pb.TagNumber(6)
  set advice($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAdvice() => $_has(5);
  @$pb.TagNumber(6)
  void clearAdvice() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get management => $_getSZ(6);
  @$pb.TagNumber(7)
  set management($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasManagement() => $_has(6);
  @$pb.TagNumber(7)
  void clearManagement() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get active => $_getBF(7);
  @$pb.TagNumber(8)
  set active($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActive() => $_has(7);
  @$pb.TagNumber(8)
  void clearActive() => $_clearField(8);
}

class SetInteractionRuleRequest extends $pb.GeneratedMessage {
  factory SetInteractionRuleRequest({
    InteractionRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  SetInteractionRuleRequest._();

  factory SetInteractionRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetInteractionRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetInteractionRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<InteractionRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: InteractionRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetInteractionRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetInteractionRuleRequest copyWith(
          void Function(SetInteractionRuleRequest) updates) =>
      super.copyWith((message) => updates(message as SetInteractionRuleRequest))
          as SetInteractionRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetInteractionRuleRequest create() => SetInteractionRuleRequest._();
  @$core.override
  SetInteractionRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetInteractionRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetInteractionRuleRequest>(create);
  static SetInteractionRuleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  InteractionRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(InteractionRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  InteractionRule ensureRule() => $_ensure(0);
}

class SetInteractionRuleResponse extends $pb.GeneratedMessage {
  factory SetInteractionRuleResponse() => create();

  SetInteractionRuleResponse._();

  factory SetInteractionRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetInteractionRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetInteractionRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetInteractionRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetInteractionRuleResponse copyWith(
          void Function(SetInteractionRuleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetInteractionRuleResponse))
          as SetInteractionRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetInteractionRuleResponse create() => SetInteractionRuleResponse._();
  @$core.override
  SetInteractionRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetInteractionRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetInteractionRuleResponse>(create);
  static SetInteractionRuleResponse? _defaultInstance;
}

class ListInteractionRulesRequest extends $pb.GeneratedMessage {
  factory ListInteractionRulesRequest() => create();

  ListInteractionRulesRequest._();

  factory ListInteractionRulesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInteractionRulesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInteractionRulesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInteractionRulesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInteractionRulesRequest copyWith(
          void Function(ListInteractionRulesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListInteractionRulesRequest))
          as ListInteractionRulesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInteractionRulesRequest create() =>
      ListInteractionRulesRequest._();
  @$core.override
  ListInteractionRulesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInteractionRulesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInteractionRulesRequest>(create);
  static ListInteractionRulesRequest? _defaultInstance;
}

class ListInteractionRulesResponse extends $pb.GeneratedMessage {
  factory ListInteractionRulesResponse({
    $core.Iterable<InteractionRule>? rules,
  }) {
    final result = create();
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  ListInteractionRulesResponse._();

  factory ListInteractionRulesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInteractionRulesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInteractionRulesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..pPM<InteractionRule>(1, _omitFieldNames ? '' : 'rules',
        subBuilder: InteractionRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInteractionRulesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInteractionRulesResponse copyWith(
          void Function(ListInteractionRulesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListInteractionRulesResponse))
          as ListInteractionRulesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInteractionRulesResponse create() =>
      ListInteractionRulesResponse._();
  @$core.override
  ListInteractionRulesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInteractionRulesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInteractionRulesResponse>(create);
  static ListInteractionRulesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InteractionRule> get rules => $_getList(0);
}

class DoseRule extends $pb.GeneratedMessage {
  factory DoseRule({
    $core.String? ruleId,
    $core.String? version,
    DoseRuleScope? scope,
    Coding? medication,
    $core.double? maxCreatinineClearance,
    $core.double? maxAgeYears,
    $core.String? advice,
    $core.bool? validated,
    $core.bool? active,
  }) {
    final result = create();
    if (ruleId != null) result.ruleId = ruleId;
    if (version != null) result.version = version;
    if (scope != null) result.scope = scope;
    if (medication != null) result.medication = medication;
    if (maxCreatinineClearance != null)
      result.maxCreatinineClearance = maxCreatinineClearance;
    if (maxAgeYears != null) result.maxAgeYears = maxAgeYears;
    if (advice != null) result.advice = advice;
    if (validated != null) result.validated = validated;
    if (active != null) result.active = active;
    return result;
  }

  DoseRule._();

  factory DoseRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DoseRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DoseRule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ruleId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aE<DoseRuleScope>(3, _omitFieldNames ? '' : 'scope',
        enumValues: DoseRuleScope.values)
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'medication',
        subBuilder: Coding.create)
    ..aD(5, _omitFieldNames ? '' : 'maxCreatinineClearance')
    ..aD(6, _omitFieldNames ? '' : 'maxAgeYears')
    ..aOS(7, _omitFieldNames ? '' : 'advice')
    ..aOB(8, _omitFieldNames ? '' : 'validated')
    ..aOB(9, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoseRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoseRule copyWith(void Function(DoseRule) updates) =>
      super.copyWith((message) => updates(message as DoseRule)) as DoseRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DoseRule create() => DoseRule._();
  @$core.override
  DoseRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DoseRule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoseRule>(create);
  static DoseRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ruleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ruleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRuleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRuleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  DoseRuleScope get scope => $_getN(2);
  @$pb.TagNumber(3)
  set scope(DoseRuleScope value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScope() => $_has(2);
  @$pb.TagNumber(3)
  void clearScope() => $_clearField(3);

  @$pb.TagNumber(4)
  Coding get medication => $_getN(3);
  @$pb.TagNumber(4)
  set medication(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMedication() => $_has(3);
  @$pb.TagNumber(4)
  void clearMedication() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureMedication() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get maxCreatinineClearance => $_getN(4);
  @$pb.TagNumber(5)
  set maxCreatinineClearance($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxCreatinineClearance() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxCreatinineClearance() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get maxAgeYears => $_getN(5);
  @$pb.TagNumber(6)
  set maxAgeYears($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxAgeYears() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxAgeYears() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get advice => $_getSZ(6);
  @$pb.TagNumber(7)
  set advice($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAdvice() => $_has(6);
  @$pb.TagNumber(7)
  void clearAdvice() => $_clearField(7);

  /// SRS-MED-004 applies dose support "when configured and validated". An
  /// unvalidated rule is advice nobody has checked, so it does not run at all.
  @$pb.TagNumber(8)
  $core.bool get validated => $_getBF(7);
  @$pb.TagNumber(8)
  set validated($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasValidated() => $_has(7);
  @$pb.TagNumber(8)
  void clearValidated() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get active => $_getBF(8);
  @$pb.TagNumber(9)
  set active($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasActive() => $_has(8);
  @$pb.TagNumber(9)
  void clearActive() => $_clearField(9);
}

class SetDoseRuleRequest extends $pb.GeneratedMessage {
  factory SetDoseRuleRequest({
    DoseRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  SetDoseRuleRequest._();

  factory SetDoseRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetDoseRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDoseRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<DoseRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: DoseRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDoseRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDoseRuleRequest copyWith(void Function(SetDoseRuleRequest) updates) =>
      super.copyWith((message) => updates(message as SetDoseRuleRequest))
          as SetDoseRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetDoseRuleRequest create() => SetDoseRuleRequest._();
  @$core.override
  SetDoseRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetDoseRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDoseRuleRequest>(create);
  static SetDoseRuleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DoseRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(DoseRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  DoseRule ensureRule() => $_ensure(0);
}

class SetDoseRuleResponse extends $pb.GeneratedMessage {
  factory SetDoseRuleResponse() => create();

  SetDoseRuleResponse._();

  factory SetDoseRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetDoseRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDoseRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDoseRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDoseRuleResponse copyWith(void Function(SetDoseRuleResponse) updates) =>
      super.copyWith((message) => updates(message as SetDoseRuleResponse))
          as SetDoseRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetDoseRuleResponse create() => SetDoseRuleResponse._();
  @$core.override
  SetDoseRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetDoseRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDoseRuleResponse>(create);
  static SetDoseRuleResponse? _defaultInstance;
}

/// One medication's terminology (SRS-MED-002).
///
/// The mapping that lets a penicillin allergy catch a co-amoxiclav prescription.
/// Matching on the prescribed code alone misses it, which is the failure mode
/// that kills people.
class TerminologyMapping extends $pb.GeneratedMessage {
  factory TerminologyMapping({
    Coding? medication,
    $core.Iterable<Coding>? ingredients,
    $core.Iterable<Coding>? classes,
    Coding? therapeuticMoiety,
    $core.String? mapVersion,
  }) {
    final result = create();
    if (medication != null) result.medication = medication;
    if (ingredients != null) result.ingredients.addAll(ingredients);
    if (classes != null) result.classes.addAll(classes);
    if (therapeuticMoiety != null) result.therapeuticMoiety = therapeuticMoiety;
    if (mapVersion != null) result.mapVersion = mapVersion;
    return result;
  }

  TerminologyMapping._();

  factory TerminologyMapping.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TerminologyMapping.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TerminologyMapping',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<Coding>(1, _omitFieldNames ? '' : 'medication',
        subBuilder: Coding.create)
    ..pPM<Coding>(2, _omitFieldNames ? '' : 'ingredients',
        subBuilder: Coding.create)
    ..pPM<Coding>(3, _omitFieldNames ? '' : 'classes',
        subBuilder: Coding.create)
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'therapeuticMoiety',
        subBuilder: Coding.create)
    ..aOS(5, _omitFieldNames ? '' : 'mapVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TerminologyMapping clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TerminologyMapping copyWith(void Function(TerminologyMapping) updates) =>
      super.copyWith((message) => updates(message as TerminologyMapping))
          as TerminologyMapping;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TerminologyMapping create() => TerminologyMapping._();
  @$core.override
  TerminologyMapping createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TerminologyMapping getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TerminologyMapping>(create);
  static TerminologyMapping? _defaultInstance;

  @$pb.TagNumber(1)
  Coding get medication => $_getN(0);
  @$pb.TagNumber(1)
  set medication(Coding value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMedication() => $_has(0);
  @$pb.TagNumber(1)
  void clearMedication() => $_clearField(1);
  @$pb.TagNumber(1)
  Coding ensureMedication() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Coding> get ingredients => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Coding> get classes => $_getList(2);

  /// What the medication does, for the duplicate-therapy check. Two brands of
  /// the same drug share this and share nothing else.
  @$pb.TagNumber(4)
  Coding get therapeuticMoiety => $_getN(3);
  @$pb.TagNumber(4)
  set therapeuticMoiety(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTherapeuticMoiety() => $_has(3);
  @$pb.TagNumber(4)
  void clearTherapeuticMoiety() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureTherapeuticMoiety() => $_ensure(3);

  /// So a finding can name the edition of the map that produced it.
  @$pb.TagNumber(5)
  $core.String get mapVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set mapVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMapVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearMapVersion() => $_clearField(5);
}

class SetTerminologyMappingRequest extends $pb.GeneratedMessage {
  factory SetTerminologyMappingRequest({
    TerminologyMapping? mapping,
  }) {
    final result = create();
    if (mapping != null) result.mapping = mapping;
    return result;
  }

  SetTerminologyMappingRequest._();

  factory SetTerminologyMappingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTerminologyMappingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTerminologyMappingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<TerminologyMapping>(1, _omitFieldNames ? '' : 'mapping',
        subBuilder: TerminologyMapping.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTerminologyMappingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTerminologyMappingRequest copyWith(
          void Function(SetTerminologyMappingRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetTerminologyMappingRequest))
          as SetTerminologyMappingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTerminologyMappingRequest create() =>
      SetTerminologyMappingRequest._();
  @$core.override
  SetTerminologyMappingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetTerminologyMappingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTerminologyMappingRequest>(create);
  static SetTerminologyMappingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  TerminologyMapping get mapping => $_getN(0);
  @$pb.TagNumber(1)
  set mapping(TerminologyMapping value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMapping() => $_has(0);
  @$pb.TagNumber(1)
  void clearMapping() => $_clearField(1);
  @$pb.TagNumber(1)
  TerminologyMapping ensureMapping() => $_ensure(0);
}

class SetTerminologyMappingResponse extends $pb.GeneratedMessage {
  factory SetTerminologyMappingResponse() => create();

  SetTerminologyMappingResponse._();

  factory SetTerminologyMappingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTerminologyMappingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTerminologyMappingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTerminologyMappingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTerminologyMappingResponse copyWith(
          void Function(SetTerminologyMappingResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetTerminologyMappingResponse))
          as SetTerminologyMappingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTerminologyMappingResponse create() =>
      SetTerminologyMappingResponse._();
  @$core.override
  SetTerminologyMappingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetTerminologyMappingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTerminologyMappingResponse>(create);
  static SetTerminologyMappingResponse? _defaultInstance;
}

/// The tenant's medication policy.
class MedicationPolicy extends $pb.GeneratedMessage {
  factory MedicationPolicy({
    Severity? maxOverridable,
    $core.bool? verificationRequired,
    $core.Iterable<$core.String>? verificationClasses,
    $core.Iterable<$core.String>? structuredDoseClasses,
  }) {
    final result = create();
    if (maxOverridable != null) result.maxOverridable = maxOverridable;
    if (verificationRequired != null)
      result.verificationRequired = verificationRequired;
    if (verificationClasses != null)
      result.verificationClasses.addAll(verificationClasses);
    if (structuredDoseClasses != null)
      result.structuredDoseClasses.addAll(structuredDoseClasses);
    return result;
  }

  MedicationPolicy._();

  factory MedicationPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MedicationPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MedicationPolicy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aE<Severity>(1, _omitFieldNames ? '' : 'maxOverridable',
        enumValues: Severity.values)
    ..aOB(2, _omitFieldNames ? '' : 'verificationRequired')
    ..pPS(3, _omitFieldNames ? '' : 'verificationClasses')
    ..pPS(4, _omitFieldNames ? '' : 'structuredDoseClasses')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedicationPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedicationPolicy copyWith(void Function(MedicationPolicy) updates) =>
      super.copyWith((message) => updates(message as MedicationPolicy))
          as MedicationPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MedicationPolicy create() => MedicationPolicy._();
  @$core.override
  MedicationPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MedicationPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MedicationPolicy>(create);
  static MedicationPolicy? _defaultInstance;

  /// The most serious finding a clinician may override. Never contraindicated.
  @$pb.TagNumber(1)
  Severity get maxOverridable => $_getN(0);
  @$pb.TagNumber(1)
  set maxOverridable(Severity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxOverridable() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxOverridable() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get verificationRequired => $_getBF(1);
  @$pb.TagNumber(2)
  set verificationRequired($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVerificationRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerificationRequired() => $_clearField(2);

  /// Classes that always need a pharmacist, whatever verification_required says:
  /// a hospital that cannot staff overnight pharmacy still wants every cytotoxic
  /// checked.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get verificationClasses => $_getList(2);

  /// Classes where a free-text dose is refused (SRS-MED-010).
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get structuredDoseClasses => $_getList(3);
}

class SetMedicationPolicyRequest extends $pb.GeneratedMessage {
  factory SetMedicationPolicyRequest({
    MedicationPolicy? policy,
  }) {
    final result = create();
    if (policy != null) result.policy = policy;
    return result;
  }

  SetMedicationPolicyRequest._();

  factory SetMedicationPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetMedicationPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetMedicationPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<MedicationPolicy>(1, _omitFieldNames ? '' : 'policy',
        subBuilder: MedicationPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMedicationPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMedicationPolicyRequest copyWith(
          void Function(SetMedicationPolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetMedicationPolicyRequest))
          as SetMedicationPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetMedicationPolicyRequest create() => SetMedicationPolicyRequest._();
  @$core.override
  SetMedicationPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetMedicationPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetMedicationPolicyRequest>(create);
  static SetMedicationPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  MedicationPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(MedicationPolicy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => $_clearField(1);
  @$pb.TagNumber(1)
  MedicationPolicy ensurePolicy() => $_ensure(0);
}

class SetMedicationPolicyResponse extends $pb.GeneratedMessage {
  factory SetMedicationPolicyResponse() => create();

  SetMedicationPolicyResponse._();

  factory SetMedicationPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetMedicationPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetMedicationPolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMedicationPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetMedicationPolicyResponse copyWith(
          void Function(SetMedicationPolicyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetMedicationPolicyResponse))
          as SetMedicationPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetMedicationPolicyResponse create() =>
      SetMedicationPolicyResponse._();
  @$core.override
  SetMedicationPolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetMedicationPolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetMedicationPolicyResponse>(create);
  static SetMedicationPolicyResponse? _defaultInstance;
}

class GetMedicationPolicyRequest extends $pb.GeneratedMessage {
  factory GetMedicationPolicyRequest() => create();

  GetMedicationPolicyRequest._();

  factory GetMedicationPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMedicationPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMedicationPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationPolicyRequest copyWith(
          void Function(GetMedicationPolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetMedicationPolicyRequest))
          as GetMedicationPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMedicationPolicyRequest create() => GetMedicationPolicyRequest._();
  @$core.override
  GetMedicationPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMedicationPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMedicationPolicyRequest>(create);
  static GetMedicationPolicyRequest? _defaultInstance;
}

class GetMedicationPolicyResponse extends $pb.GeneratedMessage {
  factory GetMedicationPolicyResponse({
    MedicationPolicy? policy,
  }) {
    final result = create();
    if (policy != null) result.policy = policy;
    return result;
  }

  GetMedicationPolicyResponse._();

  factory GetMedicationPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMedicationPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMedicationPolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.medication.v1'),
      createEmptyInstance: create)
    ..aOM<MedicationPolicy>(1, _omitFieldNames ? '' : 'policy',
        subBuilder: MedicationPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationPolicyResponse copyWith(
          void Function(GetMedicationPolicyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetMedicationPolicyResponse))
          as GetMedicationPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMedicationPolicyResponse create() =>
      GetMedicationPolicyResponse._();
  @$core.override
  GetMedicationPolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMedicationPolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMedicationPolicyResponse>(create);
  static GetMedicationPolicyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MedicationPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(MedicationPolicy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => $_clearField(1);
  @$pb.TagNumber(1)
  MedicationPolicy ensurePolicy() => $_ensure(0);
}

/// MedicationService is the medication context's boundary (SRS-MED).
class MedicationServiceApi {
  final $pb.RpcClient _client;

  MedicationServiceApi(this._client);

  /// SRS-MED-001 … SRS-MED-004, SRS-MED-010, SRS-MED-012. Screens, places the
  /// order and records the prescription in one act.
  $async.Future<PrescribeResponse> prescribe(
          $pb.ClientContext? ctx, PrescribeRequest request) =>
      _client.invoke<PrescribeResponse>(
          ctx, 'MedicationService', 'Prescribe', request, PrescribeResponse());
  $async.Future<GetPrescriptionResponse> getPrescription(
          $pb.ClientContext? ctx, GetPrescriptionRequest request) =>
      _client.invoke<GetPrescriptionResponse>(ctx, 'MedicationService',
          'GetPrescription', request, GetPrescriptionResponse());
  $async.Future<ListPrescriptionsResponse> listPrescriptions(
          $pb.ClientContext? ctx, ListPrescriptionsRequest request) =>
      _client.invoke<ListPrescriptionsResponse>(ctx, 'MedicationService',
          'ListPrescriptions', request, ListPrescriptionsResponse());

  /// SRS-MED-013. Three calls rather than one with a status, because the
  /// preconditions differ: only a held therapy restarts, and a discontinued one
  /// never does.
  $async.Future<HoldTherapyResponse> holdTherapy(
          $pb.ClientContext? ctx, HoldTherapyRequest request) =>
      _client.invoke<HoldTherapyResponse>(ctx, 'MedicationService',
          'HoldTherapy', request, HoldTherapyResponse());
  $async.Future<RestartTherapyResponse> restartTherapy(
          $pb.ClientContext? ctx, RestartTherapyRequest request) =>
      _client.invoke<RestartTherapyResponse>(ctx, 'MedicationService',
          'RestartTherapy', request, RestartTherapyResponse());
  $async.Future<DiscontinueTherapyResponse> discontinueTherapy(
          $pb.ClientContext? ctx, DiscontinueTherapyRequest request) =>
      _client.invoke<DiscontinueTherapyResponse>(ctx, 'MedicationService',
          'DiscontinueTherapy', request, DiscontinueTherapyResponse());

  /// SRS-MED-006.
  $async.Future<VerifyPrescriptionResponse> verifyPrescription(
          $pb.ClientContext? ctx, VerifyPrescriptionRequest request) =>
      _client.invoke<VerifyPrescriptionResponse>(ctx, 'MedicationService',
          'VerifyPrescription', request, VerifyPrescriptionResponse());
  $async.Future<VerificationQueueResponse> verificationQueue(
          $pb.ClientContext? ctx, VerificationQueueRequest request) =>
      _client.invoke<VerificationQueueResponse>(ctx, 'MedicationService',
          'VerificationQueue', request, VerificationQueueResponse());

  /// SRS-MED-007. Only eligible prescriptions produce doses.
  $async.Future<DueDosesResponse> dueDoses(
          $pb.ClientContext? ctx, DueDosesRequest request) =>
      _client.invoke<DueDosesResponse>(
          ctx, 'MedicationService', 'DueDoses', request, DueDosesResponse());

  /// SRS-MED-005.
  $async.Future<StartReconciliationResponse> startReconciliation(
          $pb.ClientContext? ctx, StartReconciliationRequest request) =>
      _client.invoke<StartReconciliationResponse>(ctx, 'MedicationService',
          'StartReconciliation', request, StartReconciliationResponse());
  $async.Future<DecideReconciliationResponse> decideReconciliation(
          $pb.ClientContext? ctx, DecideReconciliationRequest request) =>
      _client.invoke<DecideReconciliationResponse>(ctx, 'MedicationService',
          'DecideReconciliation', request, DecideReconciliationResponse());
  $async.Future<CompleteReconciliationResponse> completeReconciliation(
          $pb.ClientContext? ctx, CompleteReconciliationRequest request) =>
      _client.invoke<CompleteReconciliationResponse>(ctx, 'MedicationService',
          'CompleteReconciliation', request, CompleteReconciliationResponse());
  $async.Future<ListReconciliationsResponse> listReconciliations(
          $pb.ClientContext? ctx, ListReconciliationsRequest request) =>
      _client.invoke<ListReconciliationsResponse>(ctx, 'MedicationService',
          'ListReconciliations', request, ListReconciliationsResponse());

  /// SRS-MED-011.
  $async.Future<ProposeSubstitutionResponse> proposeSubstitution(
          $pb.ClientContext? ctx, ProposeSubstitutionRequest request) =>
      _client.invoke<ProposeSubstitutionResponse>(ctx, 'MedicationService',
          'ProposeSubstitution', request, ProposeSubstitutionResponse());
  $async.Future<AuthorizeSubstitutionResponse> authorizeSubstitution(
          $pb.ClientContext? ctx, AuthorizeSubstitutionRequest request) =>
      _client.invoke<AuthorizeSubstitutionResponse>(ctx, 'MedicationService',
          'AuthorizeSubstitution', request, AuthorizeSubstitutionResponse());
  $async.Future<RejectSubstitutionResponse> rejectSubstitution(
          $pb.ClientContext? ctx, RejectSubstitutionRequest request) =>
      _client.invoke<RejectSubstitutionResponse>(ctx, 'MedicationService',
          'RejectSubstitution', request, RejectSubstitutionResponse());
  $async.Future<DispenseSubstitutionResponse> dispenseSubstitution(
          $pb.ClientContext? ctx, DispenseSubstitutionRequest request) =>
      _client.invoke<DispenseSubstitutionResponse>(ctx, 'MedicationService',
          'DispenseSubstitution', request, DispenseSubstitutionResponse());
  $async.Future<ListSubstitutionsResponse> listSubstitutions(
          $pb.ClientContext? ctx, ListSubstitutionsRequest request) =>
      _client.invoke<ListSubstitutionsResponse>(ctx, 'MedicationService',
          'ListSubstitutions', request, ListSubstitutionsResponse());

  /// Configuration (SRS-MED-002, SRS-MED-003, SRS-MED-004, SRS-MED-012).
  $async.Future<SetFormularyEntryResponse> setFormularyEntry(
          $pb.ClientContext? ctx, SetFormularyEntryRequest request) =>
      _client.invoke<SetFormularyEntryResponse>(ctx, 'MedicationService',
          'SetFormularyEntry', request, SetFormularyEntryResponse());
  $async.Future<SetInteractionRuleResponse> setInteractionRule(
          $pb.ClientContext? ctx, SetInteractionRuleRequest request) =>
      _client.invoke<SetInteractionRuleResponse>(ctx, 'MedicationService',
          'SetInteractionRule', request, SetInteractionRuleResponse());
  $async.Future<ListInteractionRulesResponse> listInteractionRules(
          $pb.ClientContext? ctx, ListInteractionRulesRequest request) =>
      _client.invoke<ListInteractionRulesResponse>(ctx, 'MedicationService',
          'ListInteractionRules', request, ListInteractionRulesResponse());
  $async.Future<SetDoseRuleResponse> setDoseRule(
          $pb.ClientContext? ctx, SetDoseRuleRequest request) =>
      _client.invoke<SetDoseRuleResponse>(ctx, 'MedicationService',
          'SetDoseRule', request, SetDoseRuleResponse());
  $async.Future<SetTerminologyMappingResponse> setTerminologyMapping(
          $pb.ClientContext? ctx, SetTerminologyMappingRequest request) =>
      _client.invoke<SetTerminologyMappingResponse>(ctx, 'MedicationService',
          'SetTerminologyMapping', request, SetTerminologyMappingResponse());
  $async.Future<SetMedicationPolicyResponse> setMedicationPolicy(
          $pb.ClientContext? ctx, SetMedicationPolicyRequest request) =>
      _client.invoke<SetMedicationPolicyResponse>(ctx, 'MedicationService',
          'SetMedicationPolicy', request, SetMedicationPolicyResponse());
  $async.Future<GetMedicationPolicyResponse> getMedicationPolicy(
          $pb.ClientContext? ctx, GetMedicationPolicyRequest request) =>
      _client.invoke<GetMedicationPolicyResponse>(ctx, 'MedicationService',
          'GetMedicationPolicy', request, GetMedicationPolicyResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
