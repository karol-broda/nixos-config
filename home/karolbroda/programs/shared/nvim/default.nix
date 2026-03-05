{
  pkgs,
  pkgs-unstable,
  platformOpts,
  ...
}: let
  inherit (platformOpts) isLinux;
in {
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
        transparent_background = true;
        term_colors = true;
        styles = {
          comments = ["italic"];
          conditionals = ["italic"];
        };
        default_integrations = true;
        integrations = {
          avante = true;
          blink_cmp = true;
          diffview = true;
          fidget = true;
          flash = true;
          gitsigns = true;
          illuminate.enabled = true;
          indent_blankline.enabled = true;
          mini.enabled = true;
          noice = true;
          notify = true;
          nvimtree = true;
          render_markdown = true;
          telescope.enabled = true;
          treesitter = true;
          treesitter_context = true;
          trouble = true;
          which_key = true;
        };
        # force transparency on panels that catppuccin doesn't clear by default
        # cause of transparent background
        custom_highlights.__raw = ''
          function(colors)
            return {
              NormalFloat = { bg = "NONE" },
              FloatBorder = { bg = "NONE" },
              FloatTitle = { bg = "NONE" },
              NvimTreeNormal = { bg = "NONE" },
              NvimTreeNormalNC = { bg = "NONE" },
              NvimTreeEndOfBuffer = { bg = "NONE" },
              NvimTreeWinSeparator = { bg = "NONE", fg = colors.surface0 },
              TelescopeNormal = { bg = "NONE" },
              TelescopeBorder = { bg = "NONE" },
              TelescopePromptNormal = { bg = "NONE" },
              TelescopePromptBorder = { bg = "NONE" },
              TelescopeResultsNormal = { bg = "NONE" },
              TelescopeResultsBorder = { bg = "NONE" },
              TelescopePreviewNormal = { bg = "NONE" },
              TelescopePreviewBorder = { bg = "NONE" },
              WhichKeyFloat = { bg = "NONE" },
              TreesitterContext = { bg = "NONE" },
              TroubleNormal = { bg = "NONE" },
              NoiceCmdlinePopup = { bg = "NONE" },
              NoiceCmdlinePopupBorder = { bg = "NONE" },
              AvanteNormal = { bg = "NONE" },
              AvanteSidebar = { bg = "NONE" },
              AvanteSidebarNormal = { bg = "NONE" },
              AvanteInput = { bg = "NONE" },
            }
          end
        '';
      };
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = isLinux;
    };

    extraPackages = with pkgs; [
      ripgrep
      fd
      git
      curl
      tree-sitter

      # formatters (referenced by conform-nvim)
      stylua
      nixpkgs-fmt
      pkgs-unstable.prettier
      black
      isort
      rustfmt
      shfmt
      gofumpt
    ];
  };
}
