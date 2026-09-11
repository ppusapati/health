<!--
  Persistent failure banner.

  Shows plain language plus the correlation ID, so a user can quote something
  actionable to support without the page ever exposing a stack trace or an
  internal message (SRS-WEB-011, Domain/Data spec §7).
-->
<script lang="ts">
	import type { PresentedError } from '$lib/api/errors.js';

	interface Props {
		error: PresentedError | null;
		onRetry?: () => void;
	}

	const { error, onRetry }: Props = $props();
</script>

{#if error}
	<div class="banner" role="alert">
		<p class="message">{error.message}</p>
		<p class="meta">
			<span>Reference: <code>{error.code}</code></span>
			{#if error.correlationId}
				<span>Correlation ID: <code>{error.correlationId}</code></span>
			{/if}
		</p>
		{#if error.retryable && onRetry}
			<button type="button" onclick={onRetry}>Try again</button>
		{/if}
	</div>
{/if}

<style>
	.banner {
		border: 1px solid #e9b0ab;
		background: #fdeceb;
		color: #7a1c17;
		border-radius: 6px;
		padding: 0.75rem 1rem;
		margin-bottom: 1rem;
	}
	.message {
		margin: 0 0 0.25rem;
		font-weight: 600;
	}
	.meta {
		margin: 0;
		display: flex;
		flex-wrap: wrap;
		gap: 1rem;
		font-size: 0.8125rem;
	}
	code {
		font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
	}
	button {
		margin-top: 0.5rem;
	}
</style>
