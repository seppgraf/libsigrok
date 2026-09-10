# Building libsigrok in the devcontainer

This tutorial walks through building libsigrok from source in the
repository's devcontainer. The repository provides a ready-to-use Ubuntu
environment for both native Linux builds and AArch64 cross-compilation for
Raspberry Pi targets, so you don't have to install the toolchain on your host
machine.

## Prerequisites

- [Docker](https://www.docker.com/) (or another devcontainer-compatible
  container runtime)
- [Visual Studio Code](https://code.visualstudio.com/) with the
  [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  extension, or the [Dev Container CLI](https://github.com/devcontainers/cli)
  if you prefer the command line
- Alternatively, a [GitHub Codespace](https://github.com/features/codespaces)
  can be used instead of a local Docker install

The native Linux container image is defined in `.devcontainer/Dockerfile` and
already includes the full set of packages listed in the `README` file under
"Requirements for the C library", such as `gcc`/`g++`, `autoconf`,
`automake`, `libtool`, `pkg-config`, `libglib2.0-dev`, `libzip-dev`,
`libusb-1.0-0-dev`, `libftdi1-dev`, `libhidapi-dev`, `check`, `doxygen` and
`graphviz`.

For Raspberry Pi AArch64 cross-compilation, use the dedicated configuration in
`.devcontainer/aarch64-cross`, which adds the `aarch64-linux-gnu` cross
toolchain plus the ARM64 target `-dev` packages needed by libsigrok.

## 1. Open the repository in the devcontainer

Choose one of these devcontainer configurations:

- `.devcontainer/devcontainer.json` for a native Linux build.
- `.devcontainer/aarch64-cross/devcontainer.json` for an AArch64
  cross-compilation build that targets 64-bit Raspberry Pi Linux systems.

### Using VS Code

1. Open the cloned `libsigrok` folder in VS Code.
2. If VS Code offers multiple devcontainer configurations, select the one you
   want to use. Otherwise, open the Command Palette
   (`Ctrl+Shift+P` / `Cmd+Shift+P`) and run **Dev Containers: Reopen in
   Container**.
3. VS Code will build the selected image and open a terminal inside the
   running container with the repository mounted at `/workspaces/libsigrok`.

### Using GitHub Codespaces

1. On the repository's GitHub page, click **Code > Codespaces > Create
   codespace on main**.
2. Wait for the codespace to finish building; it uses the same
   `.devcontainer` configuration.

### Using the Dev Container CLI

Native build:

```
$ devcontainer up --workspace-folder .
$ devcontainer exec --workspace-folder . bash
```

AArch64 cross-build:

```
$ devcontainer up --workspace-folder . \
    --config .devcontainer/aarch64-cross/devcontainer.json
$ devcontainer exec --workspace-folder . \
    --config .devcontainer/aarch64-cross/devcontainer.json bash
```

## 2. Build libsigrok natively

Once you have a shell inside the devcontainer, build libsigrok the same way
you would on any Linux machine:

```
$ ./autogen.sh
$ ./configure
$ make
```

- `./autogen.sh` runs `autoreconf` to generate the `configure` script and
  other build files from the `.am`/`.ac` sources (only needed when building
  from a git checkout).
- `./configure` detects the available optional dependencies (drivers that
  need `libftdi1`, `libusb`, `libhidapi`, etc. are automatically enabled or
  disabled depending on what is installed) and generates the `Makefile`s.
- `make` compiles the library and all enabled hardware drivers.

You can pass the usual `configure` options if you want to customize the
build, for example:

```
$ ./configure --with-udevrulesdir=/etc/udev/rules.d
```

## 3. Cross-compile libsigrok for Raspberry Pi AArch64

Once you have a shell inside the `.devcontainer/aarch64-cross` container, use
the AArch64 host triplet when running `configure`:

```
$ ./autogen.sh
$ ./configure --host=aarch64-linux-gnu --disable-bindings
$ make
```

- The cross-build devcontainer already exports the `aarch64-linux-gnu`
  compiler, binutils, and target `pkg-config` search path.
- `--disable-bindings` keeps the build focused on the core C library and avoids
  cross-compilation issues with optional language bindings, which are enabled
  by default.
- If you need a specific driver and `./configure` reports a missing dependency,
  install the matching ARM64 `-dev` package in
  `.devcontainer/aarch64-cross/Dockerfile` or disable the corresponding
  optional driver.

## 4. Verify the build

To confirm the shared library was built successfully:

```
$ file src/.libs/libsigrok.so*
```

For the cross-build container, `file` should report an `ELF 64-bit` binary for
`ARM aarch64`.

For the native Linux devcontainer, the optional `check` unit-testing framework
is installed, so you can also run the test suite:

```
$ make check
```

For the AArch64 cross-build devcontainer, `make check` is not expected to work
unless you add target emulation separately, because the test binaries are built
for ARM64 rather than the container's native CPU.

## 5. Install (optional)

To install the built library and headers into the container's filesystem:

```
$ make install
```

Note that this installs into the container only; it does not affect your
host machine.

## Troubleshooting

- If `./configure` reports a missing dependency, double-check that the
  corresponding `-dev` package is listed in `.devcontainer/Dockerfile` and
  rebuild the container image (**Dev Containers: Rebuild Container** in
  VS Code).
- For the Raspberry Pi cross-build devcontainer, check the package list in
  `.devcontainer/aarch64-cross/Dockerfile` instead.
- See the main `README` file for the full list of dependencies and optional
  features, and `http://sigrok.org/wiki/Building` for further
  platform-specific notes and a build FAQ.
