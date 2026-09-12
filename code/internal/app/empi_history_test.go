package app_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Effective-dated demographics, deceased status and caregivers
// (SRS-EMPI-007/008/009), end to end.

func (h *empiHarness) history(t *testing.T, patientID string) *empiv1.GetPatientHistoryResponse {
	t.Helper()
	resp, err := h.patients.GetPatientHistory(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientHistoryRequest{
			PatientId: patientID,
		}))
	if err != nil {
		t.Fatalf("GetPatientHistory: %v", err)
	}
	return resp.Msg
}

// SRS-EMPI-007. The failure: a patient marries, the desk overwrites the
// surname, and six months later a result addressed to the maiden name finds
// nobody — so a clerk files it under a new record, and now there are two.
func TestRenamingAPatientKeepsThePriorNameSearchable(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.UpdateDemographics(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.UpdateDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Rao", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			ExpectedVersion: patient.GetVersion(),
		})); err != nil {
		t.Fatalf("UpdateDemographics: %v", err)
	}

	history := h.history(t, patient.GetPatientId())

	var maidenClosed, marriedOpen bool
	for _, n := range history.GetNames() {
		if n.GetKind() != empiv1.NameKind_NAME_KIND_LEGAL {
			continue
		}
		switch n.GetName().GetFamily() {
		case "Iyer":
			// Closed, not deleted: the interval it applied to is the fact a
			// misfiled result needs.
			maidenClosed = n.GetWindow().GetUntil() != nil
		case "Rao":
			marriedOpen = n.GetWindow().GetUntil() == nil
		}
	}
	if !maidenClosed {
		t.Fatalf("the maiden name was not closed off: %+v", history.GetNames())
	}
	if !marriedOpen {
		t.Fatalf("the married name is not the open one: %+v", history.GetNames())
	}

	// And the current record shows the new name, because that is what the
	// matcher reads and the wristband prints.
	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}
	if got := current.Msg.GetPatient().GetDemographics().GetName().GetFamily(); got != "Rao" {
		t.Fatalf("the current name is %q, want Rao", got)
	}

	// The point of keeping the name is that a search finds it. A lab result
	// addressed to "Iyer" arrives after the marriage, and the clerk searching
	// that name has to reach this patient rather than create a second record.
	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			Name: "Iyer",
		}))
	if err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}

	var match *empiv1.PatientMatch
	for _, m := range found.Msg.GetMatches() {
		if m.GetPatient().GetPatientId() == patient.GetPatientId() {
			match = m
		}
	}
	if match == nil {
		t.Fatalf("searching the maiden name did not find the patient: %+v",
			found.Msg.GetMatches())
	}

	// Found is not enough. A row that scores near zero and shows "Rao" reads as
	// somebody else, so the result has to say which name matched.
	former := match.GetMatchedFormerName()
	if former.GetName().GetFamily() != "Iyer" {
		t.Fatalf("the match does not name the former name it matched: %+v", former)
	}
	if former.GetWindow().GetUntil() == nil {
		t.Fatalf("a former name should be closed, got an open window: %+v", former)
	}
	if match.GetConfidence() <= 0.5 {
		t.Fatalf("a maiden-name hit scored %v; it was scored against the "+
			"current name, not the one that matched", match.GetConfidence())
	}
}

// A patient who still holds the name searched for is a current-name hit, even
// when an older name would also have matched. Labelling that "former name"
// would tell the clerk the record has changed when it has not.
func TestACurrentNameMatchIsNotReportedAsAFormerName(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Rao", []string{"Anil"}, date(1979, 6, 2), empiv1.Sex_SEX_MALE, "9812345670"))

	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			Name: "Rao",
		}))
	if err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}

	for _, m := range found.Msg.GetMatches() {
		if m.GetPatient().GetPatientId() != patient.GetPatientId() {
			continue
		}
		if m.GetMatchedFormerName() != nil {
			t.Fatalf("a current-name match was reported as a former name: %+v",
				m.GetMatchedFormerName())
		}
		return
	}
	t.Fatalf("the patient was not found by their current name")
}

// The name a patient registered under is recorded as applying to an interval,
// so the first rename has something to close.
func TestRegistrationOpensTheNameHistory(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	history := h.history(t, patient.GetPatientId())
	if len(history.GetNames()) != 1 {
		t.Fatalf("%d names recorded at registration, want 1", len(history.GetNames()))
	}
	recorded := history.GetNames()[0]
	if recorded.GetKind() != empiv1.NameKind_NAME_KIND_LEGAL {
		t.Fatalf("the registered name is %v, want legal", recorded.GetKind())
	}
	if recorded.GetSource() != "registration" {
		t.Fatalf("source = %q", recorded.GetSource())
	}
	if recorded.GetWindow().GetUntil() != nil {
		t.Fatal("the registered name is already closed")
	}
}

// A preferred name is an additional way to address somebody, not a replacement
// for the one on the paperwork.
func TestAPreferredNameDoesNotChangeTheLegalRecord(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meenakshi"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	if _, err := h.patients.RecordName(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RecordNameRequest{
			PatientId: patient.GetPatientId(),
			Kind:      empiv1.NameKind_NAME_KIND_PREFERRED,
			Name:      &empiv1.HumanName{Family: "Iyer", Given: []string{"Meera"}},
			Source:    "patient",
		})); err != nil {
		t.Fatalf("RecordName: %v", err)
	}

	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}
	given := current.Msg.GetPatient().GetDemographics().GetName().GetGiven()
	if len(given) == 0 || given[0] != "Meenakshi" {
		t.Fatalf("a preferred name replaced the legal one: %v", given)
	}

	history := h.history(t, patient.GetPatientId())
	var sawPreferred bool
	for _, n := range history.GetNames() {
		if n.GetKind() == empiv1.NameKind_NAME_KIND_PREFERRED {
			sawPreferred = true
		}
	}
	if !sawPreferred {
		t.Fatal("the preferred name was not recorded")
	}
}

// SRS-EMPI-007's preferences. Treating "reachable by SMS" as one setting is how
// a hospital texts somebody their test results because they agreed to
// reminders.
func TestCommunicationPreferencesAreHeldPerPurpose(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	record := func(purpose empiv1.CommunicationPurpose, allowed bool) {
		t.Helper()
		if _, err := h.patients.RecordCommunicationPreference(context.Background(),
			withFacility(h.clerkToken(), h.facility, &empiv1.RecordCommunicationPreferenceRequest{
				PatientId: patient.GetPatientId(),
				Channel:   empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_SMS,
				Purpose:   purpose, Allowed: allowed,
			})); err != nil {
			t.Fatalf("RecordCommunicationPreference: %v", err)
		}
	}

	record(empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER, true)
	record(empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_RESULTS, false)

	history := h.history(t, patient.GetPatientId())
	got := map[empiv1.CommunicationPurpose]bool{}
	for _, p := range history.GetPreferences() {
		if p.GetChannel() == empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_SMS &&
			p.GetWindow().GetUntil() == nil {
			got[p.GetPurpose()] = p.GetAllowed()
		}
	}

	if !got[empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER] {
		t.Fatal("the agreed reminder preference was not recorded")
	}
	if got[empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_RESULTS] {
		t.Fatal("the refusal for results was recorded as agreement")
	}
	// A refusal is a recorded answer, not an absent row.
	if len(history.GetPreferences()) != 2 {
		t.Fatalf("%d preferences recorded, want 2", len(history.GetPreferences()))
	}
}

// Changing an answer closes the previous window rather than overwriting it.
func TestChangingAPreferenceClosesThePreviousOne(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	for _, allowed := range []bool{true, false} {
		if _, err := h.patients.RecordCommunicationPreference(context.Background(),
			withFacility(h.clerkToken(), h.facility, &empiv1.RecordCommunicationPreferenceRequest{
				PatientId: patient.GetPatientId(),
				Channel:   empiv1.CommunicationChannel_COMMUNICATION_CHANNEL_EMAIL,
				Purpose:   empiv1.CommunicationPurpose_COMMUNICATION_PURPOSE_HEALTH_PROMOTION,
				Allowed:   allowed,
				// A distinct instant, so the closing window is valid.
				EffectiveFrom: timestamppb.New(time.Now().UTC().Add(time.Duration(map[bool]int{true: -1, false: 0}[allowed]) * time.Hour)),
			})); err != nil {
			t.Fatalf("RecordCommunicationPreference(%v): %v", allowed, err)
		}
	}

	history := h.history(t, patient.GetPatientId())
	var open, closed int
	for _, p := range history.GetPreferences() {
		if p.GetWindow().GetUntil() == nil {
			open++
		} else {
			closed++
		}
	}
	if open != 1 {
		t.Fatalf("%d open preferences, want exactly 1", open)
	}
	if closed != 1 {
		t.Fatalf("%d closed preferences, want the earlier answer kept", closed)
	}
}

// SRS-EMPI-008. Recording a death stops routine scheduling.
func TestRecordingADeathStopsRoutineScheduling(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))
	if !patient.GetAcceptsRoutineScheduling() {
		t.Fatal("a living patient does not accept routine scheduling")
	}

	deceased, err := h.patients.RecordDeceased(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RecordDeceasedRequest{
			PatientId: patient.GetPatientId(),
			Date: &empiv1.PartialDate{
				Date:      timestamppb.New(date(2026, 9, 1)),
				Precision: empiv1.DatePrecision_DATE_PRECISION_DAY,
			},
			Source: "national death registry",
		}))
	if err != nil {
		t.Fatalf("RecordDeceased: %v", err)
	}

	if deceased.Msg.GetPatient().GetAcceptsRoutineScheduling() {
		t.Fatal("a deceased patient still accepts routine scheduling")
	}
	if deceased.Msg.GetPatient().GetDeceased().GetSource() != "national death registry" {
		t.Fatal("the source was not recorded, so the record cannot be challenged")
	}

	// The event is how scheduling and billing find out, rather than by polling.
	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE event_type = 'patient.deceased' AND aggregate_id = $1`,
		patient.GetPatientId()).Scan(&payload); err != nil {
		t.Fatalf("no patient.deceased event: %v", err)
	}
}

// A death with no source cannot be challenged or reversed, and the
// wrong-patient case is exactly the one that has to be reversible.
func TestRecordingADeathNeedsASource(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	_, err := h.patients.RecordDeceased(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RecordDeceasedRequest{
			PatientId: patient.GetPatientId(), Source: "",
		}))
	if err == nil {
		t.Fatal("a death was recorded with no source")
	}
}

// A registry feed can match the wrong record. A system that cannot undo that
// leaves somebody unable to book an appointment because a computer believes
// they are dead.
func TestAMisrecordedDeathCanBeWithdrawn(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	if _, err := h.patients.RecordDeceased(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RecordDeceasedRequest{
			PatientId: patient.GetPatientId(), Source: "national death registry",
		})); err != nil {
		t.Fatalf("RecordDeceased: %v", err)
	}

	restored, err := h.patients.ReverseDeceased(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ReverseDeceasedRequest{
			PatientId: patient.GetPatientId(),
			Reason:    "registry feed matched the wrong record; patient attended in person",
		}))
	if err != nil {
		t.Fatalf("ReverseDeceased: %v", err)
	}
	if !restored.Msg.GetPatient().GetAcceptsRoutineScheduling() {
		t.Fatal("the patient still cannot be scheduled after the death was withdrawn")
	}

	// What was withdrawn, and why, is in the audit trail — the row itself has
	// stopped saying it.
	var reason string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT reason FROM platform_data.audit_record
		 WHERE resource_id = $1 AND reason LIKE 'withdrew death%'`,
		patient.GetPatientId()).Scan(&reason); err != nil {
		t.Fatalf("the withdrawal was not audited: %v", err)
	}
	if !contains(reason, "national death registry") {
		t.Fatalf("the audit does not say what was withdrawn: %q", reason)
	}
}

func TestWithdrawingADeathNeedsAReason(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))
	if _, err := h.patients.RecordDeceased(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RecordDeceasedRequest{
			PatientId: patient.GetPatientId(), Source: "registrar",
		})); err != nil {
		t.Fatalf("RecordDeceased: %v", err)
	}

	if _, err := h.patients.ReverseDeceased(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ReverseDeceasedRequest{
			PatientId: patient.GetPatientId(),
		})); err == nil {
		t.Fatal("a death was withdrawn with no reason")
	}
}

// SRS-EMPI-009: "caregiver access honors relationship scope and expiry".
func TestCaregiverAuthorityIsScopedVerifiedAndExpiring(t *testing.T) {
	h := newEmpiHarness(t)

	child := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Anya"}, date(2015, 6, 4), empiv1.Sex_SEX_FEMALE, ""))
	parent := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""),
		child.GetPatientId())

	authority := func() []empiv1.Authority {
		t.Helper()
		resp, err := h.patients.GetCaregiverAuthority(context.Background(),
			withFacility(h.clerkToken(), h.facility, &empiv1.GetCaregiverAuthorityRequest{
				HolderPatientId:  parent.GetPatientId(),
				SubjectPatientId: child.GetPatientId(),
			}))
		if err != nil {
			t.Fatalf("GetCaregiverAuthority: %v", err)
		}
		return resp.Msg.GetAuthorities()
	}

	added, err := h.patients.AddRelatedPerson(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.AddRelatedPersonRequest{
			PatientId:        child.GetPatientId(),
			RelatedPatientId: parent.GetPatientId(),
			Relationship:     empiv1.RelationshipType_RELATIONSHIP_TYPE_PARENT,
			Authorities: []empiv1.Authority{
				empiv1.Authority_AUTHORITY_VIEW_DEMOGRAPHICS,
				empiv1.Authority_AUTHORITY_BOOK_APPOINTMENTS,
			},
		}))
	if err != nil {
		t.Fatalf("AddRelatedPerson: %v", err)
	}

	// Recorded but unverified: "I am her mother" is a sentence anybody can say
	// at a reception desk.
	if got := authority(); len(got) != 0 {
		t.Fatalf("an unverified relationship granted %v", got)
	}

	if _, err := h.patients.VerifyRelatedPerson(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.VerifyRelatedPersonRequest{
			RelationshipId: added.Msg.GetRelated().GetRelationshipId(),
			Note:           "birth certificate seen at the desk",
		})); err != nil {
		t.Fatalf("VerifyRelatedPerson: %v", err)
	}

	granted := authority()
	if len(granted) != 2 {
		t.Fatalf("a verified relationship granted %v, want two authorities", granted)
	}
	// Scoped: the parent who brings the child to an appointment does not by
	// that fact get the clinical record.
	for _, a := range granted {
		if a == empiv1.Authority_AUTHORITY_VIEW_CLINICAL {
			t.Fatal("a booking grant carried the clinical record with it")
		}
	}

	// Ending it revokes everything, without deleting the record of it.
	if _, err := h.patients.EndRelatedPerson(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.EndRelatedPersonRequest{
			RelationshipId: added.Msg.GetRelated().GetRelationshipId(),
		})); err != nil {
		t.Fatalf("EndRelatedPerson: %v", err)
	}
	if got := authority(); len(got) != 0 {
		t.Fatalf("an ended relationship still grants %v", got)
	}

	history := h.history(t, child.GetPatientId())
	if len(history.GetRelated()) != 1 {
		t.Fatal("the ended relationship was deleted rather than closed")
	}
	if history.GetRelated()[0].GetWindow().GetUntil() == nil {
		t.Fatal("the ended relationship is still open")
	}
}

// Verification must say what was checked. "Birth certificate" and "she said so"
// are both verifications and only one of them holds up.
func TestVerifyingARelationshipNeedsANote(t *testing.T) {
	h := newEmpiHarness(t)

	child := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Anya"}, date(2015, 6, 4), empiv1.Sex_SEX_FEMALE, ""))

	added, err := h.patients.AddRelatedPerson(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.AddRelatedPersonRequest{
			PatientId:    child.GetPatientId(),
			Name:         &empiv1.HumanName{Family: "Kumar", Given: []string{"Anil"}},
			Relationship: empiv1.RelationshipType_RELATIONSHIP_TYPE_CAREGIVER,
			Authorities:  []empiv1.Authority{empiv1.Authority_AUTHORITY_VIEW_DEMOGRAPHICS},
		}))
	if err != nil {
		t.Fatalf("AddRelatedPerson: %v", err)
	}

	if _, err := h.patients.VerifyRelatedPerson(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.VerifyRelatedPersonRequest{
			RelationshipId: added.Msg.GetRelated().GetRelationshipId(),
		})); err == nil {
		t.Fatal("a relationship was verified with no note")
	}
}

// An emergency contact is somebody to telephone, not somebody with rights over
// the record. A mis-typed relationship is corrected rather than widened.
func TestAnEmergencyContactCannotBeGivenAuthority(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	_, err := h.patients.AddRelatedPerson(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.AddRelatedPersonRequest{
			PatientId:    patient.GetPatientId(),
			Name:         &empiv1.HumanName{Family: "Kumar", Given: []string{"Anil"}},
			Relationship: empiv1.RelationshipType_RELATIONSHIP_TYPE_EMERGENCY_CONTACT,
			Authorities:  []empiv1.Authority{empiv1.Authority_AUTHORITY_VIEW_CLINICAL},
		}))
	if err == nil {
		t.Fatal("an emergency contact was granted authority over the record")
	}
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("code = %v, want InvalidArgument", got)
	}
}

// A relationship naming a patient in another tenant must not resolve.
func TestARelationshipCannotNameAPatientInAnotherTenant(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	neighbour := h.provisionNeighbour(t)
	theirs, err := h.patients.RegisterPatient(context.Background(),
		withFacility(neighbour.clerkToken(), neighbour.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Banerjee", []string{"Arjun"},
				date(1959, 11, 2), empiv1.Sex_SEX_MALE, ""),
		}))
	if err != nil {
		t.Fatalf("neighbour registration: %v", err)
	}

	_, err = h.patients.AddRelatedPerson(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.AddRelatedPersonRequest{
			PatientId:        patient.GetPatientId(),
			RelatedPatientId: theirs.Msg.GetPatient().GetPatientId(),
			Relationship:     empiv1.RelationshipType_RELATIONSHIP_TYPE_SPOUSE,
		}))
	if err == nil {
		t.Fatal("a relationship named a patient in another tenant")
	}
	if got := connectCode(err); got != connect.CodeNotFound {
		t.Fatalf("code = %v, want NotFound", got)
	}
}

// Reading the history is a patient read, and patient reads are audited.
func TestReadingTheHistoryIsAudited(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))
	h.history(t, patient.GetPatientId())

	var auditContext string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT context::text FROM platform_data.audit_record
		 WHERE resource_id = $1 AND action = 'empi.patient.read' AND context::text LIKE '%history%'`,
		patient.GetPatientId()).Scan(&auditContext); err != nil {
		t.Fatalf("the history read was not audited: %v", err)
	}
}

func contains(haystack, needle string) bool { return strings.Contains(haystack, needle) }
