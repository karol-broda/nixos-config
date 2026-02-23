{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  pkgs-hypr,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.desktop.hyprland;
in {
  options.personal.desktop.hyprland = {
    enable = mkEnableOption "hyprland wayland compositor";

    greeter = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable greetd login manager";
      };

      command = mkOption {
        type = types.str;
        default = "${pkgs-unstable.tuigreet}/bin/tuigreet --cmd start-hyprland";
        description = "greeter command to run on the login screen";
      };
    };

    portal = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable xdg desktop portals";
      };

      extraPortals = mkOption {
        type = types.listOf types.package;
        default = [pkgs.xdg-desktop-portal-gtk];
        description = "additional xdg portal implementations";
      };

      defaultPortals = mkOption {
        type = types.listOf types.str;
        default = ["hyprland" "gtk"];
        description = "default portal backend ordering";
      };
    };

    polkit = mkOption {
      type = types.bool;
      default = true;
      description = "enable polkit for privilege escalation prompts";
    };
  };

  config = mkIf cfg.enable {
    personal = {
      services.desktop.enable = lib.mkDefault true;
      fonts.enable = lib.mkDefault true;
      packages.enable = lib.mkDefault true;
      security.gnome-keyring.enable = lib.mkDefault true;
    };

    programs.hyprland = {
      enable = true;
      package = pkgs-hypr.hyprland;
      portalPackage = pkgs-hypr.xdg-desktop-portal-hyprland;
    };

    xdg.portal = mkIf cfg.portal.enable {
      enable = true;
      extraPortals = cfg.portal.extraPortals;
      config.common.default = cfg.portal.defaultPortals;
    };

    services = mkIf cfg.greeter.enable {
      greetd = {
        enable = true;
        restart = true;
        settings = {
          default_session = {
            command = cfg.greeter.command;
          };
        };
      };

      dbus.enable = true;
    };

    systemd.services.greetd = mkIf cfg.greeter.enable {
      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "null";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };

    security.polkit.enable = cfg.polkit;

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
