_: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    extraConfig = builtins.readFile ./config.lua;
  };

  services.hyprpolkitagent.enable = true;
}
