# Building libsigrok for Linux in the devcontainer

This tutorial walks through building libsigrok from source for Linux using
the repository's devcontainer. The devcontainer provides a ready-to-use
Ubuntu environment with all the tools and libraries required to build
libsigrok, so you don't have to install anything on your host machine.

## Prerequisites

- [Docker](https://www.docker.com/) (or another devcontainer-compatible
  container runtime)
- [Visual Studio Code](https://code.visualstudio.com/) with the
  [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  extension, or the [Dev Container CLI](https://github.com/devcontainers/cli)
  if you prefer the command line
- Alternatively, a [GitHub Codespace](https://github.com/features/codespaces)
  can be used instead of a local Docker install

The container image is defined in `.devcontainer/Dockerfile` and already
includes the full set of packages listed in the `README` file under
"Requirements for the C library", such as `gcc`/`g++`, `autoconf`,
`automake`, `libtool`, `pkg-config`, `libglib2.0-dev`, `libzip-dev`,
`libusb-1.0-0-dev`, `libftdi1-dev`, `libhidapi-dev`, `check`, `doxygen` and
`graphviz`.

## 1. Open the repository in the devcontainer

### Using VS Code

1. Open the cloned `libsigrok` folder in VS Code.
2. When prompted, click **Reopen in Container**. If you are not prompted,
   open the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`) and run
   **Dev Containers: Reopen in Container**.
3. VS Code will build the image described in `.devcontainer/Dockerfile` (this
   can take a few minutes the first time) and open a terminal inside the
   running container with the repository mounted at `/workspaces/libsigrok`.

### Using GitHub Codespaces

1. On the repository's GitHub page, click **Code > Codespaces > Create
   codespace on main**.
2. Wait for the codespace to finish building; it uses the same
   `.devcontainer` configuration.

### Using the Dev Container CLI

```
$ devcontainer up --workspace-folder .
$ devcontainer exec --workspace-folder . bash
```

## 2. Build libsigrok

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

## 3. Verify the build

To confirm the shared library was built successfully:

```
$ file src/.libs/libsigrok.so*
```

If the optional `check` unit-testing framework dependency is present (it is
installed in the devcontainer image), you can also run the test suite:

```
$ make check
```

## 4. Install (optional)

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
- See the main `README` file for the full list of dependencies and optional
  features, and `http://sigrok.org/wiki/Building` for further
  platform-specific notes and a build FAQ.
