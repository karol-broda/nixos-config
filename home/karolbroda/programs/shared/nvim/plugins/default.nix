{pkgs, ...}: {
  programs.nixvim.plugins = {
    nvim-tree = {
      enable = true;
      settings = {
        auto_reload_on_write = true;
        disable_netrw = true;
        hijack_netrw = true;
        hijack_cursor = true;
        update_focused_file = {
          enable = true;
          update_root = false;
        };
        diagnostics = {
          enable = true;
          show_on_dirs = true;
        };
        view = {
          width = 30;
          side = "left";
        };
        renderer = {
          group_empty = true;
          highlight_git = true;
          icons = {
            show = {
              file = true;
              folder = true;
              folder_arrow = true;
              git = true;
            };
          };
        };
      };
    };

    lualine = {
      enable = true;
      settings = {
        options = {
          globalstatus = true;
          theme = "catppuccin";
        };
        sections = {
          lualine_a = ["mode"];
          lualine_b = ["branch" "diff" "diagnostics"];
          lualine_c = ["filename"];
          lualine_x = ["encoding" "fileformat" "filetype"];
          lualine_y = ["progress"];
          lualine_z = ["location"];
        };
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
        highlights = {
          fill = {bg = "NONE";};
          background = {bg = "NONE";};
          tab = {bg = "NONE";};
          tab_selected = {bg = "NONE";};
          tab_separator = {bg = "NONE";};
          tab_separator_selected = {bg = "NONE";};
          separator = {bg = "NONE";};
          separator_visible = {bg = "NONE";};
          separator_selected = {bg = "NONE";};
          buffer_visible = {bg = "NONE";};
          buffer_selected = {bg = "NONE";};
        };
      };
    };

    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent = {
          enable = true;
        };
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
        enable = true;
        maxLines = 0;
        minWindowHeight = 0;
        lineNumbers = true;
        multilineThreshold = 20;
        trimScope = "outer";
        mode = "cursor";
        separator = null;
        zindex = 20;
      };
    };

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };
        completion = {
          completeopt = "menu,menuone,noselect";
        };
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = ''
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require('luasnip').expand_or_jumpable() then
                require('luasnip').expand_or_jump()
              else
                fallback()
              end
            end
          '';
          "<S-Tab>" = ''
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require('luasnip').jumpable(-1) then
                require('luasnip').jump(-1)
              else
                fallback()
              end
            end
          '';
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "buffer";}
          {name = "path";}
        ];
        formatting = {
          format = ''
            function(entry, vim_item)
              local icons = {
                Text = "",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = ""
              }
              vim_item.kind = string.format('%s %s', icons[vim_item.kind] or "", vim_item.kind)
              vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end
          '';
        };
      };
    };

    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;

    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [
        {
          lazyLoad = true;
          paths = "${pkgs.vimPlugins.friendly-snippets}";
        }
      ];
    };

    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {text = "▎";};
          change = {text = "▎";};
          delete = {text = "";};
          topdelete = {text = "";};
          changedelete = {text = "▎";};
          untracked = {text = "▎";};
        };
      };
    };

    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          prompt_prefix = " ";
          selection_caret = " ";
          path_display = ["truncate"];
          file_ignore_patterns = [
            "^.git/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
          ];
        };
      };
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "find files";
          };
        };
        "<leader>fg" = {
          action = "live_grep";
          options = {
            desc = "find string in cwd";
          };
        };
        "<leader>fb" = {
          action = "buffers";
          options = {
            desc = "buffers";
          };
        };
        "<leader>fh" = {
          action = "help_tags";
          options = {
            desc = "help pages";
          };
        };
        "<leader>fr" = {
          action = "oldfiles";
          options = {
            desc = "recent files";
          };
        };
      };
    };

    which-key = {
      enable = true;
      settings = {
        delay = 200;
        expand = 1;
        notify = false;
        preset = "classic";
        spec = [
          {
            __unkeyed-1 = "<leader>b";
            group = "buffer";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "code";
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "file/find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "git";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "windows";
          }
        ];
      };
    };

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

    comment = {
      enable = true;
      settings = {
        sticky = true;
        ignore = "^$";
        toggler = {
          line = "gcc";
          block = "gbc";
        };
        opleader = {
          line = "gc";
          block = "gb";
        };
      };
    };

    indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "│";
          tab_char = "│";
        };
        scope = {
          enabled = false;
        };
        exclude = {
          filetypes = [
            "help"
            "alpha"
            "dashboard"
            "neo-tree"
            "Trouble"
            "trouble"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "lazyterm"
          ];
        };
      };
    };

    nvim-surround = {
      enable = true;
    };

    alpha = {
      enable = true;
      settings.layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            "        ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          "
            "         ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       "
            "               ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     "
            "                ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    "
            "               ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   "
            "        ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  "
            "       ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   "
            "      ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  "
            "      ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ "
            "           ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     "
            "            ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     "
            ""
            "                   · neovim ·                   "
          ];
          opts = {
            position = "center";
            hl = "String";
          };
        }
        {
          type = "text";
          val = {
            __raw = ''
              (function()
                local taglines = {
                  "embrace the flow",
                  "edit. think. flow.",
                  "modal mastery",
                  "keystrokes matter",
                  "think in motions",
                  "where text meets thought",
                }
                math.randomseed(os.time() + 1)
                local selected = taglines[math.random(#taglines)]
                return { "- " .. selected .. " -" }
              end)()
            '';
          };
          opts = {
            position = "center";
            hl = "String";
          };
        }
        {
          type = "padding";
          val = 1;
        }
        {
          type = "text";
          val = {
            __raw = ''
              (function()
                local quotes = {
                  "\"when in doubt, use brute force\" - ken thompson",
                  "\"someone is sitting in the shade today because someone planted a tree a long time ago\" - warren buffett",
                  "\"premature optimization is the root of all evil\" - donald knuth",
                  "\"nine people can't make a baby in one month\" - fred brooks",
                  "\"make everything as simple as possible, but not simpler\" - albert einstein",
                  "\"talk is cheap. show me the code\" - linus torvalds",
                  "\"a language that doesn't affect the way you think about programming is not worth knowing\" - alan perlis",
                }
                math.randomseed(os.time())
                local selected = quotes[math.random(#quotes)]
                return { "  " .. selected }
              end)()
            '';
          };
          opts = {
            position = "center";
            hl = "Comment";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = "  find files";
              on_press = {
                __raw = "function() require('telescope.builtin').find_files() end";
              };
              opts = {
                keymap = ["n" "ff" ":Telescope find_files <CR>" {}];
                shortcut = "SPC f f";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = "  recent files";
              on_press = {
                __raw = "function() require('telescope.builtin').oldfiles() end";
              };
              opts = {
                keymap = ["n" "fr" ":Telescope oldfiles <CR>" {}];
                shortcut = "SPC f r";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = "󰱼  find text";
              on_press = {
                __raw = "function() require('telescope.builtin').live_grep() end";
              };
              opts = {
                keymap = ["n" "fg" ":Telescope live_grep <CR>" {}];
                shortcut = "SPC f g";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = "  file explorer";
              on_press = {
                __raw = "function() vim.cmd('NvimTreeToggle') end";
              };
              opts = {
                keymap = ["n" "ee" ":NvimTreeToggle <CR>" {}];
                shortcut = "SPC e e";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = "  new file";
              on_press = {
                __raw = "function() vim.cmd('ene | startinsert') end";
              };
              opts = {
                keymap = ["n" "fn" ":ene <BAR> startinsert <CR>" {}];
                shortcut = "SPC f n";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = " configuration";
              on_press = {
                __raw = "function() require('telescope.builtin').find_files({cwd = '~/nix-config'}) end";
              };
              opts = {
                keymap = ["n" "fc" ":Telescope find_files cwd=~/nix-config<CR>" {}];
                shortcut = "SPC f c";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = "  quit neovim";
              on_press = {
                __raw = "function() vim.cmd('qa') end";
              };
              opts = {
                keymap = ["n" "qq" ":qa<CR>" {}];
                shortcut = "SPC q q";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
          ];
        }
        {
          type = "padding";
          val = 1;
        }
      ];
    };

    trouble = {
      enable = true;
      settings = {
        auto_open = false;
        auto_close = false;
        auto_preview = true;
        auto_refresh = true;
        auto_jump = false;
        focus = false;
        restore = true;
        follow = true;
        indent_guides = true;
        max_items = 200;
        multiline = true;
        pinned = false;
        warn_no_results = true;
        open_no_results = false;
      };
    };

    web-devicons = {
      enable = true;
    };

    direnv = {};

    notify = {
      enable = true;
      settings = {
        background_colour = "#000000";
        fps = 30;
        level = 2;
        minimum_width = 50;
        render = "default";
        stages = "fade_in_slide_out";
        timeout = 5000;
        top_down = true;
      };
    };
  };
}
