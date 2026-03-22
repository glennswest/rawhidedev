#!/bin/bash
set -euo pipefail

PLATFORM="linux/amd64"

echo "=== Building rawhidedev (Fedora Rawhide) [${PLATFORM}] ==="
buildah build --platform "${PLATFORM}" -t rawhidedev -f Containerfile .

echo "=== Building fedoradev (Fedora Stable) [${PLATFORM}] ==="
buildah build --platform "${PLATFORM}" -t fedoradev -f Containerfile.stable .

echo ""
echo "=== Build complete ==="
