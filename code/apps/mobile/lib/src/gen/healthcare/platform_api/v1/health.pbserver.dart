// This is a generated file - do not edit.
//
// Generated from healthcare/platform_api/v1/health.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'health.pb.dart' as $0;
import 'health.pbjson.dart';

export 'health.pb.dart';

abstract class HealthServiceBase extends $pb.GeneratedService {
  $async.Future<$0.CheckLivenessResponse> checkLiveness(
      $pb.ServerContext ctx, $0.CheckLivenessRequest request);
  $async.Future<$0.CheckReadinessResponse> checkReadiness(
      $pb.ServerContext ctx, $0.CheckReadinessRequest request);
  $async.Future<$0.GetBuildInfoResponse> getBuildInfo(
      $pb.ServerContext ctx, $0.GetBuildInfoRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CheckLiveness':
        return $0.CheckLivenessRequest();
      case 'CheckReadiness':
        return $0.CheckReadinessRequest();
      case 'GetBuildInfo':
        return $0.GetBuildInfoRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CheckLiveness':
        return checkLiveness(ctx, request as $0.CheckLivenessRequest);
      case 'CheckReadiness':
        return checkReadiness(ctx, request as $0.CheckReadinessRequest);
      case 'GetBuildInfo':
        return getBuildInfo(ctx, request as $0.GetBuildInfoRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => HealthServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => HealthServiceBase$messageJson;
}
