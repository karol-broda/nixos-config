{config, ...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [
    ];

    casks = [
      "1password"
      "1password-cli"
      "sol"
    ];

    masApps = {
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
