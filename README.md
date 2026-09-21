# Azeo Kernel for Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)

[![Build & Package Kernel](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml/badge.svg)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml)
[![GitHub Release](https://img.shields.io/github/v/release/AzeoLXC/android_kernel_xiaomi_sm6150?style=flat-square&color=blue)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases)
[![License: GPL-2.0](https://img.shields.io/badge/License-GPL%20v2-orange.svg?style=flat-square)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Kernel Version](https://img.shields.io/badge/Linux-4.14.357-brightgreen?style=flat-square)](https://kernel.org)
[![Target SoC](https://img.shields.io/badge/SoC-Snapdragon%20732G%20(SM6150)-critical?style=flat-square)](https://www.qualcomm.com/)

Custom Linux kernel for **Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)**, built from the LineageOS/CAF SM6150 stable tree (`manipvlator/los_kernel_xiaomi_sm6150`). Targets AOSP-based Android 14 (U), 15 (V), and 16 (B) ROMs with integrated KernelSU, native SuSFS v2.3.0, backported CPU governors, and ZyCromerZ Clang 17 compilation.

---

## Specifications

| Parameter | Detail |
|---|---|
| Target Devices | Xiaomi Redmi Note 10 Pro / Pro Max (`sweet`, `sweetin`) |
| Platform / SoC | Qualcomm Snapdragon 732G / SM6150 (`sdmsteppe`) |
| Linux Version | 4.14.357 LTS |
| Upstream Baseline | LineageOS CAF SM6150 (`manipvlator/los_kernel_xiaomi_sm6150:stable`) |
| Target Android Versions | Android 14 (U), Android 15 (V), Android 16 (B) |
| C / C++ Compiler | ZyCromerZ Clang 17.0.0 (LLVM Integrated Assembler) |
| Cross Compilers | Greenforce GCC 64-bit (`aarch64-elf-`) and 32-bit (`arm-eabi-`) |
| Root Implementation | In-Tree KernelSU (Syscall table tampering via `CONFIG_KSU_TAMPER_SYSCALL_TABLE`) |
| Root Concealment | In-Tree SuSFS v2.3.0 Non-GKI (`CONFIG_KSU_SUSFS_*`) |
| Defconfig Target | `arch/arm64/configs/vendor/sweet_defconfig` |
| Localversion | `-AzeoKernel` (`CONFIG_LOCALVERSION_AUTO=n`) |
| Package Format | AnyKernel3 flashable zip archive |

---

## Features & Upstream Changes

### Root & Concealment
- **In-Tree KernelSU**: Uses the syscall table tampering method (`CONFIG_KSU_TAMPER_SYSCALL_TABLE=y`), avoiding kprobe overhead and CFI issues.
- **SuSFS v2.3.0 Non-GKI**: Native kernel-level isolation for paths (`CONFIG_KSU_SUSFS_SUS_PATH`), mount points (`CONFIG_KSU_SUSFS_SUS_MOUNT`), file attributes (`CONFIG_KSU_SUSFS_SUS_KSTAT`), kallsyms symbol hiding (`CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS`), and open redirection (`CONFIG_KSU_SUSFS_OPEN_REDIRECT`).
- **Manager Compatibility**: In-kernel APK signature verification supports official KernelSU, KernelSU-Next, KowSU, MamboSU, and ReSukiSU manager applications.

### CPU Governors & Scheduler
- **Reflex (v0.3.0r2)**: Backported CPUFreq governor featuring fast ramp-up, EWMA load smoothing, and trend-based load prediction adapted for 4.14 WALT scheduler APIs.
- **Vorpal (v2.2)**: Tri-cluster schedutil derivative with daily and gaming operating profiles, thermal headroom tracking, and per-cluster floors/caps.
- **NAP Optimal-Idle (v0.5.0)**: Neural network MLP idle predictor ported to arm64 with scalar-NEON arithmetic.
- **Cambyses CFS Load Balancer (v0.6.0)**: Backported `LB_ROTATE_BLOCK` and `LB_STRICT_BUDGET` optimizations for task migration under CFS.

### Thermal & Power Tuning
- **Gaming Step_Wise Thermal**: Thermal governor tuned to eliminate userspace throttling stalls during sustained gaming workloads.
- **DCVS Throttle Bypass**: `limits-dcvs` CPU throttle components stubbed to maintain target CPU frequencies without persistent throttling locks.
- **Power-Efficient Workqueue**: Uses `system_freezable_power_efficient_wq` for thermal polling (`CONFIG_WQ_POWER_EFFICIENT=y`).
- **Wi-Fi Wakelock Mitigation**: Restricts unneeded wakelocks in `qcacld-3.0` to minimize battery drain while the screen is off.
- **Audio SPI Race Fix**: Fixes a race condition in `wcd-spi` during system suspend (`-EBUSY` error).

### Peripherals & Input
- **PlayStation DualSense & DualSense Edge**: Backported HID driver support with updated rumble modes and calibration sanity checks.

### Stability & Security Fixes
- **Filesystem**: Backported upstream fixes for ext4 CVE-2025-22121 (xattr inode OOB read) and CVE-2025-37785 (dotdot directory entry check).
- **RCU & Memory**: Backported `eventpoll` RCU grace period lifetime fix to prevent use-after-free conditions.
- **Locking**: Backported self-deadlock checks for futex requeue PI (`remove_waiter`).

---

## CI/CD Pipeline

Kernel releases are compiled via GitHub Actions (`workflow_dispatch`):

```text
[ 1. Upstream Check & Sync ]
  ├── Resolve semantic versioning and upstream commit SHA
  └── Verify release tag state
              │
              ▼
[ 2. Compile & Package ]
  ├── Setup ZyCromerZ Clang 17 and GCC cross-compilers
  ├── Clone and link in-tree KernelSU (manipvlator source)
  ├── Enforce -AzeoKernel localversion and SuSFS configs
  ├── Compile Image.gz, dtbo.img, and dtb.img
  └── Package AnyKernel3 flashable zip with SHA-256 checksum
              │
              ▼
[ 3. Release & State Sync ]
  ├── Publish GitHub Release with assets and notes
  └── Update last processed upstream commit SHA
```

---

## Installation

### Prerequisites
- Unlocked bootloader.
- Custom recovery installed (TWRP, OrangeFox, or Lineage Recovery).
- Optional backup of existing `boot` and `dtbo` partitions.

### Flashing Steps
1. Download `AzeoKernel-sweet-<version>.zip` and `.sha256` from [Releases](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases).
2. Verify checksum:
   ```bash
   sha256sum -c AzeoKernel-sweet-*.zip.sha256
   ```
3. Reboot to custom recovery:
   ```bash
   adb reboot recovery
   ```
4. Flash the zip file directly (do not wipe system or data partitions).
5. Reboot to system.
6. Install [KernelSU Manager](https://github.com/tiann/KernelSU/releases) or [KernelSU-Next Manager](https://github.com/KernelSU-Next/KernelSU-Next/releases).

---

## Credits & Upstream

- [LineageOS](https://github.com/LineageOS) — Android SM6150 kernel tree base.
- [manipvlator](https://github.com/manipvlator) — SM6150 kernel tree maintenance, SuSFS v2.3.0 backport, and KernelSU integration.
- [KernelSU](https://github.com/tiann/KernelSU) — Kernel root framework.
- [SuSFS](https://gitlab.com/simonpunk/susfs4ksu) — Kernel-level root concealment.
- [firelzrd](https://github.com/firelzrd) — Reflex, Vorpal, NAP, and Cambyses governor implementations.
- [ZyCromerZ](https://github.com/ZyCromerZ) — Clang toolchain builds.
- [osm0sis](https://github.com/osm0sis) — AnyKernel3 packaging framework.

---

## License

Distributed under the [GNU General Public License v2.0 (GPL-2.0)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).