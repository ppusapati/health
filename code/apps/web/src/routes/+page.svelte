<!--
  Workspace home (SRS-WEB-004).

  What a user sees first is decided by the permissions they hold, not by a role
  name: roles get renamed and recombined, and a home screen branching on one
  shows the wrong thing the day somebody creates "Senior Receptionist".

  The distinction this screen has to keep is between "you have no work" and
  "you have no access". They look identical if both render as an empty page,
  and the user's next move is completely different — one is a quiet morning,
  the other is a call to an administrator.
-->
<script lang="ts">
	import { session } from '$lib/session.js';
	import EmptyState from '$lib/components/EmptyState.svelte';
	import {
		buildWorkspace,
		mergeCatalogues,
		receptionCatalogue,
		waveZeroCatalogue
	} from '$lib/workspace/navigation.js';

	const catalogue = mergeCatalogues(waveZeroCatalogue, receptionCatalogue);
	const workspace = $derived(buildWorkspace(catalogue, $session?.context.permissions ?? []));

	/** Where a quick action leads. Kept beside the catalogue it mirrors. */
	function hrefFor(actionId: string): string {
		switch (actionId) {
			case 'find-patient':
			case 'register-patient':
				return '/reception/search';
			case 'new-facility':
			case 'approve-change':
				return '/facilities';
			default:
				return '/';
		}
	}
</script>

<h1>Your workspace</h1>

{#if !$session}
	<p>
		This shell consumes the same canonical ConnectRPC contracts as the Go service and the
		Flutter applications. Every action is authorized server-side; what is rendered here only
		reflects what the signed-in user may attempt.
	</p>
	<p>Sign in on the <a href="/facilities">Facilities</a> screen to begin.</p>
{:else if workspace.empty}
	<EmptyState
		kind="permission"
		title="Your roles grant no workspace yet"
		detail="Ask your administrator for the permissions your job needs."
	/>
{:else}
	{#if workspace.worklists.length > 0}
		<h2>Your work</h2>
		<ul class="tiles">
			{#each workspace.worklists as worklist (worklist.id)}
				<li><a class="tile" href={worklist.href}>{worklist.label}</a></li>
			{/each}
		</ul>
	{/if}

	{#if workspace.quickActions.length > 0}
		<h2>Actions</h2>
		<ul class="actions">
			{#each workspace.quickActions as action (action.id)}
				<li>
					<!--
					  An action that finalizes something clinical or financial is
					  never a one-click tile (SRS-WEB-007). It is a link into the
					  screen that can show what is about to happen, with the
					  consequence stated here so the difference is visible before
					  the click rather than after it.
					-->
					<a class="action" class:finalizes={action.finalizes} href={hrefFor(action.id)}>
						{action.label}
					</a>
					{#if action.finalizes}
						<span class="warns">Creates a permanent record — you will confirm first</span>
					{/if}
				</li>
			{/each}
		</ul>
	{/if}
{/if}

<style>
	.tiles,
	.actions {
		list-style: none;
		padding: 0;
		margin: 0 0 1.5rem;
		display: flex;
		flex-wrap: wrap;
		gap: 0.75rem;
	}
	.actions li {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}
	.tile,
	.action {
		display: inline-block;
		padding: 0.75rem 1rem;
		border: 1px solid #dde2ea;
		border-radius: 8px;
		background: #fff;
		text-decoration: none;
		color: #1b2333;
		font-weight: 600;
	}
	.action.finalizes {
		border-color: #e8cb91;
		background: #fdf3e0;
	}
	.warns {
		font-size: 0.75rem;
		color: #6b4708;
		max-width: 16rem;
	}
</style>
