FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install the toolchain and libraries needed to build libsigrok (and its
# optional bindings) from a git checkout on Linux. See README for the
# authoritative list of dependencies.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
	&& apt-get install -y --no-install-recommends \
		git \
		build-essential \
		gcc \
		g++ \
		make \
		autoconf \
		automake \
		autoconf-archive \
		libtool \
		pkg-config \
		libglib2.0-dev \
		zlib1g-dev \
		libzip-dev \
		libtirpc-dev \
		libserialport-dev \
		libusb-1.0-0-dev \
		libhidapi-dev \
		libbluetooth-dev \
		libftdi1-dev \
		libieee1284-3-dev \
		nettle-dev \
		check \
		doxygen \
		graphviz \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
