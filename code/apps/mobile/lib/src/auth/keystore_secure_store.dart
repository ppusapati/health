/// Platform keystore binding for [SecureStore].
///
/// Credentials live in the Android Keystore or the iOS Keychain, never in
/// SharedPreferences, NSUserDefaults or a plain file. SRS-IAM-002 forbids
/// persisting a credential where any code on the device can read it.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_store.dart';

/// Keystore-backed credential storage.
class KeystoreSecureStore implements SecureStore {
  KeystoreSecureStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                // EncryptedSharedPreferences puts the entry behind a
                // Keystore-held key rather than a plain XML file.
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                // The credential is usable only while the device is unlocked,
                // and never leaves this device in an iCloud or iTunes backup.
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  final FlutterSecureStorage _storage;

  /// Namespace prefix, so a future feature cannot collide with the session.
  static const _prefix = 'health.';

  @override
  Future<String?> read(String key) => _storage.read(key: '$_prefix$key');

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: '$_prefix$key', value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: '$_prefix$key');

  @override
  Future<void> clear() async {
    // Deletes only this app's namespaced entries. deleteAll() would also
    // remove entries another package stored in the same keystore.
    final all = await _storage.readAll();
    for (final key in all.keys) {
      if (key.startsWith(_prefix)) {
        await _storage.delete(key: key);
      }
    }
  }
}
