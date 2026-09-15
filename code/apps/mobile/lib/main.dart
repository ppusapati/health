/// Unified Healthcare Platform — Flutter shell (Wave 0, P0-09).
///
/// The reference authenticated journey: sign in, resolve the server-side
/// session context, list facilities through the canonical contract, and queue
/// work when the device is offline.
library;

import 'package:flutter/material.dart';

import 'src/api/api_error.dart';
import 'src/api/connect_client.dart';
import 'src/api/organization_client.dart';
import 'src/auth/keystore_secure_store.dart';
import 'src/auth/session.dart';
import 'src/config/environment.dart';
import 'src/drafts/guard.dart';
import 'src/gen/healthcare/organization/v1/organization.pb.dart';
import 'src/offline/file_queue_storage.dart';
import 'src/offline/operation_queue.dart';
import 'src/ui/app_shell.dart';
import 'src/ui/states.dart';
import 'src/workspace/navigation.dart';

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
      final confirmed = await _confirmDiscard(decision);
      if (!confirmed) return;
    }

    await widget.session.signOut();
    if (!mounted) return;
    setState(() {
      _facilities = const [];
      _error = null;
      _loaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session.context;

    return MaterialApp(
      navigatorKey: _navigator,
      title: 'Unified Healthcare Platform',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1C5FD6)),
      home: AppShell(
        config: widget.config,
        title: 'Facilities',
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
        child: widget.session.isSignedIn ? _facilityList() : _signInForm(),
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

  /// Asks before discarding unsaved work.
  ///
  /// The drafts are named. "You have unsaved changes" is not enough to decide
  /// with: the user has to know whether the thing they are about to lose is a
  /// search box or a progress note.
  Future<bool> _confirmDiscard(GuardDecision decision) async {
    final navigator = _navigator.currentContext;
    if (navigator == null) return false;

    final confirmed = await showDialog<bool>(
      context: navigator,
      builder: (context) => AlertDialog(
        key: const Key('discard-drafts'),
        title: const Text('Sign out and discard unsaved work?'),
        content: Text(describe(decision)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay signed in'),
          ),
          // Destructive, so it is not the default action and does not read like
          // one.
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard and sign out'),
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
