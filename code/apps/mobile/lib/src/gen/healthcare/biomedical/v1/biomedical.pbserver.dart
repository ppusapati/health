// This is a generated file - do not edit.
//
// Generated from healthcare/biomedical/v1/biomedical.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'biomedical.pb.dart' as $1;
import 'biomedical.pbjson.dart';

export 'biomedical.pb.dart';

abstract class BiomedicalServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterAssetResponse> registerAsset(
      $pb.ServerContext ctx, $1.RegisterAssetRequest request);
  $async.Future<$1.GetAssetResponse> getAsset(
      $pb.ServerContext ctx, $1.GetAssetRequest request);
  $async.Future<$1.GetAssetByTagResponse> getAssetByTag(
      $pb.ServerContext ctx, $1.GetAssetByTagRequest request);
  $async.Future<$1.ListAssetsResponse> listAssets(
      $pb.ServerContext ctx, $1.ListAssetsRequest request);
  $async.Future<$1.MoveAssetResponse> moveAsset(
      $pb.ServerContext ctx, $1.MoveAssetRequest request);
  $async.Future<$1.RecordCalibrationResponse> recordCalibration(
      $pb.ServerContext ctx, $1.RecordCalibrationRequest request);
  $async.Future<$1.GetLocationCapabilityResponse> getLocationCapability(
      $pb.ServerContext ctx, $1.GetLocationCapabilityRequest request);
  $async.Future<$1.RecordContractResponse> recordContract(
      $pb.ServerContext ctx, $1.RecordContractRequest request);
  $async.Future<$1.GetContractResponse> getContract(
      $pb.ServerContext ctx, $1.GetContractRequest request);
  $async.Future<$1.ListContractsForAssetResponse> listContractsForAsset(
      $pb.ServerContext ctx, $1.ListContractsForAssetRequest request);
  $async.Future<$1.GetCoverForAssetResponse> getCoverForAsset(
      $pb.ServerContext ctx, $1.GetCoverForAssetRequest request);
  $async.Future<$1.ListExpiryRemindersResponse> listExpiryReminders(
      $pb.ServerContext ctx, $1.ListExpiryRemindersRequest request);
  $async.Future<$1.SchedulePlanResponse> schedulePlan(
      $pb.ServerContext ctx, $1.SchedulePlanRequest request);
  $async.Future<$1.RetirePlanResponse> retirePlan(
      $pb.ServerContext ctx, $1.RetirePlanRequest request);
  $async.Future<$1.ListPlansResponse> listPlans(
      $pb.ServerContext ctx, $1.ListPlansRequest request);
  $async.Future<$1.ListDueMaintenanceResponse> listDueMaintenance(
      $pb.ServerContext ctx, $1.ListDueMaintenanceRequest request);
  $async.Future<$1.RaiseTicketResponse> raiseTicket(
      $pb.ServerContext ctx, $1.RaiseTicketRequest request);
  $async.Future<$1.GetTicketResponse> getTicket(
      $pb.ServerContext ctx, $1.GetTicketRequest request);
  $async.Future<$1.ListTicketsResponse> listTickets(
      $pb.ServerContext ctx, $1.ListTicketsRequest request);
  $async.Future<$1.AssignTicketResponse> assignTicket(
      $pb.ServerContext ctx, $1.AssignTicketRequest request);
  $async.Future<$1.StartTicketResponse> startTicket(
      $pb.ServerContext ctx, $1.StartTicketRequest request);
  $async.Future<$1.AwaitPartsResponse> awaitParts(
      $pb.ServerContext ctx, $1.AwaitPartsRequest request);
  $async.Future<$1.CancelTicketResponse> cancelTicket(
      $pb.ServerContext ctx, $1.CancelTicketRequest request);
  $async.Future<$1.ResolveTicketResponse> resolveTicket(
      $pb.ServerContext ctx, $1.ResolveTicketRequest request);
  $async.Future<$1.CloseTicketResponse> closeTicket(
      $pb.ServerContext ctx, $1.CloseTicketRequest request);
  $async.Future<$1.ListBreachesResponse> listBreaches(
      $pb.ServerContext ctx, $1.ListBreachesRequest request);
  $async.Future<$1.RaiseNoticeResponse> raiseNotice(
      $pb.ServerContext ctx, $1.RaiseNoticeRequest request);
  $async.Future<$1.GetNoticeResponse> getNotice(
      $pb.ServerContext ctx, $1.GetNoticeRequest request);
  $async.Future<$1.ListNoticesResponse> listNotices(
      $pb.ServerContext ctx, $1.ListNoticesRequest request);
  $async.Future<$1.ListNoticeTasksResponse> listNoticeTasks(
      $pb.ServerContext ctx, $1.ListNoticeTasksRequest request);
  $async.Future<$1.AdvanceTaskResponse> advanceTask(
      $pb.ServerContext ctx, $1.AdvanceTaskRequest request);
  $async.Future<$1.TrackNoticeResponse> trackNotice(
      $pb.ServerContext ctx, $1.TrackNoticeRequest request);
  $async.Future<$1.CloseNoticeResponse> closeNotice(
      $pb.ServerContext ctx, $1.CloseNoticeRequest request);
  $async.Future<$1.HoldAssetResponse> holdAsset(
      $pb.ServerContext ctx, $1.HoldAssetRequest request);
  $async.Future<$1.ReleaseAssetResponse> releaseAsset(
      $pb.ServerContext ctx, $1.ReleaseAssetRequest request);
  $async.Future<$1.AppendReadingsResponse> appendReadings(
      $pb.ServerContext ctx, $1.AppendReadingsRequest request);
  $async.Future<$1.ListReadingsResponse> listReadings(
      $pb.ServerContext ctx, $1.ListReadingsRequest request);
  $async.Future<$1.GetAssetMetricsResponse> getAssetMetrics(
      $pb.ServerContext ctx, $1.GetAssetMetricsRequest request);
  $async.Future<$1.GetFleetMetricsResponse> getFleetMetrics(
      $pb.ServerContext ctx, $1.GetFleetMetricsRequest request);
  $async.Future<$1.DisposeAssetResponse> disposeAsset(
      $pb.ServerContext ctx, $1.DisposeAssetRequest request);
  $async.Future<$1.GetDisposalResponse> getDisposal(
      $pb.ServerContext ctx, $1.GetDisposalRequest request);
  $async.Future<$1.ListDisposalsResponse> listDisposals(
      $pb.ServerContext ctx, $1.ListDisposalsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterAsset':
        return $1.RegisterAssetRequest();
      case 'GetAsset':
        return $1.GetAssetRequest();
      case 'GetAssetByTag':
        return $1.GetAssetByTagRequest();
      case 'ListAssets':
        return $1.ListAssetsRequest();
      case 'MoveAsset':
        return $1.MoveAssetRequest();
      case 'RecordCalibration':
        return $1.RecordCalibrationRequest();
      case 'GetLocationCapability':
        return $1.GetLocationCapabilityRequest();
      case 'RecordContract':
        return $1.RecordContractRequest();
      case 'GetContract':
        return $1.GetContractRequest();
      case 'ListContractsForAsset':
        return $1.ListContractsForAssetRequest();
      case 'GetCoverForAsset':
        return $1.GetCoverForAssetRequest();
      case 'ListExpiryReminders':
        return $1.ListExpiryRemindersRequest();
      case 'SchedulePlan':
        return $1.SchedulePlanRequest();
      case 'RetirePlan':
        return $1.RetirePlanRequest();
      case 'ListPlans':
        return $1.ListPlansRequest();
      case 'ListDueMaintenance':
        return $1.ListDueMaintenanceRequest();
      case 'RaiseTicket':
        return $1.RaiseTicketRequest();
      case 'GetTicket':
        return $1.GetTicketRequest();
      case 'ListTickets':
        return $1.ListTicketsRequest();
      case 'AssignTicket':
        return $1.AssignTicketRequest();
      case 'StartTicket':
        return $1.StartTicketRequest();
      case 'AwaitParts':
        return $1.AwaitPartsRequest();
      case 'CancelTicket':
        return $1.CancelTicketRequest();
      case 'ResolveTicket':
        return $1.ResolveTicketRequest();
      case 'CloseTicket':
        return $1.CloseTicketRequest();
      case 'ListBreaches':
        return $1.ListBreachesRequest();
      case 'RaiseNotice':
        return $1.RaiseNoticeRequest();
      case 'GetNotice':
        return $1.GetNoticeRequest();
      case 'ListNotices':
        return $1.ListNoticesRequest();
      case 'ListNoticeTasks':
        return $1.ListNoticeTasksRequest();
      case 'AdvanceTask':
        return $1.AdvanceTaskRequest();
      case 'TrackNotice':
        return $1.TrackNoticeRequest();
      case 'CloseNotice':
        return $1.CloseNoticeRequest();
      case 'HoldAsset':
        return $1.HoldAssetRequest();
      case 'ReleaseAsset':
        return $1.ReleaseAssetRequest();
      case 'AppendReadings':
        return $1.AppendReadingsRequest();
      case 'ListReadings':
        return $1.ListReadingsRequest();
      case 'GetAssetMetrics':
        return $1.GetAssetMetricsRequest();
      case 'GetFleetMetrics':
        return $1.GetFleetMetricsRequest();
      case 'DisposeAsset':
        return $1.DisposeAssetRequest();
      case 'GetDisposal':
        return $1.GetDisposalRequest();
      case 'ListDisposals':
        return $1.ListDisposalsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterAsset':
        return registerAsset(ctx, request as $1.RegisterAssetRequest);
      case 'GetAsset':
        return getAsset(ctx, request as $1.GetAssetRequest);
      case 'GetAssetByTag':
        return getAssetByTag(ctx, request as $1.GetAssetByTagRequest);
      case 'ListAssets':
        return listAssets(ctx, request as $1.ListAssetsRequest);
      case 'MoveAsset':
        return moveAsset(ctx, request as $1.MoveAssetRequest);
      case 'RecordCalibration':
        return recordCalibration(ctx, request as $1.RecordCalibrationRequest);
      case 'GetLocationCapability':
        return getLocationCapability(
            ctx, request as $1.GetLocationCapabilityRequest);
      case 'RecordContract':
        return recordContract(ctx, request as $1.RecordContractRequest);
      case 'GetContract':
        return getContract(ctx, request as $1.GetContractRequest);
      case 'ListContractsForAsset':
        return listContractsForAsset(
            ctx, request as $1.ListContractsForAssetRequest);
      case 'GetCoverForAsset':
        return getCoverForAsset(ctx, request as $1.GetCoverForAssetRequest);
      case 'ListExpiryReminders':
        return listExpiryReminders(
            ctx, request as $1.ListExpiryRemindersRequest);
      case 'SchedulePlan':
        return schedulePlan(ctx, request as $1.SchedulePlanRequest);
      case 'RetirePlan':
        return retirePlan(ctx, request as $1.RetirePlanRequest);
      case 'ListPlans':
        return listPlans(ctx, request as $1.ListPlansRequest);
      case 'ListDueMaintenance':
        return listDueMaintenance(ctx, request as $1.ListDueMaintenanceRequest);
      case 'RaiseTicket':
        return raiseTicket(ctx, request as $1.RaiseTicketRequest);
      case 'GetTicket':
        return getTicket(ctx, request as $1.GetTicketRequest);
      case 'ListTickets':
        return listTickets(ctx, request as $1.ListTicketsRequest);
      case 'AssignTicket':
        return assignTicket(ctx, request as $1.AssignTicketRequest);
      case 'StartTicket':
        return startTicket(ctx, request as $1.StartTicketRequest);
      case 'AwaitParts':
        return awaitParts(ctx, request as $1.AwaitPartsRequest);
      case 'CancelTicket':
        return cancelTicket(ctx, request as $1.CancelTicketRequest);
      case 'ResolveTicket':
        return resolveTicket(ctx, request as $1.ResolveTicketRequest);
      case 'CloseTicket':
        return closeTicket(ctx, request as $1.CloseTicketRequest);
      case 'ListBreaches':
        return listBreaches(ctx, request as $1.ListBreachesRequest);
      case 'RaiseNotice':
        return raiseNotice(ctx, request as $1.RaiseNoticeRequest);
      case 'GetNotice':
        return getNotice(ctx, request as $1.GetNoticeRequest);
      case 'ListNotices':
        return listNotices(ctx, request as $1.ListNoticesRequest);
      case 'ListNoticeTasks':
        return listNoticeTasks(ctx, request as $1.ListNoticeTasksRequest);
      case 'AdvanceTask':
        return advanceTask(ctx, request as $1.AdvanceTaskRequest);
      case 'TrackNotice':
        return trackNotice(ctx, request as $1.TrackNoticeRequest);
      case 'CloseNotice':
        return closeNotice(ctx, request as $1.CloseNoticeRequest);
      case 'HoldAsset':
        return holdAsset(ctx, request as $1.HoldAssetRequest);
      case 'ReleaseAsset':
        return releaseAsset(ctx, request as $1.ReleaseAssetRequest);
      case 'AppendReadings':
        return appendReadings(ctx, request as $1.AppendReadingsRequest);
      case 'ListReadings':
        return listReadings(ctx, request as $1.ListReadingsRequest);
      case 'GetAssetMetrics':
        return getAssetMetrics(ctx, request as $1.GetAssetMetricsRequest);
      case 'GetFleetMetrics':
        return getFleetMetrics(ctx, request as $1.GetFleetMetricsRequest);
      case 'DisposeAsset':
        return disposeAsset(ctx, request as $1.DisposeAssetRequest);
      case 'GetDisposal':
        return getDisposal(ctx, request as $1.GetDisposalRequest);
      case 'ListDisposals':
        return listDisposals(ctx, request as $1.ListDisposalsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      BiomedicalServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => BiomedicalServiceBase$messageJson;
}
