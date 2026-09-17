// This is a generated file - do not edit.
//
// Generated from healthcare/icu/v1/icu.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'icu.pb.dart' as $1;
import 'icu.pbjson.dart';

export 'icu.pb.dart';

abstract class IcuServiceBase extends $pb.GeneratedService {
  $async.Future<$1.AdmitResponse> admit(
      $pb.ServerContext ctx, $1.AdmitRequest request);
  $async.Future<$1.GetIcuEpisodeResponse> getIcuEpisode(
      $pb.ServerContext ctx, $1.GetIcuEpisodeRequest request);
  $async.Future<$1.MoveBedResponse> moveBed(
      $pb.ServerContext ctx, $1.MoveBedRequest request);
  $async.Future<$1.DeclareReadyResponse> declareReady(
      $pb.ServerContext ctx, $1.DeclareReadyRequest request);
  $async.Future<$1.DischargeResponse> discharge(
      $pb.ServerContext ctx, $1.DischargeRequest request);
  $async.Future<$1.ChartValueResponse> chartValue(
      $pb.ServerContext ctx, $1.ChartValueRequest request);
  $async.Future<$1.DecideReadingResponse> decideReading(
      $pb.ServerContext ctx, $1.DecideReadingRequest request);
  $async.Future<$1.ListFlowsheetResponse> listFlowsheet(
      $pb.ServerContext ctx, $1.ListFlowsheetRequest request);
  $async.Future<$1.ListPendingReadingsResponse> listPendingReadings(
      $pb.ServerContext ctx, $1.ListPendingReadingsRequest request);
  $async.Future<$1.RecordBalanceResponse> recordBalance(
      $pb.ServerContext ctx, $1.RecordBalanceRequest request);
  $async.Future<$1.GetBalanceResponse> getBalance(
      $pb.ServerContext ctx, $1.GetBalanceRequest request);
  $async.Future<$1.StartSupportResponse> startSupport(
      $pb.ServerContext ctx, $1.StartSupportRequest request);
  $async.Future<$1.StopSupportResponse> stopSupport(
      $pb.ServerContext ctx, $1.StopSupportRequest request);
  $async.Future<$1.ListSupportResponse> listSupport(
      $pb.ServerContext ctx, $1.ListSupportRequest request);
  $async.Future<$1.RecordVentSettingResponse> recordVentSetting(
      $pb.ServerContext ctx, $1.RecordVentSettingRequest request);
  $async.Future<$1.GetVentTimelineResponse> getVentTimeline(
      $pb.ServerContext ctx, $1.GetVentTimelineRequest request);
  $async.Future<$1.StartInfusionResponse> startInfusion(
      $pb.ServerContext ctx, $1.StartInfusionRequest request);
  $async.Future<$1.TitrateResponse> titrate(
      $pb.ServerContext ctx, $1.TitrateRequest request);
  $async.Future<$1.StopInfusionResponse> stopInfusion(
      $pb.ServerContext ctx, $1.StopInfusionRequest request);
  $async.Future<$1.ListInfusionsResponse> listInfusions(
      $pb.ServerContext ctx, $1.ListInfusionsRequest request);
  $async.Future<$1.InsertDeviceResponse> insertDevice(
      $pb.ServerContext ctx, $1.InsertDeviceRequest request);
  $async.Future<$1.RemoveDeviceResponse> removeDevice(
      $pb.ServerContext ctx, $1.RemoveDeviceRequest request);
  $async.Future<$1.ReviewDeviceResponse> reviewDevice(
      $pb.ServerContext ctx, $1.ReviewDeviceRequest request);
  $async.Future<$1.ListDevicesResponse> listDevices(
      $pb.ServerContext ctx, $1.ListDevicesRequest request);
  $async.Future<$1.CalculateScoreResponse> calculateScore(
      $pb.ServerContext ctx, $1.CalculateScoreRequest request);
  $async.Future<$1.ListScoresResponse> listScores(
      $pb.ServerContext ctx, $1.ListScoresRequest request);
  $async.Future<$1.ReproduceScoreResponse> reproduceScore(
      $pb.ServerContext ctx, $1.ReproduceScoreRequest request);
  $async.Future<$1.PerformBundleResponse> performBundle(
      $pb.ServerContext ctx, $1.PerformBundleRequest request);
  $async.Future<$1.ListBundlesResponse> listBundles(
      $pb.ServerContext ctx, $1.ListBundlesRequest request);
  $async.Future<$1.RecordAssessmentResponse> recordAssessment(
      $pb.ServerContext ctx, $1.RecordAssessmentRequest request);
  $async.Future<$1.ListDueAssessmentsResponse> listDueAssessments(
      $pb.ServerContext ctx, $1.ListDueAssessmentsRequest request);
  $async.Future<$1.RecordRoundResponse> recordRound(
      $pb.ServerContext ctx, $1.RecordRoundRequest request);
  $async.Future<$1.ResolveGoalResponse> resolveGoal(
      $pb.ServerContext ctx, $1.ResolveGoalRequest request);
  $async.Future<$1.ListOpenGoalsResponse> listOpenGoals(
      $pb.ServerContext ctx, $1.ListOpenGoalsRequest request);
  $async.Future<$1.SetCeilingResponse> setCeiling(
      $pb.ServerContext ctx, $1.SetCeilingRequest request);
  $async.Future<$1.GetCeilingResponse> getCeiling(
      $pb.ServerContext ctx, $1.GetCeilingRequest request);
  $async.Future<$1.GetDashboardResponse> getDashboard(
      $pb.ServerContext ctx, $1.GetDashboardRequest request);
  $async.Future<$1.ListAdvisoriesResponse> listAdvisories(
      $pb.ServerContext ctx, $1.ListAdvisoriesRequest request);
  $async.Future<$1.EscalateAdvisoryResponse> escalateAdvisory(
      $pb.ServerContext ctx, $1.EscalateAdvisoryRequest request);
  $async.Future<$1.GetUnitMetricsResponse> getUnitMetrics(
      $pb.ServerContext ctx, $1.GetUnitMetricsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Admit':
        return $1.AdmitRequest();
      case 'GetIcuEpisode':
        return $1.GetIcuEpisodeRequest();
      case 'MoveBed':
        return $1.MoveBedRequest();
      case 'DeclareReady':
        return $1.DeclareReadyRequest();
      case 'Discharge':
        return $1.DischargeRequest();
      case 'ChartValue':
        return $1.ChartValueRequest();
      case 'DecideReading':
        return $1.DecideReadingRequest();
      case 'ListFlowsheet':
        return $1.ListFlowsheetRequest();
      case 'ListPendingReadings':
        return $1.ListPendingReadingsRequest();
      case 'RecordBalance':
        return $1.RecordBalanceRequest();
      case 'GetBalance':
        return $1.GetBalanceRequest();
      case 'StartSupport':
        return $1.StartSupportRequest();
      case 'StopSupport':
        return $1.StopSupportRequest();
      case 'ListSupport':
        return $1.ListSupportRequest();
      case 'RecordVentSetting':
        return $1.RecordVentSettingRequest();
      case 'GetVentTimeline':
        return $1.GetVentTimelineRequest();
      case 'StartInfusion':
        return $1.StartInfusionRequest();
      case 'Titrate':
        return $1.TitrateRequest();
      case 'StopInfusion':
        return $1.StopInfusionRequest();
      case 'ListInfusions':
        return $1.ListInfusionsRequest();
      case 'InsertDevice':
        return $1.InsertDeviceRequest();
      case 'RemoveDevice':
        return $1.RemoveDeviceRequest();
      case 'ReviewDevice':
        return $1.ReviewDeviceRequest();
      case 'ListDevices':
        return $1.ListDevicesRequest();
      case 'CalculateScore':
        return $1.CalculateScoreRequest();
      case 'ListScores':
        return $1.ListScoresRequest();
      case 'ReproduceScore':
        return $1.ReproduceScoreRequest();
      case 'PerformBundle':
        return $1.PerformBundleRequest();
      case 'ListBundles':
        return $1.ListBundlesRequest();
      case 'RecordAssessment':
        return $1.RecordAssessmentRequest();
      case 'ListDueAssessments':
        return $1.ListDueAssessmentsRequest();
      case 'RecordRound':
        return $1.RecordRoundRequest();
      case 'ResolveGoal':
        return $1.ResolveGoalRequest();
      case 'ListOpenGoals':
        return $1.ListOpenGoalsRequest();
      case 'SetCeiling':
        return $1.SetCeilingRequest();
      case 'GetCeiling':
        return $1.GetCeilingRequest();
      case 'GetDashboard':
        return $1.GetDashboardRequest();
      case 'ListAdvisories':
        return $1.ListAdvisoriesRequest();
      case 'EscalateAdvisory':
        return $1.EscalateAdvisoryRequest();
      case 'GetUnitMetrics':
        return $1.GetUnitMetricsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Admit':
        return admit(ctx, request as $1.AdmitRequest);
      case 'GetIcuEpisode':
        return getIcuEpisode(ctx, request as $1.GetIcuEpisodeRequest);
      case 'MoveBed':
        return moveBed(ctx, request as $1.MoveBedRequest);
      case 'DeclareReady':
        return declareReady(ctx, request as $1.DeclareReadyRequest);
      case 'Discharge':
        return discharge(ctx, request as $1.DischargeRequest);
      case 'ChartValue':
        return chartValue(ctx, request as $1.ChartValueRequest);
      case 'DecideReading':
        return decideReading(ctx, request as $1.DecideReadingRequest);
      case 'ListFlowsheet':
        return listFlowsheet(ctx, request as $1.ListFlowsheetRequest);
      case 'ListPendingReadings':
        return listPendingReadings(
            ctx, request as $1.ListPendingReadingsRequest);
      case 'RecordBalance':
        return recordBalance(ctx, request as $1.RecordBalanceRequest);
      case 'GetBalance':
        return getBalance(ctx, request as $1.GetBalanceRequest);
      case 'StartSupport':
        return startSupport(ctx, request as $1.StartSupportRequest);
      case 'StopSupport':
        return stopSupport(ctx, request as $1.StopSupportRequest);
      case 'ListSupport':
        return listSupport(ctx, request as $1.ListSupportRequest);
      case 'RecordVentSetting':
        return recordVentSetting(ctx, request as $1.RecordVentSettingRequest);
      case 'GetVentTimeline':
        return getVentTimeline(ctx, request as $1.GetVentTimelineRequest);
      case 'StartInfusion':
        return startInfusion(ctx, request as $1.StartInfusionRequest);
      case 'Titrate':
        return titrate(ctx, request as $1.TitrateRequest);
      case 'StopInfusion':
        return stopInfusion(ctx, request as $1.StopInfusionRequest);
      case 'ListInfusions':
        return listInfusions(ctx, request as $1.ListInfusionsRequest);
      case 'InsertDevice':
        return insertDevice(ctx, request as $1.InsertDeviceRequest);
      case 'RemoveDevice':
        return removeDevice(ctx, request as $1.RemoveDeviceRequest);
      case 'ReviewDevice':
        return reviewDevice(ctx, request as $1.ReviewDeviceRequest);
      case 'ListDevices':
        return listDevices(ctx, request as $1.ListDevicesRequest);
      case 'CalculateScore':
        return calculateScore(ctx, request as $1.CalculateScoreRequest);
      case 'ListScores':
        return listScores(ctx, request as $1.ListScoresRequest);
      case 'ReproduceScore':
        return reproduceScore(ctx, request as $1.ReproduceScoreRequest);
      case 'PerformBundle':
        return performBundle(ctx, request as $1.PerformBundleRequest);
      case 'ListBundles':
        return listBundles(ctx, request as $1.ListBundlesRequest);
      case 'RecordAssessment':
        return recordAssessment(ctx, request as $1.RecordAssessmentRequest);
      case 'ListDueAssessments':
        return listDueAssessments(ctx, request as $1.ListDueAssessmentsRequest);
      case 'RecordRound':
        return recordRound(ctx, request as $1.RecordRoundRequest);
      case 'ResolveGoal':
        return resolveGoal(ctx, request as $1.ResolveGoalRequest);
      case 'ListOpenGoals':
        return listOpenGoals(ctx, request as $1.ListOpenGoalsRequest);
      case 'SetCeiling':
        return setCeiling(ctx, request as $1.SetCeilingRequest);
      case 'GetCeiling':
        return getCeiling(ctx, request as $1.GetCeilingRequest);
      case 'GetDashboard':
        return getDashboard(ctx, request as $1.GetDashboardRequest);
      case 'ListAdvisories':
        return listAdvisories(ctx, request as $1.ListAdvisoriesRequest);
      case 'EscalateAdvisory':
        return escalateAdvisory(ctx, request as $1.EscalateAdvisoryRequest);
      case 'GetUnitMetrics':
        return getUnitMetrics(ctx, request as $1.GetUnitMetricsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IcuServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => IcuServiceBase$messageJson;
}
