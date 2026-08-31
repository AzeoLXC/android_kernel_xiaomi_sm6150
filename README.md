# Azeo Kernel for Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)

[![Build & Package Kernel](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml/badge.svg)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml)
[![GitHub Release](https://img.shields.io/github/v/release/AzeoLXC/android_kernel_xiaomi_sm6150?style=flat-square&color=blue)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases)
[![License: GPL-2.0](https://img.shields.io/badge/License-GPL%20v2-orange.svg?style=flat-square)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![Kernel Version](https://img.shields.io/badge/Linux-4.14.x%20LTS-brightgreen?style=flat-square)](https://kernel.org)
[![Target SoC](https://img.shields.io/badge/SoC-Snapdragon%20732G%20(SM6150)-critical?style=flat-square)](https://www.qualcomm.com/)

Custom Linux kernel for **Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)**, built from the LineageOS/CAF SM6150 stable tree. Designed for AOSP-based Android 14, 15, and 16 custom ROMs with in-tree KernelSU-Next, SusFS non-GKI hooks, and ZyCromerZ Clang 17 compilation.

---

## Technical Specifications

| Parameter | Specification |
|---|---|
| Target Devices | Xiaomi Redmi Note 10 Pro / Pro Max (`sweet`, `sweetin`) |
| Platform / SoC | Qualcomm Snapdragon 732G / SM6150 (`sdmsteppe`) |
| Base Tree | Linux 4.14.x LTS (LineageOS / CAF SM6150 stable) |
| Target OS | Android 14 (U), Android 15 (V), Android 16 (B) |
| C / C++ Compiler | ZyCromerZ Clang 17.0.0 (LLVM Integrated Assembler) |
| Cross Toolchains | Greenforce GCC 64-bit (`aarch64-elf-`) and 32-bit (`arm-eabi-`) |
| Root Implementation | In-Tree KernelSU-Next (Syscall backend) |
| Concealment Engine | SusFS v2.2.0 Non-GKI (`CONFIG_KSU_SUSFS_*`) |
| Package Format | AnyKernel3 flashable zip archive |

---

## Configuration & Feature Details

### 1. In-Tree KernelSU-Next (Syscall Mode)
- Native syscall interception via `drivers/kernelsu`.
- Grants kernel-space root control without patching boot image ramdisks.
- Leaves stock init scripts and AVB status untouched.

### 2. SusFS v2.2.0 (Non-GKI Concealment)
Configured with in-kernel anti-detection mechanisms:
- Path and mount concealment (`CONFIG_KSU_SUSFS_SUS_PATH`, `CONFIG_KSU_SUSFS_SUS_MOUNT`) to isolate root paths and mount points from userspace detection.
- Kernel file attribute hooks (`CONFIG_KSU_SUSFS_SUS_KSTAT`) and identification masking (`CONFIG_KSU_SUSFS_SPOOF_UNAME`).
- Symbol table pruning (`CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS`) to eliminate detection via `/proc/kallsyms`.
- Open redirection and bootconfig spoofing support.

### 3. Build & Kconfig Adjustments
- Defconfig target: `arch/arm64/configs/vendor/sweet_defconfig`.
- Localversion hardcoded to `-AzeoKernel` with `CONFIG_LOCALVERSION_AUTO` disabled to prevent unversioned `-dirty` tags.
- Schedutil energy-model tuning for steady active state performance and minimal idle drain.

---

## CI/CD Pipeline

Builds are executed via GitHub Actions (`workflow_dispatch`):

```text
[ Trigger: workflow_dispatch ]
              │
              ▼
[ Setup Build Environment & Dependencies ]
              │
              ▼
[ Fetch ZyCromerZ Clang 17 & GCC Toolchains ]
              │
              ▼
[ Clone SM6150 Source & Ingest KernelSU-Next Syscall ]
              │
              ▼
[ Generate vendor/sweet_defconfig & Apply Kconfig Flags ]
              │
              ▼
[ Compile Kernel (Image.gz, dtbo.img, dtb.img) ]
              │
              ▼
[ Package AnyKernel3 Zip, Compute SHA-256 & Publish Release ]
```

---

## Installation

### Requirements
- Unlocked bootloader.
- Custom Recovery (TWRP, OrangeFox, or Lineage Recovery).
- Optional backup of existing `boot` and `dtbo` partitions.

### Steps
1. Download `AzeoKernel-sweet-<version>.zip` and `.sha256` from [Releases](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases).
2. Verify integrity:
   ```bash
   sha256sum -c AzeoKernel-sweet-*.zip.sha256
   ```
3. Reboot device into custom recovery:
   ```bash
   adb reboot recovery
   ```
4. Flash the zip file directly (do not wipe partitions beforehand).
5. Reboot to system.
6. Install [KernelSU-Next Manager](https://github.com/rifsxd/KernelSU-Next/releases) to manage root permissions and SusFS modules.

---

## Credits & Upstream Projects

- [LineageOS SM6150 Tree](https://github.com/LineageOS) — Kernel tree baseline.
- [manipvlator](https://github.com/manipvlator) — SM6150 source maintenance and device configuration.
- [KernelSU-Next](https://github.com/rifsxd/KernelSU-Next) — Kernel root solution.
- [SusFS](https://gitlab.com/simonpunk/susfs4ksu) — Kernel-level root concealment implementation.
- [ZyCromerZ](https://github.com/ZyCromerZ) — Clang toolchain builds.
- [osm0sis](https://github.com/osm0sis) — AnyKernel3 packaging engine.

---

## License

Licensed under the [GNU General Public License v2.0 (GPL-2.0)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).
