{pkgs, ...}: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
    ./lsp.nix
    ./autocmds.nix
    ./ai.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "frappe";
        background = {
          light = "latte";
          dark = "frappe";
        };
        transparent_background = true;
        show_end_of_buffer = false;
        term_colors = true;
        dim_inactive = {
          enabled = false;
          shade = "dark";
          percentage = 0.15;
        };
        no_italic = false;
        no_bold = false;
        no_underline = false;
        styles = {
          comments = ["italic"];
          conditionals = ["italic"];
          loops = [];
          functions = [];
          keywords = [];
          strings = [];
          variables = [];
          numbers = [];
          booleans = [];
          properties = [];
          types = [];
          operators = [];
        };
        color_overrides = {};
        custom_highlights = {};
        default_integrations = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          notify = false;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
          alpha = true;
          bufferline = true;
          indent_blankline = {
            enabled = true;
            scope_color = "";
            colored_indent_levels = false;
          };
          telescope = {
            enabled = true;
          };
          treesitter_context = true;
          trouble = false;
          which_key = true;
        };
      };
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = pkgs.stdenv.hostPlatform.isLinux;
    };

    extraPackages = with pkgs; [
      stylua
      nixpkgs-fmt
      prettier
      black
      isort
      rustfmt
      ripgrep
      fd
      git
      curl
      tree-sitter
    ];
  };
}
