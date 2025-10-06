{ pkgs, lib, metadata, src }:
let
  inherit (metadata) version vendorHashes;
in
pkgs.buildGoModule {
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
}
