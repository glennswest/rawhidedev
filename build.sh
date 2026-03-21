#!/bin/bash
set -euo pipefail

REGISTRY="registry.gt.lo:5000"

echo "=== Building rawhidedev (Fedora Rawhide) ==="
podman build -t rawhidedev -f Containerfile .

echo "=== Building fedoradev (Fedora Stable) ==="
podman build -t fedoradev -f Containerfile.stable .

echo ""
echo "=== Build complete ==="
podman images --filter "reference=rawhidedev" --filter "reference=fedoradev"
