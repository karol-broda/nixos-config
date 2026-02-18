{...}: {
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;
}
