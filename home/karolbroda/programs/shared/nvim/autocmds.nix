{...}: {
  programs.nixvim = {
    autoCmd = [
      {
        event = ["TextYankPost"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.highlight.on_yank({
                higroup = "IncSearch",
                timeout = 40,
              })
            end
          '';
        };
        desc = "highlight yanked text";
      }

      {
        event = ["BufReadPost"];
        pattern = "*";
        callback = {
          __raw = ''
            function(event)
              local exclude = { "gitcommit" }
              local buf = event.buf
              if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
                return
              end
              vim.b[buf].lazyvim_last_loc = true
              local mark = vim.api.nvim_buf_get_mark(buf, '"')
              local lcount = vim.api.nvim_buf_line_count(buf)
              if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
              end
            end
          '';
        };
        desc = "go to last loc when opening a buffer";
      }

      {
        event = ["FileType"];
        pattern = [
          "PlenaryTestPopup"
          "help"
          "lspinfo"
          "notify"
          "qf"
          "spectre_panel"
          "startuptime"
          "tsplayground"
          "neotest-output"
          "checkhealth"
          "neotest-summary"
          "neotest-output-panel"
          "dbout"
          "gitsigns.blame"
        ];
        callback = {
          __raw = ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", {
                buffer = event.buf,
                silent = true,
                desc = "Quit buffer",
              })
            end
          '';
        };
        desc = "close some filetypes with <q>";
      }

      {
        event = ["FileType"];
        pattern = ["man"];
        callback = {
          __raw = ''
            function(event)
              vim.bo[event.buf].buflisted = false
            end
          '';
        };
        desc = "make it easier to close man-files when opened inline";
      }

      {
        event = ["FileType"];
        pattern = [
          "*.txt"
          "*.tex"
          "*.typ"
          "gitcommit"
          "markdown"
        ];
        callback = {
          __raw = ''
            function()
              vim.opt_local.wrap = true
              vim.opt_local.spell = true
            end
          '';
        };
        desc = "wrap and check for spell in text filetypes";
      }

      {
        event = ["FileType"];
        pattern = ["json" "jsonc" "json5"];
        callback = {
          __raw = ''
            function()
              vim.opt_local.conceallevel = 0
            end
          '';
        };
        desc = "fix conceallevel for json files";
      }

      {
        event = ["BufWritePre"];
        pattern = "*";
        callback = {
          __raw = ''
            function(event)
              if event.match:match("^%w%w+:[\\/][\\/]") then
                return
              end
              local file = vim.uv.fs_realpath(event.match) or event.match
              vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
            end
          '';
        };
        desc = "auto create dir when saving a file, in case some intermediate directory does not exist";
      }

      {
        event = ["FocusGained" "TermClose" "TermLeave"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              if vim.o.buftype ~= "nofile" then
                vim.cmd("checktime")
              end
            end
          '';
        };
        desc = "reload file when changed on disk";
      }

      {
        event = ["VimResized"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              local current_tab = vim.fn.tabpagenr()
              vim.cmd("tabdo wincmd =")
              vim.cmd("tabnext " .. current_tab)
            end
          '';
        };
        desc = "resize splits if window got resized";
      }

      {
        event = ["BufWinEnter"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.cmd("set formatoptions-=cro")
            end
          '';
        };
        desc = "don't auto commenting new lines";
      }

      {
        event = ["InsertLeave" "WinEnter"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              if vim.w.auto_cursorline then
                vim.wo.cursorline = true
                vim.w.auto_cursorline = nil
              end
            end
          '';
        };
        desc = "show cursor line only in active window";
      }

      {
        event = ["InsertEnter" "WinLeave"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              if vim.wo.cursorline then
                vim.w.auto_cursorline = true
                vim.wo.cursorline = false
              end
            end
          '';
        };
        desc = "hide cursor line on inactive windows";
      }

      {
        event = ["CmdlineEnter"];
        pattern = ["/" "\\?"];
        callback = {
          __raw = ''
            function()
              vim.opt.hlsearch = true
            end
          '';
        };
        desc = "auto toggle hlsearch";
      }

      {
        event = ["CmdlineLeave"];
        pattern = ["/" "\\?"];
        callback = {
          __raw = ''
            function()
              vim.opt.hlsearch = false
            end
          '';
        };
        desc = "auto toggle hlsearch";
      }

      {
        event = ["FileType"];
        pattern = ["gitcommit" "gitrebase"];
        callback = {
          __raw = ''
            function()
              vim.cmd("startinsert!")
            end
          '';
        };
        desc = "start git messages in insert mode";
      }

      {
        event = ["VimResized"];
        pattern = "*";
        command = "wincmd =";
        desc = "automatically equalize splits when vim is resized";
      }

      {
        event = ["FileType"];
        pattern = ["python"];
        callback = {
          __raw = ''
            function()
              vim.opt_local.tabstop = 4
              vim.opt_local.softtabstop = 4
              vim.opt_local.shiftwidth = 4
            end
          '';
        };
        desc = "set indentation to 4 spaces for python";
      }

      {
        event = ["FileType"];
        pattern = ["go"];
        callback = {
          __raw = ''
            function()
              vim.opt_local.tabstop = 4
              vim.opt_local.softtabstop = 4
              vim.opt_local.shiftwidth = 4
              vim.opt_local.expandtab = false
            end
          '';
        };
        desc = "set indentation to 4 spaces for go";
      }

      {
        event = ["InsertLeave"];
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.opt.paste = false
            end
          '';
        };
        desc = "turn off paste mode when leaving insert";
      }

      {
        event = ["FocusGained" "TermClose" "TermLeave"];
        pattern = "*";
        command = "checktime";
        desc = "check if we need to reload the file when it changed";
      }

      {
        event = ["FileType"];
        pattern = [
          "OverseerForm"
          "OverseerList"
          "floggraph"
          "fugitive"
          "git"
          "help"
          "lspinfo"
          "man"
          "notify"
          "qf"
          "query"
          "spectre_panel"
          "startuptime"
          "toggleterm"
          "tsplayground"
          "vim"
        ];
        callback = {
          __raw = ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
            end
          '';
        };
        desc = "windows to close with 'q'";
      }

      {
        event = ["BufRead" "BufNewFile"];
        pattern = ["*/node_modules/*" "node_modules/*"];
        callback = {
          __raw = ''
            function()
              vim.diagnostic.disable(0)
            end
          '';
        };
        desc = "disable diagnostics in node_modules (0 is current buffer only)";
      }

      {
        event = ["BufRead" "BufNewFile"];
        pattern = ["*.txt" "*.md" "*.tex"];
        callback = {
          __raw = ''
            function()
              vim.opt.spell = true
              vim.opt.spelllang = "en_us"
            end
          '';
        };
        desc = "enable spell checking for certain file types";
      }
    ];

    extraConfigLua = ''
      vim.g.loaded_node_provider = 0
      vim.g.loaded_python3_provider = 0
      vim.g.loaded_perl_provider = 0
      vim.g.loaded_ruby_provider = 0

      local is_windows = vim.fn.has("win32") ~= 0
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

      vim.g.markdown_recommended_style = 0
    '';
  };
}
