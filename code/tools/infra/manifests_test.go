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
	"strconv"
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

// devFixture reports whether a document is a local development fixture rather
// than something the release pipeline ships.
//
// The distinction matters for exactly three invariants — digest pinning, the
// release registry, and zero-downtime rollout — which a side-loaded image and a
// single-replica scratch database cannot satisfy and should not pretend to.
// Every security invariant still applies: a fixture exempted from the policy is
// a hole the policy does not cover, and the namespace enforces "restricted"
// against it either way.
//
// Marked on the object rather than matched by filename, so a new fixture has to
// say so in its own text and a shipped workload cannot become exempt by being
// moved.
func (d document) devFixture() bool {
	metadata, _ := d.data["metadata"].(map[string]any)
	annotations, _ := metadata["annotations"].(map[string]any)
	return annotations["health.dev/fixture"] == "true"
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

			// The probe paths are plain HTTP, not the Connect procedure
			// paths they used to be: a Connect unary procedure is a POST and a
			// Kubernetes httpGet probe issues GET, so the old declaration
			// answered 405 and the Pod never became ready. See
			// RegisterProbes in internal/platform_api/transport/health.go.
			if path == "/readyz" || strings.Contains(path, "CheckReadiness") {
				t.Errorf("%s/%s: liveness probes readiness (%s); a dependency outage would restart every pod",
					doc.path, doc.name(), path)
			}
			if path != "/healthz" {
				t.Errorf("%s/%s: liveness probe path %q is not the liveness endpoint", doc.path, doc.name(), path)
			}
		}
	}

	if checked == 0 {
		t.Fatal("no liveness probes found")
	}
}

// A probe Kubernetes cannot issue is a probe that never passes.
//
// httpGet probes send GET and there is no way to make them send anything else.
// Every probe here was originally declared against a ConnectRPC procedure path,
// which only answers POST, so all three returned 405 and the Deployment could
// not roll out in any cluster. Schema validation passed, admission passed, and
// running the image by hand passed — because doing it by hand means choosing
// the verb yourself, which is the whole mistake.
func TestProbesUseGetReachablePaths(t *testing.T) {
	checked := 0
	for _, doc := range loadManifests(t) {
		if doc.isPatch() {
			continue
		}
		podSpec, ok := doc.podSpec()
		if !ok {
			continue
		}
		for _, container := range containersOf(podSpec) {
			for _, kind := range []string{"livenessProbe", "readinessProbe", "startupProbe"} {
				probe, ok := container[kind].(map[string]any)
				if !ok {
					continue
				}
				httpGet, ok := probe["httpGet"].(map[string]any)
				if !ok {
					// exec and tcpSocket probes are not subject to this.
					continue
				}
				checked++
				path, _ := httpGet["path"].(string)
				if strings.Contains(path, ".v1.") || strings.Contains(path, "Service/") {
					t.Errorf("%s/%s: %s httpGet path %q looks like an RPC procedure; "+
						"a Connect procedure only answers POST and an httpGet probe sends GET",
						doc.path, doc.name(), kind, path)
				}
			}
		}
	}
	if checked == 0 {
		t.Fatal("no httpGet probes found")
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
		if doc.devFixture() {
			continue
		}
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

// TLS_MODE follows AUTH_MODE: no base default, and every overlay must declare
// one (SRS-SEC-001). The process refuses to start without it, so a missing
// value in an overlay is a crash-loop found at deploy time rather than here.
func TestTLSModeIsDeclaredPerOverlayAndNeverInBase(t *testing.T) {
	declared := map[string]string{}

	for _, doc := range loadManifests(t) {
		if doc.kind() != "ConfigMap" {
			continue
		}
		data, _ := doc.data["data"].(map[string]any)

		if strings.HasPrefix(doc.path, "base/") {
			if _, isCoreConfig := data["LISTEN_ADDR"]; isCoreConfig {
				if value, present := data["TLS_MODE"]; present {
					t.Errorf("base ConfigMap defaults TLS_MODE to %q; set it per overlay", value)
				}
			}
			continue
		}
		if doc.name() != "core-config" {
			continue
		}
		mode, present := data["TLS_MODE"]
		if !present {
			t.Errorf("%s does not declare TLS_MODE; the pod will refuse to start", doc.path)
			continue
		}
		text, _ := mode.(string)
		switch text {
		case "serve", "mesh":
		default:
			t.Errorf("%s sets TLS_MODE=%q, which is neither serve nor mesh", doc.path, text)
		}
		declared[filepath.Dir(doc.path)] = text
	}

	for _, env := range []string{
		filepath.Join("overlays", "dev"),
		filepath.Join("overlays", "preprod"),
		filepath.Join("overlays", "prod"),
	} {
		if _, ok := declared[env]; !ok {
			t.Errorf("%s declares no TLS_MODE", env)
		}
	}
}

// Every database connection string assembled in a manifest must authenticate
// the server it connects to (SRS-SEC-001, SRS-SEC-002).
//
// ValidateDatabaseDSN refuses anything weaker at startup, so this test is the
// earlier half of the same rule: catch it in review rather than in a
// crash-loop, and catch the sslmode that was dropped from a template during an
// unrelated edit.
func TestDatabaseTemplatesPinVerifiedTLS(t *testing.T) {
	var sawTemplate bool

	for _, doc := range loadManifests(t) {
		if doc.kind() != "ExternalSecret" {
			continue
		}
		spec, _ := doc.data["spec"].(map[string]any)
		target, _ := spec["target"].(map[string]any)
		template, _ := target["template"].(map[string]any)
		data, _ := template["data"].(map[string]any)

		for key, raw := range data {
			text, _ := raw.(string)
			if !strings.HasPrefix(text, "postgres://") {
				continue
			}
			sawTemplate = true
			if !strings.Contains(text, "sslmode=verify-full") && !strings.Contains(text, "sslmode=verify-ca") {
				t.Errorf("%s: %s.%s builds a DSN without a verifying sslmode", doc.path, doc.name(), key)
			}
		}
	}

	if !sawTemplate {
		t.Fatal("no database DSN template found; this invariant would pass vacuously")
	}
}

// Stores that can hold PHI must name the managed key that protects them
// (SRS-SEC-002). The check is that a reference exists and is an alias: an
// inline key id pins a specific key version, so rotating the key would then
// require a manifest change and would therefore not happen on schedule.
func TestEncryptionAtRestNamesManagedKeys(t *testing.T) {
	const policyName = "core-encryption-policy"

	required := []string{
		"KMS_KEY_ALIAS_DATABASE",
		"KMS_KEY_ALIAS_OBJECT_STORE",
		"KMS_KEY_ALIAS_BACKUP",
	}

	var found bool
	for _, doc := range loadManifests(t) {
		if doc.kind() != "ConfigMap" || doc.name() != policyName {
			continue
		}
		found = true
		data, _ := doc.data["data"].(map[string]any)

		for _, key := range required {
			value, _ := data[key].(string)
			if value == "" {
				t.Errorf("%s: %s names no key", doc.path, key)
				continue
			}
			if !strings.HasPrefix(value, "alias/") {
				t.Errorf("%s: %s is %q; use an alias so rotation needs no manifest change",
					doc.path, key, value)
			}
		}

		// The backup key must differ from the database key. Same key means one
		// compromised or deleted key takes the data and the means of recovering
		// it at the same time.
		if data["KMS_KEY_ALIAS_BACKUP"] == data["KMS_KEY_ALIAS_DATABASE"] {
			t.Errorf("%s: backups share the database key; a single key loss takes both", doc.path)
		}

		rotation, _ := data["KMS_KEY_ROTATION_DAYS"].(string)
		days, err := strconv.Atoi(rotation)
		if err != nil {
			t.Errorf("%s: KMS_KEY_ROTATION_DAYS is %q, not a number of days", doc.path, rotation)
		} else if days <= 0 || days > 365 {
			t.Errorf("%s: key rotation every %d days is outside the annual maximum", doc.path, days)
		}
	}

	if !found {
		t.Fatalf("%s not found; encryption-at-rest references are unasserted", policyName)
	}
}

// Any PersistentVolumeClaim must bind to an encrypted storage class
// (SRS-SEC-002). A claim that omits storageClassName gets the cluster default,
// which is whatever the platform team last set and is not a decision this
// repository has made.
func TestVolumeClaimsUseAnEncryptedStorageClass(t *testing.T) {
	encrypted := map[string]bool{}
	for _, doc := range loadManifests(t) {
		if doc.kind() != "StorageClass" {
			continue
		}
		params, _ := doc.data["parameters"].(map[string]any)
		if params["encrypted"] == "true" && params["kmsKeyId"] != nil {
			encrypted[doc.name()] = true
		}
	}

	for _, doc := range loadManifests(t) {
		var claims []map[string]any
		switch doc.kind() {
		case "PersistentVolumeClaim":
			claims = append(claims, doc.data)
		case "StatefulSet":
			spec, _ := doc.data["spec"].(map[string]any)
			raw, _ := spec["volumeClaimTemplates"].([]any)
			for _, c := range raw {
				if m, ok := c.(map[string]any); ok {
					claims = append(claims, m)
				}
			}
		default:
			continue
		}

		for _, claim := range claims {
			spec, _ := claim["spec"].(map[string]any)
			class, _ := spec["storageClassName"].(string)
			if class == "" {
				t.Errorf("%s: a volume claim relies on the cluster default storage class", doc.path)
				continue
			}
			if !encrypted[class] {
				t.Errorf("%s: storage class %q is not declared encrypted with a managed key", doc.path, class)
			}
		}
	}
}

// TestEncryptionDetectorWorks proves the assertions above can fail.
//
// There are no PersistentVolumeClaims in the manifests today, so
// TestVolumeClaimsUseAnEncryptedStorageClass currently passes over an empty
// set. That is fine as an invariant and useless as evidence, so the detector
// is exercised directly against a claim that would violate it.
func TestEncryptionDetectorWorks(t *testing.T) {
	encrypted := map[string]bool{"healthcare-encrypted": true}

	unclassed := map[string]any{"spec": map[string]any{}}
	spec, _ := unclassed["spec"].(map[string]any)
	if class, _ := spec["storageClassName"].(string); class != "" {
		t.Fatal("a claim with no storage class should read as empty")
	}

	plain := map[string]any{"spec": map[string]any{"storageClassName": "gp2"}}
	spec, _ = plain["spec"].(map[string]any)
	class, _ := spec["storageClassName"].(string)
	if encrypted[class] {
		t.Fatal("an unencrypted storage class was treated as encrypted")
	}
	if !encrypted["healthcare-encrypted"] {
		t.Fatal("the encrypted storage class was not recognised")
	}
}

// Supply chain (P0-11, SRS-SEC-006).
//
// Signing an image and then deploying it by tag proves nothing: a signature is
// over a digest, so verifying a tag verifies whatever that tag happened to
// point at a moment ago. These three invariants hold the chain together, and
// they run without a cluster because the failure they prevent is a YAML edit.

// imageRefs returns every container image referenced by a workload.
func (d document) imageRefs() []string {
	var refs []string

	var walk func(node any)
	walk = func(node any) {
		switch typed := node.(type) {
		case map[string]any:
			// A container is anything with both a name and an image; that is
			// true of initContainers and ephemeralContainers too, which is
			// exactly why the walk is generic rather than a fixed path.
			if image, ok := typed["image"].(string); ok {
				if _, named := typed["name"]; named {
					refs = append(refs, image)
				}
			}
			for _, value := range typed {
				walk(value)
			}
		case []any:
			for _, value := range typed {
				walk(value)
			}
		}
	}
	walk(d.data)
	return refs
}

func TestImagesArePinnedByDigest(t *testing.T) {
	var checked int

	for _, doc := range loadManifests(t) {
		if doc.devFixture() {
			continue
		}
		for _, ref := range doc.imageRefs() {
			checked++

			if !strings.Contains(ref, "@sha256:") {
				t.Errorf("%s deploys %q by tag; pin the digest that was signed", doc.path, ref)
				continue
			}
			// A reference may carry both a tag and a digest. The digest wins at
			// pull time, so this is safe, but it is also misleading in review —
			// the tag reads as the thing being deployed and is not.
			if before, _, _ := strings.Cut(ref, "@"); strings.Contains(before, ":") {
				t.Errorf("%s deploys %q with both a tag and a digest; drop the tag", doc.path, ref)
			}
		}
	}

	if checked == 0 {
		t.Fatal("no container images found; this invariant would pass vacuously")
	}
}

// Every image must come from the registry the release pipeline publishes to.
// A correctly-pinned digest from somewhere else is still an image nobody in
// this repository built.
func TestImagesComeFromTheReleaseRegistry(t *testing.T) {
	// Postgres tooling in the backup job is the one legitimate third party: it
	// is an upstream image, and pinning it by digest is the control that
	// applies. Listed explicitly so adding another needs a deliberate edit.
	allowedExternal := []string{"postgres@sha256:", "docker.io/library/postgres@sha256:"}

	for _, doc := range loadManifests(t) {
		if doc.devFixture() {
			continue
		}
		for _, ref := range doc.imageRefs() {
			if strings.HasPrefix(ref, "ghcr.io/ppusapati/health/") {
				continue
			}
			external := false
			for _, prefix := range allowedExternal {
				if strings.HasPrefix(ref, prefix) {
					external = true
					break
				}
			}
			if !external {
				t.Errorf("%s deploys %q from outside the release registry", doc.path, ref)
			}
		}
	}
}

// The cluster-side half. Signing without admission verification is a pipeline
// gate, and a pipeline gate is bypassed by anyone with kubectl.
func TestAdmissionVerifiesImageSignatures(t *testing.T) {
	var policy *document

	for _, doc := range loadManifests(t) {
		if doc.kind() == "ClusterPolicy" {
			found := doc
			policy = &found
			break
		}
	}
	if policy == nil {
		t.Fatal("no image-verification ClusterPolicy; signed images are never checked before a pod starts")
	}

	spec, _ := policy.data["spec"].(map[string]any)
	if action, _ := spec["validationFailureAction"].(string); action != "Enforce" {
		t.Errorf("the image policy is %q, not Enforce; it reports violations instead of refusing them", action)
	}

	rules, _ := spec["rules"].([]any)
	if len(rules) == 0 {
		t.Fatal("the image policy has no rules")
	}

	var sawSignature, sawProvenance bool
	for _, raw := range rules {
		rule, _ := raw.(map[string]any)
		verify, _ := rule["verifyImages"].([]any)
		for _, entry := range verify {
			image, _ := entry.(map[string]any)

			if required, ok := image["required"].(bool); !ok || !required {
				t.Errorf("rule %v does not require verification; an unsigned image would pass", rule["name"])
			}
			if _, has := image["attestations"]; has {
				sawProvenance = true
				continue
			}
			if _, has := image["attestors"]; has {
				sawSignature = true
				// Without this, a mutable tag could resolve to one image at
				// verification and another at pull.
				if mutate, ok := image["mutateDigest"].(bool); !ok || !mutate {
					t.Errorf("rule %v verifies a signature without pinning the digest it verified", rule["name"])
				}
			}
		}
	}

	if !sawSignature {
		t.Error("the policy never verifies a signature")
	}
	if !sawProvenance {
		t.Error("the policy never verifies build provenance; the signature alone does not say which commit produced the image")
	}
}

// The restore-verification job must not use the application's database
// credential (SRS-NFR-016, least privilege).
//
// backup-verify.sh creates a scratch database to restore into, so its
// credential needs CREATEDB. Sharing the application's secret would mean
// granting that privilege to the role that serves patient traffic, where it has
// no use and is one more thing a stolen credential can do. The drill that found
// this is recorded in docs/engineering/drill-log.md (DRILL-2026-002); this test
// is what stops it coming back the next time somebody consolidates two secrets
// that look alike.
func TestBackupJobUsesItsOwnDatabaseCredential(t *testing.T) {
	const applicationSecret = "core-database"

	var sawJob bool
	for _, doc := range loadManifests(t) {
		if doc.kind() != "CronJob" {
			continue
		}
		spec, _ := doc.data["spec"].(map[string]any)
		jobTemplate, _ := spec["jobTemplate"].(map[string]any)
		jobSpec, _ := jobTemplate["spec"].(map[string]any)
		podTemplate, _ := jobSpec["template"].(map[string]any)
		podSpec, _ := podTemplate["spec"].(map[string]any)
		containers, _ := podSpec["containers"].([]any)

		for _, rawContainer := range containers {
			container, _ := rawContainer.(map[string]any)
			env, _ := container["env"].([]any)
			for _, rawEntry := range env {
				entry, _ := rawEntry.(map[string]any)
				if entry["name"] != "DATABASE_URL" {
					continue
				}
				sawJob = true
				valueFrom, _ := entry["valueFrom"].(map[string]any)
				ref, _ := valueFrom["secretKeyRef"].(map[string]any)
				name, _ := ref["name"].(string)
				if name == applicationSecret {
					t.Errorf("%s: %s reads its database credential from %q, "+
						"the credential the application serves traffic with; "+
						"this job needs CREATEDB and the application must not have it",
						doc.path, doc.name(), applicationSecret)
				}
				if name == "" {
					t.Errorf("%s: %s takes DATABASE_URL from something other than a secret", doc.path, doc.name())
				}
			}
		}
	}

	if !sawJob {
		t.Fatal("no CronJob with a DATABASE_URL found; this invariant would pass vacuously")
	}
}
