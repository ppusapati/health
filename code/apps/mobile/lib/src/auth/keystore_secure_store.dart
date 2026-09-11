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
              aOptions: androidOptions,
              iOptions: iosOptions,
            );

  /// Android hardening.
  ///
  /// EncryptedSharedPreferences puts the entry behind a Keystore-held key
  /// rather than a plain XML file. Named rather than inlined so a test can
  /// assert it: this is a one-word difference between a credential in the
  /// hardware keystore and a credential in a readable file, and it is the kind
  /// of line that gets flipped to make a build work on an old emulator.
  ///
  /// Requires API 23; android/app/build.gradle.kts pins minSdk accordingly.
  static const androidOptions = AndroidOptions(encryptedSharedPreferences: true);

  /// iOS hardening.
  ///
  /// first_unlock_this_device means the credential is usable only after the
  /// first unlock following a boot, and — the "this device" half — never leaves
  /// the device in an iCloud or encrypted iTunes backup. A session token
  /// restored onto a replacement handset from a backup is a session nobody
  /// authenticated.
  static const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  final FlutterSecureStorage _storage;

  /// Namespace prefix, so a future feature cannot collide with the session.
  static const prefix = 'health.';

  @override
  Future<String?> read(String key) => _storage.read(key: '$prefix$key');

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: '$prefix$key', value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: '$prefix$key');

  @override
  Future<void> clear() async {
    // Deletes only this app's namespaced entries. deleteAll() would also
    // remove entries another package stored in the same keystore.
    final all = await _storage.readAll();
    for (final key in all.keys) {
      if (key.startsWith(prefix)) {
        await _storage.delete(key: key);
      }
    }
  }
}
