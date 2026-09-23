package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The prehospital record and the handover (SRS-AMB-004, SRS-AMB-007).
//
// What a crew writes in the back of a moving ambulance is a clinical record,
// and SRS-AMB-004's acceptance is that it attaches to the emergency encounter
// on arrival. Two things follow. It is written by somebody the service says
// may write it — a driver is not a clinician here, which is not about
// competence but about the record naming somebody who may. And it is
// append-only: a set of observations somebody can go back and tidy is a set
// nobody can rely on afterwards, and the afterwards is usually an inquest.

// EntryKind is what a crew recorded (SRS-AMB-004).
type EntryKind string

const (
	// EntryObservation is a vital sign or a score.
	EntryObservation EntryKind = "observation"
	// EntryIntervention is something the crew did: a splint, an airway, a
	// cannula.
	EntryIntervention EntryKind = "intervention"
	// EntryMedication is a drug given. Its own kind, because the questions
	// asked of it afterwards are different and it needs the dose.
	EntryMedication EntryKind = "medication"
	// EntryNote is everything else.
	EntryNote EntryKind = "note"
)

var knownEntryKind = map[EntryKind]bool{
	EntryObservation: true, EntryIntervention: true,
	EntryMedication: true, EntryNote: true,
}

// Entry is one thing recorded on the road (SRS-AMB-004).
//
// Append-only once written. There is no method here that edits one.
type Entry struct {
	ID   string
	Kind EntryKind

	// Code is the observation or the drug, in whatever coding the service
	// uses.
	Code  string
	Label string
	// Value and Unit carry a measurement. Strings rather than a number,
	// because a blood pressure is "120/80" and a GCS is "15" and forcing
	// both into one numeric column loses one of them.
	Value string
	Unit  string

	// DoseAmount and DoseUnit are set for a medication. Integers in the
	// smallest unit the service records, because a dose of 0.30000000000004
	// milligrams is a number whose decimal is about floating point.
	DoseAmount int
	DoseUnit   string
	Route      string

	Narrative string

	// RecordedBy is the crew member. Their role is pinned here rather than
	// looked up later, because a paramedic who becomes a manager next year
	// still gave that drug as a paramedic.
	RecordedBy   string
	RecordedRole CrewRole
	RecordedAt   time.Time
	// EnteredAt is when it reached the system, which on a vehicle with no
	// signal is not when it happened. Both are kept: a record written up
	// two hours later is a different thing from one written at the time.
	EnteredAt time.Time
}

// HandoverState is where a handover stands (SRS-AMB-004, SRS-AMB-007).
type HandoverState string

const (
	// HandoverDraft is the crew's record before they hand over.
	HandoverDraft HandoverState = "draft"
	// HandoverGiven is the crew having handed over and signed.
	HandoverGiven HandoverState = "given"
	// HandoverAccepted is the receiving clinician having taken the patient.
	// SRS-AMB-007's acceptance is that the transfer documents and the
	// acceptance are linked, and this is the link.
	HandoverAccepted HandoverState = "accepted"
)

// PrehospitalRecord is what a crew did and wrote on one trip
// (SRS-AMB-004, SRS-AMB-007).
type PrehospitalRecord struct {
	ID       string
	TenantID string

	TripID    string
	RequestID string
	PatientID string
	// EncounterID is the emergency encounter this attaches to on arrival.
	// Empty until there is one, which for a scene call is when the patient
	// reaches the department.
	EncounterID string
	FacilityID  string

	// PresentingComplaint and Impression are the crew's own words.
	PresentingComplaint string
	Impression          string

	Entries []Entry

	State HandoverState

	// SendingSummary is the handover the crew gives. For an interfacility
	// transfer it is the sending hospital's clinical handover
	// (SRS-AMB-007).
	SendingSummary string
	GivenBy        string
	GivenRole      CrewRole
	GivenAt        time.Time

	// AcceptedBy is the receiving clinician. Never the crew member who gave
	// it: a handover accepted by the person who gave it is the same claim
	// made twice, and the patient is standing between two people neither of
	// whom has taken responsibility.
	AcceptedBy   string
	AcceptedAt   time.Time
	AcceptedNote string

	// DocumentRefs are the transfer documents — the referral, the images,
	// the consent — held wherever the hospital holds them. References, not
	// copies: a second copy of a referral goes stale the first time
	// somebody corrects one.
	DocumentRefs []string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewRecordInput opens a prehospital record.
type NewRecordInput struct {
	TripID              string
	RequestID           string
	PatientID           string
	EncounterID         string
	FacilityID          string
	PresentingComplaint string
	DocumentRefs        []string
}

// OpenRecord starts the crew's record for a trip (SRS-AMB-004).
func OpenRecord(id, tenantID string, in NewRecordInput, by string,
	now time.Time) (PrehospitalRecord, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return PrehospitalRecord{}, fmt.Errorf("%w: a record needs an id",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.TripID) == "":
		// A record with no trip behind it cannot be attributed to a crew,
		// a vehicle or a timeline.
		return PrehospitalRecord{}, fmt.Errorf("%w: a record names its trip",
			ErrInvalidAmbulance)
	case strings.TrimSpace(by) == "":
		return PrehospitalRecord{}, fmt.Errorf(
			"%w: a record names who opened it", ErrInvalidAmbulance)
	}

	return PrehospitalRecord{
		ID: id, TenantID: tenantID,
		TripID:              strings.TrimSpace(in.TripID),
		RequestID:           strings.TrimSpace(in.RequestID),
		PatientID:           strings.TrimSpace(in.PatientID),
		EncounterID:         strings.TrimSpace(in.EncounterID),
		FacilityID:          in.FacilityID,
		PresentingComplaint: strings.TrimSpace(in.PresentingComplaint),
		State:               HandoverDraft,
		DocumentRefs:        normalise(in.DocumentRefs),
		CreatedAt:           now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// NewEntryInput records something on the road.
type NewEntryInput struct {
	Kind       EntryKind
	Code       string
	Label      string
	Value      string
	Unit       string
	DoseAmount int
	DoseUnit   string
	Route      string
	Narrative  string
	// RecordedAt is when it happened, which on a vehicle with no signal is
	// not when it reaches the system. Zero means now.
	RecordedAt time.Time
}

// Record appends an entry (SRS-AMB-004).
//
// The crew member is passed in rather than named, and has to be somebody the
// shift says may record this. A medication given by a driver is not a record
// of who gave it, it is a record of who typed it.
func (r *PrehospitalRecord) Record(id string, in NewEntryInput,
	member CrewMember, now time.Time) error {

	switch {
	case strings.TrimSpace(id) == "":
		return fmt.Errorf("%w: an entry needs an id", ErrInvalidAmbulance)
	case r.State == HandoverAccepted:
		// Once the receiving clinician has taken the patient, the crew's
		// record is what they took them on. A late addition is an
		// amendment to somebody else's decision.
		return fmt.Errorf(
			"%w: this record has been accepted and is not added to",
			ErrInvalidAmbulance)
	case !knownEntryKind[in.Kind]:
		return fmt.Errorf("%w: unknown entry kind %q",
			ErrInvalidAmbulance, in.Kind)
	case strings.TrimSpace(member.SubjectID) == "":
		return fmt.Errorf("%w: an entry names who recorded it",
			ErrInvalidAmbulance)
	case !member.Role.Clinical():
		return fmt.Errorf(
			"%w: a %s does not record a prehospital %s",
			ErrInvalidAmbulance, member.Role, in.Kind)
	}

	if in.Kind == EntryMedication {
		switch {
		case strings.TrimSpace(in.Code) == "":
			return fmt.Errorf("%w: a medication entry names the drug",
				ErrInvalidAmbulance)
		case in.DoseAmount <= 0 || strings.TrimSpace(in.DoseUnit) == "":
			// A drug with no dose is a line in a record that cannot be
			// checked against anything.
			return fmt.Errorf("%w: a medication entry says how much",
				ErrInvalidAmbulance)
		case strings.TrimSpace(in.Route) == "":
			return fmt.Errorf("%w: a medication entry says how it was given",
				ErrInvalidAmbulance)
		}
	}
	if in.Kind == EntryObservation &&
		strings.TrimSpace(in.Code) == "" &&
		strings.TrimSpace(in.Label) == "" {
		return fmt.Errorf("%w: an observation says what was measured",
			ErrInvalidAmbulance)
	}

	at := in.RecordedAt
	if at.IsZero() {
		at = now
	}

	r.Entries = append(r.Entries, Entry{
		ID: id, Kind: in.Kind,
		Code: strings.TrimSpace(in.Code), Label: strings.TrimSpace(in.Label),
		Value: strings.TrimSpace(in.Value), Unit: strings.TrimSpace(in.Unit),
		DoseAmount: in.DoseAmount, DoseUnit: strings.TrimSpace(in.DoseUnit),
		Route:      strings.TrimSpace(in.Route),
		Narrative:  strings.TrimSpace(in.Narrative),
		RecordedBy: member.SubjectID, RecordedRole: member.Role,
		RecordedAt: at.UTC(), EnteredAt: now.UTC(),
	})
	return nil
}

// GiveHandover closes the crew's record and hands the patient over
// (SRS-AMB-004, SRS-AMB-007).
func (r *PrehospitalRecord) GiveHandover(summary, impression string,
	member CrewMember, now time.Time) error {

	switch {
	case r.State != HandoverDraft:
		return fmt.Errorf("%w: this handover is %s",
			ErrInvalidAmbulance, r.State)
	case strings.TrimSpace(member.SubjectID) == "":
		return fmt.Errorf("%w: a handover names who gave it",
			ErrInvalidAmbulance)
	case !member.Role.Clinical():
		return fmt.Errorf("%w: a %s does not give a clinical handover",
			ErrInvalidAmbulance, member.Role)
	case strings.TrimSpace(summary) == "":
		// A handover with nothing in it is a patient arriving with a
		// wristband and a shrug.
		return fmt.Errorf("%w: a handover says what happened",
			ErrInvalidAmbulance)
	case len(r.Entries) == 0:
		// A crew that recorded nothing at all on the way in did not assess
		// the patient, or did and wrote none of it down. Either is worth
		// stopping at the door.
		return fmt.Errorf(
			"%w: a handover carries what the crew recorded on the way",
			ErrInvalidAmbulance)
	}

	r.State = HandoverGiven
	r.SendingSummary = strings.TrimSpace(summary)
	r.Impression = strings.TrimSpace(impression)
	r.GivenBy, r.GivenRole = member.SubjectID, member.Role
	r.GivenAt = now.UTC()
	return nil
}

// Accept records the receiving clinician taking the patient
// (SRS-AMB-004, SRS-AMB-007).
//
// Never the crew member who gave it. SRS-AMB-007's acceptance links the
// transfer documents to the acceptance, and the acceptance is only worth
// anything if it is somebody else's.
func (r *PrehospitalRecord) Accept(encounterID, note, by string,
	now time.Time) error {

	switch {
	case r.State != HandoverGiven:
		return fmt.Errorf("%w: this handover is %s and has not been given",
			ErrInvalidAmbulance, r.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an acceptance names who made it",
			ErrInvalidAmbulance)
	case by == r.GivenBy:
		return fmt.Errorf(
			"%w: a handover is accepted by somebody other than whoever "+
				"gave it", ErrInvalidAmbulance)
	}

	r.State = HandoverAccepted
	r.AcceptedBy, r.AcceptedAt = by, now.UTC()
	r.AcceptedNote = strings.TrimSpace(note)
	// SRS-AMB-004: the data attaches to the emergency encounter on arrival,
	// and arrival is this moment.
	if encounter := strings.TrimSpace(encounterID); encounter != "" {
		r.EncounterID = encounter
	}
	return nil
}

// AttachDocument links a transfer document (SRS-AMB-007).
//
// A reference, never a copy. A second copy of a referral goes stale the first
// time somebody corrects one, and the corrected one is the one the receiving
// team needed.
func (r *PrehospitalRecord) AttachDocument(ref string) error {
	trimmed := strings.TrimSpace(ref)
	switch {
	case trimmed == "":
		return fmt.Errorf("%w: a document reference cannot be empty",
			ErrInvalidAmbulance)
	case r.State == HandoverAccepted:
		return fmt.Errorf(
			"%w: this record has been accepted and is not added to",
			ErrInvalidAmbulance)
	}
	for _, existing := range r.DocumentRefs {
		if strings.EqualFold(existing, trimmed) {
			return fmt.Errorf("%w: %q is already attached",
				ErrInvalidAmbulance, trimmed)
		}
	}
	r.DocumentRefs = append(r.DocumentRefs, trimmed)
	sort.Strings(r.DocumentRefs)
	return nil
}

// Medications lists the drugs given, in the order they were given
// (SRS-AMB-004).
//
// The question asked of a prehospital record most often, and the one an
// emergency department asks in the first minute.
func (r PrehospitalRecord) Medications() []Entry {
	var out []Entry
	for _, entry := range r.Entries {
		if entry.Kind == EntryMedication {
			out = append(out, entry)
		}
	}
	sort.SliceStable(out, func(a, b int) bool {
		return out[a].RecordedAt.Before(out[b].RecordedAt)
	})
	return out
}

// Unaccepted lists the records a receiving clinician has not taken
// (SRS-AMB-004, SRS-AMB-007).
//
// A crew that handed over to nobody is a patient in a corridor, and the
// oldest one is the one to look at first.
func Unaccepted(records []PrehospitalRecord) []PrehospitalRecord {
	var out []PrehospitalRecord
	for _, record := range records {
		if record.State == HandoverGiven {
			out = append(out, record)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		if !out[a].GivenAt.Equal(out[b].GivenAt) {
			return out[a].GivenAt.Before(out[b].GivenAt)
		}
		return out[a].ID < out[b].ID
	})
	return out
}
