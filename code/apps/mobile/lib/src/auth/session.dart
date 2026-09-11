/// Session state for the mobile shell.
library;

import '../gen/healthcare/identity_access/v1/identity.pb.dart';
import 'secure_store.dart';

/// Keys under which credentials are stored. Namespaced so a future feature
/// cannot collide with the session.
class _Keys {
  static const token = 'session.token';
  static const tenantId = 'session.tenant_id';
}

/// Holds the signed-in session.
///
/// The token lives only in the keystore and in memory for the life of the
/// process. Nothing here writes it to a log, an analytics event or a crash
/// report.
class SessionManager {
  SessionManager(this._store);

  final SecureStore _store;

  String? _token;
  SessionContext? _context;

  String? get token => _token;
  SessionContext? get context => _context;
  bool get isSignedIn => _token != null && _context != null;

  /// Restores a token from the keystore on cold start.
  ///
  /// The context is deliberately not restored: it is server-authoritative and
  /// may have changed while the app was closed, so it is re-fetched. Caching
  /// permissions across restarts would let a revoked user keep a stale menu.
  Future<String?> restoreToken() async {
    _token = await _store.read(_Keys.token);
    return _token;
  }

  /// Records a successful sign-in.
  Future<void> signIn({required String token, required SessionContext context}) async {
    _token = token;
    _context = context;
    await _store.write(_Keys.token, token);
    await _store.write(_Keys.tenantId, context.tenantId);
  }

  /// Updates the server-resolved context without touching the token.
  void updateContext(SessionContext context) => _context = context;

  /// Clears everything. Called on sign-out and on any authentication failure.
  Future<void> signOut() async {
    _token = null;
    _context = null;
    await _store.clear();
  }

  /// Whether the signed-in user holds a permission.
  ///
  /// Used only to avoid offering actions that will be refused. The server
  /// re-evaluates every call regardless (SRS-IAM-003).
  bool can(String permission) =>
      _context?.permissions.contains(permission) ?? false;
}
