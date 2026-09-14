<!--
  Patient banner (SRS-CLN-001).

  The one control that makes "wrong patient" noticeable, so it appears on every
  workspace and looks the same on all of them. What it shows is decided in
  $lib/patient/banner.ts and tested there; this renders it.

  Two rendering rules earn their place.

  Alerts render before the name, not beside it. A deceased or merged-away
  record is a fact about whether this chart may be used at all, and a banner
  that puts it to the right of a long name puts it off the edge of a narrow
  screen.

  Nothing here is colour-only. A ward terminal is often a cheap panel at a bad
  angle, and the alert that matters must survive being printed in greyscale.
-->
<script lang="ts">
	import type { PatientBanner } from '$lib/patient/banner.js';
	import StatusChip from './StatusChip.svelte';

	interface Props {
		banner: PatientBanner;
		/** Rendered smaller inside a list row. */
		compact?: boolean;
	}

	const { banner, compact = false }: Props = $props();

	const tones = {
		deceased: 'critical',
		merged: 'critical',
		unidentified: 'caution',
		inactive: 'caution',
		masked: 'neutral'
	} as const;
</script>

<section class="banner" class:compact aria-label="Patient">
	{#if banner.alerts.length > 0}
		<!--
		  role="alert" only when the record must not be used. Announcing a
		  masked-field notice as an alert on every chart trains people to ignore
		  the region, which is where the deceased notice also lives.
		-->
		<ul class="alerts" role={banner.readOnly ? 'alert' : undefined}>
			{#each banner.alerts as alert (alert.kind)}
				<li><StatusChip label={alert.text} tone={tones[alert.kind]} /></li>
			{/each}
		</ul>
	{/if}

	<div class="identity">
		<h2 class="name">{banner.displayName}</h2>
		<dl class="facts">
			<div><dt>Age</dt><dd>{banner.age}</dd></div>
			<div><dt>Sex</dt><dd>{banner.sex}</dd></div>
			{#each banner.identifiers as identifier (identifier.label + identifier.value)}
				<div>
					<dt>{identifier.label}</dt>
					<dd><code>{identifier.value}</code></dd>
				</div>
			{/each}
		</dl>
	</div>
</section>

<style>
	.banner {
		border: 1px solid #c8d0dd;
		border-radius: 8px;
		padding: 0.75rem 1rem;
		background: #fbfcfe;
	}
	.compact {
		padding: 0.5rem 0.75rem;
		background: transparent;
		border: none;
	}
	.alerts {
		list-style: none;
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin: 0 0 0.5rem;
		padding: 0;
	}
	.name {
		margin: 0;
		font-size: 1.25rem;
		line-height: 1.3;
	}
	.compact .name {
		font-size: 1rem;
	}
	.facts {
		display: flex;
		flex-wrap: wrap;
		gap: 0.25rem 1.25rem;
		margin: 0.35rem 0 0;
	}
	.facts div {
		display: flex;
		gap: 0.35rem;
		align-items: baseline;
	}
	dt {
		font-size: 0.75rem;
		text-transform: uppercase;
		letter-spacing: 0.04em;
		color: #5a6884;
		margin: 0;
	}
	dd {
		margin: 0;
		font-size: 0.9375rem;
	}
	code {
		font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
	}
</style>
