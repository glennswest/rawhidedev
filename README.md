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

## How it was built

### Project structure

```
rawhidedev/
├── Containerfile          # Fedora Rawhide image
├── Containerfile.stable   # Fedora Stable image (identical tooling)
├── CHANGELOG.md
├── README.md
└── .gitignore
```

### Build process

Both images were built locally on macOS (ARM64) using `podman`, which cross-builds for linux/aarch64 via QEMU emulation.

**Rawhide build:**

```bash
podman build -t rawhidedev -f Containerfile .
```

**Stable build:**

```bash
podman build -t fedoradev -f Containerfile.stable .
```

The Containerfile is structured as layered `RUN` steps to maximize build cache reuse:

1. **Step 6** — Core build tools, kernel development packages, all driver subsystem `-devel` headers, debugging/tracing tools, BPF tooling (~966 packages, ~3 GB)
2. **Step 7** — Block device tools, filesystem formatters, storage utilities, ublk/io_uring
3. **Steps 8-10** — Rust toolchain via rustup + cargo tools (compiled from source)
4. **Step 11** — Musl cross-compile support
5. **Steps 12-14** — Go toolchain + Go tools (installed via `go install`)
6. **Steps 15-20** — Git/GitHub, networking, editors, containers/packaging, Python extras
7. **Steps 21-22** — Workspace setup and git config defaults

### Registry push

Images were tagged and pushed to the local mkube registry:

```bash
# Rawhide
podman tag rawhidedev registry.gt.lo:5000/rawhidedev:latest
podman push --tls-verify=false registry.gt.lo:5000/rawhidedev:latest

# Stable
podman tag fedoradev registry.gt.lo:5000/fedoradev:latest
podman push --tls-verify=false registry.gt.lo:5000/fedoradev:latest
```

`--tls-verify=false` is needed because the mkube registry at `192.168.200.3:5000` uses a self-signed CA.

### Build fixes applied during iteration

- Removed `glibc-headers-x86` (not available in Rawhide — headers are included in `glibc-devel`)
- Removed `dmraid` (not packaged in Rawhide)
- Removed `ntfsprogs` (merged into `ntfs-3g`)
- Deduplicated packages already installed in earlier layers (util-linux, lvm2, nvme-cli, liburing, liburing-devel)
- Removed standalone `debugfs` (provided by e2fsprogs)

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
