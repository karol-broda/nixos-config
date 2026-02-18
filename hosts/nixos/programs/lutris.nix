{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types optional getExe;

  corePackages = with pkgs; [
    bottles
    wineWowPackages.staging
    winetricks
    dxvk
    vkd3d-proton
    mangohud
    vkbasalt
    gamescope
    cabextract
    p7zip
    vulkan-tools
  ];

  bottlesGamemode = pkgs.writeShellScriptBin "bottles-gamemode" ''
    #!/usr/bin/env bash
    exec ${getExe pkgs.gamemode} ${getExe pkgs.bottles} "$@"
  '';
in {
  options.gaming.bottles = {
    enable = mkEnableOption "system-wide setup for bottles + wine";

    withGamescopeWrapper = mkOption {
      type = types.bool;
      default = true;
      description = "install a bottles-gamemode helper that runs bottles through gamemoderun";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "additional packages to install alongside bottles + wine";
    };

    extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "extra environment variables to export in user sessions";
    };
  };

  config = mkIf config.gaming.bottles.enable {
    services.udev.packages = [pkgs.game-devices-udev-rules];

    security.pam.loginLimits = [
      {
        domain = "@users";
        type = "-";
        item = "rtprio";
        value = "99";
      }
      {
        domain = "@users";
        type = "-";
        item = "nice";
        value = "-11";
      }
    ];

    environment.sessionVariables =
      {
        WINEDEBUG = "-all";
        WINEESYNC = "1";
        WINEFSYNC = "1";
        STAGING_SHARED_MEMORY = "1";
        DXVK_LOG_LEVEL = "none";
        DXVK_STATE_CACHE = "1";
        VKD3D_DEBUG = "none";
        __GL_SHADER_DISK_CACHE = "1";
      }
      // config.gaming.bottles.extraEnv;

    environment.systemPackages =
      corePackages
      ++ config.gaming.bottles.extraPackages
      ++ (optional config.gaming.bottles.withGamescopeWrapper bottlesGamemode);

    programs.gamemode = {
      enable = true;
      settings.general = {
        renice = 10;
        ioprio = 4;
      };
    };
  };
}
