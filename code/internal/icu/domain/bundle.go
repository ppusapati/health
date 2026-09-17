package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Care bundles and checklists (SRS-ICU-010), and the assessments whose
// reassessment timers the unit runs on (SRS-ICU-014).

// BundleKind is a checklist the unit runs.
//
// The five SRS-ICU-010 names plus a local one, because a unit that has agreed
// its own bundle should not wait for this enumeration.
type BundleKind string

const (
	BundleSepsis     BundleKind = "sepsis"
	BundleVTE        BundleKind = "vte"
	BundleDelirium   BundleKind = "delirium"
	BundlePressure   BundleKind = "pressure_injury"
	BundleSedation   BundleKind = "sedation"
	BundleVentilator BundleKind = "ventilator"
	BundleLocal      BundleKind = "local"
)

var knownBundleKinds = map[BundleKind]bool{
	BundleSepsis: true, BundleVTE: true, BundleDelirium: true,
	BundlePressure: true, BundleSedation: true, BundleVentilator: true,
	BundleLocal: true,
}

// BundleItem is one element of a bundle, as the deployment defines it.
type BundleItem struct {
	Code  string
	Label string
	// Required marks an element that must be done or explicitly excepted. A
	// bundle where everything is optional reports 100% compliance and means
	// nothing.
	Required bool
}

// BundleDefinition is a bundle as configured.
type BundleDefinition struct {
	Kind    BundleKind
	Label   string
	Version string
	Items   []BundleItem
	// Every is how often the bundle is performed — usually daily.
	Every time.Duration
}

// Validate refuses a bundle nothing could be measured against.
func (d BundleDefinition) Validate() error {
	switch {
	case !knownBundleKinds[d.Kind]:
		return fmt.Errorf("%w: unknown bundle %q", ErrInvalidEpisode, d.Kind)
	case d.Kind == BundleLocal && strings.TrimSpace(d.Label) == "":
		return fmt.Errorf("%w: name the bundle this unit calls local", ErrInvalidEpisode)
	case strings.TrimSpace(d.Version) == "":
		return fmt.Errorf("%w: a bundle definition has a version", ErrInvalidEpisode)
	case len(d.Items) == 0:
		return fmt.Errorf("%w: a bundle has elements", ErrInvalidEpisode)
	}
	seen := map[string]bool{}
	required := 0
	for _, item := range d.Items {
		if strings.TrimSpace(item.Code) == "" {
			return fmt.Errorf("%w: a bundle element has a code", ErrInvalidEpisode)
		}
		if seen[item.Code] {
			return fmt.Errorf("%w: element %q appears twice", ErrInvalidEpisode, item.Code)
		}
		seen[item.Code] = true
		if item.Required {
			required++
		}
	}
	if required == 0 {
		return fmt.Errorf(
			"%w: a bundle with no required element reports full compliance and measures nothing",
			ErrInvalidEpisode)
	}
	return nil
}

// ItemState is what happened to one element.
type ItemState string

const (
	ItemDone ItemState = "done"
	// ItemException is an element deliberately not done, with a reason. The
	// requirement's "exceptions captured" clause: a patient on therapeutic
	// anticoagulation does not get VTE prophylaxis, and recording that as a
	// failure teaches the unit to stop recording.
	ItemException ItemState = "exception"
	ItemNotDone   ItemState = "not_done"
)

// BundleResult is one element's outcome.
type BundleResult struct {
	Code   string
	State  ItemState
	Reason string
}

// BundlePerformance is one run of a bundle against one patient.
type BundlePerformance struct {
	ID        string
	TenantID  string
	EpisodeID string

	Kind    BundleKind
	Label   string
	Version string

	Results []BundleResult

	PerformedAt time.Time
	PerformedBy string
}

// PerformBundle records a bundle run (SRS-ICU-010).
func PerformBundle(id, tenantID, episodeID string, def BundleDefinition,
	results []BundleResult, by string, at time.Time) (BundlePerformance, error) {

	if err := def.Validate(); err != nil {
		return BundlePerformance{}, err
	}
	if strings.TrimSpace(id) == "" || strings.TrimSpace(episodeID) == "" {
		return BundlePerformance{}, fmt.Errorf("%w: a bundle run belongs to an episode",
			ErrInvalidEpisode)
	}
	if strings.TrimSpace(by) == "" {
		return BundlePerformance{}, fmt.Errorf("%w: a bundle run names who performed it",
			ErrInvalidEpisode)
	}

	defined := map[string]bool{}
	for _, item := range def.Items {
		defined[item.Code] = true
	}

	recorded := make([]BundleResult, 0, len(results))
	seen := map[string]bool{}
	for _, result := range results {
		code := strings.TrimSpace(result.Code)
		if !defined[code] {
			return BundlePerformance{}, fmt.Errorf(
				"%w: %q is not an element of the %s bundle", ErrInvalidEpisode,
				code, def.Kind)
		}
		if seen[code] {
			return BundlePerformance{}, fmt.Errorf("%w: element %q recorded twice",
				ErrInvalidEpisode, code)
		}
		seen[code] = true

		if result.State == ItemException && strings.TrimSpace(result.Reason) == "" {
			// An exception with no reason is a failure wearing a better name.
			return BundlePerformance{}, fmt.Errorf(
				"%w: an exception to %q needs a reason", ErrInvalidEpisode, code)
		}
		recorded = append(recorded, BundleResult{
			Code: code, State: result.State, Reason: strings.TrimSpace(result.Reason),
		})
	}

	sort.SliceStable(recorded, func(i, j int) bool {
		return recorded[i].Code < recorded[j].Code
	})

	return BundlePerformance{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(episodeID),
		Kind: def.Kind, Label: strings.TrimSpace(def.Label), Version: def.Version,
		Results:     recorded,
		PerformedAt: at.UTC(), PerformedBy: strings.TrimSpace(by),
	}, nil
}

// Compliance is how a bundle run scored.
type Compliance struct {
	Required int
	Done     int
	// Excepted counts elements deliberately not done with a reason. Reported
	// separately rather than folded into either side, because "we did not do
	// it" and "we decided not to, and here is why" are different facts and a
	// unit improves on only one of them.
	Excepted int
	Missed   int
	// Compliant is the all-or-nothing verdict every published bundle measure
	// uses: a bundle is a bundle because the elements work together, and
	// four-fifths of a sepsis bundle is not 80% of the benefit.
	Compliant bool
}

// Score reports a bundle run's compliance (SRS-ICU-010).
func (p BundlePerformance) Score(def BundleDefinition) Compliance {
	states := make(map[string]BundleResult, len(p.Results))
	for _, result := range p.Results {
		states[result.Code] = result
	}

	out := Compliance{}
	for _, item := range def.Items {
		if !item.Required {
			continue
		}
		out.Required++
		switch states[item.Code].State {
		case ItemDone:
			out.Done++
		case ItemException:
			out.Excepted++
		default:
			out.Missed++
		}
	}
	out.Compliant = out.Required > 0 && out.Missed == 0
	return out
}

// Assessments and their reassessment timers (SRS-ICU-014).

// AssessmentKind is a repeated bedside assessment.
type AssessmentKind string

const (
	AssessmentPressureInjury AssessmentKind = "pressure_injury"
	AssessmentSkin           AssessmentKind = "skin"
	AssessmentPositioning    AssessmentKind = "positioning"
	AssessmentRestraint      AssessmentKind = "restraint"
	AssessmentSedation       AssessmentKind = "sedation"
	AssessmentDelirium       AssessmentKind = "delirium"
)

// DefaultReassessment is how often each assessment repeats where the
// deployment has not configured an interval.
//
// The restraint interval is the short one on purpose. A restrained patient is
// the one a unit is most answerable for, and an interval a unit drifts past is
// how a restraint becomes indefinite.
func DefaultReassessment(kind AssessmentKind) time.Duration {
	switch kind {
	case AssessmentRestraint:
		return time.Hour
	case AssessmentPositioning:
		return 2 * time.Hour
	case AssessmentSedation, AssessmentDelirium:
		return 4 * time.Hour
	case AssessmentPressureInjury, AssessmentSkin:
		return 12 * time.Hour
	default:
		return 12 * time.Hour
	}
}

// Assessment is one bedside assessment (SRS-ICU-014).
type Assessment struct {
	ID        string
	TenantID  string
	EpisodeID string

	Kind AssessmentKind
	// Scale and Score record a scored assessment — Braden, RASS, CAM-ICU.
	Scale string
	Score *int
	// Findings is the structured detail the deployment configured.
	Findings map[string]string
	Note     string

	PerformedAt time.Time
	PerformedBy string
	// NextDueAt is generated here rather than by the reader, so a unit's
	// worklist and its audit agree about when the reassessment was due
	// (SRS-ICU-014's "required reassessment timers are generated").
	NextDueAt time.Time
}

// NewAssessmentInput is one assessment.
type NewAssessmentInput struct {
	EpisodeID   string
	Kind        AssessmentKind
	Scale       string
	Score       *int
	Findings    map[string]string
	Note        string
	PerformedAt time.Time
	// Every overrides the default interval.
	Every time.Duration
}

// RecordAssessment records an assessment and generates its next due time.
func RecordAssessment(id, tenantID string, in NewAssessmentInput, by string,
	now time.Time) (Assessment, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return Assessment{}, fmt.Errorf("%w: an assessment belongs to an episode",
			ErrInvalidEpisode)
	case strings.TrimSpace(string(in.Kind)) == "":
		return Assessment{}, fmt.Errorf("%w: an assessment names what was assessed",
			ErrInvalidEpisode)
	case strings.TrimSpace(by) == "":
		return Assessment{}, fmt.Errorf("%w: an assessment names who performed it",
			ErrInvalidEpisode)
	}

	performed := in.PerformedAt
	if performed.IsZero() {
		performed = now
	}
	every := in.Every
	if every <= 0 {
		every = DefaultReassessment(in.Kind)
	}

	return Assessment{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		Kind: in.Kind, Scale: strings.TrimSpace(in.Scale), Score: in.Score,
		Findings: copyStrings(in.Findings), Note: strings.TrimSpace(in.Note),
		PerformedAt: performed.UTC(), PerformedBy: strings.TrimSpace(by),
		NextDueAt: performed.UTC().Add(every),
	}, nil
}

// Overdue reports an assessment whose reassessment time has passed.
func (a Assessment) Overdue(now time.Time) bool {
	return !a.NextDueAt.IsZero() && now.After(a.NextDueAt)
}

// DueAssessments returns the assessments a bed is behind on.
//
// Latest per kind, because an assessment done twice does not make the next one
// due sooner and an old one does not stay overdue after a new one.
func DueAssessments(assessments []Assessment, now time.Time) []Assessment {
	latest := map[AssessmentKind]Assessment{}
	for _, a := range assessments {
		if held, ok := latest[a.Kind]; !ok || a.PerformedAt.After(held.PerformedAt) {
			latest[a.Kind] = a
		}
	}

	out := make([]Assessment, 0, len(latest))
	for _, a := range latest {
		if a.Overdue(now) {
			out = append(out, a)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].NextDueAt.Before(out[j].NextDueAt)
	})
	return out
}
