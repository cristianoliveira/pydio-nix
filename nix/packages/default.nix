{ pkgs, lib, metadata, src, buildRevision }:
let
  inherit (metadata) version buildStamp vendorHashes;

  mkLdflags = extra:
    [ "-s" "-w" ] ++ extra;

  cells = pkgs.buildGoModule rec {
    pname = "pydio-cells";
    inherit version src;

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
    inherit version src;

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
    inherit version src;

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
    inherit version src;

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

in {
  default = cells;
  cells = cells;
  "cells-fuse" = cellsFuse;
  "protoc-gen-go-client-stub" = protocGenGoClientStub;
  "protoc-gen-go-enhanced-grpc" = protocGenGoEnhancedGrpc;
}
