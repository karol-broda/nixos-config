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
      "roblox"
      "robloxstudio"
      "steam"
      "whisky"
      "autodesk-fusion"
    ];

    masApps = {
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
