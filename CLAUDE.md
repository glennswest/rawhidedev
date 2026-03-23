# CLAUDE.md — rawhidedev

## Building Container Images

Images are built via mkube's job scheduler on bare metal (server1). Each image has its own build script and is submitted as a separate job so they build in parallel.

### Submit parallel builds

```bash
# Rawhide build
curl -s -X POST 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs' \
  -H 'Content-Type: application/json' --data-binary @- <<'EOF'
{"apiVersion":"v1","kind":"Job","metadata":{"name":"build-rawhide","namespace":"default"},"spec":{"pool":"build","priority":10,"repo":"https://github.com/glennswest/rawhidedev","buildScript":"build-rawhide.sh","buildImage":"registry.gt.lo:5000/rawhidedev:latest","timeout":7200}}
EOF

# Stable build
curl -s -X POST 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs' \
  -H 'Content-Type: application/json' --data-binary @- <<'EOF'
{"apiVersion":"v1","kind":"Job","metadata":{"name":"build-stable","namespace":"default"},"spec":{"pool":"build","priority":10,"repo":"https://github.com/glennswest/rawhidedev","buildScript":"build-stable.sh","buildImage":"registry.gt.lo:5000/fedoradev:latest","timeout":7200}}
EOF
```

### Monitor

```bash
mk get jobs -n default
curl -s 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs/build-rawhide/logs'
curl -s 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs/build-stable/logs'
```

### Cleanup

```bash
mk delete job build-rawhide -n default
mk delete job build-stable -n default
```

### Build scripts

| Script | Purpose |
|--------|---------|
| `build-rawhide.sh` | Build + push `rawhidedev:latest` (mkube job) |
| `build-stable.sh` | Build + push `fedoradev:latest` (mkube job) |
| `build-and-push.sh` | Build + push both sequentially (local buildah) |
| `build.sh` | Build both locally without push |
| `push.sh` | Push pre-built images to registry |

### Key details

- mkube API: `http://192.168.200.2:8082`
- Registry: `registry.gt.lo:5000`
- Build pool: `build` (JobRunner: `build-runner`, host: `server1`)
- `mk` is aliased to `KUBECONFIG=~/.kube/mkube.config oc`
- Jobs are submitted via `POST /api/v1/namespaces/{ns}/jobs` (not `mk apply`, which has a Kind conflict with jobqueue)
