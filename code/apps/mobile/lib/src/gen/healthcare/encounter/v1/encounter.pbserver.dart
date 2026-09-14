// This is a generated file - do not edit.
//
// Generated from healthcare/encounter/v1/encounter.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'encounter.pb.dart' as $1;
import 'encounter.pbjson.dart';

export 'encounter.pb.dart';

abstract class EncounterServiceBase extends $pb.GeneratedService {
  $async.Future<$1.OpenEncounterResponse> openEncounter(
      $pb.ServerContext ctx, $1.OpenEncounterRequest request);
  $async.Future<$1.StartEncounterResponse> startEncounter(
      $pb.ServerContext ctx, $1.StartEncounterRequest request);
  $async.Future<$1.EndEncounterResponse> endEncounter(
      $pb.ServerContext ctx, $1.EndEncounterRequest request);
  $async.Future<$1.CancelEncounterResponse> cancelEncounter(
      $pb.ServerContext ctx, $1.CancelEncounterRequest request);
  $async.Future<$1.ReopenEncounterResponse> reopenEncounter(
      $pb.ServerContext ctx, $1.ReopenEncounterRequest request);
  $async.Future<$1.SetEncounterLeaveResponse> setEncounterLeave(
      $pb.ServerContext ctx, $1.SetEncounterLeaveRequest request);
  $async.Future<$1.GetEncounterResponse> getEncounter(
      $pb.ServerContext ctx, $1.GetEncounterRequest request);
  $async.Future<$1.ListEncountersResponse> listEncounters(
      $pb.ServerContext ctx, $1.ListEncountersRequest request);
  $async.Future<$1.OpenEpisodeResponse> openEpisode(
      $pb.ServerContext ctx, $1.OpenEpisodeRequest request);
  $async.Future<$1.SetEpisodeStatusResponse> setEpisodeStatus(
      $pb.ServerContext ctx, $1.SetEpisodeStatusRequest request);
  $async.Future<$1.ListEpisodesResponse> listEpisodes(
      $pb.ServerContext ctx, $1.ListEpisodesRequest request);
  $async.Future<$1.AssignCareTeamMemberResponse> assignCareTeamMember(
      $pb.ServerContext ctx, $1.AssignCareTeamMemberRequest request);
  $async.Future<$1.EndCareTeamAssignmentResponse> endCareTeamAssignment(
      $pb.ServerContext ctx, $1.EndCareTeamAssignmentRequest request);
  $async.Future<$1.GetCareTeamResponse> getCareTeam(
      $pb.ServerContext ctx, $1.GetCareTeamRequest request);
  $async.Future<$1.RecordDiagnosisResponse> recordDiagnosis(
      $pb.ServerContext ctx, $1.RecordDiagnosisRequest request);
  $async.Future<$1.RetractDiagnosisResponse> retractDiagnosis(
      $pb.ServerContext ctx, $1.RetractDiagnosisRequest request);
  $async.Future<$1.ListDiagnosesResponse> listDiagnoses(
      $pb.ServerContext ctx, $1.ListDiagnosesRequest request);
  $async.Future<$1.CloseEncounterResponse> closeEncounter(
      $pb.ServerContext ctx, $1.CloseEncounterRequest request);
  $async.Future<$1.AmendSummaryResponse> amendSummary(
      $pb.ServerContext ctx, $1.AmendSummaryRequest request);
  $async.Future<$1.GetSummariesResponse> getSummaries(
      $pb.ServerContext ctx, $1.GetSummariesRequest request);
  $async.Future<$1.SetClosurePolicyResponse> setClosurePolicy(
      $pb.ServerContext ctx, $1.SetClosurePolicyRequest request);
  $async.Future<$1.GetClosurePolicyResponse> getClosurePolicy(
      $pb.ServerContext ctx, $1.GetClosurePolicyRequest request);
  $async.Future<$1.ListClosureOverridesResponse> listClosureOverrides(
      $pb.ServerContext ctx, $1.ListClosureOverridesRequest request);
  $async.Future<$1.GetTimelineResponse> getTimeline(
      $pb.ServerContext ctx, $1.GetTimelineRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'OpenEncounter':
        return $1.OpenEncounterRequest();
      case 'StartEncounter':
        return $1.StartEncounterRequest();
      case 'EndEncounter':
        return $1.EndEncounterRequest();
      case 'CancelEncounter':
        return $1.CancelEncounterRequest();
      case 'ReopenEncounter':
        return $1.ReopenEncounterRequest();
      case 'SetEncounterLeave':
        return $1.SetEncounterLeaveRequest();
      case 'GetEncounter':
        return $1.GetEncounterRequest();
      case 'ListEncounters':
        return $1.ListEncountersRequest();
      case 'OpenEpisode':
        return $1.OpenEpisodeRequest();
      case 'SetEpisodeStatus':
        return $1.SetEpisodeStatusRequest();
      case 'ListEpisodes':
        return $1.ListEpisodesRequest();
      case 'AssignCareTeamMember':
        return $1.AssignCareTeamMemberRequest();
      case 'EndCareTeamAssignment':
        return $1.EndCareTeamAssignmentRequest();
      case 'GetCareTeam':
        return $1.GetCareTeamRequest();
      case 'RecordDiagnosis':
        return $1.RecordDiagnosisRequest();
      case 'RetractDiagnosis':
        return $1.RetractDiagnosisRequest();
      case 'ListDiagnoses':
        return $1.ListDiagnosesRequest();
      case 'CloseEncounter':
        return $1.CloseEncounterRequest();
      case 'AmendSummary':
        return $1.AmendSummaryRequest();
      case 'GetSummaries':
        return $1.GetSummariesRequest();
      case 'SetClosurePolicy':
        return $1.SetClosurePolicyRequest();
      case 'GetClosurePolicy':
        return $1.GetClosurePolicyRequest();
      case 'ListClosureOverrides':
        return $1.ListClosureOverridesRequest();
      case 'GetTimeline':
        return $1.GetTimelineRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'OpenEncounter':
        return openEncounter(ctx, request as $1.OpenEncounterRequest);
      case 'StartEncounter':
        return startEncounter(ctx, request as $1.StartEncounterRequest);
      case 'EndEncounter':
        return endEncounter(ctx, request as $1.EndEncounterRequest);
      case 'CancelEncounter':
        return cancelEncounter(ctx, request as $1.CancelEncounterRequest);
      case 'ReopenEncounter':
        return reopenEncounter(ctx, request as $1.ReopenEncounterRequest);
      case 'SetEncounterLeave':
        return setEncounterLeave(ctx, request as $1.SetEncounterLeaveRequest);
      case 'GetEncounter':
        return getEncounter(ctx, request as $1.GetEncounterRequest);
      case 'ListEncounters':
        return listEncounters(ctx, request as $1.ListEncountersRequest);
      case 'OpenEpisode':
        return openEpisode(ctx, request as $1.OpenEpisodeRequest);
      case 'SetEpisodeStatus':
        return setEpisodeStatus(ctx, request as $1.SetEpisodeStatusRequest);
      case 'ListEpisodes':
        return listEpisodes(ctx, request as $1.ListEpisodesRequest);
      case 'AssignCareTeamMember':
        return assignCareTeamMember(
            ctx, request as $1.AssignCareTeamMemberRequest);
      case 'EndCareTeamAssignment':
        return endCareTeamAssignment(
            ctx, request as $1.EndCareTeamAssignmentRequest);
      case 'GetCareTeam':
        return getCareTeam(ctx, request as $1.GetCareTeamRequest);
      case 'RecordDiagnosis':
        return recordDiagnosis(ctx, request as $1.RecordDiagnosisRequest);
      case 'RetractDiagnosis':
        return retractDiagnosis(ctx, request as $1.RetractDiagnosisRequest);
      case 'ListDiagnoses':
        return listDiagnoses(ctx, request as $1.ListDiagnosesRequest);
      case 'CloseEncounter':
        return closeEncounter(ctx, request as $1.CloseEncounterRequest);
      case 'AmendSummary':
        return amendSummary(ctx, request as $1.AmendSummaryRequest);
      case 'GetSummaries':
        return getSummaries(ctx, request as $1.GetSummariesRequest);
      case 'SetClosurePolicy':
        return setClosurePolicy(ctx, request as $1.SetClosurePolicyRequest);
      case 'GetClosurePolicy':
        return getClosurePolicy(ctx, request as $1.GetClosurePolicyRequest);
      case 'ListClosureOverrides':
        return listClosureOverrides(
            ctx, request as $1.ListClosureOverridesRequest);
      case 'GetTimeline':
        return getTimeline(ctx, request as $1.GetTimelineRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => EncounterServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => EncounterServiceBase$messageJson;
}
