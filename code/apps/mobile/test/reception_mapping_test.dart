import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/gen/healthcare/empi/v1/patient.pb.dart' as empi;
import 'package:health_mobile/src/gen/healthcare/scheduling/v1/appointment.pb.dart'
    as sched;
import 'package:health_mobile/src/reception/board.dart';
import 'package:health_mobile/src/reception/mapping.dart';
import 'package:health_mobile/src/reception/search.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

/// Appends a varint field to an encoded message, the way a newer server would.
///
/// This is the whole point of the enum tests: a value from a contract this
/// build predates cannot be constructed through the generated API — `valueOf`
/// returns null for a tag it does not know — so it has to arrive the way it
/// really would, on the wire.
List<int> withVarintField(List<int> encoded, int tag, int value) {
  final out = [...encoded];
  // The key is itself a varint, not a byte: tag 23 becomes 184, which does not
  // fit in one. Getting this wrong produces a truncated-message parse error
  // rather than a wrong answer, which is at least loud.
  _varint(out, (tag << 3) | 0); // wire type 0
  _varint(out, value);
  return out;
}

void _varint(List<int> out, int value) {
  var v = value;
  while (v >= 0x80) {
    out.add((v & 0x7f) | 0x80);
    v >>= 7;
  }
  out.add(v);
}

void main() {
  group('an enum from a newer contract', () {
    test('protobuf hides it as the zero member, which is why this check exists', () {
      // The measurement the mapping's design rests on. If this ever stops
      // being true, the mapping's unknownFields check is the wrong mechanism
      // and this test is where that gets noticed.
      final bytes = withVarintField(
        empi.PatientMatch(patient: empi.Patient(patientId: 'p1')).writeToBuffer(),
        matchOutcomeField,
        9999,
      );
      final decoded = empi.PatientMatch.fromBuffer(bytes);
      expect(decoded.outcome, empi.MatchOutcome.MATCH_OUTCOME_UNSPECIFIED);
      expect(decoded.unknownFields.hasField(matchOutcomeField), isTrue);
    });

    test('an unreadable match outcome is unrecognised, not "not assessed"', () {
      final bytes = withVarintField(
        empi.PatientMatch(patient: empi.Patient(patientId: 'p1')).writeToBuffer(),
        matchOutcomeField,
        9999,
      );
      expect(matchOutcomeOf(empi.PatientMatch.fromBuffer(bytes)),
          MatchOutcome.unrecognised);
    });

    test('an unreadable match outcome blocks registration', () {
      // The reason the whole mechanism exists. Were this to read as
      // "unspecified", a newer server's verdict would unlock the create
      // button on somebody already in the index.
      final bytes = withVarintField(
        empi.PatientMatch(patient: empi.Patient(patientId: 'p1')).writeToBuffer(),
        matchOutcomeField,
        9999,
      );
      final candidate = matchOf(empi.PatientMatch.fromBuffer(bytes));
      expect(candidate.blocksRegistration, isTrue);

      final gate = registrationGate(
        searched: true, matches: [candidate], acknowledged: [],
      );
      expect(gate.mayRegister, isFalse);
      expect(gate.state, GateState.reviewCandidates);
    });

    test('its label says the app is behind rather than stating a verdict', () {
      expect(describeOutcome(MatchOutcome.unrecognised), contains('cannot read'));
      expect(describeOutcome(MatchOutcome.unrecognised),
          isNot(contains('different person')));
    });

    test('a genuinely unspecified outcome is still just unspecified', () {
      // The control: without the unknown tag, nothing is unrecognised.
      final wire = empi.PatientMatch(
        patient: empi.Patient(patientId: 'p1'),
        outcome: empi.MatchOutcome.MATCH_OUTCOME_UNSPECIFIED,
      );
      expect(matchOutcomeOf(wire), MatchOutcome.unspecified);
      expect(matchOf(wire).blocksRegistration, isFalse);
    });

    test('an unreadable appointment status offers no check-in', () {
      final bytes = withVarintField(
        sched.Appointment(
          appointmentId: 'a1',
          startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
        ).writeToBuffer(),
        appointmentStatusField,
        9999,
      );
      final appointment = appointmentOf(sched.Appointment.fromBuffer(bytes));
      expect(appointment.status, QueueStatus.unrecognised);

      final board = buildBoard(
        positions: [],
        expected: [appointment],
        fetchedAt: DateTime.utc(2026, 9, 16, 9),
        now: DateTime.utc(2026, 9, 16, 9),
      );
      expect(board.rows.single.canCheckIn, isFalse);
      expect(board.rows.single.statusLabel, contains('not recognised'));
    });

    test('an unreadable priority is ranked with standard, not invented', () {
      // Sorting it to the top invents urgency; sorting it to the bottom buries
      // it. The label is the part that helps.
      final bytes = withVarintField(
        sched.Appointment(
          appointmentId: 'a1',
          status: sched.AppointmentStatus.APPOINTMENT_STATUS_SCHEDULED,
          startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
        ).writeToBuffer(),
        priorityField,
        9999,
      );
      final appointment = appointmentOf(sched.Appointment.fromBuffer(bytes));
      expect(appointment.priority, QueuePriority.unrecognised);
      expect(describeQueuePriority(QueuePriority.unrecognised),
          contains('not recognised'));
    });

    test('one unreadable row does not cost the whole board', () {
      // Refusing the response would be defensible and is the wrong trade: a
      // receptionist with a queue in front of them will find another way.
      final unreadable = sched.Appointment.fromBuffer(withVarintField(
        sched.Appointment(
          appointmentId: 'bad',
          startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
        ).writeToBuffer(),
        appointmentStatusField,
        9999,
      ));
      final fine = sched.Appointment(
        appointmentId: 'good',
        status: sched.AppointmentStatus.APPOINTMENT_STATUS_SCHEDULED,
        startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 10)),
      );
      final board = buildBoard(
        positions: [],
        expected: [appointmentOf(unreadable), appointmentOf(fine)],
        fetchedAt: DateTime.utc(2026, 9, 16, 9),
        now: DateTime.utc(2026, 9, 16, 9),
      );
      expect(board.rows, hasLength(2));
      expect(board.rows.map((r) => r.appointmentId), containsAll(['bad', 'good']));
    });

    test('the field tags are the ones the contract actually uses', () {
      // The tag number is the entire check; reading the wrong one would
      // silently stop detecting anything, and every test above would still
      // pass because it writes to the same wrong number.
      expect(empi.PatientMatch.getDefault().info_.byName['outcome']!.tagNumber,
          matchOutcomeField);
      final appointment = sched.Appointment.getDefault().info_;
      expect(appointment.byName['status']!.tagNumber, appointmentStatusField);
      expect(appointment.byName['priority']!.tagNumber, priorityField);
      expect(appointment.byName['arrivalMode']!.tagNumber, arrivalModeField);
    });
  });

  group('appointments', () {
    test('a patient who has not checked in has no arrival time', () {
      // Not the epoch: the epoch is a real instant, and a wrong clock has to
      // stay distinguishable from an absent one.
      final wire = sched.Appointment(
        appointmentId: 'a1',
        patientId: 'p1',
        token: 'A7',
        status: sched.AppointmentStatus.APPOINTMENT_STATUS_SCHEDULED,
        startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
      );
      expect(appointmentOf(wire).checkedInAt, isNull);
    });

    test('an arrival time that was sent is carried through in UTC', () {
      final arrived = DateTime.utc(2026, 9, 16, 9, 42);
      final mapped = appointmentOf(sched.Appointment(
        appointmentId: 'a1',
        status: sched.AppointmentStatus.APPOINTMENT_STATUS_ARRIVED,
        startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
        checkedInAt: Timestamp.fromDateTime(arrived),
      ));
      expect(mapped.checkedInAt, arrived);
      expect(mapped.checkedInAt!.isUtc, isTrue);
    });

    test('an unspecified priority is standard, because the proto says so', () {
      final mapped = appointmentOf(sched.Appointment(
        appointmentId: 'a1',
        status: sched.AppointmentStatus.APPOINTMENT_STATUS_SCHEDULED,
        startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
      ));
      expect(mapped.priority, QueuePriority.standard);
    });

    test('every status the contract defines maps to something usable', () {
      for (final status in sched.AppointmentStatus.values) {
        final mapped = queueStatusOf(sched.Appointment(
          appointmentId: 'a1',
          status: status,
          startsAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
        ));
        if (status == sched.AppointmentStatus.APPOINTMENT_STATUS_UNSPECIFIED) {
          // An appointment with no status is not a state the board can act on.
          expect(mapped, QueueStatus.unrecognised);
        } else {
          expect(mapped, isNot(QueueStatus.unrecognised),
              reason: 'no mapping for ${status.name}');
        }
      }
    });
  });

  group('search candidates', () {
    empi.PatientMatch match({
      String family = 'Sharma',
      List<String> given = const ['Anita'],
      double confidence = 0.9,
      empi.MatchOutcome outcome = empi.MatchOutcome.MATCH_OUTCOME_PROBABLE,
      bool masked = false,
      empi.PatientName? formerName,
    }) =>
        empi.PatientMatch(
          patient: empi.Patient(
            patientId: 'p1',
            demographics: empi.Demographics(
              name: empi.HumanName(family: family, given: given),
            ),
          ),
          confidence: confidence,
          outcome: outcome,
          masked: masked,
          matchedFormerName: formerName,
        );

    test('a name is assembled given-then-family', () {
      expect(matchOf(match()).displayName, 'Anita Sharma');
    });

    test('a record with no name says so rather than rendering a blank row', () {
      expect(matchOf(match(family: '', given: [])).displayName,
          'Name not available');
    });

    test('a masked row is marked, not hidden', () {
      expect(matchOf(match(masked: true)).masked, isTrue);
    });

    test('no former name means no former name, not a placeholder', () {
      expect(matchOf(match()).matchedFormerName, '');
    });

    test('a former name is carried so the row can explain the match', () {
      expect(
        matchOf(match(
          formerName: empi.PatientName(
            name: empi.HumanName(family: 'Gupta', given: ['Anita']),
          ),
        )).matchedFormerName,
        'Anita Gupta',
      );
    });

    test('a distinct candidate does not block, a probable one does', () {
      expect(matchOf(match()).blocksRegistration, isTrue);
      expect(
        matchOf(match(outcome: empi.MatchOutcome.MATCH_OUTCOME_DISTINCT))
            .blocksRegistration,
        isFalse,
      );
    });
  });
}
