/**
 * Saved views and column preferences (SRS-WEB-013).
 *
 * The verification clause is "preferences are user-scoped and resettable", and
 * both halves are load-bearing in a hospital.
 *
 * User-scoped, because ward terminals are shared. A nurse who hides the
 * allergy column on the machine at the nurses' station must not hide it for
 * the next person who signs in — that is a patient-safety failure produced by
 * a preferences feature.
 *
 * Resettable, because a saved view can be wrong in a way its owner cannot see:
 * a filter narrow enough to hide the patients they are looking for looks
 * identical to an empty worklist. "Reset to default" is the escape hatch, and
 * it has to be one action rather than undoing a dozen individual settings.
 */

/** One column's presentation in a worklist. */
export interface ColumnPreference {
	readonly key: string;
	readonly visible: boolean;
	/** Display order, ascending. */
	readonly position: number;
	/** Pixel width, or null to let the table decide. */
	readonly width: number | null;
}

/** A named, saved configuration of a worklist. */
export interface SavedView {
	readonly id: string;
	readonly name: string;
	readonly worklist: string;
	readonly columns: readonly ColumnPreference[];
	/** Opaque filter state, owned by the worklist that defined it. */
	readonly filters: Readonly<Record<string, string>>;
	readonly sortKey: string | null;
	readonly sortDescending: boolean;
}

/** The columns a worklist ships with, before any preference is applied. */
export interface WorklistDefinition {
	readonly worklist: string;
	readonly columns: readonly ColumnPreference[];
	/**
	 * Columns that may never be hidden. Allergies, alerts, patient identifiers:
	 * a preference that can hide a safety-critical column is a preference that
	 * will hide one.
	 */
	readonly mandatoryColumns: readonly string[];
}

/** Thrown when a preference would produce an unusable or unsafe view. */
export class InvalidViewError extends Error {
	constructor(message: string) {
		super(message);
		this.name = 'InvalidViewError';
	}
}

/**
 * Applies saved preferences to a worklist's definition.
 *
 * Unknown columns in the saved view are dropped and columns the definition has
 * gained are appended visible. That combination is what makes a saved view
 * survive a release: a view saved last month must not break when a column is
 * added, and must not hide a new column the user has never seen — because a
 * hidden new column is indistinguishable from a column that does not exist.
 */
export function applyPreferences(
	definition: WorklistDefinition,
	view: SavedView | null
): readonly ColumnPreference[] {
	if (!view) {
		return [...definition.columns].sort((a, b) => a.position - b.position);
	}

	const saved = new Map(view.columns.map((c) => [c.key, c]));
	const mandatory = new Set(definition.mandatoryColumns);

	const resolved = definition.columns.map((column, index) => {
		const preference = saved.get(column.key);
		if (!preference) {
			// A column the definition gained since the view was saved. Visible,
			// and placed after the saved ones so it does not silently displace
			// a column the user deliberately ordered.
			return { ...column, position: 1000 + index };
		}
		return {
			key: column.key,
			// Mandatory columns ignore the saved visibility. A view saved
			// before a column became mandatory would otherwise keep hiding it.
			visible: mandatory.has(column.key) ? true : preference.visible,
			position: preference.position,
			width: preference.width
		};
	});

	return resolved.sort((a, b) => a.position - b.position);
}

/**
 * Validates a view before it is saved.
 *
 * Rejects rather than silently corrects. A silently corrected preference is one
 * the user will set again, because from their side nothing happened.
 */
export function validateView(definition: WorklistDefinition, view: SavedView): void {
	if (!view.name.trim()) {
		throw new InvalidViewError('a saved view needs a name');
	}
	if (view.worklist !== definition.worklist) {
		throw new InvalidViewError(
			`view is for worklist ${view.worklist}, not ${definition.worklist}`
		);
	}

	const known = new Set(definition.columns.map((c) => c.key));
	for (const column of view.columns) {
		if (!known.has(column.key)) {
			throw new InvalidViewError(`unknown column ${column.key}`);
		}
	}

	for (const key of definition.mandatoryColumns) {
		const preference = view.columns.find((c) => c.key === key);
		if (preference && !preference.visible) {
			throw new InvalidViewError(
				`column ${key} cannot be hidden: it carries information the worklist ` +
					`must always show`
			);
		}
	}

	if (!view.columns.some((c) => c.visible)) {
		throw new InvalidViewError('a view must show at least one column');
	}
}

/** The storage a view store persists through. */
export interface PreferenceStore {
	load(userKey: string): Promise<readonly SavedView[]>;
	save(userKey: string, views: readonly SavedView[]): Promise<void>;
}

/**
 * Manages one user's saved views.
 *
 * The user key is supplied at construction and every operation goes through it,
 * so there is no method that can read or write another user's preferences —
 * which is the shared-ward-terminal problem solved by construction rather than
 * by remembering to pass the right key.
 */
export class ViewStore {
	constructor(
		private readonly store: PreferenceStore,
		private readonly userKey: string
	) {
		if (!userKey.trim()) {
			// An empty key would collapse every user onto one bucket, which on
			// a shared terminal means the last person's view for everyone.
			throw new InvalidViewError('a preference store needs a user key');
		}
	}

	async list(worklist: string): Promise<readonly SavedView[]> {
		const all = await this.store.load(this.userKey);
		return all.filter((v) => v.worklist === worklist);
	}

	async put(definition: WorklistDefinition, view: SavedView): Promise<void> {
		validateView(definition, view);
		const all = await this.store.load(this.userKey);
		const without = all.filter((v) => v.id !== view.id);
		await this.store.save(this.userKey, [...without, view]);
	}

	/**
	 * Removes one view, returning the worklist to its defaults for that view.
	 */
	async remove(viewId: string): Promise<void> {
		const all = await this.store.load(this.userKey);
		await this.store.save(
			this.userKey,
			all.filter((v) => v.id !== viewId)
		);
	}

	/**
	 * Discards every saved view for a worklist — the escape hatch.
	 *
	 * One action rather than undoing a dozen settings, because the user
	 * reaching for this cannot see what is wrong: a filter narrow enough to
	 * hide the patients they are looking for looks exactly like an empty
	 * worklist.
	 */
	async reset(worklist: string): Promise<void> {
		const all = await this.store.load(this.userKey);
		await this.store.save(
			this.userKey,
			all.filter((v) => v.worklist !== worklist)
		);
	}

	/** Discards every saved view this user holds. */
	async resetAll(): Promise<void> {
		await this.store.save(this.userKey, []);
	}
}

/**
 * A PreferenceStore backed by localStorage.
 *
 * Preferences are per-device on purpose at this stage: they are presentation
 * only, they carry no PHI, and keeping them local avoids a round trip on every
 * worklist render. The key is namespaced by user so a shared ward terminal
 * does not mix two people's views.
 *
 * Every access is guarded: localStorage throws in a private window and in an
 * iframe with third-party storage blocked, and a worklist must render anyway.
 */
export function localPreferenceStore(): PreferenceStore {
	const keyFor = (userKey: string): string => `health.views.${userKey}`;

	return {
		async load(userKey: string): Promise<readonly SavedView[]> {
			try {
				const raw = localStorage.getItem(keyFor(userKey));
				if (!raw) {
					return [];
				}
				const parsed: unknown = JSON.parse(raw);
				return Array.isArray(parsed) ? (parsed as SavedView[]) : [];
			} catch {
				// Unreadable or corrupt: behave as if nothing was saved. The
				// worklist renders with its defaults, which is always usable.
				return [];
			}
		},
		async save(userKey: string, views: readonly SavedView[]): Promise<void> {
			try {
				localStorage.setItem(keyFor(userKey), JSON.stringify(views));
			} catch {
				// Storage is full or blocked. A preference that does not persist
				// is a small annoyance; an exception here would break the
				// worklist, which is not.
			}
		}
	};
}
