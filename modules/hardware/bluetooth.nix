{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.hardware.bluetooth;
in {
  options.personal.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth support";

    powerOnBoot = mkOption {
      type = types.bool;
      default = true;
      description = "power on bluetooth adapter at boot";
    };

    experimental = mkOption {
      type = types.bool;
      default = true;
      description = "enable experimental bluez features (battery reporting, fast connect)";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [pkgs.bluetuith];
      description = "bluetooth management packages to install";
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.powerOnBoot;
      settings = {
        General = {
          Experimental = cfg.experimental;
        };
      };
    };

    environment.systemPackages = cfg.extraPackages;
  };
}
