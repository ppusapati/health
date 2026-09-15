/// The banner a bedside screen carries above everything else.
///
/// Allergies first, and an unanswered allergy question said out loud. The
/// widget is dumb: everything it decides was decided in `patient/banner.dart`
/// and tested there.
library;

import 'package:flutter/material.dart';

import '../patient/banner.dart';

class PatientBannerBar extends StatelessWidget {
  const PatientBannerBar({super.key, required this.banner});

  final PatientBanner banner;

  @override
  Widget build(BuildContext context) {
    // One node carrying the whole sentence: read piece by piece, a name, an
    // age and three allergy chips arrive as five unrelated announcements, and
    // the reader has to assemble them. The visible layout stays as it is.
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: _spoken(),
      child: Container(
        key: const Key('patient-banner'),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF1F4F9),
          border: Border(bottom: BorderSide(color: Color(0xFFC9D2E0))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              banner.displayName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF16233B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${banner.age} · ${banner.sex}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF3B4A63)),
            ),
            const SizedBox(height: 8),
            _allergies(),
            if (banner.alerts.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final alert in banner.alerts)
                    _Chip(
                      key: Key('alert-${alert.kind}'),
                      text: alert.text,
                      background: const Color(0xFFFDF3E0),
                      foreground: const Color(0xFF6B4708),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _allergies() {
    if (banner.allergiesUnknown) {
      // Not an empty row. An empty allergy line reads as "no allergies", and
      // nobody having asked is a different and more dangerous thing.
      return const _Chip(
        key: Key('allergies-unknown'),
        text: 'Allergies not recorded — ask before giving anything',
        background: Color(0xFFFDF3E0),
        foreground: Color(0xFF6B4708),
      );
    }
    if (banner.allergies.isEmpty) {
      return const _Chip(
        key: Key('allergies-none'),
        text: 'No known allergies',
        background: Color(0xFFE7F5EC),
        foreground: Color(0xFF11593A),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final allergy in banner.allergies)
          _Chip(
            key: Key('allergy-${allergy.substance}'),
            text: allergy.label,
            background: const Color(0xFFFDECEB),
            foreground: const Color(0xFF7A1C17),
          ),
      ],
    );
  }

  String _spoken() {
    final parts = <String>[
      banner.displayName,
      banner.age,
      banner.sex,
      if (banner.allergiesUnknown)
        'Allergies not recorded. Ask before giving anything'
      else if (banner.allergies.isEmpty)
        'No known allergies'
      else
        'Allergies: ${banner.allergies.map((a) => a.label).join(', ')}',
      for (final alert in banner.alerts) alert.text,
    ];
    return parts.join('. ');
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}
