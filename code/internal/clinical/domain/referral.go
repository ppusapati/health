package domain

import (
	"fmt"
	"strings"
	"time"
)

// Consults and disease registries (SRS-CLN-022, SRS-CLN-023).

// ConsultUrgency is how soon a consult is needed.
type ConsultUrgency string

const (
	// UrgencyEmergency is now. Somebody is on the phone as well; this is the
	// record of it.
	UrgencyEmergency ConsultUrgency = "emergency"
	UrgencyUrgent    ConsultUrgency = "urgent"
	UrgencyRoutine   ConsultUrgency = "routine"
)

var knownConsultUrgencies = map[ConsultUrgency]bool{
	UrgencyEmergency: true, UrgencyUrgent: true, UrgencyRoutine: true,
}

// ConsultStatus is where a consult request stands (SRS-CLN-022).
type ConsultStatus string

const (
	ConsultRequested ConsultStatus = "requested"
	// ConsultAccepted has been picked up by the receiving service, which is
	// what tells the requester somebody has it.
	ConsultAccepted ConsultStatus = "accepted"
	// ConsultAnswered has a response. The loop is closed.
	ConsultAnswered ConsultStatus = "answered"
	// ConsultDeclined was refused, with a reason. Recorded rather than
	// deleted: a declined consult is the fact a requester most needs, and one
	// that silently vanished would be waited on for days.
	ConsultDeclined  ConsultStatus = "declined"
	ConsultCancelled ConsultStatus = "cancelled"
)

var knownConsultStatuses = map[ConsultStatus]bool{
	ConsultRequested: true, ConsultAccepted: true, ConsultAnswered: true,
	ConsultDeclined: true, ConsultCancelled: true,
}

// Consult is a request for another service's opinion (SRS-CLN-022).
type Consult struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	// Specialty is who is being asked.
	Specialty string
	Urgency   ConsultUrgency
	// Reason is the clinical background.
	Reason string
	// Question is what is actually being asked. Separate from the reason
	// because a consult with background but no question produces an opinion
	// that answers something else — the commonest way a consult wastes two
	// clinicians' time.
	Question string
	Status   ConsultStatus

	// RespondingSubjectID is who answered, and Response is what they said.
	RespondingSubjectID string
	Response            string
	// ResponseDocumentID links to the full consultation note, where one was
	// written. The short response here is what the requester reads at a
	// glance; the note is the record.
	ResponseDocumentID string
	// DeclineReason is why it was refused.
	DeclineReason string

	RequestedBy string
	RequestedAt time.Time
	RespondedAt time.Time
	UpdatedAt   time.Time
	Version     int64
}

// MaxConsultTextLength bounds the free text on a consult.
const MaxConsultTextLength = 2_000

// NewConsult validates and constructs a consult request.
func NewConsult(id, tenantID, patientID, encounterID, specialty string,
	urgency ConsultUrgency, reason, question, requestedBy string,
	now time.Time) (Consult, error) {

	reason = strings.TrimSpace(reason)
	question = strings.TrimSpace(question)

	switch {
	case strings.TrimSpace(id) == "":
		return Consult{}, fmt.Errorf("%w: consult id is required", ErrInvalidDocument)
	case strings.TrimSpace(patientID) == "":
		return Consult{}, fmt.Errorf("%w: a consult needs a patient", ErrInvalidDocument)
	case strings.TrimSpace(encounterID) == "":
		return Consult{}, fmt.Errorf("%w: a consult needs an encounter", ErrInvalidDocument)
	case strings.TrimSpace(specialty) == "":
		return Consult{}, fmt.Errorf("%w: a consult needs a specialty to ask",
			ErrInvalidDocument)
	case !knownConsultUrgencies[urgency]:
		return Consult{}, fmt.Errorf("%w: unknown consult urgency %q",
			ErrInvalidDocument, urgency)
	case question == "":
		// A consult with background but no question produces an opinion that
		// answers something else, which is the commonest way a consult wastes
		// two clinicians' time.
		return Consult{}, fmt.Errorf("%w: a consult must state the question being asked",
			ErrInvalidDocument)
	case len(reason) > MaxConsultTextLength || len(question) > MaxConsultTextLength:
		return Consult{}, fmt.Errorf("%w: consult text is longer than %d characters",
			ErrInvalidDocument, MaxConsultTextLength)
	case strings.TrimSpace(requestedBy) == "":
		return Consult{}, fmt.Errorf("%w: a consult must record who asked", ErrInvalidDocument)
	}

	return Consult{
		ID: id, TenantID: tenantID, PatientID: patientID, EncounterID: encounterID,
		Specialty: specialty, Urgency: urgency, Reason: reason, Question: question,
		Status: ConsultRequested, RequestedBy: requestedBy,
		RequestedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// Accept records the receiving service picking the consult up.
func (c *Consult) Accept(by string, now time.Time) error {
	if c.Status != ConsultRequested {
		return fmt.Errorf("%w: a %s consult cannot be accepted", ErrInvalidDocument, c.Status)
	}
	c.Status = ConsultAccepted
	c.RespondingSubjectID = by
	c.UpdatedAt = now.UTC()
	return nil
}

// Answer closes the loop (SRS-CLN-022).
//
// The acceptance criterion is that the "consult response closes loop and
// remains linked", so the answer lands on the request rather than becoming a
// free-floating note: a requester who has to search the chart for the reply is
// a requester who will not find it.
func (c *Consult) Answer(by, response, documentID string, now time.Time) error {
	response = strings.TrimSpace(response)

	switch {
	case c.Status == ConsultAnswered:
		return fmt.Errorf("%w: this consult has already been answered", ErrInvalidDocument)
	case c.Status == ConsultCancelled || c.Status == ConsultDeclined:
		return fmt.Errorf("%w: a %s consult cannot be answered", ErrInvalidDocument, c.Status)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a consult response must record who gave it",
			ErrInvalidDocument)
	case response == "" && strings.TrimSpace(documentID) == "":
		// Either a short answer or a note. Neither is a status change dressed
		// up as a reply.
		return fmt.Errorf("%w: a consult response needs an answer or a note",
			ErrInvalidDocument)
	case len(response) > MaxConsultTextLength:
		return fmt.Errorf("%w: the response is longer than %d characters",
			ErrInvalidDocument, MaxConsultTextLength)
	}

	c.Status = ConsultAnswered
	c.RespondingSubjectID = by
	c.Response = response
	c.ResponseDocumentID = documentID
	c.RespondedAt = now.UTC()
	c.UpdatedAt = now.UTC()
	return nil
}

// Decline refuses a consult with a reason.
func (c *Consult) Decline(by, reason string, now time.Time) error {
	reason = strings.TrimSpace(reason)

	switch {
	case c.Status == ConsultAnswered:
		return fmt.Errorf("%w: an answered consult cannot be declined", ErrInvalidDocument)
	case reason == "":
		// A declined consult with no reason leaves the requester waiting for
		// an answer that is never coming.
		return fmt.Errorf("%w: declining a consult needs a reason", ErrInvalidDocument)
	}

	c.Status = ConsultDeclined
	c.RespondingSubjectID = by
	c.DeclineReason = reason
	c.RespondedAt = now.UTC()
	c.UpdatedAt = now.UTC()
	return nil
}

// Open reports a consult still waiting for somebody.
func (c Consult) Open() bool {
	return c.Status == ConsultRequested || c.Status == ConsultAccepted
}

// RegistryMembership is a patient's place in a disease registry
// (SRS-CLN-023).
//
// A pointer, never a copy. The acceptance criterion is that "registry
// membership points to canonical clinical facts", and the reason is that a
// registry holding its own copy of a diagnosis is a second version of the
// patient's record that nobody updates: the diabetes registry still says type 1
// three years after the diagnosis was corrected.
type RegistryMembership struct {
	ID        string
	TenantID  string
	PatientID string
	// RegistryID names the registry — "diabetes", "cancer", "dialysis".
	RegistryID string
	// ProblemID and DiagnosisID are the canonical facts membership rests on.
	// At least one is required: a membership resting on nothing cannot be
	// re-derived or defended.
	ProblemID   string
	DiagnosisID string
	// EnrolledAt and ExitedAt bound the membership.
	EnrolledAt time.Time
	ExitedAt   time.Time
	// ExitReason says why they left — recovered, moved away, died.
	ExitReason string
	// Consented records that the patient agreed to be in a registry that needs
	// consent. Not every registry does — a statutory cancer registry does not —
	// so this is a fact rather than a gate.
	Consented bool

	EnrolledBy string
	RecordedAt time.Time
}

// NewRegistryMembership validates and constructs a membership.
func NewRegistryMembership(id, tenantID, patientID, registryID, problemID,
	diagnosisID string, enrolledAt time.Time, consented bool, enrolledBy string,
	now time.Time) (RegistryMembership, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return RegistryMembership{}, fmt.Errorf("%w: membership id is required",
			ErrInvalidDocument)
	case strings.TrimSpace(patientID) == "":
		return RegistryMembership{}, fmt.Errorf("%w: a membership needs a patient",
			ErrInvalidDocument)
	case strings.TrimSpace(registryID) == "":
		return RegistryMembership{}, fmt.Errorf("%w: a membership needs a registry",
			ErrInvalidDocument)
	case strings.TrimSpace(problemID) == "" && strings.TrimSpace(diagnosisID) == "":
		// A membership resting on nothing cannot be re-derived or defended, and
		// the alternative — copying the diagnosis in — is the drift the
		// requirement exists to prevent.
		return RegistryMembership{}, fmt.Errorf(
			"%w: a registry membership must point at the problem or diagnosis it rests on",
			ErrInvalidDocument)
	case strings.TrimSpace(enrolledBy) == "":
		return RegistryMembership{}, fmt.Errorf("%w: a membership must record who enrolled them",
			ErrInvalidDocument)
	}

	if enrolledAt.IsZero() {
		enrolledAt = now
	}

	return RegistryMembership{
		ID: id, TenantID: tenantID, PatientID: patientID, RegistryID: registryID,
		ProblemID: problemID, DiagnosisID: diagnosisID,
		EnrolledAt: enrolledAt.UTC(), Consented: consented,
		EnrolledBy: enrolledBy, RecordedAt: now.UTC(),
	}, nil
}

// Exit records a patient leaving a registry.
func (m *RegistryMembership) Exit(at time.Time, reason string, now time.Time) error {
	reason = strings.TrimSpace(reason)
	if reason == "" {
		return fmt.Errorf("%w: leaving a registry needs a reason", ErrInvalidDocument)
	}
	if at.IsZero() {
		at = now
	}
	if at.Before(m.EnrolledAt) {
		return fmt.Errorf("%w: a membership cannot end before it began", ErrInvalidDocument)
	}

	m.ExitedAt = at.UTC()
	m.ExitReason = reason
	return nil
}

// Current reports a membership still in force at an instant.
func (m RegistryMembership) Current(at time.Time) bool {
	if at.Before(m.EnrolledAt) {
		return false
	}
	return m.ExitedAt.IsZero() || at.Before(m.ExitedAt)
}
