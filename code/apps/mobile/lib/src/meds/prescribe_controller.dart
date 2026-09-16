/// Loading medication, writing a prescription, and verifying one.
///
/// The safety findings are the server's, not this screen's. A first attempt
/// carries no override answers, the server evaluates the rules and refuses,
/// and what comes back is what the prescriber is asked about. A client that
/// decided for itself which rules applied would be a second rule engine, and
/// two rule engines disagree the week after one of them is edited.
library;

import '../api/api_error.dart';
import '../api/medication_client.dart';
import '../gen/healthcare/medication/v1/medication.pb.dart' as wire;
import '../screens/prescribe_screen.dart';
import 'prescribe.dart';
import 'prescribe_mapping.dart';

class PrescribeController {
  /// Positional because a named parameter cannot be a private initializing
  /// formal.
  PrescribeController(this._medication);

  final MedicationClient _medication;

  PrescriptionDraft _draft =
      const PrescriptionDraft(patientId: '', encounterId: '');
  List<String> _structuredDoseClasses = const [];
  List<PresentedFinding> _findings = const [];
  final Map<String, String> _answers = {};
  FormularyNotice? _formulary;
  List<QueueEntry> _therapies = const [];
  List<QueueEntry> _queue = const [];
  bool _mayVerify = false;

  PrescribeView? _view;
  String? _failure;
  bool _loading = false;

  PrescribeView? get view => _view;
  String? get failure => _failure;
  bool get loading => _loading;

  void _rebuild() {
    _view = PrescribeView(
      draft: _draft,
      structuredDoseClasses: _structuredDoseClasses,
      findings: _findings,
      answers: Map.unmodifiable(_answers),
      formulary: _formulary,
      therapies: _therapies,
      queue: _queue,
      mayVerify: _mayVerify,
    );
  }

  /// Starts a new prescription, discarding any half-built one.
  ///
  /// The findings and the reasons given for them go with it. A reason typed
  /// against one patient's interaction must never carry to another's, and the
  /// cheapest way to guarantee that is to have nowhere for it to survive.
  void startDraft({
    required String patientId,
    required String encounterId,
    List<String> structuredDoseClasses = const [],
    bool mayVerify = false,
  }) {
    _draft = PrescriptionDraft(patientId: patientId, encounterId: encounterId);
    _structuredDoseClasses = structuredDoseClasses;
    _findings = const [];
    _answers.clear();
    _formulary = null;
    _mayVerify = mayVerify;
    _rebuild();
  }

  void _edit({
    String? ingredientDisplay,
    String? drugClass,
    String? route,
    String? indication,
    String? amount,
    String? unit,
    String? freeText,
  }) {
    _draft = PrescriptionDraft(
      patientId: _draft.patientId,
      encounterId: _draft.encounterId,
      ingredientCode: _draft.ingredientCode,
      ingredientDisplay: ingredientDisplay ?? _draft.ingredientDisplay,
      drugClass: drugClass ?? _draft.drugClass,
      route: route ?? _draft.route,
      dose: DoseDraft(
        amount: amount ?? _draft.dose.amount,
        unit: unit ?? _draft.dose.unit,
        freeText: freeText ?? _draft.dose.freeText,
        frequencySeconds: _draft.dose.frequencySeconds,
      ),
      indication: indication ?? _draft.indication,
      startsAt: _draft.startsAt,
    );
    _rebuild();
  }

  void setIngredient(String value) => _edit(ingredientDisplay: value);
  void setDrugClass(String value) => _edit(drugClass: value);
  void setRoute(String value) => _edit(route: value);
  void setIndication(String value) => _edit(indication: value);
  void setDoseAmount(String value) => _edit(amount: value);
  void setDoseUnit(String value) => _edit(unit: value);
  void setFreeTextDose(String value) => _edit(freeText: value);

  /// Records the reason given against one rule.
  void setReason(String ruleId, String reason) {
    _answers[ruleId] = reason;
    _rebuild();
  }

  /// Loads what this encounter is already on.
  Future<void> loadTherapies({required String encounterId}) async {
    _loading = true;
    try {
      final response =
          await _medication.listPrescriptions(encounterId: encounterId);
      _therapies = [
        for (final prescription in response.prescriptions)
          queueEntryOf(prescription),
      ];
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
    } finally {
      _loading = false;
      _rebuild();
    }
  }

  /// Loads what is waiting for a pharmacist.
  Future<void> loadQueue({String facilityId = ''}) async {
    _loading = true;
    try {
      final response =
          await _medication.verificationQueue(facilityId: facilityId);
      _queue = [
        for (final prescription in response.prescriptions)
          queueEntryOf(prescription),
      ];
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
    } finally {
      _loading = false;
      _rebuild();
    }
  }

  /// Writes the prescription.
  ///
  /// Returns it, or null when it was refused. A refusal carrying safety
  /// findings is not a failure: it is the server asking the question the gate
  /// exists to put to the prescriber, so it fills the findings in rather than
  /// the error.
  Future<wire.Prescription?> prescribe() async {
    final view = _view;
    if (view == null) {
      return null;
    }
    if (!view.prescribable) {
      _failure = view.validity.order.isNotEmpty
          ? view.validity.order.first
          : view.gate.message;
      _rebuild();
      return null;
    }

    try {
      final response = await _medication.prescribe(
        patientId: _draft.patientId,
        encounterId: _draft.encounterId,
        ingredient: wire.Coding(
          code: _draft.ingredientCode,
          display: _draft.ingredientDisplay,
        ),
        route: _draft.route,
        segments: [_segment()],
        indication: _draft.indication,
        overrides: [
          for (final entry in _answers.entries)
            if (entry.value.trim().isNotEmpty)
              wire.OverrideAnswer(ruleId: entry.key, reason: entry.value),
        ],
      );

      final prescription = response.prescription;
      _findings = [
        for (final finding in prescription.findings) presentedFindingOf(finding),
      ];
      _formulary = formularyNoticeOf(prescription);
      _failure = null;
      _rebuild();
      return prescription;
    } on ApiError catch (error) {
      _failure = error.message;
      _rebuild();
      return null;
    }
  }

  /// The one dose segment the composer builds.
  ///
  /// A structured dose only when there is a number and a unit to make one
  /// from. `validatePrescription` has already refused an amount that is not a
  /// plain decimal, but only where the unit made it a structured dose in the
  /// first place — so "abc" with no unit and a free-text dose beside it is a
  /// valid prescription, and the amount must not reach the wire as a number.
  wire.DoseSegment _segment() {
    final amount = double.tryParse(_draft.dose.amount.trim());
    final structured = amount != null && _draft.dose.unit.trim().isNotEmpty;
    return wire.DoseSegment(
      sequence: 1,
      dose: structured
          ? wire.Quantity(value: amount, unit: _draft.dose.unit)
          : null,
      freeTextDose: structured ? '' : _draft.dose.freeText,
    );
  }

  /// Verifies one prescription and refreshes the queue.
  Future<bool> verify(String prescriptionId, {String note = ''}) async {
    try {
      await _medication.verifyPrescription(
        prescriptionId: prescriptionId,
        note: note,
      );
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
      _rebuild();
      return false;
    }
    await loadQueue();
    return true;
  }
}
