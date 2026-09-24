// This is a generated file - do not edit.
//
// Generated from healthcare/organization/v1/organization.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'organization.pb.dart' as $2;
import 'organization.pbjson.dart';

export 'organization.pb.dart';

abstract class OrganizationServiceBase extends $pb.GeneratedService {
  $async.Future<$2.CreateTenantResponse> createTenant(
      $pb.ServerContext ctx, $2.CreateTenantRequest request);
  $async.Future<$2.GetTenantResponse> getTenant(
      $pb.ServerContext ctx, $2.GetTenantRequest request);
  $async.Future<$2.CreateFacilityResponse> createFacility(
      $pb.ServerContext ctx, $2.CreateFacilityRequest request);
  $async.Future<$2.GetFacilityResponse> getFacility(
      $pb.ServerContext ctx, $2.GetFacilityRequest request);
  $async.Future<$2.ListFacilitiesResponse> listFacilities(
      $pb.ServerContext ctx, $2.ListFacilitiesRequest request);
  $async.Future<$2.CommissionOrgUnitResponse> commissionOrgUnit(
      $pb.ServerContext ctx, $2.CommissionOrgUnitRequest request);
  $async.Future<$2.DefineBedClassResponse> defineBedClass(
      $pb.ServerContext ctx, $2.DefineBedClassRequest request);
  $async.Future<$2.ListBedClassesResponse> listBedClasses(
      $pb.ServerContext ctx, $2.ListBedClassesRequest request);
  $async.Future<$2.CommissionRoomResponse> commissionRoom(
      $pb.ServerContext ctx, $2.CommissionRoomRequest request);
  $async.Future<$2.CommissionBedResponse> commissionBed(
      $pb.ServerContext ctx, $2.CommissionBedRequest request);
  $async.Future<$2.SetBedAvailabilityResponse> setBedAvailability(
      $pb.ServerContext ctx, $2.SetBedAvailabilityRequest request);
  $async.Future<$2.RetireBedResponse> retireBed(
      $pb.ServerContext ctx, $2.RetireBedRequest request);
  $async.Future<$2.BedBoardResponse> bedBoard(
      $pb.ServerContext ctx, $2.BedBoardRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateTenant':
        return $2.CreateTenantRequest();
      case 'GetTenant':
        return $2.GetTenantRequest();
      case 'CreateFacility':
        return $2.CreateFacilityRequest();
      case 'GetFacility':
        return $2.GetFacilityRequest();
      case 'ListFacilities':
        return $2.ListFacilitiesRequest();
      case 'CommissionOrgUnit':
        return $2.CommissionOrgUnitRequest();
      case 'DefineBedClass':
        return $2.DefineBedClassRequest();
      case 'ListBedClasses':
        return $2.ListBedClassesRequest();
      case 'CommissionRoom':
        return $2.CommissionRoomRequest();
      case 'CommissionBed':
        return $2.CommissionBedRequest();
      case 'SetBedAvailability':
        return $2.SetBedAvailabilityRequest();
      case 'RetireBed':
        return $2.RetireBedRequest();
      case 'BedBoard':
        return $2.BedBoardRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateTenant':
        return createTenant(ctx, request as $2.CreateTenantRequest);
      case 'GetTenant':
        return getTenant(ctx, request as $2.GetTenantRequest);
      case 'CreateFacility':
        return createFacility(ctx, request as $2.CreateFacilityRequest);
      case 'GetFacility':
        return getFacility(ctx, request as $2.GetFacilityRequest);
      case 'ListFacilities':
        return listFacilities(ctx, request as $2.ListFacilitiesRequest);
      case 'CommissionOrgUnit':
        return commissionOrgUnit(ctx, request as $2.CommissionOrgUnitRequest);
      case 'DefineBedClass':
        return defineBedClass(ctx, request as $2.DefineBedClassRequest);
      case 'ListBedClasses':
        return listBedClasses(ctx, request as $2.ListBedClassesRequest);
      case 'CommissionRoom':
        return commissionRoom(ctx, request as $2.CommissionRoomRequest);
      case 'CommissionBed':
        return commissionBed(ctx, request as $2.CommissionBedRequest);
      case 'SetBedAvailability':
        return setBedAvailability(ctx, request as $2.SetBedAvailabilityRequest);
      case 'RetireBed':
        return retireBed(ctx, request as $2.RetireBedRequest);
      case 'BedBoard':
        return bedBoard(ctx, request as $2.BedBoardRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      OrganizationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => OrganizationServiceBase$messageJson;
}
