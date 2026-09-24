// This is a generated file - do not edit.
//
// Generated from healthcare/records/v1/records.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'records.pb.dart' as $1;
import 'records.pbjson.dart';

export 'records.pb.dart';

abstract class RecordsServiceBase extends $pb.GeneratedService {
  $async.Future<$1.DraftChecklistResponse> draftChecklist(
      $pb.ServerContext ctx, $1.DraftChecklistRequest request);
  $async.Future<$1.ApproveChecklistResponse> approveChecklist(
      $pb.ServerContext ctx, $1.ApproveChecklistRequest request);
  $async.Future<$1.ListChecklistsResponse> listChecklists(
      $pb.ServerContext ctx, $1.ListChecklistsRequest request);
  $async.Future<$1.GetChartGapsResponse> getChartGaps(
      $pb.ServerContext ctx, $1.GetChartGapsRequest request);
  $async.Future<$1.RaiseDeficienciesResponse> raiseDeficiencies(
      $pb.ServerContext ctx, $1.RaiseDeficienciesRequest request);
  $async.Future<$1.RaiseCodingQueryResponse> raiseCodingQuery(
      $pb.ServerContext ctx, $1.RaiseCodingQueryRequest request);
  $async.Future<$1.ResolveDeficiencyResponse> resolveDeficiency(
      $pb.ServerContext ctx, $1.ResolveDeficiencyRequest request);
  $async.Future<$1.WaiveDeficiencyResponse> waiveDeficiency(
      $pb.ServerContext ctx, $1.WaiveDeficiencyRequest request);
  $async.Future<$1.ReassignDeficiencyResponse> reassignDeficiency(
      $pb.ServerContext ctx, $1.ReassignDeficiencyRequest request);
  $async.Future<$1.ListDeficienciesResponse> listDeficiencies(
      $pb.ServerContext ctx, $1.ListDeficienciesRequest request);
  $async.Future<$1.GetAgingReportResponse> getAgingReport(
      $pb.ServerContext ctx, $1.GetAgingReportRequest request);
  $async.Future<$1.GetCompletionSummaryResponse> getCompletionSummary(
      $pb.ServerContext ctx, $1.GetCompletionSummaryRequest request);
  $async.Future<$1.EscalateOverdueDeficienciesResponse>
      escalateOverdueDeficiencies(
          $pb.ServerContext ctx, $1.EscalateOverdueDeficienciesRequest request);
  $async.Future<$1.AssignCodesResponse> assignCodes(
      $pb.ServerContext ctx, $1.AssignCodesRequest request);
  $async.Future<$1.FinaliseCodingResponse> finaliseCoding(
      $pb.ServerContext ctx, $1.FinaliseCodingRequest request);
  $async.Future<$1.QueryCodingResponse> queryCoding(
      $pb.ServerContext ctx, $1.QueryCodingRequest request);
  $async.Future<$1.GetCodedEpisodeResponse> getCodedEpisode(
      $pb.ServerContext ctx, $1.GetCodedEpisodeRequest request);
  $async.Future<$1.GetCodingDiffResponse> getCodingDiff(
      $pb.ServerContext ctx, $1.GetCodingDiffRequest request);
  $async.Future<$1.RequestReleaseResponse> requestRelease(
      $pb.ServerContext ctx, $1.RequestReleaseRequest request);
  $async.Future<$1.ApproveReleaseResponse> approveRelease(
      $pb.ServerContext ctx, $1.ApproveReleaseRequest request);
  $async.Future<$1.RefuseReleaseResponse> refuseRelease(
      $pb.ServerContext ctx, $1.RefuseReleaseRequest request);
  $async.Future<$1.AssembleReleaseResponse> assembleRelease(
      $pb.ServerContext ctx, $1.AssembleReleaseRequest request);
  $async.Future<$1.SendReleaseResponse> sendRelease(
      $pb.ServerContext ctx, $1.SendReleaseRequest request);
  $async.Future<$1.ListReleasesResponse> listReleases(
      $pb.ServerContext ctx, $1.ListReleasesRequest request);
  $async.Future<$1.RecordDisclosureResponse> recordDisclosure(
      $pb.ServerContext ctx, $1.RecordDisclosureRequest request);
  $async.Future<$1.ListDisclosuresResponse> listDisclosures(
      $pb.ServerContext ctx, $1.ListDisclosuresRequest request);
  $async.Future<$1.DraftRetentionRuleResponse> draftRetentionRule(
      $pb.ServerContext ctx, $1.DraftRetentionRuleRequest request);
  $async.Future<$1.ApproveRetentionRuleResponse> approveRetentionRule(
      $pb.ServerContext ctx, $1.ApproveRetentionRuleRequest request);
  $async.Future<$1.ListRetentionRulesResponse> listRetentionRules(
      $pb.ServerContext ctx, $1.ListRetentionRulesRequest request);
  $async.Future<$1.PlaceHoldResponse> placeHold(
      $pb.ServerContext ctx, $1.PlaceHoldRequest request);
  $async.Future<$1.ReleaseHoldResponse> releaseHold(
      $pb.ServerContext ctx, $1.ReleaseHoldRequest request);
  $async.Future<$1.SweepForDispositionResponse> sweepForDisposition(
      $pb.ServerContext ctx, $1.SweepForDispositionRequest request);
  $async.Future<$1.PrepareDispositionResponse> prepareDisposition(
      $pb.ServerContext ctx, $1.PrepareDispositionRequest request);
  $async.Future<$1.ApproveDispositionResponse> approveDisposition(
      $pb.ServerContext ctx, $1.ApproveDispositionRequest request);
  $async.Future<$1.ExecuteDispositionResponse> executeDisposition(
      $pb.ServerContext ctx, $1.ExecuteDispositionRequest request);
  $async.Future<$1.CancelDispositionResponse> cancelDisposition(
      $pb.ServerContext ctx, $1.CancelDispositionRequest request);
  $async.Future<$1.ListDispositionListsResponse> listDispositionLists(
      $pb.ServerContext ctx, $1.ListDispositionListsRequest request);
  $async.Future<$1.RegisterPhysicalRecordResponse> registerPhysicalRecord(
      $pb.ServerContext ctx, $1.RegisterPhysicalRecordRequest request);
  $async.Future<$1.CheckOutRecordResponse> checkOutRecord(
      $pb.ServerContext ctx, $1.CheckOutRecordRequest request);
  $async.Future<$1.CheckInRecordResponse> checkInRecord(
      $pb.ServerContext ctx, $1.CheckInRecordRequest request);
  $async.Future<$1.MarkRecordMissingResponse> markRecordMissing(
      $pb.ServerContext ctx, $1.MarkRecordMissingRequest request);
  $async.Future<$1.ArchiveRecordResponse> archiveRecord(
      $pb.ServerContext ctx, $1.ArchiveRecordRequest request);
  $async.Future<$1.ListPhysicalRecordsResponse> listPhysicalRecords(
      $pb.ServerContext ctx, $1.ListPhysicalRecordsRequest request);
  $async.Future<$1.DraftCertificateFormResponse> draftCertificateForm(
      $pb.ServerContext ctx, $1.DraftCertificateFormRequest request);
  $async.Future<$1.ApproveCertificateFormResponse> approveCertificateForm(
      $pb.ServerContext ctx, $1.ApproveCertificateFormRequest request);
  $async.Future<$1.ListCertificateFormsResponse> listCertificateForms(
      $pb.ServerContext ctx, $1.ListCertificateFormsRequest request);
  $async.Future<$1.IssueCertificateResponse> issueCertificate(
      $pb.ServerContext ctx, $1.IssueCertificateRequest request);
  $async.Future<$1.CorrectCertificateResponse> correctCertificate(
      $pb.ServerContext ctx, $1.CorrectCertificateRequest request);
  $async.Future<$1.VoidCertificateResponse> voidCertificate(
      $pb.ServerContext ctx, $1.VoidCertificateRequest request);
  $async.Future<$1.ListCertificatesResponse> listCertificates(
      $pb.ServerContext ctx, $1.ListCertificatesRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'DraftChecklist':
        return $1.DraftChecklistRequest();
      case 'ApproveChecklist':
        return $1.ApproveChecklistRequest();
      case 'ListChecklists':
        return $1.ListChecklistsRequest();
      case 'GetChartGaps':
        return $1.GetChartGapsRequest();
      case 'RaiseDeficiencies':
        return $1.RaiseDeficienciesRequest();
      case 'RaiseCodingQuery':
        return $1.RaiseCodingQueryRequest();
      case 'ResolveDeficiency':
        return $1.ResolveDeficiencyRequest();
      case 'WaiveDeficiency':
        return $1.WaiveDeficiencyRequest();
      case 'ReassignDeficiency':
        return $1.ReassignDeficiencyRequest();
      case 'ListDeficiencies':
        return $1.ListDeficienciesRequest();
      case 'GetAgingReport':
        return $1.GetAgingReportRequest();
      case 'GetCompletionSummary':
        return $1.GetCompletionSummaryRequest();
      case 'EscalateOverdueDeficiencies':
        return $1.EscalateOverdueDeficienciesRequest();
      case 'AssignCodes':
        return $1.AssignCodesRequest();
      case 'FinaliseCoding':
        return $1.FinaliseCodingRequest();
      case 'QueryCoding':
        return $1.QueryCodingRequest();
      case 'GetCodedEpisode':
        return $1.GetCodedEpisodeRequest();
      case 'GetCodingDiff':
        return $1.GetCodingDiffRequest();
      case 'RequestRelease':
        return $1.RequestReleaseRequest();
      case 'ApproveRelease':
        return $1.ApproveReleaseRequest();
      case 'RefuseRelease':
        return $1.RefuseReleaseRequest();
      case 'AssembleRelease':
        return $1.AssembleReleaseRequest();
      case 'SendRelease':
        return $1.SendReleaseRequest();
      case 'ListReleases':
        return $1.ListReleasesRequest();
      case 'RecordDisclosure':
        return $1.RecordDisclosureRequest();
      case 'ListDisclosures':
        return $1.ListDisclosuresRequest();
      case 'DraftRetentionRule':
        return $1.DraftRetentionRuleRequest();
      case 'ApproveRetentionRule':
        return $1.ApproveRetentionRuleRequest();
      case 'ListRetentionRules':
        return $1.ListRetentionRulesRequest();
      case 'PlaceHold':
        return $1.PlaceHoldRequest();
      case 'ReleaseHold':
        return $1.ReleaseHoldRequest();
      case 'SweepForDisposition':
        return $1.SweepForDispositionRequest();
      case 'PrepareDisposition':
        return $1.PrepareDispositionRequest();
      case 'ApproveDisposition':
        return $1.ApproveDispositionRequest();
      case 'ExecuteDisposition':
        return $1.ExecuteDispositionRequest();
      case 'CancelDisposition':
        return $1.CancelDispositionRequest();
      case 'ListDispositionLists':
        return $1.ListDispositionListsRequest();
      case 'RegisterPhysicalRecord':
        return $1.RegisterPhysicalRecordRequest();
      case 'CheckOutRecord':
        return $1.CheckOutRecordRequest();
      case 'CheckInRecord':
        return $1.CheckInRecordRequest();
      case 'MarkRecordMissing':
        return $1.MarkRecordMissingRequest();
      case 'ArchiveRecord':
        return $1.ArchiveRecordRequest();
      case 'ListPhysicalRecords':
        return $1.ListPhysicalRecordsRequest();
      case 'DraftCertificateForm':
        return $1.DraftCertificateFormRequest();
      case 'ApproveCertificateForm':
        return $1.ApproveCertificateFormRequest();
      case 'ListCertificateForms':
        return $1.ListCertificateFormsRequest();
      case 'IssueCertificate':
        return $1.IssueCertificateRequest();
      case 'CorrectCertificate':
        return $1.CorrectCertificateRequest();
      case 'VoidCertificate':
        return $1.VoidCertificateRequest();
      case 'ListCertificates':
        return $1.ListCertificatesRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'DraftChecklist':
        return draftChecklist(ctx, request as $1.DraftChecklistRequest);
      case 'ApproveChecklist':
        return approveChecklist(ctx, request as $1.ApproveChecklistRequest);
      case 'ListChecklists':
        return listChecklists(ctx, request as $1.ListChecklistsRequest);
      case 'GetChartGaps':
        return getChartGaps(ctx, request as $1.GetChartGapsRequest);
      case 'RaiseDeficiencies':
        return raiseDeficiencies(ctx, request as $1.RaiseDeficienciesRequest);
      case 'RaiseCodingQuery':
        return raiseCodingQuery(ctx, request as $1.RaiseCodingQueryRequest);
      case 'ResolveDeficiency':
        return resolveDeficiency(ctx, request as $1.ResolveDeficiencyRequest);
      case 'WaiveDeficiency':
        return waiveDeficiency(ctx, request as $1.WaiveDeficiencyRequest);
      case 'ReassignDeficiency':
        return reassignDeficiency(ctx, request as $1.ReassignDeficiencyRequest);
      case 'ListDeficiencies':
        return listDeficiencies(ctx, request as $1.ListDeficienciesRequest);
      case 'GetAgingReport':
        return getAgingReport(ctx, request as $1.GetAgingReportRequest);
      case 'GetCompletionSummary':
        return getCompletionSummary(
            ctx, request as $1.GetCompletionSummaryRequest);
      case 'EscalateOverdueDeficiencies':
        return escalateOverdueDeficiencies(
            ctx, request as $1.EscalateOverdueDeficienciesRequest);
      case 'AssignCodes':
        return assignCodes(ctx, request as $1.AssignCodesRequest);
      case 'FinaliseCoding':
        return finaliseCoding(ctx, request as $1.FinaliseCodingRequest);
      case 'QueryCoding':
        return queryCoding(ctx, request as $1.QueryCodingRequest);
      case 'GetCodedEpisode':
        return getCodedEpisode(ctx, request as $1.GetCodedEpisodeRequest);
      case 'GetCodingDiff':
        return getCodingDiff(ctx, request as $1.GetCodingDiffRequest);
      case 'RequestRelease':
        return requestRelease(ctx, request as $1.RequestReleaseRequest);
      case 'ApproveRelease':
        return approveRelease(ctx, request as $1.ApproveReleaseRequest);
      case 'RefuseRelease':
        return refuseRelease(ctx, request as $1.RefuseReleaseRequest);
      case 'AssembleRelease':
        return assembleRelease(ctx, request as $1.AssembleReleaseRequest);
      case 'SendRelease':
        return sendRelease(ctx, request as $1.SendReleaseRequest);
      case 'ListReleases':
        return listReleases(ctx, request as $1.ListReleasesRequest);
      case 'RecordDisclosure':
        return recordDisclosure(ctx, request as $1.RecordDisclosureRequest);
      case 'ListDisclosures':
        return listDisclosures(ctx, request as $1.ListDisclosuresRequest);
      case 'DraftRetentionRule':
        return draftRetentionRule(ctx, request as $1.DraftRetentionRuleRequest);
      case 'ApproveRetentionRule':
        return approveRetentionRule(
            ctx, request as $1.ApproveRetentionRuleRequest);
      case 'ListRetentionRules':
        return listRetentionRules(ctx, request as $1.ListRetentionRulesRequest);
      case 'PlaceHold':
        return placeHold(ctx, request as $1.PlaceHoldRequest);
      case 'ReleaseHold':
        return releaseHold(ctx, request as $1.ReleaseHoldRequest);
      case 'SweepForDisposition':
        return sweepForDisposition(
            ctx, request as $1.SweepForDispositionRequest);
      case 'PrepareDisposition':
        return prepareDisposition(ctx, request as $1.PrepareDispositionRequest);
      case 'ApproveDisposition':
        return approveDisposition(ctx, request as $1.ApproveDispositionRequest);
      case 'ExecuteDisposition':
        return executeDisposition(ctx, request as $1.ExecuteDispositionRequest);
      case 'CancelDisposition':
        return cancelDisposition(ctx, request as $1.CancelDispositionRequest);
      case 'ListDispositionLists':
        return listDispositionLists(
            ctx, request as $1.ListDispositionListsRequest);
      case 'RegisterPhysicalRecord':
        return registerPhysicalRecord(
            ctx, request as $1.RegisterPhysicalRecordRequest);
      case 'CheckOutRecord':
        return checkOutRecord(ctx, request as $1.CheckOutRecordRequest);
      case 'CheckInRecord':
        return checkInRecord(ctx, request as $1.CheckInRecordRequest);
      case 'MarkRecordMissing':
        return markRecordMissing(ctx, request as $1.MarkRecordMissingRequest);
      case 'ArchiveRecord':
        return archiveRecord(ctx, request as $1.ArchiveRecordRequest);
      case 'ListPhysicalRecords':
        return listPhysicalRecords(
            ctx, request as $1.ListPhysicalRecordsRequest);
      case 'DraftCertificateForm':
        return draftCertificateForm(
            ctx, request as $1.DraftCertificateFormRequest);
      case 'ApproveCertificateForm':
        return approveCertificateForm(
            ctx, request as $1.ApproveCertificateFormRequest);
      case 'ListCertificateForms':
        return listCertificateForms(
            ctx, request as $1.ListCertificateFormsRequest);
      case 'IssueCertificate':
        return issueCertificate(ctx, request as $1.IssueCertificateRequest);
      case 'CorrectCertificate':
        return correctCertificate(ctx, request as $1.CorrectCertificateRequest);
      case 'VoidCertificate':
        return voidCertificate(ctx, request as $1.VoidCertificateRequest);
      case 'ListCertificates':
        return listCertificates(ctx, request as $1.ListCertificatesRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => RecordsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => RecordsServiceBase$messageJson;
}
