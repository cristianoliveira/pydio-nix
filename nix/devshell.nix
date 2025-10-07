{ pkgs }:
  pkgs.mkShell {
    packages = with pkgs; [
      go

      golangci-lint

      # Test runner with good output
      # USAGE: gotestsum --watch
      gotestsum

      # To create new subcommands, run:
      # cobra-cli add <subcommand-name>
      cobra-cli

      # File watcher 
      # USAGE: (check .watch.yaml for config)
      # fzz 
      funzzy
    ];
  }
