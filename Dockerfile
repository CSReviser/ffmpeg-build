FROM ubuntu:22.04

ENV ANDROID_NDK_VERSION=r25c
ENV ANDROID_API=21

RUN apt-get update && apt-get install -y \
  git wget curl unzip build-essential autoconf automake libtool pkg-config \
  python3 openjdk-17-jdk yasm

# NDKインストール
RUN wget https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux.zip && \
    unzip android-ndk-${ANDROID_NDK_VERSION}-linux.zip && \
    mv android-ndk-${ANDROID_NDK_VERSION} /opt/android-ndk

ENV PATH=$PATH:/opt/android-ndk

# ビルドスクリプトコピー
WORKDIR /ffmpeg
COPY build-ffmpeg.sh .

RUN chmod +x build-ffmpeg.sh && ./build-ffmpeg.sh