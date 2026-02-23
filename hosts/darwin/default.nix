{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./homebrew.nix
  ];

  personal = {
    nix.enable = true;
    locale.enable = true;
    fonts.enable = true;
    packages.enable = true;
  };

  system = {
    primaryUser = username;

    defaults = {
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

    activationScripts.postActivation.text = ''
      /Systems/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    stateVersion = 5;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
}
