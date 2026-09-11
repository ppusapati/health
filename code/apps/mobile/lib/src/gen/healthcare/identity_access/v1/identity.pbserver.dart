// This is a generated file - do not edit.
//
// Generated from healthcare/identity_access/v1/identity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'identity.pb.dart' as $1;
import 'identity.pbjson.dart';

export 'identity.pb.dart';

abstract class IdentityServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GetSessionContextResponse> getSessionContext(
      $pb.ServerContext ctx, $1.GetSessionContextRequest request);
  $async.Future<$1.EvaluateAccessResponse> evaluateAccess(
      $pb.ServerContext ctx, $1.EvaluateAccessRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetSessionContext':
        return $1.GetSessionContextRequest();
      case 'EvaluateAccess':
        return $1.EvaluateAccessRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetSessionContext':
        return getSessionContext(ctx, request as $1.GetSessionContextRequest);
      case 'EvaluateAccess':
        return evaluateAccess(ctx, request as $1.EvaluateAccessRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => IdentityServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => IdentityServiceBase$messageJson;
}
