// Package infra holds deployment manifest invariants.
//
// These assertions run in CI without a cluster or kustomize. They exist
// because the manifests encode security and availability decisions that are
// easy to weaken by accident — dropping a securityContext to make a debug
// container work, say — and a YAML diff rarely makes that obvious in review.
package infra_test

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"gopkg.in/yaml.v3"
)

func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Clean(filepath.Join(wd, "..", ".."))
}

// document is one parsed YAML document from a manifest file.
type document struct {
	path string
	data map[string]any
}

// loadManifests parses every YAML document under infra/k8s.
func loadManifests(t *testing.T) []document {
	t.Helper()
	root := filepath.Join(repoRoot(t), "infra", "k8s")

	var docs []document
	err := filepath.WalkDir(root, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() || !strings.HasSuffix(path, ".yaml") {
			return nil
		}

		raw, readErr := os.ReadFile(path)
		if readErr != nil {
			return readErr
		}

		decoder := yaml.NewDecoder(strings.NewReader(string(raw)))
		for {
			var parsed map[string]any
			if decodeErr := decoder.Decode(&parsed); decodeErr != nil {
				break
			}
			if parsed == nil {
				continue
			}
			rel, _ := filepath.Rel(root, path)
			docs = append(docs, document{path: rel, data: parsed})
		}
		return nil
	})
	if err != nil {
		t.Fatalf("walk manifests: %v", err)
	}
	if len(docs) == 0 {
		t.Fatal("no manifests found; these invariants would pass vacuously")
	}
	return docs
}

// isPatch reports whether a document is a strategic-merge patch fragment
// rather than a complete resource.
//
// A patch is intentionally partial — it names only the fields it changes — so
// completeness invariants must not be applied to it. Overlays are instead
// checked for weakening, below.
func (d document) isPatch() bool {
	return strings.HasPrefix(filepath.ToSlash(d.path), "overlays/")
}

func (d document) kind() string {
	k, _ := d.data["kind"].(string)
	return k
}

func (d document) name() string {
	meta, _ := d.data["metadata"].(map[string]any)
	n, _ := meta["name"].(string)
	return n
}

// podSpec returns the pod template spec for workload kinds.
func (d document) podSpec() (map[string]any, bool) {
	spec, ok := d.data["spec"].(map[string]any)
	if !ok {
		return nil, false
	}

	switch d.kind() {
	case "Deployment", "StatefulSet", "DaemonSet":
		template, ok := spec["template"].(map[string]any)
		if !ok {
			return nil, false
		}
		podSpec, ok := template["spec"].(map[string]any)
		return podSpec, ok
	case "CronJob":
		jobTemplate, ok := spec["jobTemplate"].(map[string]any)
		if !ok {
			return nil, false
		}
		jobSpec, ok := jobTemplate["spec"].(map[string]any)
		if !ok {
			return nil, false
		}
		template, ok := jobSpec["template"].(map[string]any)
		if !ok {
			return nil, false
		}
		podSpec, ok := template["spec"].(map[string]any)
		return podSpec, ok
	default:
		return nil, false
	}
}

func containersOf(podSpec map[string]any) []map[string]any {
	raw, _ := podSpec["containers"].([]any)
	out := make([]map[string]any, 0, len(raw))
	for _, c := range raw {
		if m, ok := c.(map[string]any); ok {
			out = append(out, m)
		}
	}
	return out
}

// Every workload must run unprivileged with a read-only root filesystem and no
// capabilities. This is the Pod Security "restricted" profile expressed as a
// test, so a violation fails the build rather than being rejected at deploy
// time in a cluster nobody is watching.
func TestWorkloadsRunRestricted(t *testing.T) {
	var checked int

	for _, doc := range loadManifests(t) {
		if doc.isPatch() {
			continue
		}
		podSpec, ok := doc.podSpec()
		if !ok {
			continue
		}
		checked++

		podSecurity, _ := podSpec["securityContext"].(map[string]any)
		if podSecurity["runAsNonRoot"] != true {
			t.Errorf("%s/%s: pod securityContext must set runAsNonRoot: true", doc.path, doc.name())
		}
		if seccomp, _ := podSecurity["seccompProfile"].(map[string]any); seccomp["type"] != "RuntimeDefault" {
			t.Errorf("%s/%s: pod must set seccompProfile RuntimeDefault", doc.path, doc.name())
		}

		// A mounted service-account token is a free cluster credential for
		// anything that achieves code execution in the pod.
		if podSpec["automountServiceAccountToken"] != false {
			t.Errorf("%s/%s: automountServiceAccountToken must be false", doc.path, doc.name())
		}

		for _, container := range containersOf(podSpec) {
			containerName, _ := container["name"].(string)
			security, _ := container["securityContext"].(map[string]any)

			if security["allowPrivilegeEscalation"] != false {
				t.Errorf("%s/%s/%s: allowPrivilegeEscalation must be false", doc.path, doc.name(), containerName)
			}
			if security["readOnlyRootFilesystem"] != true {
				t.Errorf("%s/%s/%s: readOnlyRootFilesystem must be true", doc.path, doc.name(), containerName)
			}

			capabilities, _ := security["capabilities"].(map[string]any)
			dropped, _ := capabilities["drop"].([]any)
			var dropsAll bool
			for _, c := range dropped {
				if c == "ALL" {
					dropsAll = true
				}
			}
			if !dropsAll {
				t.Errorf("%s/%s/%s: must drop ALL capabilities", doc.path, doc.name(), containerName)
			}
		}
	}

	if checked == 0 {
		t.Fatal("no workloads were checked")
	}
}

// A memory limit contains a leak. A CPU limit is deliberately absent on the API
// deployment: throttling turns a load spike into a latency cliff.
func TestContainersDeclareResources(t *testing.T) {
	for _, doc := range loadManifests(t) {
		if doc.isPatch() {
			continue
		}
		podSpec, ok := doc.podSpec()
		if !ok {
			continue
		}
		for _, container := range containersOf(podSpec) {
			containerName, _ := container["name"].(string)
			resources, _ := container["resources"].(map[string]any)

			requests, _ := resources["requests"].(map[string]any)
			if requests["cpu"] == nil || requests["memory"] == nil {
				t.Errorf("%s/%s/%s: must request cpu and memory so the scheduler can place it",
					doc.path, doc.name(), containerName)
			}

			limits, _ := resources["limits"].(map[string]any)
			if limits["memory"] == nil {
				t.Errorf("%s/%s/%s: must limit memory so a leak cannot evict neighbours",
					doc.path, doc.name(), containerName)
			}
		}
	}
}

// Liveness must not depend on the database.
//
// Pointing liveness at readiness means a database outage restarts every pod,
// converting a recoverable degradation into a total outage with an empty
// connection pool on the other side.
func TestLivenessDoesNotProbeDependencies(t *testing.T) {
	var checked int

	for _, doc := range loadManifests(t) {
		if doc.isPatch() {
			continue
		}
		podSpec, ok := doc.podSpec()
		if !ok {
			continue
		}
		for _, container := range containersOf(podSpec) {
			liveness, ok := container["livenessProbe"].(map[string]any)
			if !ok {
				continue
			}
			checked++

			httpGet, _ := liveness["httpGet"].(map[string]any)
			path, _ := httpGet["path"].(string)

			if strings.Contains(path, "CheckReadiness") {
				t.Errorf("%s/%s: liveness probes readiness (%s); a dependency outage would restart every pod",
					doc.path, doc.name(), path)
			}
			if !strings.Contains(path, "CheckLiveness") {
				t.Errorf("%s/%s: liveness probe path %q is not the liveness endpoint", doc.path, doc.name(), path)
			}
		}
	}

	if checked == 0 {
		t.Fatal("no liveness probes found")
	}
}

// Readiness must exist, or a rollout sends traffic to a pod with no database
// connection.
func TestApiDeploymentHasReadinessProbe(t *testing.T) {
	for _, doc := range loadManifests(t) {
		if doc.kind() != "Deployment" || doc.isPatch() {
			continue
		}
		podSpec, _ := doc.podSpec()
		for _, container := range containersOf(podSpec) {
			if _, ok := container["readinessProbe"]; !ok {
				name, _ := container["name"].(string)
				t.Errorf("%s/%s/%s: no readiness probe", doc.path, doc.name(), name)
			}
		}
	}
}

// AUTH_MODE must never have a base default.
//
// The service refuses to start without it (ADR-W0-003). That protection only
// holds if no overlay can inherit a value: a base default of "dev" would reach
// production the first time someone forgot to patch it.
func TestAuthModeIsNeverDefaultedInBase(t *testing.T) {
	var sawBaseConfig bool

	for _, doc := range loadManifests(t) {
		if doc.kind() != "ConfigMap" || !strings.HasPrefix(doc.path, "base/") {
			continue
		}
		data, _ := doc.data["data"].(map[string]any)
		if _, isCoreConfig := data["LISTEN_ADDR"]; !isCoreConfig {
			continue
		}
		sawBaseConfig = true

		if value, present := data["AUTH_MODE"]; present {
			t.Errorf("base ConfigMap defaults AUTH_MODE to %q; it must be set per overlay", value)
		}
	}

	if !sawBaseConfig {
		t.Fatal("base core-config ConfigMap not found")
	}
}

// The development token verifier must be confined to the dev overlay.
func TestDevAuthModeOnlyInDevOverlay(t *testing.T) {
	for _, doc := range loadManifests(t) {
		if doc.kind() != "ConfigMap" {
			continue
		}
		data, _ := doc.data["data"].(map[string]any)
		if data["AUTH_MODE"] != "dev" {
			continue
		}
		if !strings.HasPrefix(doc.path, filepath.Join("overlays", "dev")) {
			t.Errorf("%s enables AUTH_MODE=dev outside the dev overlay", doc.path)
		}
	}
}

// No secret may be committed as a literal. Secrets come from the cluster's
// secret store; a literal in Git is a literal in every clone and every CI log.
func TestNoLiteralSecretsInManifests(t *testing.T) {
	for _, doc := range loadManifests(t) {
		if doc.kind() != "Secret" {
			continue
		}
		t.Errorf("%s defines a Secret resource; secrets must come from the external secret store", doc.path)
	}

	// A connection string in a ConfigMap is the same mistake wearing a
	// different kind.
	for _, doc := range loadManifests(t) {
		if doc.kind() != "ConfigMap" {
			continue
		}
		data, _ := doc.data["data"].(map[string]any)
		for key, value := range data {
			str, ok := value.(string)
			if !ok {
				continue
			}
			if strings.Contains(str, "postgres://") || strings.Contains(str, "password=") {
				t.Errorf("%s ConfigMap key %q looks like a credential", doc.path, key)
			}
		}
	}
}

// A rollout must not reduce capacity below the current replica count, and a
// disruption budget must keep at least one replica during a node drain.
func TestRolloutAndDisruptionProtectAvailability(t *testing.T) {
	var sawDeployment, sawPDB bool

	for _, doc := range loadManifests(t) {
		if doc.isPatch() {
			continue
		}
		switch doc.kind() {
		case "Deployment":
			sawDeployment = true
			spec, _ := doc.data["spec"].(map[string]any)
			strategy, _ := spec["strategy"].(map[string]any)
			rolling, _ := strategy["rollingUpdate"].(map[string]any)
			if rolling["maxUnavailable"] != 0 {
				t.Errorf("%s/%s: maxUnavailable must be 0 so a rollout never drops capacity",
					doc.path, doc.name())
			}
		case "PodDisruptionBudget":
			sawPDB = true
			spec, _ := doc.data["spec"].(map[string]any)
			if spec["minAvailable"] == nil && spec["maxUnavailable"] == nil {
				t.Errorf("%s/%s: PDB sets neither minAvailable nor maxUnavailable", doc.path, doc.name())
			}
		}
	}

	if !sawDeployment || !sawPDB {
		t.Fatalf("expected a Deployment and a PodDisruptionBudget (deployment=%v pdb=%v)", sawDeployment, sawPDB)
	}
}

// Network policy must default-deny. Application-level tenant isolation is
// worthless if a compromised pod can reach the database directly.
func TestNetworkPolicyDefaultsToDeny(t *testing.T) {
	var sawDefaultDeny bool

	for _, doc := range loadManifests(t) {
		if doc.kind() != "NetworkPolicy" || doc.name() != "default-deny" {
			continue
		}
		sawDefaultDeny = true

		spec, _ := doc.data["spec"].(map[string]any)
		selector, _ := spec["podSelector"].(map[string]any)
		if len(selector) != 0 {
			t.Errorf("%s: default-deny must select all pods, got %v", doc.path, selector)
		}

		types, _ := spec["policyTypes"].([]any)
		var hasIngress, hasEgress bool
		for _, pt := range types {
			switch pt {
			case "Ingress":
				hasIngress = true
			case "Egress":
				hasEgress = true
			}
		}
		if !hasIngress || !hasEgress {
			t.Errorf("%s: default-deny must cover both Ingress and Egress", doc.path)
		}
	}

	if !sawDefaultDeny {
		t.Fatal("no default-deny NetworkPolicy found")
	}
}

// Every deployable carries its owner, SLO and runbook, so an incident responder
// does not have to guess who to wake (Blueprint §14).
func TestWorkloadsDeclareOwnershipAndRunbook(t *testing.T) {
	for _, doc := range loadManifests(t) {
		if doc.kind() != "Deployment" && doc.kind() != "CronJob" {
			continue
		}
		if !strings.HasPrefix(doc.path, "base/") {
			continue
		}

		meta, _ := doc.data["metadata"].(map[string]any)
		annotations, _ := meta["annotations"].(map[string]any)

		for _, required := range []string{"healthcare.io/owning-team", "healthcare.io/runbook"} {
			if annotations[required] == nil {
				t.Errorf("%s/%s: missing annotation %s", doc.path, doc.name(), required)
			}
		}
	}
}

// The namespace enforces the restricted Pod Security profile, so a workload
// that slips past these tests is still rejected by the API server.
func TestNamespaceEnforcesRestrictedPodSecurity(t *testing.T) {
	var sawNamespace bool

	for _, doc := range loadManifests(t) {
		if doc.kind() != "Namespace" {
			continue
		}
		sawNamespace = true

		meta, _ := doc.data["metadata"].(map[string]any)
		labels, _ := meta["labels"].(map[string]any)
		if labels["pod-security.kubernetes.io/enforce"] != "restricted" {
			t.Errorf("%s: namespace must enforce the restricted Pod Security profile", doc.path)
		}
	}

	if !sawNamespace {
		t.Fatal("no Namespace manifest found")
	}
}

// An overlay may raise resources or spread replicas; it must never relax a
// security control. Checking the patch fragments directly catches the
// weakening at the point it is written, without needing kustomize in CI.
func TestOverlayPatchesNeverWeakenSecurity(t *testing.T) {
	// field -> the only value that is not a weakening.
	required := map[string]any{
		"runAsNonRoot":             true,
		"allowPrivilegeEscalation": false,
		"readOnlyRootFilesystem":   true,
		"privileged":               false,
		"hostNetwork":              false,
		"hostPID":                  false,
		"hostIPC":                  false,
	}

	var checked int
	for _, doc := range loadManifests(t) {
		if !doc.isPatch() {
			continue
		}
		checked++
		walkForWeakening(t, doc.path, doc.data, required)
	}

	if checked == 0 {
		t.Fatal("no overlay patches found; this rule is no longer testing anything")
	}
}

// walkForWeakening recurses through a patch looking for security fields set to
// anything other than their required value.
func walkForWeakening(t *testing.T, path string, node any, required map[string]any) {
	t.Helper()

	switch typed := node.(type) {
	case map[string]any:
		for key, value := range typed {
			if want, guarded := required[key]; guarded && value != want {
				t.Errorf("%s sets %s: %v, weakening the base (must be %v)", path, key, value, want)
			}
			if key == "capabilities" {
				if caps, ok := value.(map[string]any); ok {
					if added, _ := caps["add"].([]any); len(added) > 0 {
						t.Errorf("%s adds capabilities %v", path, added)
					}
				}
			}
			walkForWeakening(t, path, value, required)
		}
	case []any:
		for _, item := range typed {
			walkForWeakening(t, path, item, required)
		}
	}
}
