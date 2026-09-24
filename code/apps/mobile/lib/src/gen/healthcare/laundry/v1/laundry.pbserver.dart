// This is a generated file - do not edit.
//
// Generated from healthcare/laundry/v1/laundry.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'laundry.pb.dart' as $1;
import 'laundry.pbjson.dart';

export 'laundry.pb.dart';

abstract class LaundryServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ConfigureLinenItemResponse> configureLinenItem(
      $pb.ServerContext ctx, $1.ConfigureLinenItemRequest request);
  $async.Future<$1.RetireLinenItemResponse> retireLinenItem(
      $pb.ServerContext ctx, $1.RetireLinenItemRequest request);
  $async.Future<$1.ListLinenItemsResponse> listLinenItems(
      $pb.ServerContext ctx, $1.ListLinenItemsRequest request);
  $async.Future<$1.SetParLevelResponse> setParLevel(
      $pb.ServerContext ctx, $1.SetParLevelRequest request);
  $async.Future<$1.ApproveParLevelResponse> approveParLevel(
      $pb.ServerContext ctx, $1.ApproveParLevelRequest request);
  $async.Future<$1.GetParInForceResponse> getParInForce(
      $pb.ServerContext ctx, $1.GetParInForceRequest request);
  $async.Future<$1.ListParLevelsResponse> listParLevels(
      $pb.ServerContext ctx, $1.ListParLevelsRequest request);
  $async.Future<$1.RecordCollectionResponse> recordCollection(
      $pb.ServerContext ctx, $1.RecordCollectionRequest request);
  $async.Future<$1.RecountCollectionResponse> recountCollection(
      $pb.ServerContext ctx, $1.RecountCollectionRequest request);
  $async.Future<$1.CancelCollectionResponse> cancelCollection(
      $pb.ServerContext ctx, $1.CancelCollectionRequest request);
  $async.Future<$1.ListCollectionsResponse> listCollections(
      $pb.ServerContext ctx, $1.ListCollectionsRequest request);
  $async.Future<$1.CheckCollectionWeightResponse> checkCollectionWeight(
      $pb.ServerContext ctx, $1.CheckCollectionWeightRequest request);
  $async.Future<$1.OpenWashBatchResponse> openWashBatch(
      $pb.ServerContext ctx, $1.OpenWashBatchRequest request);
  $async.Future<$1.LoadWashBatchResponse> loadWashBatch(
      $pb.ServerContext ctx, $1.LoadWashBatchRequest request);
  $async.Future<$1.StartWashBatchResponse> startWashBatch(
      $pb.ServerContext ctx, $1.StartWashBatchRequest request);
  $async.Future<$1.CompleteWashBatchResponse> completeWashBatch(
      $pb.ServerContext ctx, $1.CompleteWashBatchRequest request);
  $async.Future<$1.RewashBatchResponse> rewashBatch(
      $pb.ServerContext ctx, $1.RewashBatchRequest request);
  $async.Future<$1.GetWashBatchResponse> getWashBatch(
      $pb.ServerContext ctx, $1.GetWashBatchRequest request);
  $async.Future<$1.ListWashBatchesResponse> listWashBatches(
      $pb.ServerContext ctx, $1.ListWashBatchesRequest request);
  $async.Future<$1.ListAffectedUnitsResponse> listAffectedUnits(
      $pb.ServerContext ctx, $1.ListAffectedUnitsRequest request);
  $async.Future<$1.IssueLinenResponse> issueLinen(
      $pb.ServerContext ctx, $1.IssueLinenRequest request);
  $async.Future<$1.ReceiveLinenResponse> receiveLinen(
      $pb.ServerContext ctx, $1.ReceiveLinenRequest request);
  $async.Future<$1.ListLinenIssuesResponse> listLinenIssues(
      $pb.ServerContext ctx, $1.ListLinenIssuesRequest request);
  $async.Future<$1.GetUnitStockResponse> getUnitStock(
      $pb.ServerContext ctx, $1.GetUnitStockRequest request);
  $async.Future<$1.ReportLinenLossResponse> reportLinenLoss(
      $pb.ServerContext ctx, $1.ReportLinenLossRequest request);
  $async.Future<$1.ApproveLinenLossResponse> approveLinenLoss(
      $pb.ServerContext ctx, $1.ApproveLinenLossRequest request);
  $async.Future<$1.RecoverLinenLossResponse> recoverLinenLoss(
      $pb.ServerContext ctx, $1.RecoverLinenLossRequest request);
  $async.Future<$1.ListLinenLossesResponse> listLinenLosses(
      $pb.ServerContext ctx, $1.ListLinenLossesRequest request);
  $async.Future<$1.ListPendingLossApprovalsResponse> listPendingLossApprovals(
      $pb.ServerContext ctx, $1.ListPendingLossApprovalsRequest request);
  $async.Future<$1.RegisterTagResponse> registerTag(
      $pb.ServerContext ctx, $1.RegisterTagRequest request);
  $async.Future<$1.RecordTagScanResponse> recordTagScan(
      $pb.ServerContext ctx, $1.RecordTagScanRequest request);
  $async.Future<$1.RetireTagResponse> retireTag(
      $pb.ServerContext ctx, $1.RetireTagRequest request);
  $async.Future<$1.GetTagCustodyResponse> getTagCustody(
      $pb.ServerContext ctx, $1.GetTagCustodyRequest request);
  $async.Future<$1.ListTrackedItemsResponse> listTrackedItems(
      $pb.ServerContext ctx, $1.ListTrackedItemsRequest request);
  $async.Future<$1.ListStaleTrackedItemsResponse> listStaleTrackedItems(
      $pb.ServerContext ctx, $1.ListStaleTrackedItemsRequest request);
  $async.Future<$1.GetWashReportResponse> getWashReport(
      $pb.ServerContext ctx, $1.GetWashReportRequest request);
  $async.Future<$1.GetLinenLossReportResponse> getLinenLossReport(
      $pb.ServerContext ctx, $1.GetLinenLossReportRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ConfigureLinenItem':
        return $1.ConfigureLinenItemRequest();
      case 'RetireLinenItem':
        return $1.RetireLinenItemRequest();
      case 'ListLinenItems':
        return $1.ListLinenItemsRequest();
      case 'SetParLevel':
        return $1.SetParLevelRequest();
      case 'ApproveParLevel':
        return $1.ApproveParLevelRequest();
      case 'GetParInForce':
        return $1.GetParInForceRequest();
      case 'ListParLevels':
        return $1.ListParLevelsRequest();
      case 'RecordCollection':
        return $1.RecordCollectionRequest();
      case 'RecountCollection':
        return $1.RecountCollectionRequest();
      case 'CancelCollection':
        return $1.CancelCollectionRequest();
      case 'ListCollections':
        return $1.ListCollectionsRequest();
      case 'CheckCollectionWeight':
        return $1.CheckCollectionWeightRequest();
      case 'OpenWashBatch':
        return $1.OpenWashBatchRequest();
      case 'LoadWashBatch':
        return $1.LoadWashBatchRequest();
      case 'StartWashBatch':
        return $1.StartWashBatchRequest();
      case 'CompleteWashBatch':
        return $1.CompleteWashBatchRequest();
      case 'RewashBatch':
        return $1.RewashBatchRequest();
      case 'GetWashBatch':
        return $1.GetWashBatchRequest();
      case 'ListWashBatches':
        return $1.ListWashBatchesRequest();
      case 'ListAffectedUnits':
        return $1.ListAffectedUnitsRequest();
      case 'IssueLinen':
        return $1.IssueLinenRequest();
      case 'ReceiveLinen':
        return $1.ReceiveLinenRequest();
      case 'ListLinenIssues':
        return $1.ListLinenIssuesRequest();
      case 'GetUnitStock':
        return $1.GetUnitStockRequest();
      case 'ReportLinenLoss':
        return $1.ReportLinenLossRequest();
      case 'ApproveLinenLoss':
        return $1.ApproveLinenLossRequest();
      case 'RecoverLinenLoss':
        return $1.RecoverLinenLossRequest();
      case 'ListLinenLosses':
        return $1.ListLinenLossesRequest();
      case 'ListPendingLossApprovals':
        return $1.ListPendingLossApprovalsRequest();
      case 'RegisterTag':
        return $1.RegisterTagRequest();
      case 'RecordTagScan':
        return $1.RecordTagScanRequest();
      case 'RetireTag':
        return $1.RetireTagRequest();
      case 'GetTagCustody':
        return $1.GetTagCustodyRequest();
      case 'ListTrackedItems':
        return $1.ListTrackedItemsRequest();
      case 'ListStaleTrackedItems':
        return $1.ListStaleTrackedItemsRequest();
      case 'GetWashReport':
        return $1.GetWashReportRequest();
      case 'GetLinenLossReport':
        return $1.GetLinenLossReportRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ConfigureLinenItem':
        return configureLinenItem(ctx, request as $1.ConfigureLinenItemRequest);
      case 'RetireLinenItem':
        return retireLinenItem(ctx, request as $1.RetireLinenItemRequest);
      case 'ListLinenItems':
        return listLinenItems(ctx, request as $1.ListLinenItemsRequest);
      case 'SetParLevel':
        return setParLevel(ctx, request as $1.SetParLevelRequest);
      case 'ApproveParLevel':
        return approveParLevel(ctx, request as $1.ApproveParLevelRequest);
      case 'GetParInForce':
        return getParInForce(ctx, request as $1.GetParInForceRequest);
      case 'ListParLevels':
        return listParLevels(ctx, request as $1.ListParLevelsRequest);
      case 'RecordCollection':
        return recordCollection(ctx, request as $1.RecordCollectionRequest);
      case 'RecountCollection':
        return recountCollection(ctx, request as $1.RecountCollectionRequest);
      case 'CancelCollection':
        return cancelCollection(ctx, request as $1.CancelCollectionRequest);
      case 'ListCollections':
        return listCollections(ctx, request as $1.ListCollectionsRequest);
      case 'CheckCollectionWeight':
        return checkCollectionWeight(
            ctx, request as $1.CheckCollectionWeightRequest);
      case 'OpenWashBatch':
        return openWashBatch(ctx, request as $1.OpenWashBatchRequest);
      case 'LoadWashBatch':
        return loadWashBatch(ctx, request as $1.LoadWashBatchRequest);
      case 'StartWashBatch':
        return startWashBatch(ctx, request as $1.StartWashBatchRequest);
      case 'CompleteWashBatch':
        return completeWashBatch(ctx, request as $1.CompleteWashBatchRequest);
      case 'RewashBatch':
        return rewashBatch(ctx, request as $1.RewashBatchRequest);
      case 'GetWashBatch':
        return getWashBatch(ctx, request as $1.GetWashBatchRequest);
      case 'ListWashBatches':
        return listWashBatches(ctx, request as $1.ListWashBatchesRequest);
      case 'ListAffectedUnits':
        return listAffectedUnits(ctx, request as $1.ListAffectedUnitsRequest);
      case 'IssueLinen':
        return issueLinen(ctx, request as $1.IssueLinenRequest);
      case 'ReceiveLinen':
        return receiveLinen(ctx, request as $1.ReceiveLinenRequest);
      case 'ListLinenIssues':
        return listLinenIssues(ctx, request as $1.ListLinenIssuesRequest);
      case 'GetUnitStock':
        return getUnitStock(ctx, request as $1.GetUnitStockRequest);
      case 'ReportLinenLoss':
        return reportLinenLoss(ctx, request as $1.ReportLinenLossRequest);
      case 'ApproveLinenLoss':
        return approveLinenLoss(ctx, request as $1.ApproveLinenLossRequest);
      case 'RecoverLinenLoss':
        return recoverLinenLoss(ctx, request as $1.RecoverLinenLossRequest);
      case 'ListLinenLosses':
        return listLinenLosses(ctx, request as $1.ListLinenLossesRequest);
      case 'ListPendingLossApprovals':
        return listPendingLossApprovals(
            ctx, request as $1.ListPendingLossApprovalsRequest);
      case 'RegisterTag':
        return registerTag(ctx, request as $1.RegisterTagRequest);
      case 'RecordTagScan':
        return recordTagScan(ctx, request as $1.RecordTagScanRequest);
      case 'RetireTag':
        return retireTag(ctx, request as $1.RetireTagRequest);
      case 'GetTagCustody':
        return getTagCustody(ctx, request as $1.GetTagCustodyRequest);
      case 'ListTrackedItems':
        return listTrackedItems(ctx, request as $1.ListTrackedItemsRequest);
      case 'ListStaleTrackedItems':
        return listStaleTrackedItems(
            ctx, request as $1.ListStaleTrackedItemsRequest);
      case 'GetWashReport':
        return getWashReport(ctx, request as $1.GetWashReportRequest);
      case 'GetLinenLossReport':
        return getLinenLossReport(ctx, request as $1.GetLinenLossReportRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => LaundryServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => LaundryServiceBase$messageJson;
}
