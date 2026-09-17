// This is a generated file - do not edit.
//
// Generated from healthcare/emergency/v1/emergency.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'emergency.pb.dart' as $1;
import 'emergency.pbjson.dart';

export 'emergency.pb.dart';

abstract class EmergencyServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ArriveResponse> arrive(
      $pb.ServerContext ctx, $1.ArriveRequest request);
  $async.Future<$1.GetEmergencyVisitResponse> getEmergencyVisit(
      $pb.ServerContext ctx, $1.GetEmergencyVisitRequest request);
  $async.Future<$1.IdentifyPatientResponse> identifyPatient(
      $pb.ServerContext ctx, $1.IdentifyPatientRequest request);
  $async.Future<$1.AssignTriageResponse> assignTriage(
      $pb.ServerContext ctx, $1.AssignTriageRequest request);
  $async.Future<$1.OverridePriorityResponse> overridePriority(
      $pb.ServerContext ctx, $1.OverridePriorityRequest request);
  $async.Future<$1.GetBoardResponse> getBoard(
      $pb.ServerContext ctx, $1.GetBoardRequest request);
  $async.Future<$1.ActivatePathwayResponse> activatePathway(
      $pb.ServerContext ctx, $1.ActivatePathwayRequest request);
  $async.Future<$1.StandDownPathwayResponse> standDownPathway(
      $pb.ServerContext ctx, $1.StandDownPathwayRequest request);
  $async.Future<$1.RecordEmergencyEventResponse> recordEmergencyEvent(
      $pb.ServerContext ctx, $1.RecordEmergencyEventRequest request);
  $async.Future<$1.GetTimelineResponse> getTimeline(
      $pb.ServerContext ctx, $1.GetTimelineRequest request);
  $async.Future<$1.ReconcileAdministrationResponse> reconcileAdministration(
      $pb.ServerContext ctx, $1.ReconcileAdministrationRequest request);
  $async.Future<$1.ListUnreconciledResponse> listUnreconciled(
      $pb.ServerContext ctx, $1.ListUnreconciledRequest request);
  $async.Future<$1.StartObservationResponse> startObservation(
      $pb.ServerContext ctx, $1.StartObservationRequest request);
  $async.Future<$1.DisposeResponse> dispose(
      $pb.ServerContext ctx, $1.DisposeRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Arrive':
        return $1.ArriveRequest();
      case 'GetEmergencyVisit':
        return $1.GetEmergencyVisitRequest();
      case 'IdentifyPatient':
        return $1.IdentifyPatientRequest();
      case 'AssignTriage':
        return $1.AssignTriageRequest();
      case 'OverridePriority':
        return $1.OverridePriorityRequest();
      case 'GetBoard':
        return $1.GetBoardRequest();
      case 'ActivatePathway':
        return $1.ActivatePathwayRequest();
      case 'StandDownPathway':
        return $1.StandDownPathwayRequest();
      case 'RecordEmergencyEvent':
        return $1.RecordEmergencyEventRequest();
      case 'GetTimeline':
        return $1.GetTimelineRequest();
      case 'ReconcileAdministration':
        return $1.ReconcileAdministrationRequest();
      case 'ListUnreconciled':
        return $1.ListUnreconciledRequest();
      case 'StartObservation':
        return $1.StartObservationRequest();
      case 'Dispose':
        return $1.DisposeRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Arrive':
        return arrive(ctx, request as $1.ArriveRequest);
      case 'GetEmergencyVisit':
        return getEmergencyVisit(ctx, request as $1.GetEmergencyVisitRequest);
      case 'IdentifyPatient':
        return identifyPatient(ctx, request as $1.IdentifyPatientRequest);
      case 'AssignTriage':
        return assignTriage(ctx, request as $1.AssignTriageRequest);
      case 'OverridePriority':
        return overridePriority(ctx, request as $1.OverridePriorityRequest);
      case 'GetBoard':
        return getBoard(ctx, request as $1.GetBoardRequest);
      case 'ActivatePathway':
        return activatePathway(ctx, request as $1.ActivatePathwayRequest);
      case 'StandDownPathway':
        return standDownPathway(ctx, request as $1.StandDownPathwayRequest);
      case 'RecordEmergencyEvent':
        return recordEmergencyEvent(
            ctx, request as $1.RecordEmergencyEventRequest);
      case 'GetTimeline':
        return getTimeline(ctx, request as $1.GetTimelineRequest);
      case 'ReconcileAdministration':
        return reconcileAdministration(
            ctx, request as $1.ReconcileAdministrationRequest);
      case 'ListUnreconciled':
        return listUnreconciled(ctx, request as $1.ListUnreconciledRequest);
      case 'StartObservation':
        return startObservation(ctx, request as $1.StartObservationRequest);
      case 'Dispose':
        return dispose(ctx, request as $1.DisposeRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => EmergencyServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => EmergencyServiceBase$messageJson;
}
