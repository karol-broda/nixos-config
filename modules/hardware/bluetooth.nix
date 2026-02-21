{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.hardware.bluetooth;
in {
  options.personal.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth support";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    environment.systemPackages = [pkgs.bluetuith];
  };
}
