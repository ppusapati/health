// Package domain holds the biomedical engineering and asset maintenance rules
// (SRS-BIO-001 … 011).
//
// No infrastructure: the rules here are the ones a biomedical engineer would
// recognise as theirs, and they are testable without a database (FIT-01).
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidAsset refuses an equipment record that could not be true.
var ErrInvalidAsset = errors.New("biomedical: invalid")

// Criticality is what happens to a patient when this asset stops
// (SRS-BIO-001).
//
// Not a priority and not a cost band. It is the question a hospital answers
// once per asset and then uses to decide how fast a breakdown is answered, how
// often it is inspected, and whether a list can go ahead without it.
type Criticality string

const (
	// CriticalityRoutine is equipment a department works around for a day.
	CriticalityRoutine Criticality = "routine"
	// CriticalityImportant stops a service if it is out for long.
	CriticalityImportant Criticality = "important"
	// CriticalityCritical stops a service now: the only image intensifier, the
	// theatre's laminar flow.
	CriticalityCritical Criticality = "critical"
	// CriticalityLifeSupport is equipment a patient is alive because of. It is
	// distinct from critical because the response is different in kind: a
	// ventilator failing is not a delayed list.
	CriticalityLifeSupport Criticality = "life_support"
)

var knownCriticality = map[Criticality]bool{
	CriticalityRoutine: true, CriticalityImportant: true,
	CriticalityCritical: true, CriticalityLifeSupport: true,
}

// Rank orders criticality for triage and reporting.
//
// Higher is more urgent. A method rather than an ordered constant list,
// because the wire enum and the domain constant are allowed to diverge and a
// numeric constant on the type would make that divergence silent.
func (c Criticality) Rank() int {
	switch c {
	case CriticalityLifeSupport:
		return 4
	case CriticalityCritical:
		return 3
	case CriticalityImportant:
		return 2
	case CriticalityRoutine:
		return 1
	default:
		return 0
	}
}

// AssetStatus is where a piece of equipment is in its life (SRS-BIO-001,
// SRS-BIO-011).
type AssetStatus string

const (
	AssetInService AssetStatus = "in_service"
	// AssetUnderMaintenance is being worked on. Counted, located, and not
	// usable.
	AssetUnderMaintenance AssetStatus = "under_maintenance"
	// AssetAwaitingParts is broken and waiting. Distinct from under
	// maintenance because the wait is the vendor's and the escalation is
	// different.
	AssetAwaitingParts AssetStatus = "awaiting_parts"
	// AssetOutOfService is withdrawn but still owned — condemned, or held
	// pending a decision.
	AssetOutOfService AssetStatus = "out_of_service"
	// AssetDecommissioned has been approved for disposal and is awaiting it.
	AssetDecommissioned AssetStatus = "decommissioned"
	// AssetDisposed has left the hospital. SRS-BIO-011's clause is that a
	// disposed asset cannot be assigned for use, and this is the state that
	// says so.
	AssetDisposed AssetStatus = "disposed"
)

var knownAssetStatus = map[AssetStatus]bool{
	AssetInService: true, AssetUnderMaintenance: true,
	AssetAwaitingParts: true, AssetOutOfService: true,
	AssetDecommissioned: true, AssetDisposed: true,
}

// Retired reports a status the asset never comes back from.
func (s AssetStatus) Retired() bool {
	return s == AssetDecommissioned || s == AssetDisposed
}

// Working reports a status in which the asset could be used, before calibration
// and safety holds are considered.
//
// Deliberately not called Usable: whether an asset may actually be used is
// Asset.Usable, which also weighs an expired calibration and an open safety
// notice. Two names because they are two questions, and collapsing them is how
// an uncalibrated ventilator gets offered to a list.
func (s AssetStatus) Working() bool { return s == AssetInService }

// Asset is one piece of equipment (SRS-BIO-001).
type Asset struct {
	ID       string
	TenantID string

	// Tag is the hospital's own asset number, unique within the tenant. What a
	// sticker on the machine says and what a service request names.
	Tag string
	// UDI is the Unique Device Identifier where the manufacturer issues one,
	// and Serial is theirs. Both, because a recall is announced by one or the
	// other and a hospital does not get to choose which.
	UDI    string
	Serial string

	Make     string
	Model    string
	Category string

	Criticality Criticality
	Status      AssetStatus

	// LocationID is where it is. A ward, a theatre room, a store. What
	// SRS-BIO-009's link to scheduling runs along: a room's equipment is the
	// assets standing in it.
	LocationID string
	// Department owns it, which is who is asked when it goes missing and whose
	// budget replaces it.
	Department string

	// Capabilities are what this asset lets a room do — "image_intensifier",
	// "laminar_flow". The vocabulary SRS-OT's rooms already match a case's
	// requirements against, so an asset out of service can subtract from it.
	Capabilities []string

	AcquiredOn time.Time
	// AcquisitionCostMinor is in minor units and an integer, never a float:
	// depreciation and replacement analysis add these up.
	AcquisitionCostMinor int64
	ExpectedLifeYears    int

	// CalibrationRequired marks an asset whose readings are only meaningful if
	// it has been calibrated (SRS-BIO-004).
	CalibrationRequired bool
	// CalibrationDue is when the current certificate lapses. Zero where none
	// is required, and refused where one is.
	CalibrationDue time.Time
	// CalibrationCertificate is the reference an auditor asks for.
	CalibrationCertificate string

	// SafetyHold marks an asset stopped by a recall or safety notice
	// (SRS-BIO-008). Separate from status because the asset may be perfectly
	// serviceable and still must not be used.
	SafetyHold       bool
	SafetyHoldReason string

	Notes     string
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewAssetInput registers a piece of equipment.
type NewAssetInput struct {
	Tag                  string
	UDI                  string
	Serial               string
	Make                 string
	Model                string
	Category             string
	Criticality          Criticality
	LocationID           string
	Department           string
	Capabilities         []string
	AcquiredOn           time.Time
	AcquisitionCostMinor int64
	ExpectedLifeYears    int
	CalibrationRequired  bool
	CalibrationDue       time.Time
	Notes                string
}

// NewAsset registers a piece of equipment (SRS-BIO-001).
func NewAsset(id, tenantID string, in NewAssetInput, by string,
	now time.Time) (Asset, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Asset{}, fmt.Errorf("%w: an asset needs an id", ErrInvalidAsset)
	case strings.TrimSpace(in.Tag) == "":
		// The number on the sticker. Without it a service request names
		// nothing a engineer can walk to.
		return Asset{}, fmt.Errorf("%w: an asset needs a tag", ErrInvalidAsset)
	case strings.TrimSpace(in.Make) == "" || strings.TrimSpace(in.Model) == "":
		// A recall is announced against a make and model. An asset with
		// neither cannot be found by one.
		return Asset{}, fmt.Errorf("%w: an asset names its make and model",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return Asset{}, fmt.Errorf("%w: an asset names who registered it",
			ErrInvalidAsset)
	case in.AcquisitionCostMinor < 0:
		return Asset{}, fmt.Errorf("%w: an acquisition cost is not negative",
			ErrInvalidAsset)
	}

	criticality := in.Criticality
	if criticality == "" {
		// Routine rather than critical. Defaulting the other way would make
		// every breakdown urgent, which means none is, and a hospital that
		// never sets the field would find its escalation matrix useless.
		criticality = CriticalityRoutine
	}
	if !knownCriticality[criticality] {
		return Asset{}, fmt.Errorf("%w: unknown criticality %q",
			ErrInvalidAsset, criticality)
	}

	if in.CalibrationRequired && in.CalibrationDue.IsZero() {
		// An asset that needs calibrating and has no due date never comes due,
		// which is the one direction that lets an uncalibrated machine stay in
		// service for ever.
		return Asset{}, fmt.Errorf(
			"%w: %s requires calibration; say when it is next due",
			ErrInvalidAsset, in.Tag)
	}
	if !in.CalibrationRequired && !in.CalibrationDue.IsZero() {
		// A due date on an asset nobody calibrates is a reminder that will be
		// dismissed every month until people stop reading them.
		return Asset{}, fmt.Errorf(
			"%w: %s has a calibration date but is not marked as requiring one",
			ErrInvalidAsset, in.Tag)
	}

	return Asset{
		ID: id, TenantID: tenantID,
		Tag: strings.TrimSpace(in.Tag), UDI: strings.TrimSpace(in.UDI),
		Serial: strings.TrimSpace(in.Serial),
		Make:   strings.TrimSpace(in.Make), Model: strings.TrimSpace(in.Model),
		Category:    strings.TrimSpace(in.Category),
		Criticality: criticality, Status: AssetInService,
		LocationID:           strings.TrimSpace(in.LocationID),
		Department:           strings.TrimSpace(in.Department),
		Capabilities:         normalise(in.Capabilities),
		AcquiredOn:           in.AcquiredOn.UTC(),
		AcquisitionCostMinor: in.AcquisitionCostMinor,
		ExpectedLifeYears:    in.ExpectedLifeYears,
		CalibrationRequired:  in.CalibrationRequired,
		CalibrationDue:       in.CalibrationDue.UTC(),
		Notes:                strings.TrimSpace(in.Notes),
		CreatedAt:            now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// CalibrationExpired reports an asset past its certificate (SRS-BIO-004).
func (a Asset) CalibrationExpired(now time.Time) bool {
	return a.CalibrationRequired && !a.CalibrationDue.IsZero() &&
		!now.Before(a.CalibrationDue)
}

// Unusable names every reason this asset may not be used right now.
//
// Every reason, not the first. An engineer told one at a time fixes the
// calibration, brings the machine back, and discovers the safety notice.
func (a Asset) Unusable(now time.Time, blockOnCalibration bool) []string {
	var out []string
	if a.Status == AssetDisposed {
		out = append(out, "this asset has been disposed of")
	} else if a.Status.Retired() {
		out = append(out, "this asset has been decommissioned")
	} else if !a.Status.Working() {
		out = append(out, "this asset is "+strings.ReplaceAll(
			string(a.Status), "_", " "))
	}
	if a.SafetyHold {
		out = append(out, "safety notice: "+a.SafetyHoldReason)
	}
	if blockOnCalibration && a.CalibrationExpired(now) {
		// SRS-BIO-004's "can block use by policy". Whether a hospital stops a
		// machine with a lapsed certificate is its decision; that the decision
		// is applied consistently is not.
		out = append(out, "calibration expired on "+
			a.CalibrationDue.Format("2006-01-02"))
	}
	return out
}

// Usable reports an asset that may be used now (SRS-BIO-004, SRS-BIO-008,
// SRS-BIO-011).
func (a Asset) Usable(now time.Time, blockOnCalibration bool) bool {
	return len(a.Unusable(now, blockOnCalibration)) == 0
}

// Move changes an asset's status (SRS-BIO-001).
//
// A disposed asset never moves again. That is the whole of SRS-BIO-011's
// "disposed asset cannot be assigned for use": not a check at the point of
// assignment, which somebody would forget, but a state the record cannot leave.
func (a *Asset) Move(to AssetStatus, note string, now time.Time) error {
	switch {
	case !knownAssetStatus[to]:
		return fmt.Errorf("%w: unknown asset status %q", ErrInvalidAsset, to)
	case a.Status == AssetDisposed:
		return fmt.Errorf("%w: this asset has been disposed of", ErrInvalidAsset)
	case to == AssetDisposed:
		// Disposal is its own use case, because it needs an approval and
		// sanitisation evidence. Reaching it through a status change would
		// step round both.
		return fmt.Errorf(
			"%w: disposal is recorded with its approval, not as a status change",
			ErrInvalidAsset)
	case to != AssetInService && strings.TrimSpace(note) == "":
		// Taking equipment out of service is the event a replacement analysis
		// reads. A status change with no reason is a number nobody can act on.
		return fmt.Errorf("%w: say why this asset is %s", ErrInvalidAsset, to)
	case a.Status == AssetDecommissioned && to != AssetOutOfService:
		// A decommissioned asset can be un-decommissioned only back to the
		// shelf, never straight into service: whatever made it unfit has to be
		// re-examined first.
		return fmt.Errorf(
			"%w: a decommissioned asset returns to out-of-service first",
			ErrInvalidAsset)
	}

	a.Status = to
	if note != "" {
		a.Notes = strings.TrimSpace(note)
	}
	return nil
}

// Calibrate records a certificate and the next due date (SRS-BIO-004).
func (a *Asset) Calibrate(certificate string, due time.Time,
	now time.Time) error {

	switch {
	case !a.CalibrationRequired:
		return fmt.Errorf("%w: %s is not marked as requiring calibration",
			ErrInvalidAsset, a.Tag)
	case strings.TrimSpace(certificate) == "":
		// The certificate is what an auditor asks for. A calibration recorded
		// without one is a date somebody typed.
		return fmt.Errorf("%w: a calibration records its certificate",
			ErrInvalidAsset)
	case due.IsZero() || !due.After(now):
		// A due date in the past would mark the asset expired the moment it
		// was calibrated.
		return fmt.Errorf("%w: a calibration is next due in the future",
			ErrInvalidAsset)
	}

	a.CalibrationCertificate = strings.TrimSpace(certificate)
	a.CalibrationDue = due.UTC()
	return nil
}

// Hold stops an asset under a safety notice (SRS-BIO-008).
func (a *Asset) Hold(reason string) error {
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: a safety hold says why", ErrInvalidAsset)
	}
	a.SafetyHold, a.SafetyHoldReason = true, strings.TrimSpace(reason)
	return nil
}

// Clear lifts a safety hold (SRS-BIO-008).
func (a *Asset) Clear() error {
	if !a.SafetyHold {
		return fmt.Errorf("%w: this asset is not held", ErrInvalidAsset)
	}
	a.SafetyHold, a.SafetyHoldReason = false, ""
	return nil
}

// AvailableCapabilities is what a location can actually do right now
// (SRS-BIO-009).
//
// The answer SRS-OT's room matching needs. A room lists an image intensifier
// because one stands in it; if that one is broken, held or uncalibrated, the
// room cannot do image-intensified work, and a scheduler offering the slot is
// offering something the hospital cannot deliver. The requirement's acceptance
// is exactly this: unavailable equipment cannot be falsely shown as
// schedulable.
//
// Capabilities are counted rather than flagged, because a theatre with two
// intensifiers loses nothing when one goes for service.
func AvailableCapabilities(assets []Asset, locationID string, now time.Time,
	blockOnCalibration bool) map[string]int {

	out := map[string]int{}
	for _, asset := range assets {
		if asset.LocationID != locationID {
			continue
		}
		if !asset.Usable(now, blockOnCalibration) {
			continue
		}
		for _, capability := range asset.Capabilities {
			out[capability]++
		}
	}
	return out
}

// UnavailableCapabilities names what a location claims and cannot deliver
// (SRS-BIO-009).
//
// The difference between the capabilities standing in a room and the ones
// working. Returned as a list rather than a set difference computed by the
// caller, so every client asks the question the same way.
func UnavailableCapabilities(assets []Asset, locationID string, now time.Time,
	blockOnCalibration bool) []string {

	working := AvailableCapabilities(assets, locationID, now, blockOnCalibration)

	present := map[string]bool{}
	for _, asset := range assets {
		if asset.LocationID != locationID || asset.Status == AssetDisposed {
			continue
		}
		for _, capability := range asset.Capabilities {
			present[capability] = true
		}
	}

	var out []string
	for capability := range present {
		if working[capability] == 0 {
			out = append(out, capability)
		}
	}
	sort.Strings(out)
	return out
}

// normalise trims, de-duplicates and orders a code list.
func normalise(in []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, value := range in {
		trimmed := strings.TrimSpace(value)
		if trimmed == "" || seen[trimmed] {
			continue
		}
		seen[trimmed] = true
		out = append(out, trimmed)
	}
	sort.Strings(out)
	return out
}
