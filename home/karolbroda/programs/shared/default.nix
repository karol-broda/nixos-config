{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
    ./git.nix
    ./shell
    ./nvim
    ./direnv.nix
    ./bat.nix
    ./zellij.nix
    ./wezterm.nix
    ./superfile.nix
    ./fastfetch.nix
    ./firefox.nix
    ./librewolf.nix
    ./zen-browser.nix
    ./obsidian.nix
    ./zed.nix
    ./spicetify.nix
    ./sioyek.nix
    ./theming.nix
    ./discord.nix
    ./ai-coding
  ];

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

    inputs.snitch.packages.${system}.default

    blockbench
    zotero
    just
    posting
    television
    pkgs-unstable.code-cursor

    taskwarrior3
  ];

  home.file = {
    "Pictures/Wallpapers".source = ../../wallpapers;
    "Pictures/ProfilePictures".source = ../../profile-pictures;
  };

  programs.home-manager.enable = true;
}
