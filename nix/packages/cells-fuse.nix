{ pkgs, lib, metadata, src, buildRevision }:
let
  inherit (metadata) version buildStamp vendorHashes;
  mkLdflags = extra: [ "-s" "-w" ] ++ extra;
in
pkgs.buildGoModule rec {
  pname = "pydio-cells-fuse";
  inherit version;
  src = src;

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
}
