"""Render the shipped Deployment as a privileged one, for the guard check.

Used by admission-check.sh. It takes the real overlay on stdin and emits a
single Deployment that violates every clause of the restricted profile the
namespace enforces: privileged, escalating, keeping its capabilities, running
as root, and without a seccomp profile.

Derived from the shipped manifest rather than written by hand, so it cannot
drift into a fixture that would be refused for some unrelated reason.
"""

import sys

import yaml


def main() -> None:
    documents = [d for d in yaml.safe_load_all(sys.stdin) if d]
    injected = []

    for document in documents:
        if document.get("kind") != "Deployment":
            continue

        pod = document["spec"]["template"]["spec"]
        pod["securityContext"]["runAsNonRoot"] = False
        pod["securityContext"].pop("seccompProfile", None)

        container = pod["containers"][0]
        container["securityContext"]["allowPrivilegeEscalation"] = True
        container["securityContext"]["privileged"] = True
        container["securityContext"].pop("capabilities", None)

        # Renamed so it cannot be confused with the real workload, and so the
        # check can delete exactly what it created.
        document["metadata"]["name"] = "core-injected"
        document["spec"]["selector"]["matchLabels"]["app.kubernetes.io/name"] = "core-injected"
        document["spec"]["template"]["metadata"]["labels"]["app.kubernetes.io/name"] = "core-injected"
        injected.append(document)

    if not injected:
        raise SystemExit("no Deployment found on stdin; nothing to inject into")

    yaml.safe_dump_all(injected, sys.stdout)


if __name__ == "__main__":
    main()
