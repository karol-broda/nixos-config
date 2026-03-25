_: {
  programs.nixcord = {
    enable = true;
    discord = {
      enable = false;
    };
    vesktop.enable = true;

    config = {
      useQuickCss = true;
      autoUpdate = false;
      autoUpdateNotification = false;
      enableReactDevtools = false;
      frameless = false;
      disableMinSize = false;
      notifyAboutUpdates = false;

      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-latte-lavender.theme.css"
      ];

      plugins = {
        crashHandler.enable = true;
        experiments.enable = true;

        betterUploadButton.enable = true;
        ClearURLs.enable = true;
        CopyUserURLs.enable = true;
        fakeNitro = {
          enable = true;
          enableEmojiBypass = true;
          enableStickerBypass = true;
        };
        favoriteEmojiFirst.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        friendsSince.enable = true;
        imageZoom.enable = true;
        messageClickActions = {
          enable = true;
          enableDoubleClickToEdit = true;
          enableDoubleClickToReply = true;
        };
        noBlockedMessages.enable = true;
        permissionsViewer.enable = true;
        platformIndicators.enable = true;
        previewMessage.enable = true;
        quickMention.enable = true;
        readAllNotificationsButton.enable = true;
        reverseImageSearch.enable = true;
        showHiddenChannels.enable = true;
        silentTyping.enable = true;
        typingIndicator.enable = true;
        typingTweaks.enable = true;
        voiceChatDoubleClick.enable = true;
        whoReacted.enable = true;

        youtubeAdblock.enable = true;
        spotifyControls.enable = true;

        memberCount.enable = true;
        showMeYourName.enable = true;
        betterFolders = {
          enable = true;
          sidebar = true;
          closeAllFolders = true;
        };
        betterRoleContext.enable = true;
        callTimer.enable = true;
        noProfileThemes.enable = true;
        roleColorEverywhere.enable = true;
        alwaysAnimate.enable = true;
        viewIcons.enable = true;

        translate.enable = true;
        sendTimestamps.enable = true;
        voiceMessages.enable = true;
        voiceDownload.enable = true;
        USRBG.enable = true;
        decor.enable = true;
        shikiCodeblocks.enable = true;
        betterSettings.enable = true;
        quickReply.enable = true;
      };
    };

    vesktop = {
      settings = {
        minimizeToTray = "on";
        discordBranch = "stable";
        arRPC = "on";
        hardwareAcceleration = true;
        enableMenu = true;
      };
    };
  };

  home.sessionVariables = {
    VESKTOP_USE_WAYLAND = "1";
  };
}
