// This is a generated file - do not edit.
//
// Generated from healthcare/ambulance/v1/ambulance.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'ambulance.pb.dart' as $1;
import 'ambulance.pbjson.dart';

export 'ambulance.pb.dart';

abstract class AmbulanceServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterVehicleResponse> registerVehicle(
      $pb.ServerContext ctx, $1.RegisterVehicleRequest request);
  $async.Future<$1.SetVehicleStateResponse> setVehicleState(
      $pb.ServerContext ctx, $1.SetVehicleStateRequest request);
  $async.Future<$1.GetVehicleResponse> getVehicle(
      $pb.ServerContext ctx, $1.GetVehicleRequest request);
  $async.Future<$1.ListVehiclesResponse> listVehicles(
      $pb.ServerContext ctx, $1.ListVehiclesRequest request);
  $async.Future<$1.RosterShiftResponse> rosterShift(
      $pb.ServerContext ctx, $1.RosterShiftRequest request);
  $async.Future<$1.SetShiftStateResponse> setShiftState(
      $pb.ServerContext ctx, $1.SetShiftStateRequest request);
  $async.Future<$1.GetShiftResponse> getShift(
      $pb.ServerContext ctx, $1.GetShiftRequest request);
  $async.Future<$1.ListShiftsResponse> listShifts(
      $pb.ServerContext ctx, $1.ListShiftsRequest request);
  $async.Future<$1.RecordReadinessCheckResponse> recordReadinessCheck(
      $pb.ServerContext ctx, $1.RecordReadinessCheckRequest request);
  $async.Future<$1.OverrideReadinessCheckResponse> overrideReadinessCheck(
      $pb.ServerContext ctx, $1.OverrideReadinessCheckRequest request);
  $async.Future<$1.GetReadinessCheckResponse> getReadinessCheck(
      $pb.ServerContext ctx, $1.GetReadinessCheckRequest request);
  $async.Future<$1.ListReadinessChecksResponse> listReadinessChecks(
      $pb.ServerContext ctx, $1.ListReadinessChecksRequest request);
  $async.Future<$1.GetReadinessSummaryResponse> getReadinessSummary(
      $pb.ServerContext ctx, $1.GetReadinessSummaryRequest request);
  $async.Future<$1.RaiseRequestResponse> raiseRequest(
      $pb.ServerContext ctx, $1.RaiseRequestRequest request);
  $async.Future<$1.CancelRequestResponse> cancelRequest(
      $pb.ServerContext ctx, $1.CancelRequestRequest request);
  $async.Future<$1.GetRequestResponse> getRequest(
      $pb.ServerContext ctx, $1.GetRequestRequest request);
  $async.Future<$1.ListRequestsResponse> listRequests(
      $pb.ServerContext ctx, $1.ListRequestsRequest request);
  $async.Future<$1.GetDispatchQueueResponse> getDispatchQueue(
      $pb.ServerContext ctx, $1.GetDispatchQueueRequest request);
  $async.Future<$1.DispatchResponse> dispatch(
      $pb.ServerContext ctx, $1.DispatchRequest request);
  $async.Future<$1.RecordTripMilestoneResponse> recordTripMilestone(
      $pb.ServerContext ctx, $1.RecordTripMilestoneRequest request);
  $async.Future<$1.AmendTripMilestoneResponse> amendTripMilestone(
      $pb.ServerContext ctx, $1.AmendTripMilestoneRequest request);
  $async.Future<$1.AbortTripResponse> abortTrip(
      $pb.ServerContext ctx, $1.AbortTripRequest request);
  $async.Future<$1.GetTripResponse> getTrip(
      $pb.ServerContext ctx, $1.GetTripRequest request);
  $async.Future<$1.ListTripsResponse> listTrips(
      $pb.ServerContext ctx, $1.ListTripsRequest request);
  $async.Future<$1.GetTimelineGapsResponse> getTimelineGaps(
      $pb.ServerContext ctx, $1.GetTimelineGapsRequest request);
  $async.Future<$1.OpenPrehospitalRecordResponse> openPrehospitalRecord(
      $pb.ServerContext ctx, $1.OpenPrehospitalRecordRequest request);
  $async.Future<$1.RecordPrehospitalEntryResponse> recordPrehospitalEntry(
      $pb.ServerContext ctx, $1.RecordPrehospitalEntryRequest request);
  $async.Future<$1.AttachTransferDocumentResponse> attachTransferDocument(
      $pb.ServerContext ctx, $1.AttachTransferDocumentRequest request);
  $async.Future<$1.GiveHandoverResponse> giveHandover(
      $pb.ServerContext ctx, $1.GiveHandoverRequest request);
  $async.Future<$1.AcceptHandoverResponse> acceptHandover(
      $pb.ServerContext ctx, $1.AcceptHandoverRequest request);
  $async.Future<$1.GetPrehospitalRecordResponse> getPrehospitalRecord(
      $pb.ServerContext ctx, $1.GetPrehospitalRecordRequest request);
  $async.Future<$1.ListPrehospitalRecordsResponse> listPrehospitalRecords(
      $pb.ServerContext ctx, $1.ListPrehospitalRecordsRequest request);
  $async.Future<$1.SweepWaitingHandoversResponse> sweepWaitingHandovers(
      $pb.ServerContext ctx, $1.SweepWaitingHandoversRequest request);
  $async.Future<$1.RecordPingResponse> recordPing(
      $pb.ServerContext ctx, $1.RecordPingRequest request);
  $async.Future<$1.RecordETAResponse> recordETA(
      $pb.ServerContext ctx, $1.RecordETARequest request);
  $async.Future<$1.GetVehiclePositionResponse> getVehiclePosition(
      $pb.ServerContext ctx, $1.GetVehiclePositionRequest request);
  $async.Future<$1.ListPingsResponse> listPings(
      $pb.ServerContext ctx, $1.ListPingsRequest request);
  $async.Future<$1.PurgeExpiredPingsResponse> purgeExpiredPings(
      $pb.ServerContext ctx, $1.PurgeExpiredPingsRequest request);
  $async.Future<$1.GetTripMetricsResponse> getTripMetrics(
      $pb.ServerContext ctx, $1.GetTripMetricsRequest request);
  $async.Future<$1.GetServiceSummaryResponse> getServiceSummary(
      $pb.ServerContext ctx, $1.GetServiceSummaryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterVehicle':
        return $1.RegisterVehicleRequest();
      case 'SetVehicleState':
        return $1.SetVehicleStateRequest();
      case 'GetVehicle':
        return $1.GetVehicleRequest();
      case 'ListVehicles':
        return $1.ListVehiclesRequest();
      case 'RosterShift':
        return $1.RosterShiftRequest();
      case 'SetShiftState':
        return $1.SetShiftStateRequest();
      case 'GetShift':
        return $1.GetShiftRequest();
      case 'ListShifts':
        return $1.ListShiftsRequest();
      case 'RecordReadinessCheck':
        return $1.RecordReadinessCheckRequest();
      case 'OverrideReadinessCheck':
        return $1.OverrideReadinessCheckRequest();
      case 'GetReadinessCheck':
        return $1.GetReadinessCheckRequest();
      case 'ListReadinessChecks':
        return $1.ListReadinessChecksRequest();
      case 'GetReadinessSummary':
        return $1.GetReadinessSummaryRequest();
      case 'RaiseRequest':
        return $1.RaiseRequestRequest();
      case 'CancelRequest':
        return $1.CancelRequestRequest();
      case 'GetRequest':
        return $1.GetRequestRequest();
      case 'ListRequests':
        return $1.ListRequestsRequest();
      case 'GetDispatchQueue':
        return $1.GetDispatchQueueRequest();
      case 'Dispatch':
        return $1.DispatchRequest();
      case 'RecordTripMilestone':
        return $1.RecordTripMilestoneRequest();
      case 'AmendTripMilestone':
        return $1.AmendTripMilestoneRequest();
      case 'AbortTrip':
        return $1.AbortTripRequest();
      case 'GetTrip':
        return $1.GetTripRequest();
      case 'ListTrips':
        return $1.ListTripsRequest();
      case 'GetTimelineGaps':
        return $1.GetTimelineGapsRequest();
      case 'OpenPrehospitalRecord':
        return $1.OpenPrehospitalRecordRequest();
      case 'RecordPrehospitalEntry':
        return $1.RecordPrehospitalEntryRequest();
      case 'AttachTransferDocument':
        return $1.AttachTransferDocumentRequest();
      case 'GiveHandover':
        return $1.GiveHandoverRequest();
      case 'AcceptHandover':
        return $1.AcceptHandoverRequest();
      case 'GetPrehospitalRecord':
        return $1.GetPrehospitalRecordRequest();
      case 'ListPrehospitalRecords':
        return $1.ListPrehospitalRecordsRequest();
      case 'SweepWaitingHandovers':
        return $1.SweepWaitingHandoversRequest();
      case 'RecordPing':
        return $1.RecordPingRequest();
      case 'RecordETA':
        return $1.RecordETARequest();
      case 'GetVehiclePosition':
        return $1.GetVehiclePositionRequest();
      case 'ListPings':
        return $1.ListPingsRequest();
      case 'PurgeExpiredPings':
        return $1.PurgeExpiredPingsRequest();
      case 'GetTripMetrics':
        return $1.GetTripMetricsRequest();
      case 'GetServiceSummary':
        return $1.GetServiceSummaryRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterVehicle':
        return registerVehicle(ctx, request as $1.RegisterVehicleRequest);
      case 'SetVehicleState':
        return setVehicleState(ctx, request as $1.SetVehicleStateRequest);
      case 'GetVehicle':
        return getVehicle(ctx, request as $1.GetVehicleRequest);
      case 'ListVehicles':
        return listVehicles(ctx, request as $1.ListVehiclesRequest);
      case 'RosterShift':
        return rosterShift(ctx, request as $1.RosterShiftRequest);
      case 'SetShiftState':
        return setShiftState(ctx, request as $1.SetShiftStateRequest);
      case 'GetShift':
        return getShift(ctx, request as $1.GetShiftRequest);
      case 'ListShifts':
        return listShifts(ctx, request as $1.ListShiftsRequest);
      case 'RecordReadinessCheck':
        return recordReadinessCheck(
            ctx, request as $1.RecordReadinessCheckRequest);
      case 'OverrideReadinessCheck':
        return overrideReadinessCheck(
            ctx, request as $1.OverrideReadinessCheckRequest);
      case 'GetReadinessCheck':
        return getReadinessCheck(ctx, request as $1.GetReadinessCheckRequest);
      case 'ListReadinessChecks':
        return listReadinessChecks(
            ctx, request as $1.ListReadinessChecksRequest);
      case 'GetReadinessSummary':
        return getReadinessSummary(
            ctx, request as $1.GetReadinessSummaryRequest);
      case 'RaiseRequest':
        return raiseRequest(ctx, request as $1.RaiseRequestRequest);
      case 'CancelRequest':
        return cancelRequest(ctx, request as $1.CancelRequestRequest);
      case 'GetRequest':
        return getRequest(ctx, request as $1.GetRequestRequest);
      case 'ListRequests':
        return listRequests(ctx, request as $1.ListRequestsRequest);
      case 'GetDispatchQueue':
        return getDispatchQueue(ctx, request as $1.GetDispatchQueueRequest);
      case 'Dispatch':
        return dispatch(ctx, request as $1.DispatchRequest);
      case 'RecordTripMilestone':
        return recordTripMilestone(
            ctx, request as $1.RecordTripMilestoneRequest);
      case 'AmendTripMilestone':
        return amendTripMilestone(ctx, request as $1.AmendTripMilestoneRequest);
      case 'AbortTrip':
        return abortTrip(ctx, request as $1.AbortTripRequest);
      case 'GetTrip':
        return getTrip(ctx, request as $1.GetTripRequest);
      case 'ListTrips':
        return listTrips(ctx, request as $1.ListTripsRequest);
      case 'GetTimelineGaps':
        return getTimelineGaps(ctx, request as $1.GetTimelineGapsRequest);
      case 'OpenPrehospitalRecord':
        return openPrehospitalRecord(
            ctx, request as $1.OpenPrehospitalRecordRequest);
      case 'RecordPrehospitalEntry':
        return recordPrehospitalEntry(
            ctx, request as $1.RecordPrehospitalEntryRequest);
      case 'AttachTransferDocument':
        return attachTransferDocument(
            ctx, request as $1.AttachTransferDocumentRequest);
      case 'GiveHandover':
        return giveHandover(ctx, request as $1.GiveHandoverRequest);
      case 'AcceptHandover':
        return acceptHandover(ctx, request as $1.AcceptHandoverRequest);
      case 'GetPrehospitalRecord':
        return getPrehospitalRecord(
            ctx, request as $1.GetPrehospitalRecordRequest);
      case 'ListPrehospitalRecords':
        return listPrehospitalRecords(
            ctx, request as $1.ListPrehospitalRecordsRequest);
      case 'SweepWaitingHandovers':
        return sweepWaitingHandovers(
            ctx, request as $1.SweepWaitingHandoversRequest);
      case 'RecordPing':
        return recordPing(ctx, request as $1.RecordPingRequest);
      case 'RecordETA':
        return recordETA(ctx, request as $1.RecordETARequest);
      case 'GetVehiclePosition':
        return getVehiclePosition(ctx, request as $1.GetVehiclePositionRequest);
      case 'ListPings':
        return listPings(ctx, request as $1.ListPingsRequest);
      case 'PurgeExpiredPings':
        return purgeExpiredPings(ctx, request as $1.PurgeExpiredPingsRequest);
      case 'GetTripMetrics':
        return getTripMetrics(ctx, request as $1.GetTripMetricsRequest);
      case 'GetServiceSummary':
        return getServiceSummary(ctx, request as $1.GetServiceSummaryRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AmbulanceServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AmbulanceServiceBase$messageJson;
}
