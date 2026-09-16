/// The reception desk (UX-W1-01).
///
/// Two things on one screen, in the order the desk works: the board of who is
/// here and who is coming, and — behind a deliberate gate — searching for a
/// patient before registering a new one.
///
/// Registration is not its own route, on this shell for the same reason as on
/// the web plus one more. On the web the argument is that `/reception/register`
/// is a URL and a URL can be typed. Here there are no URLs, but there is a
/// back button and a drawer, and a registration form reachable from either
/// would be a registration form reachable without a search. So the form lives
/// inside the search view and is built from its gate.
///
/// The reasoning is in `reception/search.dart` and `reception/board.dart`;
/// this renders it.
library;

import 'package:flutter/material.dart';

import '../reception/board.dart';
import '../reception/search.dart';
import '../ui/states.dart';

/// Everything the reception screen renders.
class ReceptionView {
  const ReceptionView({
    required this.board,
    this.matches = const [],
    this.acknowledged = const [],
    this.searched = false,
    this.searchProblem = '',
  });

  final Board board;

  /// Candidates from the last search.
  final List<PresentedMatch> matches;

  /// Candidate ids the user has said are somebody else.
  final List<String> acknowledged;

  /// Whether a search has been run. Distinguishes "nobody matched" from
  /// "nobody looked", which produce the same empty list and mean the opposite.
  final bool searched;

  /// Why the last search could not run, if it could not.
  final String searchProblem;

  /// The gate, derived rather than stored: a stored gate is one that can be
  /// left behind by a new search.
  RegistrationGate get gate => registrationGate(
        searched: searched,
        matches: matches,
        acknowledged: acknowledged,
      );
}

class ReceptionScreen extends StatefulWidget {
  const ReceptionScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onCheckIn,
    this.onSearch,
    this.onOpenCandidate,
    this.onAcknowledge,
    this.onRegister,
  });

  final ReceptionView? view;
  final bool loading;
  final String? failure;
  final VoidCallback? onRetry;

  final void Function(BoardRow row)? onCheckIn;
  final void Function(SearchCriteria criteria)? onSearch;
  final void Function(PresentedMatch match)? onOpenCandidate;
  final void Function(PresentedMatch match)? onAcknowledge;

  /// Offered only when the gate allows it. The screen asks; the server decides.
  final VoidCallback? onRegister;

  @override
  State<ReceptionScreen> createState() => _ReceptionScreenState();
}

class _ReceptionScreenState extends State<ReceptionScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _identifier = TextEditingController();
  final _birthDate = TextEditingController();
  bool _searchMode = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _identifier.dispose();
    _birthDate.dispose();
    super.dispose();
  }

  SearchCriteria get _criteria => SearchCriteria(
        name: _name.text,
        phone: _phone.text,
        identifierValue: _identifier.text,
        birthDate: _birthDate.text,
      );

  @override
  Widget build(BuildContext context) {
    final view = widget.view;

    if (widget.loading && view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading the board…',
        ),
      );
    }
    if (widget.failure != null && view == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.failure,
          title: widget.failure!,
          onRetry: widget.onRetry,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _modeBar(),
        if (widget.failure != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: ScreenState(
              kind: ScreenStateKind.failure,
              title: widget.failure!,
              onRetry: widget.onRetry,
            ),
          ),
        Expanded(
          child: _searchMode ? _search(view) : _board(view),
        ),
      ],
    );
  }

  Widget _modeBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: const Color(0xFFF1F4F9),
        child: Row(
          children: [
            Expanded(
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('Board'),
                    icon: Icon(Icons.list_alt),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('Find a patient'),
                    icon: Icon(Icons.search),
                  ),
                ],
                selected: {_searchMode},
                onSelectionChanged: (selected) =>
                    setState(() => _searchMode = selected.first),
              ),
            ),
          ],
        ),
      );

  // ---------------------------------------------------------------- the board

  Widget _board(ReceptionView? view) {
    if (view == null) {
      return const SizedBox.shrink();
    }
    final board = view.board;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _summary(board),
        if (board.empty)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: ScreenState(
              kind: ScreenStateKind.empty,
              title: 'Nobody is waiting and nobody is expected.',
            ),
          ),
        for (final row in board.rows) _row(row),
      ],
    );
  }

  Widget _summary(Board board) {
    // The staleness line is a sentence rather than a colour, because it is
    // read aloud to a patient: "about twenty minutes" said from a five-minute
    // old snapshot is a promise the clinic did not make.
    final parts = <String>[
      board.waiting == 1 ? '1 person waiting' : '${board.waiting} people waiting',
      if (board.serviceMinutes != null)
        board.estimateObserved
            ? 'about ${board.serviceMinutes} minutes each, measured today'
            : 'about ${board.serviceMinutes} minutes each, from the roster',
      if (board.activeClinicians > 0)
        board.activeClinicians == 1
            ? '1 clinician working'
            : '${board.activeClinicians} clinicians working',
    ];

    return Semantics(
      container: true,
      liveRegion: true,
      child: Card(
        color: board.stale ? const Color(0xFFFFF4E5) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(parts.join(' · '),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                board.stale
                    ? 'This board is ${board.ageSeconds} seconds old. '
                        'Refresh before quoting a waiting time.'
                    : 'Updated just now.',
                key: const Key('board-freshness'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BoardRow row) {
    final detail = <String>[
      row.statusLabel,
      if (row.position != null) 'position ${row.position}',
      if (row.waitedMinutes != null) 'waiting ${row.waitedMinutes} min',
      if (row.estimatedWaitMinutes != null)
        'about ${row.estimatedWaitMinutes} min to go',
    ].join(' · ');

    return Card(
      key: Key('board-row-${row.appointmentId}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // The token, not the name. This screen is held up at a desk a
                // waiting room can see.
                Text(row.token.isEmpty ? '—' : row.token,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(width: 12),
                Expanded(child: Text(describeQueuePriority(row.priority))),
              ],
            ),
            const SizedBox(height: 4),
            Text(detail),
            if (row.priorityReason.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                // Never hidden: SRS-SCH-011 requires the reason somebody was
                // moved up the queue to stay visible.
                child: Text('Raised: ${row.priorityReason}'),
              ),
            if (row.canCheckIn)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: Key('check-in-${row.appointmentId}'),
                  onPressed: () => widget.onCheckIn?.call(row),
                  child: const Text('Check in'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------- the search

  Widget _search(ReceptionView? view) {
    final gate = view?.gate ??
        registrationGate(searched: false, matches: [], acknowledged: []);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        TextField(
          key: const Key('search-name'),
          controller: _name,
          decoration: const InputDecoration(
            labelText: 'Name', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('search-birth-date'),
          controller: _birthDate,
          decoration: const InputDecoration(
            labelText: 'Date of birth (yyyy-mm-dd)',
            border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('search-phone'),
          controller: _phone,
          decoration: const InputDecoration(
            labelText: 'Phone', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('search-identifier'),
          controller: _identifier,
          decoration: const InputDecoration(
            labelText: 'Identifier', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        FilledButton(
          key: const Key('run-search'),
          onPressed: () => widget.onSearch?.call(_criteria),
          child: const Text('Search'),
        ),
        if (view != null && view.searchProblem.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ScreenState(
              kind: ScreenStateKind.failure,
              title: view.searchProblem,
            ),
          ),
        const SizedBox(height: 16),
        for (final match in view?.matches ?? const <PresentedMatch>[])
          _candidate(match, view!.acknowledged.contains(match.patientId)),
        const SizedBox(height: 16),
        _gate(gate),
      ],
    );
  }

  Widget _candidate(PresentedMatch match, bool acknowledged) => Card(
        key: Key('candidate-${match.patientId}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(match.displayName,
                  style: Theme.of(context).textTheme.titleMedium),
              // The sentence, not the percentage. The bar is decoration beside
              // it, never the thing that is read.
              Text(match.outcomeLabel),
              if (match.matchedFormerName.isNotEmpty)
                Text('Previously known as ${match.matchedFormerName}'),
              if (match.masked)
                const Text('Some details are hidden by your access level.'),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    key: Key('open-${match.patientId}'),
                    onPressed: () => widget.onOpenCandidate?.call(match),
                    child: const Text('Open this record'),
                  ),
                  if (match.blocksRegistration)
                    TextButton(
                      key: Key('acknowledge-${match.patientId}'),
                      onPressed: acknowledged
                          ? null
                          : () => widget.onAcknowledge?.call(match),
                      child: Text(acknowledged
                          ? 'Confirmed a different person'
                          : 'This is somebody else'),
                    ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _gate(RegistrationGate gate) => Semantics(
        container: true,
        liveRegion: true,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(gate.message, key: const Key('gate-message')),
                const SizedBox(height: 8),
                // Absent rather than disabled until the gate opens. A disabled
                // button invites hunting for the permission that would enable
                // it; the truth is that the work has not been done yet, and
                // the message above says what the work is.
                if (gate.mayRegister)
                  FilledButton(
                    key: const Key('register-patient'),
                    onPressed: widget.onRegister,
                    child: const Text('Register a new patient'),
                  ),
              ],
            ),
          ),
        ),
      );
}
