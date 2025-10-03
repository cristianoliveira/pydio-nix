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

        version = "4.4.15";
        buildStamp = "2025-06-17T07:14:26Z";
        src = pkgs.fetchFromGitHub {
          owner = "pydio";
          repo = "cells";
          rev = "v${version}";
          sha256 = "0mmhw1psi6kkfgi04wkcn74mbbsbyvshk2j7afwv2lvjvk3qh4kk";
        };
        buildRevision = src.rev or "v${version}";
      in {
        packages = rec {
          default = cells;

          cells = pkgs.buildGoModule rec {
            pname = "pydio-cells";
            inherit version src;

            vendorHash = "sha256-v23Ep9mTyG8fe5xa9ay9T4/ZEBU9LQHj6keIPZmm5d0=";

            subPackages = [ "." ];
            ldflags = [
              "-s"
              "-w"
              "-X github.com/pydio/cells/v4/common.version=${version}"
              "-X github.com/pydio/cells/v4/common.BuildStamp=${buildStamp}"
              "-X github.com/pydio/cells/v4/common.BuildRevision=${buildRevision}"
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

          cells-fuse = pkgs.buildGoModule rec {
            pname = "pydio-cells-fuse";
            inherit version src;

            modRoot = "cmd/cells-fuse";
            subPackages = [ "." ];
            vendorHash = "sha256-FKXoxGkhUuqYpzYTGzLKFPXU785QjCEKOGemxV+SRxY=";
            ldflags = [
              "-s"
              "-w"
              "-X github.com/pydio/cells-fuse/vars.version=${version}"
              "-X github.com/pydio/cells-fuse/vars.BuildStamp=${buildStamp}"
              "-X github.com/pydio/cells-fuse/vars.BuildRevision=${buildRevision}"
            ];

            doCheck = false;

            meta = with lib; {
              description = "Offline FUSE mounter for Pydio Cells datasources";
              homepage = "https://github.com/pydio/cells";
              license = licenses.agpl3Plus;
              maintainers = with maintainers; [ cristianoliveira ];
              mainProgram = "cells-fuse";
              platforms = platforms.linux ++ platforms.darwin;
            };
          };

          protoc-gen-go-client-stub = pkgs.buildGoModule {
            pname = "pydio-protoc-gen-go-client-stub";
            inherit version src;

            modRoot = "cmd/protoc-gen-go-client-stub";
            subPackages = [ "." ];
            vendorHash = "sha256-exgsJovl52MpRUM8mNfEJu3opZZk58GnbTu9Ka5CxnA=";

            doCheck = false;

            meta = with lib; {
              description = "protoc plugin that generates client stubs for Pydio Cells";
              homepage = "https://github.com/pydio/cells";
              license = licenses.agpl3Plus;
              maintainers = with maintainers; [ cristianoliveira ];
              mainProgram = "protoc-gen-go-client-stub";
              platforms = platforms.all;
            };
          };

          protoc-gen-go-enhanced-grpc = pkgs.buildGoModule {
            pname = "pydio-protoc-gen-go-enhanced-grpc";
            inherit version src;

            modRoot = "cmd/protoc-gen-go-enhanced-grpc";
            subPackages = [ "." ];
            vendorHash = "sha256-exgsJovl52MpRUM8mNfEJu3opZZk58GnbTu9Ka5CxnA=";

            doCheck = false;

            meta = with lib; {
              description = "protoc plugin adding enhanced gRPC helpers used by Cells";
              homepage = "https://github.com/pydio/cells";
              license = licenses.agpl3Plus;
              maintainers = with maintainers; [ cristianoliveira ];
              mainProgram = "protoc-gen-go-enhanced-grpc";
              platforms = platforms.all;
            };
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ go nixpkgs-fmt protobuf ];
        };
      }
    );
}
