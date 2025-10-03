# pydio-nix

Nix flake packaging for [Pydio Cells](https://github.com/pydio/cells), a self-hosted file sharing and collaboration platform.

## Overview

This repository offers an opinionated flake that builds the Pydio Cells server as a Go module using `nix build`. It fetches the upstream `v4.4.15` release, wires in the vendor dependencies, and exposes the resulting `cells` binary as the default package output.

## Getting Started

### Build the binary

```
nix build .#default
```

Once the build completes, the `cells` binary is available in `./result/bin/cells`.

### Run the server

```
nix run .#default -- --help
```

Use the upstream documentation to configure and run the server; by default Pydio Cells needs a database and object storage for production use.

### Dev shell

Drop into a shell with Go and `nixpkgs-fmt`:

```
nix develop
```

## Upgrading Pydio Cells

1. Update the `version` in `flake.nix` and adjust the `rev` if the tag naming changes.
2. Fetch the new source hash: `nix-prefetch-url --unpack https://github.com/pydio/cells/archive/refs/tags/vX.Y.Z.tar.gz`.
3. Build once with `vendorHash = lib.fakeSha256;` to capture the new vendor hash from the build failure output, then replace it.
4. Rebuild via `nix build` to confirm, and regenerate or update the lock file if needed (`nix flake update`).

## License

Pydio Cells is licensed under the AGPL-3.0-or-later. This repository only contains packaging metadata; refer to upstream for license details.
