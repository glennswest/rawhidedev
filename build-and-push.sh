#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"
PLATFORM="linux/amd64"

echo "=== Installing build tools ==="
dnf install -y buildah

echo "=== Building rawhidedev (Fedora Rawhide) [${PLATFORM}] ==="
buildah build --platform "${PLATFORM}" -t rawhidedev -f Containerfile .

echo "=== Building fedoradev (Fedora Stable) [${PLATFORM}] ==="
buildah build --platform "${PLATFORM}" -t fedoradev -f Containerfile.stable .

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
