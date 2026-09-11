/// Error presentation for the mobile client.
///
/// The server returns a stable machine code plus field violations
/// (SRS-API-004); the app turns those into language a patient or a nurse can
/// act on. Display strings live here only, so wording stays consistent and
/// translatable (SRS-NFR-008).
library;

import '../gen/healthcare/common/v1/common.pb.dart';

/// Connect status codes, as returned in the JSON error body.
enum ApiStatus {
  canceled,
  unknown,
  invalidArgument,
  deadlineExceeded,
  notFound,
  alreadyExists,
  permissionDenied,
  resourceExhausted,
  failedPrecondition,
  aborted,
  outOfRange,
  unimplemented,
  internal,
  unavailable,
  dataLoss,
  unauthenticated;

  static ApiStatus fromWire(String code) => switch (code) {
        'canceled' => ApiStatus.canceled,
        'invalid_argument' => ApiStatus.invalidArgument,
        'deadline_exceeded' => ApiStatus.deadlineExceeded,
        'not_found' => ApiStatus.notFound,
        'already_exists' => ApiStatus.alreadyExists,
        'permission_denied' => ApiStatus.permissionDenied,
        'resource_exhausted' => ApiStatus.resourceExhausted,
        'failed_precondition' => ApiStatus.failedPrecondition,
        'aborted' => ApiStatus.aborted,
        'out_of_range' => ApiStatus.outOfRange,
        'unimplemented' => ApiStatus.unimplemented,
        'internal' => ApiStatus.internal,
        'unavailable' => ApiStatus.unavailable,
        'data_loss' => ApiStatus.dataLoss,
        'unauthenticated' => ApiStatus.unauthenticated,
        _ => ApiStatus.unknown,
      };

  /// Whether an identical retry is safe without changing the request.
  bool get isRetryable =>
      this == ApiStatus.unavailable ||
      this == ApiStatus.deadlineExceeded ||
      this == ApiStatus.resourceExhausted;
}

/// A failed API call, in a form a screen can render.
class ApiError implements Exception {
  ApiError({
    required this.status,
    required this.code,
    required this.correlationId,
    this.fieldViolations = const {},
    this.retryable = false,
  });

  final ApiStatus status;

  /// Stable domain code, e.g. `ORG_FACILITY_CODE_TAKEN`.
  final String code;

  /// Correlation ID to quote to support (SRS-WEB-011 applied to mobile).
  final String correlationId;

  /// Field path to stable reason code, for inline form errors.
  final Map<String, String> fieldViolations;

  final bool retryable;

  /// Builds an error from a decoded Connect error body.
  factory ApiError.fromJson(Map<String, dynamic> body) {
    final status = ApiStatus.fromWire(body['code'] as String? ?? 'unknown');

    var domainCode = status.name;
    var correlationId = '';
    final violations = <String, String>{};
    var retryable = status.isRetryable;

    final details = body['details'];
    if (details is List) {
      for (final detail in details) {
        if (detail is! Map) continue;
        final debug = detail['debug'];
        if (debug is! Map) continue;

        domainCode = debug['code'] as String? ?? domainCode;
        correlationId = debug['correlationId'] as String? ?? correlationId;
        retryable = debug['retryable'] as bool? ?? retryable;

        final rawViolations = debug['fieldViolations'];
        if (rawViolations is List) {
          for (final violation in rawViolations) {
            if (violation is! Map) continue;
            final field = violation['field'] as String?;
            final reason = violation['reason'] as String?;
            if (field != null && reason != null) violations[field] = reason;
          }
        }
      }
    }

    return ApiError(
      status: status,
      code: domainCode,
      correlationId: correlationId,
      fieldViolations: violations,
      retryable: retryable,
    );
  }

  /// Builds an error from a structured ErrorDetail message.
  factory ApiError.fromDetail(ApiStatus status, ErrorDetail detail) => ApiError(
        status: status,
        code: detail.code,
        correlationId: detail.correlationId,
        // The Dart generator renames `field` to `field_1` because `field` is
        // reserved in generated message code.
        fieldViolations: {
          for (final v in detail.fieldViolations) v.field_1: v.reason,
        },
        retryable: detail.retryable,
      );

  /// A network failure before any response arrived.
  factory ApiError.offline() => ApiError(
        status: ApiStatus.unavailable,
        code: 'OFFLINE',
        correlationId: '',
        retryable: true,
      );

  /// User-facing message. Never the raw server message, which can quote input
  /// or internal detail.
  String get message => switch (status) {
        ApiStatus.invalidArgument => 'Please correct the highlighted fields.',
        ApiStatus.notFound => 'That record could not be found.',
        ApiStatus.alreadyExists => 'That record already exists.',
        ApiStatus.permissionDenied => 'You do not have permission to do that.',
        ApiStatus.unauthenticated => 'Your session has expired. Please sign in again.',
        ApiStatus.failedPrecondition => 'That action is not available right now.',
        ApiStatus.aborted => 'This changed while you were editing. Reload and try again.',
        ApiStatus.resourceExhausted => 'Too many requests. Please wait and try again.',
        ApiStatus.unavailable => 'You appear to be offline. Your work has been saved.',
        ApiStatus.deadlineExceeded => 'That took too long. Please try again.',
        _ => 'Something went wrong. Please try again.',
      };

  @override
  String toString() => 'ApiError($code, ${status.name})';
}

/// Guidance for a field reason code.
String describeFieldReason(String reason) => switch (reason) {
      'REQUIRED' => 'This field is required.',
      'INVALID_FORMAT' => 'Use 2–32 characters: letters, digits, hyphen or underscore.',
      'UNSUPPORTED' => 'Choose one of the available options.',
      'UNKNOWN_IANA_ZONE' => 'Choose a valid time zone.',
      'MUST_BE_ISO_3166_ALPHA2' => 'Use a two-letter country code.',
      _ => reason,
    };
