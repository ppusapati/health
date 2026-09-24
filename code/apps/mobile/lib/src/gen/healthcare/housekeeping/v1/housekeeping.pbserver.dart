// This is a generated file - do not edit.
//
// Generated from healthcare/housekeeping/v1/housekeeping.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'housekeeping.pb.dart' as $1;
import 'housekeeping.pbjson.dart';

export 'housekeeping.pb.dart';

abstract class HousekeepingServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ConfigureLocationResponse> configureLocation(
      $pb.ServerContext ctx, $1.ConfigureLocationRequest request);
  $async.Future<$1.ApproveLocationResponse> approveLocation(
      $pb.ServerContext ctx, $1.ApproveLocationRequest request);
  $async.Future<$1.ListLocationsResponse> listLocations(
      $pb.ServerContext ctx, $1.ListLocationsRequest request);
  $async.Future<$1.GetLocationInForceResponse> getLocationInForce(
      $pb.ServerContext ctx, $1.GetLocationInForceRequest request);
  $async.Future<$1.ListDueRoutineCleansResponse> listDueRoutineCleans(
      $pb.ServerContext ctx, $1.ListDueRoutineCleansRequest request);
  $async.Future<$1.RaiseCleaningTaskResponse> raiseCleaningTask(
      $pb.ServerContext ctx, $1.RaiseCleaningTaskRequest request);
  $async.Future<$1.AssignCleaningTaskResponse> assignCleaningTask(
      $pb.ServerContext ctx, $1.AssignCleaningTaskRequest request);
  $async.Future<$1.StartCleaningTaskResponse> startCleaningTask(
      $pb.ServerContext ctx, $1.StartCleaningTaskRequest request);
  $async.Future<$1.CompleteCleaningTaskResponse> completeCleaningTask(
      $pb.ServerContext ctx, $1.CompleteCleaningTaskRequest request);
  $async.Future<$1.VerifyCleaningTaskResponse> verifyCleaningTask(
      $pb.ServerContext ctx, $1.VerifyCleaningTaskRequest request);
  $async.Future<$1.CancelCleaningTaskResponse> cancelCleaningTask(
      $pb.ServerContext ctx, $1.CancelCleaningTaskRequest request);
  $async.Future<$1.GetCleaningTaskResponse> getCleaningTask(
      $pb.ServerContext ctx, $1.GetCleaningTaskRequest request);
  $async.Future<$1.ListCleaningTasksResponse> listCleaningTasks(
      $pb.ServerContext ctx, $1.ListCleaningTasksRequest request);
  $async.Future<$1.EscalateOverdueCleansResponse> escalateOverdueCleans(
      $pb.ServerContext ctx, $1.EscalateOverdueCleansRequest request);
  $async.Future<$1.RecordLocationScanResponse> recordLocationScan(
      $pb.ServerContext ctx, $1.RecordLocationScanRequest request);
  $async.Future<$1.TriggerTerminalCleanResponse> triggerTerminalClean(
      $pb.ServerContext ctx, $1.TriggerTerminalCleanRequest request);
  $async.Future<$1.OverrideBedHoldResponse> overrideBedHold(
      $pb.ServerContext ctx, $1.OverrideBedHoldRequest request);
  $async.Future<$1.GetBedStatusResponse> getBedStatus(
      $pb.ServerContext ctx, $1.GetBedStatusRequest request);
  $async.Future<$1.ListHeldBedsResponse> listHeldBeds(
      $pb.ServerContext ctx, $1.ListHeldBedsRequest request);
  $async.Future<$1.GetCleaningReportResponse> getCleaningReport(
      $pb.ServerContext ctx, $1.GetCleaningReportRequest request);
  $async.Future<$1.GetTurnaroundReportResponse> getTurnaroundReport(
      $pb.ServerContext ctx, $1.GetTurnaroundReportRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ConfigureLocation':
        return $1.ConfigureLocationRequest();
      case 'ApproveLocation':
        return $1.ApproveLocationRequest();
      case 'ListLocations':
        return $1.ListLocationsRequest();
      case 'GetLocationInForce':
        return $1.GetLocationInForceRequest();
      case 'ListDueRoutineCleans':
        return $1.ListDueRoutineCleansRequest();
      case 'RaiseCleaningTask':
        return $1.RaiseCleaningTaskRequest();
      case 'AssignCleaningTask':
        return $1.AssignCleaningTaskRequest();
      case 'StartCleaningTask':
        return $1.StartCleaningTaskRequest();
      case 'CompleteCleaningTask':
        return $1.CompleteCleaningTaskRequest();
      case 'VerifyCleaningTask':
        return $1.VerifyCleaningTaskRequest();
      case 'CancelCleaningTask':
        return $1.CancelCleaningTaskRequest();
      case 'GetCleaningTask':
        return $1.GetCleaningTaskRequest();
      case 'ListCleaningTasks':
        return $1.ListCleaningTasksRequest();
      case 'EscalateOverdueCleans':
        return $1.EscalateOverdueCleansRequest();
      case 'RecordLocationScan':
        return $1.RecordLocationScanRequest();
      case 'TriggerTerminalClean':
        return $1.TriggerTerminalCleanRequest();
      case 'OverrideBedHold':
        return $1.OverrideBedHoldRequest();
      case 'GetBedStatus':
        return $1.GetBedStatusRequest();
      case 'ListHeldBeds':
        return $1.ListHeldBedsRequest();
      case 'GetCleaningReport':
        return $1.GetCleaningReportRequest();
      case 'GetTurnaroundReport':
        return $1.GetTurnaroundReportRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ConfigureLocation':
        return configureLocation(ctx, request as $1.ConfigureLocationRequest);
      case 'ApproveLocation':
        return approveLocation(ctx, request as $1.ApproveLocationRequest);
      case 'ListLocations':
        return listLocations(ctx, request as $1.ListLocationsRequest);
      case 'GetLocationInForce':
        return getLocationInForce(ctx, request as $1.GetLocationInForceRequest);
      case 'ListDueRoutineCleans':
        return listDueRoutineCleans(
            ctx, request as $1.ListDueRoutineCleansRequest);
      case 'RaiseCleaningTask':
        return raiseCleaningTask(ctx, request as $1.RaiseCleaningTaskRequest);
      case 'AssignCleaningTask':
        return assignCleaningTask(ctx, request as $1.AssignCleaningTaskRequest);
      case 'StartCleaningTask':
        return startCleaningTask(ctx, request as $1.StartCleaningTaskRequest);
      case 'CompleteCleaningTask':
        return completeCleaningTask(
            ctx, request as $1.CompleteCleaningTaskRequest);
      case 'VerifyCleaningTask':
        return verifyCleaningTask(ctx, request as $1.VerifyCleaningTaskRequest);
      case 'CancelCleaningTask':
        return cancelCleaningTask(ctx, request as $1.CancelCleaningTaskRequest);
      case 'GetCleaningTask':
        return getCleaningTask(ctx, request as $1.GetCleaningTaskRequest);
      case 'ListCleaningTasks':
        return listCleaningTasks(ctx, request as $1.ListCleaningTasksRequest);
      case 'EscalateOverdueCleans':
        return escalateOverdueCleans(
            ctx, request as $1.EscalateOverdueCleansRequest);
      case 'RecordLocationScan':
        return recordLocationScan(ctx, request as $1.RecordLocationScanRequest);
      case 'TriggerTerminalClean':
        return triggerTerminalClean(
            ctx, request as $1.TriggerTerminalCleanRequest);
      case 'OverrideBedHold':
        return overrideBedHold(ctx, request as $1.OverrideBedHoldRequest);
      case 'GetBedStatus':
        return getBedStatus(ctx, request as $1.GetBedStatusRequest);
      case 'ListHeldBeds':
        return listHeldBeds(ctx, request as $1.ListHeldBedsRequest);
      case 'GetCleaningReport':
        return getCleaningReport(ctx, request as $1.GetCleaningReportRequest);
      case 'GetTurnaroundReport':
        return getTurnaroundReport(
            ctx, request as $1.GetTurnaroundReportRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      HousekeepingServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => HousekeepingServiceBase$messageJson;
}
