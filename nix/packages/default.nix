{ pkgs, lib, metadata, srcs }:
let
  cellsMeta = metadata.cells;
  cellsSrc = srcs.cells;
  buildRevision = cellsSrc.rev or cellsMeta.source.rev;

  cellsPkg = import ./cells.nix {
    inherit pkgs lib buildRevision;
    metadata = cellsMeta;
    src = cellsSrc;
  };

  cellsFusePkg = import ./cells-fuse.nix {
    inherit pkgs lib buildRevision;
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

in {
  default = cellsPkg;
  cells = cellsPkg;
  "cells-fuse" = cellsFusePkg;
  "protoc-gen-go-client-stub" = protocClientStubPkg;
  "protoc-gen-go-enhanced-grpc" = protocEnhancedGrpcPkg;
  "cells-client" = cellsClientPkg;
}
