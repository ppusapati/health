// This is a generated file - do not edit.
//
// Generated from healthcare/quality/v1/quality.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'quality.pb.dart' as $1;
import 'quality.pbjson.dart';

export 'quality.pb.dart';

abstract class QualityServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ReportIncidentResponse> reportIncident(
      $pb.ServerContext ctx, $1.ReportIncidentRequest request);
  $async.Future<$1.GetIncidentResponse> getIncident(
      $pb.ServerContext ctx, $1.GetIncidentRequest request);
  $async.Future<$1.ListIncidentsResponse> listIncidents(
      $pb.ServerContext ctx, $1.ListIncidentsRequest request);
  $async.Future<$1.RescoreIncidentResponse> rescoreIncident(
      $pb.ServerContext ctx, $1.RescoreIncidentRequest request);
  $async.Future<$1.AdvanceIncidentResponse> advanceIncident(
      $pb.ServerContext ctx, $1.AdvanceIncidentRequest request);
  $async.Future<$1.SetIncidentRestrictionResponse> setIncidentRestriction(
      $pb.ServerContext ctx, $1.SetIncidentRestrictionRequest request);
  $async.Future<$1.GetTrendsResponse> getTrends(
      $pb.ServerContext ctx, $1.GetTrendsRequest request);
  $async.Future<$1.StartRcaResponse> startRca(
      $pb.ServerContext ctx, $1.StartRcaRequest request);
  $async.Future<$1.AddFactorResponse> addFactor(
      $pb.ServerContext ctx, $1.AddFactorRequest request);
  $async.Future<$1.CompleteRcaResponse> completeRca(
      $pb.ServerContext ctx, $1.CompleteRcaRequest request);
  $async.Future<$1.GetRcaResponse> getRca(
      $pb.ServerContext ctx, $1.GetRcaRequest request);
  $async.Future<$1.RaiseActionResponse> raiseAction(
      $pb.ServerContext ctx, $1.RaiseActionRequest request);
  $async.Future<$1.ApproveActionResponse> approveAction(
      $pb.ServerContext ctx, $1.ApproveActionRequest request);
  $async.Future<$1.AdvanceActionResponse> advanceAction(
      $pb.ServerContext ctx, $1.AdvanceActionRequest request);
  $async.Future<$1.RecordEffectivenessResponse> recordEffectiveness(
      $pb.ServerContext ctx, $1.RecordEffectivenessRequest request);
  $async.Future<$1.CloseActionResponse> closeAction(
      $pb.ServerContext ctx, $1.CloseActionRequest request);
  $async.Future<$1.GetActionResponse> getAction(
      $pb.ServerContext ctx, $1.GetActionRequest request);
  $async.Future<$1.ListActionsResponse> listActions(
      $pb.ServerContext ctx, $1.ListActionsRequest request);
  $async.Future<$1.ListOverdueActionsResponse> listOverdueActions(
      $pb.ServerContext ctx, $1.ListOverdueActionsRequest request);
  $async.Future<$1.EscalateOverdueActionsResponse> escalateOverdueActions(
      $pb.ServerContext ctx, $1.EscalateOverdueActionsRequest request);
  $async.Future<$1.RegisterDocumentResponse> registerDocument(
      $pb.ServerContext ctx, $1.RegisterDocumentRequest request);
  $async.Future<$1.DraftVersionResponse> draftVersion(
      $pb.ServerContext ctx, $1.DraftVersionRequest request);
  $async.Future<$1.ApproveVersionResponse> approveVersion(
      $pb.ServerContext ctx, $1.ApproveVersionRequest request);
  $async.Future<$1.GetCurrentVersionResponse> getCurrentVersion(
      $pb.ServerContext ctx, $1.GetCurrentVersionRequest request);
  $async.Future<$1.ListVersionsResponse> listVersions(
      $pb.ServerContext ctx, $1.ListVersionsRequest request);
  $async.Future<$1.ListDocumentsResponse> listDocuments(
      $pb.ServerContext ctx, $1.ListDocumentsRequest request);
  $async.Future<$1.AcknowledgeDocumentResponse> acknowledgeDocument(
      $pb.ServerContext ctx, $1.AcknowledgeDocumentRequest request);
  $async.Future<$1.ListOutstandingAcknowledgementsResponse>
      listOutstandingAcknowledgements($pb.ServerContext ctx,
          $1.ListOutstandingAcknowledgementsRequest request);
  $async.Future<$1.ListReviewsDueResponse> listReviewsDue(
      $pb.ServerContext ctx, $1.ListReviewsDueRequest request);
  $async.Future<$1.DefineCompetencyResponse> defineCompetency(
      $pb.ServerContext ctx, $1.DefineCompetencyRequest request);
  $async.Future<$1.RequireCompetencyResponse> requireCompetency(
      $pb.ServerContext ctx, $1.RequireCompetencyRequest request);
  $async.Future<$1.AwardCompetencyResponse> awardCompetency(
      $pb.ServerContext ctx, $1.AwardCompetencyRequest request);
  $async.Future<$1.ListCompetencyGapsResponse> listCompetencyGaps(
      $pb.ServerContext ctx, $1.ListCompetencyGapsRequest request);
  $async.Future<$1.PlanAuditResponse> planAudit(
      $pb.ServerContext ctx, $1.PlanAuditRequest request);
  $async.Future<$1.RecordFindingResponse> recordFinding(
      $pb.ServerContext ctx, $1.RecordFindingRequest request);
  $async.Future<$1.LinkFindingActionResponse> linkFindingAction(
      $pb.ServerContext ctx, $1.LinkFindingActionRequest request);
  $async.Future<$1.CloseFindingResponse> closeFinding(
      $pb.ServerContext ctx, $1.CloseFindingRequest request);
  $async.Future<$1.ReportAuditResponse> reportAudit(
      $pb.ServerContext ctx, $1.ReportAuditRequest request);
  $async.Future<$1.CloseAuditResponse> closeAudit(
      $pb.ServerContext ctx, $1.CloseAuditRequest request);
  $async.Future<$1.GetAuditResponse> getAudit(
      $pb.ServerContext ctx, $1.GetAuditRequest request);
  $async.Future<$1.ListAuditsResponse> listAudits(
      $pb.ServerContext ctx, $1.ListAuditsRequest request);
  $async.Future<$1.ListFindingsResponse> listFindings(
      $pb.ServerContext ctx, $1.ListFindingsRequest request);
  $async.Future<$1.FormCommitteeResponse> formCommittee(
      $pb.ServerContext ctx, $1.FormCommitteeRequest request);
  $async.Future<$1.ScheduleMeetingResponse> scheduleMeeting(
      $pb.ServerContext ctx, $1.ScheduleMeetingRequest request);
  $async.Future<$1.RecordMinutesResponse> recordMinutes(
      $pb.ServerContext ctx, $1.RecordMinutesRequest request);
  $async.Future<$1.GetMeetingResponse> getMeeting(
      $pb.ServerContext ctx, $1.GetMeetingRequest request);
  $async.Future<$1.ListCommitteesResponse> listCommittees(
      $pb.ServerContext ctx, $1.ListCommitteesRequest request);
  $async.Future<$1.LoadStandardResponse> loadStandard(
      $pb.ServerContext ctx, $1.LoadStandardRequest request);
  $async.Future<$1.FileEvidenceResponse> fileEvidence(
      $pb.ServerContext ctx, $1.FileEvidenceRequest request);
  $async.Future<$1.WithdrawEvidenceResponse> withdrawEvidence(
      $pb.ServerContext ctx, $1.WithdrawEvidenceRequest request);
  $async.Future<$1.ReviewClauseResponse> reviewClause(
      $pb.ServerContext ctx, $1.ReviewClauseRequest request);
  $async.Future<$1.GetReadinessResponse> getReadiness(
      $pb.ServerContext ctx, $1.GetReadinessRequest request);
  $async.Future<$1.ListStandardsResponse> listStandards(
      $pb.ServerContext ctx, $1.ListStandardsRequest request);
  $async.Future<$1.ListClausesResponse> listClauses(
      $pb.ServerContext ctx, $1.ListClausesRequest request);
  $async.Future<$1.DefineIndicatorResponse> defineIndicator(
      $pb.ServerContext ctx, $1.DefineIndicatorRequest request);
  $async.Future<$1.RecordIndicatorValueResponse> recordIndicatorValue(
      $pb.ServerContext ctx, $1.RecordIndicatorValueRequest request);
  $async.Future<$1.GetDashboardResponse> getDashboard(
      $pb.ServerContext ctx, $1.GetDashboardRequest request);
  $async.Future<$1.ListIndicatorValuesResponse> listIndicatorValues(
      $pb.ServerContext ctx, $1.ListIndicatorValuesRequest request);
  $async.Future<$1.ReceiveComplaintResponse> receiveComplaint(
      $pb.ServerContext ctx, $1.ReceiveComplaintRequest request);
  $async.Future<$1.AcknowledgeComplaintResponse> acknowledgeComplaint(
      $pb.ServerContext ctx, $1.AcknowledgeComplaintRequest request);
  $async.Future<$1.ResolveComplaintResponse> resolveComplaint(
      $pb.ServerContext ctx, $1.ResolveComplaintRequest request);
  $async.Future<$1.CloseComplaintResponse> closeComplaint(
      $pb.ServerContext ctx, $1.CloseComplaintRequest request);
  $async.Future<$1.GetComplaintResponse> getComplaint(
      $pb.ServerContext ctx, $1.GetComplaintRequest request);
  $async.Future<$1.ListComplaintsResponse> listComplaints(
      $pb.ServerContext ctx, $1.ListComplaintsRequest request);
  $async.Future<$1.ListComplaintBreachesResponse> listComplaintBreaches(
      $pb.ServerContext ctx, $1.ListComplaintBreachesRequest request);
  $async.Future<$1.EscalateComplaintBreachesResponse> escalateComplaintBreaches(
      $pb.ServerContext ctx, $1.EscalateComplaintBreachesRequest request);
  $async.Future<$1.StartMortalityReviewResponse> startMortalityReview(
      $pb.ServerContext ctx, $1.StartMortalityReviewRequest request);
  $async.Future<$1.CompleteMortalityReviewResponse> completeMortalityReview(
      $pb.ServerContext ctx, $1.CompleteMortalityReviewRequest request);
  $async.Future<$1.GetMortalityReviewResponse> getMortalityReview(
      $pb.ServerContext ctx, $1.GetMortalityReviewRequest request);
  $async.Future<$1.ListMortalityReviewsResponse> listMortalityReviews(
      $pb.ServerContext ctx, $1.ListMortalityReviewsRequest request);
  $async.Future<$1.PlaceHoldResponse> placeHold(
      $pb.ServerContext ctx, $1.PlaceHoldRequest request);
  $async.Future<$1.ReleaseHoldResponse> releaseHold(
      $pb.ServerContext ctx, $1.ReleaseHoldRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ReportIncident':
        return $1.ReportIncidentRequest();
      case 'GetIncident':
        return $1.GetIncidentRequest();
      case 'ListIncidents':
        return $1.ListIncidentsRequest();
      case 'RescoreIncident':
        return $1.RescoreIncidentRequest();
      case 'AdvanceIncident':
        return $1.AdvanceIncidentRequest();
      case 'SetIncidentRestriction':
        return $1.SetIncidentRestrictionRequest();
      case 'GetTrends':
        return $1.GetTrendsRequest();
      case 'StartRca':
        return $1.StartRcaRequest();
      case 'AddFactor':
        return $1.AddFactorRequest();
      case 'CompleteRca':
        return $1.CompleteRcaRequest();
      case 'GetRca':
        return $1.GetRcaRequest();
      case 'RaiseAction':
        return $1.RaiseActionRequest();
      case 'ApproveAction':
        return $1.ApproveActionRequest();
      case 'AdvanceAction':
        return $1.AdvanceActionRequest();
      case 'RecordEffectiveness':
        return $1.RecordEffectivenessRequest();
      case 'CloseAction':
        return $1.CloseActionRequest();
      case 'GetAction':
        return $1.GetActionRequest();
      case 'ListActions':
        return $1.ListActionsRequest();
      case 'ListOverdueActions':
        return $1.ListOverdueActionsRequest();
      case 'EscalateOverdueActions':
        return $1.EscalateOverdueActionsRequest();
      case 'RegisterDocument':
        return $1.RegisterDocumentRequest();
      case 'DraftVersion':
        return $1.DraftVersionRequest();
      case 'ApproveVersion':
        return $1.ApproveVersionRequest();
      case 'GetCurrentVersion':
        return $1.GetCurrentVersionRequest();
      case 'ListVersions':
        return $1.ListVersionsRequest();
      case 'ListDocuments':
        return $1.ListDocumentsRequest();
      case 'AcknowledgeDocument':
        return $1.AcknowledgeDocumentRequest();
      case 'ListOutstandingAcknowledgements':
        return $1.ListOutstandingAcknowledgementsRequest();
      case 'ListReviewsDue':
        return $1.ListReviewsDueRequest();
      case 'DefineCompetency':
        return $1.DefineCompetencyRequest();
      case 'RequireCompetency':
        return $1.RequireCompetencyRequest();
      case 'AwardCompetency':
        return $1.AwardCompetencyRequest();
      case 'ListCompetencyGaps':
        return $1.ListCompetencyGapsRequest();
      case 'PlanAudit':
        return $1.PlanAuditRequest();
      case 'RecordFinding':
        return $1.RecordFindingRequest();
      case 'LinkFindingAction':
        return $1.LinkFindingActionRequest();
      case 'CloseFinding':
        return $1.CloseFindingRequest();
      case 'ReportAudit':
        return $1.ReportAuditRequest();
      case 'CloseAudit':
        return $1.CloseAuditRequest();
      case 'GetAudit':
        return $1.GetAuditRequest();
      case 'ListAudits':
        return $1.ListAuditsRequest();
      case 'ListFindings':
        return $1.ListFindingsRequest();
      case 'FormCommittee':
        return $1.FormCommitteeRequest();
      case 'ScheduleMeeting':
        return $1.ScheduleMeetingRequest();
      case 'RecordMinutes':
        return $1.RecordMinutesRequest();
      case 'GetMeeting':
        return $1.GetMeetingRequest();
      case 'ListCommittees':
        return $1.ListCommitteesRequest();
      case 'LoadStandard':
        return $1.LoadStandardRequest();
      case 'FileEvidence':
        return $1.FileEvidenceRequest();
      case 'WithdrawEvidence':
        return $1.WithdrawEvidenceRequest();
      case 'ReviewClause':
        return $1.ReviewClauseRequest();
      case 'GetReadiness':
        return $1.GetReadinessRequest();
      case 'ListStandards':
        return $1.ListStandardsRequest();
      case 'ListClauses':
        return $1.ListClausesRequest();
      case 'DefineIndicator':
        return $1.DefineIndicatorRequest();
      case 'RecordIndicatorValue':
        return $1.RecordIndicatorValueRequest();
      case 'GetDashboard':
        return $1.GetDashboardRequest();
      case 'ListIndicatorValues':
        return $1.ListIndicatorValuesRequest();
      case 'ReceiveComplaint':
        return $1.ReceiveComplaintRequest();
      case 'AcknowledgeComplaint':
        return $1.AcknowledgeComplaintRequest();
      case 'ResolveComplaint':
        return $1.ResolveComplaintRequest();
      case 'CloseComplaint':
        return $1.CloseComplaintRequest();
      case 'GetComplaint':
        return $1.GetComplaintRequest();
      case 'ListComplaints':
        return $1.ListComplaintsRequest();
      case 'ListComplaintBreaches':
        return $1.ListComplaintBreachesRequest();
      case 'EscalateComplaintBreaches':
        return $1.EscalateComplaintBreachesRequest();
      case 'StartMortalityReview':
        return $1.StartMortalityReviewRequest();
      case 'CompleteMortalityReview':
        return $1.CompleteMortalityReviewRequest();
      case 'GetMortalityReview':
        return $1.GetMortalityReviewRequest();
      case 'ListMortalityReviews':
        return $1.ListMortalityReviewsRequest();
      case 'PlaceHold':
        return $1.PlaceHoldRequest();
      case 'ReleaseHold':
        return $1.ReleaseHoldRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ReportIncident':
        return reportIncident(ctx, request as $1.ReportIncidentRequest);
      case 'GetIncident':
        return getIncident(ctx, request as $1.GetIncidentRequest);
      case 'ListIncidents':
        return listIncidents(ctx, request as $1.ListIncidentsRequest);
      case 'RescoreIncident':
        return rescoreIncident(ctx, request as $1.RescoreIncidentRequest);
      case 'AdvanceIncident':
        return advanceIncident(ctx, request as $1.AdvanceIncidentRequest);
      case 'SetIncidentRestriction':
        return setIncidentRestriction(
            ctx, request as $1.SetIncidentRestrictionRequest);
      case 'GetTrends':
        return getTrends(ctx, request as $1.GetTrendsRequest);
      case 'StartRca':
        return startRca(ctx, request as $1.StartRcaRequest);
      case 'AddFactor':
        return addFactor(ctx, request as $1.AddFactorRequest);
      case 'CompleteRca':
        return completeRca(ctx, request as $1.CompleteRcaRequest);
      case 'GetRca':
        return getRca(ctx, request as $1.GetRcaRequest);
      case 'RaiseAction':
        return raiseAction(ctx, request as $1.RaiseActionRequest);
      case 'ApproveAction':
        return approveAction(ctx, request as $1.ApproveActionRequest);
      case 'AdvanceAction':
        return advanceAction(ctx, request as $1.AdvanceActionRequest);
      case 'RecordEffectiveness':
        return recordEffectiveness(
            ctx, request as $1.RecordEffectivenessRequest);
      case 'CloseAction':
        return closeAction(ctx, request as $1.CloseActionRequest);
      case 'GetAction':
        return getAction(ctx, request as $1.GetActionRequest);
      case 'ListActions':
        return listActions(ctx, request as $1.ListActionsRequest);
      case 'ListOverdueActions':
        return listOverdueActions(ctx, request as $1.ListOverdueActionsRequest);
      case 'EscalateOverdueActions':
        return escalateOverdueActions(
            ctx, request as $1.EscalateOverdueActionsRequest);
      case 'RegisterDocument':
        return registerDocument(ctx, request as $1.RegisterDocumentRequest);
      case 'DraftVersion':
        return draftVersion(ctx, request as $1.DraftVersionRequest);
      case 'ApproveVersion':
        return approveVersion(ctx, request as $1.ApproveVersionRequest);
      case 'GetCurrentVersion':
        return getCurrentVersion(ctx, request as $1.GetCurrentVersionRequest);
      case 'ListVersions':
        return listVersions(ctx, request as $1.ListVersionsRequest);
      case 'ListDocuments':
        return listDocuments(ctx, request as $1.ListDocumentsRequest);
      case 'AcknowledgeDocument':
        return acknowledgeDocument(
            ctx, request as $1.AcknowledgeDocumentRequest);
      case 'ListOutstandingAcknowledgements':
        return listOutstandingAcknowledgements(
            ctx, request as $1.ListOutstandingAcknowledgementsRequest);
      case 'ListReviewsDue':
        return listReviewsDue(ctx, request as $1.ListReviewsDueRequest);
      case 'DefineCompetency':
        return defineCompetency(ctx, request as $1.DefineCompetencyRequest);
      case 'RequireCompetency':
        return requireCompetency(ctx, request as $1.RequireCompetencyRequest);
      case 'AwardCompetency':
        return awardCompetency(ctx, request as $1.AwardCompetencyRequest);
      case 'ListCompetencyGaps':
        return listCompetencyGaps(ctx, request as $1.ListCompetencyGapsRequest);
      case 'PlanAudit':
        return planAudit(ctx, request as $1.PlanAuditRequest);
      case 'RecordFinding':
        return recordFinding(ctx, request as $1.RecordFindingRequest);
      case 'LinkFindingAction':
        return linkFindingAction(ctx, request as $1.LinkFindingActionRequest);
      case 'CloseFinding':
        return closeFinding(ctx, request as $1.CloseFindingRequest);
      case 'ReportAudit':
        return reportAudit(ctx, request as $1.ReportAuditRequest);
      case 'CloseAudit':
        return closeAudit(ctx, request as $1.CloseAuditRequest);
      case 'GetAudit':
        return getAudit(ctx, request as $1.GetAuditRequest);
      case 'ListAudits':
        return listAudits(ctx, request as $1.ListAuditsRequest);
      case 'ListFindings':
        return listFindings(ctx, request as $1.ListFindingsRequest);
      case 'FormCommittee':
        return formCommittee(ctx, request as $1.FormCommitteeRequest);
      case 'ScheduleMeeting':
        return scheduleMeeting(ctx, request as $1.ScheduleMeetingRequest);
      case 'RecordMinutes':
        return recordMinutes(ctx, request as $1.RecordMinutesRequest);
      case 'GetMeeting':
        return getMeeting(ctx, request as $1.GetMeetingRequest);
      case 'ListCommittees':
        return listCommittees(ctx, request as $1.ListCommitteesRequest);
      case 'LoadStandard':
        return loadStandard(ctx, request as $1.LoadStandardRequest);
      case 'FileEvidence':
        return fileEvidence(ctx, request as $1.FileEvidenceRequest);
      case 'WithdrawEvidence':
        return withdrawEvidence(ctx, request as $1.WithdrawEvidenceRequest);
      case 'ReviewClause':
        return reviewClause(ctx, request as $1.ReviewClauseRequest);
      case 'GetReadiness':
        return getReadiness(ctx, request as $1.GetReadinessRequest);
      case 'ListStandards':
        return listStandards(ctx, request as $1.ListStandardsRequest);
      case 'ListClauses':
        return listClauses(ctx, request as $1.ListClausesRequest);
      case 'DefineIndicator':
        return defineIndicator(ctx, request as $1.DefineIndicatorRequest);
      case 'RecordIndicatorValue':
        return recordIndicatorValue(
            ctx, request as $1.RecordIndicatorValueRequest);
      case 'GetDashboard':
        return getDashboard(ctx, request as $1.GetDashboardRequest);
      case 'ListIndicatorValues':
        return listIndicatorValues(
            ctx, request as $1.ListIndicatorValuesRequest);
      case 'ReceiveComplaint':
        return receiveComplaint(ctx, request as $1.ReceiveComplaintRequest);
      case 'AcknowledgeComplaint':
        return acknowledgeComplaint(
            ctx, request as $1.AcknowledgeComplaintRequest);
      case 'ResolveComplaint':
        return resolveComplaint(ctx, request as $1.ResolveComplaintRequest);
      case 'CloseComplaint':
        return closeComplaint(ctx, request as $1.CloseComplaintRequest);
      case 'GetComplaint':
        return getComplaint(ctx, request as $1.GetComplaintRequest);
      case 'ListComplaints':
        return listComplaints(ctx, request as $1.ListComplaintsRequest);
      case 'ListComplaintBreaches':
        return listComplaintBreaches(
            ctx, request as $1.ListComplaintBreachesRequest);
      case 'EscalateComplaintBreaches':
        return escalateComplaintBreaches(
            ctx, request as $1.EscalateComplaintBreachesRequest);
      case 'StartMortalityReview':
        return startMortalityReview(
            ctx, request as $1.StartMortalityReviewRequest);
      case 'CompleteMortalityReview':
        return completeMortalityReview(
            ctx, request as $1.CompleteMortalityReviewRequest);
      case 'GetMortalityReview':
        return getMortalityReview(ctx, request as $1.GetMortalityReviewRequest);
      case 'ListMortalityReviews':
        return listMortalityReviews(
            ctx, request as $1.ListMortalityReviewsRequest);
      case 'PlaceHold':
        return placeHold(ctx, request as $1.PlaceHoldRequest);
      case 'ReleaseHold':
        return releaseHold(ctx, request as $1.ReleaseHoldRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => QualityServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => QualityServiceBase$messageJson;
}
