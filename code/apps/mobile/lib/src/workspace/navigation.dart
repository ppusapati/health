/// Role-specific workspace home (SRS-WEB-004).
///
/// The verification clause is "navigation reflects role but server still
/// enforces authorization". Those are two independent statements, and
/// conflating them is the classic client-side security failure: a menu that
/// hides an action is a menu, not a control, and the endpoint behind it is
/// still there for anybody who can reach it.
///
/// So this builds navigation from permissions and says so loudly, and a test
/// asserts that nothing here is used as an access decision. Hiding is a
/// courtesy: it stops the user being offered actions that will fail. The
/// server refuses regardless.
library;

import 'package:meta/meta.dart';

/// Where an entry sits in the app.
enum WorkspaceSection { clinical, operations, administration }

/// One entry in the workspace navigation.
@immutable
class NavItem {
  const NavItem({
    required this.id,
    required this.label,
    required this.route,
    required this.requires,
    required this.section,
  });

  final String id;
  final String label;
  final String route;

  /// The permission that makes this entry useful. The server enforces it; this
  /// only decides whether to offer the link.
  final String requires;

  final WorkspaceSection section;
}

/// A quick action offered on the workspace home.
@immutable
class QuickAction {
  const QuickAction({
    required this.id,
    required this.label,
    required this.requires,
    required this.finalizes,
  });

  final String id;
  final String label;
  final String requires;

  /// True for actions that finalize something clinical or financial. The home
  /// screen renders these differently — never as a one-tap tile, because a tap
  /// target on a phone is hit by accident far more often than a mouse click.
  final bool finalizes;
}

/// What a worklist tile shows.
@immutable
class Worklist {
  const Worklist({
    required this.id,
    required this.label,
    required this.requires,
    required this.route,
  });

  final String id;
  final String label;
  final String requires;
  final String route;
}

/// The catalogue the workspace is built from.
@immutable
class WorkspaceCatalogue {
  const WorkspaceCatalogue({
    required this.navigation,
    required this.quickActions,
    required this.worklists,
  });

  final List<NavItem> navigation;
  final List<QuickAction> quickActions;
  final List<Worklist> worklists;
}

/// What a user actually sees.
@immutable
class Workspace {
  const Workspace({
    required this.navigation,
    required this.quickActions,
    required this.worklists,
    required this.empty,
  });

  final List<NavItem> navigation;
  final List<QuickAction> quickActions;
  final List<Worklist> worklists;

  /// True when the user holds no permission that any entry needs. The home
  /// screen shows an explanation rather than a blank page, because an empty
  /// workspace looks identical to a broken one.
  final bool empty;
}

/// Builds the workspace a set of permissions should see.
///
/// Takes the permission list rather than a session object so it cannot
/// accidentally reach for anything else — a function that could see the whole
/// session could start branching on a role name, and role names drift from
/// permissions the moment a role is renamed.
Workspace buildWorkspace(
  WorkspaceCatalogue catalogue,
  List<String> permissions,
) {
  final held = permissions.toSet();
  bool offers(String requires) => held.contains(requires);

  final navigation =
      catalogue.navigation.where((i) => offers(i.requires)).toList(growable: false);
  final quickActions =
      catalogue.quickActions.where((a) => offers(a.requires)).toList(growable: false);
  final worklists =
      catalogue.worklists.where((w) => offers(w.requires)).toList(growable: false);

  return Workspace(
    navigation: navigation,
    quickActions: quickActions,
    worklists: worklists,
    empty: navigation.isEmpty && quickActions.isEmpty && worklists.isEmpty,
  );
}

/// The Wave-0 catalogue.
///
/// Small, because Wave 0 has two bounded contexts. A data structure rather than
/// widgets so a test can assert what each role sees without pumping anything,
/// and so a Wave-1 context adds entries without touching a screen.
const WorkspaceCatalogue waveZeroCatalogue = WorkspaceCatalogue(
  navigation: [
    NavItem(
      id: 'facilities',
      label: 'Facilities',
      route: '/facilities',
      requires: 'organization.facility.read',
      section: WorkspaceSection.administration,
    ),
    NavItem(
      id: 'org-units',
      label: 'Departments and units',
      route: '/units',
      requires: 'organization.unit.read',
      section: WorkspaceSection.administration,
    ),
  ],
  quickActions: [
    QuickAction(
      id: 'new-facility',
      label: 'Add facility',
      requires: 'organization.facility.create',
      finalizes: false,
    ),
    QuickAction(
      id: 'approve-change',
      label: 'Approve a master-data change',
      requires: 'organization.master_data.approve',
      // Approving a change takes effect on production configuration, so it is
      // never a one-tap tile.
      finalizes: true,
    ),
  ],
  worklists: [
    Worklist(
      id: 'pending-approvals',
      label: 'Changes awaiting your approval',
      requires: 'organization.master_data.approve',
      route: '/approvals',
    ),
  ],
);

/// The Wave-1 catalogue for a ward device.
///
/// Permission-gated rather than short. An earlier version of this file carried
/// only the two workspaces a nurse uses on a round, on the argument that a
/// tablet is for work done standing up. That argument was about the device and
/// it was the wrong axis: the same tablet is carried by a receptionist at a
/// counter and handed to a clinician at a bedside, and what each of them
/// should see is decided by what they may do, not by what the hardware is.
///
/// So every workspace is here, and each appears only for somebody holding the
/// permission it needs. A nurse still sees a short list — theirs — because the
/// permissions do the narrowing that the old comment did by omission.
const WorkspaceCatalogue wardCatalogue = WorkspaceCatalogue(
  navigation: [
    NavItem(
      id: 'reception',
      label: 'Reception',
      route: '/reception',
      requires: 'scheduling.queue.read',
      section: WorkspaceSection.clinical,
    ),
    NavItem(
      id: 'patients',
      label: 'My patients',
      route: '/patients',
      // The same permission the worklist needs: a nurse who may see the work
      // may see whose work it is.
      requires: 'nursing.task.read',
      section: WorkspaceSection.clinical,
    ),
    NavItem(
      id: 'chart',
      label: 'Chart',
      route: '/chart',
      requires: 'clinical.note.read',
      section: WorkspaceSection.clinical,
    ),
    NavItem(
      id: 'ward',
      label: 'Ward worklist',
      route: '/ward',
      requires: 'nursing.task.read',
      section: WorkspaceSection.clinical,
    ),
    NavItem(
      id: 'medication-round',
      label: 'Medication round',
      route: '/medications/round',
      requires: 'nursing.administration.read',
      section: WorkspaceSection.clinical,
    ),
  ],
  quickActions: [
    QuickAction(
      id: 'chart-observation',
      label: 'Record observations',
      requires: 'nursing.observation.write',
      finalizes: false,
    ),
    QuickAction(
      id: 'administer',
      label: 'Give a medication',
      // Finalizing: this one puts a drug into a patient, and on a phone a tile
      // is hit by accident far more often than a mouse click.
      requires: 'nursing.administration.write',
      finalizes: true,
    ),
  ],
  worklists: [
    Worklist(
      id: 'doses-due',
      label: 'Doses due now',
      requires: 'nursing.administration.read',
      route: '/medications/round',
    ),
    Worklist(
      id: 'observations-due',
      label: 'Observations due',
      requires: 'nursing.task.read',
      route: '/ward',
    ),
  ],
);

/// Merges catalogues into the one the shell renders.
WorkspaceCatalogue mergeCatalogues(List<WorkspaceCatalogue> catalogues) =>
    WorkspaceCatalogue(
      navigation: [for (final c in catalogues) ...c.navigation],
      quickActions: [for (final c in catalogues) ...c.quickActions],
      worklists: [for (final c in catalogues) ...c.worklists],
    );
