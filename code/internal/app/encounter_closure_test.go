package app_test

import (
	"context"
	"strings"
	"testing"
	"time"

	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Diagnoses, the closure gate, the visit summary and the timeline
// (SRS-ENC-007 … SRS-ENC-012).

// icd is a coded diagnosis with everything a code needs to be acted on.
func icd(code, display string) *encounterv1.Coding {
	return &encounterv1.Coding{
		System: "icd-10", Version: "2019", Code: code, Display: display,
	}
}

// consultation opens an encounter, records a final primary diagnosis and ends
// it — the ordinary path, which most of these tests start from.
func (h *encHarness) consultation(t *testing.T, patient string) *encounterv1.Encounter {
	t.Helper()

	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	if _, err := h.encounters.RecordDiagnosis(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.RecordDiagnosisRequest{
			EncounterId: encounter.GetEncounterId(),
			Code:        icd("I21.9", "Acute myocardial infarction"),
			Certainty:   encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
			Rank:        encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY,
		})); err != nil {
		t.Fatalf("RecordDiagnosis: %v", err)
	}

	ended, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		}))
	if err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}
	return ended.Msg.GetEncounter()
}

// SRS-ENC-007: "a code with no terminology is a number nobody can safely act
// on".
func TestADiagnosisNeedsItsTerminologyAndADisplayTerm(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	cases := map[string]*encounterv1.Coding{
		"no terminology":  {Code: "I21.9", Display: "MI"},
		"no display term": {System: "icd-10", Code: "I21.9"},
		"no code":         {System: "icd-10", Display: "MI"},
	}
	for name, code := range cases {
		t.Run(name, func(t *testing.T) {
			if _, err := h.encounters.RecordDiagnosis(context.Background(),
				withFacility(h.clinicianToken(), h.facility,
					&encounterv1.RecordDiagnosisRequest{
						EncounterId: encounter.GetEncounterId(), Code: code,
						Certainty: encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
						Rank:      encounterv1.DiagnosisRank_DIAGNOSIS_RANK_SECONDARY,
					})); err == nil {
				t.Fatalf("a diagnosis with %s was accepted", name)
			}
		})
	}
}

// SRS-ENC-007: "diagnosis history and author/time retained".
//
// A differential that became a final diagnosis is a clinical reasoning trail,
// and overwriting it destroys the only evidence that the reasoning happened.
func TestRevisingADiagnosisKeepsTheReasoningTrail(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	working, err := h.encounters.RecordDiagnosis(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.RecordDiagnosisRequest{
			EncounterId: encounter.GetEncounterId(),
			Code:        icd("R07.4", "Chest pain, unspecified"),
			Certainty:   encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_PROVISIONAL,
			Rank:        encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY,
		}))
	if err != nil {
		t.Fatalf("RecordDiagnosis: %v", err)
	}

	// A second primary supersedes the first without the caller having to say
	// so: the rank answers "what was this visit about", and two answers is no
	// answer.
	confirmed, err := h.encounters.RecordDiagnosis(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.RecordDiagnosisRequest{
			EncounterId: encounter.GetEncounterId(),
			Code:        icd("I21.9", "Acute myocardial infarction"),
			Certainty:   encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
			Rank:        encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY,
		}))
	if err != nil {
		t.Fatalf("RecordDiagnosis (confirmed): %v", err)
	}

	trail, err := h.encounters.ListDiagnoses(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.ListDiagnosesRequest{
			EncounterId: encounter.GetEncounterId(),
		}))
	if err != nil {
		t.Fatalf("ListDiagnoses: %v", err)
	}
	if len(trail.Msg.GetDiagnoses()) != 2 {
		t.Fatalf("%d diagnoses on the encounter, want both — the working "+
			"diagnosis is the reasoning trail", len(trail.Msg.GetDiagnoses()))
	}

	for _, d := range trail.Msg.GetDiagnoses() {
		if d.GetDiagnosisId() == working.Msg.GetDiagnosis().GetDiagnosisId() {
			if d.GetSupersededById() != confirmed.Msg.GetDiagnosis().GetDiagnosisId() {
				t.Fatal("the working diagnosis does not chain forwards to the confirmed one")
			}
		}
	}

	// The patient's live conditions show only what still stands.
	live, err := h.encounters.ListDiagnoses(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.ListDiagnosesRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("ListDiagnoses (patient): %v", err)
	}
	if len(live.Msg.GetDiagnoses()) != 1 {
		t.Fatalf("%d live conditions, want only the confirmed infarction",
			len(live.Msg.GetDiagnoses()))
	}
	if live.Msg.GetDiagnoses()[0].GetCode().GetCode() != "I21.9" {
		t.Fatal("the superseded working diagnosis is still presented as live")
	}
}

// A clerk opens and closes encounters all day. Recording what is wrong with the
// patient is a clinical act.
func TestAClerkCannotRecordADiagnosis(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	_, err := h.encounters.RecordDiagnosis(context.Background(),
		withFacility(h.clerkToken(), h.facility, &encounterv1.RecordDiagnosisRequest{
			EncounterId: encounter.GetEncounterId(),
			Code:        icd("I21.9", "Acute myocardial infarction"),
			Certainty:   encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
			Rank:        encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY,
		}))
	if err == nil {
		t.Fatal("a registration clerk recorded a diagnosis under their own name")
	}
	if !strings.Contains(strings.ToLower(err.Error()), "permission") {
		t.Fatalf("the refusal is not a permission one: %v", err)
	}
}

// A closed encounter is amended, not added to.
func TestAClosedEncounterTakesNoNewDiagnosis(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.consultation(t, patient)

	if _, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
			Narrative:   "Seen with chest pain. Troponin raised.",
		})); err != nil {
		t.Fatalf("CloseEncounter: %v", err)
	}

	_, err := h.encounters.RecordDiagnosis(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.RecordDiagnosisRequest{
			EncounterId: encounter.GetEncounterId(),
			Code:        icd("E11", "Type 2 diabetes"),
			Certainty:   encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
			Rank:        encounterv1.DiagnosisRank_DIAGNOSIS_RANK_SECONDARY,
		}))
	if err == nil {
		t.Fatal("a diagnosis was added to a closed encounter, so its chronology " +
			"can be silently rewritten")
	}
	if !strings.Contains(err.Error(), "amended") {
		t.Fatalf("the refusal does not point at the amendment route: %v", err)
	}
}

// SRS-ENC-008: "blocking items listed".
func TestAnIncompleteEncounterCannotBeClosedAndSaysWhy(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	// Started and ended, but nothing diagnosed.
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)
	if _, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}

	_, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(), Narrative: "Reassured.",
		}))
	if err == nil {
		t.Fatal("an encounter with no diagnosis was closed")
	}
	// Written as the action to take rather than the rule that was broken.
	if !strings.Contains(err.Error(), "record a final diagnosis") {
		t.Fatalf("the refusal does not tell the clinician what to do: %v", err)
	}
}

// SRS-ENC-008: "emergency override where policy allows; override reason
// audited".
func TestAnEmergencyEncounterCanBeForcedClosedWithAnAuditedReason(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_EMERGENCY)
	if _, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}

	// Without the reason it is blocked, exactly like the routine case.
	if _, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(), Narrative: "Resuscitated.",
		})); err == nil {
		t.Fatal("an incomplete emergency encounter closed with no override reason")
	}

	const reason = "resuscitation in progress, documenting afterwards"
	closed, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(), Narrative: "Resuscitated.",
			OverrideReason: reason,
		}))
	if err != nil {
		t.Fatalf("CloseEncounter with override: %v", err)
	}
	if !closed.Msg.GetOverridden() {
		t.Fatal("the closure does not report itself as overridden")
	}
	if len(closed.Msg.GetMissingItems()) == 0 {
		t.Fatal("the override does not say what was outstanding, so a quality " +
			"report cannot say what is being skipped")
	}

	// Stored, not just audited: the audit trail answers "who did this", and
	// this answers "how often does this happen and for what".
	overrides, err := h.encounters.ListClosureOverrides(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.ListClosureOverridesRequest{
				EncounterId: encounter.GetEncounterId(),
			}))
	if err != nil {
		t.Fatalf("ListClosureOverrides: %v", err)
	}
	if len(overrides.Msg.GetOverrides()) != 1 {
		t.Fatalf("%d overrides recorded, want 1", len(overrides.Msg.GetOverrides()))
	}
	if overrides.Msg.GetOverrides()[0].GetReason() != reason {
		t.Fatal("the stated reason was not kept")
	}

	var actor string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT actor_id FROM platform_data.audit_record
		 WHERE resource_id = $1 AND reason LIKE 'closed over incomplete%'`,
		encounter.GetEncounterId()).Scan(&actor); err != nil {
		t.Fatalf("the override was not audited: %v", err)
	}
	if actor != "doctor-1" {
		t.Fatalf("the audit names %q, want the clinician who forced the closure", actor)
	}
}

// A routine outpatient encounter cannot be forced by default: only the
// emergency department's own judgement is in scope for the requirement's
// "where policy allows" clause.
func TestARoutineEncounterCannotBeForcedClosed(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)
	if _, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}

	_, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(), Narrative: "Reassured.",
			OverrideReason: "in a hurry, will finish the notes later",
		}))
	if err == nil {
		t.Fatal("a routine outpatient encounter was force-closed")
	}
	if !strings.Contains(err.Error(), "does not allow") {
		t.Fatalf("the refusal does not say it is a policy decision: %v", err)
	}
}

// Forcing a complete encounter would put a false entry in the report that
// exists to count real ones.
func TestOverridingACompleteEncounterIsRefused(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_EMERGENCY)
	if _, err := h.encounters.RecordDiagnosis(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.RecordDiagnosisRequest{
			EncounterId: encounter.GetEncounterId(),
			Code:        icd("I21.9", "Acute myocardial infarction"),
			Certainty:   encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
			Rank:        encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY,
		})); err != nil {
		t.Fatalf("RecordDiagnosis: %v", err)
	}
	if _, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}

	_, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(), Narrative: "Treated.",
			OverrideReason: "resuscitation in progress, documenting afterwards",
		}))
	if err == nil {
		t.Fatal("a complete encounter was closed with an override, which would " +
			"inflate the report the override exists to make possible")
	}
}

// A facility can configure its own gate (SRS-ENC-008).
func TestAFacilityCanConfigureWhatBlocksAClosure(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	// This hospital's outpatient clinics require nothing but an end time, and
	// allow an override.
	if _, err := h.encounters.SetClosurePolicy(context.Background(),
		as(tenantAdminToken(h.tenantID), &encounterv1.SetClosurePolicyRequest{
			FacilityId: h.facility,
			Classes: []*encounterv1.ClosurePolicyForClass{{
				Class:         encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
				RequiredItems: []string{"end_time"},
				AllowOverride: true,
			}},
		})); err != nil {
		t.Fatalf("SetClosurePolicy: %v", err)
	}

	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)
	if _, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}

	// No diagnosis, and it closes: this facility does not require one.
	if _, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(), Narrative: "Reassured.",
		})); err != nil {
		t.Fatalf("a configured closure gate still blocked: %v", err)
	}
}

// A clerk does not decide what documentation a hospital requires.
func TestAClerkCannotSetTheClosurePolicy(t *testing.T) {
	h := newEncHarness(t)

	_, err := h.encounters.SetClosurePolicy(context.Background(),
		withFacility(h.clerkToken(), h.facility, &encounterv1.SetClosurePolicyRequest{
			FacilityId: h.facility,
			Classes: []*encounterv1.ClosurePolicyForClass{{
				Class:         encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				RequiredItems: nil,
			}},
		}))
	if err == nil {
		t.Fatal("a registration clerk rewrote the hospital's documentation requirements")
	}
}

// SRS-ENC-009: "closed encounter chronology cannot be silently rewritten".
func TestAVisitSummaryIsAmendedRatherThanRewritten(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.consultation(t, patient)

	closed, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
			Narrative:   "Seen with chest pain. Troponin raised.",
		}))
	if err != nil {
		t.Fatalf("CloseEncounter: %v", err)
	}

	original := closed.Msg.GetSummary()
	if original.GetVersion() != 1 {
		t.Fatalf("summary version = %d, want 1", original.GetVersion())
	}
	if len(original.GetDiagnoses()) != 1 {
		t.Fatal("the summary was generated without the encounter's diagnoses")
	}

	// An amendment with no reason is indistinguishable from a rewrite.
	if _, err := h.encounters.AmendSummary(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.AmendSummaryRequest{
			EncounterId: encounter.GetEncounterId(), Narrative: "Corrected.",
		})); err == nil {
		t.Fatal("a summary was amended with no stated reason")
	}

	amended, err := h.encounters.AmendSummary(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.AmendSummaryRequest{
			EncounterId: encounter.GetEncounterId(),
			Narrative:   "Corrected: troponin was normal.",
			Reason:      "the initial result was transcribed from the wrong patient",
		}))
	if err != nil {
		t.Fatalf("AmendSummary: %v", err)
	}
	if amended.Msg.GetSummary().GetVersion() != 2 {
		t.Fatalf("amended version = %d, want 2", amended.Msg.GetSummary().GetVersion())
	}

	// Both versions stay readable: somebody acted on the first.
	versions, err := h.encounters.GetSummaries(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.GetSummariesRequest{
			EncounterId: encounter.GetEncounterId(),
		}))
	if err != nil {
		t.Fatalf("GetSummaries: %v", err)
	}
	if len(versions.Msg.GetSummaries()) != 2 {
		t.Fatalf("%d summary versions, want both", len(versions.Msg.GetSummaries()))
	}
	for _, s := range versions.Msg.GetSummaries() {
		if s.GetVersion() == 1 &&
			s.GetNarrative() != "Seen with chest pain. Troponin raised." {
			t.Fatal("amending the summary changed the version somebody already read")
		}
	}
}

// SRS-ENC-012: "emit encounter.started/completed/cancelled and
// diagnosis.recorded events" with "event ordering/version deterministic per
// aggregate".
func TestTheEncounterEventsCarryTheAggregateVersion(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Venkataraghavan", "9876543210")
	encounter := h.consultation(t, patient)

	for _, eventType := range []string{
		"encounter.started", "encounter.completed", "diagnosis.recorded",
	} {
		var payload string
		if err := h.pool.QueryRow(context.Background(),
			`SELECT payload::text FROM platform_data.outbox_event
			 WHERE aggregate_id = $1 AND event_type = $2
			 ORDER BY occurred_at LIMIT 1`,
			encounter.GetEncounterId(), eventType).Scan(&payload); err != nil {
			t.Fatalf("no %s event was written: %v", eventType, err)
		}
		if !strings.Contains(payload, `"version"`) {
			t.Fatalf("%s carries no aggregate version, so a consumer cannot order "+
				"two events about one encounter: %s", eventType, payload)
		}
		// Identifiers and times, never the reason for the visit or a
		// diagnosis's free text.
		if strings.Contains(payload, "Venkataraghavan") ||
			strings.Contains(payload, "chest pain") {
			t.Fatalf("%s carries clinical or demographic detail: %s", eventType, payload)
		}
	}

	// A cancelled encounter emits its own event rather than a completion.
	other := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)
	if _, err := h.encounters.CancelEncounter(context.Background(),
		withFacility(h.clerkToken(), h.facility, &encounterv1.CancelEncounterRequest{
			EncounterId: other.GetEncounterId(), Reason: "patient left",
		})); err != nil {
		t.Fatalf("CancelEncounter: %v", err)
	}
	var cancelled int
	if err := h.pool.QueryRow(context.Background(),
		`SELECT count(*) FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'encounter.cancelled'`,
		other.GetEncounterId()).Scan(&cancelled); err != nil {
		t.Fatalf("counting cancellation events: %v", err)
	}
	if cancelled != 1 {
		t.Fatalf("%d encounter.cancelled events, want 1", cancelled)
	}
}

// SRS-ENC-011: the longitudinal timeline, with the encounter's own records on
// it.
func TestTheTimelineShowsEncountersAndDiagnosesNewestFirst(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	h.consultation(t, patient)

	timeline, err := h.encounters.GetTimeline(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.GetTimelineRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("GetTimeline: %v", err)
	}

	entries := timeline.Msg.GetEntries()
	if len(entries) < 2 {
		t.Fatalf("%d timeline entries, want the encounter and its diagnosis",
			len(entries))
	}
	for i := 1; i < len(entries); i++ {
		if entries[i].GetAt().AsTime().After(entries[i-1].GetAt().AsTime()) {
			t.Fatal("the timeline is not in descending time order")
		}
	}

	// A filter is a view and never changes the record (SRS-CLN-018).
	filtered, err := h.encounters.GetTimeline(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.GetTimelineRequest{
			PatientId: patient,
			Kinds: []encounterv1.TimelineEntryKind{
				encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_DIAGNOSIS,
			},
		}))
	if err != nil {
		t.Fatalf("GetTimeline (filtered): %v", err)
	}
	for _, e := range filtered.Msg.GetEntries() {
		if e.GetKind() != encounterv1.TimelineEntryKind_TIMELINE_ENTRY_KIND_DIAGNOSIS {
			t.Fatalf("the diagnosis filter returned a %v entry", e.GetKind())
		}
	}

	again, err := h.encounters.GetTimeline(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.GetTimelineRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("GetTimeline (again): %v", err)
	}
	if len(again.Msg.GetEntries()) != len(entries) {
		t.Fatal("filtering the timeline changed what the unfiltered one returns")
	}
}

// A chart cannot be read across a tenant boundary.
func TestAnEncounterCannotBeReachedFromAnotherTenant(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.consultation(t, patient)

	other := newEncHarness(t)
	_, err := other.encounters.GetEncounter(context.Background(),
		withFacility(other.clinicianToken(), other.facility,
			&encounterv1.GetEncounterRequest{
				EncounterId: encounter.GetEncounterId(),
			}))
	if err == nil {
		t.Fatal("another tenant's encounter is readable")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that an identifier exists in somebody else's tenant.
	if !strings.Contains(strings.ToLower(err.Error()), "not_found") &&
		!strings.Contains(strings.ToLower(err.Error()), "no such") {
		t.Fatalf("the refusal confirms the encounter exists elsewhere: %v", err)
	}
}

// An encounter cannot be opened against a patient this tenant does not hold.
func TestAnEncounterCannotBeOpenedForAnotherTenantsPatient(t *testing.T) {
	h := newEncHarness(t)
	other := newEncHarness(t)
	theirs := other.registerPatient(t, "Iyer", "9876543210")

	_, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: theirs, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
			AttendingProviderId: "doctor-1", Reason: "review",
		}))
	if err == nil {
		t.Fatal("an encounter was opened against another tenant's patient")
	}
}

// SRS-ENC-003: a consultation that runs long is recorded as it happened.
func TestAnEncounterCannotEndBeforeItStarted(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	_, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
			EndedAt:     timestamppb.New(time.Now().UTC().Add(-24 * time.Hour)),
		}))
	if err == nil {
		t.Fatal("an encounter ended before it started")
	}
}
