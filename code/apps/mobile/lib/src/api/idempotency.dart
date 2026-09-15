/// Client-generated idempotency keys (SRS-API-006).
///
/// The key is minted by the caller, before anything is sent, so a retry after a
/// lost response is deduplicated by the server rather than becoming a second
/// record — a second dose, in the case this shell most cares about.
///
/// A key is not a secret and does not need to be unguessable; it needs to be
/// unique across the devices on a ward for as long as the server remembers it.
/// 128 random bits from `Random.secure` gives that without a dependency, and
/// the timestamp prefix makes a key sortable and legible in a log when
/// somebody is working out what happened.
library;

import 'dart:math';

final _random = Random.secure();

/// Mints one key.
String newIdempotencyKey() {
  final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  final stamp = DateTime.now().toUtc().microsecondsSinceEpoch.toRadixString(16);
  return 'idem-$stamp-$hex';
}
