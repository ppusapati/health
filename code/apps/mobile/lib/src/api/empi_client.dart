/// Typed client for healthcare.empi.v1.PatientService.
///
/// Two callers with different needs. A ward device finds the patient in front
/// of it; a reception desk searches before creating and then registers. Merge
/// and unmerge stay on the web — reconciling two records is a seated job with
/// two charts open, and a phone is the worst possible place to do it.
library;

import '../gen/healthcare/empi/v1/patient.pb.dart';
import 'connect_client.dart';

class EmpiClient {
  EmpiClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.empi.v1.PatientService';

  /// Looks a patient up by the identifier on their wristband.
  ///
  /// A separate method from the general search, with a page size of two rather
  /// than one. One would make a duplicated identifier look like a clean match,
  /// and a duplicate is exactly the fault a bedside must not resolve by
  /// guessing — so the caller is given enough to see that there is more than
  /// one.
  Future<SearchPatientsResponse> findByIdentifier({
    required String identifierValue,
    IdentifierType type = IdentifierType.IDENTIFIER_TYPE_UNSPECIFIED,
    String system = '',
  }) {
    return _connect.unary(
      procedure: '$_service/SearchPatients',
      request: SearchPatientsRequest(
        identifierValue: identifierValue,
        identifierType: type,
        identifierSystem: system,
        pageSize: 2,
      ),
      parse: SearchPatientsResponse.fromBuffer,
    );
  }

  /// The reception search: every criterion the desk can type.
  ///
  /// Separate from [searchByName] because the caller is different. A ward
  /// device looking for the patient in front of it wants one field; a desk
  /// asking "have we seen this person before" wants all of them, and the
  /// answer to that question is what stands between the index and a duplicate.
  Future<SearchPatientsResponse> searchPatients({
    String name = '',
    String phone = '',
    String identifierValue = '',
    PartialDate? birthDate,
    int pageSize = 20,
  }) {
    return _connect.unary(
      procedure: '$_service/SearchPatients',
      request: SearchPatientsRequest(
        name: name,
        phone: phone,
        identifierValue: identifierValue,
        birthDate: birthDate,
        pageSize: pageSize,
      ),
      parse: SearchPatientsResponse.fromBuffer,
    );
  }

  /// Registers a patient, naming the duplicates the user was shown.
  ///
  /// [acknowledgedDuplicatePatientIds] is not bookkeeping: the server refuses a
  /// probable duplicate unless the caller lists the ids it has seen, so an
  /// empty list here is how a genuinely new patient is registered and a
  /// populated one is a receptionist saying "I looked at those, this is
  /// somebody else". The screen's gate makes that refusal comprehensible; it
  /// is not what enforces it.
  Future<RegisterPatientResponse> registerPatient({
    required Demographics demographics,
    List<PatientIdentifier> identifiers = const [],
    List<String> acknowledgedDuplicatePatientIds = const [],
  }) {
    return _connect.unary(
      procedure: '$_service/RegisterPatient',
      request: RegisterPatientRequest(
        demographics: demographics,
        identifiers: identifiers,
        acknowledgedDuplicatePatientIds: acknowledgedDuplicatePatientIds,
      ),
      parse: RegisterPatientResponse.fromBuffer,
    );
  }

  /// Finds a patient by name, for a band that is missing or unreadable.
  Future<SearchPatientsResponse> searchByName({
    required String name,
    int pageSize = 20,
  }) {
    return _connect.unary(
      procedure: '$_service/SearchPatients',
      request: SearchPatientsRequest(name: name, pageSize: pageSize),
      parse: SearchPatientsResponse.fromBuffer,
    );
  }
}
