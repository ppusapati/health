/**
 * The web half of the parity harness (tools/parity/cases.json).
 *
 * Not a test of behaviour — it emits this implementation's answer for every
 * case in the shared corpus, so the Dart half's answers can be compared
 * against it. A divergence is a bug in one of the two, and which one is a
 * judgement call the diff makes possible rather than makes for you.
 */
import { describe, it } from 'vitest';
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';

import {
	decimalsFor, formatMoney, parseMoney, describeBalance, formatRate, sumMoney,
	type Money
} from './billing/money.js';
import {
	buildStatement, presentEntry, presentInvoice, validatePayment, closeReadiness,
	presentCharge, unbilledTotal,
	type EntryKind, type InvoiceStatus, type ChargeStatus, type PaymentMethod
} from './billing/account.js';
import {
	validateSearch, presentMatch, registrationGate, type MatchOutcome
} from './reception/search.js';
import {
	actionsFor, readyToSign, finalises,
	type DocumentStatus, type SignatureMeaning, type ChartDocument
} from './chart/notes.js';
import {
	presentAllergy, orderAllergies, buildTrend, presentObservation,
	type Criticality, type Verification
} from './chart/safety.js';
import {
	validateOrder, duplicateGate, orderInbox, acknowledgementProblem,
	type OrderType, type OrderPriority, type OrderStatus
} from './orders/composer.js';
import {
	presentFinding, orderFindings, safetyGate, structuredDoseRequiredFor,
	validatePrescription, mayPrescribe, describeFormulary, describeFindingKind,
	worstSeverity, orderQueue,
	type Severity, type FormularyStatus, type FindingKind
} from './meds/prescribe.js';
import {
	describeOutcome, needsReason, describeRefusal, formatDose, orderDoses,
	evaluateAdministration,
	type AdministrationOutcome, type PresentedDose, type Refusal
} from './meds/administer.js';

const root = resolve(__dirname, '../../../../tools/parity');
const cases = JSON.parse(readFileSync(resolve(root, 'cases.json'), 'utf8'));

const money = (m: { minor: number; currency: string }): Money => ({
	minor: BigInt(m.minor),
	currency: m.currency
});
const out = (m: Money) => ({ minor: Number(m.minor), currency: m.currency });

describe('parity runner', () => {
	it('emits this implementation\'s answers', () => {
		const results: Record<string, unknown> = {};

		results.decimalsFor = cases.decimalsFor.map((c: string) => decimalsFor(c));

		results.formatMoney = cases.formatMoney.map((c: never) => ({
			withCurrency: formatMoney(money(c)),
			bare: formatMoney(money(c), { withCurrency: false })
		}));

		results.parseMoney = cases.parseMoney.map((c: { input: string; currency: string }) => {
			const parsed = parseMoney(c.input, c.currency);
			return parsed === null ? null : out(parsed);
		});

		results.describeBalance = cases.describeBalance.map((c: never) =>
			describeBalance(money(c))
		);

		results.formatRate = cases.formatRate.map((c: number) => formatRate(c));

		results.validateSearch = cases.validateSearch.map((c: never) => {
			const v = validateSearch(c);
			return { runnable: v.runnable, reason: v.reason, message: v.message };
		});

		results.presentMatch = cases.presentMatch.map(
			(c: { confidence: number; outcome: MatchOutcome }) => {
				const m = presentMatch({
					patientId: 'p1', displayName: 'X', confidence: c.confidence,
					outcome: c.outcome, masked: false, matchedFormerName: ''
				});
				return {
					confidencePercent: m.confidencePercent,
					outcomeLabel: m.outcomeLabel,
					blocksRegistration: m.blocksRegistration
				};
			}
		);

		results.registrationGate = cases.registrationGate.map(
			(c: { searched: boolean; matches: [string, MatchOutcome][]; acknowledged: string[] }) => {
				const gate = registrationGate({
					searched: c.searched,
					matches: c.matches.map(([id, outcome]) =>
						presentMatch({
							patientId: id, displayName: id, confidence: 0.8,
							outcome, masked: false, matchedFormerName: ''
						})
					),
					acknowledged: c.acknowledged
				});
				return {
					state: gate.state,
					message: gate.message,
					outstanding: 'outstanding' in gate ? gate.outstanding : []
				};
			}
		);

		results.readyToSign = cases.readyToSign.map(
			(c: { title: string; sections: [string, string][]; templateVersion: string; patientId: string; encounterId: string }) => {
				const r = readyToSign({
					title: c.title,
					sections: c.sections.map(([heading, text]) => ({ heading, text })),
					templateVersion: c.templateVersion,
					patientId: c.patientId,
					encounterId: c.encounterId
				});
				return { ready: r.ready, problems: r.problems };
			}
		);

		const doc = (status: DocumentStatus, intact: boolean): ChartDocument => ({
			documentId: 'd1', title: 'T', kind: 'k', status, authoredBy: 'a',
			createdAt: new Date(0), updatedAt: new Date(0), amendsId: '', addsToId: '',
			changeReason: '', retractionReason: '', dictated: false, signatures: [],
			intact, confidentiality: ''
		});
		results.actionsFor = [];
		for (const status of cases.actionsFor.statuses as DocumentStatus[]) {
			for (const intact of cases.actionsFor.intact as boolean[]) {
				for (const mayWrite of cases.actionsFor.mayWrite as boolean[]) {
					const a = actionsFor(doc(status, intact), { subjectId: 's', mayWrite });
					(results.actionsFor as unknown[]).push({
						status, intact, mayWrite,
						edit: a.edit, sign: a.sign, amend: a.amend,
						addendum: a.addendum, retract: a.retract,
						blocked: a.blockedReason !== ''
					});
				}
			}
		}

		results.finalises = cases.finalises.map((m: SignatureMeaning) => finalises(m));

		const allergy = (criticality: Criticality, verification: Verification, substance: string) =>
			presentAllergy({
				allergyId: substance, substance, kind: 'allergy',
				criticality, verification, reactions: [], note: ''
			});

		results.orderAllergies = cases.orderAllergies.map(
			(group: [Criticality, Verification, string][]) =>
				orderAllergies(group.map(([c, v, s]) => allergy(c, v, s))).map((a) => a.allergyId)
		);

		results.presentAllergy = [];
		for (const criticality of cases.presentAllergy.criticalities as Criticality[]) {
			for (const verification of cases.presentAllergy.verifications as Verification[]) {
				const a = allergy(criticality, verification, 'S');
				(results.presentAllergy as unknown[]).push({
					criticality, verification,
					prominent: a.prominent, historical: a.historical,
					criticalityLabel: a.criticalityLabel
				});
			}
		}

		results.buildTrend = cases.buildTrend.map(
			(group: [string, number | null, string][]) => {
				const observations = group.map(([id, value, unit]) =>
					presentObservation({
						observationId: id, display: 'D', value, unit, textValue: '',
						interpretation: 'normal', interpretationSource: '',
						referenceLow: 0, referenceHigh: 0, hasReferenceRange: false,
						referenceText: '', effectiveAt: new Date(0), status: ''
					})
				);
				const raw = group.map(([id, value]) => ({ observationId: id, value }));
				const trend = buildTrend(observations, raw);
				return {
					mixedUnits: trend.mixedUnits,
					points: trend.points.length,
					unit: trend.unit
				};
			}
		);

		results.validateOrder = cases.validateOrder.map((c: never) => {
			const draft = {
				type: (c as { type: OrderType }).type,
				patientId: (c as { patientId: string }).patientId,
				encounterId: (c as { encounterId: string }).encounterId,
				code: (c as { code: string }).code,
				display: '', detail: '',
				indication: (c as { indication: string }).indication,
				priority: 'routine' as OrderPriority,
				startAt: (c as { startAt: string }).startAt,
				frequencySeconds: (c as { frequencySeconds: number }).frequencySeconds,
				conditionalInstruction: ''
			};
			const raw = (c as { policy: { indicationRequired: boolean; structuredTimingRequired: boolean } | null }).policy;
			const policy = raw === null ? null : {
				type: draft.type, indicationRequired: raw.indicationRequired,
				structuredTimingRequired: raw.structuredTimingRequired, requiredPrivilege: ''
			};
			const v = validateOrder(draft, policy);
			return { ready: v.ready, order: v.order, fields: Object.keys(v.problems).sort() };
		});

		results.duplicateGate = cases.duplicateGate.map((c: never) => {
			const cc = c as { candidates: string[]; overridable: boolean; windowSeconds: number; acknowledged: string[]; reason: string };
			const gate = duplicateGate({
				candidates: cc.candidates.map((id) => ({
					orderId: id, number: `ORD-${id}`, display: 'D',
					status: 'requested' as OrderStatus, statusLabel: 'Requested',
					placedAt: new Date(0), requesterId: ''
				})),
				overridable: cc.overridable,
				windowSeconds: cc.windowSeconds,
				acknowledged: cc.acknowledged,
				reason: cc.reason
			});
			return {
				state: gate.state,
				message: 'message' in gate ? gate.message : '',
				windowHours: 'windowHours' in gate ? gate.windowHours : 0
			};
		});

		results.orderInbox = cases.orderInbox.map(
			(group: [string, number, string][]) =>
				orderInbox(group.map(([id, escalations, at]) => ({
					observationId: id, patientId: 'p', display: 'D', value: 'v',
					interpretationLabel: 'L', effectiveAt: new Date(at),
					dueEscalations: escalations, waitingMinutes: 0
				}))).map((i) => i.observationId)
		);

		results.acknowledgementProblem = cases.acknowledgementProblem.map(
			(a: string) => acknowledgementProblem(a)
		);

		results.validatePayment = cases.validatePayment.map((c: never) => {
			const cc = c as { amount: { minor: number; currency: string } | null; method: PaymentMethod; idempotencyKey: string; accountId: string };
			const v = validatePayment({
				amount: cc.amount === null ? null : money(cc.amount),
				method: cc.method,
				idempotencyKey: cc.idempotencyKey,
				accountId: cc.accountId
			});
			return { ready: v.ready, problems: v.problems };
		});

		results.presentInvoice = cases.presentInvoice.map((status: InvoiceStatus) => {
			const i = presentInvoice({
				invoiceId: 'i1', number: 'INV-1', status,
				total: { minor: 100n, currency: 'INR' },
				issuedAt: null, supersededBy: '', correctsInvoiceId: '', lineCount: 0
			});
			return { status, editable: i.editable, correctable: i.correctable };
		});

		results.buildStatement = cases.buildStatement.map(
			(c: { entries: number[]; reported: number }) => {
				const s = buildStatement({
					entries: c.entries.map((minor, n) =>
						presentEntry({
							entryId: `e${n}`, kind: 'adjustment' as EntryKind,
							amount: { minor: BigInt(minor), currency: 'INR' },
							receiptNumber: '', method: 'cash' as PaymentMethod, reason: '',
							occurredAt: new Date(n * 1000), recordedBy: ''
						})
					),
					reportedBalance: { minor: BigInt(c.reported), currency: 'INR' },
					deposits: { minor: 0n, currency: 'INR' },
					currency: 'INR'
				});
				return {
					derived: Number(s.derivedBalance.minor),
					reconciles: s.reconciles,
					order: s.entries.map((e) => e.entryId)
				};
			}
		);

		results.closeReadiness = cases.closeReadiness.map((n: number) => {
			const r = closeReadiness(
				Array.from({ length: n }, (_, i) => ({
					check: `c${i}`, detail: 'd', amount: null, references: []
				}))
			);
			return { ready: r.ready, message: r.message };
		});

		results.unbilledTotal = cases.unbilledTotal.map(
			(group: [ChargeStatus, number][]) =>
				Number(
					unbilledTotal(
						group.map(([status, minor], n) =>
							presentCharge({
								chargeId: `c${n}`, description: 'D', department: '',
								quantity: 1, status,
								total: { minor: BigInt(minor), currency: 'INR' },
								covered: false, coverageNote: '',
								// Unused by unbilledTotal; the epoch rather than null so the
								// corpus case cannot be mistaken for a missing timestamp.
								occurredAt: new Date(0)
							})
						),
						'INR'
					).minor
				)
		);

		const asFinding = (id: string, severity: Severity, existing = '') =>
			presentFinding({
				ruleId: id, ruleVersion: 'v1', kind: 'interaction', severity,
				summary: `Finding ${id}`, subjects: [],
				existingOverrideReason: existing
			});

		results.safetyGate = cases.safetyGate.map(
			(c: { findings: [string, Severity, string][]; answers: [string, string][] }) => {
				const gate = safetyGate(
					c.findings.map(([id, severity, existing]) => asFinding(id, severity, existing)),
					c.answers.map(([ruleId, reason]) => ({ ruleId, reason }))
				);
				return {
					state: gate.state,
					message: 'message' in gate ? gate.message : '',
					outstanding: 'outstanding' in gate
						? gate.outstanding.map((f) => f.ruleId)
						: []
				};
			}
		);

		results.orderFindings = cases.orderFindings.map(
			(group: [string, Severity][]) =>
				orderFindings(group.map(([id, severity]) => asFinding(id, severity)))
					.map((f) => f.ruleId)
		);

		results.presentFinding = cases.presentFinding.map((severity: Severity) => {
			const f = asFinding('r1', severity);
			return { severity, overridable: f.overridable, severityLabel: f.severityLabel };
		});

		results.describeFindingKind = cases.describeFindingKind.map((kind: FindingKind) =>
			describeFindingKind(kind)
		);

		results.structuredDoseRequiredFor = cases.structuredDoseRequiredFor.map(
			(c: { classes: string[]; drugClass: string }) =>
				structuredDoseRequiredFor(c.classes, c.drugClass)
		);

		results.validatePrescription = cases.validatePrescription.map((c: never) => {
			const cc = c as {
				patientId: string; encounterId: string; ingredientCode: string;
				route: string; indication: string; amount: string; unit: string;
				freeText: string; structuredDoseRequired: boolean;
			};
			const validity = validatePrescription({
				patientId: cc.patientId, encounterId: cc.encounterId,
				ingredientCode: cc.ingredientCode, ingredientDisplay: '',
				drugClass: '', route: cc.route,
				dose: {
					amount: cc.amount, unit: cc.unit, freeText: cc.freeText,
					frequencySeconds: 0
				},
				indication: cc.indication, startsAt: ''
			}, { structuredDoseRequired: cc.structuredDoseRequired });
			return {
				ready: validity.ready,
				order: validity.order,
				fields: Object.keys(validity.problems).sort(),
				mayPrescribe: mayPrescribe(validity, { state: 'clear' })
			};
		});

		results.formularyNotice = cases.formularyNotice.map(
			(c: { status: FormularyStatus; restriction: string; approvalPath: string }) => {
				const notice = describeFormulary(c);
				return { label: notice.label, action: notice.action, prominent: notice.prominent };
			}
		);

		results.worstSeverity = cases.worstSeverity.map((group: Severity[]) =>
			worstSeverity(group.map((severity, i) => asFinding(`r${i}`, severity)))
		);

		results.orderQueue = cases.orderQueue.map((group: [string, Severity, string][]) =>
			orderQueue(
				group.map(([prescriptionId, severity, createdAt]) => ({
					prescriptionId, patientId: 'p1', description: prescriptionId,
					prescriberId: 'd1', createdAt: new Date(createdAt),
					therapyStatus: 'draft' as const, worstSeverity: severity,
					findings: [], overridden: false, verified: false
				}))
			).map((e) => e.prescriptionId)
		);

		results.describeOutcome = cases.describeOutcome.map((o: AdministrationOutcome) =>
			describeOutcome(o)
		);

		results.needsReason = cases.needsReason.map((o: AdministrationOutcome) =>
			needsReason(o)
		);

		results.describeRefusal = cases.describeRefusal.map((r: Refusal) =>
			describeRefusal(r)
		);

		results.formatDose = cases.formatDose.map((c: { value: number; unit: string }) =>
			formatDose(c.value, c.unit)
		);

		const asDose = (
			orderId: string, outstanding: boolean, scheduledAt: string
		): PresentedDose => ({
			orderId, medication: 'Amoxicillin', doseLabel: '500 mg', route: 'oral',
			scheduledAt: new Date(scheduledAt), outstanding, overdue: false,
			minutesLate: 0, prn: false, verifiedByPharmacy: true,
			recordedOutcome: outstanding ? null : 'administered'
		});

		results.orderDoses = cases.orderDoses.map((group: [string, boolean, string][]) =>
			orderDoses(group.map((row) => asDose(...row))).map((d) => d.orderId)
		);

		results.evaluateAdministration = cases.evaluateAdministration.map((c: never) => {
			const cc = c as {
				outcome: AdministrationOutcome | null; patientScan: string;
				medicationScan: string; barcodeRequired: boolean;
				overrideAllowed: boolean; overrideReason: string; reason: string;
				settled: boolean;
			};
			const decision = evaluateAdministration({
				dose: {
					...asDose('o1', true, '2026-09-16T09:00:00Z'),
					recordedOutcome: cc.settled ? 'administered' : null
				},
				policy: {
					barcodeRequired: cc.barcodeRequired,
					overrideAllowed: cc.overrideAllowed,
					lateAfterMinutes: 60
				},
				outcome: cc.outcome,
				scan: { patient: cc.patientScan, medication: cc.medicationScan },
				overrideReason: cc.overrideReason,
				reason: cc.reason
			});
			return {
				allowed: decision.allowed,
				overriding: decision.overriding,
				refusals: decision.refusals
			};
		});

		results.sumMoney = [Number(sumMoney(
			Array.from({ length: 100 }, () => ({ minor: 10n, currency: 'INR' })), 'INR'
		).minor)];

		writeFileSync(
			resolve(root, 'web-results.json'),
			JSON.stringify(results, null, 2) + '\n'
		);
	});
});
