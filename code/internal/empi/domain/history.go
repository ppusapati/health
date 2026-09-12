package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/effective"
)

// Effective-dated demographic history (SRS-EMPI-007).
//
// "History is effective-dated and auditable" is the verification clause, and
// the failure it guards against is specific. A patient marries and the
// registration desk overwrites the surname. Six months later a laboratory
// result arrives addressed to the old name, a clerk searches for it, finds
// nobody, and files it under a new record — and now there are two.
//
// So a name is never overwritten. The current one is closed off and a new one
// opens, and every name the patient has ever been known by stays searchable
// for the interval it applied to.
//
// Two representations, deliberately:
//
//   - `patient.family_name` and friends hold the CURRENT name. That is what
//     the matcher reads and what the search index is built over, and a query
//     that had to reconstruct it from history would be a join per candidate.
//   - The history table is the record. It is what answers "what was this
//     patient called in March", which is the question a misfiled result poses.
//
// Both are written in one transaction. Neither is a cache of the other: the
// columns are the current state of the aggregate, the history is the audit.

// NameKind distinguishes what a recorded name is for.
type NameKind string

const (
	// NameLegal is the name on the identity document.
	NameLegal NameKind = "legal"
	// NamePreferred is what the patient asks to be called. Shown on a
	// worklist; never printed on a legal document.
	NamePreferred NameKind = "preferred"
	// NameAlias is another name the patient is known by — a maiden name, a
	// religious name, a transliteration.
	NameAlias NameKind = "alias"
)

var knownNameKinds = map[NameKind]bool{
	NameLegal: true, NamePreferred: true, NameAlias: true,
}

// PatientName is one name, effective-dated.
type PatientName struct {
	ID        string
	PatientID string
	Kind      NameKind
	Name      HumanName
	Window    effective.Window
	// RecordedBy is who entered it, which is half of "auditable" — the other
	// half is the audit record written alongside.
	RecordedBy string
	RecordedAt time.Time
	// Source says where it came from: a registration desk, a document, an
	// external feed.
	Source string
}

// NewPatientName validates and constructs a historical name.
func NewPatientName(id, patientID string, kind NameKind, name HumanName,
	window effective.Window, recordedBy, source string, now time.Time) (PatientName, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return PatientName{}, fmt.Errorf("%w: id is required", ErrInvalidPatient)
	case strings.TrimSpace(patientID) == "":
		return PatientName{}, fmt.Errorf("%w: a name needs a patient", ErrInvalidPatient)
	case !knownNameKinds[kind]:
		return PatientName{}, fmt.Errorf("%w: unknown name kind %q", ErrInvalidPatient, kind)
	case name.IsEmpty():
		return PatientName{}, fmt.Errorf("%w: a name needs something in it", ErrInvalidPatient)
	case strings.TrimSpace(recordedBy) == "":
		return PatientName{}, fmt.Errorf("%w: a recorded name needs an actor", ErrInvalidPatient)
	}
	if err := window.Validate(); err != nil {
		return PatientName{}, fmt.Errorf("%w: %v", ErrInvalidPatient, err)
	}

	return PatientName{
		ID: id, PatientID: patientID, Kind: kind,
		Name: HumanName{
			Family: normaliseText(name.Family),
			Given:  normaliseGiven(name.Given),
			Prefix: normaliseText(name.Prefix),
			Suffix: normaliseText(name.Suffix),
		},
		Window:     window,
		RecordedBy: recordedBy,
		RecordedAt: now.UTC(),
		Source:     normaliseText(source),
	}, nil
}

func normaliseGiven(given []string) []string {
	out := make([]string, 0, len(given))
	for _, g := range given {
		if trimmed := normaliseText(g); trimmed != "" {
			out = append(out, trimmed)
		}
	}
	return out
}

// NameHistory is a patient's names across time.
type NameHistory []PatientName

// InForceAt returns the legal name that applied at an instant.
//
// Legal specifically: a preferred name and an alias are additional ways to
// address somebody, not replacements, and "what was this patient called in
// March" for a misfiled document means the name on the paperwork.
func (h NameHistory) InForceAt(kind NameKind, at time.Time) (PatientName, bool) {
	for _, n := range h {
		if n.Kind == kind && n.Window.Contains(at) {
			return n, true
		}
	}
	return PatientName{}, false
}

// Searchable returns every distinct family name the patient has been known by.
//
// Including closed windows, which is the point: a result addressed to a maiden
// name arrives after the marriage, and the clerk searching for it must find
// this patient rather than create a second one.
func (h NameHistory) Searchable() []string {
	seen := map[string]bool{}
	var out []string
	for _, n := range h {
		family := strings.TrimSpace(n.Name.Family)
		if family == "" || seen[strings.ToLower(family)] {
			continue
		}
		seen[strings.ToLower(family)] = true
		out = append(out, family)
	}
	sort.Strings(out)
	return out
}

// Communication preferences (SRS-EMPI-007, carried into SRS-EMPI-013).

// CommunicationChannel is how the patient may be reached.
type CommunicationChannel string

const (
	ChannelSMS   CommunicationChannel = "sms"
	ChannelEmail CommunicationChannel = "email"
	ChannelPhone CommunicationChannel = "phone"
	ChannelPost  CommunicationChannel = "post"
)

var knownChannels = map[CommunicationChannel]bool{
	ChannelSMS: true, ChannelEmail: true, ChannelPhone: true, ChannelPost: true,
}

// CommunicationPurpose is what the message is about.
//
// Separated from the channel because the answers differ: a patient who wants
// appointment reminders by SMS may want nothing else by SMS, and treating
// "reachable by SMS" as one setting is how a hospital ends up texting somebody
// their test results because they agreed to reminders.
type CommunicationPurpose string

const (
	PurposeAppointmentReminder CommunicationPurpose = "appointment_reminder"
	PurposeResults             CommunicationPurpose = "results"
	PurposeBilling             CommunicationPurpose = "billing"
	PurposeHealthPromotion     CommunicationPurpose = "health_promotion"
)

var knownCommunicationPurposes = map[CommunicationPurpose]bool{
	PurposeAppointmentReminder: true, PurposeResults: true,
	PurposeBilling: true, PurposeHealthPromotion: true,
}

// CommunicationPreference is one channel-and-purpose decision, effective-dated.
type CommunicationPreference struct {
	ID        string
	PatientID string
	Channel   CommunicationChannel
	Purpose   CommunicationPurpose
	// Allowed false is a recorded refusal, which is not the same as an absent
	// row: one says the patient declined and the other says nobody asked.
	Allowed    bool
	Window     effective.Window
	RecordedBy string
	RecordedAt time.Time
}

// NewCommunicationPreference validates and constructs a preference.
func NewCommunicationPreference(id, patientID string, channel CommunicationChannel,
	purpose CommunicationPurpose, allowed bool, window effective.Window,
	recordedBy string, now time.Time) (CommunicationPreference, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CommunicationPreference{}, fmt.Errorf("%w: id is required", ErrInvalidPatient)
	case strings.TrimSpace(patientID) == "":
		return CommunicationPreference{}, fmt.Errorf("%w: a preference needs a patient", ErrInvalidPatient)
	case !knownChannels[channel]:
		return CommunicationPreference{}, fmt.Errorf("%w: unknown channel %q", ErrInvalidPatient, channel)
	case !knownCommunicationPurposes[purpose]:
		return CommunicationPreference{}, fmt.Errorf("%w: unknown purpose %q", ErrInvalidPatient, purpose)
	case strings.TrimSpace(recordedBy) == "":
		return CommunicationPreference{}, fmt.Errorf("%w: a preference needs an actor", ErrInvalidPatient)
	}
	if err := window.Validate(); err != nil {
		return CommunicationPreference{}, fmt.Errorf("%w: %v", ErrInvalidPatient, err)
	}

	return CommunicationPreference{
		ID: id, PatientID: patientID, Channel: channel, Purpose: purpose,
		Allowed: allowed, Window: window, RecordedBy: recordedBy, RecordedAt: now.UTC(),
	}, nil
}

// PreferenceSet is a patient's communication preferences.
type PreferenceSet []CommunicationPreference

// Permits reports whether a message may be sent, at an instant.
//
// Deny by default. An absent preference means nobody asked, and sending
// anyway on the grounds that the patient never said no is how an optional
// communication reaches somebody who did not want it. The exception is
// deliberately narrow and belongs to the caller: a clinically necessary
// message is not an optional communication and does not come through here.
func (s PreferenceSet) Permits(channel CommunicationChannel,
	purpose CommunicationPurpose, at time.Time) bool {

	for _, p := range s {
		if p.Channel == channel && p.Purpose == purpose && p.Window.Contains(at) {
			return p.Allowed
		}
	}
	return false
}

// Recorded reports whether the patient has been asked at all, which a UI needs
// in order to distinguish "declined" from "never asked".
func (s PreferenceSet) Recorded(channel CommunicationChannel,
	purpose CommunicationPurpose, at time.Time) bool {

	for _, p := range s {
		if p.Channel == channel && p.Purpose == purpose && p.Window.Contains(at) {
			return true
		}
	}
	return false
}
