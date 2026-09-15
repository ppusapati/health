<!--
  Medication and prescription workspace (UX-W1-05).

  Prescribing, the drug chart, and the pharmacist's verification queue. The
  rules are in $lib/meds/prescribe.ts and tested there.

  This is the highest-consequence screen in the wave, and almost all of its
  design is about what it refuses.

  A contraindication is not a warning with a bigger chip. There is no reason
  box beside it, because there is no reason that clears it — offering one and
  then refusing the submit is worse than not offering it, since the prescriber
  has already composed an argument.

  Every other finding gets its own reason box, attached to its own rule. One
  shared "I have considered these" field would produce a single sentence
  covering an allergy and a dose warning at once, and that is precisely the
  record a pharmacist reads at verification and an incident review reads
  afterwards.
-->
<script lang="ts">
	import { createApiClients } from '$lib/api/client.js';
	import { presentError, type PresentedError } from '$lib/api/errors.js';
	import { PUBLIC_API_BASE_URL } from '$lib/config.js';
	import ErrorBanner from '$lib/components/ErrorBanner.svelte';
	import EmptyState from '$lib/components/EmptyState.svelte';
	import StatusChip from '$lib/components/StatusChip.svelte';
	import { can, currentCredentials, session } from '$lib/session.js';
	import {
		describeFormulary,
		mayPrescribe,
		orderFindings,
		orderQueue,
		safetyGate,
		structuredDoseRequiredFor,
		validatePrescription,
		type OverrideAnswer,
		type PresentedFinding,
		type PrescriptionDraft,
		type QueueEntry
	} from '$lib/meds/prescribe.js';
	import {
		describePrescription,
		therapyLabels,
		toFormularyDecision,
		toPresentedFinding,
		toQueueEntry,
		toTherapyStatus
	} from '$lib/meds/mapping.js';
	import { timestampFromDate } from '@bufbuild/protobuf/wkt';
	import type { Prescription } from '$gen/healthcare/medication/v1/medication_pb.js';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);

	let patientId = $state('');
	let encounterId = $state('');
	let loadedFor = $state('');

	let prescriptions = $state<Prescription[]>([]);
	let queue = $state<readonly QueueEntry[]>([]);
	let loading = $state(false);
	let error = $state<PresentedError | null>(null);

	// Composer.
	let ingredientCode = $state('');
	let ingredientDisplay = $state('');
	let drugClass = $state('');
	let route = $state('oral');
	let doseAmount = $state('');
	let doseUnit = $state('');
	let doseFreeText = $state('');
	let frequencyHours = $state(6);
	let indication = $state('');
	let prescribing = $state(false);

	/**
	 * The classes that must carry a structured dose (SRS-MED-010).
	 *
	 * Read from the medication policy rather than decided here: which classes
	 * must not take free text is a clinical policy a hospital sets, and a list
	 * hard-coded in the browser would be both wrong and invisible.
	 */
	let structuredDoseClasses = $state<readonly string[]>([]);

	// Findings returned by the last attempt, with reasons keyed by rule.
	let findings = $state<readonly PresentedFinding[]>([]);
	let reasons = $state<Record<string, string>>({});

	let acting = $state('');

	const mayRead = $derived($session ? can('med.prescription.read') : false);
	const mayPrescribeHere = $derived($session ? can('med.prescription.write') : false);
	const mayVerify = $derived($session ? can('med.prescription.verify') : false);

	const draft = $derived<PrescriptionDraft>({
		patientId,
		encounterId,
		ingredientCode,
		ingredientDisplay,
		drugClass,
		route,
		dose: {
			amount: doseAmount,
			unit: doseUnit,
			freeText: doseFreeText,
			frequencySeconds: frequencyHours > 0 ? frequencyHours * 3600 : 0
		},
		indication,
		startsAt: ''
	});
	const structuredDoseRequired = $derived(
		structuredDoseRequiredFor(structuredDoseClasses, drugClass)
	);
	const validity = $derived(validatePrescription(draft, { structuredDoseRequired }));
	const answers = $derived<readonly OverrideAnswer[]>(
		Object.entries(reasons).map(([ruleId, reason]) => ({ ruleId, reason }))
	);
	const gate = $derived(safetyGate(findings, answers));
	const canSubmit = $derived(mayPrescribeHere && mayPrescribe(validity, gate));

	const severityTones = {
		contraindicated: 'critical',
		severe: 'critical',
		moderate: 'caution',
		mild: 'caution',
		informational: 'neutral',
		unspecified: 'caution'
	} as const;

	async function load() {
		if (!mayRead || patientId.trim() === '') return;

		loading = true;
		error = null;
		try {
			const [list, policy] = await Promise.all([
				clients.medication.listPrescriptions({ encounterId, pageSize: 100 }),
				clients.medication.getMedicationPolicy({})
			]);
			prescriptions = list.prescriptions;
			structuredDoseClasses = policy.policy?.structuredDoseClasses ?? [];
			loadedFor = patientId;
		} catch (err) {
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	async function loadQueue() {
		if (!mayVerify) return;
		try {
			const response = await clients.medication.verificationQueue({ pageSize: 50 });
			queue = orderQueue(response.prescriptions.map(toQueueEntry));
		} catch (err) {
			error = presentError(err);
		}
	}

	async function prescribe(event: SubmitEvent) {
		event.preventDefault();
		if (prescribing || !canSubmit) return;

		prescribing = true;
		error = null;
		try {
			const amount = Number(doseAmount);
			const response = await clients.medication.prescribe({
				patientId,
				encounterId,
				ingredient: { code: ingredientCode, display: ingredientDisplay || ingredientCode },
				route,
				segments: [
					{
						sequence: 1,
						dose:
							doseAmount !== '' && Number.isFinite(amount)
								? { value: amount, unit: doseUnit }
								: undefined,
						freeTextDose: doseAmount === '' ? doseFreeText : '',
						timing:
							frequencyHours > 0 ? { intervalSeconds: BigInt(frequencyHours * 3600) } : undefined
					}
				],
				indication,
				// One answer per rule, exactly as reviewed. A blanket override
				// would make the verification record unreadable.
				overrides: answers
					.filter((answer) => answer.reason.trim() !== '')
					.map((answer) => ({ ruleId: answer.ruleId, reason: answer.reason }))
			});

			const written = response.prescription;
			if (written && written.findings.length > 0) {
				// Findings came back with the prescription: show them, with the
				// reasons already attached, rather than treating the write as
				// silently clean.
				findings = orderFindings(written.findings.map(toPresentedFinding));
			} else {
				findings = [];
				reasons = {};
			}
			ingredientCode = '';
			ingredientDisplay = '';
			doseAmount = '';
			doseFreeText = '';
			indication = '';
			await load();
		} catch (err) {
			const presented = presentError(err);
			error = presented;
			// A refusal that names findings is the common case: the safety
			// check ran and said no. Nothing to re-render here beyond the
			// banner, because the server does not return them on an error.
		} finally {
			prescribing = false;
		}
	}

	async function hold(prescription: Prescription) {
		if (acting !== '' || !mayPrescribeHere) return;
		acting = prescription.prescriptionId;
		error = null;
		try {
			await clients.medication.holdTherapy({
				change: {
					prescriptionId: prescription.prescriptionId,
					reason: 'held on the ward round',
					effectiveAt: timestampFromDate(new Date())
				}
			});
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			acting = '';
		}
	}

	async function verify(entry: QueueEntry) {
		if (acting !== '' || !mayVerify) return;
		acting = entry.prescriptionId;
		error = null;
		try {
			await clients.medication.verifyPrescription({
				prescriptionId: entry.prescriptionId,
				note: 'checked against the chart'
			});
			await loadQueue();
		} catch (err) {
			error = presentError(err);
		} finally {
			acting = '';
		}
	}

	function time(at: Date): string {
		return at.toLocaleString([], {
			day: '2-digit',
			month: 'short',
			hour: '2-digit',
			minute: '2-digit'
		});
	}

	let queueLoaded = $state(false);

	$effect(() => {
		if (mayRead && patientId.trim() !== '' && loadedFor !== patientId && !loading) {
			void load();
		}
	});

	$effect(() => {
		if (mayVerify && !queueLoaded) {
			queueLoaded = true;
			void loadQueue();
		}
	});
</script>

<h1>Medications</h1>

{#if !$session}
	<EmptyState kind="permission" title="Sign in to open the drug chart" />
{:else if !mayRead}
	<EmptyState
		kind="permission"
		title="You do not have access to prescriptions"
		detail="Ask your administrator for the medication read permission."
	/>
{:else}
	<ErrorBanner {error} onRetry={load} />

	{#if mayVerify && queue.length > 0}
		<section aria-labelledby="queue-heading">
			<h2 id="queue-heading">Awaiting pharmacist verification</h2>
			<ul class="panel">
				{#each queue as entry (entry.prescriptionId)}
					<li class:prominent={entry.worstSeverity === 'severe' || entry.worstSeverity === 'contraindicated'}>
						<div class="row-head">
							<span class="title">{entry.description}</span>
							<StatusChip label={therapyLabels[entry.therapyStatus]} tone="neutral" />
							{#if entry.findings.length > 0}
								<StatusChip
									label={`${entry.findings.length} safety finding${entry.findings.length === 1 ? '' : 's'}`}
									tone={severityTones[entry.worstSeverity]}
								/>
							{/if}
							{#if entry.overridden}
								<!--
								  SRS-MED-006: the pharmacist checks before dispensing,
								  and what the prescriber overrode is the first thing
								  they need to see.
								-->
								<StatusChip label="Overridden by prescriber" tone="caution" />
							{/if}
						</div>
						<p class="row-meta">
							<span>Patient <code>{entry.patientId.slice(0, 8)}</code></span>
							<span>{entry.prescriberId}</span>
							<span>{time(entry.createdAt)}</span>
						</p>
						{#each entry.findings as finding (finding.ruleId)}
							<p class="finding-line">
								<strong>{finding.severityLabel}</strong>
								{finding.kindLabel}: {finding.summary}
								{#if finding.existingOverrideReason}
									<span class="reason">Prescriber: {finding.existingOverrideReason}</span>
								{/if}
							</p>
						{/each}
						<button
							type="button"
							class="secondary"
							onclick={() => verify(entry)}
							disabled={acting !== ''}
						>
							{acting === entry.prescriptionId ? 'Verifying…' : 'Verify'}
						</button>
					</li>
				{/each}
			</ul>
		</section>
	{/if}

	<form class="picker" onsubmit={(e) => { e.preventDefault(); void load(); }}>
		<div>
			<label for="med-patient">Patient</label>
			<input id="med-patient" bind:value={patientId} />
		</div>
		<div>
			<label for="med-encounter">Encounter</label>
			<input id="med-encounter" bind:value={encounterId} />
		</div>
		<button type="submit" disabled={loading || patientId.trim() === ''}>
			{loading ? 'Loading…' : 'Open chart'}
		</button>
	</form>

	{#if loadedFor === ''}
		<EmptyState
			kind="search-first"
			title="Choose a patient"
			detail="The drug chart is per patient. The verification queue above is facility-wide."
		/>
	{:else}
		{#if mayPrescribeHere}
			<section aria-labelledby="prescribe-heading">
				<h2 id="prescribe-heading">Prescribe</h2>
				<form class="card" onsubmit={prescribe}>
					<div class="fields">
						<div>
							<label for="med-code">Code</label>
							<input id="med-code" bind:value={ingredientCode} />
						</div>
						<div>
							<label for="med-name">Medicine</label>
							<input id="med-name" bind:value={ingredientDisplay} />
						</div>
						<div>
							<label for="med-class">Class</label>
							<input id="med-class" bind:value={drugClass} placeholder="anticoagulant" />
						</div>
						<div>
							<label for="med-route">Route</label>
							<input id="med-route" bind:value={route} />
						</div>
						<div>
							<label for="med-amount">Dose</label>
							<input id="med-amount" bind:value={doseAmount} inputmode="decimal" />
						</div>
						<div>
							<label for="med-unit">Unit</label>
							<input id="med-unit" bind:value={doseUnit} />
						</div>
						<div>
							<label for="med-frequency">Every (hours)</label>
							<input id="med-frequency" type="number" min="0" bind:value={frequencyHours} />
						</div>
					</div>

					{#if !structuredDoseRequired}
						<label for="med-freetext">Or a free-text dose</label>
						<input id="med-freetext" bind:value={doseFreeText} placeholder="two puffs as needed" />
					{:else}
						<!--
						  SRS-MED-010. Said rather than merely enforced: a
						  prescriber who cannot find the free-text box needs to
						  know it is absent on purpose.
						-->
						<p class="hint">
							This medicine needs a numeric dose and unit. The eMAR and the dose checks
							cannot read free text.
						</p>
					{/if}

					<label for="med-indication">Indication</label>
					<input id="med-indication" bind:value={indication} />

					{#if validity.order.length > 0 && (ingredientCode !== '' || ingredientDisplay !== '')}
						<ul class="readiness">
							{#each validity.order as problem (problem)}
								<li>{problem}</li>
							{/each}
						</ul>
					{/if}

					{#if gate.state === 'contraindicated'}
						<div class="findings blocked" role="alert">
							<p class="findings-title">{gate.message}</p>
							{#each gate.findings as finding (finding.ruleId)}
								<p class="finding-line">
									<strong>{finding.kindLabel}</strong>
									{finding.summary}
									{#if finding.subjects.length > 0}
										<span class="reason">{finding.subjects.join(' + ')}</span>
									{/if}
									<!--
									  No reason box. There is no reason that clears a
									  contraindication, and offering a box then refusing
									  the submit is worse than not offering it — the
									  prescriber has already composed an argument.
									-->
								</p>
							{/each}
						</div>
					{:else if findings.length > 0}
						<div class="findings" role="status">
							<p class="findings-title">
								{gate.state === 'needs-reasons' ? gate.message : 'Safety findings'}
							</p>
							{#each findings as finding (finding.ruleId)}
								<div class="finding">
									<p class="finding-line">
										<StatusChip
											label={finding.severityLabel}
											tone={severityTones[finding.severity]}
										/>
										<strong>{finding.kindLabel}</strong>
										{finding.summary}
										<span class="reason">Rule {finding.ruleId} {finding.ruleVersion}</span>
									</p>
									{#if finding.overridable && finding.severity !== 'informational' && finding.existingOverrideReason === ''}
										<label for={`reason-${finding.ruleId}`}>Reason for proceeding</label>
										<input id={`reason-${finding.ruleId}`} bind:value={reasons[finding.ruleId]} />
									{:else if finding.existingOverrideReason}
										<p class="reason">Recorded: {finding.existingOverrideReason}</p>
									{/if}
								</div>
							{/each}
						</div>
					{/if}

					<button type="submit" disabled={!canSubmit || prescribing}>
						{prescribing ? 'Prescribing…' : 'Prescribe'}
					</button>
				</form>
			</section>
		{/if}

		<section aria-labelledby="chart-heading">
			<h2 id="chart-heading">Drug chart</h2>
			{#if prescriptions.length === 0}
				<EmptyState kind="empty" title="Nothing prescribed for this patient" />
			{:else}
				<ul class="panel">
					{#each prescriptions as prescription (prescription.prescriptionId)}
						{@const status = toTherapyStatus(prescription)}
						{@const formulary = describeFormulary(toFormularyDecision(prescription))}
						<li class:stopped={status === 'discontinued' || status === 'completed'}>
							<div class="row-head">
								<span class="title">{describePrescription(prescription)}</span>
								<StatusChip
									label={therapyLabels[status]}
									tone={status === 'active' ? 'positive' : status === 'held' ? 'caution' : 'neutral'}
								/>
								{#if formulary.prominent}
									<!--
									  Shown, never blocking (SRS-MED-012): the drug may
									  be exactly right, and the prescriber needs to know
									  what it takes to get it.
									-->
									<StatusChip label={formulary.label} tone="caution" />
								{/if}
								{#if prescription.verification?.by}
									<StatusChip label="Verified" tone="positive" />
								{/if}
							</div>
							<p class="row-meta">
								{#if prescription.indication}<span>for {prescription.indication}</span>{/if}
								{#if formulary.action}<span>{formulary.action}</span>{/if}
							</p>
							{#each prescription.findings as finding (finding.ruleId)}
								{@const presented = toPresentedFinding(finding)}
								<p class="finding-line">
									<strong>{presented.severityLabel}</strong>
									{presented.summary}
									{#if presented.existingOverrideReason}
										<span class="reason">Overridden: {presented.existingOverrideReason}</span>
									{/if}
								</p>
							{/each}
							{#if status === 'active' && mayPrescribeHere}
								<button
									type="button"
									class="secondary"
									onclick={() => hold(prescription)}
									disabled={acting !== ''}
								>
									{acting === prescription.prescriptionId ? 'Holding…' : 'Hold'}
								</button>
							{/if}
						</li>
					{/each}
				</ul>
			{/if}
		</section>
	{/if}
{/if}

<style>
	.picker {
		display: flex;
		align-items: flex-end;
		gap: 0.75rem;
		margin: 1rem 0;
		flex-wrap: wrap;
	}
	.picker > div {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
	}
	h2 {
		font-size: 1rem;
		margin: 1.25rem 0 0.5rem;
	}
	.panel {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}
	.panel li {
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 0.6rem 0.8rem;
		background: #fff;
	}
	.panel li.prominent {
		border-color: #e9b0ab;
		background: #fffafa;
	}
	.panel li.stopped {
		background: #f6f7f9;
		color: #5b6779;
	}
	.row-head {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		flex-wrap: wrap;
	}
	.title {
		font-weight: 600;
	}
	.row-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.2rem 0.9rem;
		margin: 0.3rem 0 0;
		font-size: 0.8125rem;
		color: #5b6779;
	}
	.card {
		background: #fff;
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 1rem 1.25rem;
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
	}
	.fields {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr));
		gap: 0.6rem;
	}
	.fields > div {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
	}
	label {
		font-size: 0.8125rem;
		font-weight: 600;
	}
	input {
		padding: 0.45rem 0.55rem;
		border: 1px solid #c8d0dd;
		border-radius: 6px;
		font: inherit;
	}
	.findings {
		border: 1px solid #e8cb91;
		background: #fdf3e0;
		color: #6b4708;
		border-radius: 6px;
		padding: 0.6rem 0.8rem;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}
	.findings.blocked {
		border-color: #e9b0ab;
		background: #fdeceb;
		color: #7a1c17;
	}
	.findings-title {
		margin: 0;
		font-weight: 600;
	}
	.finding {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
	}
	.finding-line {
		margin: 0.25rem 0 0;
		font-size: 0.9375rem;
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.4rem;
	}
	.reason {
		font-size: 0.8125rem;
		color: #5b6779;
	}
	.readiness {
		margin: 0.25rem 0 0;
		padding-left: 1.1rem;
		font-size: 0.8125rem;
		color: #6b4708;
	}
	.hint {
		color: #5b6779;
		font-size: 0.875rem;
		margin: 0;
	}
	button {
		align-self: flex-start;
		margin-top: 0.4rem;
		padding: 0.45rem 0.9rem;
		border-radius: 6px;
		border: 1px solid #1c5fd6;
		background: #1c5fd6;
		color: #fff;
		font: inherit;
		font-size: 0.9375rem;
		cursor: pointer;
	}
	button.secondary {
		background: #fff;
		color: #1c5fd6;
	}
	button:disabled {
		opacity: 0.6;
		cursor: not-allowed;
	}
	code {
		font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
	}
</style>
