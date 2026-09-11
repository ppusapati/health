import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/api/api_error.dart';
import 'package:health_mobile/src/api/connect_client.dart';
import 'package:health_mobile/src/api/organization_client.dart';
import 'package:health_mobile/src/gen/healthcare/organization/v1/organization.pb.dart';
import 'package:http/http.dart' as http;

/// Captures requests and returns a canned response.
class FakeHttp extends http.BaseClient {
  FakeHttp(this._respond);

  final http.Response Function(http.Request request) _respond;
  final List<http.Request> requests = [];

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final typed = request as http.Request;
    requests.add(typed);
    final response = _respond(typed);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
    );
  }
}

ConnectClient clientFor(FakeHttp http, {String? token}) => ConnectClient(
      baseUrl: 'http://api.test',
      credentials: () => token,
      httpClient: http,
      correlationIds: () => 'cid-fixed',
    );

void main() {
  group('ConnectClient', () {
    test('posts protobuf to the canonical procedure path', () async {
      final response = ListFacilitiesResponse(
        facilities: [Facility(facilityId: 'f-1', code: 'MAIN', displayName: 'Main Hospital')],
      );
      final fake = FakeHttp((_) => http.Response.bytes(response.writeToBuffer(), 200));

      final result = await OrganizationClient(clientFor(fake, token: 'tok')).listFacilities();

      expect(result.facilities.single.code, 'MAIN');

      final request = fake.requests.single;
      // Gate A9: the Flutter app calls the same endpoint the Svelte app does,
      // derived from the same proto package.
      expect(request.url.path, '/healthcare.organization.v1.OrganizationService/ListFacilities');
      expect(request.headers['Content-Type'], 'application/proto');
      expect(request.headers[ConnectHeaders.authorization], 'Bearer tok');
    });

    test('always sends a correlation ID', () async {
      final fake = FakeHttp((_) => http.Response.bytes(ListFacilitiesResponse().writeToBuffer(), 200));

      await OrganizationClient(clientFor(fake)).listFacilities();

      expect(fake.requests.single.headers[ConnectHeaders.correlationId], 'cid-fixed');
    });

    // Signed out means no Authorization header at all, so the server applies
    // deny-by-default rather than seeing an empty credential.
    test('sends no authorization header when signed out', () async {
      final fake = FakeHttp((_) => http.Response.bytes(ListFacilitiesResponse().writeToBuffer(), 200));

      await OrganizationClient(clientFor(fake)).listFacilities();

      expect(fake.requests.single.headers.containsKey(ConnectHeaders.authorization), isFalse);
    });

    // A lost response on a retryable command must not become a duplicate
    // record, so the key travels with the request (SRS-API-003).
    test('sends an idempotency key on retryable commands', () async {
      final fake = FakeHttp((_) => http.Response.bytes(CreateFacilityResponse().writeToBuffer(), 200));

      await OrganizationClient(clientFor(fake, token: 'tok')).createFacility(
        code: 'MAIN',
        displayName: 'Main Hospital',
        type: FacilityType.FACILITY_TYPE_HOSPITAL,
        timeZone: 'Asia/Kolkata',
        idempotencyKey: 'idem-1',
      );

      expect(fake.requests.single.headers[ConnectHeaders.idempotencyKey], 'idem-1');
    });

    // A query carries no idempotency key: it has no side effect to deduplicate.
    test('sends no idempotency key on queries', () async {
      final fake = FakeHttp((_) => http.Response.bytes(ListFacilitiesResponse().writeToBuffer(), 200));

      await OrganizationClient(clientFor(fake, token: 'tok')).listFacilities();

      expect(fake.requests.single.headers.containsKey(ConnectHeaders.idempotencyKey), isFalse);
    });

    test('the request body is the generated protobuf message', () async {
      final fake = FakeHttp((_) => http.Response.bytes(CreateFacilityResponse().writeToBuffer(), 200));

      await OrganizationClient(clientFor(fake, token: 'tok')).createFacility(
        code: 'MAIN',
        displayName: 'Main Hospital',
        type: FacilityType.FACILITY_TYPE_HOSPITAL,
        timeZone: 'Asia/Kolkata',
        idempotencyKey: 'idem-1',
      );

      // Decoding with the generated type proves the bytes are a real message,
      // not a hand-rolled body that merely looks right.
      final decoded = CreateFacilityRequest.fromBuffer(fake.requests.single.bodyBytes);
      expect(decoded.code, 'MAIN');
      expect(decoded.type, FacilityType.FACILITY_TYPE_HOSPITAL);
      // The request carries no tenant: tenancy comes from the token.
      expect(decoded.getTagNumber('tenantId'), isNull);
    });

    test('turns a Connect error body into a structured ApiError', () async {
      final fake = FakeHttp((_) => http.Response(
            jsonEncode({
              'code': 'already_exists',
              'message': 'facility code already exists in this tenant',
              'details': [
                {
                  'debug': {'code': 'ORG_FACILITY_CODE_TAKEN', 'correlationId': 'corr-9'},
                },
              ],
            }),
            409,
          ));

      await expectLater(
        OrganizationClient(clientFor(fake, token: 'tok')).listFacilities(),
        throwsA(isA<ApiError>()
            .having((e) => e.code, 'code', 'ORG_FACILITY_CODE_TAKEN')
            .having((e) => e.correlationId, 'correlationId', 'corr-9')
            .having((e) => e.status, 'status', ApiStatus.alreadyExists)),
      );
    });

    // A transport failure is indistinguishable from being offline, and both
    // mean "queue it and retry".
    test('a transport failure surfaces as a retryable offline error', () async {
      final fake = FakeHttp((_) => throw const SocketFailure());

      await expectLater(
        OrganizationClient(clientFor(fake, token: 'tok')).listFacilities(),
        throwsA(isA<ApiError>()
            .having((e) => e.code, 'code', 'OFFLINE')
            .having((e) => e.retryable, 'retryable', isTrue)),
      );
    });

    test('a non-JSON error body does not crash the client', () async {
      final fake = FakeHttp((_) => http.Response('<html>502 Bad Gateway</html>', 502));

      await expectLater(
        OrganizationClient(clientFor(fake, token: 'tok')).listFacilities(),
        throwsA(isA<ApiError>().having((e) => e.code, 'code', 'MALFORMED_ERROR_RESPONSE')),
      );
    });
  });
}

/// Stand-in for a socket-level failure.
class SocketFailure implements Exception {
  const SocketFailure();
}
