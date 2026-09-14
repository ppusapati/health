// This is a generated file - do not edit.
//
// Generated from healthcare/billing/v1/billing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'billing.pb.dart' as $1;
import 'billing.pbjson.dart';

export 'billing.pb.dart';

abstract class BillingServiceBase extends $pb.GeneratedService {
  $async.Future<$1.OpenAccountResponse> openAccount(
      $pb.ServerContext ctx, $1.OpenAccountRequest request);
  $async.Future<$1.GetAccountResponse> getAccount(
      $pb.ServerContext ctx, $1.GetAccountRequest request);
  $async.Future<$1.PostChargeResponse> postCharge(
      $pb.ServerContext ctx, $1.PostChargeRequest request);
  $async.Future<$1.VoidChargeResponse> voidCharge(
      $pb.ServerContext ctx, $1.VoidChargeRequest request);
  $async.Future<$1.HoldChargeResponse> holdCharge(
      $pb.ServerContext ctx, $1.HoldChargeRequest request);
  $async.Future<$1.ReleaseChargeResponse> releaseCharge(
      $pb.ServerContext ctx, $1.ReleaseChargeRequest request);
  $async.Future<$1.ListChargesResponse> listCharges(
      $pb.ServerContext ctx, $1.ListChargesRequest request);
  $async.Future<$1.PackageLedgerResponse> packageLedger(
      $pb.ServerContext ctx, $1.PackageLedgerRequest request);
  $async.Future<$1.RaiseInvoiceResponse> raiseInvoice(
      $pb.ServerContext ctx, $1.RaiseInvoiceRequest request);
  $async.Future<$1.CorrectInvoiceResponse> correctInvoice(
      $pb.ServerContext ctx, $1.CorrectInvoiceRequest request);
  $async.Future<$1.GetInvoiceResponse> getInvoice(
      $pb.ServerContext ctx, $1.GetInvoiceRequest request);
  $async.Future<$1.ListInvoicesResponse> listInvoices(
      $pb.ServerContext ctx, $1.ListInvoicesRequest request);
  $async.Future<$1.ReceivePaymentResponse> receivePayment(
      $pb.ServerContext ctx, $1.ReceivePaymentRequest request);
  $async.Future<$1.RefundResponse> refund(
      $pb.ServerContext ctx, $1.RefundRequest request);
  $async.Future<$1.StatementResponse> statement(
      $pb.ServerContext ctx, $1.StatementRequest request);
  $async.Future<$1.CloseAccountResponse> closeAccount(
      $pb.ServerContext ctx, $1.CloseAccountRequest request);
  $async.Future<$1.CloseReadinessResponse> closeReadiness(
      $pb.ServerContext ctx, $1.CloseReadinessRequest request);
  $async.Future<$1.RevenueIntegrityResponse> revenueIntegrity(
      $pb.ServerContext ctx, $1.RevenueIntegrityRequest request);
  $async.Future<$1.OpenShiftResponse> openShift(
      $pb.ServerContext ctx, $1.OpenShiftRequest request);
  $async.Future<$1.CloseShiftResponse> closeShift(
      $pb.ServerContext ctx, $1.CloseShiftRequest request);
  $async.Future<$1.ApproveShiftResponse> approveShift(
      $pb.ServerContext ctx, $1.ApproveShiftRequest request);
  $async.Future<$1.ListShiftsResponse> listShifts(
      $pb.ServerContext ctx, $1.ListShiftsRequest request);
  $async.Future<$1.PublishServiceResponse> publishService(
      $pb.ServerContext ctx, $1.PublishServiceRequest request);
  $async.Future<$1.ListServicesResponse> listServices(
      $pb.ServerContext ctx, $1.ListServicesRequest request);
  $async.Future<$1.PublishTariffResponse> publishTariff(
      $pb.ServerContext ctx, $1.PublishTariffRequest request);
  $async.Future<$1.ListTariffsResponse> listTariffs(
      $pb.ServerContext ctx, $1.ListTariffsRequest request);
  $async.Future<$1.QuoteResponse> quote(
      $pb.ServerContext ctx, $1.QuoteRequest request);
  $async.Future<$1.PublishPackageResponse> publishPackage(
      $pb.ServerContext ctx, $1.PublishPackageRequest request);
  $async.Future<$1.ListPackagesResponse> listPackages(
      $pb.ServerContext ctx, $1.ListPackagesRequest request);
  $async.Future<$1.SetBillingPolicyResponse> setBillingPolicy(
      $pb.ServerContext ctx, $1.SetBillingPolicyRequest request);
  $async.Future<$1.GetBillingPolicyResponse> getBillingPolicy(
      $pb.ServerContext ctx, $1.GetBillingPolicyRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'OpenAccount':
        return $1.OpenAccountRequest();
      case 'GetAccount':
        return $1.GetAccountRequest();
      case 'PostCharge':
        return $1.PostChargeRequest();
      case 'VoidCharge':
        return $1.VoidChargeRequest();
      case 'HoldCharge':
        return $1.HoldChargeRequest();
      case 'ReleaseCharge':
        return $1.ReleaseChargeRequest();
      case 'ListCharges':
        return $1.ListChargesRequest();
      case 'PackageLedger':
        return $1.PackageLedgerRequest();
      case 'RaiseInvoice':
        return $1.RaiseInvoiceRequest();
      case 'CorrectInvoice':
        return $1.CorrectInvoiceRequest();
      case 'GetInvoice':
        return $1.GetInvoiceRequest();
      case 'ListInvoices':
        return $1.ListInvoicesRequest();
      case 'ReceivePayment':
        return $1.ReceivePaymentRequest();
      case 'Refund':
        return $1.RefundRequest();
      case 'Statement':
        return $1.StatementRequest();
      case 'CloseAccount':
        return $1.CloseAccountRequest();
      case 'CloseReadiness':
        return $1.CloseReadinessRequest();
      case 'RevenueIntegrity':
        return $1.RevenueIntegrityRequest();
      case 'OpenShift':
        return $1.OpenShiftRequest();
      case 'CloseShift':
        return $1.CloseShiftRequest();
      case 'ApproveShift':
        return $1.ApproveShiftRequest();
      case 'ListShifts':
        return $1.ListShiftsRequest();
      case 'PublishService':
        return $1.PublishServiceRequest();
      case 'ListServices':
        return $1.ListServicesRequest();
      case 'PublishTariff':
        return $1.PublishTariffRequest();
      case 'ListTariffs':
        return $1.ListTariffsRequest();
      case 'Quote':
        return $1.QuoteRequest();
      case 'PublishPackage':
        return $1.PublishPackageRequest();
      case 'ListPackages':
        return $1.ListPackagesRequest();
      case 'SetBillingPolicy':
        return $1.SetBillingPolicyRequest();
      case 'GetBillingPolicy':
        return $1.GetBillingPolicyRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'OpenAccount':
        return openAccount(ctx, request as $1.OpenAccountRequest);
      case 'GetAccount':
        return getAccount(ctx, request as $1.GetAccountRequest);
      case 'PostCharge':
        return postCharge(ctx, request as $1.PostChargeRequest);
      case 'VoidCharge':
        return voidCharge(ctx, request as $1.VoidChargeRequest);
      case 'HoldCharge':
        return holdCharge(ctx, request as $1.HoldChargeRequest);
      case 'ReleaseCharge':
        return releaseCharge(ctx, request as $1.ReleaseChargeRequest);
      case 'ListCharges':
        return listCharges(ctx, request as $1.ListChargesRequest);
      case 'PackageLedger':
        return packageLedger(ctx, request as $1.PackageLedgerRequest);
      case 'RaiseInvoice':
        return raiseInvoice(ctx, request as $1.RaiseInvoiceRequest);
      case 'CorrectInvoice':
        return correctInvoice(ctx, request as $1.CorrectInvoiceRequest);
      case 'GetInvoice':
        return getInvoice(ctx, request as $1.GetInvoiceRequest);
      case 'ListInvoices':
        return listInvoices(ctx, request as $1.ListInvoicesRequest);
      case 'ReceivePayment':
        return receivePayment(ctx, request as $1.ReceivePaymentRequest);
      case 'Refund':
        return refund(ctx, request as $1.RefundRequest);
      case 'Statement':
        return statement(ctx, request as $1.StatementRequest);
      case 'CloseAccount':
        return closeAccount(ctx, request as $1.CloseAccountRequest);
      case 'CloseReadiness':
        return closeReadiness(ctx, request as $1.CloseReadinessRequest);
      case 'RevenueIntegrity':
        return revenueIntegrity(ctx, request as $1.RevenueIntegrityRequest);
      case 'OpenShift':
        return openShift(ctx, request as $1.OpenShiftRequest);
      case 'CloseShift':
        return closeShift(ctx, request as $1.CloseShiftRequest);
      case 'ApproveShift':
        return approveShift(ctx, request as $1.ApproveShiftRequest);
      case 'ListShifts':
        return listShifts(ctx, request as $1.ListShiftsRequest);
      case 'PublishService':
        return publishService(ctx, request as $1.PublishServiceRequest);
      case 'ListServices':
        return listServices(ctx, request as $1.ListServicesRequest);
      case 'PublishTariff':
        return publishTariff(ctx, request as $1.PublishTariffRequest);
      case 'ListTariffs':
        return listTariffs(ctx, request as $1.ListTariffsRequest);
      case 'Quote':
        return quote(ctx, request as $1.QuoteRequest);
      case 'PublishPackage':
        return publishPackage(ctx, request as $1.PublishPackageRequest);
      case 'ListPackages':
        return listPackages(ctx, request as $1.ListPackagesRequest);
      case 'SetBillingPolicy':
        return setBillingPolicy(ctx, request as $1.SetBillingPolicyRequest);
      case 'GetBillingPolicy':
        return getBillingPolicy(ctx, request as $1.GetBillingPolicyRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => BillingServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => BillingServiceBase$messageJson;
}
