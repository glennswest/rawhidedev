#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"

echo "=== Building rawhidedev (Fedora Rawhide) ==="
buildah build -t rawhidedev -f Containerfile .

echo "=== Building fedoradev (Fedora Stable) ==="
buildah build -t fedoradev -f Containerfile.stable .

echo ""
echo "=== Build complete ==="

echo ""
echo "=== Tagging images ==="
buildah tag rawhidedev "${REGISTRY}/rawhidedev:latest"
buildah tag fedoradev "${REGISTRY}/fedoradev:latest"

echo "=== Pushing rawhidedev ==="
buildah push --tls-verify=false "${REGISTRY}/rawhidedev:latest"

echo "=== Pushing fedoradev ==="
buildah push --tls-verify=false "${REGISTRY}/fedoradev:latest"

echo ""
echo "=== Done ==="
echo "  ${REGISTRY}/rawhidedev:latest"
echo "  ${REGISTRY}/fedoradev:latest"
