// This is a generated file - do not edit.
//
// Generated from healthcare/orders/v1/orders.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'orders.pb.dart' as $1;
import 'orders.pbjson.dart';

export 'orders.pb.dart';

abstract class OrderServiceBase extends $pb.GeneratedService {
  $async.Future<$1.PlaceOrderResponse> placeOrder(
      $pb.ServerContext ctx, $1.PlaceOrderRequest request);
  $async.Future<$1.GetOrderResponse> getOrder(
      $pb.ServerContext ctx, $1.GetOrderRequest request);
  $async.Future<$1.ListOrdersResponse> listOrders(
      $pb.ServerContext ctx, $1.ListOrdersRequest request);
  $async.Future<$1.GetWorklistResponse> getWorklist(
      $pb.ServerContext ctx, $1.GetWorklistRequest request);
  $async.Future<$1.CancelOrderResponse> cancelOrder(
      $pb.ServerContext ctx, $1.CancelOrderRequest request);
  $async.Future<$1.RetractOrderResponse> retractOrder(
      $pb.ServerContext ctx, $1.RetractOrderRequest request);
  $async.Future<$1.AcknowledgeOrderResponse> acknowledgeOrder(
      $pb.ServerContext ctx, $1.AcknowledgeOrderRequest request);
  $async.Future<$1.DefineOrderSetResponse> defineOrderSet(
      $pb.ServerContext ctx, $1.DefineOrderSetRequest request);
  $async.Future<$1.ListOrderSetsResponse> listOrderSets(
      $pb.ServerContext ctx, $1.ListOrderSetsRequest request);
  $async.Future<$1.RetireOrderSetResponse> retireOrderSet(
      $pb.ServerContext ctx, $1.RetireOrderSetRequest request);
  $async.Future<$1.PlaceFromOrderSetResponse> placeFromOrderSet(
      $pb.ServerContext ctx, $1.PlaceFromOrderSetRequest request);
  $async.Future<$1.SaveFavouriteResponse> saveFavourite(
      $pb.ServerContext ctx, $1.SaveFavouriteRequest request);
  $async.Future<$1.ListFavouritesResponse> listFavourites(
      $pb.ServerContext ctx, $1.ListFavouritesRequest request);
  $async.Future<$1.DeleteFavouriteResponse> deleteFavourite(
      $pb.ServerContext ctx, $1.DeleteFavouriteRequest request);
  $async.Future<$1.PlaceFromFavouriteResponse> placeFromFavourite(
      $pb.ServerContext ctx, $1.PlaceFromFavouriteRequest request);
  $async.Future<$1.SetOrderPolicyResponse> setOrderPolicy(
      $pb.ServerContext ctx, $1.SetOrderPolicyRequest request);
  $async.Future<$1.SetDuplicateRuleResponse> setDuplicateRule(
      $pb.ServerContext ctx, $1.SetDuplicateRuleRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'PlaceOrder':
        return $1.PlaceOrderRequest();
      case 'GetOrder':
        return $1.GetOrderRequest();
      case 'ListOrders':
        return $1.ListOrdersRequest();
      case 'GetWorklist':
        return $1.GetWorklistRequest();
      case 'CancelOrder':
        return $1.CancelOrderRequest();
      case 'RetractOrder':
        return $1.RetractOrderRequest();
      case 'AcknowledgeOrder':
        return $1.AcknowledgeOrderRequest();
      case 'DefineOrderSet':
        return $1.DefineOrderSetRequest();
      case 'ListOrderSets':
        return $1.ListOrderSetsRequest();
      case 'RetireOrderSet':
        return $1.RetireOrderSetRequest();
      case 'PlaceFromOrderSet':
        return $1.PlaceFromOrderSetRequest();
      case 'SaveFavourite':
        return $1.SaveFavouriteRequest();
      case 'ListFavourites':
        return $1.ListFavouritesRequest();
      case 'DeleteFavourite':
        return $1.DeleteFavouriteRequest();
      case 'PlaceFromFavourite':
        return $1.PlaceFromFavouriteRequest();
      case 'SetOrderPolicy':
        return $1.SetOrderPolicyRequest();
      case 'SetDuplicateRule':
        return $1.SetDuplicateRuleRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'PlaceOrder':
        return placeOrder(ctx, request as $1.PlaceOrderRequest);
      case 'GetOrder':
        return getOrder(ctx, request as $1.GetOrderRequest);
      case 'ListOrders':
        return listOrders(ctx, request as $1.ListOrdersRequest);
      case 'GetWorklist':
        return getWorklist(ctx, request as $1.GetWorklistRequest);
      case 'CancelOrder':
        return cancelOrder(ctx, request as $1.CancelOrderRequest);
      case 'RetractOrder':
        return retractOrder(ctx, request as $1.RetractOrderRequest);
      case 'AcknowledgeOrder':
        return acknowledgeOrder(ctx, request as $1.AcknowledgeOrderRequest);
      case 'DefineOrderSet':
        return defineOrderSet(ctx, request as $1.DefineOrderSetRequest);
      case 'ListOrderSets':
        return listOrderSets(ctx, request as $1.ListOrderSetsRequest);
      case 'RetireOrderSet':
        return retireOrderSet(ctx, request as $1.RetireOrderSetRequest);
      case 'PlaceFromOrderSet':
        return placeFromOrderSet(ctx, request as $1.PlaceFromOrderSetRequest);
      case 'SaveFavourite':
        return saveFavourite(ctx, request as $1.SaveFavouriteRequest);
      case 'ListFavourites':
        return listFavourites(ctx, request as $1.ListFavouritesRequest);
      case 'DeleteFavourite':
        return deleteFavourite(ctx, request as $1.DeleteFavouriteRequest);
      case 'PlaceFromFavourite':
        return placeFromFavourite(ctx, request as $1.PlaceFromFavouriteRequest);
      case 'SetOrderPolicy':
        return setOrderPolicy(ctx, request as $1.SetOrderPolicyRequest);
      case 'SetDuplicateRule':
        return setDuplicateRule(ctx, request as $1.SetDuplicateRuleRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => OrderServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => OrderServiceBase$messageJson;
}
