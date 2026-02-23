{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.services;
in {
  options.personal.services = {
    desktop.enable = mkEnableOption "common desktop services (libinput, udisks2, gvfs, dbus)";

    power = {
      enable = mkEnableOption "power management services";

      upower = mkOption {
        type = types.bool;
        default = true;
        description = "enable upower battery/power device monitoring";
      };

      profiles = mkOption {
        type = types.bool;
        default = true;
        description = "enable power-profiles-daemon for switching between power modes";
      };
    };

    thunderbolt = mkOption {
      type = types.bool;
      default = false;
      description = "enable thunderbolt/bolt device management";
    };
  };

  config = lib.mkMerge [
    (mkIf cfg.desktop.enable {
      services = {
        libinput.enable = true;
        udisks2.enable = true;
        gvfs.enable = true;
        dbus.enable = true;
      };
    })

    (mkIf cfg.power.enable {
      services = {
        upower.enable = cfg.power.upower;
        power-profiles-daemon.enable = cfg.power.profiles;
      };
    })

    (mkIf cfg.thunderbolt {
      services.hardware.bolt.enable = true;
    })
  ];
}
