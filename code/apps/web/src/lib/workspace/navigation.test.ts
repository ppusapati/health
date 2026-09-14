import { describe, expect, it } from 'vitest';
import {
	buildWorkspace,
	mergeCatalogues,
	receptionCatalogue,
	waveZeroCatalogue
} from './navigation.js';

describe('role-specific workspace (SRS-WEB-004)', () => {
	it('offers an administrator the administration entries', () => {
		const workspace = buildWorkspace(waveZeroCatalogue, [
			'organization.facility.read',
			'organization.facility.create',
			'organization.unit.read'
		]);

		expect(workspace.navigation.map((i) => i.id)).toContain('facilities');
		expect(workspace.navigation.map((i) => i.id)).toContain('org-units');
		expect(workspace.quickActions.map((a) => a.id)).toContain('new-facility');
		expect(workspace.empty).toBe(false);
	});

	it('offers a viewer only what they can read', () => {
		const workspace = buildWorkspace(waveZeroCatalogue, ['organization.facility.read']);

		expect(workspace.navigation.map((i) => i.id)).toEqual(['facilities']);
		// No create action: offering a button that will fail teaches users to
		// distrust the interface.
		expect(workspace.quickActions).toHaveLength(0);
	});

	it('gives an approver their worklist', () => {
		const workspace = buildWorkspace(waveZeroCatalogue, ['organization.master_data.approve']);
		expect(workspace.worklists.map((w) => w.id)).toContain('pending-approvals');
		expect(workspace.navigation.map((i) => i.id)).toContain('approvals');
	});

	it('reports an empty workspace rather than rendering a blank page', () => {
		// An empty workspace looks identical to a broken one, and the user's
		// next action is a support ticket either way unless we say which.
		const workspace = buildWorkspace(waveZeroCatalogue, []);
		expect(workspace.empty).toBe(true);
	});

	it('ignores permissions no entry needs', () => {
		const workspace = buildWorkspace(waveZeroCatalogue, ['some.future.permission']);
		expect(workspace.empty).toBe(true);
	});
});

describe('navigation is not authorization', () => {
	it('every entry names the permission the server will enforce', () => {
		// The entry exists to be hidden, not to authorise. Each one naming its
		// permission is what lets a reviewer check that the hiding matches what
		// the server actually requires.
		const all = [
			...waveZeroCatalogue.navigation,
			...waveZeroCatalogue.quickActions,
			...waveZeroCatalogue.worklists
		];
		for (const entry of all) {
			expect(entry.requires).toBeTruthy();
			expect(entry.requires).toMatch(/^[a-z_]+\.[a-z_.]+$/);
		}
	});

	it('hiding an entry removes the link, not the endpoint', () => {
		// This is a documentation test: it records that buildWorkspace returns
		// presentation only. The server-side proof is in internal/app's
		// contract tests, which call the endpoints directly with a token that
		// holds no permission and expect PERMISSION_DENIED.
		const workspace = buildWorkspace(waveZeroCatalogue, []);
		expect(workspace.navigation).toHaveLength(0);
		// Nothing in the returned shape claims authority: no tokens, no flags
		// a caller could mistake for a decision.
		expect(Object.keys(workspace).sort()).toEqual([
			'empty',
			'navigation',
			'quickActions',
			'worklists'
		]);
	});

	it('marks finalizing actions so the home screen does not make them one-click', () => {
		const approve = waveZeroCatalogue.quickActions.find((a) => a.id === 'approve-change');
		expect(approve?.finalizes).toBe(true);

		const add = waveZeroCatalogue.quickActions.find((a) => a.id === 'new-facility');
		expect(add?.finalizes).toBe(false);
	});
});

describe('the reception catalogue', () => {
	it('offers nothing to a user with no clinical permissions', () => {
		// A receptionist's terminal and a finance terminal run the same build.
		// Offering clinical navigation to a user the server will refuse is how a
		// workspace fills with buttons that produce permission errors.
		const workspace = buildWorkspace(receptionCatalogue, ['billing.invoice.read']);
		expect(workspace.empty).toBe(true);
	});

	it('offers search and the board to a receptionist', () => {
		const workspace = buildWorkspace(receptionCatalogue, [
			'empi.patient.read',
			'sch.schedule.read'
		]);
		expect(workspace.navigation.map((n) => n.id)).toEqual([
			'reception-board',
			'patient-search'
		]);
		expect(workspace.worklists.map((w) => w.id)).toEqual(['todays-clinic']);
	});

	it('treats registering a patient as an action that finalizes something', () => {
		// A duplicate created by a mis-click reads as a second person until
		// somebody notices, so it never becomes a one-click tile (SRS-WEB-007).
		const register = receptionCatalogue.quickActions.find((a) => a.id === 'register-patient');
		expect(register?.finalizes).toBe(true);
	});

	it('merges with the Wave-0 catalogue without losing either', () => {
		const merged = mergeCatalogues(waveZeroCatalogue, receptionCatalogue);
		const workspace = buildWorkspace(merged, [
			'organization.facility.read',
			'empi.patient.read'
		]);
		expect(workspace.navigation.map((n) => n.id)).toContain('facilities');
		expect(workspace.navigation.map((n) => n.id)).toContain('patient-search');
	});
});
