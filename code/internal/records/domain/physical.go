package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// PhysicalState is where a paper record is (SRS-MRD-006).
type PhysicalState string

const (
	// PhysicalFiled is in the record library, where it belongs.
	PhysicalFiled PhysicalState = "filed"
	// PhysicalOut is with somebody.
	PhysicalOut PhysicalState = "checked_out"
	// PhysicalArchived has gone to off-site storage.
	PhysicalArchived PhysicalState = "archived"
	// PhysicalDestroyed has been disposed of under a retention rule. The row
	// stays: a hospital has to be able to say that a record existed and was
	// destroyed lawfully, which is a different answer from never having had
	// it.
	PhysicalDestroyed PhysicalState = "destroyed"
	// PhysicalMissing is the honest state for a record nobody can find. Named
	// rather than left as "checked out to somebody who left in 2019", because
	// a record library that cannot say what it has lost does not know what it
	// has.
	PhysicalMissing PhysicalState = "missing"
)

var knownPhysicalState = map[PhysicalState]bool{
	PhysicalFiled: true, PhysicalOut: true, PhysicalArchived: true,
	PhysicalDestroyed: true, PhysicalMissing: true,
}

// PhysicalRecord is one paper volume (SRS-MRD-006).
type PhysicalRecord struct {
	ID       string
	TenantID string

	// Reference is what is written on the folder.
	Reference string
	PatientID string
	// Volume distinguishes the second folder of a long history.
	Volume       int
	RecordClass  string
	Jurisdiction string
	Description  string

	State PhysicalState
	// HomeLocation is where it lives when it is filed — the shelf, the bay.
	HomeLocation string
	// CurrentLocation and Custodian are where it is now and who has it.
	// SRS-MRD-006's acceptance names both, and the custodian is the half that
	// gets a record back.
	CurrentLocation string
	Custodian       string
	CheckedOutAt    time.Time
	CheckedOutBy    string
	DueBackAt       time.Time
	Purpose         string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewPhysicalRecordInput registers a paper volume.
type NewPhysicalRecordInput struct {
	Reference    string
	PatientID    string
	Volume       int
	RecordClass  string
	Jurisdiction string
	Description  string
	HomeLocation string
}

// RegisterPhysicalRecord records a paper volume the hospital holds
// (SRS-MRD-006).
func RegisterPhysicalRecord(id, tenantID string, in NewPhysicalRecordInput,
	by string, now time.Time) (PhysicalRecord, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return PhysicalRecord{}, fmt.Errorf("%w: a record needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Reference) == "":
		// The reference is what is written on the folder, and it is how
		// somebody at a shelf finds it.
		return PhysicalRecord{}, fmt.Errorf(
			"%w: a physical record needs the reference on its folder",
			ErrInvalidRecord)
	case strings.TrimSpace(in.PatientID) == "":
		return PhysicalRecord{}, fmt.Errorf("%w: a record names its patient",
			ErrInvalidRecord)
	case strings.TrimSpace(in.HomeLocation) == "":
		return PhysicalRecord{}, fmt.Errorf(
			"%w: a record names where it is filed", ErrInvalidRecord)
	case in.Volume < 0:
		return PhysicalRecord{}, fmt.Errorf("%w: a volume number is positive",
			ErrInvalidRecord)
	}

	volume := in.Volume
	if volume == 0 {
		volume = 1
	}
	return PhysicalRecord{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference), PatientID: in.PatientID,
		Volume:          volume,
		RecordClass:     strings.TrimSpace(in.RecordClass),
		Jurisdiction:    strings.TrimSpace(in.Jurisdiction),
		Description:     strings.TrimSpace(in.Description),
		State:           PhysicalFiled,
		HomeLocation:    strings.TrimSpace(in.HomeLocation),
		CurrentLocation: strings.TrimSpace(in.HomeLocation),
		CreatedAt:       now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// CheckOut records a record leaving the library (SRS-MRD-006).
//
// A record already out cannot be checked out again. That refusal is the
// point: two people each believing they have the notes is how a record goes
// missing, and the second request has to become a wait rather than a second
// custodian.
func (p *PhysicalRecord) CheckOut(custodian, location, purpose string,
	dueBack time.Time, by string, now time.Time) error {

	switch {
	case p.State == PhysicalOut:
		return fmt.Errorf("%w: this record is already with %s at %s",
			ErrInvalidRecord, p.Custodian, p.CurrentLocation)
	case p.State != PhysicalFiled && p.State != PhysicalArchived:
		return fmt.Errorf("%w: this record is %s", ErrInvalidRecord, p.State)
	case strings.TrimSpace(custodian) == "":
		// A record out to "the ward" is a record nobody has to give back.
		return fmt.Errorf("%w: a record goes out to a named custodian",
			ErrInvalidRecord)
	case strings.TrimSpace(location) == "":
		return fmt.Errorf("%w: say where the record is going",
			ErrInvalidRecord)
	case strings.TrimSpace(purpose) == "":
		return fmt.Errorf("%w: say what the record is wanted for",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a check-out names who issued it",
			ErrInvalidRecord)
	case !dueBack.IsZero() && !dueBack.After(now):
		return fmt.Errorf("%w: a record cannot be due back before it goes out",
			ErrInvalidRecord)
	}

	p.State = PhysicalOut
	p.Custodian = custodian
	p.CurrentLocation = strings.TrimSpace(location)
	p.Purpose = strings.TrimSpace(purpose)
	p.CheckedOutAt, p.CheckedOutBy = now.UTC(), by
	p.DueBackAt = utcOrZero(dueBack)
	return nil
}

// CheckIn records a record coming back (SRS-MRD-006).
func (p *PhysicalRecord) CheckIn(location, by string, now time.Time) error {
	switch {
	case p.State != PhysicalOut && p.State != PhysicalMissing:
		return fmt.Errorf("%w: this record is %s and not out",
			ErrInvalidRecord, p.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a check-in names who received it",
			ErrInvalidRecord)
	}

	filed := strings.TrimSpace(location)
	if filed == "" {
		filed = p.HomeLocation
	}
	p.State = PhysicalFiled
	p.CurrentLocation, p.HomeLocation = filed, filed
	p.Custodian, p.Purpose = "", ""
	p.CheckedOutAt, p.CheckedOutBy = time.Time{}, ""
	p.DueBackAt = time.Time{}
	_ = now
	return nil
}

// MarkMissing records a record nobody can find (SRS-MRD-006).
//
// Its own state rather than leaving it checked out to somebody who left. The
// custodian and the date it went out are kept: they are the only trail back
// to it.
func (p *PhysicalRecord) MarkMissing(reason, by string, now time.Time) error {
	switch {
	case p.State == PhysicalDestroyed:
		return fmt.Errorf("%w: this record was destroyed", ErrInvalidRecord)
	case p.State == PhysicalMissing:
		return fmt.Errorf("%w: this record is already recorded missing",
			ErrInvalidRecord)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say what is known about where it went",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a missing record names who reported it",
			ErrInvalidRecord)
	}
	p.State = PhysicalMissing
	p.Description = strings.TrimSpace(p.Description)
	p.Purpose = strings.TrimSpace(reason)
	_ = now
	return nil
}

// Archive moves a record to off-site storage (SRS-MRD-006, SRS-MRD-009).
func (p *PhysicalRecord) Archive(location, by string, now time.Time) error {
	switch {
	case p.State == PhysicalOut:
		return fmt.Errorf("%w: this record is with %s and cannot be archived",
			ErrInvalidRecord, p.Custodian)
	case p.State != PhysicalFiled:
		return fmt.Errorf("%w: this record is %s", ErrInvalidRecord, p.State)
	case strings.TrimSpace(location) == "":
		return fmt.Errorf("%w: say where the record is archived",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an archival names who carried it out",
			ErrInvalidRecord)
	}
	p.State = PhysicalArchived
	p.CurrentLocation = strings.TrimSpace(location)
	_ = now
	return nil
}

// MarkDestroyed records a record disposed of under a retention rule
// (SRS-MRD-006, SRS-MRD-009).
//
// The row stays. "We had it and destroyed it lawfully in 2021, under this
// rule, on this certificate" is a different answer from "we never had it",
// and only one of them is defensible.
func (p *PhysicalRecord) MarkDestroyed(listID, certificate, by string,
	now time.Time) error {

	switch {
	case p.State == PhysicalDestroyed:
		return fmt.Errorf("%w: this record is already destroyed",
			ErrInvalidRecord)
	case p.State == PhysicalOut:
		return fmt.Errorf("%w: this record is with %s",
			ErrInvalidRecord, p.Custodian)
	case strings.TrimSpace(listID) == "":
		// A destruction with no approved list behind it is the one thing
		// SRS-MRD-009's approval control exists to prevent.
		return fmt.Errorf(
			"%w: a destruction names the approved disposition list it was on",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a destruction names who carried it out",
			ErrInvalidRecord)
	}
	p.State = PhysicalDestroyed
	p.CurrentLocation = "destroyed under list " + strings.TrimSpace(listID)
	if certificate != "" {
		p.CurrentLocation += " (" + strings.TrimSpace(certificate) + ")"
	}
	p.Custodian = ""
	_ = now
	return nil
}

// Outstanding lists the records that are out, oldest first (SRS-MRD-006).
//
// overdueOnly narrows to the ones past their date. The whole list is what a
// record library works from at the end of a week; the overdue half is what it
// chases.
func Outstanding(records []PhysicalRecord, overdueOnly bool,
	at time.Time) []PhysicalRecord {

	var out []PhysicalRecord
	for _, record := range records {
		if record.State != PhysicalOut {
			continue
		}
		if overdueOnly && (record.DueBackAt.IsZero() ||
			!at.After(record.DueBackAt)) {
			continue
		}
		out = append(out, record)
	}
	sort.Slice(out, func(a, b int) bool {
		return out[a].CheckedOutAt.Before(out[b].CheckedOutAt)
	})
	return out
}
