package domain_test

import (
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
)

// The longitudinal timeline (SRS-ENC-011, SRS-CLN-018, SRS-CLN-019).

func entries() []domain.Entry {
	base := at(2026, time.March, 3, 9)
	return []domain.Entry{
		{
			ID: "n-1", Kind: domain.EntryNote, At: base, Title: "Consultation note",
			Confidentiality: domain.ConfidentialityNormal, AuthorID: "doctor-1",
		},
		{
			ID: "n-2", Kind: domain.EntryNote, At: base.Add(time.Hour),
			Title:           "Mental health review",
			Confidentiality: domain.ConfidentialityRestricted, AuthorID: "psych-1",
			CareTeamIDs: []string{"psych-1"},
		},
		{
			ID: "n-3", Kind: domain.EntryNote, At: base.Add(2 * time.Hour),
			Title:           "Safeguarding concern",
			Confidentiality: domain.ConfidentialityVeryRestricted, AuthorID: "safeguard-1",
		},
		{
			ID: "o-1", Kind: domain.EntryObservation, At: base.Add(3 * time.Hour),
			Title: "Blood pressure", Confidentiality: domain.ConfidentialityNormal,
			AuthorID: "nurse-1",
		},
	}
}

// SRS-ENC-011: "unauthorized restricted notes are omitted/masked".
func TestAnOrdinaryReaderSeesNeitherRestrictedNote(t *testing.T) {
	got := domain.FilterTimeline(entries(), domain.TimelineAccess{
		SubjectID:          "doctor-9",
		MaxConfidentiality: domain.ConfidentialityNormal,
		MaskRatherThanOmit: true,
	})

	byID := map[string]domain.Entry{}
	for _, e := range got {
		byID[e.ID] = e
	}

	if _, present := byID["n-3"]; present {
		t.Fatal("a very-restricted safeguarding note appears on an ordinary timeline; " +
			"its existence is itself the disclosure")
	}

	masked, present := byID["n-2"]
	if !present {
		t.Fatal("the restricted note was omitted entirely, so the chart silently " +
			"claims to be complete")
	}
	if !masked.Masked {
		t.Fatal("the restricted note is not marked as masked")
	}
	if masked.Title == "Mental health review" {
		t.Fatal("a masked entry still carries its title, which is the disclosure")
	}
	if _, present := byID["n-1"]; !present {
		t.Fatal("an ordinary note was withheld")
	}
}

// A note its own author cannot reopen is a note nobody will write.
func TestTheAuthorOfARestrictedNoteCanAlwaysReadItBack(t *testing.T) {
	got := domain.FilterTimeline(entries(), domain.TimelineAccess{
		SubjectID:          "psych-1",
		MaxConfidentiality: domain.ConfidentialityNormal,
		MaskRatherThanOmit: true,
	})

	for _, e := range got {
		if e.ID == "n-2" {
			if e.Masked {
				t.Fatal("the author cannot read their own restricted note")
			}
			return
		}
	}
	t.Fatal("the author's own restricted note is missing from their timeline")
}

// Break-glass reaches restricted content and stops there: the very-restricted
// tier is the one a hospital has decided needs a conversation rather than a
// button.
func TestBreakGlassReachesRestrictedButNotVeryRestricted(t *testing.T) {
	got := domain.FilterTimeline(entries(), domain.TimelineAccess{
		SubjectID:          "doctor-9",
		MaxConfidentiality: domain.ConfidentialityNormal,
		BreakGlass:         true,
		MaskRatherThanOmit: true,
	})

	for _, e := range got {
		switch e.ID {
		case "n-2":
			if e.Masked {
				t.Fatal("break-glass did not reach a restricted note")
			}
		case "n-3":
			t.Fatal("break-glass reached a very-restricted safeguarding note")
		}
	}
}

// A classification this version does not understand is one it cannot safely
// show.
func TestAnUnknownConfidentialityClassIsTreatedAsTheTightest(t *testing.T) {
	unknown := []domain.Entry{{
		ID: "x-1", Kind: domain.EntryNote, At: at(2026, time.March, 3, 9),
		Title: "Unknown class", Confidentiality: "invented_by_a_later_version",
		AuthorID: "someone",
	}}

	got := domain.FilterTimeline(unknown, domain.TimelineAccess{
		SubjectID:          "doctor-9",
		MaxConfidentiality: domain.ConfidentialityVeryRestricted,
		MaskRatherThanOmit: true,
	})
	if len(got) != 0 {
		t.Fatalf("an entry with an unrecognised confidentiality class was shown: %+v", got)
	}
}

// SRS-CLN-019: a restricted read is what has to be explicitly audited, so the
// caller needs to know which entries were withheld.
func TestTheFilterReportsWhatItWithheld(t *testing.T) {
	got := domain.FilterTimeline(entries(), domain.TimelineAccess{
		SubjectID:          "doctor-9",
		MaxConfidentiality: domain.ConfidentialityNormal,
		MaskRatherThanOmit: true,
	})

	withheld := domain.Restricted(got)
	if len(withheld) != 1 || withheld[0].ID != "n-2" {
		t.Fatalf("withheld = %+v, want the restricted note", withheld)
	}
}

// SRS-CLN-018: "filters never change underlying record".
func TestFilteringByKindLeavesTheTimelineAlone(t *testing.T) {
	all := entries()

	notes := domain.FilterKinds(all, []domain.EntryKind{domain.EntryNote})
	if len(notes) != 3 {
		t.Fatalf("%d notes, want 3", len(notes))
	}
	if len(all) != 4 {
		t.Fatal("filtering shortened the underlying slice")
	}
	if all[3].Kind != domain.EntryObservation {
		t.Fatal("filtering reordered or rewrote the underlying entries")
	}

	// No filter means everything, not nothing.
	if len(domain.FilterKinds(all, nil)) != 4 {
		t.Fatal("an empty filter hid every entry")
	}
}

// A chart is read newest first.
func TestTheTimelineSortsNewestFirst(t *testing.T) {
	all := entries()
	domain.SortTimeline(all)

	if all[0].ID != "o-1" {
		t.Fatalf("the timeline leads with %q, want the most recent entry", all[0].ID)
	}
	for i := 1; i < len(all); i++ {
		if all[i].At.After(all[i-1].At) {
			t.Fatal("the timeline is not in descending time order")
		}
	}
}
