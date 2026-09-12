package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Proposed demographic changes (SRS-EMPI-012, SRS-EMPI-017).
//
// Two requirements meet in one model, because they are the same shape: a change
// somebody wants made to a patient's demographics, which is not made until
// somebody with the authority to make it agrees.
//
// SRS-EMPI-012 is the machine case. A national registry, an HIE feed or a payer
// file returns a birth date that differs from the one on file. Applying it is
// the obvious implementation and the wrong one: the feed may be describing a
// different person, or may be the one that is wrong, and by the time anybody
// notices the trusted value is gone and nothing records what it was. So the
// incoming value is held beside the current one until a human decides.
//
// SRS-EMPI-017 is the human case. A patient says their name is misspelled. The
// correction must be applied without erasing what the record said before,
// because a result filed last month was filed against the old value and an
// investigator needs to see why.
//
// What they share: the proposal is the record. It says what was on file, what
// was proposed, who proposed it, on what basis, who decided, and when. Deleting
// a rejected proposal would destroy the evidence that the wrong value was
// offered and refused — which is exactly what somebody asks about when the same
// wrong value arrives a third time.

// ProposalOrigin says where a proposed change came from.
//
// The distinction is not decoration: it decides who may raise one, what the
// reviewer is being asked, and whether a repeat is a duplicate or a second
// independent claim.
type ProposalOrigin string

const (
	// OriginExternalSource is a machine feed — a national registry, an HIE, a
	// payer file. Raised by the system when the incoming data disagrees.
	OriginExternalSource ProposalOrigin = "external_source"
	// OriginCorrectionRequest is a person asking for their record to be
	// corrected (SRS-EMPI-017).
	OriginCorrectionRequest ProposalOrigin = "correction_request"
)

var knownOrigins = map[ProposalOrigin]bool{
	OriginExternalSource: true, OriginCorrectionRequest: true,
}

// ProposalStatus is where a proposal sits.
type ProposalStatus string

const (
	// ProposalOpen is awaiting a decision.
	ProposalOpen ProposalStatus = "open"
	// ProposalAccepted had at least one field applied.
	ProposalAccepted ProposalStatus = "accepted"
	// ProposalRejected was refused in full. Kept: the fact that a value was
	// offered and refused is what makes a third arrival of the same value a
	// pattern rather than a surprise.
	ProposalRejected ProposalStatus = "rejected"
	// ProposalWithdrawn was taken back by whoever raised it.
	ProposalWithdrawn ProposalStatus = "withdrawn"
	// ProposalSuperseded was overtaken: the record changed underneath it, so
	// the comparison the reviewer would be shown no longer holds.
	ProposalSuperseded ProposalStatus = "superseded"
)

// FieldProposal is one field's proposed change.
//
// Per field rather than a whole demographics blob, because a registry that
// agrees on the name and disagrees on the birth date is offering one correction
// and one conflict, and a reviewer must be able to take the first without the
// second.
type FieldProposal struct {
	Field Field
	// CurrentValue is what was on file when the proposal was raised, stored
	// rather than looked up at review time. The reviewer has to see the
	// comparison the proposer saw; a value re-read later may have changed for
	// an unrelated reason and would make the proposal read as something else.
	CurrentValue string
	// ProposedValue is what the source or requester wants it to say.
	ProposedValue string
	// Accepted is nil while the proposal is open, then the reviewer's
	// per-field decision.
	Accepted *bool
}

// Proposal is a set of field changes awaiting a decision.
type Proposal struct {
	ID        string
	PatientID string
	Origin    ProposalOrigin
	// Source names the feed or the requester. SRS-EMPI-012 turns on knowing
	// which system claimed a conflicting value; without it, reconciling the
	// same disagreement twice teaches nothing.
	Source string
	// ProposedBy is the subject who submitted it — a service account for a
	// feed, a person for a correction request.
	ProposedBy string
	Reason     string
	Status     ProposalStatus
	Fields     []FieldProposal
	// PatientVersion is the record's version when the proposal was raised.
	// A decision taken against a stale comparison is refused rather than
	// applied (see Stale).
	PatientVersion int64
	ProposedAt     time.Time

	ResolvedAt     time.Time
	ResolvedBy     string
	ResolutionNote string
}

// MaxProposalFields bounds one proposal. Every demographic field plus room for
// a scheme that grows; a submission larger than this is a bad import.
const MaxProposalFields = 16

// NewProposal validates and constructs a proposal.
func NewProposal(id, patientID string, origin ProposalOrigin, source, proposedBy,
	reason string, fields []FieldProposal, patientVersion int64, now time.Time) (Proposal, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Proposal{}, fmt.Errorf("%w: proposal id is required", ErrInvalidPatient)
	case strings.TrimSpace(patientID) == "":
		return Proposal{}, fmt.Errorf("%w: a proposal needs a patient", ErrInvalidPatient)
	case !knownOrigins[origin]:
		return Proposal{}, fmt.Errorf("%w: unknown proposal origin %q", ErrInvalidPatient, origin)
	case strings.TrimSpace(source) == "":
		// SRS-EMPI-012 is about reconciling disagreements between sources. One
		// with no source cannot be reconciled against anything.
		return Proposal{}, fmt.Errorf("%w: a proposal must name its source", ErrInvalidPatient)
	case strings.TrimSpace(proposedBy) == "":
		return Proposal{}, fmt.Errorf("%w: a proposal must name who raised it", ErrInvalidPatient)
	case len(fields) == 0:
		// A proposal that changes nothing is not a proposal. Reaching here
		// usually means a feed agreed with the record entirely, and the caller
		// should have raised nothing at all.
		return Proposal{}, fmt.Errorf("%w: a proposal must propose at least one change", ErrInvalidPatient)
	case len(fields) > MaxProposalFields:
		return Proposal{}, fmt.Errorf("%w: a proposal may change at most %d fields",
			ErrInvalidPatient, MaxProposalFields)
	}

	if origin == OriginCorrectionRequest && strings.TrimSpace(reason) == "" {
		// A person asking for a change says why. Approving a correction with
		// no stated reason leaves a reviewer deciding on the value alone, and
		// "the spelling on my passport" and "I would prefer a different name"
		// are different requests with the same proposed value.
		return Proposal{}, fmt.Errorf("%w: a correction request needs a reason", ErrInvalidPatient)
	}

	seen := map[Field]bool{}
	cleaned := make([]FieldProposal, 0, len(fields))
	for _, f := range fields {
		if !knownFields[f.Field] {
			return Proposal{}, fmt.Errorf("%w: unknown field %q", ErrInvalidPatient, f.Field)
		}
		if seen[f.Field] {
			// Two proposed values for one field is not a decision a reviewer
			// can take; it is a malformed submission.
			return Proposal{}, fmt.Errorf("%w: field %q proposed twice", ErrInvalidPatient, f.Field)
		}
		seen[f.Field] = true

		if strings.TrimSpace(f.ProposedValue) == strings.TrimSpace(f.CurrentValue) {
			return Proposal{}, fmt.Errorf("%w: field %q proposes the value it already has",
				ErrInvalidPatient, f.Field)
		}
		cleaned = append(cleaned, FieldProposal{
			Field:         f.Field,
			CurrentValue:  f.CurrentValue,
			ProposedValue: f.ProposedValue,
		})
	}
	// Stable order, so a worklist and a diff read the same way twice.
	sort.Slice(cleaned, func(i, j int) bool { return cleaned[i].Field < cleaned[j].Field })

	return Proposal{
		ID: id, PatientID: patientID, Origin: origin,
		Source: normaliseText(source), ProposedBy: proposedBy,
		Reason: normaliseText(reason), Status: ProposalOpen,
		Fields: cleaned, PatientVersion: patientVersion,
		ProposedAt: now.UTC(),
	}, nil
}

// Stale reports that the record moved since the proposal was raised.
//
// A reviewer is shown "on file: 1984-03-12, proposed: 1984-12-03" and decides
// on that comparison. If the record has since changed for an unrelated reason,
// accepting would overwrite a value nobody reviewed — which is the silent
// overwrite SRS-EMPI-012 exists to prevent, arriving through the mechanism
// meant to prevent it.
func (p Proposal) Stale(currentVersion int64) bool {
	return currentVersion != p.PatientVersion
}

// Resolve records a per-field decision.
//
// accepted names the fields to apply; everything else in the proposal is
// refused. An empty set is a full rejection, which is a real decision and is
// recorded as one.
func (p *Proposal) Resolve(accepted []Field, by, note string, now time.Time) error {
	if p.Status != ProposalOpen {
		return fmt.Errorf("%w: proposal %s is already %s", ErrInvalidPatient, p.ID, p.Status)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: a resolution must name who made it", ErrInvalidPatient)
	}

	wanted := map[Field]bool{}
	for _, f := range accepted {
		wanted[f] = true
	}

	inProposal := map[Field]bool{}
	for _, f := range p.Fields {
		inProposal[f.Field] = true
	}
	for f := range wanted {
		if !inProposal[f] {
			// Accepting a field the proposal does not contain would apply a
			// value nobody proposed and nobody reviewed.
			return fmt.Errorf("%w: field %q is not part of this proposal", ErrInvalidPatient, f)
		}
	}

	any := false
	for i := range p.Fields {
		decision := wanted[p.Fields[i].Field]
		p.Fields[i].Accepted = &decision
		if decision {
			any = true
		}
	}

	if !any && strings.TrimSpace(note) == "" {
		// Refusing everything is the decision that needs explaining most: the
		// same value will arrive again, and the next reviewer needs to know
		// this one was considered rather than missed.
		return fmt.Errorf("%w: rejecting a proposal needs a note saying why", ErrInvalidPatient)
	}

	p.Status = ProposalRejected
	if any {
		p.Status = ProposalAccepted
	}
	p.ResolvedAt = now.UTC()
	p.ResolvedBy = by
	p.ResolutionNote = normaliseText(note)
	return nil
}

// Withdraw takes back an open proposal.
func (p *Proposal) Withdraw(by, note string, now time.Time) error {
	if p.Status != ProposalOpen {
		return fmt.Errorf("%w: proposal %s is already %s", ErrInvalidPatient, p.ID, p.Status)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: a withdrawal must name who made it", ErrInvalidPatient)
	}
	p.Status = ProposalWithdrawn
	p.ResolvedAt = now.UTC()
	p.ResolvedBy = by
	p.ResolutionNote = normaliseText(note)
	return nil
}

// AcceptedFields returns the fields a resolution applied.
func (p Proposal) AcceptedFields() []Field {
	out := make([]Field, 0, len(p.Fields))
	for _, f := range p.Fields {
		if f.Accepted != nil && *f.Accepted {
			out = append(out, f.Field)
		}
	}
	return out
}
