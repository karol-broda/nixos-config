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

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";

    activation = {
      aliasApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
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

      setWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.desktoppr}/bin/desktoppr "$HOME/Pictures/Wallpapers/angel.jpg"
      '';

      setProfilePicture = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -f "$HOME/Pictures/ProfilePictures/profile.jpg" ]; then
          $DRY_RUN_CMD /usr/bin/sudo /usr/bin/dscl . delete /Users/$USER JPEGPhoto 2>/dev/null || true
          $DRY_RUN_CMD /usr/bin/sudo /usr/bin/dscl . delete /Users/$USER Picture 2>/dev/null || true

          $DRY_RUN_CMD /usr/bin/sudo /usr/bin/dscl . create /Users/$USER Picture "$HOME/Pictures/ProfilePictures/profile.jpg"
        fi
      '';
    };

    sessionVariables = {
      SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };

    file = {
      "Pictures/Wallpapers".source = ./wallpapers;
      "Pictures/ProfilePictures".source = ./profile-pictures;
      ".hushlogin".text = "";
    };

    packages = with pkgs; [
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
  };

  programs = {
    home-manager.enable = true;
    try = {
      enable = true;
      path = "~/experiments";
    };
  };

  fonts.fontconfig.enable = true;
}
