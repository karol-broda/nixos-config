{pkgs-hypr, ...}: {
  home.packages = [pkgs-hypr.hyprpaper];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    ipc = true
    splash = false

    wallpaper {
      monitor =
      path = ~/Pictures/Wallpapers/angel.jpg
    }
  '';
}
