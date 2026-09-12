package domain

import (
	"fmt"
	"strings"
	"time"
)

// Episodes of care and care teams (SRS-ENC-004, SRS-ENC-005).

// EpisodeType is the kind of longitudinal course an episode groups.
//
// Named rather than free text because the type decides what the episode means:
// a pregnancy ends at delivery, an oncology episode runs to remission or death,
// and a dialysis episode may never end at all. A report that could not tell
// them apart could not answer how many pregnancies a unit managed this year.
type EpisodeType string

const (
	EpisodePregnancy EpisodeType = "pregnancy"
	EpisodeOncology  EpisodeType = "oncology"
	EpisodeDialysis  EpisodeType = "dialysis"
	// EpisodeChronicDisease covers diabetes, hypertension and the rest: a
	// course of care with no expected end.
	EpisodeChronicDisease EpisodeType = "chronic_disease"
	EpisodeRehabilitation EpisodeType = "rehabilitation"
	EpisodeSurgicalCare   EpisodeType = "surgical_care"
	// EpisodeOther is the honest catch-all. Present because the alternative is
	// somebody filing a course of care under "chronic_disease" because there
	// was nowhere else to put it, which is worse: it produces a wrong answer
	// rather than a missing one.
	EpisodeOther EpisodeType = "other"
)

var knownEpisodeTypes = map[EpisodeType]bool{
	EpisodePregnancy: true, EpisodeOncology: true, EpisodeDialysis: true,
	EpisodeChronicDisease: true, EpisodeRehabilitation: true,
	EpisodeSurgicalCare: true, EpisodeOther: true,
}

// EpisodeStatus is where a course of care stands.
type EpisodeStatus string

const (
	EpisodeActive EpisodeStatus = "active"
	// EpisodeOnHold is paused rather than finished — a course of chemotherapy
	// suspended while the patient recovers from an infection.
	EpisodeOnHold   EpisodeStatus = "on_hold"
	EpisodeFinished EpisodeStatus = "finished"
	// EpisodeCancelled was opened and should not have been.
	EpisodeCancelled EpisodeStatus = "cancelled"
)

var knownEpisodeStatuses = map[EpisodeStatus]bool{
	EpisodeActive: true, EpisodeOnHold: true,
	EpisodeFinished: true, EpisodeCancelled: true,
}

// Episode groups encounters into one course of treatment (SRS-ENC-004).
//
// Deliberately thin. The acceptance criterion is that "multiple encounters can
// reference one episode without copying data", so an episode holds the fact of
// the grouping and nothing else: no diagnosis, no plan, no summary of its
// encounters. The moment it held a copy of anything, that copy would be the
// version somebody read after the original changed.
type Episode struct {
	id         string
	TenantID   string
	PatientID  string
	FacilityID string
	Type       EpisodeType
	// Label is what clinicians call it — "second pregnancy", "left breast".
	// Short and non-diagnostic: the diagnosis lives on the encounter.
	Label string
	// CareManagerID is the clinician who owns the course of care, where one is
	// named. Optional: plenty of episodes are managed by a team rather than a
	// person, and inventing an owner would put a name against decisions they
	// did not make.
	CareManagerID string
	Status        EpisodeStatus
	StartedAt     time.Time
	EndedAt       time.Time

	CreatedBy string
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// ID returns the immutable identifier.
func (e *Episode) ID() string { return e.id }

// RestoreEpisode rebuilds an episode from storage.
func RestoreEpisode(id string, e Episode) *Episode {
	e.id = id
	return &e
}

// MaxLabelLength bounds an episode label.
const MaxLabelLength = 120

// NewEpisode validates and constructs an episode of care.
func NewEpisode(id, tenantID, patientID, facilityID string, episodeType EpisodeType,
	label, careManagerID string, startedAt time.Time, createdBy string,
	now time.Time) (*Episode, error) {

	label = strings.TrimSpace(label)

	switch {
	case strings.TrimSpace(id) == "":
		return nil, fmt.Errorf("%w: episode id is required", ErrInvalidEncounter)
	case strings.TrimSpace(patientID) == "":
		return nil, fmt.Errorf("%w: an episode needs a patient", ErrInvalidEncounter)
	case !knownEpisodeTypes[episodeType]:
		return nil, fmt.Errorf("%w: unknown episode type %q", ErrInvalidEncounter, episodeType)
	case label == "":
		// An unlabelled episode is one nobody can pick out of a list of four,
		// and a patient with two pregnancies has two.
		return nil, fmt.Errorf("%w: an episode needs a label", ErrInvalidEncounter)
	case len(label) > MaxLabelLength:
		return nil, fmt.Errorf("%w: the label is longer than %d characters",
			ErrInvalidEncounter, MaxLabelLength)
	case strings.TrimSpace(createdBy) == "":
		return nil, fmt.Errorf("%w: an episode must record who opened it", ErrInvalidEncounter)
	}

	if startedAt.IsZero() {
		startedAt = now
	}

	return &Episode{
		id: id, TenantID: tenantID, PatientID: patientID, FacilityID: facilityID,
		Type: episodeType, Label: label, CareManagerID: careManagerID,
		Status: EpisodeActive, StartedAt: startedAt.UTC(),
		CreatedBy: createdBy, CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// SetStatus moves an episode through its life.
func (e *Episode) SetStatus(to EpisodeStatus, at time.Time, now time.Time) error {
	if !knownEpisodeStatuses[to] {
		return fmt.Errorf("%w: unknown episode status %q", ErrInvalidEncounter, to)
	}
	if e.Status == EpisodeFinished && to == EpisodeActive {
		// Reopening a finished course of care hides that it ever ended. A new
		// episode is the honest record: a pregnancy that resumes is a different
		// pregnancy.
		return fmt.Errorf(
			"%w: a finished episode is not reopened; open a new one", ErrInvalidEncounter)
	}

	e.Status = to
	if to == EpisodeFinished || to == EpisodeCancelled {
		if at.IsZero() {
			at = now
		}
		if at.Before(e.StartedAt) {
			return fmt.Errorf("%w: an episode cannot end before it started",
				ErrInvalidEncounter)
		}
		e.EndedAt = at.UTC()
	}
	e.UpdatedAt = now.UTC()
	return nil
}

// Accepts reports whether an encounter may be filed against this episode.
func (e *Episode) Accepts() bool {
	return e.Status == EpisodeActive || e.Status == EpisodeOnHold
}

// CareTeamRole is what somebody does on an encounter (SRS-ENC-005).
//
// Coarse on purpose. The acceptance criterion is that "authorization can
// evaluate active care-team relationship", and authorization needs to know
// whether this clinician is looking after this patient — not their exact job
// title, which belongs to an HR system this wave does not build.
type CareTeamRole string

const (
	// RoleAttending holds clinical responsibility. Mirrors the encounter's own
	// attending provider, and is held here too so a change of consultant
	// mid-admission is a dated fact rather than an overwrite.
	RoleAttending   CareTeamRole = "attending"
	RoleConsulting  CareTeamRole = "consulting"
	RoleNurse       CareTeamRole = "nurse"
	RoleResident    CareTeamRole = "resident"
	RoleTherapist   CareTeamRole = "therapist"
	RolePharmacist  CareTeamRole = "pharmacist"
	RoleSocialWork  CareTeamRole = "social_work"
	RoleAdmitting   CareTeamRole = "admitting"
	RoleDischarging CareTeamRole = "discharging"
)

var knownCareTeamRoles = map[CareTeamRole]bool{
	RoleAttending: true, RoleConsulting: true, RoleNurse: true,
	RoleResident: true, RoleTherapist: true, RolePharmacist: true,
	RoleSocialWork: true, RoleAdmitting: true, RoleDischarging: true,
}

// CareTeamMember is one person's involvement in one encounter, effective-dated.
//
// Dated rather than a simple membership list because the question authorization
// actually asks is "was this clinician on the team *at the time*". A list with
// no dates answers today's question and silently gives the wrong answer to
// every question about the past — including the one an investigation asks.
type CareTeamMember struct {
	ID          string
	TenantID    string
	EncounterID string
	SubjectID   string
	Role        CareTeamRole
	// From and Until bound the involvement. Until zero means still involved.
	From  time.Time
	Until time.Time

	AssignedBy string
	AssignedAt time.Time
}

// NewCareTeamMember validates and constructs an assignment.
func NewCareTeamMember(id, tenantID, encounterID, subjectID string, role CareTeamRole,
	from, until time.Time, assignedBy string, now time.Time) (CareTeamMember, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CareTeamMember{}, fmt.Errorf("%w: care-team id is required", ErrInvalidEncounter)
	case strings.TrimSpace(encounterID) == "":
		return CareTeamMember{}, fmt.Errorf("%w: a care-team member needs an encounter",
			ErrInvalidEncounter)
	case strings.TrimSpace(subjectID) == "":
		return CareTeamMember{}, fmt.Errorf("%w: a care-team member needs a person",
			ErrInvalidEncounter)
	case !knownCareTeamRoles[role]:
		return CareTeamMember{}, fmt.Errorf("%w: unknown care-team role %q",
			ErrInvalidEncounter, role)
	case strings.TrimSpace(assignedBy) == "":
		return CareTeamMember{}, fmt.Errorf("%w: an assignment must record who made it",
			ErrInvalidEncounter)
	}

	if from.IsZero() {
		from = now
	}
	if !until.IsZero() && !until.After(from) {
		return CareTeamMember{}, fmt.Errorf("%w: a care-team assignment must end after it begins",
			ErrInvalidEncounter)
	}

	return CareTeamMember{
		ID: id, TenantID: tenantID, EncounterID: encounterID, SubjectID: subjectID,
		Role: role, From: from.UTC(), Until: until.UTC(),
		AssignedBy: assignedBy, AssignedAt: now.UTC(),
	}, nil
}

// ActiveAt reports whether this involvement was in force at an instant.
func (m CareTeamMember) ActiveAt(at time.Time) bool {
	if at.Before(m.From) {
		return false
	}
	return m.Until.IsZero() || at.Before(m.Until)
}

// CareTeam is an encounter's assignments.
type CareTeam []CareTeamMember

// Includes reports whether somebody was on the team at an instant
// (SRS-ENC-005).
//
// The question authorization asks. Deliberately not "is this person a
// clinician": a consultant who has never met this patient is still a
// consultant, and the care-team relationship is what distinguishes looking
// after somebody from being able to look them up.
func (t CareTeam) Includes(subjectID string, at time.Time) bool {
	for _, m := range t {
		if m.SubjectID == subjectID && m.ActiveAt(at) {
			return true
		}
	}
	return false
}

// RoleOf returns somebody's role at an instant, and whether they had one.
func (t CareTeam) RoleOf(subjectID string, at time.Time) (CareTeamRole, bool) {
	for _, m := range t {
		if m.SubjectID == subjectID && m.ActiveAt(at) {
			return m.Role, true
		}
	}
	return "", false
}

// ActiveAt returns the team as it stood at an instant.
func (t CareTeam) ActiveAt(at time.Time) CareTeam {
	out := make(CareTeam, 0, len(t))
	for _, m := range t {
		if m.ActiveAt(at) {
			out = append(out, m)
		}
	}
	return out
}
