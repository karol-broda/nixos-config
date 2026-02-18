{...}: {
  programs.virt-manager = {
    enable = true;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.extraGroups.vboxusers.members = ["karolbroda"];
  users.extraGroups.libvirtd.members = ["karolbroda"];

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = [ "qemu:///system" ];
  #     uris = [ "qemu:///system" ];
  #   };
  # };
}
