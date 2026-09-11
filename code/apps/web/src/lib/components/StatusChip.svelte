<!--
  Canonical status chip.

  One concept, one appearance, everywhere (UX spec §6.1). Status carries an
  icon and a label, never colour alone: colour-only encoding fails both
  colour-blind users and greyscale printing (UX spec §13).
-->
<script lang="ts">
	/** Semantic class, not a colour name. */
	type Tone = 'neutral' | 'positive' | 'caution' | 'critical';

	interface Props {
		label: string;
		tone?: Tone;
	}

	const { label, tone = 'neutral' }: Props = $props();

	const glyphs: Record<Tone, string> = {
		neutral: '●',
		positive: '✓',
		caution: '!',
		critical: '✕'
	};
</script>

<span class="chip {tone}">
	<span class="glyph" aria-hidden="true">{glyphs[tone]}</span>
	<span class="label">{label}</span>
</span>

<style>
	.chip {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.15rem 0.5rem;
		border-radius: 999px;
		border: 1px solid var(--chip-border);
		background: var(--chip-bg);
		color: var(--chip-fg);
		font-size: 0.8125rem;
		line-height: 1.4;
		white-space: nowrap;
	}
	.glyph {
		font-size: 0.75em;
	}
	.neutral {
		--chip-bg: #eef1f5;
		--chip-fg: #33415c;
		--chip-border: #c8d0dd;
	}
	.positive {
		--chip-bg: #e7f5ec;
		--chip-fg: #11593a;
		--chip-border: #a8d8bd;
	}
	.caution {
		--chip-bg: #fdf3e0;
		--chip-fg: #6b4708;
		--chip-border: #e8cb91;
	}
	.critical {
		--chip-bg: #fdeceb;
		--chip-fg: #7a1c17;
		--chip-border: #e9b0ab;
	}
</style>
