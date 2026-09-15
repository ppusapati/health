/// Fetching the medication round and recording against it.
///
/// The counterpart to `WardController`, with one difference that matters: an
/// administration goes through `submitAdministration`, so a dose given out of
/// network coverage lands on the queue instead of being lost — and is reported
/// as queued rather than as given.
library;

import '../api/api_error.dart';
import '../api/nursing_client.dart';
import '../gen/healthcare/nursing/v1/nursing.pb.dart' as wire;
import '../offline/operation_queue.dart';
import '../patient/banner.dart';
import '../screens/medication_round_screen.dart';
import 'round.dart';
import 'submission.dart';

class RoundController {
  /// Positional for the same reason as [WardController]: a named parameter
  /// cannot be a private initializing formal.
  RoundController(this._nursing, this._queue, this._now, this._newIdempotencyKey);

  final NursingClient _nursing;
  final OperationQueue _queue;
  final DateTime Function() _now;
  final String Function() _newIdempotencyKey;

  MedicationRoundView? _view;
  String? _failure;
  bool _loading = false;
  final Map<String, Submission> _submissions = {};

  MedicationRoundView? get view => _view;
  String? get failure => _failure;
  bool get loading => _loading;

  /// Loads the doses due in a window.
  Future<void> load({
    required String encounterId,
    required String patientId,
    required String facilityId,
    required DateTime from,
    required DateTime to,
    PatientBanner? banner,
  }) async {
    _loading = true;
    try {
      final response = await _nursing.getMedicationRound(
        encounterId: encounterId,
        patientId: patientId,
        facilityId: facilityId,
        from: from,
        to: to,
      );

      final doses = response.doses
          .map((dose) => _present(dose))
          .toList(growable: false);

      _view = MedicationRoundView(
        banner: banner ?? _view?.banner,
        doses: orderDoses(doses),
        // The policy comes back with the doses. A tablet that cached it could
        // skip a scan the deployment now requires.
        policy: response.hasPolicy()
            ? _policy(response.policy)
            : RoundPolicy.strict,
        submissions: Map.of(_submissions),
      );
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
    } finally {
      _loading = false;
    }
  }

  /// Records one administration.
  ///
  /// The local gate runs first so a nurse at a bedside is told what is missing
  /// without a round trip. It is not the control — the server enforces the same
  /// policy — and a refusal here is returned rather than thrown so the screen
  /// can show every problem at once.
  Future<AdministrationDecision> record({
    required PresentedDose dose,
    required String facilityId,
    required AdministrationOutcome? outcome,
    required Scan scan,
    String overrideReason = '',
    String reason = '',
    double? givenValue,
    String givenUnit = '',
    String route = '',
    String site = '',
    String witnessedBy = '',
    void Function(Submission submission)? onSettled,
  }) async {
    final policy = _view?.policy ?? RoundPolicy.strict;
    final decision = evaluateAdministration(
      dose: dose,
      policy: policy,
      outcome: outcome,
      scan: scan,
      overrideReason: overrideReason,
      reason: reason,
    );
    if (!decision.allowed) return decision;

    // Minted here, before anything is sent, so a retry after a lost response is
    // the same operation and not a second dose.
    final captured = CapturedAdministration(
      orderId: dose.orderId,
      facilityId: facilityId,
      scheduledAt: dose.scheduledAt,
      givenAt: _now(),
      outcome: outcome!,
      idempotencyKey: _newIdempotencyKey(),
      doseValue: givenValue,
      doseUnit: givenUnit,
      route: route,
      site: site,
      reason: reason,
      scan: scan,
      overrideReason: overrideReason,
      witnessedBy: witnessedBy,
    );

    final submission = await submitAdministration(
      captured: captured,
      queue: _queue,
      now: _now(),
      send: () => _nursing.administer(
        orderId: captured.orderId,
        facilityId: captured.facilityId,
        scheduledAt: captured.scheduledAt,
        givenAt: captured.givenAt,
        outcome: _wireOutcome(captured.outcome),
        idempotencyKey: captured.idempotencyKey,
        givenDose: givenValue == null
            ? null
            : wire.Quantity(value: givenValue, unit: givenUnit),
        route: route,
        site: site,
        reason: reason,
        verification: scan.patientScanned || scan.medicationScanned
            ? wire.Verification(
                patientScanned: scan.patient,
                medicationScanned: scan.medication,
                performed: scan.complete,
              )
            : null,
        overrideReason: overrideReason,
        witnessedBy: witnessedBy,
      ),
    );

    _submissions[dose.orderId] = submission;
    _view = _view == null
        ? null
        : MedicationRoundView(
            banner: _view!.banner,
            doses: _view!.doses,
            policy: _view!.policy,
            submissions: Map.of(_submissions),
          );
    onSettled?.call(submission);
    return decision;
  }

  PresentedDose _present(wire.DueDose dose) {
    final order = dose.order;
    return presentDose(
      orderId: order.orderId,
      medication: order.medication.display.isEmpty
          ? order.medication.code
          : order.medication.display,
      doseValue: order.dose.value,
      doseUnit: order.dose.unit,
      route: order.route,
      scheduledAt: dose.scheduledAt.toDateTime().toUtc(),
      outstanding: dose.outstanding,
      // From the server, as with the worklist.
      overdue: dose.overdue,
      prn: order.prn,
      verifiedByPharmacy: order.verified,
      recordedOutcome:
          dose.hasGiven() ? _localOutcome(dose.given.outcome) : null,
      now: _now(),
    );
  }
}

RoundPolicy _policy(wire.AdministrationPolicy policy) => RoundPolicy(
      barcodeRequired: policy.barcodeRequired,
      overrideAllowed: policy.overrideAllowed,
      lateAfter: Duration(seconds: policy.lateAfterSeconds.toInt()),
    );

wire.AdministrationOutcome _wireOutcome(AdministrationOutcome outcome) =>
    switch (outcome) {
      AdministrationOutcome.administered =>
        wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_ADMINISTERED,
      AdministrationOutcome.notAdministered =>
        wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_NOT_ADMINISTERED,
      AdministrationOutcome.held =>
        wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_HELD,
      AdministrationOutcome.refused =>
        wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_REFUSED,
      AdministrationOutcome.delayed =>
        wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_DELAYED,
      AdministrationOutcome.unspecified =>
        wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_UNSPECIFIED,
    };

AdministrationOutcome _localOutcome(wire.AdministrationOutcome outcome) =>
    switch (outcome) {
      wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_ADMINISTERED =>
        AdministrationOutcome.administered,
      wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_NOT_ADMINISTERED =>
        AdministrationOutcome.notAdministered,
      wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_HELD =>
        AdministrationOutcome.held,
      wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_REFUSED =>
        AdministrationOutcome.refused,
      wire.AdministrationOutcome.ADMINISTRATION_OUTCOME_DELAYED =>
        AdministrationOutcome.delayed,
      // An outcome this build does not know is shown as unrecorded rather than
      // guessed at. "Given" would be the dangerous guess.
      _ => AdministrationOutcome.unspecified,
    };
