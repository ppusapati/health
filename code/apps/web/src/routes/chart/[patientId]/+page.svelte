<!--
  Doctor OPD workspace (UX-W1-02).

  The chart: who the patient is, what is wrong with them, what they react to,
  what has been measured, and what has been written. The rules about what each
  of those panels may show and what a note allows are in $lib/chart and tested
  there; this fetches, renders and acts.

  Two things on this screen are controls rather than conveniences.

  The patient-context lock (SRS-CLN-017). A clinician with several charts open
  who starts a note in one and switches to another is the wrong-patient error
  this system exists to make hard. The draft registry knows which patient each
  open draft belongs to and refuses the switch outright — a prompt would not
  help, because the whole failure is that the user believes they are somewhere
  else.

  The absence of an edit button on a signed note. Not disabled: absent. A
  disabled control invites the reading "I need a permission for this", and the
  correct reading is "that is not a thing this record does".
-->
<script lang="ts">
	import { onDestroy, onMount } from 'svelte';
	import { page } from '$app/state';
	import { createApiClients } from '$lib/api/client.js';
	import { presentError, type PresentedError } from '$lib/api/errors.js';
	import { PUBLIC_API_BASE_URL } from '$lib/config.js';
	import ErrorBanner from '$lib/components/ErrorBanner.svelte';
	import EmptyState from '$lib/components/EmptyState.svelte';
	import PatientBannerView from '$lib/components/PatientBanner.svelte';
	import StatusChip from '$lib/components/StatusChip.svelte';
	import { can, currentCredentials, session } from '$lib/session.js';
	import { bannerFor, type PatientBanner } from '$lib/patient/banner.js';
	import { toPatientLike } from '$lib/reception/mapping.js';
	import {
		actionsFor,
		describeCorrection,
		describeStatus,
		isFinalised,
		readyToSign,
		type ChartDocument,
		type CorrectionKind
	} from '$lib/chart/notes.js';
	import {
		allergiesUnrecorded,
		orderAllergies,
		orderProblems,
		type PresentedAllergy,
		type PresentedObservation,
		type PresentedProblem
	} from '$lib/chart/safety.js';
	import {
		toChartDocument,
		toPresentedAllergy,
		toPresentedObservation,
		toPresentedProblem
	} from '$lib/chart/mapping.js';
	import { DraftRegistry, describe as describeGuard, installUnloadGuard } from '$lib/drafts/guard.js';
	import { DocumentKind, SignatureMeaning } from '$gen/healthcare/clinical/v1/clinical_pb.js';

	const clients = createApiClients(PUBLIC_API_BASE_URL, currentCredentials);
	const drafts = new DraftRegistry();

	const patientId = $derived(page.params.patientId ?? '');
	const encounterId = $derived(page.url.searchParams.get('encounter') ?? '');

	let banner = $state<PatientBanner | null>(null);
	let allergies = $state<readonly PresentedAllergy[]>([]);
	let problems = $state<readonly PresentedProblem[]>([]);
	let observations = $state<PresentedObservation[]>([]);
	let notes = $state<ChartDocument[]>([]);

	let loading = $state(false);
	let error = $state<PresentedError | null>(null);
	let loadedFor = $state('');

	// The note being written.
	let draftId = $state('');
	let draftTitle = $state('');
	let draftText = $state('');
	let templateVersion = $state('v1');
	let saving = $state(false);
	let signing = $state(false);

	// A correction being made to an existing note.
	let correcting = $state<{ document: ChartDocument; kind: CorrectionKind } | null>(null);
	let correctionText = $state('');
	let correctionReason = $state('');

	const mayRead = $derived($session ? can('clinical.record.read') : false);
	const mayWrite = $derived($session ? can('clinical.record.write') : false);
	const maySign = $derived($session ? can('clinical.document.sign') : false);
	const subjectId = $derived($session?.context.subjectId ?? '');

	const draftDirty = $derived(draftTitle.trim() !== '' || draftText.trim() !== '');
	const signReadiness = $derived(
		readyToSign({
			title: draftTitle,
			sections: [{ heading: 'Note', text: draftText }],
			templateVersion,
			patientId,
			encounterId
		})
	);

	/**
	 * The guard's verdict on leaving this chart while a draft is open.
	 *
	 * Recomputed from the registry rather than from draftDirty, so a draft
	 * registered by any future panel on this screen is covered by the same
	 * check instead of each one wiring its own.
	 */
	let guardMessage = $state('');

	$effect(() => {
		// Registered with the patient it belongs to. That association is the
		// whole mechanism: without it the guard cannot tell a chart switch from
		// an ordinary navigation.
		if (draftDirty) {
			drafts.register({
				id: 'chart-note',
				description: 'progress note',
				policy: 'block-patient-switch',
				patientRef: patientId,
				dirty: true
			});
		} else {
			drafts.release('chart-note');
		}
	});

	onMount(() => {
		const teardown = installUnloadGuard(drafts, window);
		const unsubscribe = drafts.subscribe(() => {
			const decision = drafts.evaluate({ kind: 'route', to: '/' });
			guardMessage = decision.allow ? '' : describeGuard(decision);
		});
		return () => {
			teardown();
			unsubscribe();
		};
	});

	onDestroy(() => drafts.release('chart-note'));

	async function load() {
		if (!mayRead || patientId === '') return;

		loading = true;
		error = null;
		try {
			const [patient, allergyList, problemList, observationList, noteList] = await Promise.all([
				clients.patients.getPatient({ patientId }),
				clients.clinical.listAllergies({ patientId, pageSize: 50 }),
				clients.clinical.listProblems({ patientId, pageSize: 50 }),
				clients.clinical.listObservations({ patientId, encounterId, pageSize: 50 }),
				// Drafts included: a clinician's own unfinished note is part of
				// the chart to them, and hiding it is how two drafts of the same
				// note get written.
				clients.clinical.listNotes({ patientId, encounterId, includeDrafts: true, pageSize: 50 })
			]);

			banner = patient.patient ? bannerFor(toPatientLike(patient.patient), new Date()) : null;
			allergies = orderAllergies(allergyList.allergies.map(toPresentedAllergy));
			problems = orderProblems(problemList.problems.map(toPresentedProblem));
			observations = observationList.observations.map(toPresentedObservation);
			notes = noteList.documents.map(toChartDocument);
			loadedFor = patientId;
		} catch (err) {
			error = presentError(err);
		} finally {
			loading = false;
		}
	}

	$effect(() => {
		if (mayRead && patientId !== '' && loadedFor !== patientId && !loading) {
			void load();
		}
	});

	function contextMessage() {
		// Sent with every write. The server compares it against the chart the
		// write names, so a stale tab cannot save into the chart it is looking
		// at while the user believes they moved on.
		return { patientId, encounterId, openedAt: undefined };
	}

	async function saveDraft() {
		if (saving || !mayWrite) return;
		saving = true;
		error = null;
		try {
			const response = await clients.clinical.writeNote({
				documentId: draftId,
				patientId,
				encounterId,
				kind: DocumentKind.PROGRESS_NOTE,
				templateVersion,
				title: draftTitle,
				sections: [{ heading: 'Note', text: draftText }],
				context: contextMessage()
			});
			if (response.document) {
				draftId = response.document.documentId;
			}
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			saving = false;
		}
	}

	async function signDraft() {
		if (signing || !maySign || !signReadiness.ready) return;
		signing = true;
		error = null;
		try {
			// Saved first. Signing pins a hash of the stored content, so signing
			// without saving would sign the previous text while the clinician
			// looks at the new one.
			await saveDraft();
			if (draftId === '') {
				return;
			}
			await clients.clinical.signNote({
				documentId: draftId,
				meaning: SignatureMeaning.AUTHOR,
				context: contextMessage()
			});
			draftId = '';
			draftTitle = '';
			draftText = '';
			drafts.release('chart-note');
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			signing = false;
		}
	}

	function startCorrection(document: ChartDocument, kind: CorrectionKind) {
		correcting = { document, kind };
		correctionText = '';
		correctionReason = '';
	}

	async function submitCorrection() {
		if (!correcting || saving) return;
		const guidance = describeCorrection(correcting.kind);
		if (guidance.reasonRequired && correctionReason.trim() === '') {
			return;
		}
		saving = true;
		error = null;
		try {
			await clients.clinical.amendNote({
				documentId: correcting.document.documentId,
				title: correcting.document.title,
				sections: [{ heading: 'Note', text: correctionText }],
				reason: correctionReason,
				addendum: correcting.kind === 'addendum',
				context: contextMessage()
			});
			correcting = null;
			await load();
		} catch (err) {
			error = presentError(err);
		} finally {
			saving = false;
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
</script>

<svelte:head><title>Chart</title></svelte:head>

{#if !$session}
	<h1>Patient chart</h1>
	<EmptyState kind="permission" title="Sign in to open a chart" />
{:else if !mayRead}
	<h1>Patient chart</h1>
	<EmptyState
		kind="permission"
		title="You do not have access to clinical records"
		detail="Ask your administrator for the clinical read permission."
	/>
{:else if patientId === ''}
	<h1>Patient chart</h1>
	<EmptyState kind="empty" title="No patient selected" detail="Open a chart from the board." />
{:else}
	<ErrorBanner {error} onRetry={load} />

	{#if guardMessage}
		<!--
		  SRS-CLN-017. Shown persistently while a draft is open, because the
		  hazard is the user believing they are somewhere else — a prompt at the
		  moment of navigation arrives after they have stopped thinking about it.
		-->
		<p class="context-lock" role="status">{guardMessage}</p>
	{/if}

	{#if banner}
		<PatientBannerView {banner} />
	{:else if loading}
		<EmptyState kind="loading" title="Opening the chart…" />
	{/if}

	{#if banner?.readOnly}
		<p class="read-only" role="status">
			This record takes no new clinical entries. Anything written now belongs on the
			surviving record.
		</p>
	{/if}

	<div class="columns">
		<section aria-labelledby="allergies-heading">
			<h2 id="allergies-heading">Allergies and intolerances</h2>
			{#if allergiesUnrecorded(allergies)}
				<!--
				  Not "no known allergies". Nobody has recorded anything, which
				  is a different clinical fact and the one a prescriber must not
				  read as reassurance.
				-->
				<EmptyState
					kind="empty"
					title="Nothing recorded"
					detail="No allergy status has been recorded for this patient. This is not the same as no known allergies."
				/>
			{:else}
				<ul class="panel">
					{#each allergies as item (item.allergyId)}
						<li class:prominent={item.prominent} class:historical={item.historical}>
							<div class="row-head">
								<span class="substance">{item.substance}</span>
								<StatusChip
									label={item.criticalityLabel}
									tone={item.prominent ? 'critical' : 'neutral'}
								/>
							</div>
							<p class="row-meta">
								<span>{item.kindLabel}</span>
								<span>{item.verificationLabel}</span>
								{#if item.reactions.length > 0}
									<span>{item.reactions.join(', ')}</span>
								{/if}
							</p>
						</li>
					{/each}
				</ul>
			{/if}
		</section>

		<section aria-labelledby="problems-heading">
			<h2 id="problems-heading">Problem list</h2>
			{#if problems.length === 0}
				<EmptyState kind="empty" title="No problems recorded" />
			{:else}
				<ul class="panel">
					{#each problems as item (item.problemId)}
						<li class:historical={!item.active}>
							<div class="row-head">
								<span class="substance">{item.display}</span>
								<StatusChip
									label={item.statusLabel}
									tone={item.active ? 'caution' : 'neutral'}
								/>
							</div>
							{#if item.onsetAt}
								<p class="row-meta"><span>Onset {time(item.onsetAt)}</span></p>
							{/if}
						</li>
					{/each}
				</ul>
			{/if}
		</section>
	</div>

	<section aria-labelledby="results-heading">
		<h2 id="results-heading">Results</h2>
		{#if observations.length === 0}
			<EmptyState kind="empty" title="No results for this encounter" />
		{:else}
			<ul class="panel">
				{#each observations as item (item.observationId)}
					<li class:prominent={item.critical}>
						<div class="row-head">
							<span class="substance">{item.display}</span>
							<span class="value">{item.value}</span>
							<StatusChip
								label={item.interpretationLabel}
								tone={item.critical ? 'critical' : 'neutral'}
							/>
						</div>
						<p class="row-meta">
							<span>{time(item.effectiveAt)}</span>
							<span>{item.status}</span>
							{#if item.referenceRange}<span>Reference {item.referenceRange}</span>{/if}
							{#if item.interpretationSource}
								<!--
								  SRS-CLN-011: the flag comes from the authoritative
								  service. Shown with its source, because a flag with
								  no attribution is indistinguishable from one this
								  screen inferred.
								-->
								<span class="source">Interpreted by {item.interpretationSource}</span>
							{/if}
						</p>
					</li>
				{/each}
			</ul>
		{/if}
	</section>

	<section aria-labelledby="notes-heading">
		<h2 id="notes-heading">Notes</h2>

		{#if mayWrite && !banner?.readOnly}
			<form class="card" onsubmit={(e) => { e.preventDefault(); void signDraft(); }}>
				<h3>Write a note</h3>
				<label for="note-title">Title</label>
				<input id="note-title" bind:value={draftTitle} />

				<label for="note-text">Note</label>
				<textarea id="note-text" rows="6" bind:value={draftText}></textarea>

				{#if draftDirty && !signReadiness.ready}
					<ul class="readiness">
						{#each signReadiness.problems as problem (problem)}
							<li>{problem}</li>
						{/each}
					</ul>
				{/if}

				<div class="buttons">
					<button type="button" class="secondary" onclick={saveDraft} disabled={saving || !draftDirty}>
						{saving ? 'Saving…' : 'Save draft'}
					</button>
					<button type="submit" disabled={signing || !maySign || !signReadiness.ready}>
						{signing ? 'Signing…' : 'Sign note'}
					</button>
				</div>
				{#if !maySign}
					<p class="hint">Your role can write a note but not sign one.</p>
				{/if}
			</form>
		{/if}

		{#if notes.length === 0}
			<EmptyState kind="empty" title="Nothing written yet" />
		{:else}
			<ul class="notes">
				{#each notes as note (note.documentId)}
					{@const actions = actionsFor(note, { subjectId, mayWrite })}
					<li>
						<div class="row-head">
							<span class="substance">{note.title || 'Untitled note'}</span>
							<StatusChip
								label={describeStatus(note.status)}
								tone={note.status === 'draft' ? 'caution' : 'neutral'}
							/>
							{#if note.dictated && !isFinalised(note)}
								<!--
								  SRS-CLN-016: dictated content is draft input until a
								  clinician reviews and signs. A transcriber's signature
								  does not finalise it.
								-->
								<StatusChip label="Dictated — awaiting clinician" tone="caution" />
							{/if}
							{#if !note.intact}
								<StatusChip label="Does not match its signature" tone="critical" />
							{/if}
						</div>
						<p class="row-meta">
							<span>{note.authoredBy}</span>
							<span>{time(note.updatedAt)}</span>
							{#if note.changeReason}<span>Reason: {note.changeReason}</span>{/if}
						</p>

						{#if actions.blockedReason}
							<p class="blocked">{actions.blockedReason}</p>
						{:else}
							<div class="buttons">
								<!--
								  No Edit button on a signed note. Absent rather than
								  disabled: a disabled control reads as "I need a
								  permission", and the correct reading is "the record
								  does not do that".
								-->
								{#if actions.amend}
									<button
										type="button"
										class="secondary"
										onclick={() => startCorrection(note, 'amendment')}
									>
										Correct what this says
									</button>
								{/if}
								{#if actions.addendum}
									<button
										type="button"
										class="secondary"
										onclick={() => startCorrection(note, 'addendum')}
									>
										Add something later
									</button>
								{/if}
							</div>
						{/if}
					</li>
				{/each}
			</ul>
		{/if}

		{#if correcting}
			{@const guidance = describeCorrection(correcting.kind)}
			<form class="card" onsubmit={(e) => { e.preventDefault(); void submitCorrection(); }}>
				<h3>{guidance.title}</h3>
				<p class="hint">{guidance.detail}</p>

				<label for="correction-text">Text</label>
				<textarea id="correction-text" rows="5" bind:value={correctionText}></textarea>

				<label for="correction-reason">
					Reason{guidance.reasonRequired ? '' : ' (optional)'}
				</label>
				<input id="correction-reason" bind:value={correctionReason} />

				<div class="buttons">
					<button type="button" class="secondary" onclick={() => (correcting = null)}>
						Cancel
					</button>
					<button
						type="submit"
						disabled={saving ||
							(guidance.reasonRequired && correctionReason.trim() === '') ||
							correctionText.trim() === ''}
					>
						{saving ? 'Saving…' : 'Save'}
					</button>
				</div>
			</form>
		{/if}
	</section>
{/if}

<style>
	.columns {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(20rem, 1fr));
		gap: 1.5rem;
		margin: 1.5rem 0;
	}
	h2 {
		font-size: 1rem;
		margin: 0 0 0.5rem;
	}
	h3 {
		font-size: 0.9375rem;
		margin: 0 0 0.35rem;
	}
	.panel,
	.notes {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}
	.panel li,
	.notes li {
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 0.6rem 0.8rem;
		background: #fff;
	}
	.panel li.prominent {
		border-color: #e9b0ab;
		background: #fffafa;
	}
	.panel li.historical {
		background: #f6f7f9;
		color: #5b6779;
	}
	.row-head {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		flex-wrap: wrap;
	}
	.substance {
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
	.source {
		font-style: italic;
	}
	.context-lock {
		border: 1px solid #e9b0ab;
		background: #fdeceb;
		color: #7a1c17;
		border-radius: 6px;
		padding: 0.5rem 0.75rem;
		margin: 0 0 0.75rem;
		font-weight: 600;
	}
	.read-only {
		border: 1px solid #e8cb91;
		background: #fdf3e0;
		color: #6b4708;
		border-radius: 6px;
		padding: 0.5rem 0.75rem;
		margin: 0.75rem 0 0;
	}
	.blocked {
		margin: 0.4rem 0 0;
		font-size: 0.8125rem;
		color: #6b4708;
	}
	.card {
		background: #fff;
		border: 1px solid #dde2ea;
		border-radius: 8px;
		padding: 1rem 1.25rem;
		margin-bottom: 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
	}
	label {
		font-size: 0.8125rem;
		font-weight: 600;
	}
	input,
	textarea {
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
	.buttons {
		display: flex;
		gap: 0.5rem;
		margin-top: 0.5rem;
		flex-wrap: wrap;
	}
	button {
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
	.hint {
		color: #5b6779;
		font-size: 0.875rem;
		margin: 0;
	}
</style>
