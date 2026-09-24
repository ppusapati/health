// This is a generated file - do not edit.
//
// Generated from healthcare/hospital_ops_diet/v1/diet.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'diet.pb.dart' as $1;
import 'diet.pbjson.dart';

export 'diet.pb.dart';

abstract class DietServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RecordAssessmentResponse> recordAssessment(
      $pb.ServerContext ctx, $1.RecordAssessmentRequest request);
  $async.Future<$1.SignAssessmentResponse> signAssessment(
      $pb.ServerContext ctx, $1.SignAssessmentRequest request);
  $async.Future<$1.ListAssessmentsResponse> listAssessments(
      $pb.ServerContext ctx, $1.ListAssessmentsRequest request);
  $async.Future<$1.OpenCarePlanResponse> openCarePlan(
      $pb.ServerContext ctx, $1.OpenCarePlanRequest request);
  $async.Future<$1.RecordProgressResponse> recordProgress(
      $pb.ServerContext ctx, $1.RecordProgressRequest request);
  $async.Future<$1.CloseCarePlanResponse> closeCarePlan(
      $pb.ServerContext ctx, $1.CloseCarePlanRequest request);
  $async.Future<$1.ListCarePlansResponse> listCarePlans(
      $pb.ServerContext ctx, $1.ListCarePlansRequest request);
  $async.Future<$1.GetGoalTrendResponse> getGoalTrend(
      $pb.ServerContext ctx, $1.GetGoalTrendRequest request);
  $async.Future<$1.PlaceDietOrderResponse> placeDietOrder(
      $pb.ServerContext ctx, $1.PlaceDietOrderRequest request);
  $async.Future<$1.ResolveConflictResponse> resolveConflict(
      $pb.ServerContext ctx, $1.ResolveConflictRequest request);
  $async.Future<$1.CancelDietOrderResponse> cancelDietOrder(
      $pb.ServerContext ctx, $1.CancelDietOrderRequest request);
  $async.Future<$1.GetCurrentDietOrderResponse> getCurrentDietOrder(
      $pb.ServerContext ctx, $1.GetCurrentDietOrderRequest request);
  $async.Future<$1.ListDietOrdersResponse> listDietOrders(
      $pb.ServerContext ctx, $1.ListDietOrdersRequest request);
  $async.Future<$1.PlanNutritionSupportResponse> planNutritionSupport(
      $pb.ServerContext ctx, $1.PlanNutritionSupportRequest request);
  $async.Future<$1.LinkSupportOrderResponse> linkSupportOrder(
      $pb.ServerContext ctx, $1.LinkSupportOrderRequest request);
  $async.Future<$1.StopSupportResponse> stopSupport(
      $pb.ServerContext ctx, $1.StopSupportRequest request);
  $async.Future<$1.ListSupportPlansResponse> listSupportPlans(
      $pb.ServerContext ctx, $1.ListSupportPlansRequest request);
  $async.Future<$1.BuildCensusResponse> buildCensus(
      $pb.ServerContext ctx, $1.BuildCensusRequest request);
  $async.Future<$1.FreezeCensusResponse> freezeCensus(
      $pb.ServerContext ctx, $1.FreezeCensusRequest request);
  $async.Future<$1.ReissueCensusResponse> reissueCensus(
      $pb.ServerContext ctx, $1.ReissueCensusRequest request);
  $async.Future<$1.ListCensusesResponse> listCensuses(
      $pb.ServerContext ctx, $1.ListCensusesRequest request);
  $async.Future<$1.PlateTraysResponse> plateTrays(
      $pb.ServerContext ctx, $1.PlateTraysRequest request);
  $async.Future<$1.PrepareTrayResponse> prepareTray(
      $pb.ServerContext ctx, $1.PrepareTrayRequest request);
  $async.Future<$1.DispatchTrayResponse> dispatchTray(
      $pb.ServerContext ctx, $1.DispatchTrayRequest request);
  $async.Future<$1.DeliverTrayResponse> deliverTray(
      $pb.ServerContext ctx, $1.DeliverTrayRequest request);
  $async.Future<$1.CloseTrayResponse> closeTray(
      $pb.ServerContext ctx, $1.CloseTrayRequest request);
  $async.Future<$1.ListTraysResponse> listTrays(
      $pb.ServerContext ctx, $1.ListTraysRequest request);
  $async.Future<$1.GetMealOutcomeResponse> getMealOutcome(
      $pb.ServerContext ctx, $1.GetMealOutcomeRequest request);
  $async.Future<$1.ConfigureItemResponse> configureItem(
      $pb.ServerContext ctx, $1.ConfigureItemRequest request);
  $async.Future<$1.ConfigureRecipeResponse> configureRecipe(
      $pb.ServerContext ctx, $1.ConfigureRecipeRequest request);
  $async.Future<$1.ConfigureMenuItemResponse> configureMenuItem(
      $pb.ServerContext ctx, $1.ConfigureMenuItemRequest request);
  $async.Future<$1.ListMenuResponse> listMenu(
      $pb.ServerContext ctx, $1.ListMenuRequest request);
  $async.Future<$1.RecordConsumptionResponse> recordConsumption(
      $pb.ServerContext ctx, $1.RecordConsumptionRequest request);
  $async.Future<$1.GetIngredientForecastResponse> getIngredientForecast(
      $pb.ServerContext ctx, $1.GetIngredientForecastRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RecordAssessment':
        return $1.RecordAssessmentRequest();
      case 'SignAssessment':
        return $1.SignAssessmentRequest();
      case 'ListAssessments':
        return $1.ListAssessmentsRequest();
      case 'OpenCarePlan':
        return $1.OpenCarePlanRequest();
      case 'RecordProgress':
        return $1.RecordProgressRequest();
      case 'CloseCarePlan':
        return $1.CloseCarePlanRequest();
      case 'ListCarePlans':
        return $1.ListCarePlansRequest();
      case 'GetGoalTrend':
        return $1.GetGoalTrendRequest();
      case 'PlaceDietOrder':
        return $1.PlaceDietOrderRequest();
      case 'ResolveConflict':
        return $1.ResolveConflictRequest();
      case 'CancelDietOrder':
        return $1.CancelDietOrderRequest();
      case 'GetCurrentDietOrder':
        return $1.GetCurrentDietOrderRequest();
      case 'ListDietOrders':
        return $1.ListDietOrdersRequest();
      case 'PlanNutritionSupport':
        return $1.PlanNutritionSupportRequest();
      case 'LinkSupportOrder':
        return $1.LinkSupportOrderRequest();
      case 'StopSupport':
        return $1.StopSupportRequest();
      case 'ListSupportPlans':
        return $1.ListSupportPlansRequest();
      case 'BuildCensus':
        return $1.BuildCensusRequest();
      case 'FreezeCensus':
        return $1.FreezeCensusRequest();
      case 'ReissueCensus':
        return $1.ReissueCensusRequest();
      case 'ListCensuses':
        return $1.ListCensusesRequest();
      case 'PlateTrays':
        return $1.PlateTraysRequest();
      case 'PrepareTray':
        return $1.PrepareTrayRequest();
      case 'DispatchTray':
        return $1.DispatchTrayRequest();
      case 'DeliverTray':
        return $1.DeliverTrayRequest();
      case 'CloseTray':
        return $1.CloseTrayRequest();
      case 'ListTrays':
        return $1.ListTraysRequest();
      case 'GetMealOutcome':
        return $1.GetMealOutcomeRequest();
      case 'ConfigureItem':
        return $1.ConfigureItemRequest();
      case 'ConfigureRecipe':
        return $1.ConfigureRecipeRequest();
      case 'ConfigureMenuItem':
        return $1.ConfigureMenuItemRequest();
      case 'ListMenu':
        return $1.ListMenuRequest();
      case 'RecordConsumption':
        return $1.RecordConsumptionRequest();
      case 'GetIngredientForecast':
        return $1.GetIngredientForecastRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RecordAssessment':
        return recordAssessment(ctx, request as $1.RecordAssessmentRequest);
      case 'SignAssessment':
        return signAssessment(ctx, request as $1.SignAssessmentRequest);
      case 'ListAssessments':
        return listAssessments(ctx, request as $1.ListAssessmentsRequest);
      case 'OpenCarePlan':
        return openCarePlan(ctx, request as $1.OpenCarePlanRequest);
      case 'RecordProgress':
        return recordProgress(ctx, request as $1.RecordProgressRequest);
      case 'CloseCarePlan':
        return closeCarePlan(ctx, request as $1.CloseCarePlanRequest);
      case 'ListCarePlans':
        return listCarePlans(ctx, request as $1.ListCarePlansRequest);
      case 'GetGoalTrend':
        return getGoalTrend(ctx, request as $1.GetGoalTrendRequest);
      case 'PlaceDietOrder':
        return placeDietOrder(ctx, request as $1.PlaceDietOrderRequest);
      case 'ResolveConflict':
        return resolveConflict(ctx, request as $1.ResolveConflictRequest);
      case 'CancelDietOrder':
        return cancelDietOrder(ctx, request as $1.CancelDietOrderRequest);
      case 'GetCurrentDietOrder':
        return getCurrentDietOrder(
            ctx, request as $1.GetCurrentDietOrderRequest);
      case 'ListDietOrders':
        return listDietOrders(ctx, request as $1.ListDietOrdersRequest);
      case 'PlanNutritionSupport':
        return planNutritionSupport(
            ctx, request as $1.PlanNutritionSupportRequest);
      case 'LinkSupportOrder':
        return linkSupportOrder(ctx, request as $1.LinkSupportOrderRequest);
      case 'StopSupport':
        return stopSupport(ctx, request as $1.StopSupportRequest);
      case 'ListSupportPlans':
        return listSupportPlans(ctx, request as $1.ListSupportPlansRequest);
      case 'BuildCensus':
        return buildCensus(ctx, request as $1.BuildCensusRequest);
      case 'FreezeCensus':
        return freezeCensus(ctx, request as $1.FreezeCensusRequest);
      case 'ReissueCensus':
        return reissueCensus(ctx, request as $1.ReissueCensusRequest);
      case 'ListCensuses':
        return listCensuses(ctx, request as $1.ListCensusesRequest);
      case 'PlateTrays':
        return plateTrays(ctx, request as $1.PlateTraysRequest);
      case 'PrepareTray':
        return prepareTray(ctx, request as $1.PrepareTrayRequest);
      case 'DispatchTray':
        return dispatchTray(ctx, request as $1.DispatchTrayRequest);
      case 'DeliverTray':
        return deliverTray(ctx, request as $1.DeliverTrayRequest);
      case 'CloseTray':
        return closeTray(ctx, request as $1.CloseTrayRequest);
      case 'ListTrays':
        return listTrays(ctx, request as $1.ListTraysRequest);
      case 'GetMealOutcome':
        return getMealOutcome(ctx, request as $1.GetMealOutcomeRequest);
      case 'ConfigureItem':
        return configureItem(ctx, request as $1.ConfigureItemRequest);
      case 'ConfigureRecipe':
        return configureRecipe(ctx, request as $1.ConfigureRecipeRequest);
      case 'ConfigureMenuItem':
        return configureMenuItem(ctx, request as $1.ConfigureMenuItemRequest);
      case 'ListMenu':
        return listMenu(ctx, request as $1.ListMenuRequest);
      case 'RecordConsumption':
        return recordConsumption(ctx, request as $1.RecordConsumptionRequest);
      case 'GetIngredientForecast':
        return getIngredientForecast(
            ctx, request as $1.GetIngredientForecastRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => DietServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => DietServiceBase$messageJson;
}
