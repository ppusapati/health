import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/api/api_error.dart';

void main() {
  group('ApiError.fromJson', () {
    test('extracts the machine code and correlation ID for support', () {
      final error = ApiError.fromJson({
        'code': 'invalid_argument',
        'message': 'facility is not valid',
        'details': [
          {
            'type': 'healthcare.common.v1.ErrorDetail',
            'debug': {
              'code': 'ORG_FACILITY_INVALID',
              'correlationId': 'corr-123',
              'fieldViolations': [
                {'field': 'code', 'reason': 'INVALID_FORMAT'},
                {'field': 'display_name', 'reason': 'REQUIRED'},
              ],
            },
          },
        ],
      });

      expect(error.status, ApiStatus.invalidArgument);
      expect(error.code, 'ORG_FACILITY_INVALID');
      expect(error.correlationId, 'corr-123');
      expect(error.fieldViolations, {
        'code': 'INVALID_FORMAT',
        'display_name': 'REQUIRED',
      });
    });

    // The server message may quote user input or internal detail; the app shows
    // its own wording instead.
    test('never displays the raw server message', () {
      final error = ApiError.fromJson({
        'code': 'internal',
        'message': 'pq: duplicate key value violates unique constraint',
      });

      expect(error.message, isNot(contains('pq:')));
      expect(error.message, 'Something went wrong. Please try again.');
    });

    test('maps each status to distinct guidance', () {
      expect(ApiError.fromJson({'code': 'permission_denied'}).message,
          'You do not have permission to do that.');
      expect(ApiError.fromJson({'code': 'not_found'}).message,
          'That record could not be found.');
      expect(ApiError.fromJson({'code': 'unauthenticated'}).message,
          'Your session has expired. Please sign in again.');
    });

    test('an unknown status code degrades to the generic message', () {
      final error = ApiError.fromJson({'code': 'teapot'});
      expect(error.status, ApiStatus.unknown);
      expect(error.message, 'Something went wrong. Please try again.');
    });

    test('tolerates an error body with no details', () {
      final error = ApiError.fromJson({'code': 'not_found'});
      expect(error.correlationId, '');
      expect(error.fieldViolations, isEmpty);
    });

    test('marks transient statuses retryable', () {
      expect(ApiError.fromJson({'code': 'unavailable'}).retryable, isTrue);
      expect(ApiError.fromJson({'code': 'deadline_exceeded'}).retryable, isTrue);
      expect(ApiError.fromJson({'code': 'invalid_argument'}).retryable, isFalse);
      expect(ApiError.fromJson({'code': 'permission_denied'}).retryable, isFalse);
    });
  });

  group('ApiError.offline', () {
    // Offline is retryable and its message must reassure the user their work is
    // kept, because it is: it went into the queue.
    test('is retryable and says the work was saved', () {
      final error = ApiError.offline();
      expect(error.retryable, isTrue);
      expect(error.code, 'OFFLINE');
      expect(error.message, contains('saved'));
    });
  });

  group('describeFieldReason', () {
    test('translates known reason codes', () {
      expect(describeFieldReason('REQUIRED'), 'This field is required.');
      expect(describeFieldReason('UNKNOWN_IANA_ZONE'), 'Choose a valid time zone.');
    });

    test('falls back to the raw code rather than rendering nothing', () {
      expect(describeFieldReason('SOME_NEW_REASON'), 'SOME_NEW_REASON');
    });
  });
}
