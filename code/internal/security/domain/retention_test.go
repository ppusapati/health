package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/security/domain"
)

func days(n int32) *int32 { return &n }

func TestRetentionClassValidation(t *testing.T) {
	cases := map[string]struct {
		name, dataClass string
		retain, archive *int32
	}{
		"no name":               {"", "PHI", days(30), nil},
		"no data class":         {"clinical", "", days(30), nil},
		"zero retention":        {"clinical", "PHI", days(0), nil},
		"archive after retain":  {"clinical", "PHI", days(30), days(30)},
		"archive beyond retain": {"clinical", "PHI", days(30), days(60)},
	}
	for name, c := range cases {
		t.Run(name, func(t *testing.T) {
			_, err := domain.NewRetentionClass("rc-1", "tenant-a", c.name, c.dataClass, c.retain, c.archive, at)
			if !errors.Is(err, domain.ErrInvalidRetention) {
				t.Fatalf("invalid class accepted: %v", err)
			}
		})
	}

	if _, err := domain.NewRetentionClass("rc-1", "tenant-a", "clinical", "PHI", days(3650), days(365), at); err != nil {
		t.Fatalf("valid class rejected: %v", err)
	}
}

// The central SRS-DAT-009 guarantee: a deletion job must skip held records,
// whatever the retention period says.
func TestLegalHoldBeatsAnExpiredRetentionPeriod(t *testing.T) {
	class, err := domain.NewRetentionClass("rc-1", "tenant-a", "clinical", "PHI", days(30), nil, at)
	if err != nil {
		t.Fatalf("NewRetentionClass: %v", err)
	}

	createdAt := at.AddDate(0, 0, -100) // long past retention

	withoutHold := domain.EvaluateDeletion(class, createdAt, at, false)
	if !withoutHold.MayDelete || withoutHold.Reason != domain.ReasonDeletable {
		t.Fatalf("expired record not deletable: %+v", withoutHold)
	}

	withHold := domain.EvaluateDeletion(class, createdAt, at, true)
	if withHold.MayDelete {
		t.Fatal("a record under legal hold was marked deletable")
	}
	if withHold.Reason != domain.ReasonLegalHeld {
		t.Fatalf("Reason = %q", withHold.Reason)
	}
}

func TestRecordWithinRetentionIsNotDeletable(t *testing.T) {
	class, _ := domain.NewRetentionClass("rc-1", "tenant-a", "clinical", "PHI", days(30), nil, at)

	decision := domain.EvaluateDeletion(class, at.AddDate(0, 0, -10), at, false)
	if decision.MayDelete || decision.Reason != domain.ReasonRetained {
		t.Fatalf("decision = %+v", decision)
	}
}

// An unset retention period means "keep", not "delete immediately".
func TestIndefiniteRetentionNeverDeletes(t *testing.T) {
	class, _ := domain.NewRetentionClass("rc-1", "tenant-a", "legal", "Restricted", nil, nil, at)

	decision := domain.EvaluateDeletion(class, at.AddDate(-50, 0, 0), at, false)
	if decision.MayDelete {
		t.Fatal("an indefinitely retained record was marked deletable")
	}
	if decision.Reason != domain.ReasonIndefinite {
		t.Fatalf("Reason = %q", decision.Reason)
	}
}

func TestRetentionBoundaryIsInclusive(t *testing.T) {
	class, _ := domain.NewRetentionClass("rc-1", "tenant-a", "clinical", "PHI", days(30), nil, at)
	createdAt := at.AddDate(0, 0, -30)

	if !class.DueForDeletion(createdAt, at) {
		t.Fatal("a record exactly at its retention boundary was not due")
	}
	if class.DueForDeletion(createdAt, at.Add(-time.Second)) {
		t.Fatal("a record one second short of its boundary was due")
	}
}

func TestArchiveThreshold(t *testing.T) {
	class, _ := domain.NewRetentionClass("rc-1", "tenant-a", "clinical", "PHI", days(3650), days(365), at)

	if class.DueForArchive(at.AddDate(0, 0, -100), at) {
		t.Fatal("archived too early")
	}
	if !class.DueForArchive(at.AddDate(0, 0, -400), at) {
		t.Fatal("not archived past the threshold")
	}
}

func TestLegalHoldRequiresAReason(t *testing.T) {
	if _, err := domain.NewLegalHold("h-1", "tenant-a", "facility", "f-1", "  ", "legal-1", at); !errors.Is(err, domain.ErrInvalidLegalHold) {
		t.Fatalf("a hold with no reason was accepted: %v", err)
	}
	if _, err := domain.NewLegalHold("h-1", "tenant-a", "facility", "f-1", "Litigation XYZ", "legal-1", at); err != nil {
		t.Fatalf("valid hold rejected: %v", err)
	}
}
