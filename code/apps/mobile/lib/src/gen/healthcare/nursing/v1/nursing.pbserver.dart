// This is a generated file - do not edit.
//
// Generated from healthcare/nursing/v1/nursing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'nursing.pb.dart' as $1;
import 'nursing.pbjson.dart';

export 'nursing.pb.dart';

abstract class NursingServiceBase extends $pb.GeneratedService {
  $async.Future<$1.ChartObservationResponse> chartObservation(
      $pb.ServerContext ctx, $1.ChartObservationRequest request);
  $async.Future<$1.GetFlowsheetResponse> getFlowsheet(
      $pb.ServerContext ctx, $1.GetFlowsheetRequest request);
  $async.Future<$1.RecordFluidResponse> recordFluid(
      $pb.ServerContext ctx, $1.RecordFluidRequest request);
  $async.Future<$1.CorrectFluidResponse> correctFluid(
      $pb.ServerContext ctx, $1.CorrectFluidRequest request);
  $async.Future<$1.GetFluidBalanceResponse> getFluidBalance(
      $pb.ServerContext ctx, $1.GetFluidBalanceRequest request);
  $async.Future<$1.GetFluidTrailResponse> getFluidTrail(
      $pb.ServerContext ctx, $1.GetFluidTrailRequest request);
  $async.Future<$1.DefineAssessmentTemplateResponse> defineAssessmentTemplate(
      $pb.ServerContext ctx, $1.DefineAssessmentTemplateRequest request);
  $async.Future<$1.ListAssessmentTemplatesResponse> listAssessmentTemplates(
      $pb.ServerContext ctx, $1.ListAssessmentTemplatesRequest request);
  $async.Future<$1.RetireAssessmentTemplateResponse> retireAssessmentTemplate(
      $pb.ServerContext ctx, $1.RetireAssessmentTemplateRequest request);
  $async.Future<$1.RecordAssessmentResponse> recordAssessment(
      $pb.ServerContext ctx, $1.RecordAssessmentRequest request);
  $async.Future<$1.ListAssessmentsResponse> listAssessments(
      $pb.ServerContext ctx, $1.ListAssessmentsRequest request);
  $async.Future<$1.DefineRiskScaleResponse> defineRiskScale(
      $pb.ServerContext ctx, $1.DefineRiskScaleRequest request);
  $async.Future<$1.ScoreRiskResponse> scoreRisk(
      $pb.ServerContext ctx, $1.ScoreRiskRequest request);
  $async.Future<$1.ListRiskAssessmentsResponse> listRiskAssessments(
      $pb.ServerContext ctx, $1.ListRiskAssessmentsRequest request);
  $async.Future<$1.ListDueReassessmentsResponse> listDueReassessments(
      $pb.ServerContext ctx, $1.ListDueReassessmentsRequest request);
  $async.Future<$1.InsertDeviceResponse> insertDevice(
      $pb.ServerContext ctx, $1.InsertDeviceRequest request);
  $async.Future<$1.RemoveDeviceResponse> removeDevice(
      $pb.ServerContext ctx, $1.RemoveDeviceRequest request);
  $async.Future<$1.RecordDeviceCareResponse> recordDeviceCare(
      $pb.ServerContext ctx, $1.RecordDeviceCareRequest request);
  $async.Future<$1.ListDevicesResponse> listDevices(
      $pb.ServerContext ctx, $1.ListDevicesRequest request);
  $async.Future<$1.GetMedicationRoundResponse> getMedicationRound(
      $pb.ServerContext ctx, $1.GetMedicationRoundRequest request);
  $async.Future<$1.AdministerResponse> administer(
      $pb.ServerContext ctx, $1.AdministerRequest request);
  $async.Future<$1.ListAdministrationsResponse> listAdministrations(
      $pb.ServerContext ctx, $1.ListAdministrationsRequest request);
  $async.Future<$1.GetOverrideReportResponse> getOverrideReport(
      $pb.ServerContext ctx, $1.GetOverrideReportRequest request);
  $async.Future<$1.SetAdministrationPolicyResponse> setAdministrationPolicy(
      $pb.ServerContext ctx, $1.SetAdministrationPolicyRequest request);
  $async.Future<$1.CreateCarePlanResponse> createCarePlan(
      $pb.ServerContext ctx, $1.CreateCarePlanRequest request);
  $async.Future<$1.ReviewCarePlanResponse> reviewCarePlan(
      $pb.ServerContext ctx, $1.ReviewCarePlanRequest request);
  $async.Future<$1.ListCarePlansResponse> listCarePlans(
      $pb.ServerContext ctx, $1.ListCarePlansRequest request);
  $async.Future<$1.CreateTaskResponse> createTask(
      $pb.ServerContext ctx, $1.CreateTaskRequest request);
  $async.Future<$1.CompleteTaskResponse> completeTask(
      $pb.ServerContext ctx, $1.CompleteTaskRequest request);
  $async.Future<$1.SkipTaskResponse> skipTask(
      $pb.ServerContext ctx, $1.SkipTaskRequest request);
  $async.Future<$1.GetWorklistResponse> getWorklist(
      $pb.ServerContext ctx, $1.GetWorklistRequest request);
  $async.Future<$1.EscalateOverdueWorkResponse> escalateOverdueWork(
      $pb.ServerContext ctx, $1.EscalateOverdueWorkRequest request);
  $async.Future<$1.ComposeHandoverResponse> composeHandover(
      $pb.ServerContext ctx, $1.ComposeHandoverRequest request);
  $async.Future<$1.AcknowledgeHandoverResponse> acknowledgeHandover(
      $pb.ServerContext ctx, $1.AcknowledgeHandoverRequest request);
  $async.Future<$1.ListHandoversResponse> listHandovers(
      $pb.ServerContext ctx, $1.ListHandoversRequest request);
  $async.Future<$1.ApplyRestraintResponse> applyRestraint(
      $pb.ServerContext ctx, $1.ApplyRestraintRequest request);
  $async.Future<$1.RenewRestraintResponse> renewRestraint(
      $pb.ServerContext ctx, $1.RenewRestraintRequest request);
  $async.Future<$1.CheckRestraintResponse> checkRestraint(
      $pb.ServerContext ctx, $1.CheckRestraintRequest request);
  $async.Future<$1.DiscontinueRestraintResponse> discontinueRestraint(
      $pb.ServerContext ctx, $1.DiscontinueRestraintRequest request);
  $async.Future<$1.ListRestraintsResponse> listRestraints(
      $pb.ServerContext ctx, $1.ListRestraintsRequest request);
  $async.Future<$1.GetRestraintAlertsResponse> getRestraintAlerts(
      $pb.ServerContext ctx, $1.GetRestraintAlertsRequest request);
  $async.Future<$1.StartTransfusionResponse> startTransfusion(
      $pb.ServerContext ctx, $1.StartTransfusionRequest request);
  $async.Future<$1.ObserveTransfusionResponse> observeTransfusion(
      $pb.ServerContext ctx, $1.ObserveTransfusionRequest request);
  $async.Future<$1.ReportTransfusionReactionResponse> reportTransfusionReaction(
      $pb.ServerContext ctx, $1.ReportTransfusionReactionRequest request);
  $async.Future<$1.CompleteTransfusionResponse> completeTransfusion(
      $pb.ServerContext ctx, $1.CompleteTransfusionRequest request);
  $async.Future<$1.AssessWoundResponse> assessWound(
      $pb.ServerContext ctx, $1.AssessWoundRequest request);
  $async.Future<$1.AttachWoundImageResponse> attachWoundImage(
      $pb.ServerContext ctx, $1.AttachWoundImageRequest request);
  $async.Future<$1.GetWoundHistoryResponse> getWoundHistory(
      $pb.ServerContext ctx, $1.GetWoundHistoryRequest request);
  $async.Future<$1.RecordEducationResponse> recordEducation(
      $pb.ServerContext ctx, $1.RecordEducationRequest request);
  $async.Future<$1.GetDischargeReadinessResponse> getDischargeReadiness(
      $pb.ServerContext ctx, $1.GetDischargeReadinessRequest request);
  $async.Future<$1.AssignNurseResponse> assignNurse(
      $pb.ServerContext ctx, $1.AssignNurseRequest request);
  $async.Future<$1.EndAssignmentResponse> endAssignment(
      $pb.ServerContext ctx, $1.EndAssignmentRequest request);
  $async.Future<$1.ListAssignmentsResponse> listAssignments(
      $pb.ServerContext ctx, $1.ListAssignmentsRequest request);
  $async.Future<$1.GetUnitAcuityResponse> getUnitAcuity(
      $pb.ServerContext ctx, $1.GetUnitAcuityRequest request);
  $async.Future<$1.SetAcuityWeightsResponse> setAcuityWeights(
      $pb.ServerContext ctx, $1.SetAcuityWeightsRequest request);
  $async.Future<$1.DeclareDowntimeResponse> declareDowntime(
      $pb.ServerContext ctx, $1.DeclareDowntimeRequest request);
  $async.Future<$1.EndDowntimeResponse> endDowntime(
      $pb.ServerContext ctx, $1.EndDowntimeRequest request);
  $async.Future<$1.ReconcileDowntimeResponse> reconcileDowntime(
      $pb.ServerContext ctx, $1.ReconcileDowntimeRequest request);
  $async.Future<$1.ListDowntimeResponse> listDowntime(
      $pb.ServerContext ctx, $1.ListDowntimeRequest request);
  $async.Future<$1.GetSuspectedDuplicatesResponse> getSuspectedDuplicates(
      $pb.ServerContext ctx, $1.GetSuspectedDuplicatesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ChartObservation':
        return $1.ChartObservationRequest();
      case 'GetFlowsheet':
        return $1.GetFlowsheetRequest();
      case 'RecordFluid':
        return $1.RecordFluidRequest();
      case 'CorrectFluid':
        return $1.CorrectFluidRequest();
      case 'GetFluidBalance':
        return $1.GetFluidBalanceRequest();
      case 'GetFluidTrail':
        return $1.GetFluidTrailRequest();
      case 'DefineAssessmentTemplate':
        return $1.DefineAssessmentTemplateRequest();
      case 'ListAssessmentTemplates':
        return $1.ListAssessmentTemplatesRequest();
      case 'RetireAssessmentTemplate':
        return $1.RetireAssessmentTemplateRequest();
      case 'RecordAssessment':
        return $1.RecordAssessmentRequest();
      case 'ListAssessments':
        return $1.ListAssessmentsRequest();
      case 'DefineRiskScale':
        return $1.DefineRiskScaleRequest();
      case 'ScoreRisk':
        return $1.ScoreRiskRequest();
      case 'ListRiskAssessments':
        return $1.ListRiskAssessmentsRequest();
      case 'ListDueReassessments':
        return $1.ListDueReassessmentsRequest();
      case 'InsertDevice':
        return $1.InsertDeviceRequest();
      case 'RemoveDevice':
        return $1.RemoveDeviceRequest();
      case 'RecordDeviceCare':
        return $1.RecordDeviceCareRequest();
      case 'ListDevices':
        return $1.ListDevicesRequest();
      case 'GetMedicationRound':
        return $1.GetMedicationRoundRequest();
      case 'Administer':
        return $1.AdministerRequest();
      case 'ListAdministrations':
        return $1.ListAdministrationsRequest();
      case 'GetOverrideReport':
        return $1.GetOverrideReportRequest();
      case 'SetAdministrationPolicy':
        return $1.SetAdministrationPolicyRequest();
      case 'CreateCarePlan':
        return $1.CreateCarePlanRequest();
      case 'ReviewCarePlan':
        return $1.ReviewCarePlanRequest();
      case 'ListCarePlans':
        return $1.ListCarePlansRequest();
      case 'CreateTask':
        return $1.CreateTaskRequest();
      case 'CompleteTask':
        return $1.CompleteTaskRequest();
      case 'SkipTask':
        return $1.SkipTaskRequest();
      case 'GetWorklist':
        return $1.GetWorklistRequest();
      case 'EscalateOverdueWork':
        return $1.EscalateOverdueWorkRequest();
      case 'ComposeHandover':
        return $1.ComposeHandoverRequest();
      case 'AcknowledgeHandover':
        return $1.AcknowledgeHandoverRequest();
      case 'ListHandovers':
        return $1.ListHandoversRequest();
      case 'ApplyRestraint':
        return $1.ApplyRestraintRequest();
      case 'RenewRestraint':
        return $1.RenewRestraintRequest();
      case 'CheckRestraint':
        return $1.CheckRestraintRequest();
      case 'DiscontinueRestraint':
        return $1.DiscontinueRestraintRequest();
      case 'ListRestraints':
        return $1.ListRestraintsRequest();
      case 'GetRestraintAlerts':
        return $1.GetRestraintAlertsRequest();
      case 'StartTransfusion':
        return $1.StartTransfusionRequest();
      case 'ObserveTransfusion':
        return $1.ObserveTransfusionRequest();
      case 'ReportTransfusionReaction':
        return $1.ReportTransfusionReactionRequest();
      case 'CompleteTransfusion':
        return $1.CompleteTransfusionRequest();
      case 'AssessWound':
        return $1.AssessWoundRequest();
      case 'AttachWoundImage':
        return $1.AttachWoundImageRequest();
      case 'GetWoundHistory':
        return $1.GetWoundHistoryRequest();
      case 'RecordEducation':
        return $1.RecordEducationRequest();
      case 'GetDischargeReadiness':
        return $1.GetDischargeReadinessRequest();
      case 'AssignNurse':
        return $1.AssignNurseRequest();
      case 'EndAssignment':
        return $1.EndAssignmentRequest();
      case 'ListAssignments':
        return $1.ListAssignmentsRequest();
      case 'GetUnitAcuity':
        return $1.GetUnitAcuityRequest();
      case 'SetAcuityWeights':
        return $1.SetAcuityWeightsRequest();
      case 'DeclareDowntime':
        return $1.DeclareDowntimeRequest();
      case 'EndDowntime':
        return $1.EndDowntimeRequest();
      case 'ReconcileDowntime':
        return $1.ReconcileDowntimeRequest();
      case 'ListDowntime':
        return $1.ListDowntimeRequest();
      case 'GetSuspectedDuplicates':
        return $1.GetSuspectedDuplicatesRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ChartObservation':
        return chartObservation(ctx, request as $1.ChartObservationRequest);
      case 'GetFlowsheet':
        return getFlowsheet(ctx, request as $1.GetFlowsheetRequest);
      case 'RecordFluid':
        return recordFluid(ctx, request as $1.RecordFluidRequest);
      case 'CorrectFluid':
        return correctFluid(ctx, request as $1.CorrectFluidRequest);
      case 'GetFluidBalance':
        return getFluidBalance(ctx, request as $1.GetFluidBalanceRequest);
      case 'GetFluidTrail':
        return getFluidTrail(ctx, request as $1.GetFluidTrailRequest);
      case 'DefineAssessmentTemplate':
        return defineAssessmentTemplate(
            ctx, request as $1.DefineAssessmentTemplateRequest);
      case 'ListAssessmentTemplates':
        return listAssessmentTemplates(
            ctx, request as $1.ListAssessmentTemplatesRequest);
      case 'RetireAssessmentTemplate':
        return retireAssessmentTemplate(
            ctx, request as $1.RetireAssessmentTemplateRequest);
      case 'RecordAssessment':
        return recordAssessment(ctx, request as $1.RecordAssessmentRequest);
      case 'ListAssessments':
        return listAssessments(ctx, request as $1.ListAssessmentsRequest);
      case 'DefineRiskScale':
        return defineRiskScale(ctx, request as $1.DefineRiskScaleRequest);
      case 'ScoreRisk':
        return scoreRisk(ctx, request as $1.ScoreRiskRequest);
      case 'ListRiskAssessments':
        return listRiskAssessments(
            ctx, request as $1.ListRiskAssessmentsRequest);
      case 'ListDueReassessments':
        return listDueReassessments(
            ctx, request as $1.ListDueReassessmentsRequest);
      case 'InsertDevice':
        return insertDevice(ctx, request as $1.InsertDeviceRequest);
      case 'RemoveDevice':
        return removeDevice(ctx, request as $1.RemoveDeviceRequest);
      case 'RecordDeviceCare':
        return recordDeviceCare(ctx, request as $1.RecordDeviceCareRequest);
      case 'ListDevices':
        return listDevices(ctx, request as $1.ListDevicesRequest);
      case 'GetMedicationRound':
        return getMedicationRound(ctx, request as $1.GetMedicationRoundRequest);
      case 'Administer':
        return administer(ctx, request as $1.AdministerRequest);
      case 'ListAdministrations':
        return listAdministrations(
            ctx, request as $1.ListAdministrationsRequest);
      case 'GetOverrideReport':
        return getOverrideReport(ctx, request as $1.GetOverrideReportRequest);
      case 'SetAdministrationPolicy':
        return setAdministrationPolicy(
            ctx, request as $1.SetAdministrationPolicyRequest);
      case 'CreateCarePlan':
        return createCarePlan(ctx, request as $1.CreateCarePlanRequest);
      case 'ReviewCarePlan':
        return reviewCarePlan(ctx, request as $1.ReviewCarePlanRequest);
      case 'ListCarePlans':
        return listCarePlans(ctx, request as $1.ListCarePlansRequest);
      case 'CreateTask':
        return createTask(ctx, request as $1.CreateTaskRequest);
      case 'CompleteTask':
        return completeTask(ctx, request as $1.CompleteTaskRequest);
      case 'SkipTask':
        return skipTask(ctx, request as $1.SkipTaskRequest);
      case 'GetWorklist':
        return getWorklist(ctx, request as $1.GetWorklistRequest);
      case 'EscalateOverdueWork':
        return escalateOverdueWork(
            ctx, request as $1.EscalateOverdueWorkRequest);
      case 'ComposeHandover':
        return composeHandover(ctx, request as $1.ComposeHandoverRequest);
      case 'AcknowledgeHandover':
        return acknowledgeHandover(
            ctx, request as $1.AcknowledgeHandoverRequest);
      case 'ListHandovers':
        return listHandovers(ctx, request as $1.ListHandoversRequest);
      case 'ApplyRestraint':
        return applyRestraint(ctx, request as $1.ApplyRestraintRequest);
      case 'RenewRestraint':
        return renewRestraint(ctx, request as $1.RenewRestraintRequest);
      case 'CheckRestraint':
        return checkRestraint(ctx, request as $1.CheckRestraintRequest);
      case 'DiscontinueRestraint':
        return discontinueRestraint(
            ctx, request as $1.DiscontinueRestraintRequest);
      case 'ListRestraints':
        return listRestraints(ctx, request as $1.ListRestraintsRequest);
      case 'GetRestraintAlerts':
        return getRestraintAlerts(ctx, request as $1.GetRestraintAlertsRequest);
      case 'StartTransfusion':
        return startTransfusion(ctx, request as $1.StartTransfusionRequest);
      case 'ObserveTransfusion':
        return observeTransfusion(ctx, request as $1.ObserveTransfusionRequest);
      case 'ReportTransfusionReaction':
        return reportTransfusionReaction(
            ctx, request as $1.ReportTransfusionReactionRequest);
      case 'CompleteTransfusion':
        return completeTransfusion(
            ctx, request as $1.CompleteTransfusionRequest);
      case 'AssessWound':
        return assessWound(ctx, request as $1.AssessWoundRequest);
      case 'AttachWoundImage':
        return attachWoundImage(ctx, request as $1.AttachWoundImageRequest);
      case 'GetWoundHistory':
        return getWoundHistory(ctx, request as $1.GetWoundHistoryRequest);
      case 'RecordEducation':
        return recordEducation(ctx, request as $1.RecordEducationRequest);
      case 'GetDischargeReadiness':
        return getDischargeReadiness(
            ctx, request as $1.GetDischargeReadinessRequest);
      case 'AssignNurse':
        return assignNurse(ctx, request as $1.AssignNurseRequest);
      case 'EndAssignment':
        return endAssignment(ctx, request as $1.EndAssignmentRequest);
      case 'ListAssignments':
        return listAssignments(ctx, request as $1.ListAssignmentsRequest);
      case 'GetUnitAcuity':
        return getUnitAcuity(ctx, request as $1.GetUnitAcuityRequest);
      case 'SetAcuityWeights':
        return setAcuityWeights(ctx, request as $1.SetAcuityWeightsRequest);
      case 'DeclareDowntime':
        return declareDowntime(ctx, request as $1.DeclareDowntimeRequest);
      case 'EndDowntime':
        return endDowntime(ctx, request as $1.EndDowntimeRequest);
      case 'ReconcileDowntime':
        return reconcileDowntime(ctx, request as $1.ReconcileDowntimeRequest);
      case 'ListDowntime':
        return listDowntime(ctx, request as $1.ListDowntimeRequest);
      case 'GetSuspectedDuplicates':
        return getSuspectedDuplicates(
            ctx, request as $1.GetSuspectedDuplicatesRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => NursingServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => NursingServiceBase$messageJson;
}
