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

echo "=== Building fedoradev (Fedora Stable) [${PLATFORM}] ==="
buildah ${STORAGE_ARGS} build --platform "${PLATFORM}" -t fedoradev -f Containerfile.stable .

echo "=== Tagging fedoradev ==="
buildah ${STORAGE_ARGS} tag fedoradev "${REGISTRY}/fedoradev:latest"

echo "=== Pushing fedoradev ==="
buildah ${STORAGE_ARGS} push --tls-verify=false "${REGISTRY}/fedoradev:latest"

echo ""
echo "=== Done ==="
echo "  ${REGISTRY}/fedoradev:latest"
