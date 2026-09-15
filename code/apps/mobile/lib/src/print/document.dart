/// Clinical print and share views (SRS-WEB-016, applied to mobile).
///
/// The verification clause is "printed representation references document
/// ID/version/date", and the reason is what happens to clinical documents once
/// they leave the system. They are faxed, scanned into another provider's
/// records, filed in a case bundle, and produced in evidence years later. By
/// then the only way to establish what a page is — and whether it is still
/// current — is what is printed on it.
///
/// A phone adds an exit the desktop does not have: the share sheet. A
/// screenshot or a PDF sent through a messaging app carries no chrome, no URL
/// and no session, so whatever identity the page does not contain is gone. That
/// makes the footer more important here, not less.
///
/// So a page carries its own identity, and one whose identity cannot be
/// established is not produced at all. A document with a missing version is
/// more dangerous than no document: it looks authoritative and cannot be
/// checked against the record.
library;

import 'package:meta/meta.dart';

import '../time/display.dart' as clock;

/// Identity of the source record, printed on every page.
@immutable
class DocumentIdentity {
  const DocumentIdentity({
    required this.documentId,
    required this.version,
    required this.authoredAt,
    required this.facilityZone,
    required this.authorName,
  });

  final String documentId;

  /// The record's version at the moment of printing.
  final int version;

  /// When the content was authored — not when it was printed.
  final DateTime authoredAt;

  /// The facility's zone, so the printed time means something specific.
  final String facilityZone;

  final String authorName;
}

/// A signature applied to the document, when it has one.
@immutable
class DocumentSignature {
  const DocumentSignature({
    required this.signedBy,
    required this.signedAt,
    required this.contentSha256,
  });

  final String signedBy;
  final DateTime signedAt;
  final String contentSha256;
}

/// The template that laid the document out.
@immutable
class TemplateVersion {
  const TemplateVersion({required this.templateId, required this.version});

  final String templateId;
  final String version;
}

/// Thrown when a document cannot be produced with a checkable identity.
class UnprintableDocumentError implements Exception {
  UnprintableDocumentError(this.message);
  final String message;

  @override
  String toString() => 'UnprintableDocumentError: $message';
}

/// The identity block that appears on every page.
@immutable
class PrintFooter {
  const PrintFooter({
    required this.documentReference,
    required this.templateReference,
    required this.printedAt,
    required this.signatureBlock,
    required this.draftWatermark,
  });

  final String documentReference;
  final String templateReference;
  final String printedAt;

  /// Null for an unsigned document.
  final String? signatureBlock;

  /// Non-null for an unsigned document, so a draft that escapes through the
  /// share sheet is visibly a draft.
  final String? draftWatermark;
}

/// Builds the identity block for a printed or shared document.
///
/// Refuses rather than degrading. Every check here is something a reader years
/// later would need and could not reconstruct.
PrintFooter buildFooter({
  required DocumentIdentity identity,
  required TemplateVersion template,
  required DocumentSignature? signature,
  required DateTime printedAt,
}) {
  if (identity.documentId.trim().isEmpty) {
    throw UnprintableDocumentError(
      'a printed document must carry its document id',
    );
  }
  if (identity.version <= 0) {
    // A document with no version looks authoritative and cannot be checked
    // against the record, which is worse than not producing it.
    throw UnprintableDocumentError(
      'document ${identity.documentId} has no version; a printed page that '
      'cannot be matched to a record version must not be produced',
    );
  }
  if (template.templateId.trim().isEmpty || template.version.trim().isEmpty) {
    throw UnprintableDocumentError(
      'a printed document must name the template version that laid it out',
    );
  }

  final authored = clock.clinical(identity.authoredAt, identity.facilityZone);

  return PrintFooter(
    documentReference: 'Document ${identity.documentId} v${identity.version} · '
        'authored $authored by ${identity.authorName}',
    templateReference: 'Template ${template.templateId} v${template.version}',
    // Distinct from the authored time and labelled as such. A single date on a
    // page is always read as the clinical date, and on a reprint it is wrong.
    printedAt: 'Printed ${clock.clinical(printedAt, identity.facilityZone)}',
    signatureBlock: signature == null
        ? null
        : 'Signed by ${signature.signedBy} on '
            '${clock.clinical(signature.signedAt, identity.facilityZone)} · '
            // Truncated for legibility; enough to detect a substituted page,
            // and the full digest is in the record.
            'content ${_shortDigest(signature.contentSha256)}',
    draftWatermark: signature == null ? 'DRAFT — NOT SIGNED' : null,
  );
}

String _shortDigest(String digest) =>
    digest.length <= 16 ? digest : digest.substring(0, 16);

/// Why a re-presented page does or does not match the record.
enum ReconcileReason { current, superseded, differentDocument, unknownVersion }

/// The result of checking a page against the record.
@immutable
class Reconciliation {
  const Reconciliation({required this.isCurrent, required this.reason});

  final bool isCurrent;
  final ReconcileReason reason;
}

/// Reports whether a printed page still matches the current record.
///
/// Used when a page is re-presented — scanned back in, photographed, or quoted
/// in a discussion — to establish whether it is the current version. Returns a
/// reason rather than a boolean because "superseded" and "from another
/// document" call for different responses.
Reconciliation reconcile({
  required String printedDocumentId,
  required int printedVersion,
  required String currentDocumentId,
  required int currentVersion,
}) {
  if (printedDocumentId != currentDocumentId) {
    return const Reconciliation(
      isCurrent: false,
      reason: ReconcileReason.differentDocument,
    );
  }
  if (printedVersion < currentVersion) {
    return const Reconciliation(
      isCurrent: false,
      reason: ReconcileReason.superseded,
    );
  }
  if (printedVersion > currentVersion) {
    // The page claims a version the record does not have. Either the record
    // was restored from a backup or the page is not genuine; both need a human.
    return const Reconciliation(
      isCurrent: false,
      reason: ReconcileReason.unknownVersion,
    );
  }
  return const Reconciliation(
    isCurrent: true,
    reason: ReconcileReason.current,
  );
}
