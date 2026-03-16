{pkgs, ...}: {
  home.packages = [
    (pkgs.runCommand "zed" {} ''
      mkdir -p $out/bin
      ln -s ${pkgs.zed-editor}/bin/zeditor $out/bin/zed
    '')
  ];

  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;

    extensions = [
      "nix"
      "rust"
      "python"
      "go"
      "typescript"
      "json"
      "yaml"
      "toml"
      "dockerfile"
      "markdown"
      "mdx"
      "java"
      "lean4"
      "zig"
      "git-firefly"
      "qml"
      "assembly"
    ];

    userSettings = {
      telemetry.metrics = false;
      features.copilot = false;

      vim_mode = true;
      vim = {
        use_smartcase_find = true;
        toggle_relative_line_numbers = true;
      };
      ui_font_size = 15;
      buffer_font_size = 14;

      confirm_quit = true;
      auto_update = true;

      trim_trailing_whitespace_on_save = true;
      insert_final_newline_on_save = true;

      load_direnv = "direct";

      relative_line_numbers = true;

      format_on_save = "on";

      lsp = {
        nil = {
          initialization_options = {
            formatting = {
              command = [
                "alejandra"
                "--quiet"
                "--"
              ];
            };
          };
        };
      };
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-t" = "workspace::NewTerminal";
          "ctrl-p" = "file_finder::Toggle";
          "ctrl-s" = "workspace::Save";
        };
      }

      {
        context = "Editor";
        bindings = {
          "alt-up" = "editor::MoveLineUp";
          "alt-down" = "editor::MoveLineDown";
          "alt-k" = "editor::MoveLineUp";
          "alt-j" = "editor::MoveLineDown";
        };
      }

      {
        context = "vim_mode == insert";
        bindings = {
          "j k" = "vim::NormalBefore";
          "ctrl-s" = "workspace::Save";
        };
      }

      {
        context = "Editor && vim_mode == normal";
        bindings = {
          "space f f" = "file_finder::Toggle";
          "space f g" = "workspace::NewSearch";
          "space f n" = "workspace::NewFile";

          "space e" = "project_panel::ToggleFocus";
          "space o" = "project_panel::ToggleFocus";

          "space n h" = "search::SelectAllMatches";

          "shift-h" = "pane::ActivatePrevItem";
          "shift-l" = "pane::ActivateNextItem";
          "[ b" = "pane::ActivatePrevItem";
          "] b" = "pane::ActivateNextItem";
          "space b b" = "pane::AlternateFile";
          "space b d" = "pane::CloseActiveItem";
          "space b shift-d" = "pane::CloseActiveItem";

          "space c d" = "editor::Hover";
          "] e" = "editor::GoToDiagnostic";
          "[ e" = "editor::GoToPrevDiagnostic";

          "space x l" = "diagnostics::Deploy";
          "space x q" = "diagnostics::Deploy";
          "[ q" = "editor::GoToPrevDiagnostic";
          "] q" = "editor::GoToDiagnostic";

          "space w" = "pane::SplitRight";
          "space -" = "pane::SplitDown";
          "space |" = "pane::SplitRight";
          "space w d" = "pane::CloseActiveItem";

          "space tab l" = "pane::ActivateLastItem";
          "space tab f" = [
            "pane::ActivateItem"
            0
          ];
          "space tab tab" = "workspace::NewFile";
          "space tab ]" = "pane::ActivateNextItem";
          "space tab [" = "pane::ActivatePrevItem";
          "space tab d" = "pane::CloseActiveItem";

          "space y" = "editor::Copy";
          "space shift-y" = "editor::Copy";

          "space c a" = "editor::ToggleCodeActions";
          "space r n" = "editor::Rename";
          "g r" = "editor::FindAllReferences";
        };
      }

      {
        context = "vim_mode == visual";
        bindings = {
          "shift-s" = "vim::PushAddSurrounds";

          "alt-j" = "editor::MoveLineDown";
          "alt-k" = "editor::MoveLineUp";

          "space y" = "editor::Copy";
        };
      }

      {
        context = "VimControl && !menu";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-j" = "workspace::ActivatePaneDown";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-l" = "workspace::ActivatePaneRight";
        };
      }

      {
        context = "Dock";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-j" = "workspace::ActivatePaneDown";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-l" = "workspace::ActivatePaneRight";
        };
      }

      {
        context = "Terminal";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-j" = "workspace::ActivatePaneDown";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-l" = "workspace::ActivatePaneRight";
        };
      }
    ];
  };
}
