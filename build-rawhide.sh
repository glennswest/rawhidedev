#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"
PLATFORM="linux/amd64"

# Use vfs storage driver when running inside a container (no /dev/fuse)
export BUILDAH_ISOLATION=chroot
STORAGE_ARGS="--storage-driver vfs"

# Install buildah if not present (bootstrap from upstream Fedora image)
if ! command -v buildah &>/dev/null; then
    echo "=== Installing buildah ==="
    dnf install -y buildah
fi

echo "=== Building rawhidedev (Fedora Rawhide) [${PLATFORM}] ==="
buildah ${STORAGE_ARGS} build --platform "${PLATFORM}" -t rawhidedev -f Containerfile .

echo "=== Tagging rawhidedev ==="
buildah ${STORAGE_ARGS} tag rawhidedev "${REGISTRY}/rawhidedev:latest"

echo "=== Pushing rawhidedev ==="
buildah ${STORAGE_ARGS} push --tls-verify=false "${REGISTRY}/rawhidedev:latest"

echo ""
echo "=== Done ==="
echo "  ${REGISTRY}/rawhidedev:latest"
