{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.hardware.spacenavd;
in {
  options.personal.hardware.spacenavd = {
    enable = mkEnableOption "3d mouse (spacenavd) support";
  };

  config = mkIf cfg.enable {
    hardware.spacenavd.enable = true;
    environment.systemPackages = [pkgs.spacenavd];
  };
}
