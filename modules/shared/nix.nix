{
  config,
  lib,
  platformOpts,
  ...
}: let
  inherit (lib) mkIf mkMerge mkEnableOption mkOption types;
  inherit (platformOpts) whenLinux whenDarwin always;
  cfg = config.personal.nix;
in {
  options.personal.nix = {
    enable = mkEnableOption "nix daemon and package manager configuration";

    experimentalFeatures = mkOption {
      type = types.listOf types.str;
      default = [
        "nix-command"
        "flakes"
      ];
      description = "nix experimental features to enable";
    };

    substituters = mkOption {
      type = types.listOf types.str;
      default = [
        "https://cache.nixos.org?priority=40"
        "https://nix-community.cachix.org?priority=43"
      ];
      description = "binary cache substituters shared across all hosts";
    };

    extraSubstituters = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "additional binary cache substituters for this host";
    };

    trustedPublicKeys = mkOption {
      type = types.listOf types.str;
      default = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      description = "trusted public keys shared across all hosts";
    };

    extraTrustedPublicKeys = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "additional trusted public keys for this host";
    };

    gc = {
      automatic = mkOption {
        type = types.bool;
        default = true;
        description = "enable automatic nix garbage collection";
      };

      dates = mkOption {
        type = types.str;
        default = "weekly";
        description = "how often to run garbage collection (nixos only, systemd calendar format)";
      };

      intervalDays = mkOption {
        type = types.int;
        default = 7;
        description = "days between garbage collection runs (darwin only, launchd interval)";
      };

      olderThan = mkOption {
        type = types.str;
        default = "14d";
        description = "delete store paths older than this";
      };
    };

    optimise = mkOption {
      type = types.bool;
      default = true;
      description = "enable automatic nix store optimisation (hard-linking identical files)";
    };

    allowUnfree = mkOption {
      type = types.bool;
      default = true;
      description = "allow installation of unfree packages";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (always {
      nix = {
        settings = {
          experimental-features = cfg.experimentalFeatures;
          substituters = cfg.substituters ++ cfg.extraSubstituters;
          trusted-public-keys = cfg.trustedPublicKeys ++ cfg.extraTrustedPublicKeys;
        };

        gc = {
          inherit (cfg.gc) automatic;
          options = "--delete-older-than ${cfg.gc.olderThan}";
        };

        optimise.automatic = cfg.optimise;
      };

      nixpkgs.config.allowUnfree = cfg.allowUnfree;
      programs.zsh.enable = true;
    })

    (whenLinux {
      nix.gc.dates = lib.mkDefault cfg.gc.dates;
    })

    (whenDarwin {
      nix.gc.interval.Day = cfg.gc.intervalDays;
    })
  ]);
}
