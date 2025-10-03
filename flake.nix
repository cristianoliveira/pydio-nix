{
  description = "Nix flake: pydio-cells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;

        metadata = import ./nix/metadata.nix;
        src = pkgs.fetchFromGitHub metadata.source;
        buildRevision = src.rev or metadata.source.rev;

        packageSet = import ./nix/packages/default.nix {
          inherit pkgs lib metadata src buildRevision;
        };
      in {
        packages = packageSet;

        devShells.default = import ./nix/devshell.nix { inherit pkgs; };
      }
    );
}
