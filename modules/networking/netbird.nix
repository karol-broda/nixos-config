{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.networking.netbird;
in {
  options.personal.networking.netbird = {
    enable = mkEnableOption "netbird vpn mesh network";
  };

  config = mkIf cfg.enable {
    services.netbird = {
      enable = true;
      package = pkgs-unstable.netbird;
    };

    environment.systemPackages = [pkgs-unstable.netbird-ui];
  };
}
