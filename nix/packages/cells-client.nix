{ pkgs, lib, metadata, src }:
let
  inherit (metadata) version vendorHash;
  mkLdflags = extra: [ "-s" "-w" ] ++ extra;
in
pkgs.buildGoModule {
  pname = "pydio-cells-client";
  inherit version src;

  inherit vendorHash;
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
}
