{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.virtualisation.docker;
in {
  options.personal.virtualisation.docker = {
    enable = mkEnableOption "docker container runtime";

    package = mkOption {
      type = types.package;
      default = pkgs.docker_28;
      description = "docker package to use";
    };

    enableOnBoot = mkOption {
      type = types.bool;
      default = true;
      description = "start docker daemon on boot";
    };

    liveRestore = mkOption {
      type = types.bool;
      default = true;
      description = "keep containers running during daemon downtime";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [pkgs.dive];
      description = "additional docker-related tools to install";
    };

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable automatic docker resource cleanup";
      };

      dates = mkOption {
        type = types.str;
        default = "weekly";
        description = "how often to run docker prune";
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = ["--all" "--volumes"];
        description = "flags to pass to docker system prune";
      };

      randomizedDelaySec = mkOption {
        type = types.str;
        default = "30min";
        description = "randomized delay before running prune to avoid thundering herd";
      };
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      inherit (cfg) enableOnBoot package liveRestore extraPackages;
      autoPrune = {
        inherit (cfg.autoPrune) enable dates randomizedDelaySec flags;
        persistent = true;
      };
    };

    users.users.${username} = {
      extraGroups = ["docker"];
      linger = true;
    };
  };
}
