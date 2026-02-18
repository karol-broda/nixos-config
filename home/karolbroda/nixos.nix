{
  pkgs,
  inputs,
  ...
}: let
  tryPkg = inputs.try.packages.${pkgs.stdenv.hostPlatform.system}.default;
  snitchPkg = inputs.snitch.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  imports = [
    ./programs/shared
    ./programs/nixos
  ];

  home.username = "karolbroda";
  home.homeDirectory = "/home/karolbroda";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.try = {
    enable = true;
    path = "~/experiments";
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    GTK_THEME = "adw-gtk3-dark";
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
    QT_QPA_PLATFORMTHEME = "kvantum";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  home.file."Pictures/Wallpapers".source = ./wallpapers;
  home.file."Pictures/ProfilePictures".source = ./profile-pictures;

  home.packages = with pkgs; [
    fastfetch
    htop
    hyprlock
    app2unit

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
}
