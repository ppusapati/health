<!--
  Order composer and results inbox (UX-W1-04).

  Two halves of the same loop: what has been asked for, and what has come back
  and not been acted on. The rules are in $lib/orders/composer.ts and tested
  there.

  The composer's job is to make an order either complete or refused, never
  ambiguous — an ambiguous order is resolved downstream by somebody guessing.
  So a required indication blocks the button rather than warning beside it, and
  a duplicate is shown with what already exists and a box for why another is
  needed, never suppressed.

  The inbox sorts by escalations before age. A result that has escalated twice
  is one where the acknowledgement process has already failed, and it belongs
  above a fresher result that is merely unread.
-->
<script lang="ts">
	import { createApiClients } from '$lib/api/client.js';
	import { describeFieldReason, presentError, type PresentedError } from '$lib/api/errors.js';
	import { PUBLIC_API_BASE_URL } from '$lib/config.js';
	import ErrorBanner from '$lib/components/ErrorBanner.svelte';
	import EmptyState from '$lib/components/EmptyState.svelte';
	import StatusChip from '$lib/components/StatusChip.svelte';
	import { can, currentCredentials, session } from '$lib/session.js';
	import {
		acknowledgementProblem,
		describeOrderPriority,
		describeType,
		duplicateGate,
		mayPlace,
		orderInbox,
		validateOrder,
		type DuplicateCandidate,
		type InboxItem,
		type OrderDraft,
		type OrderPolicy,
		type OrderPriority,
		type OrderType
	} from '$lib/orders/composer.js';
	import {
		toDuplicateCandidate,
		toInboxItem,
		toPresentedOrder,
		wireOrderTypes,
		wirePriorities,
		type PresentedOrder
	} from '$lib/orders/mapping.js';
	import { timestampFromDate } from '@bufbuild/protobuf/wkt';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);

	let patientId = $state('');
	let encounterId = $state('');
	let loadedFor = $state('');

	let orders = $state<readonly PresentedOrder[]>([]);
	let inbox = $state<readonly InboxItem[]>([]);
	let loading = $state(false);
	let error = $state<PresentedError | null>(null);

	// Composer state.
	let type = $state<OrderType>('laboratory');
	let code = $state('');
	let display = $state('');
	let detail = $state('');
	let indication = $state('');
	let priority = $state<OrderPriority>('routine');
	let startAt = $state('');
	let frequencyHours = $state(0);
	let placing = $state(false);

	// Duplicate state, populated by the server's warning.
	let duplicates = $state<readonly DuplicateCandidate[]>([]);
	let duplicatesOverridable = $state(true);
	let duplicateWindowSeconds = $state(0);
	let acknowledged = $state<string[]>([]);
	let overrideReason = $state('');

	// Acknowledgement state for the inbox.
	let acknowledging = $state('');
	let actions = $state<Record<string, string>>({});

	/**
	 * Policy per order type.
	 *
	 * Read from configuration rather than hard-coded, because which types need
	 * an indication differs between hospitals — a list baked in here would be
	 * wrong somewhere, and wrong in the direction of letting an incomplete
	 * order through.
	 */
	let policies = $state<Record<string, OrderPolicy>>({});

	const mayRead = $derived($session ? can('orders.order.read') : false);
	const mayPlaceOrders = $derived($session ? can('orders.order.place') : false);
	const mayAcknowledge = $derived($session ? can('clinical.record.write') : false);

	const draft = $derived<OrderDraft>({
		type,
		patientId,
		encounterId,
		code,
		display,
		detail,
		indication,
		priority,
		startAt,
		frequencySeconds: frequencyHours > 0 ? frequencyHours * 3600 : 0,
		conditionalInstruction: ''
	});
	const policy = $derived(policies[type] ?? null);
	const validity = $derived(validateOrder(draft, policy));
	const gate = $derived(
		duplicateGate({
			candidates: duplicates,
			overridable: duplicatesOverridable,
			windowSeconds: duplicateWindowSeconds,
			acknowledged,
			reason: overrideReason
		})
	);
	const canPlace = $derived(mayPlaceOrders && mayPlace(validity, gate));

	const orderTypes: readonly OrderType[] = [
		'laboratory',
		'imaging',
		'procedure',
		'nursing',
		'diet',
		'blood_product',
		'referral',
		'allied_health'
	];
	const priorities: readonly OrderPriority[] = ['routine', 'urgent', 'stat', 'timing_critical'];

	/**
	 * The inbox is not scoped to a patient.
	 *
	 * Deliberately: it is the list of critical results nobody has acted on yet,
	 * and scoping it to whichever chart happens to be open would hide exactly
	 * the ones nobody is looking at. That is the failure SRS-CLN-012's
	 * escalation exists to catch, so the screen must not reintroduce it.
	 */
	async function loadInbox() {
		if (!mayAcknowledge) return;
		try {
			const critical = await clients.clinical.listCriticalResults({ pageSize: 50 });
			const at = new Date();
			inbox = orderInbox(
				critical.results
					.map((result) => toInboxItem(result, at))
					.filter((item): item is InboxItem => item !== null)
			);
		} catch (err) {
			error = presentError(err);
		}
	}

	async function load() {
		if (!mayRead || patientId.trim() === '') return;

		loading = true;
		error = null;
		try {
			const orderList = await clients.orders.listOrders({
				patientId,
				encounterId,
				pageSize: 100
			});
			orders = orderList.orders.map(toPresentedOrder);
			loadedFor = patientId;
		} catch (err) {
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	function acknowledgeDuplicate(orderId: string) {
		if (!acknowledged.includes(orderId)) {
			acknowledged = [...acknowledged, orderId];
		}
	}

	function resetDuplicates() {
		duplicates = [];
		acknowledged = [];
		overrideReason = '';
		duplicatesOverridable = true;
		duplicateWindowSeconds = 0;
	}

	async function place(event: SubmitEvent) {
		event.preventDefault();
		if (placing || !canPlace) return;

		placing = true;
		error = null;
		try {
			const response = await clients.orders.placeOrder({
				type: wireOrderTypes[type],
				patientId,
				encounterId,
				code: { code, display: display || code },
				detail,
				indication,
				priority: wirePriorities[priority],
				timing:
					startAt !== '' || frequencyHours > 0
						? {
								startAt: startAt ? timestampFromDate(new Date(startAt)) : undefined,
								frequencySeconds: BigInt(frequencyHours > 0 ? frequencyHours * 3600 : 0)
							}
						: undefined,
				// Exactly what was reviewed, with the reason. Sending a blanket
				// acknowledgement would turn the server's independent check into
				// a rubber stamp.
				acknowledgeDuplicates: gate.state === 'overridden' ? overrideReason : ''
			});

			if (!response.order && response.warning) {
				// Not a failure: the server found existing orders this screen
				// did not know about. Shown for review.
				duplicates = response.warning.existing.map(toDuplicateCandidate);
				duplicatesOverridable = response.warning.overridable;
				duplicateWindowSeconds = Number(response.warning.windowSeconds);
				acknowledged = [];
				overrideReason = '';
				return;
			}

			code = '';
			display = '';
			detail = '';
			indication = '';
			resetDuplicates();
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			placing = false;
		}
	}

	async function acknowledge(item: InboxItem) {
		const action = actions[item.observationId] ?? '';
		if (acknowledging !== '' || acknowledgementProblem(action) !== '') return;

		acknowledging = item.observationId;
		error = null;
		try {
			await clients.clinical.acknowledgeCriticalResult({
				observationId: item.observationId,
				action
			});
			actions = { ...actions, [item.observationId]: '' };
			await loadInbox();
		} catch (err) {
			error = presentError(err);
		} finally {
			acknowledging = '';
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

	let inboxLoaded = $state(false);

	$effect(() => {
		if (mayRead && patientId.trim() !== '' && loadedFor !== patientId && !loading) {
			void load();
		}
	});

	$effect(() => {
		if (mayAcknowledge && !inboxLoaded) {
			inboxLoaded = true;
			void loadInbox();
		}
	});
</script>

<h1>Orders and results</h1>

{#if !$session}
	<EmptyState kind="permission" title="Sign in to place orders" />
{:else if !mayRead}
	<EmptyState
		kind="permission"
		title="You do not have access to orders"
		detail="Ask your administrator for the orders read permission."
	/>
{:else}
	<ErrorBanner {error} onRetry={load} />

	<form class="picker" onsubmit={(e) => { e.preventDefault(); void load(); }}>
		<div>
			<label for="ord-patient">Patient</label>
			<input id="ord-patient" bind:value={patientId} />
		</div>
		<div>
			<label for="ord-encounter">Encounter</label>
			<input id="ord-encounter" bind:value={encounterId} />
		</div>
		<button type="submit" disabled={loading || patientId.trim() === ''}>
			{loading ? 'Loading…' : 'Open'}
		</button>
	</form>

	{#if inbox.length > 0}
			<section aria-labelledby="inbox-heading">
				<h2 id="inbox-heading">Results awaiting action</h2>
				<ul class="panel">
					{#each inbox as item (item.observationId)}
						<li class="prominent">
							<div class="row-head">
								<span class="title">{item.display}</span>
								<span class="value">{item.value}</span>
								<StatusChip label={item.interpretationLabel} tone="critical" />
								{#if item.dueEscalations > 0}
									<!--
									  SRS-CLN-012: unacknowledged critical results
									  escalate. Shown with the count, because a result
									  that has escalated twice is a process failure
									  rather than a fresh arrival.
									-->
									<StatusChip
										label={`Escalated ${item.dueEscalations}×`}
										tone="critical"
									/>
								{/if}
							</div>
							<p class="row-meta">
								<span>{time(item.effectiveAt)}</span>
								<span>Waiting {item.waitingMinutes} min</span>
							</p>
							{#if mayAcknowledge}
								<div class="ack">
									<label for={`ack-${item.observationId}`}>
										What was done about this?
									</label>
									<input
										id={`ack-${item.observationId}`}
										bind:value={actions[item.observationId]}
										placeholder="discussed with registrar, insulin-dextrose started"
									/>
									<button
										type="button"
										onclick={() => acknowledge(item)}
										disabled={acknowledging !== '' ||
											acknowledgementProblem(actions[item.observationId] ?? '') !== ''}
									>
										{acknowledging === item.observationId ? 'Recording…' : 'Acknowledge'}
									</button>
									{#if acknowledgementProblem(actions[item.observationId] ?? '') !== ''}
										<!--
										  Not "Seen". SRS-CLN-012 asks for the action
										  taken, and an acknowledgement with no action
										  closes the loop administratively while leaving
										  the next reader unable to tell whether anything
										  was done.
										-->
										<p class="hint">
											{acknowledgementProblem(actions[item.observationId] ?? '')}
										</p>
									{/if}
								</div>
							{/if}
						</li>
					{/each}
				</ul>
			</section>
		{/if}

	{#if loadedFor === ''}
		<EmptyState
			kind="search-first"
			title="Choose a patient"
			detail="Orders are shown per patient. Critical results above are ward-wide."
		/>
	{:else}
		{#if mayPlaceOrders}
			<section aria-labelledby="composer-heading">
				<h2 id="composer-heading">Place an order</h2>
				<form class="card" onsubmit={place}>
					<div class="fields">
						<div>
							<label for="ord-type">Type</label>
							<select id="ord-type" bind:value={type} onchange={resetDuplicates}>
								{#each orderTypes as option (option)}
									<option value={option}>{describeType(option)}</option>
								{/each}
							</select>
						</div>
						<div>
							<label for="ord-code">Code</label>
							<input id="ord-code" bind:value={code} />
							{#if error?.fieldViolations.code}
								<p class="field-error">{describeFieldReason(error.fieldViolations.code)}</p>
							{/if}
						</div>
						<div>
							<label for="ord-display">Name</label>
							<input id="ord-display" bind:value={display} />
						</div>
						<div>
							<label for="ord-priority">Priority</label>
							<select id="ord-priority" bind:value={priority}>
								{#each priorities as option (option)}
									<option value={option}>{describeOrderPriority(option)}</option>
								{/each}
							</select>
						</div>
					</div>

					<label for="ord-indication">
						Clinical indication{policy?.indicationRequired ? '' : ' (optional)'}
					</label>
					<input id="ord-indication" bind:value={indication} />
					{#if validity.problems.indication}
						<p class="field-error">{validity.problems.indication}</p>
					{/if}

					{#if policy?.structuredTimingRequired}
						<div class="fields">
							<div>
								<label for="ord-start">Start at</label>
								<input id="ord-start" type="datetime-local" bind:value={startAt} />
								{#if validity.problems.startAt}
									<p class="field-error">{validity.problems.startAt}</p>
								{/if}
							</div>
							<div>
								<label for="ord-frequency">Every (hours)</label>
								<input id="ord-frequency" type="number" min="0" bind:value={frequencyHours} />
								{#if validity.problems.frequency}
									<p class="field-error">{validity.problems.frequency}</p>
								{/if}
							</div>
						</div>
					{/if}

					<label for="ord-detail">Detail</label>
					<input id="ord-detail" bind:value={detail} />

					{#if gate.state === 'needs-override' || gate.state === 'refused'}
						<div class="duplicates" role="status">
							<p class="duplicates-title">{gate.message}</p>
							<ul>
								{#each gate.candidates as candidate (candidate.orderId)}
									<li>
										<code>{candidate.number}</code>
										{candidate.display} — {candidate.statusLabel},
										{time(candidate.placedAt)} by {candidate.requesterId}
										{#if gate.state === 'needs-override'}
											{#if acknowledged.includes(candidate.orderId)}
												<span class="ack-done">Reviewed</span>
											{:else}
												<button
													type="button"
													class="secondary"
													onclick={() => acknowledgeDuplicate(candidate.orderId)}
												>
													I have reviewed this
												</button>
											{/if}
										{/if}
									</li>
								{/each}
							</ul>
							{#if gate.state === 'needs-override'}
								<label for="ord-override">Why is another needed?</label>
								<input id="ord-override" bind:value={overrideReason} />
							{/if}
						</div>
					{/if}

					{#if !validity.ready && validity.order.length > 0 && (code !== '' || display !== '')}
						<ul class="readiness">
							{#each validity.order as problem (problem)}
								<li>{problem}</li>
							{/each}
						</ul>
					{/if}

					<button type="submit" disabled={!canPlace || placing}>
						{placing ? 'Placing…' : 'Place order'}
					</button>
				</form>
			</section>
		{/if}

		<section aria-labelledby="orders-heading">
			<h2 id="orders-heading">Orders</h2>
			{#if orders.length === 0}
				<EmptyState kind="empty" title="No orders for this patient" />
			{:else}
				<table>
					<caption class="visually-hidden">Orders for this patient</caption>
					<thead>
						<tr>
							<th scope="col">Number</th>
							<th scope="col">Order</th>
							<th scope="col">Type</th>
							<th scope="col">Priority</th>
							<th scope="col">Status</th>
							<th scope="col">Placed</th>
						</tr>
					</thead>
					<tbody>
						{#each orders as order (order.orderId)}
							<tr class:closed={!order.live}>
								<td><code>{order.number}</code></td>
								<td>
									{order.display}
									{#if order.indication}
										<span class="indication">for {order.indication}</span>
									{/if}
									{#if order.overrideReason}
										<!--
										  A repeat placed over a duplicate warning shows
										  why, so the row does not read as unexplained.
										-->
										<span class="indication">repeat: {order.overrideReason}</span>
									{/if}
								</td>
								<td>{describeType(order.type)}</td>
								<td>{describeOrderPriority(order.priority)}</td>
								<td>{order.statusLabel}</td>
								<td>{time(order.placedAt)}</td>
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
		gap: 0.75rem;
		margin-bottom: 1rem;
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
	.row-head {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		flex-wrap: wrap;
	}
	.title {
		font-weight: 600;
	}
	.value {
		font-variant-numeric: tabular-nums;
	}
	.row-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.2rem 0.9rem;
		margin: 0.3rem 0 0;
		font-size: 0.8125rem;
		color: #5b6779;
	}
	.ack {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		margin-top: 0.5rem;
	}
	.ack-done {
		color: #11593a;
		font-size: 0.8125rem;
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
		grid-template-columns: repeat(auto-fit, minmax(11rem, 1fr));
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
	input,
	select {
		padding: 0.45rem 0.55rem;
		border: 1px solid #c8d0dd;
		border-radius: 6px;
		font: inherit;
	}
	.duplicates {
		border: 1px solid #e8cb91;
		background: #fdf3e0;
		color: #6b4708;
		border-radius: 6px;
		padding: 0.6rem 0.8rem;
		display: flex;
		flex-direction: column;
		gap: 0.3rem;
	}
	.duplicates-title {
		margin: 0;
		font-weight: 600;
	}
	.duplicates ul {
		margin: 0;
		padding-left: 1.1rem;
		font-size: 0.9375rem;
	}
	.duplicates li {
		margin-bottom: 0.25rem;
	}
	.readiness {
		margin: 0.25rem 0 0;
		padding-left: 1.1rem;
		font-size: 0.8125rem;
		color: #6b4708;
	}
	.field-error {
		margin: 0;
		color: #7a1c17;
		font-size: 0.8125rem;
	}
	.hint {
		color: #5b6779;
		font-size: 0.8125rem;
		margin: 0;
	}
	button {
		align-self: flex-start;
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
		padding: 0.2rem 0.5rem;
		font-size: 0.8125rem;
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
	tr.closed {
		color: #5b6779;
	}
	.indication {
		display: block;
		font-size: 0.8125rem;
		color: #5b6779;
	}
	code {
		font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
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
