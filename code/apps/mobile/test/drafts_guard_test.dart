import 'package:flutter_test/flutter_test.dart';

import 'package:health_mobile/src/drafts/guard.dart';

Draft draft({
  String id = 'note-1',
  String description = 'progress note',
  DraftPolicy policy = DraftPolicy.confirm,
  String? patientRef = 'pat-1',
  bool dirty = true,
}) =>
    Draft(
      id: id,
      description: description,
      policy: policy,
      patientRef: patientRef,
      dirty: dirty,
    );

void main() {
  group('nothing to lose', () {
    test('lets every navigation through when no draft is dirty', () {
      final clean = [draft(dirty: false)];
      for (final navigation in <Navigation>[
        const RouteChange('/ward'),
        const PatientSwitch('pat-2'),
        const SignOut(),
        const Backgrounded(),
      ]) {
        final decision = evaluate(clean, navigation);
        expect(decision.allow, isTrue, reason: navigation.runtimeType.toString());
        expect(decision.prompt, isFalse);
        expect(decision.mustPersist, isFalse);
        expect(decision.reason, reasonClean);
      }
    });

    test('ignores drafts that are meant to be discarded silently', () {
      // A search box is not clinical work, and prompting about one trains the
      // user to dismiss the prompt that matters.
      final filters = [draft(policy: DraftPolicy.discardSilently)];
      expect(evaluate(filters, const RouteChange('/ward')).allow, isTrue);
    });
  });

  group('leaving a screen', () {
    test('prompts on an ordinary route change', () {
      final decision = evaluate([draft()], const RouteChange('/ward'));
      expect(decision.allow, isFalse);
      expect(decision.prompt, isTrue);
      expect(decision.blocked, isFalse);
      expect(decision.reason, reasonConfirm);
      expect(describe(decision), contains('progress note'));
    });

    test('prompts on sign-out, which discards the session the drafts belong to', () {
      expect(evaluate([draft()], const SignOut()).prompt, isTrue);
    });
  });

  group('switching patient', () {
    test('refuses outright when the draft belongs to another chart', () {
      // The hazard is that the user believes they are on a different chart,
      // and a prompt arrives after they have stopped thinking about which one.
      final decision = evaluate(
        [draft(policy: DraftPolicy.blockPatientSwitch, patientRef: 'pat-1')],
        const PatientSwitch('pat-2'),
      );
      expect(decision.blocked, isTrue);
      expect(decision.prompt, isFalse);
      expect(decision.allow, isFalse);
      expect(decision.reason, reasonWrongChart);
      expect(describe(decision), contains('pat-1'));
    });

    test('only prompts when the draft belongs to the chart being opened', () {
      // Returning to the chart the draft is on is not a wrong-patient hazard.
      final decision = evaluate(
        [draft(policy: DraftPolicy.blockPatientSwitch, patientRef: 'pat-2')],
        const PatientSwitch('pat-2'),
      );
      expect(decision.blocked, isFalse);
      expect(decision.prompt, isTrue);
    });

    test('prompts rather than blocks for a draft that is not chart-bound', () {
      final decision = evaluate(
        [draft(policy: DraftPolicy.confirm, patientRef: 'pat-1')],
        const PatientSwitch('pat-2'),
      );
      expect(decision.blocked, isFalse);
      expect(decision.prompt, isTrue);
    });

    test('does not block a draft with no patient attached', () {
      final decision = evaluate(
        [draft(policy: DraftPolicy.blockPatientSwitch, patientRef: null)],
        const PatientSwitch('pat-2'),
      );
      expect(decision.blocked, isFalse);
    });
  });

  group('the app going to the background', () {
    test('is not prompted about, and requires the work to be persisted', () {
      // A phone is backgrounded by a call or a screen lock every few minutes,
      // and the operating system may kill the process without ever returning
      // to the app. There is nobody to ask.
      final decision = evaluate([draft()], const Backgrounded());
      expect(decision.prompt, isFalse);
      expect(decision.blocked, isFalse);
      expect(decision.allow, isTrue);
      expect(decision.mustPersist, isTrue);
      expect(decision.reason, reasonMustPersist);
      expect(describe(decision), contains('saved to this device'));
    });

    test('requires nothing when there is no unsaved work', () {
      expect(evaluate([draft(dirty: false)], const Backgrounded()).mustPersist, isFalse);
    });

    test('names every dirty draft, so nothing is silently dropped', () {
      final decision = evaluate(
        [
          draft(id: 'a', description: 'progress note'),
          draft(id: 'b', description: 'medication administration'),
        ],
        const Backgrounded(),
      );
      expect(decision.drafts, hasLength(2));
      expect(describe(decision), contains('progress note'));
      expect(describe(decision), contains('medication administration'));
    });
  });

  group('the registry', () {
    test('tracks, cleans and releases drafts', () {
      final registry = DraftRegistry()..register(draft());
      expect(registry.evaluateNavigation(const RouteChange('/x')).prompt, isTrue);

      registry.setDirty('note-1', dirty: false);
      expect(registry.evaluateNavigation(const RouteChange('/x')).allow, isTrue);

      registry.setDirty('note-1', dirty: true);
      registry.release('note-1');
      expect(registry.open, isEmpty);
      expect(registry.evaluateNavigation(const RouteChange('/x')).allow, isTrue);
    });

    test('ignores a dirty flag for a draft it does not hold', () {
      final registry = DraftRegistry()..setDirty('ghost', dirty: true);
      expect(registry.open, isEmpty);
    });

    test('notifies subscribers and stops after unsubscribe', () {
      final registry = DraftRegistry();
      var notifications = 0;
      final unsubscribe = registry.subscribe((_) => notifications++);
      expect(notifications, 1, reason: 'subscribe delivers the current state');

      registry.register(draft());
      expect(notifications, 2);

      unsubscribe();
      registry.release('note-1');
      expect(notifications, 2);
    });
  });
}
