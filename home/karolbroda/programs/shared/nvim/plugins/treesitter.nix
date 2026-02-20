{...}: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight = {enable = true; additional_vim_regex_highlighting = false;};
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = "<c-s>";
            node_decremental = "<m-space>";
          };
        };
      };
    };

    treesitter-context = {
      enable = true;
      settings = {
        maxLines = 3;
        lineNumbers = true;
        multilineThreshold = 20;
        trimScope = "outer";
        mode = "cursor";
      };
    };

    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]f" = "@function.outer";
            "]c" = "@class.outer";
            "]a" = "@parameter.inner";
          };
          goto_next_end = {
            "]F" = "@function.outer";
            "]C" = "@class.outer";
          };
          goto_previous_start = {
            "[f" = "@function.outer";
            "[c" = "@class.outer";
            "[a" = "@parameter.inner";
          };
          goto_previous_end = {
            "[F" = "@function.outer";
            "[C" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swap_next."<leader>na" = "@parameter.inner";
          swap_previous."<leader>pa" = "@parameter.inner";
        };
      };
    };
  };
}
