# rawhidedev / fedoradev

Development containers for Fedora Rawhide and Fedora Stable with comprehensive tooling for kernel development, device driver development, Rust, Go, and general systems programming.

## Images

| Image | Base | Size | Registry |
|-------|------|------|----------|
| **rawhidedev** | `fedora:rawhide` | 8.29 GB | `registry.gt.lo:5000/rawhidedev:latest` |
| **fedoradev** | `fedora:latest` (stable) | 8.25 GB | `registry.gt.lo:5000/fedoradev:latest` |

Both images contain identical tooling — the only difference is the base Fedora version.

## What's included

### Kernel development

| Category | Packages |
|----------|----------|
| **Core** | kernel-devel, kernel-headers, kernel-modules, kernel-modules-extra, glibc-devel, elfutils-libelf-devel, elfutils-devel, openssl-devel, dwarves, sparse, coccinelle, bc, bison, flex, ncurses-devel, kmod, kmod-devel |
| **Source navigation** | cscope, ctags |
| **Documentation** | python3-sphinx, graphviz, ImageMagick, texinfo |
| **Kernel mail workflow** | b4, git-email |

### Device driver subsystem headers

| Subsystem | Packages |
|-----------|----------|
| **PCI** | pciutils, pciutils-devel |
| **USB** | usbutils, libusb1-devel |
| **GPU / DRM** | libdrm-devel, mesa-libGL-devel, mesa-libEGL-devel |
| **Input** | libinput-devel, libevdev-devel |
| **udev / systemd** | libudev-devel, systemd-devel |
| **Block / storage** | lvm2-devel, device-mapper-devel, libblkid-devel, libaio-devel, liburing-devel, sg3_utils-devel |
| **Network** | libmnl-devel, libnl3-devel, libnfnetlink-devel, libnetfilter_conntrack-devel, libpcap-devel |
| **RDMA / InfiniBand** | rdma-core-devel, libibverbs-devel |
| **NUMA** | numactl-devel |
| **Sound / ALSA** | alsa-lib-devel |
| **Crypto** | libgcrypt-devel, nss-devel |
| **I2C / SPI / GPIO** | i2c-tools |
| **Firmware / ACPI** | acpica-tools, pesign |
| **Device tree** | dtc |
| **Wireless** | iw, wireless-regdb, ethtool |

### Kernel debugging and tracing

| Category | Packages |
|----------|----------|
| **Profiling** | perf, strace, ltrace |
| **Crash analysis** | crash, systemtap, systemtap-devel |
| **Tracing** | trace-cmd, kernelshark |
| **BPF / eBPF** | bpftool, libbpf-devel, bcc-devel, bcc-tools, clang, llvm, lld |

### Block device and storage tools

| Category | Packages |
|----------|----------|
| **Partitioning** | parted, gdisk (fdisk/sfdisk/lsblk/blockdev/losetup via util-linux) |
| **LVM / RAID** | lvm2, mdadm, device-mapper-multipath, cryptsetup |
| **iSCSI / NVMe / SCSI** | iscsi-initiator-utils, nvme-cli, sg3_utils, lsscsi, sdparm, hdparm, smartmontools |
| **ublk / io_uring** | ubdsrv (ublk CLI — userspace block driver via io_uring), liburing, liburing-devel |
| **NBD** | nbd |
| **Benchmarking** | blktrace, fio, ioping |
| **Debugging** | dump (debugfs via e2fsprogs) |

### Filesystem tools

| Filesystem | Package |
|------------|---------|
| ext2/3/4 | e2fsprogs |
| XFS | xfsprogs, xfsdump |
| Btrfs | btrfs-progs |
| FAT/VFAT | dosfstools |
| NTFS | ntfs-3g |
| F2FS | f2fs-tools |
| exFAT | exfatprogs |
| SquashFS | squashfs-tools |
| EROFS | erofs-utils |
| JFS | jfsutils |

### Rust development

| Component | Details |
|-----------|---------|
| **Toolchain** | rustup (stable), rust-src, rust-analyzer, clippy, rustfmt |
| **Cross targets** | x86_64-unknown-linux-musl, aarch64-unknown-linux-musl |
| **Musl support** | musl-gcc, musl-libc-static |
| **Cargo tools** | cargo-watch, cargo-expand, cargo-audit, cargo-fuzz, sccache |

### Go development

| Component | Details |
|-----------|---------|
| **Toolchain** | golang, golang-misc |
| **Tools** | gopls, delve (dlv), staticcheck, golangci-lint |

### C/C++ build tools

gcc, g++, clang, llvm, lld, make, cmake, ninja-build, meson, autoconf, automake, libtool, pkgconf, ccache

### Git and GitHub

git, git-lfs, git-email, gh (GitHub CLI), tig

### Networking and debugging

curl, wget, jq, yq, bind-utils, iputils, iproute, nmap-ncat, socat, tcpdump, wireshark-cli, openssh-clients, rsync

### Editors and terminal

vim-enhanced, neovim, tmux, ripgrep, fd-find, bat, fzf, htop, tree, zsh, ShellCheck, diffutils, patch

### Container and packaging

podman, buildah, skopeo, rpm-build, rpm-devel, rpmlint, fedpkg, mock

### Python extras

b4 (kernel patch management), codespell

## Building

### Project structure

```
rawhidedev/
├── Containerfile          # Fedora Rawhide image
├── Containerfile.stable   # Fedora Stable image (identical tooling)
├── build-rawhide.sh       # Build + push rawhidedev (mkube job script)
├── build-stable.sh        # Build + push fedoradev (mkube job script)
├── build.sh               # Build both images locally (buildah)
├── build-and-push.sh      # Build + push both sequentially (buildah)
├── push.sh                # Push pre-built images to registry
├── CHANGELOG.md
├── README.md
└── .gitignore
```

### Build via mkube jobs (recommended)

Submit two parallel build jobs to mkube's job scheduler. Each job clones the repo on a bare metal host, builds one container image using `buildah`, and pushes it to the registry.

**Submit both builds in parallel:**

```bash
# Rawhide build
curl -s -X POST 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs' \
  -H 'Content-Type: application/json' --data-binary @- <<'EOF'
{"apiVersion":"v1","kind":"Job","metadata":{"name":"build-rawhide","namespace":"default"},"spec":{"pool":"build","priority":10,"repo":"https://github.com/glennswest/rawhidedev","buildScript":"build-rawhide.sh","buildImage":"registry.fedoraproject.org/fedora:rawhide","timeout":7200}}
EOF

# Stable build
curl -s -X POST 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs' \
  -H 'Content-Type: application/json' --data-binary @- <<'EOF'
{"apiVersion":"v1","kind":"Job","metadata":{"name":"build-stable","namespace":"default"},"spec":{"pool":"build","priority":10,"repo":"https://github.com/glennswest/rawhidedev","buildScript":"build-stable.sh","buildImage":"registry.fedoraproject.org/fedora:latest","timeout":7200}}
EOF
```

| Job | Script | Build Image | Output |
|-----|--------|-------------|--------|
| `build-rawhide` | `build-rawhide.sh` | `fedora:rawhide` | `registry.gt.lo:5000/rawhidedev:latest` |
| `build-stable` | `build-stable.sh` | `fedora:latest` | `registry.gt.lo:5000/fedoradev:latest` |

**Monitor the builds:**

```bash
# All jobs
mk get jobs -n default

# Individual job status
curl -s 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs/build-rawhide' | python3 -m json.tool
curl -s 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs/build-stable' | python3 -m json.tool

# Logs
curl -s 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs/build-rawhide/logs'
curl -s 'http://192.168.200.2:8082/api/v1/namespaces/default/jobs/build-stable/logs'
```

**Cleanup after completion:**

```bash
mk delete job build-rawhide -n default
mk delete job build-stable -n default
```

### Build locally (alternative)

If building on a local Linux host with `buildah` installed:

```bash
# Build both images
./build.sh

# Build + push to registry
./build-and-push.sh

# Push only (images must already be built)
./push.sh
```

### Containerfile structure

Layered `RUN` steps maximize build cache reuse:

1. Core build tools, kernel development packages, driver subsystem `-devel` headers, debugging/tracing, BPF tooling
2. Block device tools, filesystem formatters, storage utilities, ublk/io_uring
3. Rust toolchain via rustup + cargo tools
4. Musl cross-compile support
5. Go toolchain + Go tools
6. Git/GitHub, networking, editors, containers/packaging, Python extras
7. Workspace setup and git config defaults

## Usage

### Pull from registry

```bash
# Rawhide
podman pull --tls-verify=false registry.gt.lo:5000/rawhidedev:latest

# Stable
podman pull --tls-verify=false registry.gt.lo:5000/fedoradev:latest
```

### Run

```bash
# Interactive shell
podman run -it --rm rawhidedev

# Mount a project directory
podman run -it --rm -v ~/projects:/workspace rawhidedev

# With git identity
podman run -it --rm \
  -e GIT_AUTHOR_NAME="Your Name" \
  -e GIT_AUTHOR_EMAIL="you@example.com" \
  -e GIT_COMMITTER_NAME="Your Name" \
  -e GIT_COMMITTER_EMAIL="you@example.com" \
  -v ~/projects:/workspace \
  rawhidedev

# For kernel development (needs /dev access)
podman run -it --rm --privileged \
  -v /lib/modules:/lib/modules:ro \
  -v ~/projects:/workspace \
  rawhidedev
```

### Mount your dotfiles

```bash
podman run -it --rm \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v ~/.ssh:/root/.ssh:ro \
  -v ~/projects:/workspace \
  rawhidedev
```

### Rebuild locally

```bash
# Rawhide
podman build -t rawhidedev -f Containerfile .

# Stable
podman build -t fedoradev -f Containerfile.stable .
```

## Commit history

```
71b3674 feat: initial Fedora Rawhide development container
e0cabcf feat: add comprehensive kernel/driver development headers and tools
d0a6118 feat: add block device, filesystem, and formatting tools
1977c2e feat: add ublk and io_uring tools
166e194 fix: remove glibc-headers-x86, not available in rawhide
54578ea fix: remove packages unavailable or duplicated in rawhide
ff1416d chore: log initial build and registry push
4734d6e feat: add Containerfile.stable for latest stable Fedora
7391a2d chore: build and push fedoradev stable image to registry
```
