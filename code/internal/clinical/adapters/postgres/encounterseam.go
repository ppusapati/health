package postgres

import (
	"context"
	"time"

	clinicaldomain "github.com/ppusapati/health/code/internal/clinical/domain"
	clinicalports "github.com/ppusapati/health/code/internal/clinical/ports"
	encounterdomain "github.com/ppusapati/health/code/internal/encounter/domain"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// The seam the encounter context reaches the clinical record through.
//
// Lives here rather than in the encounter context because it is this context's
// data being exposed, and the narrowness of what it exposes is this context's
// decision to defend. SRS-ENC-008's closure gate needs to know whether a signed
// note exists; SRS-ENC-011's timeline needs what happened and when. Neither
// needs the clinical content, and handing it over would put the chart inside a
// container with weaker access rules than the chart has.

// ClinicalContent adapts the clinical record for the encounter context.
type ClinicalContent struct {
	documents clinicalports.DocumentRepository
	timeline  clinicalports.TimelineRepository
}

// NewClinicalContent constructs the adapter.
func NewClinicalContent(documents clinicalports.DocumentRepository,
	timeline clinicalports.TimelineRepository) ClinicalContent {

	return ClinicalContent{documents: documents, timeline: timeline}
}

var _ encounterports.ClinicalContent = ClinicalContent{}

// DocumentationFor reports which mandatory items an encounter has
// (SRS-ENC-008).
//
// Booleans rather than the records themselves. The encounter context is asking
// a gating question, not reading a chart, and returning the note would make
// every closure check a clinical read.
func (c ClinicalContent) DocumentationFor(ctx context.Context,
	scope authctx.TenantScope, encounterID string) (
	encounterdomain.DocumentationState, error) {

	signed, err := c.documents.HasSignedDocument(ctx, scope, encounterID)
	if err != nil {
		return encounterdomain.DocumentationState{}, err
	}

	// Discharge disposition is SRS-NUR's, and arrives with Sprint 4C. Reported
	// as absent until then, which correctly blocks an inpatient closure that
	// requires it rather than silently passing one: a deployment that cannot
	// record a discharge destination should not be able to satisfy a rule about
	// discharge destinations.
	return encounterdomain.DocumentationState{HasSignedNote: signed}, nil
}

// TimelineFor returns the clinical entries for a patient's timeline
// (SRS-ENC-011).
//
// Unfiltered by confidentiality: the encounter context applies the filter once,
// on the way out, so one rule governs every contributing source. The
// classification travels with each entry so it has something to apply.
func (c ClinicalContent) TimelineFor(ctx context.Context, scope authctx.TenantScope,
	patientID string, from, until time.Time, limit int32) (
	[]encounterdomain.Entry, error) {

	entries, err := c.timeline.Entries(ctx, scope, patientID, from, until, limit)
	if err != nil {
		return nil, err
	}

	out := make([]encounterdomain.Entry, 0, len(entries))
	for _, e := range entries {
		out = append(out, encounterdomain.Entry{
			ID: e.ID, Kind: timelineKind(e.Kind), At: e.At,
			EncounterID: e.EncounterID, Title: e.Title,
			Confidentiality: timelineConfidentiality(e.Confidentiality),
			AuthorID:        e.AuthorID,
		})
	}
	return out, nil
}

// timelineKind maps this context's entry kinds onto the encounter context's.
//
// An explicit map rather than a cast, because the two enumerations are owned by
// different contexts: a kind added here must be deliberately exposed there
// rather than appearing by coincidence of spelling.
func timelineKind(kind string) encounterdomain.EntryKind {
	switch kind {
	case "note":
		return encounterdomain.EntryNote
	case "observation":
		return encounterdomain.EntryObservation
	case "procedure":
		return encounterdomain.EntryProcedure
	case "allergy":
		return encounterdomain.EntryAllergy
	default:
		return encounterdomain.EntryDocument
	}
}

// timelineConfidentiality maps the classification across the seam.
//
// An unrecognised class becomes very-restricted rather than normal: the two
// contexts version independently, and the safe answer to "this version does not
// know what that means" is to withhold it.
func timelineConfidentiality(c clinicaldomain.Confidentiality) encounterdomain.Confidentiality {
	switch c {
	case clinicaldomain.ConfidentialityNormal:
		return encounterdomain.ConfidentialityNormal
	case clinicaldomain.ConfidentialityRestricted:
		return encounterdomain.ConfidentialityRestricted
	case clinicaldomain.ConfidentialityVeryRestricted:
		return encounterdomain.ConfidentialityVeryRestricted
	default:
		return encounterdomain.ConfidentialityVeryRestricted
	}
}
