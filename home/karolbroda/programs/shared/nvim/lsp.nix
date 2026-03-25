{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>cd" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gI" = "implementation";
            "K" = "hover";
            "gr" = "references";
            "gt" = "type_definition";
            "<leader>ca" = "code_action";
            "<leader>cr" = "rename";
            "<leader>cs" = "signature_help";
          };
        };

        servers = {
          # nix (nixd has option completion, flake awareness, better hover)
          nixd = {
            enable = true;
            settings = {
              nixpkgs.expr = "import <nixpkgs> {}";
              formatting.command = ["${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"];
              options = {
                nixos.expr = ''(builtins.getFlake "git+file:///home/karolbroda/nix-config").nixosConfigurations.nixos.options'';
                home-manager.expr = ''(builtins.getFlake "git+file:///home/karolbroda/nix-config").homeConfigurations.karolbroda.options'';
              };
            };
          };

          # lua
          lua_ls = {
            enable = true;
            settings.Lua = {
              runtime.version = "LuaJIT";
              diagnostics.disable = ["missing-fields"];
              workspace.checkThirdParty = false;
              completion.callSnippet = "Replace";
              telemetry.enable = false;
            };
          };

          # web
          ts_ls.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          tailwindcss = {
            enable = true;
            filetypes = ["html" "javascript" "javascriptreact" "typescript" "typescriptreact" "svelte" "astro" "vue"];
            extraOptions.init_options.userLanguages.tailwindcss = "css";
          };

          # languages
          pyright.enable = true;
          gopls.enable = true;
          bashls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          zls.enable = true;
        };
      };

      # proper neovim lua workspace for lua_ls
      lazydev = {
        enable = true;
        settings.library = [
          {
            path = "luvit-meta/library";
            words = ["vim%.uv"];
          }
        ];
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_format = "fallback";
            timeout_ms = 1000;
          };
          formatters_by_ft = {
            lua = ["stylua"];
            nix = ["nixpkgs_fmt"];
            python = ["black"];
            javascript = ["prettier"];
            typescript = ["prettier"];
            json = ["prettier"];
            yaml = ["prettier"];
            html = ["prettier"];
            css = ["prettier"];
            markdown = ["prettier"];
            rust = ["rustfmt"];
            go = ["gofumpt"];
            sh = ["shfmt"];
          };
          formatters = {
            nixpkgs_fmt.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            stylua.command = "${pkgs.stylua}/bin/stylua";
            prettier.command = "${pkgs.nodePackages.prettier}/bin/prettier";
            black.command = "${pkgs.python3Packages.black}/bin/black";
            rustfmt.command = "${pkgs.rustfmt}/bin/rustfmt";
          };
        };
      };
    };

    keymaps = [
      {
        mode = ["n" "v"];
        key = "<leader>cf";
        action = "<cmd>lua require('conform').format({ lsp_format = 'fallback', async = false, timeout_ms = 1000 })<CR>";
        options.desc = "format";
      }
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "diagnostics (trouble)";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "buffer diagnostics (trouble)";
      }
      {
        mode = "n";
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options.desc = "location list (trouble)";
      }
      {
        mode = "n";
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options.desc = "quickfix list (trouble)";
      }
    ];
  };
}
