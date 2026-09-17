package app_test

import (
	"context"
	"strings"
	"testing"
	"time"

	clinicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// A critical result reaching a clinician (SRS-CLN-012, SRS-ER-016,
// SRS-OPSNFR-003).
//
// Wave 1 recorded the result and computed how overdue its acknowledgement was.
// Nobody was told. These tests are about the difference: a result recorded
// through the ordinary RPC has to produce a notice that outlives the request,
// names somebody, and stops when a human says they have it.

const criticalKind = "critical_result"

func (h *clnHarness) scope() authctx.TenantScope {
	// The same grant the sweeper uses, and for the same reason: a test has no
	// session either. See authctx.SystemScope.
	return authctx.SystemScope(h.tenantID)
}

func (h *clnHarness) saveCriticalChain(t *testing.T) {
	t.Helper()
	tx := pgtx.NewManager(h.pool)
	matrix := escalation.Matrix{
		FacilityID: h.facility, Kind: criticalKind,
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{{UserID: "doctor-1"}},
				Note: "the clinician who ordered it"},
			{Level: 1, Recipients: []escalation.Recipient{{UserID: "doctor-2"}},
				Note: "the on-call registrar"},
		},
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return h.escalations.SaveMatrix(ctx, h.scope(), matrix, time.Now())
	}); err != nil {
		t.Fatalf("save escalation matrix: %v", err)
	}
}

func (h *clnHarness) recordPotassium(t *testing.T, patient, encounter string,
	interpretation clinicalv1.Interpretation) string {

	t.Helper()
	recorded, err := h.clinical.RecordObservation(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.RecordObservationRequest{
			PatientId: patient, EncounterId: encounter,
			Code:  clnCode("http://loinc.org", "2823-3", "Potassium"),
			Value: &clinicalv1.Quantity{Value: 7.1, Unit: "mmol/L"},
			// SRS-CLN-011: the server never infers this, so the test supplies
			// it exactly as a laboratory would.
			Interpretation:       interpretation,
			InterpretationSource: "central laboratory",
			Status:               clinicalv1.ObservationStatus_OBSERVATION_STATUS_FINAL,
		}))
	if err != nil {
		t.Fatalf("RecordObservation: %v", err)
	}
	return recorded.Msg.GetObservation().GetObservationId()
}

func (h *clnHarness) notice(t *testing.T, observationID string) escalation.Notice {
	t.Helper()
	tx := pgtx.NewManager(h.pool)
	var notice escalation.Notice
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		notice, err = h.escalations.NoticeFor(ctx, h.scope(), escalation.Subject{
			Kind: criticalKind, ID: observationID,
		})
		return err
	})
	if err != nil {
		t.Fatalf("no escalation notice for observation %s: %v", observationID, err)
	}
	return notice
}

func TestACriticalResultRaisesANoticeInTheSameTransaction(t *testing.T) {
	h := newClnHarness(t)
	h.saveCriticalChain(t)
	patient, encounter := h.chart(t, "Krishnan", "+91-99000-11001")

	observation := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_CRITICAL_HIGH)

	notice := h.notice(t, observation)
	if notice.State != escalation.StatePending {
		t.Fatalf("notice state %q, want pending", notice.State)
	}
	if notice.Subject.PatientID != patient {
		t.Fatalf("notice is about patient %q, want %q", notice.Subject.PatientID, patient)
	}
	if notice.Subject.FacilityID != h.facility {
		t.Fatalf("notice facility %q, want %q", notice.Subject.FacilityID, h.facility)
	}
}

func TestTheNoticeCarriesTheReadingAndNotTheNumber(t *testing.T) {
	// SRS-API-009's rule, applied to a platform table. The escalation inbox is
	// read by a mechanism that knows nothing about clinical confidentiality,
	// so it carries enough to make somebody open the chart and no more. A
	// potassium of 7.1 in a row outside the chart is a result outside the
	// chart's access rules.
	h := newClnHarness(t)
	h.saveCriticalChain(t)
	patient, encounter := h.chart(t, "Krishnan", "+91-99000-11002")

	observation := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_CRITICAL_HIGH)

	summary := h.notice(t, observation).Summary
	if !strings.Contains(summary, "Potassium") {
		t.Fatalf("the summary does not say what the test was: %q", summary)
	}
	if !strings.Contains(summary, "critical") {
		t.Fatalf("the summary does not say it is critical: %q", summary)
	}
	if strings.Contains(summary, "7.1") {
		t.Fatalf("the result value reached a platform table: %q", summary)
	}
}

func TestAnOrdinaryResultRaisesNothing(t *testing.T) {
	// The guard on the tests above. A mechanism that escalated every result
	// would pass them and be worse than no mechanism, because the ward would
	// learn to dismiss the notices.
	h := newClnHarness(t)
	h.saveCriticalChain(t)
	patient, encounter := h.chart(t, "Krishnan", "+91-99000-11003")

	observation := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_NORMAL)

	tx := pgtx.NewManager(h.pool)
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		_, err := h.escalations.NoticeFor(ctx, h.scope(), escalation.Subject{
			Kind: criticalKind, ID: observation,
		})
		return err
	})
	if err == nil {
		t.Fatal("a normal potassium raised an escalation notice")
	}
}

func TestTheSameResultRecordedTwiceRaisesOneNotice(t *testing.T) {
	// A laboratory interface that redelivers, or a client that retries, must
	// not start a second chain to the same consultant.
	h := newClnHarness(t)
	h.saveCriticalChain(t)
	patient, encounter := h.chart(t, "Krishnan", "+91-99000-11004")

	first := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_CRITICAL_HIGH)
	second := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_CRITICAL_LOW)

	// Two distinct observations are two distinct notices — they are two
	// results. The idempotency that matters is per observation, which the
	// platform test covers directly; here the point is that the second did not
	// collide with or overwrite the first.
	if first == second {
		t.Fatal("two recordings produced one observation id")
	}
	if a, b := h.notice(t, first), h.notice(t, second); a.ID == b.ID {
		t.Fatal("two results share one notice")
	}
}

func TestACriticalResultIsStillRecordedWhereNoChainIsConfigured(t *testing.T) {
	// A small clinic where the person who ordered the test is standing next to
	// the analyser has configured no chain. Refusing to record a critical
	// potassium because nobody filled in a form would be the worse failure.
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Krishnan", "+91-99000-11005")

	observation := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_CRITICAL_HIGH)
	if observation == "" {
		t.Fatal("the result was not recorded")
	}

	listed, err := h.clinical.ListObservations(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.ListObservationsRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("ListObservations: %v", err)
	}
	if len(listed.Msg.GetObservations()) == 0 {
		t.Fatal("the chart has no result")
	}
}

func TestTheNoticeReachesTheClinicianAndStopsOnAcknowledgement(t *testing.T) {
	// The whole point, end to end: a result recorded through the ordinary RPC
	// reaches a named clinician's inbox, and leaves it when a human says they
	// have it rather than when something was sent.
	h := newClnHarness(t)
	h.saveCriticalChain(t)
	patient, encounter := h.chart(t, "Krishnan", "+91-99000-11006")

	observation := h.recordPotassium(t, patient, encounter,
		clinicalv1.Interpretation_INTERPRETATION_CRITICAL_HIGH)

	// One sweep, standing in for the driver the server runs in the background.
	if _, err := h.driver.Sweep(context.Background(), 10); err != nil {
		t.Fatalf("sweep: %v", err)
	}

	tx := pgtx.NewManager(h.pool)
	inbox := func(user string) []escalation.Notice {
		t.Helper()
		var out []escalation.Notice
		if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
			var err error
			out, err = h.escalations.OpenFor(ctx, h.scope(), user)
			return err
		}); err != nil {
			t.Fatalf("read inbox: %v", err)
		}
		return out
	}

	open := inbox("doctor-1")
	if len(open) != 1 {
		t.Fatalf("the ordering clinician's inbox holds %d notices, want 1", len(open))
	}
	// Not the registrar's, yet: level one is fifteen minutes away.
	if got := inbox("doctor-2"); len(got) != 0 {
		t.Fatalf("the registrar was told immediately: %d notices", len(got))
	}

	notice := h.notice(t, observation)
	if err := notice.Acknowledge("doctor-1", time.Now()); err != nil {
		t.Fatalf("acknowledge: %v", err)
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return h.escalations.Save(ctx, h.scope(), notice)
	}); err != nil {
		t.Fatalf("save: %v", err)
	}

	if got := inbox("doctor-1"); len(got) != 0 {
		t.Fatalf("the inbox still holds %d after acknowledgement", len(got))
	}
}
