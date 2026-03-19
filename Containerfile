# Fedora Rawhide Development Container
# Kernel, Rust, Go, and general development tooling
FROM registry.fedoraproject.org/fedora:rawhide

LABEL maintainer="gwest"
LABEL description="Fedora Rawhide development container — kernel, Rust, Go, and general dev tools"

# Avoid interactive prompts
ENV LANG=C.UTF-8
ENV TERM=xterm-256color

# ── Core build tools & kernel development ────────────────────────────────
RUN dnf -y update && dnf -y install \
    # Essential build tools
    @development-tools \
    @c-development \
    make \
    cmake \
    ninja-build \
    meson \
    autoconf \
    automake \
    libtool \
    pkgconf \
    ccache \
    # Kernel development — core
    kernel-devel \
    kernel-headers \
    kernel-modules \
    kernel-modules-extra \
    glibc-devel \
    glibc-headers-x86 \
    elfutils-libelf-devel \
    elfutils-devel \
    openssl-devel \
    dwarves \
    sparse \
    coccinelle \
    bc \
    bison \
    flex \
    ncurses-devel \
    perl \
    perl-devel \
    python3 \
    python3-pip \
    python3-devel \
    # Kernel source navigation
    cscope \
    ctags \
    # Kernel module management
    kmod \
    kmod-devel \
    # Device driver subsystem headers
    pciutils \
    pciutils-devel \
    usbutils \
    libusb1-devel \
    libpcap-devel \
    libdrm-devel \
    mesa-libGL-devel \
    mesa-libEGL-devel \
    libinput-devel \
    libevdev-devel \
    libudev-devel \
    systemd-devel \
    # Block/storage driver headers
    lvm2-devel \
    device-mapper-devel \
    libblkid-devel \
    libaio-devel \
    liburing-devel \
    sg3_utils-devel \
    nvme-cli \
    # Network driver headers
    libmnl-devel \
    libnl3-devel \
    libnfnetlink-devel \
    libnetfilter_conntrack-devel \
    ethtool \
    iw \
    wireless-regdb \
    # RDMA / InfiniBand
    rdma-core-devel \
    libibverbs-devel \
    # NUMA
    numactl-devel \
    # Sound/ALSA driver headers
    alsa-lib-devel \
    # Crypto
    libgcrypt-devel \
    nss-devel \
    # Firmware / ACPI
    acpica-tools \
    # I2C / SPI / GPIO (embedded/driver dev)
    i2c-tools \
    # Kernel debugging & tracing
    perf \
    strace \
    ltrace \
    systemtap \
    systemtap-devel \
    crash \
    trace-cmd \
    kernelshark \
    # BPF/eBPF tooling
    bpftool \
    libbpf-devel \
    bcc-devel \
    bcc-tools \
    clang \
    llvm \
    lld \
    # Device tree (for ARM kernel work)
    dtc \
    # Firmware tools
    pesign \
    # Kernel doc build
    python3-sphinx \
    graphviz \
    ImageMagick \
    texinfo \
    && dnf clean all

# ── Rust development ─────────────────────────────────────────────────────
# Install via rustup for latest toolchain + cross-compile targets
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH="/usr/local/cargo/bin:${PATH}"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain stable --profile default && \
    rustup component add rust-src rust-analyzer clippy rustfmt && \
    rustup target add x86_64-unknown-linux-musl aarch64-unknown-linux-musl && \
    # Install common cargo tools
    cargo install cargo-watch cargo-expand cargo-audit cargo-fuzz sccache && \
    rm -rf /usr/local/cargo/registry/cache

# Musl cross-compile support
RUN dnf -y install musl-gcc musl-libc-static && dnf clean all

# ── Go development ───────────────────────────────────────────────────────
RUN dnf -y install golang golang-misc && dnf clean all

ENV GOPATH=/go
ENV PATH="${GOPATH}/bin:/usr/local/go/bin:${PATH}"
RUN mkdir -p "${GOPATH}/src" "${GOPATH}/bin" "${GOPATH}/pkg"

# Common Go tools
RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest && \
    rm -rf /root/.cache/go-build /tmp/*

# ── Git & GitHub ─────────────────────────────────────────────────────────
RUN dnf -y install \
    git \
    git-lfs \
    git-email \
    gh \
    tig \
    && dnf clean all

# ── Networking & debugging tools ─────────────────────────────────────────
RUN dnf -y install \
    curl \
    wget \
    jq \
    yq \
    bind-utils \
    iputils \
    iproute \
    nmap-ncat \
    socat \
    tcpdump \
    wireshark-cli \
    openssh-clients \
    rsync \
    && dnf clean all

# ── Editors & terminal utilities ─────────────────────────────────────────
RUN dnf -y install \
    vim-enhanced \
    neovim \
    tmux \
    ripgrep \
    fd-find \
    bat \
    fzf \
    htop \
    tree \
    zsh \
    ShellCheck \
    diffutils \
    patch \
    && dnf clean all

# ── Container & packaging tools ──────────────────────────────────────────
RUN dnf -y install \
    podman \
    buildah \
    skopeo \
    rpm-build \
    rpm-devel \
    rpmlint \
    fedpkg \
    mock \
    && dnf clean all

# ── Python extras for kernel/dev scripting ───────────────────────────────
RUN pip3 install --no-cache-dir \
    b4 \
    codespell

# ── Default workspace ───────────────────────────────────────────────────
RUN mkdir -p /workspace
WORKDIR /workspace

# Git config defaults (override at runtime with -e or volume mount)
RUN git config --system init.defaultBranch main && \
    git config --system pull.rebase true && \
    git config --system core.autocrlf input

CMD ["/bin/bash"]
