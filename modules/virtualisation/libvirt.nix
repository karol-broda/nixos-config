{
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.virtualisation.libvirt;
in {
  options.personal.virtualisation.libvirt = {
    enable = mkEnableOption "libvirt/kvm virtualisation";

    virtManager = mkOption {
      type = types.bool;
      default = true;
      description = "enable virt-manager gui";
    };

    spiceUSBRedirection = mkOption {
      type = types.bool;
      default = true;
      description = "enable usb passthrough to vms via spice";
    };
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = cfg.virtManager;

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = cfg.spiceUSBRedirection;
    };

    users.extraGroups = {
      vboxusers.members = [username];
      libvirtd.members = [username];
    };
  };
}
