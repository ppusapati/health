/// SRS-WEB-008's verification clause: a repeated click or a network retry
/// creates one transaction. The key is minted on the device before the first
/// attempt, so every retry of that administration carries the same one and the
/// server can tell a retry from a second dose.
/// Recording an administration from a device that may be offline.
///
/// The three facts that have to survive a lost network are different facts, and
/// most of these tests are about keeping them apart.
library;

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/api/api_error.dart';
import 'package:health_mobile/src/api/optimistic.dart';
import 'package:health_mobile/src/meds/round.dart';
import 'package:health_mobile/src/meds/submission.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';

final _bedside = DateTime.utc(2026, 9, 15, 8, 0);
final _reconnected = DateTime.utc(2026, 9, 15, 8, 47);

CapturedAdministration captured({
  String key = 'idem-1',
  AdministrationOutcome outcome = AdministrationOutcome.administered,
  DateTime? givenAt,
}) =>
    CapturedAdministration(
      orderId: 'order-1',
      facilityId: 'facility-1',
      scheduledAt: _bedside,
      givenAt: givenAt ?? _bedside,
      outcome: outcome,
      idempotencyKey: key,
      doseValue: 500,
      doseUnit: 'mg',
      route: 'oral',
      scan: const Scan(patient: 'wristband-1', medication: 'pack-1'),
    );

void main() {
  late OperationQueue queue;

  setUp(() => queue = OperationQueue(InMemoryQueueStorage()));

  test('a delivered administration is confirmed and nothing is queued', () async {
    final result = await submitAdministration(
      captured: captured(),
      send: () async {},
      queue: queue,
    );

    expect(result.state, SubmissionState.confirmed);
    expect(result.settled, isTrue);
    expect(await queue.pending(), isEmpty);
  });

  test('a lost network queues the dose and does not claim it was given', () async {
    final result = await submitAdministration(
      captured: captured(),
      send: () async => throw ApiError.offline(),
      queue: queue,
      now: _reconnected,
    );

    expect(result.state, SubmissionState.queued);
    // Queued is a promise, not a fact. A nurse shown "given" for something that
    // never arrived is a nurse whose colleague gives it again.
    expect(result.settled, isFalse);
    expect(result.message, contains('Saved on this device'));
    expect(await queue.pending(), hasLength(1));
  });

  test('the queued dose keeps the bedside time, not the reconnect time', () async {
    await submitAdministration(
      captured: captured(),
      send: () async => throw ApiError.offline(),
      queue: queue,
      now: _reconnected,
    );

    final queued = (await queue.pending()).single;
    expect(queued.payload['given_at'], _bedside.toIso8601String());
    // A dose that read as given at 08:47 because that is when the lift doors
    // opened would be a falsified record.
    expect(queued.payload['given_at'], isNot(contains('08:47')));
  });

  test('a timeout queues too — nobody decided anything', () async {
    final result = await submitAdministration(
      captured: captured(),
      send: () async => throw TimeoutException('no response'),
      queue: queue,
    );

    expect(result.state, SubmissionState.queued);
    expect(await queue.pending(), hasLength(1));
  });

  test('a refusal by the server is not queued', () async {
    // The order was cancelled, or the override was not permitted. That is an
    // answer, and replaying it later is asking the same question hoping for a
    // different one.
    final result = await submitAdministration(
      captured: captured(),
      send: () async => throw ApiError(
        status: ApiStatus.failedPrecondition,
        code: 'ORDER_NOT_ACTIVE',
        correlationId: 'corr-1',
      ),
      queue: queue,
    );

    expect(result.state, SubmissionState.failed);
    expect(result.settled, isFalse);
    expect(await queue.pending(), isEmpty);
  });

  test('a permission refusal is not queued either', () async {
    final result = await submitAdministration(
      captured: captured(),
      send: () async => throw ApiError(
        status: ApiStatus.permissionDenied,
        code: 'FORBIDDEN',
        correlationId: 'corr-2',
      ),
      queue: queue,
    );

    expect(result.state, SubmissionState.failed);
    expect(await queue.pending(), isEmpty);
  });

  test('the queued operation is keyed on the idempotency key the request used',
      () async {
    await submitAdministration(
      captured: captured(key: 'idem-42'),
      send: () async => throw ApiError.offline(),
      queue: queue,
    );

    final queued = (await queue.pending()).single;
    expect(queued.id, 'idem-42');
    expect(queued.payload['idempotency_key'], 'idem-42');
  });

  test('the same dose queued twice stays one dose', () async {
    // A nurse who presses record, sees nothing happen, and presses again must
    // not produce two administrations.
    for (var attempt = 0; attempt < 2; attempt++) {
      await submitAdministration(
        captured: captured(key: 'idem-same'),
        send: () async => throw ApiError.offline(),
        queue: queue,
      );
    }

    expect(await queue.pending(), hasLength(1));
  });

  test('two different doses queue separately', () async {
    for (final key in ['idem-a', 'idem-b']) {
      await submitAdministration(
        captured: captured(key: key),
        send: () async => throw ApiError.offline(),
        queue: queue,
      );
    }

    expect(await queue.pending(), hasLength(2));
  });

  test('the payload carries what the replay needs and nothing invented', () async {
    await submitAdministration(
      captured: captured(outcome: AdministrationOutcome.refused),
      send: () async => throw ApiError.offline(),
      queue: queue,
    );

    final payload = (await queue.pending()).single.payload;
    expect(payload['order_id'], 'order-1');
    expect(payload['facility_id'], 'facility-1');
    expect(payload['outcome'], 'refused');
    expect(payload['dose_value'], 500);
    expect(payload['dose_unit'], 'mg');
    expect(payload['patient_scanned'], 'wristband-1');
    expect(payload['medication_scanned'], 'pack-1');
  });

  test('the operation type says what it is, so a replayer can route it', () async {
    await submitAdministration(
      captured: captured(),
      send: () async => throw ApiError.offline(),
      queue: queue,
    );

    expect((await queue.pending()).single.type, administrationOperationType);
    expect(administrationOperationType, 'nursing.administer');
  });

  test('a queued dose survives the app being killed', () async {
    // The storage is what the real queue uses; the point is that the dose is on
    // disk before the nurse is told it is saved.
    final storage = InMemoryQueueStorage();
    await submitAdministration(
      captured: captured(key: 'idem-survive'),
      send: () async => throw ApiError.offline(),
      queue: OperationQueue(storage),
    );

    final afterRestart = OperationQueue(storage);
    final pending = await afterRestart.pending();
    expect(pending, hasLength(1));
    expect(pending.single.id, 'idem-survive');
    expect(pending.single.payload['given_at'], _bedside.toIso8601String());
  });

  test('the tile is told pending before it is told anything else', () async {
    // The whole point of not being optimistic is that there is a visible
    // pending state. If nothing reports it, the tile jumps from idle to given
    // and the distinction exists only in the comments.
    final seen = <OptimisticState>[];

    await submitAdministration(
      captured: captured(),
      send: () async {},
      queue: queue,
      onProgress: (result) => seen.add(result.state),
    );

    expect(seen, [OptimisticState.pending, OptimisticState.confirmed]);
  });

  test('a queued dose was pending and then rolled back, never confirmed', () async {
    final seen = <OptimisticState>[];

    await submitAdministration(
      captured: captured(),
      send: () async => throw ApiError.offline(),
      queue: queue,
      onProgress: (result) => seen.add(result.state),
    );

    expect(seen, [OptimisticState.pending, OptimisticState.rolledBack]);
    expect(seen, isNot(contains(OptimisticState.confirmed)));
  });
}
