# rawhidedev

Fedora Rawhide development container with tooling for kernel, Rust, Go, and general development.

## What's included

| Category | Tools |
|----------|-------|
| **Kernel dev** | kernel-devel, kernel-headers, elfutils, dwarves, sparse, bc, bison, flex, ncurses-devel, perf, strace, crash, bpftool, libbpf, dtc |
| **Rust** | rustup (stable), rust-analyzer, clippy, rustfmt, musl targets (x86_64 + aarch64), cargo-watch, cargo-expand, cargo-audit, cargo-fuzz, sccache |
| **Go** | golang, gopls, delve, staticcheck, golangci-lint |
| **C/C++** | gcc, g++, clang, llvm, lld, cmake, ninja, meson, autoconf, automake, ccache |
| **BPF/eBPF** | bpftool, libbpf-devel, clang, llvm |
| **Git/GitHub** | git, git-lfs, git-email, gh (GitHub CLI), tig |
| **Containers** | podman, buildah, skopeo |
| **RPM packaging** | rpm-build, rpmlint, fedpkg, mock |
| **Editors** | vim, neovim |
| **Terminal** | tmux, ripgrep, fd, bat, fzf, htop, zsh, ShellCheck |
| **Network** | curl, wget, jq, yq, ncat, socat, tcpdump, tshark |
| **Kernel mail** | b4, git-email |

## Build

```bash
podman build -t rawhidedev .
```

## Run

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

## Customization

Mount your own dotfiles or config:

```bash
podman run -it --rm \
  -v ~/.gitconfig:/root/.gitconfig:ro \
  -v ~/.ssh:/root/.ssh:ro \
  -v ~/projects:/workspace \
  rawhidedev
```
