// This is a generated file - do not edit.
//
// Generated from healthcare/laundry/v1/laundry.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// What kind of linen an item is (SRS-LND-001).
class LinenCategory extends $pb.ProtobufEnum {
  static const LinenCategory LINEN_CATEGORY_UNSPECIFIED =
      LinenCategory._(0, _omitEnumNames ? '' : 'LINEN_CATEGORY_UNSPECIFIED');
  static const LinenCategory LINEN_CATEGORY_BEDDING =
      LinenCategory._(1, _omitEnumNames ? '' : 'LINEN_CATEGORY_BEDDING');
  static const LinenCategory LINEN_CATEGORY_PATIENT =
      LinenCategory._(2, _omitEnumNames ? '' : 'LINEN_CATEGORY_PATIENT');

  /// Drapes, gowns and wraps. Kept apart because a theatre item that failed
  /// its wash is a different conversation.
  static const LinenCategory LINEN_CATEGORY_THEATRE =
      LinenCategory._(3, _omitEnumNames ? '' : 'LINEN_CATEGORY_THEATRE');

  /// Staff uniforms and scrubs, which is where the tagged items mostly are.
  static const LinenCategory LINEN_CATEGORY_UNIFORM =
      LinenCategory._(4, _omitEnumNames ? '' : 'LINEN_CATEGORY_UNIFORM');
  static const LinenCategory LINEN_CATEGORY_OTHER =
      LinenCategory._(5, _omitEnumNames ? '' : 'LINEN_CATEGORY_OTHER');

  static const $core.List<LinenCategory> values = <LinenCategory>[
    LINEN_CATEGORY_UNSPECIFIED,
    LINEN_CATEGORY_BEDDING,
    LINEN_CATEGORY_PATIENT,
    LINEN_CATEGORY_THEATRE,
    LINEN_CATEGORY_UNIFORM,
    LINEN_CATEGORY_OTHER,
  ];

  static final $core.List<LinenCategory?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static LinenCategory? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LinenCategory._(super.value, super.name);
}

/// How a bag of linen has to be handled (SRS-LND-002, SRS-LND-005).
///
/// An enum rather than a flag, because "infected" is not a degree of
/// "soiled". It decides which bag the linen goes into at the bedside, whether
/// anybody may open it again, and which cycle it is allowed into.
class SoilClass extends $pb.ProtobufEnum {
  static const SoilClass SOIL_CLASS_UNSPECIFIED =
      SoilClass._(0, _omitEnumNames ? '' : 'SOIL_CLASS_UNSPECIFIED');

  /// Linen that was on a bed and is not wet.
  static const SoilClass SOIL_CLASS_USED =
      SoilClass._(1, _omitEnumNames ? '' : 'SOIL_CLASS_USED');

  /// Blood or body fluid. Gloves and a hot wash; not a barrier load.
  static const SoilClass SOIL_CLASS_FOULED =
      SoilClass._(2, _omitEnumNames ? '' : 'SOIL_CLASS_FOULED');

  /// From a patient on transmission-based precautions. Bagged at the
  /// bedside, sealed, never opened again, washed in a barrier cycle.
  static const SoilClass SOIL_CLASS_INFECTED =
      SoilClass._(3, _omitEnumNames ? '' : 'SOIL_CLASS_INFECTED');

  static const $core.List<SoilClass> values = <SoilClass>[
    SOIL_CLASS_UNSPECIFIED,
    SOIL_CLASS_USED,
    SOIL_CLASS_FOULED,
    SOIL_CLASS_INFECTED,
  ];

  static final $core.List<SoilClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SoilClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SoilClass._(super.value, super.name);
}

/// A wash programme (SRS-LND-003, SRS-LND-005).
class WashCycle extends $pb.ProtobufEnum {
  static const WashCycle WASH_CYCLE_UNSPECIFIED =
      WashCycle._(0, _omitEnumNames ? '' : 'WASH_CYCLE_UNSPECIFIED');
  static const WashCycle WASH_CYCLE_STANDARD =
      WashCycle._(1, _omitEnumNames ? '' : 'WASH_CYCLE_STANDARD');

  /// Thermal disinfection, used for fouled linen.
  static const WashCycle WASH_CYCLE_HOT =
      WashCycle._(2, _omitEnumNames ? '' : 'WASH_CYCLE_HOT');

  /// Rated to take sealed infected linen: the bag dissolves in the drum and
  /// nobody handles the contents.
  static const WashCycle WASH_CYCLE_BARRIER =
      WashCycle._(3, _omitEnumNames ? '' : 'WASH_CYCLE_BARRIER');

  /// For theatre drapes and anything that cannot take a hot wash.
  static const WashCycle WASH_CYCLE_DELICATE =
      WashCycle._(4, _omitEnumNames ? '' : 'WASH_CYCLE_DELICATE');

  static const $core.List<WashCycle> values = <WashCycle>[
    WASH_CYCLE_UNSPECIFIED,
    WASH_CYCLE_STANDARD,
    WASH_CYCLE_HOT,
    WASH_CYCLE_BARRIER,
    WASH_CYCLE_DELICATE,
  ];

  static final $core.List<WashCycle?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static WashCycle? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WashCycle._(super.value, super.name);
}

/// Where a soiled collection stands (SRS-LND-002).
class CollectionState extends $pb.ProtobufEnum {
  static const CollectionState COLLECTION_STATE_UNSPECIFIED = CollectionState._(
      0, _omitEnumNames ? '' : 'COLLECTION_STATE_UNSPECIFIED');
  static const CollectionState COLLECTION_STATE_OPEN =
      CollectionState._(1, _omitEnumNames ? '' : 'COLLECTION_STATE_OPEN');

  /// In a wash batch. The chain SRS-LND-002 asks to be retained.
  static const CollectionState COLLECTION_STATE_BATCHED =
      CollectionState._(2, _omitEnumNames ? '' : 'COLLECTION_STATE_BATCHED');

  /// Recorded in error. Kept, because a unit's loss is computed from what
  /// went out and what came back.
  static const CollectionState COLLECTION_STATE_CANCELLED =
      CollectionState._(3, _omitEnumNames ? '' : 'COLLECTION_STATE_CANCELLED');

  static const $core.List<CollectionState> values = <CollectionState>[
    COLLECTION_STATE_UNSPECIFIED,
    COLLECTION_STATE_OPEN,
    COLLECTION_STATE_BATCHED,
    COLLECTION_STATE_CANCELLED,
  ];

  static final $core.List<CollectionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CollectionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CollectionState._(super.value, super.name);
}

/// Where a wash batch stands (SRS-LND-003).
class BatchState extends $pb.ProtobufEnum {
  static const BatchState BATCH_STATE_UNSPECIFIED =
      BatchState._(0, _omitEnumNames ? '' : 'BATCH_STATE_UNSPECIFIED');
  static const BatchState BATCH_STATE_LOADING =
      BatchState._(1, _omitEnumNames ? '' : 'BATCH_STATE_LOADING');
  static const BatchState BATCH_STATE_PROCESSING =
      BatchState._(2, _omitEnumNames ? '' : 'BATCH_STATE_PROCESSING');

  /// Completed its cycle. The only state linen may be issued from.
  static const BatchState BATCH_STATE_PASSED =
      BatchState._(3, _omitEnumNames ? '' : 'BATCH_STATE_PASSED');

  /// The cycle did not hold. Its linen looks exactly like clean linen and is
  /// not.
  static const BatchState BATCH_STATE_FAILED =
      BatchState._(4, _omitEnumNames ? '' : 'BATCH_STATE_FAILED');

  /// A failed batch whose load went back through. Its own state, so a report
  /// cannot count the second pass as though the first had never happened.
  static const BatchState BATCH_STATE_REWASHED =
      BatchState._(5, _omitEnumNames ? '' : 'BATCH_STATE_REWASHED');

  static const $core.List<BatchState> values = <BatchState>[
    BATCH_STATE_UNSPECIFIED,
    BATCH_STATE_LOADING,
    BATCH_STATE_PROCESSING,
    BATCH_STATE_PASSED,
    BATCH_STATE_FAILED,
    BATCH_STATE_REWASHED,
  ];

  static final $core.List<BatchState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static BatchState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BatchState._(super.value, super.name);
}

/// How linen left the system other than by being washed (SRS-LND-006).
class LossKind extends $pb.ProtobufEnum {
  static const LossKind LOSS_KIND_UNSPECIFIED =
      LossKind._(0, _omitEnumNames ? '' : 'LOSS_KIND_UNSPECIFIED');

  /// Deliberately taken out of service: torn, worn through, stained past
  /// use.
  static const LossKind LOSS_KIND_CONDEMNED =
      LossKind._(1, _omitEnumNames ? '' : 'LOSS_KIND_CONDEMNED');

  /// Ruined by something identifiable. Kept apart from condemnation because
  /// the follow-up is an incident rather than a laundry cycle.
  static const LossKind LOSS_KIND_DAMAGED =
      LossKind._(2, _omitEnumNames ? '' : 'LOSS_KIND_DAMAGED');

  /// Did not come back.
  static const LossKind LOSS_KIND_MISSING =
      LossKind._(3, _omitEnumNames ? '' : 'LOSS_KIND_MISSING');

  static const $core.List<LossKind> values = <LossKind>[
    LOSS_KIND_UNSPECIFIED,
    LOSS_KIND_CONDEMNED,
    LOSS_KIND_DAMAGED,
    LOSS_KIND_MISSING,
  ];

  static final $core.List<LossKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static LossKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LossKind._(super.value, super.name);
}

/// Where a loss record stands (SRS-LND-006).
class LossState extends $pb.ProtobufEnum {
  static const LossState LOSS_STATE_UNSPECIFIED =
      LossState._(0, _omitEnumNames ? '' : 'LOSS_STATE_UNSPECIFIED');
  static const LossState LOSS_STATE_REPORTED =
      LossState._(1, _omitEnumNames ? '' : 'LOSS_STATE_REPORTED');

  /// Authorised. Only an approved record comes off the unit's balance.
  static const LossState LOSS_STATE_APPROVED =
      LossState._(2, _omitEnumNames ? '' : 'LOSS_STATE_APPROVED');
  static const LossState LOSS_STATE_REJECTED =
      LossState._(3, _omitEnumNames ? '' : 'LOSS_STATE_REJECTED');

  /// Missing linen that turned up. Its own state, so an annual loss figure
  /// is not quietly reduced by records somebody reopened.
  static const LossState LOSS_STATE_RECOVERED =
      LossState._(4, _omitEnumNames ? '' : 'LOSS_STATE_RECOVERED');

  static const $core.List<LossState> values = <LossState>[
    LOSS_STATE_UNSPECIFIED,
    LOSS_STATE_REPORTED,
    LOSS_STATE_APPROVED,
    LOSS_STATE_REJECTED,
    LOSS_STATE_RECOVERED,
  ];

  static final $core.List<LossState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static LossState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LossState._(super.value, super.name);
}

/// How a tracked item is read (SRS-LND-007).
class TagKind extends $pb.ProtobufEnum {
  static const TagKind TAG_KIND_UNSPECIFIED =
      TagKind._(0, _omitEnumNames ? '' : 'TAG_KIND_UNSPECIFIED');
  static const TagKind TAG_KIND_RFID =
      TagKind._(1, _omitEnumNames ? '' : 'TAG_KIND_RFID');
  static const TagKind TAG_KIND_BARCODE =
      TagKind._(2, _omitEnumNames ? '' : 'TAG_KIND_BARCODE');

  static const $core.List<TagKind> values = <TagKind>[
    TAG_KIND_UNSPECIFIED,
    TAG_KIND_RFID,
    TAG_KIND_BARCODE,
  ];

  static final $core.List<TagKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TagKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TagKind._(super.value, super.name);
}

/// Where a tagged item stands (SRS-LND-007).
class TrackedState extends $pb.ProtobufEnum {
  static const TrackedState TRACKED_STATE_UNSPECIFIED =
      TrackedState._(0, _omitEnumNames ? '' : 'TRACKED_STATE_UNSPECIFIED');
  static const TrackedState TRACKED_STATE_IN_SERVICE =
      TrackedState._(1, _omitEnumNames ? '' : 'TRACKED_STATE_IN_SERVICE');
  static const TrackedState TRACKED_STATE_RETIRED =
      TrackedState._(2, _omitEnumNames ? '' : 'TRACKED_STATE_RETIRED');

  static const $core.List<TrackedState> values = <TrackedState>[
    TRACKED_STATE_UNSPECIFIED,
    TRACKED_STATE_IN_SERVICE,
    TRACKED_STATE_RETIRED,
  ];

  static final $core.List<TrackedState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TrackedState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TrackedState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
