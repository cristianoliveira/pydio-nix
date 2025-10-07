{
  description = "Nix flake: pydio-cells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }:
    let
      overlay = import ./nix/overlay.nix;
    in
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;

        metadata = import ./nix/metadata.nix;
        srcs = {
          cells = pkgs.fetchFromGitHub metadata.cells.source;
          cells-client = pkgs.fetchFromGitHub metadata."cells-client".source;
          "cells-v5" = pkgs.fetchFromGitHub metadata."cells-v5".source;
        };

        packageSet = import ./nix/packages/default.nix {
          inherit pkgs lib metadata srcs;
        };
      in {
        packages = packageSet;

        devShells = rec {
          default = import ./nix/devshell.nix { inherit pkgs; };
          cells = default;
        };
      }
    ) // {
      overlays.default = overlay;
    };
}
