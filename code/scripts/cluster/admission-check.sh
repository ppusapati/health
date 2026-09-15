#!/usr/bin/env bash
# Apply every overlay to a real Kubernetes API server and prove the pod
# security policy is enforcing (Gate A8, SRS-SEC-004).
#
# This is the step between `make manifests-validate` and an actual deployment,
# and it closes a gap neither of the others covers.
#
# `kubeconform` checks the rendered YAML against published JSON schemas and
# **skips ExternalSecret, SecretStore and ClusterPolicy entirely** -- there are
# no schemas for them, so today those three kinds are not validated at all. A
# real API server with the CRDs installed validates them properly.
#
# And `tools/infra` asserts the namespace carries the
# pod-security.kubernetes.io/enforce=restricted label. That is a statement about
# the label, not about the workload: nothing checked that the Deployment
# actually satisfies `restricted`. Applying it to a cluster does, because the
# ReplicaSet controller's pod creation goes through the admission plugin. The
# fault injection at the end is what makes a pass mean something -- a variant
# with privileged=true must be refused, or the check is measuring nothing.
#
# What this does NOT do is run the workload. The image is digest-pinned to a
# placeholder that only the release pipeline substitutes, so pods will not pull;
# and the database, the mesh and external-secrets are not here. "It applies" and
# "it runs" are different claims and this script only makes the first.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODE_ROOT="$(cd "$HERE/../.." && pwd)"

# CRD versions are pinned for the same reason image digests are: a check that
# silently tracks upstream stops being a check of anything in particular.
ESO_VERSION="${ESO_VERSION:-v0.10.5}"
KYVERNO_VERSION="${KYVERNO_VERSION:-v1.13.2}"

OVERLAYS=(dev preprod prod)
NAMESPACES=(healthcare-dev healthcare-preprod healthcare)

log() { printf '%s  %s\n' "$(date -u +%H:%M:%S)" "$*"; }

require_cluster() {
    if ! kubectl get --raw /readyz >/dev/null 2>&1; then
        echo "no reachable cluster; set KUBECONFIG" >&2
        exit 1
    fi
    log "cluster: $(kubectl version -o json 2>/dev/null | python3 -c 'import sys,json; print(json.load(sys.stdin)["serverVersion"]["gitVersion"])')"
}

install_crds() {
    # CRDs only, not the controllers. The point is schema validation and
    # admission, and a controller that reconciled these would try to reach a
    # Vault that is not here.
    log "installing CRDs (external-secrets $ESO_VERSION, kyverno $KYVERNO_VERSION)"
    kubectl apply --server-side -f \
        "https://raw.githubusercontent.com/external-secrets/external-secrets/$ESO_VERSION/deploy/crds/bundle.yaml" \
        >/dev/null
    kubectl apply --server-side -f \
        "https://raw.githubusercontent.com/kyverno/kyverno/$KYVERNO_VERSION/config/crds/kyverno/kyverno.io_clusterpolicies.yaml" \
        >/dev/null
}

apply_overlays() {
    local env
    for env in "${OVERLAYS[@]}"; do
        log "applying overlay $env"
        kustomize build "$CODE_ROOT/infra/k8s/overlays/$env" \
            | kubectl apply --server-side -f - > "/tmp/apply-$env.log" 2>&1 \
            || { echo "overlay $env was refused:"; sed 's/^/    /' "/tmp/apply-$env.log"; return 1; }
        printf '    %s objects applied\n' "$(wc -l < "/tmp/apply-$env.log" | tr -d ' ')"
    done
}

# The Deployment producing a Pod is the evidence that `restricted` admitted it.
# Waiting for a ReplicaSet rather than a running Pod is deliberate: the image
# cannot be pulled here, and a check that waited for Ready would be testing the
# registry.
pods_were_admitted() {
    local ns="$1"
    local deadline=$(( $(date +%s) + 60 ))
    while [ "$(date +%s)" -lt "$deadline" ]; do
        if [ "$(kubectl -n "$ns" get pods -l app.kubernetes.io/name=core \
                --no-headers 2>/dev/null | wc -l | tr -d ' ')" -gt 0 ]; then
            return 0
        fi
        if kubectl -n "$ns" get events --field-selector reason=FailedCreate \
            2>/dev/null | grep -qi podsecurity; then
            echo "    the shipped Deployment was REFUSED by PodSecurity:"
            kubectl -n "$ns" get events --field-selector reason=FailedCreate \
                -o jsonpath='{.items[0].message}' | fold -w 100 | sed 's/^/      /'
            return 1
        fi
        sleep 1
    done
    echo "    no pod appeared and no PodSecurity refusal was recorded"
    return 1
}

# Guard the guard. A namespace labelled `restricted` that is not enforcing looks
# exactly like one that is, right up until something privileged runs in it.
policy_refuses_a_privileged_pod() {
    local ns="$1"
    kustomize build "$CODE_ROOT/infra/k8s/overlays/dev" \
        | python3 "$HERE/inject-privileged.py" \
        | kubectl apply -f - >/dev/null 2>&1 || true

    local deadline=$(( $(date +%s) + 30 ))
    while [ "$(date +%s)" -lt "$deadline" ]; do
        if kubectl -n "$ns" get events --field-selector reason=FailedCreate 2>/dev/null \
            | grep -qi 'core-injected.*podsecurity'; then
            kubectl -n "$ns" delete deployment core-injected --ignore-not-found >/dev/null 2>&1
            return 0
        fi
        sleep 1
    done

    if kubectl -n "$ns" get pods -l app.kubernetes.io/name=core-injected \
        --no-headers 2>/dev/null | grep -q .; then
        echo "    A PRIVILEGED POD WAS ADMITTED. The namespace carries the"
        echo "    restricted label but the policy is not enforcing, so every"
        echo "    pass this script has ever reported was meaningless."
    else
        echo "    the injected deployment produced neither a pod nor a"
        echo "    PodSecurity refusal; the check cannot say whether the policy"
        echo "    is enforcing"
    fi
    kubectl -n "$ns" delete deployment core-injected --ignore-not-found >/dev/null 2>&1
    return 1
}

cleanup() {
    local ns
    for ns in "${NAMESPACES[@]}"; do
        kubectl delete namespace "$ns" --ignore-not-found --wait=false >/dev/null 2>&1 || true
    done
}

main() {
    require_cluster
    install_crds
    apply_overlays

    log "checking the shipped workload is admitted under restricted"
    pods_were_admitted healthcare-dev || { cleanup; exit 1; }
    echo "    admitted"

    log "checking the policy refuses a privileged variant"
    policy_refuses_a_privileged_pod healthcare-dev || { cleanup; exit 1; }
    echo "    refused"

    cleanup
    echo
    echo "every overlay applies to a real API server, including the three CRD"
    echo "kinds kubeconform cannot check, and pod security is enforcing."
}

main "$@"
