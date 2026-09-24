// This is a generated file - do not edit.
//
// Generated from healthcare/infection/v1/infection.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'infection.pb.dart' as $1;
import 'infection.pbjson.dart';

export 'infection.pb.dart';

abstract class InfectionServiceBase extends $pb.GeneratedService {
  $async.Future<$1.OpenCaseResponse> openCase(
      $pb.ServerContext ctx, $1.OpenCaseRequest request);
  $async.Future<$1.ReviewCaseResponse> reviewCase(
      $pb.ServerContext ctx, $1.ReviewCaseRequest request);
  $async.Future<$1.OverrideOnsetResponse> overrideOnset(
      $pb.ServerContext ctx, $1.OverrideOnsetRequest request);
  $async.Future<$1.ListCasesResponse> listCases(
      $pb.ServerContext ctx, $1.ListCasesRequest request);
  $async.Future<$1.RecordDeviceDaysResponse> recordDeviceDays(
      $pb.ServerContext ctx, $1.RecordDeviceDaysRequest request);
  $async.Future<$1.GetRateResponse> getRate(
      $pb.ServerContext ctx, $1.GetRateRequest request);
  $async.Future<$1.StartIsolationResponse> startIsolation(
      $pb.ServerContext ctx, $1.StartIsolationRequest request);
  $async.Future<$1.ExtendIsolationResponse> extendIsolation(
      $pb.ServerContext ctx, $1.ExtendIsolationRequest request);
  $async.Future<$1.EndIsolationResponse> endIsolation(
      $pb.ServerContext ctx, $1.EndIsolationRequest request);
  $async.Future<$1.GetBoardResponse> getBoard(
      $pb.ServerContext ctx, $1.GetBoardRequest request);
  $async.Future<$1.DraftAlertRuleResponse> draftAlertRule(
      $pb.ServerContext ctx, $1.DraftAlertRuleRequest request);
  $async.Future<$1.ApproveAlertRuleResponse> approveAlertRule(
      $pb.ServerContext ctx, $1.ApproveAlertRuleRequest request);
  $async.Future<$1.ScreenEncounterResponse> screenEncounter(
      $pb.ServerContext ctx, $1.ScreenEncounterRequest request);
  $async.Future<$1.AcknowledgeAlertResponse> acknowledgeAlert(
      $pb.ServerContext ctx, $1.AcknowledgeAlertRequest request);
  $async.Future<$1.OverrideAlertResponse> overrideAlert(
      $pb.ServerContext ctx, $1.OverrideAlertRequest request);
  $async.Future<$1.ListAlertsResponse> listAlerts(
      $pb.ServerContext ctx, $1.ListAlertsRequest request);
  $async.Future<$1.OpenOutbreakResponse> openOutbreak(
      $pb.ServerContext ctx, $1.OpenOutbreakRequest request);
  $async.Future<$1.AdvanceOutbreakResponse> advanceOutbreak(
      $pb.ServerContext ctx, $1.AdvanceOutbreakRequest request);
  $async.Future<$1.CloseOutbreakResponse> closeOutbreak(
      $pb.ServerContext ctx, $1.CloseOutbreakRequest request);
  $async.Future<$1.AddOutbreakMemberResponse> addOutbreakMember(
      $pb.ServerContext ctx, $1.AddOutbreakMemberRequest request);
  $async.Future<$1.GetClusterResponse> getCluster(
      $pb.ServerContext ctx, $1.GetClusterRequest request);
  $async.Future<$1.ListOutbreaksResponse> listOutbreaks(
      $pb.ServerContext ctx, $1.ListOutbreaksRequest request);
  $async.Future<$1.StartHygieneSessionResponse> startHygieneSession(
      $pb.ServerContext ctx, $1.StartHygieneSessionRequest request);
  $async.Future<$1.RecordObservationResponse> recordObservation(
      $pb.ServerContext ctx, $1.RecordObservationRequest request);
  $async.Future<$1.EndHygieneSessionResponse> endHygieneSession(
      $pb.ServerContext ctx, $1.EndHygieneSessionRequest request);
  $async.Future<$1.GetHygieneComplianceResponse> getHygieneCompliance(
      $pb.ServerContext ctx, $1.GetHygieneComplianceRequest request);
  $async.Future<$1.ReportExposureResponse> reportExposure(
      $pb.ServerContext ctx, $1.ReportExposureRequest request);
  $async.Future<$1.GetExposureResponse> getExposure(
      $pb.ServerContext ctx, $1.GetExposureRequest request);
  $async.Future<$1.CompleteExposureTaskResponse> completeExposureTask(
      $pb.ServerContext ctx, $1.CompleteExposureTaskRequest request);
  $async.Future<$1.CloseExposureResponse> closeExposure(
      $pb.ServerContext ctx, $1.CloseExposureRequest request);
  $async.Future<$1.ListExposuresResponse> listExposures(
      $pb.ServerContext ctx, $1.ListExposuresRequest request);
  $async.Future<$1.SweepExposureTasksResponse> sweepExposureTasks(
      $pb.ServerContext ctx, $1.SweepExposureTasksRequest request);
  $async.Future<$1.DraftStewardshipRuleResponse> draftStewardshipRule(
      $pb.ServerContext ctx, $1.DraftStewardshipRuleRequest request);
  $async.Future<$1.ApproveStewardshipRuleResponse> approveStewardshipRule(
      $pb.ServerContext ctx, $1.ApproveStewardshipRuleRequest request);
  $async.Future<$1.ReviewEncounterResponse> reviewEncounter(
      $pb.ServerContext ctx, $1.ReviewEncounterRequest request);
  $async.Future<$1.AdviseReviewResponse> adviseReview(
      $pb.ServerContext ctx, $1.AdviseReviewRequest request);
  $async.Future<$1.RespondToReviewResponse> respondToReview(
      $pb.ServerContext ctx, $1.RespondToReviewRequest request);
  $async.Future<$1.WithdrawReviewResponse> withdrawReview(
      $pb.ServerContext ctx, $1.WithdrawReviewRequest request);
  $async.Future<$1.ListReviewsResponse> listReviews(
      $pb.ServerContext ctx, $1.ListReviewsRequest request);
  $async.Future<$1.GetStewardshipIndicatorsResponse> getStewardshipIndicators(
      $pb.ServerContext ctx, $1.GetStewardshipIndicatorsRequest request);
  $async.Future<$1.DraftLimitResponse> draftLimit(
      $pb.ServerContext ctx, $1.DraftLimitRequest request);
  $async.Future<$1.ApproveLimitResponse> approveLimit(
      $pb.ServerContext ctx, $1.ApproveLimitRequest request);
  $async.Future<$1.AddSamplingPlanResponse> addSamplingPlan(
      $pb.ServerContext ctx, $1.AddSamplingPlanRequest request);
  $async.Future<$1.CollectSampleResponse> collectSample(
      $pb.ServerContext ctx, $1.CollectSampleRequest request);
  $async.Future<$1.RecordSampleResultResponse> recordSampleResult(
      $pb.ServerContext ctx, $1.RecordSampleResultRequest request);
  $async.Future<$1.RaiseCorrectiveActionResponse> raiseCorrectiveAction(
      $pb.ServerContext ctx, $1.RaiseCorrectiveActionRequest request);
  $async.Future<$1.CompleteCorrectiveActionResponse> completeCorrectiveAction(
      $pb.ServerContext ctx, $1.CompleteCorrectiveActionRequest request);
  $async.Future<$1.VerifyCorrectiveActionResponse> verifyCorrectiveAction(
      $pb.ServerContext ctx, $1.VerifyCorrectiveActionRequest request);
  $async.Future<$1.CloseSampleResponse> closeSample(
      $pb.ServerContext ctx, $1.CloseSampleRequest request);
  $async.Future<$1.ListDueSamplingResponse> listDueSampling(
      $pb.ServerContext ctx, $1.ListDueSamplingRequest request);
  $async.Future<$1.ListSamplesResponse> listSamples(
      $pb.ServerContext ctx, $1.ListSamplesRequest request);
  $async.Future<$1.ListCorrectiveActionsResponse> listCorrectiveActions(
      $pb.ServerContext ctx, $1.ListCorrectiveActionsRequest request);
  $async.Future<$1.GetEnvironmentSummaryResponse> getEnvironmentSummary(
      $pb.ServerContext ctx, $1.GetEnvironmentSummaryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'OpenCase':
        return $1.OpenCaseRequest();
      case 'ReviewCase':
        return $1.ReviewCaseRequest();
      case 'OverrideOnset':
        return $1.OverrideOnsetRequest();
      case 'ListCases':
        return $1.ListCasesRequest();
      case 'RecordDeviceDays':
        return $1.RecordDeviceDaysRequest();
      case 'GetRate':
        return $1.GetRateRequest();
      case 'StartIsolation':
        return $1.StartIsolationRequest();
      case 'ExtendIsolation':
        return $1.ExtendIsolationRequest();
      case 'EndIsolation':
        return $1.EndIsolationRequest();
      case 'GetBoard':
        return $1.GetBoardRequest();
      case 'DraftAlertRule':
        return $1.DraftAlertRuleRequest();
      case 'ApproveAlertRule':
        return $1.ApproveAlertRuleRequest();
      case 'ScreenEncounter':
        return $1.ScreenEncounterRequest();
      case 'AcknowledgeAlert':
        return $1.AcknowledgeAlertRequest();
      case 'OverrideAlert':
        return $1.OverrideAlertRequest();
      case 'ListAlerts':
        return $1.ListAlertsRequest();
      case 'OpenOutbreak':
        return $1.OpenOutbreakRequest();
      case 'AdvanceOutbreak':
        return $1.AdvanceOutbreakRequest();
      case 'CloseOutbreak':
        return $1.CloseOutbreakRequest();
      case 'AddOutbreakMember':
        return $1.AddOutbreakMemberRequest();
      case 'GetCluster':
        return $1.GetClusterRequest();
      case 'ListOutbreaks':
        return $1.ListOutbreaksRequest();
      case 'StartHygieneSession':
        return $1.StartHygieneSessionRequest();
      case 'RecordObservation':
        return $1.RecordObservationRequest();
      case 'EndHygieneSession':
        return $1.EndHygieneSessionRequest();
      case 'GetHygieneCompliance':
        return $1.GetHygieneComplianceRequest();
      case 'ReportExposure':
        return $1.ReportExposureRequest();
      case 'GetExposure':
        return $1.GetExposureRequest();
      case 'CompleteExposureTask':
        return $1.CompleteExposureTaskRequest();
      case 'CloseExposure':
        return $1.CloseExposureRequest();
      case 'ListExposures':
        return $1.ListExposuresRequest();
      case 'SweepExposureTasks':
        return $1.SweepExposureTasksRequest();
      case 'DraftStewardshipRule':
        return $1.DraftStewardshipRuleRequest();
      case 'ApproveStewardshipRule':
        return $1.ApproveStewardshipRuleRequest();
      case 'ReviewEncounter':
        return $1.ReviewEncounterRequest();
      case 'AdviseReview':
        return $1.AdviseReviewRequest();
      case 'RespondToReview':
        return $1.RespondToReviewRequest();
      case 'WithdrawReview':
        return $1.WithdrawReviewRequest();
      case 'ListReviews':
        return $1.ListReviewsRequest();
      case 'GetStewardshipIndicators':
        return $1.GetStewardshipIndicatorsRequest();
      case 'DraftLimit':
        return $1.DraftLimitRequest();
      case 'ApproveLimit':
        return $1.ApproveLimitRequest();
      case 'AddSamplingPlan':
        return $1.AddSamplingPlanRequest();
      case 'CollectSample':
        return $1.CollectSampleRequest();
      case 'RecordSampleResult':
        return $1.RecordSampleResultRequest();
      case 'RaiseCorrectiveAction':
        return $1.RaiseCorrectiveActionRequest();
      case 'CompleteCorrectiveAction':
        return $1.CompleteCorrectiveActionRequest();
      case 'VerifyCorrectiveAction':
        return $1.VerifyCorrectiveActionRequest();
      case 'CloseSample':
        return $1.CloseSampleRequest();
      case 'ListDueSampling':
        return $1.ListDueSamplingRequest();
      case 'ListSamples':
        return $1.ListSamplesRequest();
      case 'ListCorrectiveActions':
        return $1.ListCorrectiveActionsRequest();
      case 'GetEnvironmentSummary':
        return $1.GetEnvironmentSummaryRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'OpenCase':
        return openCase(ctx, request as $1.OpenCaseRequest);
      case 'ReviewCase':
        return reviewCase(ctx, request as $1.ReviewCaseRequest);
      case 'OverrideOnset':
        return overrideOnset(ctx, request as $1.OverrideOnsetRequest);
      case 'ListCases':
        return listCases(ctx, request as $1.ListCasesRequest);
      case 'RecordDeviceDays':
        return recordDeviceDays(ctx, request as $1.RecordDeviceDaysRequest);
      case 'GetRate':
        return getRate(ctx, request as $1.GetRateRequest);
      case 'StartIsolation':
        return startIsolation(ctx, request as $1.StartIsolationRequest);
      case 'ExtendIsolation':
        return extendIsolation(ctx, request as $1.ExtendIsolationRequest);
      case 'EndIsolation':
        return endIsolation(ctx, request as $1.EndIsolationRequest);
      case 'GetBoard':
        return getBoard(ctx, request as $1.GetBoardRequest);
      case 'DraftAlertRule':
        return draftAlertRule(ctx, request as $1.DraftAlertRuleRequest);
      case 'ApproveAlertRule':
        return approveAlertRule(ctx, request as $1.ApproveAlertRuleRequest);
      case 'ScreenEncounter':
        return screenEncounter(ctx, request as $1.ScreenEncounterRequest);
      case 'AcknowledgeAlert':
        return acknowledgeAlert(ctx, request as $1.AcknowledgeAlertRequest);
      case 'OverrideAlert':
        return overrideAlert(ctx, request as $1.OverrideAlertRequest);
      case 'ListAlerts':
        return listAlerts(ctx, request as $1.ListAlertsRequest);
      case 'OpenOutbreak':
        return openOutbreak(ctx, request as $1.OpenOutbreakRequest);
      case 'AdvanceOutbreak':
        return advanceOutbreak(ctx, request as $1.AdvanceOutbreakRequest);
      case 'CloseOutbreak':
        return closeOutbreak(ctx, request as $1.CloseOutbreakRequest);
      case 'AddOutbreakMember':
        return addOutbreakMember(ctx, request as $1.AddOutbreakMemberRequest);
      case 'GetCluster':
        return getCluster(ctx, request as $1.GetClusterRequest);
      case 'ListOutbreaks':
        return listOutbreaks(ctx, request as $1.ListOutbreaksRequest);
      case 'StartHygieneSession':
        return startHygieneSession(
            ctx, request as $1.StartHygieneSessionRequest);
      case 'RecordObservation':
        return recordObservation(ctx, request as $1.RecordObservationRequest);
      case 'EndHygieneSession':
        return endHygieneSession(ctx, request as $1.EndHygieneSessionRequest);
      case 'GetHygieneCompliance':
        return getHygieneCompliance(
            ctx, request as $1.GetHygieneComplianceRequest);
      case 'ReportExposure':
        return reportExposure(ctx, request as $1.ReportExposureRequest);
      case 'GetExposure':
        return getExposure(ctx, request as $1.GetExposureRequest);
      case 'CompleteExposureTask':
        return completeExposureTask(
            ctx, request as $1.CompleteExposureTaskRequest);
      case 'CloseExposure':
        return closeExposure(ctx, request as $1.CloseExposureRequest);
      case 'ListExposures':
        return listExposures(ctx, request as $1.ListExposuresRequest);
      case 'SweepExposureTasks':
        return sweepExposureTasks(ctx, request as $1.SweepExposureTasksRequest);
      case 'DraftStewardshipRule':
        return draftStewardshipRule(
            ctx, request as $1.DraftStewardshipRuleRequest);
      case 'ApproveStewardshipRule':
        return approveStewardshipRule(
            ctx, request as $1.ApproveStewardshipRuleRequest);
      case 'ReviewEncounter':
        return reviewEncounter(ctx, request as $1.ReviewEncounterRequest);
      case 'AdviseReview':
        return adviseReview(ctx, request as $1.AdviseReviewRequest);
      case 'RespondToReview':
        return respondToReview(ctx, request as $1.RespondToReviewRequest);
      case 'WithdrawReview':
        return withdrawReview(ctx, request as $1.WithdrawReviewRequest);
      case 'ListReviews':
        return listReviews(ctx, request as $1.ListReviewsRequest);
      case 'GetStewardshipIndicators':
        return getStewardshipIndicators(
            ctx, request as $1.GetStewardshipIndicatorsRequest);
      case 'DraftLimit':
        return draftLimit(ctx, request as $1.DraftLimitRequest);
      case 'ApproveLimit':
        return approveLimit(ctx, request as $1.ApproveLimitRequest);
      case 'AddSamplingPlan':
        return addSamplingPlan(ctx, request as $1.AddSamplingPlanRequest);
      case 'CollectSample':
        return collectSample(ctx, request as $1.CollectSampleRequest);
      case 'RecordSampleResult':
        return recordSampleResult(ctx, request as $1.RecordSampleResultRequest);
      case 'RaiseCorrectiveAction':
        return raiseCorrectiveAction(
            ctx, request as $1.RaiseCorrectiveActionRequest);
      case 'CompleteCorrectiveAction':
        return completeCorrectiveAction(
            ctx, request as $1.CompleteCorrectiveActionRequest);
      case 'VerifyCorrectiveAction':
        return verifyCorrectiveAction(
            ctx, request as $1.VerifyCorrectiveActionRequest);
      case 'CloseSample':
        return closeSample(ctx, request as $1.CloseSampleRequest);
      case 'ListDueSampling':
        return listDueSampling(ctx, request as $1.ListDueSamplingRequest);
      case 'ListSamples':
        return listSamples(ctx, request as $1.ListSamplesRequest);
      case 'ListCorrectiveActions':
        return listCorrectiveActions(
            ctx, request as $1.ListCorrectiveActionsRequest);
      case 'GetEnvironmentSummary':
        return getEnvironmentSummary(
            ctx, request as $1.GetEnvironmentSummaryRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => InfectionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => InfectionServiceBase$messageJson;
}
