// This is a generated file - do not edit.
//
// Generated from healthcare/medication/v1/medication.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'medication.pb.dart' as $1;
import 'medication.pbjson.dart';

export 'medication.pb.dart';

abstract class MedicationServiceBase extends $pb.GeneratedService {
  $async.Future<$1.PrescribeResponse> prescribe(
      $pb.ServerContext ctx, $1.PrescribeRequest request);
  $async.Future<$1.GetPrescriptionResponse> getPrescription(
      $pb.ServerContext ctx, $1.GetPrescriptionRequest request);
  $async.Future<$1.ListPrescriptionsResponse> listPrescriptions(
      $pb.ServerContext ctx, $1.ListPrescriptionsRequest request);
  $async.Future<$1.HoldTherapyResponse> holdTherapy(
      $pb.ServerContext ctx, $1.HoldTherapyRequest request);
  $async.Future<$1.RestartTherapyResponse> restartTherapy(
      $pb.ServerContext ctx, $1.RestartTherapyRequest request);
  $async.Future<$1.DiscontinueTherapyResponse> discontinueTherapy(
      $pb.ServerContext ctx, $1.DiscontinueTherapyRequest request);
  $async.Future<$1.VerifyPrescriptionResponse> verifyPrescription(
      $pb.ServerContext ctx, $1.VerifyPrescriptionRequest request);
  $async.Future<$1.VerificationQueueResponse> verificationQueue(
      $pb.ServerContext ctx, $1.VerificationQueueRequest request);
  $async.Future<$1.DueDosesResponse> dueDoses(
      $pb.ServerContext ctx, $1.DueDosesRequest request);
  $async.Future<$1.StartReconciliationResponse> startReconciliation(
      $pb.ServerContext ctx, $1.StartReconciliationRequest request);
  $async.Future<$1.DecideReconciliationResponse> decideReconciliation(
      $pb.ServerContext ctx, $1.DecideReconciliationRequest request);
  $async.Future<$1.CompleteReconciliationResponse> completeReconciliation(
      $pb.ServerContext ctx, $1.CompleteReconciliationRequest request);
  $async.Future<$1.ListReconciliationsResponse> listReconciliations(
      $pb.ServerContext ctx, $1.ListReconciliationsRequest request);
  $async.Future<$1.ProposeSubstitutionResponse> proposeSubstitution(
      $pb.ServerContext ctx, $1.ProposeSubstitutionRequest request);
  $async.Future<$1.AuthorizeSubstitutionResponse> authorizeSubstitution(
      $pb.ServerContext ctx, $1.AuthorizeSubstitutionRequest request);
  $async.Future<$1.RejectSubstitutionResponse> rejectSubstitution(
      $pb.ServerContext ctx, $1.RejectSubstitutionRequest request);
  $async.Future<$1.DispenseSubstitutionResponse> dispenseSubstitution(
      $pb.ServerContext ctx, $1.DispenseSubstitutionRequest request);
  $async.Future<$1.ListSubstitutionsResponse> listSubstitutions(
      $pb.ServerContext ctx, $1.ListSubstitutionsRequest request);
  $async.Future<$1.SetFormularyEntryResponse> setFormularyEntry(
      $pb.ServerContext ctx, $1.SetFormularyEntryRequest request);
  $async.Future<$1.SetInteractionRuleResponse> setInteractionRule(
      $pb.ServerContext ctx, $1.SetInteractionRuleRequest request);
  $async.Future<$1.ListInteractionRulesResponse> listInteractionRules(
      $pb.ServerContext ctx, $1.ListInteractionRulesRequest request);
  $async.Future<$1.SetDoseRuleResponse> setDoseRule(
      $pb.ServerContext ctx, $1.SetDoseRuleRequest request);
  $async.Future<$1.SetTerminologyMappingResponse> setTerminologyMapping(
      $pb.ServerContext ctx, $1.SetTerminologyMappingRequest request);
  $async.Future<$1.SetMedicationPolicyResponse> setMedicationPolicy(
      $pb.ServerContext ctx, $1.SetMedicationPolicyRequest request);
  $async.Future<$1.GetMedicationPolicyResponse> getMedicationPolicy(
      $pb.ServerContext ctx, $1.GetMedicationPolicyRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Prescribe':
        return $1.PrescribeRequest();
      case 'GetPrescription':
        return $1.GetPrescriptionRequest();
      case 'ListPrescriptions':
        return $1.ListPrescriptionsRequest();
      case 'HoldTherapy':
        return $1.HoldTherapyRequest();
      case 'RestartTherapy':
        return $1.RestartTherapyRequest();
      case 'DiscontinueTherapy':
        return $1.DiscontinueTherapyRequest();
      case 'VerifyPrescription':
        return $1.VerifyPrescriptionRequest();
      case 'VerificationQueue':
        return $1.VerificationQueueRequest();
      case 'DueDoses':
        return $1.DueDosesRequest();
      case 'StartReconciliation':
        return $1.StartReconciliationRequest();
      case 'DecideReconciliation':
        return $1.DecideReconciliationRequest();
      case 'CompleteReconciliation':
        return $1.CompleteReconciliationRequest();
      case 'ListReconciliations':
        return $1.ListReconciliationsRequest();
      case 'ProposeSubstitution':
        return $1.ProposeSubstitutionRequest();
      case 'AuthorizeSubstitution':
        return $1.AuthorizeSubstitutionRequest();
      case 'RejectSubstitution':
        return $1.RejectSubstitutionRequest();
      case 'DispenseSubstitution':
        return $1.DispenseSubstitutionRequest();
      case 'ListSubstitutions':
        return $1.ListSubstitutionsRequest();
      case 'SetFormularyEntry':
        return $1.SetFormularyEntryRequest();
      case 'SetInteractionRule':
        return $1.SetInteractionRuleRequest();
      case 'ListInteractionRules':
        return $1.ListInteractionRulesRequest();
      case 'SetDoseRule':
        return $1.SetDoseRuleRequest();
      case 'SetTerminologyMapping':
        return $1.SetTerminologyMappingRequest();
      case 'SetMedicationPolicy':
        return $1.SetMedicationPolicyRequest();
      case 'GetMedicationPolicy':
        return $1.GetMedicationPolicyRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Prescribe':
        return prescribe(ctx, request as $1.PrescribeRequest);
      case 'GetPrescription':
        return getPrescription(ctx, request as $1.GetPrescriptionRequest);
      case 'ListPrescriptions':
        return listPrescriptions(ctx, request as $1.ListPrescriptionsRequest);
      case 'HoldTherapy':
        return holdTherapy(ctx, request as $1.HoldTherapyRequest);
      case 'RestartTherapy':
        return restartTherapy(ctx, request as $1.RestartTherapyRequest);
      case 'DiscontinueTherapy':
        return discontinueTherapy(ctx, request as $1.DiscontinueTherapyRequest);
      case 'VerifyPrescription':
        return verifyPrescription(ctx, request as $1.VerifyPrescriptionRequest);
      case 'VerificationQueue':
        return verificationQueue(ctx, request as $1.VerificationQueueRequest);
      case 'DueDoses':
        return dueDoses(ctx, request as $1.DueDosesRequest);
      case 'StartReconciliation':
        return startReconciliation(
            ctx, request as $1.StartReconciliationRequest);
      case 'DecideReconciliation':
        return decideReconciliation(
            ctx, request as $1.DecideReconciliationRequest);
      case 'CompleteReconciliation':
        return completeReconciliation(
            ctx, request as $1.CompleteReconciliationRequest);
      case 'ListReconciliations':
        return listReconciliations(
            ctx, request as $1.ListReconciliationsRequest);
      case 'ProposeSubstitution':
        return proposeSubstitution(
            ctx, request as $1.ProposeSubstitutionRequest);
      case 'AuthorizeSubstitution':
        return authorizeSubstitution(
            ctx, request as $1.AuthorizeSubstitutionRequest);
      case 'RejectSubstitution':
        return rejectSubstitution(ctx, request as $1.RejectSubstitutionRequest);
      case 'DispenseSubstitution':
        return dispenseSubstitution(
            ctx, request as $1.DispenseSubstitutionRequest);
      case 'ListSubstitutions':
        return listSubstitutions(ctx, request as $1.ListSubstitutionsRequest);
      case 'SetFormularyEntry':
        return setFormularyEntry(ctx, request as $1.SetFormularyEntryRequest);
      case 'SetInteractionRule':
        return setInteractionRule(ctx, request as $1.SetInteractionRuleRequest);
      case 'ListInteractionRules':
        return listInteractionRules(
            ctx, request as $1.ListInteractionRulesRequest);
      case 'SetDoseRule':
        return setDoseRule(ctx, request as $1.SetDoseRuleRequest);
      case 'SetTerminologyMapping':
        return setTerminologyMapping(
            ctx, request as $1.SetTerminologyMappingRequest);
      case 'SetMedicationPolicy':
        return setMedicationPolicy(
            ctx, request as $1.SetMedicationPolicyRequest);
      case 'GetMedicationPolicy':
        return getMedicationPolicy(
            ctx, request as $1.GetMedicationPolicyRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      MedicationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => MedicationServiceBase$messageJson;
}
