{ pkgs, lib, metadata, src }:
let
  inherit (metadata) version vendorHashes;
in
pkgs.buildGoModule {
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
}
