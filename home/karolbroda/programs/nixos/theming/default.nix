{pkgs, ...}: {
  xdg = {
    enable = true;

    configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-frappe-lavender
    '';
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = 1;
    gtk4.extraConfig."gtk-application-prefer-dark-theme" = 1;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
  };

  qt = {
    enable = true;

    platformTheme = {
      name = "kvantum";
    };

    style = {
      name = "kvantum";
    };
  };

  home.pointerCursor = {
    name = "catppuccin-frappe-lavender-cursors";
    package = pkgs.catppuccin-cursors.frappeLavender;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
