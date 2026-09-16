/// Typed client for healthcare.scheduling.v1.AppointmentService.
///
/// The reception desk's half of scheduling: what the queue looks like now, who
/// is expected, and checking somebody in. Booking, rescheduling, waitlists and
/// recurring series are desk work with a keyboard and stay on the web.
library;

import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../gen/healthcare/scheduling/v1/appointment.pb.dart';
import 'connect_client.dart';

class SchedulingClient {
  SchedulingClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.scheduling.v1.AppointmentService';

  /// The queue as the server has it, with the arithmetic behind the estimate.
  ///
  /// The estimate comes back rather than being computed here on purpose: the
  /// board has to be able to say *why* a wait is forty minutes, and "four
  /// ahead at ten minutes each" is something a patient can judge.
  Future<GetQueueResponse> getQueue({
    required String facilityId,
    String resourceId = '',
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/GetQueue',
      request: GetQueueRequest(
        facilityId: facilityId,
        resourceId: resourceId,
        pageSize: pageSize,
      ),
      parse: GetQueueResponse.fromBuffer,
    );
  }

  /// The appointments expected in a window.
  ///
  /// Fetched alongside the queue, never instead of it: the queue holds the
  /// people who have arrived, and a board built from it alone shows an empty
  /// clinic at nine in the morning.
  Future<ListAppointmentsResponse> listAppointments({
    required String facilityId,
    required DateTime from,
    required DateTime until,
    int pageSize = 200,
  }) {
    return _connect.unary(
      procedure: '$_service/ListAppointments',
      request: ListAppointmentsRequest(
        facilityId: facilityId,
        from: Timestamp.fromDateTime(from.toUtc()),
        until: Timestamp.fromDateTime(until.toUtc()),
        pageSize: pageSize,
      ),
      parse: ListAppointmentsResponse.fromBuffer,
    );
  }

  /// Checks a patient in.
  ///
  /// Carries no expected version, and that is the server's design rather than
  /// an omission here: the appointment's own state machine refuses a second
  /// check-in, so a stale screen produces a refusal rather than a double
  /// entry. A priority above standard requires its reason, because a walk-in
  /// put to the front without one is indistinguishable from queue-jumping.
  Future<CheckInResponse> checkIn({
    required String appointmentId,
    String token = '',
    ArrivalMode arrivalMode = ArrivalMode.ARRIVAL_MODE_UNSPECIFIED,
    Priority priority = Priority.PRIORITY_UNSPECIFIED,
    String priorityReason = '',
  }) {
    return _connect.unary(
      procedure: '$_service/CheckIn',
      request: CheckInRequest(
        appointmentId: appointmentId,
        token: token,
        arrivalMode: arrivalMode,
        priority: priority,
        priorityReason: priorityReason,
      ),
      parse: CheckInResponse.fromBuffer,
    );
  }
}
