{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  pkgs-hypr,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.desktop.hyprland;
in {
  options.personal.desktop.hyprland = {
    enable = mkEnableOption "hyprland wayland compositor with greetd";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = pkgs-hypr.hyprland;
      portalPackage = pkgs-hypr.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = ["hyprland" "gtk"];
    };

    services = {
      greetd = {
        enable = true;
        restart = true;
        settings = {
          default_session = {
            command = "${pkgs-unstable.tuigreet}/bin/tuigreet --cmd start-hyprland";
          };
        };
      };

      dbus.enable = true;
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "null";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    security.polkit.enable = true;

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
