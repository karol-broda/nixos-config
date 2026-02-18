{pkgs, ...}: {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>cd" = "open_float";
          "[d" = "goto_next";
          "]d" = "goto_prev";
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
        };
      };

      servers = {
        nil_ls = {
          enable = true;
          settings = {
            formatting = {
              command = ["${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"];
            };
          };
        };

        lua_ls = {
          enable = true;
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT";
              };
              diagnostics = {
                globals = ["vim"];
                disable = ["missing-fields"];
              };
              workspace = {
                checkThirdParty = false;
              };
              completion = {
                callSnippet = "Replace";
              };
              telemetry = {
                enable = false;
              };
            };
          };
        };

        ts_ls = {
          enable = true;
        };

        pyright = {
          enable = true;
        };

        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };

        gopls = {
          enable = true;
        };

        jsonls = {
          enable = true;
        };

        yamlls = {
          enable = true;
        };

        html = {
          enable = true;
        };

        cssls = {
          enable = true;
        };

        bashls = {
          enable = true;
        };

        tailwindcss = {
          enable = true;

          filetypes = [
            "tailwindcss"
            "html"
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
            "svelte"
            "astro"
            "vue"
          ];

          extraOptions = {
            init_options = {
              userLanguages = {
                tailwindcss = "css";
              };
            };
          };
        };
      };
    };

    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
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
          tailwindcss = ["prettier"];
        };
        formatters = {
          nixpkgs_fmt = {
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
          stylua = {
            command = "${pkgs.stylua}/bin/stylua";
          };
          prettier = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
          };
          black = {
            command = "${pkgs.python3Packages.black}/bin/black";
          };
          rustfmt = {
            command = "${pkgs.rustfmt}/bin/rustfmt";
          };
        };
      };
    };

    keymaps = [
      {
        mode = ["n" "v"];
        key = "<leader>cf";
        action = "<cmd>lua require('conform').format({ lsp_format = 'fallback', async = false, timeout_ms = 1000 })<CR>";
        options = {
          desc = "format file or range (in visual mode)";
        };
      }

      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options = {
          desc = "diagnostics (trouble)";
        };
      }

      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options = {
          desc = "buffer diagnostics (trouble)";
        };
      }
    ];

    extraConfigLua = ''
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    '';
  };
}
