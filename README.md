# Azeo Kernel for Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)

[![Build & Package Kernel](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml/badge.svg)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml)
[![GitHub Release](https://img.shields.io/github/v/release/AzeoLXC/android_kernel_xiaomi_sm6150?style=flat-square&color=blue)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases)
[![License: GPL-2.0](https://img.shields.io/badge/License-GPL%20v2-orange.svg?style=flat-square)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Kernel Version](https://img.shields.io/badge/Linux-4.14.x%20LTS-brightgreen?style=flat-square)](https://kernel.org)
[![Target SoC](https://img.shields.io/badge/SoC-Snapdragon%20732G%20(SM6150)-critical?style=flat-square)](https://www.qualcomm.com/)

High-performance, security-hardened Linux kernel built for **Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)**. Tailored for AOSP/CAF-based Android 14 (U), 15 (V), and 16 ROMs, featuring in-tree **KernelSU-Next**, full **SusFS (v2.2.0 Non-GKI)** integration, and compiler toolchain optimizations.

---

## Technical Specifications

| Component | Detail |
|---|---|
| **Target Device** | Xiaomi Redmi Note 10 Pro / Pro Max |
| **Device Codenames** | `sweet`, `sweetin` |
| **SoC Platform** | Qualcomm Snapdragon 732G (SM6150 / `sdmsteppe`) |
| **Kernel Base** | Linux 4.14.x LTS (LineageOS / CAF SM6150 stable tree) |
| **Android Compatibility** | Android 14 (U), Android 15 (V), Android 16 |
| **C Compiler** | ZyCromerZ Clang 17.0.0 (LLVM IAS enabled) |
| **Cross Compilers** | Greenforce GCC 64-bit (`aarch64-elf-`) & 32-bit (`arm-eabi-`) |
| **Root Solution** | In-Tree KernelSU-Next (Syscall backend) |
| **Concealment Engine**| SusFS v2.2.0 Non-GKI (`CONFIG_KSU_SUSFS_*`) |
| **Release Artifact** | AnyKernel3 flashable archive + SHA-256 checksum |

---

## Key Features & Architecture

### 1. In-Tree KernelSU-Next (Syscall Mode)
- Native syscall interception layer via `drivers/kernelsu`.
- Grants kernel-level root access without modifying `boot.img` ramdisk partitions.
- Zero footprint on stock AOSP init scripts and partition signatures.

### 2. SusFS v2.2.0 (Non-GKI Anti-Detection)
Configured with full kernel-space concealment flags:
- `CONFIG_KSU_SUSFS_SUS_PATH` & `CONFIG_KSU_SUSFS_SUS_MOUNT`: Hides overlay mounts, root paths, and KSU mount points from user-space scanner scans.
- `CONFIG_KSU_SUSFS_SUS_KSTAT`: Spoofs kernel file status hooks.
- `CONFIG_KSU_SUSFS_SPOOF_UNAME`: Masks kernel identification signatures.
- `CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS`: Eradicates symbol table leaks in `/proc/kallsyms`.
- Passes advanced hardware-backed and software integrity checks (Play Integrity, banking apps, Knox-style detections) when paired with modern managers.

### 3. Kbuild & Defconfig Integration
- Merges `vendor/sweet_defconfig` with `vendor/droidspaces_defconfig`.
- Strict override to `-AzeoKernel` localversion with `CONFIG_LOCALVERSION_AUTO` disabled to eliminate unversioned `-dirty` tags.
- Optimized schedutil CPU energy models for responsive thread migration and lower idle battery drain.

---

## CI/CD Workflow Architecture

Kernel builds and packaging are executed on-demand via GitHub Actions (`workflow_dispatch`):

```text
[ Trigger: Manual Workflow Dispatch ]
                  │
                  ▼
    [ Setup Build Environment ]       ── Ubuntu Latest + Dependencies
                  │
                  ▼
    [ Toolchain Provisioning ]        ── ZyCromerZ Clang 17 + GCC64 / GCC32
                  │
                  ▼
    [ Source & Patches Setup ]        ── Ingest KernelSU-Next & SusFS
                  │
                  ▼
    [ Defconfig Merge & Build ]       ── vendor/sweet_defconfig + droidspaces
                  │
                  ▼
    [ AnyKernel3 Zip Packaging ]      ── Image.gz, dtbo.img, dtb.img
                  │
                  ▼
    [ SHA-256 Sum & Release ]         ── Publish GitHub Release Asset
```

- **Manual Trigger Only:** Eliminates unintended builds from commits or push events.
- **Dynamic Tagging:** Automatic semantic release bumping (`vMAJOR.MINOR.PATCH-YYYY.MM.DD`).

---

## Installation Guide

### Prerequisites
- Bootloader unlocked.
- Custom Recovery installed (TWRP, OrangeFox, or LineageOS Recovery).
- Clean backup of existing `boot` and `dtbo` partitions.

### Recovery Flashing Procedure
1. Download the latest `AzeoKernel-sweet-*.zip` from the [Releases Page](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases).
2. Verify archive integrity using the accompanying `.sha256` checksum file:
   ```bash
   sha256sum -c AzeoKernel-sweet-*.zip.sha256
   ```
3. Reboot to Recovery:
   ```bash
   adb reboot recovery
   ```
4. In recovery: **Install** -> Select `AzeoKernel-sweet-*.zip` -> **Swipe to Flash**.
5. Wipe Dalvik/Cache and **Reboot to System**.
6. Install [KernelSU-Next Manager APK](https://github.com/rifsxd/KernelSU-Next/releases) (`v1.0.5` or later) to manage superuser access and SusFS modules.

---

## Local Compilation

To build Azeo Kernel manually on Linux (Debian/Ubuntu x86_64):

```bash
# 1. Install dependencies
sudo apt-get update && sudo apt-get install -y \
  bc bison build-essential ca-certificates cpio curl flex git \
  libssl-dev make python3 libelf-dev zlib1g-dev libncurses5-dev lz4

# 2. Clone repository & toolchain
git clone https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150.git -b main kernel_src
cd kernel_src

# 3. Export build environment variables
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Azeo"
export KBUILD_BUILD_HOST="AzeoLab"

# 4. Generate defconfig
make O=out ARCH=arm64 vendor/sweet_defconfig
scripts/kconfig/merge_config.sh -O out \
  arch/arm64/configs/vendor/sweet_defconfig \
  arch/arm64/configs/vendor/droidspaces_defconfig

# 5. Compile kernel image
make -j$(nproc --all) O=out ARCH=arm64 \
  LLVM=1 \
  LLVM_IAS=1 \
  CC=clang
```

Output image: `out/arch/arm64/boot/Image.gz`

---

## Upstream References & Credits

- [LineageOS SM6150 Tree](https://github.com/LineageOS) — Upstream base kernel source.
- [manipvlator](https://github.com/manipvlator) — SM6150 stable maintenance and device configurations.
- [KernelSU-Next](https://github.com/rifsxd/KernelSU-Next) — Next-generation kernel-level root solution.
- [SusFS](https://gitlab.com/simonpunk/susfs4ksu) — Kernel-level root-hiding and mount concealment engine.
- [ZyCromerZ](https://github.com/ZyCromerZ) — Optimized AOSP Clang toolchain builds.
- [osm0sis](https://github.com/osm0sis) — AnyKernel3 flashable packaging template.

---

## License

This project is licensed under the [GNU General Public License v2.0 (GPLv2)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).
