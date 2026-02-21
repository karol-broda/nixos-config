{...}: {
  programs.nixvim = {
    plugins = {
      nvim-autopairs = {
        enable = true;
        settings = {
          checkTs = true;
          tsConfig = {
            lua = ["string" "source"];
            javascript = ["string" "template_string"];
          };
        };
      };

      # treesitter-aware commenting (handles JSX, Vue, etc.)
      ts-comments = {
        enable = true;
      };

      nvim-surround.enable = true;

      flash = {
        enable = true;
        settings = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
          modes = {
            char.jump_labels = true;
            search.enabled = false;
          };
          jump.autojump = true;
          label.uppercase = false;
        };
      };

      illuminate = {
        enable = true;
        settings = {
          under_cursor = true;
          filetypes_denylist = ["alpha" "NvimTree" "Trouble" "toggleterm"];
          large_file_cutoff = 2000;
          large_file_overrides.providers = ["lsp"];
        };
      };

      # session management
      persistence = {
        enable = true;
      };

      mini = {
        enable = true;
        modules = {
          indentscope = {
            symbol = "│";
            options.try_as_border = true;
            draw = {
              delay = 0;
              animation.__raw = ''require("mini.indentscope").gen_animation.none()'';
            };
          };
          ai.n_lines = 500;
        };
      };
    };

    keymaps = [
      # flash
      {
        mode = ["n" "x" "o"];
        key = "s";
        action = ''function() require("flash").jump() end'';
        options.desc = "flash";
      }
      {
        mode = ["n" "x" "o"];
        key = "S";
        action = ''function() require("flash").treesitter() end'';
        options.desc = "flash treesitter";
      }
      {
        mode = "o";
        key = "r";
        action = ''function() require("flash").remote() end'';
        options.desc = "remote flash";
      }
      {
        mode = ["o" "x"];
        key = "R";
        action = ''function() require("flash").treesitter_search() end'';
        options.desc = "treesitter search";
      }

      # persistence (session management)
      {
        mode = "n";
        key = "<leader>qs";
        action = ''function() require("persistence").load() end'';
        options.desc = "restore session";
      }
      {
        mode = "n";
        key = "<leader>qS";
        action = ''function() require("persistence").select() end'';
        options.desc = "select session";
      }
      {
        mode = "n";
        key = "<leader>ql";
        action = ''function() require("persistence").load({ last = true }) end'';
        options.desc = "restore last session";
      }
      {
        mode = "n";
        key = "<leader>qd";
        action = ''function() require("persistence").stop() end'';
        options.desc = "stop session recording";
      }
    ];
  };
}
