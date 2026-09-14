// This is a generated file - do not edit.
//
// Generated from healthcare/clinical/v1/clinical.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'clinical.pb.dart' as $1;
import 'clinical.pbjson.dart';

export 'clinical.pb.dart';

abstract class ClinicalServiceBase extends $pb.GeneratedService {
  $async.Future<$1.WriteNoteResponse> writeNote(
      $pb.ServerContext ctx, $1.WriteNoteRequest request);
  $async.Future<$1.SignNoteResponse> signNote(
      $pb.ServerContext ctx, $1.SignNoteRequest request);
  $async.Future<$1.AmendNoteResponse> amendNote(
      $pb.ServerContext ctx, $1.AmendNoteRequest request);
  $async.Future<$1.RetractNoteResponse> retractNote(
      $pb.ServerContext ctx, $1.RetractNoteRequest request);
  $async.Future<$1.GetNoteResponse> getNote(
      $pb.ServerContext ctx, $1.GetNoteRequest request);
  $async.Future<$1.ListNotesResponse> listNotes(
      $pb.ServerContext ctx, $1.ListNotesRequest request);
  $async.Future<$1.DefineTemplateResponse> defineTemplate(
      $pb.ServerContext ctx, $1.DefineTemplateRequest request);
  $async.Future<$1.ListTemplatesResponse> listTemplates(
      $pb.ServerContext ctx, $1.ListTemplatesRequest request);
  $async.Future<$1.RetireTemplateResponse> retireTemplate(
      $pb.ServerContext ctx, $1.RetireTemplateRequest request);
  $async.Future<$1.DefineSmartPhraseResponse> defineSmartPhrase(
      $pb.ServerContext ctx, $1.DefineSmartPhraseRequest request);
  $async.Future<$1.ListSmartPhrasesResponse> listSmartPhrases(
      $pb.ServerContext ctx, $1.ListSmartPhrasesRequest request);
  $async.Future<$1.RecordProblemResponse> recordProblem(
      $pb.ServerContext ctx, $1.RecordProblemRequest request);
  $async.Future<$1.UpdateProblemResponse> updateProblem(
      $pb.ServerContext ctx, $1.UpdateProblemRequest request);
  $async.Future<$1.ListProblemsResponse> listProblems(
      $pb.ServerContext ctx, $1.ListProblemsRequest request);
  $async.Future<$1.RecordAllergyResponse> recordAllergy(
      $pb.ServerContext ctx, $1.RecordAllergyRequest request);
  $async.Future<$1.VerifyAllergyResponse> verifyAllergy(
      $pb.ServerContext ctx, $1.VerifyAllergyRequest request);
  $async.Future<$1.ListAllergiesResponse> listAllergies(
      $pb.ServerContext ctx, $1.ListAllergiesRequest request);
  $async.Future<$1.RecordObservationResponse> recordObservation(
      $pb.ServerContext ctx, $1.RecordObservationRequest request);
  $async.Future<$1.ListObservationsResponse> listObservations(
      $pb.ServerContext ctx, $1.ListObservationsRequest request);
  $async.Future<$1.ListCriticalResultsResponse> listCriticalResults(
      $pb.ServerContext ctx, $1.ListCriticalResultsRequest request);
  $async.Future<$1.AcknowledgeCriticalResultResponse> acknowledgeCriticalResult(
      $pb.ServerContext ctx, $1.AcknowledgeCriticalResultRequest request);
  $async.Future<$1.RecordProcedureResponse> recordProcedure(
      $pb.ServerContext ctx, $1.RecordProcedureRequest request);
  $async.Future<$1.ListProceduresResponse> listProcedures(
      $pb.ServerContext ctx, $1.ListProceduresRequest request);
  $async.Future<$1.CreateCarePlanResponse> createCarePlan(
      $pb.ServerContext ctx, $1.CreateCarePlanRequest request);
  $async.Future<$1.UpdateCarePlanResponse> updateCarePlan(
      $pb.ServerContext ctx, $1.UpdateCarePlanRequest request);
  $async.Future<$1.ListCarePlansResponse> listCarePlans(
      $pb.ServerContext ctx, $1.ListCarePlansRequest request);
  $async.Future<$1.GetBannerResponse> getBanner(
      $pb.ServerContext ctx, $1.GetBannerRequest request);
  $async.Future<$1.RecordConsentResponse> recordConsent(
      $pb.ServerContext ctx, $1.RecordConsentRequest request);
  $async.Future<$1.WithdrawConsentResponse> withdrawConsent(
      $pb.ServerContext ctx, $1.WithdrawConsentRequest request);
  $async.Future<$1.ListConsentsResponse> listConsents(
      $pb.ServerContext ctx, $1.ListConsentsRequest request);
  $async.Future<$1.AttachFileResponse> attachFile(
      $pb.ServerContext ctx, $1.AttachFileRequest request);
  $async.Future<$1.ListAttachmentsResponse> listAttachments(
      $pb.ServerContext ctx, $1.ListAttachmentsRequest request);
  $async.Future<$1.GetProvenanceResponse> getProvenance(
      $pb.ServerContext ctx, $1.GetProvenanceRequest request);
  $async.Future<$1.StoreCalculationResponse> storeCalculation(
      $pb.ServerContext ctx, $1.StoreCalculationRequest request);
  $async.Future<$1.ListCalculationsResponse> listCalculations(
      $pb.ServerContext ctx, $1.ListCalculationsRequest request);
  $async.Future<$1.RaiseAlertResponse> raiseAlert(
      $pb.ServerContext ctx, $1.RaiseAlertRequest request);
  $async.Future<$1.RespondToAlertResponse> respondToAlert(
      $pb.ServerContext ctx, $1.RespondToAlertRequest request);
  $async.Future<$1.ListAlertsResponse> listAlerts(
      $pb.ServerContext ctx, $1.ListAlertsRequest request);
  $async.Future<$1.RequestConsultResponse> requestConsult(
      $pb.ServerContext ctx, $1.RequestConsultRequest request);
  $async.Future<$1.RespondToConsultResponse> respondToConsult(
      $pb.ServerContext ctx, $1.RespondToConsultRequest request);
  $async.Future<$1.ListConsultsResponse> listConsults(
      $pb.ServerContext ctx, $1.ListConsultsRequest request);
  $async.Future<$1.EnrolInRegistryResponse> enrolInRegistry(
      $pb.ServerContext ctx, $1.EnrolInRegistryRequest request);
  $async.Future<$1.ExitRegistryResponse> exitRegistry(
      $pb.ServerContext ctx, $1.ExitRegistryRequest request);
  $async.Future<$1.ListRegistryMembershipsResponse> listRegistryMemberships(
      $pb.ServerContext ctx, $1.ListRegistryMembershipsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'WriteNote':
        return $1.WriteNoteRequest();
      case 'SignNote':
        return $1.SignNoteRequest();
      case 'AmendNote':
        return $1.AmendNoteRequest();
      case 'RetractNote':
        return $1.RetractNoteRequest();
      case 'GetNote':
        return $1.GetNoteRequest();
      case 'ListNotes':
        return $1.ListNotesRequest();
      case 'DefineTemplate':
        return $1.DefineTemplateRequest();
      case 'ListTemplates':
        return $1.ListTemplatesRequest();
      case 'RetireTemplate':
        return $1.RetireTemplateRequest();
      case 'DefineSmartPhrase':
        return $1.DefineSmartPhraseRequest();
      case 'ListSmartPhrases':
        return $1.ListSmartPhrasesRequest();
      case 'RecordProblem':
        return $1.RecordProblemRequest();
      case 'UpdateProblem':
        return $1.UpdateProblemRequest();
      case 'ListProblems':
        return $1.ListProblemsRequest();
      case 'RecordAllergy':
        return $1.RecordAllergyRequest();
      case 'VerifyAllergy':
        return $1.VerifyAllergyRequest();
      case 'ListAllergies':
        return $1.ListAllergiesRequest();
      case 'RecordObservation':
        return $1.RecordObservationRequest();
      case 'ListObservations':
        return $1.ListObservationsRequest();
      case 'ListCriticalResults':
        return $1.ListCriticalResultsRequest();
      case 'AcknowledgeCriticalResult':
        return $1.AcknowledgeCriticalResultRequest();
      case 'RecordProcedure':
        return $1.RecordProcedureRequest();
      case 'ListProcedures':
        return $1.ListProceduresRequest();
      case 'CreateCarePlan':
        return $1.CreateCarePlanRequest();
      case 'UpdateCarePlan':
        return $1.UpdateCarePlanRequest();
      case 'ListCarePlans':
        return $1.ListCarePlansRequest();
      case 'GetBanner':
        return $1.GetBannerRequest();
      case 'RecordConsent':
        return $1.RecordConsentRequest();
      case 'WithdrawConsent':
        return $1.WithdrawConsentRequest();
      case 'ListConsents':
        return $1.ListConsentsRequest();
      case 'AttachFile':
        return $1.AttachFileRequest();
      case 'ListAttachments':
        return $1.ListAttachmentsRequest();
      case 'GetProvenance':
        return $1.GetProvenanceRequest();
      case 'StoreCalculation':
        return $1.StoreCalculationRequest();
      case 'ListCalculations':
        return $1.ListCalculationsRequest();
      case 'RaiseAlert':
        return $1.RaiseAlertRequest();
      case 'RespondToAlert':
        return $1.RespondToAlertRequest();
      case 'ListAlerts':
        return $1.ListAlertsRequest();
      case 'RequestConsult':
        return $1.RequestConsultRequest();
      case 'RespondToConsult':
        return $1.RespondToConsultRequest();
      case 'ListConsults':
        return $1.ListConsultsRequest();
      case 'EnrolInRegistry':
        return $1.EnrolInRegistryRequest();
      case 'ExitRegistry':
        return $1.ExitRegistryRequest();
      case 'ListRegistryMemberships':
        return $1.ListRegistryMembershipsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'WriteNote':
        return writeNote(ctx, request as $1.WriteNoteRequest);
      case 'SignNote':
        return signNote(ctx, request as $1.SignNoteRequest);
      case 'AmendNote':
        return amendNote(ctx, request as $1.AmendNoteRequest);
      case 'RetractNote':
        return retractNote(ctx, request as $1.RetractNoteRequest);
      case 'GetNote':
        return getNote(ctx, request as $1.GetNoteRequest);
      case 'ListNotes':
        return listNotes(ctx, request as $1.ListNotesRequest);
      case 'DefineTemplate':
        return defineTemplate(ctx, request as $1.DefineTemplateRequest);
      case 'ListTemplates':
        return listTemplates(ctx, request as $1.ListTemplatesRequest);
      case 'RetireTemplate':
        return retireTemplate(ctx, request as $1.RetireTemplateRequest);
      case 'DefineSmartPhrase':
        return defineSmartPhrase(ctx, request as $1.DefineSmartPhraseRequest);
      case 'ListSmartPhrases':
        return listSmartPhrases(ctx, request as $1.ListSmartPhrasesRequest);
      case 'RecordProblem':
        return recordProblem(ctx, request as $1.RecordProblemRequest);
      case 'UpdateProblem':
        return updateProblem(ctx, request as $1.UpdateProblemRequest);
      case 'ListProblems':
        return listProblems(ctx, request as $1.ListProblemsRequest);
      case 'RecordAllergy':
        return recordAllergy(ctx, request as $1.RecordAllergyRequest);
      case 'VerifyAllergy':
        return verifyAllergy(ctx, request as $1.VerifyAllergyRequest);
      case 'ListAllergies':
        return listAllergies(ctx, request as $1.ListAllergiesRequest);
      case 'RecordObservation':
        return recordObservation(ctx, request as $1.RecordObservationRequest);
      case 'ListObservations':
        return listObservations(ctx, request as $1.ListObservationsRequest);
      case 'ListCriticalResults':
        return listCriticalResults(
            ctx, request as $1.ListCriticalResultsRequest);
      case 'AcknowledgeCriticalResult':
        return acknowledgeCriticalResult(
            ctx, request as $1.AcknowledgeCriticalResultRequest);
      case 'RecordProcedure':
        return recordProcedure(ctx, request as $1.RecordProcedureRequest);
      case 'ListProcedures':
        return listProcedures(ctx, request as $1.ListProceduresRequest);
      case 'CreateCarePlan':
        return createCarePlan(ctx, request as $1.CreateCarePlanRequest);
      case 'UpdateCarePlan':
        return updateCarePlan(ctx, request as $1.UpdateCarePlanRequest);
      case 'ListCarePlans':
        return listCarePlans(ctx, request as $1.ListCarePlansRequest);
      case 'GetBanner':
        return getBanner(ctx, request as $1.GetBannerRequest);
      case 'RecordConsent':
        return recordConsent(ctx, request as $1.RecordConsentRequest);
      case 'WithdrawConsent':
        return withdrawConsent(ctx, request as $1.WithdrawConsentRequest);
      case 'ListConsents':
        return listConsents(ctx, request as $1.ListConsentsRequest);
      case 'AttachFile':
        return attachFile(ctx, request as $1.AttachFileRequest);
      case 'ListAttachments':
        return listAttachments(ctx, request as $1.ListAttachmentsRequest);
      case 'GetProvenance':
        return getProvenance(ctx, request as $1.GetProvenanceRequest);
      case 'StoreCalculation':
        return storeCalculation(ctx, request as $1.StoreCalculationRequest);
      case 'ListCalculations':
        return listCalculations(ctx, request as $1.ListCalculationsRequest);
      case 'RaiseAlert':
        return raiseAlert(ctx, request as $1.RaiseAlertRequest);
      case 'RespondToAlert':
        return respondToAlert(ctx, request as $1.RespondToAlertRequest);
      case 'ListAlerts':
        return listAlerts(ctx, request as $1.ListAlertsRequest);
      case 'RequestConsult':
        return requestConsult(ctx, request as $1.RequestConsultRequest);
      case 'RespondToConsult':
        return respondToConsult(ctx, request as $1.RespondToConsultRequest);
      case 'ListConsults':
        return listConsults(ctx, request as $1.ListConsultsRequest);
      case 'EnrolInRegistry':
        return enrolInRegistry(ctx, request as $1.EnrolInRegistryRequest);
      case 'ExitRegistry':
        return exitRegistry(ctx, request as $1.ExitRegistryRequest);
      case 'ListRegistryMemberships':
        return listRegistryMemberships(
            ctx, request as $1.ListRegistryMembershipsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ClinicalServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ClinicalServiceBase$messageJson;
}
