/// Typed client for healthcare.empi.v1.PatientService.
///
/// Only what a ward device needs: finding the patient in front of you. The
/// registration and merge surfaces belong to reception, on a desk.
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
