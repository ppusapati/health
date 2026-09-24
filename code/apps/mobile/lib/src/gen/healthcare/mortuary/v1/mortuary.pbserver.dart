// This is a generated file - do not edit.
//
// Generated from healthcare/mortuary/v1/mortuary.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'mortuary.pb.dart' as $1;
import 'mortuary.pbjson.dart';

export 'mortuary.pb.dart';

abstract class MortuaryServiceBase extends $pb.GeneratedService {
  $async.Future<$1.OpenCaseResponse> openCase(
      $pb.ServerContext ctx, $1.OpenCaseRequest request);
  $async.Future<$1.IdentifyResponse> identify(
      $pb.ServerContext ctx, $1.IdentifyRequest request);
  $async.Future<$1.RecordCauseResponse> recordCause(
      $pb.ServerContext ctx, $1.RecordCauseRequest request);
  $async.Future<$1.RecordDeathCertificateResponse> recordDeathCertificate(
      $pb.ServerContext ctx, $1.RecordDeathCertificateRequest request);
  $async.Future<$1.MarkMedicoLegalResponse> markMedicoLegal(
      $pb.ServerContext ctx, $1.MarkMedicoLegalRequest request);
  $async.Future<$1.GetCaseResponse> getCase(
      $pb.ServerContext ctx, $1.GetCaseRequest request);
  $async.Future<$1.GetCaseByReferenceResponse> getCaseByReference(
      $pb.ServerContext ctx, $1.GetCaseByReferenceRequest request);
  $async.Future<$1.ListCasesResponse> listCases(
      $pb.ServerContext ctx, $1.ListCasesRequest request);
  $async.Future<$1.AddLocationResponse> addLocation(
      $pb.ServerContext ctx, $1.AddLocationRequest request);
  $async.Future<$1.SetLocationServiceResponse> setLocationService(
      $pb.ServerContext ctx, $1.SetLocationServiceRequest request);
  $async.Future<$1.ListLocationsResponse> listLocations(
      $pb.ServerContext ctx, $1.ListLocationsRequest request);
  $async.Future<$1.PlaceBodyResponse> placeBody(
      $pb.ServerContext ctx, $1.PlaceBodyRequest request);
  $async.Future<$1.GetPlacementHistoryResponse> getPlacementHistory(
      $pb.ServerContext ctx, $1.GetPlacementHistoryRequest request);
  $async.Future<$1.ListItemResponse> listItem(
      $pb.ServerContext ctx, $1.ListItemRequest request);
  $async.Future<$1.RetainItemResponse> retainItem(
      $pb.ServerContext ctx, $1.RetainItemRequest request);
  $async.Future<$1.HandOverBelongingsResponse> handOverBelongings(
      $pb.ServerContext ctx, $1.HandOverBelongingsRequest request);
  $async.Future<$1.GetBelongingsResponse> getBelongings(
      $pb.ServerContext ctx, $1.GetBelongingsRequest request);
  $async.Future<$1.GetChainOfCustodyResponse> getChainOfCustody(
      $pb.ServerContext ctx, $1.GetChainOfCustodyRequest request);
  $async.Future<$1.RequestPostmortemResponse> requestPostmortem(
      $pb.ServerContext ctx, $1.RequestPostmortemRequest request);
  $async.Future<$1.AdvancePostmortemResponse> advancePostmortem(
      $pb.ServerContext ctx, $1.AdvancePostmortemRequest request);
  $async.Future<$1.GetPostmortemsResponse> getPostmortems(
      $pb.ServerContext ctx, $1.GetPostmortemsRequest request);
  $async.Future<$1.RecordAuthorisationResponse> recordAuthorisation(
      $pb.ServerContext ctx, $1.RecordAuthorisationRequest request);
  $async.Future<$1.GetReleaseChecksResponse> getReleaseChecks(
      $pb.ServerContext ctx, $1.GetReleaseChecksRequest request);
  $async.Future<$1.ReleaseBodyResponse> releaseBody(
      $pb.ServerContext ctx, $1.ReleaseBodyRequest request);
  $async.Future<$1.GetReleaseResponse> getRelease(
      $pb.ServerContext ctx, $1.GetReleaseRequest request);
  $async.Future<$1.ListReleasesResponse> listReleases(
      $pb.ServerContext ctx, $1.ListReleasesRequest request);
  $async.Future<$1.GetBoardResponse> getBoard(
      $pb.ServerContext ctx, $1.GetBoardRequest request);
  $async.Future<$1.SweepLongStayResponse> sweepLongStay(
      $pb.ServerContext ctx, $1.SweepLongStayRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'OpenCase':
        return $1.OpenCaseRequest();
      case 'Identify':
        return $1.IdentifyRequest();
      case 'RecordCause':
        return $1.RecordCauseRequest();
      case 'RecordDeathCertificate':
        return $1.RecordDeathCertificateRequest();
      case 'MarkMedicoLegal':
        return $1.MarkMedicoLegalRequest();
      case 'GetCase':
        return $1.GetCaseRequest();
      case 'GetCaseByReference':
        return $1.GetCaseByReferenceRequest();
      case 'ListCases':
        return $1.ListCasesRequest();
      case 'AddLocation':
        return $1.AddLocationRequest();
      case 'SetLocationService':
        return $1.SetLocationServiceRequest();
      case 'ListLocations':
        return $1.ListLocationsRequest();
      case 'PlaceBody':
        return $1.PlaceBodyRequest();
      case 'GetPlacementHistory':
        return $1.GetPlacementHistoryRequest();
      case 'ListItem':
        return $1.ListItemRequest();
      case 'RetainItem':
        return $1.RetainItemRequest();
      case 'HandOverBelongings':
        return $1.HandOverBelongingsRequest();
      case 'GetBelongings':
        return $1.GetBelongingsRequest();
      case 'GetChainOfCustody':
        return $1.GetChainOfCustodyRequest();
      case 'RequestPostmortem':
        return $1.RequestPostmortemRequest();
      case 'AdvancePostmortem':
        return $1.AdvancePostmortemRequest();
      case 'GetPostmortems':
        return $1.GetPostmortemsRequest();
      case 'RecordAuthorisation':
        return $1.RecordAuthorisationRequest();
      case 'GetReleaseChecks':
        return $1.GetReleaseChecksRequest();
      case 'ReleaseBody':
        return $1.ReleaseBodyRequest();
      case 'GetRelease':
        return $1.GetReleaseRequest();
      case 'ListReleases':
        return $1.ListReleasesRequest();
      case 'GetBoard':
        return $1.GetBoardRequest();
      case 'SweepLongStay':
        return $1.SweepLongStayRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'OpenCase':
        return openCase(ctx, request as $1.OpenCaseRequest);
      case 'Identify':
        return identify(ctx, request as $1.IdentifyRequest);
      case 'RecordCause':
        return recordCause(ctx, request as $1.RecordCauseRequest);
      case 'RecordDeathCertificate':
        return recordDeathCertificate(
            ctx, request as $1.RecordDeathCertificateRequest);
      case 'MarkMedicoLegal':
        return markMedicoLegal(ctx, request as $1.MarkMedicoLegalRequest);
      case 'GetCase':
        return getCase(ctx, request as $1.GetCaseRequest);
      case 'GetCaseByReference':
        return getCaseByReference(ctx, request as $1.GetCaseByReferenceRequest);
      case 'ListCases':
        return listCases(ctx, request as $1.ListCasesRequest);
      case 'AddLocation':
        return addLocation(ctx, request as $1.AddLocationRequest);
      case 'SetLocationService':
        return setLocationService(ctx, request as $1.SetLocationServiceRequest);
      case 'ListLocations':
        return listLocations(ctx, request as $1.ListLocationsRequest);
      case 'PlaceBody':
        return placeBody(ctx, request as $1.PlaceBodyRequest);
      case 'GetPlacementHistory':
        return getPlacementHistory(
            ctx, request as $1.GetPlacementHistoryRequest);
      case 'ListItem':
        return listItem(ctx, request as $1.ListItemRequest);
      case 'RetainItem':
        return retainItem(ctx, request as $1.RetainItemRequest);
      case 'HandOverBelongings':
        return handOverBelongings(ctx, request as $1.HandOverBelongingsRequest);
      case 'GetBelongings':
        return getBelongings(ctx, request as $1.GetBelongingsRequest);
      case 'GetChainOfCustody':
        return getChainOfCustody(ctx, request as $1.GetChainOfCustodyRequest);
      case 'RequestPostmortem':
        return requestPostmortem(ctx, request as $1.RequestPostmortemRequest);
      case 'AdvancePostmortem':
        return advancePostmortem(ctx, request as $1.AdvancePostmortemRequest);
      case 'GetPostmortems':
        return getPostmortems(ctx, request as $1.GetPostmortemsRequest);
      case 'RecordAuthorisation':
        return recordAuthorisation(
            ctx, request as $1.RecordAuthorisationRequest);
      case 'GetReleaseChecks':
        return getReleaseChecks(ctx, request as $1.GetReleaseChecksRequest);
      case 'ReleaseBody':
        return releaseBody(ctx, request as $1.ReleaseBodyRequest);
      case 'GetRelease':
        return getRelease(ctx, request as $1.GetReleaseRequest);
      case 'ListReleases':
        return listReleases(ctx, request as $1.ListReleasesRequest);
      case 'GetBoard':
        return getBoard(ctx, request as $1.GetBoardRequest);
      case 'SweepLongStay':
        return sweepLongStay(ctx, request as $1.SweepLongStayRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => MortuaryServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MortuaryServiceBase$messageJson;
}
