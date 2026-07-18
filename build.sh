#!/usr/bin/env bash
# Local build script for Azeo Kernel (Redmi Note 10 Pro - sweet)

set -e

echo "=== Azeo Kernel Local Build Environment ==="
echo "Target: Redmi Note 10 Pro (sweet)"
echo "Toolchain: AOSP Clang 18"
echo "KernelSU: Integrated"

# Check dependencies
for tool in make clang git zip bc bison flex; do
    if ! command -v "$tool" &>/dev/null; then
        echo "Missing required dependency: $tool. Please install it first."
    fi
done

echo "Ready. To compile in cloud, push your changes to GitHub Actions."
