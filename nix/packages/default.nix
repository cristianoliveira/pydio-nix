{ pkgs, lib, metadata, srcs }:
let
  inherit (metadata.cells) version buildStamp vendorHashes;
  buildRevision = srcs.cells.rev or metadata.cells.source.rev;

  mkLdflags = extra: [ "-s" "-w" ] ++ extra;

  cells = pkgs.buildGoModule rec {
    pname = "pydio-cells";
    inherit version;
    src = srcs.cells;

    vendorHash = vendorHashes.cells;

    subPackages = [ "." ];
    ldflags = mkLdflags [
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

  cellsFuse = pkgs.buildGoModule rec {
    pname = "pydio-cells-fuse";
    inherit version;
    src = srcs.cells;

    modRoot = "cmd/cells-fuse";
    subPackages = [ "." ];
    vendorHash = vendorHashes."cells-fuse";
    ldflags = mkLdflags [
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

  protocGenGoClientStub = pkgs.buildGoModule {
    pname = "pydio-protoc-gen-go-client-stub";
    inherit version;
    src = srcs.cells;

    modRoot = "cmd/protoc-gen-go-client-stub";
    subPackages = [ "." ];
    vendorHash = vendorHashes."protoc-gen-go-client-stub";

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

  protocGenGoEnhancedGrpc = pkgs.buildGoModule {
    pname = "pydio-protoc-gen-go-enhanced-grpc";
    inherit version;
    src = srcs.cells;

    modRoot = "cmd/protoc-gen-go-enhanced-grpc";
    subPackages = [ "." ];
    vendorHash = vendorHashes."protoc-gen-go-enhanced-grpc";

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

  cellsClient = pkgs.buildGoModule rec {
    pname = "pydio-cells-client";
    version = metadata."cells-client".version;
    src = srcs.cells-client;

    vendorHash = metadata."cells-client".vendorHash;
    subPackages = [ "." ];
    ldflags = mkLdflags [
      "-X github.com/pydio/cells-client/v4/common.Version=${version}"
    ];

    doCheck = false;

    meta = with lib; {
      description = "Command-line client for interacting with Pydio Cells";
      homepage = "https://github.com/pydio/cells-client";
      license = licenses.agpl3Plus;
      maintainers = with maintainers; [ cristianoliveira ];
      mainProgram = "cec";
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

in {
  default = cells;
  cells = cells;
  "cells-fuse" = cellsFuse;
  "protoc-gen-go-client-stub" = protocGenGoClientStub;
  "protoc-gen-go-enhanced-grpc" = protocGenGoEnhancedGrpc;
  "cells-client" = cellsClient;
}
