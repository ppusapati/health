<script lang="ts">
	import { session } from '$lib/session.js';
</script>

<h1>Wave 0 — Platform Foundation</h1>

<p>
	This shell consumes the same canonical ConnectRPC contracts as the Go service and the Flutter
	applications. Every action is authorized server-side; what is rendered here only reflects what
	the signed-in user may attempt.
</p>

{#if $session}
	<h2>Your permissions</h2>
	<ul>
		{#each $session.context.permissions as permission (permission)}
			<li><code>{permission}</code></li>
		{/each}
	</ul>
{:else}
	<p>Sign in on the <a href="/facilities">Facilities</a> screen to begin.</p>
{/if}

<style>
	code {
		font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
	}
</style>
