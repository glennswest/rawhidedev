#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"

echo "=== Tagging images ==="
podman tag rawhidedev "${REGISTRY}/rawhidedev:latest"
podman tag fedoradev "${REGISTRY}/fedoradev:latest"

echo "=== Pushing rawhidedev ==="
podman push --tls-verify=false "${REGISTRY}/rawhidedev:latest"

echo "=== Pushing fedoradev ==="
podman push --tls-verify=false "${REGISTRY}/fedoradev:latest"

echo ""
echo "=== Push complete ==="
echo "  ${REGISTRY}/rawhidedev:latest"
echo "  ${REGISTRY}/fedoradev:latest"
