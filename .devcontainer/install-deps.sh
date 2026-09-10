#!/usr/bin/env bash
set -euo pipefail

apt-get install -y --no-install-recommends \
  git build-essential gcc g++ make \
  autoconf automake autoconf-archive libtool pkg-config \
  libglib2.0-dev zlib1g-dev libzip-dev libtirpc-dev \
  libserialport-dev libusb-1.0-0-dev libhidapi-dev \
  libbluetooth-dev libftdi1-dev libgpib-dev \
  libieee1284-3-dev nettle-dev \
  check doxygen graphviz \
  swig python3 python3-dev python3-setuptools \
  python3-gi python3-numpy \
  ruby ruby-dev \
  default-jdk

rm -rf /var/lib/apt/lists/*
