// Package transport serves the platform API surface: liveness, readiness and
// build provenance.
package transport

import (
	"context"

	"connectrpc.com/connect"
	platformapiv1 "github.com/ppusapati/health/code/gen/go/healthcare/platform_api/v1"
)

// Pinger reports whether a dependency is reachable.
type Pinger interface {
	Ping(ctx context.Context) error
}

// BuildInfo is stamped at link time so a running pod can name its own artifact
// during an incident (SRS-SRE-DEP).
type BuildInfo struct {
	Version string
	Commit  string
	BuiltAt string
}

// Handler serves healthcare.platform_api.v1.HealthService.
type Handler struct {
	build        BuildInfo
	dependencies map[string]Pinger
}

// NewHandler constructs the handler with the dependencies readiness must check.
func NewHandler(build BuildInfo, dependencies map[string]Pinger) *Handler {
	return &Handler{build: build, dependencies: dependencies}
}

// CheckLiveness reports process health. It deliberately touches no dependency:
// a database outage must not cause the orchestrator to restart every pod.
func (h *Handler) CheckLiveness(
	_ context.Context,
	_ *connect.Request[platformapiv1.CheckLivenessRequest],
) (*connect.Response[platformapiv1.CheckLivenessResponse], error) {
	return connect.NewResponse(&platformapiv1.CheckLivenessResponse{Alive: true}), nil
}

// CheckReadiness reports whether this instance should receive traffic.
func (h *Handler) CheckReadiness(
	ctx context.Context,
	_ *connect.Request[platformapiv1.CheckReadinessRequest],
) (*connect.Response[platformapiv1.CheckReadinessResponse], error) {
	results := make(map[string]bool, len(h.dependencies))
	ready := true
	for name, dep := range h.dependencies {
		ok := dep.Ping(ctx) == nil
		results[name] = ok
		if !ok {
			ready = false
		}
	}
	return connect.NewResponse(&platformapiv1.CheckReadinessResponse{
		Ready:        ready,
		Dependencies: results,
	}), nil
}

// GetBuildInfo returns release provenance.
func (h *Handler) GetBuildInfo(
	_ context.Context,
	_ *connect.Request[platformapiv1.GetBuildInfoRequest],
) (*connect.Response[platformapiv1.GetBuildInfoResponse], error) {
	return connect.NewResponse(&platformapiv1.GetBuildInfoResponse{
		Version: h.build.Version,
		Commit:  h.build.Commit,
		BuiltAt: h.build.BuiltAt,
	}), nil
}
