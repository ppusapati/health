import 'package:flutter_test/flutter_test.dart';

import 'package:health_mobile/src/api/pagination.dart';

class Row {
  const Row(this.id);
  final String id;
}

void main() {
  PagedList<Row> list() => PagedList<Row>((row) => row.id);

  group('accumulating pages', () {
    test('appends rows and follows the server\'s cursor', () {
      final paged = list();
      paged.beginLoad();
      paged.absorb(const Page(items: [Row('a'), Row('b')], nextPageToken: 'cur-1'));

      expect(paged.items.map((r) => r.id), ['a', 'b']);
      expect(paged.pageToken, 'cur-1');
      expect(paged.isExhausted, isFalse);
    });

    test('deduplicates rows it has already seen', () {
      // At-least-once paging is normal: a retried request after a lost
      // response returns rows the caller already has, and appending them puts
      // the same patient on the list twice.
      final paged = list();
      paged.beginLoad();
      paged.absorb(const Page(items: [Row('a'), Row('b')], nextPageToken: 'cur-1'));
      paged.beginLoad();
      final added =
          paged.absorb(const Page(items: [Row('b'), Row('c')], nextPageToken: ''));

      expect(added, 1);
      expect(paged.items.map((r) => r.id), ['a', 'b', 'c']);
    });

    test('is exhausted when the server sends no further cursor', () {
      final paged = list();
      paged.beginLoad();
      paged.absorb(const Page(items: [Row('a')], nextPageToken: ''));
      expect(paged.isExhausted, isTrue);
      expect(paged.beginLoad(), isFalse, reason: 'nothing further to ask for');
    });
  });

  group('empty and not-yet-loaded', () {
    test('are different states', () {
      // They look identical on screen and mean the opposite things: one is a
      // quiet worklist, the other is a request that has not returned.
      final paged = list();
      expect(paged.isEmptyResult, isFalse, reason: 'nothing has loaded yet');

      paged.beginLoad();
      paged.absorb(const Page(items: [], nextPageToken: ''));
      expect(paged.isEmptyResult, isTrue);
    });
  });

  group('overlapping requests', () {
    test('refuses a second load while one is in flight', () {
      // Infinite scroll fires its trigger repeatedly while the user is still
      // moving. Without this the same page is requested three times and the
      // cursor advances three times, skipping two pages of patients.
      final paged = list();
      expect(paged.beginLoad(), isTrue);
      expect(paged.beginLoad(), isFalse);
      expect(paged.isLoading, isTrue);
    });

    test('allows a retry after a failure', () {
      final paged = list();
      paged.beginLoad();
      paged.failLoad();
      expect(paged.beginLoad(), isTrue);
    });

    test('clears the in-flight flag when a page arrives', () {
      final paged = list();
      paged.beginLoad();
      paged.absorb(const Page(items: [Row('a')], nextPageToken: 'cur-1'));
      expect(paged.isLoading, isFalse);
      expect(paged.beginLoad(), isTrue);
    });
  });

  group('changing the query', () {
    test('resets everything, because the cursor belongs to the old query', () {
      // Keeping the rows and continuing to page would interleave two result
      // sets.
      final paged = list();
      paged.beginLoad();
      paged.absorb(const Page(items: [Row('a')], nextPageToken: 'cur-1'));

      paged.reset();
      expect(paged.items, isEmpty);
      expect(paged.pageToken, isEmpty);
      expect(paged.isExhausted, isFalse);
      expect(paged.isEmptyResult, isFalse);
    });

    test('forgets what it had seen, so the new query may return the same rows', () {
      final paged = list();
      paged.beginLoad();
      paged.absorb(const Page(items: [Row('a')], nextPageToken: ''));
      paged.reset();
      paged.beginLoad();
      final added = paged.absorb(const Page(items: [Row('a')], nextPageToken: ''));
      expect(added, 1);
    });
  });
}
