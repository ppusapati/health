package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The operative note (SRS-OT-009), consumables and implants (SRS-OT-010),
// specimens (SRS-OT-011), instrument trays (SRS-OT-012) and preference cards
// (SRS-OT-016).

// NoteStatus is where an operative note has got to.
type NoteStatus string

const (
	NoteDraft NoteStatus = "draft"
	// NoteSigned is the surgeon's assertion. Amendments after this point are
	// versions rather than edits (SRS-OT-009).
	NoteSigned     NoteStatus = "signed"
	NoteAmended    NoteStatus = "amended"
	NoteSuperseded NoteStatus = "superseded"
)

// OperativeNote is what was done (SRS-OT-009).
//
// Versioned rather than edited once signed. An operative note is the document
// read in a complaint, a claim and a coroner's court, and one whose history
// was overwritten cannot answer what the surgeon wrote on the day.
type OperativeNote struct {
	ID       string
	TenantID string
	CaseID   string

	// Version counts from 1. An amendment is a new row pointing at the one it
	// replaces, so the chain reads forwards.
	Version    int
	Supersedes string

	ProcedurePerformed string
	Findings           string
	// Specimens, Implants and Complications are recorded as structured lists
	// rather than buried in the narrative, because each of them is read by a
	// different department: pathology, the implant registry and the
	// governance team.
	SpecimenIDs   []string
	ImplantIDs    []string
	Complications []string
	// EstimatedBloodLossML is a number rather than a phrase. "Minimal" means
	// different things to different surgeons, and the transfusion service
	// needs a figure.
	EstimatedBloodLossML int
	PostOperativeOrders  string
	Narrative            string

	Status NoteStatus
	// AmendmentReason explains a version after the first. Required, because an
	// unexplained amendment to an operative note is the entry a claim asks
	// about.
	AmendmentReason string

	AuthoredBy string
	AuthoredAt time.Time
	SignedBy   string
	SignedAt   time.Time
}

// NewNoteInput is an operative note.
type NewNoteInput struct {
	CaseID               string
	ProcedurePerformed   string
	Findings             string
	SpecimenIDs          []string
	ImplantIDs           []string
	Complications        []string
	EstimatedBloodLossML int
	PostOperativeOrders  string
	Narrative            string
}

// NewOperativeNote drafts an operative note (SRS-OT-009).
func NewOperativeNote(id, tenantID string, in NewNoteInput, by string,
	now time.Time) (OperativeNote, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.CaseID) == "":
		return OperativeNote{}, fmt.Errorf("%w: an operative note belongs to a case",
			ErrInvalidCase)
	case strings.TrimSpace(in.ProcedurePerformed) == "":
		// What was actually done, which is not always what was booked.
		return OperativeNote{}, fmt.Errorf(
			"%w: an operative note says what was performed", ErrInvalidCase)
	case strings.TrimSpace(by) == "":
		return OperativeNote{}, fmt.Errorf("%w: an operative note names its author",
			ErrInvalidCase)
	case in.EstimatedBloodLossML < 0:
		return OperativeNote{}, fmt.Errorf("%w: blood loss is not negative",
			ErrInvalidCase)
	}

	return OperativeNote{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(in.CaseID),
		Version:              1,
		ProcedurePerformed:   strings.TrimSpace(in.ProcedurePerformed),
		Findings:             strings.TrimSpace(in.Findings),
		SpecimenIDs:          trimmedAll(in.SpecimenIDs),
		ImplantIDs:           trimmedAll(in.ImplantIDs),
		Complications:        trimmedAll(in.Complications),
		EstimatedBloodLossML: in.EstimatedBloodLossML,
		PostOperativeOrders:  strings.TrimSpace(in.PostOperativeOrders),
		Narrative:            strings.TrimSpace(in.Narrative),
		Status:               NoteDraft,
		AuthoredBy:           strings.TrimSpace(by),
		AuthoredAt:           now.UTC(),
	}, nil
}

// Sign asserts the note (SRS-OT-009).
func (n *OperativeNote) Sign(by string, at time.Time) error {
	switch {
	case n.Status != NoteDraft:
		return fmt.Errorf("%w: this note is already %s", ErrInvalidCase, n.Status)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: signing names who signed", ErrInvalidCase)
	}
	n.Status, n.SignedBy, n.SignedAt = NoteSigned, strings.TrimSpace(by), at.UTC()
	return nil
}

// Amend produces a new version of a signed note (SRS-OT-009).
//
// The original is not changed. This returns the replacement and the caller
// marks the original superseded, which keeps both in the record: an operative
// note whose history was overwritten cannot answer what was written on the day.
func (n OperativeNote) Amend(id string, in NewNoteInput, reason, by string,
	now time.Time) (OperativeNote, error) {

	switch {
	case n.Status != NoteSigned && n.Status != NoteAmended:
		return OperativeNote{}, fmt.Errorf(
			"%w: only a signed note is amended; an unsigned one is edited",
			ErrInvalidCase)
	case strings.TrimSpace(reason) == "":
		return OperativeNote{}, fmt.Errorf(
			"%w: amending an operative note needs a reason", ErrInvalidCase)
	}

	in.CaseID = n.CaseID
	amended, err := NewOperativeNote(id, n.TenantID, in, by, now)
	if err != nil {
		return OperativeNote{}, err
	}
	amended.Version = n.Version + 1
	amended.Supersedes = n.ID
	amended.AmendmentReason = strings.TrimSpace(reason)
	amended.Status = NoteAmended
	amended.SignedBy, amended.SignedAt = strings.TrimSpace(by), now.UTC()
	return amended, nil
}

// Consumables and implants (SRS-OT-010).

// UsageKind separates what is thrown away from what stays in the patient.
type UsageKind string

const (
	UsageConsumable UsageKind = "consumable"
	// UsageImplant stays in the patient. Serial and lot are mandatory for one,
	// because an implant recall is traced patient by patient and an implant
	// with no serial is one nobody can find.
	UsageImplant UsageKind = "implant"
)

// Usage is one item used in a case (SRS-OT-010).
type Usage struct {
	ID       string
	TenantID string
	CaseID   string

	Kind         UsageKind
	ItemCode     string
	ItemName     string
	LotNumber    string
	SerialNumber string
	Quantity     int
	// ExpiryDate matters for an implant and for a sterile consumable.
	ExpiryDate time.Time

	// Scanned records that the item was read by barcode rather than typed.
	// SRS-OT-010's clause is "inventory decrement and patient charge are
	// traceable to scan", and a typed item is traceable to somebody's memory.
	Scanned bool
	// ScanData is the raw barcode, kept so a decode that turns out wrong can
	// be re-read rather than guessed at.
	ScanData string

	RecordedAt time.Time
	RecordedBy string
}

// NewUsageInput is one item used.
type NewUsageInput struct {
	CaseID       string
	Kind         UsageKind
	ItemCode     string
	ItemName     string
	LotNumber    string
	SerialNumber string
	Quantity     int
	ExpiryDate   time.Time
	Scanned      bool
	ScanData     string
}

// RecordUsage records a consumable or implant (SRS-OT-010).
func RecordUsage(id, tenantID string, in NewUsageInput, by string, now time.Time) (
	Usage, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.CaseID) == "":
		return Usage{}, fmt.Errorf("%w: a usage belongs to a case", ErrInvalidCase)
	case strings.TrimSpace(in.ItemCode) == "":
		return Usage{}, fmt.Errorf("%w: a usage names the item", ErrInvalidCase)
	case in.Quantity <= 0:
		return Usage{}, fmt.Errorf("%w: a usage is a positive quantity", ErrInvalidCase)
	case strings.TrimSpace(by) == "":
		return Usage{}, fmt.Errorf("%w: a usage names who recorded it", ErrInvalidCase)
	}

	kind := in.Kind
	if kind == "" {
		kind = UsageConsumable
	}
	if kind != UsageConsumable && kind != UsageImplant {
		return Usage{}, fmt.Errorf("%w: unknown usage kind %q", ErrInvalidCase, kind)
	}

	if kind == UsageImplant {
		// A recall is traced patient by patient. An implant with no serial and
		// no lot is one nobody can find when the manufacturer writes.
		if strings.TrimSpace(in.SerialNumber) == "" &&
			strings.TrimSpace(in.LotNumber) == "" {
			return Usage{}, fmt.Errorf(
				"%w: an implant records its serial or lot number; a recall is traced by it",
				ErrInvalidCase)
		}
		if in.Quantity != 1 {
			// Two implants are two rows, each with its own serial. A quantity
			// of two against one serial is a record that cannot be traced.
			return Usage{}, fmt.Errorf(
				"%w: record implants one at a time, each with its own identifier",
				ErrInvalidCase)
		}
	}

	return Usage{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(in.CaseID),
		Kind: kind, ItemCode: strings.TrimSpace(in.ItemCode),
		ItemName:     strings.TrimSpace(in.ItemName),
		LotNumber:    strings.TrimSpace(in.LotNumber),
		SerialNumber: strings.TrimSpace(in.SerialNumber),
		Quantity:     in.Quantity, ExpiryDate: in.ExpiryDate.UTC(),
		Scanned: in.Scanned, ScanData: strings.TrimSpace(in.ScanData),
		RecordedAt: now.UTC(), RecordedBy: strings.TrimSpace(by),
	}, nil
}

// Expired reports an item used past its expiry date.
//
// Reported rather than refused. An expired item used in an emergency is a
// governance event that has to be recorded, and refusing to record it is how
// it stops being recorded.
func (u Usage) Expired(at time.Time) bool {
	return !u.ExpiryDate.IsZero() && at.After(u.ExpiryDate)
}

// Specimens (SRS-OT-011).

// Specimen is tissue taken in theatre (SRS-OT-011).
//
// The chain starts here, with the patient and the site, and continues into the
// diagnostics context through the order it raises. A specimen whose site was
// recorded later, from memory, is the one that comes back reported against the
// wrong side.
type Specimen struct {
	ID        string
	TenantID  string
	CaseID    string
	PatientID string

	// Label is what is written on the pot.
	Label string
	// Site and Laterality come from the case rather than being retyped, so a
	// left-sided case cannot produce a right-sided specimen.
	Site       string
	Laterality Laterality
	Container  string
	// Fixative is formalin, fresh, or whatever the request needs. Recorded
	// because a specimen in the wrong fixative cannot be processed and nobody
	// discovers it until the laboratory opens the pot.
	Fixative string

	// OrderID is the diagnostic order this specimen was raised against. Set
	// once the orders context has accepted it; empty means the chain has not
	// started, which is what the outstanding list looks for.
	OrderID string

	TakenAt time.Time
	TakenBy string
}

// NewSpecimenInput is one specimen.
type NewSpecimenInput struct {
	CaseID     string
	PatientID  string
	Label      string
	Site       string
	Laterality Laterality
	Container  string
	Fixative   string
	TakenAt    time.Time
}

// TakeSpecimen records a specimen taken in theatre (SRS-OT-011).
func TakeSpecimen(id, tenantID string, in NewSpecimenInput, by string,
	now time.Time) (Specimen, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.CaseID) == "":
		return Specimen{}, fmt.Errorf("%w: a specimen belongs to a case", ErrInvalidCase)
	case strings.TrimSpace(in.PatientID) == "":
		return Specimen{}, fmt.Errorf("%w: a specimen names its patient", ErrInvalidCase)
	case strings.TrimSpace(in.Label) == "":
		return Specimen{}, fmt.Errorf("%w: a specimen has a label", ErrInvalidCase)
	case strings.TrimSpace(in.Site) == "":
		// The site is half of every histology report, and the half that cannot
		// be reconstructed afterwards.
		return Specimen{}, fmt.Errorf("%w: a specimen names the site it came from",
			ErrInvalidCase)
	case strings.TrimSpace(by) == "":
		return Specimen{}, fmt.Errorf("%w: a specimen names who took it", ErrInvalidCase)
	}

	taken := in.TakenAt
	if taken.IsZero() {
		taken = now
	}
	return Specimen{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(in.CaseID),
		PatientID: strings.TrimSpace(in.PatientID),
		Label:     strings.TrimSpace(in.Label), Site: strings.TrimSpace(in.Site),
		Laterality: in.Laterality, Container: strings.TrimSpace(in.Container),
		Fixative: strings.TrimSpace(in.Fixative),
		TakenAt:  taken.UTC(), TakenBy: strings.TrimSpace(by),
	}, nil
}

// Accession links the specimen to the diagnostic order it was raised against.
func (s *Specimen) Accession(orderID string) error {
	if strings.TrimSpace(orderID) == "" {
		return fmt.Errorf("%w: an accession names the order", ErrInvalidCase)
	}
	if s.OrderID != "" {
		return fmt.Errorf("%w: this specimen already has order %s",
			ErrInvalidCase, s.OrderID)
	}
	s.OrderID = strings.TrimSpace(orderID)
	return nil
}

// UnaccessionedSpecimens is the theatre's outstanding chain (SRS-OT-011).
//
// A specimen in a pot with no order is the one found in a fridge on Monday.
func UnaccessionedSpecimens(specimens []Specimen) []Specimen {
	out := make([]Specimen, 0, len(specimens))
	for _, specimen := range specimens {
		if specimen.OrderID == "" {
			out = append(out, specimen)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].TakenAt.Before(out[j].TakenAt)
	})
	return out
}

// Instrument trays (SRS-OT-012).

// TrayUse links a sterile set to the case it was opened for (SRS-OT-012).
//
// The requirement's clause is "used trays/sets can be traced back to
// sterilization cycle", which is a question asked in one direction — an
// infection is investigated backwards from the patient — and answered by
// recording the cycle at the moment the tray is opened. A link made afterwards
// from a paper log is the link that is missing for the case that matters.
type TrayUse struct {
	ID       string
	TenantID string
	CaseID   string

	TrayID   string
	TrayName string
	// CycleID is the sterilisation cycle the tray came out of, which is what
	// CSSD's record is keyed on (SRS-CSSD).
	CycleID string
	// IndicatorPassed is the chemical indicator on the pack, read by the scrub
	// nurse as it is opened. Recorded because it is the last check before the
	// instruments touch the patient.
	IndicatorPassed bool
	IndicatorNote   string

	OpenedAt time.Time
	OpenedBy string
}

// OpenTray records a sterile set being opened for a case (SRS-OT-012).
func OpenTray(id, tenantID, caseID, trayID, trayName, cycleID string,
	indicatorPassed bool, note, by string, now time.Time) (TrayUse, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(caseID) == "":
		return TrayUse{}, fmt.Errorf("%w: a tray use belongs to a case", ErrInvalidCase)
	case strings.TrimSpace(trayID) == "":
		return TrayUse{}, fmt.Errorf("%w: a tray use names the tray", ErrInvalidCase)
	case strings.TrimSpace(cycleID) == "":
		// Without the cycle there is no chain to trace back along, which is
		// the whole of the requirement.
		return TrayUse{}, fmt.Errorf(
			"%w: record the sterilisation cycle the tray came from", ErrInvalidCase)
	case strings.TrimSpace(by) == "":
		return TrayUse{}, fmt.Errorf("%w: a tray use names who opened it",
			ErrInvalidCase)
	case !indicatorPassed && strings.TrimSpace(note) == "":
		// A failed indicator is a governance event. Recording it without
		// saying what happened next is worse than not recording it.
		return TrayUse{}, fmt.Errorf(
			"%w: a failed sterilisation indicator needs a note saying what was done",
			ErrInvalidCase)
	}

	return TrayUse{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(caseID),
		TrayID: strings.TrimSpace(trayID), TrayName: strings.TrimSpace(trayName),
		CycleID:         strings.TrimSpace(cycleID),
		IndicatorPassed: indicatorPassed, IndicatorNote: strings.TrimSpace(note),
		OpenedAt: now.UTC(), OpenedBy: strings.TrimSpace(by),
	}, nil
}

// Preference cards (SRS-OT-016).

// PreferenceCard is a surgeon's usual requirements for a procedure
// (SRS-OT-016).
//
// It seeds a case's requirements and never constrains what is actually used.
// The requirement says so explicitly, and the reason is that a card is a
// convenience that goes stale: a system that refused an instrument because it
// was not on the card would have theatre staff editing cards mid-case.
type PreferenceCard struct {
	ID       string
	TenantID string

	SurgeonID     string
	ProcedureCode string
	Name          string

	// Equipment and Consumables are what the card suggests.
	Equipment   []string
	Consumables []CardItem
	Trays       []string
	Notes       string

	Version   int
	UpdatedAt time.Time
	UpdatedBy string
}

// CardItem is one suggested consumable.
type CardItem struct {
	ItemCode string
	ItemName string
	Quantity int
}

// Seed applies a card's suggestions to a case's requirements (SRS-OT-016).
//
// Additive and never subtractive: a case that already asks for something the
// card does not mention keeps asking for it.
func (p PreferenceCard) Seed(c *Case) {
	existing := map[string]bool{}
	for _, requirement := range c.Requirements {
		existing[strings.ToLower(requirement)] = true
	}
	for _, item := range p.Equipment {
		if !existing[strings.ToLower(item)] {
			c.Requirements = append(c.Requirements, item)
			existing[strings.ToLower(item)] = true
		}
	}
	sort.Strings(c.Requirements)
}
