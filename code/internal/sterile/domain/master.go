// Package domain holds the sterile services rules (SRS-CSSD-001 … 012).
//
// No infrastructure: the rules here are the ones a CSSD technician would
// recognise as theirs, and they are testable without a database (FIT-01).
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidSet refuses a sterile services record that could not be true.
var ErrInvalidSet = errors.New("sterile: invalid")

// Instrument is one item in the instrument master (SRS-CSSD-001).
//
// Individually identified where the deployment tracks it that way, and
// counted where it does not. Both exist in a real department: a
// laparoscope has a serial number and a mosquito forcep is one of forty.
type Instrument struct {
	ID       string
	TenantID string

	// Code is the catalogue code — what a packing list names.
	Code    string
	Display string
	// SerialNumber identifies one physical instrument, where the department
	// tracks them singly. Empty for a consumable-grade item counted in bulk,
	// which is not a gap: SRS-CSSD-012's lifecycle history is only possible
	// for the ones that have one, and claiming otherwise would produce a
	// repair history for a class rather than an object.
	SerialNumber string

	Status InstrumentStatus
	// Location is where it was last seen — a tray, a store, a repair vendor.
	Location string

	AcquiredOn time.Time
	// RetiredOn closes an instrument's life. A retired instrument cannot be
	// packed, which is what stops a broken one returning to a tray.
	RetiredOn time.Time
	Notes     string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// InstrumentStatus is where one instrument is in its life (SRS-CSSD-012).
type InstrumentStatus string

const (
	InstrumentInService InstrumentStatus = "in_service"
	// InstrumentInRepair is away being mended. It cannot be packed, and the
	// count on every tray it belongs to is short until it comes back.
	InstrumentInRepair InstrumentStatus = "in_repair"
	// InstrumentMissing is unaccounted for. Distinct from retired, because a
	// missing instrument may be inside a patient, and the count that found it
	// missing is the one that says so.
	InstrumentMissing InstrumentStatus = "missing"
	InstrumentRetired InstrumentStatus = "retired"
)

var knownInstrumentStatuses = map[InstrumentStatus]bool{
	InstrumentInService: true, InstrumentInRepair: true,
	InstrumentMissing: true, InstrumentRetired: true,
}

// Packable reports an instrument that may go into a tray.
func (s InstrumentStatus) Packable() bool { return s == InstrumentInService }

// NewInstrumentInput registers one instrument.
type NewInstrumentInput struct {
	Code         string
	Display      string
	SerialNumber string
	Location     string
	AcquiredOn   time.Time
	Notes        string
}

// NewInstrument registers an instrument (SRS-CSSD-001).
func NewInstrument(id, tenantID string, in NewInstrumentInput, by string,
	now time.Time) (Instrument, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Instrument{}, fmt.Errorf("%w: an instrument needs an id", ErrInvalidSet)
	case strings.TrimSpace(in.Code) == "":
		// The catalogue code, which is what a packing list names. Without it
		// an instrument cannot be checked against the list it belongs on.
		return Instrument{}, fmt.Errorf("%w: an instrument needs a catalogue code",
			ErrInvalidSet)
	case strings.TrimSpace(by) == "":
		return Instrument{}, fmt.Errorf("%w: an instrument names who registered it",
			ErrInvalidSet)
	}

	return Instrument{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Display: strings.TrimSpace(in.Display),
		SerialNumber: strings.TrimSpace(in.SerialNumber),
		Status:       InstrumentInService,
		Location:     strings.TrimSpace(in.Location),
		AcquiredOn:   in.AcquiredOn.UTC(),
		Notes:        strings.TrimSpace(in.Notes),
		CreatedAt:    now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Move changes an instrument's status (SRS-CSSD-012).
func (i *Instrument) Move(to InstrumentStatus, note string,
	now time.Time) error {

	switch {
	case !knownInstrumentStatuses[to]:
		return fmt.Errorf("%w: unknown instrument status %q", ErrInvalidSet, to)
	case i.Status == InstrumentRetired:
		return fmt.Errorf("%w: this instrument has been retired", ErrInvalidSet)
	case to != InstrumentInService && strings.TrimSpace(note) == "":
		// Going out of service is the event a replacement or loss analysis
		// reads. A status change with no reason is a number in a report
		// nobody can act on.
		return fmt.Errorf("%w: say why this instrument is %s", ErrInvalidSet, to)
	}

	i.Status = to
	if note != "" {
		i.Notes = strings.TrimSpace(note)
	}
	if to == InstrumentRetired {
		i.RetiredOn = now.UTC()
	}
	return nil
}

// PackingItem is one line of a tray's packing list (SRS-CSSD-001).
type PackingItem struct {
	// Code is the catalogue code, matched against the instruments packed.
	Code    string
	Display string
	// Quantity is how many of it the tray holds. A tray is checked against
	// this at assembly and again at the count after the case.
	Quantity int
	// Critical marks an item the tray cannot go out without. A missing
	// retractor is a delay; a missing blade handle is a cancelled case.
	Critical bool
}

// TraySet is a tray, set or container in the master (SRS-CSSD-001).
//
// Versioned rather than edited. The requirement's clause is "set
// composition/version is traceable", and a tray packed last month was packed
// against the list as it was then: overwriting the list makes every historical
// pack unauditable against the only thing that could audit it.
type TraySet struct {
	ID       string
	TenantID string

	Code    string
	Display string
	// Kind distinguishes a tray from a single-item peel pack from a rigid
	// container, which have different handling and different expiries.
	Kind string

	Version int
	// Supersedes is the version this replaces, so the chain reads backwards.
	Supersedes string
	// Items is the packing list at this version.
	Items []PackingItem
	// ShelfLife is how long a pack of this set stays sterile once processed.
	// Zero means the deployment's default applies, which the application
	// supplies: a set with no expiry policy at all is refused at packing.
	ShelfLife time.Duration

	CreatedAt time.Time
	CreatedBy string
	// SupersededAt closes a version.
	SupersededAt time.Time
}

// Current reports the version in force.
func (t TraySet) Current() bool { return t.SupersededAt.IsZero() }

// CriticalItems returns the codes a pack cannot go out without.
func (t TraySet) CriticalItems() []string {
	var out []string
	for _, item := range t.Items {
		if item.Critical {
			out = append(out, item.Code)
		}
	}
	sort.Strings(out)
	return out
}

// Expected returns the packing list as code-to-quantity.
func (t TraySet) Expected() map[string]int {
	out := make(map[string]int, len(t.Items))
	for _, item := range t.Items {
		out[item.Code] += item.Quantity
	}
	return out
}

// NewTraySetInput defines a tray.
type NewTraySetInput struct {
	Code      string
	Display   string
	Kind      string
	Items     []PackingItem
	ShelfLife time.Duration
}

// NewTraySet defines the first version of a tray (SRS-CSSD-001).
func NewTraySet(id, tenantID string, in NewTraySetInput, by string,
	now time.Time) (TraySet, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return TraySet{}, fmt.Errorf("%w: a set needs an id", ErrInvalidSet)
	case strings.TrimSpace(in.Code) == "":
		return TraySet{}, fmt.Errorf("%w: a set needs a code", ErrInvalidSet)
	case strings.TrimSpace(by) == "":
		return TraySet{}, fmt.Errorf("%w: a set names who defined it", ErrInvalidSet)
	}

	items, err := checkedItems(in.Items)
	if err != nil {
		return TraySet{}, err
	}

	return TraySet{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Display: strings.TrimSpace(in.Display),
		Kind: strings.TrimSpace(in.Kind), Version: 1, Items: items,
		ShelfLife: in.ShelfLife,
		CreatedAt: now.UTC(), CreatedBy: strings.TrimSpace(by),
	}, nil
}

func checkedItems(in []PackingItem) ([]PackingItem, error) {
	if len(in) == 0 {
		// A set with no packing list cannot be assembled against anything, and
		// every count after it would pass.
		return nil, fmt.Errorf("%w: a set has a packing list", ErrInvalidSet)
	}

	seen := map[string]bool{}
	out := make([]PackingItem, 0, len(in))
	for _, item := range in {
		code := strings.TrimSpace(item.Code)
		switch {
		case code == "":
			return nil, fmt.Errorf("%w: a packing list line names an item",
				ErrInvalidSet)
		case seen[code]:
			// Two lines for one code would make the expected count ambiguous,
			// and the count after a case is what finds an instrument left in
			// a patient.
			return nil, fmt.Errorf("%w: %q appears twice on the packing list",
				ErrInvalidSet, code)
		case item.Quantity <= 0:
			return nil, fmt.Errorf("%w: %q is on the list with no quantity",
				ErrInvalidSet, code)
		}
		seen[code] = true
		out = append(out, PackingItem{
			Code: code, Display: strings.TrimSpace(item.Display),
			Quantity: item.Quantity, Critical: item.Critical,
		})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Code < out[j].Code })
	return out, nil
}

// Revise produces the next version of a set (SRS-CSSD-001).
//
// The earlier version is not changed. A tray packed against it was packed
// against the list as it was then, and the pack record names the version it
// was assembled from.
func (t TraySet) Revise(id string, in NewTraySetInput, by string,
	now time.Time) (TraySet, error) {

	if !t.Current() {
		return TraySet{}, fmt.Errorf(
			"%w: this version has already been superseded", ErrInvalidSet)
	}
	in.Code = t.Code

	next, err := NewTraySet(id, t.TenantID, in, by, now)
	if err != nil {
		return TraySet{}, err
	}
	next.Version, next.Supersedes = t.Version+1, t.ID
	return next, nil
}

// CurrentSet returns the version in force from a set's history.
func CurrentSet(all []TraySet) (TraySet, bool) {
	var best TraySet
	found := false
	for _, set := range all {
		if !set.Current() {
			continue
		}
		if !found || set.Version > best.Version {
			best, found = set, true
		}
	}
	return best, found
}
