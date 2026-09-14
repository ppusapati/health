// This is a generated file - do not edit.
//
// Generated from healthcare/empi/v1/patient.proto.

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

import 'patient.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'patient.pbenum.dart';

/// A date whose precision is recorded alongside it.
class PartialDate extends $pb.GeneratedMessage {
  factory PartialDate({
    $0.Timestamp? date,
    DatePrecision? precision,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (precision != null) result.precision = precision;
    return result;
  }

  PartialDate._();

  factory PartialDate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PartialDate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PartialDate',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'date',
        subBuilder: $0.Timestamp.create)
    ..aE<DatePrecision>(2, _omitFieldNames ? '' : 'precision',
        enumValues: DatePrecision.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PartialDate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PartialDate copyWith(void Function(PartialDate) updates) =>
      super.copyWith((message) => updates(message as PartialDate))
          as PartialDate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PartialDate create() => PartialDate._();
  @$core.override
  PartialDate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PartialDate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PartialDate>(create);
  static PartialDate? _defaultInstance;

  /// Date component; time of day is ignored.
  @$pb.TagNumber(1)
  $0.Timestamp get date => $_getN(0);
  @$pb.TagNumber(1)
  set date($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureDate() => $_ensure(0);

  @$pb.TagNumber(2)
  DatePrecision get precision => $_getN(1);
  @$pb.TagNumber(2)
  set precision(DatePrecision value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPrecision() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrecision() => $_clearField(2);
}

class HumanName extends $pb.GeneratedMessage {
  factory HumanName({
    $core.String? family,
    $core.Iterable<$core.String>? given,
    $core.String? prefix,
    $core.String? suffix,
  }) {
    final result = create();
    if (family != null) result.family = family;
    if (given != null) result.given.addAll(given);
    if (prefix != null) result.prefix = prefix;
    if (suffix != null) result.suffix = suffix;
    return result;
  }

  HumanName._();

  factory HumanName.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HumanName.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HumanName',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'family')
    ..pPS(2, _omitFieldNames ? '' : 'given')
    ..aOS(3, _omitFieldNames ? '' : 'prefix')
    ..aOS(4, _omitFieldNames ? '' : 'suffix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HumanName clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HumanName copyWith(void Function(HumanName) updates) =>
      super.copyWith((message) => updates(message as HumanName)) as HumanName;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HumanName create() => HumanName._();
  @$core.override
  HumanName createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HumanName getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HumanName>(create);
  static HumanName? _defaultInstance;

  /// Some cultures record no family name at all, so this is not universally
  /// required — the facility's demographic policy decides.
  @$pb.TagNumber(1)
  $core.String get family => $_getSZ(0);
  @$pb.TagNumber(1)
  set family($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFamily() => $_has(0);
  @$pb.TagNumber(1)
  void clearFamily() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get given => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get prefix => $_getSZ(2);
  @$pb.TagNumber(3)
  set prefix($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrefix() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrefix() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get suffix => $_getSZ(3);
  @$pb.TagNumber(4)
  set suffix($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSuffix() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuffix() => $_clearField(4);
}

class ContactPoint extends $pb.GeneratedMessage {
  factory ContactPoint({
    ContactSystem? system,
    $core.String? value,
    $core.String? use,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (value != null) result.value = value;
    if (use != null) result.use = use;
    return result;
  }

  ContactPoint._();

  factory ContactPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContactPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContactPoint',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aE<ContactSystem>(1, _omitFieldNames ? '' : 'system',
        enumValues: ContactSystem.values)
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aOS(3, _omitFieldNames ? '' : 'use')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactPoint copyWith(void Function(ContactPoint) updates) =>
      super.copyWith((message) => updates(message as ContactPoint))
          as ContactPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactPoint create() => ContactPoint._();
  @$core.override
  ContactPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContactPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContactPoint>(create);
  static ContactPoint? _defaultInstance;

  @$pb.TagNumber(1)
  ContactSystem get system => $_getN(0);
  @$pb.TagNumber(1)
  set system(ContactSystem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  /// Distinguishes a mobile the patient answers from a landline at an address
  /// they left — which matters for contacting them and for matching.
  @$pb.TagNumber(3)
  $core.String get use => $_getSZ(2);
  @$pb.TagNumber(3)
  set use($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUse() => $_has(2);
  @$pb.TagNumber(3)
  void clearUse() => $_clearField(3);
}

class Address extends $pb.GeneratedMessage {
  factory Address({
    $core.Iterable<$core.String>? lines,
    $core.String? city,
    $core.String? district,
    $core.String? state,
    $core.String? postalCode,
    $core.String? country,
  }) {
    final result = create();
    if (lines != null) result.lines.addAll(lines);
    if (city != null) result.city = city;
    if (district != null) result.district = district;
    if (state != null) result.state = state;
    if (postalCode != null) result.postalCode = postalCode;
    if (country != null) result.country = country;
    return result;
  }

  Address._();

  factory Address.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Address.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Address',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'lines')
    ..aOS(2, _omitFieldNames ? '' : 'city')
    ..aOS(3, _omitFieldNames ? '' : 'district')
    ..aOS(4, _omitFieldNames ? '' : 'state')
    ..aOS(5, _omitFieldNames ? '' : 'postalCode')
    ..aOS(6, _omitFieldNames ? '' : 'country')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Address clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Address copyWith(void Function(Address) updates) =>
      super.copyWith((message) => updates(message as Address)) as Address;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Address create() => Address._();
  @$core.override
  Address createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Address getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Address>(create);
  static Address? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get lines => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get city => $_getSZ(1);
  @$pb.TagNumber(2)
  set city($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCity() => $_has(1);
  @$pb.TagNumber(2)
  void clearCity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get district => $_getSZ(2);
  @$pb.TagNumber(3)
  set district($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDistrict() => $_has(2);
  @$pb.TagNumber(3)
  void clearDistrict() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get state => $_getSZ(3);
  @$pb.TagNumber(4)
  set state($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get postalCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set postalCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPostalCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearPostalCode() => $_clearField(5);

  /// ISO 3166-1 alpha-2.
  @$pb.TagNumber(6)
  $core.String get country => $_getSZ(5);
  @$pb.TagNumber(6)
  set country($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCountry() => $_has(5);
  @$pb.TagNumber(6)
  void clearCountry() => $_clearField(6);
}

class Demographics extends $pb.GeneratedMessage {
  factory Demographics({
    HumanName? name,
    PartialDate? birthDate,
    Sex? sex,
    $core.Iterable<ContactPoint>? phones,
    $core.Iterable<ContactPoint>? emails,
    $core.Iterable<Address>? addresses,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (birthDate != null) result.birthDate = birthDate;
    if (sex != null) result.sex = sex;
    if (phones != null) result.phones.addAll(phones);
    if (emails != null) result.emails.addAll(emails);
    if (addresses != null) result.addresses.addAll(addresses);
    return result;
  }

  Demographics._();

  factory Demographics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Demographics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Demographics',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<HumanName>(1, _omitFieldNames ? '' : 'name',
        subBuilder: HumanName.create)
    ..aOM<PartialDate>(2, _omitFieldNames ? '' : 'birthDate',
        subBuilder: PartialDate.create)
    ..aE<Sex>(3, _omitFieldNames ? '' : 'sex', enumValues: Sex.values)
    ..pPM<ContactPoint>(4, _omitFieldNames ? '' : 'phones',
        subBuilder: ContactPoint.create)
    ..pPM<ContactPoint>(5, _omitFieldNames ? '' : 'emails',
        subBuilder: ContactPoint.create)
    ..pPM<Address>(6, _omitFieldNames ? '' : 'addresses',
        subBuilder: Address.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Demographics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Demographics copyWith(void Function(Demographics) updates) =>
      super.copyWith((message) => updates(message as Demographics))
          as Demographics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Demographics create() => Demographics._();
  @$core.override
  Demographics createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Demographics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Demographics>(create);
  static Demographics? _defaultInstance;

  @$pb.TagNumber(1)
  HumanName get name => $_getN(0);
  @$pb.TagNumber(1)
  set name(HumanName value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
  @$pb.TagNumber(1)
  HumanName ensureName() => $_ensure(0);

  @$pb.TagNumber(2)
  PartialDate get birthDate => $_getN(1);
  @$pb.TagNumber(2)
  set birthDate(PartialDate value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBirthDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearBirthDate() => $_clearField(2);
  @$pb.TagNumber(2)
  PartialDate ensureBirthDate() => $_ensure(1);

  @$pb.TagNumber(3)
  Sex get sex => $_getN(2);
  @$pb.TagNumber(3)
  set sex(Sex value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSex() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ContactPoint> get phones => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<ContactPoint> get emails => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<Address> get addresses => $_getList(5);
}

/// One way the outside world names this patient.
///
/// None of these is the patient's key. SRS-EMPI-002 requires the internal
/// identifier to stay separate precisely so that these can change.
class PatientIdentifier extends $pb.GeneratedMessage {
  factory PatientIdentifier({
    $core.String? identifierId,
    IdentifierType? type,
    $core.String? system,
    $core.String? value,
    $core.String? assigningAuthority,
    IdentifierStatus? status,
    $core.String? source,
    $core.bool? primary,
    $0.Timestamp? linkedAt,
    $0.Timestamp? unlinkedAt,
    $core.String? reason,
    IdentifierAssurance? assurance,
    $0.Timestamp? verifiedAt,
  }) {
    final result = create();
    if (identifierId != null) result.identifierId = identifierId;
    if (type != null) result.type = type;
    if (system != null) result.system = system;
    if (value != null) result.value = value;
    if (assigningAuthority != null)
      result.assigningAuthority = assigningAuthority;
    if (status != null) result.status = status;
    if (source != null) result.source = source;
    if (primary != null) result.primary = primary;
    if (linkedAt != null) result.linkedAt = linkedAt;
    if (unlinkedAt != null) result.unlinkedAt = unlinkedAt;
    if (reason != null) result.reason = reason;
    if (assurance != null) result.assurance = assurance;
    if (verifiedAt != null) result.verifiedAt = verifiedAt;
    return result;
  }

  PatientIdentifier._();

  factory PatientIdentifier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PatientIdentifier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PatientIdentifier',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'identifierId')
    ..aE<IdentifierType>(2, _omitFieldNames ? '' : 'type',
        enumValues: IdentifierType.values)
    ..aOS(3, _omitFieldNames ? '' : 'system')
    ..aOS(4, _omitFieldNames ? '' : 'value')
    ..aOS(5, _omitFieldNames ? '' : 'assigningAuthority')
    ..aE<IdentifierStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: IdentifierStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'source')
    ..aOB(8, _omitFieldNames ? '' : 'primary')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'linkedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'unlinkedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'reason')
    ..aE<IdentifierAssurance>(12, _omitFieldNames ? '' : 'assurance',
        enumValues: IdentifierAssurance.values)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'verifiedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientIdentifier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientIdentifier copyWith(void Function(PatientIdentifier) updates) =>
      super.copyWith((message) => updates(message as PatientIdentifier))
          as PatientIdentifier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientIdentifier create() => PatientIdentifier._();
  @$core.override
  PatientIdentifier createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PatientIdentifier getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PatientIdentifier>(create);
  static PatientIdentifier? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get identifierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set identifierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdentifierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifierId() => $_clearField(1);

  @$pb.TagNumber(2)
  IdentifierType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(IdentifierType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// Namespaces the value. Two facilities both issuing "MRN 1001" are two
  /// different patients.
  @$pb.TagNumber(3)
  $core.String get system => $_getSZ(2);
  @$pb.TagNumber(3)
  set system($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSystem() => $_has(2);
  @$pb.TagNumber(3)
  void clearSystem() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get value => $_getSZ(3);
  @$pb.TagNumber(4)
  set value($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get assigningAuthority => $_getSZ(4);
  @$pb.TagNumber(5)
  set assigningAuthority($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssigningAuthority() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssigningAuthority() => $_clearField(5);

  @$pb.TagNumber(6)
  IdentifierStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(IdentifierStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  /// Where this system learned the value. SRS-EMPI-011 requires link history and
  /// source to be retained.
  @$pb.TagNumber(7)
  $core.String get source => $_getSZ(6);
  @$pb.TagNumber(7)
  set source($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);

  /// The identifier a banner shows.
  @$pb.TagNumber(8)
  $core.bool get primary => $_getBF(7);
  @$pb.TagNumber(8)
  set primary($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPrimary() => $_has(7);
  @$pb.TagNumber(8)
  void clearPrimary() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get linkedAt => $_getN(8);
  @$pb.TagNumber(9)
  set linkedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLinkedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearLinkedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureLinkedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get unlinkedAt => $_getN(9);
  @$pb.TagNumber(10)
  set unlinkedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUnlinkedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnlinkedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureUnlinkedAt() => $_ensure(9);

  /// Explains a supersede or a revoke.
  @$pb.TagNumber(11)
  $core.String get reason => $_getSZ(10);
  @$pb.TagNumber(11)
  set reason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearReason() => $_clearField(11);

  @$pb.TagNumber(12)
  IdentifierAssurance get assurance => $_getN(11);
  @$pb.TagNumber(12)
  set assurance(IdentifierAssurance value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAssurance() => $_has(11);
  @$pb.TagNumber(12)
  void clearAssurance() => $_clearField(12);

  /// When the issuing authority last confirmed the value. Unset while the
  /// identifier is merely asserted.
  @$pb.TagNumber(13)
  $0.Timestamp get verifiedAt => $_getN(12);
  @$pb.TagNumber(13)
  set verifiedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasVerifiedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearVerifiedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureVerifiedAt() => $_ensure(12);
}

/// One field's proposed change.
///
/// Per field rather than a whole demographics message, because a registry that
/// agrees on the name and disagrees on the birth date is offering one correction
/// and one conflict, and a reviewer must be able to take the first without the
/// second.
class ProposedFieldChange extends $pb.GeneratedMessage {
  factory ProposedFieldChange({
    DemographicField? field_1,
    $core.String? currentValue,
    $core.String? proposedValue,
    $core.bool? accepted,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (currentValue != null) result.currentValue = currentValue;
    if (proposedValue != null) result.proposedValue = proposedValue;
    if (accepted != null) result.accepted = accepted;
    return result;
  }

  ProposedFieldChange._();

  factory ProposedFieldChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProposedFieldChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProposedFieldChange',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aE<DemographicField>(1, _omitFieldNames ? '' : 'field',
        enumValues: DemographicField.values)
    ..aOS(2, _omitFieldNames ? '' : 'currentValue')
    ..aOS(3, _omitFieldNames ? '' : 'proposedValue')
    ..aOB(4, _omitFieldNames ? '' : 'accepted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposedFieldChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProposedFieldChange copyWith(void Function(ProposedFieldChange) updates) =>
      super.copyWith((message) => updates(message as ProposedFieldChange))
          as ProposedFieldChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProposedFieldChange create() => ProposedFieldChange._();
  @$core.override
  ProposedFieldChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProposedFieldChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProposedFieldChange>(create);
  static ProposedFieldChange? _defaultInstance;

  @$pb.TagNumber(1)
  DemographicField get field_1 => $_getN(0);
  @$pb.TagNumber(1)
  set field_1(DemographicField value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  /// What was on file when the proposal was raised, stored rather than read at
  /// review time: a value re-read later may have changed for an unrelated
  /// reason, and the reviewer must see the comparison the proposer saw.
  @$pb.TagNumber(2)
  $core.String get currentValue => $_getSZ(1);
  @$pb.TagNumber(2)
  set currentValue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get proposedValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set proposedValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProposedValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearProposedValue() => $_clearField(3);

  /// Set once decided. Unset while the proposal is open.
  @$pb.TagNumber(4)
  $core.bool get accepted => $_getBF(3);
  @$pb.TagNumber(4)
  set accepted($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccepted() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccepted() => $_clearField(4);
}

class DemographicProposal extends $pb.GeneratedMessage {
  factory DemographicProposal({
    $core.String? proposalId,
    $core.String? patientId,
    ProposalOrigin? origin,
    $core.String? source,
    $core.String? proposedBy,
    $core.String? reason,
    ProposalStatus? status,
    $core.Iterable<ProposedFieldChange>? fields,
    $fixnum.Int64? patientVersion,
    $0.Timestamp? proposedAt,
    $0.Timestamp? resolvedAt,
    $core.String? resolvedBy,
    $core.String? resolutionNote,
  }) {
    final result = create();
    if (proposalId != null) result.proposalId = proposalId;
    if (patientId != null) result.patientId = patientId;
    if (origin != null) result.origin = origin;
    if (source != null) result.source = source;
    if (proposedBy != null) result.proposedBy = proposedBy;
    if (reason != null) result.reason = reason;
    if (status != null) result.status = status;
    if (fields != null) result.fields.addAll(fields);
    if (patientVersion != null) result.patientVersion = patientVersion;
    if (proposedAt != null) result.proposedAt = proposedAt;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    if (resolvedBy != null) result.resolvedBy = resolvedBy;
    if (resolutionNote != null) result.resolutionNote = resolutionNote;
    return result;
  }

  DemographicProposal._();

  factory DemographicProposal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DemographicProposal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DemographicProposal',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'proposalId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aE<ProposalOrigin>(3, _omitFieldNames ? '' : 'origin',
        enumValues: ProposalOrigin.values)
    ..aOS(4, _omitFieldNames ? '' : 'source')
    ..aOS(5, _omitFieldNames ? '' : 'proposedBy')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aE<ProposalStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: ProposalStatus.values)
    ..pPM<ProposedFieldChange>(8, _omitFieldNames ? '' : 'fields',
        subBuilder: ProposedFieldChange.create)
    ..aInt64(9, _omitFieldNames ? '' : 'patientVersion')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'proposedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'resolvedBy')
    ..aOS(13, _omitFieldNames ? '' : 'resolutionNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DemographicProposal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DemographicProposal copyWith(void Function(DemographicProposal) updates) =>
      super.copyWith((message) => updates(message as DemographicProposal))
          as DemographicProposal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DemographicProposal create() => DemographicProposal._();
  @$core.override
  DemographicProposal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DemographicProposal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DemographicProposal>(create);
  static DemographicProposal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get proposalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set proposalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  ProposalOrigin get origin => $_getN(2);
  @$pb.TagNumber(3)
  set origin(ProposalOrigin value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOrigin() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrigin() => $_clearField(3);

  /// Which feed, or which person.
  @$pb.TagNumber(4)
  $core.String get source => $_getSZ(3);
  @$pb.TagNumber(4)
  set source($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get proposedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set proposedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProposedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearProposedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  ProposalStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(ProposalStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<ProposedFieldChange> get fields => $_getList(7);

  /// The record's version when this was raised. A decision taken against a
  /// record that has since moved is refused rather than applied.
  @$pb.TagNumber(9)
  $fixnum.Int64 get patientVersion => $_getI64(8);
  @$pb.TagNumber(9)
  set patientVersion($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPatientVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearPatientVersion() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get proposedAt => $_getN(9);
  @$pb.TagNumber(10)
  set proposedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasProposedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearProposedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureProposedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get resolvedAt => $_getN(10);
  @$pb.TagNumber(11)
  set resolvedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasResolvedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearResolvedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureResolvedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get resolvedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set resolvedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasResolvedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearResolvedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get resolutionNote => $_getSZ(12);
  @$pb.TagNumber(13)
  set resolutionNote($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasResolutionNote() => $_has(12);
  @$pb.TagNumber(13)
  void clearResolutionNote() => $_clearField(13);
}

class SubmitExternalDemographicsRequest extends $pb.GeneratedMessage {
  factory SubmitExternalDemographicsRequest({
    $core.String? patientId,
    Demographics? demographics,
    $core.String? source,
    $core.bool? fillBlanks,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (demographics != null) result.demographics = demographics;
    if (source != null) result.source = source;
    if (fillBlanks != null) result.fillBlanks = fillBlanks;
    return result;
  }

  SubmitExternalDemographicsRequest._();

  factory SubmitExternalDemographicsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitExternalDemographicsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitExternalDemographicsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOM<Demographics>(2, _omitFieldNames ? '' : 'demographics',
        subBuilder: Demographics.create)
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..aOB(4, _omitFieldNames ? '' : 'fillBlanks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitExternalDemographicsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitExternalDemographicsRequest copyWith(
          void Function(SubmitExternalDemographicsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SubmitExternalDemographicsRequest))
          as SubmitExternalDemographicsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitExternalDemographicsRequest create() =>
      SubmitExternalDemographicsRequest._();
  @$core.override
  SubmitExternalDemographicsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitExternalDemographicsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitExternalDemographicsRequest>(
          create);
  static SubmitExternalDemographicsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  Demographics get demographics => $_getN(1);
  @$pb.TagNumber(2)
  set demographics(Demographics value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDemographics() => $_has(1);
  @$pb.TagNumber(2)
  void clearDemographics() => $_clearField(2);
  @$pb.TagNumber(2)
  Demographics ensureDemographics() => $_ensure(1);

  /// Which feed is claiming this. Required — SRS-EMPI-012 is about reconciling
  /// disagreements between sources, and one with no source reconciles against
  /// nothing.
  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  /// Also propose values for fields the record leaves empty. A registry
  /// offering a birth date the record lacks is filling a gap rather than
  /// contradicting anything — still a proposal, because "usually welcome" is
  /// not "always correct".
  @$pb.TagNumber(4)
  $core.bool get fillBlanks => $_getBF(3);
  @$pb.TagNumber(4)
  set fillBlanks($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFillBlanks() => $_has(3);
  @$pb.TagNumber(4)
  void clearFillBlanks() => $_clearField(4);
}

class SubmitExternalDemographicsResponse extends $pb.GeneratedMessage {
  factory SubmitExternalDemographicsResponse({
    DemographicProposal? proposal,
    $core.bool? conflicted,
    $core.bool? refreshed,
  }) {
    final result = create();
    if (proposal != null) result.proposal = proposal;
    if (conflicted != null) result.conflicted = conflicted;
    if (refreshed != null) result.refreshed = refreshed;
    return result;
  }

  SubmitExternalDemographicsResponse._();

  factory SubmitExternalDemographicsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitExternalDemographicsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitExternalDemographicsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<DemographicProposal>(1, _omitFieldNames ? '' : 'proposal',
        subBuilder: DemographicProposal.create)
    ..aOB(2, _omitFieldNames ? '' : 'conflicted')
    ..aOB(3, _omitFieldNames ? '' : 'refreshed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitExternalDemographicsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitExternalDemographicsResponse copyWith(
          void Function(SubmitExternalDemographicsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SubmitExternalDemographicsResponse))
          as SubmitExternalDemographicsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitExternalDemographicsResponse create() =>
      SubmitExternalDemographicsResponse._();
  @$core.override
  SubmitExternalDemographicsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitExternalDemographicsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitExternalDemographicsResponse>(
          create);
  static SubmitExternalDemographicsResponse? _defaultInstance;

  /// Set when the source disagreed. Unset when it agreed, which is the common
  /// case and is not an error.
  @$pb.TagNumber(1)
  DemographicProposal get proposal => $_getN(0);
  @$pb.TagNumber(1)
  set proposal(DemographicProposal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposal() => $_clearField(1);
  @$pb.TagNumber(1)
  DemographicProposal ensureProposal() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get conflicted => $_getBF(1);
  @$pb.TagNumber(2)
  set conflicted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConflicted() => $_has(1);
  @$pb.TagNumber(2)
  void clearConflicted() => $_clearField(2);

  /// An existing open proposal from this source was refreshed rather than a
  /// second one added. A nightly feed that keeps disagreeing must not add a
  /// queue item every night.
  @$pb.TagNumber(3)
  $core.bool get refreshed => $_getBF(2);
  @$pb.TagNumber(3)
  set refreshed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefreshed() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefreshed() => $_clearField(3);
}

class RequestCorrectionRequest extends $pb.GeneratedMessage {
  factory RequestCorrectionRequest({
    $core.String? patientId,
    Demographics? demographics,
    $core.String? reason,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (demographics != null) result.demographics = demographics;
    if (reason != null) result.reason = reason;
    return result;
  }

  RequestCorrectionRequest._();

  factory RequestCorrectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestCorrectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestCorrectionRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOM<Demographics>(2, _omitFieldNames ? '' : 'demographics',
        subBuilder: Demographics.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestCorrectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestCorrectionRequest copyWith(
          void Function(RequestCorrectionRequest) updates) =>
      super.copyWith((message) => updates(message as RequestCorrectionRequest))
          as RequestCorrectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestCorrectionRequest create() => RequestCorrectionRequest._();
  @$core.override
  RequestCorrectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestCorrectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestCorrectionRequest>(create);
  static RequestCorrectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  Demographics get demographics => $_getN(1);
  @$pb.TagNumber(2)
  set demographics(Demographics value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDemographics() => $_has(1);
  @$pb.TagNumber(2)
  void clearDemographics() => $_clearField(2);
  @$pb.TagNumber(2)
  Demographics ensureDemographics() => $_ensure(1);

  /// What the reviewer is actually deciding on. "The spelling on my passport"
  /// and "I would prefer a different name" are different requests with the same
  /// proposed value.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RequestCorrectionResponse extends $pb.GeneratedMessage {
  factory RequestCorrectionResponse({
    DemographicProposal? proposal,
  }) {
    final result = create();
    if (proposal != null) result.proposal = proposal;
    return result;
  }

  RequestCorrectionResponse._();

  factory RequestCorrectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestCorrectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestCorrectionResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<DemographicProposal>(1, _omitFieldNames ? '' : 'proposal',
        subBuilder: DemographicProposal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestCorrectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestCorrectionResponse copyWith(
          void Function(RequestCorrectionResponse) updates) =>
      super.copyWith((message) => updates(message as RequestCorrectionResponse))
          as RequestCorrectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestCorrectionResponse create() => RequestCorrectionResponse._();
  @$core.override
  RequestCorrectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestCorrectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestCorrectionResponse>(create);
  static RequestCorrectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DemographicProposal get proposal => $_getN(0);
  @$pb.TagNumber(1)
  set proposal(DemographicProposal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposal() => $_clearField(1);
  @$pb.TagNumber(1)
  DemographicProposal ensureProposal() => $_ensure(0);
}

class ListDemographicProposalsRequest extends $pb.GeneratedMessage {
  factory ListDemographicProposalsRequest({
    $core.String? patientId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDemographicProposalsRequest._();

  factory ListDemographicProposalsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDemographicProposalsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDemographicProposalsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDemographicProposalsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDemographicProposalsRequest copyWith(
          void Function(ListDemographicProposalsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListDemographicProposalsRequest))
          as ListDemographicProposalsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDemographicProposalsRequest create() =>
      ListDemographicProposalsRequest._();
  @$core.override
  ListDemographicProposalsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDemographicProposalsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDemographicProposalsRequest>(
          create);
  static ListDemographicProposalsRequest? _defaultInstance;

  /// Empty lists the open worklist; a patient id lists everything ever proposed
  /// about that patient, rejections included.
  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListDemographicProposalsResponse extends $pb.GeneratedMessage {
  factory ListDemographicProposalsResponse({
    $core.Iterable<DemographicProposal>? proposals,
  }) {
    final result = create();
    if (proposals != null) result.proposals.addAll(proposals);
    return result;
  }

  ListDemographicProposalsResponse._();

  factory ListDemographicProposalsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDemographicProposalsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDemographicProposalsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pPM<DemographicProposal>(1, _omitFieldNames ? '' : 'proposals',
        subBuilder: DemographicProposal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDemographicProposalsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDemographicProposalsResponse copyWith(
          void Function(ListDemographicProposalsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDemographicProposalsResponse))
          as ListDemographicProposalsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDemographicProposalsResponse create() =>
      ListDemographicProposalsResponse._();
  @$core.override
  ListDemographicProposalsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDemographicProposalsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDemographicProposalsResponse>(
          create);
  static ListDemographicProposalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DemographicProposal> get proposals => $_getList(0);
}

class ResolveDemographicProposalRequest extends $pb.GeneratedMessage {
  factory ResolveDemographicProposalRequest({
    $core.String? proposalId,
    $core.Iterable<DemographicField>? accept,
    $core.String? note,
  }) {
    final result = create();
    if (proposalId != null) result.proposalId = proposalId;
    if (accept != null) result.accept.addAll(accept);
    if (note != null) result.note = note;
    return result;
  }

  ResolveDemographicProposalRequest._();

  factory ResolveDemographicProposalRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveDemographicProposalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveDemographicProposalRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'proposalId')
    ..pc<DemographicField>(
        2, _omitFieldNames ? '' : 'accept', $pb.PbFieldType.KE,
        valueOf: DemographicField.valueOf,
        enumValues: DemographicField.values,
        defaultEnumValue: DemographicField.DEMOGRAPHIC_FIELD_UNSPECIFIED)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDemographicProposalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDemographicProposalRequest copyWith(
          void Function(ResolveDemographicProposalRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ResolveDemographicProposalRequest))
          as ResolveDemographicProposalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveDemographicProposalRequest create() =>
      ResolveDemographicProposalRequest._();
  @$core.override
  ResolveDemographicProposalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveDemographicProposalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveDemographicProposalRequest>(
          create);
  static ResolveDemographicProposalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get proposalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set proposalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => $_clearField(1);

  /// The fields to apply. Empty is a full rejection, which is a real decision
  /// and needs a note saying why: the same value will arrive again, and the next
  /// reviewer needs to know this one was considered rather than missed.
  @$pb.TagNumber(2)
  $pb.PbList<DemographicField> get accept => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class ResolveDemographicProposalResponse extends $pb.GeneratedMessage {
  factory ResolveDemographicProposalResponse({
    DemographicProposal? proposal,
    Patient? patient,
  }) {
    final result = create();
    if (proposal != null) result.proposal = proposal;
    if (patient != null) result.patient = patient;
    return result;
  }

  ResolveDemographicProposalResponse._();

  factory ResolveDemographicProposalResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveDemographicProposalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveDemographicProposalResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<DemographicProposal>(1, _omitFieldNames ? '' : 'proposal',
        subBuilder: DemographicProposal.create)
    ..aOM<Patient>(2, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDemographicProposalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveDemographicProposalResponse copyWith(
          void Function(ResolveDemographicProposalResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ResolveDemographicProposalResponse))
          as ResolveDemographicProposalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveDemographicProposalResponse create() =>
      ResolveDemographicProposalResponse._();
  @$core.override
  ResolveDemographicProposalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveDemographicProposalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveDemographicProposalResponse>(
          create);
  static ResolveDemographicProposalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DemographicProposal get proposal => $_getN(0);
  @$pb.TagNumber(1)
  set proposal(DemographicProposal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposal() => $_clearField(1);
  @$pb.TagNumber(1)
  DemographicProposal ensureProposal() => $_ensure(0);

  /// Set when at least one field was applied.
  @$pb.TagNumber(2)
  Patient get patient => $_getN(1);
  @$pb.TagNumber(2)
  set patient(Patient value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPatient() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatient() => $_clearField(2);
  @$pb.TagNumber(2)
  Patient ensurePatient() => $_ensure(1);
}

class WithdrawDemographicProposalRequest extends $pb.GeneratedMessage {
  factory WithdrawDemographicProposalRequest({
    $core.String? proposalId,
    $core.String? note,
  }) {
    final result = create();
    if (proposalId != null) result.proposalId = proposalId;
    if (note != null) result.note = note;
    return result;
  }

  WithdrawDemographicProposalRequest._();

  factory WithdrawDemographicProposalRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawDemographicProposalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawDemographicProposalRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'proposalId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawDemographicProposalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawDemographicProposalRequest copyWith(
          void Function(WithdrawDemographicProposalRequest) updates) =>
      super.copyWith((message) =>
              updates(message as WithdrawDemographicProposalRequest))
          as WithdrawDemographicProposalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawDemographicProposalRequest create() =>
      WithdrawDemographicProposalRequest._();
  @$core.override
  WithdrawDemographicProposalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawDemographicProposalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawDemographicProposalRequest>(
          create);
  static WithdrawDemographicProposalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get proposalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set proposalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class WithdrawDemographicProposalResponse extends $pb.GeneratedMessage {
  factory WithdrawDemographicProposalResponse({
    DemographicProposal? proposal,
  }) {
    final result = create();
    if (proposal != null) result.proposal = proposal;
    return result;
  }

  WithdrawDemographicProposalResponse._();

  factory WithdrawDemographicProposalResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawDemographicProposalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawDemographicProposalResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<DemographicProposal>(1, _omitFieldNames ? '' : 'proposal',
        subBuilder: DemographicProposal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawDemographicProposalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawDemographicProposalResponse copyWith(
          void Function(WithdrawDemographicProposalResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WithdrawDemographicProposalResponse))
          as WithdrawDemographicProposalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawDemographicProposalResponse create() =>
      WithdrawDemographicProposalResponse._();
  @$core.override
  WithdrawDemographicProposalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawDemographicProposalResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          WithdrawDemographicProposalResponse>(create);
  static WithdrawDemographicProposalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DemographicProposal get proposal => $_getN(0);
  @$pb.TagNumber(1)
  set proposal(DemographicProposal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposal() => $_clearField(1);
  @$pb.TagNumber(1)
  DemographicProposal ensureProposal() => $_ensure(0);
}

/// A patient whose identity is not yet known (SRS-EMPI-015).
///
/// Deliberately not a HumanName. A record whose family name is "TRAUMA ALPHA"
/// sorts into the name index, fuzzy-matches the next trauma patient, and prints
/// on a wristband looking exactly like a name.
class TemporaryDesignation extends $pb.GeneratedMessage {
  factory TemporaryDesignation({
    $core.String? label,
    Sex? apparentSex,
    $core.int? apparentAge,
    $core.String? circumstance,
  }) {
    final result = create();
    if (label != null) result.label = label;
    if (apparentSex != null) result.apparentSex = apparentSex;
    if (apparentAge != null) result.apparentAge = apparentAge;
    if (circumstance != null) result.circumstance = circumstance;
    return result;
  }

  TemporaryDesignation._();

  factory TemporaryDesignation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TemporaryDesignation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemporaryDesignation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'label')
    ..aE<Sex>(2, _omitFieldNames ? '' : 'apparentSex', enumValues: Sex.values)
    ..aI(3, _omitFieldNames ? '' : 'apparentAge')
    ..aOS(4, _omitFieldNames ? '' : 'circumstance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemporaryDesignation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemporaryDesignation copyWith(void Function(TemporaryDesignation) updates) =>
      super.copyWith((message) => updates(message as TemporaryDesignation))
          as TemporaryDesignation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TemporaryDesignation create() => TemporaryDesignation._();
  @$core.override
  TemporaryDesignation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TemporaryDesignation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemporaryDesignation>(create);
  static TemporaryDesignation? _defaultInstance;

  /// What staff say out loud and what prints on the band. Site convention, not
  /// this system's invention.
  @$pb.TagNumber(1)
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => $_clearField(1);

  /// What a clinician records at the bedside: an observation, not a claim about
  /// identity. Frequently wrong and still worth recording, because a lab needs a
  /// reference range before anybody knows who this is.
  @$pb.TagNumber(2)
  Sex get apparentSex => $_getN(1);
  @$pb.TagNumber(2)
  set apparentSex(Sex value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasApparentSex() => $_has(1);
  @$pb.TagNumber(2)
  void clearApparentSex() => $_clearField(2);

  /// Estimated years. Zero means nobody estimated one.
  @$pb.TagNumber(3)
  $core.int get apparentAge => $_getIZ(2);
  @$pb.TagNumber(3)
  set apparentAge($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasApparentAge() => $_has(2);
  @$pb.TagNumber(3)
  void clearApparentAge() => $_clearField(3);

  /// The free-text peg staff actually use to find the record again — "road
  /// traffic collision, brought in by ambulance 14". Deliberately unstructured:
  /// an enumeration of ways people arrive unconscious would be wrong within a
  /// week.
  @$pb.TagNumber(4)
  $core.String get circumstance => $_getSZ(3);
  @$pb.TagNumber(4)
  set circumstance($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCircumstance() => $_has(3);
  @$pb.TagNumber(4)
  void clearCircumstance() => $_clearField(4);
}

class RegisterUnidentifiedRequest extends $pb.GeneratedMessage {
  factory RegisterUnidentifiedRequest({
    TemporaryDesignation? designation,
  }) {
    final result = create();
    if (designation != null) result.designation = designation;
    return result;
  }

  RegisterUnidentifiedRequest._();

  factory RegisterUnidentifiedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterUnidentifiedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterUnidentifiedRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<TemporaryDesignation>(1, _omitFieldNames ? '' : 'designation',
        subBuilder: TemporaryDesignation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUnidentifiedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUnidentifiedRequest copyWith(
          void Function(RegisterUnidentifiedRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RegisterUnidentifiedRequest))
          as RegisterUnidentifiedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterUnidentifiedRequest create() =>
      RegisterUnidentifiedRequest._();
  @$core.override
  RegisterUnidentifiedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterUnidentifiedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterUnidentifiedRequest>(create);
  static RegisterUnidentifiedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  TemporaryDesignation get designation => $_getN(0);
  @$pb.TagNumber(1)
  set designation(TemporaryDesignation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDesignation() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignation() => $_clearField(1);
  @$pb.TagNumber(1)
  TemporaryDesignation ensureDesignation() => $_ensure(0);
}

class RegisterUnidentifiedResponse extends $pb.GeneratedMessage {
  factory RegisterUnidentifiedResponse({
    Patient? patient,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    return result;
  }

  RegisterUnidentifiedResponse._();

  factory RegisterUnidentifiedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterUnidentifiedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterUnidentifiedResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUnidentifiedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUnidentifiedResponse copyWith(
          void Function(RegisterUnidentifiedResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RegisterUnidentifiedResponse))
          as RegisterUnidentifiedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterUnidentifiedResponse create() =>
      RegisterUnidentifiedResponse._();
  @$core.override
  RegisterUnidentifiedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterUnidentifiedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterUnidentifiedResponse>(create);
  static RegisterUnidentifiedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);
}

class IdentifyPatientRequest extends $pb.GeneratedMessage {
  factory IdentifyPatientRequest({
    $core.String? patientId,
    Demographics? demographics,
    $fixnum.Int64? expectedVersion,
    $core.Iterable<$core.String>? acknowledgedDuplicatePatientIds,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (demographics != null) result.demographics = demographics;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    if (acknowledgedDuplicatePatientIds != null)
      result.acknowledgedDuplicatePatientIds
          .addAll(acknowledgedDuplicatePatientIds);
    return result;
  }

  IdentifyPatientRequest._();

  factory IdentifyPatientRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IdentifyPatientRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyPatientRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOM<Demographics>(2, _omitFieldNames ? '' : 'demographics',
        subBuilder: Demographics.create)
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..pPS(4, _omitFieldNames ? '' : 'acknowledgedDuplicatePatientIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientRequest copyWith(
          void Function(IdentifyPatientRequest) updates) =>
      super.copyWith((message) => updates(message as IdentifyPatientRequest))
          as IdentifyPatientRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IdentifyPatientRequest create() => IdentifyPatientRequest._();
  @$core.override
  IdentifyPatientRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IdentifyPatientRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentifyPatientRequest>(create);
  static IdentifyPatientRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  Demographics get demographics => $_getN(1);
  @$pb.TagNumber(2)
  set demographics(Demographics value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDemographics() => $_has(1);
  @$pb.TagNumber(2)
  void clearDemographics() => $_clearField(2);
  @$pb.TagNumber(2)
  Demographics ensureDemographics() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);

  /// Records the caller has been shown and judged to be different people.
  /// Identification is exactly when the duplicate check that emergency
  /// registration skipped has to happen: the patient now has a name, and an
  /// existing record for them is likely.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get acknowledgedDuplicatePatientIds => $_getList(3);
}

class IdentifyPatientResponse extends $pb.GeneratedMessage {
  factory IdentifyPatientResponse({
    Patient? patient,
    $core.Iterable<PatientMatch>? potentialDuplicates,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    if (potentialDuplicates != null)
      result.potentialDuplicates.addAll(potentialDuplicates);
    return result;
  }

  IdentifyPatientResponse._();

  factory IdentifyPatientResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IdentifyPatientResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentifyPatientResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..pPM<PatientMatch>(2, _omitFieldNames ? '' : 'potentialDuplicates',
        subBuilder: PatientMatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentifyPatientResponse copyWith(
          void Function(IdentifyPatientResponse) updates) =>
      super.copyWith((message) => updates(message as IdentifyPatientResponse))
          as IdentifyPatientResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IdentifyPatientResponse create() => IdentifyPatientResponse._();
  @$core.override
  IdentifyPatientResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IdentifyPatientResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentifyPatientResponse>(create);
  static IdentifyPatientResponse? _defaultInstance;

  /// Unset when duplicates need review first.
  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PatientMatch> get potentialDuplicates => $_getList(1);
}

class ListUnidentifiedRequest extends $pb.GeneratedMessage {
  factory ListUnidentifiedRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListUnidentifiedRequest._();

  factory ListUnidentifiedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUnidentifiedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUnidentifiedRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnidentifiedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnidentifiedRequest copyWith(
          void Function(ListUnidentifiedRequest) updates) =>
      super.copyWith((message) => updates(message as ListUnidentifiedRequest))
          as ListUnidentifiedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUnidentifiedRequest create() => ListUnidentifiedRequest._();
  @$core.override
  ListUnidentifiedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUnidentifiedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUnidentifiedRequest>(create);
  static ListUnidentifiedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListUnidentifiedResponse extends $pb.GeneratedMessage {
  factory ListUnidentifiedResponse({
    $core.Iterable<Patient>? patients,
  }) {
    final result = create();
    if (patients != null) result.patients.addAll(patients);
    return result;
  }

  ListUnidentifiedResponse._();

  factory ListUnidentifiedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUnidentifiedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUnidentifiedResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pPM<Patient>(1, _omitFieldNames ? '' : 'patients',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnidentifiedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUnidentifiedResponse copyWith(
          void Function(ListUnidentifiedResponse) updates) =>
      super.copyWith((message) => updates(message as ListUnidentifiedResponse))
          as ListUnidentifiedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUnidentifiedResponse create() => ListUnidentifiedResponse._();
  @$core.override
  ListUnidentifiedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUnidentifiedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUnidentifiedResponse>(create);
  static ListUnidentifiedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Patient> get patients => $_getList(0);
}

/// Consent to be photographed (SRS-EMPI-010).
///
/// Its own message because consent has a shape: somebody gave it, at a time, for
/// a stated purpose. A boolean records none of that, and "did this patient agree
/// to their photograph being kept" is a question somebody will be asked to
/// answer with evidence.
class PhotoConsent extends $pb.GeneratedMessage {
  factory PhotoConsent({
    $core.String? givenBy,
    $core.String? onBehalf,
    $core.String? purpose,
    $0.Timestamp? givenAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (givenBy != null) result.givenBy = givenBy;
    if (onBehalf != null) result.onBehalf = onBehalf;
    if (purpose != null) result.purpose = purpose;
    if (givenAt != null) result.givenAt = givenAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  PhotoConsent._();

  factory PhotoConsent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PhotoConsent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhotoConsent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'givenBy')
    ..aOS(2, _omitFieldNames ? '' : 'onBehalf')
    ..aOS(3, _omitFieldNames ? '' : 'purpose')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'givenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhotoConsent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhotoConsent copyWith(void Function(PhotoConsent) updates) =>
      super.copyWith((message) => updates(message as PhotoConsent))
          as PhotoConsent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhotoConsent create() => PhotoConsent._();
  @$core.override
  PhotoConsent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhotoConsent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhotoConsent>(create);
  static PhotoConsent? _defaultInstance;

  /// Who consented — the patient, or a related person holding the authority to
  /// consent for them.
  @$pb.TagNumber(1)
  $core.String get givenBy => $_getSZ(0);
  @$pb.TagNumber(1)
  set givenBy($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGivenBy() => $_has(0);
  @$pb.TagNumber(1)
  void clearGivenBy() => $_clearField(1);

  /// Set when somebody consented for the patient, naming the relationship that
  /// permitted it.
  @$pb.TagNumber(2)
  $core.String get onBehalf => $_getSZ(1);
  @$pb.TagNumber(2)
  set onBehalf($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnBehalf() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnBehalf() => $_clearField(2);

  /// What the photograph may be used for. "They agreed to a photo" is not
  /// consent to anything in particular: identification at the bedside and
  /// publication in a case report are both photographs of a patient.
  @$pb.TagNumber(3)
  $core.String get purpose => $_getSZ(2);
  @$pb.TagNumber(3)
  set purpose($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPurpose() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurpose() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get givenAt => $_getN(3);
  @$pb.TagNumber(4)
  set givenAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGivenAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearGivenAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureGivenAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get recordedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set recordedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecordedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecordedBy() => $_clearField(5);
}

class PatientPhoto extends $pb.GeneratedMessage {
  factory PatientPhoto({
    $core.String? photoId,
    $core.String? patientId,
    $core.String? contentType,
    $fixnum.Int64? byteSize,
    $core.String? digest,
    PhotoConsent? consent,
    $0.Timestamp? capturedAt,
    $core.String? capturedBy,
    $0.Timestamp? withdrawnAt,
    $core.String? withdrawnReason,
  }) {
    final result = create();
    if (photoId != null) result.photoId = photoId;
    if (patientId != null) result.patientId = patientId;
    if (contentType != null) result.contentType = contentType;
    if (byteSize != null) result.byteSize = byteSize;
    if (digest != null) result.digest = digest;
    if (consent != null) result.consent = consent;
    if (capturedAt != null) result.capturedAt = capturedAt;
    if (capturedBy != null) result.capturedBy = capturedBy;
    if (withdrawnAt != null) result.withdrawnAt = withdrawnAt;
    if (withdrawnReason != null) result.withdrawnReason = withdrawnReason;
    return result;
  }

  PatientPhoto._();

  factory PatientPhoto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PatientPhoto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PatientPhoto',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'contentType')
    ..aInt64(4, _omitFieldNames ? '' : 'byteSize')
    ..aOS(5, _omitFieldNames ? '' : 'digest')
    ..aOM<PhotoConsent>(6, _omitFieldNames ? '' : 'consent',
        subBuilder: PhotoConsent.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'capturedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'withdrawnAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'withdrawnReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientPhoto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientPhoto copyWith(void Function(PatientPhoto) updates) =>
      super.copyWith((message) => updates(message as PatientPhoto))
          as PatientPhoto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientPhoto create() => PatientPhoto._();
  @$core.override
  PatientPhoto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PatientPhoto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PatientPhoto>(create);
  static PatientPhoto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentType => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get byteSize => $_getI64(3);
  @$pb.TagNumber(4)
  set byteSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasByteSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearByteSize() => $_clearField(4);

  /// SHA-256 of the bytes, hex-encoded, so a stored object can be shown to be
  /// the one this record describes.
  @$pb.TagNumber(5)
  $core.String get digest => $_getSZ(4);
  @$pb.TagNumber(5)
  set digest($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDigest() => $_has(4);
  @$pb.TagNumber(5)
  void clearDigest() => $_clearField(5);

  @$pb.TagNumber(6)
  PhotoConsent get consent => $_getN(5);
  @$pb.TagNumber(6)
  set consent(PhotoConsent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConsent() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsent() => $_clearField(6);
  @$pb.TagNumber(6)
  PhotoConsent ensureConsent() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get capturedAt => $_getN(6);
  @$pb.TagNumber(7)
  set capturedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCapturedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCapturedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCapturedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get capturedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set capturedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCapturedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearCapturedBy() => $_clearField(8);

  /// Set when consent was withdrawn. The record stays and the bytes go: a
  /// deletion that left nothing behind would leave nobody able to answer whether
  /// a photograph ever existed.
  @$pb.TagNumber(9)
  $0.Timestamp get withdrawnAt => $_getN(8);
  @$pb.TagNumber(9)
  set withdrawnAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasWithdrawnAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearWithdrawnAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureWithdrawnAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get withdrawnReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set withdrawnReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWithdrawnReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearWithdrawnReason() => $_clearField(10);
}

class CapturePhotoRequest extends $pb.GeneratedMessage {
  factory CapturePhotoRequest({
    $core.String? patientId,
    $core.String? contentType,
    $core.List<$core.int>? content,
    PhotoConsent? consent,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (contentType != null) result.contentType = contentType;
    if (content != null) result.content = content;
    if (consent != null) result.consent = consent;
    return result;
  }

  CapturePhotoRequest._();

  factory CapturePhotoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CapturePhotoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CapturePhotoRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'contentType')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..aOM<PhotoConsent>(4, _omitFieldNames ? '' : 'consent',
        subBuilder: PhotoConsent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapturePhotoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapturePhotoRequest copyWith(void Function(CapturePhotoRequest) updates) =>
      super.copyWith((message) => updates(message as CapturePhotoRequest))
          as CapturePhotoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CapturePhotoRequest create() => CapturePhotoRequest._();
  @$core.override
  CapturePhotoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CapturePhotoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CapturePhotoRequest>(create);
  static CapturePhotoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  /// image/jpeg, image/png or image/webp. An allowlist, not a blocklist: a
  /// blocklist accepts SVG, which is a script container.
  @$pb.TagNumber(2)
  $core.String get contentType => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContentType() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentType() => $_clearField(2);

  /// At most 2 MiB. The bytes come from a ward tablet, and an unbounded endpoint
  /// is a way to fill a disk from the registration desk.
  @$pb.TagNumber(3)
  $core.List<$core.int> get content => $_getN(2);
  @$pb.TagNumber(3)
  set content($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  PhotoConsent get consent => $_getN(3);
  @$pb.TagNumber(4)
  set consent(PhotoConsent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasConsent() => $_has(3);
  @$pb.TagNumber(4)
  void clearConsent() => $_clearField(4);
  @$pb.TagNumber(4)
  PhotoConsent ensureConsent() => $_ensure(3);
}

class CapturePhotoResponse extends $pb.GeneratedMessage {
  factory CapturePhotoResponse({
    PatientPhoto? photo,
  }) {
    final result = create();
    if (photo != null) result.photo = photo;
    return result;
  }

  CapturePhotoResponse._();

  factory CapturePhotoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CapturePhotoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CapturePhotoResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<PatientPhoto>(1, _omitFieldNames ? '' : 'photo',
        subBuilder: PatientPhoto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapturePhotoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapturePhotoResponse copyWith(void Function(CapturePhotoResponse) updates) =>
      super.copyWith((message) => updates(message as CapturePhotoResponse))
          as CapturePhotoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CapturePhotoResponse create() => CapturePhotoResponse._();
  @$core.override
  CapturePhotoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CapturePhotoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CapturePhotoResponse>(create);
  static CapturePhotoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PatientPhoto get photo => $_getN(0);
  @$pb.TagNumber(1)
  set photo(PatientPhoto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoto() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoto() => $_clearField(1);
  @$pb.TagNumber(1)
  PatientPhoto ensurePhoto() => $_ensure(0);
}

class GetPhotoRequest extends $pb.GeneratedMessage {
  factory GetPhotoRequest({
    $core.String? patientId,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    return result;
  }

  GetPhotoRequest._();

  factory GetPhotoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPhotoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPhotoRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoRequest copyWith(void Function(GetPhotoRequest) updates) =>
      super.copyWith((message) => updates(message as GetPhotoRequest))
          as GetPhotoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPhotoRequest create() => GetPhotoRequest._();
  @$core.override
  GetPhotoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPhotoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPhotoRequest>(create);
  static GetPhotoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);
}

class GetPhotoResponse extends $pb.GeneratedMessage {
  factory GetPhotoResponse({
    PatientPhoto? photo,
    $core.List<$core.int>? content,
  }) {
    final result = create();
    if (photo != null) result.photo = photo;
    if (content != null) result.content = content;
    return result;
  }

  GetPhotoResponse._();

  factory GetPhotoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPhotoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPhotoResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<PatientPhoto>(1, _omitFieldNames ? '' : 'photo',
        subBuilder: PatientPhoto.create)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPhotoResponse copyWith(void Function(GetPhotoResponse) updates) =>
      super.copyWith((message) => updates(message as GetPhotoResponse))
          as GetPhotoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPhotoResponse create() => GetPhotoResponse._();
  @$core.override
  GetPhotoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPhotoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPhotoResponse>(create);
  static GetPhotoResponse? _defaultInstance;

  /// Unset when the patient has no photograph, which is an ordinary state
  /// rather than an error.
  @$pb.TagNumber(1)
  PatientPhoto get photo => $_getN(0);
  @$pb.TagNumber(1)
  set photo(PatientPhoto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoto() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoto() => $_clearField(1);
  @$pb.TagNumber(1)
  PatientPhoto ensurePhoto() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get content => $_getN(1);
  @$pb.TagNumber(2)
  set content($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

class WithdrawPhotoConsentRequest extends $pb.GeneratedMessage {
  factory WithdrawPhotoConsentRequest({
    $core.String? photoId,
    $core.String? reason,
  }) {
    final result = create();
    if (photoId != null) result.photoId = photoId;
    if (reason != null) result.reason = reason;
    return result;
  }

  WithdrawPhotoConsentRequest._();

  factory WithdrawPhotoConsentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawPhotoConsentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawPhotoConsentRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'photoId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawPhotoConsentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawPhotoConsentRequest copyWith(
          void Function(WithdrawPhotoConsentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WithdrawPhotoConsentRequest))
          as WithdrawPhotoConsentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawPhotoConsentRequest create() =>
      WithdrawPhotoConsentRequest._();
  @$core.override
  WithdrawPhotoConsentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawPhotoConsentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawPhotoConsentRequest>(create);
  static WithdrawPhotoConsentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get photoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set photoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhotoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhotoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class WithdrawPhotoConsentResponse extends $pb.GeneratedMessage {
  factory WithdrawPhotoConsentResponse({
    PatientPhoto? photo,
  }) {
    final result = create();
    if (photo != null) result.photo = photo;
    return result;
  }

  WithdrawPhotoConsentResponse._();

  factory WithdrawPhotoConsentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WithdrawPhotoConsentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WithdrawPhotoConsentResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<PatientPhoto>(1, _omitFieldNames ? '' : 'photo',
        subBuilder: PatientPhoto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawPhotoConsentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WithdrawPhotoConsentResponse copyWith(
          void Function(WithdrawPhotoConsentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WithdrawPhotoConsentResponse))
          as WithdrawPhotoConsentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WithdrawPhotoConsentResponse create() =>
      WithdrawPhotoConsentResponse._();
  @$core.override
  WithdrawPhotoConsentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WithdrawPhotoConsentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WithdrawPhotoConsentResponse>(create);
  static WithdrawPhotoConsentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PatientPhoto get photo => $_getN(0);
  @$pb.TagNumber(1)
  set photo(PatientPhoto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPhoto() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhoto() => $_clearField(1);
  @$pb.TagNumber(1)
  PatientPhoto ensurePhoto() => $_ensure(0);
}

class ConfigureFieldAccessRequest extends $pb.GeneratedMessage {
  factory ConfigureFieldAccessRequest({
    $core.String? facilityId,
    DemographicField? field_2,
    $core.String? requiredPermission,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (field_2 != null) result.field_2 = field_2;
    if (requiredPermission != null)
      result.requiredPermission = requiredPermission;
    return result;
  }

  ConfigureFieldAccessRequest._();

  factory ConfigureFieldAccessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureFieldAccessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureFieldAccessRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aE<DemographicField>(2, _omitFieldNames ? '' : 'field',
        enumValues: DemographicField.values)
    ..aOS(3, _omitFieldNames ? '' : 'requiredPermission')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureFieldAccessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureFieldAccessRequest copyWith(
          void Function(ConfigureFieldAccessRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ConfigureFieldAccessRequest))
          as ConfigureFieldAccessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureFieldAccessRequest create() =>
      ConfigureFieldAccessRequest._();
  @$core.override
  ConfigureFieldAccessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureFieldAccessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureFieldAccessRequest>(create);
  static ConfigureFieldAccessRequest? _defaultInstance;

  /// Empty applies to every facility in the jurisdiction; naming one overrides.
  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  DemographicField get field_2 => $_getN(1);
  @$pb.TagNumber(2)
  set field_2(DemographicField value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasField_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearField_2() => $_clearField(2);

  /// The permission that reveals this field in full. A field restricted behind
  /// no permission is restricted from everybody forever with nothing saying so.
  @$pb.TagNumber(3)
  $core.String get requiredPermission => $_getSZ(2);
  @$pb.TagNumber(3)
  set requiredPermission($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequiredPermission() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequiredPermission() => $_clearField(3);
}

class ConfigureFieldAccessResponse extends $pb.GeneratedMessage {
  factory ConfigureFieldAccessResponse() => create();

  ConfigureFieldAccessResponse._();

  factory ConfigureFieldAccessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureFieldAccessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureFieldAccessResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureFieldAccessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureFieldAccessResponse copyWith(
          void Function(ConfigureFieldAccessResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConfigureFieldAccessResponse))
          as ConfigureFieldAccessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureFieldAccessResponse create() =>
      ConfigureFieldAccessResponse._();
  @$core.override
  ConfigureFieldAccessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureFieldAccessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureFieldAccessResponse>(create);
  static ConfigureFieldAccessResponse? _defaultInstance;
}

class LinkIdentifierRequest extends $pb.GeneratedMessage {
  factory LinkIdentifierRequest({
    $core.String? patientId,
    IdentifierType? type,
    $core.String? system,
    $core.String? value,
    $core.String? assigningAuthority,
    $core.String? source,
    $core.bool? verify,
    $core.bool? requireVerification,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (type != null) result.type = type;
    if (system != null) result.system = system;
    if (value != null) result.value = value;
    if (assigningAuthority != null)
      result.assigningAuthority = assigningAuthority;
    if (source != null) result.source = source;
    if (verify != null) result.verify = verify;
    if (requireVerification != null)
      result.requireVerification = requireVerification;
    return result;
  }

  LinkIdentifierRequest._();

  factory LinkIdentifierRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkIdentifierRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkIdentifierRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<IdentifierType>(2, _omitFieldNames ? '' : 'type',
        enumValues: IdentifierType.values)
    ..aOS(3, _omitFieldNames ? '' : 'system')
    ..aOS(4, _omitFieldNames ? '' : 'value')
    ..aOS(5, _omitFieldNames ? '' : 'assigningAuthority')
    ..aOS(6, _omitFieldNames ? '' : 'source')
    ..aOB(7, _omitFieldNames ? '' : 'verify')
    ..aOB(8, _omitFieldNames ? '' : 'requireVerification')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkIdentifierRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkIdentifierRequest copyWith(
          void Function(LinkIdentifierRequest) updates) =>
      super.copyWith((message) => updates(message as LinkIdentifierRequest))
          as LinkIdentifierRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkIdentifierRequest create() => LinkIdentifierRequest._();
  @$core.override
  LinkIdentifierRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkIdentifierRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkIdentifierRequest>(create);
  static LinkIdentifierRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  /// The MRN is issued by this system from the facility's sequence and is not
  /// linkable from outside: accepting one would let a caller pick a value the
  /// sequence has not reached, and the next issue would collide.
  @$pb.TagNumber(2)
  IdentifierType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(IdentifierType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get system => $_getSZ(2);
  @$pb.TagNumber(3)
  set system($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSystem() => $_has(2);
  @$pb.TagNumber(3)
  void clearSystem() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get value => $_getSZ(3);
  @$pb.TagNumber(4)
  set value($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get assigningAuthority => $_getSZ(4);
  @$pb.TagNumber(5)
  set assigningAuthority($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssigningAuthority() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssigningAuthority() => $_clearField(5);

  /// Where this system learned the value. Required — SRS-EMPI-011 retains
  /// source, and a link with no source cannot be unwound with any confidence
  /// about what claimed it.
  @$pb.TagNumber(6)
  $core.String get source => $_getSZ(5);
  @$pb.TagNumber(6)
  set source($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);

  /// Ask the issuing authority to confirm the value, when a registry is
  /// configured for this system.
  @$pb.TagNumber(7)
  $core.bool get verify => $_getBF(6);
  @$pb.TagNumber(7)
  set verify($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVerify() => $_has(6);
  @$pb.TagNumber(7)
  void clearVerify() => $_clearField(7);

  /// Refuse the link unless the authority confirms it. Distinct from verify: a
  /// desk that wants confirmation but will accept an asserted value during an
  /// outage sets verify alone.
  @$pb.TagNumber(8)
  $core.bool get requireVerification => $_getBF(7);
  @$pb.TagNumber(8)
  set requireVerification($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRequireVerification() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequireVerification() => $_clearField(8);
}

class LinkIdentifierResponse extends $pb.GeneratedMessage {
  factory LinkIdentifierResponse({
    PatientIdentifier? identifier,
    $core.bool? verificationAttempted,
    $core.bool? registryUnavailable,
    $core.String? verificationReason,
    Demographics? authorityDemographics,
    $core.bool? hasAuthorityDemographics_6,
    $core.String? conflictProposalId,
  }) {
    final result = create();
    if (identifier != null) result.identifier = identifier;
    if (verificationAttempted != null)
      result.verificationAttempted = verificationAttempted;
    if (registryUnavailable != null)
      result.registryUnavailable = registryUnavailable;
    if (verificationReason != null)
      result.verificationReason = verificationReason;
    if (authorityDemographics != null)
      result.authorityDemographics = authorityDemographics;
    if (hasAuthorityDemographics_6 != null)
      result.hasAuthorityDemographics_6 = hasAuthorityDemographics_6;
    if (conflictProposalId != null)
      result.conflictProposalId = conflictProposalId;
    return result;
  }

  LinkIdentifierResponse._();

  factory LinkIdentifierResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkIdentifierResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkIdentifierResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<PatientIdentifier>(1, _omitFieldNames ? '' : 'identifier',
        subBuilder: PatientIdentifier.create)
    ..aOB(2, _omitFieldNames ? '' : 'verificationAttempted')
    ..aOB(3, _omitFieldNames ? '' : 'registryUnavailable')
    ..aOS(4, _omitFieldNames ? '' : 'verificationReason')
    ..aOM<Demographics>(5, _omitFieldNames ? '' : 'authorityDemographics',
        subBuilder: Demographics.create)
    ..aOB(6, _omitFieldNames ? '' : 'hasAuthorityDemographics')
    ..aOS(7, _omitFieldNames ? '' : 'conflictProposalId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkIdentifierResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkIdentifierResponse copyWith(
          void Function(LinkIdentifierResponse) updates) =>
      super.copyWith((message) => updates(message as LinkIdentifierResponse))
          as LinkIdentifierResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkIdentifierResponse create() => LinkIdentifierResponse._();
  @$core.override
  LinkIdentifierResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkIdentifierResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkIdentifierResponse>(create);
  static LinkIdentifierResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PatientIdentifier get identifier => $_getN(0);
  @$pb.TagNumber(1)
  set identifier(PatientIdentifier value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => $_clearField(1);
  @$pb.TagNumber(1)
  PatientIdentifier ensureIdentifier() => $_ensure(0);

  /// False when no registry is configured for the system, which is a different
  /// situation from an authority that was asked and declined.
  @$pb.TagNumber(2)
  $core.bool get verificationAttempted => $_getBF(1);
  @$pb.TagNumber(2)
  set verificationAttempted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVerificationAttempted() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerificationAttempted() => $_clearField(2);

  /// The authority could not be reached. The identifier is linked as asserted.
  @$pb.TagNumber(3)
  $core.bool get registryUnavailable => $_getBF(2);
  @$pb.TagNumber(3)
  set registryUnavailable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegistryUnavailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegistryUnavailable() => $_clearField(3);

  /// A negative answer's explanation.
  @$pb.TagNumber(4)
  $core.String get verificationReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set verificationReason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVerificationReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerificationReason() => $_clearField(4);

  /// What the issuing authority holds against the identifier, when it returned
  /// anything. Never applied to the record here: a difference is a conflict for
  /// reconciliation (SRS-EMPI-012), and silently overwriting trusted data with
  /// a feed is the failure that requirement exists to prevent.
  @$pb.TagNumber(5)
  Demographics get authorityDemographics => $_getN(4);
  @$pb.TagNumber(5)
  set authorityDemographics(Demographics value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAuthorityDemographics() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthorityDemographics() => $_clearField(5);
  @$pb.TagNumber(5)
  Demographics ensureAuthorityDemographics() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get hasAuthorityDemographics_6 => $_getBF(5);
  @$pb.TagNumber(6)
  set hasAuthorityDemographics_6($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHasAuthorityDemographics_6() => $_has(5);
  @$pb.TagNumber(6)
  void clearHasAuthorityDemographics_6() => $_clearField(6);

  /// Set when the authority's demographics disagreed with the record and a
  /// reconciliation proposal was raised (SRS-EMPI-012). The values are never
  /// applied here: a registry can be wrong, and can be describing a different
  /// person.
  @$pb.TagNumber(7)
  $core.String get conflictProposalId => $_getSZ(6);
  @$pb.TagNumber(7)
  set conflictProposalId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConflictProposalId() => $_has(6);
  @$pb.TagNumber(7)
  void clearConflictProposalId() => $_clearField(7);
}

class UnlinkIdentifierRequest extends $pb.GeneratedMessage {
  factory UnlinkIdentifierRequest({
    $core.String? identifierId,
    $core.bool? revoke,
    $core.String? reason,
  }) {
    final result = create();
    if (identifierId != null) result.identifierId = identifierId;
    if (revoke != null) result.revoke = revoke;
    if (reason != null) result.reason = reason;
    return result;
  }

  UnlinkIdentifierRequest._();

  factory UnlinkIdentifierRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnlinkIdentifierRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlinkIdentifierRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'identifierId')
    ..aOB(2, _omitFieldNames ? '' : 'revoke')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkIdentifierRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkIdentifierRequest copyWith(
          void Function(UnlinkIdentifierRequest) updates) =>
      super.copyWith((message) => updates(message as UnlinkIdentifierRequest))
          as UnlinkIdentifierRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlinkIdentifierRequest create() => UnlinkIdentifierRequest._();
  @$core.override
  UnlinkIdentifierRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnlinkIdentifierRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnlinkIdentifierRequest>(create);
  static UnlinkIdentifierRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get identifierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set identifierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdentifierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifierId() => $_clearField(1);

  /// True when the identifier should never have pointed at this patient, as
  /// opposed to having been correct and replaced. The difference decides whether
  /// a search on the value still resolves here, so it is explicit rather than
  /// inferred.
  @$pb.TagNumber(2)
  $core.bool get revoke => $_getBF(1);
  @$pb.TagNumber(2)
  set revoke($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevoke() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevoke() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class UnlinkIdentifierResponse extends $pb.GeneratedMessage {
  factory UnlinkIdentifierResponse({
    PatientIdentifier? identifier,
  }) {
    final result = create();
    if (identifier != null) result.identifier = identifier;
    return result;
  }

  UnlinkIdentifierResponse._();

  factory UnlinkIdentifierResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnlinkIdentifierResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlinkIdentifierResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<PatientIdentifier>(1, _omitFieldNames ? '' : 'identifier',
        subBuilder: PatientIdentifier.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkIdentifierResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkIdentifierResponse copyWith(
          void Function(UnlinkIdentifierResponse) updates) =>
      super.copyWith((message) => updates(message as UnlinkIdentifierResponse))
          as UnlinkIdentifierResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlinkIdentifierResponse create() => UnlinkIdentifierResponse._();
  @$core.override
  UnlinkIdentifierResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnlinkIdentifierResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnlinkIdentifierResponse>(create);
  static UnlinkIdentifierResponse? _defaultInstance;

  /// The retired identifier, not its absence: SRS-EMPI-011 retains unlink
  /// history, and there is no delete on this path.
  @$pb.TagNumber(1)
  PatientIdentifier get identifier => $_getN(0);
  @$pb.TagNumber(1)
  set identifier(PatientIdentifier value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => $_clearField(1);
  @$pb.TagNumber(1)
  PatientIdentifier ensureIdentifier() => $_ensure(0);
}

class VerifyIdentifierRequest extends $pb.GeneratedMessage {
  factory VerifyIdentifierRequest({
    $core.String? identifierId,
  }) {
    final result = create();
    if (identifierId != null) result.identifierId = identifierId;
    return result;
  }

  VerifyIdentifierRequest._();

  factory VerifyIdentifierRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyIdentifierRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyIdentifierRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'identifierId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyIdentifierRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyIdentifierRequest copyWith(
          void Function(VerifyIdentifierRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyIdentifierRequest))
          as VerifyIdentifierRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyIdentifierRequest create() => VerifyIdentifierRequest._();
  @$core.override
  VerifyIdentifierRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyIdentifierRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyIdentifierRequest>(create);
  static VerifyIdentifierRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get identifierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set identifierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdentifierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifierId() => $_clearField(1);
}

class VerifyIdentifierResponse extends $pb.GeneratedMessage {
  factory VerifyIdentifierResponse({
    PatientIdentifier? identifier,
    Demographics? authorityDemographics,
    $core.bool? hasAuthorityDemographics_3,
  }) {
    final result = create();
    if (identifier != null) result.identifier = identifier;
    if (authorityDemographics != null)
      result.authorityDemographics = authorityDemographics;
    if (hasAuthorityDemographics_3 != null)
      result.hasAuthorityDemographics_3 = hasAuthorityDemographics_3;
    return result;
  }

  VerifyIdentifierResponse._();

  factory VerifyIdentifierResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyIdentifierResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyIdentifierResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<PatientIdentifier>(1, _omitFieldNames ? '' : 'identifier',
        subBuilder: PatientIdentifier.create)
    ..aOM<Demographics>(2, _omitFieldNames ? '' : 'authorityDemographics',
        subBuilder: Demographics.create)
    ..aOB(3, _omitFieldNames ? '' : 'hasAuthorityDemographics')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyIdentifierResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyIdentifierResponse copyWith(
          void Function(VerifyIdentifierResponse) updates) =>
      super.copyWith((message) => updates(message as VerifyIdentifierResponse))
          as VerifyIdentifierResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyIdentifierResponse create() => VerifyIdentifierResponse._();
  @$core.override
  VerifyIdentifierResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyIdentifierResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyIdentifierResponse>(create);
  static VerifyIdentifierResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PatientIdentifier get identifier => $_getN(0);
  @$pb.TagNumber(1)
  set identifier(PatientIdentifier value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => $_clearField(1);
  @$pb.TagNumber(1)
  PatientIdentifier ensureIdentifier() => $_ensure(0);

  @$pb.TagNumber(2)
  Demographics get authorityDemographics => $_getN(1);
  @$pb.TagNumber(2)
  set authorityDemographics(Demographics value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthorityDemographics() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorityDemographics() => $_clearField(2);
  @$pb.TagNumber(2)
  Demographics ensureAuthorityDemographics() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get hasAuthorityDemographics_3 => $_getBF(2);
  @$pb.TagNumber(3)
  set hasAuthorityDemographics_3($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasAuthorityDemographics_3() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasAuthorityDemographics_3() => $_clearField(3);
}

class DeceasedRecord extends $pb.GeneratedMessage {
  factory DeceasedRecord({
    PartialDate? date,
    $core.String? source,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (date != null) result.date = date;
    if (source != null) result.source = source;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  DeceasedRecord._();

  factory DeceasedRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeceasedRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeceasedRecord',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<PartialDate>(1, _omitFieldNames ? '' : 'date',
        subBuilder: PartialDate.create)
    ..aOS(2, _omitFieldNames ? '' : 'source')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeceasedRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeceasedRecord copyWith(void Function(DeceasedRecord) updates) =>
      super.copyWith((message) => updates(message as DeceasedRecord))
          as DeceasedRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeceasedRecord create() => DeceasedRecord._();
  @$core.override
  DeceasedRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeceasedRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeceasedRecord>(create);
  static DeceasedRecord? _defaultInstance;

  @$pb.TagNumber(1)
  PartialDate get date => $_getN(0);
  @$pb.TagNumber(1)
  set date(PartialDate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
  @$pb.TagNumber(1)
  PartialDate ensureDate() => $_ensure(0);

  /// Who says so: a registrar, a clinician, a national death registry feed. A
  /// feed can be wrong about the wrong patient, and reversing it needs to know
  /// what claimed it.
  @$pb.TagNumber(2)
  $core.String get source => $_getSZ(1);
  @$pb.TagNumber(2)
  set source($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get recordedAt => $_getN(2);
  @$pb.TagNumber(3)
  set recordedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureRecordedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get recordedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set recordedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordedBy() => $_clearField(4);
}

class Patient extends $pb.GeneratedMessage {
  factory Patient({
    $core.String? patientId,
    $core.String? registeredFacilityId,
    PatientStatus? status,
    Demographics? demographics,
    $core.Iterable<PatientIdentifier>? identifiers,
    $core.String? mergedIntoPatientId,
    DeceasedRecord? deceased,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $fixnum.Int64? version,
    $core.bool? acceptsRoutineScheduling,
    TemporaryDesignation? designation,
    $0.Timestamp? identifiedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (registeredFacilityId != null)
      result.registeredFacilityId = registeredFacilityId;
    if (status != null) result.status = status;
    if (demographics != null) result.demographics = demographics;
    if (identifiers != null) result.identifiers.addAll(identifiers);
    if (mergedIntoPatientId != null)
      result.mergedIntoPatientId = mergedIntoPatientId;
    if (deceased != null) result.deceased = deceased;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    if (acceptsRoutineScheduling != null)
      result.acceptsRoutineScheduling = acceptsRoutineScheduling;
    if (designation != null) result.designation = designation;
    if (identifiedAt != null) result.identifiedAt = identifiedAt;
    return result;
  }

  Patient._();

  factory Patient.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Patient.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Patient',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'registeredFacilityId')
    ..aE<PatientStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: PatientStatus.values)
    ..aOM<Demographics>(4, _omitFieldNames ? '' : 'demographics',
        subBuilder: Demographics.create)
    ..pPM<PatientIdentifier>(5, _omitFieldNames ? '' : 'identifiers',
        subBuilder: PatientIdentifier.create)
    ..aOS(6, _omitFieldNames ? '' : 'mergedIntoPatientId')
    ..aOM<DeceasedRecord>(7, _omitFieldNames ? '' : 'deceased',
        subBuilder: DeceasedRecord.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..aOB(11, _omitFieldNames ? '' : 'acceptsRoutineScheduling')
    ..aOM<TemporaryDesignation>(12, _omitFieldNames ? '' : 'designation',
        subBuilder: TemporaryDesignation.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'identifiedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Patient clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Patient copyWith(void Function(Patient) updates) =>
      super.copyWith((message) => updates(message as Patient)) as Patient;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Patient create() => Patient._();
  @$core.override
  Patient createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Patient getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Patient>(create);
  static Patient? _defaultInstance;

  /// Opaque, internal, immutable. Never printed, never quoted, never changed —
  /// not by a merge, not by a correction (SRS-EMPI-002).
  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get registeredFacilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set registeredFacilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegisteredFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegisteredFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  PatientStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(PatientStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  Demographics get demographics => $_getN(3);
  @$pb.TagNumber(4)
  set demographics(Demographics value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDemographics() => $_has(3);
  @$pb.TagNumber(4)
  void clearDemographics() => $_clearField(4);
  @$pb.TagNumber(4)
  Demographics ensureDemographics() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<PatientIdentifier> get identifiers => $_getList(4);

  /// Set only on the losing side of a merge. Resolves a reference written
  /// before it.
  @$pb.TagNumber(6)
  $core.String get mergedIntoPatientId => $_getSZ(5);
  @$pb.TagNumber(6)
  set mergedIntoPatientId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMergedIntoPatientId() => $_has(5);
  @$pb.TagNumber(6)
  void clearMergedIntoPatientId() => $_clearField(6);

  @$pb.TagNumber(7)
  DeceasedRecord get deceased => $_getN(6);
  @$pb.TagNumber(7)
  set deceased(DeceasedRecord value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDeceased() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeceased() => $_clearField(7);
  @$pb.TagNumber(7)
  DeceasedRecord ensureDeceased() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get updatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set updatedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureUpdatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);

  /// True when the record is fit to receive a routine appointment. The identity
  /// context answers the factual half; scheduling owns whether to warn or block
  /// (SRS-EMPI-008).
  @$pb.TagNumber(11)
  $core.bool get acceptsRoutineScheduling => $_getBF(10);
  @$pb.TagNumber(11)
  set acceptsRoutineScheduling($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAcceptsRoutineScheduling() => $_has(10);
  @$pb.TagNumber(11)
  void clearAcceptsRoutineScheduling() => $_clearField(11);

  /// Set only on a patient registered unidentified (SRS-EMPI-015). Kept after
  /// identification rather than cleared: an hour of records was filed under it.
  @$pb.TagNumber(12)
  TemporaryDesignation get designation => $_getN(11);
  @$pb.TagNumber(12)
  set designation(TemporaryDesignation value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDesignation() => $_has(11);
  @$pb.TagNumber(12)
  void clearDesignation() => $_clearField(12);
  @$pb.TagNumber(12)
  TemporaryDesignation ensureDesignation() => $_ensure(11);

  /// When real demographics replaced the designation. Unset while still unknown.
  @$pb.TagNumber(13)
  $0.Timestamp get identifiedAt => $_getN(12);
  @$pb.TagNumber(13)
  set identifiedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasIdentifiedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearIdentifiedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureIdentifiedAt() => $_ensure(12);
}

/// One signal's contribution, so a score is reviewable rather than a bare
/// number (SRS-EMPI-003).
class MatchFieldScore extends $pb.GeneratedMessage {
  factory MatchFieldScore({
    $core.String? field_1,
    $core.double? similarity,
    $core.double? weight,
    $core.String? note,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (similarity != null) result.similarity = similarity;
    if (weight != null) result.weight = weight;
    if (note != null) result.note = note;
    return result;
  }

  MatchFieldScore._();

  factory MatchFieldScore.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchFieldScore.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchFieldScore',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aD(2, _omitFieldNames ? '' : 'similarity')
    ..aD(3, _omitFieldNames ? '' : 'weight')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchFieldScore clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchFieldScore copyWith(void Function(MatchFieldScore) updates) =>
      super.copyWith((message) => updates(message as MatchFieldScore))
          as MatchFieldScore;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchFieldScore create() => MatchFieldScore._();
  @$core.override
  MatchFieldScore createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchFieldScore getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchFieldScore>(create);
  static MatchFieldScore? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  /// 0..1, or negative when the signal says these are different people.
  @$pb.TagNumber(2)
  $core.double get similarity => $_getN(1);
  @$pb.TagNumber(2)
  set similarity($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSimilarity() => $_has(1);
  @$pb.TagNumber(2)
  void clearSimilarity() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get weight => $_getN(2);
  @$pb.TagNumber(3)
  set weight($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearWeight() => $_clearField(3);

  /// Short, non-PHI explanation such as "year only" or "names appear
  /// transposed".
  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class PatientMatch extends $pb.GeneratedMessage {
  factory PatientMatch({
    Patient? patient,
    $core.double? confidence,
    MatchOutcome? outcome,
    $core.Iterable<MatchFieldScore>? fields,
    $core.bool? masked,
    PatientName? matchedFormerName,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    if (confidence != null) result.confidence = confidence;
    if (outcome != null) result.outcome = outcome;
    if (fields != null) result.fields.addAll(fields);
    if (masked != null) result.masked = masked;
    if (matchedFormerName != null) result.matchedFormerName = matchedFormerName;
    return result;
  }

  PatientMatch._();

  factory PatientMatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PatientMatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PatientMatch',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..aD(2, _omitFieldNames ? '' : 'confidence')
    ..aE<MatchOutcome>(3, _omitFieldNames ? '' : 'outcome',
        enumValues: MatchOutcome.values)
    ..pPM<MatchFieldScore>(4, _omitFieldNames ? '' : 'fields',
        subBuilder: MatchFieldScore.create)
    ..aOB(5, _omitFieldNames ? '' : 'masked')
    ..aOM<PatientName>(6, _omitFieldNames ? '' : 'matchedFormerName',
        subBuilder: PatientName.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientMatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientMatch copyWith(void Function(PatientMatch) updates) =>
      super.copyWith((message) => updates(message as PatientMatch))
          as PatientMatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientMatch create() => PatientMatch._();
  @$core.override
  PatientMatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PatientMatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PatientMatch>(create);
  static PatientMatch? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get confidence => $_getN(1);
  @$pb.TagNumber(2)
  set confidence($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConfidence() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfidence() => $_clearField(2);

  @$pb.TagNumber(3)
  MatchOutcome get outcome => $_getN(2);
  @$pb.TagNumber(3)
  set outcome(MatchOutcome value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOutcome() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutcome() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<MatchFieldScore> get fields => $_getList(3);

  /// True when protected fields were masked for this caller. The UI says so
  /// rather than showing blanks that read as missing data.
  @$pb.TagNumber(5)
  $core.bool get masked => $_getBF(4);
  @$pb.TagNumber(5)
  set masked($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMasked() => $_has(4);
  @$pb.TagNumber(5)
  void clearMasked() => $_clearField(5);

  /// Set when this patient was reached through a name they no longer hold
  /// (SRS-EMPI-007). A match on a maiden name scores low against the current
  /// name, so without this the row reads as an irrelevant result and is
  /// dismissed — which is the outcome the history exists to prevent.
  @$pb.TagNumber(6)
  PatientName get matchedFormerName => $_getN(5);
  @$pb.TagNumber(6)
  set matchedFormerName(PatientName value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMatchedFormerName() => $_has(5);
  @$pb.TagNumber(6)
  void clearMatchedFormerName() => $_clearField(6);
  @$pb.TagNumber(6)
  PatientName ensureMatchedFormerName() => $_ensure(5);
}

class RegisterPatientRequest extends $pb.GeneratedMessage {
  factory RegisterPatientRequest({
    Demographics? demographics,
    $core.Iterable<PatientIdentifier>? identifiers,
    $core.Iterable<$core.String>? acknowledgedDuplicatePatientIds,
  }) {
    final result = create();
    if (demographics != null) result.demographics = demographics;
    if (identifiers != null) result.identifiers.addAll(identifiers);
    if (acknowledgedDuplicatePatientIds != null)
      result.acknowledgedDuplicatePatientIds
          .addAll(acknowledgedDuplicatePatientIds);
    return result;
  }

  RegisterPatientRequest._();

  factory RegisterPatientRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterPatientRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterPatientRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Demographics>(1, _omitFieldNames ? '' : 'demographics',
        subBuilder: Demographics.create)
    ..pPM<PatientIdentifier>(2, _omitFieldNames ? '' : 'identifiers',
        subBuilder: PatientIdentifier.create)
    ..pPS(3, _omitFieldNames ? '' : 'acknowledgedDuplicatePatientIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPatientRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPatientRequest copyWith(
          void Function(RegisterPatientRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterPatientRequest))
          as RegisterPatientRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPatientRequest create() => RegisterPatientRequest._();
  @$core.override
  RegisterPatientRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterPatientRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterPatientRequest>(create);
  static RegisterPatientRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Demographics get demographics => $_getN(0);
  @$pb.TagNumber(1)
  set demographics(Demographics value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDemographics() => $_has(0);
  @$pb.TagNumber(1)
  void clearDemographics() => $_clearField(1);
  @$pb.TagNumber(1)
  Demographics ensureDemographics() => $_ensure(0);

  /// Identifiers the patient already holds — a national health identifier, a
  /// card from another facility. The MRN is issued by this system and must not
  /// be supplied here.
  @$pb.TagNumber(2)
  $pb.PbList<PatientIdentifier> get identifiers => $_getList(1);

  /// Acknowledges duplicates already shown to the user. Registration refuses a
  /// probable duplicate unless the caller has seen it and said to proceed,
  /// which is what makes search-before-create a control rather than a courtesy.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get acknowledgedDuplicatePatientIds => $_getList(2);
}

/// Exactly one of these is populated.
///
/// Finding a probable duplicate is an expected outcome of search-before-create,
/// not a failure, so it comes back as a successful response with `patient`
/// empty and `potential_duplicates` set. Returning an error instead would be
/// truthful about the outcome and useless in practice: Connect discards the
/// response body on an error, so the caller would be told to review candidates
/// it cannot see, and would have to search again to find them.
///
/// A client checks `patient`: set means registered, empty means review the
/// candidates and either correct the details or re-send with the patient ids in
/// acknowledged_duplicate_patient_ids.
class RegisterPatientResponse extends $pb.GeneratedMessage {
  factory RegisterPatientResponse({
    Patient? patient,
    $core.Iterable<PatientMatch>? potentialDuplicates,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    if (potentialDuplicates != null)
      result.potentialDuplicates.addAll(potentialDuplicates);
    return result;
  }

  RegisterPatientResponse._();

  factory RegisterPatientResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterPatientResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterPatientResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..pPM<PatientMatch>(2, _omitFieldNames ? '' : 'potentialDuplicates',
        subBuilder: PatientMatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPatientResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterPatientResponse copyWith(
          void Function(RegisterPatientResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterPatientResponse))
          as RegisterPatientResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterPatientResponse create() => RegisterPatientResponse._();
  @$core.override
  RegisterPatientResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterPatientResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterPatientResponse>(create);
  static RegisterPatientResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);

  /// Set when registration did not proceed because a probable duplicate needs
  /// review. Empty on success.
  @$pb.TagNumber(2)
  $pb.PbList<PatientMatch> get potentialDuplicates => $_getList(1);
}

class SearchPatientsRequest extends $pb.GeneratedMessage {
  factory SearchPatientsRequest({
    $core.String? name,
    PartialDate? birthDate,
    $core.String? phone,
    $core.String? identifierValue,
    IdentifierType? identifierType,
    $core.String? identifierSystem,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (birthDate != null) result.birthDate = birthDate;
    if (phone != null) result.phone = phone;
    if (identifierValue != null) result.identifierValue = identifierValue;
    if (identifierType != null) result.identifierType = identifierType;
    if (identifierSystem != null) result.identifierSystem = identifierSystem;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  SearchPatientsRequest._();

  factory SearchPatientsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchPatientsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchPatientsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<PartialDate>(2, _omitFieldNames ? '' : 'birthDate',
        subBuilder: PartialDate.create)
    ..aOS(3, _omitFieldNames ? '' : 'phone')
    ..aOS(4, _omitFieldNames ? '' : 'identifierValue')
    ..aE<IdentifierType>(5, _omitFieldNames ? '' : 'identifierType',
        enumValues: IdentifierType.values)
    ..aOS(6, _omitFieldNames ? '' : 'identifierSystem')
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..aOS(8, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPatientsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPatientsRequest copyWith(
          void Function(SearchPatientsRequest) updates) =>
      super.copyWith((message) => updates(message as SearchPatientsRequest))
          as SearchPatientsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchPatientsRequest create() => SearchPatientsRequest._();
  @$core.override
  SearchPatientsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchPatientsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchPatientsRequest>(create);
  static SearchPatientsRequest? _defaultInstance;

  /// Free-text name fragment, matched case-insensitively.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  PartialDate get birthDate => $_getN(1);
  @$pb.TagNumber(2)
  set birthDate(PartialDate value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBirthDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearBirthDate() => $_clearField(2);
  @$pb.TagNumber(2)
  PartialDate ensureBirthDate() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get phone => $_getSZ(2);
  @$pb.TagNumber(3)
  set phone($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhone() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhone() => $_clearField(3);

  /// Exact identifier lookup. Finds superseded identifiers too, because a
  /// patient quoting an old card must still be found.
  @$pb.TagNumber(4)
  $core.String get identifierValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set identifierValue($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdentifierValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdentifierValue() => $_clearField(4);

  @$pb.TagNumber(5)
  IdentifierType get identifierType => $_getN(4);
  @$pb.TagNumber(5)
  set identifierType(IdentifierType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIdentifierType() => $_has(4);
  @$pb.TagNumber(5)
  void clearIdentifierType() => $_clearField(5);

  /// Namespaces the value. Required for every type except MRN, which is
  /// namespaced by the facility that issued it — two insurers both issue
  /// membership numbers, and without the namespace they collide.
  @$pb.TagNumber(6)
  $core.String get identifierSystem => $_getSZ(5);
  @$pb.TagNumber(6)
  set identifierSystem($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdentifierSystem() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentifierSystem() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get pageSize => $_getIZ(6);
  @$pb.TagNumber(7)
  set pageSize($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageSize() => $_clearField(7);

  /// Opaque cursor, never a page number.
  @$pb.TagNumber(8)
  $core.String get pageToken => $_getSZ(7);
  @$pb.TagNumber(8)
  set pageToken($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPageToken() => $_has(7);
  @$pb.TagNumber(8)
  void clearPageToken() => $_clearField(8);
}

class SearchPatientsResponse extends $pb.GeneratedMessage {
  factory SearchPatientsResponse({
    $core.Iterable<PatientMatch>? matches,
    $core.String? nextPageToken,
  }) {
    final result = create();
    if (matches != null) result.matches.addAll(matches);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  SearchPatientsResponse._();

  factory SearchPatientsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchPatientsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchPatientsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pPM<PatientMatch>(1, _omitFieldNames ? '' : 'matches',
        subBuilder: PatientMatch.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPatientsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchPatientsResponse copyWith(
          void Function(SearchPatientsResponse) updates) =>
      super.copyWith((message) => updates(message as SearchPatientsResponse))
          as SearchPatientsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchPatientsResponse create() => SearchPatientsResponse._();
  @$core.override
  SearchPatientsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchPatientsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchPatientsResponse>(create);
  static SearchPatientsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PatientMatch> get matches => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class GetPatientRequest extends $pb.GeneratedMessage {
  factory GetPatientRequest({
    $core.String? patientId,
    $core.bool? resolveMerged,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (resolveMerged != null) result.resolveMerged = resolveMerged;
    return result;
  }

  GetPatientRequest._();

  factory GetPatientRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPatientRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPatientRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOB(2, _omitFieldNames ? '' : 'resolveMerged')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientRequest copyWith(void Function(GetPatientRequest) updates) =>
      super.copyWith((message) => updates(message as GetPatientRequest))
          as GetPatientRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPatientRequest create() => GetPatientRequest._();
  @$core.override
  GetPatientRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPatientRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPatientRequest>(create);
  static GetPatientRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  /// Follows merged records to the survivor. Default false, so a caller that
  /// means "this exact record" gets it.
  @$pb.TagNumber(2)
  $core.bool get resolveMerged => $_getBF(1);
  @$pb.TagNumber(2)
  set resolveMerged($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResolveMerged() => $_has(1);
  @$pb.TagNumber(2)
  void clearResolveMerged() => $_clearField(2);
}

class GetPatientResponse extends $pb.GeneratedMessage {
  factory GetPatientResponse({
    Patient? patient,
    $core.String? resolvedFromPatientId,
    $core.bool? masked,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    if (resolvedFromPatientId != null)
      result.resolvedFromPatientId = resolvedFromPatientId;
    if (masked != null) result.masked = masked;
    return result;
  }

  GetPatientResponse._();

  factory GetPatientResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPatientResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPatientResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..aOS(2, _omitFieldNames ? '' : 'resolvedFromPatientId')
    ..aOB(3, _omitFieldNames ? '' : 'masked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientResponse copyWith(void Function(GetPatientResponse) updates) =>
      super.copyWith((message) => updates(message as GetPatientResponse))
          as GetPatientResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPatientResponse create() => GetPatientResponse._();
  @$core.override
  GetPatientResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPatientResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPatientResponse>(create);
  static GetPatientResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);

  /// Set when resolve_merged followed a merge, naming the record asked for.
  @$pb.TagNumber(2)
  $core.String get resolvedFromPatientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resolvedFromPatientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResolvedFromPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResolvedFromPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get masked => $_getBF(2);
  @$pb.TagNumber(3)
  set masked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMasked() => $_has(2);
  @$pb.TagNumber(3)
  void clearMasked() => $_clearField(3);
}

class UpdateDemographicsRequest extends $pb.GeneratedMessage {
  factory UpdateDemographicsRequest({
    $core.String? patientId,
    Demographics? demographics,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (demographics != null) result.demographics = demographics;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  UpdateDemographicsRequest._();

  factory UpdateDemographicsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateDemographicsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDemographicsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOM<Demographics>(2, _omitFieldNames ? '' : 'demographics',
        subBuilder: Demographics.create)
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDemographicsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDemographicsRequest copyWith(
          void Function(UpdateDemographicsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateDemographicsRequest))
          as UpdateDemographicsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateDemographicsRequest create() => UpdateDemographicsRequest._();
  @$core.override
  UpdateDemographicsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateDemographicsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDemographicsRequest>(create);
  static UpdateDemographicsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  Demographics get demographics => $_getN(1);
  @$pb.TagNumber(2)
  set demographics(Demographics value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDemographics() => $_has(1);
  @$pb.TagNumber(2)
  void clearDemographics() => $_clearField(2);
  @$pb.TagNumber(2)
  Demographics ensureDemographics() => $_ensure(1);

  /// Optimistic concurrency: two clerks correcting one record at the same desk
  /// is routine.
  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class UpdateDemographicsResponse extends $pb.GeneratedMessage {
  factory UpdateDemographicsResponse({
    Patient? patient,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    return result;
  }

  UpdateDemographicsResponse._();

  factory UpdateDemographicsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateDemographicsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDemographicsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDemographicsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDemographicsResponse copyWith(
          void Function(UpdateDemographicsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateDemographicsResponse))
          as UpdateDemographicsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateDemographicsResponse create() => UpdateDemographicsResponse._();
  @$core.override
  UpdateDemographicsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateDemographicsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDemographicsResponse>(create);
  static UpdateDemographicsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);
}

/// What was actually checked before confirming a patient's identity
/// (SRS-EMPI-010).
///
/// Evidence rather than a bare confirmation: the requirement prohibits a
/// photograph from being the sole identity proof and requires the workflow to
/// include a configured positive identifier, and neither is checkable against a
/// call that says only that somebody clicked a button.
class IdentityEvidence extends $pb.GeneratedMessage {
  factory IdentityEvidence({
    $core.Iterable<$core.String>? identifierIds,
    $core.bool? photoMatched,
    $core.String? vouchedForBy,
    $core.String? note,
  }) {
    final result = create();
    if (identifierIds != null) result.identifierIds.addAll(identifierIds);
    if (photoMatched != null) result.photoMatched = photoMatched;
    if (vouchedForBy != null) result.vouchedForBy = vouchedForBy;
    if (note != null) result.note = note;
    return result;
  }

  IdentityEvidence._();

  factory IdentityEvidence.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IdentityEvidence.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IdentityEvidence',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'identifierIds')
    ..aOB(2, _omitFieldNames ? '' : 'photoMatched')
    ..aOS(3, _omitFieldNames ? '' : 'vouchedForBy')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentityEvidence clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IdentityEvidence copyWith(void Function(IdentityEvidence) updates) =>
      super.copyWith((message) => updates(message as IdentityEvidence))
          as IdentityEvidence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IdentityEvidence create() => IdentityEvidence._();
  @$core.override
  IdentityEvidence createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IdentityEvidence getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentityEvidence>(create);
  static IdentityEvidence? _defaultInstance;

  /// The identifiers that were sighted and checked. Only a *verified* one
  /// counts: a number read off a photocopy carries no more assurance than the
  /// photograph does.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get identifierIds => $_getList(0);

  /// A human compared the patient with the stored photograph. Useful, and never
  /// sufficient — face comparison fails hardest for siblings, twins, an old
  /// photo, and measurably by skin tone and age, which concentrates its errors
  /// on the people least able to contest them.
  @$pb.TagNumber(2)
  $core.bool get photoMatched => $_getBF(1);
  @$pb.TagNumber(2)
  set photoMatched($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhotoMatched() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhotoMatched() => $_clearField(2);

  /// A related person identified the patient. Also never sufficient alone.
  @$pb.TagNumber(3)
  $core.String get vouchedForBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set vouchedForBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVouchedForBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearVouchedForBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class ConfirmIdentityRequest extends $pb.GeneratedMessage {
  factory ConfirmIdentityRequest({
    $core.String? patientId,
    $fixnum.Int64? expectedVersion,
    IdentityEvidence? evidence,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    if (evidence != null) result.evidence = evidence;
    return result;
  }

  ConfirmIdentityRequest._();

  factory ConfirmIdentityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmIdentityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmIdentityRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedVersion')
    ..aOM<IdentityEvidence>(3, _omitFieldNames ? '' : 'evidence',
        subBuilder: IdentityEvidence.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmIdentityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmIdentityRequest copyWith(
          void Function(ConfirmIdentityRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmIdentityRequest))
          as ConfirmIdentityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmIdentityRequest create() => ConfirmIdentityRequest._();
  @$core.override
  ConfirmIdentityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmIdentityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmIdentityRequest>(create);
  static ConfirmIdentityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedVersion() => $_clearField(2);

  /// What was checked. Confirmation is refused unless it includes a sighted,
  /// verified identifier (SRS-EMPI-010).
  @$pb.TagNumber(3)
  IdentityEvidence get evidence => $_getN(2);
  @$pb.TagNumber(3)
  set evidence(IdentityEvidence value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => $_clearField(3);
  @$pb.TagNumber(3)
  IdentityEvidence ensureEvidence() => $_ensure(2);
}

class ConfirmIdentityResponse extends $pb.GeneratedMessage {
  factory ConfirmIdentityResponse({
    Patient? patient,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    return result;
  }

  ConfirmIdentityResponse._();

  factory ConfirmIdentityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmIdentityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmIdentityResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmIdentityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmIdentityResponse copyWith(
          void Function(ConfirmIdentityResponse) updates) =>
      super.copyWith((message) => updates(message as ConfirmIdentityResponse))
          as ConfirmIdentityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmIdentityResponse create() => ConfirmIdentityResponse._();
  @$core.override
  ConfirmIdentityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmIdentityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmIdentityResponse>(create);
  static ConfirmIdentityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);
}

/// One pair awaiting or past review.
///
/// The queue exists because "thresholds route to manual review" needs somewhere
/// to route to. A clerk who acknowledges a probable duplicate and registers
/// anyway has made that call at a busy desk with a patient waiting; the pair
/// still goes to the people whose job it is.
class DuplicateCandidate extends $pb.GeneratedMessage {
  factory DuplicateCandidate({
    $core.String? candidateId,
    $core.String? patientAId,
    $core.String? patientBId,
    $core.double? score,
    MatchOutcome? outcome,
    ReviewStatus? status,
    $core.String? detectedBy,
    $0.Timestamp? detectedAt,
    $core.String? reviewedBy,
    $0.Timestamp? reviewedAt,
    $core.String? resolution,
  }) {
    final result = create();
    if (candidateId != null) result.candidateId = candidateId;
    if (patientAId != null) result.patientAId = patientAId;
    if (patientBId != null) result.patientBId = patientBId;
    if (score != null) result.score = score;
    if (outcome != null) result.outcome = outcome;
    if (status != null) result.status = status;
    if (detectedBy != null) result.detectedBy = detectedBy;
    if (detectedAt != null) result.detectedAt = detectedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (resolution != null) result.resolution = resolution;
    return result;
  }

  DuplicateCandidate._();

  factory DuplicateCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DuplicateCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuplicateCandidate',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'candidateId')
    ..aOS(2, _omitFieldNames ? '' : 'patientAId')
    ..aOS(3, _omitFieldNames ? '' : 'patientBId')
    ..aD(4, _omitFieldNames ? '' : 'score')
    ..aE<MatchOutcome>(5, _omitFieldNames ? '' : 'outcome',
        enumValues: MatchOutcome.values)
    ..aE<ReviewStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: ReviewStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'detectedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'detectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'reviewedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'resolution')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateCandidate copyWith(void Function(DuplicateCandidate) updates) =>
      super.copyWith((message) => updates(message as DuplicateCandidate))
          as DuplicateCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DuplicateCandidate create() => DuplicateCandidate._();
  @$core.override
  DuplicateCandidate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DuplicateCandidate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DuplicateCandidate>(create);
  static DuplicateCandidate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCandidateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientAId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientAId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientAId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientAId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientBId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientBId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientBId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientBId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get score => $_getN(3);
  @$pb.TagNumber(4)
  set score($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => $_clearField(4);

  @$pb.TagNumber(5)
  MatchOutcome get outcome => $_getN(4);
  @$pb.TagNumber(5)
  set outcome(MatchOutcome value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOutcome() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutcome() => $_clearField(5);

  @$pb.TagNumber(6)
  ReviewStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(ReviewStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  /// What surfaced the pair: a registration, a bulk scan, an operator. It
  /// matters when deciding how much to trust the score.
  @$pb.TagNumber(7)
  $core.String get detectedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set detectedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDetectedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearDetectedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get detectedAt => $_getN(7);
  @$pb.TagNumber(8)
  set detectedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDetectedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetectedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureDetectedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get reviewedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set reviewedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReviewedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearReviewedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get reviewedAt => $_getN(9);
  @$pb.TagNumber(10)
  set reviewedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReviewedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearReviewedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureReviewedAt() => $_ensure(9);

  /// Explains a dismissal, or names the merge that resolved it.
  @$pb.TagNumber(11)
  $core.String get resolution => $_getSZ(10);
  @$pb.TagNumber(11)
  set resolution($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasResolution() => $_has(10);
  @$pb.TagNumber(11)
  void clearResolution() => $_clearField(11);
}

class MergePatientsRequest extends $pb.GeneratedMessage {
  factory MergePatientsRequest({
    $core.String? survivorPatientId,
    $core.String? mergedPatientId,
    $core.String? reason,
    $core.String? candidateId,
  }) {
    final result = create();
    if (survivorPatientId != null) result.survivorPatientId = survivorPatientId;
    if (mergedPatientId != null) result.mergedPatientId = mergedPatientId;
    if (reason != null) result.reason = reason;
    if (candidateId != null) result.candidateId = candidateId;
    return result;
  }

  MergePatientsRequest._();

  factory MergePatientsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MergePatientsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MergePatientsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'survivorPatientId')
    ..aOS(2, _omitFieldNames ? '' : 'mergedPatientId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'candidateId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MergePatientsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MergePatientsRequest copyWith(void Function(MergePatientsRequest) updates) =>
      super.copyWith((message) => updates(message as MergePatientsRequest))
          as MergePatientsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MergePatientsRequest create() => MergePatientsRequest._();
  @$core.override
  MergePatientsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MergePatientsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MergePatientsRequest>(create);
  static MergePatientsRequest? _defaultInstance;

  /// The record that keeps its patient id and its MRN. Which one survives is
  /// the reviewer's decision — usually the one carrying the clinical history —
  /// and it is never inferred.
  @$pb.TagNumber(1)
  $core.String get survivorPatientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set survivorPatientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSurvivorPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurvivorPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mergedPatientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mergedPatientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMergedPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMergedPatientId() => $_clearField(2);

  /// Required. A merge with no reason cannot be reviewed afterwards, and that
  /// review is the only thing between a mistake and two people's records.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  /// Closes the review-queue entry this merge came from, when there is one.
  @$pb.TagNumber(4)
  $core.String get candidateId => $_getSZ(3);
  @$pb.TagNumber(4)
  set candidateId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCandidateId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCandidateId() => $_clearField(4);
}

class MergePatientsResponse extends $pb.GeneratedMessage {
  factory MergePatientsResponse({
    Patient? survivor,
    $core.String? mergedPatientId,
    $core.String? mergeId,
  }) {
    final result = create();
    if (survivor != null) result.survivor = survivor;
    if (mergedPatientId != null) result.mergedPatientId = mergedPatientId;
    if (mergeId != null) result.mergeId = mergeId;
    return result;
  }

  MergePatientsResponse._();

  factory MergePatientsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MergePatientsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MergePatientsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'survivor',
        subBuilder: Patient.create)
    ..aOS(2, _omitFieldNames ? '' : 'mergedPatientId')
    ..aOS(3, _omitFieldNames ? '' : 'mergeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MergePatientsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MergePatientsResponse copyWith(
          void Function(MergePatientsResponse) updates) =>
      super.copyWith((message) => updates(message as MergePatientsResponse))
          as MergePatientsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MergePatientsResponse create() => MergePatientsResponse._();
  @$core.override
  MergePatientsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MergePatientsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MergePatientsResponse>(create);
  static MergePatientsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get survivor => $_getN(0);
  @$pb.TagNumber(1)
  set survivor(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurvivor() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurvivor() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensureSurvivor() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get mergedPatientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mergedPatientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMergedPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMergedPatientId() => $_clearField(2);

  /// Names the journal entry an unmerge would reverse.
  @$pb.TagNumber(3)
  $core.String get mergeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set mergeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMergeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMergeId() => $_clearField(3);
}

class UnmergePatientsRequest extends $pb.GeneratedMessage {
  factory UnmergePatientsRequest({
    $core.String? mergeId,
    $core.String? reason,
  }) {
    final result = create();
    if (mergeId != null) result.mergeId = mergeId;
    if (reason != null) result.reason = reason;
    return result;
  }

  UnmergePatientsRequest._();

  factory UnmergePatientsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnmergePatientsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnmergePatientsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mergeId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnmergePatientsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnmergePatientsRequest copyWith(
          void Function(UnmergePatientsRequest) updates) =>
      super.copyWith((message) => updates(message as UnmergePatientsRequest))
          as UnmergePatientsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnmergePatientsRequest create() => UnmergePatientsRequest._();
  @$core.override
  UnmergePatientsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnmergePatientsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnmergePatientsRequest>(create);
  static UnmergePatientsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mergeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mergeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMergeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMergeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class UnmergePatientsResponse extends $pb.GeneratedMessage {
  factory UnmergePatientsResponse({
    Patient? survivor,
    Patient? restored,
  }) {
    final result = create();
    if (survivor != null) result.survivor = survivor;
    if (restored != null) result.restored = restored;
    return result;
  }

  UnmergePatientsResponse._();

  factory UnmergePatientsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnmergePatientsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnmergePatientsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'survivor',
        subBuilder: Patient.create)
    ..aOM<Patient>(2, _omitFieldNames ? '' : 'restored',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnmergePatientsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnmergePatientsResponse copyWith(
          void Function(UnmergePatientsResponse) updates) =>
      super.copyWith((message) => updates(message as UnmergePatientsResponse))
          as UnmergePatientsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnmergePatientsResponse create() => UnmergePatientsResponse._();
  @$core.override
  UnmergePatientsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnmergePatientsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnmergePatientsResponse>(create);
  static UnmergePatientsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get survivor => $_getN(0);
  @$pb.TagNumber(1)
  set survivor(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSurvivor() => $_has(0);
  @$pb.TagNumber(1)
  void clearSurvivor() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensureSurvivor() => $_ensure(0);

  @$pb.TagNumber(2)
  Patient get restored => $_getN(1);
  @$pb.TagNumber(2)
  set restored(Patient value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRestored() => $_has(1);
  @$pb.TagNumber(2)
  void clearRestored() => $_clearField(2);
  @$pb.TagNumber(2)
  Patient ensureRestored() => $_ensure(1);
}

class ListDuplicateCandidatesRequest extends $pb.GeneratedMessage {
  factory ListDuplicateCandidatesRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDuplicateCandidatesRequest._();

  factory ListDuplicateCandidatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDuplicateCandidatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDuplicateCandidatesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateCandidatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateCandidatesRequest copyWith(
          void Function(ListDuplicateCandidatesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListDuplicateCandidatesRequest))
          as ListDuplicateCandidatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDuplicateCandidatesRequest create() =>
      ListDuplicateCandidatesRequest._();
  @$core.override
  ListDuplicateCandidatesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDuplicateCandidatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDuplicateCandidatesRequest>(create);
  static ListDuplicateCandidatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListDuplicateCandidatesResponse extends $pb.GeneratedMessage {
  factory ListDuplicateCandidatesResponse({
    $core.Iterable<DuplicateCandidate>? candidates,
  }) {
    final result = create();
    if (candidates != null) result.candidates.addAll(candidates);
    return result;
  }

  ListDuplicateCandidatesResponse._();

  factory ListDuplicateCandidatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDuplicateCandidatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDuplicateCandidatesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pPM<DuplicateCandidate>(1, _omitFieldNames ? '' : 'candidates',
        subBuilder: DuplicateCandidate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateCandidatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDuplicateCandidatesResponse copyWith(
          void Function(ListDuplicateCandidatesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDuplicateCandidatesResponse))
          as ListDuplicateCandidatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDuplicateCandidatesResponse create() =>
      ListDuplicateCandidatesResponse._();
  @$core.override
  ListDuplicateCandidatesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDuplicateCandidatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDuplicateCandidatesResponse>(
          create);
  static ListDuplicateCandidatesResponse? _defaultInstance;

  /// Strongest first: the pair most likely to be one person, and the one whose
  /// being wrong costs the most.
  @$pb.TagNumber(1)
  $pb.PbList<DuplicateCandidate> get candidates => $_getList(0);
}

class DismissDuplicateCandidateRequest extends $pb.GeneratedMessage {
  factory DismissDuplicateCandidateRequest({
    $core.String? candidateId,
    $core.String? reason,
  }) {
    final result = create();
    if (candidateId != null) result.candidateId = candidateId;
    if (reason != null) result.reason = reason;
    return result;
  }

  DismissDuplicateCandidateRequest._();

  factory DismissDuplicateCandidateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DismissDuplicateCandidateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissDuplicateCandidateRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'candidateId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissDuplicateCandidateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissDuplicateCandidateRequest copyWith(
          void Function(DismissDuplicateCandidateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DismissDuplicateCandidateRequest))
          as DismissDuplicateCandidateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DismissDuplicateCandidateRequest create() =>
      DismissDuplicateCandidateRequest._();
  @$core.override
  DismissDuplicateCandidateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DismissDuplicateCandidateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DismissDuplicateCandidateRequest>(
          create);
  static DismissDuplicateCandidateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCandidateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidateId() => $_clearField(1);

  /// Required. A dismissal with no reason is indistinguishable from a mis-click,
  /// and the pair never returns to the queue to be reconsidered.
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class DismissDuplicateCandidateResponse extends $pb.GeneratedMessage {
  factory DismissDuplicateCandidateResponse() => create();

  DismissDuplicateCandidateResponse._();

  factory DismissDuplicateCandidateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DismissDuplicateCandidateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DismissDuplicateCandidateResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissDuplicateCandidateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DismissDuplicateCandidateResponse copyWith(
          void Function(DismissDuplicateCandidateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as DismissDuplicateCandidateResponse))
          as DismissDuplicateCandidateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DismissDuplicateCandidateResponse create() =>
      DismissDuplicateCandidateResponse._();
  @$core.override
  DismissDuplicateCandidateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DismissDuplicateCandidateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DismissDuplicateCandidateResponse>(
          create);
  static DismissDuplicateCandidateResponse? _defaultInstance;
}

/// A half-open interval [from, until). Until unset means open-ended.
///
/// Half-open because closed intervals make the changeover day ambiguous, and
/// somebody always ends up in both.
class EffectiveWindow extends $pb.GeneratedMessage {
  factory EffectiveWindow({
    $0.Timestamp? from,
    $0.Timestamp? until,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (until != null) result.until = until;
    return result;
  }

  EffectiveWindow._();

  factory EffectiveWindow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EffectiveWindow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EffectiveWindow',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'until',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EffectiveWindow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EffectiveWindow copyWith(void Function(EffectiveWindow) updates) =>
      super.copyWith((message) => updates(message as EffectiveWindow))
          as EffectiveWindow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EffectiveWindow create() => EffectiveWindow._();
  @$core.override
  EffectiveWindow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EffectiveWindow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EffectiveWindow>(create);
  static EffectiveWindow? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureFrom() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get until => $_getN(1);
  @$pb.TagNumber(2)
  set until($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUntil() => $_has(1);
  @$pb.TagNumber(2)
  void clearUntil() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureUntil() => $_ensure(1);
}

/// One name, effective-dated.
///
/// Names are never overwritten. A patient marries, the surname changes, and six
/// months later a result addressed to the maiden name arrives — a clerk who
/// cannot find that name creates a second record, which is the failure this
/// history prevents.
class PatientName extends $pb.GeneratedMessage {
  factory PatientName({
    $core.String? nameId,
    NameKind? kind,
    HumanName? name,
    EffectiveWindow? window,
    $core.String? recordedBy,
    $0.Timestamp? recordedAt,
    $core.String? source,
  }) {
    final result = create();
    if (nameId != null) result.nameId = nameId;
    if (kind != null) result.kind = kind;
    if (name != null) result.name = name;
    if (window != null) result.window = window;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (source != null) result.source = source;
    return result;
  }

  PatientName._();

  factory PatientName.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PatientName.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PatientName',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nameId')
    ..aE<NameKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: NameKind.values)
    ..aOM<HumanName>(3, _omitFieldNames ? '' : 'name',
        subBuilder: HumanName.create)
    ..aOM<EffectiveWindow>(4, _omitFieldNames ? '' : 'window',
        subBuilder: EffectiveWindow.create)
    ..aOS(5, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientName clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientName copyWith(void Function(PatientName) updates) =>
      super.copyWith((message) => updates(message as PatientName))
          as PatientName;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientName create() => PatientName._();
  @$core.override
  PatientName createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PatientName getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PatientName>(create);
  static PatientName? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nameId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nameId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNameId() => $_clearField(1);

  @$pb.TagNumber(2)
  NameKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(NameKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  HumanName get name => $_getN(2);
  @$pb.TagNumber(3)
  set name(HumanName value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
  @$pb.TagNumber(3)
  HumanName ensureName() => $_ensure(2);

  @$pb.TagNumber(4)
  EffectiveWindow get window => $_getN(3);
  @$pb.TagNumber(4)
  set window(EffectiveWindow value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWindow() => $_has(3);
  @$pb.TagNumber(4)
  void clearWindow() => $_clearField(4);
  @$pb.TagNumber(4)
  EffectiveWindow ensureWindow() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get recordedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set recordedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecordedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecordedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get recordedAt => $_getN(5);
  @$pb.TagNumber(6)
  set recordedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecordedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecordedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureRecordedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get source => $_getSZ(6);
  @$pb.TagNumber(7)
  set source($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);
}

class CommunicationPreference extends $pb.GeneratedMessage {
  factory CommunicationPreference({
    $core.String? preferenceId,
    CommunicationChannel? channel,
    CommunicationPurpose? purpose,
    $core.bool? allowed,
    EffectiveWindow? window,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (preferenceId != null) result.preferenceId = preferenceId;
    if (channel != null) result.channel = channel;
    if (purpose != null) result.purpose = purpose;
    if (allowed != null) result.allowed = allowed;
    if (window != null) result.window = window;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  CommunicationPreference._();

  factory CommunicationPreference.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommunicationPreference.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommunicationPreference',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'preferenceId')
    ..aE<CommunicationChannel>(2, _omitFieldNames ? '' : 'channel',
        enumValues: CommunicationChannel.values)
    ..aE<CommunicationPurpose>(3, _omitFieldNames ? '' : 'purpose',
        enumValues: CommunicationPurpose.values)
    ..aOB(4, _omitFieldNames ? '' : 'allowed')
    ..aOM<EffectiveWindow>(5, _omitFieldNames ? '' : 'window',
        subBuilder: EffectiveWindow.create)
    ..aOS(6, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunicationPreference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommunicationPreference copyWith(
          void Function(CommunicationPreference) updates) =>
      super.copyWith((message) => updates(message as CommunicationPreference))
          as CommunicationPreference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommunicationPreference create() => CommunicationPreference._();
  @$core.override
  CommunicationPreference createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommunicationPreference getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommunicationPreference>(create);
  static CommunicationPreference? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get preferenceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set preferenceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreferenceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreferenceId() => $_clearField(1);

  @$pb.TagNumber(2)
  CommunicationChannel get channel => $_getN(1);
  @$pb.TagNumber(2)
  set channel(CommunicationChannel value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => $_clearField(2);

  @$pb.TagNumber(3)
  CommunicationPurpose get purpose => $_getN(2);
  @$pb.TagNumber(3)
  set purpose(CommunicationPurpose value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPurpose() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurpose() => $_clearField(3);

  /// false is a recorded refusal, which is not the same as an absent row: one
  /// says the patient declined, the other says nobody asked.
  @$pb.TagNumber(4)
  $core.bool get allowed => $_getBF(3);
  @$pb.TagNumber(4)
  set allowed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAllowed() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllowed() => $_clearField(4);

  @$pb.TagNumber(5)
  EffectiveWindow get window => $_getN(4);
  @$pb.TagNumber(5)
  set window(EffectiveWindow value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasWindow() => $_has(4);
  @$pb.TagNumber(5)
  void clearWindow() => $_clearField(5);
  @$pb.TagNumber(5)
  EffectiveWindow ensureWindow() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get recordedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set recordedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecordedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecordedBy() => $_clearField(6);
}

class RelatedPerson extends $pb.GeneratedMessage {
  factory RelatedPerson({
    $core.String? relationshipId,
    $core.String? relatedPatientId,
    HumanName? name,
    $core.Iterable<ContactPoint>? contact,
    RelationshipType? relationship,
    $core.Iterable<Authority>? authorities,
    EffectiveWindow? window,
    $core.String? verifiedBy,
    $0.Timestamp? verifiedAt,
    $core.String? verificationNote,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (relationshipId != null) result.relationshipId = relationshipId;
    if (relatedPatientId != null) result.relatedPatientId = relatedPatientId;
    if (name != null) result.name = name;
    if (contact != null) result.contact.addAll(contact);
    if (relationship != null) result.relationship = relationship;
    if (authorities != null) result.authorities.addAll(authorities);
    if (window != null) result.window = window;
    if (verifiedBy != null) result.verifiedBy = verifiedBy;
    if (verifiedAt != null) result.verifiedAt = verifiedAt;
    if (verificationNote != null) result.verificationNote = verificationNote;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  RelatedPerson._();

  factory RelatedPerson.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RelatedPerson.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelatedPerson',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'relationshipId')
    ..aOS(2, _omitFieldNames ? '' : 'relatedPatientId')
    ..aOM<HumanName>(3, _omitFieldNames ? '' : 'name',
        subBuilder: HumanName.create)
    ..pPM<ContactPoint>(4, _omitFieldNames ? '' : 'contact',
        subBuilder: ContactPoint.create)
    ..aE<RelationshipType>(5, _omitFieldNames ? '' : 'relationship',
        enumValues: RelationshipType.values)
    ..pc<Authority>(6, _omitFieldNames ? '' : 'authorities', $pb.PbFieldType.KE,
        valueOf: Authority.valueOf,
        enumValues: Authority.values,
        defaultEnumValue: Authority.AUTHORITY_UNSPECIFIED)
    ..aOM<EffectiveWindow>(7, _omitFieldNames ? '' : 'window',
        subBuilder: EffectiveWindow.create)
    ..aOS(8, _omitFieldNames ? '' : 'verifiedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'verifiedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'verificationNote')
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedPerson clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedPerson copyWith(void Function(RelatedPerson) updates) =>
      super.copyWith((message) => updates(message as RelatedPerson))
          as RelatedPerson;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RelatedPerson create() => RelatedPerson._();
  @$core.override
  RelatedPerson createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RelatedPerson getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelatedPerson>(create);
  static RelatedPerson? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get relationshipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set relationshipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRelationshipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelationshipId() => $_clearField(1);

  /// Set when the related person is themselves a patient here, which a parent
  /// usually is.
  @$pb.TagNumber(2)
  $core.String get relatedPatientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set relatedPatientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRelatedPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRelatedPatientId() => $_clearField(2);

  /// Used when they are not — a care-home key worker will never have a record.
  @$pb.TagNumber(3)
  HumanName get name => $_getN(2);
  @$pb.TagNumber(3)
  set name(HumanName value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
  @$pb.TagNumber(3)
  HumanName ensureName() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<ContactPoint> get contact => $_getList(3);

  @$pb.TagNumber(5)
  RelationshipType get relationship => $_getN(4);
  @$pb.TagNumber(5)
  set relationship(RelationshipType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRelationship() => $_has(4);
  @$pb.TagNumber(5)
  void clearRelationship() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Authority> get authorities => $_getList(5);

  @$pb.TagNumber(7)
  EffectiveWindow get window => $_getN(6);
  @$pb.TagNumber(7)
  set window(EffectiveWindow value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWindow() => $_has(6);
  @$pb.TagNumber(7)
  void clearWindow() => $_clearField(7);
  @$pb.TagNumber(7)
  EffectiveWindow ensureWindow() => $_ensure(6);

  /// An unverified relationship carries no authority. "I am her son" is a
  /// sentence anybody can say at a reception desk.
  @$pb.TagNumber(8)
  $core.String get verifiedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set verifiedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVerifiedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearVerifiedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get verifiedAt => $_getN(8);
  @$pb.TagNumber(9)
  set verifiedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasVerifiedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearVerifiedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureVerifiedAt() => $_ensure(8);

  /// What was actually checked — a birth certificate, a court order — rather
  /// than merely that something was.
  @$pb.TagNumber(10)
  $core.String get verificationNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set verificationNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVerificationNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearVerificationNote() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get recordedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set recordedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedBy() => $_clearField(11);
}

class RecordNameRequest extends $pb.GeneratedMessage {
  factory RecordNameRequest({
    $core.String? patientId,
    NameKind? kind,
    HumanName? name,
    $0.Timestamp? effectiveFrom,
    $core.String? source,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (name != null) result.name = name;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (source != null) result.source = source;
    return result;
  }

  RecordNameRequest._();

  factory RecordNameRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordNameRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordNameRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<NameKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: NameKind.values)
    ..aOM<HumanName>(3, _omitFieldNames ? '' : 'name',
        subBuilder: HumanName.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordNameRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordNameRequest copyWith(void Function(RecordNameRequest) updates) =>
      super.copyWith((message) => updates(message as RecordNameRequest))
          as RecordNameRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordNameRequest create() => RecordNameRequest._();
  @$core.override
  RecordNameRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordNameRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordNameRequest>(create);
  static RecordNameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  NameKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(NameKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  HumanName get name => $_getN(2);
  @$pb.TagNumber(3)
  set name(HumanName value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
  @$pb.TagNumber(3)
  HumanName ensureName() => $_ensure(2);

  /// When the name started applying — a marriage date, a deed poll — not when
  /// somebody got round to typing it. Unset means now.
  @$pb.TagNumber(4)
  $0.Timestamp get effectiveFrom => $_getN(3);
  @$pb.TagNumber(4)
  set effectiveFrom($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEffectiveFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearEffectiveFrom() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);
}

class RecordNameResponse extends $pb.GeneratedMessage {
  factory RecordNameResponse() => create();

  RecordNameResponse._();

  factory RecordNameResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordNameResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordNameResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordNameResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordNameResponse copyWith(void Function(RecordNameResponse) updates) =>
      super.copyWith((message) => updates(message as RecordNameResponse))
          as RecordNameResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordNameResponse create() => RecordNameResponse._();
  @$core.override
  RecordNameResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordNameResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordNameResponse>(create);
  static RecordNameResponse? _defaultInstance;
}

class GetPatientHistoryRequest extends $pb.GeneratedMessage {
  factory GetPatientHistoryRequest({
    $core.String? patientId,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    return result;
  }

  GetPatientHistoryRequest._();

  factory GetPatientHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPatientHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPatientHistoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientHistoryRequest copyWith(
          void Function(GetPatientHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetPatientHistoryRequest))
          as GetPatientHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPatientHistoryRequest create() => GetPatientHistoryRequest._();
  @$core.override
  GetPatientHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPatientHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPatientHistoryRequest>(create);
  static GetPatientHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);
}

class GetPatientHistoryResponse extends $pb.GeneratedMessage {
  factory GetPatientHistoryResponse({
    $core.Iterable<PatientName>? names,
    $core.Iterable<CommunicationPreference>? preferences,
    $core.Iterable<RelatedPerson>? related,
  }) {
    final result = create();
    if (names != null) result.names.addAll(names);
    if (preferences != null) result.preferences.addAll(preferences);
    if (related != null) result.related.addAll(related);
    return result;
  }

  GetPatientHistoryResponse._();

  factory GetPatientHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPatientHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPatientHistoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pPM<PatientName>(1, _omitFieldNames ? '' : 'names',
        subBuilder: PatientName.create)
    ..pPM<CommunicationPreference>(2, _omitFieldNames ? '' : 'preferences',
        subBuilder: CommunicationPreference.create)
    ..pPM<RelatedPerson>(3, _omitFieldNames ? '' : 'related',
        subBuilder: RelatedPerson.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPatientHistoryResponse copyWith(
          void Function(GetPatientHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as GetPatientHistoryResponse))
          as GetPatientHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPatientHistoryResponse create() => GetPatientHistoryResponse._();
  @$core.override
  GetPatientHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPatientHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPatientHistoryResponse>(create);
  static GetPatientHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PatientName> get names => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<CommunicationPreference> get preferences => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<RelatedPerson> get related => $_getList(2);
}

class RecordCommunicationPreferenceRequest extends $pb.GeneratedMessage {
  factory RecordCommunicationPreferenceRequest({
    $core.String? patientId,
    CommunicationChannel? channel,
    CommunicationPurpose? purpose,
    $core.bool? allowed,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (channel != null) result.channel = channel;
    if (purpose != null) result.purpose = purpose;
    if (allowed != null) result.allowed = allowed;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  RecordCommunicationPreferenceRequest._();

  factory RecordCommunicationPreferenceRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCommunicationPreferenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCommunicationPreferenceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<CommunicationChannel>(2, _omitFieldNames ? '' : 'channel',
        enumValues: CommunicationChannel.values)
    ..aE<CommunicationPurpose>(3, _omitFieldNames ? '' : 'purpose',
        enumValues: CommunicationPurpose.values)
    ..aOB(4, _omitFieldNames ? '' : 'allowed')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCommunicationPreferenceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCommunicationPreferenceRequest copyWith(
          void Function(RecordCommunicationPreferenceRequest) updates) =>
      super.copyWith((message) =>
              updates(message as RecordCommunicationPreferenceRequest))
          as RecordCommunicationPreferenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCommunicationPreferenceRequest create() =>
      RecordCommunicationPreferenceRequest._();
  @$core.override
  RecordCommunicationPreferenceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCommunicationPreferenceRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          RecordCommunicationPreferenceRequest>(create);
  static RecordCommunicationPreferenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  CommunicationChannel get channel => $_getN(1);
  @$pb.TagNumber(2)
  set channel(CommunicationChannel value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => $_clearField(2);

  @$pb.TagNumber(3)
  CommunicationPurpose get purpose => $_getN(2);
  @$pb.TagNumber(3)
  set purpose(CommunicationPurpose value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPurpose() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurpose() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get allowed => $_getBF(3);
  @$pb.TagNumber(4)
  set allowed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAllowed() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllowed() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get effectiveFrom => $_getN(4);
  @$pb.TagNumber(5)
  set effectiveFrom($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEffectiveFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearEffectiveFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(4);
}

class RecordCommunicationPreferenceResponse extends $pb.GeneratedMessage {
  factory RecordCommunicationPreferenceResponse() => create();

  RecordCommunicationPreferenceResponse._();

  factory RecordCommunicationPreferenceResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCommunicationPreferenceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCommunicationPreferenceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCommunicationPreferenceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCommunicationPreferenceResponse copyWith(
          void Function(RecordCommunicationPreferenceResponse) updates) =>
      super.copyWith((message) =>
              updates(message as RecordCommunicationPreferenceResponse))
          as RecordCommunicationPreferenceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCommunicationPreferenceResponse create() =>
      RecordCommunicationPreferenceResponse._();
  @$core.override
  RecordCommunicationPreferenceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCommunicationPreferenceResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          RecordCommunicationPreferenceResponse>(create);
  static RecordCommunicationPreferenceResponse? _defaultInstance;
}

class RecordDeceasedRequest extends $pb.GeneratedMessage {
  factory RecordDeceasedRequest({
    $core.String? patientId,
    PartialDate? date,
    $core.String? source,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (date != null) result.date = date;
    if (source != null) result.source = source;
    return result;
  }

  RecordDeceasedRequest._();

  factory RecordDeceasedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeceasedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeceasedRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOM<PartialDate>(2, _omitFieldNames ? '' : 'date',
        subBuilder: PartialDate.create)
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeceasedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeceasedRequest copyWith(
          void Function(RecordDeceasedRequest) updates) =>
      super.copyWith((message) => updates(message as RecordDeceasedRequest))
          as RecordDeceasedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeceasedRequest create() => RecordDeceasedRequest._();
  @$core.override
  RecordDeceasedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeceasedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeceasedRequest>(create);
  static RecordDeceasedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  PartialDate get date => $_getN(1);
  @$pb.TagNumber(2)
  set date(PartialDate value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);
  @$pb.TagNumber(2)
  PartialDate ensureDate() => $_ensure(1);

  /// Required: a registrar, a clinician, a national death registry feed. A feed
  /// can be wrong about the wrong patient, and reversing it needs to know what
  /// claimed it.
  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);
}

class RecordDeceasedResponse extends $pb.GeneratedMessage {
  factory RecordDeceasedResponse({
    Patient? patient,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    return result;
  }

  RecordDeceasedResponse._();

  factory RecordDeceasedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeceasedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeceasedResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeceasedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeceasedResponse copyWith(
          void Function(RecordDeceasedResponse) updates) =>
      super.copyWith((message) => updates(message as RecordDeceasedResponse))
          as RecordDeceasedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeceasedResponse create() => RecordDeceasedResponse._();
  @$core.override
  RecordDeceasedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeceasedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeceasedResponse>(create);
  static RecordDeceasedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);
}

class ReverseDeceasedRequest extends $pb.GeneratedMessage {
  factory ReverseDeceasedRequest({
    $core.String? patientId,
    $core.String? reason,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReverseDeceasedRequest._();

  factory ReverseDeceasedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReverseDeceasedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReverseDeceasedRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReverseDeceasedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReverseDeceasedRequest copyWith(
          void Function(ReverseDeceasedRequest) updates) =>
      super.copyWith((message) => updates(message as ReverseDeceasedRequest))
          as ReverseDeceasedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReverseDeceasedRequest create() => ReverseDeceasedRequest._();
  @$core.override
  ReverseDeceasedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReverseDeceasedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReverseDeceasedRequest>(create);
  static ReverseDeceasedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class ReverseDeceasedResponse extends $pb.GeneratedMessage {
  factory ReverseDeceasedResponse({
    Patient? patient,
  }) {
    final result = create();
    if (patient != null) result.patient = patient;
    return result;
  }

  ReverseDeceasedResponse._();

  factory ReverseDeceasedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReverseDeceasedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReverseDeceasedResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<Patient>(1, _omitFieldNames ? '' : 'patient',
        subBuilder: Patient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReverseDeceasedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReverseDeceasedResponse copyWith(
          void Function(ReverseDeceasedResponse) updates) =>
      super.copyWith((message) => updates(message as ReverseDeceasedResponse))
          as ReverseDeceasedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReverseDeceasedResponse create() => ReverseDeceasedResponse._();
  @$core.override
  ReverseDeceasedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReverseDeceasedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReverseDeceasedResponse>(create);
  static ReverseDeceasedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Patient get patient => $_getN(0);
  @$pb.TagNumber(1)
  set patient(Patient value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPatient() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatient() => $_clearField(1);
  @$pb.TagNumber(1)
  Patient ensurePatient() => $_ensure(0);
}

class AddRelatedPersonRequest extends $pb.GeneratedMessage {
  factory AddRelatedPersonRequest({
    $core.String? patientId,
    $core.String? relatedPatientId,
    HumanName? name,
    $core.Iterable<ContactPoint>? contact,
    RelationshipType? relationship,
    $core.Iterable<Authority>? authorities,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveUntil,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (relatedPatientId != null) result.relatedPatientId = relatedPatientId;
    if (name != null) result.name = name;
    if (contact != null) result.contact.addAll(contact);
    if (relationship != null) result.relationship = relationship;
    if (authorities != null) result.authorities.addAll(authorities);
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveUntil != null) result.effectiveUntil = effectiveUntil;
    return result;
  }

  AddRelatedPersonRequest._();

  factory AddRelatedPersonRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddRelatedPersonRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddRelatedPersonRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'relatedPatientId')
    ..aOM<HumanName>(3, _omitFieldNames ? '' : 'name',
        subBuilder: HumanName.create)
    ..pPM<ContactPoint>(4, _omitFieldNames ? '' : 'contact',
        subBuilder: ContactPoint.create)
    ..aE<RelationshipType>(5, _omitFieldNames ? '' : 'relationship',
        enumValues: RelationshipType.values)
    ..pc<Authority>(6, _omitFieldNames ? '' : 'authorities', $pb.PbFieldType.KE,
        valueOf: Authority.valueOf,
        enumValues: Authority.values,
        defaultEnumValue: Authority.AUTHORITY_UNSPECIFIED)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectiveUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRelatedPersonRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRelatedPersonRequest copyWith(
          void Function(AddRelatedPersonRequest) updates) =>
      super.copyWith((message) => updates(message as AddRelatedPersonRequest))
          as AddRelatedPersonRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddRelatedPersonRequest create() => AddRelatedPersonRequest._();
  @$core.override
  AddRelatedPersonRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddRelatedPersonRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddRelatedPersonRequest>(create);
  static AddRelatedPersonRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get relatedPatientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set relatedPatientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRelatedPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRelatedPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  HumanName get name => $_getN(2);
  @$pb.TagNumber(3)
  set name(HumanName value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
  @$pb.TagNumber(3)
  HumanName ensureName() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<ContactPoint> get contact => $_getList(3);

  @$pb.TagNumber(5)
  RelationshipType get relationship => $_getN(4);
  @$pb.TagNumber(5)
  set relationship(RelationshipType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRelationship() => $_has(4);
  @$pb.TagNumber(5)
  void clearRelationship() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Authority> get authorities => $_getList(5);

  @$pb.TagNumber(7)
  $0.Timestamp get effectiveFrom => $_getN(6);
  @$pb.TagNumber(7)
  set effectiveFrom($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEffectiveFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearEffectiveFrom() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(6);

  /// When the authority ends. A guardian's ends on a date everybody can
  /// predict, and a relationship with no end is a standing grant nobody
  /// revisits.
  @$pb.TagNumber(8)
  $0.Timestamp get effectiveUntil => $_getN(7);
  @$pb.TagNumber(8)
  set effectiveUntil($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEffectiveUntil() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectiveUntil() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureEffectiveUntil() => $_ensure(7);
}

class AddRelatedPersonResponse extends $pb.GeneratedMessage {
  factory AddRelatedPersonResponse({
    RelatedPerson? related,
  }) {
    final result = create();
    if (related != null) result.related = related;
    return result;
  }

  AddRelatedPersonResponse._();

  factory AddRelatedPersonResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddRelatedPersonResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddRelatedPersonResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOM<RelatedPerson>(1, _omitFieldNames ? '' : 'related',
        subBuilder: RelatedPerson.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRelatedPersonResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddRelatedPersonResponse copyWith(
          void Function(AddRelatedPersonResponse) updates) =>
      super.copyWith((message) => updates(message as AddRelatedPersonResponse))
          as AddRelatedPersonResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddRelatedPersonResponse create() => AddRelatedPersonResponse._();
  @$core.override
  AddRelatedPersonResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddRelatedPersonResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddRelatedPersonResponse>(create);
  static AddRelatedPersonResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RelatedPerson get related => $_getN(0);
  @$pb.TagNumber(1)
  set related(RelatedPerson value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelated() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelated() => $_clearField(1);
  @$pb.TagNumber(1)
  RelatedPerson ensureRelated() => $_ensure(0);
}

class VerifyRelatedPersonRequest extends $pb.GeneratedMessage {
  factory VerifyRelatedPersonRequest({
    $core.String? relationshipId,
    $core.String? note,
  }) {
    final result = create();
    if (relationshipId != null) result.relationshipId = relationshipId;
    if (note != null) result.note = note;
    return result;
  }

  VerifyRelatedPersonRequest._();

  factory VerifyRelatedPersonRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyRelatedPersonRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyRelatedPersonRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'relationshipId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyRelatedPersonRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyRelatedPersonRequest copyWith(
          void Function(VerifyRelatedPersonRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyRelatedPersonRequest))
          as VerifyRelatedPersonRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyRelatedPersonRequest create() => VerifyRelatedPersonRequest._();
  @$core.override
  VerifyRelatedPersonRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyRelatedPersonRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyRelatedPersonRequest>(create);
  static VerifyRelatedPersonRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get relationshipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set relationshipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRelationshipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelationshipId() => $_clearField(1);

  /// Required, and it must say what was checked.
  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class VerifyRelatedPersonResponse extends $pb.GeneratedMessage {
  factory VerifyRelatedPersonResponse() => create();

  VerifyRelatedPersonResponse._();

  factory VerifyRelatedPersonResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyRelatedPersonResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyRelatedPersonResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyRelatedPersonResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyRelatedPersonResponse copyWith(
          void Function(VerifyRelatedPersonResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyRelatedPersonResponse))
          as VerifyRelatedPersonResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyRelatedPersonResponse create() =>
      VerifyRelatedPersonResponse._();
  @$core.override
  VerifyRelatedPersonResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyRelatedPersonResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyRelatedPersonResponse>(create);
  static VerifyRelatedPersonResponse? _defaultInstance;
}

class EndRelatedPersonRequest extends $pb.GeneratedMessage {
  factory EndRelatedPersonRequest({
    $core.String? relationshipId,
  }) {
    final result = create();
    if (relationshipId != null) result.relationshipId = relationshipId;
    return result;
  }

  EndRelatedPersonRequest._();

  factory EndRelatedPersonRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndRelatedPersonRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndRelatedPersonRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'relationshipId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndRelatedPersonRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndRelatedPersonRequest copyWith(
          void Function(EndRelatedPersonRequest) updates) =>
      super.copyWith((message) => updates(message as EndRelatedPersonRequest))
          as EndRelatedPersonRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndRelatedPersonRequest create() => EndRelatedPersonRequest._();
  @$core.override
  EndRelatedPersonRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndRelatedPersonRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndRelatedPersonRequest>(create);
  static EndRelatedPersonRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get relationshipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set relationshipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRelationshipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelationshipId() => $_clearField(1);
}

class EndRelatedPersonResponse extends $pb.GeneratedMessage {
  factory EndRelatedPersonResponse() => create();

  EndRelatedPersonResponse._();

  factory EndRelatedPersonResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndRelatedPersonResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndRelatedPersonResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndRelatedPersonResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndRelatedPersonResponse copyWith(
          void Function(EndRelatedPersonResponse) updates) =>
      super.copyWith((message) => updates(message as EndRelatedPersonResponse))
          as EndRelatedPersonResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndRelatedPersonResponse create() => EndRelatedPersonResponse._();
  @$core.override
  EndRelatedPersonResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndRelatedPersonResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndRelatedPersonResponse>(create);
  static EndRelatedPersonResponse? _defaultInstance;
}

class GetCaregiverAuthorityRequest extends $pb.GeneratedMessage {
  factory GetCaregiverAuthorityRequest({
    $core.String? holderPatientId,
    $core.String? subjectPatientId,
  }) {
    final result = create();
    if (holderPatientId != null) result.holderPatientId = holderPatientId;
    if (subjectPatientId != null) result.subjectPatientId = subjectPatientId;
    return result;
  }

  GetCaregiverAuthorityRequest._();

  factory GetCaregiverAuthorityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCaregiverAuthorityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCaregiverAuthorityRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'holderPatientId')
    ..aOS(2, _omitFieldNames ? '' : 'subjectPatientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaregiverAuthorityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaregiverAuthorityRequest copyWith(
          void Function(GetCaregiverAuthorityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCaregiverAuthorityRequest))
          as GetCaregiverAuthorityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCaregiverAuthorityRequest create() =>
      GetCaregiverAuthorityRequest._();
  @$core.override
  GetCaregiverAuthorityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCaregiverAuthorityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCaregiverAuthorityRequest>(create);
  static GetCaregiverAuthorityRequest? _defaultInstance;

  /// The person asking to act.
  @$pb.TagNumber(1)
  $core.String get holderPatientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set holderPatientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHolderPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHolderPatientId() => $_clearField(1);

  /// The patient they want to act for.
  @$pb.TagNumber(2)
  $core.String get subjectPatientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set subjectPatientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubjectPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubjectPatientId() => $_clearField(2);
}

class GetCaregiverAuthorityResponse extends $pb.GeneratedMessage {
  factory GetCaregiverAuthorityResponse({
    $core.Iterable<Authority>? authorities,
  }) {
    final result = create();
    if (authorities != null) result.authorities.addAll(authorities);
    return result;
  }

  GetCaregiverAuthorityResponse._();

  factory GetCaregiverAuthorityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCaregiverAuthorityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCaregiverAuthorityResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'healthcare.empi.v1'),
      createEmptyInstance: create)
    ..pc<Authority>(1, _omitFieldNames ? '' : 'authorities', $pb.PbFieldType.KE,
        valueOf: Authority.valueOf,
        enumValues: Authority.values,
        defaultEnumValue: Authority.AUTHORITY_UNSPECIFIED)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaregiverAuthorityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCaregiverAuthorityResponse copyWith(
          void Function(GetCaregiverAuthorityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetCaregiverAuthorityResponse))
          as GetCaregiverAuthorityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCaregiverAuthorityResponse create() =>
      GetCaregiverAuthorityResponse._();
  @$core.override
  GetCaregiverAuthorityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCaregiverAuthorityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCaregiverAuthorityResponse>(create);
  static GetCaregiverAuthorityResponse? _defaultInstance;

  /// What they may do right now: verified, in force, and in scope. Empty means
  /// nothing, which is also the answer for an unverified or expired
  /// relationship.
  @$pb.TagNumber(1)
  $pb.PbList<Authority> get authorities => $_getList(0);
}

/// Patient identity (SRS-EMPI).
class PatientServiceApi {
  final $pb.RpcClient _client;

  PatientServiceApi(this._client);

  /// SRS-EMPI-001. Issues the MRN from the registering facility's sequence.
  $async.Future<RegisterPatientResponse> registerPatient(
          $pb.ClientContext? ctx, RegisterPatientRequest request) =>
      _client.invoke<RegisterPatientResponse>(ctx, 'PatientService',
          'RegisterPatient', request, RegisterPatientResponse());

  /// SRS-EMPI-003. Search before create, exact and fuzzy, with confidence.
  $async.Future<SearchPatientsResponse> searchPatients(
          $pb.ClientContext? ctx, SearchPatientsRequest request) =>
      _client.invoke<SearchPatientsResponse>(ctx, 'PatientService',
          'SearchPatients', request, SearchPatientsResponse());
  $async.Future<GetPatientResponse> getPatient(
          $pb.ClientContext? ctx, GetPatientRequest request) =>
      _client.invoke<GetPatientResponse>(
          ctx, 'PatientService', 'GetPatient', request, GetPatientResponse());
  $async.Future<UpdateDemographicsResponse> updateDemographics(
          $pb.ClientContext? ctx, UpdateDemographicsRequest request) =>
      _client.invoke<UpdateDemographicsResponse>(ctx, 'PatientService',
          'UpdateDemographics', request, UpdateDemographicsResponse());

  /// Moves a candidate to active once a positive identifier has been seen.
  $async.Future<ConfirmIdentityResponse> confirmIdentity(
          $pb.ClientContext? ctx, ConfirmIdentityRequest request) =>
      _client.invoke<ConfirmIdentityResponse>(ctx, 'PatientService',
          'ConfirmIdentity', request, ConfirmIdentityResponse());

  /// SRS-EMPI-005. Merging is the most destructive operation here: a merge that
  /// should not have happened produces a chart that reads as coherent, and is
  /// found by a reaction rather than by a report. Restricted to authorised HIM.
  $async.Future<MergePatientsResponse> mergePatients(
          $pb.ClientContext? ctx, MergePatientsRequest request) =>
      _client.invoke<MergePatientsResponse>(ctx, 'PatientService',
          'MergePatients', request, MergePatientsResponse());

  /// SRS-EMPI-006. Reverses a merge, or refuses with the reason it cannot.
  $async.Future<UnmergePatientsResponse> unmergePatients(
          $pb.ClientContext? ctx, UnmergePatientsRequest request) =>
      _client.invoke<UnmergePatientsResponse>(ctx, 'PatientService',
          'UnmergePatients', request, UnmergePatientsResponse());

  /// SRS-EMPI-004. The manual-review worklist thresholds route to.
  $async.Future<ListDuplicateCandidatesResponse> listDuplicateCandidates(
          $pb.ClientContext? ctx, ListDuplicateCandidatesRequest request) =>
      _client.invoke<ListDuplicateCandidatesResponse>(
          ctx,
          'PatientService',
          'ListDuplicateCandidates',
          request,
          ListDuplicateCandidatesResponse());
  $async.Future<DismissDuplicateCandidateResponse> dismissDuplicateCandidate(
          $pb.ClientContext? ctx, DismissDuplicateCandidateRequest request) =>
      _client.invoke<DismissDuplicateCandidateResponse>(
          ctx,
          'PatientService',
          'DismissDuplicateCandidate',
          request,
          DismissDuplicateCandidateResponse());

  /// SRS-EMPI-015. An unconscious patient is registered immediately, with a
  /// designation instead of a name, and identified later. The internal
  /// identifier never changes, so everything written during the emergency still
  /// points at the same record — which is what "without losing encounter
  /// chronology" means in practice.
  $async.Future<RegisterUnidentifiedResponse> registerUnidentified(
          $pb.ClientContext? ctx, RegisterUnidentifiedRequest request) =>
      _client.invoke<RegisterUnidentifiedResponse>(ctx, 'PatientService',
          'RegisterUnidentified', request, RegisterUnidentifiedResponse());
  $async.Future<IdentifyPatientResponse> identifyPatient(
          $pb.ClientContext? ctx, IdentifyPatientRequest request) =>
      _client.invoke<IdentifyPatientResponse>(ctx, 'PatientService',
          'IdentifyPatient', request, IdentifyPatientResponse());
  $async.Future<ListUnidentifiedResponse> listUnidentified(
          $pb.ClientContext? ctx, ListUnidentifiedRequest request) =>
      _client.invoke<ListUnidentifiedResponse>(ctx, 'PatientService',
          'ListUnidentified', request, ListUnidentifiedResponse());

  /// SRS-EMPI-010. A photograph is held with the consent it was taken under and
  /// is never sufficient to establish identity on its own.
  $async.Future<CapturePhotoResponse> capturePhoto(
          $pb.ClientContext? ctx, CapturePhotoRequest request) =>
      _client.invoke<CapturePhotoResponse>(ctx, 'PatientService',
          'CapturePhoto', request, CapturePhotoResponse());
  $async.Future<GetPhotoResponse> getPhoto(
          $pb.ClientContext? ctx, GetPhotoRequest request) =>
      _client.invoke<GetPhotoResponse>(
          ctx, 'PatientService', 'GetPhoto', request, GetPhotoResponse());
  $async.Future<WithdrawPhotoConsentResponse> withdrawPhotoConsent(
          $pb.ClientContext? ctx, WithdrawPhotoConsentRequest request) =>
      _client.invoke<WithdrawPhotoConsentResponse>(ctx, 'PatientService',
          'WithdrawPhotoConsent', request, WithdrawPhotoConsentResponse());

  /// SRS-EMPI-014. Which demographic fields are restricted is a tenant
  /// decision, not a constant in this system.
  $async.Future<ConfigureFieldAccessResponse> configureFieldAccess(
          $pb.ClientContext? ctx, ConfigureFieldAccessRequest request) =>
      _client.invoke<ConfigureFieldAccessResponse>(ctx, 'PatientService',
          'ConfigureFieldAccess', request, ConfigureFieldAccessResponse());

  /// SRS-EMPI-011. External identifiers are linked and unlinked through an
  /// adapter; neither direction deletes a row, because link and unlink history
  /// is what makes a wrong link investigable.
  $async.Future<LinkIdentifierResponse> linkIdentifier(
          $pb.ClientContext? ctx, LinkIdentifierRequest request) =>
      _client.invoke<LinkIdentifierResponse>(ctx, 'PatientService',
          'LinkIdentifier', request, LinkIdentifierResponse());
  $async.Future<UnlinkIdentifierResponse> unlinkIdentifier(
          $pb.ClientContext? ctx, UnlinkIdentifierRequest request) =>
      _client.invoke<UnlinkIdentifierResponse>(ctx, 'PatientService',
          'UnlinkIdentifier', request, UnlinkIdentifierResponse());

  /// Confirms an identifier linked while the issuing authority was unreachable.
  $async.Future<VerifyIdentifierResponse> verifyIdentifier(
          $pb.ClientContext? ctx, VerifyIdentifierRequest request) =>
      _client.invoke<VerifyIdentifierResponse>(ctx, 'PatientService',
          'VerifyIdentifier', request, VerifyIdentifierResponse());

  /// SRS-EMPI-012. An external source that disagrees with the record raises a
  /// proposal; it never writes. A feed that can overwrite demographics will
  /// eventually overwrite the right value with the wrong one, and nothing will
  /// record what was lost.
  $async.Future<SubmitExternalDemographicsResponse> submitExternalDemographics(
          $pb.ClientContext? ctx, SubmitExternalDemographicsRequest request) =>
      _client.invoke<SubmitExternalDemographicsResponse>(
          ctx,
          'PatientService',
          'SubmitExternalDemographics',
          request,
          SubmitExternalDemographicsResponse());

  /// SRS-EMPI-017. A person asks for a correction; a reviewer decides. Raising
  /// needs only read access, because the person asking is often the patient.
  $async.Future<RequestCorrectionResponse> requestCorrection(
          $pb.ClientContext? ctx, RequestCorrectionRequest request) =>
      _client.invoke<RequestCorrectionResponse>(ctx, 'PatientService',
          'RequestCorrection', request, RequestCorrectionResponse());
  $async.Future<ListDemographicProposalsResponse> listDemographicProposals(
          $pb.ClientContext? ctx, ListDemographicProposalsRequest request) =>
      _client.invoke<ListDemographicProposalsResponse>(
          ctx,
          'PatientService',
          'ListDemographicProposals',
          request,
          ListDemographicProposalsResponse());

  /// Applying or refusing is where the authority lives: deciding a proposal
  /// needs the permission to change demographics, because that is what it does.
  $async.Future<ResolveDemographicProposalResponse> resolveDemographicProposal(
          $pb.ClientContext? ctx, ResolveDemographicProposalRequest request) =>
      _client.invoke<ResolveDemographicProposalResponse>(
          ctx,
          'PatientService',
          'ResolveDemographicProposal',
          request,
          ResolveDemographicProposalResponse());
  $async.Future<WithdrawDemographicProposalResponse>
      withdrawDemographicProposal($pb.ClientContext? ctx,
              WithdrawDemographicProposalRequest request) =>
          _client.invoke<WithdrawDemographicProposalResponse>(
              ctx,
              'PatientService',
              'WithdrawDemographicProposal',
              request,
              WithdrawDemographicProposalResponse());

  /// SRS-EMPI-007. Names, preferences and relationships, effective-dated.
  $async.Future<RecordNameResponse> recordName(
          $pb.ClientContext? ctx, RecordNameRequest request) =>
      _client.invoke<RecordNameResponse>(
          ctx, 'PatientService', 'RecordName', request, RecordNameResponse());
  $async.Future<GetPatientHistoryResponse> getPatientHistory(
          $pb.ClientContext? ctx, GetPatientHistoryRequest request) =>
      _client.invoke<GetPatientHistoryResponse>(ctx, 'PatientService',
          'GetPatientHistory', request, GetPatientHistoryResponse());
  $async.Future<RecordCommunicationPreferenceResponse>
      recordCommunicationPreference($pb.ClientContext? ctx,
              RecordCommunicationPreferenceRequest request) =>
          _client.invoke<RecordCommunicationPreferenceResponse>(
              ctx,
              'PatientService',
              'RecordCommunicationPreference',
              request,
              RecordCommunicationPreferenceResponse());

  /// SRS-EMPI-008. Recording a death stops routine scheduling; withdrawing one
  /// exists because a registry feed can match the wrong record, and a system
  /// that cannot undo it leaves somebody unable to book an appointment because
  /// a computer believes they are dead.
  $async.Future<RecordDeceasedResponse> recordDeceased(
          $pb.ClientContext? ctx, RecordDeceasedRequest request) =>
      _client.invoke<RecordDeceasedResponse>(ctx, 'PatientService',
          'RecordDeceased', request, RecordDeceasedResponse());
  $async.Future<ReverseDeceasedResponse> reverseDeceased(
          $pb.ClientContext? ctx, ReverseDeceasedRequest request) =>
      _client.invoke<ReverseDeceasedResponse>(ctx, 'PatientService',
          'ReverseDeceased', request, ReverseDeceasedResponse());

  /// SRS-EMPI-009. Caregiver relationships, scoped and expiring.
  $async.Future<AddRelatedPersonResponse> addRelatedPerson(
          $pb.ClientContext? ctx, AddRelatedPersonRequest request) =>
      _client.invoke<AddRelatedPersonResponse>(ctx, 'PatientService',
          'AddRelatedPerson', request, AddRelatedPersonResponse());
  $async.Future<VerifyRelatedPersonResponse> verifyRelatedPerson(
          $pb.ClientContext? ctx, VerifyRelatedPersonRequest request) =>
      _client.invoke<VerifyRelatedPersonResponse>(ctx, 'PatientService',
          'VerifyRelatedPerson', request, VerifyRelatedPersonResponse());
  $async.Future<EndRelatedPersonResponse> endRelatedPerson(
          $pb.ClientContext? ctx, EndRelatedPersonRequest request) =>
      _client.invoke<EndRelatedPersonResponse>(ctx, 'PatientService',
          'EndRelatedPerson', request, EndRelatedPersonResponse());
  $async.Future<GetCaregiverAuthorityResponse> getCaregiverAuthority(
          $pb.ClientContext? ctx, GetCaregiverAuthorityRequest request) =>
      _client.invoke<GetCaregiverAuthorityResponse>(ctx, 'PatientService',
          'GetCaregiverAuthority', request, GetCaregiverAuthorityResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
