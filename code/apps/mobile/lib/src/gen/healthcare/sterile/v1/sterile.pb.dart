// This is a generated file - do not edit.
//
// Generated from healthcare/sterile/v1/sterile.proto.

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

import 'sterile.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'sterile.pbenum.dart';

/// One item in the instrument master (SRS-CSSD-001).
class Instrument extends $pb.GeneratedMessage {
  factory Instrument({
    $core.String? instrumentId,
    $core.String? code,
    $core.String? display,
    $core.String? serialNumber,
    InstrumentStatus? status,
    $core.String? location,
    $0.Timestamp? acquiredOn,
    $0.Timestamp? retiredOn,
    $core.String? notes,
    $fixnum.Int64? version,
    $core.bool? packable,
  }) {
    final result = create();
    if (instrumentId != null) result.instrumentId = instrumentId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (status != null) result.status = status;
    if (location != null) result.location = location;
    if (acquiredOn != null) result.acquiredOn = acquiredOn;
    if (retiredOn != null) result.retiredOn = retiredOn;
    if (notes != null) result.notes = notes;
    if (version != null) result.version = version;
    if (packable != null) result.packable = packable;
    return result;
  }

  Instrument._();

  factory Instrument.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Instrument.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Instrument',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instrumentId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'display')
    ..aOS(4, _omitFieldNames ? '' : 'serialNumber')
    ..aE<InstrumentStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: InstrumentStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'location')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'acquiredOn',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'retiredOn',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'notes')
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..aOB(11, _omitFieldNames ? '' : 'packable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Instrument clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Instrument copyWith(void Function(Instrument) updates) =>
      super.copyWith((message) => updates(message as Instrument)) as Instrument;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Instrument create() => Instrument._();
  @$core.override
  Instrument createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Instrument getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Instrument>(create);
  static Instrument? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instrumentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instrumentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstrumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrumentId() => $_clearField(1);

  /// The catalogue code, which is what a packing list names.
  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get display => $_getSZ(2);
  @$pb.TagNumber(3)
  set display($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplay() => $_clearField(3);

  /// Identifies one physical instrument where the department tracks them
  /// singly. Empty for an item counted in bulk, which is not a gap.
  @$pb.TagNumber(4)
  $core.String get serialNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set serialNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSerialNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearSerialNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  InstrumentStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(InstrumentStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get location => $_getSZ(5);
  @$pb.TagNumber(6)
  set location($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocation() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocation() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get acquiredOn => $_getN(6);
  @$pb.TagNumber(7)
  set acquiredOn($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAcquiredOn() => $_has(6);
  @$pb.TagNumber(7)
  void clearAcquiredOn() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureAcquiredOn() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get retiredOn => $_getN(7);
  @$pb.TagNumber(8)
  set retiredOn($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRetiredOn() => $_has(7);
  @$pb.TagNumber(8)
  void clearRetiredOn() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureRetiredOn() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(8);
  @$pb.TagNumber(9)
  set notes($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotes() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);

  /// Derived: only an in-service instrument may go into a tray.
  @$pb.TagNumber(11)
  $core.bool get packable => $_getBF(10);
  @$pb.TagNumber(11)
  set packable($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPackable() => $_has(10);
  @$pb.TagNumber(11)
  void clearPackable() => $_clearField(11);
}

/// One recorded move of one instrument (SRS-CSSD-012).
///
/// Append-only history rather than a status field, because the requirement is
/// about the past: whether to replace an item is answered by how often it has
/// been away, and a loss analysis asks where things were when they went
/// missing. Neither can be read from a field the next move overwrites.
class InstrumentEvent extends $pb.GeneratedMessage {
  factory InstrumentEvent({
    $core.String? instrumentEventId,
    $core.String? instrumentId,
    InstrumentStatus? fromStatus,
    InstrumentStatus? toStatus,
    $core.String? note,
    $core.String? location,
    $0.Timestamp? occurredAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (instrumentEventId != null) result.instrumentEventId = instrumentEventId;
    if (instrumentId != null) result.instrumentId = instrumentId;
    if (fromStatus != null) result.fromStatus = fromStatus;
    if (toStatus != null) result.toStatus = toStatus;
    if (note != null) result.note = note;
    if (location != null) result.location = location;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  InstrumentEvent._();

  factory InstrumentEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InstrumentEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InstrumentEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instrumentEventId')
    ..aOS(2, _omitFieldNames ? '' : 'instrumentId')
    ..aE<InstrumentStatus>(3, _omitFieldNames ? '' : 'fromStatus',
        enumValues: InstrumentStatus.values)
    ..aE<InstrumentStatus>(4, _omitFieldNames ? '' : 'toStatus',
        enumValues: InstrumentStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'note')
    ..aOS(6, _omitFieldNames ? '' : 'location')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstrumentEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstrumentEvent copyWith(void Function(InstrumentEvent) updates) =>
      super.copyWith((message) => updates(message as InstrumentEvent))
          as InstrumentEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InstrumentEvent create() => InstrumentEvent._();
  @$core.override
  InstrumentEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InstrumentEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InstrumentEvent>(create);
  static InstrumentEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instrumentEventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instrumentEventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstrumentEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrumentEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instrumentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set instrumentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstrumentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstrumentId() => $_clearField(2);

  /// What it left. Unspecified for the registration itself, which is the first
  /// row of every instrument's history.
  @$pb.TagNumber(3)
  InstrumentStatus get fromStatus => $_getN(2);
  @$pb.TagNumber(3)
  set fromStatus(InstrumentStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFromStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  InstrumentStatus get toStatus => $_getN(3);
  @$pb.TagNumber(4)
  set toStatus(InstrumentStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasToStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearToStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get note => $_getSZ(4);
  @$pb.TagNumber(5)
  set note($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearNote() => $_clearField(5);

  /// Where it was at the moment of the move, frozen. The instrument's current
  /// location moves on; a loss analysis needs where it was when it went.
  @$pb.TagNumber(6)
  $core.String get location => $_getSZ(5);
  @$pb.TagNumber(6)
  set location($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocation() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocation() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get occurredAt => $_getN(6);
  @$pb.TagNumber(7)
  set occurredAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOccurredAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearOccurredAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureOccurredAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get recordedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set recordedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRecordedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecordedBy() => $_clearField(8);
}

/// One line of a tray's packing list (SRS-CSSD-001).
class PackingItem extends $pb.GeneratedMessage {
  factory PackingItem({
    $core.String? code,
    $core.String? display,
    $core.int? quantity,
    $core.bool? critical,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (quantity != null) result.quantity = quantity;
    if (critical != null) result.critical = critical;
    return result;
  }

  PackingItem._();

  factory PackingItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PackingItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackingItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOB(4, _omitFieldNames ? '' : 'critical')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackingItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackingItem copyWith(void Function(PackingItem) updates) =>
      super.copyWith((message) => updates(message as PackingItem))
          as PackingItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PackingItem create() => PackingItem._();
  @$core.override
  PackingItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PackingItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackingItem>(create);
  static PackingItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get display => $_getSZ(1);
  @$pb.TagNumber(2)
  set display($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  /// An item the tray cannot go out without. A missing retractor is a delay; a
  /// missing blade handle is a cancelled case.
  @$pb.TagNumber(4)
  $core.bool get critical => $_getBF(3);
  @$pb.TagNumber(4)
  set critical($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCritical() => $_has(3);
  @$pb.TagNumber(4)
  void clearCritical() => $_clearField(4);
}

/// A tray, set or container (SRS-CSSD-001).
///
/// Versioned rather than edited: a tray packed last month was packed against
/// the list as it was then.
class TraySet extends $pb.GeneratedMessage {
  factory TraySet({
    $core.String? setId,
    $core.String? code,
    $core.String? display,
    $core.String? kind,
    $core.int? setVersion,
    $core.String? supersedes,
    $core.bool? current,
    $core.Iterable<PackingItem>? items,
    $fixnum.Int64? shelfLifeSeconds,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $0.Timestamp? supersededAt,
  }) {
    final result = create();
    if (setId != null) result.setId = setId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (kind != null) result.kind = kind;
    if (setVersion != null) result.setVersion = setVersion;
    if (supersedes != null) result.supersedes = supersedes;
    if (current != null) result.current = current;
    if (items != null) result.items.addAll(items);
    if (shelfLifeSeconds != null) result.shelfLifeSeconds = shelfLifeSeconds;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (supersededAt != null) result.supersededAt = supersededAt;
    return result;
  }

  TraySet._();

  factory TraySet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraySet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraySet',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'setId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'display')
    ..aOS(4, _omitFieldNames ? '' : 'kind')
    ..aI(5, _omitFieldNames ? '' : 'setVersion')
    ..aOS(6, _omitFieldNames ? '' : 'supersedes')
    ..aOB(7, _omitFieldNames ? '' : 'current')
    ..pPM<PackingItem>(8, _omitFieldNames ? '' : 'items',
        subBuilder: PackingItem.create)
    ..aInt64(9, _omitFieldNames ? '' : 'shelfLifeSeconds')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraySet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraySet copyWith(void Function(TraySet) updates) =>
      super.copyWith((message) => updates(message as TraySet)) as TraySet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraySet create() => TraySet._();
  @$core.override
  TraySet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TraySet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TraySet>(create);
  static TraySet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get setId => $_getSZ(0);
  @$pb.TagNumber(1)
  set setId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get display => $_getSZ(2);
  @$pb.TagNumber(3)
  set display($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplay() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get kind => $_getSZ(3);
  @$pb.TagNumber(4)
  set kind($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get setVersion => $_getIZ(4);
  @$pb.TagNumber(5)
  set setVersion($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSetVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearSetVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get supersedes => $_getSZ(5);
  @$pb.TagNumber(6)
  set supersedes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSupersedes() => $_has(5);
  @$pb.TagNumber(6)
  void clearSupersedes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get current => $_getBF(6);
  @$pb.TagNumber(7)
  set current($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrent() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrent() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<PackingItem> get items => $_getList(7);

  /// How long a pack of this set stays sterile once processed. Zero takes the
  /// deployment's default; a set with neither is refused at sterilisation.
  @$pb.TagNumber(9)
  $fixnum.Int64 get shelfLifeSeconds => $_getI64(8);
  @$pb.TagNumber(9)
  set shelfLifeSeconds($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShelfLifeSeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearShelfLifeSeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get createdBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set createdBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get supersededAt => $_getN(11);
  @$pb.TagNumber(12)
  set supersededAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSupersededAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearSupersededAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureSupersededAt() => $_ensure(11);
}

/// One step actually performed (SRS-CSSD-003).
class StageRecord extends $pb.GeneratedMessage {
  factory StageRecord({
    $core.String? stageRecordId,
    $core.String? runId,
    Stage? stage,
    $core.String? equipment,
    $core.String? notes,
    $core.bool? skipped,
    $core.String? skipAuthorisedBy,
    $core.String? skipReason,
    $0.Timestamp? performedAt,
    $core.String? performedBy,
  }) {
    final result = create();
    if (stageRecordId != null) result.stageRecordId = stageRecordId;
    if (runId != null) result.runId = runId;
    if (stage != null) result.stage = stage;
    if (equipment != null) result.equipment = equipment;
    if (notes != null) result.notes = notes;
    if (skipped != null) result.skipped = skipped;
    if (skipAuthorisedBy != null) result.skipAuthorisedBy = skipAuthorisedBy;
    if (skipReason != null) result.skipReason = skipReason;
    if (performedAt != null) result.performedAt = performedAt;
    if (performedBy != null) result.performedBy = performedBy;
    return result;
  }

  StageRecord._();

  factory StageRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StageRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StageRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'stageRecordId')
    ..aOS(2, _omitFieldNames ? '' : 'runId')
    ..aE<Stage>(3, _omitFieldNames ? '' : 'stage', enumValues: Stage.values)
    ..aOS(4, _omitFieldNames ? '' : 'equipment')
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..aOB(6, _omitFieldNames ? '' : 'skipped')
    ..aOS(7, _omitFieldNames ? '' : 'skipAuthorisedBy')
    ..aOS(8, _omitFieldNames ? '' : 'skipReason')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'performedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StageRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StageRecord copyWith(void Function(StageRecord) updates) =>
      super.copyWith((message) => updates(message as StageRecord))
          as StageRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StageRecord create() => StageRecord._();
  @$core.override
  StageRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StageRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StageRecord>(create);
  static StageRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stageRecordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stageRecordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStageRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStageRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get runId => $_getSZ(1);
  @$pb.TagNumber(2)
  set runId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunId() => $_clearField(2);

  @$pb.TagNumber(3)
  Stage get stage => $_getN(2);
  @$pb.TagNumber(3)
  set stage(Stage value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStage() => $_has(2);
  @$pb.TagNumber(3)
  void clearStage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get equipment => $_getSZ(3);
  @$pb.TagNumber(4)
  set equipment($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEquipment() => $_has(3);
  @$pb.TagNumber(4)
  void clearEquipment() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);

  /// An authorised exception: a stage that did not happen and was signed off.
  @$pb.TagNumber(6)
  $core.bool get skipped => $_getBF(5);
  @$pb.TagNumber(6)
  set skipped($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSkipped() => $_has(5);
  @$pb.TagNumber(6)
  void clearSkipped() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get skipAuthorisedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set skipAuthorisedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSkipAuthorisedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearSkipAuthorisedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get skipReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set skipReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSkipReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearSkipReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get performedAt => $_getN(8);
  @$pb.TagNumber(9)
  set performedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPerformedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearPerformedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensurePerformedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get performedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set performedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPerformedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearPerformedBy() => $_clearField(10);
}

/// One pass of a set through the department (SRS-CSSD-002 … 008).
class Run extends $pb.GeneratedMessage {
  factory Run({
    $core.String? runId,
    $core.String? setId,
    $core.int? setVersion,
    $core.String? setCode,
    $core.String? sourceUnit,
    $core.String? sourceCaseId,
    Stage? stage,
    $core.Iterable<StageRecord>? stages,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? receivedCount,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? packedCount,
    $core.Iterable<$core.String>? missing,
    $core.Iterable<$core.String>? replaced,
    $core.String? cycleId,
    $core.String? packagingMethod,
    $core.String? indicatorType,
    $0.Timestamp? sterilisedAt,
    $0.Timestamp? expiresAt,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $fixnum.Int64? version,
    $core.bool? issuable,
    $core.Iterable<$core.String>? skippedStages,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (setId != null) result.setId = setId;
    if (setVersion != null) result.setVersion = setVersion;
    if (setCode != null) result.setCode = setCode;
    if (sourceUnit != null) result.sourceUnit = sourceUnit;
    if (sourceCaseId != null) result.sourceCaseId = sourceCaseId;
    if (stage != null) result.stage = stage;
    if (stages != null) result.stages.addAll(stages);
    if (receivedCount != null) result.receivedCount.addEntries(receivedCount);
    if (packedCount != null) result.packedCount.addEntries(packedCount);
    if (missing != null) result.missing.addAll(missing);
    if (replaced != null) result.replaced.addAll(replaced);
    if (cycleId != null) result.cycleId = cycleId;
    if (packagingMethod != null) result.packagingMethod = packagingMethod;
    if (indicatorType != null) result.indicatorType = indicatorType;
    if (sterilisedAt != null) result.sterilisedAt = sterilisedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (version != null) result.version = version;
    if (issuable != null) result.issuable = issuable;
    if (skippedStages != null) result.skippedStages.addAll(skippedStages);
    return result;
  }

  Run._();

  factory Run.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Run.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Run',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'setId')
    ..aI(3, _omitFieldNames ? '' : 'setVersion')
    ..aOS(4, _omitFieldNames ? '' : 'setCode')
    ..aOS(5, _omitFieldNames ? '' : 'sourceUnit')
    ..aOS(6, _omitFieldNames ? '' : 'sourceCaseId')
    ..aE<Stage>(7, _omitFieldNames ? '' : 'stage', enumValues: Stage.values)
    ..pPM<StageRecord>(8, _omitFieldNames ? '' : 'stages',
        subBuilder: StageRecord.create)
    ..m<$core.String, $core.int>(9, _omitFieldNames ? '' : 'receivedCount',
        entryClassName: 'Run.ReceivedCountEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..m<$core.String, $core.int>(10, _omitFieldNames ? '' : 'packedCount',
        entryClassName: 'Run.PackedCountEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..pPS(11, _omitFieldNames ? '' : 'missing')
    ..pPS(12, _omitFieldNames ? '' : 'replaced')
    ..aOS(13, _omitFieldNames ? '' : 'cycleId')
    ..aOS(14, _omitFieldNames ? '' : 'packagingMethod')
    ..aOS(15, _omitFieldNames ? '' : 'indicatorType')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'sterilisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(19, _omitFieldNames ? '' : 'startedBy')
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..aOB(21, _omitFieldNames ? '' : 'issuable')
    ..pPS(22, _omitFieldNames ? '' : 'skippedStages')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Run clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Run copyWith(void Function(Run) updates) =>
      super.copyWith((message) => updates(message as Run)) as Run;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Run create() => Run._();
  @$core.override
  Run createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Run getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Run>(create);
  static Run? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get setId => $_getSZ(1);
  @$pb.TagNumber(2)
  set setId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSetId() => $_clearField(2);

  /// The packing list this pack was assembled against. Carried, not joined.
  @$pb.TagNumber(3)
  $core.int get setVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set setVersion($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSetVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearSetVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get setCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set setCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSetCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetCode() => $_clearField(4);

  /// Where the dirty set came from, which begins the chain of custody.
  @$pb.TagNumber(5)
  $core.String get sourceUnit => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceUnit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceUnit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceCaseId => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceCaseId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceCaseId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceCaseId() => $_clearField(6);

  @$pb.TagNumber(7)
  Stage get stage => $_getN(6);
  @$pb.TagNumber(7)
  set stage(Stage value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStage() => $_has(6);
  @$pb.TagNumber(7)
  void clearStage() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<StageRecord> get stages => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.int> get receivedCount => $_getMap(8);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.int> get packedCount => $_getMap(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get missing => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get replaced => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get cycleId => $_getSZ(12);
  @$pb.TagNumber(13)
  set cycleId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCycleId() => $_has(12);
  @$pb.TagNumber(13)
  void clearCycleId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get packagingMethod => $_getSZ(13);
  @$pb.TagNumber(14)
  set packagingMethod($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPackagingMethod() => $_has(13);
  @$pb.TagNumber(14)
  void clearPackagingMethod() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get indicatorType => $_getSZ(14);
  @$pb.TagNumber(15)
  set indicatorType($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIndicatorType() => $_has(14);
  @$pb.TagNumber(15)
  void clearIndicatorType() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get sterilisedAt => $_getN(15);
  @$pb.TagNumber(16)
  set sterilisedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSterilisedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearSterilisedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureSterilisedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $0.Timestamp get expiresAt => $_getN(16);
  @$pb.TagNumber(17)
  set expiresAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasExpiresAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearExpiresAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureExpiresAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $0.Timestamp get startedAt => $_getN(17);
  @$pb.TagNumber(18)
  set startedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasStartedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearStartedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureStartedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $core.String get startedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set startedBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasStartedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearStartedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);

  /// Derived, so a client cannot offer an expired pack by checking only the
  /// stage: the two fail independently.
  @$pb.TagNumber(21)
  $core.bool get issuable => $_getBF(20);
  @$pb.TagNumber(21)
  set issuable($core.bool value) => $_setBool(20, value);
  @$pb.TagNumber(21)
  $core.bool hasIssuable() => $_has(20);
  @$pb.TagNumber(21)
  void clearIssuable() => $_clearField(21);

  /// The reprocessing steps this pack did not actually have. An infection
  /// investigation asks this first.
  @$pb.TagNumber(22)
  $pb.PbList<$core.String> get skippedStages => $_getList(21);
}

/// One indicator read against a load (SRS-CSSD-007).
class IndicatorResult extends $pb.GeneratedMessage {
  factory IndicatorResult({
    $core.String? indicatorId,
    $core.String? cycleId,
    IndicatorKind? kind,
    $core.String? lot,
    $core.bool? passed,
    $core.String? notes,
    $0.Timestamp? readAt,
    $core.String? readBy,
  }) {
    final result = create();
    if (indicatorId != null) result.indicatorId = indicatorId;
    if (cycleId != null) result.cycleId = cycleId;
    if (kind != null) result.kind = kind;
    if (lot != null) result.lot = lot;
    if (passed != null) result.passed = passed;
    if (notes != null) result.notes = notes;
    if (readAt != null) result.readAt = readAt;
    if (readBy != null) result.readBy = readBy;
    return result;
  }

  IndicatorResult._();

  factory IndicatorResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IndicatorResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IndicatorResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'indicatorId')
    ..aOS(2, _omitFieldNames ? '' : 'cycleId')
    ..aE<IndicatorKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: IndicatorKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'lot')
    ..aOB(5, _omitFieldNames ? '' : 'passed')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'readAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'readBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndicatorResult copyWith(void Function(IndicatorResult) updates) =>
      super.copyWith((message) => updates(message as IndicatorResult))
          as IndicatorResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IndicatorResult create() => IndicatorResult._();
  @$core.override
  IndicatorResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IndicatorResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IndicatorResult>(create);
  static IndicatorResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get indicatorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set indicatorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndicatorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndicatorId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cycleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cycleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCycleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCycleId() => $_clearField(2);

  @$pb.TagNumber(3)
  IndicatorKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(IndicatorKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  /// A bad batch of indicators invalidates every load they cleared, and the lot
  /// is the only thing that can find them.
  @$pb.TagNumber(4)
  $core.String get lot => $_getSZ(3);
  @$pb.TagNumber(4)
  set lot($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLot() => $_has(3);
  @$pb.TagNumber(4)
  void clearLot() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get passed => $_getBF(4);
  @$pb.TagNumber(5)
  set passed($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassed() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get readAt => $_getN(6);
  @$pb.TagNumber(7)
  set readAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReadAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearReadAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureReadAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get readBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set readBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReadBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearReadBy() => $_clearField(8);
}

/// One sterilizer load (SRS-CSSD-006).
class Cycle extends $pb.GeneratedMessage {
  factory Cycle({
    $core.String? cycleId,
    $core.String? machine,
    $core.String? loadNumber,
    $core.String? program,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? parameters,
    CycleSource? source,
    CycleResult? result,
    $core.bool? released,
    $core.String? releasedBy,
    $0.Timestamp? releasedAt,
    $core.String? releaseNote,
    $core.Iterable<IndicatorResult>? indicators,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    $core.String? startedBy,
    $fixnum.Int64? version,
  }) {
    final result$ = create();
    if (cycleId != null) result$.cycleId = cycleId;
    if (machine != null) result$.machine = machine;
    if (loadNumber != null) result$.loadNumber = loadNumber;
    if (program != null) result$.program = program;
    if (parameters != null) result$.parameters.addEntries(parameters);
    if (source != null) result$.source = source;
    if (result != null) result$.result = result;
    if (released != null) result$.released = released;
    if (releasedBy != null) result$.releasedBy = releasedBy;
    if (releasedAt != null) result$.releasedAt = releasedAt;
    if (releaseNote != null) result$.releaseNote = releaseNote;
    if (indicators != null) result$.indicators.addAll(indicators);
    if (startedAt != null) result$.startedAt = startedAt;
    if (endedAt != null) result$.endedAt = endedAt;
    if (startedBy != null) result$.startedBy = startedBy;
    if (version != null) result$.version = version;
    return result$;
  }

  Cycle._();

  factory Cycle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Cycle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Cycle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..aOS(2, _omitFieldNames ? '' : 'machine')
    ..aOS(3, _omitFieldNames ? '' : 'loadNumber')
    ..aOS(4, _omitFieldNames ? '' : 'program')
    ..m<$core.String, $core.double>(5, _omitFieldNames ? '' : 'parameters',
        entryClassName: 'Cycle.ParametersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..aE<CycleSource>(6, _omitFieldNames ? '' : 'source',
        enumValues: CycleSource.values)
    ..aE<CycleResult>(7, _omitFieldNames ? '' : 'result',
        enumValues: CycleResult.values)
    ..aOB(8, _omitFieldNames ? '' : 'released')
    ..aOS(9, _omitFieldNames ? '' : 'releasedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'releasedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'releaseNote')
    ..pPM<IndicatorResult>(12, _omitFieldNames ? '' : 'indicators',
        subBuilder: IndicatorResult.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'startedBy')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cycle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cycle copyWith(void Function(Cycle) updates) =>
      super.copyWith((message) => updates(message as Cycle)) as Cycle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Cycle create() => Cycle._();
  @$core.override
  Cycle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Cycle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cycle>(create);
  static Cycle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  /// The machine and the load number identify the run to an engineer, and the
  /// load number is what a recall is announced by.
  @$pb.TagNumber(2)
  $core.String get machine => $_getSZ(1);
  @$pb.TagNumber(2)
  set machine($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMachine() => $_has(1);
  @$pb.TagNumber(2)
  void clearMachine() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get loadNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set loadNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLoadNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearLoadNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get program => $_getSZ(3);
  @$pb.TagNumber(4)
  set program($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProgram() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgram() => $_clearField(4);

  /// What the machine reported or a technician recorded. Free-form, because
  /// sterilizers differ and a fixed schema would lose whatever this one
  /// measures.
  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.double> get parameters => $_getMap(4);

  @$pb.TagNumber(6)
  CycleSource get source => $_getN(5);
  @$pb.TagNumber(6)
  set source(CycleSource value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);

  @$pb.TagNumber(7)
  CycleResult get result => $_getN(6);
  @$pb.TagNumber(7)
  set result(CycleResult value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasResult() => $_has(6);
  @$pb.TagNumber(7)
  void clearResult() => $_clearField(7);

  /// Separate from the result: a passed cycle with an unread biological
  /// indicator is a load nobody may distribute yet.
  @$pb.TagNumber(8)
  $core.bool get released => $_getBF(7);
  @$pb.TagNumber(8)
  set released($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReleased() => $_has(7);
  @$pb.TagNumber(8)
  void clearReleased() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get releasedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set releasedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReleasedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearReleasedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get releasedAt => $_getN(9);
  @$pb.TagNumber(10)
  set releasedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReleasedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearReleasedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureReleasedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get releaseNote => $_getSZ(10);
  @$pb.TagNumber(11)
  set releaseNote($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReleaseNote() => $_has(10);
  @$pb.TagNumber(11)
  void clearReleaseNote() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<IndicatorResult> get indicators => $_getList(11);

  @$pb.TagNumber(13)
  $0.Timestamp get startedAt => $_getN(12);
  @$pb.TagNumber(13)
  set startedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStartedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearStartedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureStartedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get endedAt => $_getN(13);
  @$pb.TagNumber(14)
  set endedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEndedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureEndedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get startedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set startedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasStartedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearStartedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

/// Whether a load's packs may be distributed (SRS-CSSD-007).
class ReleaseDecision extends $pb.GeneratedMessage {
  factory ReleaseDecision({
    $core.bool? allowed,
    $core.Iterable<ReleaseRefusal>? refusals,
    $core.Iterable<$core.String>? explanations,
  }) {
    final result = create();
    if (allowed != null) result.allowed = allowed;
    if (refusals != null) result.refusals.addAll(refusals);
    if (explanations != null) result.explanations.addAll(explanations);
    return result;
  }

  ReleaseDecision._();

  factory ReleaseDecision.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseDecision.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseDecision',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowed')
    ..pc<ReleaseRefusal>(
        2, _omitFieldNames ? '' : 'refusals', $pb.PbFieldType.KE,
        valueOf: ReleaseRefusal.valueOf,
        enumValues: ReleaseRefusal.values,
        defaultEnumValue: ReleaseRefusal.RELEASE_REFUSAL_UNSPECIFIED)
    ..pPS(3, _omitFieldNames ? '' : 'explanations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseDecision clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseDecision copyWith(void Function(ReleaseDecision) updates) =>
      super.copyWith((message) => updates(message as ReleaseDecision))
          as ReleaseDecision;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseDecision create() => ReleaseDecision._();
  @$core.override
  ReleaseDecision createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseDecision getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseDecision>(create);
  static ReleaseDecision? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowed => $_getBF(0);
  @$pb.TagNumber(1)
  set allowed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowed() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowed() => $_clearField(1);

  /// Every reason, not the first: a technician told one at a time comes back to
  /// the same screen three times.
  @$pb.TagNumber(2)
  $pb.PbList<ReleaseRefusal> get refusals => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get explanations => $_getList(2);
}

/// What goes on the outside of a pack (SRS-CSSD-008).
///
/// Derived, never submitted.
class Label extends $pb.GeneratedMessage {
  factory Label({
    $core.String? runId,
    $core.String? setCode,
    $core.int? setVersion,
    $core.String? cycleId,
    $core.String? loadNumber,
    $core.String? machine,
    $0.Timestamp? sterilisedAt,
    $0.Timestamp? expiresAt,
    $core.Iterable<$core.String>? incomplete,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (setCode != null) result.setCode = setCode;
    if (setVersion != null) result.setVersion = setVersion;
    if (cycleId != null) result.cycleId = cycleId;
    if (loadNumber != null) result.loadNumber = loadNumber;
    if (machine != null) result.machine = machine;
    if (sterilisedAt != null) result.sterilisedAt = sterilisedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (incomplete != null) result.incomplete.addAll(incomplete);
    return result;
  }

  Label._();

  factory Label.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Label.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Label',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'setCode')
    ..aI(3, _omitFieldNames ? '' : 'setVersion')
    ..aOS(4, _omitFieldNames ? '' : 'cycleId')
    ..aOS(5, _omitFieldNames ? '' : 'loadNumber')
    ..aOS(6, _omitFieldNames ? '' : 'machine')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'sterilisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..pPS(9, _omitFieldNames ? '' : 'incomplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Label clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Label copyWith(void Function(Label) updates) =>
      super.copyWith((message) => updates(message as Label)) as Label;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Label create() => Label._();
  @$core.override
  Label createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Label getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Label>(create);
  static Label? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get setCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set setCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSetCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearSetCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get setVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set setVersion($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSetVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearSetVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cycleId => $_getSZ(3);
  @$pb.TagNumber(4)
  set cycleId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCycleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCycleId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get loadNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set loadNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLoadNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearLoadNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get machine => $_getSZ(5);
  @$pb.TagNumber(6)
  set machine($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMachine() => $_has(5);
  @$pb.TagNumber(6)
  void clearMachine() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get sterilisedAt => $_getN(6);
  @$pb.TagNumber(7)
  set sterilisedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSterilisedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearSterilisedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureSterilisedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get expiresAt => $_getN(7);
  @$pb.TagNumber(8)
  set expiresAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpiresAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiresAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureExpiresAt() => $_ensure(7);

  /// What the label could not be built from. A pack whose label silently
  /// omitted its cycle would look like any other.
  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get incomplete => $_getList(8);
}

/// A sterile pack leaving the department (SRS-CSSD-009).
class Issue extends $pb.GeneratedMessage {
  factory Issue({
    $core.String? issueId,
    $core.String? runId,
    $core.String? setCode,
    $core.String? cycleId,
    $core.String? destination,
    $core.String? issuedTo,
    IssueState? state,
    $core.String? usedCaseId,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? returnCount,
    $core.String? returnNote,
    $0.Timestamp? issuedAt,
    $core.String? issuedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
  }) {
    final result = create();
    if (issueId != null) result.issueId = issueId;
    if (runId != null) result.runId = runId;
    if (setCode != null) result.setCode = setCode;
    if (cycleId != null) result.cycleId = cycleId;
    if (destination != null) result.destination = destination;
    if (issuedTo != null) result.issuedTo = issuedTo;
    if (state != null) result.state = state;
    if (usedCaseId != null) result.usedCaseId = usedCaseId;
    if (returnCount != null) result.returnCount.addEntries(returnCount);
    if (returnNote != null) result.returnNote = returnNote;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (issuedBy != null) result.issuedBy = issuedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    return result;
  }

  Issue._();

  factory Issue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Issue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Issue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issueId')
    ..aOS(2, _omitFieldNames ? '' : 'runId')
    ..aOS(3, _omitFieldNames ? '' : 'setCode')
    ..aOS(4, _omitFieldNames ? '' : 'cycleId')
    ..aOS(5, _omitFieldNames ? '' : 'destination')
    ..aOS(6, _omitFieldNames ? '' : 'issuedTo')
    ..aE<IssueState>(7, _omitFieldNames ? '' : 'state',
        enumValues: IssueState.values)
    ..aOS(8, _omitFieldNames ? '' : 'usedCaseId')
    ..m<$core.String, $core.int>(9, _omitFieldNames ? '' : 'returnCount',
        entryClassName: 'Issue.ReturnCountEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..aOS(10, _omitFieldNames ? '' : 'returnNote')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'issuedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'closedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Issue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Issue copyWith(void Function(Issue) updates) =>
      super.copyWith((message) => updates(message as Issue)) as Issue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Issue create() => Issue._();
  @$core.override
  Issue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Issue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Issue>(create);
  static Issue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set issueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get runId => $_getSZ(1);
  @$pb.TagNumber(2)
  set runId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get setCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set setCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSetCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearSetCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cycleId => $_getSZ(3);
  @$pb.TagNumber(4)
  set cycleId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCycleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCycleId() => $_clearField(4);

  /// A pack with no destination is one nobody can fetch back, which is what a
  /// recall has to do.
  @$pb.TagNumber(5)
  $core.String get destination => $_getSZ(4);
  @$pb.TagNumber(5)
  set destination($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDestination() => $_has(4);
  @$pb.TagNumber(5)
  void clearDestination() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get issuedTo => $_getSZ(5);
  @$pb.TagNumber(6)
  set issuedTo($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIssuedTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearIssuedTo() => $_clearField(6);

  @$pb.TagNumber(7)
  IssueState get state => $_getN(6);
  @$pb.TagNumber(7)
  set state(IssueState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  /// The link SRS-CSSD-010's case trace runs along.
  @$pb.TagNumber(8)
  $core.String get usedCaseId => $_getSZ(7);
  @$pb.TagNumber(8)
  set usedCaseId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsedCaseId() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsedCaseId() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.int> get returnCount => $_getMap(8);

  @$pb.TagNumber(10)
  $core.String get returnNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set returnNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReturnNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearReturnNote() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get issuedAt => $_getN(10);
  @$pb.TagNumber(11)
  set issuedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasIssuedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearIssuedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureIssuedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get issuedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set issuedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIssuedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearIssuedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get closedAt => $_getN(12);
  @$pb.TagNumber(13)
  set closedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasClosedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearClosedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureClosedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get closedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set closedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasClosedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearClosedBy() => $_clearField(14);
}

/// One set used in a case, with its cycle (SRS-CSSD-010).
class TracedSet extends $pb.GeneratedMessage {
  factory TracedSet({
    $core.String? runId,
    $core.String? setCode,
    $core.int? setVersion,
    $core.String? cycleId,
    $core.String? loadNumber,
    $core.String? machine,
    $core.Iterable<$core.String>? skippedStages,
    $0.Timestamp? sterilisedAt,
    $0.Timestamp? usedAt,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (setCode != null) result.setCode = setCode;
    if (setVersion != null) result.setVersion = setVersion;
    if (cycleId != null) result.cycleId = cycleId;
    if (loadNumber != null) result.loadNumber = loadNumber;
    if (machine != null) result.machine = machine;
    if (skippedStages != null) result.skippedStages.addAll(skippedStages);
    if (sterilisedAt != null) result.sterilisedAt = sterilisedAt;
    if (usedAt != null) result.usedAt = usedAt;
    return result;
  }

  TracedSet._();

  factory TracedSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TracedSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TracedSet',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'setCode')
    ..aI(3, _omitFieldNames ? '' : 'setVersion')
    ..aOS(4, _omitFieldNames ? '' : 'cycleId')
    ..aOS(5, _omitFieldNames ? '' : 'loadNumber')
    ..aOS(6, _omitFieldNames ? '' : 'machine')
    ..pPS(7, _omitFieldNames ? '' : 'skippedStages')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'sterilisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'usedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TracedSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TracedSet copyWith(void Function(TracedSet) updates) =>
      super.copyWith((message) => updates(message as TracedSet)) as TracedSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TracedSet create() => TracedSet._();
  @$core.override
  TracedSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TracedSet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TracedSet>(create);
  static TracedSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get setCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set setCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSetCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearSetCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get setVersion => $_getIZ(2);
  @$pb.TagNumber(3)
  set setVersion($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSetVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearSetVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cycleId => $_getSZ(3);
  @$pb.TagNumber(4)
  set cycleId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCycleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCycleId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get loadNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set loadNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLoadNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearLoadNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get machine => $_getSZ(5);
  @$pb.TagNumber(6)
  set machine($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMachine() => $_has(5);
  @$pb.TagNumber(6)
  void clearMachine() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get skippedStages => $_getList(6);

  @$pb.TagNumber(8)
  $0.Timestamp get sterilisedAt => $_getN(7);
  @$pb.TagNumber(8)
  set sterilisedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSterilisedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearSterilisedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureSterilisedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get usedAt => $_getN(8);
  @$pb.TagNumber(9)
  set usedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUsedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUsedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureUsedAt() => $_ensure(8);
}

/// Everything a patient's procedure touched (SRS-CSSD-010).
class CaseTrace extends $pb.GeneratedMessage {
  factory CaseTrace({
    $core.String? caseId,
    $core.Iterable<TracedSet>? sets,
    $core.Iterable<$core.String>? incomplete,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    if (sets != null) result.sets.addAll(sets);
    if (incomplete != null) result.incomplete.addAll(incomplete);
    return result;
  }

  CaseTrace._();

  factory CaseTrace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CaseTrace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CaseTrace',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..pPM<TracedSet>(2, _omitFieldNames ? '' : 'sets',
        subBuilder: TracedSet.create)
    ..pPS(3, _omitFieldNames ? '' : 'incomplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaseTrace clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaseTrace copyWith(void Function(CaseTrace) updates) =>
      super.copyWith((message) => updates(message as CaseTrace)) as CaseTrace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CaseTrace create() => CaseTrace._();
  @$core.override
  CaseTrace createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CaseTrace getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CaseTrace>(create);
  static CaseTrace? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<TracedSet> get sets => $_getList(1);

  /// Sets whose chain could not be followed, so a reader can tell "three sets"
  /// from "three sets that we know of".
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get incomplete => $_getList(2);
}

/// One pack in a recall (SRS-CSSD-011).
class RecalledPack extends $pb.GeneratedMessage {
  factory RecalledPack({
    $core.String? runId,
    $core.String? setCode,
    $core.String? state,
    $core.String? location,
    $core.String? usedCaseId,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (setCode != null) result.setCode = setCode;
    if (state != null) result.state = state;
    if (location != null) result.location = location;
    if (usedCaseId != null) result.usedCaseId = usedCaseId;
    return result;
  }

  RecalledPack._();

  factory RecalledPack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecalledPack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecalledPack',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'setCode')
    ..aOS(3, _omitFieldNames ? '' : 'state')
    ..aOS(4, _omitFieldNames ? '' : 'location')
    ..aOS(5, _omitFieldNames ? '' : 'usedCaseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecalledPack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecalledPack copyWith(void Function(RecalledPack) updates) =>
      super.copyWith((message) => updates(message as RecalledPack))
          as RecalledPack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecalledPack create() => RecalledPack._();
  @$core.override
  RecalledPack createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecalledPack getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecalledPack>(create);
  static RecalledPack? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get setCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set setCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSetCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearSetCode() => $_clearField(2);

  /// Where it is: still in the department, out somewhere, or already used. The
  /// three need different actions.
  @$pb.TagNumber(3)
  $core.String get state => $_getSZ(2);
  @$pb.TagNumber(3)
  set state($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get location => $_getSZ(3);
  @$pb.TagNumber(4)
  set location($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get usedCaseId => $_getSZ(4);
  @$pb.TagNumber(5)
  set usedCaseId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUsedCaseId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUsedCaseId() => $_clearField(5);
}

/// What a failed load reaches (SRS-CSSD-011).
class RecallScope extends $pb.GeneratedMessage {
  factory RecallScope({
    $core.String? cycleId,
    $core.String? loadNumber,
    $core.String? reason,
    $core.Iterable<RecalledPack>? packs,
    $core.Iterable<$core.String>? cases,
    $core.Iterable<$core.String>? locations,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    if (loadNumber != null) result.loadNumber = loadNumber;
    if (reason != null) result.reason = reason;
    if (packs != null) result.packs.addAll(packs);
    if (cases != null) result.cases.addAll(cases);
    if (locations != null) result.locations.addAll(locations);
    return result;
  }

  RecallScope._();

  factory RecallScope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecallScope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecallScope',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..aOS(2, _omitFieldNames ? '' : 'loadNumber')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..pPM<RecalledPack>(4, _omitFieldNames ? '' : 'packs',
        subBuilder: RecalledPack.create)
    ..pPS(5, _omitFieldNames ? '' : 'cases')
    ..pPS(6, _omitFieldNames ? '' : 'locations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallScope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallScope copyWith(void Function(RecallScope) updates) =>
      super.copyWith((message) => updates(message as RecallScope))
          as RecallScope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecallScope create() => RecallScope._();
  @$core.override
  RecallScope createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecallScope getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecallScope>(create);
  static RecallScope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get loadNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set loadNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLoadNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoadNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<RecalledPack> get packs => $_getList(3);

  /// The operations a pack from this load was opened for. The list that has to
  /// reach infection control, because those patients cannot have the pack back.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get cases => $_getList(4);

  /// Where the unopened packs are, so somebody can go and fetch them.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get locations => $_getList(5);
}

/// A raised recall (SRS-CSSD-011).
class Recall extends $pb.GeneratedMessage {
  factory Recall({
    $core.String? recallId,
    $core.String? cycleId,
    $core.String? reason,
    $core.int? packsAffected,
    $core.int? casesAffected,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? closingNote,
  }) {
    final result = create();
    if (recallId != null) result.recallId = recallId;
    if (cycleId != null) result.cycleId = cycleId;
    if (reason != null) result.reason = reason;
    if (packsAffected != null) result.packsAffected = packsAffected;
    if (casesAffected != null) result.casesAffected = casesAffected;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closingNote != null) result.closingNote = closingNote;
    return result;
  }

  Recall._();

  factory Recall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Recall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Recall',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recallId')
    ..aOS(2, _omitFieldNames ? '' : 'cycleId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aI(4, _omitFieldNames ? '' : 'packsAffected')
    ..aI(5, _omitFieldNames ? '' : 'casesAffected')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'raisedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'closedBy')
    ..aOS(10, _omitFieldNames ? '' : 'closingNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Recall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Recall copyWith(void Function(Recall) updates) =>
      super.copyWith((message) => updates(message as Recall)) as Recall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Recall create() => Recall._();
  @$core.override
  Recall createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Recall getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Recall>(create);
  static Recall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recallId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recallId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecallId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cycleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cycleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCycleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCycleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  /// Frozen at the moment it was raised, because the packs move afterwards and
  /// a recall report has to say what it found.
  @$pb.TagNumber(4)
  $core.int get packsAffected => $_getIZ(3);
  @$pb.TagNumber(4)
  set packsAffected($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPacksAffected() => $_has(3);
  @$pb.TagNumber(4)
  void clearPacksAffected() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get casesAffected => $_getIZ(4);
  @$pb.TagNumber(5)
  set casesAffected($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCasesAffected() => $_has(4);
  @$pb.TagNumber(5)
  void clearCasesAffected() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get raisedAt => $_getN(5);
  @$pb.TagNumber(6)
  set raisedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRaisedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearRaisedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureRaisedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get raisedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set raisedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRaisedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearRaisedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get closedAt => $_getN(7);
  @$pb.TagNumber(8)
  set closedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasClosedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearClosedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureClosedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get closedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set closedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasClosedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearClosedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get closingNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set closingNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClosingNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearClosingNote() => $_clearField(10);
}

class RegisterInstrumentRequest extends $pb.GeneratedMessage {
  factory RegisterInstrumentRequest({
    $core.String? code,
    $core.String? display,
    $core.String? serialNumber,
    $core.String? location,
    $0.Timestamp? acquiredOn,
    $core.String? notes,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (location != null) result.location = location;
    if (acquiredOn != null) result.acquiredOn = acquiredOn;
    if (notes != null) result.notes = notes;
    return result;
  }

  RegisterInstrumentRequest._();

  factory RegisterInstrumentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterInstrumentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterInstrumentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aOS(3, _omitFieldNames ? '' : 'serialNumber')
    ..aOS(4, _omitFieldNames ? '' : 'location')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'acquiredOn',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterInstrumentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterInstrumentRequest copyWith(
          void Function(RegisterInstrumentRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterInstrumentRequest))
          as RegisterInstrumentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterInstrumentRequest create() => RegisterInstrumentRequest._();
  @$core.override
  RegisterInstrumentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterInstrumentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterInstrumentRequest>(create);
  static RegisterInstrumentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get display => $_getSZ(1);
  @$pb.TagNumber(2)
  set display($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get serialNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set serialNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSerialNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearSerialNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get location => $_getSZ(3);
  @$pb.TagNumber(4)
  set location($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get acquiredOn => $_getN(4);
  @$pb.TagNumber(5)
  set acquiredOn($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAcquiredOn() => $_has(4);
  @$pb.TagNumber(5)
  void clearAcquiredOn() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureAcquiredOn() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);
}

class RegisterInstrumentResponse extends $pb.GeneratedMessage {
  factory RegisterInstrumentResponse({
    Instrument? instrument,
  }) {
    final result = create();
    if (instrument != null) result.instrument = instrument;
    return result;
  }

  RegisterInstrumentResponse._();

  factory RegisterInstrumentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterInstrumentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterInstrumentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Instrument>(1, _omitFieldNames ? '' : 'instrument',
        subBuilder: Instrument.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterInstrumentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterInstrumentResponse copyWith(
          void Function(RegisterInstrumentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RegisterInstrumentResponse))
          as RegisterInstrumentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterInstrumentResponse create() => RegisterInstrumentResponse._();
  @$core.override
  RegisterInstrumentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterInstrumentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterInstrumentResponse>(create);
  static RegisterInstrumentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Instrument get instrument => $_getN(0);
  @$pb.TagNumber(1)
  set instrument(Instrument value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstrument() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrument() => $_clearField(1);
  @$pb.TagNumber(1)
  Instrument ensureInstrument() => $_ensure(0);
}

class MoveInstrumentRequest extends $pb.GeneratedMessage {
  factory MoveInstrumentRequest({
    $core.String? instrumentId,
    InstrumentStatus? status,
    $core.String? note,
  }) {
    final result = create();
    if (instrumentId != null) result.instrumentId = instrumentId;
    if (status != null) result.status = status;
    if (note != null) result.note = note;
    return result;
  }

  MoveInstrumentRequest._();

  factory MoveInstrumentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveInstrumentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveInstrumentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instrumentId')
    ..aE<InstrumentStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: InstrumentStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveInstrumentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveInstrumentRequest copyWith(
          void Function(MoveInstrumentRequest) updates) =>
      super.copyWith((message) => updates(message as MoveInstrumentRequest))
          as MoveInstrumentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveInstrumentRequest create() => MoveInstrumentRequest._();
  @$core.override
  MoveInstrumentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveInstrumentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveInstrumentRequest>(create);
  static MoveInstrumentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instrumentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instrumentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstrumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  InstrumentStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(InstrumentStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// Required for anything but a return to service: a status change with no
  /// reason is a number in a report nobody can act on.
  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class MoveInstrumentResponse extends $pb.GeneratedMessage {
  factory MoveInstrumentResponse({
    Instrument? instrument,
  }) {
    final result = create();
    if (instrument != null) result.instrument = instrument;
    return result;
  }

  MoveInstrumentResponse._();

  factory MoveInstrumentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveInstrumentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveInstrumentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Instrument>(1, _omitFieldNames ? '' : 'instrument',
        subBuilder: Instrument.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveInstrumentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveInstrumentResponse copyWith(
          void Function(MoveInstrumentResponse) updates) =>
      super.copyWith((message) => updates(message as MoveInstrumentResponse))
          as MoveInstrumentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveInstrumentResponse create() => MoveInstrumentResponse._();
  @$core.override
  MoveInstrumentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveInstrumentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveInstrumentResponse>(create);
  static MoveInstrumentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Instrument get instrument => $_getN(0);
  @$pb.TagNumber(1)
  set instrument(Instrument value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstrument() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrument() => $_clearField(1);
  @$pb.TagNumber(1)
  Instrument ensureInstrument() => $_ensure(0);
}

class ListInstrumentsRequest extends $pb.GeneratedMessage {
  factory ListInstrumentsRequest({
    $core.String? code,
    $core.bool? outOfServiceOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (outOfServiceOnly != null) result.outOfServiceOnly = outOfServiceOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListInstrumentsRequest._();

  factory ListInstrumentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInstrumentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInstrumentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOB(2, _omitFieldNames ? '' : 'outOfServiceOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentsRequest copyWith(
          void Function(ListInstrumentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListInstrumentsRequest))
          as ListInstrumentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInstrumentsRequest create() => ListInstrumentsRequest._();
  @$core.override
  ListInstrumentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInstrumentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInstrumentsRequest>(create);
  static ListInstrumentsRequest? _defaultInstance;

  /// Empty lists the whole master.
  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  /// True lists only what is away, missing or retired (SRS-CSSD-012).
  @$pb.TagNumber(2)
  $core.bool get outOfServiceOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set outOfServiceOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutOfServiceOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutOfServiceOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListInstrumentsResponse extends $pb.GeneratedMessage {
  factory ListInstrumentsResponse({
    $core.Iterable<Instrument>? instruments,
  }) {
    final result = create();
    if (instruments != null) result.instruments.addAll(instruments);
    return result;
  }

  ListInstrumentsResponse._();

  factory ListInstrumentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInstrumentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInstrumentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Instrument>(1, _omitFieldNames ? '' : 'instruments',
        subBuilder: Instrument.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentsResponse copyWith(
          void Function(ListInstrumentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListInstrumentsResponse))
          as ListInstrumentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInstrumentsResponse create() => ListInstrumentsResponse._();
  @$core.override
  ListInstrumentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInstrumentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInstrumentsResponse>(create);
  static ListInstrumentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Instrument> get instruments => $_getList(0);
}

class GetInstrumentHistoryRequest extends $pb.GeneratedMessage {
  factory GetInstrumentHistoryRequest({
    $core.String? instrumentId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (instrumentId != null) result.instrumentId = instrumentId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetInstrumentHistoryRequest._();

  factory GetInstrumentHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInstrumentHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInstrumentHistoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instrumentId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstrumentHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstrumentHistoryRequest copyWith(
          void Function(GetInstrumentHistoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetInstrumentHistoryRequest))
          as GetInstrumentHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInstrumentHistoryRequest create() =>
      GetInstrumentHistoryRequest._();
  @$core.override
  GetInstrumentHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetInstrumentHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInstrumentHistoryRequest>(create);
  static GetInstrumentHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instrumentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set instrumentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstrumentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrumentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class GetInstrumentHistoryResponse extends $pb.GeneratedMessage {
  factory GetInstrumentHistoryResponse({
    $core.Iterable<InstrumentEvent>? events,
  }) {
    final result = create();
    if (events != null) result.events.addAll(events);
    return result;
  }

  GetInstrumentHistoryResponse._();

  factory GetInstrumentHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInstrumentHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInstrumentHistoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<InstrumentEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: InstrumentEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstrumentHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstrumentHistoryResponse copyWith(
          void Function(GetInstrumentHistoryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetInstrumentHistoryResponse))
          as GetInstrumentHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInstrumentHistoryResponse create() =>
      GetInstrumentHistoryResponse._();
  @$core.override
  GetInstrumentHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetInstrumentHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInstrumentHistoryResponse>(create);
  static GetInstrumentHistoryResponse? _defaultInstance;

  /// Most recent first.
  @$pb.TagNumber(1)
  $pb.PbList<InstrumentEvent> get events => $_getList(0);
}

class ListInstrumentMovesRequest extends $pb.GeneratedMessage {
  factory ListInstrumentMovesRequest({
    InstrumentStatus? status,
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
    $core.int? pageSize,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListInstrumentMovesRequest._();

  factory ListInstrumentMovesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInstrumentMovesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInstrumentMovesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aE<InstrumentStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: InstrumentStatus.values)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentMovesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentMovesRequest copyWith(
          void Function(ListInstrumentMovesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListInstrumentMovesRequest))
          as ListInstrumentMovesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInstrumentMovesRequest create() => ListInstrumentMovesRequest._();
  @$core.override
  ListInstrumentMovesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInstrumentMovesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInstrumentMovesRequest>(create);
  static ListInstrumentMovesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  InstrumentStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(InstrumentStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  /// A period is required rather than defaulted: "every instrument ever lost"
  /// and "the ones lost since April" are different reports, and a caller who
  /// meant the second should not be handed the first.
  @$pb.TagNumber(2)
  $0.Timestamp get periodStart => $_getN(1);
  @$pb.TagNumber(2)
  set periodStart($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodStart() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodStart() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get periodEnd => $_getN(2);
  @$pb.TagNumber(3)
  set periodEnd($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodEnd() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListInstrumentMovesResponse extends $pb.GeneratedMessage {
  factory ListInstrumentMovesResponse({
    $core.Iterable<InstrumentEvent>? events,
  }) {
    final result = create();
    if (events != null) result.events.addAll(events);
    return result;
  }

  ListInstrumentMovesResponse._();

  factory ListInstrumentMovesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInstrumentMovesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInstrumentMovesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<InstrumentEvent>(1, _omitFieldNames ? '' : 'events',
        subBuilder: InstrumentEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentMovesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInstrumentMovesResponse copyWith(
          void Function(ListInstrumentMovesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListInstrumentMovesResponse))
          as ListInstrumentMovesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInstrumentMovesResponse create() =>
      ListInstrumentMovesResponse._();
  @$core.override
  ListInstrumentMovesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInstrumentMovesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInstrumentMovesResponse>(create);
  static ListInstrumentMovesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InstrumentEvent> get events => $_getList(0);
}

class DefineSetRequest extends $pb.GeneratedMessage {
  factory DefineSetRequest({
    $core.String? code,
    $core.String? display,
    $core.String? kind,
    $core.Iterable<PackingItem>? items,
    $fixnum.Int64? shelfLifeSeconds,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (kind != null) result.kind = kind;
    if (items != null) result.items.addAll(items);
    if (shelfLifeSeconds != null) result.shelfLifeSeconds = shelfLifeSeconds;
    return result;
  }

  DefineSetRequest._();

  factory DefineSetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineSetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineSetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aOS(3, _omitFieldNames ? '' : 'kind')
    ..pPM<PackingItem>(4, _omitFieldNames ? '' : 'items',
        subBuilder: PackingItem.create)
    ..aInt64(5, _omitFieldNames ? '' : 'shelfLifeSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSetRequest copyWith(void Function(DefineSetRequest) updates) =>
      super.copyWith((message) => updates(message as DefineSetRequest))
          as DefineSetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineSetRequest create() => DefineSetRequest._();
  @$core.override
  DefineSetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineSetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineSetRequest>(create);
  static DefineSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get display => $_getSZ(1);
  @$pb.TagNumber(2)
  set display($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get kind => $_getSZ(2);
  @$pb.TagNumber(3)
  set kind($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<PackingItem> get items => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get shelfLifeSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set shelfLifeSeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShelfLifeSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearShelfLifeSeconds() => $_clearField(5);
}

class DefineSetResponse extends $pb.GeneratedMessage {
  factory DefineSetResponse({
    TraySet? set,
  }) {
    final result = create();
    if (set != null) result.set = set;
    return result;
  }

  DefineSetResponse._();

  factory DefineSetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineSetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineSetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<TraySet>(1, _omitFieldNames ? '' : 'set', subBuilder: TraySet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineSetResponse copyWith(void Function(DefineSetResponse) updates) =>
      super.copyWith((message) => updates(message as DefineSetResponse))
          as DefineSetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineSetResponse create() => DefineSetResponse._();
  @$core.override
  DefineSetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineSetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineSetResponse>(create);
  static DefineSetResponse? _defaultInstance;

  /// A code that already has a current version is revised rather than replaced,
  /// and the response carries the new version number.
  @$pb.TagNumber(1)
  TraySet get set => $_getN(0);
  @$pb.TagNumber(1)
  set set(TraySet value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSet() => $_has(0);
  @$pb.TagNumber(1)
  void clearSet() => $_clearField(1);
  @$pb.TagNumber(1)
  TraySet ensureSet() => $_ensure(0);
}

class GetSetRequest extends $pb.GeneratedMessage {
  factory GetSetRequest({
    $core.String? setId,
    $core.String? code,
  }) {
    final result = create();
    if (setId != null) result.setId = setId;
    if (code != null) result.code = code;
    return result;
  }

  GetSetRequest._();

  factory GetSetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'setId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetRequest copyWith(void Function(GetSetRequest) updates) =>
      super.copyWith((message) => updates(message as GetSetRequest))
          as GetSetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSetRequest create() => GetSetRequest._();
  @$core.override
  GetSetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSetRequest>(create);
  static GetSetRequest? _defaultInstance;

  /// Either: the code resolves to the version in force, the id to one version.
  @$pb.TagNumber(1)
  $core.String get setId => $_getSZ(0);
  @$pb.TagNumber(1)
  set setId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);
}

class GetSetResponse extends $pb.GeneratedMessage {
  factory GetSetResponse({
    TraySet? set,
  }) {
    final result = create();
    if (set != null) result.set = set;
    return result;
  }

  GetSetResponse._();

  factory GetSetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<TraySet>(1, _omitFieldNames ? '' : 'set', subBuilder: TraySet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSetResponse copyWith(void Function(GetSetResponse) updates) =>
      super.copyWith((message) => updates(message as GetSetResponse))
          as GetSetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSetResponse create() => GetSetResponse._();
  @$core.override
  GetSetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSetResponse>(create);
  static GetSetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TraySet get set => $_getN(0);
  @$pb.TagNumber(1)
  set set(TraySet value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSet() => $_has(0);
  @$pb.TagNumber(1)
  void clearSet() => $_clearField(1);
  @$pb.TagNumber(1)
  TraySet ensureSet() => $_ensure(0);
}

class ListSetVersionsRequest extends $pb.GeneratedMessage {
  factory ListSetVersionsRequest({
    $core.String? code,
  }) {
    final result = create();
    if (code != null) result.code = code;
    return result;
  }

  ListSetVersionsRequest._();

  factory ListSetVersionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSetVersionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSetVersionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetVersionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetVersionsRequest copyWith(
          void Function(ListSetVersionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSetVersionsRequest))
          as ListSetVersionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSetVersionsRequest create() => ListSetVersionsRequest._();
  @$core.override
  ListSetVersionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSetVersionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSetVersionsRequest>(create);
  static ListSetVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class ListSetVersionsResponse extends $pb.GeneratedMessage {
  factory ListSetVersionsResponse({
    $core.Iterable<TraySet>? versions,
  }) {
    final result = create();
    if (versions != null) result.versions.addAll(versions);
    return result;
  }

  ListSetVersionsResponse._();

  factory ListSetVersionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSetVersionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSetVersionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<TraySet>(1, _omitFieldNames ? '' : 'versions',
        subBuilder: TraySet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetVersionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetVersionsResponse copyWith(
          void Function(ListSetVersionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSetVersionsResponse))
          as ListSetVersionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSetVersionsResponse create() => ListSetVersionsResponse._();
  @$core.override
  ListSetVersionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSetVersionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSetVersionsResponse>(create);
  static ListSetVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TraySet> get versions => $_getList(0);
}

class ListSetsRequest extends $pb.GeneratedMessage {
  factory ListSetsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListSetsRequest._();

  factory ListSetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSetsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetsRequest copyWith(void Function(ListSetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSetsRequest))
          as ListSetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSetsRequest create() => ListSetsRequest._();
  @$core.override
  ListSetsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSetsRequest>(create);
  static ListSetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListSetsResponse extends $pb.GeneratedMessage {
  factory ListSetsResponse({
    $core.Iterable<TraySet>? sets,
  }) {
    final result = create();
    if (sets != null) result.sets.addAll(sets);
    return result;
  }

  ListSetsResponse._();

  factory ListSetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSetsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<TraySet>(1, _omitFieldNames ? '' : 'sets', subBuilder: TraySet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSetsResponse copyWith(void Function(ListSetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSetsResponse))
          as ListSetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSetsResponse create() => ListSetsResponse._();
  @$core.override
  ListSetsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSetsResponse>(create);
  static ListSetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TraySet> get sets => $_getList(0);
}

class ReceiveRequest extends $pb.GeneratedMessage {
  factory ReceiveRequest({
    $core.String? setCode,
    $core.String? sourceUnit,
    $core.String? sourceCaseId,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? counted,
  }) {
    final result = create();
    if (setCode != null) result.setCode = setCode;
    if (sourceUnit != null) result.sourceUnit = sourceUnit;
    if (sourceCaseId != null) result.sourceCaseId = sourceCaseId;
    if (counted != null) result.counted.addEntries(counted);
    return result;
  }

  ReceiveRequest._();

  factory ReceiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'setCode')
    ..aOS(2, _omitFieldNames ? '' : 'sourceUnit')
    ..aOS(3, _omitFieldNames ? '' : 'sourceCaseId')
    ..m<$core.String, $core.int>(4, _omitFieldNames ? '' : 'counted',
        entryClassName: 'ReceiveRequest.CountedEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveRequest copyWith(void Function(ReceiveRequest) updates) =>
      super.copyWith((message) => updates(message as ReceiveRequest))
          as ReceiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveRequest create() => ReceiveRequest._();
  @$core.override
  ReceiveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveRequest>(create);
  static ReceiveRequest? _defaultInstance;

  /// The technician scans the tray; which version of the packing list applies
  /// is the service's to resolve.
  @$pb.TagNumber(1)
  $core.String get setCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set setCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceUnit => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceUnit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceUnit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceCaseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceCaseId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceCaseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceCaseId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.int> get counted => $_getMap(3);
}

class ReceiveResponse extends $pb.GeneratedMessage {
  factory ReceiveResponse({
    Run? run,
    $core.Iterable<$core.String>? short,
  }) {
    final result = create();
    if (run != null) result.run = run;
    if (short != null) result.short.addAll(short);
    return result;
  }

  ReceiveResponse._();

  factory ReceiveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Run>(1, _omitFieldNames ? '' : 'run', subBuilder: Run.create)
    ..pPS(2, _omitFieldNames ? '' : 'short')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveResponse copyWith(void Function(ReceiveResponse) updates) =>
      super.copyWith((message) => updates(message as ReceiveResponse))
          as ReceiveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveResponse create() => ReceiveResponse._();
  @$core.override
  ReceiveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveResponse>(create);
  static ReceiveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Run get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(Run value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  Run ensureRun() => $_ensure(0);

  /// Codes that arrived short. Returned rather than refused: the set is on the
  /// counter whatever the count says, and refusing it would leave the shortfall
  /// unwritten.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get short => $_getList(1);
}

class AdvanceRequest extends $pb.GeneratedMessage {
  factory AdvanceRequest({
    $core.String? runId,
    Stage? stage,
    $core.String? equipment,
    $core.String? notes,
    $core.bool? skipped,
    $core.String? skipReason,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (stage != null) result.stage = stage;
    if (equipment != null) result.equipment = equipment;
    if (notes != null) result.notes = notes;
    if (skipped != null) result.skipped = skipped;
    if (skipReason != null) result.skipReason = skipReason;
    return result;
  }

  AdvanceRequest._();

  factory AdvanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aE<Stage>(2, _omitFieldNames ? '' : 'stage', enumValues: Stage.values)
    ..aOS(3, _omitFieldNames ? '' : 'equipment')
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..aOB(5, _omitFieldNames ? '' : 'skipped')
    ..aOS(6, _omitFieldNames ? '' : 'skipReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceRequest copyWith(void Function(AdvanceRequest) updates) =>
      super.copyWith((message) => updates(message as AdvanceRequest))
          as AdvanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceRequest create() => AdvanceRequest._();
  @$core.override
  AdvanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceRequest>(create);
  static AdvanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  Stage get stage => $_getN(1);
  @$pb.TagNumber(2)
  set stage(Stage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStage() => $_has(1);
  @$pb.TagNumber(2)
  void clearStage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get equipment => $_getSZ(2);
  @$pb.TagNumber(3)
  set equipment($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEquipment() => $_has(2);
  @$pb.TagNumber(3)
  void clearEquipment() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);

  /// An authorised exception. The authoriser is the caller, so a technician
  /// cannot record a manager's approval without the manager being there.
  @$pb.TagNumber(5)
  $core.bool get skipped => $_getBF(4);
  @$pb.TagNumber(5)
  set skipped($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSkipped() => $_has(4);
  @$pb.TagNumber(5)
  void clearSkipped() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get skipReason => $_getSZ(5);
  @$pb.TagNumber(6)
  set skipReason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSkipReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearSkipReason() => $_clearField(6);
}

class AdvanceResponse extends $pb.GeneratedMessage {
  factory AdvanceResponse({
    StageRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  AdvanceResponse._();

  factory AdvanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<StageRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: StageRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceResponse copyWith(void Function(AdvanceResponse) updates) =>
      super.copyWith((message) => updates(message as AdvanceResponse))
          as AdvanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceResponse create() => AdvanceResponse._();
  @$core.override
  AdvanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceResponse>(create);
  static AdvanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StageRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(StageRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  StageRecord ensureRecord() => $_ensure(0);
}

class AssembleRequest extends $pb.GeneratedMessage {
  factory AssembleRequest({
    $core.String? runId,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? packed,
    $core.Iterable<$core.String>? replaced,
    $core.String? notes,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (packed != null) result.packed.addEntries(packed);
    if (replaced != null) result.replaced.addAll(replaced);
    if (notes != null) result.notes = notes;
    return result;
  }

  AssembleRequest._();

  factory AssembleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssembleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssembleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..m<$core.String, $core.int>(2, _omitFieldNames ? '' : 'packed',
        entryClassName: 'AssembleRequest.PackedEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..pPS(3, _omitFieldNames ? '' : 'replaced')
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleRequest copyWith(void Function(AssembleRequest) updates) =>
      super.copyWith((message) => updates(message as AssembleRequest))
          as AssembleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssembleRequest create() => AssembleRequest._();
  @$core.override
  AssembleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssembleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssembleRequest>(create);
  static AssembleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.int> get packed => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get replaced => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

class AssembleResponse extends $pb.GeneratedMessage {
  factory AssembleResponse({
    StageRecord? record,
    $core.Iterable<$core.String>? missing,
  }) {
    final result = create();
    if (record != null) result.record = record;
    if (missing != null) result.missing.addAll(missing);
    return result;
  }

  AssembleResponse._();

  factory AssembleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssembleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssembleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<StageRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: StageRecord.create)
    ..pPS(2, _omitFieldNames ? '' : 'missing')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssembleResponse copyWith(void Function(AssembleResponse) updates) =>
      super.copyWith((message) => updates(message as AssembleResponse))
          as AssembleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssembleResponse create() => AssembleResponse._();
  @$core.override
  AssembleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssembleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssembleResponse>(create);
  static AssembleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StageRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(StageRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  StageRecord ensureRecord() => $_ensure(0);

  /// Non-critical items the pack went out without. A critical shortfall refuses
  /// the assembly instead.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get missing => $_getList(1);
}

class PackageRequest extends $pb.GeneratedMessage {
  factory PackageRequest({
    $core.String? runId,
    $core.String? method,
    $core.String? indicatorType,
    $core.String? notes,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (method != null) result.method = method;
    if (indicatorType != null) result.indicatorType = indicatorType;
    if (notes != null) result.notes = notes;
    return result;
  }

  PackageRequest._();

  factory PackageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PackageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'method')
    ..aOS(3, _omitFieldNames ? '' : 'indicatorType')
    ..aOS(4, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageRequest copyWith(void Function(PackageRequest) updates) =>
      super.copyWith((message) => updates(message as PackageRequest))
          as PackageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PackageRequest create() => PackageRequest._();
  @$core.override
  PackageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PackageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackageRequest>(create);
  static PackageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get indicatorType => $_getSZ(2);
  @$pb.TagNumber(3)
  set indicatorType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIndicatorType() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndicatorType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get notes => $_getSZ(3);
  @$pb.TagNumber(4)
  set notes($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotes() => $_clearField(4);
}

class PackageResponse extends $pb.GeneratedMessage {
  factory PackageResponse({
    StageRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  PackageResponse._();

  factory PackageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PackageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<StageRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: StageRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageResponse copyWith(void Function(PackageResponse) updates) =>
      super.copyWith((message) => updates(message as PackageResponse))
          as PackageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PackageResponse create() => PackageResponse._();
  @$core.override
  PackageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PackageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackageResponse>(create);
  static PackageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StageRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(StageRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  StageRecord ensureRecord() => $_ensure(0);
}

class StartCycleRequest extends $pb.GeneratedMessage {
  factory StartCycleRequest({
    $core.String? machine,
    $core.String? loadNumber,
    $core.String? program,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? parameters,
    CycleSource? source,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (machine != null) result.machine = machine;
    if (loadNumber != null) result.loadNumber = loadNumber;
    if (program != null) result.program = program;
    if (parameters != null) result.parameters.addEntries(parameters);
    if (source != null) result.source = source;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StartCycleRequest._();

  factory StartCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartCycleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'machine')
    ..aOS(2, _omitFieldNames ? '' : 'loadNumber')
    ..aOS(3, _omitFieldNames ? '' : 'program')
    ..m<$core.String, $core.double>(4, _omitFieldNames ? '' : 'parameters',
        entryClassName: 'StartCycleRequest.ParametersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..aE<CycleSource>(5, _omitFieldNames ? '' : 'source',
        enumValues: CycleSource.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleRequest copyWith(void Function(StartCycleRequest) updates) =>
      super.copyWith((message) => updates(message as StartCycleRequest))
          as StartCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartCycleRequest create() => StartCycleRequest._();
  @$core.override
  StartCycleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartCycleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartCycleRequest>(create);
  static StartCycleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get machine => $_getSZ(0);
  @$pb.TagNumber(1)
  set machine($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMachine() => $_has(0);
  @$pb.TagNumber(1)
  void clearMachine() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get loadNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set loadNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLoadNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoadNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get program => $_getSZ(2);
  @$pb.TagNumber(3)
  set program($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProgram() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgram() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.double> get parameters => $_getMap(3);

  @$pb.TagNumber(5)
  CycleSource get source => $_getN(4);
  @$pb.TagNumber(5)
  set source(CycleSource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get startedAt => $_getN(5);
  @$pb.TagNumber(6)
  set startedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStartedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureStartedAt() => $_ensure(5);
}

class StartCycleResponse extends $pb.GeneratedMessage {
  factory StartCycleResponse({
    Cycle? cycle,
  }) {
    final result = create();
    if (cycle != null) result.cycle = cycle;
    return result;
  }

  StartCycleResponse._();

  factory StartCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartCycleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Cycle>(1, _omitFieldNames ? '' : 'cycle', subBuilder: Cycle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartCycleResponse copyWith(void Function(StartCycleResponse) updates) =>
      super.copyWith((message) => updates(message as StartCycleResponse))
          as StartCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartCycleResponse create() => StartCycleResponse._();
  @$core.override
  StartCycleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartCycleResponse>(create);
  static StartCycleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Cycle get cycle => $_getN(0);
  @$pb.TagNumber(1)
  set cycle(Cycle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCycle() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycle() => $_clearField(1);
  @$pb.TagNumber(1)
  Cycle ensureCycle() => $_ensure(0);
}

class LoadCycleRequest extends $pb.GeneratedMessage {
  factory LoadCycleRequest({
    $core.String? cycleId,
    $core.Iterable<$core.String>? runIds,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    if (runIds != null) result.runIds.addAll(runIds);
    return result;
  }

  LoadCycleRequest._();

  factory LoadCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoadCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadCycleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..pPS(2, _omitFieldNames ? '' : 'runIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadCycleRequest copyWith(void Function(LoadCycleRequest) updates) =>
      super.copyWith((message) => updates(message as LoadCycleRequest))
          as LoadCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadCycleRequest create() => LoadCycleRequest._();
  @$core.override
  LoadCycleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoadCycleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadCycleRequest>(create);
  static LoadCycleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  /// One call for the whole load: a load is put in together, and a partial
  /// attachment leaves packs whose cycle differs from the packs beside them in
  /// the chamber.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get runIds => $_getList(1);
}

class LoadCycleResponse extends $pb.GeneratedMessage {
  factory LoadCycleResponse({
    $core.Iterable<Run>? runs,
  }) {
    final result = create();
    if (runs != null) result.runs.addAll(runs);
    return result;
  }

  LoadCycleResponse._();

  factory LoadCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoadCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadCycleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Run>(1, _omitFieldNames ? '' : 'runs', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadCycleResponse copyWith(void Function(LoadCycleResponse) updates) =>
      super.copyWith((message) => updates(message as LoadCycleResponse))
          as LoadCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadCycleResponse create() => LoadCycleResponse._();
  @$core.override
  LoadCycleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoadCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadCycleResponse>(create);
  static LoadCycleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Run> get runs => $_getList(0);
}

class FinishCycleRequest extends $pb.GeneratedMessage {
  factory FinishCycleRequest({
    $core.String? cycleId,
    CycleResult? result,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? parameters,
    $0.Timestamp? endedAt,
  }) {
    final result$ = create();
    if (cycleId != null) result$.cycleId = cycleId;
    if (result != null) result$.result = result;
    if (parameters != null) result$.parameters.addEntries(parameters);
    if (endedAt != null) result$.endedAt = endedAt;
    return result$;
  }

  FinishCycleRequest._();

  factory FinishCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishCycleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..aE<CycleResult>(2, _omitFieldNames ? '' : 'result',
        enumValues: CycleResult.values)
    ..m<$core.String, $core.double>(3, _omitFieldNames ? '' : 'parameters',
        entryClassName: 'FinishCycleRequest.ParametersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishCycleRequest copyWith(void Function(FinishCycleRequest) updates) =>
      super.copyWith((message) => updates(message as FinishCycleRequest))
          as FinishCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishCycleRequest create() => FinishCycleRequest._();
  @$core.override
  FinishCycleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishCycleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishCycleRequest>(create);
  static FinishCycleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  CycleResult get result => $_getN(1);
  @$pb.TagNumber(2)
  set result(CycleResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.double> get parameters => $_getMap(2);

  @$pb.TagNumber(4)
  $0.Timestamp get endedAt => $_getN(3);
  @$pb.TagNumber(4)
  set endedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEndedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureEndedAt() => $_ensure(3);
}

class FinishCycleResponse extends $pb.GeneratedMessage {
  factory FinishCycleResponse({
    Cycle? cycle,
  }) {
    final result = create();
    if (cycle != null) result.cycle = cycle;
    return result;
  }

  FinishCycleResponse._();

  factory FinishCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishCycleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Cycle>(1, _omitFieldNames ? '' : 'cycle', subBuilder: Cycle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishCycleResponse copyWith(void Function(FinishCycleResponse) updates) =>
      super.copyWith((message) => updates(message as FinishCycleResponse))
          as FinishCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishCycleResponse create() => FinishCycleResponse._();
  @$core.override
  FinishCycleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishCycleResponse>(create);
  static FinishCycleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Cycle get cycle => $_getN(0);
  @$pb.TagNumber(1)
  set cycle(Cycle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCycle() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycle() => $_clearField(1);
  @$pb.TagNumber(1)
  Cycle ensureCycle() => $_ensure(0);
}

class RecordIndicatorRequest extends $pb.GeneratedMessage {
  factory RecordIndicatorRequest({
    $core.String? cycleId,
    IndicatorKind? kind,
    $core.String? lot,
    $core.bool? passed,
    $core.String? notes,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    if (kind != null) result.kind = kind;
    if (lot != null) result.lot = lot;
    if (passed != null) result.passed = passed;
    if (notes != null) result.notes = notes;
    return result;
  }

  RecordIndicatorRequest._();

  factory RecordIndicatorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordIndicatorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordIndicatorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..aE<IndicatorKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: IndicatorKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'lot')
    ..aOB(4, _omitFieldNames ? '' : 'passed')
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorRequest copyWith(
          void Function(RecordIndicatorRequest) updates) =>
      super.copyWith((message) => updates(message as RecordIndicatorRequest))
          as RecordIndicatorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordIndicatorRequest create() => RecordIndicatorRequest._();
  @$core.override
  RecordIndicatorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordIndicatorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordIndicatorRequest>(create);
  static RecordIndicatorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  IndicatorKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(IndicatorKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lot => $_getSZ(2);
  @$pb.TagNumber(3)
  set lot($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLot() => $_has(2);
  @$pb.TagNumber(3)
  void clearLot() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get passed => $_getBF(3);
  @$pb.TagNumber(4)
  set passed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassed() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);
}

class RecordIndicatorResponse extends $pb.GeneratedMessage {
  factory RecordIndicatorResponse({
    IndicatorResult? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  RecordIndicatorResponse._();

  factory RecordIndicatorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordIndicatorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordIndicatorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<IndicatorResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: IndicatorResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordIndicatorResponse copyWith(
          void Function(RecordIndicatorResponse) updates) =>
      super.copyWith((message) => updates(message as RecordIndicatorResponse))
          as RecordIndicatorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordIndicatorResponse create() => RecordIndicatorResponse._();
  @$core.override
  RecordIndicatorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordIndicatorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordIndicatorResponse>(create);
  static RecordIndicatorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IndicatorResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(IndicatorResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  IndicatorResult ensureResult() => $_ensure(0);
}

class GetReleaseDecisionRequest extends $pb.GeneratedMessage {
  factory GetReleaseDecisionRequest({
    $core.String? cycleId,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    return result;
  }

  GetReleaseDecisionRequest._();

  factory GetReleaseDecisionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseDecisionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseDecisionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionRequest copyWith(
          void Function(GetReleaseDecisionRequest) updates) =>
      super.copyWith((message) => updates(message as GetReleaseDecisionRequest))
          as GetReleaseDecisionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionRequest create() => GetReleaseDecisionRequest._();
  @$core.override
  GetReleaseDecisionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseDecisionRequest>(create);
  static GetReleaseDecisionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);
}

class GetReleaseDecisionResponse extends $pb.GeneratedMessage {
  factory GetReleaseDecisionResponse({
    ReleaseDecision? decision,
  }) {
    final result = create();
    if (decision != null) result.decision = decision;
    return result;
  }

  GetReleaseDecisionResponse._();

  factory GetReleaseDecisionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReleaseDecisionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReleaseDecisionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<ReleaseDecision>(1, _omitFieldNames ? '' : 'decision',
        subBuilder: ReleaseDecision.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReleaseDecisionResponse copyWith(
          void Function(GetReleaseDecisionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetReleaseDecisionResponse))
          as GetReleaseDecisionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionResponse create() => GetReleaseDecisionResponse._();
  @$core.override
  GetReleaseDecisionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReleaseDecisionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReleaseDecisionResponse>(create);
  static GetReleaseDecisionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReleaseDecision get decision => $_getN(0);
  @$pb.TagNumber(1)
  set decision(ReleaseDecision value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDecision() => $_has(0);
  @$pb.TagNumber(1)
  void clearDecision() => $_clearField(1);
  @$pb.TagNumber(1)
  ReleaseDecision ensureDecision() => $_ensure(0);
}

class ReleaseLoadRequest extends $pb.GeneratedMessage {
  factory ReleaseLoadRequest({
    $core.String? cycleId,
    $core.String? note,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    if (note != null) result.note = note;
    return result;
  }

  ReleaseLoadRequest._();

  factory ReleaseLoadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseLoadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseLoadRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLoadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLoadRequest copyWith(void Function(ReleaseLoadRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseLoadRequest))
          as ReleaseLoadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseLoadRequest create() => ReleaseLoadRequest._();
  @$core.override
  ReleaseLoadRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseLoadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseLoadRequest>(create);
  static ReleaseLoadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class ReleaseLoadResponse extends $pb.GeneratedMessage {
  factory ReleaseLoadResponse({
    Cycle? cycle,
    $core.Iterable<Run>? runs,
  }) {
    final result = create();
    if (cycle != null) result.cycle = cycle;
    if (runs != null) result.runs.addAll(runs);
    return result;
  }

  ReleaseLoadResponse._();

  factory ReleaseLoadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseLoadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseLoadResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Cycle>(1, _omitFieldNames ? '' : 'cycle', subBuilder: Cycle.create)
    ..pPM<Run>(2, _omitFieldNames ? '' : 'runs', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLoadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLoadResponse copyWith(void Function(ReleaseLoadResponse) updates) =>
      super.copyWith((message) => updates(message as ReleaseLoadResponse))
          as ReleaseLoadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseLoadResponse create() => ReleaseLoadResponse._();
  @$core.override
  ReleaseLoadResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseLoadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseLoadResponse>(create);
  static ReleaseLoadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Cycle get cycle => $_getN(0);
  @$pb.TagNumber(1)
  set cycle(Cycle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCycle() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycle() => $_clearField(1);
  @$pb.TagNumber(1)
  Cycle ensureCycle() => $_ensure(0);

  /// Every pack in the load, now releasable.
  @$pb.TagNumber(2)
  $pb.PbList<Run> get runs => $_getList(1);
}

class GetCycleRequest extends $pb.GeneratedMessage {
  factory GetCycleRequest({
    $core.String? cycleId,
    $core.String? machine,
    $core.String? loadNumber,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    if (machine != null) result.machine = machine;
    if (loadNumber != null) result.loadNumber = loadNumber;
    return result;
  }

  GetCycleRequest._();

  factory GetCycleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCycleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCycleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..aOS(2, _omitFieldNames ? '' : 'machine')
    ..aOS(3, _omitFieldNames ? '' : 'loadNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCycleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCycleRequest copyWith(void Function(GetCycleRequest) updates) =>
      super.copyWith((message) => updates(message as GetCycleRequest))
          as GetCycleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCycleRequest create() => GetCycleRequest._();
  @$core.override
  GetCycleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCycleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCycleRequest>(create);
  static GetCycleRequest? _defaultInstance;

  /// Either: the id, or the machine and the number on the printout.
  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get machine => $_getSZ(1);
  @$pb.TagNumber(2)
  set machine($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMachine() => $_has(1);
  @$pb.TagNumber(2)
  void clearMachine() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get loadNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set loadNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLoadNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearLoadNumber() => $_clearField(3);
}

class GetCycleResponse extends $pb.GeneratedMessage {
  factory GetCycleResponse({
    Cycle? cycle,
  }) {
    final result = create();
    if (cycle != null) result.cycle = cycle;
    return result;
  }

  GetCycleResponse._();

  factory GetCycleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCycleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCycleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Cycle>(1, _omitFieldNames ? '' : 'cycle', subBuilder: Cycle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCycleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCycleResponse copyWith(void Function(GetCycleResponse) updates) =>
      super.copyWith((message) => updates(message as GetCycleResponse))
          as GetCycleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCycleResponse create() => GetCycleResponse._();
  @$core.override
  GetCycleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCycleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCycleResponse>(create);
  static GetCycleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Cycle get cycle => $_getN(0);
  @$pb.TagNumber(1)
  set cycle(Cycle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCycle() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycle() => $_clearField(1);
  @$pb.TagNumber(1)
  Cycle ensureCycle() => $_ensure(0);
}

class ListCyclesAwaitingReleaseRequest extends $pb.GeneratedMessage {
  factory ListCyclesAwaitingReleaseRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListCyclesAwaitingReleaseRequest._();

  factory ListCyclesAwaitingReleaseRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCyclesAwaitingReleaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCyclesAwaitingReleaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesAwaitingReleaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesAwaitingReleaseRequest copyWith(
          void Function(ListCyclesAwaitingReleaseRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCyclesAwaitingReleaseRequest))
          as ListCyclesAwaitingReleaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCyclesAwaitingReleaseRequest create() =>
      ListCyclesAwaitingReleaseRequest._();
  @$core.override
  ListCyclesAwaitingReleaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCyclesAwaitingReleaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCyclesAwaitingReleaseRequest>(
          create);
  static ListCyclesAwaitingReleaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListCyclesAwaitingReleaseResponse extends $pb.GeneratedMessage {
  factory ListCyclesAwaitingReleaseResponse({
    $core.Iterable<Cycle>? cycles,
  }) {
    final result = create();
    if (cycles != null) result.cycles.addAll(cycles);
    return result;
  }

  ListCyclesAwaitingReleaseResponse._();

  factory ListCyclesAwaitingReleaseResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCyclesAwaitingReleaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCyclesAwaitingReleaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Cycle>(1, _omitFieldNames ? '' : 'cycles', subBuilder: Cycle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesAwaitingReleaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCyclesAwaitingReleaseResponse copyWith(
          void Function(ListCyclesAwaitingReleaseResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListCyclesAwaitingReleaseResponse))
          as ListCyclesAwaitingReleaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCyclesAwaitingReleaseResponse create() =>
      ListCyclesAwaitingReleaseResponse._();
  @$core.override
  ListCyclesAwaitingReleaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCyclesAwaitingReleaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCyclesAwaitingReleaseResponse>(
          create);
  static ListCyclesAwaitingReleaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Cycle> get cycles => $_getList(0);
}

class ListLoadsClearedByLotRequest extends $pb.GeneratedMessage {
  factory ListLoadsClearedByLotRequest({
    $core.String? lot,
    $core.int? pageSize,
  }) {
    final result = create();
    if (lot != null) result.lot = lot;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListLoadsClearedByLotRequest._();

  factory ListLoadsClearedByLotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLoadsClearedByLotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLoadsClearedByLotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lot')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLoadsClearedByLotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLoadsClearedByLotRequest copyWith(
          void Function(ListLoadsClearedByLotRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListLoadsClearedByLotRequest))
          as ListLoadsClearedByLotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLoadsClearedByLotRequest create() =>
      ListLoadsClearedByLotRequest._();
  @$core.override
  ListLoadsClearedByLotRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLoadsClearedByLotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLoadsClearedByLotRequest>(create);
  static ListLoadsClearedByLotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lot => $_getSZ(0);
  @$pb.TagNumber(1)
  set lot($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLot() => $_has(0);
  @$pb.TagNumber(1)
  void clearLot() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListLoadsClearedByLotResponse extends $pb.GeneratedMessage {
  factory ListLoadsClearedByLotResponse({
    $core.Iterable<Cycle>? cycles,
  }) {
    final result = create();
    if (cycles != null) result.cycles.addAll(cycles);
    return result;
  }

  ListLoadsClearedByLotResponse._();

  factory ListLoadsClearedByLotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLoadsClearedByLotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLoadsClearedByLotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Cycle>(1, _omitFieldNames ? '' : 'cycles', subBuilder: Cycle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLoadsClearedByLotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLoadsClearedByLotResponse copyWith(
          void Function(ListLoadsClearedByLotResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListLoadsClearedByLotResponse))
          as ListLoadsClearedByLotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLoadsClearedByLotResponse create() =>
      ListLoadsClearedByLotResponse._();
  @$core.override
  ListLoadsClearedByLotResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLoadsClearedByLotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLoadsClearedByLotResponse>(create);
  static ListLoadsClearedByLotResponse? _defaultInstance;

  /// The bad-batch investigation: a failed indicator lot invalidates every load
  /// it passed.
  @$pb.TagNumber(1)
  $pb.PbList<Cycle> get cycles => $_getList(0);
}

class GetRunRequest extends $pb.GeneratedMessage {
  factory GetRunRequest({
    $core.String? runId,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    return result;
  }

  GetRunRequest._();

  factory GetRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunRequest copyWith(void Function(GetRunRequest) updates) =>
      super.copyWith((message) => updates(message as GetRunRequest))
          as GetRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRunRequest create() => GetRunRequest._();
  @$core.override
  GetRunRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRunRequest>(create);
  static GetRunRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);
}

class GetRunResponse extends $pb.GeneratedMessage {
  factory GetRunResponse({
    Run? run,
  }) {
    final result = create();
    if (run != null) result.run = run;
    return result;
  }

  GetRunResponse._();

  factory GetRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Run>(1, _omitFieldNames ? '' : 'run', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRunResponse copyWith(void Function(GetRunResponse) updates) =>
      super.copyWith((message) => updates(message as GetRunResponse))
          as GetRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRunResponse create() => GetRunResponse._();
  @$core.override
  GetRunResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRunResponse>(create);
  static GetRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Run get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(Run value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  Run ensureRun() => $_ensure(0);
}

class GetBoardRequest extends $pb.GeneratedMessage {
  factory GetBoardRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetBoardRequest._();

  factory GetBoardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBoardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBoardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardRequest copyWith(void Function(GetBoardRequest) updates) =>
      super.copyWith((message) => updates(message as GetBoardRequest))
          as GetBoardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBoardRequest create() => GetBoardRequest._();
  @$core.override
  GetBoardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBoardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBoardRequest>(create);
  static GetBoardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class GetBoardResponse extends $pb.GeneratedMessage {
  factory GetBoardResponse({
    $core.Iterable<Run>? runs,
  }) {
    final result = create();
    if (runs != null) result.runs.addAll(runs);
    return result;
  }

  GetBoardResponse._();

  factory GetBoardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBoardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBoardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Run>(1, _omitFieldNames ? '' : 'runs', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBoardResponse copyWith(void Function(GetBoardResponse) updates) =>
      super.copyWith((message) => updates(message as GetBoardResponse))
          as GetBoardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBoardResponse create() => GetBoardResponse._();
  @$core.override
  GetBoardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBoardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBoardResponse>(create);
  static GetBoardResponse? _defaultInstance;

  /// The department's work in progress and how far along each run is.
  @$pb.TagNumber(1)
  $pb.PbList<Run> get runs => $_getList(0);
}

class GetShelfRequest extends $pb.GeneratedMessage {
  factory GetShelfRequest({
    $core.String? setCode,
    $core.int? pageSize,
  }) {
    final result = create();
    if (setCode != null) result.setCode = setCode;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetShelfRequest._();

  factory GetShelfRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetShelfRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetShelfRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'setCode')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShelfRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShelfRequest copyWith(void Function(GetShelfRequest) updates) =>
      super.copyWith((message) => updates(message as GetShelfRequest))
          as GetShelfRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetShelfRequest create() => GetShelfRequest._();
  @$core.override
  GetShelfRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetShelfRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetShelfRequest>(create);
  static GetShelfRequest? _defaultInstance;

  /// Empty returns every set.
  @$pb.TagNumber(1)
  $core.String get setCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set setCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class GetShelfResponse extends $pb.GeneratedMessage {
  factory GetShelfResponse({
    $core.Iterable<Run>? runs,
  }) {
    final result = create();
    if (runs != null) result.runs.addAll(runs);
    return result;
  }

  GetShelfResponse._();

  factory GetShelfResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetShelfResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetShelfResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Run>(1, _omitFieldNames ? '' : 'runs', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShelfResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShelfResponse copyWith(void Function(GetShelfResponse) updates) =>
      super.copyWith((message) => updates(message as GetShelfResponse))
          as GetShelfResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetShelfResponse create() => GetShelfResponse._();
  @$core.override
  GetShelfResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetShelfResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetShelfResponse>(create);
  static GetShelfResponse? _defaultInstance;

  /// Released, in-date packs, soonest to expire first, so the department issues
  /// the pack that would otherwise be wasted.
  @$pb.TagNumber(1)
  $pb.PbList<Run> get runs => $_getList(0);
}

class ListExpiredPacksRequest extends $pb.GeneratedMessage {
  factory ListExpiredPacksRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListExpiredPacksRequest._();

  factory ListExpiredPacksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExpiredPacksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExpiredPacksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiredPacksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiredPacksRequest copyWith(
          void Function(ListExpiredPacksRequest) updates) =>
      super.copyWith((message) => updates(message as ListExpiredPacksRequest))
          as ListExpiredPacksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExpiredPacksRequest create() => ListExpiredPacksRequest._();
  @$core.override
  ListExpiredPacksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExpiredPacksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExpiredPacksRequest>(create);
  static ListExpiredPacksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListExpiredPacksResponse extends $pb.GeneratedMessage {
  factory ListExpiredPacksResponse({
    $core.Iterable<Run>? runs,
  }) {
    final result = create();
    if (runs != null) result.runs.addAll(runs);
    return result;
  }

  ListExpiredPacksResponse._();

  factory ListExpiredPacksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExpiredPacksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExpiredPacksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Run>(1, _omitFieldNames ? '' : 'runs', subBuilder: Run.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiredPacksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiredPacksResponse copyWith(
          void Function(ListExpiredPacksResponse) updates) =>
      super.copyWith((message) => updates(message as ListExpiredPacksResponse))
          as ListExpiredPacksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExpiredPacksResponse create() => ListExpiredPacksResponse._();
  @$core.override
  ListExpiredPacksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExpiredPacksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExpiredPacksResponse>(create);
  static ListExpiredPacksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Run> get runs => $_getList(0);
}

class ListExceptionsRequest extends $pb.GeneratedMessage {
  factory ListExceptionsRequest({
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
    $core.int? pageSize,
  }) {
    final result = create();
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListExceptionsRequest._();

  factory ListExceptionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExceptionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExceptionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExceptionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExceptionsRequest copyWith(
          void Function(ListExceptionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListExceptionsRequest))
          as ListExceptionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExceptionsRequest create() => ListExceptionsRequest._();
  @$core.override
  ListExceptionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExceptionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExceptionsRequest>(create);
  static ListExceptionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get periodStart => $_getN(0);
  @$pb.TagNumber(1)
  set periodStart($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPeriodStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriodStart() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensurePeriodStart() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get periodEnd => $_getN(1);
  @$pb.TagNumber(2)
  set periodEnd($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodEnd() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodEnd() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListExceptionsResponse extends $pb.GeneratedMessage {
  factory ListExceptionsResponse({
    $core.Iterable<StageRecord>? records,
  }) {
    final result = create();
    if (records != null) result.records.addAll(records);
    return result;
  }

  ListExceptionsResponse._();

  factory ListExceptionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExceptionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExceptionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<StageRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: StageRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExceptionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExceptionsResponse copyWith(
          void Function(ListExceptionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListExceptionsResponse))
          as ListExceptionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExceptionsResponse create() => ListExceptionsResponse._();
  @$core.override
  ListExceptionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExceptionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExceptionsResponse>(create);
  static ListExceptionsResponse? _defaultInstance;

  /// The register of skipped stages, which is what a quality review reads.
  @$pb.TagNumber(1)
  $pb.PbList<StageRecord> get records => $_getList(0);
}

class GetLabelRequest extends $pb.GeneratedMessage {
  factory GetLabelRequest({
    $core.String? runId,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    return result;
  }

  GetLabelRequest._();

  factory GetLabelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLabelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLabelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLabelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLabelRequest copyWith(void Function(GetLabelRequest) updates) =>
      super.copyWith((message) => updates(message as GetLabelRequest))
          as GetLabelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLabelRequest create() => GetLabelRequest._();
  @$core.override
  GetLabelRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLabelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLabelRequest>(create);
  static GetLabelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);
}

class GetLabelResponse extends $pb.GeneratedMessage {
  factory GetLabelResponse({
    Label? label,
  }) {
    final result = create();
    if (label != null) result.label = label;
    return result;
  }

  GetLabelResponse._();

  factory GetLabelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLabelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLabelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Label>(1, _omitFieldNames ? '' : 'label', subBuilder: Label.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLabelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLabelResponse copyWith(void Function(GetLabelResponse) updates) =>
      super.copyWith((message) => updates(message as GetLabelResponse))
          as GetLabelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLabelResponse create() => GetLabelResponse._();
  @$core.override
  GetLabelResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLabelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLabelResponse>(create);
  static GetLabelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Label get label => $_getN(0);
  @$pb.TagNumber(1)
  set label(Label value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => $_clearField(1);
  @$pb.TagNumber(1)
  Label ensureLabel() => $_ensure(0);
}

class IssuePackRequest extends $pb.GeneratedMessage {
  factory IssuePackRequest({
    $core.String? runId,
    $core.String? destination,
    $core.String? issuedTo,
  }) {
    final result = create();
    if (runId != null) result.runId = runId;
    if (destination != null) result.destination = destination;
    if (issuedTo != null) result.issuedTo = issuedTo;
    return result;
  }

  IssuePackRequest._();

  factory IssuePackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssuePackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssuePackRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'destination')
    ..aOS(3, _omitFieldNames ? '' : 'issuedTo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssuePackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssuePackRequest copyWith(void Function(IssuePackRequest) updates) =>
      super.copyWith((message) => updates(message as IssuePackRequest))
          as IssuePackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssuePackRequest create() => IssuePackRequest._();
  @$core.override
  IssuePackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssuePackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssuePackRequest>(create);
  static IssuePackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get destination => $_getSZ(1);
  @$pb.TagNumber(2)
  set destination($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDestination() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestination() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get issuedTo => $_getSZ(2);
  @$pb.TagNumber(3)
  set issuedTo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssuedTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssuedTo() => $_clearField(3);
}

class IssuePackResponse extends $pb.GeneratedMessage {
  factory IssuePackResponse({
    Issue? issue,
  }) {
    final result = create();
    if (issue != null) result.issue = issue;
    return result;
  }

  IssuePackResponse._();

  factory IssuePackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssuePackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssuePackResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Issue>(1, _omitFieldNames ? '' : 'issue', subBuilder: Issue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssuePackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssuePackResponse copyWith(void Function(IssuePackResponse) updates) =>
      super.copyWith((message) => updates(message as IssuePackResponse))
          as IssuePackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssuePackResponse create() => IssuePackResponse._();
  @$core.override
  IssuePackResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssuePackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssuePackResponse>(create);
  static IssuePackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Issue get issue => $_getN(0);
  @$pb.TagNumber(1)
  set issue(Issue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIssue() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssue() => $_clearField(1);
  @$pb.TagNumber(1)
  Issue ensureIssue() => $_ensure(0);
}

class MarkUsedRequest extends $pb.GeneratedMessage {
  factory MarkUsedRequest({
    $core.String? issueId,
    $core.String? caseId,
  }) {
    final result = create();
    if (issueId != null) result.issueId = issueId;
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  MarkUsedRequest._();

  factory MarkUsedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkUsedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkUsedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issueId')
    ..aOS(2, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkUsedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkUsedRequest copyWith(void Function(MarkUsedRequest) updates) =>
      super.copyWith((message) => updates(message as MarkUsedRequest))
          as MarkUsedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkUsedRequest create() => MarkUsedRequest._();
  @$core.override
  MarkUsedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkUsedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkUsedRequest>(create);
  static MarkUsedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set issueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get caseId => $_getSZ(1);
  @$pb.TagNumber(2)
  set caseId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCaseId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaseId() => $_clearField(2);
}

class MarkUsedResponse extends $pb.GeneratedMessage {
  factory MarkUsedResponse({
    Issue? issue,
  }) {
    final result = create();
    if (issue != null) result.issue = issue;
    return result;
  }

  MarkUsedResponse._();

  factory MarkUsedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkUsedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkUsedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Issue>(1, _omitFieldNames ? '' : 'issue', subBuilder: Issue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkUsedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkUsedResponse copyWith(void Function(MarkUsedResponse) updates) =>
      super.copyWith((message) => updates(message as MarkUsedResponse))
          as MarkUsedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkUsedResponse create() => MarkUsedResponse._();
  @$core.override
  MarkUsedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkUsedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkUsedResponse>(create);
  static MarkUsedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Issue get issue => $_getN(0);
  @$pb.TagNumber(1)
  set issue(Issue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIssue() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssue() => $_clearField(1);
  @$pb.TagNumber(1)
  Issue ensureIssue() => $_ensure(0);
}

class ReturnPackRequest extends $pb.GeneratedMessage {
  factory ReturnPackRequest({
    $core.String? issueId,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? counted,
    $core.String? note,
  }) {
    final result = create();
    if (issueId != null) result.issueId = issueId;
    if (counted != null) result.counted.addEntries(counted);
    if (note != null) result.note = note;
    return result;
  }

  ReturnPackRequest._();

  factory ReturnPackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReturnPackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReturnPackRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issueId')
    ..m<$core.String, $core.int>(2, _omitFieldNames ? '' : 'counted',
        entryClassName: 'ReturnPackRequest.CountedEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.sterile.v1'))
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnPackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnPackRequest copyWith(void Function(ReturnPackRequest) updates) =>
      super.copyWith((message) => updates(message as ReturnPackRequest))
          as ReturnPackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReturnPackRequest create() => ReturnPackRequest._();
  @$core.override
  ReturnPackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReturnPackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReturnPackRequest>(create);
  static ReturnPackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set issueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.int> get counted => $_getMap(1);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class ReturnPackResponse extends $pb.GeneratedMessage {
  factory ReturnPackResponse({
    Issue? issue,
    $core.Iterable<$core.String>? short,
  }) {
    final result = create();
    if (issue != null) result.issue = issue;
    if (short != null) result.short.addAll(short);
    return result;
  }

  ReturnPackResponse._();

  factory ReturnPackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReturnPackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReturnPackResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Issue>(1, _omitFieldNames ? '' : 'issue', subBuilder: Issue.create)
    ..pPS(2, _omitFieldNames ? '' : 'short')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnPackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnPackResponse copyWith(void Function(ReturnPackResponse) updates) =>
      super.copyWith((message) => updates(message as ReturnPackResponse))
          as ReturnPackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReturnPackResponse create() => ReturnPackResponse._();
  @$core.override
  ReturnPackResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReturnPackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReturnPackResponse>(create);
  static ReturnPackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Issue get issue => $_getN(0);
  @$pb.TagNumber(1)
  set issue(Issue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIssue() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssue() => $_clearField(1);
  @$pb.TagNumber(1)
  Issue ensureIssue() => $_ensure(0);

  /// Codes that came back short. The moment a set is counted back is the last
  /// moment anybody can say where a missing instrument was.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get short => $_getList(1);
}

class ListOutstandingRequest extends $pb.GeneratedMessage {
  factory ListOutstandingRequest({
    $core.String? destination,
    $core.int? pageSize,
  }) {
    final result = create();
    if (destination != null) result.destination = destination;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOutstandingRequest._();

  factory ListOutstandingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'destination')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingRequest copyWith(
          void Function(ListOutstandingRequest) updates) =>
      super.copyWith((message) => updates(message as ListOutstandingRequest))
          as ListOutstandingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingRequest create() => ListOutstandingRequest._();
  @$core.override
  ListOutstandingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutstandingRequest>(create);
  static ListOutstandingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get destination => $_getSZ(0);
  @$pb.TagNumber(1)
  set destination($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDestination() => $_has(0);
  @$pb.TagNumber(1)
  void clearDestination() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListOutstandingResponse extends $pb.GeneratedMessage {
  factory ListOutstandingResponse({
    $core.Iterable<Issue>? issues,
  }) {
    final result = create();
    if (issues != null) result.issues.addAll(issues);
    return result;
  }

  ListOutstandingResponse._();

  factory ListOutstandingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutstandingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutstandingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Issue>(1, _omitFieldNames ? '' : 'issues', subBuilder: Issue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutstandingResponse copyWith(
          void Function(ListOutstandingResponse) updates) =>
      super.copyWith((message) => updates(message as ListOutstandingResponse))
          as ListOutstandingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutstandingResponse create() => ListOutstandingResponse._();
  @$core.override
  ListOutstandingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutstandingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutstandingResponse>(create);
  static ListOutstandingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Issue> get issues => $_getList(0);
}

class TraceCaseRequest extends $pb.GeneratedMessage {
  factory TraceCaseRequest({
    $core.String? caseId,
  }) {
    final result = create();
    if (caseId != null) result.caseId = caseId;
    return result;
  }

  TraceCaseRequest._();

  factory TraceCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraceCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'caseId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCaseRequest copyWith(void Function(TraceCaseRequest) updates) =>
      super.copyWith((message) => updates(message as TraceCaseRequest))
          as TraceCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceCaseRequest create() => TraceCaseRequest._();
  @$core.override
  TraceCaseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TraceCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceCaseRequest>(create);
  static TraceCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set caseId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaseId() => $_clearField(1);
}

class TraceCaseResponse extends $pb.GeneratedMessage {
  factory TraceCaseResponse({
    CaseTrace? trace,
  }) {
    final result = create();
    if (trace != null) result.trace = trace;
    return result;
  }

  TraceCaseResponse._();

  factory TraceCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TraceCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<CaseTrace>(1, _omitFieldNames ? '' : 'trace',
        subBuilder: CaseTrace.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceCaseResponse copyWith(void Function(TraceCaseResponse) updates) =>
      super.copyWith((message) => updates(message as TraceCaseResponse))
          as TraceCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceCaseResponse create() => TraceCaseResponse._();
  @$core.override
  TraceCaseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TraceCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceCaseResponse>(create);
  static TraceCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CaseTrace get trace => $_getN(0);
  @$pb.TagNumber(1)
  set trace(CaseTrace value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrace() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrace() => $_clearField(1);
  @$pb.TagNumber(1)
  CaseTrace ensureTrace() => $_ensure(0);
}

class GetRecallScopeRequest extends $pb.GeneratedMessage {
  factory GetRecallScopeRequest({
    $core.String? cycleId,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    return result;
  }

  GetRecallScopeRequest._();

  factory GetRecallScopeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecallScopeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecallScopeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallScopeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallScopeRequest copyWith(
          void Function(GetRecallScopeRequest) updates) =>
      super.copyWith((message) => updates(message as GetRecallScopeRequest))
          as GetRecallScopeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecallScopeRequest create() => GetRecallScopeRequest._();
  @$core.override
  GetRecallScopeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecallScopeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecallScopeRequest>(create);
  static GetRecallScopeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);
}

class GetRecallScopeResponse extends $pb.GeneratedMessage {
  factory GetRecallScopeResponse({
    RecallScope? scope,
  }) {
    final result = create();
    if (scope != null) result.scope = scope;
    return result;
  }

  GetRecallScopeResponse._();

  factory GetRecallScopeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecallScopeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecallScopeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<RecallScope>(1, _omitFieldNames ? '' : 'scope',
        subBuilder: RecallScope.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallScopeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallScopeResponse copyWith(
          void Function(GetRecallScopeResponse) updates) =>
      super.copyWith((message) => updates(message as GetRecallScopeResponse))
          as GetRecallScopeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecallScopeResponse create() => GetRecallScopeResponse._();
  @$core.override
  GetRecallScopeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecallScopeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecallScopeResponse>(create);
  static GetRecallScopeResponse? _defaultInstance;

  /// What the load reaches, without raising anything.
  @$pb.TagNumber(1)
  RecallScope get scope => $_getN(0);
  @$pb.TagNumber(1)
  set scope(RecallScope value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScope() => $_has(0);
  @$pb.TagNumber(1)
  void clearScope() => $_clearField(1);
  @$pb.TagNumber(1)
  RecallScope ensureScope() => $_ensure(0);
}

class RaiseRecallRequest extends $pb.GeneratedMessage {
  factory RaiseRecallRequest({
    $core.String? cycleId,
    $core.String? reason,
  }) {
    final result = create();
    if (cycleId != null) result.cycleId = cycleId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RaiseRecallRequest._();

  factory RaiseRecallRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseRecallRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseRecallRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cycleId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRecallRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRecallRequest copyWith(void Function(RaiseRecallRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseRecallRequest))
          as RaiseRecallRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseRecallRequest create() => RaiseRecallRequest._();
  @$core.override
  RaiseRecallRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseRecallRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseRecallRequest>(create);
  static RaiseRecallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cycleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cycleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCycleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCycleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class RaiseRecallResponse extends $pb.GeneratedMessage {
  factory RaiseRecallResponse({
    Recall? recall,
    RecallScope? scope,
  }) {
    final result = create();
    if (recall != null) result.recall = recall;
    if (scope != null) result.scope = scope;
    return result;
  }

  RaiseRecallResponse._();

  factory RaiseRecallResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseRecallResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseRecallResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOM<Recall>(1, _omitFieldNames ? '' : 'recall', subBuilder: Recall.create)
    ..aOM<RecallScope>(2, _omitFieldNames ? '' : 'scope',
        subBuilder: RecallScope.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRecallResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRecallResponse copyWith(void Function(RaiseRecallResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseRecallResponse))
          as RaiseRecallResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseRecallResponse create() => RaiseRecallResponse._();
  @$core.override
  RaiseRecallResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseRecallResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseRecallResponse>(create);
  static RaiseRecallResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Recall get recall => $_getN(0);
  @$pb.TagNumber(1)
  set recall(Recall value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecall() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecall() => $_clearField(1);
  @$pb.TagNumber(1)
  Recall ensureRecall() => $_ensure(0);

  @$pb.TagNumber(2)
  RecallScope get scope => $_getN(1);
  @$pb.TagNumber(2)
  set scope(RecallScope value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScope() => $_has(1);
  @$pb.TagNumber(2)
  void clearScope() => $_clearField(2);
  @$pb.TagNumber(2)
  RecallScope ensureScope() => $_ensure(1);
}

class CloseRecallRequest extends $pb.GeneratedMessage {
  factory CloseRecallRequest({
    $core.String? recallId,
    $core.String? note,
  }) {
    final result = create();
    if (recallId != null) result.recallId = recallId;
    if (note != null) result.note = note;
    return result;
  }

  CloseRecallRequest._();

  factory CloseRecallRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseRecallRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseRecallRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recallId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseRecallRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseRecallRequest copyWith(void Function(CloseRecallRequest) updates) =>
      super.copyWith((message) => updates(message as CloseRecallRequest))
          as CloseRecallRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseRecallRequest create() => CloseRecallRequest._();
  @$core.override
  CloseRecallRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseRecallRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseRecallRequest>(create);
  static CloseRecallRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recallId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recallId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecallId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class CloseRecallResponse extends $pb.GeneratedMessage {
  factory CloseRecallResponse() => create();

  CloseRecallResponse._();

  factory CloseRecallResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseRecallResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseRecallResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseRecallResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseRecallResponse copyWith(void Function(CloseRecallResponse) updates) =>
      super.copyWith((message) => updates(message as CloseRecallResponse))
          as CloseRecallResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseRecallResponse create() => CloseRecallResponse._();
  @$core.override
  CloseRecallResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseRecallResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseRecallResponse>(create);
  static CloseRecallResponse? _defaultInstance;
}

class ListOpenRecallsRequest extends $pb.GeneratedMessage {
  factory ListOpenRecallsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOpenRecallsRequest._();

  factory ListOpenRecallsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenRecallsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenRecallsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenRecallsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenRecallsRequest copyWith(
          void Function(ListOpenRecallsRequest) updates) =>
      super.copyWith((message) => updates(message as ListOpenRecallsRequest))
          as ListOpenRecallsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenRecallsRequest create() => ListOpenRecallsRequest._();
  @$core.override
  ListOpenRecallsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenRecallsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenRecallsRequest>(create);
  static ListOpenRecallsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListOpenRecallsResponse extends $pb.GeneratedMessage {
  factory ListOpenRecallsResponse({
    $core.Iterable<Recall>? recalls,
  }) {
    final result = create();
    if (recalls != null) result.recalls.addAll(recalls);
    return result;
  }

  ListOpenRecallsResponse._();

  factory ListOpenRecallsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenRecallsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenRecallsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.sterile.v1'),
      createEmptyInstance: create)
    ..pPM<Recall>(1, _omitFieldNames ? '' : 'recalls',
        subBuilder: Recall.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenRecallsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenRecallsResponse copyWith(
          void Function(ListOpenRecallsResponse) updates) =>
      super.copyWith((message) => updates(message as ListOpenRecallsResponse))
          as ListOpenRecallsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenRecallsResponse create() => ListOpenRecallsResponse._();
  @$core.override
  ListOpenRecallsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenRecallsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenRecallsResponse>(create);
  static ListOpenRecallsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Recall> get recalls => $_getList(0);
}

/// Sterile services / CSSD (SRS-CSSD-001 … 012).
class SterileServicesServiceApi {
  final $pb.RpcClient _client;

  SterileServicesServiceApi(this._client);

  /// SRS-CSSD-001, SRS-CSSD-012.
  $async.Future<RegisterInstrumentResponse> registerInstrument(
          $pb.ClientContext? ctx, RegisterInstrumentRequest request) =>
      _client.invoke<RegisterInstrumentResponse>(ctx, 'SterileServicesService',
          'RegisterInstrument', request, RegisterInstrumentResponse());
  $async.Future<MoveInstrumentResponse> moveInstrument(
          $pb.ClientContext? ctx, MoveInstrumentRequest request) =>
      _client.invoke<MoveInstrumentResponse>(ctx, 'SterileServicesService',
          'MoveInstrument', request, MoveInstrumentResponse());
  $async.Future<ListInstrumentsResponse> listInstruments(
          $pb.ClientContext? ctx, ListInstrumentsRequest request) =>
      _client.invoke<ListInstrumentsResponse>(ctx, 'SterileServicesService',
          'ListInstruments', request, ListInstrumentsResponse());

  /// One instrument's history: the replacement question.
  $async.Future<GetInstrumentHistoryResponse> getInstrumentHistory(
          $pb.ClientContext? ctx, GetInstrumentHistoryRequest request) =>
      _client.invoke<GetInstrumentHistoryResponse>(
          ctx,
          'SterileServicesService',
          'GetInstrumentHistory',
          request,
          GetInstrumentHistoryResponse());

  /// Every move of one kind in a period: the loss analysis.
  $async.Future<ListInstrumentMovesResponse> listInstrumentMoves(
          $pb.ClientContext? ctx, ListInstrumentMovesRequest request) =>
      _client.invoke<ListInstrumentMovesResponse>(ctx, 'SterileServicesService',
          'ListInstrumentMoves', request, ListInstrumentMovesResponse());

  /// A code that already has a current version is revised, not replaced.
  $async.Future<DefineSetResponse> defineSet(
          $pb.ClientContext? ctx, DefineSetRequest request) =>
      _client.invoke<DefineSetResponse>(ctx, 'SterileServicesService',
          'DefineSet', request, DefineSetResponse());
  $async.Future<GetSetResponse> getSet(
          $pb.ClientContext? ctx, GetSetRequest request) =>
      _client.invoke<GetSetResponse>(
          ctx, 'SterileServicesService', 'GetSet', request, GetSetResponse());
  $async.Future<ListSetVersionsResponse> listSetVersions(
          $pb.ClientContext? ctx, ListSetVersionsRequest request) =>
      _client.invoke<ListSetVersionsResponse>(ctx, 'SterileServicesService',
          'ListSetVersions', request, ListSetVersionsResponse());
  $async.Future<ListSetsResponse> listSets(
          $pb.ClientContext? ctx, ListSetsRequest request) =>
      _client.invoke<ListSetsResponse>(ctx, 'SterileServicesService',
          'ListSets', request, ListSetsResponse());

  /// SRS-CSSD-002 … 005.
  $async.Future<ReceiveResponse> receive(
          $pb.ClientContext? ctx, ReceiveRequest request) =>
      _client.invoke<ReceiveResponse>(
          ctx, 'SterileServicesService', 'Receive', request, ReceiveResponse());
  $async.Future<AdvanceResponse> advance(
          $pb.ClientContext? ctx, AdvanceRequest request) =>
      _client.invoke<AdvanceResponse>(
          ctx, 'SterileServicesService', 'Advance', request, AdvanceResponse());
  $async.Future<AssembleResponse> assemble(
          $pb.ClientContext? ctx, AssembleRequest request) =>
      _client.invoke<AssembleResponse>(ctx, 'SterileServicesService',
          'Assemble', request, AssembleResponse());
  $async.Future<PackageResponse> package(
          $pb.ClientContext? ctx, PackageRequest request) =>
      _client.invoke<PackageResponse>(
          ctx, 'SterileServicesService', 'Package', request, PackageResponse());

  /// SRS-CSSD-006, SRS-CSSD-007.
  $async.Future<StartCycleResponse> startCycle(
          $pb.ClientContext? ctx, StartCycleRequest request) =>
      _client.invoke<StartCycleResponse>(ctx, 'SterileServicesService',
          'StartCycle', request, StartCycleResponse());
  $async.Future<LoadCycleResponse> loadCycle(
          $pb.ClientContext? ctx, LoadCycleRequest request) =>
      _client.invoke<LoadCycleResponse>(ctx, 'SterileServicesService',
          'LoadCycle', request, LoadCycleResponse());
  $async.Future<FinishCycleResponse> finishCycle(
          $pb.ClientContext? ctx, FinishCycleRequest request) =>
      _client.invoke<FinishCycleResponse>(ctx, 'SterileServicesService',
          'FinishCycle', request, FinishCycleResponse());
  $async.Future<RecordIndicatorResponse> recordIndicator(
          $pb.ClientContext? ctx, RecordIndicatorRequest request) =>
      _client.invoke<RecordIndicatorResponse>(ctx, 'SterileServicesService',
          'RecordIndicator', request, RecordIndicatorResponse());
  $async.Future<GetReleaseDecisionResponse> getReleaseDecision(
          $pb.ClientContext? ctx, GetReleaseDecisionRequest request) =>
      _client.invoke<GetReleaseDecisionResponse>(ctx, 'SterileServicesService',
          'GetReleaseDecision', request, GetReleaseDecisionResponse());
  $async.Future<ReleaseLoadResponse> releaseLoad(
          $pb.ClientContext? ctx, ReleaseLoadRequest request) =>
      _client.invoke<ReleaseLoadResponse>(ctx, 'SterileServicesService',
          'ReleaseLoad', request, ReleaseLoadResponse());
  $async.Future<GetCycleResponse> getCycle(
          $pb.ClientContext? ctx, GetCycleRequest request) =>
      _client.invoke<GetCycleResponse>(ctx, 'SterileServicesService',
          'GetCycle', request, GetCycleResponse());
  $async.Future<ListCyclesAwaitingReleaseResponse> listCyclesAwaitingRelease(
          $pb.ClientContext? ctx, ListCyclesAwaitingReleaseRequest request) =>
      _client.invoke<ListCyclesAwaitingReleaseResponse>(
          ctx,
          'SterileServicesService',
          'ListCyclesAwaitingRelease',
          request,
          ListCyclesAwaitingReleaseResponse());
  $async.Future<ListLoadsClearedByLotResponse> listLoadsClearedByLot(
          $pb.ClientContext? ctx, ListLoadsClearedByLotRequest request) =>
      _client.invoke<ListLoadsClearedByLotResponse>(
          ctx,
          'SterileServicesService',
          'ListLoadsClearedByLot',
          request,
          ListLoadsClearedByLotResponse());

  /// SRS-CSSD-003, SRS-CSSD-008.
  $async.Future<GetRunResponse> getRun(
          $pb.ClientContext? ctx, GetRunRequest request) =>
      _client.invoke<GetRunResponse>(
          ctx, 'SterileServicesService', 'GetRun', request, GetRunResponse());
  $async.Future<GetBoardResponse> getBoard(
          $pb.ClientContext? ctx, GetBoardRequest request) =>
      _client.invoke<GetBoardResponse>(ctx, 'SterileServicesService',
          'GetBoard', request, GetBoardResponse());
  $async.Future<GetShelfResponse> getShelf(
          $pb.ClientContext? ctx, GetShelfRequest request) =>
      _client.invoke<GetShelfResponse>(ctx, 'SterileServicesService',
          'GetShelf', request, GetShelfResponse());
  $async.Future<ListExpiredPacksResponse> listExpiredPacks(
          $pb.ClientContext? ctx, ListExpiredPacksRequest request) =>
      _client.invoke<ListExpiredPacksResponse>(ctx, 'SterileServicesService',
          'ListExpiredPacks', request, ListExpiredPacksResponse());
  $async.Future<ListExceptionsResponse> listExceptions(
          $pb.ClientContext? ctx, ListExceptionsRequest request) =>
      _client.invoke<ListExceptionsResponse>(ctx, 'SterileServicesService',
          'ListExceptions', request, ListExceptionsResponse());

  /// Derived from the record, never submitted.
  $async.Future<GetLabelResponse> getLabel(
          $pb.ClientContext? ctx, GetLabelRequest request) =>
      _client.invoke<GetLabelResponse>(ctx, 'SterileServicesService',
          'GetLabel', request, GetLabelResponse());

  /// SRS-CSSD-009.
  $async.Future<IssuePackResponse> issuePack(
          $pb.ClientContext? ctx, IssuePackRequest request) =>
      _client.invoke<IssuePackResponse>(ctx, 'SterileServicesService',
          'IssuePack', request, IssuePackResponse());
  $async.Future<MarkUsedResponse> markUsed(
          $pb.ClientContext? ctx, MarkUsedRequest request) =>
      _client.invoke<MarkUsedResponse>(ctx, 'SterileServicesService',
          'MarkUsed', request, MarkUsedResponse());
  $async.Future<ReturnPackResponse> returnPack(
          $pb.ClientContext? ctx, ReturnPackRequest request) =>
      _client.invoke<ReturnPackResponse>(ctx, 'SterileServicesService',
          'ReturnPack', request, ReturnPackResponse());
  $async.Future<ListOutstandingResponse> listOutstanding(
          $pb.ClientContext? ctx, ListOutstandingRequest request) =>
      _client.invoke<ListOutstandingResponse>(ctx, 'SterileServicesService',
          'ListOutstanding', request, ListOutstandingResponse());

  /// SRS-CSSD-010, SRS-CSSD-011.
  $async.Future<TraceCaseResponse> traceCase(
          $pb.ClientContext? ctx, TraceCaseRequest request) =>
      _client.invoke<TraceCaseResponse>(ctx, 'SterileServicesService',
          'TraceCase', request, TraceCaseResponse());
  $async.Future<GetRecallScopeResponse> getRecallScope(
          $pb.ClientContext? ctx, GetRecallScopeRequest request) =>
      _client.invoke<GetRecallScopeResponse>(ctx, 'SterileServicesService',
          'GetRecallScope', request, GetRecallScopeResponse());
  $async.Future<RaiseRecallResponse> raiseRecall(
          $pb.ClientContext? ctx, RaiseRecallRequest request) =>
      _client.invoke<RaiseRecallResponse>(ctx, 'SterileServicesService',
          'RaiseRecall', request, RaiseRecallResponse());
  $async.Future<CloseRecallResponse> closeRecall(
          $pb.ClientContext? ctx, CloseRecallRequest request) =>
      _client.invoke<CloseRecallResponse>(ctx, 'SterileServicesService',
          'CloseRecall', request, CloseRecallResponse());
  $async.Future<ListOpenRecallsResponse> listOpenRecalls(
          $pb.ClientContext? ctx, ListOpenRecallsRequest request) =>
      _client.invoke<ListOpenRecallsResponse>(ctx, 'SterileServicesService',
          'ListOpenRecalls', request, ListOpenRecallsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
