package domain_test

import (
	"encoding/json"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/security/domain"
)

func newExport(t *testing.T) domain.ExportRequest {
	t.Helper()
	e, err := domain.NewExportRequest("exp-1", "tenant-a", "analyst-1",
		"Quarterly regulatory submission to the state health authority",
		"PHI", "stepup-ref-1", json.RawMessage(`{"from":"2026-01-01"}`), at)
	if err != nil {
		t.Fatalf("NewExportRequest: %v", err)
	}
	return e
}

func TestExportStartsPendingApproval(t *testing.T) {
	e := newExport(t)
	if e.Status != domain.ExportPendingApproval {
		t.Fatalf("Status = %q; a bulk PHI export must not start approved", e.Status)
	}
	// The watermark attributes a leaked file to whoever took it.
	if !strings.Contains(e.Watermark, "analyst-1") || !strings.Contains(e.Watermark, "tenant-a") {
		t.Fatalf("Watermark = %q", e.Watermark)
	}
}

// SRS-IAM-012: a bulk export is a high-risk action, so step-up must already
// have happened before the request is even recorded.
// SRS-SEC-008's verification clause: a bulk export is authorized, stepped up,
// justified, watermarked and downloadable only through a grant that expires.
// This is the step-up; the rest of the file is the others.
func TestExportRequiresStepUp(t *testing.T) {
	_, err := domain.NewExportRequest("exp-1", "tenant-a", "analyst-1",
		"Quarterly regulatory submission", "PHI", "", nil, at)
	if !errors.Is(err, domain.ErrInvalidExport) {
		t.Fatalf("an export without step-up was accepted: %v", err)
	}
}

// A one-word justification is not reviewable, and review is the point.
func TestExportRequiresMeaningfulJustification(t *testing.T) {
	for _, justification := range []string{"", "   ", "because", "adhoc"} {
		if _, err := domain.NewExportRequest("exp-1", "tenant-a", "analyst-1",
			justification, "PHI", "ref", nil, at); err == nil {
			t.Fatalf("justification %q was accepted", justification)
		}
	}
}

// Segregation of duties: without this the approval step is paperwork.
func TestRequesterCannotApproveTheirOwnExport(t *testing.T) {
	e := newExport(t)

	if err := e.Approve("analyst-1", at); !errors.Is(err, domain.ErrSelfApproval) {
		t.Fatalf("self-approval was accepted: %v", err)
	}
	if e.Status != domain.ExportPendingApproval {
		t.Fatalf("the failed approval changed status to %q", e.Status)
	}

	if err := e.Approve("privacy-officer-1", at); err != nil {
		t.Fatalf("second-party approval: %v", err)
	}
	if e.Status != domain.ExportApproved || e.ApprovedBy != "privacy-officer-1" {
		t.Fatalf("export = %+v", e)
	}
}

func TestRequesterCannotRejectTheirOwnExport(t *testing.T) {
	e := newExport(t)
	if err := e.Reject("analyst-1", at); !errors.Is(err, domain.ErrSelfApproval) {
		t.Fatalf("self-rejection accepted: %v", err)
	}
}

func TestApprovalIsOnlyValidFromPending(t *testing.T) {
	e := newExport(t)
	if err := e.Approve("officer-1", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	// A second approval must not overwrite the first approver.
	if err := e.Approve("officer-2", at); err == nil {
		t.Fatal("a second approval was accepted")
	}
	if e.ApprovedBy != "officer-1" {
		t.Fatalf("ApprovedBy = %q", e.ApprovedBy)
	}
}

// SRS-NFR-012: export completeness must be verifiable, which needs a digest.
func TestCompletionRequiresAChecksum(t *testing.T) {
	e := newExport(t)
	if err := e.Approve("officer-1", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}

	if err := e.Complete("s3://exports/exp-1", "", nil, 100, at, 0); err == nil {
		t.Fatal("completion without a checksum was accepted")
	}
	if err := e.Complete("s3://exports/exp-1", "tooshort", nil, 100, at, 0); err == nil {
		t.Fatal("completion with a malformed checksum was accepted")
	}

	digest := strings.Repeat("a", 64)
	if err := e.Complete("s3://exports/exp-1", digest,
		json.RawMessage(`{"tables":["facility"]}`), 100, at, 0); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if e.RowCount != 100 || e.ObjectSHA256 != digest {
		t.Fatalf("export = %+v", e)
	}
}

func TestCompletionRequiresApprovalFirst(t *testing.T) {
	e := newExport(t)
	if err := e.Complete("s3://x", strings.Repeat("a", 64), nil, 1, at, 0); err == nil {
		t.Fatal("an unapproved export was completed")
	}
}

// A permanent URL to a PHI export is a standing breach waiting for someone to
// find the link.
// SRS-SEC-008 again: the download grant expires, so an export that leaked a
// link does not stay fetchable for as long as the link survives.
func TestDownloadGrantExpires(t *testing.T) {
	e := newExport(t)
	if err := e.Approve("officer-1", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := e.Complete("s3://x", strings.Repeat("a", 64), nil, 1, at, time.Hour); err != nil {
		t.Fatalf("Complete: %v", err)
	}

	if err := e.AuthorizeDownload(at.Add(30 * time.Minute)); err != nil {
		t.Fatalf("download inside the window refused: %v", err)
	}
	if err := e.AuthorizeDownload(at.Add(2 * time.Hour)); !errors.Is(err, domain.ErrGrantExpired) {
		t.Fatalf("download after the window was allowed: %v", err)
	}
	// The boundary itself is closed, not open.
	if err := e.AuthorizeDownload(at.Add(time.Hour)); !errors.Is(err, domain.ErrGrantExpired) {
		t.Fatalf("download exactly at expiry was allowed: %v", err)
	}
}

func TestIncompleteExportCannotBeDownloaded(t *testing.T) {
	e := newExport(t)
	if err := e.AuthorizeDownload(at); err == nil {
		t.Fatal("a pending export was downloadable")
	}

	if err := e.Reject("officer-1", at); err != nil {
		t.Fatalf("Reject: %v", err)
	}
	if err := e.AuthorizeDownload(at); err == nil {
		t.Fatal("a rejected export was downloadable")
	}
}
