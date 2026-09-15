import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'package:health_mobile/src/print/document.dart';

void main() {
  setUpAll(tzdata.initializeTimeZones);

  DocumentIdentity ident({
    String documentId = 'doc-1',
    int version = 3,
    String zone = 'Asia/Kolkata',
  }) =>
      DocumentIdentity(
        documentId: documentId,
        version: version,
        authoredAt: DateTime.utc(2026, 9, 12, 20, 0),
        facilityZone: zone,
        authorName: 'Dr Rao',
      );

  const template = TemplateVersion(templateId: 'discharge', version: 'v4');
  final printedAt = DateTime.utc(2026, 9, 15, 6, 0);

  group('the identity block', () {
    test('carries the document, its version and its author', () {
      // By the time a page is produced in evidence, what is printed on it is
      // the only way to establish what it is.
      final footer = buildFooter(
        identity: ident(),
        template: template,
        signature: null,
        printedAt: printedAt,
      );
      expect(footer.documentReference, contains('doc-1'));
      expect(footer.documentReference, contains('v3'));
      expect(footer.documentReference, contains('Dr Rao'));
      expect(footer.templateReference, contains('discharge'));
      expect(footer.templateReference, contains('v4'));
    });

    test('keeps the printed time distinct from the authored time', () {
      // A single date on a page is always read as the clinical date, and on a
      // reprint it would be wrong.
      final footer = buildFooter(
        identity: ident(),
        template: template,
        signature: null,
        printedAt: printedAt,
      );
      expect(footer.documentReference, contains('13 Sep 2026'));
      expect(footer.printedAt, contains('15 Sep 2026'));
      expect(footer.printedAt, startsWith('Printed'));
    });

    test('renders both times on the facility clock, named', () {
      final footer = buildFooter(
        identity: ident(zone: 'Asia/Kolkata'),
        template: template,
        signature: null,
        printedAt: printedAt,
      );
      expect(footer.documentReference, contains('IST'));
      expect(footer.printedAt, contains('IST'));
    });
  });

  group('refusing to produce a page', () {
    test('without a document id', () {
      expect(
        () => buildFooter(
          identity: ident(documentId: '  '),
          template: template,
          signature: null,
          printedAt: printedAt,
        ),
        throwsA(isA<UnprintableDocumentError>()),
      );
    });

    test('without a version', () {
      // More dangerous than no document: it looks authoritative and cannot be
      // checked against the record.
      expect(
        () => buildFooter(
          identity: ident(version: 0),
          template: template,
          signature: null,
          printedAt: printedAt,
        ),
        throwsA(isA<UnprintableDocumentError>()),
      );
    });

    test('without the template that laid it out', () {
      for (final bad in [
        const TemplateVersion(templateId: '', version: 'v4'),
        const TemplateVersion(templateId: 'discharge', version: ''),
      ]) {
        expect(
          () => buildFooter(
            identity: ident(),
            template: bad,
            signature: null,
            printedAt: printedAt,
          ),
          throwsA(isA<UnprintableDocumentError>()),
        );
      }
    });
  });

  group('signed and unsigned pages', () {
    test('an unsigned page is watermarked as a draft', () {
      // A phone's share sheet strips every other clue that a page is not final.
      final footer = buildFooter(
        identity: ident(),
        template: template,
        signature: null,
        printedAt: printedAt,
      );
      expect(footer.draftWatermark, contains('DRAFT'));
      expect(footer.signatureBlock, isNull);
    });

    test('a signed page carries the signer, the time and a content digest', () {
      final footer = buildFooter(
        identity: ident(),
        template: template,
        signature: DocumentSignature(
          signedBy: 'Dr Rao',
          signedAt: DateTime.utc(2026, 9, 13, 4, 0),
          contentSha256: 'a1b2c3d4e5f60718293a4b5c6d7e8f90',
        ),
        printedAt: printedAt,
      );
      expect(footer.draftWatermark, isNull);
      expect(footer.signatureBlock, contains('Dr Rao'));
      expect(footer.signatureBlock, contains('a1b2c3d4e5f60718'));
      // Truncated for legibility; the full digest is in the record.
      expect(footer.signatureBlock, isNot(contains('293a4b5c6d7e8f90')));
    });

    test('does not crash on a digest shorter than the truncation', () {
      final footer = buildFooter(
        identity: ident(),
        template: template,
        signature: DocumentSignature(
          signedBy: 'Dr Rao',
          signedAt: DateTime.utc(2026, 9, 13, 4, 0),
          contentSha256: 'abc',
        ),
        printedAt: printedAt,
      );
      expect(footer.signatureBlock, contains('abc'));
    });
  });

  group('checking a re-presented page against the record', () {
    Reconciliation check(int printed, int current, {String id = 'doc-1'}) =>
        reconcile(
          printedDocumentId: id,
          printedVersion: printed,
          currentDocumentId: 'doc-1',
          currentVersion: current,
        );

    test('recognises the current version', () {
      final result = check(3, 3);
      expect(result.isCurrent, isTrue);
      expect(result.reason, ReconcileReason.current);
    });

    test('distinguishes superseded from a different document', () {
      // They call for different responses: one is an old copy, the other is
      // somebody else's page.
      expect(check(2, 3).reason, ReconcileReason.superseded);
      expect(check(3, 3, id: 'doc-9').reason, ReconcileReason.differentDocument);
    });

    test('flags a page claiming a version the record does not have', () {
      // Either the record was restored from a backup or the page is not
      // genuine; both need a human.
      final result = check(9, 3);
      expect(result.isCurrent, isFalse);
      expect(result.reason, ReconcileReason.unknownVersion);
    });
  });
}
