<!--
  Facility worklist and creation.

  This is the Wave-0 reference screen: it proves the browser reaches the
  canonical contract end to end (Gate A1 / A9). It deliberately shows every
  state a real screen must handle — loading, empty, validation, permission
  denied and unexpected failure (SRS-WEB-006, UX spec §16).
-->
<script lang="ts">
	import { createApiClients } from '$lib/api/client.js';
	import { describeFieldReason, presentError, type PresentedError } from '$lib/api/errors.js';
	import { PUBLIC_API_BASE_URL } from '$lib/config.js';
	import ErrorBanner from '$lib/components/ErrorBanner.svelte';
	import StatusChip from '$lib/components/StatusChip.svelte';
	import { can, currentCredentials, session, setSession } from '$lib/session.js';
	import {
		FacilityStatus,
		FacilityType,
		type Facility
	} from '$gen/healthcare/organization/v1/organization_pb.js';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);

	let token = $state('');
	let facilities = $state<Facility[]>([]);
	let nextPageToken = $state('');
	let loading = $state(false);
	let submitting = $state(false);
	let error = $state<PresentedError | null>(null);

	let code = $state('');
	let displayName = $state('');
	let timeZone = $state('Asia/Kolkata');

	const canCreate = $derived($session ? can('organization.facility.create') : false);

	const statusLabels: Record<FacilityStatus, string> = {
		[FacilityStatus.UNSPECIFIED]: 'Unknown',
		[FacilityStatus.ACTIVE]: 'Active',
		[FacilityStatus.INACTIVE]: 'Inactive',
		[FacilityStatus.RETIRED]: 'Retired'
	};

	const statusTones = {
		[FacilityStatus.UNSPECIFIED]: 'neutral',
		[FacilityStatus.ACTIVE]: 'positive',
		[FacilityStatus.INACTIVE]: 'caution',
		[FacilityStatus.RETIRED]: 'neutral'
	} as const;

	async function signIn(event: SubmitEvent) {
		event.preventDefault();
		error = null;
		loading = true;
		try {
			setSession({ credentials: { token }, context: emptyContext() });
			const response = await clients.identity.getSessionContext({});
			if (!response.session) {
				throw new Error('no session returned');
			}
			setSession({ credentials: { token }, context: response.session });
			await loadFacilities();
		} catch (err) {
			setSession(null);
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	async function loadFacilities() {
		loading = true;
		error = null;
		try {
			const response = await clients.organization.listFacilities({
				page: { pageSize: 25, pageToken: '' }
			});
			facilities = response.facilities;
			nextPageToken = response.page?.nextPageToken ?? '';
		} catch (err) {
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	async function createFacility(event: SubmitEvent) {
		event.preventDefault();
		// SRS-WEB-008: the button is disabled for the duration of the request so
		// a double click cannot create two facilities.
		if (submitting) return;

		submitting = true;
		error = null;
		try {
			// Note the absence of a tenant field: tenancy comes from the token.
			await clients.organization.createFacility({
				code,
				displayName,
				type: FacilityType.HOSPITAL,
				timeZone
			});
			code = '';
			displayName = '';
			await loadFacilities();
		} catch (err) {
			error = presentError(err);
		} finally {
			submitting = false;
		}
	}

	function emptyContext() {
		return {
			$typeName: 'healthcare.identity_access.v1.SessionContext',
			subjectId: '',
			tenantId: '',
			activeFacilityId: '',
			roles: [],
			permissions: [],
			purposeOfUse: 0,
			breakGlassActive: false
		} as never;
	}
</script>

<h1>Facilities</h1>

<ErrorBanner {error} onRetry={loadFacilities} />

{#if !$session}
	<form class="card" onsubmit={signIn}>
		<h2>Sign in</h2>
		<p class="hint">
			Development tokens take the form <code>tenantId:subjectId:role</code>. The production
			identity provider replaces this once ADR-008 closes.
		</p>
		<label for="token">Token</label>
		<input id="token" bind:value={token} required autocomplete="off" />
		<button type="submit" disabled={loading}>{loading ? 'Signing in…' : 'Sign in'}</button>
	</form>
{:else}
	{#if canCreate}
		<form class="card" onsubmit={createFacility}>
			<h2>Add a facility</h2>

			<label for="code">Code</label>
			<input id="code" bind:value={code} required aria-describedby="code-error" />
			{#if error?.fieldViolations.code}
				<p class="field-error" id="code-error">
					{describeFieldReason(error.fieldViolations.code)}
				</p>
			{/if}

			<label for="display-name">Display name</label>
			<input id="display-name" bind:value={displayName} required aria-describedby="name-error" />
			{#if error?.fieldViolations.display_name}
				<p class="field-error" id="name-error">
					{describeFieldReason(error.fieldViolations.display_name)}
				</p>
			{/if}

			<label for="time-zone">Time zone</label>
			<input id="time-zone" bind:value={timeZone} required />

			<button type="submit" disabled={submitting}>
				{submitting ? 'Saving…' : 'Create facility'}
			</button>
		</form>
	{:else}
		<p class="hint">Your role can view facilities but not create them.</p>
	{/if}

	{#if loading}
		<p role="status">Loading facilities…</p>
	{:else if facilities.length === 0}
		<p role="status">
			No facilities yet.{#if canCreate}&nbsp;Add the first one above.{/if}
		</p>
	{:else}
		<table>
			<caption class="visually-hidden">Facilities in the current tenant</caption>
			<thead>
				<tr>
					<th scope="col">Code</th>
					<th scope="col">Name</th>
					<th scope="col">Status</th>
					<th scope="col">Time zone</th>
				</tr>
			</thead>
			<tbody>
				{#each facilities as facility (facility.facilityId)}
					<tr>
						<td><code>{facility.code}</code></td>
						<td>{facility.displayName}</td>
						<td>
							<StatusChip
								label={statusLabels[facility.status]}
								tone={statusTones[facility.status]}
							/>
						</td>
						<td>{facility.timeZone}</td>
					</tr>
				{/each}
			</tbody>
		</table>

		{#if nextPageToken}
			<p class="hint">More results are available on the next page.</p>
		{/if}
	{/if}
{/if}

<style>
	.card {
		background: #fff;
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 1rem 1.25rem;
		margin-bottom: 1.5rem;
		max-width: 34rem;
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
	}
	.card h2 {
		margin: 0 0 0.5rem;
		font-size: 1rem;
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
	button {
		margin-top: 0.75rem;
		align-self: flex-start;
		padding: 0.5rem 1rem;
		border-radius: 6px;
		border: 1px solid #1c5fd6;
		background: #1c5fd6;
		color: #fff;
		font: inherit;
		cursor: pointer;
	}
	button:disabled {
		opacity: 0.6;
		cursor: progress;
	}
	.field-error {
		margin: 0;
		color: #7a1c17;
		font-size: 0.8125rem;
	}
	.hint {
		color: #5b6779;
		font-size: 0.875rem;
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
		padding: 0.6rem 0.75rem;
		border-bottom: 1px solid #eef1f5;
		font-size: 0.9375rem;
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
