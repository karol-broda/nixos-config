{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;

      palette = "catppuccin_frappe";

      palettes.catppuccin_frappe = {
        rosewater = "#f2d5cf";
        flamingo = "#eebebe";
        pink = "#f4b8e4";
        mauve = "#ca9ee6";
        red = "#e78284";
        maroon = "#ea999c";
        peach = "#ef9f76";
        yellow = "#e5c890";
        green = "#a6d189";
        teal = "#81c8be";
        sky = "#99d1db";
        sapphire = "#85c1dc";
        blue = "#8caaee";
        lavender = "#babbf1";
        text = "#c6d0f5";
        subtext1 = "#b5bfe2";
        subtext0 = "#a5adce";
        overlay2 = "#949cbb";
        overlay1 = "#838ba7";
        overlay0 = "#737994";
        surface2 = "#626880";
        surface1 = "#51576d";
        surface0 = "#414559";
        base = "#303446";
        mantle = "#292c3c";
        crust = "#232634";
      };

      character = {
        success_symbol = "[>](bold mauve)";
        error_symbol = "[>](bold red)";
        vimcmd_symbol = "[<](bold yellow)";
      };

      directory = {
        truncation_length = 3;
        truncation_symbol = ".../";
        style = "bold blue";
        read_only = " ro";
        read_only_style = "red";
      };

      git_branch = {
        symbol = "";
        truncation_length = 20;
        truncation_symbol = "...";
        style = "bold teal";
        format = "on [$symbol$branch]($style) ";
      };

      git_status = {
        style = "teal";
        modified = "[~$count](teal) ";
        staged = "[+$count](green) ";
        deleted = "[-$count](red) ";
        untracked = "[?$count](yellow) ";
        stashed = "[*$count](lavender) ";
        ahead = "[^$count](green) ";
        behind = "[v$count](red) ";
        diverged = "[^v](yellow) ";
      };

      nodejs = {
        symbol = "node ";
        format = "[$symbol($version )]($style)";
        detect_extensions = [];
        detect_files = ["package-lock.json" ".nvmrc" ".node-version"];
        detect_folders = [];
        style = "green";
      };

      bun = {
        symbol = "bun ";
        format = "[$symbol($version )]($style)";
        detect_files = ["bun.lockb" "bun.lock" "bunfig.toml"];
        detect_extensions = [];
        detect_folders = [];
        style = "rosewater";
      };

      python = {
        symbol = "py ";
        format = "[$symbol($version )]($style)";
        style = "yellow";
        detect_files = ["requirements.txt" "pyproject.toml" "Pipfile" ".venv"];
        pyenv_version_name = false;
      };

      rust = {
        symbol = "rs ";
        format = "[$symbol($version )]($style)";
        style = "maroon";
      };

      golang = {
        symbol = "go ";
        format = "[$symbol($version )]($style)";
        style = "sapphire";
      };

      zig = {
        symbol = "zig ";
        format = "[$symbol($version )]($style)";
        style = "peach";
      };

      c = {
        symbol = "c ";
        format = "[$symbol($version )]($style)";
        style = "blue";
      };

      cmake = {
        symbol = "cmake ";
        format = "[$symbol($version )]($style)";
        style = "blue";
      };

      kubernetes = {
        symbol = "k8s ";
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        style = "sky";
        disabled = false;
      };

      terraform = {
        symbol = "tf ";
        format = "[$symbol$workspace]($style) ";
        style = "lavender";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "overlay1";
      };

      docker_context = {
        symbol = "docker ";
        format = "[$symbol$context]($style) ";
        only_with_files = true;
        style = "sky";
      };

      nix_shell = {
        symbol = "nix ";
        format = "[$symbol$state]($style) ";
        style = "lavender";
      };

      aws = {
        symbol = "aws ";
        format = "[$symbol($profile )]($style)";
        style = "peach";
      };

      hostname = {
        style = "green";
        trim_at = ".";
      };

      time.disabled = true;
      sudo.disabled = true;
      status.disabled = true;
    };
  };
}
