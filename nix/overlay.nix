final: prev:
let
  metadata = import ./metadata.nix;
  srcs = {
    cells = final.fetchFromGitHub metadata.cells.source;
    cells-client = final.fetchFromGitHub metadata."cells-client".source;
    "cells-v5" = final.fetchFromGitHub metadata."cells-v5".source;
  };
  packages = import ./packages/default.nix {
    pkgs = final;
    lib = final.lib;
    inherit metadata srcs;
  };
in {
  pydio = packages;
}
