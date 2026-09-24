// This is a generated file - do not edit.
//
// Generated from healthcare/sterile/v1/sterile.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'sterile.pb.dart' as $1;
import 'sterile.pbjson.dart';

export 'sterile.pb.dart';

abstract class SterileServicesServiceBase extends $pb.GeneratedService {
  $async.Future<$1.RegisterInstrumentResponse> registerInstrument(
      $pb.ServerContext ctx, $1.RegisterInstrumentRequest request);
  $async.Future<$1.MoveInstrumentResponse> moveInstrument(
      $pb.ServerContext ctx, $1.MoveInstrumentRequest request);
  $async.Future<$1.ListInstrumentsResponse> listInstruments(
      $pb.ServerContext ctx, $1.ListInstrumentsRequest request);
  $async.Future<$1.GetInstrumentHistoryResponse> getInstrumentHistory(
      $pb.ServerContext ctx, $1.GetInstrumentHistoryRequest request);
  $async.Future<$1.ListInstrumentMovesResponse> listInstrumentMoves(
      $pb.ServerContext ctx, $1.ListInstrumentMovesRequest request);
  $async.Future<$1.DefineSetResponse> defineSet(
      $pb.ServerContext ctx, $1.DefineSetRequest request);
  $async.Future<$1.GetSetResponse> getSet(
      $pb.ServerContext ctx, $1.GetSetRequest request);
  $async.Future<$1.ListSetVersionsResponse> listSetVersions(
      $pb.ServerContext ctx, $1.ListSetVersionsRequest request);
  $async.Future<$1.ListSetsResponse> listSets(
      $pb.ServerContext ctx, $1.ListSetsRequest request);
  $async.Future<$1.ReceiveResponse> receive(
      $pb.ServerContext ctx, $1.ReceiveRequest request);
  $async.Future<$1.AdvanceResponse> advance(
      $pb.ServerContext ctx, $1.AdvanceRequest request);
  $async.Future<$1.AssembleResponse> assemble(
      $pb.ServerContext ctx, $1.AssembleRequest request);
  $async.Future<$1.PackageResponse> package(
      $pb.ServerContext ctx, $1.PackageRequest request);
  $async.Future<$1.StartCycleResponse> startCycle(
      $pb.ServerContext ctx, $1.StartCycleRequest request);
  $async.Future<$1.LoadCycleResponse> loadCycle(
      $pb.ServerContext ctx, $1.LoadCycleRequest request);
  $async.Future<$1.FinishCycleResponse> finishCycle(
      $pb.ServerContext ctx, $1.FinishCycleRequest request);
  $async.Future<$1.RecordIndicatorResponse> recordIndicator(
      $pb.ServerContext ctx, $1.RecordIndicatorRequest request);
  $async.Future<$1.GetReleaseDecisionResponse> getReleaseDecision(
      $pb.ServerContext ctx, $1.GetReleaseDecisionRequest request);
  $async.Future<$1.ReleaseLoadResponse> releaseLoad(
      $pb.ServerContext ctx, $1.ReleaseLoadRequest request);
  $async.Future<$1.GetCycleResponse> getCycle(
      $pb.ServerContext ctx, $1.GetCycleRequest request);
  $async.Future<$1.ListCyclesAwaitingReleaseResponse> listCyclesAwaitingRelease(
      $pb.ServerContext ctx, $1.ListCyclesAwaitingReleaseRequest request);
  $async.Future<$1.ListLoadsClearedByLotResponse> listLoadsClearedByLot(
      $pb.ServerContext ctx, $1.ListLoadsClearedByLotRequest request);
  $async.Future<$1.GetRunResponse> getRun(
      $pb.ServerContext ctx, $1.GetRunRequest request);
  $async.Future<$1.GetBoardResponse> getBoard(
      $pb.ServerContext ctx, $1.GetBoardRequest request);
  $async.Future<$1.GetShelfResponse> getShelf(
      $pb.ServerContext ctx, $1.GetShelfRequest request);
  $async.Future<$1.ListExpiredPacksResponse> listExpiredPacks(
      $pb.ServerContext ctx, $1.ListExpiredPacksRequest request);
  $async.Future<$1.ListExceptionsResponse> listExceptions(
      $pb.ServerContext ctx, $1.ListExceptionsRequest request);
  $async.Future<$1.GetLabelResponse> getLabel(
      $pb.ServerContext ctx, $1.GetLabelRequest request);
  $async.Future<$1.IssuePackResponse> issuePack(
      $pb.ServerContext ctx, $1.IssuePackRequest request);
  $async.Future<$1.MarkUsedResponse> markUsed(
      $pb.ServerContext ctx, $1.MarkUsedRequest request);
  $async.Future<$1.ReturnPackResponse> returnPack(
      $pb.ServerContext ctx, $1.ReturnPackRequest request);
  $async.Future<$1.ListOutstandingResponse> listOutstanding(
      $pb.ServerContext ctx, $1.ListOutstandingRequest request);
  $async.Future<$1.TraceCaseResponse> traceCase(
      $pb.ServerContext ctx, $1.TraceCaseRequest request);
  $async.Future<$1.GetRecallScopeResponse> getRecallScope(
      $pb.ServerContext ctx, $1.GetRecallScopeRequest request);
  $async.Future<$1.RaiseRecallResponse> raiseRecall(
      $pb.ServerContext ctx, $1.RaiseRecallRequest request);
  $async.Future<$1.CloseRecallResponse> closeRecall(
      $pb.ServerContext ctx, $1.CloseRecallRequest request);
  $async.Future<$1.ListOpenRecallsResponse> listOpenRecalls(
      $pb.ServerContext ctx, $1.ListOpenRecallsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'RegisterInstrument':
        return $1.RegisterInstrumentRequest();
      case 'MoveInstrument':
        return $1.MoveInstrumentRequest();
      case 'ListInstruments':
        return $1.ListInstrumentsRequest();
      case 'GetInstrumentHistory':
        return $1.GetInstrumentHistoryRequest();
      case 'ListInstrumentMoves':
        return $1.ListInstrumentMovesRequest();
      case 'DefineSet':
        return $1.DefineSetRequest();
      case 'GetSet':
        return $1.GetSetRequest();
      case 'ListSetVersions':
        return $1.ListSetVersionsRequest();
      case 'ListSets':
        return $1.ListSetsRequest();
      case 'Receive':
        return $1.ReceiveRequest();
      case 'Advance':
        return $1.AdvanceRequest();
      case 'Assemble':
        return $1.AssembleRequest();
      case 'Package':
        return $1.PackageRequest();
      case 'StartCycle':
        return $1.StartCycleRequest();
      case 'LoadCycle':
        return $1.LoadCycleRequest();
      case 'FinishCycle':
        return $1.FinishCycleRequest();
      case 'RecordIndicator':
        return $1.RecordIndicatorRequest();
      case 'GetReleaseDecision':
        return $1.GetReleaseDecisionRequest();
      case 'ReleaseLoad':
        return $1.ReleaseLoadRequest();
      case 'GetCycle':
        return $1.GetCycleRequest();
      case 'ListCyclesAwaitingRelease':
        return $1.ListCyclesAwaitingReleaseRequest();
      case 'ListLoadsClearedByLot':
        return $1.ListLoadsClearedByLotRequest();
      case 'GetRun':
        return $1.GetRunRequest();
      case 'GetBoard':
        return $1.GetBoardRequest();
      case 'GetShelf':
        return $1.GetShelfRequest();
      case 'ListExpiredPacks':
        return $1.ListExpiredPacksRequest();
      case 'ListExceptions':
        return $1.ListExceptionsRequest();
      case 'GetLabel':
        return $1.GetLabelRequest();
      case 'IssuePack':
        return $1.IssuePackRequest();
      case 'MarkUsed':
        return $1.MarkUsedRequest();
      case 'ReturnPack':
        return $1.ReturnPackRequest();
      case 'ListOutstanding':
        return $1.ListOutstandingRequest();
      case 'TraceCase':
        return $1.TraceCaseRequest();
      case 'GetRecallScope':
        return $1.GetRecallScopeRequest();
      case 'RaiseRecall':
        return $1.RaiseRecallRequest();
      case 'CloseRecall':
        return $1.CloseRecallRequest();
      case 'ListOpenRecalls':
        return $1.ListOpenRecallsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'RegisterInstrument':
        return registerInstrument(ctx, request as $1.RegisterInstrumentRequest);
      case 'MoveInstrument':
        return moveInstrument(ctx, request as $1.MoveInstrumentRequest);
      case 'ListInstruments':
        return listInstruments(ctx, request as $1.ListInstrumentsRequest);
      case 'GetInstrumentHistory':
        return getInstrumentHistory(
            ctx, request as $1.GetInstrumentHistoryRequest);
      case 'ListInstrumentMoves':
        return listInstrumentMoves(
            ctx, request as $1.ListInstrumentMovesRequest);
      case 'DefineSet':
        return defineSet(ctx, request as $1.DefineSetRequest);
      case 'GetSet':
        return getSet(ctx, request as $1.GetSetRequest);
      case 'ListSetVersions':
        return listSetVersions(ctx, request as $1.ListSetVersionsRequest);
      case 'ListSets':
        return listSets(ctx, request as $1.ListSetsRequest);
      case 'Receive':
        return receive(ctx, request as $1.ReceiveRequest);
      case 'Advance':
        return advance(ctx, request as $1.AdvanceRequest);
      case 'Assemble':
        return assemble(ctx, request as $1.AssembleRequest);
      case 'Package':
        return package(ctx, request as $1.PackageRequest);
      case 'StartCycle':
        return startCycle(ctx, request as $1.StartCycleRequest);
      case 'LoadCycle':
        return loadCycle(ctx, request as $1.LoadCycleRequest);
      case 'FinishCycle':
        return finishCycle(ctx, request as $1.FinishCycleRequest);
      case 'RecordIndicator':
        return recordIndicator(ctx, request as $1.RecordIndicatorRequest);
      case 'GetReleaseDecision':
        return getReleaseDecision(ctx, request as $1.GetReleaseDecisionRequest);
      case 'ReleaseLoad':
        return releaseLoad(ctx, request as $1.ReleaseLoadRequest);
      case 'GetCycle':
        return getCycle(ctx, request as $1.GetCycleRequest);
      case 'ListCyclesAwaitingRelease':
        return listCyclesAwaitingRelease(
            ctx, request as $1.ListCyclesAwaitingReleaseRequest);
      case 'ListLoadsClearedByLot':
        return listLoadsClearedByLot(
            ctx, request as $1.ListLoadsClearedByLotRequest);
      case 'GetRun':
        return getRun(ctx, request as $1.GetRunRequest);
      case 'GetBoard':
        return getBoard(ctx, request as $1.GetBoardRequest);
      case 'GetShelf':
        return getShelf(ctx, request as $1.GetShelfRequest);
      case 'ListExpiredPacks':
        return listExpiredPacks(ctx, request as $1.ListExpiredPacksRequest);
      case 'ListExceptions':
        return listExceptions(ctx, request as $1.ListExceptionsRequest);
      case 'GetLabel':
        return getLabel(ctx, request as $1.GetLabelRequest);
      case 'IssuePack':
        return issuePack(ctx, request as $1.IssuePackRequest);
      case 'MarkUsed':
        return markUsed(ctx, request as $1.MarkUsedRequest);
      case 'ReturnPack':
        return returnPack(ctx, request as $1.ReturnPackRequest);
      case 'ListOutstanding':
        return listOutstanding(ctx, request as $1.ListOutstandingRequest);
      case 'TraceCase':
        return traceCase(ctx, request as $1.TraceCaseRequest);
      case 'GetRecallScope':
        return getRecallScope(ctx, request as $1.GetRecallScopeRequest);
      case 'RaiseRecall':
        return raiseRecall(ctx, request as $1.RaiseRecallRequest);
      case 'CloseRecall':
        return closeRecall(ctx, request as $1.CloseRecallRequest);
      case 'ListOpenRecalls':
        return listOpenRecalls(ctx, request as $1.ListOpenRecallsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      SterileServicesServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => SterileServicesServiceBase$messageJson;
}
