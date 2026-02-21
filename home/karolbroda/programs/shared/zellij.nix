{
  pkgs,
  pkgs-unstable,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  copyCmd =
    if isDarwin
    then "pbcopy"
    else "wl-copy";
in {
  programs.zellij = {
    enable = true;
    package = pkgs-unstable.zellij;

    settings = {
      theme = "catppuccin-frappe";
      default_shell = "zsh";
      copy_command = copyCmd;
      copy_clipboard = "primary";
      copy_on_select = true;
      scrollback_editor = "nvim";
      mirror_session = true;
      mouse_mode = true;
      pane_frames = true;
      auto_layout = true;
      show_startup_tips = false;

      keybinds = {
        _props.clear-defaults = true;

        normal._children = [
          {
            bind = {
              _args = ["Alt h"];
              MoveFocus = ["Left"];
            };
          }
          {
            bind = {
              _args = ["Alt j"];
              MoveFocus = ["Down"];
            };
          }
          {
            bind = {
              _args = ["Alt k"];
              MoveFocus = ["Up"];
            };
          }
          {
            bind = {
              _args = ["Alt l"];
              MoveFocus = ["Right"];
            };
          }

          {
            bind = {
              _args = ["Alt n"];
              NewPane = ["Down"];
            };
          }
          {
            bind = {
              _args = ["Alt m"];
              NewPane = ["Right"];
            };
          }
          {
            bind = {
              _args = ["Alt d"];
              _children = [{CloseFocus = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt f"];
              _children = [{ToggleFocusFullscreen = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt z"];
              _children = [{TogglePaneFrames = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt Space"];
              _children = [{ToggleFloatingPanes = {};}];
            };
          }

          {
            bind = {
              _args = ["Alt H"];
              _children = [{Resize = {"Left" = {};};}];
            };
          }
          {
            bind = {
              _args = ["Alt J"];
              _children = [{Resize = {"Down" = {};};}];
            };
          }
          {
            bind = {
              _args = ["Alt K"];
              _children = [{Resize = {"Up" = {};};}];
            };
          }
          {
            bind = {
              _args = ["Alt L"];
              _children = [{Resize = {"Right" = {};};}];
            };
          }

          {
            bind = {
              _args = ["Ctrl Alt h"];
              _children = [{MovePane = {};}];
            };
          }
          {
            bind = {
              _args = ["Ctrl Alt j"];
              _children = [{MovePane = {};}];
            };
          }
          {
            bind = {
              _args = ["Ctrl Alt k"];
              _children = [{MovePane = {};}];
            };
          }
          {
            bind = {
              _args = ["Ctrl Alt l"];
              _children = [{MovePane = {};}];
            };
          }

          {
            bind = {
              _args = ["Alt t"];
              _children = [{NewTab = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt w"];
              _children = [{CloseTab = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt Tab"];
              _children = [{GoToNextTab = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt Shift Tab"];
              _children = [{GoToPreviousTab = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt 1"];
              GoToTab = [1];
            };
          }
          {
            bind = {
              _args = ["Alt 2"];
              GoToTab = [2];
            };
          }
          {
            bind = {
              _args = ["Alt 3"];
              GoToTab = [3];
            };
          }
          {
            bind = {
              _args = ["Alt 4"];
              GoToTab = [4];
            };
          }
          {
            bind = {
              _args = ["Alt 5"];
              GoToTab = [5];
            };
          }
          {
            bind = {
              _args = ["Alt 6"];
              GoToTab = [6];
            };
          }
          {
            bind = {
              _args = ["Alt 7"];
              GoToTab = [7];
            };
          }
          {
            bind = {
              _args = ["Alt 8"];
              GoToTab = [8];
            };
          }
          {
            bind = {
              _args = ["Alt 9"];
              GoToTab = [9];
            };
          }

          {
            bind = {
              _args = ["Alt s"];
              SwitchToMode = ["Scroll"];
            };
          }
          {
            bind = {
              _args = ["Alt /"];
              SwitchToMode = ["EnterSearch"];
            };
          }
          {
            bind = {
              _args = ["Alt ?"];
              _children = [{SearchToggleOption = "CaseSensitivity";}];
            };
          }

          {
            bind = {
              _args = ["Alt o"];
              SwitchToMode = ["Session"];
            };
          }
          {
            bind = {
              _args = ["Alt r"];
              SwitchToMode = ["RenameTab"];
            };
          }

          {
            bind = {
              _args = ["Ctrl p"];
              SwitchToMode = ["Pane"];
            };
          }
          {
            bind = {
              _args = ["Ctrl t"];
              SwitchToMode = ["Tab"];
            };
          }
          {
            bind = {
              _args = ["Ctrl n"];
              SwitchToMode = ["Resize"];
            };
          }
          {
            bind = {
              _args = ["Ctrl h"];
              SwitchToMode = ["Move"];
            };
          }
          {
            bind = {
              _args = ["Ctrl s"];
              SwitchToMode = ["Scroll"];
            };
          }
          {
            bind = {
              _args = ["Ctrl o"];
              SwitchToMode = ["Session"];
            };
          }

          {
            bind = {
              _args = ["Alt ="];
              _children = [{TogglePaneEmbedOrFloating = {};}];
            };
          }
          {
            bind = {
              _args = ["Alt -"];
              _children = [{UndoRenameTab = {};}];
            };
          }
          {
            bind = {
              _args = ["F11"];
              _children = [{ToggleFocusFullscreen = {};}];
            };
          }
        ];

        pane._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["h"];
              MoveFocus = ["Left"];
            };
          }
          {
            bind = {
              _args = ["j"];
              MoveFocus = ["Down"];
            };
          }
          {
            bind = {
              _args = ["k"];
              MoveFocus = ["Up"];
            };
          }
          {
            bind = {
              _args = ["l"];
              MoveFocus = ["Right"];
            };
          }
          {
            bind = {
              _args = ["n"];
              NewPane = ["Down"];
            };
          }
          {
            bind = {
              _args = ["m"];
              NewPane = ["Right"];
            };
          }
          {
            bind = {
              _args = ["d"];
              _children = [{CloseFocus = {};}];
            };
          }
          {
            bind = {
              _args = ["f"];
              _children = [{ToggleFocusFullscreen = {};}];
            };
          }
          {
            bind = {
              _args = ["z"];
              _children = [{TogglePaneFrames = {};}];
            };
          }
          {
            bind = {
              _args = ["Space"];
              _children = [{ToggleFloatingPanes = {};}];
            };
          }
        ];

        tab._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["h"];
              _children = [{GoToPreviousTab = {};}];
            };
          }
          {
            bind = {
              _args = ["l"];
              _children = [{GoToNextTab = {};}];
            };
          }
          {
            bind = {
              _args = ["n"];
              _children = [{NewTab = {};}];
            };
          }
          {
            bind = {
              _args = ["x"];
              _children = [{CloseTab = {};}];
            };
          }
          {
            bind = {
              _args = ["r"];
              SwitchToMode = ["RenameTab"];
            };
          }
          {
            bind = {
              _args = ["1"];
              GoToTab = [1];
            };
          }
          {
            bind = {
              _args = ["2"];
              GoToTab = [2];
            };
          }
          {
            bind = {
              _args = ["3"];
              GoToTab = [3];
            };
          }
          {
            bind = {
              _args = ["4"];
              GoToTab = [4];
            };
          }
          {
            bind = {
              _args = ["5"];
              GoToTab = [5];
            };
          }
          {
            bind = {
              _args = ["6"];
              GoToTab = [6];
            };
          }
          {
            bind = {
              _args = ["7"];
              GoToTab = [7];
            };
          }
          {
            bind = {
              _args = ["8"];
              GoToTab = [8];
            };
          }
          {
            bind = {
              _args = ["9"];
              GoToTab = [9];
            };
          }
        ];

        resize._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["h"];
              _children = [{Resize = {"Left" = {};};}];
            };
          }
          {
            bind = {
              _args = ["j"];
              _children = [{Resize = {"Down" = {};};}];
            };
          }
          {
            bind = {
              _args = ["k"];
              _children = [{Resize = {"Up" = {};};}];
            };
          }
          {
            bind = {
              _args = ["l"];
              _children = [{Resize = {"Right" = {};};}];
            };
          }
          {
            bind = {
              _args = ["H"];
              _children = [{Resize = {"Left" = {};};}];
            };
          }
          {
            bind = {
              _args = ["J"];
              _children = [{Resize = {"Down" = {};};}];
            };
          }
          {
            bind = {
              _args = ["K"];
              _children = [{Resize = {"Up" = {};};}];
            };
          }
          {
            bind = {
              _args = ["L"];
              _children = [{Resize = {"Right" = {};};}];
            };
          }
          {
            bind = {
              _args = ["+"];
              _children = [{Resize = {"Increase" = {};};}];
            };
          }
          {
            bind = {
              _args = ["-"];
              _children = [{Resize = {"Decrease" = {};};}];
            };
          }
        ];

        move._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["h"];
              _children = [{MovePane = {};}];
            };
          }
          {
            bind = {
              _args = ["j"];
              _children = [{MovePane = {};}];
            };
          }
          {
            bind = {
              _args = ["k"];
              _children = [{MovePane = {};}];
            };
          }
          {
            bind = {
              _args = ["l"];
              _children = [{MovePane = {};}];
            };
          }
          {
            bind = {
              _args = ["n"];
              _children = [{MovePaneBackwards = {};}];
            };
          }
          {
            bind = {
              _args = ["p"];
              _children = [{MovePaneBackwards = {};}];
            };
          }
        ];

        scroll._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["e"];
              _children = [{EditScrollback = {};}];
            };
          }
          {
            bind = {
              _args = ["s"];
              SwitchToMode = ["EnterSearch"];
            };
          }
          {
            bind = {
              _args = ["/"];
              SwitchToMode = ["EnterSearch"];
            };
          }
          {
            bind = {
              _args = ["j"];
              _children = [{ScrollDown = {};}];
            };
          }
          {
            bind = {
              _args = ["k"];
              _children = [{ScrollUp = {};}];
            };
          }
          {
            bind = {
              _args = ["Down"];
              _children = [{ScrollDown = {};}];
            };
          }
          {
            bind = {
              _args = ["Up"];
              _children = [{ScrollUp = {};}];
            };
          }
          {
            bind = {
              _args = ["PageDown"];
              _children = [{PageScrollDown = {};}];
            };
          }
          {
            bind = {
              _args = ["PageUp"];
              _children = [{PageScrollUp = {};}];
            };
          }
          {
            bind = {
              _args = ["d"];
              _children = [{HalfPageScrollDown = {};}];
            };
          }
          {
            bind = {
              _args = ["u"];
              _children = [{HalfPageScrollUp = {};}];
            };
          }
          {
            bind = {
              _args = ["g"];
              _children = [{ScrollToTop = {};}];
            };
          }
          {
            bind = {
              _args = ["G"];
              _children = [{ScrollToBottom = {};}];
            };
          }
        ];

        search._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["n"];
              _children = [{Search = "down";}];
            };
          }
          {
            bind = {
              _args = ["p"];
              _children = [{Search = "up";}];
            };
          }
          {
            bind = {
              _args = ["N"];
              _children = [{Search = "up";}];
            };
          }
          {
            bind = {
              _args = ["c"];
              _children = [{SearchToggleOption = "CaseSensitivity";}];
            };
          }
          {
            bind = {
              _args = ["w"];
              _children = [{SearchToggleOption = "Wrap";}];
            };
          }
          {
            bind = {
              _args = ["o"];
              _children = [{SearchToggleOption = "WholeWord";}];
            };
          }
        ];

        entersearch._children = [
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Search"];
            };
          }
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Scroll"];
            };
          }
        ];

        session._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["d"];
              _children = [{Detach = {};}];
            };
          }
          {
            bind = {
              _args = ["q"];
              _children = [{Quit = {};}];
            };
          }
        ];

        renametab._children = [
          {
            bind = {
              _args = ["Esc"];
              SwitchToMode = ["Normal"];
            };
          }
          {
            bind = {
              _args = ["Enter"];
              SwitchToMode = ["Normal"];
            };
          }
        ];
      };

      ui = {
        pane_frames = {
          rounded_corners = true;
          hide_session_name = false;
        };
      };

      session_serialization = false;
      serialize_pane_viewport = true;
    };
  };
}
