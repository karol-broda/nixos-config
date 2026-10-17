{ pkgs
, inputs
, ...
}:
let
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
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
in
{
  imports = [
    ../ai-zed.nix
  ];

  home = {
    sessionPath = [ "$HOME/.local/bin" ];

    packages = [
      llm-agents.codex
      llm-agents.zcode
      llm-agents.claude-code
      pkgs.mcp-server-fetch
      pkgs.mcp-server-filesystem
    ];

    file = { };
  };

  programs = {
    zsh.initContent = wtsFunc;
    bash.initExtra = wtsFunc;
  };
}
