/// The clinical document lifecycle, as a screen has to obey it
/// (UX-W1-02, SRS-CLN-008, SRS-CLN-009).
///
/// One rule shapes everything: signed content cannot be edited in place. There
/// is no UpdateNote for a signed document — only Amend, which supersedes it,
/// and Addendum, which adds without contradicting. Both produce a new document
/// pointing back at the old one, and the old one stays readable, because
/// somebody may have read and acted on it.
///
/// The server enforces that. What this module does is make the screen agree
/// with it *before* the click, so a clinician is never offered an Edit button
/// that will be refused — and, more importantly, is never offered one on a note
/// they have already signed, which is the moment they would assume the edit is
/// invisible.
///
/// The distinction between an amendment and an addendum is the one clinicians
/// get wrong, so the screen makes it explicit rather than inferring it. An
/// amendment says "what I wrote was wrong"; an addendum says "here is something
/// that arrived later". A discharge summary corrected because the date was
/// mistyped is an amendment. The same summary with a histology result that came
/// back a week later is an addendum. Recording one as the other misrepresents
/// whether the original was ever true.
library;

import 'package:meta/meta.dart';

/// Mirrors clinical.v1.DocumentStatus, plus one member the wire does not have.
enum DocumentStatus {
  draft,
  signed,
  amended,
  addendum,
  enteredInError,
  unspecified,

  /// A status this build cannot name. Everything is refused for it, which is
  /// the only safe reading of "the record is in a state I do not understand".
  unrecognised,
}

/// Mirrors clinical.v1.SignatureMeaning.
enum SignatureMeaning {
  author,
  verifier,
  cosigner,
  witness,
  transcriber,
  unspecified,
  unrecognised,
}

/// Human label for a document status.
String describeDocumentStatus(DocumentStatus status) => switch (status) {
      DocumentStatus.draft => 'Draft',
      DocumentStatus.signed => 'Signed',
      DocumentStatus.amended => 'Amended',
      DocumentStatus.addendum => 'Addendum',
      // Not "deleted". The document is retained because somebody may have read
      // and acted on it, and a record that can vanish proves nothing.
      DocumentStatus.enteredInError => 'Entered in error',
      DocumentStatus.unspecified => 'Unknown',
      DocumentStatus.unrecognised => 'Status not recognised by this app',
    };

/// True when a signature finalises the document.
///
/// A transcriber typed what somebody else dictated and is not asserting the
/// clinical content (SRS-CLN-016), so their signature finalises nothing — the
/// clinician still has to review and sign. Treating it as a signature is how a
/// dictated note reaches the record with nobody clinically accountable for it.
bool finalises(SignatureMeaning meaning) =>
    meaning == SignatureMeaning.author ||
    meaning == SignatureMeaning.verifier ||
    meaning == SignatureMeaning.cosigner;

/// One signature on a document.
@immutable
class DocumentSignature {
  const DocumentSignature({
    required this.subjectId,
    required this.meaning,
    required this.signedAt,
  });

  final String subjectId;
  final SignatureMeaning meaning;
  final DateTime signedAt;
}

/// A document as the screen reads it.
@immutable
class ChartDocument {
  const ChartDocument({
    required this.documentId,
    required this.title,
    required this.status,
    required this.authoredBy,
    required this.createdAt,
    this.kind = '',
    this.amendsId = '',
    this.addsToId = '',
    this.changeReason = '',
    this.retractionReason = '',
    this.dictated = false,
    this.signatures = const [],
    this.intact = true,
    this.confidentiality = '',
  });

  final String documentId;
  final String title;
  final String kind;
  final DocumentStatus status;
  final String authoredBy;
  final DateTime createdAt;

  /// Non-empty when this document supersedes another.
  final String amendsId;

  /// Non-empty when this document adds to another.
  final String addsToId;

  final String changeReason;
  final String retractionReason;

  /// True when the note was dictated rather than typed (SRS-CLN-016).
  final bool dictated;

  final List<DocumentSignature> signatures;

  /// False when the stored content no longer hashes to what was signed
  /// (SRS-CLN-009).
  final bool intact;

  final String confidentiality;

  /// True when at least one signature finalises this document.
  bool get finalised => signatures.any((s) => finalises(s.meaning));
}

/// What may be done to a document from here.
@immutable
class DocumentActions {
  const DocumentActions({
    this.edit = false,
    this.sign = false,
    this.amend = false,
    this.addendum = false,
    this.retract = false,
    this.blockedReason = '',
  });

  /// Editing the text in place. Only ever true for a draft.
  final bool edit;

  /// Signing, which finalises it.
  final bool sign;

  /// Correcting something that was wrong.
  final bool amend;

  /// Adding something that arrived later.
  final bool addendum;

  /// Marking it entered in error. Retained, never deleted.
  final bool retract;

  /// Why nothing may be done, when nothing may be.
  final String blockedReason;

  /// True when the screen has nothing to offer.
  bool get none => !edit && !sign && !amend && !addendum && !retract;
}

/// What the screen may offer for this document.
///
/// [mayWrite] is passed in rather than decided here because "may I amend
/// somebody else's note" is a policy the server owns. This only decides what to
/// render, and renders the narrower thing when in doubt.
DocumentActions actionsFor(
  ChartDocument document, {
  required bool mayWrite,
}) {
  if (!mayWrite) {
    return const DocumentActions(
      blockedReason: 'You have read-only access to this record.',
    );
  }

  if (!document.intact) {
    // The stored content no longer matches what was signed. Everything is
    // refused: amending it would produce a new document derived from content
    // nobody vouched for, which is worse than refusing.
    return const DocumentActions(
      blockedReason: 'This document no longer matches what was signed. '
          'It has been reported; do not amend or rely on it.',
    );
  }

  return switch (document.status) {
    DocumentStatus.draft => const DocumentActions(
        edit: true,
        sign: true,
        // A draft nobody has read can be abandoned, but it is still retracted
        // rather than deleted — a draft that was visible to the care team for
        // an hour was still visible.
        retract: true,
      ),
    DocumentStatus.signed ||
    DocumentStatus.amended ||
    DocumentStatus.addendum =>
      const DocumentActions(
        // No edit. This is the whole rule.
        amend: true,
        addendum: true,
        retract: true,
      ),
    DocumentStatus.enteredInError => const DocumentActions(
        blockedReason: 'This document is marked entered in error. It is kept '
            'for the record and cannot be changed further.',
      ),
    DocumentStatus.unspecified || DocumentStatus.unrecognised =>
      const DocumentActions(
        blockedReason: 'This document is in a state this app does not '
            'recognise. Open it on a desktop before changing anything.',
      ),
  };
}

/// Why a correction is being made.
enum CorrectionKind { amendment, addendum }

/// What the screen needs to describe a correction before it is made.
@immutable
class CorrectionGuidance {
  const CorrectionGuidance({
    required this.title,
    required this.detail,
    required this.reasonRequired,
  });

  final String title;
  final String detail;

  /// True when a reason is mandatory before the action may be submitted.
  final bool reasonRequired;
}

/// Explains the two kinds of correction in the terms the choice is about.
///
/// Deliberately not "Amend" and "Addendum" alone: those are the words the
/// record uses, not the question the clinician is answering. The question is
/// whether what they wrote was wrong or whether something has since arrived.
CorrectionGuidance describeCorrection(CorrectionKind kind) =>
    switch (kind) {
      CorrectionKind.amendment => const CorrectionGuidance(
          title: 'Correct what this note says',
          detail: 'Use this when the note was wrong. The original stays '
              'readable and is marked as superseded, because somebody may '
              'have acted on it.',
          // Required. An amendment with no reason leaves the next reader
          // unable to tell whether the original was a typing slip or a
          // clinical reversal, and those have very different consequences.
          reasonRequired: true,
        ),
      CorrectionKind.addendum => const CorrectionGuidance(
          title: 'Add something that arrived later',
          detail: 'Use this when the note was right and there is more to say '
              '— a result that came back, a conversation after discharge. '
              'The original is unchanged.',
          reasonRequired: false,
        ),
    };

/// One section of a draft.
@immutable
class DraftSection {
  const DraftSection({required this.heading, required this.text});
  final String heading;
  final String text;
}

/// Whether a draft may be signed, and what is missing.
@immutable
class SignReadiness {
  const SignReadiness({required this.ready, required this.problems});
  final bool ready;

  /// One sentence per problem, in the order they should be fixed.
  final List<String> problems;
}

/// Checks a draft before offering to sign it.
///
/// Signing is the irreversible step — after it the note can only be superseded,
/// never edited — so the screen checks what it can before the click rather than
/// letting the server refuse afterwards. The checks are deliberately about
/// completeness, not content: whether a note is clinically adequate is not
/// something a phone can assess, and pretending otherwise would be worse than
/// not trying.
SignReadiness readyToSign({
  required String title,
  required List<DraftSection> sections,
  required String templateVersion,
  required String patientId,
  required String encounterId,
}) {
  final problems = <String>[
    if (patientId.trim().isEmpty) 'This note is not attached to a patient.',
    if (encounterId.trim().isEmpty) 'This note is not attached to an encounter.',
    if (title.trim().isEmpty) 'Give the note a title.',
    // An empty signed note is worse than no note: it reads as an assessment
    // that found nothing worth recording.
    if (!sections.any((s) => s.text.trim().isNotEmpty))
      'The note has no content.',
    // SRS-CLN-002: the saved note references the exact template version.
    // Without it a note cannot be re-rendered as it was written once the
    // template changes.
    if (templateVersion.trim().isEmpty)
      'The note is not linked to a template version.',
  ];

  return SignReadiness(ready: problems.isEmpty, problems: problems);
}
