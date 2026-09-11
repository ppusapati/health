/**
 * Unsaved clinical draft warning (SRS-WEB-012).
 *
 * The verification clause is "user can stay/discard according to policy", and
 * the word *policy* is what makes this more than a confirm dialog. Different
 * drafts deserve different answers:
 *
 *   A half-typed search box should never interrupt anyone.
 *   A half-written progress note should ask.
 *   A partially signed prescription should be hard to leave by accident.
 *
 * The specific hazard this exists for is the patient switch. Navigating away
 * loses work; switching patient with a draft open risks something worse — the
 * draft being saved against the wrong chart. That is why a patient switch is a
 * distinct kind of navigation here rather than just another route change.
 */

/** How insistent the guard should be about a draft. */
export type DraftPolicy =
	/** Leave without asking. Search boxes, filters, anything re-derivable. */
	| 'discard-silently'
	/** Ask, and let the user discard. Notes, forms, most clinical drafts. */
	| 'confirm'
	/**
	 * Ask, and refuse a patient switch outright. For drafts where saving
	 * against the wrong chart is the hazard — an order being signed, a
	 * medication being administered.
	 */
	| 'block-patient-switch';

/** A piece of in-progress work the user has not committed. */
export interface Draft {
	readonly id: string;
	/** Shown to the user: "progress note", "discharge summary". */
	readonly description: string;
	readonly policy: DraftPolicy;
	/** The patient the draft belongs to, when it belongs to one. */
	readonly patientRef: string | null;
	/** False once the user has saved; a clean draft never prompts. */
	readonly dirty: boolean;
}

/** What the user is trying to do. */
export type Navigation =
	| { readonly kind: 'route'; readonly to: string }
	| { readonly kind: 'patient-switch'; readonly toPatientRef: string }
	| { readonly kind: 'close-window' };

/** What the guard decided. */
export interface GuardDecision {
	/** True when navigation may proceed with no interruption. */
	readonly allow: boolean;
	/** True when the user must be asked. */
	readonly prompt: boolean;
	/**
	 * True when the navigation is refused outright and no prompt will help.
	 * The UI shows why and offers to finish or explicitly discard the draft.
	 */
	readonly blocked: boolean;
	/** Drafts that caused the decision, for the message.  */
	readonly drafts: readonly Draft[];
	/** A stable reason code; the UI localises from it. */
	readonly reason: string;
}

export const REASON_CLEAN = 'NO_UNSAVED_WORK';
export const REASON_CONFIRM = 'UNSAVED_DRAFTS';
export const REASON_WRONG_CHART = 'DRAFT_BELONGS_TO_ANOTHER_PATIENT';

/**
 * Decides whether a navigation may proceed.
 *
 * Pure, so the policy can be tested without a browser and without simulating a
 * beforeunload event — which is the part of this that is otherwise
 * untestable and therefore the part that quietly stops working.
 */
export function evaluate(drafts: readonly Draft[], navigation: Navigation): GuardDecision {
	const dirty = drafts.filter((d) => d.dirty && d.policy !== 'discard-silently');

	if (dirty.length === 0) {
		return { allow: true, prompt: false, blocked: false, drafts: [], reason: REASON_CLEAN };
	}

	if (navigation.kind === 'patient-switch') {
		// A draft for a different patient is the dangerous case: continuing
		// risks the work being filed against the chart the user switched to.
		const foreign = dirty.filter(
			(d) =>
				d.policy === 'block-patient-switch' &&
				d.patientRef !== null &&
				d.patientRef !== navigation.toPatientRef
		);
		if (foreign.length > 0) {
			return {
				allow: false,
				prompt: false,
				blocked: true,
				drafts: foreign,
				reason: REASON_WRONG_CHART
			};
		}
	}

	return { allow: false, prompt: true, blocked: false, drafts: dirty, reason: REASON_CONFIRM };
}

/**
 * Builds the message shown to the user.
 *
 * Names the drafts. "You have unsaved changes" is not actionable — the user
 * cannot tell whether it means the note they are writing or a filter they
 * changed ten minutes ago, so they either lose work or learn to click through
 * the dialog without reading it.
 */
export function describe(decision: GuardDecision): string {
	if (decision.allow) {
		return '';
	}
	const names = decision.drafts.map((d) => d.description).join(', ');

	if (decision.blocked) {
		return (
			`Finish or discard ${names} before switching patient. ` +
			`Leaving it open risks filing it against the wrong chart.`
		);
	}
	return `You have unsaved work: ${names}. Leave and discard it?`;
}

/**
 * Tracks the drafts currently open in the workspace.
 *
 * A registry rather than each component wiring its own beforeunload handler:
 * handlers registered per component are removed inconsistently, and the ones
 * that leak keep prompting after their component is gone.
 */
export class DraftRegistry {
	private drafts = new Map<string, Draft>();
	private readonly subscribers = new Set<(drafts: readonly Draft[]) => void>();

	register(draft: Draft): void {
		this.drafts.set(draft.id, draft);
		this.notify();
	}

	/** Marks a draft clean or dirty without re-registering it. */
	setDirty(id: string, dirty: boolean): void {
		const existing = this.drafts.get(id);
		if (!existing) {
			return;
		}
		this.drafts.set(id, { ...existing, dirty });
		this.notify();
	}

	/** Removes a draft — after a save, or after the user discarded it. */
	release(id: string): void {
		if (this.drafts.delete(id)) {
			this.notify();
		}
	}

	open(): readonly Draft[] {
		return [...this.drafts.values()];
	}

	evaluate(navigation: Navigation): GuardDecision {
		return evaluate(this.open(), navigation);
	}

	subscribe(run: (drafts: readonly Draft[]) => void): () => void {
		this.subscribers.add(run);
		run(this.open());
		return () => this.subscribers.delete(run);
	}

	private notify(): void {
		const snapshot = this.open();
		for (const run of this.subscribers) {
			run(snapshot);
		}
	}
}

/**
 * Installs the browser's own unload warning.
 *
 * The browser deliberately ignores any custom message and shows its own, so
 * `describe` is for the in-app dialog and this is only the last-resort
 * backstop for a tab close. Returns a teardown function.
 */
export function installUnloadGuard(registry: DraftRegistry, target: Window): () => void {
	const handler = (event: BeforeUnloadEvent): void => {
		const decision = registry.evaluate({ kind: 'close-window' });
		if (!decision.allow) {
			event.preventDefault();
			// Assigning returnValue is what actually triggers the prompt in
			// every browser that still supports it; preventDefault alone is
			// not enough in some.
			event.returnValue = '';
		}
	};
	target.addEventListener('beforeunload', handler);
	return () => target.removeEventListener('beforeunload', handler);
}
