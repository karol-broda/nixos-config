{
  pkgs,
  inputs,
  platformOpts,
  ...
}: let
  inherit (platformOpts) whenLinux;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.spicetify =
    {
      enable = true;

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "frappe";

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        keyboardShortcut
        fullAppDisplay
        volumePercentage
        playingSource
        showQueueDuration
        lastfm
        hidePodcasts
        shuffle
        beautifulLyrics
        simpleBeautifulLyrics
      ];

      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
        newReleases
        reddit
        localFiles
      ];

      alwaysEnableDevTools = true;
      experimentalFeatures = true;

      spotifyLaunchFlags = "";
    }
    // whenLinux {
      wayland = true;
      windowManagerPatch = false;
    };
}
