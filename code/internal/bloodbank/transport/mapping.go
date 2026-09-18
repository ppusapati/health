// Package transport translates between the blood bank contract and the domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default fails in the safe direction, and for the
// two group enums the safe direction is "unknown", which is incompatible with
// everything.
package transport

import (
	"time"

	bloodbankv1 "github.com/ppusapati/health/code/gen/go/healthcare/bloodbank/v1"
	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp on the wire reads as
		// 1970, and an expiry of 1970 would take a good unit off the shelf.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var aboFromWire = map[bloodbankv1.Abo]domain.ABO{
	bloodbankv1.Abo_ABO_A:  domain.ABOA,
	bloodbankv1.Abo_ABO_B:  domain.ABOB,
	bloodbankv1.Abo_ABO_AB: domain.ABOAB,
	bloodbankv1.Abo_ABO_O:  domain.ABOO,
}

var aboToWire = map[domain.ABO]bloodbankv1.Abo{
	domain.ABOA:  bloodbankv1.Abo_ABO_A,
	domain.ABOB:  bloodbankv1.Abo_ABO_B,
	domain.ABOAB: bloodbankv1.Abo_ABO_AB,
	domain.ABOO:  bloodbankv1.Abo_ABO_O,
}

var rhFromWire = map[bloodbankv1.RhD]domain.RhD{
	bloodbankv1.RhD_RH_D_POSITIVE: domain.RhPositive,
	bloodbankv1.RhD_RH_D_NEGATIVE: domain.RhNegative,
}

var rhToWire = map[domain.RhD]bloodbankv1.RhD{
	domain.RhPositive: bloodbankv1.RhD_RH_D_POSITIVE,
	domain.RhNegative: bloodbankv1.RhD_RH_D_NEGATIVE,
}

// groupFromProto reads a group off the wire.
//
// An unset enum maps to the domain's unknown, which is incompatible with
// everything in both directions. That is the whole safety property: a client
// that forgot the field must not have its patient read as group O.
func groupFromProto(in *bloodbankv1.BloodGroup) domain.Group {
	if in == nil {
		return domain.Group{}
	}
	return domain.Group{
		ABO: aboFromWire[in.GetAbo()], Rh: rhFromWire[in.GetRhD()],
	}
}

func groupToProto(in domain.Group) *bloodbankv1.BloodGroup {
	return &bloodbankv1.BloodGroup{
		Abo: aboToWire[in.ABO], RhD: rhToWire[in.Rh],
		// Rendered the way a label reads it, so a bedside screen need not
		// reimplement the formatting.
		Display: in.String(),
	}
}

var classFromWire = map[bloodbankv1.ComponentClass]domain.ComponentClass{
	bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS:       domain.ClassRedCells,
	bloodbankv1.ComponentClass_COMPONENT_CLASS_PLASMA:          domain.ClassPlasma,
	bloodbankv1.ComponentClass_COMPONENT_CLASS_PLATELETS:       domain.ClassPlatelets,
	bloodbankv1.ComponentClass_COMPONENT_CLASS_CRYOPRECIPITATE: domain.ClassCryo,
	bloodbankv1.ComponentClass_COMPONENT_CLASS_WHOLE_BLOOD:     domain.ClassWholeBlood,
}

// componentClass maps the wire enum. An unset one stays empty, which the
// domain refuses: guessing red cells for a client that forgot the field would
// apply the wrong compatibility table.
func componentClass(in bloodbankv1.ComponentClass) domain.ComponentClass {
	return classFromWire[in]
}

var classToWire = map[domain.ComponentClass]bloodbankv1.ComponentClass{
	domain.ClassRedCells:   bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
	domain.ClassPlasma:     bloodbankv1.ComponentClass_COMPONENT_CLASS_PLASMA,
	domain.ClassPlatelets:  bloodbankv1.ComponentClass_COMPONENT_CLASS_PLATELETS,
	domain.ClassCryo:       bloodbankv1.ComponentClass_COMPONENT_CLASS_CRYOPRECIPITATE,
	domain.ClassWholeBlood: bloodbankv1.ComponentClass_COMPONENT_CLASS_WHOLE_BLOOD,
}

var statusToWire = map[domain.UnitStatus]bloodbankv1.UnitStatus{
	domain.UnitQuarantined: bloodbankv1.UnitStatus_UNIT_STATUS_QUARANTINED,
	domain.UnitAvailable:   bloodbankv1.UnitStatus_UNIT_STATUS_AVAILABLE,
	domain.UnitReserved:    bloodbankv1.UnitStatus_UNIT_STATUS_RESERVED,
	domain.UnitIssued:      bloodbankv1.UnitStatus_UNIT_STATUS_ISSUED,
	domain.UnitTransfused:  bloodbankv1.UnitStatus_UNIT_STATUS_TRANSFUSED,
	domain.UnitDiscarded:   bloodbankv1.UnitStatus_UNIT_STATUS_DISCARDED,
	domain.UnitUnsuitable:  bloodbankv1.UnitStatus_UNIT_STATUS_UNSUITABLE,
}

var discardFromWire = map[bloodbankv1.DiscardReason]domain.DiscardReason{
	bloodbankv1.DiscardReason_DISCARD_REASON_EXPIRED:                domain.DiscardExpired,
	bloodbankv1.DiscardReason_DISCARD_REASON_TEST_FAILED:            domain.DiscardTestFailed,
	bloodbankv1.DiscardReason_DISCARD_REASON_TEMPERATURE_BREACH:     domain.DiscardBreach,
	bloodbankv1.DiscardReason_DISCARD_REASON_OUT_OF_TIME:            domain.DiscardTimeOut,
	bloodbankv1.DiscardReason_DISCARD_REASON_DAMAGED:                domain.DiscardDamaged,
	bloodbankv1.DiscardReason_DISCARD_REASON_RECALLED:               domain.DiscardRecalled,
	bloodbankv1.DiscardReason_DISCARD_REASON_REACTION_INVESTIGATION: domain.DiscardReactionInv,
}

var discardToWire = map[domain.DiscardReason]bloodbankv1.DiscardReason{
	domain.DiscardExpired:     bloodbankv1.DiscardReason_DISCARD_REASON_EXPIRED,
	domain.DiscardTestFailed:  bloodbankv1.DiscardReason_DISCARD_REASON_TEST_FAILED,
	domain.DiscardBreach:      bloodbankv1.DiscardReason_DISCARD_REASON_TEMPERATURE_BREACH,
	domain.DiscardTimeOut:     bloodbankv1.DiscardReason_DISCARD_REASON_OUT_OF_TIME,
	domain.DiscardDamaged:     bloodbankv1.DiscardReason_DISCARD_REASON_DAMAGED,
	domain.DiscardRecalled:    bloodbankv1.DiscardReason_DISCARD_REASON_RECALLED,
	domain.DiscardReactionInv: bloodbankv1.DiscardReason_DISCARD_REASON_REACTION_INVESTIGATION,
}

var deferralFromWire = map[bloodbankv1.DeferralKind]domain.DeferralKind{
	bloodbankv1.DeferralKind_DEFERRAL_KIND_TEMPORARY: domain.DeferralTemporary,
	bloodbankv1.DeferralKind_DEFERRAL_KIND_PERMANENT: domain.DeferralPermanent,
}

var deferralToWire = map[domain.DeferralKind]bloodbankv1.DeferralKind{
	domain.DeferralTemporary: bloodbankv1.DeferralKind_DEFERRAL_KIND_TEMPORARY,
	domain.DeferralPermanent: bloodbankv1.DeferralKind_DEFERRAL_KIND_PERMANENT,
}

var urgencyFromWire = map[bloodbankv1.RequestUrgency]domain.RequestUrgency{
	bloodbankv1.RequestUrgency_REQUEST_URGENCY_ROUTINE:   domain.UrgencyRoutine,
	bloodbankv1.RequestUrgency_REQUEST_URGENCY_URGENT:    domain.UrgencyUrgent,
	bloodbankv1.RequestUrgency_REQUEST_URGENCY_EMERGENCY: domain.UrgencyEmergency,
}

// urgency maps the wire enum. An unset one stays empty, which the domain
// defaults to routine — the safe direction, because a client that forgot the
// field must not have its request jump the queue.
func urgency(in bloodbankv1.RequestUrgency) domain.RequestUrgency {
	return urgencyFromWire[in]
}

var urgencyToWire = map[domain.RequestUrgency]bloodbankv1.RequestUrgency{
	domain.UrgencyRoutine:   bloodbankv1.RequestUrgency_REQUEST_URGENCY_ROUTINE,
	domain.UrgencyUrgent:    bloodbankv1.RequestUrgency_REQUEST_URGENCY_URGENT,
	domain.UrgencyEmergency: bloodbankv1.RequestUrgency_REQUEST_URGENCY_EMERGENCY,
}

var requestStatusToWire = map[domain.RequestStatus]bloodbankv1.RequestStatus{
	domain.RequestOpen:      bloodbankv1.RequestStatus_REQUEST_STATUS_OPEN,
	domain.RequestFulfilled: bloodbankv1.RequestStatus_REQUEST_STATUS_FULFILLED,
	domain.RequestCancelled: bloodbankv1.RequestStatus_REQUEST_STATUS_CANCELLED,
}

var matchRefusalToWire = map[domain.MatchRefusal]bloodbankv1.MatchRefusal{
	domain.RefusalUnitNotAllocatable: bloodbankv1.MatchRefusal_MATCH_REFUSAL_UNIT_NOT_ALLOCATABLE,
	domain.RefusalUnitExpired:        bloodbankv1.MatchRefusal_MATCH_REFUSAL_UNIT_EXPIRED,
	domain.RefusalNoSample:           bloodbankv1.MatchRefusal_MATCH_REFUSAL_NO_VALID_SAMPLE,
	domain.RefusalGroupIncompatible:  bloodbankv1.MatchRefusal_MATCH_REFUSAL_GROUP_INCOMPATIBLE,
	domain.RefusalWrongComponent:     bloodbankv1.MatchRefusal_MATCH_REFUSAL_WRONG_COMPONENT_TYPE,
	domain.RefusalMissingAttribute:   bloodbankv1.MatchRefusal_MATCH_REFUSAL_MISSING_SPECIAL_REQUIREMENT,
	domain.RefusalCrossmatchReactive: bloodbankv1.MatchRefusal_MATCH_REFUSAL_CROSSMATCH_REACTIVE,
}

var bedsideRefusalToWire = map[domain.BedsideRefusal]bloodbankv1.BedsideRefusal{
	domain.BedsideWrongUnit:     bloodbankv1.BedsideRefusal_BEDSIDE_REFUSAL_WRONG_UNIT,
	domain.BedsideWrongPatient:  bloodbankv1.BedsideRefusal_BEDSIDE_REFUSAL_WRONG_PATIENT,
	domain.BedsideGroupMismatch: bloodbankv1.BedsideRefusal_BEDSIDE_REFUSAL_GROUP_MISMATCH,
	domain.BedsideSoloCheck:     bloodbankv1.BedsideRefusal_BEDSIDE_REFUSAL_SOLO_CHECK,
	domain.BedsideUnitExpired:   bloodbankv1.BedsideRefusal_BEDSIDE_REFUSAL_UNIT_EXPIRED,
	domain.BedsideNotIssued:     bloodbankv1.BedsideRefusal_BEDSIDE_REFUSAL_NOT_ISSUED,
}

var episodeStatusToWire = map[domain.EpisodeStatus]bloodbankv1.EpisodeStatus{
	domain.EpisodeRunning:     bloodbankv1.EpisodeStatus_EPISODE_STATUS_RUNNING,
	domain.EpisodeInterrupted: bloodbankv1.EpisodeStatus_EPISODE_STATUS_INTERRUPTED,
	domain.EpisodeCompleted:   bloodbankv1.EpisodeStatus_EPISODE_STATUS_COMPLETED,
	domain.EpisodeStopped:     bloodbankv1.EpisodeStatus_EPISODE_STATUS_STOPPED,
}

var severityFromWire = map[bloodbankv1.ReactionSeverity]domain.ReactionSeverity{
	bloodbankv1.ReactionSeverity_REACTION_SEVERITY_MILD:     domain.ReactionMild,
	bloodbankv1.ReactionSeverity_REACTION_SEVERITY_MODERATE: domain.ReactionModerate,
	bloodbankv1.ReactionSeverity_REACTION_SEVERITY_SEVERE:   domain.ReactionSevere,
	bloodbankv1.ReactionSeverity_REACTION_SEVERITY_FATAL:    domain.ReactionFatal,
}

var severityToWire = map[domain.ReactionSeverity]bloodbankv1.ReactionSeverity{
	domain.ReactionMild:     bloodbankv1.ReactionSeverity_REACTION_SEVERITY_MILD,
	domain.ReactionModerate: bloodbankv1.ReactionSeverity_REACTION_SEVERITY_MODERATE,
	domain.ReactionSevere:   bloodbankv1.ReactionSeverity_REACTION_SEVERITY_SEVERE,
	domain.ReactionFatal:    bloodbankv1.ReactionSeverity_REACTION_SEVERITY_FATAL,
}

var investigationToWire = map[domain.InvestigationState]bloodbankv1.InvestigationState{
	domain.InvestigationOpen:      bloodbankv1.InvestigationState_INVESTIGATION_STATE_OPEN,
	domain.InvestigationConcluded: bloodbankv1.InvestigationState_INVESTIGATION_STATE_CONCLUDED,
}

var reservationStatusToWire = map[domain.ReservationStatus]bloodbankv1.ReservationStatus{
	domain.ReservationHeld:     bloodbankv1.ReservationStatus_RESERVATION_STATUS_HELD,
	domain.ReservationIssued:   bloodbankv1.ReservationStatus_RESERVATION_STATUS_ISSUED,
	domain.ReservationReleased: bloodbankv1.ReservationStatus_RESERVATION_STATUS_RELEASED,
	domain.ReservationExpired:  bloodbankv1.ReservationStatus_RESERVATION_STATUS_EXPIRED,
}

var alertKindToWire = map[domain.StockAlertKind]bloodbankv1.StockAlertKind{
	domain.AlertLowStock: bloodbankv1.StockAlertKind_STOCK_ALERT_KIND_LOW_STOCK,
	domain.AlertExpiring: bloodbankv1.StockAlertKind_STOCK_ALERT_KIND_EXPIRING,
}

func donorToProto(in domain.Donor, now time.Time) *bloodbankv1.Donor {
	return &bloodbankv1.Donor{
		DonorId: in.ID, DonorNumber: in.DonorNumber, PatientId: in.PatientID,
		DisplayName: in.Name, ContactPhone: in.ContactPhone,
		Group:        groupToProto(in.Group),
		Deferral:     deferralToWire[in.Deferral],
		DeferralCode: in.DeferralCode, DeferralNote: in.DeferralNote,
		DeferredAt: stamp(in.DeferredAt), DeferredBy: in.DeferredBy,
		DeferredUntil: stamp(in.DeferredUntil),
		// Derived at the moment of rendering, so a temporary deferral lapses on
		// its own date rather than waiting for somebody to clear it.
		CurrentlyDeferred: in.Deferred(now),
		RegisteredAt:      stamp(in.RegisteredAt), RegisteredBy: in.RegisteredBy,
		Version: in.Version,
	}
}

func screeningToProto(in domain.Screening) *bloodbankv1.Screening {
	return &bloodbankv1.Screening{
		ScreeningId: in.ID, DonorId: in.DonorID,
		Answers: in.Answers, Measurements: in.Measurements,
		Consented: in.Consented, ConsentNote: in.ConsentNote,
		Accepted: in.Accepted,
		Deferral: deferralToWire[in.Deferral], DeferralCode: in.DeferralCode,
		ScreenedAt: stamp(in.ScreenedAt), ScreenedBy: in.ScreenedBy,
	}
}

func collectionToProto(in domain.Collection) *bloodbankv1.Collection {
	return &bloodbankv1.Collection{
		CollectionId: in.ID, DonorId: in.DonorID, ScreeningId: in.ScreeningID,
		DonationNumber: in.DonationNumber, Kind: in.Kind,
		VolumeMl: int32(in.VolumeML), Group: groupToProto(in.Group),
		CollectedAt: stamp(in.CollectedAt), CollectedBy: in.CollectedBy,
		AdverseEvent: in.AdverseEvent, AdverseNote: in.AdverseNote,
	}
}

func testResultToProto(in domain.TestResult) *bloodbankv1.TestResult {
	return &bloodbankv1.TestResult{
		TestId: in.ID, CollectionId: in.CollectionID,
		Code: in.Code, Display: in.Display, Reactive: in.Reactive,
		Value: in.Value, Method: in.Method,
		TestedAt: stamp(in.TestedAt), TestedBy: in.TestedBy,
	}
}

func componentToProto(in domain.Component, now time.Time) *bloodbankv1.Component {
	return &bloodbankv1.Component{
		ComponentId: in.ID, UnitNumber: in.UnitNumber,
		CollectionId: in.CollectionID, DonorId: in.DonorID, Source: in.Source,
		ComponentClass: classToWire[in.Class],
		Group:          groupToProto(in.Group),
		Status:         statusToWire[in.Status],
		DiscardReason:  discardToWire[in.DiscardReason],
		VolumeMl:       int32(in.VolumeML),
		Attributes:     in.Attributes, Location: in.Location,
		CollectedAt: stamp(in.CollectedAt), ExpiresAt: stamp(in.ExpiresAt),
		// Derived, so a client cannot offer an expired unit by checking only
		// the status: the two fail independently.
		Issuable:  in.Issuable(now),
		CreatedAt: stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
}

func componentsToProto(in []domain.Component, now time.Time) []*bloodbankv1.Component {
	out := make([]*bloodbankv1.Component, 0, len(in))
	for _, component := range in {
		out = append(out, componentToProto(component, now))
	}
	return out
}

func requestToProto(in domain.Request) *bloodbankv1.Request {
	return &bloodbankv1.Request{
		RequestId: in.ID, PatientId: in.PatientID,
		EncounterId: in.EncounterID, FacilityId: in.FacilityID,
		ComponentClass: classToWire[in.Class], Quantity: int32(in.Quantity),
		Indication: in.Indication, Urgency: urgencyToWire[in.Urgency],
		Requirements: in.Requirements, RequiredBy: stamp(in.RequiredBy),
		Status:      requestStatusToWire[in.Status],
		RequestedBy: in.RequestedBy, RequestedAt: stamp(in.RequestedAt),
		Version: in.Version,
	}
}

func requestsToProto(in []domain.Request) []*bloodbankv1.Request {
	out := make([]*bloodbankv1.Request, 0, len(in))
	for _, request := range in {
		out = append(out, requestToProto(request))
	}
	return out
}

func sampleToProto(in domain.PatientSample) *bloodbankv1.PatientSample {
	return &bloodbankv1.PatientSample{
		SampleId: in.ID, PatientId: in.PatientID,
		SampleNumber: in.SampleNumber, Group: groupToProto(in.Group),
		AntibodyScreenPositive: in.AntibodyScreenPositive,
		AntibodyNote:           in.AntibodyNote,
		SecondCheck:            in.SecondCheck,
		CollectedAt:            stamp(in.CollectedAt),
		CollectedBy:            in.CollectedBy,
		ExpiresAt:              stamp(in.ExpiresAt),
		TestedAt:               stamp(in.TestedAt), TestedBy: in.TestedBy,
	}
}

func matchDecisionToProto(in domain.MatchDecision) *bloodbankv1.MatchDecision {
	refusals := make([]bloodbankv1.MatchRefusal, 0, len(in.Refusals))
	for _, refusal := range in.Refusals {
		refusals = append(refusals, matchRefusalToWire[refusal])
	}
	return &bloodbankv1.MatchDecision{
		Allowed: in.Allowed(), Refusals: refusals,
		Explanations: in.Explanations,
	}
}

func reservationToProto(in domain.Reservation) *bloodbankv1.Reservation {
	return &bloodbankv1.Reservation{
		ReservationId: in.ID, ComponentId: in.ComponentID,
		RequestId: in.RequestID, PatientId: in.PatientID, SampleId: in.SampleID,
		Crossmatched: in.Crossmatched, CrossmatchNote: in.CrossmatchNote,
		Status:     reservationStatusToWire[in.Status],
		ExpiresAt:  stamp(in.ExpiresAt),
		ReservedAt: stamp(in.ReservedAt), ReservedBy: in.ReservedBy,
		ReleasedReason: in.ReleasedReason,
	}
}

func issueToProto(in domain.Issue) *bloodbankv1.Issue {
	return &bloodbankv1.Issue{
		IssueId: in.ID, ComponentId: in.ComponentID,
		ReservationId: in.ReservationID, PatientId: in.PatientID,
		RequestId: in.RequestID, Destination: in.Destination,
		Emergency:           in.Emergency,
		EmergencyAuthoriser: in.EmergencyAuthoriser,
		EmergencyReason:     in.EmergencyReason,
		Reconciled:          in.Reconciled,
		ReconciledAt:        stamp(in.ReconciledAt),
		ReconciledBy:        in.ReconciledBy,
		ReconcileNote:       in.ReconcileNote,
		IssuedAt:            stamp(in.IssuedAt), IssuedBy: in.IssuedBy,
		IssuedTo: in.IssuedTo, CheckedBy: in.CheckedBy,
	}
}

func issuesToProto(in []domain.Issue) []*bloodbankv1.Issue {
	out := make([]*bloodbankv1.Issue, 0, len(in))
	for _, issue := range in {
		out = append(out, issueToProto(issue))
	}
	return out
}

func observationToProto(in domain.Observation) *bloodbankv1.Observation {
	return &bloodbankv1.Observation{
		ObservationId: in.ID, EpisodeId: in.EpisodeID,
		Timing: in.Timing, Values: in.Values, Note: in.Note,
		ObservedAt: stamp(in.ObservedAt), ObservedBy: in.ObservedBy,
	}
}

func episodeToProto(in domain.Episode) *bloodbankv1.Episode {
	observations := make([]*bloodbankv1.Observation, 0, len(in.Observations))
	for _, observation := range in.Observations {
		observations = append(observations, observationToProto(observation))
	}
	return &bloodbankv1.Episode{
		EpisodeId: in.ID, ComponentId: in.ComponentID, IssueId: in.IssueID,
		PatientId: in.PatientID, EncounterId: in.EncounterID,
		Status:    episodeStatusToWire[in.Status],
		StartedAt: stamp(in.StartedAt), StartedBy: in.StartedBy,
		EndedAt: stamp(in.EndedAt), VolumeGivenMl: int32(in.VolumeGivenML),
		StopReason: in.StopReason, Observations: observations,
	}
}

func episodesToProto(in []domain.Episode) []*bloodbankv1.Episode {
	out := make([]*bloodbankv1.Episode, 0, len(in))
	for _, episode := range in {
		out = append(out, episodeToProto(episode))
	}
	return out
}

func reactionToProto(in domain.Reaction) *bloodbankv1.Reaction {
	return &bloodbankv1.Reaction{
		ReactionId: in.ID, EpisodeId: in.EpisodeID,
		ComponentId: in.ComponentID, PatientId: in.PatientID,
		Severity: severityToWire[in.Severity],
		Features: in.Features, Note: in.Note,
		ReportedAt: stamp(in.ReportedAt), ReportedBy: in.ReportedBy,
		State:          investigationToWire[in.State],
		Classification: in.Classification, Conclusion: in.Conclusion,
		ConcludedAt: stamp(in.ConcludedAt), ConcludedBy: in.ConcludedBy,
		UnitReturned: in.UnitReturned,
	}
}

func reactionsToProto(in []domain.Reaction) []*bloodbankv1.Reaction {
	out := make([]*bloodbankv1.Reaction, 0, len(in))
	for _, reaction := range in {
		out = append(out, reactionToProto(reaction))
	}
	return out
}

func chainToProto(in domain.Chain) *bloodbankv1.Chain {
	links := make([]*bloodbankv1.ChainLink, 0, len(in.Links))
	for _, link := range in.Links {
		links = append(links, &bloodbankv1.ChainLink{
			Stage: link.Stage, Id: link.ID, Label: link.Label,
			At: stamp(link.At), By: link.By,
		})
	}
	return &bloodbankv1.Chain{
		ComponentId: in.ComponentID, UnitNumber: in.UnitNumber,
		Links: links,
		// Named, so a reader can tell "never transfused" from "we have lost
		// the transfusion record".
		Gaps: in.Gaps,
	}
}

func recipientsToProto(in []ports.Recipient) []*bloodbankv1.Recipient {
	out := make([]*bloodbankv1.Recipient, 0, len(in))
	for _, recipient := range in {
		out = append(out, &bloodbankv1.Recipient{
			PatientId: recipient.PatientID, EpisodeId: recipient.EpisodeID,
			ComponentId: recipient.ComponentID,
			UnitNumber:  recipient.UnitNumber, At: stamp(recipient.At),
		})
	}
	return out
}

func stockToProto(levels []domain.StockLevel,
	alerts []domain.StockAlert) ([]*bloodbankv1.StockLevel,
	[]*bloodbankv1.StockAlert) {

	outLevels := make([]*bloodbankv1.StockLevel, 0, len(levels))
	for _, level := range levels {
		outLevels = append(outLevels, &bloodbankv1.StockLevel{
			ComponentClass: classToWire[level.Class],
			Group:          groupToProto(level.Group),
			Available:      int32(level.Available),
			ExpiringSoon:   int32(level.ExpiringSoon),
			Quarantined:    int32(level.Quarantined),
			Reserved:       int32(level.Reserved),
		})
	}

	outAlerts := make([]*bloodbankv1.StockAlert, 0, len(alerts))
	for _, alert := range alerts {
		outAlerts = append(outAlerts, &bloodbankv1.StockAlert{
			Kind:           alertKindToWire[alert.Kind],
			ComponentClass: classToWire[alert.Class],
			Group:          groupToProto(alert.Group),
			Available:      int32(alert.Available),
			Minimum:        int32(alert.Minimum),
			Count:          int32(alert.Count),
			Message:        alert.Message,
		})
	}
	return outLevels, outAlerts
}

func utilisationToProto(in domain.Utilisation) *bloodbankv1.Utilisation {
	byIndication := make(map[string]int32, len(in.ByIndication))
	for indication, count := range in.ByIndication {
		byIndication[indication] = int32(count)
	}
	return &bloodbankv1.Utilisation{
		Issued: int32(in.Issued), Transfused: int32(in.Transfused),
		Returned: int32(in.Returned), Discarded: int32(in.Discarded),
		Reactions:               int32(in.Reactions),
		EmergencyReleases:       int32(in.EmergencyReleases),
		UnreconciledReleases:    int32(in.UnreconciledReleases),
		Reservations:            int32(in.Reservations),
		CrossmatchToTransfusion: in.CrossmatchToTransfusion,
		ByIndication:            byIndication,
	}
}
