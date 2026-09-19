package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// DocumentKind is what sort of controlled document this is (SRS-QMS-006).
type DocumentKind string

const (
	DocumentPolicy    DocumentKind = "policy"
	DocumentSOP       DocumentKind = "sop"
	DocumentProtocol  DocumentKind = "protocol"
	DocumentGuideline DocumentKind = "guideline"
	DocumentForm      DocumentKind = "form"
	DocumentManual    DocumentKind = "manual"
)

var knownDocumentKind = map[DocumentKind]bool{
	DocumentPolicy: true, DocumentSOP: true, DocumentProtocol: true,
	DocumentGuideline: true, DocumentForm: true, DocumentManual: true,
}

// ControlledDocument is a policy, SOP or protocol under version control
// (SRS-QMS-006).
//
// The document is the identity; the versions carry the content. Separated
// because an accreditation clause cites "the hand hygiene policy" and an
// acknowledgement is always of one particular version of it.
type ControlledDocument struct {
	ID       string
	TenantID string

	Code  string
	Title string
	Kind  DocumentKind
	// OwnerID is who is answerable for keeping it current.
	OwnerID string
	// ReviewMonths is how often it must be reviewed whether or not anything
	// changed. Zero means nobody has decided, which the readiness report names
	// rather than treating as "never expires".
	ReviewMonths int

	Department string
	// Withdrawn retires the whole document. Its versions stay, because an
	// incident from last year was judged against a policy that no longer
	// exists and the record has to be able to show it.
	Withdrawn   bool
	WithdrawnAt time.Time

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewDocumentInput registers a controlled document.
type NewDocumentInput struct {
	Code         string
	Title        string
	Kind         DocumentKind
	OwnerID      string
	ReviewMonths int
	Department   string
}

// NewControlledDocument registers a document (SRS-QMS-006).
func NewControlledDocument(id, tenantID string, in NewDocumentInput, by string,
	now time.Time) (ControlledDocument, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ControlledDocument{}, fmt.Errorf("%w: a document needs an id",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Code) == "":
		return ControlledDocument{}, fmt.Errorf("%w: a document needs a code",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Title) == "":
		return ControlledDocument{}, fmt.Errorf("%w: a document needs a title",
			ErrInvalidQuality)
	case !knownDocumentKind[in.Kind]:
		return ControlledDocument{}, fmt.Errorf("%w: unknown document kind %q",
			ErrInvalidQuality, in.Kind)
	case strings.TrimSpace(in.OwnerID) == "":
		// A document nobody owns is a document nobody reviews.
		return ControlledDocument{}, fmt.Errorf("%w: a document names its owner",
			ErrInvalidQuality)
	case in.ReviewMonths < 0:
		return ControlledDocument{}, fmt.Errorf(
			"%w: a review interval cannot be negative", ErrInvalidQuality)
	}

	return ControlledDocument{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Title: strings.TrimSpace(in.Title),
		Kind: in.Kind, OwnerID: in.OwnerID, ReviewMonths: in.ReviewMonths,
		Department: strings.TrimSpace(in.Department),
		CreatedAt:  now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// VersionState is where one revision stands (SRS-QMS-006).
type VersionState string

const (
	// VersionDraft is being written. Never shown as the document.
	VersionDraft VersionState = "draft"
	// VersionApproved has been signed off and is waiting for its effective
	// date.
	VersionApproved VersionState = "approved"
	// VersionEffective is the one in force.
	VersionEffective VersionState = "effective"
	// VersionObsolete has been replaced. Retained: an incident is judged
	// against the version in force when it happened.
	VersionObsolete VersionState = "obsolete"
)

var knownVersionState = map[VersionState]bool{
	VersionDraft: true, VersionApproved: true,
	VersionEffective: true, VersionObsolete: true,
}

// DocumentVersion is one revision of a controlled document (SRS-QMS-006).
type DocumentVersion struct {
	ID         string
	TenantID   string
	DocumentID string

	// Label is what the hospital calls it — "3.1". Ordinal is what the system
	// orders by, because "10" sorts before "9" as a string and a document
	// control system that shows the wrong current version has failed at its
	// only job.
	Label   string
	Ordinal int

	// ContentRef points at the stored file. A reference rather than the
	// content, because a policy is a document and this context is not a
	// document store.
	ContentRef    string
	ChangeSummary string

	State VersionState

	ApprovedBy string
	ApprovedAt time.Time
	// EffectiveFrom is when it comes into force. Allowed to be in the future,
	// which is how a hospital publishes a policy change before the date it
	// starts applying.
	EffectiveFrom time.Time
	ObsoleteFrom  time.Time

	// RequiresAcknowledgement asks every relevant person to confirm they have
	// read this version. Per version rather than per document: acknowledging
	// version 1 says nothing about version 2, and a system that carries an old
	// acknowledgement forward is a system that reports full compliance with a
	// policy nobody has read.
	RequiresAcknowledgement bool
	// RequiresRetraining expires competencies awarded against earlier
	// versions. Not every revision does — a typo correction should not
	// invalidate a ward's training records — so it is a decision the approver
	// makes rather than a consequence of revising.
	RequiresRetraining bool

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewVersionInput drafts a revision.
type NewVersionInput struct {
	DocumentID              string
	Label                   string
	Ordinal                 int
	ContentRef              string
	ChangeSummary           string
	RequiresAcknowledgement bool
	RequiresRetraining      bool
}

// DraftVersion starts a revision (SRS-QMS-006).
func DraftVersion(id, tenantID string, in NewVersionInput, by string,
	now time.Time) (DocumentVersion, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return DocumentVersion{}, fmt.Errorf("%w: a version needs an id",
			ErrInvalidQuality)
	case strings.TrimSpace(in.DocumentID) == "":
		return DocumentVersion{}, fmt.Errorf("%w: a version names its document",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Label) == "":
		return DocumentVersion{}, fmt.Errorf("%w: a version needs a label",
			ErrInvalidQuality)
	case in.Ordinal <= 0:
		return DocumentVersion{}, fmt.Errorf(
			"%w: a version needs a positive ordinal", ErrInvalidQuality)
	}

	return DocumentVersion{
		ID: id, TenantID: tenantID, DocumentID: in.DocumentID,
		Label: strings.TrimSpace(in.Label), Ordinal: in.Ordinal,
		ContentRef:              strings.TrimSpace(in.ContentRef),
		ChangeSummary:           strings.TrimSpace(in.ChangeSummary),
		State:                   VersionDraft,
		RequiresAcknowledgement: in.RequiresAcknowledgement,
		RequiresRetraining:      in.RequiresRetraining,
		CreatedAt:               now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// ApproveVersion signs a revision off (SRS-QMS-006).
//
// Refused for the person who wrote it, and refused without content: a policy
// approved with nothing attached is an approval of nothing, and it will be
// cited in an accreditation survey as though it were a document.
func (v *DocumentVersion) ApproveVersion(by string, effectiveFrom time.Time,
	now time.Time) error {

	switch {
	case v.State != VersionDraft:
		return fmt.Errorf("%w: this version is %s", ErrInvalidQuality, v.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidQuality)
	case by == v.CreatedBy:
		return fmt.Errorf("%w: the author of a version cannot approve it",
			ErrInvalidQuality)
	case v.ContentRef == "":
		return fmt.Errorf("%w: this version has no content to approve",
			ErrInvalidQuality)
	case effectiveFrom.IsZero():
		return fmt.Errorf("%w: an approved version names its effective date",
			ErrInvalidQuality)
	}

	v.State = VersionApproved
	v.ApprovedBy, v.ApprovedAt = by, now.UTC()
	v.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// InForce reports whether this version is the one that applies at a moment.
//
// Computed from the dates rather than read from the state column, so a version
// whose effective date has passed is in force whether or not a job has run.
func (v DocumentVersion) InForce(at time.Time) bool {
	if v.State == VersionDraft {
		return false
	}
	if v.EffectiveFrom.IsZero() || v.EffectiveFrom.After(at) {
		return false
	}
	return v.ObsoleteFrom.IsZero() || v.ObsoleteFrom.After(at)
}

// CurrentVersion is the revision in force at a moment (SRS-QMS-006).
//
// The acceptance is "only effective version is shown by default; history
// retained", and this is the half that decides which one that is: the highest
// ordinal whose effective date has passed and which has not been superseded.
// Returns false rather than the newest draft when nothing is in force — a
// document with no effective version is a gap somebody has to see, not a
// reason to show them an unapproved draft.
func CurrentVersion(versions []DocumentVersion, at time.Time) (
	DocumentVersion, bool) {

	var best DocumentVersion
	found := false
	for _, version := range versions {
		if !version.InForce(at) {
			continue
		}
		if !found || version.Ordinal > best.Ordinal ||
			(version.Ordinal == best.Ordinal &&
				version.EffectiveFrom.After(best.EffectiveFrom)) {
			best, found = version, true
		}
	}
	return best, found
}

// Acknowledgement is one person confirming they have read one version
// (SRS-QMS-006).
type Acknowledgement struct {
	ID         string
	TenantID   string
	VersionID  string
	DocumentID string
	PersonID   string
	// Role is who they were acting as. Carried because the same person may
	// need to acknowledge a policy once per role they hold, and because a
	// compliance report is read by role.
	Role           string
	AcknowledgedAt time.Time
}

// AcknowledgementGap is somebody who has not read a version they must.
type AcknowledgementGap struct {
	DocumentID string
	VersionID  string
	Code       string
	PersonID   string
	Role       string
}

// OutstandingAcknowledgements lists who has not confirmed what (SRS-QMS-006).
//
// Derived on read from the current version, so a person who acknowledged
// version 2 appears again the moment version 3 comes into force. That is the
// behaviour the requirement is for: re-issuing a policy is how a hospital
// tells people it changed.
func OutstandingAcknowledgements(document ControlledDocument,
	versions []DocumentVersion, expected map[string]string,
	acknowledged []Acknowledgement, at time.Time) []AcknowledgementGap {

	current, found := CurrentVersion(versions, at)
	if !found || !current.RequiresAcknowledgement || document.Withdrawn {
		return nil
	}

	done := map[string]bool{}
	for _, ack := range acknowledged {
		if ack.VersionID == current.ID {
			done[ack.PersonID] = true
		}
	}

	var out []AcknowledgementGap
	for person, role := range expected {
		if done[person] {
			continue
		}
		out = append(out, AcknowledgementGap{
			DocumentID: document.ID, VersionID: current.ID,
			Code: document.Code, PersonID: person, Role: role,
		})
	}
	sort.Slice(out, func(a, b int) bool {
		return out[a].PersonID < out[b].PersonID
	})
	return out
}

// ReviewDue reports documents past their own review interval (SRS-QMS-006).
//
// A policy that is in force and has not been looked at for four years is a
// policy nobody has confirmed still describes what the hospital does. Derived
// from the current version's effective date rather than from the document's
// creation, because reviewing is what produces a version.
type ReviewDue struct {
	DocumentID string
	Code       string
	Title      string
	OwnerID    string
	// LastEffective is when the version in force came into force. Zero where
	// no version is in force at all, which is the worse case and is reported
	// with NoEffectiveVersion rather than as an overdue review.
	LastEffective time.Time
	DueOn         time.Time
	DaysOverdue   int
	// NoEffectiveVersion marks a controlled document with nothing in force:
	// approved drafts, obsolete versions, or nothing at all.
	NoEffectiveVersion bool
	// NoReviewInterval marks a document nobody has decided a review period
	// for. Named rather than treated as "never due", because that is the
	// answer that makes the report look clean.
	NoReviewInterval bool
}

// ReviewsDue derives the review backlog (SRS-QMS-006).
func ReviewsDue(document ControlledDocument, versions []DocumentVersion,
	at time.Time) (ReviewDue, bool) {

	if document.Withdrawn {
		return ReviewDue{}, false
	}
	out := ReviewDue{
		DocumentID: document.ID, Code: document.Code,
		Title: document.Title, OwnerID: document.OwnerID,
	}

	current, found := CurrentVersion(versions, at)
	if !found {
		out.NoEffectiveVersion = true
		return out, true
	}
	out.LastEffective = current.EffectiveFrom

	if document.ReviewMonths == 0 {
		out.NoReviewInterval = true
		return out, true
	}
	out.DueOn = current.EffectiveFrom.AddDate(0, document.ReviewMonths, 0)
	if at.After(out.DueOn) {
		out.DaysOverdue = daysBetween(out.DueOn, at)
		return out, true
	}
	return ReviewDue{}, false
}

// Competency is a skill somebody must be able to evidence (SRS-QMS-013).
type Competency struct {
	ID       string
	TenantID string

	Code string
	Name string
	// DocumentID ties the competency to the controlled document that defines
	// it. The requirement's words are "linked to controlled documents and
	// roles", and the link is what makes a policy revision able to expire
	// training against it.
	DocumentID string
	// ValidMonths is how long an award lasts. Zero means it does not expire,
	// which is a decision rather than an omission and is reported as such.
	ValidMonths int

	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// Award is one person holding one competency (SRS-QMS-013).
type Award struct {
	ID           string
	TenantID     string
	CompetencyID string
	PersonID     string

	// VersionID is the document version they were trained against. Carried so
	// that a revision marked as requiring retraining can expire exactly the
	// awards made against earlier text, and no others.
	VersionID string
	// Evidence is the certificate, assessment or sign-off.
	Evidence   string
	AwardedAt  time.Time
	AwardedBy  string
	ExpiresAt  time.Time
	RevokedAt  time.Time
	RevokedWhy string
}

// Valid reports an award that still counts at a moment.
func (a Award) Valid(at time.Time) bool {
	if !a.RevokedAt.IsZero() && !a.RevokedAt.After(at) {
		return false
	}
	return a.ExpiresAt.IsZero() || a.ExpiresAt.After(at)
}

// CompetencyGap is somebody missing something their role requires.
type CompetencyGap struct {
	PersonID     string
	Role         string
	CompetencyID string
	Code         string
	// Reason distinguishes never-held from lapsed from superseded, because
	// they need three different actions: train them, re-assess them, or brief
	// them on what changed.
	Reason string
}

// The reasons a competency is missing.
const (
	GapNeverHeld  = "never_held"
	GapExpired    = "expired"
	GapSuperseded = "trained_on_an_earlier_version"
	GapRevoked    = "revoked"
)

// CompetencyGaps lists who is missing what (SRS-QMS-013).
//
// required maps a role to the competency ids it needs; people maps a person to
// their role. Derived on read, because "expired" is a fact about today and a
// stored flag is wrong from the moment it is written.
//
// currentVersion, where given, names the document version now in force for
// each competency. A person trained against an earlier version of a document
// whose new version required retraining is a gap, and is reported as a
// different one from somebody who was never trained at all.
func CompetencyGaps(required map[string][]string, people map[string]string,
	awards []Award, competencies map[string]Competency,
	retrainedFrom map[string]string, at time.Time) []CompetencyGap {

	held := map[string]map[string]Award{}
	for _, award := range awards {
		if _, seen := held[award.PersonID]; !seen {
			held[award.PersonID] = map[string]Award{}
		}
		// The most recent award wins, so re-certifying replaces a lapsed one.
		existing, seen := held[award.PersonID][award.CompetencyID]
		if !seen || award.AwardedAt.After(existing.AwardedAt) {
			held[award.PersonID][award.CompetencyID] = award
		}
	}

	var out []CompetencyGap
	for person, role := range people {
		for _, competencyID := range required[role] {
			competency := competencies[competencyID]
			gap := CompetencyGap{
				PersonID: person, Role: role,
				CompetencyID: competencyID, Code: competency.Code,
			}

			award, has := held[person][competencyID]
			switch {
			case !has:
				gap.Reason = GapNeverHeld
			case !award.RevokedAt.IsZero() && !award.RevokedAt.After(at):
				gap.Reason = GapRevoked
			case !award.Valid(at):
				gap.Reason = GapExpired
			case retrainedFrom[competencyID] != "" &&
				award.VersionID != retrainedFrom[competencyID]:
				gap.Reason = GapSuperseded
			default:
				continue
			}
			out = append(out, gap)
		}
	}

	sort.Slice(out, func(a, b int) bool {
		if out[a].PersonID != out[b].PersonID {
			return out[a].PersonID < out[b].PersonID
		}
		return out[a].Code < out[b].Code
	})
	return out
}
