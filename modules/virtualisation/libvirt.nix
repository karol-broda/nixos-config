{
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.virtualisation.libvirt;
in {
  options.personal.virtualisation.libvirt = {
    enable = mkEnableOption "libvirt and virt-manager";
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    users.extraGroups = {
      vboxusers.members = [username];
      libvirtd.members = [username];
    };
  };
}
