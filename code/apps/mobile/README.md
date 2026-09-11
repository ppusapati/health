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

## Platform bindings

| Interface | Production binding | Requirement |
|---|---|---|
| `SecureStore` | `KeystoreSecureStore` — Android Keystore / iOS Keychain | SRS-IAM-002 |
| `QueueStorage` | `FileQueueStorage` — atomic writes to application support | SRS-NFR-013 |

Both are wired in `main.dart`. The in-memory implementations remain for tests
only: falling back to one at runtime would appear to work while storing
nothing.

## Outstanding

These are real gaps, not oversights, and are tracked in
`docs/engineering/wave-0-status.md`:

- **No device build has been run.** The package analyses cleanly and the unit
  and widget tests pass, but `flutter build apk` / `ipa` has not been executed,
  so the Android and iOS toolchain configuration is unverified.
- **Biometric re-authentication, certificate pinning and jailbreak/root
  detection** are not implemented. They belong with the identity provider
  decision (ADR-008).
