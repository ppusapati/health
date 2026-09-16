/// Wire types to the chart's models (UX-W1-02).
///
/// Same discipline as `reception/mapping.dart`, and the reasoning is there in
/// full: `protobuf.dart` decodes an enum value this build has never heard of as
/// the **zero member** and files the real tag under `unknownFields`, so a
/// `default:` arm can never run and the silent failure is the zero member's
/// meaning being applied to something else entirely.
///
/// The stakes here are the highest of the four workspaces. A document status
/// this build cannot read must not fall through to a lifecycle that offers an
/// Edit button, and an allergy criticality it cannot read must not render
/// beside the low-risk rows. Both are handled by an explicit `unrecognised`
/// member whose behaviour is defined to be the cautious one.
library;

import 'package:protobuf/protobuf.dart' as pb;

import '../gen/healthcare/clinical/v1/clinical.pb.dart' as wire;
import 'notes.dart';
import 'safety.dart';

/// Field tags carrying the enums this module reads. Pinned by test.
const int documentStatusField = 9; // clinical.v1.Document.status
const int allergyKindField = 5; // clinical.v1.Allergy.kind
const int allergyCriticalityField = 6; // clinical.v1.Allergy.criticality
const int allergyVerificationField = 7; // clinical.v1.Allergy.verification
const int problemStatusField = 6; // clinical.v1.Problem.status
const int interpretationField = 12; // clinical.v1.Observation.interpretation

/// True when [message] carried a value for [tag] this build could not read.
bool sentUnknownValueFor(pb.GeneratedMessage message, int tag) =>
    message.unknownFields.hasField(tag);

// ------------------------------------------------------------------- notes

DocumentStatus documentStatusOf(wire.Document document) {
  if (sentUnknownValueFor(document, documentStatusField)) {
    return DocumentStatus.unrecognised;
  }
  return switch (document.status) {
    wire.DocumentStatus.DOCUMENT_STATUS_DRAFT => DocumentStatus.draft,
    wire.DocumentStatus.DOCUMENT_STATUS_SIGNED => DocumentStatus.signed,
    wire.DocumentStatus.DOCUMENT_STATUS_AMENDED => DocumentStatus.amended,
    wire.DocumentStatus.DOCUMENT_STATUS_ADDENDUM => DocumentStatus.addendum,
    wire.DocumentStatus.DOCUMENT_STATUS_ENTERED_IN_ERROR =>
      DocumentStatus.enteredInError,
    wire.DocumentStatus.DOCUMENT_STATUS_UNSPECIFIED => DocumentStatus.unspecified,
    _ => DocumentStatus.unrecognised,
  };
}

/// Signature meaning, wire to model.
///
/// Takes the signature rather than the document because the tag lives on the
/// signature, and because a document with one unreadable signature among four
/// should not lose the other three.
SignatureMeaning signatureMeaningOf(wire.Signature signature, {int tag = 2}) {
  if (sentUnknownValueFor(signature, tag)) {
    // Not "author". An unreadable meaning must never finalise a note, because
    // finalising is what makes it un-editable and clinically attributed.
    return SignatureMeaning.unrecognised;
  }
  return switch (signature.meaning) {
    wire.SignatureMeaning.SIGNATURE_MEANING_AUTHOR => SignatureMeaning.author,
    wire.SignatureMeaning.SIGNATURE_MEANING_VERIFIER => SignatureMeaning.verifier,
    wire.SignatureMeaning.SIGNATURE_MEANING_COSIGNER => SignatureMeaning.cosigner,
    wire.SignatureMeaning.SIGNATURE_MEANING_WITNESS => SignatureMeaning.witness,
    wire.SignatureMeaning.SIGNATURE_MEANING_TRANSCRIBER =>
      SignatureMeaning.transcriber,
    wire.SignatureMeaning.SIGNATURE_MEANING_UNSPECIFIED =>
      SignatureMeaning.unspecified,
    _ => SignatureMeaning.unrecognised,
  };
}

ChartDocument documentOf(wire.Document document) => ChartDocument(
      documentId: document.documentId,
      title: document.title,
      kind: document.kind.name,
      status: documentStatusOf(document),
      authoredBy: document.authoredBy,
      createdAt: document.createdAt.toDateTime().toUtc(),
      amendsId: document.amendsId,
      addsToId: document.addsToId,
      changeReason: document.changeReason,
      retractionReason: document.retractionReason,
      dictated: document.dictated,
      signatures: [
        for (final s in document.signatures)
          DocumentSignature(
            subjectId: s.subjectId,
            meaning: signatureMeaningOf(s),
            signedAt: s.signedAt.toDateTime().toUtc(),
          ),
      ],
      intact: document.intact,
      confidentiality: document.confidentiality.name,
    );

// ---------------------------------------------------------------- allergies

Criticality criticalityOf(wire.Allergy allergy) {
  if (sentUnknownValueFor(allergy, allergyCriticalityField)) {
    return Criticality.unrecognised;
  }
  return switch (allergy.criticality) {
    wire.AllergyCriticality.ALLERGY_CRITICALITY_LOW => Criticality.low,
    wire.AllergyCriticality.ALLERGY_CRITICALITY_HIGH => Criticality.high,
    wire.AllergyCriticality.ALLERGY_CRITICALITY_UNABLE_TO_ASSESS =>
      Criticality.unableToAssess,
    wire.AllergyCriticality.ALLERGY_CRITICALITY_UNSPECIFIED =>
      Criticality.unspecified,
    _ => Criticality.unrecognised,
  };
}

Verification verificationOf(wire.Allergy allergy) {
  if (sentUnknownValueFor(allergy, allergyVerificationField)) {
    // Not "refuted": that would move a live allergy into the historical
    // section and out of a prescriber's way, which is the worst available
    // answer.
    return Verification.unrecognised;
  }
  return switch (allergy.verification) {
    wire.AllergyVerification.ALLERGY_VERIFICATION_UNCONFIRMED =>
      Verification.unconfirmed,
    wire.AllergyVerification.ALLERGY_VERIFICATION_CONFIRMED =>
      Verification.confirmed,
    wire.AllergyVerification.ALLERGY_VERIFICATION_REFUTED => Verification.refuted,
    wire.AllergyVerification.ALLERGY_VERIFICATION_ENTERED_IN_ERROR =>
      Verification.enteredInError,
    wire.AllergyVerification.ALLERGY_VERIFICATION_UNSPECIFIED =>
      Verification.unspecified,
    _ => Verification.unrecognised,
  };
}

AllergyKind allergyKindOf(wire.Allergy allergy) {
  if (sentUnknownValueFor(allergy, allergyKindField)) {
    return AllergyKind.unrecognised;
  }
  return switch (allergy.kind) {
    wire.AllergyKind.ALLERGY_KIND_ALLERGY => AllergyKind.allergy,
    wire.AllergyKind.ALLERGY_KIND_INTOLERANCE => AllergyKind.intolerance,
    wire.AllergyKind.ALLERGY_KIND_UNSPECIFIED => AllergyKind.unspecified,
    _ => AllergyKind.unrecognised,
  };
}

PresentedAllergy allergyOf(wire.Allergy allergy) => presentAllergy(
      allergyId: allergy.allergyId,
      substance: allergy.substance.display.isNotEmpty
          ? allergy.substance.display
          // A substance with no display text still has to name something: the
          // code is worse to read and far better than a blank row on the panel
          // a prescriber checks.
          : allergy.substance.code,
      kind: allergyKindOf(allergy),
      criticality: criticalityOf(allergy),
      verification: verificationOf(allergy),
      reactions: [
        for (final r in allergy.reactions)
          r.manifestation.display.isNotEmpty
              ? r.manifestation.display
              : r.manifestation.code,
      ],
      note: allergy.note,
    );

// ----------------------------------------------------------------- problems

ProblemStatus problemStatusOf(wire.Problem problem) {
  if (sentUnknownValueFor(problem, problemStatusField)) {
    return ProblemStatus.unrecognised;
  }
  return switch (problem.status) {
    wire.ProblemStatus.PROBLEM_STATUS_ACTIVE => ProblemStatus.active,
    wire.ProblemStatus.PROBLEM_STATUS_REMISSION => ProblemStatus.remission,
    wire.ProblemStatus.PROBLEM_STATUS_RESOLVED => ProblemStatus.resolved,
    wire.ProblemStatus.PROBLEM_STATUS_INACTIVE => ProblemStatus.inactive,
    wire.ProblemStatus.PROBLEM_STATUS_ENTERED_IN_ERROR =>
      ProblemStatus.enteredInError,
    wire.ProblemStatus.PROBLEM_STATUS_UNSPECIFIED => ProblemStatus.unspecified,
    _ => ProblemStatus.unrecognised,
  };
}

PresentedProblem problemOf(wire.Problem problem) => presentProblem(
      problemId: problem.problemId,
      code: problem.code.code,
      display: problem.code.display.isNotEmpty
          ? problem.code.display
          : problem.code.code,
      status: problemStatusOf(problem),
      onsetAt:
          problem.hasOnsetAt() ? problem.onsetAt.toDateTime().toUtc() : null,
      resolvedAt: problem.hasResolvedAt()
          ? problem.resolvedAt.toDateTime().toUtc()
          : null,
    );

// ------------------------------------------------------------- observations

Interpretation interpretationOf(wire.Observation observation) {
  if (sentUnknownValueFor(observation, interpretationField)) {
    // Not "normal". The zero member here means "nobody interpreted this",
    // which is already the careful reading; an unreadable one says so in its
    // own words so the label does not claim a laboratory verdict.
    return Interpretation.unrecognised;
  }
  return switch (observation.interpretation) {
    wire.Interpretation.INTERPRETATION_NORMAL => Interpretation.normal,
    wire.Interpretation.INTERPRETATION_HIGH => Interpretation.high,
    wire.Interpretation.INTERPRETATION_LOW => Interpretation.low,
    wire.Interpretation.INTERPRETATION_CRITICAL_HIGH => Interpretation.criticalHigh,
    wire.Interpretation.INTERPRETATION_CRITICAL_LOW => Interpretation.criticalLow,
    wire.Interpretation.INTERPRETATION_ABNORMAL => Interpretation.abnormal,
    wire.Interpretation.INTERPRETATION_UNKNOWN => Interpretation.unknown,
    wire.Interpretation.INTERPRETATION_UNSPECIFIED => Interpretation.unspecified,
    _ => Interpretation.unrecognised,
  };
}

PresentedObservation observationOf(wire.Observation observation) =>
    presentObservation(
      observationId: observation.observationId,
      display: observation.code.display.isNotEmpty
          ? observation.code.display
          : observation.code.code,
      effectiveAt: observation.effectiveAt.toDateTime().toUtc(),
      interpretation: interpretationOf(observation),
      // hasValue rather than a non-zero check: a measured zero is a result, and
      // a platelet count of zero read as "no numeric value" is a result that
      // disappears off the trend it most needs to be on.
      value: observation.hasValue() ? observation.value.value : null,
      unit: observation.hasValue() ? observation.value.unit : '',
      textValue: observation.textValue.isNotEmpty
          ? observation.textValue
          : observation.codedValue.display,
      interpretationSource: observation.interpretationSource,
      referenceLow:
          observation.hasReferenceRange ? observation.referenceLow : null,
      referenceHigh:
          observation.hasReferenceRange ? observation.referenceHigh : null,
      referenceText: observation.referenceText,
      status: observation.status.name,
    );
