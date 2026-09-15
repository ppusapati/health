/// The ward worklist (UX-W1-03).
///
/// What a nurse holding a tablet sees when they start a round: what is
/// outstanding, what is late, and what somebody else has already been told is
/// not being done.
library;

import 'package:flutter/material.dart';

import '../patient/banner.dart';
import '../ui/states.dart';
import '../ward/worklist.dart';
import 'patient_banner_bar.dart';

/// Everything the screen renders, resolved by the caller.
///
/// The screen takes a finished view rather than a client, so it can be driven
/// in a test without a server and so the ordering and counting rules stay in
/// `ward/worklist.dart` where they are tested.
class WardWorklistView {
  const WardWorklistView({
    required this.banner,
    required this.tasks,
    required this.summary,
  });

  final PatientBanner? banner;
  final List<PresentedTask> tasks;
  final WorklistSummary summary;
}

class WardWorklistScreen extends StatelessWidget {
  const WardWorklistScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onCompleteTask,
    this.onChartObservation,
  });

  final WardWorklistView? view;
  final bool loading;

  /// A message to show instead of the list. Already made safe for a screen by
  /// `ApiError.message`; never a raw server string.
  final String? failure;

  final VoidCallback? onRetry;
  final void Function(PresentedTask task)? onCompleteTask;
  final VoidCallback? onChartObservation;

  @override
  Widget build(BuildContext context) {
    final view = this.view;

    if (loading && view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading the worklist…',
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
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.awaitingInput,
          title: 'Choose a patient',
          detail: 'Pick a patient from the ward list to see their work.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (view.banner != null) PatientBannerBar(banner: view.banner!),
        _Summary(summary: view.summary),
        // A failure while a list is already on screen keeps the list. The rows
        // are still the best information available and throwing them away
        // helps nobody.
        if (failure != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: ScreenState(
              kind: ScreenStateKind.failure,
              title: failure!,
              onRetry: onRetry,
            ),
          ),
        Expanded(
          child: view.summary.clear && view.tasks.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: ScreenState(
                    kind: ScreenStateKind.empty,
                    title: 'Nothing outstanding',
                    detail: 'No nursing task is due for this patient.',
                  ),
                )
              : ListView.separated(
                  itemCount: view.tasks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _TaskRow(
                    task: view.tasks[index],
                    onComplete: onCompleteTask,
                  ),
                ),
        ),
        if (onChartObservation != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: FilledButton.icon(
                key: const Key('chart-observation'),
                onPressed:
                    view.banner?.readOnly == true ? null : onChartObservation,
                icon: const Icon(Icons.add_chart),
                label: const Text('Record observations'),
              ),
            ),
          ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.summary});

  final WorklistSummary summary;

  @override
  Widget build(BuildContext context) {
    // Spoken as one sentence. "3, 1, 0, 2" read as four numbers tells a nurse
    // nothing about which number was which.
    final spoken = summary.clear
        ? 'Nothing outstanding'
        : '${summary.open} outstanding, ${summary.overdue} overdue, '
            '${summary.escalated} escalated, ${summary.critical} critical';

    return Semantics(
      container: true,
      liveRegion: true,
      label: spoken,
      excludeSemantics: true,
      child: Container(
        key: const Key('worklist-summary'),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFFFAFBFD),
        child: Text(
          spoken,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF33415C),
          ),
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.onComplete});

  final PresentedTask task;
  final void Function(PresentedTask task)? onComplete;

  @override
  Widget build(BuildContext context) {
    final subtitle = <String>[
      task.priorityLabel,
      if (task.overdue) _lateness(),
      if (task.escalated) 'Escalated to ${task.escalatedTo}',
      if (!task.open) 'Closed',
    ].join(' · ');

    return ListTile(
      key: Key('task-${task.taskId}'),
      title: Text(task.description),
      subtitle: Text(subtitle),
      trailing: task.open && onComplete != null
          ? ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: 88, minHeight: 48),
              child: TextButton(
                onPressed: () => onComplete!(task),
                child: const Text('Record'),
              ),
            )
          : null,
    );
  }

  String _lateness() {
    final minutes = task.overdueMinutes;
    if (minutes == null || minutes <= 0) return 'Overdue';
    if (minutes < 60) return 'Overdue by ${minutes}m';
    final hours = minutes ~/ 60;
    return 'Overdue by ${hours}h';
  }
}
