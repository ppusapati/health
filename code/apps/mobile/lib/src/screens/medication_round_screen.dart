/// The medication round (UX-W1-05).
///
/// The tile is the whole design. It shows what is due, what the deployment
/// requires before it may be given, and — after the button — whether the record
/// actually has it. That last distinction is the one that matters: "given" and
/// "saved on this device" are different words on this screen because they are
/// different facts, and a nurse shown the first for the second has a colleague
/// who will give the dose again.
library;

import 'package:flutter/material.dart';

import '../meds/round.dart';
import '../meds/submission.dart';
import '../patient/banner.dart';
import '../ui/states.dart';
import 'patient_banner_bar.dart';

/// Everything the screen renders.
class MedicationRoundView {
  const MedicationRoundView({
    required this.banner,
    required this.doses,
    required this.policy,
    this.submissions = const {},
  });

  final PatientBanner? banner;
  final List<PresentedDose> doses;
  final RoundPolicy policy;

  /// Order id to what happened when it was recorded, for the tiles still
  /// showing an answer.
  final Map<String, Submission> submissions;
}

class MedicationRoundScreen extends StatelessWidget {
  const MedicationRoundScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onRecord,
  });

  final MedicationRoundView? view;
  final bool loading;
  final String? failure;
  final VoidCallback? onRetry;
  final void Function(PresentedDose dose)? onRecord;

  @override
  Widget build(BuildContext context) {
    final view = this.view;

    if (loading && view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading the round…',
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
          detail: 'Pick a patient to see the doses due.',
        ),
      );
    }

    final outstanding = view.doses.where((d) => d.outstanding).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (view.banner != null) PatientBannerBar(banner: view.banner!),
        _RoundHeader(outstanding: outstanding, policy: view.policy),
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
          child: view.doses.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: ScreenState(
                    kind: ScreenStateKind.empty,
                    title: 'Nothing due',
                    detail: 'No dose falls in this window.',
                  ),
                )
              : ListView.separated(
                  itemCount: view.doses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final dose = view.doses[index];
                    return _DoseTile(
                      dose: dose,
                      submission: view.submissions[dose.orderId],
                      readOnly: view.banner?.readOnly ?? false,
                      onRecord: onRecord,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _RoundHeader extends StatelessWidget {
  const _RoundHeader({required this.outstanding, required this.policy});

  final int outstanding;
  final RoundPolicy policy;

  @override
  Widget build(BuildContext context) {
    // The scan requirement is stated before the round starts rather than
    // discovered at the first tile, so a nurse whose scanner is flat knows it
    // now and not at the bedside.
    final spoken = [
      outstanding == 0 ? 'Nothing outstanding' : '$outstanding dose${outstanding == 1 ? '' : 's'} outstanding',
      if (policy.barcodeRequired)
        'Scanning is required on this ward'
      else
        'Scanning is not required on this ward',
    ].join('. ');

    return Semantics(
      container: true,
      liveRegion: true,
      label: spoken,
      excludeSemantics: true,
      child: Container(
        key: const Key('round-header'),
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

class _DoseTile extends StatelessWidget {
  const _DoseTile({
    required this.dose,
    required this.submission,
    required this.readOnly,
    required this.onRecord,
  });

  final PresentedDose dose;
  final Submission? submission;
  final bool readOnly;
  final void Function(PresentedDose dose)? onRecord;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('dose-${dose.orderId}'),
      title: Text('${dose.medication} ${dose.doseLabel}'),
      subtitle: Text(_subtitle()),
      isThreeLine: true,
      trailing: dose.outstanding && !readOnly && onRecord != null
          ? ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 88, minHeight: 48),
              child: FilledButton(
                onPressed: () => onRecord!(dose),
                child: const Text('Record'),
              ),
            )
          : null,
    );
  }

  String _subtitle() {
    final parts = <String>[dose.route];

    if (dose.prn) parts.add('When required');
    if (!dose.verifiedByPharmacy) {
      // Giving an unverified drug is a decision a nurse should make knowingly.
      parts.add('Not verified by pharmacy');
    }
    if (dose.overdue) {
      parts.add(dose.minutesLate >= 60
          ? 'Overdue by ${dose.minutesLate ~/ 60}h'
          : 'Overdue by ${dose.minutesLate}m');
    }

    final settled = dose.recordedOutcome;
    if (settled != null) parts.add(describeOutcome(settled));

    final submission = this.submission;
    if (submission != null) {
      parts.add(switch (submission.state) {
        // Never "given". The record does not have it yet, and the ward needs to
        // know which doses are still only promises.
        SubmissionState.queued => 'Saved on this device, not yet sent',
        SubmissionState.confirmed => 'Recorded',
        SubmissionState.failed => 'Not recorded — ${submission.message}',
      });
    }

    return parts.where((p) => p.isNotEmpty).join(' · ');
  }
}
