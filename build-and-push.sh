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

echo ""
echo "=== Tagging images ==="
podman tag rawhidedev "${REGISTRY}/rawhidedev:latest"
podman tag fedoradev "${REGISTRY}/fedoradev:latest"

echo "=== Pushing rawhidedev ==="
podman push --tls-verify=false "${REGISTRY}/rawhidedev:latest"

echo "=== Pushing fedoradev ==="
podman push --tls-verify=false "${REGISTRY}/fedoradev:latest"

echo ""
echo "=== Done ==="
echo "  ${REGISTRY}/rawhidedev:latest"
echo "  ${REGISTRY}/fedoradev:latest"
