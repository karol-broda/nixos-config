{pkgs, ...}: {
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
    ./obsidian.nix
    ./zed.nix
    ./spicetify.nix
    ./sioyek.nix
    ./theming.nix
    ./discord.nix
    ./ai-coding.nix
  ];

  home.packages = with pkgs; [
    blockbench
    zotero
    just
    posting
    television
    code-cursor
  ];
}
