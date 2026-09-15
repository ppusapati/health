/// Server-side paging for large worklists (SRS-WEB-005).
///
/// The requirement asks for "server-side pagination/filter/sort and stable
/// cursor or equivalent", and the word that matters is *stable*. A page number
/// is not stable: a worklist that grows while a user is reading it shifts every
/// row down, and page two then repeats rows from page one and skips others. In
/// a clinical worklist the skipped row is a patient nobody sees.
///
/// On a phone this compounds. The interaction is infinite scroll rather than
/// numbered pages, so a duplicate row is visible and a skipped row is not — the
/// user has no way to notice what is missing. So the cursor is opaque and comes
/// from the server, the client never constructs one, and a page that arrives
/// with rows it has already seen is deduplicated rather than appended.
library;

/// One page of results, as the server returned it.
class Page<T> {
  const Page({required this.items, required this.nextPageToken});

  final List<T> items;

  /// Opaque. Empty means there is no further page. The client never parses,
  /// increments or constructs this.
  final String nextPageToken;

  bool get hasMore => nextPageToken.isNotEmpty;
}

/// Accumulates pages into the list a scrolling view shows.
///
/// Deduplicates by identity, because at-least-once paging is normal: a retried
/// request after a lost response returns rows the caller already has, and
/// appending them produces a list with the same patient twice.
class PagedList<T> {
  /// The function must return a stable server-side id, never an index — an index
  /// is exactly what shifts when the list grows underneath the reader.
  PagedList(this._identify);

  final String Function(T) _identify;
  final List<T> _items = [];
  final Set<String> _seen = {};

  String _nextPageToken = '';
  bool _loading = false;
  bool _exhausted = false;

  List<T> get items => List.unmodifiable(_items);
  bool get isLoading => _loading;

  /// True when the server has said there is nothing further.
  bool get isExhausted => _exhausted;

  /// True when the list has loaded and found nothing — distinct from not
  /// having loaded yet, which looks identical on screen and means the opposite.
  bool get isEmptyResult => _exhausted && _items.isEmpty;

  /// The token to send with the next request.
  String get pageToken => _nextPageToken;

  /// Merges a page in, ignoring rows already present.
  ///
  /// Returns how many rows were new, so a caller can tell a page that added
  /// nothing from one that added rows — a server paging bug shows up here as a
  /// page that is never exhausted and never grows.
  int absorb(Page<T> page) {
    var added = 0;
    for (final item in page.items) {
      final id = _identify(item);
      if (_seen.add(id)) {
        _items.add(item);
        added++;
      }
    }
    _nextPageToken = page.nextPageToken;
    _exhausted = !page.hasMore;
    _loading = false;
    return added;
  }

  /// Marks a request in flight, and refuses to start a second one.
  ///
  /// Infinite scroll fires its trigger repeatedly while the user is still
  /// moving, and without this the same page is requested three times and the
  /// cursor advances three times — which skips two pages of patients.
  bool beginLoad() {
    if (_loading || _exhausted) return false;
    _loading = true;
    return true;
  }

  /// Abandons an in-flight request after a failure, so a retry may start.
  void failLoad() {
    _loading = false;
  }

  /// Clears everything, for a filter or sort change.
  ///
  /// A filter change invalidates the cursor — it was issued against a different
  /// query — so keeping the rows and continuing to page would interleave two
  /// result sets.
  void reset() {
    _items.clear();
    _seen.clear();
    _nextPageToken = '';
    _loading = false;
    _exhausted = false;
  }
}
