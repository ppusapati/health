// Package transport serves the platform API surface: liveness, readiness and
// build provenance.
package transport

import (
	"context"
	"encoding/json"
	"net/http"

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

// Probe paths a Kubernetes httpGet probe can actually reach.
//
// The Deployment's probes were declared against the Connect procedure paths,
// and a Connect unary procedure is a POST. Kubernetes httpGet probes issue GET
// and nothing can change that, so every probe answered 405 and the Pod never
// became ready — the manifests could not roll out in any cluster.
//
// Found by deploying to a real kubelet. Neither schema validation, nor
// admission, nor running the image by hand catches it: the first two never
// execute a probe, and running it by hand means choosing the verb yourself,
// which is exactly the mistake.
const (
	LivenessPath  = "/healthz"
	ReadinessPath = "/readyz"
)

// RegisterProbes serves the liveness and readiness checks over plain HTTP GET.
//
// The bodies delegate to the same methods the RPC surface exposes, rather than
// re-deriving readiness: two implementations of "is this instance ready" drift,
// and the one the orchestrator believes is whichever it happens to call.
func (h *Handler) RegisterProbes(mux *http.ServeMux) {
	mux.HandleFunc(LivenessPath, func(w http.ResponseWriter, r *http.Request) {
		// Liveness touches no dependency, by the same reasoning as the RPC: a
		// database outage must not make the orchestrator restart every pod.
		if _, err := h.CheckLiveness(r.Context(), connect.NewRequest(
			&platformapiv1.CheckLivenessRequest{})); err != nil {
			http.Error(w, "not alive", http.StatusServiceUnavailable)
			return
		}
		writeProbe(w, http.StatusOK, map[string]any{"alive": true})
	})

	mux.HandleFunc(ReadinessPath, func(w http.ResponseWriter, r *http.Request) {
		response, err := h.CheckReadiness(r.Context(), connect.NewRequest(
			&platformapiv1.CheckReadinessRequest{}))
		if err != nil {
			http.Error(w, "not ready", http.StatusServiceUnavailable)
			return
		}
		status := http.StatusOK
		if !response.Msg.GetReady() {
			// 503 rather than a 200 carrying ready:false. A probe reads the
			// status code and nothing else, so a body that says "not ready"
			// under a 200 is a pod the orchestrator keeps sending traffic to.
			status = http.StatusServiceUnavailable
		}
		writeProbe(w, status, map[string]any{
			"ready":        response.Msg.GetReady(),
			"dependencies": response.Msg.GetDependencies(),
		})
	})
}

// writeProbe renders a probe body. The body is for a human reading `kubectl
// describe` or curling the endpoint during an incident; the orchestrator only
// ever reads the status code.
func writeProbe(w http.ResponseWriter, status int, body map[string]any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(body)
}
