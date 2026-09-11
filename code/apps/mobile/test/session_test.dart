import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/auth/secure_store.dart';
import 'package:health_mobile/src/auth/session.dart';
import 'package:health_mobile/src/gen/healthcare/identity_access/v1/identity.pb.dart';

SessionContext contextFor(String tenantId, {List<String> permissions = const []}) {
  return SessionContext(
    subjectId: 'user-1',
    tenantId: tenantId,
    permissions: permissions,
  );
}

void main() {
  group('SessionManager', () {
    test('stores the token in the secure store, not in the clear', () async {
      final store = InMemorySecureStore();
      final session = SessionManager(store);

      await session.signIn(token: 'tenant-a:user-1:tenant_admin', context: contextFor('tenant-a'));

      expect(session.isSignedIn, isTrue);
      expect(await store.read('session.token'), 'tenant-a:user-1:tenant_admin');
    });

    test('restores the token on cold start', () async {
      final store = InMemorySecureStore();
      await SessionManager(store).signIn(token: 'tok', context: contextFor('tenant-a'));

      final restored = SessionManager(store);
      expect(await restored.restoreToken(), 'tok');
    });

    // Permissions are server-authoritative and can change while the app is
    // closed. Caching them across restarts would leave a revoked user with a
    // stale menu.
    test('does not restore the context, only the token', () async {
      final store = InMemorySecureStore();
      await SessionManager(store).signIn(
        token: 'tok',
        context: contextFor('tenant-a', permissions: ['organization.facility.create']),
      );

      final restored = SessionManager(store);
      await restored.restoreToken();

      expect(restored.context, isNull);
      expect(restored.isSignedIn, isFalse,
          reason: 'a restored token alone is not a session until the server confirms it');
      expect(restored.can('organization.facility.create'), isFalse);
    });

    test('sign-out clears every stored credential', () async {
      final store = InMemorySecureStore();
      final session = SessionManager(store);
      await session.signIn(token: 'tok', context: contextFor('tenant-a'));

      await session.signOut();

      expect(session.isSignedIn, isFalse);
      expect(session.token, isNull);
      expect(store.length, 0, reason: 'a stale credential must not survive sign-out');
    });

    test('can() reflects only granted permissions', () async {
      final session = SessionManager(InMemorySecureStore());
      await session.signIn(
        token: 'tok',
        context: contextFor('tenant-a', permissions: ['organization.facility.read']),
      );

      expect(session.can('organization.facility.read'), isTrue);
      expect(session.can('organization.facility.create'), isFalse);
    });

    test('an unauthenticated manager grants nothing', () {
      final session = SessionManager(InMemorySecureStore());
      expect(session.can('organization.facility.read'), isFalse);
    });
  });
}
