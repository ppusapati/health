package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// IssueLine is one item's count in a clean-linen issue.
type IssueLine struct {
	ItemCode string
	Quantity int
}

// Issue is clean linen going back to a unit (SRS-LND-004).
//
// It names the batch it came out of. That link is what makes "which wards got
// linen from the load that failed" answerable, and it is why the issue is
// refused when the batch did not pass rather than the failure being a note
// somebody reads later.
type Issue struct {
	ID       string
	TenantID string

	UnitID     string
	UnitName   string
	FacilityID string

	BatchID string
	// BatchReference is carried so a delivery note reads without a join.
	BatchReference string

	Lines []IssueLine

	IssuedAt time.Time
	IssuedBy string
	// ReceivedBy is who signed for it on the unit. Empty until somebody
	// does, and an unreceived issue is reported as such rather than assumed.
	ReceivedAt time.Time
	ReceivedBy string

	Version int64
}

// NewIssueInput issues clean linen to a unit.
type NewIssueInput struct {
	UnitID     string
	UnitName   string
	FacilityID string
	Lines      []IssueLine
}

// IssueLinen sends clean linen from a batch to a unit (SRS-LND-004).
//
// The batch is passed in and checked rather than named. Linen from a wash
// that did not pass looks exactly like clean linen, and the ward that gets it
// has no way of telling: this refusal is the only thing standing between a
// failed thermal disinfection and a made bed.
func IssueLinen(id, tenantID string, batch Batch, in NewIssueInput,
	by string, now time.Time) (Issue, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Issue{}, fmt.Errorf("%w: an issue needs an id",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.UnitID) == "":
		return Issue{}, fmt.Errorf("%w: an issue names the unit it goes to",
			ErrInvalidLaundry)
	case !batch.Issuable():
		return Issue{}, fmt.Errorf(
			"%w: batch %s is %s; linen is issued from a passed wash",
			ErrInvalidLaundry, batch.ID, batch.State)
	case strings.TrimSpace(by) == "":
		return Issue{}, fmt.Errorf("%w: an issue names who made it",
			ErrInvalidLaundry)
	case len(in.Lines) == 0:
		return Issue{}, fmt.Errorf("%w: an issue says what was sent",
			ErrInvalidLaundry)
	}

	lines := make([]IssueLine, 0, len(in.Lines))
	seen := map[string]bool{}
	for _, line := range in.Lines {
		code := strings.TrimSpace(line.ItemCode)
		switch {
		case code == "":
			return Issue{}, fmt.Errorf("%w: an issue line names its item",
				ErrInvalidLaundry)
		case seen[strings.ToLower(code)]:
			return Issue{}, fmt.Errorf("%w: item %q appears twice",
				ErrInvalidLaundry, code)
		case line.Quantity <= 0:
			return Issue{}, fmt.Errorf(
				"%w: the count for %q is not a positive number",
				ErrInvalidLaundry, code)
		}
		seen[strings.ToLower(code)] = true
		lines = append(lines, IssueLine{
			ItemCode: code, Quantity: line.Quantity,
		})
	}

	return Issue{
		ID: id, TenantID: tenantID,
		UnitID:     strings.TrimSpace(in.UnitID),
		UnitName:   strings.TrimSpace(in.UnitName),
		FacilityID: in.FacilityID,
		BatchID:    batch.ID, BatchReference: batch.Reference,
		Lines:    lines,
		IssuedAt: now.UTC(), IssuedBy: by, Version: 1,
	}, nil
}

// Receive records the unit signing for the linen (SRS-LND-004).
//
// Refused for whoever issued it. A delivery signed for by the porter who
// brought it is the same claim made twice, and a ward that never got its
// linen has no way to say so.
func (i *Issue) Receive(by string, now time.Time) error {
	switch {
	case !i.ReceivedAt.IsZero():
		return fmt.Errorf("%w: this issue has already been received",
			ErrInvalidLaundry)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a receipt names who signed for it",
			ErrInvalidLaundry)
	case by == i.IssuedBy:
		return fmt.Errorf(
			"%w: linen is received by somebody other than whoever issued it",
			ErrInvalidLaundry)
	}
	i.ReceivedAt, i.ReceivedBy = now.UTC(), by
	return nil
}

// Pieces totals an issue.
func (i Issue) Pieces() int {
	total := 0
	for _, line := range i.Lines {
		total += line.Quantity
	}
	return total
}

// UnitBalance is what a unit holds, derived (SRS-LND-004).
//
// Issued minus returned minus written off, per item. Derived from the
// movements rather than stored, which is SRS-LND-004's acceptance in one
// line: a stored balance and the issues behind it disagree the first time
// somebody corrects a delivery note, and the stored one is the number the
// ward is judged on.
type UnitBalance struct {
	UnitID string
	// OnHand is the balance per item code. Never negative: a ward that has
	// returned more than it was issued is a counting problem, and reporting
	// minus four sheets reads as a ward that owes the laundry linen it
	// never had.
	OnHand map[string]int
	// Issued, Returned and WrittenOff are the components, so a reader can
	// see how the balance was reached instead of being asked to trust it.
	Issued     map[string]int
	Returned   map[string]int
	WrittenOff map[string]int
	// Unreconciled counts returns the laundry could not attribute to an
	// item, which is every sealed infected bag recorded by weight alone.
	// Reported rather than silently dropped: a ward whose linen all comes
	// back in sealed bags would otherwise look like a ward that never
	// returns anything.
	UnreconciledReturns int
}

// DeriveBalance computes what a unit holds (SRS-LND-004).
//
// Cancelled collections are skipped and unreceived issues are counted:
// linen that left the laundry is linen the ward has, whether or not anybody
// signed for it, and treating it otherwise would let a unit hold stock that
// appears nowhere.
func DeriveBalance(unitID string, issues []Issue, collections []Collection,
	losses []LossRecord) UnitBalance {

	out := UnitBalance{
		UnitID: unitID,
		OnHand: map[string]int{}, Issued: map[string]int{},
		Returned: map[string]int{}, WrittenOff: map[string]int{},
	}

	for _, issue := range issues {
		if !strings.EqualFold(issue.UnitID, unitID) {
			continue
		}
		for _, line := range issue.Lines {
			out.Issued[line.ItemCode] += line.Quantity
		}
	}
	for _, collection := range collections {
		if !strings.EqualFold(collection.UnitID, unitID) ||
			collection.State == CollectionCancelled {
			continue
		}
		if len(collection.Lines) == 0 {
			out.UnreconciledReturns += collection.BagCount
			continue
		}
		for _, line := range collection.Lines {
			out.Returned[line.ItemCode] += line.Quantity
		}
	}
	for _, loss := range losses {
		if !strings.EqualFold(loss.UnitID, unitID) || !loss.Counts() {
			continue
		}
		out.WrittenOff[loss.ItemCode] += loss.Quantity
	}

	for code, issued := range out.Issued {
		held := issued - out.Returned[code] - out.WrittenOff[code]
		if held < 0 {
			held = 0
		}
		out.OnHand[code] = held
	}
	return out
}

// OutstandingIssues lists linen nobody has signed for, oldest first
// (SRS-LND-004).
func OutstandingIssues(issues []Issue) []Issue {
	var out []Issue
	for _, issue := range issues {
		if issue.ReceivedAt.IsZero() {
			out = append(out, issue)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		if !out[a].IssuedAt.Equal(out[b].IssuedAt) {
			return out[a].IssuedAt.Before(out[b].IssuedAt)
		}
		return out[a].ID < out[b].ID
	})
	return out
}
