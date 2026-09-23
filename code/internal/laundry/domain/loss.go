package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// LossKind is how linen left the system other than by being washed
// (SRS-LND-006).
type LossKind string

const (
	// LossCondemned is linen deliberately taken out of service: torn, worn
	// through, stained past use. A decision somebody made.
	LossCondemned LossKind = "condemned"
	// LossDamaged is linen ruined by something identifiable — a chemical
	// spill, a machine fault. Kept apart from condemnation because the
	// follow-up is different: one is a laundry cycle, the other is an
	// incident.
	LossDamaged LossKind = "damaged"
	// LossMissing is linen that did not come back. Never confirmed until
	// somebody looks, which is why it has a state of its own below rather
	// than being written off on the day it is noticed.
	LossMissing LossKind = "missing"
)

var knownLossKind = map[LossKind]bool{
	LossCondemned: true, LossDamaged: true, LossMissing: true,
}

// LossState is where a loss record stands (SRS-LND-006).
type LossState string

const (
	// LossReported is recorded and not yet decided.
	LossReported LossState = "reported"
	// LossApproved is a write-off somebody authorised. Only an approved
	// record comes off the unit's balance.
	LossApproved LossState = "approved"
	// LossRejected is a write-off refused — usually because the linen was
	// found.
	LossRejected LossState = "rejected"
	// LossRecovered is missing linen that turned up. Its own state, so a
	// hospital's annual loss figure is not quietly reduced by records
	// somebody reopened.
	LossRecovered LossState = "recovered"
)

// LossRecord is linen written off or gone missing (SRS-LND-006).
type LossRecord struct {
	ID       string
	TenantID string

	UnitID     string
	FacilityID string
	ItemCode   string
	Quantity   int
	Kind       LossKind
	Reason     string
	// ValueMinor is the replacement cost at the time, in minor units.
	// Pinned rather than computed on read, because a price list changed in
	// March must not restate what January's losses cost.
	ValueMinor int

	State LossState
	// ApprovalRequired is set when the value crosses the hospital's
	// threshold. Derived at report time and stored, so a threshold changed
	// afterwards does not retrospectively make an approved write-off look
	// unapproved.
	ApprovalRequired bool

	ApprovedBy   string
	ApprovedAt   time.Time
	DecisionNote string

	ReportedAt time.Time
	ReportedBy string
	Version    int64
}

// Counts reports a loss that has come off the unit's balance
// (SRS-LND-004, SRS-LND-006).
func (l LossRecord) Counts() bool { return l.State == LossApproved }

// NewLossInput reports linen written off or missing.
type NewLossInput struct {
	UnitID     string
	FacilityID string
	ItemCode   string
	Quantity   int
	Kind       LossKind
	Reason     string
	ValueMinor int
	// ApprovalThresholdMinor is the value at or above which somebody has to
	// authorise the write-off. Zero requires approval for everything, which
	// is a hospital that has not decided and is the safe direction.
	ApprovalThresholdMinor int
}

// ReportLoss records linen condemned, damaged or missing (SRS-LND-006).
func ReportLoss(id, tenantID string, in NewLossInput, by string,
	now time.Time) (LossRecord, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return LossRecord{}, fmt.Errorf("%w: a loss record needs an id",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.UnitID) == "":
		return LossRecord{}, fmt.Errorf("%w: a loss record names its unit",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.ItemCode) == "":
		return LossRecord{}, fmt.Errorf("%w: a loss record names its item",
			ErrInvalidLaundry)
	case !knownLossKind[in.Kind]:
		return LossRecord{}, fmt.Errorf("%w: unknown loss kind %q",
			ErrInvalidLaundry, in.Kind)
	case in.Quantity <= 0:
		return LossRecord{}, fmt.Errorf(
			"%w: a loss is a positive number of pieces", ErrInvalidLaundry)
	case in.ValueMinor < 0:
		return LossRecord{}, fmt.Errorf("%w: a value cannot be negative",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.Reason) == "":
		// A write-off with no reason is a number in an annual report that
		// nobody can act on. SRS-LND-006 asks for it to be reportable, and
		// a reportable loss is one that says what happened.
		return LossRecord{}, fmt.Errorf("%w: say why this linen is gone",
			ErrInvalidLaundry)
	case strings.TrimSpace(by) == "":
		return LossRecord{}, fmt.Errorf("%w: a loss record names who "+
			"reported it", ErrInvalidLaundry)
	}

	return LossRecord{
		ID: id, TenantID: tenantID,
		UnitID: strings.TrimSpace(in.UnitID), FacilityID: in.FacilityID,
		ItemCode: strings.TrimSpace(in.ItemCode),
		Quantity: in.Quantity, Kind: in.Kind,
		Reason:           strings.TrimSpace(in.Reason),
		ValueMinor:       in.ValueMinor,
		State:            LossReported,
		ApprovalRequired: in.ValueMinor >= in.ApprovalThresholdMinor,
		ReportedAt:       now.UTC(), ReportedBy: by, Version: 1,
	}, nil
}

// Approve authorises a write-off (SRS-LND-006).
//
// Refused for the person who reported it. A ward sister writing off her own
// ward's missing linen and approving it herself is the whole of why the
// requirement says "with approval where required": the approval is a second
// person, or it is nothing.
func (l *LossRecord) Approve(note, by string, now time.Time) error {
	switch {
	case l.State != LossReported:
		return fmt.Errorf("%w: this loss record is %s",
			ErrInvalidLaundry, l.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who made it",
			ErrInvalidLaundry)
	case by == l.ReportedBy:
		return fmt.Errorf(
			"%w: a write-off is approved by somebody other than whoever "+
				"reported it", ErrInvalidLaundry)
	}
	l.State = LossApproved
	l.ApprovedBy, l.ApprovedAt = by, now.UTC()
	l.DecisionNote = strings.TrimSpace(note)
	return nil
}

// Reject refuses a write-off (SRS-LND-006).
func (l *LossRecord) Reject(note, by string, now time.Time) error {
	switch {
	case l.State != LossReported:
		return fmt.Errorf("%w: this loss record is %s",
			ErrInvalidLaundry, l.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a decision names who made it",
			ErrInvalidLaundry)
	case by == l.ReportedBy:
		return fmt.Errorf(
			"%w: a write-off is decided by somebody other than whoever "+
				"reported it", ErrInvalidLaundry)
	case strings.TrimSpace(note) == "":
		return fmt.Errorf("%w: say why the write-off is refused",
			ErrInvalidLaundry)
	}
	l.State = LossRejected
	l.ApprovedBy, l.ApprovedAt = by, now.UTC()
	l.DecisionNote = strings.TrimSpace(note)
	return nil
}

// Recover records missing linen turning up (SRS-LND-006).
//
// Its own state rather than a deletion or a rejection. A hospital's loss
// figure has to be able to say "we lost four hundred sheets and found sixty
// of them", and a record somebody removed says neither number.
func (l *LossRecord) Recover(note, by string, now time.Time) error {
	switch {
	case l.Kind != LossMissing:
		return fmt.Errorf("%w: only missing linen is recovered; this is %s",
			ErrInvalidLaundry, l.Kind)
	case l.State == LossRecovered:
		return fmt.Errorf("%w: this linen has already been recovered",
			ErrInvalidLaundry)
	case l.State == LossRejected:
		return fmt.Errorf("%w: this write-off was refused",
			ErrInvalidLaundry)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a recovery names who found it",
			ErrInvalidLaundry)
	}
	l.State = LossRecovered
	l.DecisionNote = strings.TrimSpace(note)
	_ = now
	return nil
}

// LossSummary reports linen written off (SRS-LND-006).
type LossSummary struct {
	Reported int
	// Pieces and Value are the approved write-offs only. A reported loss
	// nobody has decided on is not yet a loss, and counting it as one would
	// let a report be moved by anybody who can type a number.
	Pieces     int
	ValueMinor int

	Condemned int
	Damaged   int
	Missing   int
	Recovered int

	// AwaitingApproval is what somebody still has to decide. Reported
	// beside the totals rather than folded in, because a large figure here
	// means the totals are understated and a reader should know that.
	AwaitingApproval int
	// Rejected counts write-offs refused.
	Rejected int
}

// SummariseLosses counts a set of loss records (SRS-LND-006).
func SummariseLosses(records []LossRecord) LossSummary {
	out := LossSummary{}
	for _, record := range records {
		out.Reported++
		switch record.State {
		case LossApproved:
			out.Pieces += record.Quantity
			out.ValueMinor += record.ValueMinor * record.Quantity
			switch record.Kind {
			case LossCondemned:
				out.Condemned += record.Quantity
			case LossDamaged:
				out.Damaged += record.Quantity
			case LossMissing:
				out.Missing += record.Quantity
			}
		case LossReported:
			out.AwaitingApproval++
		case LossRejected:
			out.Rejected++
		case LossRecovered:
			out.Recovered += record.Quantity
		}
	}
	return out
}

// AwaitingApproval lists write-offs somebody has to decide, largest first
// (SRS-LND-006).
func AwaitingApproval(records []LossRecord) []LossRecord {
	var out []LossRecord
	for _, record := range records {
		if record.State == LossReported && record.ApprovalRequired {
			out = append(out, record)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		left := out[a].ValueMinor * out[a].Quantity
		right := out[b].ValueMinor * out[b].Quantity
		if left != right {
			return left > right
		}
		return out[a].ReportedAt.Before(out[b].ReportedAt)
	})
	return out
}
