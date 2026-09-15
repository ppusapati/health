<!--
  Nursing and triage workspace (UX-W1-03).

  The worklist, the flowsheet and the risk panel — what a nurse reads between a
  drug round and a call bell, on a shared terminal, nine hours into a shift. The
  rules are in $lib/ward/worklist.ts and tested there.

  The screen is organised around one question: what is not being done. Overdue
  work and escalations sit above everything, and the counts in the header split
  overdue-critical out from overdue, because that is the number a nurse in
  charge acts on and it disappears if it is folded into a pile of late routine
  observations.

  Charting an observation is a form rather than a single field because the
  observation time is as important as the value. A late entry carries both
  times and a reason; SRS-NUR-003 requires the first two and the reason is what
  makes the entry auditable rather than merely labelled.
-->
<script lang="ts">
	import { onDestroy } from 'svelte';
	import { createApiClients } from '$lib/api/client.js';
	import { presentError, type PresentedError } from '$lib/api/errors.js';
	import { PUBLIC_API_BASE_URL } from '$lib/config.js';
	import ErrorBanner from '$lib/components/ErrorBanner.svelte';
	import EmptyState from '$lib/components/EmptyState.svelte';
	import StatusChip from '$lib/components/StatusChip.svelte';
	import { can, currentCredentials, session } from '$lib/session.js';
	import {
		isLate,
		orderEntries,
		orderTasks,
		summarise,
		validateChartEntry,
		type PresentedEntry,
		type PresentedRisk,
		type PresentedTask
	} from '$lib/ward/worklist.js';
	import { toPresentedEntry, toPresentedRisk, toPresentedTask } from '$lib/ward/mapping.js';
	import { EntrySource } from '$gen/healthcare/nursing/v1/nursing_pb.js';
	import { timestampFromDate } from '@bufbuild/protobuf/wkt';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);

	let encounterId = $state('');
	let submittedEncounter = $state('');

	let tasks = $state<readonly PresentedTask[]>([]);
	let entries = $state<readonly PresentedEntry[]>([]);
	let risks = $state<readonly PresentedRisk[]>([]);
	let patientId = $state('');

	let loading = $state(false);
	let error = $state<PresentedError | null>(null);
	let actingOn = $state('');
	let now = $state(new Date());

	// Charting form.
	let chartCode = $state('');
	let chartDisplay = $state('');
	let chartValue = $state('');
	let chartUnit = $state('');
	let chartObservedAt = $state(localNow());
	let chartLateReason = $state('');
	let charting = $state(false);

	const mayRead = $derived($session ? can('nursing.record.read') : false);
	const mayWrite = $derived($session ? can('nursing.record.write') : false);

	// Ticks so "overdue by" and the late-entry threshold stay true while the
	// screen sits open on a ward terminal, which is where it always sits.
	const tick = setInterval(() => {
		now = new Date();
	}, 15_000);
	onDestroy(() => clearInterval(tick));

	const summary = $derived(summarise(tasks));
	const observedAtDate = $derived(chartObservedAt ? new Date(chartObservedAt) : null);
	const chartValidity = $derived(
		validateChartEntry(
			{
				code: chartCode,
				value: chartValue,
				observedAt: observedAtDate,
				lateReason: chartLateReason
			},
			now
		)
	);
	const chartIsLate = $derived(observedAtDate !== null && isLate(observedAtDate, now));

	const priorityTones = {
		critical: 'critical',
		urgent: 'caution',
		routine: 'neutral',
		unspecified: 'neutral'
	} as const;

	function localNow(): string {
		const at = new Date();
		const offset = at.getTimezoneOffset() * 60_000;
		return new Date(at.getTime() - offset).toISOString().slice(0, 16);
	}

	async function load() {
		if (!mayRead || encounterId.trim() === '') return;

		loading = true;
		error = null;
		try {
			const [worklist, flowsheet, due] = await Promise.all([
				clients.nursing.getWorklist({ encounterId, pendingOnly: false, pageSize: 100 }),
				clients.nursing.getFlowsheet({ encounterId, pageSize: 100 }),
				clients.nursing.listDueReassessments({ encounterId, pageSize: 50 })
			]);

			const at = new Date();
			now = at;
			tasks = orderTasks(worklist.tasks.map((task) => toPresentedTask(task, at)));
			entries = orderEntries(flowsheet.entries.map(toPresentedEntry));
			risks = due.assessments.map((risk) => toPresentedRisk(risk, at));
			patientId = worklist.tasks[0]?.patientId ?? flowsheet.entries[0]?.patientId ?? '';
			submittedEncounter = encounterId;
		} catch (err) {
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	async function complete(task: PresentedTask, evidence: string) {
		if (actingOn !== '' || !mayWrite) return;
		actingOn = task.taskId;
		error = null;
		try {
			await clients.nursing.completeTask({ taskId: task.taskId, evidence });
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			actingOn = '';
		}
	}

	async function chart(event: SubmitEvent) {
		event.preventDefault();
		if (charting || !mayWrite || !chartValidity.ready || !observedAtDate) return;

		charting = true;
		error = null;
		try {
			const numeric = Number(chartValue);
			await clients.nursing.chartObservation({
				patientId,
				encounterId,
				code: { code: chartCode, display: chartDisplay || chartCode },
				value: Number.isFinite(numeric) ? { value: numeric, unit: chartUnit } : undefined,
				textValue: Number.isFinite(numeric) ? '' : chartValue,
				observedAt: timestampFromDate(observedAtDate),
				source: EntrySource.MANUAL,
				// Sent whenever it was taken materially earlier, so the record
				// carries why rather than only that it was late.
				lateEntryReason: chartIsLate ? chartLateReason : ''
			});
			chartValue = '';
			chartLateReason = '';
			chartObservedAt = localNow();
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			charting = false;
		}
	}

	function time(at: Date): string {
		return at.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
	}

	function lateness(task: PresentedTask): string {
		if (!task.overdue || task.overdueMinutes === null) return '';
		const minutes = task.overdueMinutes;
		if (minutes < 60) return `${minutes} min late`;
		return `${Math.floor(minutes / 60)}h ${minutes % 60}m late`;
	}
</script>

<h1>Ward worklist</h1>

{#if !$session}
	<EmptyState kind="permission" title="Sign in to open the ward worklist" />
{:else if !mayRead}
	<EmptyState
		kind="permission"
		title="You do not have access to nursing records"
		detail="Ask your administrator for the nursing read permission."
	/>
{:else}
	<ErrorBanner {error} onRetry={load} />

	<form class="picker" onsubmit={(e) => { e.preventDefault(); void load(); }}>
		<label for="encounter">Encounter</label>
		<input id="encounter" bind:value={encounterId} placeholder="Encounter identifier" />
		<button type="submit" disabled={loading || encounterId.trim() === ''}>
			{loading ? 'Loading…' : 'Open'}
		</button>
	</form>

	{#if submittedEncounter === ''}
		<EmptyState
			kind="search-first"
			title="Choose an encounter"
			detail="The worklist, flowsheet and risk panel are per encounter."
		/>
	{:else}
		<div class="summary">
			<span><strong>{summary.open}</strong> open</span>
			<span class:alarming={summary.overdue > 0}><strong>{summary.overdue}</strong> overdue</span>
			<!--
			  Counted separately. Folded into "overdue" it hides behind a pile of
			  late routine observations, and it is the number a nurse in charge
			  acts on.
			-->
			<span class:alarming={summary.overdueCritical > 0}>
				<strong>{summary.overdueCritical}</strong> overdue and critical
			</span>
			<span class:alarming={summary.escalated > 0}>
				<strong>{summary.escalated}</strong> escalated
			</span>
		</div>

		<section aria-labelledby="tasks-heading">
			<h2 id="tasks-heading">Work</h2>
			{#if tasks.length === 0}
				<EmptyState kind="empty" title="Nothing on the worklist for this encounter" />
			{:else}
				<ul class="panel">
					{#each tasks as task (task.taskId)}
						<li class:prominent={task.overdue && task.open} class:done={!task.open}>
							<div class="row-head">
								<span class="title">{task.description}</span>
								<StatusChip
									label={task.priorityLabel}
									tone={priorityTones[task.priority]}
								/>
								{#if task.escalated}
									<!--
									  SRS-NUR-011: an overdue critical task escalates,
									  and who it went to is on the row — an escalation
									  nobody can see is one nobody closes.
									-->
									<StatusChip label={`Escalated to ${task.escalatedTo}`} tone="critical" />
								{/if}
							</div>
							<p class="row-meta">
								{#if task.dueAt}<span>Due {time(task.dueAt)}</span>{/if}
								{#if task.overdue}<span class="late">{lateness(task)}</span>{/if}
								{#if task.source}<span>From {task.source.replace('_', ' ')}</span>{/if}
								{#if !task.open}<span>{task.status.replace('_', ' ')}</span>{/if}
							</p>
							{#if task.open && mayWrite}
								<button
									type="button"
									class="secondary"
									onclick={() => complete(task, 'completed on the ward round')}
									disabled={actingOn !== ''}
								>
									{actingOn === task.taskId ? 'Recording…' : 'Mark done'}
								</button>
							{/if}
						</li>
					{/each}
				</ul>
			{/if}
		</section>

		{#if risks.length > 0}
			<section aria-labelledby="risks-heading">
				<h2 id="risks-heading">Reassessments due</h2>
				<ul class="panel">
					{#each risks as risk (risk.riskId)}
						<li class:prominent={risk.escalate}>
							<div class="row-head">
								<span class="title">{risk.domain}</span>
								<!--
								  The band the scale assigned, never one derived from
								  the total here: a second scale would disagree with
								  the first the day somebody edits it (SRS-NUR-005).
								-->
								<StatusChip label={risk.band} tone={risk.escalate ? 'critical' : 'neutral'} />
							</div>
							<p class="row-meta">
								<span>Score {risk.total}</span>
								<span>Scale {risk.scaleVersion}</span>
								<span>Assessed {time(risk.assessedAt)}</span>
								{#if risk.reassessmentDue}<span class="late">Reassessment due</span>{/if}
							</p>
						</li>
					{/each}
				</ul>
			</section>
		{/if}

		<section aria-labelledby="flowsheet-heading">
			<h2 id="flowsheet-heading">Flowsheet</h2>

			{#if mayWrite}
				<form class="card" onsubmit={chart}>
					<h3>Chart an observation</h3>
					<div class="fields">
						<div>
							<label for="chart-code">Code</label>
							<input id="chart-code" bind:value={chartCode} placeholder="BP-SYS" />
						</div>
						<div>
							<label for="chart-display">Name</label>
							<input id="chart-display" bind:value={chartDisplay} placeholder="Systolic BP" />
						</div>
						<div>
							<label for="chart-value">Value</label>
							<input id="chart-value" bind:value={chartValue} />
						</div>
						<div>
							<label for="chart-unit">Unit</label>
							<input id="chart-unit" bind:value={chartUnit} placeholder="mmHg" />
						</div>
						<div>
							<label for="chart-observed">Taken at</label>
							<input id="chart-observed" type="datetime-local" bind:value={chartObservedAt} />
						</div>
					</div>

					{#if chartIsLate}
						<!--
						  Appears as soon as the time is set back, not on submit.
						  Asking for a reason after the nurse has pressed save is
						  how the field gets filled with a full stop.
						-->
						<label for="chart-late">Why is this being charted now?</label>
						<input
							id="chart-late"
							bind:value={chartLateReason}
							placeholder="monitor disconnected during transfer"
						/>
					{/if}

					{#if !chartValidity.ready && (chartValue !== '' || chartCode !== '')}
						<ul class="readiness">
							{#each chartValidity.problems as problem (problem)}
								<li>{problem}</li>
							{/each}
						</ul>
					{/if}

					<button type="submit" disabled={charting || !chartValidity.ready}>
						{charting ? 'Charting…' : 'Chart'}
					</button>
				</form>
			{/if}

			{#if entries.length === 0}
				<EmptyState kind="empty" title="Nothing charted for this encounter" />
			{:else}
				<table>
					<caption class="visually-hidden">Flowsheet, most recent observation first</caption>
					<thead>
						<tr>
							<th scope="col">Observation</th>
							<th scope="col">Value</th>
							<th scope="col">Taken</th>
							<th scope="col">Charted</th>
							<th scope="col">Source</th>
						</tr>
					</thead>
					<tbody>
						{#each entries as entry (entry.entryId)}
							<tr class:late-row={entry.late}>
								<td>{entry.display}</td>
								<td class="value">{entry.value}</td>
								<td>{time(entry.observedAt)}</td>
								<td>
									{time(entry.recordedAt)}
									{#if entry.late}
										<!--
										  Both times, always. Showing only the charted
										  time turns a three-hour-old blood pressure
										  into a fresh reading.
										-->
										<span class="late">
											late by {entry.lateByMinutes} min
											{#if entry.lateReason}— {entry.lateReason}{/if}
										</span>
									{/if}
								</td>
								<td>{entry.sourceLabel}</td>
							</tr>
						{/each}
					</tbody>
				</table>
			{/if}
		</section>
	{/if}
{/if}

<style>
	.picker {
		display: flex;
		align-items: flex-end;
		gap: 0.5rem;
		margin-bottom: 1rem;
		flex-wrap: wrap;
	}
	.picker label {
		font-size: 0.8125rem;
		font-weight: 600;
	}
	.picker input {
		min-width: 18rem;
	}
	.summary {
		display: flex;
		gap: 1.25rem;
		flex-wrap: wrap;
		margin-bottom: 1rem;
		font-size: 0.9375rem;
	}
	.alarming {
		color: #7a1c17;
		font-weight: 600;
	}
	h2 {
		font-size: 1rem;
		margin: 1.25rem 0 0.5rem;
	}
	h3 {
		font-size: 0.9375rem;
		margin: 0 0 0.35rem;
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
	.panel li.done {
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
	.late {
		color: #7a1c17;
	}
	.card {
		background: #fff;
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 1rem 1.25rem;
		margin-bottom: 1rem;
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
	.readiness {
		margin: 0.25rem 0 0;
		padding-left: 1.1rem;
		font-size: 0.8125rem;
		color: #6b4708;
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
	table {
		width: 100%;
		border-collapse: collapse;
		background: #fff;
		border: 1px solid #dde2ea;
		border-radius: 8px;
		overflow: hidden;
	}
	th,
	td {
		text-align: left;
		padding: 0.55rem 0.7rem;
		border-bottom: 1px solid #eef1f5;
		font-size: 0.9375rem;
		vertical-align: top;
	}
	th {
		background: #f6f7f9;
		font-size: 0.75rem;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: #5b6779;
	}
	tr.late-row {
		background: #fdf9f0;
	}
	td.value {
		font-variant-numeric: tabular-nums;
	}
	.visually-hidden {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip: rect(0 0 0 0);
		white-space: nowrap;
	}
</style>
