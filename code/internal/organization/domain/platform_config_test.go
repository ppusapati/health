package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
)

// --- Entitlements (SRS-PLT-011) ---

func entitlement(t *testing.T, id, facilityID string, enabled bool, from, until time.Time) domain.Entitlement {
	t.Helper()
	e, err := domain.NewEntitlement(id, "tenant-a", facilityID, "billing", enabled,
		from, until, "platform-ops", mdNow)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	return e
}

// Deny by default. The alternative — on unless switched off — ships every new
// module enabled for every tenant the day it merges.
func TestUnknownModuleIsDenied(t *testing.T) {
	decision := domain.ResolveEntitlement(nil, "fac-1", mdNow)
	if decision.Enabled {
		t.Fatal("a module with no entitlement row was enabled")
	}
	if decision.Reason != domain.ReasonNotEntitled {
		t.Fatalf("reason %q, want %q", decision.Reason, domain.ReasonNotEntitled)
	}
}

func TestTenantWideGrantAppliesToEveryFacility(t *testing.T) {
	rows := []domain.Entitlement{
		entitlement(t, "ent-tenant", "", true, mdDay(2026, time.January, 1), time.Time{}),
	}
	for _, facility := range []string{"fac-1", "fac-2", ""} {
		if d := domain.ResolveEntitlement(rows, facility, mdNow); !d.Enabled {
			t.Errorf("facility %q was denied a tenant-wide grant: %s", facility, d.Reason)
		}
	}
}

// A facility row is the more deliberate statement — somebody named that ward —
// so it decides for that facility even against a newer tenant-wide row.
func TestFacilityRowOverridesTenantRow(t *testing.T) {
	rows := []domain.Entitlement{
		// Tenant-wide grant, effective later than the facility's denial.
		entitlement(t, "ent-tenant", "", true, mdDay(2026, time.June, 1), time.Time{}),
		entitlement(t, "ent-fac", "fac-1", false, mdDay(2026, time.January, 1), time.Time{}),
	}

	denied := domain.ResolveEntitlement(rows, "fac-1", mdNow)
	if denied.Enabled {
		t.Fatal("the facility-level denial was overridden by a newer tenant-wide grant")
	}
	if denied.Reason != domain.ReasonModuleDisabled {
		t.Fatalf("reason %q, want %q", denied.Reason, domain.ReasonModuleDisabled)
	}
	if denied.Source != "ent-fac" {
		t.Fatalf("source %q; an administrator needs to know which row decided", denied.Source)
	}

	// Another ward still has it: the denial is scoped, not global.
	if d := domain.ResolveEntitlement(rows, "fac-2", mdNow); !d.Enabled {
		t.Fatalf("fac-2 was denied by fac-1's row: %s", d.Reason)
	}
}

// The single-ward pilot: enabled for one facility, off everywhere else.
func TestFacilityPilotDoesNotLeakToOtherWards(t *testing.T) {
	rows := []domain.Entitlement{
		entitlement(t, "ent-pilot", "fac-1", true, mdDay(2026, time.January, 1), time.Time{}),
	}
	if d := domain.ResolveEntitlement(rows, "fac-1", mdNow); !d.Enabled {
		t.Fatalf("the pilot ward was denied: %s", d.Reason)
	}
	if d := domain.ResolveEntitlement(rows, "fac-2", mdNow); d.Enabled {
		t.Fatal("a single-ward pilot leaked to another ward")
	}
}

// "Never granted" and "granted and lapsed" need different actions from an
// administrator; answering the same for both sends them to the wrong place.
func TestLapsedEntitlementIsDistinctFromNeverGranted(t *testing.T) {
	lapsed := []domain.Entitlement{
		entitlement(t, "ent-old", "", true, mdDay(2024, time.January, 1), mdDay(2025, time.January, 1)),
	}
	d := domain.ResolveEntitlement(lapsed, "fac-1", mdNow)
	if d.Enabled {
		t.Fatal("a lapsed entitlement was still enabled")
	}
	if d.Reason != domain.ReasonEntitlementLapsed {
		t.Fatalf("reason %q, want %q", d.Reason, domain.ReasonEntitlementLapsed)
	}
}

// A later grant replaces an earlier one within the same scope, without anybody
// having to close the old window by hand.
func TestMostRecentGrantWinsWithinAScope(t *testing.T) {
	rows := []domain.Entitlement{
		entitlement(t, "ent-1", "", false, mdDay(2026, time.January, 1), time.Time{}),
		entitlement(t, "ent-2", "", true, mdDay(2026, time.June, 1), time.Time{}),
	}
	d := domain.ResolveEntitlement(rows, "fac-1", mdNow)
	if !d.Enabled || d.Source != "ent-2" {
		t.Fatalf("the later grant did not win: enabled=%v source=%s", d.Enabled, d.Source)
	}
	// Before the later grant took effect, the earlier one still decides.
	before := domain.ResolveEntitlement(rows, "fac-1", mdDay(2026, time.March, 1))
	if before.Enabled || before.Source != "ent-1" {
		t.Fatalf("history resolved wrongly: enabled=%v source=%s", before.Enabled, before.Source)
	}
}

// --- Numbering (SRS-PLT-014) ---

func TestNumberFormatting(t *testing.T) {
	cases := []struct {
		prefix string
		pad    int32
		value  int64
		want   string
	}{
		{"MRN-", 6, 42, "MRN-000042"},
		{"", 0, 42, "42"},
		{"INV/2026/", 4, 7, "INV/2026/0007"},
		// Padding is a minimum, never a truncation: an overflowing counter must
		// keep issuing valid numbers rather than start colliding.
		{"MRN-", 3, 123456, "MRN-123456"},
	}
	for _, tc := range cases {
		if got := domain.Format(tc.prefix, tc.pad, tc.value); got != tc.want {
			t.Errorf("Format(%q,%d,%d) = %q, want %q", tc.prefix, tc.pad, tc.value, got, tc.want)
		}
	}
}

func TestSequenceValidation(t *testing.T) {
	cases := map[string]func() error{
		"zero start": func() error {
			_, err := domain.NewNumberSequence("s", "t", "", domain.ScopeMRN, "MRN-", 6, 0, "", mdNow)
			return err
		},
		"negative pad": func() error {
			_, err := domain.NewNumberSequence("s", "t", "", domain.ScopeMRN, "MRN-", -1, 1, "", mdNow)
			return err
		},
		"pad too wide": func() error {
			_, err := domain.NewNumberSequence("s", "t", "", domain.ScopeMRN, "MRN-", 99, 1, "", mdNow)
			return err
		},
		// A prefix with whitespace produces identifiers that do not survive
		// being read aloud, written down and typed back.
		"whitespace in prefix": func() error {
			_, err := domain.NewNumberSequence("s", "t", "", domain.ScopeMRN, "MRN 	", 6, 1, "", mdNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidSequence) {
				t.Fatalf("want ErrInvalidSequence, got %v", err)
			}
		})
	}
}

// The period key must be derived in the tenant's own timezone. A hospital in
// Kolkata issuing an invoice at 02:00 local on 1 April is in the new year;
// UTC would still say 31 March.
func TestPeriodKeyUsesTheTenantTimezone(t *testing.T) {
	kolkata, err := time.LoadLocation("Asia/Kolkata")
	if err != nil {
		t.Skipf("zone unavailable: %v", err)
	}
	// 2026-03-31 20:30 UTC is 2026-04-01 02:00 IST.
	instant := time.Date(2026, 3, 31, 20, 30, 0, 0, time.UTC)

	local, err := domain.PeriodKeyFor("monthly", instant, kolkata)
	if err != nil {
		t.Fatalf("PeriodKeyFor: %v", err)
	}
	if local != "2026-04" {
		t.Fatalf("period key %q; the tenant's calendar says April", local)
	}

	utc, err := domain.PeriodKeyFor("monthly", instant, time.UTC)
	if err != nil {
		t.Fatalf("PeriodKeyFor: %v", err)
	}
	if utc == local {
		t.Fatal("the timezone made no difference; the test proves nothing")
	}
}

func TestPeriodKeyPolicies(t *testing.T) {
	at := time.Date(2026, 9, 11, 12, 0, 0, 0, time.UTC)
	cases := map[string]string{
		"":        "",
		"never":   "",
		"yearly":  "2026",
		"monthly": "2026-09",
		"daily":   "2026-09-11",
	}
	for policy, want := range cases {
		got, err := domain.PeriodKeyFor(policy, at, time.UTC)
		if err != nil {
			t.Errorf("PeriodKeyFor(%q): %v", policy, err)
			continue
		}
		if got != want {
			t.Errorf("PeriodKeyFor(%q) = %q, want %q", policy, got, want)
		}
	}
	if _, err := domain.PeriodKeyFor("fortnightly", at, time.UTC); !errors.Is(err, domain.ErrInvalidSequence) {
		t.Error("an unknown reset policy was accepted")
	}
	if _, err := domain.PeriodKeyFor("yearly", at, nil); !errors.Is(err, domain.ErrInvalidSequence) {
		t.Error("a nil location was accepted; the period would depend on the server's zone")
	}
}

// --- Calendars (SRS-PLT-016) ---

func calendarEntry(t *testing.T, entryType domain.CalendarEntryType, from, to time.Time,
	label string, overridable bool) domain.CalendarEntry {
	t.Helper()
	e, err := domain.NewCalendarEntry("cal-"+label, "tenant-a", "fac-1", entryType,
		from, to, label, overridable, mdNow)
	if err != nil {
		t.Fatalf("NewCalendarEntry: %v", err)
	}
	return e
}

// SRS-PLT-016's verification clause: scheduling respects facility closure
// unless an override is authorised.
func TestSchedulingRespectsClosure(t *testing.T) {
	diwali := calendarEntry(t, domain.EntryHoliday,
		mdDay(2026, time.November, 8), mdDay(2026, time.November, 8), "Diwali", false)
	entries := []domain.CalendarEntry{diwali}

	closed := domain.AuthorizeScheduling(entries, mdDay(2026, time.November, 8), false)
	if closed.Permitted {
		t.Fatal("a booking was permitted on a holiday")
	}
	// The user is told why, not just no.
	if closed.Label != "Diwali" {
		t.Fatalf("label %q; the clerk needs to know which closure", closed.Label)
	}

	open := domain.AuthorizeScheduling(entries, mdDay(2026, time.November, 9), false)
	if !open.Permitted {
		t.Fatalf("an ordinary day was refused: %s", open.Reason)
	}
}

// Both conditions must hold: the entry must permit an override and the caller
// must be authorised. Neither is inferred from the other.
func TestOverrideNeedsBothPermissionAndAuthorization(t *testing.T) {
	overridable := []domain.CalendarEntry{
		calendarEntry(t, domain.EntryClosure,
			mdDay(2026, time.November, 8), mdDay(2026, time.November, 8), "Maintenance", true),
	}
	fixed := []domain.CalendarEntry{
		calendarEntry(t, domain.EntryHoliday,
			mdDay(2026, time.November, 8), mdDay(2026, time.November, 8), "Diwali", false),
	}
	date := mdDay(2026, time.November, 8)

	// Overridable entry, unauthorised caller: refused, but the UI can offer
	// the override to somebody who has it.
	d := domain.AuthorizeScheduling(overridable, date, false)
	if d.Permitted {
		t.Fatal("an unauthorised caller overrode a closure")
	}
	if !d.OverrideAvailable {
		t.Fatal("the caller was not told an override exists")
	}

	// Overridable entry, authorised caller: permitted, and recorded as an
	// override rather than as an ordinary booking.
	d = domain.AuthorizeScheduling(overridable, date, true)
	if !d.Permitted {
		t.Fatalf("an authorised override was refused: %s", d.Reason)
	}
	if d.Reason != domain.ReasonClosedOverridden {
		t.Fatalf("reason %q; an override must be distinguishable from a normal booking", d.Reason)
	}

	// Non-overridable entry, authorised caller: still refused. Authorisation
	// does not create a permission the calendar never granted.
	d = domain.AuthorizeScheduling(fixed, date, true)
	if d.Permitted {
		t.Fatal("an authorised caller overrode a closure that permits no override")
	}
	if d.OverrideAvailable {
		t.Fatal("an override was offered for a closure that permits none")
	}
}

// The case a special opening exists for: a facility declares itself shut for a
// holiday period and then opens for one clinic within it.
func TestSpecialOpeningBeatsAClosure(t *testing.T) {
	entries := []domain.CalendarEntry{
		calendarEntry(t, domain.EntryClosure,
			mdDay(2026, time.December, 24), mdDay(2026, time.December, 31), "Winter closure", false),
		calendarEntry(t, domain.EntrySpecialOpening,
			mdDay(2026, time.December, 29), mdDay(2026, time.December, 29), "Fracture clinic", false),
	}

	if d := domain.AuthorizeScheduling(entries, mdDay(2026, time.December, 29), false); !d.Permitted {
		t.Fatalf("the special opening did not beat the closure: %s", d.Reason)
	}
	if d := domain.AuthorizeScheduling(entries, mdDay(2026, time.December, 28), false); d.Permitted {
		t.Fatal("the closure was ignored on a day with no special opening")
	}
}

// Reduced hours are not a closure. Treating every calendar entry as a closure
// would shut a facility that merely opens late.
func TestReducedHoursDoesNotClose(t *testing.T) {
	entries := []domain.CalendarEntry{
		calendarEntry(t, domain.EntryReducedHours,
			mdDay(2026, time.December, 24), mdDay(2026, time.December, 24), "Christmas Eve", false),
	}
	if d := domain.AuthorizeScheduling(entries, mdDay(2026, time.December, 24), false); !d.Permitted {
		t.Fatalf("reduced hours were treated as a closure: %s", d.Reason)
	}
}

func TestCalendarEntryValidation(t *testing.T) {
	from, to := mdDay(2026, time.November, 8), mdDay(2026, time.November, 9)
	cases := map[string]func() error{
		"end before start": func() error {
			_, err := domain.NewCalendarEntry("c", "t", "f", domain.EntryHoliday, to, from, "Diwali", false, mdNow)
			return err
		},
		"unknown type": func() error {
			_, err := domain.NewCalendarEntry("c", "t", "f", domain.CalendarEntryType("strike"), from, to, "X", false, mdNow)
			return err
		},
		// "Closed" is not an answer at a reception desk; "Diwali" is.
		"no label": func() error {
			_, err := domain.NewCalendarEntry("c", "t", "f", domain.EntryHoliday, from, to, "", false, mdNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidCalendarEntry) {
				t.Fatalf("want ErrInvalidCalendarEntry, got %v", err)
			}
		})
	}
}

// --- Display labels (SRS-PLT-017) ---

func label(t *testing.T, locale, display, short string) domain.DisplayLabel {
	t.Helper()
	l, err := domain.NewDisplayLabel("lbl-"+locale, "tenant-a", "org_unit", "CARD",
		locale, display, short, mdNow)
	if err != nil {
		t.Fatalf("NewDisplayLabel: %v", err)
	}
	return l
}

// SRS-PLT-017's verification clause: the selected locale renders configured
// labels without altering canonical codes.
func TestRenderingNeverAltersTheCanonicalCode(t *testing.T) {
	labels := []domain.DisplayLabel{
		label(t, "en", "Cardiology", "Cardio"),
		label(t, "hi", "हृदय रोग विज्ञान", ""),
	}

	for _, locale := range []string{"en", "hi", "ta"} {
		r := domain.Render(labels, "CARD", locale)
		if r.Code != "CARD" {
			t.Fatalf("locale %s changed the canonical code to %q", locale, r.Code)
		}
	}

	hindi := domain.Render(labels, "CARD", "hi")
	if hindi.Display != "हृदय रोग विज्ञान" {
		t.Fatalf("Hindi rendered as %q", hindi.Display)
	}
	// ShortDisplay falls back to Display rather than to empty.
	if hindi.Short != hindi.Display {
		t.Fatalf("short form %q, want the full display", hindi.Short)
	}
}

// A tenant translating into Hindi should not also have to produce hi-IN.
func TestRegionalLocaleFallsBackToItsLanguage(t *testing.T) {
	labels := []domain.DisplayLabel{label(t, "en", "Cardiology", "Cardio")}

	r := domain.Render(labels, "CARD", "en-IN")
	if !r.Translated || r.Display != "Cardiology" {
		t.Fatalf("en-IN did not fall back to en: %+v", r)
	}
	if r.Locale != "en" {
		t.Fatalf("locale reported as %q; the caller should see which one was used", r.Locale)
	}

	// A regional label is preferred where it exists.
	withRegional := append(labels, label(t, "en-IN", "Cardiology (IN)", ""))
	r = domain.Render(withRegional, "CARD", "en-IN")
	if r.Display != "Cardiology (IN)" {
		t.Fatalf("the regional label was not preferred: %q", r.Display)
	}
}

// An untranslated code on screen is ugly and unambiguous. A blank label, or a
// silently substituted default locale, is a clinician reading the wrong thing
// without knowing it.
func TestUntranslatedCodeRendersAsItselfAndSaysSo(t *testing.T) {
	labels := []domain.DisplayLabel{label(t, "en", "Cardiology", "Cardio")}

	r := domain.Render(labels, "CARD", "ta")
	if r.Display != "CARD" {
		t.Fatalf("an untranslated code rendered as %q rather than as itself", r.Display)
	}
	if r.Translated {
		t.Fatal("an untranslated rendering claimed to be translated")
	}
	if r.Code != "CARD" {
		t.Fatalf("the code was altered to %q", r.Code)
	}
}

// Two rows for the same locale spelled differently would shadow each other
// depending on query order.
func TestLocaleCaseIsNormalised(t *testing.T) {
	if got := domain.NormalizeLocale("EN-in"); got != "en-IN" {
		t.Fatalf("NormalizeLocale(EN-in) = %q, want en-IN", got)
	}
	labels := []domain.DisplayLabel{label(t, "EN-in", "Cardiology (IN)", "")}
	if r := domain.Render(labels, "CARD", "en-IN"); !r.Translated {
		t.Fatal("a differently-cased locale did not match")
	}
}

func TestFallbackChain(t *testing.T) {
	cases := map[string][]string{
		"en-IN": {"en-IN", "en"},
		"en":    {"en"},
		"":      nil,
	}
	for locale, want := range cases {
		got := domain.FallbackChain(locale)
		if len(got) != len(want) {
			t.Errorf("FallbackChain(%q) = %v, want %v", locale, got, want)
			continue
		}
		for i := range want {
			if got[i] != want[i] {
				t.Errorf("FallbackChain(%q) = %v, want %v", locale, got, want)
				break
			}
		}
	}
}
