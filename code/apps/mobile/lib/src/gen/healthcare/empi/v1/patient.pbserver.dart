// This is a generated file - do not edit.
//
// Generated from healthcare/empi/v1/patient.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'patient.pb.dart' as $1;
import 'patient.pbjson.dart';

export 'patient.pb.dart';

abstract class PatientServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterPatientResponse> registerPatient(
      $pb.ServerContext ctx, $1.RegisterPatientRequest request);
  $async.Future<$1.SearchPatientsResponse> searchPatients(
      $pb.ServerContext ctx, $1.SearchPatientsRequest request);
  $async.Future<$1.GetPatientResponse> getPatient(
      $pb.ServerContext ctx, $1.GetPatientRequest request);
  $async.Future<$1.UpdateDemographicsResponse> updateDemographics(
      $pb.ServerContext ctx, $1.UpdateDemographicsRequest request);
  $async.Future<$1.ConfirmIdentityResponse> confirmIdentity(
      $pb.ServerContext ctx, $1.ConfirmIdentityRequest request);
  $async.Future<$1.MergePatientsResponse> mergePatients(
      $pb.ServerContext ctx, $1.MergePatientsRequest request);
  $async.Future<$1.UnmergePatientsResponse> unmergePatients(
      $pb.ServerContext ctx, $1.UnmergePatientsRequest request);
  $async.Future<$1.ListDuplicateCandidatesResponse> listDuplicateCandidates(
      $pb.ServerContext ctx, $1.ListDuplicateCandidatesRequest request);
  $async.Future<$1.DismissDuplicateCandidateResponse> dismissDuplicateCandidate(
      $pb.ServerContext ctx, $1.DismissDuplicateCandidateRequest request);
  $async.Future<$1.RegisterUnidentifiedResponse> registerUnidentified(
      $pb.ServerContext ctx, $1.RegisterUnidentifiedRequest request);
  $async.Future<$1.IdentifyPatientResponse> identifyPatient(
      $pb.ServerContext ctx, $1.IdentifyPatientRequest request);
  $async.Future<$1.ListUnidentifiedResponse> listUnidentified(
      $pb.ServerContext ctx, $1.ListUnidentifiedRequest request);
  $async.Future<$1.CapturePhotoResponse> capturePhoto(
      $pb.ServerContext ctx, $1.CapturePhotoRequest request);
  $async.Future<$1.GetPhotoResponse> getPhoto(
      $pb.ServerContext ctx, $1.GetPhotoRequest request);
  $async.Future<$1.WithdrawPhotoConsentResponse> withdrawPhotoConsent(
      $pb.ServerContext ctx, $1.WithdrawPhotoConsentRequest request);
  $async.Future<$1.ConfigureFieldAccessResponse> configureFieldAccess(
      $pb.ServerContext ctx, $1.ConfigureFieldAccessRequest request);
  $async.Future<$1.LinkIdentifierResponse> linkIdentifier(
      $pb.ServerContext ctx, $1.LinkIdentifierRequest request);
  $async.Future<$1.UnlinkIdentifierResponse> unlinkIdentifier(
      $pb.ServerContext ctx, $1.UnlinkIdentifierRequest request);
  $async.Future<$1.VerifyIdentifierResponse> verifyIdentifier(
      $pb.ServerContext ctx, $1.VerifyIdentifierRequest request);
  $async.Future<$1.SubmitExternalDemographicsResponse>
      submitExternalDemographics(
          $pb.ServerContext ctx, $1.SubmitExternalDemographicsRequest request);
  $async.Future<$1.RequestCorrectionResponse> requestCorrection(
      $pb.ServerContext ctx, $1.RequestCorrectionRequest request);
  $async.Future<$1.ListDemographicProposalsResponse> listDemographicProposals(
      $pb.ServerContext ctx, $1.ListDemographicProposalsRequest request);
  $async.Future<$1.ResolveDemographicProposalResponse>
      resolveDemographicProposal(
          $pb.ServerContext ctx, $1.ResolveDemographicProposalRequest request);
  $async.Future<$1.WithdrawDemographicProposalResponse>
      withdrawDemographicProposal(
          $pb.ServerContext ctx, $1.WithdrawDemographicProposalRequest request);
  $async.Future<$1.RecordNameResponse> recordName(
      $pb.ServerContext ctx, $1.RecordNameRequest request);
  $async.Future<$1.GetPatientHistoryResponse> getPatientHistory(
      $pb.ServerContext ctx, $1.GetPatientHistoryRequest request);
  $async.Future<$1.RecordCommunicationPreferenceResponse>
      recordCommunicationPreference($pb.ServerContext ctx,
          $1.RecordCommunicationPreferenceRequest request);
  $async.Future<$1.RecordDeceasedResponse> recordDeceased(
      $pb.ServerContext ctx, $1.RecordDeceasedRequest request);
  $async.Future<$1.ReverseDeceasedResponse> reverseDeceased(
      $pb.ServerContext ctx, $1.ReverseDeceasedRequest request);
  $async.Future<$1.AddRelatedPersonResponse> addRelatedPerson(
      $pb.ServerContext ctx, $1.AddRelatedPersonRequest request);
  $async.Future<$1.VerifyRelatedPersonResponse> verifyRelatedPerson(
      $pb.ServerContext ctx, $1.VerifyRelatedPersonRequest request);
  $async.Future<$1.EndRelatedPersonResponse> endRelatedPerson(
      $pb.ServerContext ctx, $1.EndRelatedPersonRequest request);
  $async.Future<$1.GetCaregiverAuthorityResponse> getCaregiverAuthority(
      $pb.ServerContext ctx, $1.GetCaregiverAuthorityRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterPatient':
        return $1.RegisterPatientRequest();
      case 'SearchPatients':
        return $1.SearchPatientsRequest();
      case 'GetPatient':
        return $1.GetPatientRequest();
      case 'UpdateDemographics':
        return $1.UpdateDemographicsRequest();
      case 'ConfirmIdentity':
        return $1.ConfirmIdentityRequest();
      case 'MergePatients':
        return $1.MergePatientsRequest();
      case 'UnmergePatients':
        return $1.UnmergePatientsRequest();
      case 'ListDuplicateCandidates':
        return $1.ListDuplicateCandidatesRequest();
      case 'DismissDuplicateCandidate':
        return $1.DismissDuplicateCandidateRequest();
      case 'RegisterUnidentified':
        return $1.RegisterUnidentifiedRequest();
      case 'IdentifyPatient':
        return $1.IdentifyPatientRequest();
      case 'ListUnidentified':
        return $1.ListUnidentifiedRequest();
      case 'CapturePhoto':
        return $1.CapturePhotoRequest();
      case 'GetPhoto':
        return $1.GetPhotoRequest();
      case 'WithdrawPhotoConsent':
        return $1.WithdrawPhotoConsentRequest();
      case 'ConfigureFieldAccess':
        return $1.ConfigureFieldAccessRequest();
      case 'LinkIdentifier':
        return $1.LinkIdentifierRequest();
      case 'UnlinkIdentifier':
        return $1.UnlinkIdentifierRequest();
      case 'VerifyIdentifier':
        return $1.VerifyIdentifierRequest();
      case 'SubmitExternalDemographics':
        return $1.SubmitExternalDemographicsRequest();
      case 'RequestCorrection':
        return $1.RequestCorrectionRequest();
      case 'ListDemographicProposals':
        return $1.ListDemographicProposalsRequest();
      case 'ResolveDemographicProposal':
        return $1.ResolveDemographicProposalRequest();
      case 'WithdrawDemographicProposal':
        return $1.WithdrawDemographicProposalRequest();
      case 'RecordName':
        return $1.RecordNameRequest();
      case 'GetPatientHistory':
        return $1.GetPatientHistoryRequest();
      case 'RecordCommunicationPreference':
        return $1.RecordCommunicationPreferenceRequest();
      case 'RecordDeceased':
        return $1.RecordDeceasedRequest();
      case 'ReverseDeceased':
        return $1.ReverseDeceasedRequest();
      case 'AddRelatedPerson':
        return $1.AddRelatedPersonRequest();
      case 'VerifyRelatedPerson':
        return $1.VerifyRelatedPersonRequest();
      case 'EndRelatedPerson':
        return $1.EndRelatedPersonRequest();
      case 'GetCaregiverAuthority':
        return $1.GetCaregiverAuthorityRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterPatient':
        return registerPatient(ctx, request as $1.RegisterPatientRequest);
      case 'SearchPatients':
        return searchPatients(ctx, request as $1.SearchPatientsRequest);
      case 'GetPatient':
        return getPatient(ctx, request as $1.GetPatientRequest);
      case 'UpdateDemographics':
        return updateDemographics(ctx, request as $1.UpdateDemographicsRequest);
      case 'ConfirmIdentity':
        return confirmIdentity(ctx, request as $1.ConfirmIdentityRequest);
      case 'MergePatients':
        return mergePatients(ctx, request as $1.MergePatientsRequest);
      case 'UnmergePatients':
        return unmergePatients(ctx, request as $1.UnmergePatientsRequest);
      case 'ListDuplicateCandidates':
        return listDuplicateCandidates(
            ctx, request as $1.ListDuplicateCandidatesRequest);
      case 'DismissDuplicateCandidate':
        return dismissDuplicateCandidate(
            ctx, request as $1.DismissDuplicateCandidateRequest);
      case 'RegisterUnidentified':
        return registerUnidentified(
            ctx, request as $1.RegisterUnidentifiedRequest);
      case 'IdentifyPatient':
        return identifyPatient(ctx, request as $1.IdentifyPatientRequest);
      case 'ListUnidentified':
        return listUnidentified(ctx, request as $1.ListUnidentifiedRequest);
      case 'CapturePhoto':
        return capturePhoto(ctx, request as $1.CapturePhotoRequest);
      case 'GetPhoto':
        return getPhoto(ctx, request as $1.GetPhotoRequest);
      case 'WithdrawPhotoConsent':
        return withdrawPhotoConsent(
            ctx, request as $1.WithdrawPhotoConsentRequest);
      case 'ConfigureFieldAccess':
        return configureFieldAccess(
            ctx, request as $1.ConfigureFieldAccessRequest);
      case 'LinkIdentifier':
        return linkIdentifier(ctx, request as $1.LinkIdentifierRequest);
      case 'UnlinkIdentifier':
        return unlinkIdentifier(ctx, request as $1.UnlinkIdentifierRequest);
      case 'VerifyIdentifier':
        return verifyIdentifier(ctx, request as $1.VerifyIdentifierRequest);
      case 'SubmitExternalDemographics':
        return submitExternalDemographics(
            ctx, request as $1.SubmitExternalDemographicsRequest);
      case 'RequestCorrection':
        return requestCorrection(ctx, request as $1.RequestCorrectionRequest);
      case 'ListDemographicProposals':
        return listDemographicProposals(
            ctx, request as $1.ListDemographicProposalsRequest);
      case 'ResolveDemographicProposal':
        return resolveDemographicProposal(
            ctx, request as $1.ResolveDemographicProposalRequest);
      case 'WithdrawDemographicProposal':
        return withdrawDemographicProposal(
            ctx, request as $1.WithdrawDemographicProposalRequest);
      case 'RecordName':
        return recordName(ctx, request as $1.RecordNameRequest);
      case 'GetPatientHistory':
        return getPatientHistory(ctx, request as $1.GetPatientHistoryRequest);
      case 'RecordCommunicationPreference':
        return recordCommunicationPreference(
            ctx, request as $1.RecordCommunicationPreferenceRequest);
      case 'RecordDeceased':
        return recordDeceased(ctx, request as $1.RecordDeceasedRequest);
      case 'ReverseDeceased':
        return reverseDeceased(ctx, request as $1.ReverseDeceasedRequest);
      case 'AddRelatedPerson':
        return addRelatedPerson(ctx, request as $1.AddRelatedPersonRequest);
      case 'VerifyRelatedPerson':
        return verifyRelatedPerson(
            ctx, request as $1.VerifyRelatedPersonRequest);
      case 'EndRelatedPerson':
        return endRelatedPerson(ctx, request as $1.EndRelatedPersonRequest);
      case 'GetCaregiverAuthority':
        return getCaregiverAuthority(
            ctx, request as $1.GetCaregiverAuthorityRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PatientServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => PatientServiceBase$messageJson;
}
