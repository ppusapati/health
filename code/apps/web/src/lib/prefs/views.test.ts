import { describe, expect, it } from 'vitest';
import {
	applyPreferences,
	InvalidViewError,
	validateView,
	ViewStore,
	type PreferenceStore,
	type SavedView,
	type WorklistDefinition
} from './views.js';

const definition: WorklistDefinition = {
	worklist: 'ward-round',
	columns: [
		{ key: 'patient', visible: true, position: 0, width: null },
		{ key: 'allergies', visible: true, position: 1, width: null },
		{ key: 'bed', visible: true, position: 2, width: null },
		{ key: 'consultant', visible: true, position: 3, width: null }
	],
	// Hiding an allergy column is a patient-safety failure produced by a
	// preferences feature.
	mandatoryColumns: ['patient', 'allergies']
};

const view = (overrides: Partial<SavedView> = {}): SavedView => ({
	id: 'view-1',
	name: 'My ward round',
	worklist: 'ward-round',
	columns: [
		{ key: 'bed', visible: true, position: 0, width: 80 },
		{ key: 'patient', visible: true, position: 1, width: null },
		{ key: 'allergies', visible: true, position: 2, width: null },
		{ key: 'consultant', visible: false, position: 3, width: null }
	],
	filters: {},
	sortKey: null,
	sortDescending: false,
	...overrides
});

/** An in-memory PreferenceStore, so tests need no browser storage. */
function memoryStore(): PreferenceStore & { readonly data: Map<string, SavedView[]> } {
	const data = new Map<string, SavedView[]>();
	return {
		data,
		async load(userKey) {
			return data.get(userKey) ?? [];
		},
		async save(userKey, views) {
			data.set(userKey, [...views]);
		}
	};
}

describe('applying saved preferences (SRS-WEB-013)', () => {
	it('uses the defaults when nothing is saved', () => {
		const columns = applyPreferences(definition, null);
		expect(columns.map((c) => c.key)).toEqual(['patient', 'allergies', 'bed', 'consultant']);
	});

	it('honours a saved order and visibility', () => {
		const columns = applyPreferences(definition, view());
		expect(columns.map((c) => c.key)).toEqual(['bed', 'patient', 'allergies', 'consultant']);
		expect(columns.find((c) => c.key === 'consultant')?.visible).toBe(false);
		expect(columns.find((c) => c.key === 'bed')?.width).toBe(80);
	});

	it('keeps a mandatory column visible even if the saved view hid it', () => {
		// A view saved before a column became mandatory would otherwise keep
		// hiding it indefinitely.
		const hidden = view({
			columns: [
				{ key: 'allergies', visible: false, position: 0, width: null },
				{ key: 'patient', visible: true, position: 1, width: null }
			]
		});
		const columns = applyPreferences(definition, hidden);
		expect(columns.find((c) => c.key === 'allergies')?.visible).toBe(true);
	});

	it('shows a column the worklist gained since the view was saved', () => {
		// A hidden new column is indistinguishable from a column that does not
		// exist, so a stale view must not hide one.
		const stale = view({
			columns: [
				{ key: 'patient', visible: true, position: 0, width: null },
				{ key: 'allergies', visible: true, position: 1, width: null }
			]
		});
		const columns = applyPreferences(definition, stale);
		const bed = columns.find((c) => c.key === 'bed');
		expect(bed?.visible).toBe(true);
		// Appended rather than inserted, so it does not displace a column the
		// user deliberately ordered.
		expect(columns.map((c) => c.key).slice(0, 2)).toEqual(['patient', 'allergies']);
	});

	it('drops a column the worklist no longer has', () => {
		const withGhost = view({
			columns: [...view().columns, { key: 'removed', visible: true, position: 9, width: null }]
		});
		const columns = applyPreferences(definition, withGhost);
		expect(columns.map((c) => c.key)).not.toContain('removed');
	});
});

describe('validation refuses rather than silently corrects', () => {
	it('refuses hiding a safety-critical column', () => {
		// A silently corrected preference is one the user will set again,
		// because from their side nothing happened.
		const unsafe = view({
			columns: view().columns.map((c) =>
				c.key === 'allergies' ? { ...c, visible: false } : c
			)
		});
		expect(() => validateView(definition, unsafe)).toThrow(InvalidViewError);
	});

	it('refuses an unknown column', () => {
		const bogus = view({
			columns: [{ key: 'not-a-column', visible: true, position: 0, width: null }]
		});
		expect(() => validateView(definition, bogus)).toThrow(InvalidViewError);
	});

	it('refuses a view for another worklist', () => {
		expect(() => validateView(definition, view({ worklist: 'theatre-list' }))).toThrow(
			InvalidViewError
		);
	});

	it('refuses a nameless view', () => {
		expect(() => validateView(definition, view({ name: '  ' }))).toThrow(InvalidViewError);
	});

	it('refuses a view that shows nothing', () => {
		const blank = view({
			columns: view().columns.map((c) => ({ ...c, visible: false }))
		});
		expect(() => validateView(definition, blank)).toThrow(InvalidViewError);
	});
});

describe('preferences are user-scoped (the shared ward terminal)', () => {
	it('one user’s view is invisible to another', async () => {
		// A nurse who hides a column on the machine at the nurses' station must
		// not hide it for the next person who signs in.
		const store = memoryStore();
		const nurse = new ViewStore(store, 'nurse-1');
		const doctor = new ViewStore(store, 'doctor-1');

		await nurse.put(definition, view());

		expect(await nurse.list('ward-round')).toHaveLength(1);
		expect(await doctor.list('ward-round')).toHaveLength(0);
	});

	it('refuses an empty user key, which would collapse everyone onto one bucket', async () => {
		expect(() => new ViewStore(memoryStore(), '  ')).toThrow(InvalidViewError);
	});

	it('lists only the requested worklist', async () => {
		const store = new ViewStore(memoryStore(), 'nurse-1');
		await store.put(definition, view());
		await store.put(
			{ ...definition, worklist: 'theatre-list' },
			view({ id: 'view-2', worklist: 'theatre-list' })
		);

		expect(await store.list('ward-round')).toHaveLength(1);
		expect(await store.list('theatre-list')).toHaveLength(1);
	});
});

describe('preferences are resettable (SRS-WEB-013)', () => {
	it('resets one worklist in a single action', async () => {
		// The user reaching for this cannot see what is wrong: a filter narrow
		// enough to hide the patients they want looks like an empty worklist.
		const store = new ViewStore(memoryStore(), 'nurse-1');
		await store.put(definition, view());
		await store.put(
			{ ...definition, worklist: 'theatre-list' },
			view({ id: 'view-2', worklist: 'theatre-list' })
		);

		await store.reset('ward-round');

		expect(await store.list('ward-round')).toHaveLength(0);
		// The other worklist is untouched: a reset is scoped, not scorched.
		expect(await store.list('theatre-list')).toHaveLength(1);
	});

	it('resets everything when asked', async () => {
		const store = new ViewStore(memoryStore(), 'nurse-1');
		await store.put(definition, view());
		await store.resetAll();
		expect(await store.list('ward-round')).toHaveLength(0);
	});

	it('after a reset the worklist renders its defaults', async () => {
		const store = new ViewStore(memoryStore(), 'nurse-1');
		await store.put(definition, view());
		await store.reset('ward-round');

		const remaining = await store.list('ward-round');
		const columns = applyPreferences(definition, remaining[0] ?? null);
		expect(columns.map((c) => c.key)).toEqual(['patient', 'allergies', 'bed', 'consultant']);
		expect(columns.every((c) => c.visible)).toBe(true);
	});

	it('replaces a view saved again under the same id', async () => {
		const store = new ViewStore(memoryStore(), 'nurse-1');
		await store.put(definition, view());
		await store.put(definition, view({ name: 'Renamed' }));

		const views = await store.list('ward-round');
		expect(views).toHaveLength(1);
		expect(views[0].name).toBe('Renamed');
	});

	it('removes a single view', async () => {
		const store = new ViewStore(memoryStore(), 'nurse-1');
		await store.put(definition, view());
		await store.put(definition, view({ id: 'view-2', name: 'Second' }));
		await store.remove('view-1');

		const views = await store.list('ward-round');
		expect(views.map((v) => v.id)).toEqual(['view-2']);
	});
});
