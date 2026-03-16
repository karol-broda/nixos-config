{
  pkgs,
  platformOpts,
  ...
}: let
  inherit (platformOpts) isLinux;
in {
  programs.ghostty = {
    enable = true;
    package =
      if isLinux
      then pkgs.ghostty
      else pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings =
      {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        cursor-style = "block";
        copy-on-select = true;
        confirm-close-surface = false;
        scrollback-limit = 10000;
        shell-integration-features = true;
      }
      // (
        if isLinux
        then {
          gtk-single-instance = true;
        }
        else {}
      );
  };
}
