/// The mobile half of the parity harness (tools/parity/cases.json).
///
/// Emits this implementation's answer for every case in the shared corpus so
/// the web half's answers can be compared against it. A divergence is a bug in
/// one of the two; which one is a judgement call the diff makes possible
/// rather than makes for you.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/billing/account.dart';
import 'package:health_mobile/src/billing/money.dart';
import 'package:health_mobile/src/chart/notes.dart';
import 'package:health_mobile/src/chart/safety.dart';
import 'package:health_mobile/src/meds/prescribe.dart';
import 'package:health_mobile/src/orders/composer.dart';
import 'package:health_mobile/src/reception/search.dart';

final _root = Directory('../../tools/parity');

T _enumBy<T>(List<T> values, String wire) => values.firstWhere(
      (v) => _snake((v as Enum).name) == wire,
      orElse: () => throw ArgumentError('no member for "$wire" in $values'),
    );

/// camelCase to snake_case, so the corpus can speak the web's vocabulary.
String _snake(String name) => name
    .replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

void main() {
  test('parity runner emits this implementation\'s answers', () {
    final cases = jsonDecode(
      File('${_root.path}/cases.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    final results = <String, dynamic>{};

    Money money(Map<String, dynamic> m) =>
        Money(minor: m['minor'] as int, currency: m['currency'] as String);
    Map<String, dynamic> out(Money m) =>
        {'minor': m.minor, 'currency': m.currency};

    results['decimalsFor'] =
        [for (final c in cases['decimalsFor']) decimalsFor(c as String)];

    results['formatMoney'] = [
      for (final c in cases['formatMoney'])
        {
          'withCurrency': formatMoney(money(c as Map<String, dynamic>)),
          'bare': formatMoney(money(c), withCurrency: false),
        },
    ];

    results['parseMoney'] = [
      for (final c in cases['parseMoney'])
        () {
          final parsed = parseMoney(
              (c as Map<String, dynamic>)['input'] as String,
              c['currency'] as String);
          return parsed == null ? null : out(parsed);
        }(),
    ];

    results['describeBalance'] = [
      for (final c in cases['describeBalance'])
        describeBalance(money(c as Map<String, dynamic>)),
    ];

    results['formatRate'] =
        [for (final c in cases['formatRate']) formatRate(c as int)];

    results['validateSearch'] = [
      for (final c in cases['validateSearch'])
        () {
          final m = c as Map<String, dynamic>;
          final v = validateSearch(SearchCriteria(
            name: m['name'] as String,
            phone: m['phone'] as String,
            identifierValue: m['identifierValue'] as String,
            birthDate: m['birthDate'] as String,
          ));
          return {
            'runnable': v.runnable,
            'reason': v.reason == null ? null : _snake(v.reason!.name).toUpperCase(),
            'message': v.message,
          };
        }(),
    ];

    PresentedMatch match(String id, String outcome, double confidence) =>
        presentMatch(
          patientId: id,
          displayName: id,
          confidence: confidence,
          outcome: _enumBy(MatchOutcome.values, outcome),
        );

    results['presentMatch'] = [
      for (final c in cases['presentMatch'])
        () {
          final m = c as Map<String, dynamic>;
          final p = match('p1', m['outcome'] as String,
              (m['confidence'] as num).toDouble());
          return {
            'confidencePercent': p.confidencePercent,
            'outcomeLabel': p.outcomeLabel,
            'blocksRegistration': p.blocksRegistration,
          };
        }(),
    ];

    results['registrationGate'] = [
      for (final c in cases['registrationGate'])
        () {
          final m = c as Map<String, dynamic>;
          final gate = registrationGate(
            searched: m['searched'] as bool,
            matches: [
              for (final pair in m['matches'])
                match(pair[0] as String, pair[1] as String, 0.8),
            ],
            acknowledged: [for (final a in m['acknowledged']) a as String],
          );
          return {
            'state': _snake(gate.state.name).replaceAll('_', '-'),
            'message': gate.message,
            'outstanding': gate.outstanding,
          };
        }(),
    ];

    results['readyToSign'] = [
      for (final c in cases['readyToSign'])
        () {
          final m = c as Map<String, dynamic>;
          final r = readyToSign(
            title: m['title'] as String,
            sections: [
              for (final s in m['sections'])
                DraftSection(heading: s[0] as String, text: s[1] as String),
            ],
            templateVersion: m['templateVersion'] as String,
            patientId: m['patientId'] as String,
            encounterId: m['encounterId'] as String,
          );
          return {'ready': r.ready, 'problems': r.problems};
        }(),
    ];

    final actions = <dynamic>[];
    for (final status in cases['actionsFor']['statuses']) {
      for (final intact in cases['actionsFor']['intact']) {
        for (final mayWrite in cases['actionsFor']['mayWrite']) {
          final a = actionsFor(
            ChartDocument(
              documentId: 'd1',
              title: 'T',
              status: _enumBy(DocumentStatus.values, status as String),
              authoredBy: 'a',
              createdAt: DateTime.utc(1970),
              intact: intact as bool,
            ),
            mayWrite: mayWrite as bool,
          );
          actions.add({
            'status': status,
            'intact': intact,
            'mayWrite': mayWrite,
            'edit': a.edit,
            'sign': a.sign,
            'amend': a.amend,
            'addendum': a.addendum,
            'retract': a.retract,
            'blocked': a.blockedReason.isNotEmpty,
          });
        }
      }
    }
    results['actionsFor'] = actions;

    results['finalises'] = [
      for (final m in cases['finalises'])
        finalises(_enumBy(SignatureMeaning.values, m as String)),
    ];

    PresentedAllergy allergy(String criticality, String verification, String s) =>
        presentAllergy(
          allergyId: s,
          substance: s,
          kind: AllergyKind.allergy,
          criticality: _enumBy(Criticality.values, criticality),
          verification: _enumBy(Verification.values, verification),
        );

    results['orderAllergies'] = [
      for (final group in cases['orderAllergies'])
        [
          for (final a in orderAllergies([
            for (final row in group)
              allergy(row[0] as String, row[1] as String, row[2] as String),
          ]))
            a.allergyId,
        ],
    ];

    final allergies = <dynamic>[];
    for (final criticality in cases['presentAllergy']['criticalities']) {
      for (final verification in cases['presentAllergy']['verifications']) {
        final a = allergy(criticality as String, verification as String, 'S');
        allergies.add({
          'criticality': criticality,
          'verification': verification,
          'prominent': a.prominent,
          'historical': a.historical,
          'criticalityLabel': a.criticalityLabel,
        });
      }
    }
    results['presentAllergy'] = allergies;

    results['buildTrend'] = [
      for (final group in cases['buildTrend'])
        () {
          final trend = buildTrend([
            for (final row in group)
              presentObservation(
                observationId: row[0] as String,
                display: 'D',
                effectiveAt: DateTime.utc(1970),
                interpretation: Interpretation.normal,
                value: row[1] == null ? null : (row[1] as num).toDouble(),
                unit: row[2] as String,
              ),
          ]);
          return {
            'mixedUnits': trend.mixedUnits,
            'points': trend.points.length,
            'unit': trend.unit,
          };
        }(),
    ];

    results['validateOrder'] = [
      for (final c in cases['validateOrder'])
        () {
          final m = c as Map<String, dynamic>;
          final rawPolicy = m['policy'] as Map<String, dynamic>?;
          final type = _enumBy(OrderType.values, m['type'] as String);
          final v = validateOrder(
            OrderDraft(
              type: type,
              patientId: m['patientId'] as String,
              encounterId: m['encounterId'] as String,
              code: m['code'] as String,
              indication: m['indication'] as String,
              startAt: m['startAt'] as String,
              frequencySeconds: m['frequencySeconds'] as int,
            ),
            rawPolicy == null
                ? null
                : OrderPolicy(
                    type: type,
                    indicationRequired: rawPolicy['indicationRequired'] as bool,
                    structuredTimingRequired:
                        rawPolicy['structuredTimingRequired'] as bool,
                  ),
          );
          return {
            'ready': v.ready,
            'order': v.order,
            'fields': v.problems.keys.toList()..sort(),
          };
        }(),
    ];

    results['duplicateGate'] = [
      for (final c in cases['duplicateGate'])
        () {
          final m = c as Map<String, dynamic>;
          final gate = duplicateGate(
            candidates: [
              for (final id in m['candidates'])
                DuplicateCandidate(
                  orderId: id as String,
                  number: 'ORD-$id',
                  display: 'D',
                  status: OrderStatus.requested,
                  placedAt: DateTime.utc(1970),
                ),
            ],
            overridable: m['overridable'] as bool,
            windowSeconds: m['windowSeconds'] as int,
            acknowledged: [for (final a in m['acknowledged']) a as String],
            reason: m['reason'] as String,
          );
          return {
            'state': _snake(gate.state.name).replaceAll('_', '-'),
            'message': gate.message,
            'windowHours': gate.windowHours,
          };
        }(),
    ];

    results['orderInbox'] = [
      for (final group in cases['orderInbox'])
        [
          for (final i in orderInbox([
            for (final row in group)
              InboxItem(
                observationId: row[0] as String,
                patientId: 'p',
                display: 'D',
                value: 'v',
                interpretationLabel: 'L',
                effectiveAt: DateTime.parse(row[2] as String),
                dueEscalations: row[1] as int,
              ),
          ]))
            i.observationId,
        ],
    ];

    results['acknowledgementProblem'] = [
      for (final a in cases['acknowledgementProblem'])
        acknowledgementProblem(a as String),
    ];

    results['validatePayment'] = [
      for (final c in cases['validatePayment'])
        () {
          final m = c as Map<String, dynamic>;
          final amount = m['amount'] as Map<String, dynamic>?;
          final v = validatePayment(
            amount: amount == null ? null : money(amount),
            method: _enumBy(PaymentMethod.values, m['method'] as String),
            idempotencyKey: m['idempotencyKey'] as String,
            accountId: m['accountId'] as String,
          );
          return {'ready': v.ready, 'problems': v.problems};
        }(),
    ];

    results['presentInvoice'] = [
      for (final status in cases['presentInvoice'])
        () {
          final i = presentInvoice(
            invoiceId: 'i1',
            number: 'INV-1',
            status: _enumBy(InvoiceStatus.values, status as String),
            total: const Money(minor: 100, currency: 'INR'),
          );
          return {
            'status': status,
            'editable': i.editable,
            'correctable': i.correctable,
          };
        }(),
    ];

    results['buildStatement'] = [
      for (final c in cases['buildStatement'])
        () {
          final m = c as Map<String, dynamic>;
          final entries = <PresentedEntry>[];
          var n = 0;
          for (final minor in m['entries']) {
            entries.add(presentEntry(
              entryId: 'e$n',
              kind: EntryKind.adjustment,
              amount: Money(minor: minor as int, currency: 'INR'),
              occurredAt: DateTime.fromMillisecondsSinceEpoch(n * 1000,
                  isUtc: true),
              method: PaymentMethod.cash,
            ));
            n++;
          }
          final s = buildStatement(
            entries: entries,
            reportedBalance: Money(minor: m['reported'] as int, currency: 'INR'),
            deposits: const Money(minor: 0, currency: 'INR'),
            currency: 'INR',
          );
          return {
            'derived': s.derivedBalance.minor,
            'reconciles': s.reconciles,
            'order': [for (final e in s.entries) e.entryId],
          };
        }(),
    ];

    results['closeReadiness'] = [
      for (final n in cases['closeReadiness'])
        () {
          final r = closeReadiness([
            for (var i = 0; i < (n as int); i++)
              CloseException(check: 'c$i', detail: 'd'),
          ]);
          return {'ready': r.ready, 'message': r.message};
        }(),
    ];

    results['unbilledTotal'] = [
      for (final group in cases['unbilledTotal'])
        () {
          final charges = <PresentedCharge>[];
          var n = 0;
          for (final row in group) {
            charges.add(presentCharge(
              chargeId: 'c$n',
              display: 'D',
              status: _enumBy(ChargeStatus.values, row[0] as String),
              total: Money(minor: row[1] as int, currency: 'INR'),
            ));
            n++;
          }
          return unbilledTotal(charges, 'INR').minor;
        }(),
    ];

    PresentedFinding asFinding(String id, String severity, [String existing = '']) =>
        presentFinding(
          ruleId: id,
          ruleVersion: 'v1',
          kind: FindingKind.interaction,
          severity: _enumBy(Severity.values, severity),
          summary: 'Finding $id',
          existingOverrideReason: existing,
        );

    results['safetyGate'] = [
      for (final c in cases['safetyGate'])
        () {
          final m = c as Map<String, dynamic>;
          final gate = safetyGate(
            [
              for (final f in m['findings'])
                asFinding(f[0] as String, f[1] as String, f[2] as String),
            ],
            [
              for (final a in m['answers'])
                OverrideAnswer(ruleId: a[0] as String, reason: a[1] as String),
            ],
          );
          return {
            'state': _snake(gate.state.name).replaceAll('_', '-'),
            'message': gate.message,
            'outstanding': [for (final f in gate.outstanding) f.ruleId],
          };
        }(),
    ];

    results['orderFindings'] = [
      for (final group in cases['orderFindings'])
        [
          for (final f in orderFindings([
            for (final row in group) asFinding(row[0] as String, row[1] as String),
          ]))
            f.ruleId,
        ],
    ];

    results['presentFinding'] = [
      for (final severity in cases['presentFinding'])
        () {
          final f = asFinding('r1', severity as String);
          return {
            'severity': severity,
            'overridable': f.overridable,
            'severityLabel': f.severityLabel,
          };
        }(),
    ];

    results['describeFindingKind'] = [
      for (final kind in cases['describeFindingKind'])
        describeFindingKind(_enumBy(FindingKind.values, kind as String)),
    ];

    results['structuredDoseRequiredFor'] = [
      for (final c in cases['structuredDoseRequiredFor'])
        structuredDoseRequiredFor(
          [for (final k in (c as Map<String, dynamic>)['classes']) k as String],
          c['drugClass'] as String,
        ),
    ];

    results['validatePrescription'] = [
      for (final c in cases['validatePrescription'])
        () {
          final m = c as Map<String, dynamic>;
          final validity = validatePrescription(
            PrescriptionDraft(
              patientId: m['patientId'] as String,
              encounterId: m['encounterId'] as String,
              ingredientCode: m['ingredientCode'] as String,
              route: m['route'] as String,
              indication: m['indication'] as String,
              dose: DoseDraft(
                amount: m['amount'] as String,
                unit: m['unit'] as String,
                freeText: m['freeText'] as String,
              ),
            ),
            structuredDoseRequired: m['structuredDoseRequired'] as bool,
          );
          return {
            'ready': validity.ready,
            'order': validity.order,
            'fields': validity.problems.keys.toList()..sort(),
            'mayPrescribe': mayPrescribe(
                validity, const SafetyGate(state: SafetyState.clear)),
          };
        }(),
    ];

    results['formularyNotice'] = [
      for (final c in cases['formularyNotice'])
        () {
          final m = c as Map<String, dynamic>;
          final notice = formularyNotice(
            status: _enumBy(FormularyStatus.values, m['status'] as String),
            restriction: m['restriction'] as String,
            approvalPath: m['approvalPath'] as String,
          );
          return {
            'label': notice.label,
            'action': notice.action,
            'prominent': notice.prominent,
          };
        }(),
    ];

    results['worstSeverity'] = [
      for (final group in cases['worstSeverity'])
        () {
          var n = 0;
          final findings = <PresentedFinding>[];
          for (final severity in group) {
            findings.add(asFinding('r$n', severity as String));
            n++;
          }
          return _snake(worstSeverity(findings).name);
        }(),
    ];

    results['orderQueue'] = [
      for (final group in cases['orderQueue'])
        [
          for (final e in orderQueue([
            for (final row in group)
              QueueEntry(
                prescriptionId: row[0] as String,
                patientId: 'p1',
                description: row[0] as String,
                prescriberId: 'd1',
                createdAt: DateTime.parse(row[2] as String),
                worstSeverity: _enumBy(Severity.values, row[1] as String),
              ),
          ]))
            e.prescriptionId,
        ],
    ];

    results['sumMoney'] = [
      sumMoney([for (var i = 0; i < 100; i++) const Money(minor: 10, currency: 'INR')],
              'INR')
          .minor,
    ];

    File('${_root.path}/mobile-results.json').writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(results)}\n',
    );
  });
}
