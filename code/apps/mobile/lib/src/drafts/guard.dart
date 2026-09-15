/// Unsaved clinical work, and what happens when the user leaves it
/// (SRS-WEB-012, applied to mobile).
///
/// The requirement is an "unsaved clinical draft warning on navigation/patient
/// switch". On a phone that is a wider surface than in a browser, and the extra
/// exits are the dangerous ones: a browser tab is closed deliberately, whereas
/// a phone is backgrounded by a call, a notification, or a screen lock every
/// few minutes, and the operating system may kill the process afterwards
/// without ever returning to the app.
///
/// So this has two halves that the web equivalent does not need to separate.
///
/// A *navigation* away from a draft is a decision the user is making now, and
/// it is met with a prompt — or, for a patient switch, refused outright,
/// because the hazard there is that the user believes they are somewhere else
/// and a prompt arrives after they have stopped thinking about it.
///
/// A *backgrounding* is not a decision at all. Prompting is impossible and
/// warning is useless, so the guard's answer is to say the draft must be
/// persisted before the process can be killed. Nothing here does the
/// persisting; it reports what the caller owes.
library;

import 'package:meta/meta.dart';

/// What should happen to a draft when its screen is left.
enum DraftPolicy {
  /// Leave without asking. Search boxes, filters, anything re-derivable.
  discardSilently,

  /// Ask, and let the user discard. Notes, forms, most clinical drafts.
  confirm,

  /// Ask, and refuse a patient switch outright. For drafts where saving
  /// against the wrong chart is the hazard — an order being signed, a
  /// medication being administered.
  blockPatientSwitch,
}

/// A piece of in-progress work the user has not committed.
@immutable
class Draft {
  const Draft({
    required this.id,
    required this.description,
    required this.policy,
    required this.patientRef,
    required this.dirty,
  });

  final String id;

  /// Shown to the user: "progress note", "medication administration".
  final String description;

  final DraftPolicy policy;

  /// The patient the draft belongs to, when it belongs to one.
  final String? patientRef;

  /// False once the user has saved; a clean draft never prompts.
  final bool dirty;

  Draft copyWith({bool? dirty}) => Draft(
        id: id,
        description: description,
        policy: policy,
        patientRef: patientRef,
        dirty: dirty ?? this.dirty,
      );
}

/// What the user is trying to do.
sealed class Navigation {
  const Navigation();
}

/// Moving to another screen within the same patient's context.
class RouteChange extends Navigation {
  const RouteChange(this.to);
  final String to;
}

/// Opening a different patient's chart.
class PatientSwitch extends Navigation {
  const PatientSwitch(this.toPatientRef);
  final String toPatientRef;
}

/// Signing out, which discards the session the drafts belong to.
class SignOut extends Navigation {
  const SignOut();
}

/// The app going to the background — a call, a notification, a screen lock.
///
/// Its own case because it is not a decision the user made and cannot be
/// prompted about. The operating system may kill the process before the app is
/// ever resumed.
class Backgrounded extends Navigation {
  const Backgrounded();
}

/// Stable reason codes. The UI localises from these rather than from prose.
const String reasonClean = 'NO_UNSAVED_WORK';
const String reasonConfirm = 'UNSAVED_DRAFTS';
const String reasonWrongChart = 'DRAFT_BELONGS_TO_ANOTHER_PATIENT';
const String reasonMustPersist = 'UNSAVED_DRAFTS_MUST_BE_PERSISTED';

/// What the guard decided.
@immutable
class GuardDecision {
  const GuardDecision({
    required this.allow,
    required this.prompt,
    required this.blocked,
    required this.mustPersist,
    required this.drafts,
    required this.reason,
  });

  /// True when the navigation may proceed with no interruption.
  final bool allow;

  /// True when the user must be asked.
  final bool prompt;

  /// True when the navigation is refused outright and no prompt will help.
  final bool blocked;

  /// True when the caller must write the drafts to durable storage before
  /// giving up control. Set for a backgrounding, where prompting is impossible.
  final bool mustPersist;

  /// The drafts that caused the decision, for the message.
  final List<Draft> drafts;

  final String reason;
}

const _clean = GuardDecision(
  allow: true,
  prompt: false,
  blocked: false,
  mustPersist: false,
  drafts: [],
  reason: reasonClean,
);

/// Decides whether a navigation may proceed.
///
/// Pure, so the policy is testable without pumping a widget tree or faking a
/// lifecycle event — which is the part of this that is otherwise untestable
/// and therefore the part that quietly stops working.
GuardDecision evaluate(List<Draft> drafts, Navigation navigation) {
  final dirty = drafts
      .where((d) => d.dirty && d.policy != DraftPolicy.discardSilently)
      .toList(growable: false);

  if (dirty.isEmpty) {
    return _clean;
  }

  switch (navigation) {
    case Backgrounded():
      // Not a decision the user made, so there is nobody to ask. The answer is
      // that the work has to survive the process being killed.
      return GuardDecision(
        allow: true,
        prompt: false,
        blocked: false,
        mustPersist: true,
        drafts: dirty,
        reason: reasonMustPersist,
      );

    case PatientSwitch(:final toPatientRef):
      final wrongChart = dirty
          .where((d) =>
              d.policy == DraftPolicy.blockPatientSwitch &&
              d.patientRef != null &&
              d.patientRef != toPatientRef)
          .toList(growable: false);
      if (wrongChart.isNotEmpty) {
        // Refused rather than prompted. The hazard is that the user believes
        // they are on a different chart, and a prompt arrives after they have
        // stopped thinking about which one.
        return GuardDecision(
          allow: false,
          prompt: false,
          blocked: true,
          mustPersist: false,
          drafts: wrongChart,
          reason: reasonWrongChart,
        );
      }
      return GuardDecision(
        allow: false,
        prompt: true,
        blocked: false,
        mustPersist: false,
        drafts: dirty,
        reason: reasonConfirm,
      );

    case RouteChange():
    case SignOut():
      return GuardDecision(
        allow: false,
        prompt: true,
        blocked: false,
        mustPersist: false,
        drafts: dirty,
        reason: reasonConfirm,
      );
  }
}

/// A sentence for the prompt or the blocking message.
String describe(GuardDecision decision) {
  if (decision.allow && !decision.mustPersist) {
    return '';
  }
  final names = decision.drafts.map((d) => d.description).join(', ');

  if (decision.blocked) {
    final chart = decision.drafts
        .map((d) => d.patientRef)
        .whereType<String>()
        .toSet()
        .join(', ');
    return 'You have unsaved work on another patient ($names). '
        'Finish or discard it before opening a different chart. '
        'It belongs to $chart.';
  }
  if (decision.mustPersist) {
    return 'Unsaved work ($names) was saved to this device so it survives '
        'the app closing.';
  }
  return 'You have unsaved work: $names. Leave and discard it?';
}

/// Tracks the drafts currently open in the app.
///
/// A registry rather than each screen wiring its own lifecycle observer:
/// observers registered per screen are removed inconsistently, and the ones
/// that leak keep prompting after their screen is gone.
class DraftRegistry {
  final Map<String, Draft> _drafts = <String, Draft>{};
  final Set<void Function(List<Draft>)> _subscribers = {};

  void register(Draft draft) {
    _drafts[draft.id] = draft;
    _notify();
  }

  /// Marks a draft clean or dirty without re-registering it.
  void setDirty(String id, {required bool dirty}) {
    final existing = _drafts[id];
    if (existing == null) return;
    _drafts[id] = existing.copyWith(dirty: dirty);
    _notify();
  }

  /// Removes a draft — after a save, or after the user discarded it.
  void release(String id) {
    if (_drafts.remove(id) != null) _notify();
  }

  List<Draft> get open => _drafts.values.toList(growable: false);

  GuardDecision evaluateNavigation(Navigation navigation) =>
      evaluate(open, navigation);

  void Function() subscribe(void Function(List<Draft>) run) {
    _subscribers.add(run);
    run(open);
    return () => _subscribers.remove(run);
  }

  void _notify() {
    final snapshot = open;
    for (final run in _subscribers.toList(growable: false)) {
      run(snapshot);
    }
  }
}
