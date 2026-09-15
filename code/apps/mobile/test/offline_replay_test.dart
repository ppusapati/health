/// Replaying what a ward tablet captured while it was offline.
///
/// The rule under test throughout: a replay re-sends what was captured, it does
/// not reconstruct it. Every field the server needs was written to disk at the
/// moment it was true.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/api/api_error.dart';
import 'package:health_mobile/src/api/connect_client.dart';
import 'package:health_mobile/src/api/nursing_client.dart';
import 'package:health_mobile/src/gen/healthcare/nursing/v1/nursing.pb.dart'
    hide AdministrationOutcome;
import 'package:health_mobile/src/gen/healthcare/nursing/v1/nursing.pbenum.dart'
    as wire;
import 'package:health_mobile/src/meds/round.dart';
import 'package:health_mobile/src/meds/submission.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/offline/replay.dart';
import 'package:health_mobile/src/offline/sync.dart';
import 'package:http/http.dart' as http;

final _bedside = DateTime.utc(2026, 9, 15, 8, 0);

/// Captures what actually went on the wire.
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

NursingClient nursingOver(FakeHttp fake) => NursingClient(ConnectClient(
      baseUrl: 'http://api.test',
      credentials: () => 'tok',
      httpClient: fake,
      correlationIds: () => 'cid-fixed',
    ));

QueuedOperation queued({
  String key = 'idem-1',
  AdministrationOutcome outcome = AdministrationOutcome.administered,
  Scan scan = const Scan(patient: 'wristband-1', medication: 'pack-1'),
  String overrideReason = '',
}) {
  final captured = CapturedAdministration(
    orderId: 'order-1',
    facilityId: 'facility-1',
    scheduledAt: _bedside,
    givenAt: _bedside,
    outcome: outcome,
    idempotencyKey: key,
    doseValue: 500,
    doseUnit: 'mg',
    route: 'oral',
    scan: scan,
    overrideReason: overrideReason,
  );
  return QueuedOperation(
    id: key,
    type: administrationOperationType,
    payload: captured.toPayload(),
    occurredAt: _bedside,
  );
}

AdministerRequest sentRequest(FakeHttp fake) =>
    AdministerRequest.fromBuffer(fake.requests.single.bodyBytes);

void main() {
  late FakeHttp fake;

  http.Response ok(http.Request _) =>
      http.Response.bytes(AdministerResponse().writeToBuffer(), 200);

  setUp(() => fake = FakeHttp(ok));

  group('re-sending an administration', () {
    test('goes to the canonical procedure path', () async {
      await administrationSender(nursingOver(fake))(queued());

      expect(fake.requests.single.url.path,
          '/healthcare.nursing.v1.NursingService/Administer');
    });

    test('carries the bedside time, not the time of the replay', () async {
      await administrationSender(nursingOver(fake))(queued());

      expect(sentRequest(fake).givenAt.toDateTime().toUtc(), _bedside);
    });

    test('carries the key minted at the bedside', () async {
      // Same key means the same operation. A fresh one would be a second dose.
      await administrationSender(nursingOver(fake))(queued(key: 'idem-42'));

      expect(sentRequest(fake).idempotencyKey, 'idem-42');
      expect(fake.requests.single.headers[ConnectHeaders.idempotencyKey],
          'idem-42');
    });

    test('tells the server it was captured offline', () async {
      // A different fact from when it arrived, and this is the only machine
      // that knows it.
      await administrationSender(nursingOver(fake))(queued());

      expect(sentRequest(fake).offline, isTrue);
    });

    test('carries the dose as captured', () async {
      await administrationSender(nursingOver(fake))(queued());

      final request = sentRequest(fake);
      expect(request.givenDose.value, 500);
      expect(request.givenDose.unit, 'mg');
      expect(request.route, 'oral');
    });

    test('rebuilds the verification from what was actually scanned', () async {
      await administrationSender(nursingOver(fake))(queued());

      final verification = sentRequest(fake).verification;
      expect(verification.patientScanned, 'wristband-1');
      expect(verification.medicationScanned, 'pack-1');
      expect(verification.performed, isTrue);
    });

    test('a half-scanned dose is not reported as verified', () async {
      await administrationSender(nursingOver(fake))(
          queued(scan: const Scan(patient: 'wristband-1')));

      final verification = sentRequest(fake).verification;
      expect(verification.patientScanned, 'wristband-1');
      expect(verification.medicationScanned, isEmpty);
      expect(verification.performed, isFalse);
    });

    test('an override survives the queue', () async {
      // An override nobody can find afterwards is not a control.
      await administrationSender(nursingOver(fake))(queued(
        scan: const Scan(),
        overrideReason: 'Scanner failed; second nurse checked',
      ));

      expect(sentRequest(fake).overrideReason,
          'Scanner failed; second nurse checked');
    });

    test('every outcome survives the round trip through the queue', () async {
      for (final outcome in [
        AdministrationOutcome.administered,
        AdministrationOutcome.notAdministered,
        AdministrationOutcome.held,
        AdministrationOutcome.refused,
        AdministrationOutcome.delayed,
      ]) {
        final each = FakeHttp(ok);
        await administrationSender(nursingOver(each))(
            queued(outcome: outcome, key: outcome.name));

        final sent = AdministerRequest.fromBuffer(each.requests.single.bodyBytes);
        expect(sent.outcome, isNot(wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_UNSPECIFIED),
            reason: outcome.name);
        expect(
          sent.outcome.name
              .replaceFirst('ADMINISTRATION_OUTCOME_', '')
              .replaceAll('_', '')
              .toLowerCase(),
          outcome.name.toLowerCase(),
          reason: outcome.name,
        );
      }
    });

    test('an outcome nothing recognises is refused, not defaulted', () async {
      // Defaulting would file a dose that was held or refused as though nothing
      // had been decided about it.
      final corrupt = QueuedOperation(
        id: 'idem-bad',
        type: administrationOperationType,
        payload: {...queued().payload, 'outcome': 'teleported'},
        occurredAt: _bedside,
      );

      await expectLater(
        administrationSender(nursingOver(fake))(corrupt),
        throwsA(isA<ApiError>().having(
            (e) => e.code, 'code', 'UNKNOWN_ADMINISTRATION_OUTCOME')),
      );
    });
  });

  group('routing', () {
    test('the ward router handles administrations', () {
      expect(wardRouter(nursingOver(fake)).handledTypes,
          contains(administrationOperationType));
    });

    test('an operation nothing claims is refused rather than dropped', () async {
      // A queue that silently discards what it cannot route loses a nurse's
      // work and reports success.
      final stranger = QueuedOperation(
        id: 'op-1',
        type: 'something.nobody.registered',
        payload: const {},
        occurredAt: _bedside,
      );

      await expectLater(
        wardRouter(nursingOver(fake)).send(stranger),
        throwsA(isA<ApiError>()
            .having((e) => e.code, 'code', 'UNROUTABLE_OPERATION')),
      );
    });
  });

  group('draining the queue', () {
    test('a queued dose is delivered and marked sent', () async {
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(queued());

      final router = wardRouter(nursingOver(fake));
      final result = await SyncService(queue, router.send).sync();

      expect(result.sent, 1);
      expect(result.isComplete, isTrue);
      expect(await queue.pending(), isEmpty);
    });

    test('an unroutable operation is parked, not retried forever', () async {
      // Deferring it would retry forever and the queue would never drain past
      // it. Marked failed, it is where somebody will see it.
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(QueuedOperation(
        id: 'op-1',
        type: 'something.nobody.registered',
        payload: const {},
        occurredAt: _bedside,
      ));

      final result = await SyncService(queue, wardRouter(nursingOver(fake)).send).sync();

      expect(result.failed, 1);
      expect(await queue.pending(), isEmpty);
      expect((await queue.counts())[QueuedStatus.failed], 1);
    });

    test('a dose the server still cannot take stays pending', () async {
      final offline = FakeHttp((_) => http.Response(
            '{"code":"unavailable","message":"no"}',
            503,
            headers: const {'content-type': 'application/json'},
          ));
      final queue = OperationQueue(InMemoryQueueStorage());
      await queue.enqueue(queued());

      final result =
          await SyncService(queue, wardRouter(nursingOver(offline)).send).sync();

      expect(result.sent, 0);
      expect(result.deferred, 1);
      expect(await queue.pending(), hasLength(1));
    });
  });
}
