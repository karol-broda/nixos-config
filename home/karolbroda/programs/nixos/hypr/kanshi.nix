{pkgs, ...}: {
  home.packages = [pkgs.kanshi];

  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-2";
              status = "enable";
              mode = "2560x1600@165.019";
              position = "0,0";
              scale = 1.0;
            }
          ];
          exec = [
            "hyprctl dispatch moveworkspacetomonitor 1 eDP-2"
            "hyprctl dispatch moveworkspacetomonitor 2 eDP-2"
            "hyprctl dispatch moveworkspacetomonitor 3 eDP-2"
          ];
        };
      }

      {
        profile = {
          name = "work";
          outputs = [
            {
              criteria = "DP-2";
              status = "enable";
              mode = "3840x2160@59.997";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
              mode = "3840x2160@60.000";
              position = "3840,0";
              scale = 1.0;
            }
            {
              criteria = "eDP-2";
              status = "enable";
              mode = "2560x1600@165.019";
              position = "2560,2160";
              scale = 1.0;
            }
          ];
          exec = [
            "hyprctl dispatch moveworkspacetomonitor 1 HDMI-A-1"
            "hyprctl dispatch moveworkspacetomonitor 2 DP-2"
            "hyprctl dispatch moveworkspacetomonitor 3 DP-2"
          ];
        };
      }
    ];
  };
}
