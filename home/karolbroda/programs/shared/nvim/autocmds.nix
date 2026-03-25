_: let
  # shorthand for the verbose autocmd shape
  autocmd = event: pattern: desc: callback: {
    inherit event pattern desc;
    callback.__raw = callback;
  };

  ftAutocmd = pattern: desc: callback:
    autocmd ["FileType"] pattern desc callback;
in {
  programs.nixvim = {
    autoCmd = [
      (autocmd ["TextYankPost"] "*" "highlight yanked text" ''
        function()
          vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
        end
      '')

      (autocmd ["BufReadPost"] "*" "restore cursor to last position" ''
        function(event)
          local exclude = { "gitcommit" }
          local buf = event.buf
          if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf]._last_loc then
            return
          end
          vim.b[buf]._last_loc = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local lcount = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '')

      (ftAutocmd [
          "PlenaryTestPopup"
          "OverseerForm"
          "OverseerList"
          "checkhealth"
          "dbout"
          "floggraph"
          "fugitive"
          "git"
          "gitsigns.blame"
          "help"
          "lspinfo"
          "man"
          "neotest-output"
          "neotest-output-panel"
          "neotest-summary"
          "notify"
          "noice"
          "qf"
          "query"
          "spectre_panel"
          "startuptime"
          "toggleterm"
          "tsplayground"
          "vim"
        ] "close special filetypes with <q>" ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", {
              buffer = event.buf, silent = true, desc = "quit buffer",
            })
          end
        '')

      (
        ftAutocmd ["gitcommit" "markdown" "text" "tex" "typst"]
        "wrap and spell in text filetypes" ''
          function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
          end
        ''
      )

      (
        ftAutocmd ["json" "jsonc" "json5"]
        "fix conceallevel for json" ''
          function()
            vim.opt_local.conceallevel = 0
          end
        ''
      )

      (autocmd ["BufWritePre"] "*" "auto create parent dirs on save" ''
        function(event)
          if event.match:match("^%w%w+:[\\/][\\/]") then
            return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
      '')

      (
        autocmd ["FocusGained" "TermClose" "TermLeave"] "*"
        "reload file when changed on disk" ''
          function()
            if vim.o.buftype ~= "nofile" then
              vim.cmd("checktime")
            end
          end
        ''
      )

      (autocmd ["VimResized"] "*" "equalize splits on resize" ''
        function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end
      '')

      (autocmd ["BufWinEnter"] "*" "disable auto-commenting new lines" ''
        function()
          vim.cmd("set formatoptions-=cro")
        end
      '')

      (autocmd ["InsertLeave" "WinEnter"] "*" "show cursorline in active window" ''
        function()
          if vim.w.auto_cursorline then
            vim.wo.cursorline = true
            vim.w.auto_cursorline = nil
          end
        end
      '')

      (autocmd ["InsertEnter" "WinLeave"] "*" "hide cursorline on inactive windows" ''
        function()
          if vim.wo.cursorline then
            vim.w.auto_cursorline = true
            vim.wo.cursorline = false
          end
        end
      '')

      (autocmd ["CmdlineEnter"] ["/" "\\?"] "enable hlsearch on search entry" ''
        function() vim.opt.hlsearch = true end
      '')

      (autocmd ["CmdlineLeave"] ["/" "\\?"] "disable hlsearch on search exit" ''
        function() vim.opt.hlsearch = false end
      '')

      (
        ftAutocmd ["gitcommit" "gitrebase"]
        "start git messages in insert mode" ''
          function() vim.cmd("startinsert!") end
        ''
      )

      (ftAutocmd ["python"] "4-space indent for python" ''
        function()
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.shiftwidth = 4
        end
      '')

      (ftAutocmd ["go"] "tabs for go" ''
        function()
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.shiftwidth = 4
          vim.opt_local.expandtab = false
        end
      '')

      (autocmd ["InsertLeave"] "*" "disable paste mode on leave insert" ''
        function() vim.opt.paste = false end
      '')

      (
        autocmd ["BufRead" "BufNewFile"] ["*/node_modules/*"]
        "disable diagnostics in node_modules" ''
          function() vim.diagnostic.disable(0) end
        ''
      )
    ];

    extraConfigLua = ''
      vim.g.loaded_node_provider = 0
      vim.g.loaded_python3_provider = 0
      vim.g.loaded_perl_provider = 0
      vim.g.loaded_ruby_provider = 0
      vim.g.markdown_recommended_style = 0
    '';
  };
}
