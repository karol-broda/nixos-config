{
  pkgs,
  pkgs-unstable,
  inputs,
  username,
  ...
}: let
  tryPkg = inputs.try.packages.${pkgs.stdenv.hostPlatform.system}.default;
  snitchPkg = inputs.snitch.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  imports = [
    ./programs/shared
    ./programs/nixos
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      GTK_THEME = "adw-gtk3-dark";
      SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
      QT_QPA_PLATFORMTHEME = "kvantum";
      QT_STYLE_OVERRIDE = "kvantum";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };

    file = {
      "Pictures/Wallpapers".source = ./wallpapers;
      "Pictures/ProfilePictures".source = ./profile-pictures;
    };

    packages = with pkgs; [
      fastfetch
      htop
      hyprlock
      pkgs-unstable.app2unit

      kdePackages.kconfig
      gowall

      catppuccin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      adwaita-qt6

      ripgrep
      fzf
      zoxide
      fd
      jq
      gh
      kubectl

      komikku

      bun

      rustscan

      (ghidra.withExtensions (p:
        with p; [
          ghidra-golanganalyzerextension
          findcrypt
          gnudisassembler
          kaiju
          ret-sync
        ]))

      libreoffice-qt
      hunspell
      hunspellDicts.en_US

      google-chrome

      corepack_24
      ov
      hoppscotch
      horizon-eda
      tor-browser
      lazysql
      tryPkg
      snitchPkg

      kdePackages.qtdeclarative
    ];
  };

  programs = {
    home-manager.enable = true;
    try = {
      enable = true;
      path = "~/experiments";
    };
  };
}
