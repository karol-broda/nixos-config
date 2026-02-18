{
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      icon-theme = "Papirus-Dark";
    };
    theme = lib.mkForce ../../themes/rofi-theme.rasi;
  };
}
