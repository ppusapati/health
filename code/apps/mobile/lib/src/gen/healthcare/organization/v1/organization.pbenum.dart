// This is a generated file - do not edit.
//
// Generated from healthcare/organization/v1/organization.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Tenant lifecycle. SRS-PLT-020 requires suspension and read-only states to be
/// first-class rather than a derived flag.
class TenantStatus extends $pb.ProtobufEnum {
  static const TenantStatus TENANT_STATUS_UNSPECIFIED =
      TenantStatus._(0, _omitEnumNames ? '' : 'TENANT_STATUS_UNSPECIFIED');
  static const TenantStatus TENANT_STATUS_PROVISIONING =
      TenantStatus._(1, _omitEnumNames ? '' : 'TENANT_STATUS_PROVISIONING');
  static const TenantStatus TENANT_STATUS_ACTIVE =
      TenantStatus._(2, _omitEnumNames ? '' : 'TENANT_STATUS_ACTIVE');
  static const TenantStatus TENANT_STATUS_SUSPENDED =
      TenantStatus._(3, _omitEnumNames ? '' : 'TENANT_STATUS_SUSPENDED');
  static const TenantStatus TENANT_STATUS_OFFBOARDING =
      TenantStatus._(4, _omitEnumNames ? '' : 'TENANT_STATUS_OFFBOARDING');
  static const TenantStatus TENANT_STATUS_TERMINATED =
      TenantStatus._(5, _omitEnumNames ? '' : 'TENANT_STATUS_TERMINATED');

  static const $core.List<TenantStatus> values = <TenantStatus>[
    TENANT_STATUS_UNSPECIFIED,
    TENANT_STATUS_PROVISIONING,
    TENANT_STATUS_ACTIVE,
    TENANT_STATUS_SUSPENDED,
    TENANT_STATUS_OFFBOARDING,
    TENANT_STATUS_TERMINATED,
  ];

  static final $core.List<TenantStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static TenantStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TenantStatus._(super.value, super.name);
}

/// SRS-PLT-015: referenced masters are retired, never hard-deleted.
class FacilityStatus extends $pb.ProtobufEnum {
  static const FacilityStatus FACILITY_STATUS_UNSPECIFIED =
      FacilityStatus._(0, _omitEnumNames ? '' : 'FACILITY_STATUS_UNSPECIFIED');
  static const FacilityStatus FACILITY_STATUS_ACTIVE =
      FacilityStatus._(1, _omitEnumNames ? '' : 'FACILITY_STATUS_ACTIVE');
  static const FacilityStatus FACILITY_STATUS_INACTIVE =
      FacilityStatus._(2, _omitEnumNames ? '' : 'FACILITY_STATUS_INACTIVE');
  static const FacilityStatus FACILITY_STATUS_RETIRED =
      FacilityStatus._(3, _omitEnumNames ? '' : 'FACILITY_STATUS_RETIRED');

  static const $core.List<FacilityStatus> values = <FacilityStatus>[
    FACILITY_STATUS_UNSPECIFIED,
    FACILITY_STATUS_ACTIVE,
    FACILITY_STATUS_INACTIVE,
    FACILITY_STATUS_RETIRED,
  ];

  static final $core.List<FacilityStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static FacilityStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FacilityStatus._(super.value, super.name);
}

class FacilityType extends $pb.ProtobufEnum {
  static const FacilityType FACILITY_TYPE_UNSPECIFIED =
      FacilityType._(0, _omitEnumNames ? '' : 'FACILITY_TYPE_UNSPECIFIED');
  static const FacilityType FACILITY_TYPE_HOSPITAL =
      FacilityType._(1, _omitEnumNames ? '' : 'FACILITY_TYPE_HOSPITAL');
  static const FacilityType FACILITY_TYPE_CLINIC =
      FacilityType._(2, _omitEnumNames ? '' : 'FACILITY_TYPE_CLINIC');
  static const FacilityType FACILITY_TYPE_LABORATORY =
      FacilityType._(3, _omitEnumNames ? '' : 'FACILITY_TYPE_LABORATORY');
  static const FacilityType FACILITY_TYPE_PHARMACY =
      FacilityType._(4, _omitEnumNames ? '' : 'FACILITY_TYPE_PHARMACY');
  static const FacilityType FACILITY_TYPE_COLLECTION_CENTRE = FacilityType._(
      5, _omitEnumNames ? '' : 'FACILITY_TYPE_COLLECTION_CENTRE');
  static const FacilityType FACILITY_TYPE_WAREHOUSE =
      FacilityType._(6, _omitEnumNames ? '' : 'FACILITY_TYPE_WAREHOUSE');

  static const $core.List<FacilityType> values = <FacilityType>[
    FACILITY_TYPE_UNSPECIFIED,
    FACILITY_TYPE_HOSPITAL,
    FACILITY_TYPE_CLINIC,
    FACILITY_TYPE_LABORATORY,
    FACILITY_TYPE_PHARMACY,
    FACILITY_TYPE_COLLECTION_CENTRE,
    FACILITY_TYPE_WAREHOUSE,
  ];

  static final $core.List<FacilityType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static FacilityType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FacilityType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
