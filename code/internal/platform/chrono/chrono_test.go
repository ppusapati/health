package chrono_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/chrono"
)

func mustLoad(t *testing.T, zone string) *time.Location {
	t.Helper()
	loc, err := chrono.Load(zone)
	if err != nil {
		t.Skipf("zone %s unavailable in this environment: %v", zone, err)
	}
	return loc
}

// The requirement's verification clause, directly: a historical timestamp
// renders the same every time, on any machine, whatever tzdata says today.
func TestRenderingIsDeterministic(t *testing.T) {
	kolkata := mustLoad(t, "Asia/Kolkata")
	// 2026-09-11 20:00 UTC is 2026-09-12 01:30 IST.
	instant := time.Date(2026, 9, 11, 20, 0, 0, 0, time.UTC)

	observed, err := chrono.Observe(instant, kolkata)
	if err != nil {
		t.Fatalf("Observe: %v", err)
	}
	if got, want := observed.String(), "2026-09-12T01:30:00+05:30"; got != want {
		t.Fatalf("rendered %s, want %s", got, want)
	}

	// Rebuilt from what the database would hold, with no access to tzdata.
	restored, err := chrono.Restore(observed.Instant, observed.Zone, observed.OffsetSeconds)
	if err != nil {
		t.Fatalf("Restore: %v", err)
	}
	if restored.String() != observed.String() {
		t.Fatalf("round trip changed the rendering: %s vs %s", restored, observed)
	}
}

// The case the stored offset exists for. During a daylight-saving fallback the
// same wall time occurs twice; the instants differ, and storing only the zone
// name would make them indistinguishable on the ward's clock.
func TestFallbackHourRendersBothOccurrencesDistinctly(t *testing.T) {
	london := mustLoad(t, "Europe/London")

	// 2026-10-25: clocks go back at 02:00 BST. 00:30 and 01:30 UTC are both
	// 01:30 local — the first in BST (+01:00), the second in GMT (+00:00).
	first := time.Date(2026, 10, 25, 0, 30, 0, 0, time.UTC)
	second := time.Date(2026, 10, 25, 1, 30, 0, 0, time.UTC)

	a, err := chrono.Observe(first, london)
	if err != nil {
		t.Fatalf("Observe: %v", err)
	}
	b, err := chrono.Observe(second, london)
	if err != nil {
		t.Fatalf("Observe: %v", err)
	}

	if a.Local().Hour() != 1 || a.Local().Minute() != 30 {
		t.Fatalf("first occurrence rendered %s, expected 01:30 local", a)
	}
	if b.Local().Hour() != 1 || b.Local().Minute() != 30 {
		t.Fatalf("second occurrence rendered %s, expected 01:30 local", b)
	}
	// Same wall time, different offsets — which is exactly the information a
	// zone name alone would have lost.
	if a.OffsetSeconds == b.OffsetSeconds {
		t.Fatal("both occurrences recorded the same offset; the fallback hour is indistinguishable")
	}
	if a.String() == b.String() {
		t.Fatalf("two different instants render identically: %s", a)
	}

	ambiguous, err := a.Ambiguous()
	if err != nil {
		t.Fatalf("Ambiguous: %v", err)
	}
	if !ambiguous {
		t.Error("the first occurrence of a repeated wall time was not flagged ambiguous")
	}
}

// Storing the offset means a tzdata update cannot move a historical record.
// Simulated by restoring with an offset today's rules would not produce.
func TestStoredOffsetSurvivesAZoneRuleChange(t *testing.T) {
	instant := time.Date(2019, 3, 15, 6, 0, 0, 0, time.UTC)

	// Suppose the zone observed +03:00 then and does not now. The stored value
	// still renders as it was experienced.
	stored, err := chrono.Restore(instant, "Europe/Moscow", 3*3600)
	if err != nil {
		t.Fatalf("Restore: %v", err)
	}
	if got, want := stored.String(), "2019-03-15T09:00:00+03:00"; got != want {
		t.Fatalf("rendered %s, want %s", got, want)
	}

	// And a row whose stored offset disagrees with today's rules is findable,
	// rather than silently rendering differently from what was recorded.
	drifted, err := chrono.Restore(instant, "Europe/Moscow", 7*3600)
	if err != nil {
		t.Fatalf("Restore: %v", err)
	}
	drifts, err := drifted.DriftsFromZoneRules()
	if err != nil {
		t.Fatalf("DriftsFromZoneRules: %v", err)
	}
	if !drifts {
		t.Fatal("an offset today's rules would never produce was not detected")
	}
}

// time.Local is where the process happens to run. That is a deployment detail,
// not clinical information, and it changes when the deployment moves.
func TestServerLocalZoneIsRefused(t *testing.T) {
	_, err := chrono.Observe(time.Now(), time.Local)
	if !errors.Is(err, chrono.ErrInvalidInstant) {
		t.Fatalf("want ErrInvalidInstant for time.Local, got %v", err)
	}
	if _, err := chrono.Load("Local"); !errors.Is(err, chrono.ErrInvalidInstant) {
		t.Fatalf("want ErrInvalidInstant for the %q zone, got %v", "Local", err)
	}
}

func TestZeroAndMissingValuesAreRefused(t *testing.T) {
	utc := mustLoad(t, "UTC")
	if _, err := chrono.Observe(time.Time{}, utc); !errors.Is(err, chrono.ErrInvalidInstant) {
		t.Errorf("zero instant: want ErrInvalidInstant, got %v", err)
	}
	if _, err := chrono.Observe(time.Now(), nil); !errors.Is(err, chrono.ErrInvalidInstant) {
		t.Errorf("nil location: want ErrInvalidInstant, got %v", err)
	}
	if _, err := chrono.Restore(time.Now(), "", 0); !errors.Is(err, chrono.ErrInvalidInstant) {
		t.Errorf("empty zone: want ErrInvalidInstant, got %v", err)
	}
	if _, err := chrono.Load("Mars/Olympus_Mons"); !errors.Is(err, chrono.ErrInvalidInstant) {
		t.Errorf("unknown zone: want ErrInvalidInstant, got %v", err)
	}
}

// A patient transferred between sites has doses recorded under two clocks.
// Each renders under its own, which is the point of storing the observing
// zone rather than one per tenant.
func TestTwoSitesRenderUnderTheirOwnClocks(t *testing.T) {
	kolkata := mustLoad(t, "Asia/Kolkata")
	london := mustLoad(t, "Europe/London")
	instant := time.Date(2026, 1, 15, 12, 0, 0, 0, time.UTC)

	here, err := chrono.Observe(instant, kolkata)
	if err != nil {
		t.Fatalf("Observe: %v", err)
	}
	there, err := chrono.Observe(instant, london)
	if err != nil {
		t.Fatalf("Observe: %v", err)
	}

	if !here.Instant.Equal(there.Instant) {
		t.Fatal("the same moment produced different instants")
	}
	if here.String() == there.String() {
		t.Fatalf("two sites rendered the same wall time: %s", here)
	}
	if here.Local().Hour() != 17 || there.Local().Hour() != 12 {
		t.Fatalf("wrong local hours: %s / %s", here, there)
	}
}
