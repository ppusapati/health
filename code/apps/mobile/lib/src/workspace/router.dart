/// Which screen a route names, and whether it may be reached from here.
///
/// Small on purpose. A full routing package buys deep links and a browser
/// history, and a ward tablet has neither: the destinations are a short list
/// chosen from a drawer, and what actually matters is the part a router usually
/// leaves to the application — **that leaving a screen can be refused.**
///
/// A half-entered set of observations is work the nurse has done. Navigating
/// away from it silently is the most ordinary way to lose clinical work, so the
/// decision runs through `drafts/guard.dart` and the caller has to act on the
/// answer rather than being able to ignore it.
library;

import 'package:meta/meta.dart';

import '../drafts/guard.dart';

/// The destinations this shell knows.
///
/// An enum rather than free strings, so a drawer entry pointing at a screen
/// that does not exist is a compile error instead of a blank page.
enum Destination {
  /// The signed-in landing screen: facilities, from Wave 0.
  facilities,

  /// Choosing a patient: the nurse's caseload, a wristband scan, a search.
  patients,

  /// The ward worklist (UX-W1-03).
  ward,

  /// The medication round (UX-W1-05).
  medicationRound,

  /// The reception desk: the queue board, and search before create (UX-W1-01).
  reception,

  /// The chart: allergies, problems, results and notes (UX-W1-02).
  chart,
}

/// The route string each destination answers to.
///
/// Kept as strings because that is what the workspace catalogue carries, and
/// the catalogue is data that a Wave-2 context will extend without touching
/// this file.
const Map<String, Destination> routes = {
  '/facilities': Destination.facilities,
  '/patients': Destination.patients,
  '/ward': Destination.ward,
  '/medications/round': Destination.medicationRound,
  '/reception': Destination.reception,
  '/chart': Destination.chart,
};

/// The destination a route names, or null when nothing does.
///
/// Null rather than a fallback to the home screen: silently landing somewhere
/// else hides a catalogue entry pointing at a screen nobody built, and the
/// person who would have noticed is the one who wrote the entry.
Destination? destinationFor(String route) => routes[route];

/// What the shell should do about a requested navigation.
@immutable
class NavigationDecision {
  const NavigationDecision({
    required this.destination,
    required this.guard,
  });

  /// Null when the route names nothing.
  final Destination? destination;

  /// The draft guard's answer. `allow` means go; `prompt` means ask first;
  /// `blocked` means refuse and say why.
  final GuardDecision guard;

  /// True when the shell may switch screens without asking anything.
  bool get immediate => destination != null && guard.allow;

  /// True when there is nowhere to go.
  bool get unknownRoute => destination == null;
}

/// Decides whether a route change may proceed.
///
/// The guard is consulted even when the destination is unknown, so a shell that
/// reports a bad route still knows there is unsaved work behind it.
NavigationDecision decideNavigation({
  required String route,
  required DraftRegistry drafts,
}) {
  return NavigationDecision(
    destination: destinationFor(route),
    guard: drafts.evaluateNavigation(RouteChange(route)),
  );
}
