package edge

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"
)

// LabelRequest is a specimen or wristband label to print locally.
type LabelRequest struct {
	TenantID   string
	FacilityID string
	// Kind is "wristband", "specimen" or "medication".
	Kind string
	// Barcode is the positive-identification value. Without it a label is
	// worse than useless: it looks authoritative and cannot be scanned.
	Barcode string
	Lines   []string
}

// Printer is the local device connector.
type Printer interface {
	Print(ctx context.Context, payload []byte) error
}

// ErrInvalidLabel reports a label that must not be printed.
var ErrInvalidLabel = errors.New("edge: invalid label")

// LabelService prints locally and records the fact for later forwarding.
//
// This is the function that must survive WAN loss. A ward cannot stop labelling
// specimens because a link is down, so printing depends only on the local
// printer — the cloud learns about it afterwards, through the queue.
type LabelService struct {
	printer Printer
	queue   *Queue
	ids     func() string
	now     func() time.Time
}

// NewLabelService constructs the service.
func NewLabelService(printer Printer, queue *Queue, ids func() string, now func() time.Time) *LabelService {
	return &LabelService{printer: printer, queue: queue, ids: ids, now: now}
}

var validLabelKinds = map[string]bool{"wristband": true, "specimen": true, "medication": true}

// Print renders and prints a label, then records it for forwarding.
//
// Ordering is deliberate: print first, record second. If recording fails the
// label still exists physically, and an unrecorded print is a reconciliation
// problem. Recording first and failing to print would tell the cloud a label
// exists when no one can scan it — the more dangerous of the two.
func (s *LabelService) Print(ctx context.Context, req LabelRequest) error {
	if err := validateLabel(req); err != nil {
		return err
	}

	payload := render(req)
	if err := s.printer.Print(ctx, payload); err != nil {
		return fmt.Errorf("edge: print failed: %w", err)
	}

	at := s.now().UTC()
	return s.queue.Enqueue(ctx, Operation{
		ID:       s.ids(),
		TenantID: req.TenantID,
		Type:     "edge.label_printed",
		Payload: []byte(fmt.Sprintf(
			`{"kind":%q,"barcode":%q,"facility_id":%q}`, req.Kind, req.Barcode, req.FacilityID)),
		OccurredAt: at,
	})
}

func validateLabel(req LabelRequest) error {
	switch {
	case req.TenantID == "":
		return fmt.Errorf("%w: tenant_id is required", ErrInvalidLabel)
	case req.FacilityID == "":
		return fmt.Errorf("%w: facility_id is required", ErrInvalidLabel)
	case !validLabelKinds[req.Kind]:
		return fmt.Errorf("%w: unsupported kind %q", ErrInvalidLabel, req.Kind)
	case strings.TrimSpace(req.Barcode) == "":
		// A label without a scannable identifier defeats positive
		// identification, which is the reason the label exists.
		return fmt.Errorf("%w: barcode is required for positive identification", ErrInvalidLabel)
	}
	return nil
}

// render produces the device payload. A real deployment emits the printer's
// own language; the shape is what matters for the prototype.
func render(req LabelRequest) []byte {
	var b strings.Builder
	b.WriteString("^XA\n")
	b.WriteString("^FO20,20^BCN,80,Y,N,N^FD" + req.Barcode + "^FS\n")
	for i, line := range req.Lines {
		fmt.Fprintf(&b, "^FO20,%d^A0N,28,28^FD%s^FS\n", 130+i*34, line)
	}
	b.WriteString("^XZ\n")
	return []byte(b.String())
}
