<script lang="ts">
	import type { Snippet } from 'svelte';
	import AppShell from '$lib/components/AppShell.svelte';
	import { PUBLIC_ENVIRONMENT } from '$lib/config.js';

	const { children }: { children: Snippet } = $props();
</script>

<AppShell environment={PUBLIC_ENVIRONMENT}>
	{@render children()}
</AppShell>
