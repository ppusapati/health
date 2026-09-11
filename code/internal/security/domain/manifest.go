package domain

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// Export manifests and completeness (SRS-NFR-012).
//
// The requirement asks that a large authorized export run as an asynchronous
// job and "produce manifest/checksums", verified by "export completeness can
// be verified". Completeness is the hard word. A checksum over the produced
// file proves the bytes arrived intact; it says nothing about whether the file
// contains everything it should. An export that silently dropped a thousand
// rows because a query timed out mid-stream has a perfectly valid checksum.
//
// So a manifest records what the export *claimed* to cover — the scope, the
// row counts per resource, the watermark it ran to — alongside the digest of
// what it produced. A recipient can then check two different things: that the
// file is intact, and that it is whole.

// ManifestEntry is one resource type included in an export.
type ManifestEntry struct {
	// ResourceType is what was exported: "patient", "encounter".
	ResourceType string `json:"resource_type"`
	// RowCount is how many records of this type the export contains.
	RowCount int64 `json:"row_count"`
	// SHA256 is the digest of this resource's portion, so a partial
	// verification is possible without re-reading the whole export.
	SHA256 string `json:"sha256"`
	// SourceMaxVersion is the highest record version included. With the
	// watermark it is what makes an incremental export verifiable: a later
	// export starting below this number would re-send, and one starting above
	// it would skip.
	SourceMaxVersion int64 `json:"source_max_version"`
}

// Manifest describes an export completely enough to verify it.
type Manifest struct {
	ExportID string `json:"export_id"`
	TenantID string `json:"tenant_id"`
	// Scope is the request that produced this export, echoed back. A recipient
	// checking completeness needs to know what was asked for, not only what
	// arrived.
	Scope json.RawMessage `json:"scope"`
	// Watermark is the instant the export is consistent as of. Records changed
	// after it are not included, by design — an export with no watermark is an
	// export nobody can say anything about.
	Watermark time.Time       `json:"watermark"`
	Entries   []ManifestEntry `json:"entries"`
	// TotalRows across every entry, so the common check is one comparison.
	TotalRows int64 `json:"total_rows"`
	// ObjectSHA256 is the digest of the produced file.
	ObjectSHA256 string    `json:"object_sha256"`
	SizeBytes    int64     `json:"size_bytes"`
	GeneratedAt  time.Time `json:"generated_at"`
	// GeneratedBy names the export job, so a manifest can be traced to the run
	// that made it.
	GeneratedBy string `json:"generated_by"`
}

// Errors returned by manifest handling.
var (
	// ErrInvalidManifest reports a manifest that cannot verify anything.
	ErrInvalidManifest = errors.New("security: invalid export manifest")
	// ErrIncomplete reports an export whose manifest and content disagree.
	ErrIncomplete = errors.New("security: export is not complete")
)

// NewManifest builds and validates a manifest.
func NewManifest(exportID, tenantID, generatedBy string, scope json.RawMessage,
	watermark time.Time, entries []ManifestEntry, objectSHA256 string,
	sizeBytes int64, now time.Time) (Manifest, error) {

	switch {
	case strings.TrimSpace(exportID) == "":
		return Manifest{}, fmt.Errorf("%w: export id is required", ErrInvalidManifest)
	case strings.TrimSpace(tenantID) == "":
		return Manifest{}, fmt.Errorf("%w: tenant is required", ErrInvalidManifest)
	case strings.TrimSpace(generatedBy) == "":
		return Manifest{}, fmt.Errorf("%w: the producing job must be named", ErrInvalidManifest)
	case watermark.IsZero():
		// An export with no watermark is an export nobody can say anything
		// about: there is no way to tell whether a record is missing or was
		// simply written after the run.
		return Manifest{}, fmt.Errorf("%w: a watermark is required", ErrInvalidManifest)
	case len(entries) == 0:
		return Manifest{}, fmt.Errorf("%w: an export with no resources is not an export", ErrInvalidManifest)
	case len(objectSHA256) != 64:
		return Manifest{}, fmt.Errorf("%w: object digest must be 64 hex characters", ErrInvalidManifest)
	case sizeBytes <= 0:
		return Manifest{}, fmt.Errorf("%w: size must be positive", ErrInvalidManifest)
	}

	var total int64
	seen := map[string]bool{}
	ordered := make([]ManifestEntry, len(entries))
	copy(ordered, entries)

	for _, e := range ordered {
		switch {
		case strings.TrimSpace(e.ResourceType) == "":
			return Manifest{}, fmt.Errorf("%w: an entry has no resource type", ErrInvalidManifest)
		case seen[e.ResourceType]:
			// Two entries for one resource type make the row count ambiguous,
			// and a recipient summing them would get a different answer from
			// one that took the first.
			return Manifest{}, fmt.Errorf("%w: %s appears twice", ErrInvalidManifest, e.ResourceType)
		case e.RowCount < 0:
			return Manifest{}, fmt.Errorf("%w: %s has a negative row count", ErrInvalidManifest, e.ResourceType)
		case len(e.SHA256) != 64:
			return Manifest{}, fmt.Errorf("%w: %s has no valid digest", ErrInvalidManifest, e.ResourceType)
		}
		seen[e.ResourceType] = true
		total += e.RowCount
	}

	// Sorted, so two manifests for the same export are byte-identical and can
	// themselves be compared by digest.
	sort.Slice(ordered, func(i, j int) bool { return ordered[i].ResourceType < ordered[j].ResourceType })

	if len(scope) == 0 {
		scope = json.RawMessage(`{}`)
	}

	return Manifest{
		ExportID: exportID, TenantID: tenantID, Scope: scope,
		Watermark: watermark.UTC(), Entries: ordered, TotalRows: total,
		ObjectSHA256: objectSHA256, SizeBytes: sizeBytes,
		GeneratedAt: now.UTC(), GeneratedBy: generatedBy,
	}, nil
}

// VerifyIntegrity checks that content matches the manifest's digest and size.
//
// This is the easy half: it proves the bytes arrived as they left.
func (m Manifest) VerifyIntegrity(content []byte) error {
	digest := sha256.Sum256(content)
	got := hex.EncodeToString(digest[:])

	if got != m.ObjectSHA256 {
		return fmt.Errorf("%w: digest is %s, manifest records %s", ErrIncomplete, got, m.ObjectSHA256)
	}
	if int64(len(content)) != m.SizeBytes {
		return fmt.Errorf("%w: %d bytes, manifest records %d", ErrIncomplete, len(content), m.SizeBytes)
	}
	return nil
}

// CompletenessCheck is what a recipient learned about an export.
type CompletenessCheck struct {
	Complete bool
	// Missing lists resource types whose observed count is below the manifest.
	Missing []Discrepancy
	// Unexpected lists resource types the content has and the manifest does
	// not. Rarer and more alarming: it means the export contains something
	// nobody described.
	Unexpected []string
	Reason     string
}

// Discrepancy is one resource type whose counts disagree.
type Discrepancy struct {
	ResourceType string
	Expected     int64
	Observed     int64
}

// Stable completeness reasons.
const (
	ReasonExportComplete       = "EXPORT_COMPLETE"
	ReasonExportShort          = "EXPORT_MISSING_ROWS"
	ReasonExportHasExtra       = "EXPORT_CONTAINS_UNDESCRIBED_RESOURCES"
	ReasonExportCountsDisagree = "EXPORT_COUNTS_DISAGREE"
)

// VerifyCompleteness compares what a recipient actually parsed against what
// the manifest claims.
//
// This is the half a checksum cannot do. An export that dropped a thousand
// rows because a query timed out mid-stream has a perfectly valid digest; only
// counting what arrived against what was promised finds it.
func (m Manifest) VerifyCompleteness(observed map[string]int64) CompletenessCheck {
	check := CompletenessCheck{Complete: true, Reason: ReasonExportComplete}

	described := map[string]bool{}
	for _, entry := range m.Entries {
		described[entry.ResourceType] = true
		got := observed[entry.ResourceType]
		if got != entry.RowCount {
			check.Complete = false
			check.Missing = append(check.Missing, Discrepancy{
				ResourceType: entry.ResourceType,
				Expected:     entry.RowCount,
				Observed:     got,
			})
		}
	}

	for resourceType := range observed {
		if !described[resourceType] {
			check.Complete = false
			check.Unexpected = append(check.Unexpected, resourceType)
		}
	}
	sort.Strings(check.Unexpected)
	sort.Slice(check.Missing, func(i, j int) bool {
		return check.Missing[i].ResourceType < check.Missing[j].ResourceType
	})

	switch {
	case check.Complete:
	case len(check.Unexpected) > 0:
		// Reported ahead of a short count: content nobody described is a
		// different and more serious problem than content that is short.
		check.Reason = ReasonExportHasExtra
	case allShort(check.Missing):
		check.Reason = ReasonExportShort
	default:
		check.Reason = ReasonExportCountsDisagree
	}
	return check
}

func allShort(discrepancies []Discrepancy) bool {
	for _, d := range discrepancies {
		if d.Observed > d.Expected {
			return false
		}
	}
	return len(discrepancies) > 0
}
