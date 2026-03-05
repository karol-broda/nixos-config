{...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$rosewater" = "rgb(dc8a78)";
      "$rosewaterAlpha" = "dc8a78";
      "$flamingo" = "rgb(dd7878)";
      "$flamingoAlpha" = "dd7878";
      "$pink" = "rgb(ea76cb)";
      "$pinkAlpha" = "ea76cb";
      "$mauve" = "rgb(8839ef)";
      "$mauveAlpha" = "8839ef";
      "$red" = "rgb(d20f39)";
      "$redAlpha" = "d20f39";
      "$maroon" = "rgb(e64553)";
      "$maroonAlpha" = "e64553";
      "$peach" = "rgb(fe640b)";
      "$peachAlpha" = "fe640b";
      "$yellow" = "rgb(df8e1d)";
      "$yellowAlpha" = "df8e1d";
      "$green" = "rgb(40a02b)";
      "$greenAlpha" = "40a02b";
      "$teal" = "rgb(179299)";
      "$tealAlpha" = "179299";
      "$sky" = "rgb(04a5e5)";
      "$skyAlpha" = "04a5e5";
      "$sapphire" = "rgb(209fb5)";
      "$sapphireAlpha" = "209fb5";
      "$blue" = "rgb(1e66f5)";
      "$blueAlpha" = "1e66f5";
      "$lavender" = "rgb(7287fd)";
      "$lavenderAlpha" = "7287fd";
      "$text" = "rgb(4c4f69)";
      "$textAlpha" = "4c4f69";
      "$subtext1" = "rgb(5c5f77)";
      "$subtext1Alpha" = "5c5f77";
      "$subtext0" = "rgb(6c6f85)";
      "$subtext0Alpha" = "6c6f85";
      "$overlay2" = "rgb(7c7f93)";
      "$overlay2Alpha" = "7c7f93";
      "$overlay1" = "rgb(8c8fa1)";
      "$overlay1Alpha" = "8c8fa1";
      "$overlay0" = "rgb(9ca0b0)";
      "$overlay0Alpha" = "9ca0b0";
      "$surface2" = "rgb(acb0be)";
      "$surface2Alpha" = "acb0be";
      "$surface1" = "rgb(bcc0cc)";
      "$surface1Alpha" = "bcc0cc";
      "$surface0" = "rgb(ccd0da)";
      "$surface0Alpha" = "ccd0da";
      "$base" = "rgb(eff1f5)";
      "$baseAlpha" = "eff1f5";
      "$mantle" = "rgb(e6e9ef)";
      "$mantleAlpha" = "e6e9ef";
      "$crust" = "rgb(dce0e8)";
      "$crustAlpha" = "dce0e8";

      "$terminal" = "wezterm";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun";
      "$mainMod" = "SUPER";
      "$shiftMainMod" = "SUPER SHIFT";

      monitor = ", preferred, auto, 1";

      env = [
        "AQ_DRM_DEVICES,/dev/dri/dgpu:/dev/dri/igpu"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,catppuccin-frappe-lavender-cursors"
      ];

      "ecosystem:enforce_permissions" = true;

      permission = [
        ".*quickshell.*, screencopy, allow"
        ".*grim.*, screencopy, allow"
      ];

      exec-once = [
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_RUNTIME_DIR HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP"
        "hyprpaper"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 18;
        border_size = 3;
        "col.active_border" = "$lavender $mauve 45deg";
        "col.inactive_border" = "rgba(8c8fa1aa)";
        layout = "dwindle";
        resize_on_border = false;
        allow_tearing = false;
      };

      decoration = {
        rounding = 12;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(00000055)";
        };

        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          ignore_opacity = false;
          vibrancy = 0.12;
        };
      };

      animations = {
        enabled = 1;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global,     1, 7,  easeInOutCubic"
          "border,     1, 6,  easeOutQuint"
          "windows,    1, 6,  easeOutQuint"
          "windowsIn,  1, 5,  easeOutQuint, popin 85%"
          "windowsOut, 1, 4,  almostLinear, popin 85%"
          "fade,       1, 6,  quick"
          "fadeIn,     1, 5,  almostLinear"
          "fadeOut,    1, 4,  almostLinear"
          "layers,     1, 6,  easeOutQuint"
          "layersIn,   1, 5,  easeOutQuint, fade"
          "layersOut,  1, 4,  almostLinear, fade"
          "workspaces, 1, 3,  almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
        center_master_fallback = "right";
      };

      misc = {
        disable_hyprland_logo = true;
        vfr = true;
        focus_on_activate = true;
      };

      input = {
        kb_layout = "us,de,pl";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          clickfinger_behavior = true;
        };
      };

      cursor = {
        hide_on_key_press = true;
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreenstate, 1 1"
        "$shiftMainMod, F, fullscreenstate, 2"
        "$mainMod, R, exec, $menu"
        "$mainMod, T, layoutmsg, togglesplit"
        "$mainMod, D, global, dashboard"
        "$mainMod, SPACE, global, quickshell:launcher"
        "$shiftMainMod, SPACE, exec, 1password --quick-access"
        "$mainMod CTRL, L, global, quickshell:lock"
        "$mainMod, I, exec, hyprctl switchxkblayout all next"

        ", Print, global, quickshell:screenshot"
        "SHIFT, Print, global, quickshell:screenshotFreeze"
        "SUPER, Print, global, quickshell:screenshot"
        "SUPER SHIFT, Print, global, quickshell:screenshotFreeze"

        "$mainMod, left,  movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up,    movefocus, u"
        "$mainMod, down,  movefocus, d"

        "$mainMod, H, movefocus, l"
        "$mainMod, J, movefocus, d"
        "$mainMod, K, movefocus, u"
        "$mainMod, L, movefocus, r"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$shiftMainMod, 1, movetoworkspace, 1"
        "$shiftMainMod, 2, movetoworkspace, 2"
        "$shiftMainMod, 3, movetoworkspace, 3"
        "$shiftMainMod, 4, movetoworkspace, 4"
        "$shiftMainMod, 5, movetoworkspace, 5"
        "$shiftMainMod, 6, movetoworkspace, 6"
        "$shiftMainMod, 7, movetoworkspace, 7"
        "$shiftMainMod, 8, movetoworkspace, 8"
        "$shiftMainMod, 9, movetoworkspace, 9"
        "$shiftMainMod, 0, movetoworkspace, 10"

        "$mainMod, period,     focusmonitor, +1"
        "$mainMod, comma,      focusmonitor, -1"
        "$shiftMainMod, period, movecurrentworkspacetomonitor, +1"
        "$shiftMainMod, comma,  movecurrentworkspacetomonitor, -1"

        "$mainMod, S, togglespecialworkspace, magic"
        "$shiftMainMod, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up,   workspace, e-1"

        "$shiftMainMod, H, swapwindow, l"
        "$shiftMainMod, J, swapwindow, d"
        "$shiftMainMod, K, swapwindow, u"
        "$shiftMainMod, L, swapwindow, r"

        "$mainMod CTRL, H, resizeactive, -30 0"
        "$mainMod CTRL, L, resizeactive, 30 0"
        "$mainMod CTRL, J, resizeactive, 0 30"
        "$mainMod CTRL, K, resizeactive, 0 -30"

        "$shiftMainMod CTRL, H, moveactive, -40 0"
        "$shiftMainMod CTRL, L, moveactive, 40 0"
        "$shiftMainMod CTRL, J, moveactive, 0 40"
        "$shiftMainMod CTRL, K, moveactive, 0 -40"

        "ALT, f4, exec, xdg-open https://www.youtube.com/watch?v=dQw4w9WgXcQ"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute,     exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp,   exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext,  exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay,  exec, playerctl play-pause"
        ", XF86AudioPrev,  exec, playerctl previous"
        ", switch:on:Lid Switch,  exec, hyprctl keyword monitor \"eDP-2, disable\""
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-2, preferred, auto, 1\""
      ];

      windowrule = [
        "match:class .*, suppress_event maximize"
        "match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, no_initial_focus on"
        "match:class ^(pavucontrol)$, float on"
        "match:title ^(Picture-in-Picture)$, float on"
      ];
    };
  };

  services.hyprpolkitagent.enable = true;
}
