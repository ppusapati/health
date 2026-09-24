// This is a generated file - do not edit.
//
// Generated from healthcare/materials/v1/materials.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'materials.pb.dart' as $1;
import 'materials.pbjson.dart';

export 'materials.pb.dart';

abstract class MaterialsServiceBase extends $pb.GeneratedService {
  $async.Future<$1.AddItemResponse> addItem(
      $pb.ServerContext ctx, $1.AddItemRequest request);
  $async.Future<$1.ReconfigureItemResponse> reconfigureItem(
      $pb.ServerContext ctx, $1.ReconfigureItemRequest request);
  $async.Future<$1.GetItemResponse> getItem(
      $pb.ServerContext ctx, $1.GetItemRequest request);
  $async.Future<$1.ListItemsResponse> listItems(
      $pb.ServerContext ctx, $1.ListItemsRequest request);
  $async.Future<$1.AddSupplierResponse> addSupplier(
      $pb.ServerContext ctx, $1.AddSupplierRequest request);
  $async.Future<$1.SetSupplierApprovalResponse> setSupplierApproval(
      $pb.ServerContext ctx, $1.SetSupplierApprovalRequest request);
  $async.Future<$1.ListSuppliersResponse> listSuppliers(
      $pb.ServerContext ctx, $1.ListSuppliersRequest request);
  $async.Future<$1.SetStockLevelResponse> setStockLevel(
      $pb.ServerContext ctx, $1.SetStockLevelRequest request);
  $async.Future<$1.ListStockLevelsResponse> listStockLevels(
      $pb.ServerContext ctx, $1.ListStockLevelsRequest request);
  $async.Future<$1.AddApprovalRuleResponse> addApprovalRule(
      $pb.ServerContext ctx, $1.AddApprovalRuleRequest request);
  $async.Future<$1.ListApprovalRulesResponse> listApprovalRules(
      $pb.ServerContext ctx, $1.ListApprovalRulesRequest request);
  $async.Future<$1.RemoveApprovalRuleResponse> removeApprovalRule(
      $pb.ServerContext ctx, $1.RemoveApprovalRuleRequest request);
  $async.Future<$1.RaiseRequisitionResponse> raiseRequisition(
      $pb.ServerContext ctx, $1.RaiseRequisitionRequest request);
  $async.Future<$1.GetApprovalRouteResponse> getApprovalRoute(
      $pb.ServerContext ctx, $1.GetApprovalRouteRequest request);
  $async.Future<$1.SubmitRequisitionResponse> submitRequisition(
      $pb.ServerContext ctx, $1.SubmitRequisitionRequest request);
  $async.Future<$1.DecideRequisitionResponse> decideRequisition(
      $pb.ServerContext ctx, $1.DecideRequisitionRequest request);
  $async.Future<$1.GetRequisitionResponse> getRequisition(
      $pb.ServerContext ctx, $1.GetRequisitionRequest request);
  $async.Future<$1.ListRequisitionsResponse> listRequisitions(
      $pb.ServerContext ctx, $1.ListRequisitionsRequest request);
  $async.Future<$1.OpenRfqResponse> openRfq(
      $pb.ServerContext ctx, $1.OpenRfqRequest request);
  $async.Future<$1.RecordBidResponse> recordBid(
      $pb.ServerContext ctx, $1.RecordBidRequest request);
  $async.Future<$1.CompareBidsResponse> compareBids(
      $pb.ServerContext ctx, $1.CompareBidsRequest request);
  $async.Future<$1.GetRfqResponse> getRfq(
      $pb.ServerContext ctx, $1.GetRfqRequest request);
  $async.Future<$1.ListRfqsResponse> listRfqs(
      $pb.ServerContext ctx, $1.ListRfqsRequest request);
  $async.Future<$1.PlaceOrderResponse> placeOrder(
      $pb.ServerContext ctx, $1.PlaceOrderRequest request);
  $async.Future<$1.IssueOrderResponse> issueOrder(
      $pb.ServerContext ctx, $1.IssueOrderRequest request);
  $async.Future<$1.AmendOrderResponse> amendOrder(
      $pb.ServerContext ctx, $1.AmendOrderRequest request);
  $async.Future<$1.GetPurchaseOrderResponse> getPurchaseOrder(
      $pb.ServerContext ctx, $1.GetPurchaseOrderRequest request);
  $async.Future<$1.ListOrderRevisionsResponse> listOrderRevisions(
      $pb.ServerContext ctx, $1.ListOrderRevisionsRequest request);
  $async.Future<$1.ListPurchaseOrdersResponse> listPurchaseOrders(
      $pb.ServerContext ctx, $1.ListPurchaseOrdersRequest request);
  $async.Future<$1.ReceiveGoodsResponse> receiveGoods(
      $pb.ServerContext ctx, $1.ReceiveGoodsRequest request);
  $async.Future<$1.InspectResponse> inspect(
      $pb.ServerContext ctx, $1.InspectRequest request);
  $async.Future<$1.GetReceiptResponse> getReceipt(
      $pb.ServerContext ctx, $1.GetReceiptRequest request);
  $async.Future<$1.ListReceiptsResponse> listReceipts(
      $pb.ServerContext ctx, $1.ListReceiptsRequest request);
  $async.Future<$1.RecommendPickResponse> recommendPick(
      $pb.ServerContext ctx, $1.RecommendPickRequest request);
  $async.Future<$1.IssueStockResponse> issueStock(
      $pb.ServerContext ctx, $1.IssueStockRequest request);
  $async.Future<$1.ReturnStockResponse> returnStock(
      $pb.ServerContext ctx, $1.ReturnStockRequest request);
  $async.Future<$1.ListBalancesResponse> listBalances(
      $pb.ServerContext ctx, $1.ListBalancesRequest request);
  $async.Future<$1.GetAvailableResponse> getAvailable(
      $pb.ServerContext ctx, $1.GetAvailableRequest request);
  $async.Future<$1.ListMovementsResponse> listMovements(
      $pb.ServerContext ctx, $1.ListMovementsRequest request);
  $async.Future<$1.DispatchTransferResponse> dispatchTransfer(
      $pb.ServerContext ctx, $1.DispatchTransferRequest request);
  $async.Future<$1.ReceiveTransferResponse> receiveTransfer(
      $pb.ServerContext ctx, $1.ReceiveTransferRequest request);
  $async.Future<$1.ListTransfersInTransitResponse> listTransfersInTransit(
      $pb.ServerContext ctx, $1.ListTransfersInTransitRequest request);
  $async.Future<$1.OpenCountResponse> openCount(
      $pb.ServerContext ctx, $1.OpenCountRequest request);
  $async.Future<$1.RecordCountResponse> recordCount(
      $pb.ServerContext ctx, $1.RecordCountRequest request);
  $async.Future<$1.ApproveCountResponse> approveCount(
      $pb.ServerContext ctx, $1.ApproveCountRequest request);
  $async.Future<$1.RejectCountResponse> rejectCount(
      $pb.ServerContext ctx, $1.RejectCountRequest request);
  $async.Future<$1.GetCountResponse> getCount(
      $pb.ServerContext ctx, $1.GetCountRequest request);
  $async.Future<$1.ListCountsResponse> listCounts(
      $pb.ServerContext ctx, $1.ListCountsRequest request);
  $async.Future<$1.BlockLotResponse> blockLot(
      $pb.ServerContext ctx, $1.BlockLotRequest request);
  $async.Future<$1.ReleaseLotResponse> releaseLot(
      $pb.ServerContext ctx, $1.ReleaseLotRequest request);
  $async.Future<$1.GetRecallListResponse> getRecallList(
      $pb.ServerContext ctx, $1.GetRecallListRequest request);
  $async.Future<$1.ListBlockedLotsResponse> listBlockedLots(
      $pb.ServerContext ctx, $1.ListBlockedLotsRequest request);
  $async.Future<$1.GetLotResponse> getLot(
      $pb.ServerContext ctx, $1.GetLotRequest request);
  $async.Future<$1.ListLotsResponse> listLots(
      $pb.ServerContext ctx, $1.ListLotsRequest request);
  $async.Future<$1.ListAlertsResponse> listAlerts(
      $pb.ServerContext ctx, $1.ListAlertsRequest request);
  $async.Future<$1.SuggestOrderResponse> suggestOrder(
      $pb.ServerContext ctx, $1.SuggestOrderRequest request);
  $async.Future<$1.RecordInvoiceResponse> recordInvoice(
      $pb.ServerContext ctx, $1.RecordInvoiceRequest request);
  $async.Future<$1.MatchInvoiceResponse> matchInvoice(
      $pb.ServerContext ctx, $1.MatchInvoiceRequest request);
  $async.Future<$1.GetMetricsResponse> getMetrics(
      $pb.ServerContext ctx, $1.GetMetricsRequest request);
  $async.Future<$1.GetFillRateResponse> getFillRate(
      $pb.ServerContext ctx, $1.GetFillRateRequest request);
  $async.Future<$1.ListLiabilitiesResponse> listLiabilities(
      $pb.ServerContext ctx, $1.ListLiabilitiesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'AddItem':
        return $1.AddItemRequest();
      case 'ReconfigureItem':
        return $1.ReconfigureItemRequest();
      case 'GetItem':
        return $1.GetItemRequest();
      case 'ListItems':
        return $1.ListItemsRequest();
      case 'AddSupplier':
        return $1.AddSupplierRequest();
      case 'SetSupplierApproval':
        return $1.SetSupplierApprovalRequest();
      case 'ListSuppliers':
        return $1.ListSuppliersRequest();
      case 'SetStockLevel':
        return $1.SetStockLevelRequest();
      case 'ListStockLevels':
        return $1.ListStockLevelsRequest();
      case 'AddApprovalRule':
        return $1.AddApprovalRuleRequest();
      case 'ListApprovalRules':
        return $1.ListApprovalRulesRequest();
      case 'RemoveApprovalRule':
        return $1.RemoveApprovalRuleRequest();
      case 'RaiseRequisition':
        return $1.RaiseRequisitionRequest();
      case 'GetApprovalRoute':
        return $1.GetApprovalRouteRequest();
      case 'SubmitRequisition':
        return $1.SubmitRequisitionRequest();
      case 'DecideRequisition':
        return $1.DecideRequisitionRequest();
      case 'GetRequisition':
        return $1.GetRequisitionRequest();
      case 'ListRequisitions':
        return $1.ListRequisitionsRequest();
      case 'OpenRfq':
        return $1.OpenRfqRequest();
      case 'RecordBid':
        return $1.RecordBidRequest();
      case 'CompareBids':
        return $1.CompareBidsRequest();
      case 'GetRfq':
        return $1.GetRfqRequest();
      case 'ListRfqs':
        return $1.ListRfqsRequest();
      case 'PlaceOrder':
        return $1.PlaceOrderRequest();
      case 'IssueOrder':
        return $1.IssueOrderRequest();
      case 'AmendOrder':
        return $1.AmendOrderRequest();
      case 'GetPurchaseOrder':
        return $1.GetPurchaseOrderRequest();
      case 'ListOrderRevisions':
        return $1.ListOrderRevisionsRequest();
      case 'ListPurchaseOrders':
        return $1.ListPurchaseOrdersRequest();
      case 'ReceiveGoods':
        return $1.ReceiveGoodsRequest();
      case 'Inspect':
        return $1.InspectRequest();
      case 'GetReceipt':
        return $1.GetReceiptRequest();
      case 'ListReceipts':
        return $1.ListReceiptsRequest();
      case 'RecommendPick':
        return $1.RecommendPickRequest();
      case 'IssueStock':
        return $1.IssueStockRequest();
      case 'ReturnStock':
        return $1.ReturnStockRequest();
      case 'ListBalances':
        return $1.ListBalancesRequest();
      case 'GetAvailable':
        return $1.GetAvailableRequest();
      case 'ListMovements':
        return $1.ListMovementsRequest();
      case 'DispatchTransfer':
        return $1.DispatchTransferRequest();
      case 'ReceiveTransfer':
        return $1.ReceiveTransferRequest();
      case 'ListTransfersInTransit':
        return $1.ListTransfersInTransitRequest();
      case 'OpenCount':
        return $1.OpenCountRequest();
      case 'RecordCount':
        return $1.RecordCountRequest();
      case 'ApproveCount':
        return $1.ApproveCountRequest();
      case 'RejectCount':
        return $1.RejectCountRequest();
      case 'GetCount':
        return $1.GetCountRequest();
      case 'ListCounts':
        return $1.ListCountsRequest();
      case 'BlockLot':
        return $1.BlockLotRequest();
      case 'ReleaseLot':
        return $1.ReleaseLotRequest();
      case 'GetRecallList':
        return $1.GetRecallListRequest();
      case 'ListBlockedLots':
        return $1.ListBlockedLotsRequest();
      case 'GetLot':
        return $1.GetLotRequest();
      case 'ListLots':
        return $1.ListLotsRequest();
      case 'ListAlerts':
        return $1.ListAlertsRequest();
      case 'SuggestOrder':
        return $1.SuggestOrderRequest();
      case 'RecordInvoice':
        return $1.RecordInvoiceRequest();
      case 'MatchInvoice':
        return $1.MatchInvoiceRequest();
      case 'GetMetrics':
        return $1.GetMetricsRequest();
      case 'GetFillRate':
        return $1.GetFillRateRequest();
      case 'ListLiabilities':
        return $1.ListLiabilitiesRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'AddItem':
        return addItem(ctx, request as $1.AddItemRequest);
      case 'ReconfigureItem':
        return reconfigureItem(ctx, request as $1.ReconfigureItemRequest);
      case 'GetItem':
        return getItem(ctx, request as $1.GetItemRequest);
      case 'ListItems':
        return listItems(ctx, request as $1.ListItemsRequest);
      case 'AddSupplier':
        return addSupplier(ctx, request as $1.AddSupplierRequest);
      case 'SetSupplierApproval':
        return setSupplierApproval(
            ctx, request as $1.SetSupplierApprovalRequest);
      case 'ListSuppliers':
        return listSuppliers(ctx, request as $1.ListSuppliersRequest);
      case 'SetStockLevel':
        return setStockLevel(ctx, request as $1.SetStockLevelRequest);
      case 'ListStockLevels':
        return listStockLevels(ctx, request as $1.ListStockLevelsRequest);
      case 'AddApprovalRule':
        return addApprovalRule(ctx, request as $1.AddApprovalRuleRequest);
      case 'ListApprovalRules':
        return listApprovalRules(ctx, request as $1.ListApprovalRulesRequest);
      case 'RemoveApprovalRule':
        return removeApprovalRule(ctx, request as $1.RemoveApprovalRuleRequest);
      case 'RaiseRequisition':
        return raiseRequisition(ctx, request as $1.RaiseRequisitionRequest);
      case 'GetApprovalRoute':
        return getApprovalRoute(ctx, request as $1.GetApprovalRouteRequest);
      case 'SubmitRequisition':
        return submitRequisition(ctx, request as $1.SubmitRequisitionRequest);
      case 'DecideRequisition':
        return decideRequisition(ctx, request as $1.DecideRequisitionRequest);
      case 'GetRequisition':
        return getRequisition(ctx, request as $1.GetRequisitionRequest);
      case 'ListRequisitions':
        return listRequisitions(ctx, request as $1.ListRequisitionsRequest);
      case 'OpenRfq':
        return openRfq(ctx, request as $1.OpenRfqRequest);
      case 'RecordBid':
        return recordBid(ctx, request as $1.RecordBidRequest);
      case 'CompareBids':
        return compareBids(ctx, request as $1.CompareBidsRequest);
      case 'GetRfq':
        return getRfq(ctx, request as $1.GetRfqRequest);
      case 'ListRfqs':
        return listRfqs(ctx, request as $1.ListRfqsRequest);
      case 'PlaceOrder':
        return placeOrder(ctx, request as $1.PlaceOrderRequest);
      case 'IssueOrder':
        return issueOrder(ctx, request as $1.IssueOrderRequest);
      case 'AmendOrder':
        return amendOrder(ctx, request as $1.AmendOrderRequest);
      case 'GetPurchaseOrder':
        return getPurchaseOrder(ctx, request as $1.GetPurchaseOrderRequest);
      case 'ListOrderRevisions':
        return listOrderRevisions(ctx, request as $1.ListOrderRevisionsRequest);
      case 'ListPurchaseOrders':
        return listPurchaseOrders(ctx, request as $1.ListPurchaseOrdersRequest);
      case 'ReceiveGoods':
        return receiveGoods(ctx, request as $1.ReceiveGoodsRequest);
      case 'Inspect':
        return inspect(ctx, request as $1.InspectRequest);
      case 'GetReceipt':
        return getReceipt(ctx, request as $1.GetReceiptRequest);
      case 'ListReceipts':
        return listReceipts(ctx, request as $1.ListReceiptsRequest);
      case 'RecommendPick':
        return recommendPick(ctx, request as $1.RecommendPickRequest);
      case 'IssueStock':
        return issueStock(ctx, request as $1.IssueStockRequest);
      case 'ReturnStock':
        return returnStock(ctx, request as $1.ReturnStockRequest);
      case 'ListBalances':
        return listBalances(ctx, request as $1.ListBalancesRequest);
      case 'GetAvailable':
        return getAvailable(ctx, request as $1.GetAvailableRequest);
      case 'ListMovements':
        return listMovements(ctx, request as $1.ListMovementsRequest);
      case 'DispatchTransfer':
        return dispatchTransfer(ctx, request as $1.DispatchTransferRequest);
      case 'ReceiveTransfer':
        return receiveTransfer(ctx, request as $1.ReceiveTransferRequest);
      case 'ListTransfersInTransit':
        return listTransfersInTransit(
            ctx, request as $1.ListTransfersInTransitRequest);
      case 'OpenCount':
        return openCount(ctx, request as $1.OpenCountRequest);
      case 'RecordCount':
        return recordCount(ctx, request as $1.RecordCountRequest);
      case 'ApproveCount':
        return approveCount(ctx, request as $1.ApproveCountRequest);
      case 'RejectCount':
        return rejectCount(ctx, request as $1.RejectCountRequest);
      case 'GetCount':
        return getCount(ctx, request as $1.GetCountRequest);
      case 'ListCounts':
        return listCounts(ctx, request as $1.ListCountsRequest);
      case 'BlockLot':
        return blockLot(ctx, request as $1.BlockLotRequest);
      case 'ReleaseLot':
        return releaseLot(ctx, request as $1.ReleaseLotRequest);
      case 'GetRecallList':
        return getRecallList(ctx, request as $1.GetRecallListRequest);
      case 'ListBlockedLots':
        return listBlockedLots(ctx, request as $1.ListBlockedLotsRequest);
      case 'GetLot':
        return getLot(ctx, request as $1.GetLotRequest);
      case 'ListLots':
        return listLots(ctx, request as $1.ListLotsRequest);
      case 'ListAlerts':
        return listAlerts(ctx, request as $1.ListAlertsRequest);
      case 'SuggestOrder':
        return suggestOrder(ctx, request as $1.SuggestOrderRequest);
      case 'RecordInvoice':
        return recordInvoice(ctx, request as $1.RecordInvoiceRequest);
      case 'MatchInvoice':
        return matchInvoice(ctx, request as $1.MatchInvoiceRequest);
      case 'GetMetrics':
        return getMetrics(ctx, request as $1.GetMetricsRequest);
      case 'GetFillRate':
        return getFillRate(ctx, request as $1.GetFillRateRequest);
      case 'ListLiabilities':
        return listLiabilities(ctx, request as $1.ListLiabilitiesRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => MaterialsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MaterialsServiceBase$messageJson;
}
