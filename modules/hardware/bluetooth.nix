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

    fastConnectable = mkOption {
      type = types.bool;
      default = true;
      description = "enable fast connectable mode (uses more power but reduces connection latency)";
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
          FastConnectable = cfg.fastConnectable;
          MultiProfile = "multiple";
          ReconnectAttempts = 7;
          ReconnectIntervals = "1,2,4,8,16,32,64";
          JustWorksRepairing = "always";
        };
        LE = {
          ConnectionLatency = 0;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    environment.systemPackages = cfg.extraPackages;
  };
}
