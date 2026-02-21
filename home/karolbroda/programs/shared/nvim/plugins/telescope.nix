{...}: {
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions.fzf-native.enable = true;

    settings.defaults = {
      prompt_prefix = "  ";
      selection_caret = "> ";
      entry_prefix = "  ";
      multi_icon = "+ ";
      path_display = ["truncate"];
      sorting_strategy = "ascending";
      results_title = false;
      layout_config = {
        horizontal = {
          prompt_position = "top";
          preview_width = 0.55;
        };
        width = 0.87;
        height = 0.80;
      };
      file_ignore_patterns = [
        "^.git/"
        "^.mypy_cache/"
        "^__pycache__/"
        "^output/"
        "^data/"
        "^node_modules/"
        "%.ipynb"
      ];
      mappings.i = {
        "<C-j>".__raw = "require('telescope.actions').move_selection_next";
        "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
        "<C-q>".__raw = ''
          function(...)
            require('telescope.actions').send_to_qflist(...)
            require('telescope.actions').open_qflist(...)
          end
        '';
      };
    };

    keymaps = {
      # files
      "<leader>ff" = {
        action = "find_files";
        options.desc = "find files";
      };
      "<leader>fg" = {
        action = "live_grep";
        options.desc = "grep in cwd";
      };
      "<leader>fb" = {
        action = "buffers";
        options.desc = "buffers";
      };
      "<leader>fh" = {
        action = "help_tags";
        options.desc = "help pages";
      };
      "<leader>fr" = {
        action = "oldfiles";
        options.desc = "recent files";
      };
      "<leader>fw" = {
        action = "grep_string";
        options.desc = "grep word under cursor";
      };
      "<leader>fd" = {
        action = "diagnostics";
        options.desc = "diagnostics";
      };

      # lsp
      "<leader>fs" = {
        action = "lsp_document_symbols";
        options.desc = "document symbols";
      };
      "<leader>fS" = {
        action = "lsp_dynamic_workspace_symbols";
        options.desc = "workspace symbols";
      };

      # git
      "<leader>gc" = {
        action = "git_commits";
        options.desc = "git commits";
      };
      "<leader>gs" = {
        action = "git_status";
        options.desc = "git status";
      };

      # search
      "<leader>sk" = {
        action = "keymaps";
        options.desc = "keymaps";
      };
      "<leader>sm" = {
        action = "marks";
        options.desc = "marks";
      };
      "<leader>sr" = {
        action = "resume";
        options.desc = "resume last search";
      };
    };
  };
}
