{...}: {
  programs.nixvim.plugins.diffview = {
    enable = true;
    settings = {
      enhanced_diff_hl = true;
      view = {
        default = {
          layout = "diff2_horizontal";
          winbar_info = true;
        };
        merge_tool = {
          layout = "diff3_mixed";
          disable_diagnostics = true;
          winbar_info = true;
        };
        file_history = {
          layout = "diff2_horizontal";
          winbar_info = true;
        };
      };
      file_panel = {
        listing_style = "tree";
        tree_options = {
          flatten_dirs = true;
          folder_statuses = "only_folded";
        };
        win_config = {
          position = "left";
          width = 35;
        };
      };
      hooks = {
        diff_buf_read.__raw = ''
          function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.colorcolumn = ""
          end
        '';
      };
    };
  };

  programs.nixvim.plugins.gitsigns = {
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
      signs_staged = {
        add = {text = "▎";};
        change = {text = "▎";};
        delete = {text = "";};
        topdelete = {text = "";};
        changedelete = {text = "▎";};
      };
      current_line_blame = false;
      current_line_blame_opts = {
        virt_text = true;
        virt_text_pos = "eol";
        delay = 300;
      };
      on_attach.__raw = ''
        function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "]h", gs.next_hunk, { desc = "next hunk" })
          map("n", "[h", gs.prev_hunk, { desc = "prev hunk" })
          map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "stage hunk" })
          map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
          map("n", "<leader>ghS", gs.stage_buffer, { desc = "stage buffer" })
          map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
          map("n", "<leader>ghR", gs.reset_buffer, { desc = "reset buffer" })
          map("n", "<leader>ghp", gs.preview_hunk_inline, { desc = "preview hunk inline" })
          map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "blame line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle line blame" })

          -- hunk text object (select a hunk in visual mode with ih)
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunk" })
        end
      '';
    };
  };

  programs.nixvim.keymaps = [
    # diffview — smart toggle opens if closed, closes if open
    {mode = "n"; key = "<leader>gd"; action.__raw = ''
      function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()
        if view then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end
    ''; options.desc = "toggle diffview";}

    # diff against specific refs
    {mode = "n"; key = "<leader>gD"; action = "<cmd>DiffviewOpen HEAD~1<cr>"; options.desc = "diff against last commit";}
    {mode = "n"; key = "<leader>gS"; action = "<cmd>DiffviewOpen --staged<cr>"; options.desc = "diff staged changes";}

    # file history
    {mode = "n"; key = "<leader>gf"; action = "<cmd>DiffviewFileHistory %<cr>"; options.desc = "current file history";}
    {mode = "n"; key = "<leader>gF"; action = "<cmd>DiffviewFileHistory<cr>"; options.desc = "branch file history";}
    {mode = "v"; key = "<leader>gf"; action = "<cmd>'<,'>DiffviewFileHistory<cr>"; options.desc = "selection history";}
  ];
}
