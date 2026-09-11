import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/auth/keystore_secure_store.dart';

/// Keystore binding (P0-09, SRS-IAM-002).
///
/// The platform channel cannot run in a unit test, so what is tested here is
/// everything around it: the hardening options, the namespacing, and the fact
/// that clearing the app's credentials does not reach into entries another
/// package put in the same keystore.
///
/// The options matter as much as the logic. `encryptedSharedPreferences: false`
/// is a one-word change between a credential held behind a Keystore key and a
/// credential in a readable XML file, and it is exactly the line somebody
/// flips to make a build work on an old emulator.

/// In-memory stand-in for the platform channel.
///
/// `noSuchMethod` absorbs the members this test does not exercise, so the fake
/// does not have to track every method the plugin adds.
class FakeSecureStorage implements FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      values[key];

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    values.remove(key);
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      Map<String, String>.from(values);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('KeystoreSecureStore', () {
    test('stores credentials under the app namespace', () async {
      final fake = FakeSecureStorage();
      final store = KeystoreSecureStore(storage: fake);

      await store.write('session_token', 'abc123');

      expect(fake.values.keys, ['health.session_token']);
      expect(await store.read('session_token'), 'abc123');
    });

    test('reads and deletes through the same namespace', () async {
      final fake = FakeSecureStorage();
      final store = KeystoreSecureStore(storage: fake);

      await store.write('session_token', 'abc123');
      await store.delete('session_token');

      expect(await store.read('session_token'), isNull);
      expect(fake.values, isEmpty);
    });

    test('clear removes only this app\'s entries', () async {
      final fake = FakeSecureStorage();
      // Another package's entry in the same keystore. deleteAll() would take
      // this with it, which on iOS means signing the user out of an unrelated
      // app that shares a keychain group.
      fake.values['com.other.app.token'] = 'not ours';

      final store = KeystoreSecureStore(storage: fake);
      await store.write('session_token', 'abc123');
      await store.write('refresh_token', 'def456');

      await store.clear();

      expect(fake.values, {'com.other.app.token': 'not ours'});
    });

    test('a missing credential reads as null rather than throwing', () async {
      final store = KeystoreSecureStore(storage: FakeSecureStorage());
      expect(await store.read('never_written'), isNull);
    });

    test('Android entries go behind an encrypted store', () {
      expect(
        KeystoreSecureStore.androidOptions.params['encryptedSharedPreferences'],
        'true',
        reason: 'without this the credential lands in a readable XML file',
      );
    });

    test('iOS entries are device-bound and unlock-gated', () {
      expect(
        KeystoreSecureStore.iosOptions.params['accessibility'],
        'first_unlock_this_device',
        reason: 'a token restored onto a replacement handset from a backup is '
            'a session nobody authenticated',
      );
    });
  });
}
