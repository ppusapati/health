# Flutter shell (P0-09)

The mobile foundation: authentication, environment configuration, networking
against the canonical contracts, credential storage and the offline queue.

## What is here

| Area | Location |
|---|---|
| Generated clients | `lib/src/gen/` — from `proto/`, never hand-edited |
| Connect transport | `lib/src/api/connect_client.dart` |
| Error presentation | `lib/src/api/api_error.dart` |
| Session and credentials | `lib/src/auth/` |
| Offline queue and sync | `lib/src/offline/` |
| App shell | `lib/src/ui/app_shell.dart` |

## Gate A9

The Svelte and Flutter shells consume the same canonical contracts. Both are
generated from `proto/`, and `test/connect_client_test.dart` asserts the
procedure path the Dart client calls matches the proto package exactly.

## Running

```bash
flutter pub get
flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080 \
  --dart-define=ENVIRONMENT=development
```

`10.0.2.2` is the host loopback as seen from the Android emulator.

## Regenerating clients

```bash
dart pub global activate protoc_plugin
buf generate --template buf.gen.dart.yaml
```

Well-known types are **not** generated into this tree — `package:protobuf` 6.x
ships them, and a second local copy produces two incompatible `Timestamp`
types.

## Outstanding

These are real gaps, not oversights, and are tracked in
`docs/engineering/wave-0-status.md`:

- **`SecureStore` has no platform binding yet.** The interface is defined and
  the session uses it, but `main.dart` wires `InMemorySecureStore`. Credentials
  therefore do not survive a restart and are not in the keystore. This must be
  bound to the platform keystore before any build reaches a real device —
  `SRS-IAM-002` is not satisfied until it is.
- **`QueueStorage` likewise has only an in-memory implementation.** The queue
  logic and its ordering guarantees are tested, but the durable device-side
  store is not written, so queued work does not survive a restart.
- **No device build has been run.** The package analyses cleanly and the unit
  and widget tests pass, but `flutter build apk` / `ipa` has not been executed,
  so the Android and iOS toolchain configuration is unverified.
- **Biometric re-authentication, certificate pinning and jailbreak/root
  detection** are not implemented. They belong with the identity provider
  decision (ADR-008).
