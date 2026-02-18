{pkgs, ...}: let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  # snowShader = ../../themes/ghostty-snow.glsl;
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vimcmd_symbol = "[V](bold yellow)";
      };

      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        style = "bold cyan";
        read_only = " [RO]";
        read_only_style = "bold red";
      };

      git_branch = {
        symbol = "git ";
        truncation_length = 20;
        truncation_symbol = "…";
        style = "bold magenta";
      };

      git_status = {
        modified = "[M](bold orange) ";
        staged = "[+](bold green) ";
        deleted = "[D](bold red) ";
        untracked = "[?](bold blue) ";
        stashed = "[S](bold yellow) ";
        ahead = "[↑](bold green) ";
        behind = "[↓](bold red) ";
        diverged = "[↕](bold yellow) ";
        style = "bold white";
      };

      nodejs = {
        format = "via [node $version](bold green)";
        detect_extensions = ["js" "ts" "jsx" "tsx"];
        detect_files = ["package.json" "node_modules"];
        style = "bold green";
      };

      python = {
        symbol = "py ";
        style = "bold yellow";
        format = "via [$symbol$version]($style)";
        detect_files = ["requirements.txt" "pyproject.toml" "Pipfile" ".venv"];
        pyenv_version_name = false;
      };

      cmd_duration = {
        min_time = 2000;
        format = " took [$duration](bold yellow)";
        style = "bold yellow";
      };

      aws = {
        format = "on [aws $profile](bold blue)";
        style = "bold blue";
        symbol = "aws ";
      };

      docker_context = {
        format = "via [docker $context](bold cyan)";
        only_with_files = true;
        style = "bold cyan";
        symbol = "docker ";
      };

      time = {
        format = "[$time](bold blue)";
        time_format = "%H:%M:%S";
        style = "bold blue";
      };

      shell = {
        format = "[sh $name](bold cyan)";
        style = "bold cyan";
      };

      hostname = {
        format = "on [$hostname](bold green)";
        style = "bold green";
        trim_at = ".";
      };

      fill = {
        symbol = "-";
        style = "bold green";
      };

      status = {
        symbol = "[!] ";
        success_symbol = "";
        format = "[$symbol$common_meaning$signal_name$maybe_int]($style) ";
        map_symbol = true;
        disabled = true;
      };

      sudo = {
        style = "bold green";
        symbol = "sudo ";
        disabled = true;
      };

      nix_shell = {
        symbol = "nix ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  programs.nushell = {
    enable = true;
    package = pkgs.nushell;

    envFile.text = ''
      $env.EDITOR = "nvim"
      $env.DO_NOT_TRACK = "1"

      let local_bin = ($nu.home-path | path join ".local" "bin")
      if (($local_bin | path exists) == true) {
        let in_path = ($env.PATH | any {|p| $p == $local_bin })
        if ($in_path == false) {
          $env.PATH = ($env.PATH | append $local_bin)
        }
      }
    '';

    configFile.text = '''';

    environmentVariables = {
      PAGER = "less -R";
    };

    shellAliases = {
      pls = "sudo";
      ll = "eza -lhA";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      k = "kubectl";
      ls = "eza";
    };
  };

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

  programs.eza = {
    enable = true;
    icons = "always";
    git = true;
    enableNushellIntegration = true;
  };

  programs.ghostty = {
    enable = true;
    package =
      if isLinux
      then pkgs.ghostty
      else pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings =
      {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        cursor-style = "block";
        copy-on-select = true;
        confirm-close-surface = false;
        scrollback-limit = 10000;
        shell-integration-features = true;
        # custom-shader = toString snowShader;
        # custom-shader-animation = true;
      }
      // (
        if isLinux
        then {
          gtk-single-instance = true;
        }
        else {}
      );
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
    defaultOptions = [
      "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796"
      "--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6"
      "--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
      "--color=selected-bg:#494d64"
      "--multi"
      "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
      "--preview-window=right:60%:wrap"
    ];
    fileWidgetCommand = "rg --files --hidden --glob '!.git/*'";
    changeDirWidgetCommand = "find . -type d -name '.git' -prune -o -type d -print | head -200";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = ["ignoredups" "ignorespace"];
    historySize = 10000;
    historyFileSize = 10000;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    initExtra = ''
      export DO_NOT_TRACK=1
      export EDITOR="nvim"
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
