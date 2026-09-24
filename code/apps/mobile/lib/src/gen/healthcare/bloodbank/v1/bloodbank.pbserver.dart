// This is a generated file - do not edit.
//
// Generated from healthcare/bloodbank/v1/bloodbank.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'bloodbank.pb.dart' as $1;
import 'bloodbank.pbjson.dart';

export 'bloodbank.pb.dart';

abstract class BloodBankServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterDonorResponse> registerDonor(
      $pb.ServerContext ctx, $1.RegisterDonorRequest request);
  $async.Future<$1.GetDonorResponse> getDonor(
      $pb.ServerContext ctx, $1.GetDonorRequest request);
  $async.Future<$1.DeferDonorResponse> deferDonor(
      $pb.ServerContext ctx, $1.DeferDonorRequest request);
  $async.Future<$1.ReinstateDonorResponse> reinstateDonor(
      $pb.ServerContext ctx, $1.ReinstateDonorRequest request);
  $async.Future<$1.ListDeferredDonorsResponse> listDeferredDonors(
      $pb.ServerContext ctx, $1.ListDeferredDonorsRequest request);
  $async.Future<$1.ScreenDonorResponse> screenDonor(
      $pb.ServerContext ctx, $1.ScreenDonorRequest request);
  $async.Future<$1.CollectResponse> collect(
      $pb.ServerContext ctx, $1.CollectRequest request);
  $async.Future<$1.RecordTestResponse> recordTest(
      $pb.ServerContext ctx, $1.RecordTestRequest request);
  $async.Future<$1.GetReleaseDecisionResponse> getReleaseDecision(
      $pb.ServerContext ctx, $1.GetReleaseDecisionRequest request);
  $async.Future<$1.ReleaseComponentsResponse> releaseComponents(
      $pb.ServerContext ctx, $1.ReleaseComponentsRequest request);
  $async.Future<$1.AddComponentResponse> addComponent(
      $pb.ServerContext ctx, $1.AddComponentRequest request);
  $async.Future<$1.GetComponentResponse> getComponent(
      $pb.ServerContext ctx, $1.GetComponentRequest request);
  $async.Future<$1.DiscardComponentResponse> discardComponent(
      $pb.ServerContext ctx, $1.DiscardComponentRequest request);
  $async.Future<$1.PlaceRequestResponse> placeRequest(
      $pb.ServerContext ctx, $1.PlaceRequestRequest request);
  $async.Future<$1.GetWorklistResponse> getWorklist(
      $pb.ServerContext ctx, $1.GetWorklistRequest request);
  $async.Future<$1.ListPatientRequestsResponse> listPatientRequests(
      $pb.ServerContext ctx, $1.ListPatientRequestsRequest request);
  $async.Future<$1.GroupPatientResponse> groupPatient(
      $pb.ServerContext ctx, $1.GroupPatientRequest request);
  $async.Future<$1.FindCompatibleResponse> findCompatible(
      $pb.ServerContext ctx, $1.FindCompatibleRequest request);
  $async.Future<$1.ReserveResponse> reserve(
      $pb.ServerContext ctx, $1.ReserveRequest request);
  $async.Future<$1.ReleaseReservationResponse> releaseReservation(
      $pb.ServerContext ctx, $1.ReleaseReservationRequest request);
  $async.Future<$1.SweepLapsedReservationsResponse> sweepLapsedReservations(
      $pb.ServerContext ctx, $1.SweepLapsedReservationsRequest request);
  $async.Future<$1.IssueUnitResponse> issueUnit(
      $pb.ServerContext ctx, $1.IssueUnitRequest request);
  $async.Future<$1.ReconcileReleaseResponse> reconcileRelease(
      $pb.ServerContext ctx, $1.ReconcileReleaseRequest request);
  $async.Future<$1.ListOutstandingReleasesResponse> listOutstandingReleases(
      $pb.ServerContext ctx, $1.ListOutstandingReleasesRequest request);
  $async.Future<$1.VerifyBedsideResponse> verifyBedside(
      $pb.ServerContext ctx, $1.VerifyBedsideRequest request);
  $async.Future<$1.StartTransfusionResponse> startTransfusion(
      $pb.ServerContext ctx, $1.StartTransfusionRequest request);
  $async.Future<$1.ObserveResponse> observe(
      $pb.ServerContext ctx, $1.ObserveRequest request);
  $async.Future<$1.EndTransfusionResponse> endTransfusion(
      $pb.ServerContext ctx, $1.EndTransfusionRequest request);
  $async.Future<$1.GetEpisodeResponse> getEpisode(
      $pb.ServerContext ctx, $1.GetEpisodeRequest request);
  $async.Future<$1.ListPatientTransfusionsResponse> listPatientTransfusions(
      $pb.ServerContext ctx, $1.ListPatientTransfusionsRequest request);
  $async.Future<$1.ReportReactionResponse> reportReaction(
      $pb.ServerContext ctx, $1.ReportReactionRequest request);
  $async.Future<$1.ConcludeInvestigationResponse> concludeInvestigation(
      $pb.ServerContext ctx, $1.ConcludeInvestigationRequest request);
  $async.Future<$1.ListOpenInvestigationsResponse> listOpenInvestigations(
      $pb.ServerContext ctx, $1.ListOpenInvestigationsRequest request);
  $async.Future<$1.TraceUnitResponse> traceUnit(
      $pb.ServerContext ctx, $1.TraceUnitRequest request);
  $async.Future<$1.LookBackResponse> lookBack(
      $pb.ServerContext ctx, $1.LookBackRequest request);
  $async.Future<$1.SetThresholdResponse> setThreshold(
      $pb.ServerContext ctx, $1.SetThresholdRequest request);
  $async.Future<$1.GetStockResponse> getStock(
      $pb.ServerContext ctx, $1.GetStockRequest request);
  $async.Future<$1.GetUtilisationResponse> getUtilisation(
      $pb.ServerContext ctx, $1.GetUtilisationRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterDonor':
        return $1.RegisterDonorRequest();
      case 'GetDonor':
        return $1.GetDonorRequest();
      case 'DeferDonor':
        return $1.DeferDonorRequest();
      case 'ReinstateDonor':
        return $1.ReinstateDonorRequest();
      case 'ListDeferredDonors':
        return $1.ListDeferredDonorsRequest();
      case 'ScreenDonor':
        return $1.ScreenDonorRequest();
      case 'Collect':
        return $1.CollectRequest();
      case 'RecordTest':
        return $1.RecordTestRequest();
      case 'GetReleaseDecision':
        return $1.GetReleaseDecisionRequest();
      case 'ReleaseComponents':
        return $1.ReleaseComponentsRequest();
      case 'AddComponent':
        return $1.AddComponentRequest();
      case 'GetComponent':
        return $1.GetComponentRequest();
      case 'DiscardComponent':
        return $1.DiscardComponentRequest();
      case 'PlaceRequest':
        return $1.PlaceRequestRequest();
      case 'GetWorklist':
        return $1.GetWorklistRequest();
      case 'ListPatientRequests':
        return $1.ListPatientRequestsRequest();
      case 'GroupPatient':
        return $1.GroupPatientRequest();
      case 'FindCompatible':
        return $1.FindCompatibleRequest();
      case 'Reserve':
        return $1.ReserveRequest();
      case 'ReleaseReservation':
        return $1.ReleaseReservationRequest();
      case 'SweepLapsedReservations':
        return $1.SweepLapsedReservationsRequest();
      case 'IssueUnit':
        return $1.IssueUnitRequest();
      case 'ReconcileRelease':
        return $1.ReconcileReleaseRequest();
      case 'ListOutstandingReleases':
        return $1.ListOutstandingReleasesRequest();
      case 'VerifyBedside':
        return $1.VerifyBedsideRequest();
      case 'StartTransfusion':
        return $1.StartTransfusionRequest();
      case 'Observe':
        return $1.ObserveRequest();
      case 'EndTransfusion':
        return $1.EndTransfusionRequest();
      case 'GetEpisode':
        return $1.GetEpisodeRequest();
      case 'ListPatientTransfusions':
        return $1.ListPatientTransfusionsRequest();
      case 'ReportReaction':
        return $1.ReportReactionRequest();
      case 'ConcludeInvestigation':
        return $1.ConcludeInvestigationRequest();
      case 'ListOpenInvestigations':
        return $1.ListOpenInvestigationsRequest();
      case 'TraceUnit':
        return $1.TraceUnitRequest();
      case 'LookBack':
        return $1.LookBackRequest();
      case 'SetThreshold':
        return $1.SetThresholdRequest();
      case 'GetStock':
        return $1.GetStockRequest();
      case 'GetUtilisation':
        return $1.GetUtilisationRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterDonor':
        return registerDonor(ctx, request as $1.RegisterDonorRequest);
      case 'GetDonor':
        return getDonor(ctx, request as $1.GetDonorRequest);
      case 'DeferDonor':
        return deferDonor(ctx, request as $1.DeferDonorRequest);
      case 'ReinstateDonor':
        return reinstateDonor(ctx, request as $1.ReinstateDonorRequest);
      case 'ListDeferredDonors':
        return listDeferredDonors(ctx, request as $1.ListDeferredDonorsRequest);
      case 'ScreenDonor':
        return screenDonor(ctx, request as $1.ScreenDonorRequest);
      case 'Collect':
        return collect(ctx, request as $1.CollectRequest);
      case 'RecordTest':
        return recordTest(ctx, request as $1.RecordTestRequest);
      case 'GetReleaseDecision':
        return getReleaseDecision(ctx, request as $1.GetReleaseDecisionRequest);
      case 'ReleaseComponents':
        return releaseComponents(ctx, request as $1.ReleaseComponentsRequest);
      case 'AddComponent':
        return addComponent(ctx, request as $1.AddComponentRequest);
      case 'GetComponent':
        return getComponent(ctx, request as $1.GetComponentRequest);
      case 'DiscardComponent':
        return discardComponent(ctx, request as $1.DiscardComponentRequest);
      case 'PlaceRequest':
        return placeRequest(ctx, request as $1.PlaceRequestRequest);
      case 'GetWorklist':
        return getWorklist(ctx, request as $1.GetWorklistRequest);
      case 'ListPatientRequests':
        return listPatientRequests(
            ctx, request as $1.ListPatientRequestsRequest);
      case 'GroupPatient':
        return groupPatient(ctx, request as $1.GroupPatientRequest);
      case 'FindCompatible':
        return findCompatible(ctx, request as $1.FindCompatibleRequest);
      case 'Reserve':
        return reserve(ctx, request as $1.ReserveRequest);
      case 'ReleaseReservation':
        return releaseReservation(ctx, request as $1.ReleaseReservationRequest);
      case 'SweepLapsedReservations':
        return sweepLapsedReservations(
            ctx, request as $1.SweepLapsedReservationsRequest);
      case 'IssueUnit':
        return issueUnit(ctx, request as $1.IssueUnitRequest);
      case 'ReconcileRelease':
        return reconcileRelease(ctx, request as $1.ReconcileReleaseRequest);
      case 'ListOutstandingReleases':
        return listOutstandingReleases(
            ctx, request as $1.ListOutstandingReleasesRequest);
      case 'VerifyBedside':
        return verifyBedside(ctx, request as $1.VerifyBedsideRequest);
      case 'StartTransfusion':
        return startTransfusion(ctx, request as $1.StartTransfusionRequest);
      case 'Observe':
        return observe(ctx, request as $1.ObserveRequest);
      case 'EndTransfusion':
        return endTransfusion(ctx, request as $1.EndTransfusionRequest);
      case 'GetEpisode':
        return getEpisode(ctx, request as $1.GetEpisodeRequest);
      case 'ListPatientTransfusions':
        return listPatientTransfusions(
            ctx, request as $1.ListPatientTransfusionsRequest);
      case 'ReportReaction':
        return reportReaction(ctx, request as $1.ReportReactionRequest);
      case 'ConcludeInvestigation':
        return concludeInvestigation(
            ctx, request as $1.ConcludeInvestigationRequest);
      case 'ListOpenInvestigations':
        return listOpenInvestigations(
            ctx, request as $1.ListOpenInvestigationsRequest);
      case 'TraceUnit':
        return traceUnit(ctx, request as $1.TraceUnitRequest);
      case 'LookBack':
        return lookBack(ctx, request as $1.LookBackRequest);
      case 'SetThreshold':
        return setThreshold(ctx, request as $1.SetThresholdRequest);
      case 'GetStock':
        return getStock(ctx, request as $1.GetStockRequest);
      case 'GetUtilisation':
        return getUtilisation(ctx, request as $1.GetUtilisationRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => BloodBankServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => BloodBankServiceBase$messageJson;
}
