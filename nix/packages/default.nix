{ pkgs, lib, metadata, srcs }:
let
  cellsMeta = metadata.cells;
  cellsSrc = srcs.cells;
  cellsBuildRevision = cellsSrc.rev or cellsMeta.source.rev;

  cellsV5Meta = metadata."cells-v5";
  cellsV5Src = srcs."cells-v5";
  cellsV5BuildRevision = cellsV5Src.rev or cellsV5Meta.source.rev;

  cellsPkg = import ./cells.nix {
    inherit pkgs lib;
    buildRevision = cellsBuildRevision;
    metadata = cellsMeta;
    src = cellsSrc;
  };

  cellsFusePkg = import ./cells-fuse.nix {
    inherit pkgs lib;
    buildRevision = cellsBuildRevision;
    metadata = cellsMeta;
    src = cellsSrc;
  };

  protocClientStubPkg = import ./protoc-gen-go-client-stub.nix {
    inherit pkgs lib;
    metadata = cellsMeta;
    src = cellsSrc;
  };

  protocEnhancedGrpcPkg = import ./protoc-gen-go-enhanced-grpc.nix {
    inherit pkgs lib;
    metadata = cellsMeta;
    src = cellsSrc;
  };

  cellsClientPkg = import ./cells-client.nix {
    inherit pkgs lib;
    metadata = metadata."cells-client";
    src = srcs."cells-client";
  };

  cellsV5Pkg = import ./cells.nix {
    inherit pkgs lib;
    buildRevision = cellsV5BuildRevision;
    metadata = cellsV5Meta;
    src = cellsV5Src;
  };

in {
  default = cellsPkg;
  cells = cellsPkg;
  "cells-fuse" = cellsFusePkg;
  "protoc-gen-go-client-stub" = protocClientStubPkg;
  "protoc-gen-go-enhanced-grpc" = protocEnhancedGrpcPkg;
  "cells-client" = cellsClientPkg;
  "cells-v5" = cellsV5Pkg;
}
