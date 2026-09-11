// This is a generated file - do not edit.
//
// Generated from healthcare/identity_access/v1/identity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Purpose of use constrains what an authenticated subject may do with data it
/// is otherwise entitled to see (Domain/Data spec §10.2).
class PurposeOfUse extends $pb.ProtobufEnum {
  static const PurposeOfUse PURPOSE_OF_USE_UNSPECIFIED =
      PurposeOfUse._(0, _omitEnumNames ? '' : 'PURPOSE_OF_USE_UNSPECIFIED');
  static const PurposeOfUse PURPOSE_OF_USE_TREATMENT =
      PurposeOfUse._(1, _omitEnumNames ? '' : 'PURPOSE_OF_USE_TREATMENT');
  static const PurposeOfUse PURPOSE_OF_USE_PAYMENT =
      PurposeOfUse._(2, _omitEnumNames ? '' : 'PURPOSE_OF_USE_PAYMENT');
  static const PurposeOfUse PURPOSE_OF_USE_OPERATIONS =
      PurposeOfUse._(3, _omitEnumNames ? '' : 'PURPOSE_OF_USE_OPERATIONS');
  static const PurposeOfUse PURPOSE_OF_USE_SUPPORT =
      PurposeOfUse._(4, _omitEnumNames ? '' : 'PURPOSE_OF_USE_SUPPORT');
  static const PurposeOfUse PURPOSE_OF_USE_RESEARCH =
      PurposeOfUse._(5, _omitEnumNames ? '' : 'PURPOSE_OF_USE_RESEARCH');

  static const $core.List<PurposeOfUse> values = <PurposeOfUse>[
    PURPOSE_OF_USE_UNSPECIFIED,
    PURPOSE_OF_USE_TREATMENT,
    PURPOSE_OF_USE_PAYMENT,
    PURPOSE_OF_USE_OPERATIONS,
    PURPOSE_OF_USE_SUPPORT,
    PURPOSE_OF_USE_RESEARCH,
  ];

  static final $core.List<PurposeOfUse?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PurposeOfUse? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PurposeOfUse._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
