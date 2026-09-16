/// Search before create (UX-W1-01, SRS-EMPI-003, SRS-EMPI-004).
///
/// The same rule as the web shell's `lib/reception/search.ts`, and the same
/// load-bearing word: a receptionist *cannot* register a second record for
/// somebody already in the index without acknowledging the candidates they
/// were shown. A workflow that merely suggests searching first is a workflow
/// where, on a busy Monday, somebody types a name straight into the form and
/// the index grows a duplicate — and duplicate records are how a clinician
/// reads half a chart and misses an allergy.
///
/// On a tablet the pressure is worse, not better. There is less screen to show
/// candidates on and the device is often held one-handed at a counter with
/// somebody waiting, so the gate is explicit state rather than a layout
/// convention, and the screen has no path around it.
///
/// The server enforces the same rule independently: RegisterPatient refuses a
/// probable duplicate unless the caller lists the ids it has seen. This module
/// is the half that makes the refusal comprehensible rather than surprising —
/// it is not the control.
library;

import 'package:meta/meta.dart';

/// Mirrors empi.v1.MatchOutcome, plus one member the wire does not have.
///
/// [unrecognised] is for an outcome the server sent that this build has no
/// meaning for. It is not a wire value; it is what the mapping produces when
/// the contract has moved on, and it exists because the alternative is worse.
/// See `mapping.dart` for why silence here would open the registration gate on
/// a duplicate.
enum MatchOutcome { distinct, review, probable, conflict, unspecified, unrecognised }

/// What the user typed.
@immutable
class SearchCriteria {
  const SearchCriteria({
    this.name = '',
    this.phone = '',
    this.identifierValue = '',
    this.birthDate = '',
  });

  final String name;
  final String phone;
  final String identifierValue;

  /// ISO yyyy-mm-dd, or '' when not given.
  final String birthDate;
}

/// Why a search cannot run.
enum SearchRefusal {
  /// Nothing was typed.
  noCriteria,

  /// One loose fragment that would match half the index.
  tooBroad,
}

/// Whether a search may run, and what to say when it may not.
@immutable
class SearchValidity {
  const SearchValidity({
    required this.runnable,
    required this.reason,
    required this.message,
  });

  final bool runnable;
  final SearchRefusal? reason;
  final String message;
}

/// Decides whether a search may run.
///
/// A single-letter name fragment is refused rather than sent. It would return
/// the first page of an enormous result set, which looks to the user like "not
/// found on this page" and leads directly to creating a duplicate — the precise
/// failure search-before-create exists to prevent.
SearchValidity validateSearch(SearchCriteria criteria) {
  final name = criteria.name.trim();
  final phone = criteria.phone.trim();
  final identifier = criteria.identifierValue.trim();
  final birthDate = criteria.birthDate.trim();

  if (name.isEmpty && phone.isEmpty && identifier.isEmpty && birthDate.isEmpty) {
    return const SearchValidity(
      runnable: false,
      reason: SearchRefusal.noCriteria,
      message: 'Enter a name, phone number, date of birth or identifier to search.',
    );
  }
  if (identifier.isEmpty && phone.isEmpty && birthDate.isEmpty && name.length < 2) {
    return const SearchValidity(
      runnable: false,
      reason: SearchRefusal.tooBroad,
      message: 'Use at least two letters of the name, or add a date of birth, '
          'phone number or identifier.',
    );
  }
  return const SearchValidity(runnable: true, reason: null, message: '');
}

/// Human label for a match outcome.
///
/// Deliberately sentences rather than "92%". A percentage invites a
/// receptionist to develop a private threshold, and the threshold that matters
/// is the configured one the server applied (SRS-EMPI-004).
String describeOutcome(MatchOutcome outcome) => switch (outcome) {
      MatchOutcome.probable => 'Almost certainly the same person',
      MatchOutcome.review => 'Possibly the same person — check before registering',
      MatchOutcome.conflict => 'Same identifier, different details — needs review',
      MatchOutcome.distinct => 'A different person',
      MatchOutcome.unspecified => 'Match strength not assessed',
      MatchOutcome.unrecognised =>
        'This app cannot read the match result — check before registering',
    };

/// Outcomes that make a new record a probable duplicate.
///
/// [MatchOutcome.unrecognised] is among them deliberately. A verdict this
/// build cannot read is not a verdict that the person is different, and
/// treating it as one would let a newer server's outcome unlock registration
/// on somebody already in the index.
bool _blocks(MatchOutcome outcome) =>
    outcome == MatchOutcome.probable ||
    outcome == MatchOutcome.review ||
    outcome == MatchOutcome.conflict ||
    outcome == MatchOutcome.unrecognised;

/// A result row as the screen shows it.
@immutable
class PresentedMatch {
  const PresentedMatch({
    required this.patientId,
    required this.displayName,
    required this.outcome,
    required this.outcomeLabel,
    required this.confidencePercent,
    required this.matchedFormerName,
    required this.masked,
    required this.blocksRegistration,
  });

  final String patientId;
  final String displayName;
  final MatchOutcome outcome;

  /// "Almost certainly the same person", and so on. Never a bare percentage.
  final String outcomeLabel;

  /// 0…100, for a bar. The label is what a user should read.
  final int confidencePercent;

  /// Set when this patient was reached through a name they no longer hold.
  final String matchedFormerName;

  /// True when field-level access hid something on this row.
  final bool masked;

  /// True when this candidate has to be acknowledged before a new record may
  /// be created for the person being registered.
  final bool blocksRegistration;
}

/// What the screen shows for one candidate.
PresentedMatch presentMatch({
  required String patientId,
  required String displayName,
  required double confidence,
  required MatchOutcome outcome,
  bool masked = false,
  String matchedFormerName = '',
}) =>
    PresentedMatch(
      patientId: patientId,
      displayName: displayName,
      outcome: outcome,
      outcomeLabel: describeOutcome(outcome),
      confidencePercent: (confidence.clamp(0, 1) * 100).round(),
      matchedFormerName: matchedFormerName,
      masked: masked,
      blocksRegistration: _blocks(outcome),
    );

/// Where the receptionist is in search-before-create.
enum GateState {
  /// Nothing searched yet. Registration is not offered at all.
  searchFirst,

  /// Searched, nothing found. Registration is the obvious next step.
  clear,

  /// Searched, candidates found and not yet all rejected.
  reviewCandidates,

  /// Every blocking candidate has been looked at and rejected.
  acknowledged,
}

/// The gate, and what to say at it.
@immutable
class RegistrationGate {
  const RegistrationGate({
    required this.state,
    required this.message,
    this.outstanding = const [],
  });

  final GateState state;
  final String message;

  /// Candidate ids still to be looked at. Empty in every other state.
  final List<String> outstanding;

  /// True when the register action may be enabled.
  bool get mayRegister =>
      state == GateState.clear || state == GateState.acknowledged;
}

/// Decides whether "Register a new patient" may be offered.
///
/// [searched] is separate from "there are no matches" on purpose: both produce
/// an empty candidate list, and they mean opposite things. Before a search, an
/// empty list means nobody has looked.
RegistrationGate registrationGate({
  required bool searched,
  required List<PresentedMatch> matches,
  required List<String> acknowledged,
}) {
  if (!searched) {
    return const RegistrationGate(
      state: GateState.searchFirst,
      message: 'Search for the patient before registering a new record.',
    );
  }

  final blockers = matches.where((m) => m.blocksRegistration).toList();
  if (blockers.isEmpty) {
    return const RegistrationGate(
      state: GateState.clear,
      message: 'No existing record matches. You can register a new patient.',
    );
  }

  final seen = acknowledged.toSet();
  final outstanding = [
    for (final m in blockers)
      if (!seen.contains(m.patientId)) m.patientId,
  ];

  if (outstanding.isNotEmpty) {
    return RegistrationGate(
      state: GateState.reviewCandidates,
      message: outstanding.length == 1
          ? 'One existing record may be this patient. Open it, or confirm it is somebody else.'
          : '${outstanding.length} existing records may be this patient. '
              'Open them, or confirm each is somebody else.',
      outstanding: outstanding,
    );
  }

  return const RegistrationGate(
    state: GateState.acknowledged,
    message: 'You have confirmed the existing records are different people. '
        'Registering will create a new record.',
  );
}
