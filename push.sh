#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"

echo "=== Tagging images ==="
buildah tag rawhidedev "${REGISTRY}/rawhidedev:latest"
buildah tag fedoradev "${REGISTRY}/fedoradev:latest"

echo "=== Pushing rawhidedev ==="
buildah push --tls-verify=false "${REGISTRY}/rawhidedev:latest"

echo "=== Pushing fedoradev ==="
buildah push --tls-verify=false "${REGISTRY}/fedoradev:latest"

echo ""
echo "=== Push complete ==="
echo "  ${REGISTRY}/rawhidedev:latest"
echo "  ${REGISTRY}/fedoradev:latest"
