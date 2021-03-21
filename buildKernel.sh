#!/bin/bash

# Check if have gcc/clang folder
if [ ! -d "$(pwd)/gcc/" ]; then
   git clone --depth 1 git://github.com/PrishKernel/toolchains -b gcc-4.9 gcc
fi

if [ ! -d "$(pwd)/clang/" ]; then
   git clone --depth 1 git://github.com/PrishKernel/toolchains.git -b proton-clang12 clang
fi

# Export KBUILD flags
export KBUILD_BUILD_USER="$(whoami)"
export KBUILD_BUILD_HOST="$(uname -n)"

# Export ARCH/SUBARCH flags
export ARCH="arm64"
export SUBARCH="arm64"

# Export ANDROID VERSION
export ANDROID_MAJOR_VERSION="q"

# Export CCACHE
export CCACHE_EXEC="$(which ccache)"
export CCACHE="${CCACHE_EXEC}"
export CCACHE_COMPRESS="1"
export USE_CCACHE="1"
ccache -M 50G

# Export toolchain/cross flags
export GCC_TOOLCHAIN="aarch64-linux-android-"
export CROSS_COMPILE="$(pwd)/gcc/bin/${GCC_TOOLCHAIN}"
export CLANG_PREFIX="aarch64-linux-gnu-"
export CLANG_TRIPLE="$(pwd)/clang/bin/${CLANG_PREFIX}"
export CC="$(pwd)/clang/bin/clang"

# Export if/else outdir var
export OUT="$(pwd)/out"
export WITH_OUTDIR=true

# Clear the console
clear

# Remove out dir folder and clean the source
if [ "${WITH_OUTDIR}" == true ]; then
   if [ -d "${OUT}" ]; then
      rm -rf ${OUT}
   fi
fi

# Build time
if [ "${WITH_OUTDIR}" == true ]; then
   if [ ! -d "${OUT}" ]; then
      mkdir ${OUT}
   fi
fi

if [ "${WITH_OUTDIR}" == true ]; then
   "${CCACHE}" make O=${OUT} a21s_defconfig
   "${CCACHE}" make -j18 O=${OUT}
fi

# Create DTB/DTBO files
python scripts/dtc/libfdt/mkdtimg.py cfg_create ${OUT}/arch/arm64/boot/exynos3830.dtb dtbcfg/dtb/exynos3830.cfg --dtb-dir ${OUT}/arch/arm64/boot/dts/exynos
python scripts/dtc/libfdt/mkdtimg.py cfg_create ${OUT}/arch/arm64/boot/dtbo.img dtbcfg/dtbo/a21s.cfg --dtb-dir ${OUT}/arch/arm64/boot/dts/samsung/a21s
