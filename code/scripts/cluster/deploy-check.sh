#!/usr/bin/env bash
# Deploys the shipped manifests to a real cluster and proves the workload runs.
#
# The companion to admission-check.sh, which stops at "the API server accepts
# these objects". This one goes further: kubelet schedules the Deployment, the
# probes it declares are the probes that gate readiness, and the running Pod
# serves the system's own gate criteria.
#
# # Why this works now and did not before
#
# Every earlier attempt died creating the pod sandbox: runc sets the pause
# container's oom_score_adj to -998, which needs CAP_SYS_RESOURCE, and that
# capability is dropped here. That was reported as "no distribution can start a
# pod in this environment", and it was wrong — it was true of the default
# configuration, not of the environment. containerd's CRI plugin has
# restrict_oom_score_adj, the supported setting for rootless and constrained
# hosts, which clamps the value to what the process may set instead of failing.
# One line of kind config and pods start.
#
# # What is substituted, and why each is honest
#
#   image       The manifests pin a digest only the release pipeline produces,
#               so nothing pulls. The locally built image is loaded into the
#               node and the digest replaced. The image is the one the
#               Dockerfile's runtime stage builds.
#   secret      The manifests source DATABASE_URL from an ExternalSecret, which
#               needs the external-secrets controller. That controller is not
#               installed, so the Secret it would create is created directly.
#               What is being tested is the workload, not the secret operator.
#   database    A PostgreSQL Deployment in the same namespace, migrated from
#               db/migrations exactly as the repository ships them.
#
# Everything else — the security context, the probes, the resource limits, the
# service account, the network policy, the disruption budget — is applied as
# written.
set -euo pipefail

CLUSTER="${CLUSTER:-health}"
NAMESPACE="${NAMESPACE:-healthcare-dev}"
IMAGE="${IMAGE:-health/core:cluster}"
POSTGRES_IMAGE="${POSTGRES_IMAGE:-local/postgres:16}"
POSTGRES_UPSTREAM="${POSTGRES_UPSTREAM:-postgres:16-alpine}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

log() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "missing: $1" >&2; exit 1; }
}
require kind
require kubectl
require docker

log "Cluster"
if ! kind get clusters 2>/dev/null | grep -qx "$CLUSTER"; then
  kind create cluster --name "$CLUSTER" --config "$ROOT/infra/k8s/kind.yaml"
fi
kubectl config use-context "kind-$CLUSTER" >/dev/null
kubectl wait --for=condition=Ready nodes --all --timeout=180s

log "Image"
# Built on the host: the sandbox's TLS-intercepting proxy blocks the Go module
# proxy inside a build container, so the build stage cannot run here. The
# runtime stage is reproduced exactly.
CGO_ENABLED=0 GOOS=linux go build -C "$ROOT" -trimpath \
  -ldflags "-s -w -X main.version=cluster -X main.commit=$(git -C "$ROOT" rev-parse HEAD)" \
  -o /tmp/core-cluster ./cmd/core
BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD" "${TLS:-}" /tmp/core-cluster' EXIT
cp /tmp/core-cluster "$BUILD/core"
# The runtime stage, character for character from infra/docker/core.Dockerfile.
sed -n '/^FROM gcr.io\/distroless/,$p' "$ROOT/infra/docker/core.Dockerfile" \
  | sed 's|COPY --from=build /out/core /core|COPY core /core|' > "$BUILD/Dockerfile"
docker build -q -t "$IMAGE" "$BUILD" >/dev/null
kind load docker-image "$IMAGE" --name "$CLUSTER"

log "Database image"
# The node cannot reach a registry: the sandbox's egress proxy listens on the
# host's loopback, which is a different network namespace from the node's. The
# host's Docker can pull, so every image this cluster runs is pulled here and
# side-loaded — the same route the core image takes, for the same reason.
#
# Rebuilt rather than loaded straight from the registry: BuildKit attaches an
# attestation manifest, and `kind load` imports with --all-platforms, which
# fails on it ("content digest ... not found"). A one-line derived image built
# with --provenance=false has a single manifest and loads cleanly.
if ! docker image inspect "$POSTGRES_IMAGE" >/dev/null 2>&1; then
  PG_BUILD="$(mktemp -d)"
  printf 'FROM %s\n' "$POSTGRES_UPSTREAM" > "$PG_BUILD/Dockerfile"
  docker build --provenance=false --platform=linux/amd64 \
    -q -t "$POSTGRES_IMAGE" "$PG_BUILD" >/dev/null
  rm -rf "$PG_BUILD"
fi
kind load docker-image "$POSTGRES_IMAGE" --name "$CLUSTER"

log "Database TLS"
# A private CA and a server certificate for the in-cluster database, which is
# what a managed PostgreSQL presents too. Generated per run and never
# committed: a certificate in a repository is a certificate somebody reuses.
TLS="$(mktemp -d)"
openssl req -x509 -newkey rsa:2048 -nodes -days 1 \
  -subj "/CN=health-deploy-check-ca" \
  -keyout "$TLS/ca.key" -out "$TLS/ca.crt" 2>/dev/null
openssl req -newkey rsa:2048 -nodes \
  -subj "/CN=postgres" -keyout "$TLS/tls.key" -out "$TLS/tls.csr" 2>/dev/null
# The SAN is what verify-full checks the hostname against, and the hostname is
# the Service name the DSN dials.
openssl x509 -req -in "$TLS/tls.csr" -CA "$TLS/ca.crt" -CAkey "$TLS/ca.key" \
  -CAcreateserial -days 1 -out "$TLS/tls.crt" \
  -extfile <(printf 'subjectAltName=DNS:postgres,DNS:postgres.%s.svc.cluster.local\n' "$NAMESPACE") \
  2>/dev/null
kubectl apply -f "$ROOT/infra/k8s/base/namespace.yaml" >/dev/null
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 ||
  kubectl create namespace "$NAMESPACE"
# The namespace the overlay targets carries the same Pod Security label the
# base namespace does; without it, restricted admission would not be enforcing
# and the deploy below would prove nothing about the security context.
kubectl label namespace "$NAMESPACE" \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/enforce-version=latest --overwrite >/dev/null

kubectl -n "$NAMESPACE" create secret tls postgres-tls \
  --cert="$TLS/tls.crt" --key="$TLS/tls.key" \
  --dry-run=client -o yaml | kubectl apply -f - >/dev/null
# The CA the workload trusts, mounted by the shipped Deployment at
# /etc/ssl/database and named by the DSN's sslrootcert.
kubectl -n "$NAMESPACE" create configmap core-database-ca \
  --from-file=ca.crt="$TLS/ca.crt" \
  --dry-run=client -o yaml | kubectl apply -f - >/dev/null

kubectl apply -n "$NAMESPACE" -f "$ROOT/infra/k8s/dev-postgres.yaml"
# The certificate is minted fresh every run, and a Secret changing under a
# running Pod does not restart it — PostgreSQL would keep serving the previous
# certificate while the workload verified against the new CA, which fails as
# "certificate signed by unknown authority" and reads like a bug in the
# manifests rather than a stale pod.
kubectl -n "$NAMESPACE" rollout restart deployment/postgres >/dev/null
kubectl -n "$NAMESPACE" rollout status deployment/postgres --timeout=300s

log "Schema"
POD="$(kubectl -n "$NAMESPACE" get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}')"
# The migrations are not idempotent and are not meant to be — they are applied
# once, in order, by a migration runner. Re-running this script against a live
# database would otherwise fail on the first CREATE TABLE.
APPLIED="$(kubectl -n "$NAMESPACE" exec -i "$POD" -- psql -qtA -U postgres -d core \
  -c "SELECT to_regclass('organization.tenant') IS NOT NULL" 2>/dev/null || echo f)"
if [ "$APPLIED" = "t" ]; then
  echo "schema already present; skipping migrations"
else
  for migration in "$ROOT"/db/migrations/*.up.sql; do
    kubectl -n "$NAMESPACE" exec -i "$POD" -- \
      psql -v ON_ERROR_STOP=1 -q -U postgres -d core < "$migration"
  done
  echo "schema applied from db/migrations"
fi

log "CRDs"
# Schemas only, not the controllers, exactly as admission-check.sh installs
# them and pinned to the same versions. The ClusterPolicy and the SecretStore
# have to be applicable for the overlay to apply at all; the controllers behind
# them would try to reach a Vault and a registry that are not here, which is
# why the ExternalSecret is dropped and its Secret created directly.
ESO_VERSION="${ESO_VERSION:-v0.10.5}"
KYVERNO_VERSION="${KYVERNO_VERSION:-v1.13.2}"
kubectl apply --server-side -f \
  "https://raw.githubusercontent.com/external-secrets/external-secrets/$ESO_VERSION/deploy/crds/bundle.yaml" >/dev/null
kubectl apply --server-side -f \
  "https://raw.githubusercontent.com/kyverno/kyverno/$KYVERNO_VERSION/config/crds/kyverno/kyverno.io_clusterpolicies.yaml" >/dev/null
echo "external-secrets $ESO_VERSION, kyverno $KYVERNO_VERSION"

log "Secret"
# What the ExternalSecret would have produced. verify-full against the private
# CA above — not "disable" and not "require", because the binary refuses both
# and is right to. This is the same shape a managed PostgreSQL needs.
kubectl -n "$NAMESPACE" create secret generic core-database \
  --from-literal=url='postgres://postgres:postgres@postgres:5432/core?sslmode=verify-full&sslrootcert=/etc/ssl/database/ca.crt' \
  --dry-run=client -o yaml | kubectl apply -f - >/dev/null

log "Deploy"
# Likewise for the workload: the CA ConfigMap it mounts has just been
# rewritten, and a mounted ConfigMap changing does not restart the Pod either.
kubectl kustomize "$ROOT/infra/k8s/overlays/dev" \
  | python3 "$ROOT/scripts/cluster/localise.py" --image "$IMAGE" \
  | kubectl apply -f - >/dev/null
kubectl -n "$NAMESPACE" rollout restart deployment/core >/dev/null
kubectl -n "$NAMESPACE" rollout status deployment/core --timeout=300s

log "The workload"
kubectl -n "$NAMESPACE" get pods -l app.kubernetes.io/name=core -o wide
echo
echo "Security context as the Pod actually runs it:"
kubectl -n "$NAMESPACE" get pod -l app.kubernetes.io/name=core \
  -o jsonpath='{range .items[0]}  runAsUser={.spec.securityContext.runAsUser}{"\n"}  runAsNonRoot={.spec.securityContext.runAsNonRoot}{"\n"}  readOnlyRootFilesystem={.spec.containers[0].securityContext.readOnlyRootFilesystem}{"\n"}  allowPrivilegeEscalation={.spec.containers[0].securityContext.allowPrivilegeEscalation}{"\n"}  capabilities={.spec.containers[0].securityContext.capabilities.drop}{"\n"}  seccomp={.spec.securityContext.seccompProfile.type}{"\n"}{end}'
