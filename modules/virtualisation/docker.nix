{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.virtualisation.docker;
in {
  options.personal.virtualisation.docker = {
    enable = mkEnableOption "docker container runtime";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      package = pkgs.docker_28;
      liveRestore = true;
      extraPackages = [pkgs.dive];
      autoPrune = {
        enable = true;
        dates = "weekly";
        randomizedDelaySec = "30min";
        persistent = true;
        flags = ["--all" "--volumes"];
      };
    };

    users.users.${username} = {
      extraGroups = ["docker"];
      linger = true;
    };
  };
}
