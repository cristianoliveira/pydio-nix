# pydio-nix

Nix flake packaging for [Pydio Cells](https://github.com/pydio/cells), a self-hosted file sharing and collaboration platform.

## Summary

- [Overview](#overview) – project goal and upstream reference
- [Packages](#packages) – binary outputs and installation commands
- [Installing](#installing) – profile commands and flake integration
- [Build the binary](#build-the-binary)
- [Run the server](#run-the-server)
- [Dev shell](#dev-shell)
- [Upgrading Pydio Cells](#upgrading-pydio-cells)
- [Repository layout](#repository-layout)
## Overview

This repository offers an opinionated flake that builds the Pydio Cells server as a Go module using `nix build`. It fetches the upstream `v4.4.15` release, wires in the vendor dependencies, and exposes the resulting `cells` binary as the default package output.

## Getting Started

### Packages

The flake exports several build outputs:

- `nix build .#default` or `.#cells` – main `cells` server binary.
- `nix build .#cells-fuse` – offline FUSE helper to mount datasources.
- `nix build .#protoc-gen-go-client-stub` – protoc plugin for generating Cells-specific client stubs.
- `nix build .#protoc-gen-go-enhanced-grpc` – protoc plugin providing enhanced gRPC helpers.
- `nix build .#cells-client` – cross-platform CLI (`cec`) to interact with a Cells server.

### Installing

Install any of them into your user profile with:

```
nix profile install .#cells
nix profile install .#cells-fuse
nix profile install .#protoc-gen-go-client-stub
nix profile install .#protoc-gen-go-enhanced-grpc
nix profile install .#cells-client
```

#### Use as dependency

Import this flake from another `flake.nix` to reuse the packages:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    pydio.url = "github:cristianoliveira/pydio-nix";
  };

  outputs = { self, nixpkgs, pydio, ... }@inputs:
    let
      system = "x86_64-linux"; # or inherit via flake-utils
      pkgs = import nixpkgs { inherit system; };
      pydioPkgs = pydio.packages.${system};
    in {
      packages.${system} = {
        inherit (pydioPkgs) cells cells-fuse cells-client;
      };

      apps.${system}.cec = {
        type = "app";
        program = "${pydioPkgs."cells-client"}/bin/cec";
      };
    };
}
```

Replace `system` with the platform(s) you target or wrap the outputs using `flake-utils` for multi-platform support.

##### As an overlay

You can also consume the packages through the provided overlay, which adds a `pydio` attribute to your package set:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    pydio.url = "github:cristianoliveira/pydio-nix";
  };

  outputs = { self, nixpkgs, pydio, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ pydio.overlays.default ];
      };
    in {
      packages.${system}.cells = pkgs.pydio.cells;
    };
}
```

The overlay exposes all packaged binaries under `pkgs.pydio` (e.g. `pkgs.pydio."cells-client"`).

### Build the binary

```
nix build .#default
```

Once the build completes, the `cells` binary is available in `./result/bin/cells` or directly in your profile if you installed it via `nix profile install`.

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

The development shell also brings in `protobuf` for working with the protoc plugins.

## Upgrading Pydio Cells

1. Update the `version` in `flake.nix` and adjust the `rev` if the tag naming changes.
2. Fetch the new source hash: `nix-prefetch-url --unpack https://github.com/pydio/cells/archive/refs/tags/vX.Y.Z.tar.gz`.
3. Build once with `vendorHash = lib.fakeSha256;` to capture the new vendor hash from the build failure output, then replace it.
4. Rebuild via `nix build` to confirm, and regenerate or update the lock file if needed (`nix flake update`).

## Repository layout

- `flake.nix` – thin entry point delegating per-system outputs.
- `nix/metadata.nix` – shared version, source and vendor hash metadata.
- `nix/packages/` – package definitions for the Cells binaries and protoc helpers.
- `nix/devshell.nix` – development shell configuration.

## Use as dependency

Import this flake from another `flake.nix` to reuse the packages:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    pydio.url = "github:cristianoliveira/pydio-nix";
  };

  outputs = { self, nixpkgs, pydio, ... }@inputs:
    let
      system = "x86_64-linux"; # or inherit via flake-utils
      pkgs = import nixpkgs { inherit system; };
      pydioPkgs = pydio.packages.${system};
    in {
      packages.${system} = {
        inherit (pydioPkgs) cells cells-fuse cells-client;
      };

      apps.${system}.cec = {
        type = "app";
        program = "${pydioPkgs."cells-client"}/bin/cec";
      };
    };
}
```

Replace `system` with the platform(s) you target or wrap the outputs using `flake-utils` for multi-platform support.

### As an overlay

You can also consume the packages through the provided overlay, which adds a `pydio` attribute to your package set:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    pydio.url = "github:cristianoliveira/pydio-nix";
  };

  outputs = { self, nixpkgs, pydio, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ pydio.overlays.default ];
      };
    in {
      packages.${system}.cells = pkgs.pydio.cells;
    };
}
```

The overlay exposes all packaged binaries under `pkgs.pydio` (e.g. `pkgs.pydio."cells-client"`).

## License

Pydio Cells is licensed under the AGPL-3.0-or-later. This repository only contains packaging metadata; refer to upstream for license details.
