/// Typed client for healthcare.medication.v1.MedicationService.
///
/// Prescribing, the live therapy list, and the pharmacist's verification
/// queue. Formulary administration, interaction-rule authoring and dose rules
/// stay on the web: those are configuration, written once and carefully by
/// somebody sitting down, and a ward tablet is the wrong place to edit the
/// rules that guard prescribing.
library;

import '../gen/healthcare/medication/v1/medication.pb.dart';
import 'connect_client.dart';

class MedicationClient {
  MedicationClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.medication.v1.MedicationService';

  /// Writes a prescription.
  ///
  /// [overrides] is empty on a first attempt: that is how the safety findings
  /// reach the prescriber at all. The server evaluates the rules, refuses, and
  /// the screen puts the reasons it gets back on the second attempt.
  Future<PrescribeResponse> prescribe({
    required String patientId,
    required String encounterId,
    required Coding ingredient,
    required String route,
    required List<DoseSegment> segments,
    String indication = '',
    String instructions = '',
    List<OverrideAnswer> overrides = const [],
  }) {
    return _connect.unary(
      procedure: '$_service/Prescribe',
      request: PrescribeRequest(
        patientId: patientId,
        encounterId: encounterId,
        ingredient: ingredient,
        route: route,
        segments: segments,
        indication: indication,
        instructions: instructions,
        overrides: overrides,
      ),
      parse: PrescribeResponse.fromBuffer,
    );
  }

  /// The medication on an encounter.
  ///
  /// [liveOnly] off by default, matching the service: a chart shows what was
  /// prescribed, not only what is still running.
  Future<ListPrescriptionsResponse> listPrescriptions({
    required String encounterId,
    bool liveOnly = false,
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/ListPrescriptions',
      request: ListPrescriptionsRequest(
        encounterId: encounterId,
        liveOnly: liveOnly,
        pageSize: pageSize,
      ),
      parse: ListPrescriptionsResponse.fromBuffer,
    );
  }

  /// What is waiting for a pharmacist.
  Future<VerificationQueueResponse> verificationQueue({
    String facilityId = '',
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/VerificationQueue',
      request: VerificationQueueRequest(
        facilityId: facilityId,
        pageSize: pageSize,
      ),
      parse: VerificationQueueResponse.fromBuffer,
    );
  }

  /// Verifies one prescription.
  Future<VerifyPrescriptionResponse> verifyPrescription({
    required String prescriptionId,
    String note = '',
  }) {
    return _connect.unary(
      procedure: '$_service/VerifyPrescription',
      request: VerifyPrescriptionRequest(
        prescriptionId: prescriptionId,
        note: note,
      ),
      parse: VerifyPrescriptionResponse.fromBuffer,
    );
  }
}
