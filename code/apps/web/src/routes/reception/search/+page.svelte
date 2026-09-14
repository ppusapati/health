<!--
  Find a patient, and register one only if they are not already here
  (UX-W1-01, SRS-EMPI-003, SRS-EMPI-004).

  Registration lives on this page rather than behind its own route, and that is
  a deliberate structural choice rather than a layout one. A separate
  /reception/register route is a URL, and a URL can be typed, bookmarked and
  linked — which means search-before-create becomes a path somebody can walk
  around on a busy Monday. There is no route here that has not searched.

  The gate itself is in $lib/reception/search.ts and tested there. The server
  enforces the same rule independently: RegisterPatient refuses a probable
  duplicate unless the caller lists the candidate ids it has seen. This screen
  is what makes that refusal comprehensible rather than surprising.
-->
<script lang="ts">
	import { createApiClients } from '$lib/api/client.js';
	import { describeFieldReason, presentError, type PresentedError } from '$lib/api/errors.js';
	import { PUBLIC_API_BASE_URL } from '$lib/config.js';
	import ErrorBanner from '$lib/components/ErrorBanner.svelte';
	import EmptyState from '$lib/components/EmptyState.svelte';
	import PatientBanner from '$lib/components/PatientBanner.svelte';
	import StatusChip from '$lib/components/StatusChip.svelte';
	import { can, currentCredentials, session } from '$lib/session.js';
	import { bannerFor, type PatientBanner as Banner } from '$lib/patient/banner.js';
	import {
		mayRegister,
		registrationGate,
		validateSearch,
		type PresentedMatch
	} from '$lib/reception/search.js';
	import { toPatientLike, toPresentedMatch } from '$lib/reception/mapping.js';
	import { Sex } from '$gen/healthcare/empi/v1/patient_pb.js';
	import { timestampFromDate } from '@bufbuild/protobuf/wkt';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);

	let name = $state('');
	let phone = $state('');
	let birthDate = $state('');
	let identifierValue = $state('');

	let searching = $state(false);
	/**
	 * Whether a search has completed, as distinct from whether it found
	 * anything. Both leave the match list empty and they mean opposite things:
	 * before a search, empty means nobody has looked.
	 */
	let searched = $state(false);
	let matches = $state<PresentedMatch[]>([]);
	let acknowledged = $state<string[]>([]);
	let error = $state<PresentedError | null>(null);

	let registering = $state(false);
	let registeredBanner = $state<Banner | null>(null);
	/** Candidates the server refused to register past. */
	let serverDuplicates = $state<PresentedMatch[]>([]);

	let newFamily = $state('');
	let newGiven = $state('');
	let newBirthDate = $state('');
	let newSex = $state<Sex>(Sex.UNSPECIFIED);
	let newPhone = $state('');

	const mayRead = $derived($session ? can('empi.patient.read') : false);
	const mayCreate = $derived($session ? can('empi.patient.create') : false);

	const criteria = $derived({ name, phone, identifierValue, birthDate });
	const validity = $derived(validateSearch(criteria));
	const gate = $derived(registrationGate({ searched, matches, acknowledged }));
	const canRegister = $derived(mayCreate && mayRegister(gate));

	async function search(event: SubmitEvent) {
		event.preventDefault();
		if (!validity.runnable || searching) return;

		searching = true;
		error = null;
		// Cleared on every new search. A stale acknowledgement would otherwise
		// unlock the gate for a completely different set of candidates.
		acknowledged = [];
		serverDuplicates = [];
		registeredBanner = null;
		try {
			const response = await clients.patients.searchPatients({
				name: name.trim(),
				phone: phone.trim(),
				identifierValue: identifierValue.trim(),
				birthDate: birthDate ? partialDate(birthDate) : undefined,
				pageSize: 25
			});
			matches = response.matches.map(toPresentedMatch);
			searched = true;
			prefillFromSearch();
		} catch (err) {
			error = presentError(err);
			// Not searched. A failed search must never satisfy the gate: the
			// index may be full of this patient and nobody would know.
			searched = false;
			matches = [];
		} finally {
			searching = false;
		}
	}

	function acknowledge(patientId: string) {
		if (!acknowledged.includes(patientId)) {
			acknowledged = [...acknowledged, patientId];
		}
	}

	function prefillFromSearch() {
		// Carried across so the receptionist does not retype what they just
		// typed — retyping is where a transposed digit in a date of birth comes
		// from, and a wrong date of birth is a duplicate waiting to happen.
		if (newFamily === '' && newGiven === '' && name.trim() !== '') {
			const parts = name.trim().split(/\s+/);
			newGiven = parts.slice(0, -1).join(' ') || parts[0];
			newFamily = parts.length > 1 ? parts[parts.length - 1] : '';
		}
		if (newBirthDate === '') newBirthDate = birthDate;
		if (newPhone === '') newPhone = phone;
	}

	async function register(event: SubmitEvent) {
		event.preventDefault();
		if (!canRegister || registering) return;

		registering = true;
		error = null;
		serverDuplicates = [];
		try {
			const response = await clients.patients.registerPatient({
				demographics: {
					name: { family: newFamily.trim(), given: newGiven.trim() ? [newGiven.trim()] : [] },
					sex: newSex,
					birthDate: newBirthDate ? partialDate(newBirthDate) : undefined,
					phones: newPhone.trim() ? [{ value: newPhone.trim(), use: 'mobile' }] : []
				},
				// Exactly what the user has reviewed and rejected — not every id
				// on screen. Sending the whole list would turn the server's
				// independent check into a rubber stamp.
				acknowledgedDuplicatePatientIds: acknowledged
			});

			if (!response.patient) {
				// Not an error: the server found a candidate this screen did
				// not, which is expected when the index changed between the
				// search and the submit. Shown for review rather than as a
				// failure.
				serverDuplicates = response.potentialDuplicates.map(toPresentedMatch);
				return;
			}
			registeredBanner = bannerFor(toPatientLike(response.patient), new Date());
			matches = [];
			searched = false;
			acknowledged = [];
		} catch (err) {
			error = presentError(err);
		} finally {
			registering = false;
		}
	}

	function partialDate(iso: string) {
		// DAY precision, because the receptionist typed a full date. A date
		// picked here is not the same fact as one estimated from appearance,
		// and the matcher weighs them differently.
		return { date: timestampFromDate(new Date(`${iso}T00:00:00Z`)), precision: 1 };
	}
</script>

<h1>Find a patient</h1>

{#if !$session}
	<EmptyState kind="permission" title="Sign in to search the patient index" />
{:else if !mayRead}
	<EmptyState
		kind="permission"
		title="You do not have access to the patient index"
		detail="Ask your administrator for the patient read permission."
	/>
{:else}
	<ErrorBanner {error} onRetry={undefined} />

	{#if registeredBanner}
		<div class="registered" role="status">
			<p class="registered-title">Patient registered</p>
			<PatientBanner banner={registeredBanner} />
		</div>
	{/if}

	<form class="card" onsubmit={search}>
		<h2>Search</h2>
		<p class="hint">
			Search before registering. A duplicate record is read as a second person until
			somebody notices, and half a chart is worse than none.
		</p>

		<div class="fields">
			<div>
				<label for="q-name">Name</label>
				<input id="q-name" bind:value={name} autocomplete="off" />
			</div>
			<div>
				<label for="q-dob">Date of birth</label>
				<input id="q-dob" type="date" bind:value={birthDate} />
			</div>
			<div>
				<label for="q-phone">Phone</label>
				<input id="q-phone" bind:value={phone} autocomplete="off" inputmode="tel" />
			</div>
			<div>
				<label for="q-id">MRN or other identifier</label>
				<input id="q-id" bind:value={identifierValue} autocomplete="off" />
			</div>
		</div>

		{#if !validity.runnable && (name || phone || birthDate || identifierValue)}
			<p class="field-error">{validity.message}</p>
		{/if}

		<button type="submit" disabled={!validity.runnable || searching}>
			{searching ? 'Searching…' : 'Search'}
		</button>
	</form>

	{#if searching}
		<EmptyState kind="loading" title="Searching the patient index…" />
	{:else if !searched}
		<EmptyState
			kind="search-first"
			title="Nothing searched yet"
			detail="Enter what you know about the patient and search."
		/>
	{:else if matches.length === 0}
		<EmptyState
			kind="empty"
			title="No existing record matches"
			detail="Register a new patient below."
		/>
	{:else}
		<h2>Possible matches</h2>
		<ul class="matches">
			{#each matches as match (match.patientId)}
				<li class:blocking={match.blocksRegistration}>
					<div class="match-head">
						<span class="match-name">{match.displayName || 'Name hidden'}</span>
						<StatusChip
							label={match.outcomeLabel}
							tone={match.blocksRegistration ? 'caution' : 'neutral'}
						/>
					</div>
					<p class="match-meta">
						<span><code>{match.patientId.slice(0, 8)}</code></span>
						<span>{match.confidencePercent}% match</span>
						{#if match.matchedFormerName}
							<!--
							  SRS-EMPI-007: a match on a maiden name scores low
							  against the current name, so without saying why the
							  row is here it reads as irrelevant and gets dismissed
							  — the outcome the name history exists to prevent.
							-->
							<span class="former">Matched on a previous name: {match.matchedFormerName}</span>
						{/if}
						{#if match.masked}
							<!-- A blank reads as "not recorded", which is a different fact. -->
							<span class="masked">Some details hidden by your access level</span>
						{/if}
					</p>
					{#if match.blocksRegistration}
						{#if acknowledged.includes(match.patientId)}
							<p class="ack" role="status">Confirmed as a different person.</p>
						{:else}
							<button
								type="button"
								class="secondary"
								onclick={() => acknowledge(match.patientId)}
							>
								This is a different person
							</button>
						{/if}
					{/if}
				</li>
			{/each}
		</ul>
	{/if}

	{#if mayCreate}
		<form class="card" onsubmit={register}>
			<h2>Register a new patient</h2>
			<p class="gate" class:blocked={!mayRegister(gate)}>{gate.message}</p>

			{#if serverDuplicates.length > 0}
				<div class="server-duplicates" role="status">
					<p>
						The index changed while you were typing. These records also look like this
						patient — review them before registering again.
					</p>
					<ul>
						{#each serverDuplicates as duplicate (duplicate.patientId)}
							<li>
								{duplicate.displayName || 'Name hidden'} — {duplicate.outcomeLabel}
								<button
									type="button"
									class="secondary"
									onclick={() => acknowledge(duplicate.patientId)}
								>
									Different person
								</button>
							</li>
						{/each}
					</ul>
				</div>
			{/if}

			<div class="fields">
				<div>
					<label for="n-given">Given name</label>
					<input id="n-given" bind:value={newGiven} disabled={!canRegister} />
					{#if error?.fieldViolations['demographics.name.given']}
						<p class="field-error">
							{describeFieldReason(error.fieldViolations['demographics.name.given'])}
						</p>
					{/if}
				</div>
				<div>
					<label for="n-family">Family name</label>
					<input id="n-family" bind:value={newFamily} disabled={!canRegister} />
				</div>
				<div>
					<label for="n-dob">Date of birth</label>
					<input id="n-dob" type="date" bind:value={newBirthDate} disabled={!canRegister} />
					{#if error?.fieldViolations['demographics.birth_date']}
						<p class="field-error">
							{describeFieldReason(error.fieldViolations['demographics.birth_date'])}
						</p>
					{/if}
				</div>
				<div>
					<label for="n-sex">Sex</label>
					<select id="n-sex" bind:value={newSex} disabled={!canRegister}>
						<option value={Sex.UNSPECIFIED}>Not stated</option>
						<option value={Sex.FEMALE}>Female</option>
						<option value={Sex.MALE}>Male</option>
						<option value={Sex.OTHER}>Other</option>
						<option value={Sex.UNKNOWN}>Unknown</option>
					</select>
				</div>
				<div>
					<label for="n-phone">Phone</label>
					<input id="n-phone" bind:value={newPhone} disabled={!canRegister} inputmode="tel" />
				</div>
			</div>

			<button type="submit" disabled={!canRegister || registering}>
				{registering ? 'Registering…' : 'Register patient'}
			</button>
		</form>
	{:else}
		<p class="hint">Your role can search the index but not register a patient.</p>
	{/if}
{/if}

<style>
	.card {
		background: #fff;
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 1rem 1.25rem;
		margin-bottom: 1.5rem;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}
	.card h2 {
		margin: 0;
		font-size: 1rem;
	}
	.fields {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(12rem, 1fr));
		gap: 0.75rem;
	}
	.fields > div {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
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
	input:disabled,
	select:disabled {
		background: #f6f7f9;
		color: #8a94a6;
	}
	button {
		align-self: flex-start;
		padding: 0.5rem 1rem;
		border-radius: 6px;
		border: 1px solid #1c5fd6;
		background: #1c5fd6;
		color: #fff;
		font: inherit;
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
	.gate {
		margin: 0;
		padding: 0.5rem 0.75rem;
		border-radius: 6px;
		background: #e7f5ec;
		color: #11593a;
		font-size: 0.9375rem;
	}
	.gate.blocked {
		background: #fdf3e0;
		color: #6b4708;
	}
	.hint {
		color: #5b6779;
		font-size: 0.875rem;
		margin: 0;
	}
	.field-error {
		margin: 0;
		color: #7a1c17;
		font-size: 0.8125rem;
	}
	.matches {
		list-style: none;
		margin: 0 0 1.5rem;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}
	.matches li {
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 0.75rem 1rem;
		background: #fff;
	}
	.matches li.blocking {
		border-color: #e8cb91;
	}
	.match-head {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		flex-wrap: wrap;
	}
	.match-name {
		font-weight: 600;
	}
	.match-meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.25rem 1rem;
		margin: 0.35rem 0 0.5rem;
		font-size: 0.8125rem;
		color: #5b6779;
	}
	.former {
		color: #6b4708;
	}
	.masked {
		font-style: italic;
	}
	.ack {
		margin: 0;
		font-size: 0.8125rem;
		color: #11593a;
	}
	.registered {
		border: 1px solid #a8d8bd;
		background: #e7f5ec;
		border-radius: 8px;
		padding: 0.75rem 1rem;
		margin-bottom: 1.5rem;
	}
	.registered-title {
		margin: 0 0 0.5rem;
		font-weight: 600;
		color: #11593a;
	}
	.server-duplicates {
		border: 1px solid #e8cb91;
		background: #fdf3e0;
		color: #6b4708;
		border-radius: 6px;
		padding: 0.5rem 0.75rem;
		font-size: 0.9375rem;
	}
	.server-duplicates ul {
		margin: 0.35rem 0 0;
		padding-left: 1.1rem;
	}
	code {
		font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
	}
</style>
