{
  pkgs,
  inputs,
  username,
  lib,
  ...
}: let
  tryPkg = inputs.try.packages.${pkgs.stdenv.hostPlatform.system}.default;
  snitchPkg = inputs.snitch.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  imports = [
    ./programs/shared
    ./programs/darwin
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.activation.aliasApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
    app_folder="/Applications/Nix Apps"
    home_manager_apps="$HOME/Applications/Home Manager Apps"
    if [ -d "$home_manager_apps" ]; then
      $DRY_RUN_CMD find "$home_manager_apps" -maxdepth 1 -name "*.app" -type l | while read -r app; do
        real_app=$(readlink -f "$app")
        app_name=$(basename "$app")
        $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_folder/$app_name"
      done
    fi
  '';

  home.activation.setWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.desktoppr}/bin/desktoppr "$HOME/Pictures/Wallpapers/angel.jpg"
  '';

  home.activation.setProfilePicture = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f "$HOME/Pictures/ProfilePictures/profile.jpg" ]; then
      $DRY_RUN_CMD /usr/bin/sudo /usr/bin/dscl . delete /Users/$USER JPEGPhoto 2>/dev/null || true
      $DRY_RUN_CMD /usr/bin/sudo /usr/bin/dscl . delete /Users/$USER Picture 2>/dev/null || true

      $DRY_RUN_CMD /usr/bin/sudo /usr/bin/dscl . create /Users/$USER Picture "$HOME/Pictures/ProfilePictures/profile.jpg"
    fi
  '';

  programs.try = {
    enable = true;
    path = "~/experiments";
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };

  home.file."Pictures/Wallpapers".source = ./wallpapers;
  home.file."Pictures/ProfilePictures".source = ./profile-pictures;
  home.file.".hushlogin".text = "";

  home.packages = with pkgs; [
    fastfetch
    htop

    ripgrep
    fzf
    zoxide
    fd
    jq
    gh
    kubectl

    bun
    corepack_24
    tryPkg

    snitchPkg

    phosphorIcons
  ];

  fonts.fontconfig.enable = true;
}
