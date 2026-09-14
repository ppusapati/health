<!--
  The state a screen is in when it has nothing to show.

  One component for four of the states UX-W1-01 requires — empty, permission,
  loading and error-free-but-nothing-here — because the failure this prevents
  is a screen that renders all of them identically. An empty worklist and a
  worklist the user may not see look the same from the outside and mean
  completely different things: one says the clinic is quiet, the other says ask
  your administrator.
-->
<script lang="ts">
	interface Props {
		kind: 'empty' | 'permission' | 'loading' | 'search-first';
		title: string;
		detail?: string;
	}

	const { kind, title, detail = '' }: Props = $props();
</script>

<div class="state {kind}" role={kind === 'loading' ? 'status' : undefined} aria-live={kind === 'loading' ? 'polite' : undefined}>
	<p class="title">{title}</p>
	{#if detail}
		<p class="detail">{detail}</p>
	{/if}
</div>

<style>
	.state {
		border: 1px dashed #c8d0dd;
		border-radius: 8px;
		padding: 2rem 1rem;
		text-align: center;
		color: #33415c;
	}
	.permission {
		border-style: solid;
		border-color: #e8cb91;
		background: #fdf3e0;
		color: #6b4708;
	}
	.title {
		margin: 0;
		font-weight: 600;
	}
	.detail {
		margin: 0.35rem 0 0;
		font-size: 0.9375rem;
		color: #5a6884;
	}
	.permission .detail {
		color: #6b4708;
	}
</style>
