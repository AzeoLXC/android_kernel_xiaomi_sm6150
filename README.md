# Azeo Kernel for Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)

[![Build Kernel](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml/badge.svg)](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/actions/workflows/build_kernel.yml)
[![KernelSU Next](https://img.shields.io/badge/KernelSU%20Next-Integrated-green.svg?style=flat-square&logo=android)](https://github.com/rifsxd/KernelSU-Next)
[![Compiler](https://img.shields.io/badge/Compiler-AOSP%20Clang%2018-blue.svg?style=flat-square)](https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/)
[![License: GPL-2.0](https://img.shields.io/badge/License-GPL--2.0-yellow.svg?style=flat-square)](LICENSE)

A custom, high-performance, and battery-efficient Linux kernel engineered specifically for the **Redmi Note 10 Pro / Pro Max (`sweet` / `sweetin`)**. Built with native **KernelSU Next** integration, modern AOSP Clang toolchains, and optimized for seamless daily usage.

---

## ⚡ Key Highlights & Features

- 🛡️ **Native KernelSU Next Integration:** Root privileges managed directly inside the kernel without altering the boot partition. Undetectable by banking applications and passes Play Integrity seamlessly.
- 🚀 **Performance & Daily Efficiency:**
  - Tuned CPU Energy Model and Schedutil governor optimization for balanced battery backup and stutter-free UI.
  - BBR / Westwood TCP Congestion Control enabled for ultra-low latency networking.
- 🛠️ **Automated Cloud CI/CD:** Fully compiled and packaged via GitHub Actions using Google's official AOSP Clang toolchain and AnyKernel3 flashable zip packaging.
- 🔒 **SELinux & Security:** Full SELinux Enforcing compliance with no compromises on device security policies.

---

## 📱 Device Specifications & Compatibility

| Specification | Details |
|---|---|
| **Device Model** | Redmi Note 10 Pro / Redmi Note 10 Pro Max |
| **Codenames** | `sweet`, `sweetin` |
| **SoC Platform** | Qualcomm Snapdragon 732G (SM6150) |
| **Linux Kernel Base** | `4.14.x` (CAF LTS / LineageOS Base) |
| **Target Android Versions** | Android 14 (U), Android 15 (V), Android 16 |

---

## 📦 Releases & Downloads

Pre-built flashable zip packages are automatically published on every GitHub release.

👉 **[Download Latest Azeo Kernel Releases](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases)**

---

## 📥 Installation Instructions

### Prerequisites:
- Unlocked Bootloader.
- Custom Recovery installed (**TWRP**, **OrangeFox**, or **AOSP Recovery**).

### Flashing via Custom Recovery:
1. Download the latest `AzeoKernel-sweet-*.zip` from the [Releases](https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150/releases) tab.
2. Reboot your device into **Recovery Mode**.
3. *(Optional but recommended)* Create a Nandroid backup of your current `Boot` and `DTBO` partitions.
4. Navigate to **Install** -> Select `AzeoKernel-sweet-*.zip` -> **Swipe to Flash**.
5. Reboot to System.
6. Install the official **[KernelSU Next Manager APK](https://github.com/rifsxd/KernelSU-Next/releases)** to manage root permissions.

---

## 🏗️ Building Locally (Optional)

If you wish to compile Azeo Kernel on your own Linux machine:

```bash
# Clone the repository
git clone https://github.com/AzeoLXC/android_kernel_xiaomi_sm6150.git kernel_sweet
cd kernel_sweet

# Trigger the automated build script (fetches Clang & AnyKernel3 automatically)
bash build.sh
```

---

## 🤝 Credits & Acknowledgements

- **LineageOS Team** — Base SM6150 kernel source tree.
- **rifsxd / KernelSU-Next** — Next-generation kernel-based root solution.
- **osm0sis** — AnyKernel3 flashable zip template.
- **Google / AOSP** — Android Open Source Project Clang toolchain.

---

## 📄 License

This kernel source code is licensed under the **GNU General Public License v2.0 (GPLv2)** as mandated by the Linux kernel.
