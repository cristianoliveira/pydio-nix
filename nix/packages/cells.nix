{ pkgs, lib, metadata, src, buildRevision }:
let
  inherit (metadata) version buildStamp vendorHashes;
  mkLdflags = extra: [ "-s" "-w" ] ++ extra;
in
pkgs.buildGoModule rec {
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
}
