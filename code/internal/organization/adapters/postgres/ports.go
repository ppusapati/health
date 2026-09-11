package postgres

import (
	"context"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// The two repository ports are served by one Repository so that a tenant read
// and a facility write share a connection and transaction. These thin wrappers
// give each port its own method names without duplicating the SQL.

// TenantRepo exposes Repository as a ports.TenantRepository.
type TenantRepo struct{ *Repository }

// FacilityRepo exposes Repository as a ports.FacilityRepository.
type FacilityRepo struct{ *Repository }

// Insert implements ports.FacilityRepository.
func (f FacilityRepo) Insert(ctx context.Context, scope authctx.TenantScope, fac *domain.Facility) error {
	return f.Repository.InsertFacility(ctx, scope, fac)
}

// GetByID implements ports.FacilityRepository.
func (f FacilityRepo) GetByID(ctx context.Context, scope authctx.TenantScope, facilityID string) (*domain.Facility, error) {
	return f.Repository.GetFacilityByID(ctx, scope, facilityID)
}

// List implements ports.FacilityRepository.
func (f FacilityRepo) List(ctx context.Context, scope authctx.TenantScope, filter ports.FacilityFilter) ([]*domain.Facility, string, error) {
	return f.Repository.ListFacilities(ctx, scope, filter)
}

// Compile-time proof that the adapters satisfy the ports the application layer
// declared. If a port gains a method, this file fails to build rather than the
// composition root failing at runtime.
var (
	_ ports.TenantRepository   = TenantRepo{}
	_ ports.FacilityRepository = FacilityRepo{}
)
