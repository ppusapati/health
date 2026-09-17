package app_test

import (
	"context"
	"testing"
	"time"

	clinicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Device-sourced readings over the wire (SRS-ICU-003, SRS-ICU-009).
//
// The domain and the repository each pin half of this. These pin the half that
// matters to a ward: a monitor value arrives on the chart, is visibly not a
// chart value, and becomes one only when a clinician says so through an RPC
// that requires a clinical permission rather than the interface credential
// that ingested it.

func (h *clnHarness) ingest(t *testing.T, patient, encounter string,
	value float64, quality string) *clinicalv1.Observation {

	t.Helper()
	observed := time.Now().Add(-3 * time.Second).UTC()
	ingested, err := h.clinical.IngestDeviceReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&clinicalv1.IngestDeviceReadingRequest{
				PatientId: patient, EncounterId: encounter,
				Code:  clnCode("http://loinc.org", "59408-5", "SpO2"),
				Value: &clinicalv1.Quantity{Value: value, Unit: "%"},
				Device: &clinicalv1.DeviceSource{
					DeviceId: "monitor-7", Channel: "SpO2", Quality: quality,
					ObservedAt: timestamppb.New(observed),
					ReceivedAt: timestamppb.New(time.Now().UTC()),
				},
			}))
	if err != nil {
		t.Fatalf("IngestDeviceReading: %v", err)
	}
	return ingested.Msg.GetObservation()
}

func TestAMonitorValueArrivesProvisional(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "+91-99000-12001")

	// A saturation probe off a finger.
	reading := h.ingest(t, patient, encounter, 60, "searching")

	if reading.GetSource() != clinicalv1.ObservationSource_OBSERVATION_SOURCE_DEVICE {
		t.Fatalf("source %v, want device", reading.GetSource())
	}
	if reading.GetValidation() != clinicalv1.ValidationState_VALIDATION_STATE_PENDING {
		t.Fatalf("validation %v, want pending", reading.GetValidation())
	}
	// The device identity travels, so a ward chasing a run of nonsense can find
	// the probe.
	if reading.GetDevice().GetDeviceId() != "monitor-7" {
		t.Fatalf("device %q", reading.GetDevice().GetDeviceId())
	}
	if reading.GetDevice().GetQuality() != "searching" {
		t.Fatalf("quality %q — the device's own word must survive", reading.GetDevice().GetQuality())
	}
	// A monitor does not interpret. SRS-CLN-011: the server never infers one.
	if reading.GetInterpretation() != clinicalv1.Interpretation_INTERPRETATION_UNKNOWN {
		t.Fatalf("a device reading arrived interpreted: %v", reading.GetInterpretation())
	}
}

func TestATypedResultIsNotMarkedProvisional(t *testing.T) {
	// The guard. If every observation came back pending, the test above would
	// pass and the distinction would be worthless.
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "+91-99000-12002")

	observation := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_NORMAL)

	listed, err := h.clinical.ListObservations(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&clinicalv1.ListObservationsRequest{PatientId: patient}))
	if err != nil {
		t.Fatalf("ListObservations: %v", err)
	}
	for _, o := range listed.Msg.GetObservations() {
		if o.GetObservationId() != observation {
			continue
		}
		if o.GetValidation() != clinicalv1.ValidationState_VALIDATION_STATE_NOT_REQUIRED {
			t.Fatalf("a typed result came back %v", o.GetValidation())
		}
		if o.GetSource() != clinicalv1.ObservationSource_OBSERVATION_SOURCE_MANUAL {
			t.Fatalf("a typed result came back from source %v", o.GetSource())
		}
		return
	}
	t.Fatal("the typed result is not on the chart")
}

func TestAClinicianConfirmsAReadingIntoTheChart(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "+91-99000-12003")
	reading := h.ingest(t, patient, encounter, 94, "good")

	decided, err := h.clinical.DecideReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.DecideReadingRequest{
			ObservationId: reading.GetObservationId(), Accept: true,
		}))
	if err != nil {
		t.Fatalf("DecideReading: %v", err)
	}
	confirmed := decided.Msg.GetObservation()
	if confirmed.GetValidation() != clinicalv1.ValidationState_VALIDATION_STATE_CONFIRMED {
		t.Fatalf("validation %v, want confirmed", confirmed.GetValidation())
	}
	if confirmed.GetValidatedBy() != "doctor-1" {
		t.Fatalf("confirmed by %q", confirmed.GetValidatedBy())
	}
}

func TestRejectingAReadingNeedsAReason(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "+91-99000-12004")
	reading := h.ingest(t, patient, encounter, 30, "artefact")

	if _, err := h.clinical.DecideReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.DecideReadingRequest{
			ObservationId: reading.GetObservationId(), Accept: false,
		})); err == nil {
		t.Fatal("a reading was rejected with no reason")
	}

	decided, err := h.clinical.DecideReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.DecideReadingRequest{
			ObservationId: reading.GetObservationId(), Accept: false,
			Reason: "probe off the finger during turning",
		}))
	if err != nil {
		t.Fatalf("DecideReading: %v", err)
	}
	rejected := decided.Msg.GetObservation()
	if rejected.GetValidation() != clinicalv1.ValidationState_VALIDATION_STATE_REJECTED {
		t.Fatalf("validation %v, want rejected", rejected.GetValidation())
	}
	if rejected.GetValidationNote() == "" {
		t.Fatal("the reason did not survive")
	}
}

func TestADecidedReadingLeavesTheProvisionalWorklist(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "+91-99000-12005")

	pending := h.ingest(t, patient, encounter, 60, "searching")
	decided := h.ingest(t, patient, encounter, 95, "good")

	provisional := func() []*clinicalv1.Observation {
		t.Helper()
		listed, err := h.clinical.ListProvisionalReadings(context.Background(),
			withFacility(h.clinicianToken(), h.facility,
				&clinicalv1.ListProvisionalReadingsRequest{PatientId: patient}))
		if err != nil {
			t.Fatalf("ListProvisionalReadings: %v", err)
		}
		return listed.Msg.GetObservations()
	}

	if got := provisional(); len(got) != 2 {
		t.Fatalf("the worklist holds %d readings, want 2", len(got))
	}

	if _, err := h.clinical.DecideReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.DecideReadingRequest{
			ObservationId: decided.GetObservationId(), Accept: true,
		})); err != nil {
		t.Fatalf("DecideReading: %v", err)
	}

	remaining := provisional()
	if len(remaining) != 1 || remaining[0].GetObservationId() != pending.GetObservationId() {
		t.Fatalf("the worklist holds %d readings after one decision", len(remaining))
	}

	// And the confirmed one is still on the chart — a decision changes how a
	// value is believed, never whether it is there.
	listed, err := h.clinical.ListObservations(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&clinicalv1.ListObservationsRequest{PatientId: patient}))
	if err != nil {
		t.Fatalf("ListObservations: %v", err)
	}
	if len(listed.Msg.GetObservations()) != 2 {
		t.Fatalf("the chart shows %d readings, want both",
			len(listed.Msg.GetObservations()))
	}
}

func TestADeviceReadingMustNameItsDeviceOverTheWire(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "+91-99000-12006")

	if _, err := h.clinical.IngestDeviceReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&clinicalv1.IngestDeviceReadingRequest{
				PatientId: patient, EncounterId: encounter,
				Code:  clnCode("http://loinc.org", "59408-5", "SpO2"),
				Value: &clinicalv1.Quantity{Value: 95, Unit: "%"},
				// No device.
			})); err == nil {
		t.Fatal("a reading with no device was accepted")
	}
}

func TestAReadingCannotBeDecidedTwice(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "+91-99000-12007")
	reading := h.ingest(t, patient, encounter, 95, "good")

	if _, err := h.clinical.DecideReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.DecideReadingRequest{
			ObservationId: reading.GetObservationId(), Accept: true,
		})); err != nil {
		t.Fatalf("DecideReading: %v", err)
	}

	// A second clinician disagreeing has to amend rather than overwrite, so
	// the chart keeps both decisions.
	if _, err := h.clinical.DecideReading(context.Background(),
		withFacility(h.otherClinicianToken(), h.facility,
			&clinicalv1.DecideReadingRequest{
				ObservationId: reading.GetObservationId(), Accept: false,
				Reason: "I think that was an artefact",
			})); err == nil {
		t.Fatal("a confirmed reading was rejected by a second clinician")
	}
}
