/// Recording an observation at the bedside (SRS-NUR-001).
///
/// A form rather than a dialog with two fields, because of the late-entry rule:
/// an observation taken more than fifteen minutes ago needs a reason, and the
/// moment to ask for it is while the nurse still remembers, not when the server
/// refuses.
///
/// The form registers itself as a draft. A half-entered set of observations is
/// work the nurse has done, and on a tablet it is lost to a phone call, a
/// backgrounding, or a tap on the wrong patient. The guard in
/// `drafts/guard.dart` is what stands in the way; this is the screen that
/// gives it something to guard.
library;

import 'package:flutter/material.dart';

import '../drafts/guard.dart';
import '../ui/states.dart';
import '../ward/worklist.dart';

/// What the form produces.
class ObservationEntry {
  const ObservationEntry({
    required this.observedAt,
    required this.numericValue,
    required this.textValue,
    required this.lateEntryReason,
    required this.source,
  });

  final DateTime observedAt;
  final String numericValue;
  final String textValue;
  final String lateEntryReason;
  final EntrySource source;
}

class ObservationForm extends StatefulWidget {
  const ObservationForm({
    super.key,
    required this.patientRef,
    required this.label,
    required this.unit,
    required this.drafts,
    required this.now,
    required this.onSubmit,
    this.draftId = 'observation',
  });

  /// The patient this belongs to, so the guard can refuse a chart switch.
  final String patientRef;

  /// What is being measured, e.g. "Temperature".
  final String label;
  final String unit;

  final DraftRegistry drafts;

  /// Injected so a test can hold the clock still, and so the form and the
  /// validator agree on what "now" is within one build.
  final DateTime Function() now;

  final void Function(ObservationEntry entry) onSubmit;
  final String draftId;

  @override
  State<ObservationForm> createState() => _ObservationFormState();
}

class _ObservationFormState extends State<ObservationForm> {
  final _valueController = TextEditingController();
  final _reasonController = TextEditingController();

  late DateTime _observedAt = widget.now();
  ChartValidity? _validity;

  @override
  void initState() {
    super.initState();
    // Registered clean. It becomes dirty on the first keystroke, so a form
    // opened and immediately closed does not prompt about nothing.
    widget.drafts.register(Draft(
      id: widget.draftId,
      description: '${widget.label.toLowerCase()} observation',
      // Not `confirm`: an observation belongs to one patient, and saving it
      // against the wrong chart is the hazard. A switch is refused outright.
      policy: DraftPolicy.blockPatientSwitch,
      patientRef: widget.patientRef,
      dirty: false,
    ));
  }

  @override
  void dispose() {
    widget.drafts.release(widget.draftId);
    _valueController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _touched() {
    widget.drafts.setDirty(widget.draftId, dirty: true);
    // Re-validate as they type only once they have been told something is
    // wrong. Complaining about an empty field the moment the form opens is how
    // a form teaches people to ignore it.
    if (_validity != null) setState(_revalidate);
  }

  void _revalidate() {
    _validity = validateChartEntry(
      observedAt: _observedAt,
      numericValue: _valueController.text,
      textValue: '',
      lateEntryReason: _reasonController.text,
      now: widget.now(),
    );
  }

  void _submit() {
    setState(_revalidate);
    final validity = _validity!;
    if (!validity.valid) return;

    widget.onSubmit(ObservationEntry(
      observedAt: _observedAt,
      numericValue: _valueController.text.trim(),
      textValue: '',
      lateEntryReason: _reasonController.text.trim(),
      source: EntrySource.manual,
    ));
    widget.drafts.release(widget.draftId);
  }

  @override
  Widget build(BuildContext context) {
    final validity = _validity;
    final late = isLate(_observedAt, widget.now());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('observation-value'),
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _touched(),
            decoration: InputDecoration(
              labelText: widget.unit.isEmpty
                  ? 'Reading'
                  : 'Reading (${widget.unit})',
              border: const OutlineInputBorder(),
            ),
          ),
          if (validity?.problems['value'] != null)
            FieldError(
              fieldLabel: 'Reading',
              message: validity!.problems['value']!,
            ),
          const SizedBox(height: 12),
          _ObservedAt(
            observedAt: _observedAt,
            now: widget.now(),
            onEarlier: () => setState(() {
              _observedAt = _observedAt.subtract(const Duration(minutes: 5));
              _touched();
              if (_validity != null) _revalidate();
            }),
          ),
          if (validity?.problems['observedAt'] != null)
            FieldError(
              fieldLabel: 'Time taken',
              message: validity!.problems['observedAt']!,
            ),
          if (late) ...[
            const SizedBox(height: 12),
            TextField(
              key: const Key('late-entry-reason'),
              controller: _reasonController,
              onChanged: (_) => _touched(),
              decoration: const InputDecoration(
                labelText: 'Why is this being entered now?',
                border: OutlineInputBorder(),
              ),
            ),
            if (validity?.problems['lateEntryReason'] != null)
              FieldError(
                fieldLabel: 'Reason',
                message: validity!.problems['lateEntryReason']!,
              ),
          ],
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: FilledButton(
              key: const Key('observation-submit'),
              onPressed: _submit,
              child: const Text('Record'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ObservedAt extends StatelessWidget {
  const _ObservedAt({
    required this.observedAt,
    required this.now,
    required this.onEarlier,
  });

  final DateTime observedAt;
  final DateTime now;
  final VoidCallback onEarlier;

  @override
  Widget build(BuildContext context) {
    final minutesAgo = now.difference(observedAt).inMinutes;
    final label = minutesAgo <= 0
        ? 'Taken just now'
        : 'Taken $minutesAgo minutes ago';

    return Semantics(
      container: true,
      label: label,
      excludeSemantics: true,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              key: const Key('observed-at'),
              style: const TextStyle(fontSize: 14, color: Color(0xFF33415C)),
            ),
          ),
          // Nudging the time backwards rather than opening a picker: on a round
          // the answer is almost always "a few minutes ago", and a date picker
          // for that is four taps and a chance to pick the wrong day.
          Semantics(
            excludeSemantics: false,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 88, minHeight: 48),
              child: TextButton(
                key: const Key('observed-earlier'),
                onPressed: onEarlier,
                child: const Text('5 min earlier'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
