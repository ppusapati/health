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
  });

  final AppConfig config;
  final String title;
  final Widget child;
  final SessionContext? session;
  final Map<QueuedStatus, int>? queueCounts;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
