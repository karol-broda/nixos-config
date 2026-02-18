{pkgs, ...}: {
  programs.quickshell = {
    enable = true;
    package = pkgs.quickshell;

    configs = {
      default = ../quickshell;
    };

    activeConfig = "default";

    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  programs.elephant = {
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
