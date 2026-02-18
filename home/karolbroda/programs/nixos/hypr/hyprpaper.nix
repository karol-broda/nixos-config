{pkgs, ...}: {
  home.packages = [pkgs.hyprpaper];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    ipc = on
    splash = false
    preload = ~/Pictures/Wallpapers/angel.jpg
    wallpaper = , ~/Pictures/Wallpapers/angel.jpg
  '';
}
