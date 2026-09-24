// This is a generated file - do not edit.
//
// Generated from healthcare/facilities/v1/facilities.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'facilities.pb.dart' as $1;
import 'facilities.pbjson.dart';

export 'facilities.pb.dart';

abstract class FacilitiesServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterAssetResponse> registerAsset(
      $pb.ServerContext ctx, $1.RegisterAssetRequest request);
  $async.Future<$1.SetAssetStatusResponse> setAssetStatus(
      $pb.ServerContext ctx, $1.SetAssetStatusRequest request);
  $async.Future<$1.GetAssetResponse> getAsset(
      $pb.ServerContext ctx, $1.GetAssetRequest request);
  $async.Future<$1.ListAssetsResponse> listAssets(
      $pb.ServerContext ctx, $1.ListAssetsRequest request);
  $async.Future<$1.GetAssetTreeResponse> getAssetTree(
      $pb.ServerContext ctx, $1.GetAssetTreeRequest request);
  $async.Future<$1.ListDownAssetsResponse> listDownAssets(
      $pb.ServerContext ctx, $1.ListDownAssetsRequest request);
  $async.Future<$1.SetWorkClassResponse> setWorkClass(
      $pb.ServerContext ctx, $1.SetWorkClassRequest request);
  $async.Future<$1.ListWorkClassesResponse> listWorkClasses(
      $pb.ServerContext ctx, $1.ListWorkClassesRequest request);
  $async.Future<$1.RaiseWorkResponse> raiseWork(
      $pb.ServerContext ctx, $1.RaiseWorkRequest request);
  $async.Future<$1.AssignWorkResponse> assignWork(
      $pb.ServerContext ctx, $1.AssignWorkRequest request);
  $async.Future<$1.StartWorkResponse> startWork(
      $pb.ServerContext ctx, $1.StartWorkRequest request);
  $async.Future<$1.HoldWorkResponse> holdWork(
      $pb.ServerContext ctx, $1.HoldWorkRequest request);
  $async.Future<$1.ResolveWorkResponse> resolveWork(
      $pb.ServerContext ctx, $1.ResolveWorkRequest request);
  $async.Future<$1.CloseWorkResponse> closeWork(
      $pb.ServerContext ctx, $1.CloseWorkRequest request);
  $async.Future<$1.CancelWorkResponse> cancelWork(
      $pb.ServerContext ctx, $1.CancelWorkRequest request);
  $async.Future<$1.GetWorkResponse> getWork(
      $pb.ServerContext ctx, $1.GetWorkRequest request);
  $async.Future<$1.ListWorkResponse> listWork(
      $pb.ServerContext ctx, $1.ListWorkRequest request);
  $async.Future<$1.GetWorklistResponse> getWorklist(
      $pb.ServerContext ctx, $1.GetWorklistRequest request);
  $async.Future<$1.AddScheduleResponse> addSchedule(
      $pb.ServerContext ctx, $1.AddScheduleRequest request);
  $async.Future<$1.ListSchedulesResponse> listSchedules(
      $pb.ServerContext ctx, $1.ListSchedulesRequest request);
  $async.Future<$1.PlanDueResponse> planDue(
      $pb.ServerContext ctx, $1.PlanDueRequest request);
  $async.Future<$1.CompleteTaskResponse> completeTask(
      $pb.ServerContext ctx, $1.CompleteTaskRequest request);
  $async.Future<$1.WaiveTaskResponse> waiveTask(
      $pb.ServerContext ctx, $1.WaiveTaskRequest request);
  $async.Future<$1.ListTasksResponse> listTasks(
      $pb.ServerContext ctx, $1.ListTasksRequest request);
  $async.Future<$1.GetMaintenanceReportResponse> getMaintenanceReport(
      $pb.ServerContext ctx, $1.GetMaintenanceReportRequest request);
  $async.Future<$1.RecordRuntimeResponse> recordRuntime(
      $pb.ServerContext ctx, $1.RecordRuntimeRequest request);
  $async.Future<$1.PlanOutageResponse> planOutage(
      $pb.ServerContext ctx, $1.PlanOutageRequest request);
  $async.Future<$1.ApproveOutageResponse> approveOutage(
      $pb.ServerContext ctx, $1.ApproveOutageRequest request);
  $async.Future<$1.AcknowledgeOutageResponse> acknowledgeOutage(
      $pb.ServerContext ctx, $1.AcknowledgeOutageRequest request);
  $async.Future<$1.StartOutageResponse> startOutage(
      $pb.ServerContext ctx, $1.StartOutageRequest request);
  $async.Future<$1.RestoreOutageResponse> restoreOutage(
      $pb.ServerContext ctx, $1.RestoreOutageRequest request);
  $async.Future<$1.CancelOutageResponse> cancelOutage(
      $pb.ServerContext ctx, $1.CancelOutageRequest request);
  $async.Future<$1.GetOutageResponse> getOutage(
      $pb.ServerContext ctx, $1.GetOutageRequest request);
  $async.Future<$1.ListOutagesResponse> listOutages(
      $pb.ServerContext ctx, $1.ListOutagesRequest request);
  $async.Future<$1.IngestAlarmResponse> ingestAlarm(
      $pb.ServerContext ctx, $1.IngestAlarmRequest request);
  $async.Future<$1.ClearAlarmResponse> clearAlarm(
      $pb.ServerContext ctx, $1.ClearAlarmRequest request);
  $async.Future<$1.AcknowledgeAlarmResponse> acknowledgeAlarm(
      $pb.ServerContext ctx, $1.AcknowledgeAlarmRequest request);
  $async.Future<$1.LinkAlarmWorkResponse> linkAlarmWork(
      $pb.ServerContext ctx, $1.LinkAlarmWorkRequest request);
  $async.Future<$1.SetAlarmRuleResponse> setAlarmRule(
      $pb.ServerContext ctx, $1.SetAlarmRuleRequest request);
  $async.Future<$1.ListAlarmsResponse> listAlarms(
      $pb.ServerContext ctx, $1.ListAlarmsRequest request);
  $async.Future<$1.RaiseDeficiencyResponse> raiseDeficiency(
      $pb.ServerContext ctx, $1.RaiseDeficiencyRequest request);
  $async.Future<$1.MitigateDeficiencyResponse> mitigateDeficiency(
      $pb.ServerContext ctx, $1.MitigateDeficiencyRequest request);
  $async.Future<$1.CloseDeficiencyResponse> closeDeficiency(
      $pb.ServerContext ctx, $1.CloseDeficiencyRequest request);
  $async.Future<$1.ListDeficienciesResponse> listDeficiencies(
      $pb.ServerContext ctx, $1.ListDeficienciesRequest request);
  $async.Future<$1.ListOpenCriticalResponse> listOpenCritical(
      $pb.ServerContext ctx, $1.ListOpenCriticalRequest request);
  $async.Future<$1.ListBlockingResponse> listBlocking(
      $pb.ServerContext ctx, $1.ListBlockingRequest request);
  $async.Future<$1.GetSafetyReportResponse> getSafetyReport(
      $pb.ServerContext ctx, $1.GetSafetyReportRequest request);
  $async.Future<$1.AddMeterResponse> addMeter(
      $pb.ServerContext ctx, $1.AddMeterRequest request);
  $async.Future<$1.RecordMeterReadingResponse> recordMeterReading(
      $pb.ServerContext ctx, $1.RecordMeterReadingRequest request);
  $async.Future<$1.ListMetersResponse> listMeters(
      $pb.ServerContext ctx, $1.ListMetersRequest request);
  $async.Future<$1.GetConsumptionResponse> getConsumption(
      $pb.ServerContext ctx, $1.GetConsumptionRequest request);
  $async.Future<$1.GetDowntimeResponse> getDowntime(
      $pb.ServerContext ctx, $1.GetDowntimeRequest request);
  $async.Future<$1.GetPerformanceResponse> getPerformance(
      $pb.ServerContext ctx, $1.GetPerformanceRequest request);
  $async.Future<$1.SignInVendorResponse> signInVendor(
      $pb.ServerContext ctx, $1.SignInVendorRequest request);
  $async.Future<$1.SignOutVendorResponse> signOutVendor(
      $pb.ServerContext ctx, $1.SignOutVendorRequest request);
  $async.Future<$1.ListVendorVisitsResponse> listVendorVisits(
      $pb.ServerContext ctx, $1.ListVendorVisitsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterAsset':
        return $1.RegisterAssetRequest();
      case 'SetAssetStatus':
        return $1.SetAssetStatusRequest();
      case 'GetAsset':
        return $1.GetAssetRequest();
      case 'ListAssets':
        return $1.ListAssetsRequest();
      case 'GetAssetTree':
        return $1.GetAssetTreeRequest();
      case 'ListDownAssets':
        return $1.ListDownAssetsRequest();
      case 'SetWorkClass':
        return $1.SetWorkClassRequest();
      case 'ListWorkClasses':
        return $1.ListWorkClassesRequest();
      case 'RaiseWork':
        return $1.RaiseWorkRequest();
      case 'AssignWork':
        return $1.AssignWorkRequest();
      case 'StartWork':
        return $1.StartWorkRequest();
      case 'HoldWork':
        return $1.HoldWorkRequest();
      case 'ResolveWork':
        return $1.ResolveWorkRequest();
      case 'CloseWork':
        return $1.CloseWorkRequest();
      case 'CancelWork':
        return $1.CancelWorkRequest();
      case 'GetWork':
        return $1.GetWorkRequest();
      case 'ListWork':
        return $1.ListWorkRequest();
      case 'GetWorklist':
        return $1.GetWorklistRequest();
      case 'AddSchedule':
        return $1.AddScheduleRequest();
      case 'ListSchedules':
        return $1.ListSchedulesRequest();
      case 'PlanDue':
        return $1.PlanDueRequest();
      case 'CompleteTask':
        return $1.CompleteTaskRequest();
      case 'WaiveTask':
        return $1.WaiveTaskRequest();
      case 'ListTasks':
        return $1.ListTasksRequest();
      case 'GetMaintenanceReport':
        return $1.GetMaintenanceReportRequest();
      case 'RecordRuntime':
        return $1.RecordRuntimeRequest();
      case 'PlanOutage':
        return $1.PlanOutageRequest();
      case 'ApproveOutage':
        return $1.ApproveOutageRequest();
      case 'AcknowledgeOutage':
        return $1.AcknowledgeOutageRequest();
      case 'StartOutage':
        return $1.StartOutageRequest();
      case 'RestoreOutage':
        return $1.RestoreOutageRequest();
      case 'CancelOutage':
        return $1.CancelOutageRequest();
      case 'GetOutage':
        return $1.GetOutageRequest();
      case 'ListOutages':
        return $1.ListOutagesRequest();
      case 'IngestAlarm':
        return $1.IngestAlarmRequest();
      case 'ClearAlarm':
        return $1.ClearAlarmRequest();
      case 'AcknowledgeAlarm':
        return $1.AcknowledgeAlarmRequest();
      case 'LinkAlarmWork':
        return $1.LinkAlarmWorkRequest();
      case 'SetAlarmRule':
        return $1.SetAlarmRuleRequest();
      case 'ListAlarms':
        return $1.ListAlarmsRequest();
      case 'RaiseDeficiency':
        return $1.RaiseDeficiencyRequest();
      case 'MitigateDeficiency':
        return $1.MitigateDeficiencyRequest();
      case 'CloseDeficiency':
        return $1.CloseDeficiencyRequest();
      case 'ListDeficiencies':
        return $1.ListDeficienciesRequest();
      case 'ListOpenCritical':
        return $1.ListOpenCriticalRequest();
      case 'ListBlocking':
        return $1.ListBlockingRequest();
      case 'GetSafetyReport':
        return $1.GetSafetyReportRequest();
      case 'AddMeter':
        return $1.AddMeterRequest();
      case 'RecordMeterReading':
        return $1.RecordMeterReadingRequest();
      case 'ListMeters':
        return $1.ListMetersRequest();
      case 'GetConsumption':
        return $1.GetConsumptionRequest();
      case 'GetDowntime':
        return $1.GetDowntimeRequest();
      case 'GetPerformance':
        return $1.GetPerformanceRequest();
      case 'SignInVendor':
        return $1.SignInVendorRequest();
      case 'SignOutVendor':
        return $1.SignOutVendorRequest();
      case 'ListVendorVisits':
        return $1.ListVendorVisitsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterAsset':
        return registerAsset(ctx, request as $1.RegisterAssetRequest);
      case 'SetAssetStatus':
        return setAssetStatus(ctx, request as $1.SetAssetStatusRequest);
      case 'GetAsset':
        return getAsset(ctx, request as $1.GetAssetRequest);
      case 'ListAssets':
        return listAssets(ctx, request as $1.ListAssetsRequest);
      case 'GetAssetTree':
        return getAssetTree(ctx, request as $1.GetAssetTreeRequest);
      case 'ListDownAssets':
        return listDownAssets(ctx, request as $1.ListDownAssetsRequest);
      case 'SetWorkClass':
        return setWorkClass(ctx, request as $1.SetWorkClassRequest);
      case 'ListWorkClasses':
        return listWorkClasses(ctx, request as $1.ListWorkClassesRequest);
      case 'RaiseWork':
        return raiseWork(ctx, request as $1.RaiseWorkRequest);
      case 'AssignWork':
        return assignWork(ctx, request as $1.AssignWorkRequest);
      case 'StartWork':
        return startWork(ctx, request as $1.StartWorkRequest);
      case 'HoldWork':
        return holdWork(ctx, request as $1.HoldWorkRequest);
      case 'ResolveWork':
        return resolveWork(ctx, request as $1.ResolveWorkRequest);
      case 'CloseWork':
        return closeWork(ctx, request as $1.CloseWorkRequest);
      case 'CancelWork':
        return cancelWork(ctx, request as $1.CancelWorkRequest);
      case 'GetWork':
        return getWork(ctx, request as $1.GetWorkRequest);
      case 'ListWork':
        return listWork(ctx, request as $1.ListWorkRequest);
      case 'GetWorklist':
        return getWorklist(ctx, request as $1.GetWorklistRequest);
      case 'AddSchedule':
        return addSchedule(ctx, request as $1.AddScheduleRequest);
      case 'ListSchedules':
        return listSchedules(ctx, request as $1.ListSchedulesRequest);
      case 'PlanDue':
        return planDue(ctx, request as $1.PlanDueRequest);
      case 'CompleteTask':
        return completeTask(ctx, request as $1.CompleteTaskRequest);
      case 'WaiveTask':
        return waiveTask(ctx, request as $1.WaiveTaskRequest);
      case 'ListTasks':
        return listTasks(ctx, request as $1.ListTasksRequest);
      case 'GetMaintenanceReport':
        return getMaintenanceReport(
            ctx, request as $1.GetMaintenanceReportRequest);
      case 'RecordRuntime':
        return recordRuntime(ctx, request as $1.RecordRuntimeRequest);
      case 'PlanOutage':
        return planOutage(ctx, request as $1.PlanOutageRequest);
      case 'ApproveOutage':
        return approveOutage(ctx, request as $1.ApproveOutageRequest);
      case 'AcknowledgeOutage':
        return acknowledgeOutage(ctx, request as $1.AcknowledgeOutageRequest);
      case 'StartOutage':
        return startOutage(ctx, request as $1.StartOutageRequest);
      case 'RestoreOutage':
        return restoreOutage(ctx, request as $1.RestoreOutageRequest);
      case 'CancelOutage':
        return cancelOutage(ctx, request as $1.CancelOutageRequest);
      case 'GetOutage':
        return getOutage(ctx, request as $1.GetOutageRequest);
      case 'ListOutages':
        return listOutages(ctx, request as $1.ListOutagesRequest);
      case 'IngestAlarm':
        return ingestAlarm(ctx, request as $1.IngestAlarmRequest);
      case 'ClearAlarm':
        return clearAlarm(ctx, request as $1.ClearAlarmRequest);
      case 'AcknowledgeAlarm':
        return acknowledgeAlarm(ctx, request as $1.AcknowledgeAlarmRequest);
      case 'LinkAlarmWork':
        return linkAlarmWork(ctx, request as $1.LinkAlarmWorkRequest);
      case 'SetAlarmRule':
        return setAlarmRule(ctx, request as $1.SetAlarmRuleRequest);
      case 'ListAlarms':
        return listAlarms(ctx, request as $1.ListAlarmsRequest);
      case 'RaiseDeficiency':
        return raiseDeficiency(ctx, request as $1.RaiseDeficiencyRequest);
      case 'MitigateDeficiency':
        return mitigateDeficiency(ctx, request as $1.MitigateDeficiencyRequest);
      case 'CloseDeficiency':
        return closeDeficiency(ctx, request as $1.CloseDeficiencyRequest);
      case 'ListDeficiencies':
        return listDeficiencies(ctx, request as $1.ListDeficienciesRequest);
      case 'ListOpenCritical':
        return listOpenCritical(ctx, request as $1.ListOpenCriticalRequest);
      case 'ListBlocking':
        return listBlocking(ctx, request as $1.ListBlockingRequest);
      case 'GetSafetyReport':
        return getSafetyReport(ctx, request as $1.GetSafetyReportRequest);
      case 'AddMeter':
        return addMeter(ctx, request as $1.AddMeterRequest);
      case 'RecordMeterReading':
        return recordMeterReading(ctx, request as $1.RecordMeterReadingRequest);
      case 'ListMeters':
        return listMeters(ctx, request as $1.ListMetersRequest);
      case 'GetConsumption':
        return getConsumption(ctx, request as $1.GetConsumptionRequest);
      case 'GetDowntime':
        return getDowntime(ctx, request as $1.GetDowntimeRequest);
      case 'GetPerformance':
        return getPerformance(ctx, request as $1.GetPerformanceRequest);
      case 'SignInVendor':
        return signInVendor(ctx, request as $1.SignInVendorRequest);
      case 'SignOutVendor':
        return signOutVendor(ctx, request as $1.SignOutVendorRequest);
      case 'ListVendorVisits':
        return listVendorVisits(ctx, request as $1.ListVendorVisitsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      FacilitiesServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => FacilitiesServiceBase$messageJson;
}
