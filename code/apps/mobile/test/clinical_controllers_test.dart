/// The controllers between the screens and the server.
///
/// Driven against a fake transport returning real protobuf, so what is tested
/// is the mapping and the failure behaviour rather than a mock's opinion of
/// them.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/api/connect_client.dart';
import 'package:health_mobile/src/api/nursing_client.dart';
import 'package:fixnum/fixnum.dart';
import 'package:health_mobile/src/gen/healthcare/nursing/v1/nursing.pb.dart'
    hide AdministrationOutcome, EntrySource, TaskPriority, TaskStatus;
import 'package:health_mobile/src/gen/healthcare/nursing/v1/nursing.pbenum.dart'
    as wire;
import 'package:health_mobile/src/meds/round.dart';
import 'package:health_mobile/src/meds/round_controller.dart';
import 'package:health_mobile/src/meds/submission.dart';
import 'package:health_mobile/src/offline/operation_queue.dart';
import 'package:health_mobile/src/ward/ward_controller.dart';
import 'package:health_mobile/src/ward/worklist.dart';
import 'package:http/http.dart' as http;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

final _now = DateTime.utc(2026, 9, 15, 10, 0);

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
      correlationIds: () => 'cid',
    ));

Timestamp at(Duration offset) => Timestamp.fromDateTime(_now.add(offset));

http.Response offline(http.Request _) => http.Response(
      '{"code":"unavailable","message":"no"}',
      503,
      headers: const {'content-type': 'application/json'},
    );

void main() {
  var keys = 0;
  String nextKey() => 'idem-${++keys}';

  setUp(() => keys = 0);

  group('the ward controller', () {
    WardController controllerOver(FakeHttp fake) =>
        WardController(nursingOver(fake), () => _now, nextKey);

    test('maps the worklist and orders it', () async {
      final fake = FakeHttp((_) => http.Response.bytes(
            GetWorklistResponse(tasks: [
              NursingTask(
                taskId: 'routine',
                description: 'Reposition',
                priority: wire.TaskPriority.TASK_PRIORITY_ROUTINE,
                status: wire.TaskStatus.TASK_STATUS_PENDING,
                dueAt: at(const Duration(hours: 1)),
              ),
              NursingTask(
                taskId: 'critical',
                description: 'Neuro observations',
                priority: wire.TaskPriority.TASK_PRIORITY_CRITICAL,
                status: wire.TaskStatus.TASK_STATUS_PENDING,
                overdue: true,
                dueAt: at(const Duration(minutes: -30)),
              ),
            ]).writeToBuffer(),
            200,
          ));

      final controller = controllerOver(fake);
      await controller.load(encounterId: 'enc-1');

      expect(fake.requests.single.url.path,
          '/healthcare.nursing.v1.NursingService/GetWorklist');
      expect(controller.view!.tasks.map((t) => t.taskId),
          ['critical', 'routine']);
      expect(controller.view!.summary.open, 2);
      expect(controller.view!.summary.overdue, 1);
      expect(controller.failure, isNull);
    });

    test('overdue comes from the server even when the clock disagrees', () async {
      // The task is due in an hour by the device clock, and the server says it
      // is overdue. The server wins: it is the thing that escalates.
      final fake = FakeHttp((_) => http.Response.bytes(
            GetWorklistResponse(tasks: [
              NursingTask(
                taskId: 't1',
                status: wire.TaskStatus.TASK_STATUS_PENDING,
                overdue: true,
                dueAt: at(const Duration(hours: 1)),
              ),
            ]).writeToBuffer(),
            200,
          ));

      final controller = controllerOver(fake);
      await controller.load(encounterId: 'enc-1');

      expect(controller.view!.tasks.single.overdue, isTrue);
      expect(controller.view!.tasks.single.overdueMinutes, -60);
    });

    test('a priority this build does not know is not guessed at', () async {
      // Guessing downwards hides work; guessing upwards floods the top.
      final fake = FakeHttp((_) => http.Response.bytes(
            GetWorklistResponse(tasks: [
              NursingTask(
                taskId: 't1',
                status: wire.TaskStatus.TASK_STATUS_PENDING,
                priority: wire.TaskPriority.TASK_PRIORITY_UNSPECIFIED,
              ),
            ]).writeToBuffer(),
            200,
          ));

      final controller = controllerOver(fake);
      await controller.load(encounterId: 'enc-1');

      expect(controller.view!.tasks.single.priority, TaskPriority.unspecified);
      expect(controller.view!.tasks.single.priorityLabel, 'Not prioritised');
    });

    test('a failure keeps the rows already on screen', () async {
      var call = 0;
      final fake = FakeHttp((request) {
        call++;
        if (call == 1) {
          return http.Response.bytes(
            GetWorklistResponse(tasks: [
              NursingTask(taskId: 't1', status: wire.TaskStatus.TASK_STATUS_PENDING),
            ]).writeToBuffer(),
            200,
          );
        }
        return offline(request);
      });

      final controller = controllerOver(fake);
      await controller.load(encounterId: 'enc-1');
      await controller.load(encounterId: 'enc-1');

      // The rows are still the best information available.
      expect(controller.view!.tasks, hasLength(1));
      expect(controller.failure, contains('offline'));
    });

    test('a failure message is safe for a screen, never the raw server string',
        () async {
      final controller = controllerOver(FakeHttp(offline));
      await controller.load(encounterId: 'enc-1');

      expect(controller.failure, 'You appear to be offline. Your work has been saved.');
      expect(controller.view, isNull);
    });

    test('completing a task sends an idempotency key and reloads', () async {
      final fake = FakeHttp((request) {
        if (request.url.path.endsWith('CompleteTask')) {
          return http.Response.bytes(CompleteTaskResponse().writeToBuffer(), 200);
        }
        return http.Response.bytes(GetWorklistResponse().writeToBuffer(), 200);
      });

      final controller = controllerOver(fake);
      await controller.load(encounterId: 'enc-1');
      final ok = await controller.complete(
        task: presentTask(
          taskId: 't1',
          patientId: 'p1',
          description: 'Reposition',
          priority: TaskPriority.routine,
          status: TaskStatus.pending,
          dueAt: null,
          overdue: false,
          escalatedTo: '',
          sourceKind: '',
          version: 1,
          now: _now,
        ),
        evidence: 'Repositioned to left lateral',
        encounterId: 'enc-1',
      );

      expect(ok, isTrue);
      final complete = fake.requests
          .firstWhere((r) => r.url.path.endsWith('CompleteTask'));
      expect(complete.headers[ConnectHeaders.idempotencyKey], isNotEmpty);
      expect(CompleteTaskRequest.fromBuffer(complete.bodyBytes).evidence,
          'Repositioned to left lateral');
      // Reloaded rather than patched locally: the server may have escalated
      // something else meanwhile.
      expect(fake.requests.where((r) => r.url.path.endsWith('GetWorklist')),
          hasLength(2));
    });

    test('charting an observation says a person typed it', () async {
      final fake = FakeHttp((request) {
        if (request.url.path.endsWith('ChartObservation')) {
          return http.Response.bytes(
              ChartObservationResponse().writeToBuffer(), 200);
        }
        return http.Response.bytes(GetWorklistResponse().writeToBuffer(), 200);
      });

      final controller = controllerOver(fake);
      final ok = await controller.chart(
        patientId: 'p1',
        encounterId: 'enc-1',
        code: Coding(code: '8310-5', display: 'Body temperature'),
        observedAt: _now.subtract(const Duration(minutes: 20)),
        value: 36.8,
        unit: '°C',
        lateEntryReason: 'Charted after the resuscitation',
      );

      expect(ok, isTrue);
      final sent = ChartObservationRequest.fromBuffer(fake.requests
          .firstWhere((r) => r.url.path.endsWith('ChartObservation'))
          .bodyBytes);
      expect(sent.source, wire.EntrySource.ENTRY_SOURCE_MANUAL);
      expect(sent.value.value, 36.8);
      expect(sent.lateEntryReason, 'Charted after the resuscitation');
      expect(sent.observedAt.toDateTime().toUtc(),
          _now.subtract(const Duration(minutes: 20)));
    });
  });

  group('the round controller', () {
    GetMedicationRoundResponse round({bool barcode = true}) =>
        GetMedicationRoundResponse(
          doses: [
            DueDose(
              order: MedicationOrder(
                orderId: 'order-1',
                medication: Coding(code: 'N02BE01', display: 'Paracetamol'),
                dose: Quantity(value: 500, unit: 'mg'),
                route: 'oral',
                verified: true,
              ),
              scheduledAt: at(const Duration(minutes: -30)),
              outstanding: true,
              overdue: true,
            ),
          ],
          policy: AdministrationPolicy(
            barcodeRequired: barcode,
            overrideAllowed: false,
            lateAfterSeconds: Int64(3600),
          ),
        );

    RoundController controllerOver(FakeHttp fake, OperationQueue queue) =>
        RoundController(nursingOver(fake), queue, () => _now, nextKey);

    test('maps the doses and the policy that governs them', () async {
      final fake = FakeHttp(
          (_) => http.Response.bytes(round().writeToBuffer(), 200));
      final controller =
          controllerOver(fake, OperationQueue(InMemoryQueueStorage()));

      await controller.load(
        encounterId: 'enc-1',
        patientId: 'p1',
        facilityId: 'f1',
        from: _now.subtract(const Duration(hours: 1)),
        to: _now.add(const Duration(hours: 1)),
      );

      final dose = controller.view!.doses.single;
      expect(dose.medication, 'Paracetamol');
      expect(dose.doseLabel, '500 mg');
      expect(dose.overdue, isTrue);
      expect(controller.view!.policy.barcodeRequired, isTrue);
    });

    test('a round that arrives with no policy gets the strict one', () async {
      final fake = FakeHttp((_) => http.Response.bytes(
            GetMedicationRoundResponse(doses: round().doses).writeToBuffer(),
            200,
          ));
      final controller =
          controllerOver(fake, OperationQueue(InMemoryQueueStorage()));

      await controller.load(
        encounterId: 'enc-1',
        patientId: 'p1',
        facilityId: 'f1',
        from: _now,
        to: _now,
      );

      expect(controller.view!.policy.barcodeRequired, isTrue);
      expect(controller.view!.policy.overrideAllowed, isFalse);
    });

    test('an unscanned dose is refused before anything is sent', () async {
      final fake = FakeHttp(
          (_) => http.Response.bytes(round().writeToBuffer(), 200));
      final controller =
          controllerOver(fake, OperationQueue(InMemoryQueueStorage()));
      await controller.load(
          encounterId: 'e', patientId: 'p', facilityId: 'f', from: _now, to: _now);

      final decision = await controller.record(
        dose: controller.view!.doses.single,
        facilityId: 'f1',
        outcome: AdministrationOutcome.administered,
        scan: const Scan(),
      );

      expect(decision.allowed, isFalse);
      expect(decision.refusals, contains(Refusal.patientNotScanned));
      // Nothing left the device.
      expect(fake.requests.where((r) => r.url.path.endsWith('Administer')),
          isEmpty);
    });

    test('a scanned dose is sent and confirmed', () async {
      final fake = FakeHttp((request) {
        if (request.url.path.endsWith('Administer')) {
          return http.Response.bytes(AdministerResponse().writeToBuffer(), 200);
        }
        return http.Response.bytes(round().writeToBuffer(), 200);
      });
      final controller =
          controllerOver(fake, OperationQueue(InMemoryQueueStorage()));
      await controller.load(
          encounterId: 'e', patientId: 'p', facilityId: 'f', from: _now, to: _now);

      Submission? settled;
      final decision = await controller.record(
        dose: controller.view!.doses.single,
        facilityId: 'f1',
        outcome: AdministrationOutcome.administered,
        scan: const Scan(patient: 'band', medication: 'pack'),
        givenValue: 500,
        givenUnit: 'mg',
        route: 'oral',
        onSettled: (s) => settled = s,
      );

      expect(decision.allowed, isTrue);
      expect(settled?.state, SubmissionState.confirmed);
      expect(controller.view!.submissions['order-1']!.settled, isTrue);

      final sent = AdministerRequest.fromBuffer(fake.requests
          .firstWhere((r) => r.url.path.endsWith('Administer'))
          .bodyBytes);
      expect(sent.outcome,
          wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_ADMINISTERED);
      expect(sent.verification.performed, isTrue);
      expect(sent.offline, isFalse);
    });

    test('a dose given out of coverage is queued and shown as queued', () async {
      final fake = FakeHttp((request) {
        if (request.url.path.endsWith('Administer')) return offline(request);
        return http.Response.bytes(round().writeToBuffer(), 200);
      });
      final queue = OperationQueue(InMemoryQueueStorage());
      final controller = controllerOver(fake, queue);
      await controller.load(
          encounterId: 'e', patientId: 'p', facilityId: 'f', from: _now, to: _now);

      await controller.record(
        dose: controller.view!.doses.single,
        facilityId: 'f1',
        outcome: AdministrationOutcome.administered,
        scan: const Scan(patient: 'band', medication: 'pack'),
      );

      final submission = controller.view!.submissions['order-1']!;
      expect(submission.state, SubmissionState.queued);
      // Never shown as given.
      expect(submission.settled, isFalse);

      final queued = (await queue.pending()).single;
      expect(queued.type, administrationOperationType);
      expect(queued.payload['given_at'], _now.toIso8601String());
    });

    test('an outcome this build does not know is never read as given', () async {
      final fake = FakeHttp((_) => http.Response.bytes(
            GetMedicationRoundResponse(doses: [
              DueDose(
                order: MedicationOrder(orderId: 'order-1'),
                scheduledAt: at(Duration.zero),
                outstanding: false,
                given: Administration(
                  outcome: wire
                      .AdministrationOutcome.ADMINISTRATION_OUTCOME_UNSPECIFIED,
                ),
              ),
            ]).writeToBuffer(),
            200,
          ));
      final controller =
          controllerOver(fake, OperationQueue(InMemoryQueueStorage()));

      await controller.load(
          encounterId: 'e', patientId: 'p', facilityId: 'f', from: _now, to: _now);

      final dose = controller.view!.doses.single;
      expect(dose.recordedOutcome, AdministrationOutcome.unspecified);
      expect(wasGiven(dose.recordedOutcome!), isFalse);
    });
  });
}
