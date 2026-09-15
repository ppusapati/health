<!--
  Reception board (UX-W1-01).

  Who is here, where they are in the queue, and who is still expected. What the
  board shows and how it orders itself is decided in $lib/reception/board.ts and
  tested there; this fetches, renders and acts.

  Every state UX-W1-01 requires is here and distinct: loading, empty,
  permission, error, conflict, and the stale one that matters most on this
  particular screen — a queue position read as current thirty seconds after it
  was fetched is a number a receptionist quotes to a waiting room.
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
		buildBoard,
		type Board,
		type BoardAppointment,
		type BoardPosition,
		type BoardRow
	} from '$lib/reception/board.js';
	import { toBoardAppointment, toBoardPosition } from '$lib/reception/mapping.js';
	import { timestampFromDate } from '@bufbuild/protobuf/wkt';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);

	/**
	 * The last answer from the server, kept raw.
	 *
	 * The board is derived from it rather than stored, so the waiting times and
	 * the staleness notice advance with the clock instead of freezing at
	 * whatever they were when the fetch returned. A board left open on a desk
	 * that reads as fresh forever is the failure the staleness notice exists to
	 * prevent.
	 */
	let snapshot = $state<{
		positions: BoardPosition[];
		expected: BoardAppointment[];
		serviceMinutes: number | null;
		estimateObserved: boolean;
		activeClinicians: number;
		fetchedAt: Date;
	} | null>(null);
	let loading = $state(false);
	let error = $state<PresentedError | null>(null);
	/** Set when the server refused an action because the row had moved on. */
	let conflict = $state('');
	let actingOn = $state('');
	let now = $state(new Date());

	const mayRead = $derived($session ? can('sch.schedule.read') : false);
	const mayCheckIn = $derived($session ? can('sch.appointment.manage') : false);
	const facilityId = $derived($session?.credentials.activeFacilityId ?? '');

	// The clock ticks so the waiting times and the staleness notice stay true
	// between fetches. Without it a board left open reads as fresh forever,
	// which is the opposite of what the staleness notice is for.
	const tick = setInterval(() => {
		now = new Date();
	}, 5_000);
	onDestroy(() => clearInterval(tick));

	const priorityTones = {
		immediate: 'critical',
		very_urgent: 'critical',
		urgent: 'caution',
		standard: 'neutral',
		non_urgent: 'neutral'
	} as const;

	const priorityLabels = {
		immediate: 'Immediate',
		very_urgent: 'Very urgent',
		urgent: 'Urgent',
		standard: 'Standard',
		non_urgent: 'Non-urgent'
	} as const;

	async function load() {
		if (!mayRead || facilityId === '') return;

		loading = true;
		error = null;
		try {
			const dayStart = startOfDay(new Date());
			const dayEnd = new Date(dayStart.getTime() + 86_400_000);

			// Both calls, because they answer different halves of the question:
			// the queue holds people who have arrived, the appointment list
			// holds people who have not. Requested together so the board is one
			// snapshot rather than two taken moments apart.
			const [queue, expected] = await Promise.all([
				clients.appointments.getQueue({
					facilityId,
					from: timestampFromDate(dayStart),
					until: timestampFromDate(dayEnd),
					pageSize: 100
				}),
				clients.appointments.listAppointments({
					facilityId,
					from: timestampFromDate(dayStart),
					until: timestampFromDate(dayEnd),
					pageSize: 100
				})
			]);

			const fetchedAt = new Date();
			now = fetchedAt;
			snapshot = {
				positions: queue.positions
					.map(toBoardPosition)
					.filter((p): p is BoardPosition => p !== null),
				expected: expected.appointments.map(toBoardAppointment),
				serviceMinutes: queue.estimate?.serviceMinutes ?? null,
				estimateObserved: queue.estimate?.observed ?? false,
				activeClinicians: queue.estimate?.activeClinicians ?? 0,
				fetchedAt
			};
		} catch (err) {
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	async function checkIn(row: BoardRow) {
		// SRS-WEB-008: disabled for the duration, so a double click cannot
		// produce two check-ins and two queue tokens.
		if (actingOn !== '') return;

		actingOn = row.appointmentId;
		error = null;
		conflict = '';
		try {
			await clients.appointments.checkIn({ appointmentId: row.appointmentId });
			await load();
		} catch (err) {
			const presented = presentError(err);
			if (presented.code === 'SCH_APPOINTMENT_CONFLICT' || presented.retryable === false) {
				// The commonest cause by far is that a colleague checked the
				// same patient in seconds ago. Saying so and reloading is more
				// use than a red banner, because the desired state has been
				// reached — just not by this click.
				conflict =
					'That patient has already been checked in, or their appointment moved on. ' +
					'The board has been reloaded.';
				await load();
			} else {
				error = presented;
			}
		} finally {
			actingOn = '';
		}
	}

	function startOfDay(at: Date): Date {
		const copy = new Date(at);
		copy.setHours(0, 0, 0, 0);
		return copy;
	}

	function time(at: Date): string {
		return at.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
	}

	// Rebuilt against the ticking clock, so waited times and the stale flag
	// advance without another round trip.
	const current = $derived.by((): Board | null =>
		snapshot ? buildBoard({ ...snapshot, now }) : null
	);

	$effect(() => {
		if (mayRead && facilityId !== '' && snapshot === null && !loading) {
			void load();
		}
	});
</script>

<h1>Reception board</h1>

{#if !$session}
	<EmptyState
		kind="permission"
		title="Sign in to see today's clinic"
		detail="The board shows the queue for the facility you are signed in to."
	/>
{:else if !mayRead}
	<!--
	  Distinct from "empty". A worklist the user may not see and a clinic with
	  nobody in it look identical otherwise, and mean opposite things.
	-->
	<EmptyState
		kind="permission"
		title="You do not have access to the reception board"
		detail="Ask your administrator for the scheduling read permission."
	/>
{:else if facilityId === ''}
	<EmptyState
		kind="permission"
		title="Choose a facility"
		detail="The board is per facility. Select one in the shell before loading it."
	/>
{:else}
	<ErrorBanner {error} onRetry={load} />

	{#if conflict}
		<p class="conflict" role="status">{conflict}</p>
	{/if}

	{#if current}
		<div class="summary">
			<p>
				<strong>{current.waiting}</strong> waiting
				{#if current.serviceMinutes !== null}
					· about {Math.round(current.serviceMinutes)} min per patient
					<!--
					  Said out loud. A configured default presented as a measured
					  rate is a wait time a receptionist repeats to a waiting room.
					-->
					<span class="hint">
						({current.estimateObserved ? 'measured today' : 'configured default'})
					</span>
				{/if}
			</p>
			<button type="button" onclick={load} disabled={loading}>
				{loading ? 'Refreshing…' : 'Refresh'}
			</button>
		</div>

		{#if current.stale}
			<p class="stale" role="status">
				These positions were read {current.ageSeconds} seconds ago and may have moved.
				Refresh before quoting a wait time.
			</p>
		{/if}
	{/if}

	{#if loading && !current}
		<EmptyState kind="loading" title="Loading today's clinic…" />
	{:else if current?.empty}
		<EmptyState
			kind="empty"
			title="Nobody is expected or waiting"
			detail="Appointments booked for today will appear here as they are made."
		/>
	{:else if current}
		<table>
			<caption class="visually-hidden">Today's clinic, most urgent first</caption>
			<thead>
				<tr>
					<th scope="col">Token</th>
					<th scope="col">Patient</th>
					<th scope="col">Status</th>
					<th scope="col">Priority</th>
					<th scope="col">Booked</th>
					<th scope="col">Waited</th>
					<th scope="col">Estimate</th>
					<th scope="col"><span class="visually-hidden">Actions</span></th>
				</tr>
			</thead>
			<tbody>
				{#each current.rows as row (row.appointmentId)}
					<tr class:present={row.position !== null}>
						<td><code>{row.token || '—'}</code></td>
						<td>
							<!--
							  The patient id, not a name. The board lists a whole
							  clinic on a screen in a public waiting area, and a
							  column of names is a disclosure to everybody who can
							  see it. The name is on the chart, one click away and
							  behind an audited read.
							-->
							<a href={`/chart/${row.patientId}`}>
								<code>{row.patientId.slice(0, 8)}</code>
							</a>
						</td>
						<td>{row.statusLabel}</td>
						<td>
							<StatusChip
								label={priorityLabels[row.priority]}
								tone={priorityTones[row.priority]}
							/>
							{#if row.priorityReason}
								<!--
								  SRS-SCH-011: a reprioritisation is visible and
								  carries its reason. A queue that can be reordered
								  invisibly is one nobody can audit.
								-->
								<span class="reason">{row.priorityReason}</span>
							{/if}
						</td>
						<td>{time(row.scheduledAt)}</td>
						<td>{row.waitedMinutes === null ? '—' : `${row.waitedMinutes} min`}</td>
						<td>
							{row.estimatedWaitMinutes === null ? '—' : `${row.estimatedWaitMinutes} min`}
						</td>
						<td>
							{#if row.canCheckIn && mayCheckIn}
								<button
									type="button"
									onclick={() => checkIn(row)}
									disabled={actingOn !== ''}
								>
									{actingOn === row.appointmentId ? 'Checking in…' : 'Check in'}
								</button>
							{/if}
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	{/if}
{/if}

<style>
	.summary {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		margin-bottom: 0.75rem;
	}
	.summary p {
		margin: 0;
	}
	.hint {
		color: #5b6779;
		font-size: 0.8125rem;
	}
	.stale {
		border: 1px solid #e8cb91;
		background: #fdf3e0;
		color: #6b4708;
		border-radius: 6px;
		padding: 0.5rem 0.75rem;
		margin: 0 0 0.75rem;
		font-size: 0.9375rem;
	}
	.conflict {
		border: 1px solid #c8d0dd;
		background: #eef1f5;
		border-radius: 6px;
		padding: 0.5rem 0.75rem;
		margin: 0 0 0.75rem;
		font-size: 0.9375rem;
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
		vertical-align: top;
	}
	th {
		background: #f6f7f9;
		font-size: 0.75rem;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: #5b6779;
	}
	tr.present {
		background: #fbfcfe;
	}
	.reason {
		display: block;
		font-size: 0.8125rem;
		color: #5b6779;
		margin-top: 0.2rem;
	}
	button {
		padding: 0.35rem 0.7rem;
		border-radius: 6px;
		border: 1px solid #1c5fd6;
		background: #1c5fd6;
		color: #fff;
		font: inherit;
		font-size: 0.875rem;
		cursor: pointer;
	}
	button:disabled {
		opacity: 0.6;
		cursor: progress;
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
