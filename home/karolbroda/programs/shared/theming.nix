{config, ...}: {
  catppuccin = {
    enable = true;
    autoEnable = false;
    flavor = "frappe";
    accent = "lavender";
  };

  gtk.gtk4.theme = config.gtk.theme;
}
