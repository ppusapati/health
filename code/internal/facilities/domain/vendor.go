package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// VisitState is where a contractor visit stands (SRS-FAC-011).
type VisitState string

const (
	VisitOnSite   VisitState = "on_site"
	VisitDeparted VisitState = "departed"
)

var knownVisitState = map[VisitState]bool{
	VisitOnSite: true, VisitDeparted: true,
}

// Visit is a contractor attendance (SRS-FAC-011).
//
// The acceptance is that vendor activity is linked to a work order or an
// asset, and the linkage is the requirement rather than a convenience. A
// contractor who came, did something to the plant and left without any record
// of which plant is the reason a maintenance history has gaps that nobody can
// explain two years later when the machine fails.
type Visit struct {
	ID       string
	TenantID string

	VendorName string
	// VendorRef is the contract or purchase order this visit is under.
	VendorRef   string
	ContactName string
	// Technicians are the people who actually came on site. Names rather
	// than user accounts: a contractor's engineer has no login here.
	Technicians []string

	FacilityID string

	// At least one of these three. A visit against nothing is a visitor
	// log entry, which is a different system's problem.
	WorkOrderID string
	AssetID     string
	TaskID      string

	// WorkRequiresPermit is copied from the linked work order's class. It
	// is here so the database can hold one rule it otherwise could not: a
	// contractor doing permit work has a recorded site induction. A
	// composite foreign key to the work order, cascading on update, stops
	// the copy drifting from the class it came from.
	WorkRequiresPermit bool
	// InductionRef is the site safety induction this contractor holds.
	InductionRef string

	Purpose string

	State       VisitState
	SignedInAt  time.Time
	SignedInBy  string
	SignedOutAt time.Time
	SignedOutBy string

	// ServiceReportRef is the contractor's own report. Required to sign
	// out: a visit with no report is a visit nobody can audit, and the
	// report is what SRS-FAC-011 is actually asking to be kept.
	ServiceReportRef string
	ReportSummary    string
	PartsUsed        []string
	// FollowUp is work the contractor says is still needed. Captured here
	// because it is otherwise said out loud in a corridor and lost.
	FollowUp string

	CreatedAt time.Time
	Version   int64
}

// SignInInput records a contractor arriving.
type SignInInput struct {
	VendorName  string
	VendorRef   string
	ContactName string
	Technicians []string
	FacilityID  string
	WorkOrderID string
	AssetID     string
	TaskID      string
	// WorkRequiresPermit is the linked work order's class flag. The
	// application reads it from the order rather than trusting the
	// caller.
	WorkRequiresPermit bool
	InductionRef       string
	Purpose            string
}

// SignIn records a contractor arriving on site (SRS-FAC-011).
func SignIn(id, tenantID string, in SignInInput, by string,
	now time.Time) (Visit, error) {

	linked := strings.TrimSpace(in.WorkOrderID) != "" ||
		strings.TrimSpace(in.AssetID) != "" ||
		strings.TrimSpace(in.TaskID) != ""

	switch {
	case strings.TrimSpace(id) == "":
		return Visit{}, fmt.Errorf("%w: a visit needs an id",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.VendorName) == "":
		return Visit{}, fmt.Errorf("%w: a visit names the contractor",
			ErrInvalidFacilities)
	case !linked:
		return Visit{}, fmt.Errorf(
			"%w: a contractor visit names the work order, asset or task it is for",
			ErrInvalidFacilities)
	case len(normalise(in.Technicians)) == 0:
		// A visit by nobody in particular cannot be matched against
		// the induction record or the gate log.
		return Visit{}, fmt.Errorf("%w: name who came on site",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Purpose) == "":
		return Visit{}, fmt.Errorf("%w: say what the contractor came to do",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return Visit{}, fmt.Errorf("%w: name who signed the contractor in",
			ErrInvalidFacilities)
	case in.WorkRequiresPermit && strings.TrimSpace(in.InductionRef) == "":
		return Visit{}, fmt.Errorf(
			"%w: permit work needs the contractor's site induction on record",
			ErrInvalidFacilities)
	case in.WorkRequiresPermit && strings.TrimSpace(in.WorkOrderID) == "":
		// The flag is copied from a work order. Setting it without one
		// would put a foreign key in the database with nothing on the
		// other end of it.
		return Visit{}, fmt.Errorf("%w: permit work names its work order",
			ErrInvalidFacilities)
	}

	return Visit{
		ID: id, TenantID: tenantID,
		VendorName:         strings.TrimSpace(in.VendorName),
		VendorRef:          strings.TrimSpace(in.VendorRef),
		ContactName:        strings.TrimSpace(in.ContactName),
		Technicians:        normalise(in.Technicians),
		FacilityID:         strings.TrimSpace(in.FacilityID),
		WorkOrderID:        strings.TrimSpace(in.WorkOrderID),
		AssetID:            strings.TrimSpace(in.AssetID),
		TaskID:             strings.TrimSpace(in.TaskID),
		WorkRequiresPermit: in.WorkRequiresPermit,
		InductionRef:       strings.TrimSpace(in.InductionRef),
		Purpose:            strings.TrimSpace(in.Purpose),
		State:              VisitOnSite,
		SignedInAt:         now.UTC(), SignedInBy: by,
		CreatedAt: now.UTC(), Version: 1,
	}, nil
}

// SignOutInput records a contractor leaving with their report.
type SignOutInput struct {
	ServiceReportRef string
	ReportSummary    string
	PartsUsed        []string
	FollowUp         string
}

// SignOut records a contractor leaving (SRS-FAC-011).
func (v *Visit) SignOut(in SignOutInput, by string, now time.Time) error {
	switch {
	case v.State != VisitOnSite:
		return fmt.Errorf("%w: this contractor has already signed out",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who signed the contractor out",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.ServiceReportRef) == "":
		return fmt.Errorf("%w: a visit closes with the service report",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.ReportSummary) == "":
		// The reference points at a PDF nobody will open. The summary
		// is what appears in the asset's history.
		return fmt.Errorf("%w: summarise what the contractor did",
			ErrInvalidFacilities)
	}

	v.State = VisitDeparted
	v.SignedOutAt = now.UTC()
	v.SignedOutBy = strings.TrimSpace(by)
	v.ServiceReportRef = strings.TrimSpace(in.ServiceReportRef)
	v.ReportSummary = strings.TrimSpace(in.ReportSummary)
	v.PartsUsed = normalise(in.PartsUsed)
	v.FollowUp = strings.TrimSpace(in.FollowUp)
	return nil
}

// OnSite lists contractors currently in the building (SRS-FAC-011).
//
// Longest on site first, which is the order that surfaces the visit somebody
// forgot to sign out — and, during an evacuation, the list that matters.
func OnSite(visits []Visit) []Visit {
	out := make([]Visit, 0, len(visits))
	for _, visit := range visits {
		if visit.State == VisitOnSite {
			out = append(out, visit)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].SignedInAt.Before(out[j].SignedInAt)
	})
	return out
}
