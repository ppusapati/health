/// The chart (UX-W1-02).
///
/// What a clinician reads at a bedside: the safety panels first, then the
/// notes. That order is the argument for the screen existing at all — on a
/// phone the top of the list is what gets read, and allergies belong there.
///
/// The reasoning is in `chart/safety.dart` and `chart/notes.dart`; this
/// renders it.
library;

import 'package:flutter/material.dart';

import '../chart/notes.dart';
import '../chart/safety.dart';
import '../ui/states.dart';

/// Everything the chart renders.
class ChartView {
  const ChartView({
    this.allergies = const [],
    this.problems = const [],
    this.observations = const [],
    this.documents = const [],
    this.mayWrite = false,
  });

  final List<PresentedAllergy> allergies;
  final List<PresentedProblem> problems;
  final List<PresentedObservation> observations;
  final List<ChartDocument> documents;

  /// Whether this viewer may write at all. The server decides; this only
  /// chooses what to draw.
  final bool mayWrite;
}

class ChartScreen extends StatelessWidget {
  const ChartScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onSign,
    this.onCorrect,
    this.onOpenDocument,
  });

  final ChartView? view;
  final bool loading;
  final String? failure;
  final VoidCallback? onRetry;

  final void Function(ChartDocument document)? onSign;
  final void Function(ChartDocument document, CorrectionKind kind)? onCorrect;
  final void Function(ChartDocument document)? onOpenDocument;

  @override
  Widget build(BuildContext context) {
    final view = this.view;

    if (loading && view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading the chart…',
        ),
      );
    }
    if (failure != null && view == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.failure,
          title: failure!,
          onRetry: onRetry,
        ),
      );
    }
    if (view == null) {
      return const SizedBox.shrink();
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (failure != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ScreenState(
              kind: ScreenStateKind.failure,
              title: failure!,
              onRetry: onRetry,
            ),
          ),
        _allergies(context, view),
        const SizedBox(height: 12),
        _problems(context, view),
        const SizedBox(height: 12),
        _results(context, view),
        const SizedBox(height: 12),
        _notes(context, view),
      ],
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      );

  Widget _allergies(BuildContext context, ChartView view) {
    if (allergiesUnrecorded(view.allergies)) {
      // Not "no known allergies". Nobody has asked, and the reassuring version
      // of that sentence is a sentence nobody wrote.
      return _section(context, 'Allergies', const [
        Text('Nothing recorded. Nobody has asked, or nothing was entered.',
            key: Key('allergies-unrecorded')),
      ]);
    }

    return _section(context, 'Allergies', [
      for (final allergy in orderAllergies(view.allergies))
        Semantics(
          container: true,
          child: Padding(
            key: Key('allergy-${allergy.allergyId}'),
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (allergy.prominent)
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(Icons.warning_amber, size: 18),
                      ),
                    Expanded(
                      child: Text(
                        allergy.substance,
                        style: TextStyle(
                          fontWeight: allergy.prominent
                              ? FontWeight.bold
                              : FontWeight.normal,
                          decoration: allergy.historical
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                // Criticality and verification always as words. A colour alone
                // is a classification somebody has to have been taught.
                Text('${allergy.criticalityLabel} · '
                    '${allergy.verificationLabel} · ${allergy.kindLabel}'),
                if (allergy.reactions.isNotEmpty)
                  Text('Reactions: ${allergy.reactions.join(', ')}'),
              ],
            ),
          ),
        ),
    ]);
  }

  Widget _problems(BuildContext context, ChartView view) {
    if (view.problems.isEmpty) {
      return _section(context, 'Problems', const [
        Text('Nothing recorded.', key: Key('problems-empty')),
      ]);
    }
    return _section(context, 'Problems', [
      for (final problem in orderProblems(view.problems))
        Padding(
          key: Key('problem-${problem.problemId}'),
          padding: const EdgeInsets.only(bottom: 6),
          child: Text('${problem.display} — ${problem.statusLabel}'),
        ),
    ]);
  }

  Widget _results(BuildContext context, ChartView view) {
    if (view.observations.isEmpty) {
      return _section(context, 'Results', const [
        Text('Nothing recorded.', key: Key('results-empty')),
      ]);
    }

    final trend = buildTrend(view.observations);

    return _section(context, 'Results', [
      for (final o in view.observations)
        Padding(
          key: Key('observation-${o.observationId}'),
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (o.critical)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.priority_high, size: 18),
                    ),
                  Expanded(child: Text('${o.display}: ${o.value}')),
                ],
              ),
              Text(o.interpretationLabel),
              if (o.interpretationSource.isNotEmpty)
                // Attribution, because a flag with no source is
                // indistinguishable from one the screen inferred.
                Text('Flagged by ${o.interpretationSource}'),
              if (o.referenceRange.isNotEmpty)
                Text('Reference ${o.referenceRange}'),
            ],
          ),
        ),
      if (trend.mixedUnits)
        const Text(
          'These results use more than one unit, so they are not charted '
          'together. Converting them here could show a change that did not '
          'happen.',
          key: Key('trend-refused'),
        ),
    ]);
  }

  Widget _notes(BuildContext context, ChartView view) {
    if (view.documents.isEmpty) {
      return _section(context, 'Notes', const [
        Text('No notes yet.', key: Key('notes-empty')),
      ]);
    }

    return _section(context, 'Notes', [
      for (final document in view.documents)
        _note(context, document, actionsFor(document, mayWrite: view.mayWrite)),
    ]);
  }

  Widget _note(
    BuildContext context,
    ChartDocument document,
    DocumentActions actions,
  ) =>
      Padding(
        key: Key('note-${document.documentId}'),
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document.title,
                style: Theme.of(context).textTheme.titleSmall),
            Text('${describeDocumentStatus(document.status)} · '
                '${document.authoredBy}'),
            if (document.dictated)
              // SRS-CLN-016: dictated content is marked, so a reader knows a
              // recogniser produced the words.
              const Text('Dictated'),
            if (!document.intact)
              const Text(
                'This document no longer matches what was signed.',
                key: Key('broken-signature'),
              ),
            if (actions.blockedReason.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(actions.blockedReason,
                    key: Key('blocked-${document.documentId}')),
              ),
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  key: Key('open-${document.documentId}'),
                  onPressed: () => onOpenDocument?.call(document),
                  child: const Text('Open'),
                ),
                // Every one of these is absent rather than disabled. A
                // disabled Edit on a signed note still tells a clinician that
                // editing is the kind of thing this note does.
                if (actions.sign)
                  TextButton(
                    key: Key('sign-${document.documentId}'),
                    onPressed: () => onSign?.call(document),
                    child: const Text('Sign'),
                  ),
                if (actions.amend)
                  TextButton(
                    key: Key('amend-${document.documentId}'),
                    onPressed: () =>
                        onCorrect?.call(document, CorrectionKind.amendment),
                    child: Text(
                        describeCorrection(CorrectionKind.amendment).title),
                  ),
                if (actions.addendum)
                  TextButton(
                    key: Key('addendum-${document.documentId}'),
                    onPressed: () =>
                        onCorrect?.call(document, CorrectionKind.addendum),
                    child: Text(
                        describeCorrection(CorrectionKind.addendum).title),
                  ),
              ],
            ),
          ],
        ),
      );
}
