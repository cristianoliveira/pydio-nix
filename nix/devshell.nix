{ pkgs }:
  pkgs.mkShell {
    packages = with pkgs; [
      go

      golangci-lint

      nodejs_20
      pnpm # Latest

      # Protobuf tools and compilers
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc

      # Test runner with good output
      # USAGE: gotestsum --watch
      gotestsum

      # To create new subcommands, run:
      # cobra-cli add <subcommand-name>
      cobra-cli
    ];
  }
