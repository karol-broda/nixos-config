{
  pkgs,
  inputs,
  ...
}: let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  mcp-servers = inputs.mcp-servers.packages.${pkgs.stdenv.hostPlatform.system};

  wtsFunc = ''
    wts() {
      local selected
      selected=$(git worktree list | awk '{print $1}' | tv)
      if [ -n "$selected" ]; then
        cd "$selected"
        if [ -f .envrc ]; then
          direnv allow
        fi
      fi
    }
  '';
in {
  imports = [
    ./ai-zed.nix
  ];

  home = {
    sessionPath = ["$HOME/.local/bin"];

    packages = [
      llm-agents.claude-code
      # llm-agents.openskills  # hash mismatch in upstream flake
      # inputs.workmux.packages.${pkgs.stdenv.hostPlatform.system}.default  # shell completion build failure upstream
      mcp-servers.mcp-server-fetch
      mcp-servers.mcp-server-filesystem
      pkgs.fabric-ai
    ];

    file = {
      ".claude/settings.json".text = builtins.toJSON {
        mcpServers = {
          filesystem = {
            command = "mcp-server-filesystem";
            args = [];
          };
          fetch = {
            command = "mcp-server-fetch";
            args = [];
          };
        };
      };

      ".local/bin/vibe" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          set -e
          BRANCH="''${1:-$(git branch --show-current)-ai}"
          ROOT=$(git rev-parse --show-toplevel)
          TREES_DIR="$ROOT/.trees"
          WORKTREE="$TREES_DIR/$BRANCH"

          mkdir -p "$TREES_DIR"

          if [ ! -d "$WORKTREE" ]; then
            git worktree add -b "$BRANCH" "$WORKTREE" HEAD 2>/dev/null || \
            git worktree add "$WORKTREE" "$BRANCH"
          fi

          cd "$WORKTREE"
          if [ -f .envrc ]; then
            direnv allow
          fi
          claude
        '';
      };
    };
  };

  programs = {
    zsh.initContent = wtsFunc;
    bash.initExtra = wtsFunc;
  };
}
