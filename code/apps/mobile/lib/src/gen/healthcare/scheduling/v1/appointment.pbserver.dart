// This is a generated file - do not edit.
//
// Generated from healthcare/scheduling/v1/appointment.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'appointment.pb.dart' as $1;
import 'appointment.pbjson.dart';

export 'appointment.pb.dart';

abstract class AppointmentServiceBase extends $pb.GeneratedService {
  $async.Future<$1.DefineResourceResponse> defineResource(
      $pb.ServerContext ctx, $1.DefineResourceRequest request);
  $async.Future<$1.SetResourceStatusResponse> setResourceStatus(
      $pb.ServerContext ctx, $1.SetResourceStatusRequest request);
  $async.Future<$1.DefineScheduleResponse> defineSchedule(
      $pb.ServerContext ctx, $1.DefineScheduleRequest request);
  $async.Future<$1.BlockPeriodResponse> blockPeriod(
      $pb.ServerContext ctx, $1.BlockPeriodRequest request);
  $async.Future<$1.UnblockPeriodResponse> unblockPeriod(
      $pb.ServerContext ctx, $1.UnblockPeriodRequest request);
  $async.Future<$1.SearchSlotsResponse> searchSlots(
      $pb.ServerContext ctx, $1.SearchSlotsRequest request);
  $async.Future<$1.BookAppointmentResponse> bookAppointment(
      $pb.ServerContext ctx, $1.BookAppointmentRequest request);
  $async.Future<$1.CancelAppointmentResponse> cancelAppointment(
      $pb.ServerContext ctx, $1.CancelAppointmentRequest request);
  $async.Future<$1.RescheduleAppointmentResponse> rescheduleAppointment(
      $pb.ServerContext ctx, $1.RescheduleAppointmentRequest request);
  $async.Future<$1.SetSchedulingPolicyResponse> setSchedulingPolicy(
      $pb.ServerContext ctx, $1.SetSchedulingPolicyRequest request);
  $async.Future<$1.BookSeriesResponse> bookSeries(
      $pb.ServerContext ctx, $1.BookSeriesRequest request);
  $async.Future<$1.CancelSeriesResponse> cancelSeries(
      $pb.ServerContext ctx, $1.CancelSeriesRequest request);
  $async.Future<$1.JoinWaitlistResponse> joinWaitlist(
      $pb.ServerContext ctx, $1.JoinWaitlistRequest request);
  $async.Future<$1.OfferWaitlistSlotResponse> offerWaitlistSlot(
      $pb.ServerContext ctx, $1.OfferWaitlistSlotRequest request);
  $async.Future<$1.AcceptWaitlistOfferResponse> acceptWaitlistOffer(
      $pb.ServerContext ctx, $1.AcceptWaitlistOfferRequest request);
  $async.Future<$1.DeclineWaitlistOfferResponse> declineWaitlistOffer(
      $pb.ServerContext ctx, $1.DeclineWaitlistOfferRequest request);
  $async.Future<$1.ListWaitlistResponse> listWaitlist(
      $pb.ServerContext ctx, $1.ListWaitlistRequest request);
  $async.Future<$1.ExpireWaitlistOffersResponse> expireWaitlistOffers(
      $pb.ServerContext ctx, $1.ExpireWaitlistOffersRequest request);
  $async.Future<$1.CheckInResponse> checkIn(
      $pb.ServerContext ctx, $1.CheckInRequest request);
  $async.Future<$1.AdvanceAppointmentResponse> advanceAppointment(
      $pb.ServerContext ctx, $1.AdvanceAppointmentRequest request);
  $async.Future<$1.GetQueueResponse> getQueue(
      $pb.ServerContext ctx, $1.GetQueueRequest request);
  $async.Future<$1.RegisterWalkInResponse> registerWalkIn(
      $pb.ServerContext ctx, $1.RegisterWalkInRequest request);
  $async.Future<$1.ReprioritiseResponse> reprioritise(
      $pb.ServerContext ctx, $1.ReprioritiseRequest request);
  $async.Future<$1.RecordDeliveryOutcomeResponse> recordDeliveryOutcome(
      $pb.ServerContext ctx, $1.RecordDeliveryOutcomeRequest request);
  $async.Future<$1.ListNotificationsResponse> listNotifications(
      $pb.ServerContext ctx, $1.ListNotificationsRequest request);
  $async.Future<$1.GetAppointmentResponse> getAppointment(
      $pb.ServerContext ctx, $1.GetAppointmentRequest request);
  $async.Future<$1.ListAppointmentsResponse> listAppointments(
      $pb.ServerContext ctx, $1.ListAppointmentsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'DefineResource':
        return $1.DefineResourceRequest();
      case 'SetResourceStatus':
        return $1.SetResourceStatusRequest();
      case 'DefineSchedule':
        return $1.DefineScheduleRequest();
      case 'BlockPeriod':
        return $1.BlockPeriodRequest();
      case 'UnblockPeriod':
        return $1.UnblockPeriodRequest();
      case 'SearchSlots':
        return $1.SearchSlotsRequest();
      case 'BookAppointment':
        return $1.BookAppointmentRequest();
      case 'CancelAppointment':
        return $1.CancelAppointmentRequest();
      case 'RescheduleAppointment':
        return $1.RescheduleAppointmentRequest();
      case 'SetSchedulingPolicy':
        return $1.SetSchedulingPolicyRequest();
      case 'BookSeries':
        return $1.BookSeriesRequest();
      case 'CancelSeries':
        return $1.CancelSeriesRequest();
      case 'JoinWaitlist':
        return $1.JoinWaitlistRequest();
      case 'OfferWaitlistSlot':
        return $1.OfferWaitlistSlotRequest();
      case 'AcceptWaitlistOffer':
        return $1.AcceptWaitlistOfferRequest();
      case 'DeclineWaitlistOffer':
        return $1.DeclineWaitlistOfferRequest();
      case 'ListWaitlist':
        return $1.ListWaitlistRequest();
      case 'ExpireWaitlistOffers':
        return $1.ExpireWaitlistOffersRequest();
      case 'CheckIn':
        return $1.CheckInRequest();
      case 'AdvanceAppointment':
        return $1.AdvanceAppointmentRequest();
      case 'GetQueue':
        return $1.GetQueueRequest();
      case 'RegisterWalkIn':
        return $1.RegisterWalkInRequest();
      case 'Reprioritise':
        return $1.ReprioritiseRequest();
      case 'RecordDeliveryOutcome':
        return $1.RecordDeliveryOutcomeRequest();
      case 'ListNotifications':
        return $1.ListNotificationsRequest();
      case 'GetAppointment':
        return $1.GetAppointmentRequest();
      case 'ListAppointments':
        return $1.ListAppointmentsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'DefineResource':
        return defineResource(ctx, request as $1.DefineResourceRequest);
      case 'SetResourceStatus':
        return setResourceStatus(ctx, request as $1.SetResourceStatusRequest);
      case 'DefineSchedule':
        return defineSchedule(ctx, request as $1.DefineScheduleRequest);
      case 'BlockPeriod':
        return blockPeriod(ctx, request as $1.BlockPeriodRequest);
      case 'UnblockPeriod':
        return unblockPeriod(ctx, request as $1.UnblockPeriodRequest);
      case 'SearchSlots':
        return searchSlots(ctx, request as $1.SearchSlotsRequest);
      case 'BookAppointment':
        return bookAppointment(ctx, request as $1.BookAppointmentRequest);
      case 'CancelAppointment':
        return cancelAppointment(ctx, request as $1.CancelAppointmentRequest);
      case 'RescheduleAppointment':
        return rescheduleAppointment(
            ctx, request as $1.RescheduleAppointmentRequest);
      case 'SetSchedulingPolicy':
        return setSchedulingPolicy(
            ctx, request as $1.SetSchedulingPolicyRequest);
      case 'BookSeries':
        return bookSeries(ctx, request as $1.BookSeriesRequest);
      case 'CancelSeries':
        return cancelSeries(ctx, request as $1.CancelSeriesRequest);
      case 'JoinWaitlist':
        return joinWaitlist(ctx, request as $1.JoinWaitlistRequest);
      case 'OfferWaitlistSlot':
        return offerWaitlistSlot(ctx, request as $1.OfferWaitlistSlotRequest);
      case 'AcceptWaitlistOffer':
        return acceptWaitlistOffer(
            ctx, request as $1.AcceptWaitlistOfferRequest);
      case 'DeclineWaitlistOffer':
        return declineWaitlistOffer(
            ctx, request as $1.DeclineWaitlistOfferRequest);
      case 'ListWaitlist':
        return listWaitlist(ctx, request as $1.ListWaitlistRequest);
      case 'ExpireWaitlistOffers':
        return expireWaitlistOffers(
            ctx, request as $1.ExpireWaitlistOffersRequest);
      case 'CheckIn':
        return checkIn(ctx, request as $1.CheckInRequest);
      case 'AdvanceAppointment':
        return advanceAppointment(ctx, request as $1.AdvanceAppointmentRequest);
      case 'GetQueue':
        return getQueue(ctx, request as $1.GetQueueRequest);
      case 'RegisterWalkIn':
        return registerWalkIn(ctx, request as $1.RegisterWalkInRequest);
      case 'Reprioritise':
        return reprioritise(ctx, request as $1.ReprioritiseRequest);
      case 'RecordDeliveryOutcome':
        return recordDeliveryOutcome(
            ctx, request as $1.RecordDeliveryOutcomeRequest);
      case 'ListNotifications':
        return listNotifications(ctx, request as $1.ListNotificationsRequest);
      case 'GetAppointment':
        return getAppointment(ctx, request as $1.GetAppointmentRequest);
      case 'ListAppointments':
        return listAppointments(ctx, request as $1.ListAppointmentsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      AppointmentServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AppointmentServiceBase$messageJson;
}
