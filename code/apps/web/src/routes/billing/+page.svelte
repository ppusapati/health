<!--
  Billing and payment workspace (UX-W1-06).

  The cashier's desk: what a patient owes, what has been charged and not yet
  invoiced, the invoices raised, and taking money. The rules are in
  $lib/billing and tested there.

  Two things on this screen are controls.

  The balance is derived from the ledger and shown beside the server's figure
  when the two disagree. SRS-BIL-012 asks for "balance derives from ledger and
  reconciles", and a derivation nobody compares is not a reconciliation. A
  cashier about to take money against a figure should see when the figure
  cannot be accounted for line by line.

  There is no edit control on an issued invoice. The patient is holding a copy.
  A correction is a credit or debit note against the original (SRS-BIL-010),
  and that is the only path the screen offers.

  The idempotency key is minted when the form opens, not when the button is
  pressed. A key generated on the click changes on every retry, which is
  precisely the case it exists to cover.
-->
<script lang="ts">
	import { createApiClients, newCorrelationId } from '$lib/api/client.js';
	import { presentError, type PresentedError } from '$lib/api/errors.js';
	import { PUBLIC_API_BASE_URL } from '$lib/config.js';
	import ErrorBanner from '$lib/components/ErrorBanner.svelte';
	import EmptyState from '$lib/components/EmptyState.svelte';
	import StatusChip from '$lib/components/StatusChip.svelte';
	import { can, currentCredentials, session } from '$lib/session.js';
	import {
		buildStatement,
		closeReadiness,
		describeAccountHeader,
		describeMethod,
		unbilledTotal,
		validatePayment,
		type CloseException,
		type PaymentMethod,
		type PresentedCharge,
		type PresentedEntry,
		type PresentedInvoice
	} from '$lib/billing/account.js';
	import { formatMoney, parseMoney, type Money } from '$lib/billing/money.js';
	import {
		fromMoney,
		toCloseException,
		toMoney,
		toPresentedCharge,
		toPresentedEntry,
		toPresentedInvoice,
		wireMethods
	} from '$lib/billing/mapping.js';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);

	let encounterId = $state('');
	let accountId = $state('');
	let currency = $state('INR');
	let loadedFor = $state('');

	let entries = $state<readonly PresentedEntry[]>([]);
	let charges = $state<readonly PresentedCharge[]>([]);
	let invoices = $state<readonly PresentedInvoice[]>([]);
	let exceptions = $state<readonly CloseException[]>([]);
	let reportedBalance = $state<Money>({ minor: 0n, currency: 'INR' });
	let deposits = $state<Money>({ minor: 0n, currency: 'INR' });

	let loading = $state(false);
	let error = $state<PresentedError | null>(null);
	let acting = $state('');

	// Payment form.
	let amountTyped = $state('');
	let method = $state<PaymentMethod>('cash');
	let isDeposit = $state(false);
	// Minted once, when the form appears. A key generated on the click changes
	// on every retry, which is exactly the case it exists to cover.
	let idempotencyKey = $state(newCorrelationId());
	let taking = $state(false);
	let lastReceipt = $state('');

	const mayRead = $derived($session ? can('billing.account.read') : false);
	const mayInvoice = $derived($session ? can('billing.invoice.issue') : false);
	const mayCollect = $derived($session ? can('billing.payment.collect') : false);

	const statement = $derived(
		buildStatement({ entries, reportedBalance, deposits, currency })
	);
	const unbilled = $derived(unbilledTotal(charges, currency));
	const readiness = $derived(closeReadiness(exceptions));
	const parsedAmount = $derived(parseMoney(amountTyped, currency));
	const paymentValidity = $derived(
		validatePayment({ amount: parsedAmount, method, idempotencyKey, accountId })
	);

	const methods: readonly PaymentMethod[] = [
		'cash',
		'card',
		'upi',
		'bank_transfer',
		'cheque',
		'payer_settlement'
	];

	async function load() {
		if (!mayRead || encounterId.trim() === '') return;

		loading = true;
		error = null;
		try {
			const account = await clients.billing.getAccount({ encounterId });
			const resolved = account.account;
			if (!resolved) {
				accountId = '';
				loadedFor = encounterId;
				return;
			}
			accountId = resolved.accountId;
			currency = resolved.currency || 'INR';

			const [statementResponse, chargeList, invoiceList, close] = await Promise.all([
				clients.billing.statement({ accountId }),
				clients.billing.listCharges({ accountId, pageSize: 200 }),
				clients.billing.listInvoices({ accountId, pageSize: 50 }),
				clients.billing.closeReadiness({ accountId })
			]);

			entries = statementResponse.entries.map((entry) => toPresentedEntry(entry, currency));
			reportedBalance = toMoney(statementResponse.balance, currency);
			deposits = toMoney(statementResponse.deposits, currency);
			charges = chargeList.charges.map((charge) => toPresentedCharge(charge, currency));
			invoices = invoiceList.invoices.map((invoice) => toPresentedInvoice(invoice, currency));
			exceptions = close.exceptions.map((exception) => toCloseException(exception, currency));
			loadedFor = encounterId;
		} catch (err) {
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	async function takePayment(event: SubmitEvent) {
		event.preventDefault();
		if (taking || !mayCollect || !paymentValidity.ready || !parsedAmount) return;

		taking = true;
		error = null;
		try {
			const response = await clients.billing.receivePayment({
				accountId,
				amount: fromMoney(parsedAmount),
				method: wireMethods[method],
				deposit: isDeposit,
				idempotencyKey
			});
			lastReceipt = response.entry?.receiptNumber ?? '';
			amountTyped = '';
			// A new key for the next payment. Reusing this one would make the
			// second payment a no-op that looks like a success.
			idempotencyKey = newCorrelationId();
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			taking = false;
		}
	}

	async function raiseInvoice() {
		if (acting !== '' || !mayInvoice) return;
		acting = 'invoice';
		error = null;
		try {
			await clients.billing.raiseInvoice({ accountId, issue: true });
			await load();
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

	$effect(() => {
		if (mayRead && encounterId.trim() !== '' && loadedFor !== encounterId && !loading) {
			void load();
		}
	});
</script>

<h1>Billing</h1>

{#if !$session}
	<EmptyState kind="permission" title="Sign in to open a patient account" />
{:else if !mayRead}
	<EmptyState
		kind="permission"
		title="You do not have access to patient accounts"
		detail="Ask your administrator for the billing read permission."
	/>
{:else}
	<ErrorBanner {error} onRetry={load} />

	<form class="picker" onsubmit={(e) => { e.preventDefault(); void load(); }}>
		<div>
			<label for="bill-encounter">Encounter</label>
			<input id="bill-encounter" bind:value={encounterId} />
		</div>
		<button type="submit" disabled={loading || encounterId.trim() === ''}>
			{loading ? 'Loading…' : 'Open account'}
		</button>
	</form>

	{#if loadedFor === ''}
		<EmptyState
			kind="search-first"
			title="Choose an encounter"
			detail="A patient account belongs to an encounter."
		/>
	{:else if accountId === ''}
		<EmptyState
			kind="empty"
			title="No account for this encounter"
			detail="An account is opened when the first charge is posted."
		/>
	{:else}
		<div class="header">
			<p class="balance">{describeAccountHeader(statement, undefined)}</p>
			{#if !statement.reconciles}
				<!--
				  SRS-BIL-012. Surfaced rather than resolved: it means either the
				  entry list is incomplete or something is genuinely wrong, and a
				  cashier about to take money against the figure should see it.
				-->
				<p class="mismatch" role="alert">
					The ledger adds up to {formatMoney(statement.derivedBalance)} but the account
					reports {formatMoney(statement.reportedBalance)}. Do not take payment against
					this figure until it is checked.
				</p>
			{/if}
			{#if lastReceipt}
				<p class="receipt" role="status">Receipt <code>{lastReceipt}</code></p>
			{/if}
		</div>

		<div class="columns">
			<section aria-labelledby="charges-heading">
				<h2 id="charges-heading">Charges</h2>
				<p class="subtotal">
					Unbilled: <strong>{formatMoney(unbilled)}</strong>
					{#if mayInvoice && unbilled.minor > 0n}
						<button type="button" onclick={raiseInvoice} disabled={acting !== ''}>
							{acting === 'invoice' ? 'Raising…' : 'Raise invoice'}
						</button>
					{/if}
				</p>
				{#if charges.length === 0}
					<EmptyState kind="empty" title="Nothing charged yet" />
				{:else}
					<ul class="panel">
						{#each charges as charge (charge.chargeId)}
							<li class:muted={!charge.unbilled}>
								<div class="row-head">
									<span class="title">{charge.description}</span>
									<span class="amount">{formatMoney(charge.total, { withCurrency: false })}</span>
									<StatusChip
										label={charge.statusLabel}
										tone={charge.unbilled ? 'caution' : 'neutral'}
									/>
								</div>
								<p class="row-meta">
									<span>{charge.department}</span>
									<span>×{charge.quantity}</span>
									<span>{time(charge.occurredAt)}</span>
									{#if charge.covered}
										<!--
										  SRS-BIL-004: the consumption ledger explains
										  what a package billed and did not. A bare zero
										  reads as a mistake.
										-->
										<span class="covered">{charge.coverageNote || 'Covered by a package'}</span>
									{/if}
								</p>
							</li>
						{/each}
					</ul>
				{/if}
			</section>

			<section aria-labelledby="invoices-heading">
				<h2 id="invoices-heading">Invoices</h2>
				{#if invoices.length === 0}
					<EmptyState kind="empty" title="No invoices raised" />
				{:else}
					<ul class="panel">
						{#each invoices as invoice (invoice.invoiceId)}
							<li class:muted={invoice.status !== 'issued'}>
								<div class="row-head">
									<code class="title">{invoice.number}</code>
									<span class="amount">{formatMoney(invoice.total, { withCurrency: false })}</span>
									<StatusChip
										label={invoice.statusLabel}
										tone={invoice.status === 'issued' ? 'positive' : 'neutral'}
									/>
								</div>
								<p class="row-meta">
									<span>{invoice.lineCount} lines</span>
									{#if invoice.issuedAt}<span>{time(invoice.issuedAt)}</span>{/if}
									{#if invoice.supersededBy}
										<span>Replaced by {invoice.supersededBy.slice(0, 8)}</span>
									{/if}
									{#if invoice.correctsInvoiceId}
										<span>Corrects {invoice.correctsInvoiceId.slice(0, 8)}</span>
									{/if}
								</p>
								<!--
								  No edit control, at any status. The patient is holding
								  a copy, and a correction is a credit or debit note
								  against the original (SRS-BIL-010).
								-->
								{#if invoice.correctable}
									<p class="row-meta">
										<span>Correct this with a credit or debit note.</span>
									</p>
								{/if}
							</li>
						{/each}
					</ul>
				{/if}
			</section>
		</div>

		{#if mayCollect}
			<section aria-labelledby="payment-heading">
				<h2 id="payment-heading">Take a payment</h2>
				<form class="card" onsubmit={takePayment}>
					<div class="fields">
						<div>
							<label for="pay-amount">Amount ({currency})</label>
							<input id="pay-amount" bind:value={amountTyped} inputmode="decimal" />
							{#if amountTyped.trim() !== '' && parsedAmount === null}
								<!--
								  Refused rather than read as zero: a lenient parser
								  turns a typing slip into a payment of nothing that
								  still prints a receipt.
								-->
								<p class="field-error">That is not an amount in {currency}.</p>
							{/if}
						</div>
						<div>
							<label for="pay-method">Method</label>
							<select id="pay-method" bind:value={method}>
								{#each methods as option (option)}
									<option value={option}>{describeMethod(option)}</option>
								{/each}
							</select>
						</div>
						<div class="checkbox">
							<input id="pay-deposit" type="checkbox" bind:checked={isDeposit} />
							<label for="pay-deposit">Hold as a deposit</label>
						</div>
					</div>

					{#if !paymentValidity.ready && amountTyped.trim() !== ''}
						<ul class="readiness">
							{#each paymentValidity.problems as problem (problem)}
								<li>{problem}</li>
							{/each}
						</ul>
					{/if}

					<button type="submit" disabled={taking || !paymentValidity.ready}>
						{taking ? 'Taking…' : 'Take payment'}
					</button>
				</form>
			</section>
		{/if}

		<section aria-labelledby="statement-heading">
			<h2 id="statement-heading">Statement</h2>
			{#if statement.entries.length === 0}
				<EmptyState kind="empty" title="Nothing on the ledger yet" />
			{:else}
				<table>
					<caption class="visually-hidden">Account ledger, most recent first</caption>
					<thead>
						<tr>
							<th scope="col">Entry</th>
							<th scope="col">Amount</th>
							<th scope="col">Method</th>
							<th scope="col">Receipt</th>
							<th scope="col">When</th>
						</tr>
					</thead>
					<tbody>
						{#each statement.entries as entry (entry.entryId)}
							<tr>
								<td>{entry.kindLabel}</td>
								<td class="amount">
									{formatMoney(entry.amount, { withCurrency: false })}
								</td>
								<td>{entry.methodLabel}</td>
								<td>{#if entry.receiptNumber}<code>{entry.receiptNumber}</code>{/if}</td>
								<td>{time(entry.occurredAt)}</td>
							</tr>
						{/each}
					</tbody>
				</table>
			{/if}
		</section>

		<section aria-labelledby="close-heading">
			<h2 id="close-heading">Closing the account</h2>
			<p class:settled={readiness.ready} class:outstanding={!readiness.ready}>
				{readiness.message}
			</p>
			{#if !readiness.ready}
				<!--
				  SRS-BIL-013: the blocking exceptions are listed, not summarised.
				  "Cannot close" with no list is a dead end for whoever is at the
				  desk; the list is what turns it into a task.
				-->
				<ul class="panel">
					{#each readiness.exceptions as exception (exception.check)}
						<li>
							<div class="row-head">
								<span class="title">{exception.check.replace(/_/g, ' ')}</span>
								{#if exception.amount}
									<span class="amount">{formatMoney(exception.amount)}</span>
								{/if}
							</div>
							<p class="row-meta"><span>{exception.detail}</span></p>
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
		margin-bottom: 1rem;
		flex-wrap: wrap;
	}
	.picker > div {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
	}
	.header {
		margin-bottom: 1rem;
	}
	.balance {
		margin: 0;
		font-size: 1.125rem;
		font-weight: 600;
	}
	.mismatch {
		border: 1px solid #e9b0ab;
		background: #fdeceb;
		color: #7a1c17;
		border-radius: 6px;
		padding: 0.5rem 0.75rem;
		margin: 0.5rem 0 0;
	}
	.receipt {
		margin: 0.35rem 0 0;
		color: #11593a;
	}
	.columns {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(20rem, 1fr));
		gap: 1.5rem;
	}
	h2 {
		font-size: 1rem;
		margin: 1.25rem 0 0.5rem;
	}
	.subtotal {
		margin: 0 0 0.5rem;
		display: flex;
		align-items: center;
		gap: 0.75rem;
		flex-wrap: wrap;
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
	.panel li.muted {
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
	.amount {
		font-variant-numeric: tabular-nums;
		margin-left: auto;
	}
	.row-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.2rem 0.9rem;
		margin: 0.3rem 0 0;
		font-size: 0.8125rem;
		color: #5b6779;
	}
	.covered {
		color: #11593a;
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
		align-items: end;
	}
	.fields > div {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
	}
	.checkbox {
		flex-direction: row !important;
		align-items: center;
		gap: 0.4rem;
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
	.checkbox input {
		padding: 0;
	}
	.field-error {
		margin: 0;
		color: #7a1c17;
		font-size: 0.8125rem;
	}
	.readiness {
		margin: 0.25rem 0 0;
		padding-left: 1.1rem;
		font-size: 0.8125rem;
		color: #6b4708;
	}
	.settled {
		color: #11593a;
	}
	.outstanding {
		color: #6b4708;
	}
	button {
		align-self: flex-start;
		padding: 0.4rem 0.85rem;
		border-radius: 6px;
		border: 1px solid #1c5fd6;
		background: #1c5fd6;
		color: #fff;
		font: inherit;
		font-size: 0.9375rem;
		cursor: pointer;
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
	}
	td.amount {
		margin-left: 0;
		text-align: right;
	}
	th {
		background: #f6f7f9;
		font-size: 0.75rem;
		text-transform: uppercase;
		letter-spacing: 0.05em;
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
