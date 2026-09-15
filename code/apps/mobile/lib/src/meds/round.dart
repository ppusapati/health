/// Medication round / eMAR (UX-W1-05, SRS-NUR-006/007, SRS-MED-009).
///
/// This is the screen where a mistake reaches a patient, so the rules here are
/// stricter than anywhere else in the shell and the reasons are written down.
///
/// Three of them shape everything below.
///
/// **An administration is never optimistic.** `src/api/optimistic.dart` already
/// says so in general; here it is worth saying why. An optimistic tile shows
/// the dose as given the moment the button is pressed. If the request then
/// fails, the nurse has seen "given" and moves on, and the next nurse reads the
/// chart, sees nothing, and gives it again. The tile stays pending until the
/// server confirms, or until the operation is safely queued.
///
/// **Refusing is not the same as not having given it.** The outcomes are
/// distinct on the wire and are kept distinct here: "held" is a clinical
/// decision, "refused" is the patient's, "not administered" is everything else,
/// and flattening them loses the only record of which happened.
///
/// **The verification gate is the control, not the button.** Where policy
/// requires a barcode scan, an unscanned administration must be refused unless
/// an override reason is given — and the override must be recorded against the
/// dose, because an override nobody can find afterwards is not a control.
library;

import 'package:meta/meta.dart';

/// Mirrors nursing.v1.AdministrationOutcome.
enum AdministrationOutcome {
  administered,
  notAdministered,
  held,
  refused,
  delayed,
  unspecified,
}

/// Human label for an outcome.
String describeOutcome(AdministrationOutcome outcome) => switch (outcome) {
      AdministrationOutcome.administered => 'Given',
      AdministrationOutcome.notAdministered => 'Not given',
      AdministrationOutcome.held => 'Held',
      AdministrationOutcome.refused => 'Refused by patient',
      AdministrationOutcome.delayed => 'Delayed',
      AdministrationOutcome.unspecified => 'Outcome not recorded',
    };

/// Whether the outcome means the drug reached the patient.
///
/// Used to decide what the tile says, never to decide what to send: the
/// outcomes are recorded as chosen.
bool wasGiven(AdministrationOutcome outcome) =>
    outcome == AdministrationOutcome.administered;

/// Outcomes that require the nurse to say why.
///
/// Anything other than giving the drug as ordered is a deviation from the
/// prescription, and a deviation with no reason is a gap in the record at
/// exactly the point somebody will later ask about.
bool needsReason(AdministrationOutcome outcome) =>
    outcome != AdministrationOutcome.administered &&
    outcome != AdministrationOutcome.unspecified;

/// What the deployment requires before a dose may be given.
@immutable
class RoundPolicy {
  const RoundPolicy({
    required this.barcodeRequired,
    required this.overrideAllowed,
    required this.lateAfter,
  });

  /// True when patient and medication must be scanned.
  final bool barcodeRequired;

  /// True when an unscanned dose may proceed with a recorded reason. A
  /// deployment that sets this false has decided the scan is absolute, and the
  /// screen must not offer a way past it.
  final bool overrideAllowed;

  /// How long after the scheduled time a dose counts as late.
  final Duration lateAfter;

  /// The shape used when the server sent no policy.
  ///
  /// The safe default is the strict one: requiring a scan that the deployment
  /// did not ask for is an inconvenience, and skipping one it did ask for is a
  /// patient given the wrong drug.
  static const RoundPolicy strict = RoundPolicy(
    barcodeRequired: true,
    overrideAllowed: false,
    lateAfter: Duration(minutes: 60),
  );
}

/// What was scanned at the bedside.
@immutable
class Scan {
  const Scan({this.patient = '', this.medication = ''});

  final String patient;
  final String medication;

  bool get patientScanned => patient.trim().isNotEmpty;
  bool get medicationScanned => medication.trim().isNotEmpty;
  bool get complete => patientScanned && medicationScanned;
}

/// One due dose as the round shows it.
@immutable
class PresentedDose {
  const PresentedDose({
    required this.orderId,
    required this.medication,
    required this.doseLabel,
    required this.route,
    required this.scheduledAt,
    required this.outstanding,
    required this.overdue,
    required this.minutesLate,
    required this.prn,
    required this.verifiedByPharmacy,
    required this.recordedOutcome,
  });

  final String orderId;
  final String medication;
  final String doseLabel;
  final String route;
  final DateTime scheduledAt;

  /// Whether it still needs giving.
  final bool outstanding;

  /// Whether the server says it is overdue — as with the worklist, not
  /// recomputed against the device clock.
  final bool overdue;

  /// How late, for display only. Negative before it is due.
  final int minutesLate;

  final bool prn;

  /// Whether a pharmacist has verified the order (SRS-MED-005). Shown because
  /// giving an unverified drug is a decision a nurse should make knowingly.
  final bool verifiedByPharmacy;

  /// The outcome already recorded, when there is one.
  final AdministrationOutcome? recordedOutcome;

  /// True when the dose has been dealt with, whatever the outcome was.
  bool get settled => recordedOutcome != null;
}

/// Presents one due dose.
PresentedDose presentDose({
  required String orderId,
  required String medication,
  required double doseValue,
  required String doseUnit,
  required String route,
  required DateTime scheduledAt,
  required bool outstanding,
  required bool overdue,
  required bool prn,
  required bool verifiedByPharmacy,
  AdministrationOutcome? recordedOutcome,
  required DateTime now,
}) {
  return PresentedDose(
    orderId: orderId,
    medication: medication,
    doseLabel: formatDose(doseValue, doseUnit),
    route: route,
    scheduledAt: scheduledAt,
    outstanding: outstanding,
    overdue: overdue,
    minutesLate: now.difference(scheduledAt).inMinutes,
    prn: prn,
    verifiedByPharmacy: verifiedByPharmacy,
    recordedOutcome: recordedOutcome,
  );
}

/// Formats a dose for display.
///
/// A trailing `.0` is dropped because "5.0 mg" and "5 mg" read differently at a
/// glance and one of them looks like a precision that was not measured. The
/// value is never rounded: a dose displayed as something other than the dose
/// ordered is the defect this whole screen exists to prevent.
String formatDose(double value, String unit) {
  final text = value == value.roundToDouble() && value.abs() < 1e15
      ? value.toStringAsFixed(0)
      : value.toString();
  return unit.isEmpty ? text : '$text $unit';
}

/// Orders the round.
///
/// Outstanding doses first, earliest scheduled first. Settled doses keep their
/// place in time below, so the round reads as a timeline rather than a queue
/// that empties.
List<PresentedDose> orderDoses(List<PresentedDose> doses) {
  final ordered = [...doses];
  ordered.sort((a, b) {
    if (a.outstanding != b.outstanding) return a.outstanding ? -1 : 1;
    return a.scheduledAt.compareTo(b.scheduledAt);
  });
  return ordered;
}

/// Why an administration may not proceed.
enum Refusal {
  /// Policy requires a scan and the patient was not scanned.
  patientNotScanned,

  /// Policy requires a scan and the medication was not scanned.
  medicationNotScanned,

  /// A scan is missing, an override would be needed, and none was given.
  overrideReasonMissing,

  /// A scan is missing and this deployment does not permit overriding.
  overrideNotPermitted,

  /// The outcome is a deviation and no reason was given.
  reasonMissing,

  /// No outcome was chosen.
  outcomeMissing,

  /// The dose has already been recorded.
  alreadySettled,
}

/// What the screen tells the nurse about each refusal.
String describeRefusal(Refusal refusal) => switch (refusal) {
      Refusal.patientNotScanned => 'Scan the patient’s wristband.',
      Refusal.medicationNotScanned => 'Scan the medication.',
      Refusal.overrideReasonMissing =>
        'Giving this without scanning needs a reason, and the reason is kept '
            'with the dose.',
      Refusal.overrideNotPermitted =>
        'This ward does not allow giving a dose without scanning. Find a '
            'working scanner or a second nurse.',
      Refusal.reasonMissing => 'Say why the dose was not given as ordered.',
      Refusal.outcomeMissing => 'Choose what happened to this dose.',
      Refusal.alreadySettled => 'This dose has already been recorded.',
    };

/// The decision about one attempted administration.
@immutable
class AdministrationDecision {
  const AdministrationDecision({
    required this.allowed,
    required this.refusals,
    required this.overriding,
  });

  final bool allowed;

  /// Everything wrong, not just the first thing. A nurse told one problem at a
  /// time is a nurse making three round trips to the trolley.
  final List<Refusal> refusals;

  /// True when this will be recorded as an override. The screen says so before
  /// the button is pressed, because an override is a thing the nurse is
  /// choosing, not a consequence they discover afterwards.
  final bool overriding;
}

/// Decides whether an administration may be recorded.
///
/// This is a local pre-flight, not the control. The server enforces the same
/// policy and its answer is the one that counts; this exists so a nurse at a
/// bedside is told what is missing before a round trip, and so the override is
/// named out loud at the moment it is being chosen.
AdministrationDecision evaluateAdministration({
  required PresentedDose dose,
  required RoundPolicy policy,
  required AdministrationOutcome? outcome,
  required Scan scan,
  required String overrideReason,
  required String reason,
}) {
  final refusals = <Refusal>[];

  if (dose.settled) {
    refusals.add(Refusal.alreadySettled);
  }
  if (outcome == null || outcome == AdministrationOutcome.unspecified) {
    refusals.add(Refusal.outcomeMissing);
  }
  if (outcome != null && needsReason(outcome) && reason.trim().isEmpty) {
    refusals.add(Refusal.reasonMissing);
  }

  // The scan gate applies to giving the drug. Recording that it was held or
  // refused does not put anything into a patient, and demanding a wristband
  // scan before a nurse can write down that the patient declined would teach
  // them to record it as something else.
  var overriding = false;
  final wouldGive = outcome == AdministrationOutcome.administered;
  if (policy.barcodeRequired && wouldGive && !scan.complete) {
    if (!scan.patientScanned) refusals.add(Refusal.patientNotScanned);
    if (!scan.medicationScanned) refusals.add(Refusal.medicationNotScanned);

    if (!policy.overrideAllowed) {
      refusals.add(Refusal.overrideNotPermitted);
    } else if (overrideReason.trim().isEmpty) {
      refusals.add(Refusal.overrideReasonMissing);
    } else {
      // The missing scans are excused by the override, but the override itself
      // is what gets recorded.
      refusals.removeWhere((r) =>
          r == Refusal.patientNotScanned || r == Refusal.medicationNotScanned);
      overriding = true;
    }
  }

  return AdministrationDecision(
    allowed: refusals.isEmpty,
    refusals: refusals,
    overriding: overriding,
  );
}
