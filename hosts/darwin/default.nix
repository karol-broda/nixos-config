{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./homebrew.nix
  ];

  system.primaryUser = username;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org?priority=40"
      "https://nix-community.cachix.org?priority=43"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.gc = {
    automatic = true;
    interval.Day = 7;
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;

  system.defaults = {
    dock = {
      autohide = false;
      orientation = "left";
      show-recents = false;
      tilesize = 40;
      minimize-to-application = true;
      mru-spaces = false;
      launchanim = false;
      expose-animation-duration = 0.1;
      persistent-apps = [
        "/Users/${username}/Applications/Home Manager Apps/Firefox.app"
        "/Users/${username}/Applications/Home Manager Apps/Ghostty.app"
      ];
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      FXDefaultSearchScope = "SCcf";
      NewWindowTarget = "Home";
      QuitMenuItem = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSWindowResizeTime = 0.001;
      AppleShowScrollBars = "WhenScrolling";
      AppleScrollerPagingBehavior = true;
      _HIHideMenuBar = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };

    screencapture = {
      target = "clipboard";
      type = "png";
      disable-shadow = true;
    };

    spaces.spans-displays = false;

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.frameworks.diskimages" = {
        skip-verify = true;
        skip-verify-locked = true;
        skip-verify-remote = true;
      };
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        ShowSidebar = true;
        SidebarWidth = 180;
      };
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadFourFingerVertSwipeGesture = 2;
      };
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        TrackpadFourFingerVertSwipeGesture = 2;
      };
    };
  };

  system.activationScripts.postActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  time.timeZone = "Europe/Warsaw";

  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
    inter
  ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    nil
    age
    openssl
    unzip
    desktoppr

    xcodes

    prismlauncher
    xh
  ];

  system.stateVersion = 5;
}
