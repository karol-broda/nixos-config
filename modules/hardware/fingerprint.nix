{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.hardware.fingerprint;
  libfprintTodFpc = pkgs.callPackage ../../pkgs/libfprint-2-tod1-fpc.nix {};
in {
  options.personal.hardware.fingerprint = {
    enable = mkEnableOption "fingerprint reader with fpc tod driver";
  };

  config = mkIf cfg.enable {
    services.fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = libfprintTodFpc;
      };
    };

    security.pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
      polkit-1.fprintAuth = true;
    };

    environment.systemPackages = [pkgs.fprintd];
  };
}
