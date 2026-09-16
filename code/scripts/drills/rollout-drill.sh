#!/usr/bin/env bash
# DRILL-2026-004 -- rolling update under load (SRS-NFR-002, SRS-SRE-DEP).
#
# The Deployment claims maxUnavailable: 0 and carries a PodDisruptionBudget.
# Both are assertions about what happens during a rollout, and neither is
# testable without one: a manifest test can read the number, and only a cluster
# can tell you whether the number is true.
#
# The drill replaces the running version while a client asks for something real
# at a steady rate, and counts what the client saw. A rollout that drops one
# request has dropped a clinician's save.
#
# What it does not cover: a multi-node cluster, a cross-zone rollout, or a
# rollout under production concurrency. One node means the new pod and the old
# one land on the same kubelet, which is the easy case; the figure below is a
# floor.
set -euo pipefail

NAMESPACE="${NAMESPACE:-healthcare-dev}"
DURATION="${DURATION:-60}"
INTERVAL="${INTERVAL:-0.1}"
PORT="${PORT:-18099}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

log() { printf '%s  %s\n' "$(date -u +%H:%M:%S)" "$*"; }

kubectl -n "$NAMESPACE" get deployment core >/dev/null

log "building the in-cluster load generator"
# In-cluster on purpose. `kubectl port-forward svc/...` binds to one Pod and
# dies with it, so a client outside the cluster measures kubectl's behaviour
# during a rollout rather than the cluster's — the first version of this drill
# did exactly that and reported 453 dropped requests that were nothing of the
# kind. The Service's virtual IP only load-balances for callers inside.
PROBE_IMAGE="${PROBE_IMAGE:-local/probe:1}"
# A development-verifier token: tenant:subject:role. It moves the probe into the
# authenticated rate-limit bucket (20/s, burst 60) rather than the
# unauthenticated one (2/s, burst 10), which this asks ten times faster than.
PROBE_TOKEN="${PROBE_TOKEN:-$(cat /proc/sys/kernel/random/uuid):rollout-drill:platform_operator}"
if ! docker image inspect "$PROBE_IMAGE" >/dev/null 2>&1; then
  BUILD="$(mktemp -d)"
  cp "$ROOT/scripts/drills/probe/main.go" "$ROOT/scripts/drills/probe/go.mod" "$BUILD/"
  ( cd "$BUILD" && CGO_ENABLED=0 GOOS=linux go build -o probe . )
  printf 'FROM gcr.io/distroless/static-debian12:nonroot\nCOPY probe /probe\nUSER 65532:65532\nENTRYPOINT ["/probe"]\n' \
    > "$BUILD/Dockerfile"
  docker build --provenance=false --platform=linux/amd64 -q -t "$PROBE_IMAGE" "$BUILD" >/dev/null
  rm -rf "$BUILD"
fi
kind load docker-image "$PROBE_IMAGE" --name "${CLUSTER:-health}" >/dev/null

BEFORE="$(kubectl -n "$NAMESPACE" get pod -l app.kubernetes.io/name=core \
  -o jsonpath='{.items[*].metadata.name}')"
log "before: $BEFORE"

kubectl -n "$NAMESPACE" delete pod rollout-probe --ignore-not-found >/dev/null 2>&1
# A real RPC rather than the readiness probe: /readyz answers 503 by design
# while a pod drains, so polling it counts the drain working as the drain
# failing. This goes through the interceptor chain and the handler.
log "asking for a real RPC every 100ms for ${DURATION}s, from inside the cluster"
kubectl -n "$NAMESPACE" run rollout-probe --image="$PROBE_IMAGE" --restart=Never \
  --image-pull-policy=Never \
  --env="TARGET=http://core/healthcare.platform_api.v1.HealthService/CheckLiveness" \
  --env="SECONDS=$DURATION" --env="TOKEN=$PROBE_TOKEN" \
  --overrides='{"spec":{"automountServiceAccountToken":false,"securityContext":{"runAsNonRoot":true,"runAsUser":65532,"seccompProfile":{"type":"RuntimeDefault"}},"containers":[{"name":"rollout-probe","image":"'"$PROBE_IMAGE"'","imagePullPolicy":"Never","env":[{"name":"TARGET","value":"http://core/healthcare.platform_api.v1.HealthService/CheckLiveness"},{"name":"SECONDS","value":"'"$DURATION"'"},{"name":"TOKEN","value":"'"$PROBE_TOKEN"'"}],"securityContext":{"allowPrivilegeEscalation":false,"readOnlyRootFilesystem":true,"capabilities":{"drop":["ALL"]}}}]}}' \
  >/dev/null

sleep 5
log "rolling the deployment while the client is asking"
kubectl -n "$NAMESPACE" set env deployment/core "DRILL_ROLLOUT=$(date +%s)" >/dev/null
kubectl -n "$NAMESPACE" rollout status deployment/core --timeout=300s

kubectl -n "$NAMESPACE" wait --for=condition=Ready=false pod/rollout-probe \
  --timeout=$(( DURATION + 60 ))s >/dev/null 2>&1 || true
RESULTS="$(kubectl -n "$NAMESPACE" logs rollout-probe 2>/dev/null | grep '^RESULTS' || true)"
kubectl -n "$NAMESPACE" delete pod rollout-probe --ignore-not-found >/dev/null 2>&1

if [ -z "$RESULTS" ]; then
  echo "RESULT: invalid -- the load generator produced no output" >&2
  exit 1
fi

TOTAL="$(echo "$RESULTS" | tr ' ' '\n' | sed -n 's/^total=//p')"
OK="$(echo "$RESULTS" | tr ' ' '\n' | sed -n 's/^200=//p')"
OK="${OK:-0}"
LIMITED="$(echo "$RESULTS" | tr ' ' '\n' | sed -n 's/^429=//p')"
LIMITED="${LIMITED:-0}"
# The rate limiter refusing a caller that asked too fast is the rate limiter
# working. Counted apart from the failures so it cannot mark a healthy rollout
# as a failed one — the mistake DRILL-2026-001 made before it was corrected.
FAILED=$(( TOTAL - OK - LIMITED ))

AFTER="$(kubectl -n "$NAMESPACE" get pod -l app.kubernetes.io/name=core \
  -o jsonpath='{.items[*].metadata.name}')"
log "after: $AFTER"

echo
echo "requests:     $TOTAL"
echo "served:       $OK"
echo "rate-limited: $LIMITED"
echo "failed:       $FAILED"
echo "breakdown:    $RESULTS"

if [ "$BEFORE" = "$AFTER" ]; then
  echo
  echo "RESULT: invalid -- the pod did not change, so nothing was rolled" >&2
  exit 1
fi

if [ "$LIMITED" -gt "$OK" ]; then
  echo
  echo "RESULT: invalid -- $LIMITED of $TOTAL were rate-limited; the drill was" >&2
  echo "        measuring the limiter rather than the rollout" >&2
  exit 1
fi

if [ "$FAILED" -ne 0 ]; then
  echo
  echo "RESULT: not met -- $FAILED of $TOTAL requests were dropped during the rollout" >&2
  exit 1
fi

echo
echo "RESULT: met -- $TOTAL requests, none dropped, across a full replacement"
