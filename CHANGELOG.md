# Changelog

## [Unreleased]

### 2026-03-19
- **feat:** Initial Containerfile — Fedora Rawhide dev container with kernel, Rust, Go, and general dev tooling
- **feat:** Full kernel/driver development headers — PCI, USB, DRM/GPU, block/storage, network, RDMA, ALSA, I2C/SPI/GPIO, NUMA, ACPI, io_uring, device-mapper, netfilter
- **feat:** Kernel tooling additions — coccinelle, trace-cmd, kernelshark, bcc-tools, cscope, ctags, kmod-devel, nvme-cli, ethtool
- **feat:** Block device and filesystem tools — parted, gdisk, fdisk, lvm2, mdadm, cryptsetup, multipath, iSCSI, NVMe, SCSI, smartmontools, blktrace, fio, ioping, nbd
- **feat:** ublk and io_uring tools — ubdsrv (ublk userspace block driver), liburing + liburing-devel
- **feat:** Filesystem formatting — e2fsprogs, xfsprogs, btrfs-progs, dosfstools, ntfs-3g, f2fs-tools, exfatprogs, squashfs-tools, erofs-utils, jfsutils
- **chore:** Built and pushed image to registry.gt.lo:5000/rawhidedev:latest (8.29 GB)
- **feat:** Containerfile.stable — same tooling based on fedora:latest (stable)
- **chore:** Built and pushed image to registry.gt.lo:5000/fedoradev:latest (8.25 GB)
- **docs:** README with build/run instructions
