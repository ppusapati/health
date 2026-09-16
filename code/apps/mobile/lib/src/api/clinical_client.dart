/// Typed client for healthcare.clinical.v1.ClinicalService.
///
/// The chart as a clinician reads it at a bedside, plus the two writes that
/// belong there: signing a note and correcting one. Recording new problems and
/// allergies stays on the web — those are coded entries chosen from a
/// terminology picker, and a picker is the control a phone does worst.
library;

import '../gen/healthcare/clinical/v1/clinical.pb.dart';
import 'connect_client.dart';

class ClinicalClient {
  ClinicalClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.clinical.v1.ClinicalService';

  /// The notes on a chart.
  ///
  /// Drafts are included by default: a clinician's own unfinished note is the
  /// one they came back for, and hiding it makes them write a second.
  Future<ListNotesResponse> listNotes({
    required String patientId,
    String encounterId = '',
    bool includeDrafts = true,
    int pageSize = 50,
  }) {
    return _connect.unary(
      procedure: '$_service/ListNotes',
      request: ListNotesRequest(
        patientId: patientId,
        encounterId: encounterId,
        includeDrafts: includeDrafts,
        pageSize: pageSize,
      ),
      parse: ListNotesResponse.fromBuffer,
    );
  }

  /// The allergy panel.
  ///
  /// `activeOnly` is deliberately false: a refuted allergy has to stay
  /// visible, because deleting the fact that the question was asked and
  /// settled is how the next clinician asks again.
  Future<ListAllergiesResponse> listAllergies({
    required String patientId,
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/ListAllergies',
      request: ListAllergiesRequest(
        patientId: patientId,
        activeOnly: false,
        pageSize: pageSize,
      ),
      parse: ListAllergiesResponse.fromBuffer,
    );
  }

  /// The problem list, resolved entries included for the same reason.
  Future<ListProblemsResponse> listProblems({
    required String patientId,
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/ListProblems',
      request: ListProblemsRequest(
        patientId: patientId,
        activeOnly: false,
        pageSize: pageSize,
      ),
      parse: ListProblemsResponse.fromBuffer,
    );
  }

  /// Results, optionally narrowed to one code for a trend.
  Future<ListObservationsResponse> listObservations({
    required String patientId,
    String encounterId = '',
    String code = '',
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/ListObservations',
      request: ListObservationsRequest(
        patientId: patientId,
        encounterId: encounterId,
        code: code,
        pageSize: pageSize,
      ),
      parse: ListObservationsResponse.fromBuffer,
    );
  }

  /// Signs a note, which finalises it.
  Future<SignNoteResponse> signNote({
    required String documentId,
    required SignatureMeaning meaning,
  }) {
    return _connect.unary(
      procedure: '$_service/SignNote',
      request: SignNoteRequest(documentId: documentId, meaning: meaning),
      parse: SignNoteResponse.fromBuffer,
    );
  }

  /// Amends or adds to a note.
  ///
  /// One RPC with an `addendum` flag rather than two, which is the contract's
  /// shape — so the distinction the clinician was asked to make is carried
  /// explicitly rather than implied by which method was called.
  Future<AmendNoteResponse> amendNote({
    required String documentId,
    required String title,
    required List<Section> sections,
    required bool addendum,
    String reason = '',
  }) {
    return _connect.unary(
      procedure: '$_service/AmendNote',
      request: AmendNoteRequest(
        documentId: documentId,
        title: title,
        sections: sections,
        reason: reason,
        addendum: addendum,
      ),
      parse: AmendNoteResponse.fromBuffer,
    );
  }
}
