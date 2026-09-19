// Package indicators implements the infection control Indicators port against
// the quality context's versioned dictionary.
//
// An adapter rather than a second dictionary here. SRS-IPC-010 requires that
// metric definitions be versioned and SRS-QMS-010 already versions them; two
// dictionaries would disagree the first time somebody changed a definition,
// and the argument would then be about which report was right rather than
// about the infection rate.
package indicators

import (
	"context"
	"time"

	infectionports "github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	qualitydomain "github.com/ppusapati/health/code/internal/quality/domain"
	qualityports "github.com/ppusapati/health/code/internal/quality/ports"
)

// Adapter files computed rates against the quality dictionary.
type Adapter struct {
	indicators qualityports.IndicatorRepository
	ids        infectionports.IDGenerator
}

// New constructs an adapter.
func New(indicators qualityports.IndicatorRepository,
	ids infectionports.IDGenerator) *Adapter {

	return &Adapter{indicators: indicators, ids: ids}
}

var _ infectionports.Indicators = (*Adapter)(nil)

// Record files a value and returns the definition revision it was computed
// under (SRS-IPC-010).
//
// A code with no current definition is refused rather than defined here. An
// infection rate filed against an indicator nobody wrote down is a number
// with no definition, which is the thing the requirement exists to prevent —
// and inventing the definition from the caller's side would put two authors
// on one dictionary.
func (a *Adapter) Record(ctx context.Context, scope authctx.TenantScope,
	code string, periodFrom, periodTo time.Time,
	numerator, denominator int, by string, at time.Time) (int, error) {

	if a == nil || a.indicators == nil {
		return 0, nil
	}

	definition, found, err := a.indicators.CurrentDefinition(ctx, scope, code)
	if err != nil {
		return 0, err
	}
	if !found {
		return 0, rpcerr.FailedPrecondition("IPC_NO_INDICATOR_DEFINITION",
			"indicator "+code+" has no current definition to compute against")
	}

	value, err := qualitydomain.RecordKPIValue(a.ids.NewID(),
		definition.TenantID, definition, periodFrom, periodTo,
		int64(numerator), int64(denominator),
		"computed from infection surveillance records", by, at)
	if err != nil {
		return 0, err
	}
	if err := a.indicators.InsertValue(ctx, scope, value); err != nil {
		return 0, err
	}
	return definition.Revision, nil
}
