FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install the AArch64 cross-toolchain plus the ARM64 target libraries needed
# to cross-compile libsigrok for Raspberry Pi class Linux systems.
RUN dpkg --add-architecture arm64 \
	&& apt-get update && export DEBIAN_FRONTEND=noninteractive \
	&& apt-get install -y --no-install-recommends \
		git \
		make \
		file \
		autoconf \
		automake \
		autoconf-archive \
		libtool \
		pkg-config \
		gcc-aarch64-linux-gnu \
		g++-aarch64-linux-gnu \
		binutils-aarch64-linux-gnu \
		libc6-dev:arm64 \
		libglib2.0-dev:arm64 \
		zlib1g-dev:arm64 \
		libzip-dev:arm64 \
		libtirpc-dev:arm64 \
		libserialport-dev:arm64 \
		libusb-1.0-0-dev:arm64 \
		libhidapi-dev:arm64 \
		libbluetooth-dev:arm64 \
		libftdi1-dev:arm64 \
		libieee1284-3-dev:arm64 \
		nettle-dev:arm64 \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
