/**
 * Role-specific workspace home (SRS-WEB-004).
 *
 * The verification clause is the whole design: "navigation reflects role but
 * server still enforces authorization". Those are two independent statements,
 * and conflating them is the classic front-end security failure — a menu that
 * hides an action is a menu, not a control, and the endpoint behind it is
 * still there for anyone who knows the URL.
 *
 * So this module builds navigation from permissions and says so loudly, and a
 * test asserts that nothing here is used as an access decision. Hiding is a
 * courtesy: it stops the user being offered buttons that will fail. The server
 * refuses regardless.
 */

/** One entry in the workspace navigation. */
export interface NavItem {
	readonly id: string;
	readonly label: string;
	readonly href: string;
	/**
	 * The permission that makes this entry useful. The server enforces it; this
	 * only decides whether to offer the link.
	 */
	readonly requires: string;
	/** Grouping in the sidebar. */
	readonly section: 'clinical' | 'operations' | 'administration';
}

/** A quick action offered on the workspace home. */
export interface QuickAction {
	readonly id: string;
	readonly label: string;
	readonly requires: string;
	/**
	 * True for actions that finalize something clinical or financial. The home
	 * screen renders these differently — never as a one-click tile — because a
	 * quick action that signs something is a mis-click away from a clinical
	 * event (SRS-WEB-007).
	 */
	readonly finalizes: boolean;
}

/** What a worklist tile shows. */
export interface Worklist {
	readonly id: string;
	readonly label: string;
	readonly requires: string;
	/** Route the tile links to. */
	readonly href: string;
}

/** The catalogue the workspace is built from. */
export interface WorkspaceCatalogue {
	readonly navigation: readonly NavItem[];
	readonly quickActions: readonly QuickAction[];
	readonly worklists: readonly Worklist[];
}

/** What a user actually sees. */
export interface Workspace {
	readonly navigation: readonly NavItem[];
	readonly quickActions: readonly QuickAction[];
	readonly worklists: readonly Worklist[];
	/**
	 * True when the user holds no permission that any entry needs. The home
	 * screen shows an explanation rather than an empty page, because an empty
	 * workspace looks identical to a broken one.
	 */
	readonly empty: boolean;
}

/**
 * Builds the workspace a set of permissions should see.
 *
 * Pure and permission-driven. It takes the permission list rather than a
 * session object so it cannot accidentally reach for anything else — a
 * function that could see the whole session could start branching on a role
 * name, and role names drift from permissions the moment a role is renamed.
 */
export function buildWorkspace(
	catalogue: WorkspaceCatalogue,
	permissions: readonly string[]
): Workspace {
	const held = new Set(permissions);
	const offers = (requires: string): boolean => held.has(requires);

	const navigation = catalogue.navigation.filter((i) => offers(i.requires));
	const quickActions = catalogue.quickActions.filter((a) => offers(a.requires));
	const worklists = catalogue.worklists.filter((w) => offers(w.requires));

	return {
		navigation,
		quickActions,
		worklists,
		empty: navigation.length === 0 && quickActions.length === 0 && worklists.length === 0
	};
}

/**
 * The Wave-0 catalogue.
 *
 * Small, because Wave 0 has two bounded contexts. It is a data structure
 * rather than markup so a test can assert what each role sees without
 * rendering anything, and so a Wave-1 context adds entries without touching a
 * component.
 */
export const waveZeroCatalogue: WorkspaceCatalogue = {
	navigation: [
		{
			id: 'facilities',
			label: 'Facilities',
			href: '/facilities',
			requires: 'organization.facility.read',
			section: 'administration'
		},
		{
			id: 'org-units',
			label: 'Departments and units',
			href: '/units',
			requires: 'organization.unit.read',
			section: 'administration'
		},
		{
			id: 'approvals',
			label: 'Pending approvals',
			href: '/approvals',
			requires: 'organization.master_data.approve',
			section: 'operations'
		}
	],
	quickActions: [
		{
			id: 'new-facility',
			label: 'Add facility',
			requires: 'organization.facility.create',
			finalizes: false
		},
		{
			id: 'approve-change',
			label: 'Approve a master-data change',
			requires: 'organization.master_data.approve',
			// Approving a change takes effect on production configuration, so
			// it is never a one-click tile.
			finalizes: true
		}
	],
	worklists: [
		{
			id: 'pending-approvals',
			label: 'Changes awaiting your approval',
			requires: 'organization.master_data.approve',
			href: '/approvals'
		},
		{
			id: 'emergency-review',
			label: 'Emergency access awaiting review',
			requires: 'security.emergency.review',
			href: '/security/emergency'
		}
	]
};

/**
 * The Wave-1 catalogue: the reception desk (UX-W1-01).
 *
 * Separate from the Wave-0 entries rather than merged into them, so a
 * deployment running only the platform contexts is not offered clinical
 * navigation that would fail at the server. Merged at the composition point
 * below.
 */
export const receptionCatalogue: WorkspaceCatalogue = {
	navigation: [
		{
			id: 'reception-board',
			label: 'Reception board',
			href: '/reception',
			requires: 'sch.schedule.read',
			section: 'operations'
		},
		{
			id: 'patient-search',
			label: 'Find a patient',
			href: '/reception/search',
			requires: 'empi.patient.read',
			section: 'clinical'
		},
		{
			id: 'ward-worklist',
			label: 'Ward worklist',
			href: '/ward',
			requires: 'nursing.record.read',
			section: 'clinical'
		},
		{
			id: 'orders',
			label: 'Orders and results',
			href: '/orders',
			requires: 'orders.order.read',
			section: 'clinical'
		}
	],
	quickActions: [
		{
			id: 'find-patient',
			label: 'Find a patient',
			requires: 'empi.patient.read',
			finalizes: false
		},
		{
			id: 'register-patient',
			label: 'Register a patient',
			// Creating a patient record is not reversible by the person who did
			// it, and a duplicate created here is read as a second person for as
			// long as it takes somebody to notice. Never a one-click tile: the
			// action routes into search-before-create (SRS-EMPI-003).
			requires: 'empi.patient.create',
			finalizes: true
		}
	],
	worklists: [
		{
			id: 'todays-clinic',
			label: "Today's clinic",
			requires: 'sch.schedule.read',
			href: '/reception'
		},
		{
			id: 'nursing-work',
			label: 'Nursing work and reassessments',
			requires: 'nursing.record.read',
			href: '/ward'
		},
		{
			id: 'results-inbox',
			label: 'Critical results awaiting action',
			requires: 'clinical.record.write',
			href: '/orders'
		}
	]
};

/** Merges catalogues into the one the shell renders. */
export function mergeCatalogues(
	...catalogues: readonly WorkspaceCatalogue[]
): WorkspaceCatalogue {
	return {
		navigation: catalogues.flatMap((c) => c.navigation),
		quickActions: catalogues.flatMap((c) => c.quickActions),
		worklists: catalogues.flatMap((c) => c.worklists)
	};
}
