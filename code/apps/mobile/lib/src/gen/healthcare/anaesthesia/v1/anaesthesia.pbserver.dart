// This is a generated file - do not edit.
//
// Generated from healthcare/anaesthesia/v1/anaesthesia.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'anaesthesia.pb.dart' as $1;
import 'anaesthesia.pbjson.dart';

export 'anaesthesia.pb.dart';

abstract class AnaesthesiaServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RecordAssessmentResponse> recordAssessment(
      $pb.ServerContext ctx, $1.RecordAssessmentRequest request);
  $async.Future<$1.ListAssessmentsResponse> listAssessments(
      $pb.ServerContext ctx, $1.ListAssessmentsRequest request);
  $async.Future<$1.ListPatientAssessmentsResponse> listPatientAssessments(
      $pb.ServerContext ctx, $1.ListPatientAssessmentsRequest request);
  $async.Future<$1.RecordPlanResponse> recordPlan(
      $pb.ServerContext ctx, $1.RecordPlanRequest request);
  $async.Future<$1.GetPlanResponse> getPlan(
      $pb.ServerContext ctx, $1.GetPlanRequest request);
  $async.Future<$1.GetReadinessResponse> getReadiness(
      $pb.ServerContext ctx, $1.GetReadinessRequest request);
  $async.Future<$1.OpenRecordResponse> openRecord(
      $pb.ServerContext ctx, $1.OpenRecordRequest request);
  $async.Future<$1.GetRecordResponse> getRecord(
      $pb.ServerContext ctx, $1.GetRecordRequest request);
  $async.Future<$1.GetRecordForCaseResponse> getRecordForCase(
      $pb.ServerContext ctx, $1.GetRecordForCaseRequest request);
  $async.Future<$1.EndAnaesthesiaResponse> endAnaesthesia(
      $pb.ServerContext ctx, $1.EndAnaesthesiaRequest request);
  $async.Future<$1.ChartVitalResponse> chartVital(
      $pb.ServerContext ctx, $1.ChartVitalRequest request);
  $async.Future<$1.ListVitalsResponse> listVitals(
      $pb.ServerContext ctx, $1.ListVitalsRequest request);
  $async.Future<$1.ChartDrugResponse> chartDrug(
      $pb.ServerContext ctx, $1.ChartDrugRequest request);
  $async.Future<$1.ListDrugsResponse> listDrugs(
      $pb.ServerContext ctx, $1.ListDrugsRequest request);
  $async.Future<$1.StopInfusionResponse> stopInfusion(
      $pb.ServerContext ctx, $1.StopInfusionRequest request);
  $async.Future<$1.RecordAirwayResponse> recordAirway(
      $pb.ServerContext ctx, $1.RecordAirwayRequest request);
  $async.Future<$1.GetAirwayResponse> getAirway(
      $pb.ServerContext ctx, $1.GetAirwayRequest request);
  $async.Future<$1.GetPatientAirwayResponse> getPatientAirway(
      $pb.ServerContext ctx, $1.GetPatientAirwayRequest request);
  $async.Future<$1.ChartFluidResponse> chartFluid(
      $pb.ServerContext ctx, $1.ChartFluidRequest request);
  $async.Future<$1.GetBalanceResponse> getBalance(
      $pb.ServerContext ctx, $1.GetBalanceRequest request);
  $async.Future<$1.HandOverResponse> handOver(
      $pb.ServerContext ctx, $1.HandOverRequest request);
  $async.Future<$1.ListHandoversResponse> listHandovers(
      $pb.ServerContext ctx, $1.ListHandoversRequest request);
  $async.Future<$1.GetRecoveryScaleResponse> getRecoveryScale(
      $pb.ServerContext ctx, $1.GetRecoveryScaleRequest request);
  $async.Future<$1.AssessRecoveryResponse> assessRecovery(
      $pb.ServerContext ctx, $1.AssessRecoveryRequest request);
  $async.Future<$1.ListRecoveryAssessmentsResponse> listRecoveryAssessments(
      $pb.ServerContext ctx, $1.ListRecoveryAssessmentsRequest request);
  $async.Future<$1.EvaluateDischargeResponse> evaluateDischarge(
      $pb.ServerContext ctx, $1.EvaluateDischargeRequest request);
  $async.Future<$1.DischargeFromRecoveryResponse> dischargeFromRecovery(
      $pb.ServerContext ctx, $1.DischargeFromRecoveryRequest request);
  $async.Future<$1.OrderPainResponse> orderPain(
      $pb.ServerContext ctx, $1.OrderPainRequest request);
  $async.Future<$1.ListPainOrdersResponse> listPainOrders(
      $pb.ServerContext ctx, $1.ListPainOrdersRequest request);
  $async.Future<$1.GetPainRoundResponse> getPainRound(
      $pb.ServerContext ctx, $1.GetPainRoundRequest request);
  $async.Future<$1.StopPainResponse> stopPain(
      $pb.ServerContext ctx, $1.StopPainRequest request);
  $async.Future<$1.GetSummaryResponse> getSummary(
      $pb.ServerContext ctx, $1.GetSummaryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RecordAssessment':
        return $1.RecordAssessmentRequest();
      case 'ListAssessments':
        return $1.ListAssessmentsRequest();
      case 'ListPatientAssessments':
        return $1.ListPatientAssessmentsRequest();
      case 'RecordPlan':
        return $1.RecordPlanRequest();
      case 'GetPlan':
        return $1.GetPlanRequest();
      case 'GetReadiness':
        return $1.GetReadinessRequest();
      case 'OpenRecord':
        return $1.OpenRecordRequest();
      case 'GetRecord':
        return $1.GetRecordRequest();
      case 'GetRecordForCase':
        return $1.GetRecordForCaseRequest();
      case 'EndAnaesthesia':
        return $1.EndAnaesthesiaRequest();
      case 'ChartVital':
        return $1.ChartVitalRequest();
      case 'ListVitals':
        return $1.ListVitalsRequest();
      case 'ChartDrug':
        return $1.ChartDrugRequest();
      case 'ListDrugs':
        return $1.ListDrugsRequest();
      case 'StopInfusion':
        return $1.StopInfusionRequest();
      case 'RecordAirway':
        return $1.RecordAirwayRequest();
      case 'GetAirway':
        return $1.GetAirwayRequest();
      case 'GetPatientAirway':
        return $1.GetPatientAirwayRequest();
      case 'ChartFluid':
        return $1.ChartFluidRequest();
      case 'GetBalance':
        return $1.GetBalanceRequest();
      case 'HandOver':
        return $1.HandOverRequest();
      case 'ListHandovers':
        return $1.ListHandoversRequest();
      case 'GetRecoveryScale':
        return $1.GetRecoveryScaleRequest();
      case 'AssessRecovery':
        return $1.AssessRecoveryRequest();
      case 'ListRecoveryAssessments':
        return $1.ListRecoveryAssessmentsRequest();
      case 'EvaluateDischarge':
        return $1.EvaluateDischargeRequest();
      case 'DischargeFromRecovery':
        return $1.DischargeFromRecoveryRequest();
      case 'OrderPain':
        return $1.OrderPainRequest();
      case 'ListPainOrders':
        return $1.ListPainOrdersRequest();
      case 'GetPainRound':
        return $1.GetPainRoundRequest();
      case 'StopPain':
        return $1.StopPainRequest();
      case 'GetSummary':
        return $1.GetSummaryRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RecordAssessment':
        return recordAssessment(ctx, request as $1.RecordAssessmentRequest);
      case 'ListAssessments':
        return listAssessments(ctx, request as $1.ListAssessmentsRequest);
      case 'ListPatientAssessments':
        return listPatientAssessments(
            ctx, request as $1.ListPatientAssessmentsRequest);
      case 'RecordPlan':
        return recordPlan(ctx, request as $1.RecordPlanRequest);
      case 'GetPlan':
        return getPlan(ctx, request as $1.GetPlanRequest);
      case 'GetReadiness':
        return getReadiness(ctx, request as $1.GetReadinessRequest);
      case 'OpenRecord':
        return openRecord(ctx, request as $1.OpenRecordRequest);
      case 'GetRecord':
        return getRecord(ctx, request as $1.GetRecordRequest);
      case 'GetRecordForCase':
        return getRecordForCase(ctx, request as $1.GetRecordForCaseRequest);
      case 'EndAnaesthesia':
        return endAnaesthesia(ctx, request as $1.EndAnaesthesiaRequest);
      case 'ChartVital':
        return chartVital(ctx, request as $1.ChartVitalRequest);
      case 'ListVitals':
        return listVitals(ctx, request as $1.ListVitalsRequest);
      case 'ChartDrug':
        return chartDrug(ctx, request as $1.ChartDrugRequest);
      case 'ListDrugs':
        return listDrugs(ctx, request as $1.ListDrugsRequest);
      case 'StopInfusion':
        return stopInfusion(ctx, request as $1.StopInfusionRequest);
      case 'RecordAirway':
        return recordAirway(ctx, request as $1.RecordAirwayRequest);
      case 'GetAirway':
        return getAirway(ctx, request as $1.GetAirwayRequest);
      case 'GetPatientAirway':
        return getPatientAirway(ctx, request as $1.GetPatientAirwayRequest);
      case 'ChartFluid':
        return chartFluid(ctx, request as $1.ChartFluidRequest);
      case 'GetBalance':
        return getBalance(ctx, request as $1.GetBalanceRequest);
      case 'HandOver':
        return handOver(ctx, request as $1.HandOverRequest);
      case 'ListHandovers':
        return listHandovers(ctx, request as $1.ListHandoversRequest);
      case 'GetRecoveryScale':
        return getRecoveryScale(ctx, request as $1.GetRecoveryScaleRequest);
      case 'AssessRecovery':
        return assessRecovery(ctx, request as $1.AssessRecoveryRequest);
      case 'ListRecoveryAssessments':
        return listRecoveryAssessments(
            ctx, request as $1.ListRecoveryAssessmentsRequest);
      case 'EvaluateDischarge':
        return evaluateDischarge(ctx, request as $1.EvaluateDischargeRequest);
      case 'DischargeFromRecovery':
        return dischargeFromRecovery(
            ctx, request as $1.DischargeFromRecoveryRequest);
      case 'OrderPain':
        return orderPain(ctx, request as $1.OrderPainRequest);
      case 'ListPainOrders':
        return listPainOrders(ctx, request as $1.ListPainOrdersRequest);
      case 'GetPainRound':
        return getPainRound(ctx, request as $1.GetPainRoundRequest);
      case 'StopPain':
        return stopPain(ctx, request as $1.StopPainRequest);
      case 'GetSummary':
        return getSummary(ctx, request as $1.GetSummaryRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      AnaesthesiaServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AnaesthesiaServiceBase$messageJson;
}
