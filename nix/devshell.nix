{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [ go nixpkgs-fmt protobuf ];
}
