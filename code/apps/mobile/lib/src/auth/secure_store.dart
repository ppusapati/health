/// Credential storage.
///
/// SRS-IAM-002 forbids persisting long-lived secrets where any code on the
/// device can read them. On mobile that means the platform keystore, never
/// SharedPreferences and never a plain file.
///
/// The interface exists so the shell can be tested without platform channels,
/// and so the concrete keystore binding is a single, reviewable place.
library;

/// Storage for values that must not be readable outside the app's keystore
/// entry.
abstract interface class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);

  /// Clears every stored credential. Called on sign-out and on any
  /// authentication failure, so a stale token cannot linger.
  Future<void> clear();
}

/// In-memory store for tests and for the widget preview.
///
/// It is deliberately NOT the default: a shell that silently falls back to
/// memory would appear to work while storing nothing.
class InMemorySecureStore implements SecureStore {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);

  @override
  Future<void> clear() async => _values.clear();

  /// Test helper: how many credentials are held.
  int get length => _values.length;
}
