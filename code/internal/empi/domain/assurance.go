package domain

import (
	"fmt"
	"strings"
	"time"
)

// How much an identifier is worth as identity evidence (SRS-EMPI-011).
//
// "The clerk typed an ABHA number" and "ABDM confirmed this ABHA number
// belongs to this person" are both an identifier row with the same value, and
// they are not the same evidence. Storing only the value loses the difference,
// and the difference is what SRS-EMPI-010 relies on when it requires the
// identity workflow to include a configured *positive* identifier: a number
// somebody read off a photocopy is not one.
//
// Deliberately two states and not a numeric score. A score invites arithmetic
// across identifiers, and there is no defensible arithmetic here: two asserted
// identifiers do not add up to a verified one.

// IdentifierAssurance is how the value came to be believed.
type IdentifierAssurance string

const (
	// AssuranceAsserted: a person stated it and somebody typed it in. This is
	// the default, because it is what happens at a registration desk.
	AssuranceAsserted IdentifierAssurance = "asserted"
	// AssuranceVerified: the authority that issues the identifier confirmed
	// the value, through an adapter, at a recorded moment.
	AssuranceVerified IdentifierAssurance = "verified"
)

var knownAssurances = map[IdentifierAssurance]bool{
	AssuranceAsserted: true, AssuranceVerified: true,
}

// IsPositive reports whether this identifier counts as positive identification.
//
// Only a verified identifier does. SRS-EMPI-010 prohibits a photo from being
// the sole identity proof and requires the workflow to include a configured
// positive identifier; an asserted number offers no more assurance than the
// photo does.
func (a IdentifierAssurance) IsPositive() bool { return a == AssuranceVerified }

// Verification is what an issuing authority said about an identifier.
//
// Carried separately from the Identifier because it is an event that happened
// at a moment, not a property of the value. Re-verifying produces a second
// Verification; it does not edit the first.
type Verification struct {
	// Verified is the authority's answer. False is a real answer — the value
	// is not recognised — and is distinct from an error, which means the
	// authority could not be asked.
	Verified bool
	// AssigningAuthority is who answered, recorded because "verified" is only
	// meaningful alongside who did the verifying.
	AssigningAuthority string
	// Demographics is what the authority holds against the identifier, when it
	// returns any. Never written over the patient's record here: a difference
	// is a conflict for reconciliation (SRS-EMPI-012), not a correction.
	Demographics    Demographics
	HasDemographics bool
	// Reason explains a negative answer in a sentence a clerk can act on.
	Reason     string
	VerifiedAt time.Time
}

// ErrRegistryUnavailable reports that the issuing authority could not be
// reached or refused to answer.
//
// Distinct from an unverified answer on purpose. A national identifier service
// being down must not silently downgrade every identifier linked during the
// outage to "asserted" without anybody noticing, and it must not block
// registration either — the caller decides, and needs to be able to tell the
// two apart to do so.
type ErrRegistryUnavailable struct {
	System string
	Cause  error
}

func (e ErrRegistryUnavailable) Error() string {
	return fmt.Sprintf("empi: identifier registry for %q is unavailable: %v", e.System, e.Cause)
}

func (e ErrRegistryUnavailable) Unwrap() error { return e.Cause }

// Verify records an authority's confirmation against an identifier.
func (i *Identifier) Verify(v Verification, now time.Time) error {
	if i.Status != IdentifierActive {
		return fmt.Errorf("%w: cannot verify identifier %s, it is %s",
			ErrInvalidPatient, i.ID, i.Status)
	}
	if !v.Verified {
		return fmt.Errorf("%w: the issuing authority did not confirm this identifier: %s",
			ErrInvalidPatient, v.Reason)
	}
	if strings.TrimSpace(v.AssigningAuthority) == "" {
		// "Verified" with nobody named is a claim with no author.
		return fmt.Errorf("%w: a verification must name the authority that made it",
			ErrInvalidPatient)
	}
	at := v.VerifiedAt
	if at.IsZero() {
		at = now
	}
	verifiedAt := at.UTC()
	i.Assurance = AssuranceVerified
	i.AssigningAuthority = normaliseText(v.AssigningAuthority)
	i.VerifiedAt = &verifiedAt
	return nil
}

// Positive returns the identifiers that count as positive identification.
func (s IdentifierSet) Positive() IdentifierSet {
	out := make(IdentifierSet, 0, len(s))
	for _, i := range s {
		if i.Status == IdentifierActive && i.Assurance.IsPositive() {
			out = append(out, i)
		}
	}
	return out
}

// HasPositiveIdentification reports whether the patient holds at least one
// verified identifier (SRS-EMPI-010).
func (s IdentifierSet) HasPositiveIdentification() bool {
	return len(s.Positive()) > 0
}
