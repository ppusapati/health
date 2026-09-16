/// Medication protobuf messages to the prescribing composer's models.
///
/// Same unknown-enum discipline as the other workspaces, and the one place it
/// matters most. protobuf.dart decodes an enum tag this build does not know as
/// the zero member and files the real tag under `unknownFields` — so a server
/// that adds a severity above `severe` would, without this, arrive as
/// `SEVERITY_UNSPECIFIED`. The finding would still be shown, and still gate,
/// because `unspecified` is not treated as safe; but it would be shown as
/// ungraded, which is a quieter thing than what the server meant.
///
/// `unrecognised` says so instead, sorts with `severe`, and still needs a
/// reason. The rule throughout: an unreadable value never becomes the
/// permissive one.
library;

import 'package:protobuf/protobuf.dart' as pb;

import '../gen/healthcare/medication/v1/medication.pb.dart' as wire;
import 'prescribe.dart';

/// Field tags carrying the enums this module reads. Pinned by test.
const int findingKindField = 1; // medication.v1.SafetyFinding.kind
const int findingSeverityField = 2; // medication.v1.SafetyFinding.severity
const int formularyStatusField = 1; // medication.v1.FormularyDecision.status
const int therapyStatusField = 19; // medication.v1.Prescription.therapy_status

/// True when [message] carried a value for [tag] this build could not read.
bool sentUnknownValueFor(pb.GeneratedMessage message, int tag) =>
    message.unknownFields.hasField(tag);

Severity severityOf(wire.SafetyFinding finding) {
  if (sentUnknownValueFor(finding, findingSeverityField)) {
    return Severity.unrecognised;
  }
  return switch (finding.severity) {
    wire.Severity.SEVERITY_CONTRAINDICATED => Severity.contraindicated,
    wire.Severity.SEVERITY_SEVERE => Severity.severe,
    wire.Severity.SEVERITY_MODERATE => Severity.moderate,
    wire.Severity.SEVERITY_MILD => Severity.mild,
    wire.Severity.SEVERITY_INFORMATIONAL => Severity.informational,
    wire.Severity.SEVERITY_UNSPECIFIED => Severity.unspecified,
    _ => Severity.unrecognised,
  };
}

FindingKind findingKindOf(wire.SafetyFinding finding) {
  if (sentUnknownValueFor(finding, findingKindField)) {
    return FindingKind.unrecognised;
  }
  return switch (finding.kind) {
    wire.FindingKind.FINDING_KIND_ALLERGY => FindingKind.allergy,
    wire.FindingKind.FINDING_KIND_INTERACTION => FindingKind.interaction,
    wire.FindingKind.FINDING_KIND_DUPLICATE_THERAPY => FindingKind.duplicateTherapy,
    wire.FindingKind.FINDING_KIND_DOSE_SUPPORT => FindingKind.doseSupport,
    wire.FindingKind.FINDING_KIND_UNSPECIFIED => FindingKind.unspecified,
    _ => FindingKind.unrecognised,
  };
}

FormularyStatus formularyStatusOf(wire.FormularyDecision decision) {
  if (sentUnknownValueFor(decision, formularyStatusField)) {
    return FormularyStatus.unrecognised;
  }
  return switch (decision.status) {
    wire.FormularyStatus.FORMULARY_STATUS_FORMULARY => FormularyStatus.formulary,
    wire.FormularyStatus.FORMULARY_STATUS_RESTRICTED => FormularyStatus.restricted,
    wire.FormularyStatus.FORMULARY_STATUS_NON_FORMULARY => FormularyStatus.nonFormulary,
    wire.FormularyStatus.FORMULARY_STATUS_UNKNOWN => FormularyStatus.unknown,
    wire.FormularyStatus.FORMULARY_STATUS_UNSPECIFIED => FormularyStatus.unspecified,
    _ => FormularyStatus.unrecognised,
  };
}

TherapyStatus therapyStatusOf(wire.Prescription prescription) {
  if (sentUnknownValueFor(prescription, therapyStatusField)) {
    return TherapyStatus.unrecognised;
  }
  return switch (prescription.therapyStatus) {
    wire.TherapyStatus.THERAPY_STATUS_DRAFT => TherapyStatus.draft,
    wire.TherapyStatus.THERAPY_STATUS_ACTIVE => TherapyStatus.active,
    wire.TherapyStatus.THERAPY_STATUS_HELD => TherapyStatus.held,
    wire.TherapyStatus.THERAPY_STATUS_DISCONTINUED => TherapyStatus.discontinued,
    wire.TherapyStatus.THERAPY_STATUS_COMPLETED => TherapyStatus.completed,
    wire.TherapyStatus.THERAPY_STATUS_UNSPECIFIED => TherapyStatus.unspecified,
    _ => TherapyStatus.unrecognised,
  };
}

/// Human label for a therapy status.
String describeTherapy(TherapyStatus status) => switch (status) {
      TherapyStatus.draft => 'Draft',
      TherapyStatus.active => 'Active',
      // Held is not discontinued: the therapy is expected to resume, and the
      // chart shows future doses suppressed rather than the drug removed.
      TherapyStatus.held => 'Held',
      TherapyStatus.discontinued => 'Discontinued',
      TherapyStatus.completed => 'Completed',
      TherapyStatus.unspecified => 'Unknown',
      TherapyStatus.unrecognised => 'Status not recognised by this app',
    };

/// Adapts a wire SafetyFinding.
PresentedFinding presentedFindingOf(wire.SafetyFinding finding) => presentFinding(
      ruleId: finding.ruleId,
      ruleVersion: finding.ruleVersion,
      kind: findingKindOf(finding),
      severity: severityOf(finding),
      summary: finding.summary,
      subjects: [
        for (final subject in finding.subjects)
          subject.display.isNotEmpty ? subject.display : subject.code,
      ],
      existingOverrideReason:
          finding.hasOverride() ? finding.override.reason : '',
    );

/// Describes a prescription in one line, for a queue row.
///
/// The server composes `description` from the structure so two clients cannot
/// render the same prescription differently (SRS-MED-001). This falls back only
/// when it is absent.
String describePrescription(wire.Prescription prescription) {
  if (prescription.description.isNotEmpty) {
    return prescription.description;
  }
  final drug = [
    prescription.product.display,
    prescription.ingredient.display,
    prescription.ingredient.code,
  ].firstWhere((part) => part.isNotEmpty, orElse: () => 'Medicine');

  final dose = prescription.segments.isEmpty
      ? ''
      : prescription.segments.first.hasDose()
          ? '${prescription.segments.first.dose.value} '
              '${prescription.segments.first.dose.unit}'
          : prescription.segments.first.freeTextDose;

  return [drug, dose, prescription.route]
      .where((part) => part.isNotEmpty)
      .join(' ');
}

/// Adapts a wire Prescription into a verification queue row.
QueueEntry queueEntryOf(wire.Prescription prescription) {
  final findings = [
    for (final finding in prescription.findings) presentedFindingOf(finding),
  ];
  return QueueEntry(
    prescriptionId: prescription.prescriptionId,
    patientId: prescription.patientId,
    description: describePrescription(prescription),
    prescriberId: prescription.prescriberId,
    createdAt: prescription.hasCreatedAt()
        ? prescription.createdAt.toDateTime().toUtc()
        : DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    therapyStatus: therapyStatusOf(prescription),
    worstSeverity: worstSeverity(findings),
    findings: findings,
    overridden: findings.any((f) => f.existingOverrideReason.isNotEmpty),
    // Presence of the verification message decides. An empty `by` on a present
    // message would be a server bug, and treating it as unverified is the
    // safer reading of one.
    verified: prescription.hasVerification() &&
        prescription.verification.by.isNotEmpty,
  );
}

/// The formulary notice for a prescription.
FormularyNotice formularyNoticeOf(wire.Prescription prescription) {
  if (!prescription.hasFormulary()) {
    return formularyNotice(status: FormularyStatus.unspecified);
  }
  return formularyNotice(
    status: formularyStatusOf(prescription.formulary),
    restriction: prescription.formulary.restriction,
    approvalPath: prescription.formulary.approvalPath,
  );
}
