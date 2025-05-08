#!/bin/bash
set -e

FFMPEG_VERSION=6.0
NDK=/opt/android-ndk
SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

ARCH=arm
CPU=armv7-a
API=21
TARGET=armv7a-linux-androideabi
PREFIX=$(pwd)/android/$ARCH

mkdir -p $PREFIX

curl -L https://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.gz | tar xz
cd ffmpeg-$FFMPEG_VERSION

./configure \
  --prefix=$PREFIX \
  --target-os=android \
  --arch=$ARCH \
  --cpu=$CPU \
  --cc=$TOOLCHAIN/bin/${TARGET}${API}-clang \
  --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
  --enable-cross-compile \
  --sysroot=$SYSROOT \
  --enable-gpl \
  --enable-static \
  --disable-shared \
  --disable-doc \
  --disable-programs \
  --disable-avdevice \
  --disable-postproc \
  --disable-vulkan
  
make -j$(nproc)
make install

# Copy build output to mounted volume (for GitHub Actions)
mkdir -p /output/armv7a
cp -r $PREFIX/* /output/armv7a/