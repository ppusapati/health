/// Placing orders and clearing the results inbox (UX-W1-04).
///
/// Two halves that look unrelated and are not: the inbox is where a clinician
/// finds out that something needs doing, and the composer is where they do it.
/// Putting them on one screen is what makes "potassium 6.8, recheck" a single
/// movement rather than two.
///
/// The reasoning is in `orders/composer.dart`; this renders it.
library;

import 'package:flutter/material.dart';

import '../orders/composer.dart';
import '../ui/states.dart';

/// Everything the orders screen renders.
class OrdersView {
  const OrdersView({
    required this.draft,
    this.policy,
    this.gate = const DuplicateGate(state: DuplicateState.clear),
    this.inbox = const [],
    this.acknowledged = const [],
    this.overrideReason = '',
  });

  final OrderDraft draft;
  final OrderPolicy? policy;
  final DuplicateGate gate;
  final List<InboxItem> inbox;
  final List<String> acknowledged;
  final String overrideReason;

  /// Derived rather than stored, so it cannot be left behind by an edit.
  ComposerValidity get validity => validateOrder(draft, policy);

  /// True when the place button may be shown at all.
  bool get placeable => mayPlace(validity, gate);
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onIndicationChanged,
    this.onOverrideReasonChanged,
    this.onAcknowledgeDuplicate,
    this.onPlace,
    this.onAcknowledgeResult,
  });

  final OrdersView? view;
  final bool loading;
  final String? failure;
  final VoidCallback? onRetry;

  final void Function(String indication)? onIndicationChanged;
  final void Function(String reason)? onOverrideReasonChanged;
  final void Function(DuplicateCandidate candidate)? onAcknowledgeDuplicate;
  final VoidCallback? onPlace;
  final void Function(InboxItem item, String action)? onAcknowledgeResult;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _indication = TextEditingController();
  final _reason = TextEditingController();
  final _action = TextEditingController();
  bool _composing = false;

  @override
  void dispose() {
    _indication.dispose();
    _reason.dispose();
    _action.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = widget.view;

    if (widget.loading && view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading orders…',
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFFF1F4F9),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                label: Text('Results'),
                icon: Icon(Icons.inbox),
              ),
              ButtonSegment(
                value: true,
                label: Text('New order'),
                icon: Icon(Icons.add_circle_outline),
              ),
            ],
            selected: {_composing},
            onSelectionChanged: (s) => setState(() => _composing = s.first),
          ),
        ),
        if (widget.failure != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: ScreenState(
              kind: ScreenStateKind.failure,
              title: widget.failure!,
              onRetry: widget.onRetry,
            ),
          ),
        Expanded(child: _composing ? _composer(view) : _inbox(view)),
      ],
    );
  }

  // -------------------------------------------------------------- the inbox

  Widget _inbox(OrdersView? view) {
    final items = orderInbox(view?.inbox ?? const []);
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.empty,
          title: 'No critical results waiting.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final item in items)
          Card(
            key: Key('inbox-${item.observationId}'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.display}: ${item.value}',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(item.interpretationLabel),
                  // The inbox is ward-wide, so every row has to say whose
                  // result it is — scoping it to the open chart would hide
                  // exactly the results nobody is looking at.
                  Text('Patient ${item.patientId} · '
                      'waiting ${item.waitingMinutes} min'),
                  if (item.dueEscalations > 0)
                    Text(
                      item.dueEscalations == 1
                          ? 'Escalated once — nobody has acknowledged this'
                          : 'Escalated ${item.dueEscalations} times — nobody '
                              'has acknowledged this',
                      key: Key('escalated-${item.observationId}'),
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    key: Key('action-${item.observationId}'),
                    controller: _action,
                    decoration: const InputDecoration(
                      labelText: 'What was done about it',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      key: Key('acknowledge-${item.observationId}'),
                      onPressed: () => widget.onAcknowledgeResult
                          ?.call(item, _action.text),
                      child: const Text('Acknowledge'),
                    ),
                  ),
                  if (acknowledgementProblem(_action.text).isNotEmpty)
                    Text(
                      acknowledgementProblem(_action.text),
                      key: Key('ack-problem-${item.observationId}'),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ----------------------------------------------------------- the composer

  Widget _composer(OrdersView? view) {
    if (view == null) {
      return const SizedBox.shrink();
    }
    final validity = view.validity;
    final gate = view.gate;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(describeOrderType(view.draft.type),
            style: Theme.of(context).textTheme.titleMedium),
        Text(view.draft.display.isNotEmpty
            ? view.draft.display
            : view.draft.code),
        const SizedBox(height: 12),
        TextField(
          key: const Key('indication'),
          controller: _indication,
          onChanged: widget.onIndicationChanged,
          decoration: InputDecoration(
            labelText: view.policy?.indicationRequired ?? false
                ? 'Clinical indication (required)'
                : 'Clinical indication',
            border: const OutlineInputBorder(),
            errorText: validity.problems[OrderField.indication],
          ),
        ),
        const SizedBox(height: 12),
        if (gate.state != DuplicateState.clear) _duplicates(view, gate),
        const SizedBox(height: 12),
        if (validity.order.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final problem in validity.order)
                  Text('• $problem', key: Key('problem-$problem')),
              ],
            ),
          ),
        // Absent until it may be used. A disabled Place button on an order
        // missing its indication reads as a permission problem, when what is
        // missing is a sentence only the clinician can write.
        if (view.placeable)
          FilledButton(
            key: const Key('place-order'),
            onPressed: widget.onPlace,
            child: const Text('Place order'),
          ),
      ],
    );
  }

  Widget _duplicates(OrdersView view, DuplicateGate gate) => Card(
        color: const Color(0xFFFFF4E5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gate.state == DuplicateState.overridden
                    ? 'You have said why another is needed.'
                    : gate.message,
                key: const Key('duplicate-message'),
              ),
              const SizedBox(height: 8),
              // Shown in full rather than counted: "a duplicate exists"
              // without saying which one is a warning nobody can act on.
              for (final candidate in gate.candidates)
                Padding(
                  key: Key('duplicate-${candidate.orderId}'),
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${candidate.number} · '
                            '${candidate.display} · '
                            '${candidate.statusLabel}'),
                      ),
                      if (gate.state != DuplicateState.refused)
                        TextButton(
                          key: Key('ack-dup-${candidate.orderId}'),
                          onPressed:
                              view.acknowledged.contains(candidate.orderId)
                                  ? null
                                  : () => widget.onAcknowledgeDuplicate
                                      ?.call(candidate),
                          child: Text(
                            view.acknowledged.contains(candidate.orderId)
                                ? 'Seen'
                                : 'I have seen this',
                          ),
                        ),
                    ],
                  ),
                ),
              if (gate.state != DuplicateState.refused)
                TextField(
                  key: const Key('override-reason'),
                  controller: _reason,
                  onChanged: widget.onOverrideReasonChanged,
                  decoration: const InputDecoration(
                    labelText: 'Why another is needed',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
            ],
          ),
        ),
      );
}
