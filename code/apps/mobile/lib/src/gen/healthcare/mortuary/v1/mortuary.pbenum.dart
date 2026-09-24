// This is a generated file - do not edit.
//
// Generated from healthcare/mortuary/v1/mortuary.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Where the body came from (SRS-MORT-001).
class Source extends $pb.ProtobufEnum {
  static const Source SOURCE_UNSPECIFIED =
      Source._(0, _omitEnumNames ? '' : 'SOURCE_UNSPECIFIED');

  /// A death this hospital recorded. The case names the encounter.
  static const Source SOURCE_IN_HOSPITAL =
      Source._(1, _omitEnumNames ? '' : 'SOURCE_IN_HOSPITAL');

  /// Received from outside: an ambulance, the police, another hospital.
  static const Source SOURCE_BROUGHT_IN =
      Source._(2, _omitEnumNames ? '' : 'SOURCE_BROUGHT_IN');

  static const $core.List<Source> values = <Source>[
    SOURCE_UNSPECIFIED,
    SOURCE_IN_HOSPITAL,
    SOURCE_BROUGHT_IN,
  ];

  static final $core.List<Source?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Source? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Source._(super.value, super.name);
}

/// How sure the mortuary is who this is (SRS-MORT-002, SRS-MORT-007).
class Identity extends $pb.ProtobufEnum {
  static const Identity IDENTITY_UNSPECIFIED =
      Identity._(0, _omitEnumNames ? '' : 'IDENTITY_UNSPECIFIED');
  static const Identity IDENTITY_UNIDENTIFIED =
      Identity._(1, _omitEnumNames ? '' : 'IDENTITY_UNIDENTIFIED');

  /// Named from effects, a document or a circumstance rather than by
  /// somebody who knew them. A hypothesis, and handing a body to a family on
  /// one is how the wrong funeral happens.
  static const Identity IDENTITY_PRESUMED =
      Identity._(2, _omitEnumNames ? '' : 'IDENTITY_PRESUMED');

  /// Named by a person who identified it, and the case records who and how.
  static const Identity IDENTITY_CONFIRMED =
      Identity._(3, _omitEnumNames ? '' : 'IDENTITY_CONFIRMED');

  static const $core.List<Identity> values = <Identity>[
    IDENTITY_UNSPECIFIED,
    IDENTITY_UNIDENTIFIED,
    IDENTITY_PRESUMED,
    IDENTITY_CONFIRMED,
  ];

  static final $core.List<Identity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Identity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Identity._(super.value, super.name);
}

/// Where a case stands (SRS-MORT-002, SRS-MORT-006).
class CaseState extends $pb.ProtobufEnum {
  static const CaseState CASE_STATE_UNSPECIFIED =
      CaseState._(0, _omitEnumNames ? '' : 'CASE_STATE_UNSPECIFIED');
  static const CaseState CASE_STATE_RECEIVED =
      CaseState._(1, _omitEnumNames ? '' : 'CASE_STATE_RECEIVED');
  static const CaseState CASE_STATE_STORED =
      CaseState._(2, _omitEnumNames ? '' : 'CASE_STATE_STORED');
  static const CaseState CASE_STATE_RELEASED =
      CaseState._(3, _omitEnumNames ? '' : 'CASE_STATE_RELEASED');

  static const $core.List<CaseState> values = <CaseState>[
    CASE_STATE_UNSPECIFIED,
    CASE_STATE_RECEIVED,
    CASE_STATE_STORED,
    CASE_STATE_RELEASED,
  ];

  static final $core.List<CaseState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CaseState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CaseState._(super.value, super.name);
}

/// What sort of storage a space is (SRS-MORT-002).
class SpaceKind extends $pb.ProtobufEnum {
  static const SpaceKind SPACE_KIND_UNSPECIFIED =
      SpaceKind._(0, _omitEnumNames ? '' : 'SPACE_KIND_UNSPECIFIED');
  static const SpaceKind SPACE_KIND_REFRIGERATED =
      SpaceKind._(1, _omitEnumNames ? '' : 'SPACE_KIND_REFRIGERATED');
  static const SpaceKind SPACE_KIND_FREEZER =
      SpaceKind._(2, _omitEnumNames ? '' : 'SPACE_KIND_FREEZER');

  /// A room a family is taken into. Occupied like any other space, because a
  /// body in the viewing room is a body not in its drawer.
  static const SpaceKind SPACE_KIND_VIEWING =
      SpaceKind._(3, _omitEnumNames ? '' : 'SPACE_KIND_VIEWING');
  static const SpaceKind SPACE_KIND_POSTMORTEM =
      SpaceKind._(4, _omitEnumNames ? '' : 'SPACE_KIND_POSTMORTEM');

  static const $core.List<SpaceKind> values = <SpaceKind>[
    SPACE_KIND_UNSPECIFIED,
    SPACE_KIND_REFRIGERATED,
    SPACE_KIND_FREEZER,
    SPACE_KIND_VIEWING,
    SPACE_KIND_POSTMORTEM,
  ];

  static final $core.List<SpaceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SpaceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SpaceKind._(super.value, super.name);
}

/// Whether a body is still in a space (SRS-MORT-002).
class PlacementState extends $pb.ProtobufEnum {
  static const PlacementState PLACEMENT_STATE_UNSPECIFIED =
      PlacementState._(0, _omitEnumNames ? '' : 'PLACEMENT_STATE_UNSPECIFIED');
  static const PlacementState PLACEMENT_STATE_CURRENT =
      PlacementState._(1, _omitEnumNames ? '' : 'PLACEMENT_STATE_CURRENT');
  static const PlacementState PLACEMENT_STATE_ENDED =
      PlacementState._(2, _omitEnumNames ? '' : 'PLACEMENT_STATE_ENDED');

  static const $core.List<PlacementState> values = <PlacementState>[
    PLACEMENT_STATE_UNSPECIFIED,
    PLACEMENT_STATE_CURRENT,
    PLACEMENT_STATE_ENDED,
  ];

  static final $core.List<PlacementState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PlacementState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlacementState._(super.value, super.name);
}

/// What sort of belonging (SRS-MORT-004).
class ItemKind extends $pb.ProtobufEnum {
  static const ItemKind ITEM_KIND_UNSPECIFIED =
      ItemKind._(0, _omitEnumNames ? '' : 'ITEM_KIND_UNSPECIFIED');

  /// Jewellery, cash, a watch: what a family asks about and what an
  /// investigation asks about. Listed with a second person present and into
  /// a numbered seal.
  static const ItemKind ITEM_KIND_VALUABLE =
      ItemKind._(1, _omitEnumNames ? '' : 'ITEM_KIND_VALUABLE');
  static const ItemKind ITEM_KIND_DOCUMENT =
      ItemKind._(2, _omitEnumNames ? '' : 'ITEM_KIND_DOCUMENT');
  static const ItemKind ITEM_KIND_CLOTHING =
      ItemKind._(3, _omitEnumNames ? '' : 'ITEM_KIND_CLOTHING');
  static const ItemKind ITEM_KIND_OTHER =
      ItemKind._(4, _omitEnumNames ? '' : 'ITEM_KIND_OTHER');

  static const $core.List<ItemKind> values = <ItemKind>[
    ITEM_KIND_UNSPECIFIED,
    ITEM_KIND_VALUABLE,
    ITEM_KIND_DOCUMENT,
    ITEM_KIND_CLOTHING,
    ITEM_KIND_OTHER,
  ];

  static final $core.List<ItemKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ItemKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ItemKind._(super.value, super.name);
}

/// Where one belonging stands (SRS-MORT-004).
class ItemState extends $pb.ProtobufEnum {
  static const ItemState ITEM_STATE_UNSPECIFIED =
      ItemState._(0, _omitEnumNames ? '' : 'ITEM_STATE_UNSPECIFIED');
  static const ItemState ITEM_STATE_HELD =
      ItemState._(1, _omitEnumNames ? '' : 'ITEM_STATE_HELD');
  static const ItemState ITEM_STATE_HANDED_OVER =
      ItemState._(2, _omitEnumNames ? '' : 'ITEM_STATE_HANDED_OVER');

  /// Held back by an authority. Its own state rather than a handover: the
  /// family has not got it.
  static const ItemState ITEM_STATE_RETAINED =
      ItemState._(3, _omitEnumNames ? '' : 'ITEM_STATE_RETAINED');

  static const $core.List<ItemState> values = <ItemState>[
    ITEM_STATE_UNSPECIFIED,
    ITEM_STATE_HELD,
    ITEM_STATE_HANDED_OVER,
    ITEM_STATE_RETAINED,
  ];

  static final $core.List<ItemState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ItemState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ItemState._(super.value, super.name);
}

/// What sort of examination (SRS-MORT-005).
class PostmortemKind extends $pb.ProtobufEnum {
  static const PostmortemKind POSTMORTEM_KIND_UNSPECIFIED =
      PostmortemKind._(0, _omitEnumNames ? '' : 'POSTMORTEM_KIND_UNSPECIFIED');

  /// Asked for by the treating team with the family's consent.
  static const PostmortemKind POSTMORTEM_KIND_CLINICAL =
      PostmortemKind._(1, _omitEnumNames ? '' : 'POSTMORTEM_KIND_CLINICAL');

  /// Ordered by a coroner, a magistrate or the police. The family's consent
  /// is not what authorises it, and the authorisation carries the
  /// authority's own reference.
  static const PostmortemKind POSTMORTEM_KIND_MEDICO_LEGAL =
      PostmortemKind._(2, _omitEnumNames ? '' : 'POSTMORTEM_KIND_MEDICO_LEGAL');

  static const $core.List<PostmortemKind> values = <PostmortemKind>[
    POSTMORTEM_KIND_UNSPECIFIED,
    POSTMORTEM_KIND_CLINICAL,
    POSTMORTEM_KIND_MEDICO_LEGAL,
  ];

  static final $core.List<PostmortemKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PostmortemKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PostmortemKind._(super.value, super.name);
}

/// Where an examination request stands (SRS-MORT-005).
class PostmortemState extends $pb.ProtobufEnum {
  static const PostmortemState POSTMORTEM_STATE_UNSPECIFIED = PostmortemState._(
      0, _omitEnumNames ? '' : 'POSTMORTEM_STATE_UNSPECIFIED');
  static const PostmortemState POSTMORTEM_STATE_REQUESTED =
      PostmortemState._(1, _omitEnumNames ? '' : 'POSTMORTEM_STATE_REQUESTED');
  static const PostmortemState POSTMORTEM_STATE_AUTHORISED =
      PostmortemState._(2, _omitEnumNames ? '' : 'POSTMORTEM_STATE_AUTHORISED');
  static const PostmortemState POSTMORTEM_STATE_PERFORMED =
      PostmortemState._(3, _omitEnumNames ? '' : 'POSTMORTEM_STATE_PERFORMED');
  static const PostmortemState POSTMORTEM_STATE_REPORTED =
      PostmortemState._(4, _omitEnumNames ? '' : 'POSTMORTEM_STATE_REPORTED');

  /// Asked for and refused. Kept, because "we asked and were refused" is a
  /// different record from never having asked.
  static const PostmortemState POSTMORTEM_STATE_DECLINED =
      PostmortemState._(5, _omitEnumNames ? '' : 'POSTMORTEM_STATE_DECLINED');

  static const $core.List<PostmortemState> values = <PostmortemState>[
    POSTMORTEM_STATE_UNSPECIFIED,
    POSTMORTEM_STATE_REQUESTED,
    POSTMORTEM_STATE_AUTHORISED,
    POSTMORTEM_STATE_PERFORMED,
    POSTMORTEM_STATE_REPORTED,
    POSTMORTEM_STATE_DECLINED,
  ];

  static final $core.List<PostmortemState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PostmortemState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PostmortemState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
