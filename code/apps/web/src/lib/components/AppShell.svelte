<!--
  Workspace shell.

  Context first: the user must always be able to see which tenant and facility
  they are acting in before they act (UX spec §1, §3.1). The environment banner
  exists so nobody enters real data into a non-production system
  (SRS-WEB-003).
-->
<script lang="ts">
	import type { Snippet } from 'svelte';
	import { session } from '$lib/session.js';

	interface Props {
		environment: string;
		children: Snippet;
	}

	const { environment, children }: Props = $props();

	const isProduction = $derived(environment === 'production');
</script>

<div class="shell">
	{#if !isProduction}
		<div class="environment" role="status">
			{environment.toUpperCase()} environment — not for real patient data
		</div>
	{/if}

	<header class="header">
		<a class="brand" href="/">Unified Healthcare Platform</a>

		<div class="context">
			{#if $session}
				<span class="context-item">
					<span class="context-label">Tenant</span>
					<span class="context-value">{$session.context.tenantId}</span>
				</span>
				<span class="context-item">
					<span class="context-label">Facility</span>
					<span class="context-value">
						{$session.context.activeFacilityId || 'All facilities'}
					</span>
				</span>
				<span class="context-item">
					<span class="context-label">Signed in</span>
					<span class="context-value">{$session.context.subjectId}</span>
				</span>
				{#if $session.context.breakGlassActive}
					<!-- A persistent indicator while an override is active
					     (UX spec §3.2). -->
					<span class="break-glass">Break-glass active</span>
				{/if}
			{:else}
				<span class="context-item"><span class="context-value">Not signed in</span></span>
			{/if}
		</div>
	</header>

	<div class="body">
		<nav class="nav" aria-label="Primary">
			<a href="/">Home</a>
			<a href="/facilities">Facilities</a>
		</nav>
		<main class="content">
			{@render children()}
		</main>
	</div>
</div>

<style>
	:global(body) {
		margin: 0;
		font-family:
			ui-sans-serif, system-ui, -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
		color: #1b2333;
		background: #f6f7f9;
	}
	.environment {
		background: #6b4708;
		color: #fff;
		text-align: center;
		padding: 0.35rem;
		font-size: 0.8125rem;
		letter-spacing: 0.04em;
	}
	.header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		flex-wrap: wrap;
		gap: 1rem;
		padding: 0.75rem 1.25rem;
		background: #fff;
		border-bottom: 1px solid #dde2ea;
	}
	.brand {
		font-weight: 700;
		color: inherit;
		text-decoration: none;
	}
	.context {
		display: flex;
		flex-wrap: wrap;
		gap: 1.25rem;
		align-items: center;
	}
	.context-item {
		display: flex;
		flex-direction: column;
		line-height: 1.2;
	}
	.context-label {
		font-size: 0.6875rem;
		text-transform: uppercase;
		letter-spacing: 0.06em;
		color: #5b6779;
	}
	.context-value {
		font-size: 0.875rem;
		font-weight: 600;
	}
	.break-glass {
		background: #7a1c17;
		color: #fff;
		padding: 0.2rem 0.6rem;
		border-radius: 999px;
		font-size: 0.75rem;
		font-weight: 700;
	}
	.body {
		display: flex;
		align-items: flex-start;
		gap: 1.5rem;
		padding: 1.5rem 1.25rem;
	}
	.nav {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		min-width: 11rem;
	}
	.nav a {
		padding: 0.5rem 0.75rem;
		border-radius: 6px;
		color: #33415c;
		text-decoration: none;
	}
	.nav a:hover,
	.nav a:focus-visible {
		background: #eef1f5;
	}
	.content {
		flex: 1;
		min-width: 0;
	}
	:global(a:focus-visible),
	:global(button:focus-visible),
	:global(input:focus-visible),
	:global(select:focus-visible) {
		outline: 2px solid #1c5fd6;
		outline-offset: 2px;
	}
	@media (max-width: 720px) {
		.body {
			flex-direction: column;
		}
		.nav {
			flex-direction: row;
			flex-wrap: wrap;
		}
	}
</style>
