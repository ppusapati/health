/// Prescribing, and the pharmacist's verification queue (UX-W1-05).
///
/// The counterpart to the medication round: the round is what a nurse does
/// with a prescription, this is where the prescription comes from. Both are on
/// the tablet for the same reason — the decision is made at the bedside, and a
/// prescriber who has to find a desk writes it on paper instead.
///
/// The reasoning is in `meds/prescribe.dart`, shared word for word with the
/// web shell and held there by `tools/parity`. This renders it.
library;

import 'package:flutter/material.dart';

import '../meds/prescribe.dart';
import '../meds/prescribe_mapping.dart';
import '../ui/states.dart';

/// Everything the prescribing screen renders.
class PrescribeView {
  const PrescribeView({
    required this.draft,
    this.structuredDoseClasses = const [],
    this.findings = const [],
    this.answers = const {},
    this.formulary,
    this.therapies = const [],
    this.queue = const [],
    this.mayVerify = false,
  });

  final PrescriptionDraft draft;

  /// The classes the tenant's medication policy says may not take a free-text
  /// dose (SRS-MED-010). Server-supplied: a list hard-coded in a client would
  /// be both wrong and invisible.
  final List<String> structuredDoseClasses;

  /// What the safety rules said, in the order they should be read.
  final List<PresentedFinding> findings;

  /// Reason given per rule. Per rule and not one box: a single "I have
  /// considered these" would cover an allergy and a dose warning at once,
  /// which is what makes an override record unreadable at verification.
  final Map<String, String> answers;

  final FormularyNotice? formulary;

  /// What this patient is already on.
  final List<QueueEntry> therapies;

  /// What is waiting for a pharmacist.
  final List<QueueEntry> queue;

  final bool mayVerify;

  /// Derived rather than stored, so an edit cannot leave it behind.
  PrescribeValidity get validity => validatePrescription(
        draft,
        structuredDoseRequired:
            structuredDoseRequiredFor(structuredDoseClasses, draft.drugClass),
      );

  SafetyGate get gate => safetyGate(
        orderFindings(findings),
        [
          for (final entry in answers.entries)
            OverrideAnswer(ruleId: entry.key, reason: entry.value),
        ],
      );

  /// True when the prescribe button may be shown at all.
  bool get prescribable => mayPrescribe(validity, gate);
}

class PrescribeScreen extends StatefulWidget {
  const PrescribeScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onIngredientChanged,
    this.onDrugClassChanged,
    this.onRouteChanged,
    this.onAmountChanged,
    this.onUnitChanged,
    this.onFreeTextDoseChanged,
    this.onIndicationChanged,
    this.onReasonChanged,
    this.onPrescribe,
    this.onVerify,
  });

  final PrescribeView? view;
  final bool loading;
  final String? failure;
  final VoidCallback? onRetry;

  final void Function(String value)? onIngredientChanged;
  final void Function(String value)? onDrugClassChanged;
  final void Function(String value)? onRouteChanged;
  final void Function(String value)? onAmountChanged;
  final void Function(String value)? onUnitChanged;
  final void Function(String value)? onFreeTextDoseChanged;
  final void Function(String value)? onIndicationChanged;
  final void Function(String ruleId, String reason)? onReasonChanged;
  final VoidCallback? onPrescribe;
  final void Function(QueueEntry entry)? onVerify;

  @override
  State<PrescribeScreen> createState() => _PrescribeScreenState();
}

enum _Panel { medications, compose, verify }

class _PrescribeScreenState extends State<PrescribeScreen> {
  final _ingredient = TextEditingController();
  final _drugClass = TextEditingController();
  final _route = TextEditingController();
  final _amount = TextEditingController();
  final _unit = TextEditingController();
  final _freeText = TextEditingController();
  final _indication = TextEditingController();
  final _reasons = <String, TextEditingController>{};

  _Panel _panel = _Panel.medications;

  @override
  void dispose() {
    for (final c in [
      _ingredient, _drugClass, _route, _amount, _unit, _freeText, _indication,
      ..._reasons.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _reasonFor(String ruleId) =>
      _reasons.putIfAbsent(ruleId, TextEditingController.new);

  @override
  Widget build(BuildContext context) {
    final view = widget.view;

    if (widget.loading && view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading medication…',
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
          child: SegmentedButton<_Panel>(
            segments: [
              const ButtonSegment(
                value: _Panel.medications,
                label: Text('Medication'),
                icon: Icon(Icons.medication_outlined),
              ),
              const ButtonSegment(
                value: _Panel.compose,
                label: Text('Prescribe'),
                icon: Icon(Icons.add_circle_outline),
              ),
              // Offered only to somebody who may verify. Hiding is a courtesy
              // — the server refuses regardless — but offering a pharmacist's
              // queue to a prescriber who cannot act on it is noise.
              if (view?.mayVerify ?? false)
                const ButtonSegment(
                  value: _Panel.verify,
                  label: Text('Verify'),
                  icon: Icon(Icons.fact_check_outlined),
                ),
            ],
            selected: {_panel},
            onSelectionChanged: (s) => setState(() => _panel = s.first),
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
        Expanded(
          child: switch (_panel) {
            _Panel.medications => _therapies(view),
            _Panel.compose => _composer(view),
            _Panel.verify => _queue(view),
          },
        ),
      ],
    );
  }

  // ------------------------------------------------- what they are already on

  Widget _therapies(PrescribeView? view) {
    final therapies = view?.therapies ?? const <QueueEntry>[];
    if (therapies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.empty,
          title: 'Nothing prescribed on this encounter.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final entry in therapies)
          Card(
            key: Key('therapy-${entry.prescriptionId}'),
            child: ListTile(
              title: Text(entry.description),
              subtitle: Text([
                describeTherapy(entry.therapyStatus),
                if (!entry.verified) 'Awaiting pharmacy verification',
                if (entry.overridden) 'Prescribed over a safety warning',
              ].join(' · ')),
            ),
          ),
      ],
    );
  }

  // ----------------------------------------------------------- the composer

  Widget _composer(PrescribeView? view) {
    if (view == null) {
      return const SizedBox.shrink();
    }
    final validity = view.validity;
    final gate = view.gate;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        TextField(
          key: const Key('ingredient'),
          controller: _ingredient,
          onChanged: widget.onIngredientChanged,
          decoration: InputDecoration(
            labelText: 'Medicine',
            border: const OutlineInputBorder(),
            errorText: validity.problems[PrescribeField.ingredient],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('drug-class'),
          controller: _drugClass,
          onChanged: widget.onDrugClassChanged,
          decoration: const InputDecoration(
            labelText: 'Therapeutic class',
            helperText: 'Some classes may not take a free-text dose',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('route'),
          controller: _route,
          onChanged: widget.onRouteChanged,
          decoration: InputDecoration(
            // Oral and intravenous paracetamol are different doses.
            labelText: 'Route',
            border: const OutlineInputBorder(),
            errorText: validity.problems[PrescribeField.route],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                key: const Key('dose-amount'),
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: widget.onAmountChanged,
                decoration: InputDecoration(
                  labelText: 'Dose',
                  border: const OutlineInputBorder(),
                  errorText: validity.problems[PrescribeField.dose],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: const Key('dose-unit'),
                controller: _unit,
                onChanged: widget.onUnitChanged,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('dose-free-text'),
          controller: _freeText,
          onChanged: widget.onFreeTextDoseChanged,
          decoration: const InputDecoration(
            labelText: 'Or a dose in words',
            helperText: '"Two puffs as needed". Refused for some classes.',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('indication'),
          controller: _indication,
          onChanged: widget.onIndicationChanged,
          decoration: InputDecoration(
            labelText: 'Indication',
            border: const OutlineInputBorder(),
            errorText: validity.problems[PrescribeField.indication],
          ),
        ),
        const SizedBox(height: 12),
        if (view.formulary != null && view.formulary!.label.isNotEmpty)
          _formulary(view.formulary!),
        if (view.findings.isNotEmpty) _safety(view, gate),
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
        // Absent until it may be used, like the order composer's. A disabled
        // button on a prescription missing its indication reads as a
        // permission problem, when what is missing is a sentence only the
        // prescriber can write.
        if (view.prescribable)
          FilledButton(
            key: const Key('prescribe'),
            onPressed: widget.onPrescribe,
            child: const Text('Prescribe'),
          ),
      ],
    );
  }

  /// Never a block (SRS-MED-012). The drug may be exactly right, and a hard
  /// block here produces a phone call and a handwritten chart.
  Widget _formulary(FormularyNotice notice) => Card(
        key: const Key('formulary'),
        color: notice.prominent ? const Color(0xFFFFF4E5) : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notice.label,
                  style: Theme.of(context).textTheme.titleSmall),
              if (notice.action.isNotEmpty)
                Text(notice.action, key: const Key('formulary-action')),
            ],
          ),
        ),
      );

  Widget _safety(PrescribeView view, SafetyGate gate) => Card(
        key: const Key('safety'),
        color: gate.state == SafetyState.contraindicated
            ? const Color(0xFFFDE7E9)
            : const Color(0xFFFFF4E5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (gate.message.isNotEmpty)
                Text(gate.message, key: const Key('safety-message')),
              const SizedBox(height: 8),
              for (final finding in orderFindings(view.findings))
                Padding(
                  key: Key('finding-${finding.ruleId}'),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${finding.severityLabel} · ${finding.kindLabel}'),
                      Text(finding.summary),
                      // Named rather than counted: "an interaction exists"
                      // without saying with what is a warning nobody can act
                      // on.
                      if (finding.subjects.isNotEmpty)
                        Text(finding.subjects.join(', ')),
                      if (finding.existingOverrideReason.isNotEmpty)
                        Text('Reason already recorded: '
                            '${finding.existingOverrideReason}'),
                      // A contraindication takes no reason at all. Showing an
                      // empty box under it would say the opposite.
                      if (finding.overridable &&
                          finding.existingOverrideReason.isEmpty &&
                          finding.severity != Severity.informational)
                        TextField(
                          key: Key('reason-${finding.ruleId}'),
                          controller: _reasonFor(finding.ruleId),
                          onChanged: (value) => widget.onReasonChanged
                              ?.call(finding.ruleId, value),
                          decoration: const InputDecoration(
                            labelText: 'Why this is being prescribed anyway',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );

  // ------------------------------------------------------ the pharmacy queue

  Widget _queue(PrescribeView? view) {
    final entries = orderQueue(view?.queue ?? const <QueueEntry>[]);
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.empty,
          title: 'Nothing waiting to be verified.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final entry in entries)
          Card(
            key: Key('queued-${entry.prescriptionId}'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.description,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text('Patient ${entry.patientId} · '
                      'prescribed by ${entry.prescriberId}'),
                  Text(describeSeverity(entry.worstSeverity)),
                  if (entry.overridden)
                    const Text('Prescribed over a safety warning',
                        key: Key('overridden')),
                  for (final finding in orderFindings(entry.findings))
                    Text('• ${finding.severityLabel}: ${finding.summary}'
                        '${finding.existingOverrideReason.isEmpty ? '' : ' — '
                            '${finding.existingOverrideReason}'}'),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      key: Key('verify-${entry.prescriptionId}'),
                      onPressed: () => widget.onVerify?.call(entry),
                      child: const Text('Verify'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
