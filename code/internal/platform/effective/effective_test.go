package effective_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/effective"
)

// tariff is a stand-in for anything effective-dated: a price, a role
// assignment, a form version, a code mapping.
type tariff struct {
	version int64
	window  effective.Window
	price   int64
}

func (t tariff) EffectiveWindow() effective.Window { return t.window }
func (t tariff) VersionNumber() int64              { return t.version }

func day(y int, m time.Month, d int) time.Time {
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

func window(from, until time.Time) effective.Window {
	return effective.Window{From: from, Until: until}
}

// SRS-PLT-013's verification clause, directly: a historical transaction
// resolves the configuration that was active when it happened, not the one
// active now.
func TestHistoricalTransactionResolvesConfigurationAtEventTime(t *testing.T) {
	timeline, err := effective.NewTimeline("tariff/consultation", []tariff{
		{version: 1, window: window(day(2024, time.January, 1), day(2025, time.April, 1)), price: 500},
		{version: 2, window: window(day(2025, time.April, 1), day(2026, time.April, 1)), price: 650},
		{version: 3, window: window(day(2026, time.April, 1), time.Time{}), price: 800},
	})
	if err != nil {
		t.Fatalf("NewTimeline: %v", err)
	}

	cases := map[string]struct {
		eventTime time.Time
		want      int64
	}{
		"during the first version":  {day(2024, time.June, 15), 500},
		"during the second":         {day(2025, time.December, 1), 650},
		"today, open-ended version": {day(2026, time.September, 11), 800},
	}
	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			got, err := timeline.At(tc.eventTime)
			if err != nil {
				t.Fatalf("At: %v", err)
			}
			if got.price != tc.want {
				t.Fatalf("price %d, want %d — the wrong version was in force", got.price, tc.want)
			}
		})
	}
}

// The boundary case that produces double billing when intervals are closed.
// On the changeover day exactly one version applies.
func TestChangeoverDayBelongsToExactlyOneVersion(t *testing.T) {
	changeover := day(2025, time.April, 1)
	timeline, err := effective.NewTimeline("tariff/consultation", []tariff{
		{version: 1, window: window(day(2024, time.January, 1), changeover), price: 500},
		{version: 2, window: window(changeover, time.Time{}), price: 650},
	})
	if err != nil {
		t.Fatalf("NewTimeline: %v", err)
	}

	got, err := timeline.At(changeover)
	if err != nil {
		t.Fatalf("At: %v", err)
	}
	if got.price != 650 {
		t.Fatalf("the changeover instant resolved to %d; half-open windows mean "+
			"effective-from is inclusive and effective-until exclusive", got.price)
	}

	// A moment before belongs to the old version.
	before, err := timeline.At(changeover.Add(-time.Nanosecond))
	if err != nil {
		t.Fatalf("At: %v", err)
	}
	if before.price != 500 {
		t.Fatalf("the instant before changeover resolved to %d, want 500", before.price)
	}
}

// Overlap is a data-entry mistake — a window never closed before the next
// opened — and resolving it silently by version would apply the wrong price to
// everything in the overlap while looking like a working system.
func TestOverlappingVersionsAreRefusedAtConstruction(t *testing.T) {
	_, err := effective.NewTimeline("tariff/consultation", []tariff{
		{version: 1, window: window(day(2024, time.January, 1), day(2026, time.January, 1)), price: 500},
		{version: 2, window: window(day(2025, time.April, 1), time.Time{}), price: 650},
	})
	if !errors.Is(err, effective.ErrOverlap) {
		t.Fatalf("want ErrOverlap, got %v", err)
	}
}

func TestTwoOpenEndedVersionsOverlap(t *testing.T) {
	_, err := effective.NewTimeline("tariff/consultation", []tariff{
		{version: 1, window: window(day(2024, time.January, 1), time.Time{}), price: 500},
		{version: 2, window: window(day(2025, time.April, 1), time.Time{}), price: 650},
	})
	if !errors.Is(err, effective.ErrOverlap) {
		t.Fatalf("two open-ended versions must overlap; got %v", err)
	}
}

// A zero event time means the caller lost it upstream. Answering with today's
// configuration would hide that and quietly price a year-old encounter at
// today's rate.
func TestAZeroEventTimeIsRefusedRatherThanDefaulted(t *testing.T) {
	timeline, err := effective.NewTimeline("tariff/consultation", []tariff{
		{version: 1, window: window(day(2024, time.January, 1), time.Time{}), price: 500},
	})
	if err != nil {
		t.Fatalf("NewTimeline: %v", err)
	}
	if _, err := timeline.At(time.Time{}); !errors.Is(err, effective.ErrNoneInForce) {
		t.Fatalf("want ErrNoneInForce for a zero event time, got %v", err)
	}
}

// Before anything was configured is a different answer from "no such key", and
// a different conversation with the user.
func TestNothingInForceBeforeTheFirstVersion(t *testing.T) {
	timeline, err := effective.NewTimeline("tariff/consultation", []tariff{
		{version: 1, window: window(day(2025, time.April, 1), time.Time{}), price: 650},
	})
	if err != nil {
		t.Fatalf("NewTimeline: %v", err)
	}
	if _, err := timeline.At(day(2024, time.June, 1)); !errors.Is(err, effective.ErrNoneInForce) {
		t.Fatalf("want ErrNoneInForce, got %v", err)
	}
}

// A gap is not always wrong — a service withdrawn for six months has one — but
// it is always worth surfacing, because otherwise a transaction inside it
// fails at the point of care.
func TestGapsAreReportable(t *testing.T) {
	timeline, err := effective.NewTimeline("tariff/mri", []tariff{
		{version: 1, window: window(day(2024, time.January, 1), day(2024, time.July, 1)), price: 5000},
		{version: 2, window: window(day(2025, time.January, 1), time.Time{}), price: 5500},
	})
	if err != nil {
		t.Fatalf("NewTimeline: %v", err)
	}

	gaps := timeline.Gaps()
	if len(gaps) != 1 {
		t.Fatalf("want 1 gap, got %d", len(gaps))
	}
	if !gaps[0].From.Equal(day(2024, time.July, 1)) || !gaps[0].Until.Equal(day(2025, time.January, 1)) {
		t.Fatalf("gap is %v", gaps[0])
	}
	if _, err := timeline.At(day(2024, time.September, 1)); !errors.Is(err, effective.ErrNoneInForce) {
		t.Fatal("an instant inside the gap resolved to a version")
	}

	// A contiguous timeline reports no gap.
	contiguous, err := effective.NewTimeline("tariff/consultation", []tariff{
		{version: 1, window: window(day(2024, time.January, 1), day(2025, time.January, 1)), price: 500},
		{version: 2, window: window(day(2025, time.January, 1), time.Time{}), price: 650},
	})
	if err != nil {
		t.Fatalf("NewTimeline: %v", err)
	}
	if len(contiguous.Gaps()) != 0 {
		t.Fatalf("a contiguous timeline reported gaps: %v", contiguous.Gaps())
	}
}

func TestInvalidWindowsAreRefused(t *testing.T) {
	cases := map[string]effective.Window{
		"no effective-from": {Until: day(2025, time.January, 1)},
		"until before from": window(day(2025, time.January, 1), day(2024, time.January, 1)),
		"zero-length":       window(day(2025, time.January, 1), day(2025, time.January, 1)),
	}
	for name, w := range cases {
		t.Run(name, func(t *testing.T) {
			_, err := effective.NewTimeline("k", []tariff{{version: 1, window: w}})
			if !errors.Is(err, effective.ErrInvalidWindow) {
				t.Fatalf("want ErrInvalidWindow, got %v", err)
			}
		})
	}
}

// Input order must not change the answer. Versions arrive from a query whose
// ordering nobody guaranteed.
func TestResolutionIsIndependentOfInputOrder(t *testing.T) {
	versions := []tariff{
		{version: 3, window: window(day(2026, time.April, 1), time.Time{}), price: 800},
		{version: 1, window: window(day(2024, time.January, 1), day(2025, time.April, 1)), price: 500},
		{version: 2, window: window(day(2025, time.April, 1), day(2026, time.April, 1)), price: 650},
	}
	timeline, err := effective.NewTimeline("tariff/consultation", versions)
	if err != nil {
		t.Fatalf("NewTimeline: %v", err)
	}
	got, err := timeline.At(day(2025, time.December, 1))
	if err != nil {
		t.Fatalf("At: %v", err)
	}
	if got.price != 650 {
		t.Fatalf("price %d, want 650", got.price)
	}
	if all := timeline.All(); all[0].version != 1 || all[2].version != 3 {
		t.Fatalf("All did not return effective order: %v", all)
	}
}
