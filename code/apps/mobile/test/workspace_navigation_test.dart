/// SRS-WEB-004 — role-specific workspace home.
///
/// The verification clause has two halves: navigation reflects role, and the
/// server still enforces authorization. The first half is testable here. The
/// second half is testable only on the server, so what these tests can honestly
/// assert about it is the negative: this module produces no answer to "may I?"
/// that a screen could mistake for a control.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/workspace/navigation.dart';

const _catalogue = WorkspaceCatalogue(
  navigation: [
    NavItem(
      id: 'ward',
      label: 'Ward',
      route: '/ward',
      requires: 'nursing.ward.read',
      section: WorkspaceSection.clinical,
    ),
    NavItem(
      id: 'facilities',
      label: 'Facilities',
      route: '/facilities',
      requires: 'organization.facility.read',
      section: WorkspaceSection.administration,
    ),
  ],
  quickActions: [
    QuickAction(
      id: 'observation',
      label: 'Record observations',
      requires: 'nursing.observation.write',
      finalizes: false,
    ),
    QuickAction(
      id: 'approve',
      label: 'Approve a change',
      requires: 'organization.master_data.approve',
      finalizes: true,
    ),
  ],
  worklists: [
    Worklist(
      id: 'due',
      label: 'Observations due',
      requires: 'nursing.ward.read',
      route: '/ward/due',
    ),
  ],
);

void main() {
  test('a user is offered only what their permissions can act on', () {
    final workspace = buildWorkspace(_catalogue, ['nursing.ward.read']);

    expect(workspace.navigation.map((i) => i.id), ['ward']);
    expect(workspace.worklists.map((w) => w.id), ['due']);
    expect(workspace.quickActions, isEmpty);
    expect(workspace.empty, isFalse);
  });

  test('holding every permission offers the whole catalogue', () {
    final workspace = buildWorkspace(_catalogue, [
      'nursing.ward.read',
      'organization.facility.read',
      'nursing.observation.write',
      'organization.master_data.approve',
    ]);

    expect(workspace.navigation, hasLength(2));
    expect(workspace.quickActions, hasLength(2));
    expect(workspace.worklists, hasLength(1));
  });

  test('a user with no relevant permission gets an explained empty workspace', () {
    // Not a blank screen: `empty` exists so the home can say why there is
    // nothing here. An unexplained empty workspace is indistinguishable from a
    // failed load, and the user's response to the two is different.
    final workspace = buildWorkspace(_catalogue, ['billing.invoice.read']);

    expect(workspace.empty, isTrue);
    expect(workspace.navigation, isEmpty);
    expect(workspace.quickActions, isEmpty);
    expect(workspace.worklists, isEmpty);
  });

  test('an unknown permission grants nothing by accident', () {
    // A near-miss is the realistic failure: a permission renamed on the server
    // and not here. It must remove the entry, never leave it offered.
    final workspace = buildWorkspace(_catalogue, ['nursing.ward.reads']);

    expect(workspace.empty, isTrue);
  });

  test('what is offered follows permissions, not the name of a role', () {
    // buildWorkspace takes a permission list and nothing else, so two roles
    // with the same grants are indistinguishable to it. This is the property
    // that keeps navigation correct when a role is renamed or split.
    final chargeNurse = buildWorkspace(_catalogue, ['nursing.ward.read']);
    final agencyNurse = buildWorkspace(_catalogue, ['nursing.ward.read']);

    expect(
      chargeNurse.navigation.map((i) => i.id),
      agencyNurse.navigation.map((i) => i.id),
    );
    expect(chargeNurse.empty, agencyNurse.empty);
  });

  test('hiding an entry does not remove the route behind it', () {
    // The point of the test is what it cannot assert. Filtering the catalogue
    // changes what is offered; the route still exists and the server is the
    // only thing standing in front of it. If this ever became an access
    // decision, the assertion below is where the lie would start.
    final workspace = buildWorkspace(_catalogue, const []);

    expect(workspace.navigation, isEmpty);
    expect(
      _catalogue.navigation.map((i) => i.route),
      containsAll(['/ward', '/facilities']),
    );
  });

  test('actions that finalize something are marked so the home can slow them down', () {
    final workspace = buildWorkspace(_catalogue, [
      'nursing.observation.write',
      'organization.master_data.approve',
    ]);

    final finalizing = workspace.quickActions.where((a) => a.finalizes);
    expect(finalizing.map((a) => a.id), ['approve']);
  });

  test('the Wave-0 catalogue offers an administrator their two contexts', () {
    final workspace = buildWorkspace(waveZeroCatalogue, [
      'organization.facility.read',
      'organization.unit.read',
      'organization.facility.create',
    ]);

    expect(workspace.navigation.map((i) => i.id), ['facilities', 'org-units']);
    expect(workspace.quickActions.map((a) => a.id), ['new-facility']);
    // Approval is a separate grant: creating master data and approving it are
    // held by different people on purpose.
    expect(workspace.worklists, isEmpty);
  });

  test('the Wave-0 catalogue is entirely administrative', () {
    expect(
      waveZeroCatalogue.navigation.every(
        (i) => i.section == WorkspaceSection.administration,
      ),
      isTrue,
    );
  });

  test('merging catalogues preserves every entry and its order', () {
    final merged = mergeCatalogues([waveZeroCatalogue, _catalogue]);

    expect(
      merged.navigation.map((i) => i.id),
      ['facilities', 'org-units', 'ward', 'facilities'],
    );
    expect(merged.quickActions, hasLength(4));
    expect(merged.worklists, hasLength(2));
  });

  test('merging nothing yields an empty workspace rather than a failure', () {
    final workspace = buildWorkspace(mergeCatalogues(const []), ['anything']);

    expect(workspace.empty, isTrue);
  });

  group('the ward catalogue', () {
    test('a ward nurse is offered the round and the worklist', () {
      final workspace = buildWorkspace(wardCatalogue, [
        'nursing.task.read',
        'nursing.administration.read',
        'nursing.observation.write',
        'nursing.administration.write',
      ]);

      expect(workspace.navigation.map((i) => i.id),
          ['patients', 'ward', 'medication-round']);
      expect(workspace.worklists.map((w) => w.id),
          ['doses-due', 'observations-due']);
      expect(workspace.empty, isFalse);
    });

    test('giving a medication is marked as finalizing', () {
      // It puts a drug into a patient, and on a phone a tile is hit by accident
      // far more often than a mouse click.
      final workspace =
          buildWorkspace(wardCatalogue, ['nursing.administration.write']);

      final action = workspace.quickActions.single;
      expect(action.id, 'administer');
      expect(action.finalizes, isTrue);
    });

    test('recording observations is not finalizing', () {
      final workspace =
          buildWorkspace(wardCatalogue, ['nursing.observation.write']);
      expect(workspace.quickActions.single.finalizes, isFalse);
    });

    test('a nurse who may read but not give sees the round and no give action', () {
      final workspace =
          buildWorkspace(wardCatalogue, ['nursing.administration.read']);

      // No 'patients': that entry needs nursing.task.read, which this nurse
      // does not hold.
      expect(workspace.navigation.map((i) => i.id), ['medication-round']);
      expect(workspace.quickActions, isEmpty);
    });

    test('everything on a ward device is clinical', () {
      // The argument for a short list: a tablet carried on a round is for work
      // done standing up. Reception and billing stay on the web.
      expect(
        wardCatalogue.navigation
            .every((i) => i.section == WorkspaceSection.clinical),
        isTrue,
      );
    });

    test('an administrator is offered nothing clinical, and a nurse nothing administrative', () {
      final administrator = buildWorkspace(
        mergeCatalogues(const [waveZeroCatalogue, wardCatalogue]),
        ['organization.facility.read'],
      );
      final nurse = buildWorkspace(
        mergeCatalogues(const [waveZeroCatalogue, wardCatalogue]),
        ['nursing.task.read'],
      );

      expect(administrator.navigation.map((i) => i.id), ['facilities']);
      // The picker rides on the same permission as the worklist: a nurse who
      // may see the work may see whose work it is.
      expect(nurse.navigation.map((i) => i.id), ['patients', 'ward']);
    });
  });
}
