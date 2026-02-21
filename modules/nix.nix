{lib, ...}: {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org?priority=40"
        "https://wezterm.cachix.org?priority=42"
        "https://nix-community.cachix.org?priority=43"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
      ];
    };

    gc = {
      automatic = true;
      dates = lib.mkDefault "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
}
