/// Choosing a patient (UX-W1-03).
///
/// Opens on the nurse's own caseload in bed order, because that is what a round
/// is. Scanning a wristband is the way to reach somebody not on it, and a name
/// search is the fallback for a band that cannot be read.
///
/// The reasoning is in `patient/caseload.dart`; this renders it.
library;

import 'package:flutter/material.dart';

import '../patient/caseload.dart';
import '../ui/states.dart';

/// Everything the picker renders.
class CaseloadView {
  const CaseloadView({
    required this.patients,
    this.scanProblem = '',
    this.searchResults = const [],
    this.searched = false,
  });

  final List<CaseloadPatient> patients;

  /// What went wrong with the last scan, if anything.
  final String scanProblem;

  final List<CaseloadPatient> searchResults;

  /// Whether a search has been run. Distinguishes "no matches" from "not
  /// asked", which look identical and mean the opposite.
  final bool searched;
}

class PatientPickerScreen extends StatefulWidget {
  const PatientPickerScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onSelect,
    this.onScan,
    this.onSearch,
  });

  final CaseloadView? view;
  final bool loading;
  final String? failure;
  final VoidCallback? onRetry;
  final void Function(PatientSelection selection)? onSelect;

  /// Handed the raw barcode. Resolving it to a patient is the controller's
  /// job, and refusing an ambiguous one is `resolveScan`'s.
  final void Function(String barcode)? onScan;

  final void Function(String name)? onSearch;

  @override
  State<PatientPickerScreen> createState() => _PatientPickerScreenState();
}

class _PatientPickerScreenState extends State<PatientPickerScreen> {
  final _scanController = TextEditingController();
  final _searchController = TextEditingController();
  bool _searching = false;

  @override
  void dispose() {
    _scanController.dispose();
    _searchController.dispose();
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
          title: 'Loading your patients…',
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
        _scanBar(),
        if (view != null && view.scanProblem.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: ScreenState(
              kind: ScreenStateKind.failure,
              title: view.scanProblem,
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
        Expanded(child: _searching ? _search(view) : _caseload(view)),
      ],
    );
  }

  Widget _scanBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFF1F4F9),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('scan-band'),
              controller: _scanController,
              decoration: const InputDecoration(
                labelText: 'Scan a wristband',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              // A barcode scanner types and presses enter. Submitting on that
              // rather than on a button press is what makes the scanner work
              // without anybody touching the screen.
              onSubmitted: (value) {
                widget.onScan?.call(value);
                _scanController.clear();
              },
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 88, minHeight: 48),
            child: TextButton(
              key: const Key('toggle-search'),
              onPressed: () => setState(() => _searching = !_searching),
              child: Text(_searching ? 'My patients' : 'Search'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseload(CaseloadView? view) {
    if (view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.awaitingInput,
          title: 'Scan a wristband to begin',
        ),
      );
    }
    if (view.patients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.empty,
          title: 'No patients assigned to you',
          // Not a dead end: the other two ways in are on the screen above.
          detail: 'Scan a wristband or search by name to open a patient.',
        ),
      );
    }

    return ListView.separated(
      itemCount: view.patients.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => _row(view.patients[index]),
    );
  }

  Widget _search(CaseloadView? view) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            key: const Key('search-name'),
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Patient name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (value) => widget.onSearch?.call(value),
          ),
        ),
        Expanded(
          child: view == null || !view.searched
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: ScreenState(
                    kind: ScreenStateKind.awaitingInput,
                    title: 'Type a name',
                    detail: 'Searching does not confirm who the patient is — '
                        'check the wristband at the bedside.',
                  ),
                )
              : view.searchResults.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: ScreenState(
                        kind: ScreenStateKind.empty,
                        title: 'No patient matched that name',
                      ),
                    )
                  : ListView.separated(
                      itemCount: view.searchResults.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) => _row(
                        view.searchResults[index],
                        method: SelectionMethod.search,
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _row(
    CaseloadPatient patient, {
    SelectionMethod method = SelectionMethod.caseload,
  }) {
    final where = [patient.unit, patient.bed]
        .where((part) => part.isNotEmpty)
        .join(' · ');
    final work = <String>[
      if (patient.outstandingTasks > 0) '${patient.outstandingTasks} outstanding',
      if (patient.dosesDue > 0) '${patient.dosesDue} due',
      // On the row, so the round can be planned from the list rather than by
      // opening every patient in turn.
      if (patient.hasHighCriticalityAllergy) 'Allergy alert',
    ].join(' · ');

    return ListTile(
      key: Key('patient-${patient.patientId}'),
      title: Text(patient.displayName),
      subtitle: Text([where, work].where((p) => p.isNotEmpty).join(' — ')),
      onTap: widget.onSelect == null
          ? null
          : () => widget.onSelect!(
                method == SelectionMethod.caseload
                    ? patient.select()
                    : PatientSelection(
                        patientId: patient.patientId,
                        encounterId: patient.encounterId,
                        displayName: patient.displayName,
                        // A search result is not a verified identity, and the
                        // selection has to say so — the medication round reads
                        // this.
                        method: SelectionMethod.search,
                        bed: patient.bed,
                        unit: patient.unit,
                      ),
              ),
    );
  }
}
