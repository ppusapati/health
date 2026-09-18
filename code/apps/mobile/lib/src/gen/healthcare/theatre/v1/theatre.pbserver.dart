// This is a generated file - do not edit.
//
// Generated from healthcare/theatre/v1/theatre.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'theatre.pb.dart' as $1;
import 'theatre.pbjson.dart';

export 'theatre.pb.dart';

abstract class TheatreServiceBase extends $pb.GeneratedService {
  $async.Future<$1.SaveRoomResponse> saveRoom(
      $pb.ServerContext ctx, $1.SaveRoomRequest request);
  $async.Future<$1.ListRoomsResponse> listRooms(
      $pb.ServerContext ctx, $1.ListRoomsRequest request);
  $async.Future<$1.SaveBlockResponse> saveBlock(
      $pb.ServerContext ctx, $1.SaveBlockRequest request);
  $async.Future<$1.RequestSurgeryResponse> requestSurgery(
      $pb.ServerContext ctx, $1.RequestSurgeryRequest request);
  $async.Future<$1.CompleteRequestResponse> completeRequest(
      $pb.ServerContext ctx, $1.CompleteRequestRequest request);
  $async.Future<$1.GetSurgicalCaseResponse> getSurgicalCase(
      $pb.ServerContext ctx, $1.GetSurgicalCaseRequest request);
  $async.Future<$1.ReprioritiseResponse> reprioritise(
      $pb.ServerContext ctx, $1.ReprioritiseRequest request);
  $async.Future<$1.CheckSlotResponse> checkSlot(
      $pb.ServerContext ctx, $1.CheckSlotRequest request);
  $async.Future<$1.ScheduleCaseResponse> scheduleCase(
      $pb.ServerContext ctx, $1.ScheduleCaseRequest request);
  $async.Future<$1.CloseCaseResponse> closeCase(
      $pb.ServerContext ctx, $1.CloseCaseRequest request);
  $async.Future<$1.ListWaitingResponse> listWaiting(
      $pb.ServerContext ctx, $1.ListWaitingRequest request);
  $async.Future<$1.RecordPreopResponse> recordPreop(
      $pb.ServerContext ctx, $1.RecordPreopRequest request);
  $async.Future<$1.ListBlockersResponse> listBlockers(
      $pb.ServerContext ctx, $1.ListBlockersRequest request);
  $async.Future<$1.PerformSafetyCheckResponse> performSafetyCheck(
      $pb.ServerContext ctx, $1.PerformSafetyCheckRequest request);
  $async.Future<$1.RecordMilestoneResponse> recordMilestone(
      $pb.ServerContext ctx, $1.RecordMilestoneRequest request);
  $async.Future<$1.GetTimelineResponse> getTimeline(
      $pb.ServerContext ctx, $1.GetTimelineRequest request);
  $async.Future<$1.RecordDelayResponse> recordDelay(
      $pb.ServerContext ctx, $1.RecordDelayRequest request);
  $async.Future<$1.WriteOperativeNoteResponse> writeOperativeNote(
      $pb.ServerContext ctx, $1.WriteOperativeNoteRequest request);
  $async.Future<$1.SignOperativeNoteResponse> signOperativeNote(
      $pb.ServerContext ctx, $1.SignOperativeNoteRequest request);
  $async.Future<$1.AmendOperativeNoteResponse> amendOperativeNote(
      $pb.ServerContext ctx, $1.AmendOperativeNoteRequest request);
  $async.Future<$1.RecordUsageResponse> recordUsage(
      $pb.ServerContext ctx, $1.RecordUsageRequest request);
  $async.Future<$1.RecallImplantResponse> recallImplant(
      $pb.ServerContext ctx, $1.RecallImplantRequest request);
  $async.Future<$1.TakeSpecimenResponse> takeSpecimen(
      $pb.ServerContext ctx, $1.TakeSpecimenRequest request);
  $async.Future<$1.AccessionSpecimenResponse> accessionSpecimen(
      $pb.ServerContext ctx, $1.AccessionSpecimenRequest request);
  $async.Future<$1.ListOutstandingSpecimensResponse> listOutstandingSpecimens(
      $pb.ServerContext ctx, $1.ListOutstandingSpecimensRequest request);
  $async.Future<$1.OpenTrayResponse> openTray(
      $pb.ServerContext ctx, $1.OpenTrayRequest request);
  $async.Future<$1.TraceCycleResponse> traceCycle(
      $pb.ServerContext ctx, $1.TraceCycleRequest request);
  $async.Future<$1.SavePreferenceCardResponse> savePreferenceCard(
      $pb.ServerContext ctx, $1.SavePreferenceCardRequest request);
  $async.Future<$1.GetPreferenceCardResponse> getPreferenceCard(
      $pb.ServerContext ctx, $1.GetPreferenceCardRequest request);
  $async.Future<$1.GetBoardResponse> getBoard(
      $pb.ServerContext ctx, $1.GetBoardRequest request);
  $async.Future<$1.GetUtilisationResponse> getUtilisation(
      $pb.ServerContext ctx, $1.GetUtilisationRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SaveRoom':
        return $1.SaveRoomRequest();
      case 'ListRooms':
        return $1.ListRoomsRequest();
      case 'SaveBlock':
        return $1.SaveBlockRequest();
      case 'RequestSurgery':
        return $1.RequestSurgeryRequest();
      case 'CompleteRequest':
        return $1.CompleteRequestRequest();
      case 'GetSurgicalCase':
        return $1.GetSurgicalCaseRequest();
      case 'Reprioritise':
        return $1.ReprioritiseRequest();
      case 'CheckSlot':
        return $1.CheckSlotRequest();
      case 'ScheduleCase':
        return $1.ScheduleCaseRequest();
      case 'CloseCase':
        return $1.CloseCaseRequest();
      case 'ListWaiting':
        return $1.ListWaitingRequest();
      case 'RecordPreop':
        return $1.RecordPreopRequest();
      case 'ListBlockers':
        return $1.ListBlockersRequest();
      case 'PerformSafetyCheck':
        return $1.PerformSafetyCheckRequest();
      case 'RecordMilestone':
        return $1.RecordMilestoneRequest();
      case 'GetTimeline':
        return $1.GetTimelineRequest();
      case 'RecordDelay':
        return $1.RecordDelayRequest();
      case 'WriteOperativeNote':
        return $1.WriteOperativeNoteRequest();
      case 'SignOperativeNote':
        return $1.SignOperativeNoteRequest();
      case 'AmendOperativeNote':
        return $1.AmendOperativeNoteRequest();
      case 'RecordUsage':
        return $1.RecordUsageRequest();
      case 'RecallImplant':
        return $1.RecallImplantRequest();
      case 'TakeSpecimen':
        return $1.TakeSpecimenRequest();
      case 'AccessionSpecimen':
        return $1.AccessionSpecimenRequest();
      case 'ListOutstandingSpecimens':
        return $1.ListOutstandingSpecimensRequest();
      case 'OpenTray':
        return $1.OpenTrayRequest();
      case 'TraceCycle':
        return $1.TraceCycleRequest();
      case 'SavePreferenceCard':
        return $1.SavePreferenceCardRequest();
      case 'GetPreferenceCard':
        return $1.GetPreferenceCardRequest();
      case 'GetBoard':
        return $1.GetBoardRequest();
      case 'GetUtilisation':
        return $1.GetUtilisationRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SaveRoom':
        return saveRoom(ctx, request as $1.SaveRoomRequest);
      case 'ListRooms':
        return listRooms(ctx, request as $1.ListRoomsRequest);
      case 'SaveBlock':
        return saveBlock(ctx, request as $1.SaveBlockRequest);
      case 'RequestSurgery':
        return requestSurgery(ctx, request as $1.RequestSurgeryRequest);
      case 'CompleteRequest':
        return completeRequest(ctx, request as $1.CompleteRequestRequest);
      case 'GetSurgicalCase':
        return getSurgicalCase(ctx, request as $1.GetSurgicalCaseRequest);
      case 'Reprioritise':
        return reprioritise(ctx, request as $1.ReprioritiseRequest);
      case 'CheckSlot':
        return checkSlot(ctx, request as $1.CheckSlotRequest);
      case 'ScheduleCase':
        return scheduleCase(ctx, request as $1.ScheduleCaseRequest);
      case 'CloseCase':
        return closeCase(ctx, request as $1.CloseCaseRequest);
      case 'ListWaiting':
        return listWaiting(ctx, request as $1.ListWaitingRequest);
      case 'RecordPreop':
        return recordPreop(ctx, request as $1.RecordPreopRequest);
      case 'ListBlockers':
        return listBlockers(ctx, request as $1.ListBlockersRequest);
      case 'PerformSafetyCheck':
        return performSafetyCheck(ctx, request as $1.PerformSafetyCheckRequest);
      case 'RecordMilestone':
        return recordMilestone(ctx, request as $1.RecordMilestoneRequest);
      case 'GetTimeline':
        return getTimeline(ctx, request as $1.GetTimelineRequest);
      case 'RecordDelay':
        return recordDelay(ctx, request as $1.RecordDelayRequest);
      case 'WriteOperativeNote':
        return writeOperativeNote(ctx, request as $1.WriteOperativeNoteRequest);
      case 'SignOperativeNote':
        return signOperativeNote(ctx, request as $1.SignOperativeNoteRequest);
      case 'AmendOperativeNote':
        return amendOperativeNote(ctx, request as $1.AmendOperativeNoteRequest);
      case 'RecordUsage':
        return recordUsage(ctx, request as $1.RecordUsageRequest);
      case 'RecallImplant':
        return recallImplant(ctx, request as $1.RecallImplantRequest);
      case 'TakeSpecimen':
        return takeSpecimen(ctx, request as $1.TakeSpecimenRequest);
      case 'AccessionSpecimen':
        return accessionSpecimen(ctx, request as $1.AccessionSpecimenRequest);
      case 'ListOutstandingSpecimens':
        return listOutstandingSpecimens(
            ctx, request as $1.ListOutstandingSpecimensRequest);
      case 'OpenTray':
        return openTray(ctx, request as $1.OpenTrayRequest);
      case 'TraceCycle':
        return traceCycle(ctx, request as $1.TraceCycleRequest);
      case 'SavePreferenceCard':
        return savePreferenceCard(ctx, request as $1.SavePreferenceCardRequest);
      case 'GetPreferenceCard':
        return getPreferenceCard(ctx, request as $1.GetPreferenceCardRequest);
      case 'GetBoard':
        return getBoard(ctx, request as $1.GetBoardRequest);
      case 'GetUtilisation':
        return getUtilisation(ctx, request as $1.GetUtilisationRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TheatreServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => TheatreServiceBase$messageJson;
}
