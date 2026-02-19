{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      share = true;
      extended = true;
    };

    completionInit = ''
      fpath+=(~/.nix-profile/share/zsh/site-functions ~/.nix-profile/share/zsh/$ZSH_VERSION/functions ~/.nix-profile/share/zsh/vendor-completions)

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' select-prompt '%SScrolling: %s'
    '';

    initContent = ''
      bindkey -e

      bindkey -M emacs '\e[1;3D' backward-word
      bindkey -M emacs '\e[1;3C' forward-word
      bindkey -M emacs '\e[1;9D' backward-word
      bindkey -M emacs '\e[1;9C' forward-word
      bindkey -M emacs '\eOd'    backward-word
      bindkey -M emacs '\eOc'    forward-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      bindkey -M emacs '\e[3;3~' kill-word
      bindkey -M emacs '\e[3;9~' kill-word
      bindkey -M emacs '\ed'      kill-word
      bindkey -M emacs '\e\x7f' backward-kill-word
      bindkey -M emacs '\e[127;3u' backward-kill-word

      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line

      autoload -Uz select-word-style
      select-word-style bash

      export DO_NOT_TRACK=1
      export EDITOR="nvim"

      _direnv_hook() {
        emulate -L zsh
        local old_fpath="$fpath"
        local dir

        for dir in $PATH; do
          local completion_dir="''${dir%/bin}/share/zsh/site-functions"
          if [[ -d "$completion_dir" ]] && [[ ! " ''${fpath[*]} " =~ " ''${completion_dir} " ]]; then
            fpath=("$completion_dir" $fpath)
          fi
        done

        if [[ "$old_fpath" != "$fpath" ]]; then
          compinit
        fi
      }

      autoload -U add-zsh-hook
      add-zsh-hook precmd _direnv_hook
    '';

    shellAliases = {
      pls = "sudo ";
      ll = "ls -lhA";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      k = "kubectl ";
      ls = "${pkgs.eza}/bin/eza";
      jq = "${pkgs.jq}/bin/jq -C";
      cat = "${pkgs.bat}/bin/bat --style=plain --paging=never --color=always";
    };
  };
}
