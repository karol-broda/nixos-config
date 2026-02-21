{pkgs, ...}: let
  flavourName = "Frappe";
  accentName = "Lavender";
  lookPkg = "Catppuccin-${flavourName}-${accentName}";
  auroraeTheme = "Catppuccin${flavourName}-Classic";
  colorScheme = "Catppuccin${flavourName}${accentName}";
in {
  home = {
    packages = [
      pkgs.catppuccin-kde
      pkgs.kdePackages.plasma-workspace
    ];

    pointerCursor = {
      name = "catppuccin-frappe-lavender-cursors";
      package = pkgs.catppuccin-cursors.frappeLavender;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  xdg.dataFile = {
    # avoids running the upstream installer script
    "plasma/look-and-feel/${lookPkg}".source = "${pkgs.catppuccin-kde}/share/plasma/look-and-feel/${lookPkg}";
    "aurorae/themes/${auroraeTheme}".source = "${pkgs.catppuccin-kde}/share/aurorae/themes/${auroraeTheme}";
    "color-schemes/${colorScheme}.colors".source = "${pkgs.catppuccin-kde}/share/color-schemes/${colorScheme}.colors";
  };

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = lookPkg;
      colorScheme = colorScheme;
    };
  };
}
