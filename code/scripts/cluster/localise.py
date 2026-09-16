#!/usr/bin/env python3
"""Rewrites a rendered overlay for a local cluster, and nothing else.

Two substitutions, both named on the command line so a reader can see the whole
list:

  --image     replaces the digest-pinned image, which only the release pipeline
              produces and which therefore cannot be pulled here.
  (implicit)  drops the ExternalSecret and SecretStore, whose controller is not
              installed; deploy-check.sh creates the Secret they would have
              produced.

Everything else passes through untouched. A script that quietly relaxed a
security control to make a deploy succeed would make the deploy prove nothing,
so this one refuses to: it asserts that the securityContext it passes through
is the one the overlay rendered.
"""
import argparse
import sys

import yaml

DROPPED_KINDS = {"ExternalSecret", "SecretStore", "ClusterSecretStore"}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", required=True)
    args = parser.parse_args()

    documents = [d for d in yaml.safe_load_all(sys.stdin) if d]
    out = []

    for doc in documents:
        if doc.get("kind") in DROPPED_KINDS:
            continue
        if doc.get("kind") == "Deployment":
            for container in doc["spec"]["template"]["spec"]["containers"]:
                if container["name"] == "core":
                    container["image"] = args.image
                    container["imagePullPolicy"] = "Never"
                    security = container.get("securityContext", {})
                    # The point of the deploy is that these hold. If a future
                    # edit to this script relaxed one, the deploy would still
                    # go green and mean nothing.
                    assert security.get("readOnlyRootFilesystem") is True, security
                    assert security.get("allowPrivilegeEscalation") is False, security
                    assert security.get("capabilities", {}).get("drop") == ["ALL"], security
        out.append(doc)

    yaml.safe_dump_all(out, sys.stdout, default_flow_style=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
