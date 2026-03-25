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
    ../ai-zed.nix
  ];

  home = {
    sessionPath = ["$HOME/.local/bin"];

    packages = [
      llm-agents.claude-code-acp
      llm-agents.agent-deck
      pkgs.tmux
      llm-agents.ccstatusline
      llm-agents.entire
      # llm-agents.openskills  # hash mismatch in upstream flake
      # inputs.workmux.packages.${pkgs.stdenv.hostPlatform.system}.default  # shell completion build failure upstream
      mcp-servers.mcp-server-fetch
      mcp-servers.mcp-server-filesystem
      pkgs.fabric-ai
    ];

    file = {
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

      ".claude/statusline.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          data=$(cat)

          model=$(echo "$data" | ${pkgs.jq}/bin/jq -r '.model.display_name // "..."')
          pct=$(echo "$data" | ${pkgs.jq}/bin/jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
          cost=$(echo "$data" | ${pkgs.jq}/bin/jq -r '.cost.total_cost_usd // 0')
          added=$(echo "$data" | ${pkgs.jq}/bin/jq -r '.cost.total_lines_added // 0')
          removed=$(echo "$data" | ${pkgs.jq}/bin/jq -r '.cost.total_lines_removed // 0')

          # colors
          reset="\033[0m"
          dim="\033[2m"
          bold="\033[1m"
          cyan="\033[36m"
          green="\033[32m"
          yellow="\033[33m"
          red="\033[31m"
          magenta="\033[35m"

          # context bar
          bar_len=15
          filled=$((pct * bar_len / 100))
          empty=$((bar_len - filled))
          if [ "$pct" -ge 80 ]; then bar_color="$red"
          elif [ "$pct" -ge 50 ]; then bar_color="$yellow"
          else bar_color="$green"
          fi
          bar="''${bar_color}$(printf '█%.0s' $(seq 1 $filled 2>/dev/null))$(printf '░%.0s' $(seq 1 $empty 2>/dev/null))$reset"

          # git branch
          branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
          branch_str=""
          if [ -n "$branch" ]; then
            branch_str=" ''${dim}on''${reset} ''${magenta}$branch''${reset}"
          fi

          # line 1: model + branch
          echo -e "''${bold}''${cyan}$model''${reset}$branch_str"
          # line 2: context bar + cost + lines
          echo -e "$bar ''${dim}''${pct}%''${reset}  ''${dim}\$''${cost}''${reset}  ''${green}+$added''${reset} ''${red}-$removed''${reset}"
        '';
      };

      # rules placed manually since release-25.11 HM doesn't have programs.claude-code.rules yet
      ".claude/rules/coding-principles.md".source = ./rules/coding-principles.md;
      ".claude/rules/nix.md".source = ./rules/nix.md;
      ".claude/rules/typescript.md".source = ./rules/typescript.md;
      ".claude/rules/python.md".source = ./rules/python.md;
      ".claude/rules/go.md".source = ./rules/go.md;
      ".claude/rules/rust.md".source = ./rules/rust.md;
      ".claude/rules/c.md".source = ./rules/c.md;
      ".claude/rules/zig.md".source = ./rules/zig.md;
    };
  };

  programs = {
    zsh.initContent = wtsFunc;
    bash.initExtra = wtsFunc;

    claude-code = {
      enable = true;
      package = llm-agents.claude-code;

      settings = {
        statusLine = {
          type = "command";
          command = "~/.claude/statusline.sh";
          padding = 2;
        };
      };

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

      skillsDir = ./skills;
      # rulesDir = ./rules;
    };
  };
}
