{...}: {
  programs.nixvim.plugins = {
    lualine = {
      enable = true;
      settings = {
        options = {
          globalstatus = true;
          theme = "catppuccin";
          component_separators = {left = ""; right = "";};
          section_separators = {left = ""; right = "";};
          disabled_filetypes.statusline = ["alpha" "dashboard"];
        };
        sections = {
          lualine_a = ["mode"];
          lualine_b = ["branch"];
          lualine_c = [
            {__unkeyed-1 = "diagnostics"; symbols = {error = " "; warn = " "; info = " "; hint = " ";};}
            {__unkeyed-1 = "filetype"; icon_only = true; separator = ""; padding = {left = 1; right = 0;};}
            {__unkeyed-1 = "filename"; path = 1; symbols = {modified = " "; readonly = " "; unnamed = "";};}
          ];
          lualine_x = [
            {__unkeyed-1 = "diff"; symbols = {added = " "; modified = " "; removed = " ";};}
          ];
          lualine_y = [
            "progress"
          ];
          lualine_z = [
            "location"
          ];
        };
        extensions = ["nvim-tree" "trouble" "toggleterm"];
      };
    };

    bufferline = {
      enable = true;
      settings = {
        options = {
          mode = "buffers";
          separator_style = "thin";
          always_show_bufferline = true;
          show_buffer_close_icons = false;
          show_close_icon = false;
          color_icons = true;
          diagnostics = "nvim_lsp";
        };
        # transparent backgrounds to match catppuccin
        highlights = let bg = {bg = "NONE";}; in {
          fill = bg;
          background = bg;
          tab = bg;
          tab_selected = bg;
          tab_separator = bg;
          tab_separator_selected = bg;
          separator = bg;
          separator_visible = bg;
          separator_selected = bg;
          buffer_visible = bg;
          buffer_selected = bg;
        };
      };
    };

    indent-blankline = {
      enable = true;
      settings = {
        indent = {char = "│"; tab_char = "│";};
        scope.enabled = false;
        exclude.filetypes = [
          "help" "alpha" "dashboard" "Trouble" "trouble"
          "notify" "toggleterm"
        ];
      };
    };

    nvim-tree = {
      enable = true;
      settings = {
        disable_netrw = true;
        hijack_netrw = true;
        hijack_cursor = true;
        update_focused_file = {enable = true; update_root = false;};
        diagnostics = {enable = true; show_on_dirs = true;};
        view = {
          width = 30;
          side = "left";
        };
        renderer = {
          group_empty = true;
          highlight_git = true;
          icons.show = {file = true; folder = true; folder_arrow = true; git = true;};
        };
        on_attach.__raw = ''
          function(bufnr)
            local api = require("nvim-tree.api")
            api.config.mappings.default_on_attach(bufnr)
            -- force transparent background in the tree window
            vim.wo[0].winhighlight = "Normal:NvimTreeNormal,NormalNC:NvimTreeNormalNC,EndOfBuffer:NvimTreeEndOfBuffer,WinSeparator:NvimTreeWinSeparator"
          end
        '';
      };
    };

    # edit filesystem as a buffer
    oil = {
      enable = true;
      settings = {
        view_options.show_hidden = true;
        float = {
          padding = 2;
          max_width = 120;
          max_height = 40;
          border = "rounded";
        };
        keymaps = {
          "g?" = "actions.show_help";
          "<CR>" = "actions.select";
          "<C-v>" = "actions.select_vsplit";
          "<C-s>" = "actions.select_split";
          "<C-t>" = "actions.select_tab";
          "<C-p>" = "actions.preview";
          "q" = "actions.close";
          "<C-r>" = "actions.refresh";
          "-" = "actions.parent";
          "_" = "actions.open_cwd";
          "gs" = "actions.change_sort";
          "gx" = "actions.open_external";
          "g." = "actions.toggle_hidden";
          "g\\\\" = "actions.toggle_trash";
        };
      };
    };

    trouble = {
      enable = true;
      settings = {
        auto_preview = true;
        auto_refresh = true;
        follow = true;
        indent_guides = true;
        multiline = true;
      };
    };

    # better vim.ui.select and vim.ui.input
    dressing = {
      enable = true;
      settings = {
        input = {
          enabled = true;
          border = "rounded";
          prefer_width = 50;
          win_options.winblend = 0;
        };
        select = {
          enabled = true;
          backend = ["telescope" "builtin"];
        };
      };
    };

    web-devicons.enable = true;
    direnv.enable = true;

    # floating notifications
    notify = {
      enable = true;
      settings = {
        background_colour = "#000000";
        level = 2;
        minimum_width = 50;
        render = "compact";
        stages = "fade_in_slide_out";
        timeout = 3000;
        top_down = true;
      };
    };

    # modern cmdline, messages, and popups
    noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          lsp_doc_border = true;
        };
        routes = [{
          filter = {
            event = "msg_show";
            any = [
              {find = "%d+L, %d+B";}
              {find = "; after #%d+";}
              {find = "; before #%d+";}
            ];
          };
          view = "mini";
        }];
      };
    };

    # lsp progress spinner
    fidget = {
      enable = true;
      settings = {
        progress.display = {
          done_icon = "✓";
          progress_icon = {
            pattern = "dots";
            period = 1;
          };
        };
        notification.window = {
          winblend = 0;
          normal_hl = "Comment";
        };
      };
    };

    # inline color previews
    colorizer = {
      enable = true;
      settings = {
        user_default_options = {
          RGB = true;
          RRGGBB = true;
          RRGGBBAA = true;
          css = true;
          css_fn = true;
          tailwind = true;
          mode = "background";
          virtualtext = "■";
        };
        filetypes = ["*" "!alpha"];
      };
    };

    # pretty markdown rendering
    render-markdown = {
      enable = true;
      settings = {
        enabled = true;
        render_modes = true;
        heading = {
          enabled = true;
          icons = ["# " "## " "### " "#### " "##### " "###### "];
        };
        code = {
          enabled = true;
          sign = false;
          width = "full";
          right_pad = 2;
        };
        bullet = {
          enabled = true;
        };
        checkbox = {
          enabled = true;
        };
        pipe_table = {
          enabled = true;
          style = "full";
        };
      };
    };

    # keymap hint popup
    which-key = {
      enable = true;
      settings = {
        delay = 300;
        expand = 1;
        notify = false;
        preset = "classic";
        spec = [
          {__unkeyed-1 = "<leader>a"; group = "ai";}
          {__unkeyed-1 = "<leader>b"; group = "buffer";}
          {__unkeyed-1 = "<leader>c"; group = "code";}
          {__unkeyed-1 = "<leader>f"; group = "file/find";}
          {__unkeyed-1 = "<leader>g"; group = "git";}
          {__unkeyed-1 = "<leader>gh"; group = "hunks";}
          {__unkeyed-1 = "<leader>n"; group = "notifications";}
          {__unkeyed-1 = "<leader>q"; group = "session";}
          {__unkeyed-1 = "<leader>s"; group = "search";}
          {__unkeyed-1 = "<leader>u"; group = "ui";}
          {__unkeyed-1 = "<leader>w"; group = "windows";}
          {__unkeyed-1 = "<leader>x"; group = "diagnostics/quickfix";}
          {__unkeyed-1 = "<leader><tab>"; group = "tabs";}
        ];
      };
    };

    # highlight TODO/FIXME/etc
    todo-comments = {
      enable = true;
      settings = {
        signs = true;
        highlight = {
          multiline = true;
          keyword = "wide";
          after = "fg";
          pattern = ''.*<(KEYWORDS)\s*:'';
          comments_only = true;
        };
      };
    };
  };

  programs.nixvim.keymaps = [
    # todo-comments
    {mode = "n"; key = "<leader>st"; action = "<cmd>TodoTelescope<cr>"; options.desc = "search todos";}
    {mode = "n"; key = "]t"; action = ''function() require("todo-comments").jump_next() end''; options.desc = "next todo";}
    {mode = "n"; key = "[t"; action = ''function() require("todo-comments").jump_prev() end''; options.desc = "prev todo";}

    # notifications
    {mode = "n"; key = "<leader>un"; action = ''function() require("notify").dismiss({ silent = true, pending = true }) end''; options.desc = "dismiss all notifications";}

    # noice
    {mode = "n"; key = "<leader>sn"; action = "<cmd>Noice telescope<cr>"; options.desc = "search notifications (noice)";}
    {mode = "n"; key = "<leader>nd"; action = "<cmd>Noice dismiss<cr>"; options.desc = "dismiss noice message";}
    {mode = "n"; key = "<leader>nl"; action = "<cmd>Noice last<cr>"; options.desc = "last noice message";}
    {mode = "n"; key = "<leader>nh"; action = "<cmd>Noice history<cr>"; options.desc = "noice history";}
  ];
}
