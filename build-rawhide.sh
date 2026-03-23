#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"
PLATFORM="linux/amd64"

# Install buildah if not present (bootstrap from upstream Fedora image)
if ! command -v buildah &>/dev/null; then
    echo "=== Installing buildah ==="
    dnf install -y buildah
fi

echo "=== Building rawhidedev (Fedora Rawhide) [${PLATFORM}] ==="
buildah build --platform "${PLATFORM}" -t rawhidedev -f Containerfile .

echo "=== Tagging rawhidedev ==="
buildah tag rawhidedev "${REGISTRY}/rawhidedev:latest"

echo "=== Pushing rawhidedev ==="
buildah push --tls-verify=false "${REGISTRY}/rawhidedev:latest"

echo ""
echo "=== Done ==="
echo "  ${REGISTRY}/rawhidedev:latest"
