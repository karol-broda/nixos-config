{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.boot;
in {
  options.personal.boot = {
    enable = mkEnableOption "boot configuration";

    loader = {
      systemd-boot.enable = mkOption {
        type = types.bool;
        default = true;
        description = "use systemd-boot as the bootloader";
      };

      efi.canTouchEfiVariables = mkOption {
        type = types.bool;
        default = true;
        description = "allow the bootloader to modify efi variables";
      };
    };

    kernelPackages = mkOption {
      type = types.raw;
      default = pkgs.linuxPackages_latest;
      description = "kernel packages to use";
    };

    emulatedSystems = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "architectures to emulate via binfmt (e.g. aarch64-linux for cross-compilation)";
    };

    extraKernelModules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "extra kernel modules to load at boot";
    };

    extraKernelParams = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "extra kernel command line parameters";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        systemd-boot.enable = cfg.loader.systemd-boot.enable;
        efi.canTouchEfiVariables = cfg.loader.efi.canTouchEfiVariables;
      };
      kernelPackages = cfg.kernelPackages;
      binfmt.emulatedSystems = cfg.emulatedSystems;
      extraModulePackages = [];
      kernelModules = cfg.extraKernelModules;
      kernelParams = cfg.extraKernelParams;
    };
  };
}
