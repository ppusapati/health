/// Mobile application shell.
///
/// Context first (UX spec §1): the user must be able to see which tenant and
/// facility they are acting in, and whether this is a real environment, before
/// they act.
library;

import 'package:flutter/material.dart';

import '../config/environment.dart';
import '../gen/healthcare/identity_access/v1/identity.pb.dart';
import '../offline/operation_queue.dart';
import '../workspace/navigation.dart';

/// Scaffold with the environment banner, context bar and sync indicator.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.config,
    required this.title,
    required this.child,
    this.session,
    this.queueCounts,
    this.onSignOut,
    this.workspace,
  });

  final AppConfig config;
  final String title;
  final Widget child;
  final SessionContext? session;
  final Map<QueuedStatus, int>? queueCounts;
  final VoidCallback? onSignOut;

  /// What this user is offered, already filtered by the permissions the server
  /// reported. Null when signed out.
  ///
  /// Filtered, not authorized: every route behind these entries is still
  /// protected on the server. Hiding a link stops the user being offered an
  /// action that will fail; it is not a control.
  final Workspace? workspace;

  @override
  Widget build(BuildContext context) {
    final workspace = this.workspace;

    return Scaffold(
      drawer: workspace == null ? null : _WorkspaceDrawer(workspace: workspace),
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (onSignOut != null)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign out',
              onPressed: onSignOut,
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (config.environment.showsEnvironmentBanner)
            _EnvironmentBanner(environment: config.environment),
          if (session != null) _ContextBar(session: session!),
          if (queueCounts != null) _SyncIndicator(counts: queueCounts!),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _EnvironmentBanner extends StatelessWidget {
  const _EnvironmentBanner({required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('environment-banner'),
      width: double.infinity,
      color: const Color(0xFF6B4708),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Text(
        '${environment.name.toUpperCase()} — not for real patient data',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class _ContextBar extends StatelessWidget {
  const _ContextBar({required this.session});

  final SessionContext session;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('context-bar'),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Wrap(
        spacing: 20,
        runSpacing: 4,
        children: [
          _ContextItem(label: 'Tenant', value: session.tenantId),
          _ContextItem(
            label: 'Facility',
            value: session.activeFacilityId.isEmpty
                ? 'All facilities'
                : session.activeFacilityId,
          ),
          _ContextItem(label: 'Signed in', value: session.subjectId),
          // A persistent indicator while an override is active (UX spec §3.2).
          if (session.breakGlassActive)
            const Chip(
              key: Key('break-glass-indicator'),
              label: Text('Break-glass active'),
              backgroundColor: Color(0xFF7A1C17),
              labelStyle: TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }
}

class _ContextItem extends StatelessWidget {
  const _ContextItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: 0.6)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// Shows queued work so the user knows their action is saved but not yet sent
/// (UX spec §12).
class _SyncIndicator extends StatelessWidget {
  const _SyncIndicator({required this.counts});

  final Map<QueuedStatus, int> counts;

  @override
  Widget build(BuildContext context) {
    final pending = counts[QueuedStatus.pending] ?? 0;
    final failed = counts[QueuedStatus.failed] ?? 0;
    if (pending == 0 && failed == 0) return const SizedBox.shrink();

    final parts = <String>[
      if (pending > 0) '$pending waiting to sync',
      if (failed > 0) '$failed need attention',
    ];

    return Container(
      key: const Key('sync-indicator'),
      width: double.infinity,
      color: failed > 0 ? const Color(0xFFFDECEB) : const Color(0xFFFDF3E0),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        children: [
          Icon(failed > 0 ? Icons.error_outline : Icons.cloud_upload_outlined, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(parts.join(' · '), style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}

/// The workspace a user's permissions produce.
class _WorkspaceDrawer extends StatelessWidget {
  const _WorkspaceDrawer({required this.workspace});

  final Workspace workspace;

  @override
  Widget build(BuildContext context) {
    if (workspace.empty) {
      return const Drawer(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            // An unexplained empty drawer reads as a broken app. It is a
            // legitimate state — a user whose role grants nothing this build
            // offers — and saying so is the difference between a support call
            // about a bug and one about access.
            child: Text(
              'Nothing is available to you here yet.\n\n'
              'Your account does not hold any of the permissions these screens '
              'need. An administrator can grant them.',
            ),
          ),
        ),
      );
    }

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            for (final section in WorkspaceSection.values)
              ..._section(context, section),
            if (workspace.worklists.isNotEmpty) ...[
              const Divider(),
              _heading(context, 'Your worklists'),
              for (final worklist in workspace.worklists)
                ListTile(
                  key: Key('worklist-${worklist.id}'),
                  leading: const Icon(Icons.checklist),
                  title: Text(worklist.label),
                ),
            ],
            if (workspace.quickActions.isNotEmpty) ...[
              const Divider(),
              _heading(context, 'Quick actions'),
              for (final action in workspace.quickActions)
                ListTile(
                  key: Key('quick-action-${action.id}'),
                  leading: Icon(action.finalizes ? Icons.gavel : Icons.add),
                  title: Text(action.label),
                  // An action that finalizes something clinical or financial
                  // says so before it is tapped, because on a phone a tile is
                  // hit by accident far more often than a mouse click is.
                  subtitle: action.finalizes
                      ? const Text('Opens a confirmation step')
                      : null,
                ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _section(BuildContext context, WorkspaceSection section) {
    final items = workspace.navigation.where((i) => i.section == section).toList();
    if (items.isEmpty) return const [];

    return [
      _heading(context, switch (section) {
        WorkspaceSection.clinical => 'Clinical',
        WorkspaceSection.operations => 'Operations',
        WorkspaceSection.administration => 'Administration',
      }),
      for (final item in items)
        ListTile(
          key: Key('nav-${item.id}'),
          title: Text(item.label),
        ),
    ];
  }

  Widget _heading(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: const Color(0xFF33415C)),
        ),
      );
}
