package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Login and session risk scoring (SRS-IAM-015).
//
// The verification clause carries the constraint that shapes everything here:
// "configured high-risk event creates alert without blocking emergency
// workflows unless policy says so". Risk scoring in a hospital is not access
// control. A consultant logging in at 03:00 from an unfamiliar device, in a
// hurry, is both the textbook high-risk signal and the textbook emergency —
// and a system that blocks them has caused a clinical incident to prevent a
// hypothetical one.
//
// So scoring produces an alert and, separately and only when policy says so, a
// block. The two are different outputs of the same evaluation, and the code
// keeps them apart so that raising a signal's weight cannot accidentally start
// denying logins.

// RiskSignal is one observation about an authentication attempt.
type RiskSignal string

const (
	SignalNewDevice          RiskSignal = "new_device"
	SignalNewLocation        RiskSignal = "new_location"
	SignalImpossibleTravel   RiskSignal = "impossible_travel"
	SignalUnusualHour        RiskSignal = "unusual_hour"
	SignalManyFailedAttempts RiskSignal = "many_failed_attempts"
	SignalDormantAccount     RiskSignal = "dormant_account"
	SignalCredentialInBreach RiskSignal = "credential_in_breach"
	SignalConcurrentSessions RiskSignal = "concurrent_sessions"
	SignalPrivilegedRole     RiskSignal = "privileged_role"
	SignalDisabledMFA        RiskSignal = "mfa_disabled"
)

// signalWeights score each signal.
//
// The weights encode judgement rather than measurement, and two are worth
// explaining because they look wrong. Unusual hour scores low: in a hospital,
// most of the day is an unusual hour for somebody, and weighting it highly
// would make night shift permanently suspicious. Impossible travel scores high
// because, unlike the others, it is not a statement about habit — the same
// credential cannot be in two places, so it is evidence of sharing or theft
// rather than of unfamiliarity.
var signalWeights = map[RiskSignal]int{
	SignalNewDevice:          15,
	SignalNewLocation:        10,
	SignalImpossibleTravel:   50,
	SignalUnusualHour:        5,
	SignalManyFailedAttempts: 25,
	SignalDormantAccount:     20,
	SignalCredentialInBreach: 60,
	SignalConcurrentSessions: 10,
	SignalPrivilegedRole:     15,
	SignalDisabledMFA:        20,
}

// Risk thresholds. Score is capped at 100 so a pile-up of weak signals cannot
// outrank a single decisive one by arithmetic alone.
const (
	MaxRiskScore      = 100
	AlertThreshold    = 40
	CriticalThreshold = 70
)

// RiskAssessment is the outcome of scoring one attempt.
type RiskAssessment struct {
	Score   int
	Signals []RiskSignal
	// Alert is whether the security team is told. This is the default output
	// and the one SRS-IAM-015 actually requires.
	Alert bool
	// Critical marks an assessment a human should look at now rather than in
	// the morning.
	Critical bool
	// Block is whether the attempt is refused. False unless policy says
	// otherwise — see BlockPolicy.
	Block bool
	// Reason is a stable code for the outcome.
	Reason string
}

// Stable risk reason codes.
const (
	ReasonRiskAccepted = "RISK_ACCEPTED"
	ReasonRiskAlerted  = "RISK_ALERTED"
	ReasonRiskCritical = "RISK_CRITICAL"
	ReasonRiskBlocked  = "RISK_BLOCKED"
)

// BlockPolicy says when a tenant wants risk to deny rather than merely alert.
//
// Default zero value blocks nothing, which is the safe default for a clinical
// system: a tenant that has not configured this gets alerts and no lockouts.
type BlockPolicy struct {
	// BlockAtScore blocks at or above this score. Zero means never block.
	BlockAtScore int
	// BlockSignals blocks outright on any of these, regardless of score. A
	// credential known to be in a breach corpus is the usual member: that is
	// not a risk signal about the user's habits, it is knowledge that the
	// password is public.
	BlockSignals []RiskSignal
	// NeverBlockEmergency exempts break-glass and downtime flows. Default
	// false is the wrong default for safety, so the constructor below sets it
	// true and a tenant must deliberately turn it off.
	NeverBlockEmergency bool
}

// DefaultBlockPolicy is what a tenant gets before configuring anything:
// alert on everything, block nothing, never stand between a clinician and an
// emergency.
func DefaultBlockPolicy() BlockPolicy {
	return BlockPolicy{NeverBlockEmergency: true}
}

// AssessRisk scores an attempt and decides whether to alert and whether to
// block.
//
// isEmergency marks a break-glass or downtime authentication. Under the
// default policy it can never be blocked — a consultant at 03:00 on an
// unfamiliar device is simultaneously the textbook high-risk signal and the
// textbook emergency, and blocking them causes a clinical incident to prevent
// a hypothetical one. The attempt is still scored and still alerts, so the
// security team sees it immediately.
func AssessRisk(signals []RiskSignal, policy BlockPolicy, isEmergency bool) RiskAssessment {
	seen := map[RiskSignal]bool{}
	score := 0
	unique := make([]RiskSignal, 0, len(signals))

	for _, s := range signals {
		if seen[s] {
			// The same signal twice is one observation reported twice, not
			// twice the risk.
			continue
		}
		seen[s] = true
		unique = append(unique, s)
		score += signalWeights[s]
	}
	if score > MaxRiskScore {
		score = MaxRiskScore
	}
	sort.Slice(unique, func(i, j int) bool { return unique[i] < unique[j] })

	assessment := RiskAssessment{
		Score:    score,
		Signals:  unique,
		Alert:    score >= AlertThreshold,
		Critical: score >= CriticalThreshold,
		Reason:   ReasonRiskAccepted,
	}
	switch {
	case assessment.Critical:
		assessment.Reason = ReasonRiskCritical
	case assessment.Alert:
		assessment.Reason = ReasonRiskAlerted
	}

	// Blocking is decided last and separately, so that raising a signal's
	// weight can never accidentally start denying logins.
	if isEmergency && policy.NeverBlockEmergency {
		return assessment
	}
	for _, blocking := range policy.BlockSignals {
		if seen[blocking] {
			assessment.Block = true
			assessment.Reason = ReasonRiskBlocked
			return assessment
		}
	}
	if policy.BlockAtScore > 0 && score >= policy.BlockAtScore {
		assessment.Block = true
		assessment.Reason = ReasonRiskBlocked
	}
	return assessment
}

// Alert is what reaches the security team.
type Alert struct {
	TenantID   string
	SubjectID  string
	Score      int
	Signals    []RiskSignal
	Critical   bool
	Blocked    bool
	OccurredAt time.Time
	// Summary is a one-line human description. Built here rather than in the
	// notifier so the wording is the same wherever the alert is rendered.
	Summary string
}

// NewAlert builds the alert for an assessment, or reports that none is needed.
func NewAlert(a RiskAssessment, tenantID, subjectID string, now time.Time) (Alert, bool) {
	if !a.Alert && !a.Block {
		return Alert{}, false
	}

	names := make([]string, 0, len(a.Signals))
	for _, s := range a.Signals {
		names = append(names, string(s))
	}
	outcome := "allowed"
	if a.Block {
		outcome = "blocked"
	}

	return Alert{
		TenantID: tenantID, SubjectID: subjectID,
		Score: a.Score, Signals: a.Signals,
		Critical: a.Critical, Blocked: a.Block, OccurredAt: now.UTC(),
		Summary: fmt.Sprintf("sign-in scored %d/%d (%s): %s",
			a.Score, MaxRiskScore, outcome, strings.Join(names, ", ")),
	}, true
}
