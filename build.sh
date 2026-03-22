#!/bin/bash
set -euo pipefail

echo "=== Building rawhidedev (Fedora Rawhide) ==="
buildah build -t rawhidedev -f Containerfile .

echo "=== Building fedoradev (Fedora Stable) ==="
buildah build -t fedoradev -f Containerfile.stable .

echo ""
echo "=== Build complete ==="
