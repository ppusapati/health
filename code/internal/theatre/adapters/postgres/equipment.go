package postgres

import (
	"context"
	"strings"
	"time"

	biomedicaldomain "github.com/ppusapati/health/code/internal/biomedical/domain"
	biomedicalports "github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/theatre/domain"
	"github.com/ppusapati/health/code/internal/theatre/ports"
)

// Equipment adapts the biomedical equipment register (SRS-BIO-009).
//
// An adapter rather than a query of its own: what a machine is and whether it
// is working belongs to SRS-BIO, and the theatre reads it without owning it.
// A second copy of "is the intensifier working" here would disagree with the
// first the first time somebody fixed one.
//
// The register's own rules decide the answer — the domain function is the one
// the biomedical use cases call, so a room's capability and the equipment
// screen cannot drift apart.
type Equipment struct {
	assets biomedicalports.AssetRepository
	// blockOnCalibration mirrors the biomedical deployment setting. Passed in
	// rather than read from a second configuration, so a hospital that treats
	// a calibration certificate as a condition of use has theatre scheduling
	// agree with its equipment screen.
	blockOnCalibration bool
	now                func() time.Time
}

// NewEquipment constructs the adapter.
func NewEquipment(assets biomedicalports.AssetRepository,
	blockOnCalibration bool, now func() time.Time) Equipment {

	if now == nil {
		now = time.Now
	}
	return Equipment{assets: assets, blockOnCalibration: blockOnCalibration, now: now}
}

var _ ports.Equipment = Equipment{}

// equipmentPageSize bounds one room's read. A theatre with more machines than
// this in it is a store cupboard that has been given a room code.
const equipmentPageSize = 500

// StatusFor implements ports.Equipment.
func (e Equipment) StatusFor(ctx context.Context, scope authctx.TenantScope,
	locations []string) (domain.EquipmentStatus, error) {

	if e.assets == nil {
		return domain.EquipmentStatus{}, nil
	}

	now := e.now()
	status := domain.EquipmentStatus{
		Working: map[string]int{},
		Down:    map[string]string{},
	}

	for _, location := range locations {
		if location == "" {
			continue
		}
		assets, err := e.assets.AtLocation(ctx, scope, location,
			equipmentPageSize)
		if err != nil {
			// Propagated rather than treated as "nothing is working". A
			// database failure that silently emptied a theatre would cancel a
			// list, and one that silently filled it would book a case onto a
			// machine nobody can use. Neither is a thing to guess at.
			return domain.EquipmentStatus{}, err
		}
		if len(assets) == 0 {
			continue
		}

		// Summed across the identifiers, because a hospital part-way through
		// re-keying its register has some machines under the code and some
		// under the id, and the room can do what all of them can do.
		for capability, count := range biomedicaldomain.AvailableCapabilities(
			assets, location, now, e.blockOnCalibration) {
			status.Working[capability] += count
		}

		// Why, per capability the room has and cannot deliver. The first
		// reason from the first asset that claims it: a scheduler needs
		// something to act on, not every reason every machine is down.
		for _, capability := range biomedicaldomain.UnavailableCapabilities(
			assets, location, now, e.blockOnCalibration) {

			if _, told := status.Down[capability]; told {
				continue
			}
			for _, asset := range assets {
				if !claims(asset, capability) {
					continue
				}
				if reasons := asset.Unusable(now,
					e.blockOnCalibration); len(reasons) > 0 {
					status.Down[capability] = asset.Tag + ": " + reasons[0]
					break
				}
			}
		}
	}

	// A capability that works somewhere in the room is not down, whatever a
	// second location said about a machine that shares its name.
	for capability, count := range status.Working {
		if count > 0 {
			delete(status.Down, capability)
		}
	}
	return status, nil
}

func claims(asset biomedicaldomain.Asset, capability string) bool {
	for _, name := range asset.Capabilities {
		if strings.EqualFold(name, capability) {
			return true
		}
	}
	return false
}
