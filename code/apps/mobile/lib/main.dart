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
import 'src/gen/healthcare/organization/v1/organization.pb.dart';
import 'src/offline/file_queue_storage.dart';
import 'src/offline/operation_queue.dart';
import 'src/ui/app_shell.dart';

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
  ));
}

class HealthApp extends StatefulWidget {
  const HealthApp({
    super.key,
    required this.config,
    required this.session,
    required this.queue,
  });

  final AppConfig config;
  final SessionManager session;
  final OperationQueue queue;

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

  List<Facility> _facilities = const [];
  Map<QueuedStatus, int>? _queueCounts;
  ApiError? _error;
  bool _busy = false;

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
      });
    } on ApiError catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  Future<void> _signOut() async {
    await widget.session.signOut();
    if (!mounted) return;
    setState(() {
      _facilities = const [];
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unified Healthcare Platform',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1C5FD6)),
      home: AppShell(
        config: widget.config,
        title: 'Facilities',
        session: widget.session.context,
        queueCounts: _queueCounts,
        onSignOut: widget.session.isSignedIn ? _signOut : null,
        child: widget.session.isSignedIn ? _facilityList() : _signInForm(),
      ),
    );
  }

  Widget _signInForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) _ErrorBanner(error: _error!),
          const Text('Development tokens take the form tenantId:subjectId:role.'),
          const SizedBox(height: 12),
          TextField(
            controller: _tokenController,
            decoration: const InputDecoration(labelText: 'Token', border: OutlineInputBorder()),
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy ? null : _signIn,
            child: Text(_busy ? 'Signing in…' : 'Sign in'),
          ),
        ],
      ),
    );
  }

  Widget _facilityList() {
    if (_facilities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) _ErrorBanner(error: _error!),
            const Text('No facilities to show.'),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (_error != null) Padding(padding: const EdgeInsets.all(12), child: _ErrorBanner(error: _error!)),
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
                  subtitle: Text('${facility.code} · ${facility.timeZone}'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Persistent failure banner carrying the correlation ID for support.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.error});

  final ApiError error;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('error-banner'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEB),
        border: Border.all(color: const Color(0xFFE9B0AB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(error.message, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            'Reference: ${error.code}'
            '${error.correlationId.isEmpty ? '' : ' · ${error.correlationId}'}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
