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
      in {
        packages.default = pkgs.buildGoModule rec {
          pname = "pydio-cells";
          version = "4.4.15";

          src = pkgs.fetchFromGitHub {
            owner = "pydio";
            repo = "cells";
            rev = "v${version}";
            sha256 = "0mmhw1psi6kkfgi04wkcn74mbbsbyvshk2j7afwv2lvjvk3qh4kk";
          };

          vendorHash = "sha256-v23Ep9mTyG8fe5xa9ay9T4/ZEBU9LQHj6keIPZmm5d0=";

          subPackages = [ "." ];
          ldflags = [
            "-s"
            "-w"
            "-X github.com/pydio/cells/v4/common.version=${version}"
            "-X github.com/pydio/cells/v4/common.BuildStamp=2025-06-17T07:14:26Z"
            "-X github.com/pydio/cells/v4/common.BuildRevision=${src.rev}"
          ];

          doCheck = false;

          meta = with lib; {
            description = "Self-hosted file sharing and collaboration platform";
            homepage = "https://github.com/pydio/cells";
            license = licenses.agpl3Plus;
            maintainers = with maintainers; [ cristianoliveira ];
            mainProgram = "cells";
            platforms = platforms.linux ++ platforms.darwin;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ go nixpkgs-fmt ];
        };
      }
    );
}
