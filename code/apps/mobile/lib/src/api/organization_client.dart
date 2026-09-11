/// Typed clients over the Connect transport.
///
/// Each method names the canonical procedure path from the proto package, so
/// the Flutter app and the Svelte app call literally the same endpoint
/// (Gate A9).
library;

import '../gen/healthcare/common/v1/common.pb.dart';
import '../gen/healthcare/identity_access/v1/identity.pb.dart';
import '../gen/healthcare/organization/v1/organization.pb.dart';
import 'connect_client.dart';

/// Client for healthcare.organization.v1.OrganizationService.
class OrganizationClient {
  OrganizationClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.organization.v1.OrganizationService';

  Future<ListFacilitiesResponse> listFacilities({
    int pageSize = 25,
    String pageToken = '',
  }) {
    return _connect.unary(
      procedure: '$_service/ListFacilities',
      request: ListFacilitiesRequest(
        page: PageRequest(pageSize: pageSize, pageToken: pageToken),
      ),
      parse: ListFacilitiesResponse.fromBuffer,
    );
  }

  /// Creates a facility.
  ///
  /// The request carries no tenant: tenancy comes from the token, so there is
  /// nothing here for a tampered client to escalate through (SRS-IAM-013).
  Future<CreateFacilityResponse> createFacility({
    required String code,
    required String displayName,
    required FacilityType type,
    required String timeZone,
    required String idempotencyKey,
  }) {
    return _connect.unary(
      procedure: '$_service/CreateFacility',
      request: CreateFacilityRequest(
        code: code,
        displayName: displayName,
        type: type,
        timeZone: timeZone,
      ),
      parse: CreateFacilityResponse.fromBuffer,
      idempotencyKey: idempotencyKey,
    );
  }
}

/// Client for healthcare.identity_access.v1.IdentityService.
class IdentityClient {
  IdentityClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.identity_access.v1.IdentityService';

  /// Resolves the caller's server-side context.
  ///
  /// [withToken] lets sign-in probe a candidate credential before it is stored,
  /// so a rejected token never leaves a half-established session behind.
  Future<GetSessionContextResponse> getSessionContext({String? withToken}) {
    return _connect.unary(
      procedure: '$_service/GetSessionContext',
      request: GetSessionContextRequest(),
      parse: GetSessionContextResponse.fromBuffer,
      overrideToken: withToken,
    );
  }
}
