{pkgs, ...}: {
  programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
          "<C-space>" = ["show" "show_documentation" "hide_documentation"];
          "<C-e>" = ["hide"];
          "<CR>" = ["accept" "fallback"];
          "<Tab>" = ["select_next" "snippet_forward" "fallback"];
          "<S-Tab>" = ["select_prev" "snippet_backward" "fallback"];
          "<C-n>" = ["select_next" "fallback"];
          "<C-p>" = ["select_prev" "fallback"];
          "<C-b>" = ["scroll_documentation_up" "fallback"];
          "<C-f>" = ["scroll_documentation_down" "fallback"];
        };
        appearance = {
          use_nvim_cmp_as_default = false;
          nerd_font_variant = "mono";
        };
        completion = {
          accept.auto_brackets.enabled = true;
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
            window.border = "rounded";
          };
          ghost_text.enabled = true;
          list.selection = {
            preselect = true;
            auto_insert = false;
          };
          menu = {
            border = "rounded";
            draw = {
              treesitter = ["lsp"];
              columns = [
                {__unkeyed-1 = "kind_icon";}
                {__unkeyed-1 = "label"; __unkeyed-2 = "label_description"; gap = 1;}
                {__unkeyed-1 = "source_name";}
              ];
            };
          };
        };
        signature = {
          enabled = true;
          window.border = "rounded";
        };
        sources = {
          default = ["lsp" "path" "snippets" "buffer"];
          providers = {
            lsp.score_offset = 1000;
            snippets.score_offset = 750;
            path.score_offset = 500;
            buffer = {
              score_offset = 250;
              min_keyword_length = 3;
            };
          };
        };
        fuzzy.implementation = "prefer_rust";
      };
    };

    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [{
        lazyLoad = true;
        paths = "${pkgs.vimPlugins.friendly-snippets}";
      }];
    };
  };
}
