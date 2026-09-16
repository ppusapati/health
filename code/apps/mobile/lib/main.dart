/// Unified Healthcare Platform — Flutter shell (Wave 0, P0-09).
///
/// The reference authenticated journey: sign in, resolve the server-side
/// session context, list facilities through the canonical contract, and queue
/// work when the device is offline.
library;

import 'package:flutter/material.dart';

import 'src/api/api_error.dart';
import 'src/api/connect_client.dart';
import 'src/api/idempotency.dart';
import 'src/api/empi_client.dart';
import 'src/api/nursing_client.dart';
import 'src/api/organization_client.dart';
import 'src/auth/keystore_secure_store.dart';
import 'src/auth/session.dart';
import 'src/config/environment.dart';
import 'src/drafts/guard.dart';
import 'src/gen/healthcare/organization/v1/organization.pb.dart';
import 'src/offline/file_queue_storage.dart';
import 'src/offline/operation_queue.dart';
import 'src/ui/app_shell.dart';
import 'src/meds/round_controller.dart';
import 'src/patient/caseload.dart';
import 'src/patient/caseload_controller.dart';
import 'src/api/scheduling_client.dart';
import 'src/api/clinical_client.dart';
import 'src/api/billing_client.dart';
import 'src/api/orders_client.dart';
import 'src/billing/billing_controller.dart';
import 'src/chart/chart_controller.dart';
import 'src/reception/reception_controller.dart';
import 'src/screens/patient_picker_screen.dart';
import 'src/orders/orders_controller.dart';
import 'src/screens/billing_screen.dart';
import 'src/screens/chart_screen.dart';
import 'src/screens/orders_screen.dart';
import 'src/screens/reception_screen.dart';
import 'src/screens/medication_round_screen.dart';
import 'src/screens/ward_worklist_screen.dart';
import 'src/ui/states.dart';
import 'src/ward/ward_controller.dart';
import 'src/workspace/navigation.dart';
import 'src/workspace/router.dart';

void main() {
  final config = AppConfig.fromEnvironment();

  // Platform bindings are chosen here, at the single composition point, rather
  // than being reached for from feature code. Both are the real durable
  // implementations: an in-memory fallback would appear to work while storing
  // nothing, which is the worst of both outcomes.
  runApp(HealthApp(
    config: config,
    session: SessionManager(KeystoreSecureStore()),
    queue: OperationQueue(FileQueueStorage()),
    // One registry for the whole application rather than one observer per
    // screen: per-screen observers are removed inconsistently, and the ones
    // that leak keep prompting after their screen is gone.
    drafts: DraftRegistry(),
  ));
}

class HealthApp extends StatefulWidget {
  const HealthApp({
    super.key,
    required this.config,
    required this.session,
    required this.queue,
    required this.drafts,
  });

  final AppConfig config;
  final SessionManager session;
  final OperationQueue queue;

  /// Work the user has started and not committed (SRS-CLN-017 applied to the
  /// shell). Consulted before the shell takes the screen away from them.
  final DraftRegistry drafts;

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  late final ConnectClient _connect = ConnectClient(
    baseUrl: widget.config.apiBaseUrl,
    credentials: () => widget.session.token,
  );
  late final OrganizationClient _organization = OrganizationClient(_connect);
  late final IdentityClient _identity = IdentityClient(_connect);
  late final NursingClient _nursing = NursingClient(_connect);
  late final EmpiClient _empi = EmpiClient(_connect);
  late final SchedulingClient _scheduling = SchedulingClient(_connect);
  late final ClinicalClient _clinical = ClinicalClient(_connect);
  late final ChartController _chart = ChartController(_clinical);
  late final OrdersClient _orders = OrdersClient(_connect);
  late final BillingClient _billingClient = BillingClient(_connect);
  late final BillingController _billing =
      BillingController(_billingClient, newIdempotencyKey);
  late final OrdersController _ordering =
      OrdersController(_orders, _clinical, DateTime.now);
  late final CaseloadController _caseload = CaseloadController(_nursing, _empi);
  late final ReceptionController _reception =
      ReceptionController(_scheduling, _empi, DateTime.now);

  late final WardController _ward =
      WardController(_nursing, DateTime.now, newIdempotencyKey);
  late final RoundController _round = RoundController(
      _nursing, widget.queue, DateTime.now, newIdempotencyKey);

  /// Where the shell currently is. Not a Navigator stack: a ward tablet has no
  /// browser history and no deep links, and the destinations are a short list
  /// chosen from a drawer.
  Destination _destination = Destination.facilities;

  /// The route the drawer asked for that nothing answers to, if any. Reported
  /// rather than silently redirected — see `workspace/router.dart`.
  String? _unknownRoute;

  /// Who the clinical screens are about, and how they came to be chosen.
  ///
  /// Null until a patient is picked, which is why both screens open in their
  /// "choose a patient" state rather than showing an empty list.
  PatientSelection? _patient;

  final _tokenController = TextEditingController();

  /// Needed because this state sits above the [MaterialApp] it builds, so its
  /// own context has no Navigator and no Material localizations. A dialog shown
  /// from here would fail at the moment it is needed most — on the way out,
  /// with unsaved work on screen.
  final _navigator = GlobalKey<NavigatorState>();

  List<Facility> _facilities = const [];
  Map<QueuedStatus, int>? _queueCounts;
  ApiError? _error;
  bool _busy = false;

  /// Whether a facility request has come back at least once.
  ///
  /// Without this, "no facilities" and "not asked yet" are the same empty list,
  /// and SRS-WEB-006 separates them precisely because they mean opposite things
  /// to the person looking at the screen.
  bool _loaded = false;

  @override
  void dispose() {
    _connect.close();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    final candidateToken = _tokenController.text;
    if (candidateToken.trim().isEmpty) {
      // Refused here rather than sent: an empty token produces an
      // unauthenticated response that reads as a server problem.
      setState(() {
        _busy = false;
        _error = ApiError(
          status: ApiStatus.invalidArgument,
          code: 'TOKEN_REQUIRED',
          correlationId: '',
          fieldViolations: const {'token': 'REQUIRED'},
        );
      });
      return;
    }

    try {
      // The context is resolved with the candidate token before the session is
      // established, so a rejected token never produces a half-signed-in state
      // with a stored credential.
      final response = await _identity.getSessionContext(withToken: candidateToken);
      await widget.session.signIn(token: candidateToken, context: response.session);
      await _loadFacilities();
    } on ApiError catch (error) {
      await widget.session.signOut();
      setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _loadFacilities() async {
    try {
      final response = await _organization.listFacilities();
      final counts = await widget.queue.counts();
      if (!mounted) return;
      setState(() {
        _facilities = response.facilities;
        _queueCounts = counts;
        _error = null;
        _loaded = true;
      });
    } on ApiError catch (error) {
      if (!mounted) return;
      // Deliberately not clearing `_loaded`: a failed refresh of a list that
      // loaded a moment ago should not make the screen claim it never asked.
      setState(() => _error = error);
    }
  }

  Future<void> _signOut() async {
    // Signing out is the one navigation the shell itself performs, and the one
    // that loses the most: it clears the credential, so an unsaved note is not
    // recoverable afterwards by signing back in.
    final decision = widget.drafts.evaluateNavigation(const SignOut());
    if (decision.prompt || decision.blocked) {
      final confirmed = await _confirmDiscard(
        decision,
        title: 'Sign out and discard unsaved work?',
        stay: 'Stay signed in',
        proceed: 'Discard and sign out',
      );
      if (!confirmed) return;
    }

    await widget.session.signOut();
    if (!mounted) return;
    setState(() {
      _facilities = const [];
      _error = null;
      _loaded = false;
      // Back to the landing screen. Leaving the shell on a ward screen would
      // show the next person to pick the tablet up the shape of the last one's
      // work before they have signed in.
      _destination = Destination.facilities;
      _unknownRoute = null;
      // The next person to pick the tablet up must not inherit a patient.
      _patient = null;
    });
  }

  /// Handles a drawer tap.
  ///
  /// The guard runs before the screen changes, not after. A route change with
  /// a half-entered observation behind it is the most ordinary way to lose
  /// clinical work, and the answer here is acted on rather than logged.
  Future<void> _navigate(String route) async {
    final decision = decideNavigation(route: route, drafts: widget.drafts);

    if (decision.guard.blocked) {
      await _explainRefusal(decision.guard);
      return;
    }
    if (decision.guard.prompt) {
      final confirmed = await _confirmDiscard(
        decision.guard,
        title: 'Leave and discard unsaved work?',
        // The words name the action being taken. A dialog that offers to sign
        // the nurse out when they tapped a different screen is a dialog they
        // will answer wrongly, or stop reading.
        stay: 'Stay here',
        proceed: 'Discard and leave',
      );
      if (!confirmed) return;
    }

    if (!mounted) return;
    setState(() {
      _unknownRoute = decision.unknownRoute ? route : null;
      if (decision.destination != null) _destination = decision.destination!;
    });

    // The picker is the one screen that fetches on arrival. The clinical
    // screens are about a patient, and loading them before one is chosen would
    // be asking the server about nobody.
    if (decision.destination == Destination.patients) await _loadCaseload();
    if (decision.destination == Destination.reception) await _loadBoard();
    if (decision.destination == Destination.chart) await _loadChart();
    if (decision.destination == Destination.orders) await _loadInbox();
    if (decision.destination == Destination.billing) await _loadAccount();
  }

  /// Opens a patient.
  ///
  /// Switching patients is the navigation the draft guard refuses rather than
  /// prompts: a half-entered observation saved against the wrong chart is the
  /// hazard, and there is no wording of "are you sure" that makes it safe.
  Future<void> _openPatient(PatientSelection selection) async {
    if (_patient != null && _patient!.patientId != selection.patientId) {
      final decision =
          widget.drafts.evaluateNavigation(PatientSwitch(selection.patientId));
      if (decision.blocked) {
        await _explainRefusal(decision);
        return;
      }
      if (decision.prompt) {
        final confirmed = await _confirmDiscard(
          decision,
          title: 'Open a different patient and discard unsaved work?',
          stay: 'Stay with this patient',
          proceed: 'Discard and open',
        );
        if (!confirmed) return;
      }
    }

    if (!mounted) return;
    setState(() {
      _patient = selection;
      _destination = Destination.ward;
    });
    await _loadPatient();
  }

  /// Loads both clinical screens for the chosen patient.
  Future<void> _loadPatient() async {
    final patient = _patient;
    final session = widget.session.context;
    if (patient == null || session == null) return;

    final now = DateTime.now();
    await _ward.load(encounterId: patient.encounterId);
    await _round.load(
      encounterId: patient.encounterId,
      patientId: patient.patientId,
      facilityId: session.activeFacilityId,
      // The round in front of the nurse: an hour either side of now, which is
      // long enough to catch a dose running late and short enough not to show
      // tomorrow's.
      from: now.subtract(const Duration(hours: 1)),
      to: now.add(const Duration(hours: 1)),
    );
    if (mounted) setState(() {});
  }

  /// Loads the reception board for the facility this session is working in.
  Future<void> _loadBoard() async {
    final session = widget.session.context;
    if (session == null) return;
    await _reception.loadBoard(facilityId: session.activeFacilityId);
    if (mounted) setState(() {});
  }

  /// Loads the billing account for the open patient.
  ///
  /// The account id is the patient's own here. A deployment that bills a
  /// guarantor separately would resolve it through the encounter instead, and
  /// the controller takes it as an argument for exactly that reason.
  Future<void> _loadAccount() async {
    final patient = _patient;
    if (patient == null) return;
    await _billing.load(accountId: patient.patientId);
    if (mounted) setState(() {});
  }

  /// Loads the ward-wide critical-result inbox.
  ///
  /// No patient argument: the inbox is deliberately not scoped to whoever is
  /// open, because the results that matter are the ones nobody is looking at.
  Future<void> _loadInbox() async {
    await _ordering.loadInbox();
    if (mounted) setState(() {});
  }

  /// Loads the chart for the open patient.
  ///
  /// mayWrite comes from the session's permissions rather than from a role
  /// name: roles are renamed and permissions are what the server actually
  /// checks, so a screen branching on the first would drift from the second.
  Future<void> _loadChart() async {
    final patient = _patient;
    if (patient == null) return;
    await _chart.load(
      patientId: patient.patientId,
      encounterId: patient.encounterId,
      mayWrite: widget.session.context?.permissions
              .contains('clinical.note.write') ??
          false,
    );
    if (mounted) setState(() {});
  }

  Future<void> _loadCaseload() async {
    final session = widget.session.context;
    if (session == null) return;
    await _caseload.load(nurseId: session.subjectId);
    if (mounted) setState(() {});
  }

  Future<void> _scan(String barcode) async {
    final selection = await _caseload.scan(barcode);
    if (!mounted) return;
    if (selection == null) {
      // The problem is on the picker's own view; nothing else to do.
      setState(() {});
      return;
    }
    await _openPatient(selection);
  }

  /// The screen the current destination names.
  Widget _screen() {
    if (!widget.session.isSignedIn) return _signInForm();

    final unknown = _unknownRoute;
    if (unknown != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.failure,
          title: 'That screen is not in this build.',
          // The route, because the person who can fix it is the one who wrote
          // the catalogue entry, and they need to know which one.
          detail: 'Nothing answers to $unknown.',
        ),
      );
    }

    return switch (_destination) {
      Destination.facilities => _facilityList(),
      Destination.patients => PatientPickerScreen(
          view: _caseload.view,
          loading: _caseload.loading,
          failure: _caseload.failure,
          onRetry: _loadCaseload,
          onSelect: _openPatient,
          onScan: _scan,
          onSearch: (name) async {
            await _caseload.search(name);
            if (mounted) setState(() {});
          },
        ),
      Destination.ward => WardWorklistScreen(
          view: _ward.view,
          loading: _ward.loading,
          failure: _ward.failure,
          onRetry: _loadPatient,
        ),
      Destination.medicationRound => MedicationRoundScreen(
          view: _round.view,
          loading: _round.loading,
          failure: _round.failure,
          onRetry: _loadPatient,
        ),
      Destination.billing => BillingScreen(
          view: _billing.view,
          loading: _billing.loading,
          failure: _billing.failure,
          onRetry: _loadAccount,
          onAmountChanged: (typed) {
            _billing.setAmount(typed);
            setState(() {});
          },
          onMethodChanged: (method) {
            _billing.setMethod(method);
            setState(() {});
          },
          onTakePayment: () async {
            await _billing.takePayment();
            if (mounted) setState(() {});
          },
        ),
      Destination.orders => OrdersScreen(
          view: _ordering.view,
          loading: _ordering.loading,
          failure: _ordering.failure,
          onRetry: _loadInbox,
          onIndicationChanged: (text) {
            _ordering.setIndication(text);
            setState(() {});
          },
          onOverrideReasonChanged: (text) {
            _ordering.setOverrideReason(text);
            setState(() {});
          },
          onAcknowledgeDuplicate: (candidate) {
            _ordering.acknowledgeDuplicate(candidate.orderId);
            setState(() {});
          },
          onPlace: () async {
            await _ordering.place();
            if (mounted) setState(() {});
          },
          onAcknowledgeResult: (item, action) async {
            await _ordering.acknowledgeResult(
              observationId: item.observationId,
              action: action,
            );
            if (mounted) setState(() {});
          },
        ),
      Destination.chart => ChartScreen(
          view: _chart.view,
          loading: _chart.loading,
          failure: _chart.failure,
          onRetry: _loadChart,
          onSign: (document) async {
            await _chart.sign(document);
            await _loadChart();
          },
        ),
      Destination.reception => ReceptionScreen(
          view: _reception.view,
          loading: _reception.loading,
          failure: _reception.failure,
          onRetry: _loadBoard,
          onSearch: (criteria) async {
            await _reception.search(criteria);
            if (mounted) setState(() {});
          },
          onAcknowledge: (match) {
            _reception.acknowledge(match.patientId);
            setState(() {});
          },
          onCheckIn: (row) async {
            await _reception.checkIn(
              appointmentId: row.appointmentId,
              facilityId: widget.session.context?.activeFacilityId ?? '',
            );
            if (mounted) setState(() {});
          },
          onOpenCandidate: (match) => _openPatient(
            PatientSelection(
              patientId: match.patientId,
              // No encounter yet: reception reaches a record, not a visit. The
              // clinical screens ask the server for the open encounter when
              // they load, and a made-up one here would be worse than none.
              encounterId: '',
              displayName: match.displayName,
              // Not a scan, so identity is not verified — the eMAR's barcode
              // gate reads this and must not be told otherwise because the
              // route happened to come through reception.
              method: SelectionMethod.search,
            ),
          ),
        ),
    };
  }

  String _title() => switch (_destination) {
        Destination.facilities => 'Facilities',
        Destination.patients => 'My patients',
        Destination.ward => 'Ward worklist',
        Destination.medicationRound => 'Medication round',
        Destination.reception => 'Reception',
        Destination.chart => 'Chart',
        Destination.orders => 'Orders',
        Destination.billing => 'Billing',
      };

  @override
  Widget build(BuildContext context) {
    final session = widget.session.context;

    return MaterialApp(
      navigatorKey: _navigator,
      title: 'Unified Healthcare Platform',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1C5FD6)),
      home: AppShell(
        config: widget.config,
        title: _title(),
        session: widget.session.context,
        queueCounts: _queueCounts,
        onSignOut: widget.session.isSignedIn ? _signOut : null,
        // Built from the permissions the server reported for this session, so
        // a role change takes effect on the next sign-in without a release.
        //
        // Both catalogues, because a ward nurse and an administrator use the
        // same build; the permission filter is what makes them different
        // screens, not a different binary.
        workspace: session == null
            ? null
            : buildWorkspace(
                mergeCatalogues(const [waveZeroCatalogue, wardCatalogue]),
                session.permissions,
              ),
        onNavigate: _navigate,
        child: _screen(),
      ),
    );
  }

  Widget _signInForm() {
    final error = _error;
    final tokenViolation = error?.fieldViolations['token'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null && tokenViolation == null) ...[
            _stateFor(error, onRetry: null),
            const SizedBox(height: 16),
          ],
          const ScreenState(
            kind: ScreenStateKind.awaitingInput,
            title: 'Sign in to continue',
            detail: 'Development tokens take the form tenantId:subjectId:role.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              labelText: 'Token',
              // Outlined in the error colour as well as described below it.
              // Colour alone is not a message: it says nothing to a screen
              // reader and nothing to the third of male staff who will read the
              // red border as grey.
              border: const OutlineInputBorder(),
              enabledBorder: tokenViolation == null
                  ? null
                  : const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF7A1C17), width: 2),
                    ),
            ),
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
          if (tokenViolation != null)
            FieldError(
              fieldLabel: 'Token',
              message: describeFieldReason(tokenViolation),
            ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: FilledButton(
              onPressed: _busy ? null : _signIn,
              child: Text(_busy ? 'Signing in\u2026' : 'Sign in'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _facilityList() {
    final error = _error;

    if (!_loaded && _facilities.isEmpty && error == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading facilities\u2026',
        ),
      );
    }

    if (_facilities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: error != null
            ? _stateFor(error, onRetry: _loadFacilities)
            : const ScreenState(
                kind: ScreenStateKind.empty,
                title: 'No facilities to show',
                detail: 'No facility has been added to this tenant yet.',
              ),
      );
    }

    return Column(
      children: [
        // A list that loaded and then failed to refresh keeps showing the rows
        // it has, with the failure above them. Replacing the list would throw
        // away information the user can still act on.
        if (error != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: _stateFor(error, onRetry: _loadFacilities),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadFacilities,
            child: ListView.separated(
              itemCount: _facilities.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final facility = _facilities[index];
                return ListTile(
                  title: Text(facility.displayName),
                  subtitle: Text('${facility.code} \u00b7 ${facility.timeZone}'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Says why a navigation was refused outright.
  ///
  /// Refused rather than prompted, so there is one button: the answer is not a
  /// choice. Saving an observation against the wrong chart is the hazard, and
  /// no wording of "are you sure" makes it safe.
  Future<void> _explainRefusal(GuardDecision decision) async {
    final navigator = _navigator.currentContext;
    if (navigator == null) return;

    await showDialog<void>(
      context: navigator,
      builder: (context) => AlertDialog(
        key: const Key('navigation-blocked'),
        title: const Text('Finish this first'),
        content: Text(describe(decision)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay here'),
          ),
        ],
      ),
    );
  }

  /// Asks before discarding unsaved work.
  ///
  /// The drafts are named. "You have unsaved changes" is not enough to decide
  /// with: the user has to know whether the thing they are about to lose is a
  /// search box or a progress note.
  Future<bool> _confirmDiscard(
    GuardDecision decision, {
    required String title,
    required String stay,
    required String proceed,
  }) async {
    final navigator = _navigator.currentContext;
    if (navigator == null) return false;

    final confirmed = await showDialog<bool>(
      context: navigator,
      builder: (context) => AlertDialog(
        key: const Key('discard-drafts'),
        title: Text(title),
        content: Text(describe(decision)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(stay),
          ),
          // Destructive, so it is not the default action and does not read like
          // one.
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(proceed),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Renders a failure as the state it actually is.
  ///
  /// The distinctions matter to the reader: a permission refusal calls for an
  /// administrator, a conflict calls for a reload, and a transient failure calls
  /// for the retry button. Rendering all three as a red box tells the user only
  /// that something is wrong.
  Widget _stateFor(ApiError error, {required VoidCallback? onRetry}) {
    final kind = switch (error.status) {
      ApiStatus.permissionDenied => ScreenStateKind.permissionDenied,
      ApiStatus.aborted => ScreenStateKind.conflict,
      _ => ScreenStateKind.failure,
    };

    // A refusal is not retryable by definition: the same request gets the same
    // answer, and a button that does nothing teaches the user to ignore
    // buttons. The caller passes an action only for reads, which are safe to
    // repeat; the rest of the decision is here.
    final offersRetry = onRetry != null && kind != ScreenStateKind.permissionDenied;

    return ScreenState(
      kind: kind,
      title: error.message,
      // The correlation ID is what support asks for first, so it is on the
      // screen rather than only in a log the user cannot reach.
      detail: 'Reference: ${error.code}'
          '${error.correlationId.isEmpty ? '' : ' \u00b7 ${error.correlationId}'}',
      onRetry: offersRetry ? onRetry : null,
      retryLabel: kind == ScreenStateKind.conflict ? 'Reload' : 'Try again',
    );
  }
}
