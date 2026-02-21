{pkgs, elephant-wallpaper-provider, ...}: {
  programs = {
    quickshell = {
      enable = true;
      package = pkgs.quickshell;

      configs = {
        default = ./.;
      };

      activeConfig = "default";

      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };

    elephant = {
      enable = true;
      installService = true;
      debug = false;

      providers = [
        "desktopapplications"
        "files"
        "clipboard"
        "runner"
        "calc"
        "websearch"
        "windows"
      ];
    };
  };

  xdg.configFile."elephant/providers/wallpaper.so" = {
    source = "${elephant-wallpaper-provider}/lib/elephant/providers/wallpaper.so";
    force = true;
  };

  home.packages = with pkgs; [
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qtimageformats
    kdePackages.qtmultimedia

    brightnessctl
    cava
    ddcutil
    lm_sensors
    grim
    swappy
    libqalculate
  ];
}
