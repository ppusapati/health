package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// IssueState is where an issued pack has got to (SRS-CSSD-009).
type IssueState string

const (
	IssueOut IssueState = "out"
	// IssueUsed is a pack opened for a case. The theatre records its own side
	// of this (SRS-OT-012); what is here is the department's.
	IssueUsed IssueState = "used"
	// IssueReturned is a pack that came back unopened, which goes back on the
	// shelf if it is still in date.
	IssueReturned IssueState = "returned"
	// IssueRecalled is a pack pulled back after a failed indicator or a
	// sterilizer event. It never goes back on the shelf.
	IssueRecalled IssueState = "recalled"
)

// Issue is a sterile pack leaving the department (SRS-CSSD-009).
type Issue struct {
	ID       string
	TenantID string

	RunID   string
	SetCode string
	CycleID string

	// Destination is where it went. A pack with none is one nobody can fetch
	// back, which is what a recall has to do.
	Destination string
	IssuedTo    string

	State IssueState
	// UsedCaseID links the pack to the operation it was opened for, where the
	// theatre told us. This is the link SRS-CSSD-010's case trace runs along.
	UsedCaseID string
	// ReturnCount is what came back, against what went out. A set returning
	// short is an instrument somewhere else — possibly in a patient.
	ReturnCount map[string]int
	ReturnNote  string

	IssuedAt time.Time
	IssuedBy string
	ClosedAt time.Time
	ClosedBy string
}

// NewIssueInput sends a pack out.
type NewIssueInput struct {
	RunID       string
	Destination string
	IssuedTo    string
}

// IssuePack sends a sterile pack out (SRS-CSSD-008, SRS-CSSD-009).
//
// Refuses an unreleased or expired pack. Those are the two ways a pack that
// looks sterile is not, and both are checked here rather than trusted from a
// label somebody printed earlier.
func IssuePack(id, tenantID string, in NewIssueInput, run Run, by string,
	now time.Time) (Issue, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Issue{}, fmt.Errorf("%w: an issue needs an id", ErrInvalidSet)
	case strings.TrimSpace(in.Destination) == "":
		return Issue{}, fmt.Errorf("%w: an issue records where the pack went",
			ErrInvalidSet)
	case strings.TrimSpace(by) == "":
		return Issue{}, fmt.Errorf("%w: an issue names who sent it", ErrInvalidSet)
	case run.Stage != StageReleased:
		return Issue{}, fmt.Errorf(
			"%w: this pack has not been released (it is at %s)",
			ErrInvalidSet, run.Stage)
	case run.Expired(now):
		return Issue{}, fmt.Errorf("%w: this pack expired on %s",
			ErrInvalidSet, run.ExpiresAt.Format(time.RFC3339))
	}

	return Issue{
		ID: id, TenantID: tenantID,
		RunID: run.ID, SetCode: run.SetCode, CycleID: run.CycleID,
		Destination: strings.TrimSpace(in.Destination),
		IssuedTo:    strings.TrimSpace(in.IssuedTo),
		State:       IssueOut,
		IssuedAt:    now.UTC(), IssuedBy: strings.TrimSpace(by),
	}, nil
}

// MarkUsed records a pack opened for a case (SRS-CSSD-009, SRS-CSSD-010).
func (i *Issue) MarkUsed(caseID, by string, now time.Time) error {
	switch {
	case i.State != IssueOut:
		return fmt.Errorf("%w: this pack is %s", ErrInvalidSet, i.State)
	case strings.TrimSpace(caseID) == "":
		// Without the case there is no trace from a patient back to this
		// cycle, which is the whole of SRS-CSSD-010.
		return fmt.Errorf("%w: say which case the pack was opened for",
			ErrInvalidSet)
	}
	i.State, i.UsedCaseID = IssueUsed, strings.TrimSpace(caseID)
	i.ClosedAt, i.ClosedBy = now.UTC(), strings.TrimSpace(by)
	return nil
}

// Return records a pack coming back unopened (SRS-CSSD-009).
//
// The count comes back with it. A set returning short is an instrument
// somewhere else, and the moment it is counted is the last moment anybody can
// say where it was.
func (i *Issue) Return(counted map[string]int, note, by string, set TraySet,
	now time.Time) ([]string, error) {

	if i.State != IssueOut {
		return nil, fmt.Errorf("%w: this pack is %s", ErrInvalidSet, i.State)
	}

	i.State = IssueReturned
	i.ReturnCount = copyCounts(counted)
	i.ReturnNote = strings.TrimSpace(note)
	i.ClosedAt, i.ClosedBy = now.UTC(), strings.TrimSpace(by)
	// Reported rather than refused: the pack is back on the counter whatever
	// the count says, and refusing to record it would leave the shortfall
	// unwritten.
	return shortfall(set.Expected(), i.ReturnCount), nil
}

// Recall pulls a pack back (SRS-CSSD-011).
func (i *Issue) Recall(by string, now time.Time) error {
	switch {
	case i.State == IssueRecalled:
		return fmt.Errorf("%w: this pack has already been recalled", ErrInvalidSet)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a recall names who raised it", ErrInvalidSet)
	}
	// A used pack is still recalled. The pack cannot come back — it was opened
	// into a patient — but the recall record is what says the patient was
	// reached, and removing them from the list would be the one thing a recall
	// must not do.
	i.State = IssueRecalled
	i.ClosedAt, i.ClosedBy = now.UTC(), strings.TrimSpace(by)
	return nil
}

// CaseTrace is everything a patient's procedure touched (SRS-CSSD-010).
//
// The direction an infection investigation runs: from the case backwards to
// the sets, and from each set to the cycle it came out of.
type CaseTrace struct {
	CaseID string
	Sets   []TracedSet
	// Incomplete names sets whose chain could not be followed, so a reader can
	// tell "this case used three sets" from "this case used three sets that we
	// know of".
	Incomplete []string
}

// TracedSet is one set used in a case, with its cycle.
type TracedSet struct {
	RunID      string
	SetCode    string
	SetVersion int
	CycleID    string
	LoadNumber string
	Machine    string
	// SkippedStages names the reprocessing steps this pack did not actually
	// have. An infection investigation asks this first.
	SkippedStages []string
	SterilisedAt  time.Time
	UsedAt        time.Time
}

// BuildCaseTrace assembles what a case touched (SRS-CSSD-010).
func BuildCaseTrace(caseID string, issues []Issue, runs map[string]Run,
	cycles map[string]Cycle) CaseTrace {

	out := CaseTrace{CaseID: caseID}
	for _, issue := range issues {
		run, haveRun := runs[issue.RunID]
		if !haveRun {
			out.Incomplete = append(out.Incomplete,
				"pack "+issue.RunID+": no reprocessing record")
			continue
		}
		traced := TracedSet{
			RunID: run.ID, SetCode: run.SetCode, SetVersion: run.SetVersion,
			CycleID: run.CycleID, SkippedStages: run.SkippedStages(),
			SterilisedAt: run.SterilisedAt, UsedAt: issue.ClosedAt,
		}
		if cycle, haveCycle := cycles[run.CycleID]; haveCycle {
			traced.LoadNumber, traced.Machine = cycle.LoadNumber, cycle.Machine
		} else {
			out.Incomplete = append(out.Incomplete,
				"set "+run.SetCode+": no cycle record")
		}
		out.Sets = append(out.Sets, traced)
	}
	sort.Slice(out.Sets, func(i, j int) bool {
		return out.Sets[i].SetCode < out.Sets[j].SetCode
	})
	sort.Strings(out.Incomplete)
	return out
}

// RecallScope is what a failed load reaches (SRS-CSSD-011).
type RecallScope struct {
	CycleID    string
	LoadNumber string
	Reason     string

	// Packs are the runs in the load, with where each one is now.
	Packs []RecalledPack
	// Cases are the operations a pack from this load was opened for. The list
	// that has to reach an infection control team, because those patients
	// cannot have the pack back.
	Cases []string
	// Locations are where the unopened packs are, so somebody can go and
	// fetch them.
	Locations []string
}

// RecalledPack is one pack in a recall.
type RecalledPack struct {
	RunID   string
	SetCode string
	// State is where it is: still in the department, out somewhere, or already
	// used. The three need different actions.
	State      string
	Location   string
	UsedCaseID string
}

// The states a recalled pack can be in.
const (
	RecallInDepartment = "in_department"
	RecallIssued       = "issued"
	RecallUsed         = "used"
)

// BuildRecall works out what a failed load reaches (SRS-CSSD-011).
//
// Every pack in the load, whether it left or not, and every case one was
// opened for. A recall that only covered the packs still on a shelf would miss
// exactly the patients it exists to find.
func BuildRecall(cycle Cycle, reason string, runs []Run,
	issues map[string][]Issue) RecallScope {

	out := RecallScope{
		CycleID: cycle.ID, LoadNumber: cycle.LoadNumber,
		Reason: strings.TrimSpace(reason),
	}

	seenCases := map[string]bool{}
	seenLocations := map[string]bool{}

	for _, run := range runs {
		pack := RecalledPack{
			RunID: run.ID, SetCode: run.SetCode, State: RecallInDepartment,
		}
		for _, issue := range issues[run.ID] {
			switch issue.State {
			case IssueUsed:
				pack.State, pack.UsedCaseID = RecallUsed, issue.UsedCaseID
				if issue.UsedCaseID != "" && !seenCases[issue.UsedCaseID] {
					seenCases[issue.UsedCaseID] = true
					out.Cases = append(out.Cases, issue.UsedCaseID)
				}
			case IssueOut:
				pack.State, pack.Location = RecallIssued, issue.Destination
				if issue.Destination != "" && !seenLocations[issue.Destination] {
					seenLocations[issue.Destination] = true
					out.Locations = append(out.Locations, issue.Destination)
				}
			}
		}
		out.Packs = append(out.Packs, pack)
	}

	sort.Slice(out.Packs, func(i, j int) bool {
		return out.Packs[i].RunID < out.Packs[j].RunID
	})
	sort.Strings(out.Cases)
	sort.Strings(out.Locations)
	return out
}
