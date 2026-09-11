/// Connect protocol client.
///
/// The Connect protocol is an HTTP POST per RPC to
/// `/<package>.<Service>/<Method>`, so a thin transport over `package:http` is
/// enough. What matters is that the request and response bodies are the
/// generated protobuf messages — no handwritten wire types (SRS-API-001), and
/// the same canonical contracts the Svelte app uses (Gate A9).
library;

import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';

import 'api_error.dart';

/// Header names shared with the Go transport layer.
class ConnectHeaders {
  static const authorization = 'Authorization';
  static const correlationId = 'X-Correlation-Id';
  static const facilityId = 'X-Facility-Id';
  static const purposeOfUse = 'X-Purpose-Of-Use';
  static const idempotencyKey = 'Idempotency-Key';
}

/// Supplies credentials for each request.
typedef CredentialsProvider = String? Function();

/// Generates correlation identifiers.
typedef CorrelationIdFactory = String Function();

/// Default correlation ID generator.
///
/// Not cryptographic: a correlation ID is for joining a user's report to a
/// server trace, not for authorisation.
String defaultCorrelationId() {
  final random = Random();
  final bytes = List<int>.generate(8, (_) => random.nextInt(256));
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return 'cid-${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}-$hex';
}

/// Transport for Connect RPCs.
class ConnectClient {
  ConnectClient({
    required this.baseUrl,
    required this.credentials,
    http.Client? httpClient,
    CorrelationIdFactory? correlationIds,
    this.timeout = const Duration(seconds: 20),
  })  : _http = httpClient ?? http.Client(),
        _correlationIds = correlationIds ?? defaultCorrelationId;

  final String baseUrl;
  final CredentialsProvider credentials;
  final Duration timeout;

  final http.Client _http;
  final CorrelationIdFactory _correlationIds;

  /// Calls one unary RPC.
  ///
  /// [parse] converts the response bytes into the generated message type; the
  /// caller supplies it because Dart cannot construct a generic message from a
  /// type parameter alone.
  Future<TResponse> unary<TRequest extends GeneratedMessage, TResponse>({
    required String procedure,
    required TRequest request,
    required TResponse Function(List<int> bytes) parse,
    String? activeFacilityId,
    String? purposeOfUse,
    String? idempotencyKey,
    String? overrideToken,
  }) async {
    final uri = Uri.parse('$baseUrl$procedure');

    final headers = <String, String>{
      'Content-Type': 'application/proto',
      ConnectHeaders.correlationId: _correlationIds(),
    };

    final token = overrideToken ?? credentials();
    if (token != null) {
      headers[ConnectHeaders.authorization] = 'Bearer $token';
    }
    if (activeFacilityId != null) {
      headers[ConnectHeaders.facilityId] = activeFacilityId;
    }
    if (purposeOfUse != null) {
      headers[ConnectHeaders.purposeOfUse] = purposeOfUse;
    }
    // Present only on retryable commands, so a lost response cannot become a
    // duplicate order or payment (SRS-API-003).
    if (idempotencyKey != null) {
      headers[ConnectHeaders.idempotencyKey] = idempotencyKey;
    }

    final http.Response response;
    try {
      response = await _http
          .post(uri, headers: headers, body: request.writeToBuffer())
          .timeout(timeout);
    } on Exception {
      // A transport failure is indistinguishable from being offline from the
      // caller's point of view, and both mean "queue it and retry".
      throw ApiError.offline();
    }

    if (response.statusCode == 200) {
      return parse(response.bodyBytes);
    }

    // Connect returns errors as JSON regardless of the request codec.
    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      throw ApiError.fromJson(decoded);
    } on FormatException {
      throw ApiError(
        status: ApiStatus.unknown,
        code: 'MALFORMED_ERROR_RESPONSE',
        correlationId: response.headers[ConnectHeaders.correlationId.toLowerCase()] ?? '',
      );
    }
  }

  void close() => _http.close();
}
