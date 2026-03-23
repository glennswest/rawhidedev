#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"
PLATFORM="linux/amd64"

# Install buildah if not present (bootstrap from upstream Fedora image)
if ! command -v buildah &>/dev/null; then
    echo "=== Installing buildah ==="
    dnf install -y buildah
fi

echo "=== Building fedoradev (Fedora Stable) [${PLATFORM}] ==="
buildah build --platform "${PLATFORM}" -t fedoradev -f Containerfile.stable .

echo "=== Tagging fedoradev ==="
buildah tag fedoradev "${REGISTRY}/fedoradev:latest"

echo "=== Pushing fedoradev ==="
buildah push --tls-verify=false "${REGISTRY}/fedoradev:latest"

echo ""
echo "=== Done ==="
echo "  ${REGISTRY}/fedoradev:latest"
