# Azeo Kernel (Redmi Note 10 Pro / Pro Max)

[![Build & Package Kernel](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml/badge.svg)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml)

Custom Linux kernel distribution compiled for the **Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)**. Built with native **KernelSU Next** integration, high-precision compiler optimizations, and tailored specifically for balanced daily performance.

---

## Technical Specifications

| Parameter | Specification |
|---|---|
| Target Device | Redmi Note 10 Pro / Pro Max |
| Device Codenames | `sweet`, `sweetin` |
| Platform SoC | Qualcomm Snapdragon 732G (SM6150) |
| Kernel Version | Linux 4.14.x LTS (CAF SM6150 Base) |
| Supported Android Versions | Android 14 (U), Android 15 (V), Android 16 |
| Compiler Toolchain | Neutron Clang (LLVM) + Greenforce GCC (ARM64 & ARM32) |
| Packaging Format | AnyKernel3 Flashable ZIP |

---

## Architectural Modifications & Feature Set

Azeo Kernel integrates deliberate modifications over the standard OEM and upstream source trees to improve security, responsiveness, and root management:

1. **KernelSU Next Integration (In-Tree Syscall Hooks)**
   - Integrated directly into the kernel source tree (`drivers/kernelsu`).
   - Grants kernel-level root access without modifying the ramdisk or `boot.img` partition.
   - Bypasses root-detection mechanisms (Play Integrity / Banking apps) out of the box.

2. **Compiler & Optimization Flags**
   - Compiled using **Neutron Clang** with LLVM Integrated Assembler (`LLVM_IAS=1`).
   - Linked with Greenforce GCC cross-compilers (`aarch64-elf-` and `arm-eabi-`).
   - Glitched glibc headers patched via automated build environment configuration.

3. **Energy Model & Performance Tuning**
   - Configured with `vendor/sweet_defconfig` tailored for Snapdragon 732G.
   - Schedutil CPU energy model tuned for responsive UI thread scheduling while reducing active battery drain during background tasks.

---

## Downloads

Official flashable zip packages and SHA-256 checksums are published on every GitHub release.

* **Releases Page:** [https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases)

---

## Installation Guide

### Prerequisites
- Bootloader unlocked.
- Custom Recovery installed (TWRP, OrangeFox, or Lineage Recovery).

### Flashing Procedure
1. Download the latest `AzeoKernel-sweet-*.zip` release asset.
2. Reboot device into **Recovery Mode**.
3. *(Recommended)* Create a backup of existing `Boot` and `DTBO` partitions.
4. Navigate to **Install** -> Select the downloaded `.zip` file -> **Confirm Flash**.
5. Reboot to System.
6. Install the official **KernelSU Next Manager APK** to configure root permissions.

---

## Automated CI/CD Workflow

Kernel builds and packaging are fully automated via GitHub Actions:

```
[ Git Push / Manual Dispatch ]
              │
              ▼
   Setup Build Environment     ── Ubuntu Latest + Build Dependencies
              │
              ▼
   Fetch Toolchains            ── Neutron Clang + GCC64 / GCC32
              │
              ▼
   Clone Source Tree           ── SM6150 23.2 CAF Base
              │
              ▼
   Kernel Compilation          ── make vendor/sweet_defconfig
              │
              ▼
   AnyKernel3 Packaging        ── Generate Image.gz, dtbo.img, dtb.img
              │
              ▼
   Publish GitHub Release      ── Export Flashable ZIP + SHA-256 Checksum
```

---

## Credits & Upstream Sources

- **LineageOS** — Base SM6150 kernel tree.
- **manipvlator** — KernelSU integration and SM6150 device configuration tree.
- **rifsxd / KernelSU-Next** — Next-generation kernel root solution.
- **Neutron Toolchains** — Clang compiler distribution.
- **osm0sis** — AnyKernel3 packaging template.

---

## License

This project is open-source and licensed under the **GNU General Public License v2.0 (GPLv2)**.
