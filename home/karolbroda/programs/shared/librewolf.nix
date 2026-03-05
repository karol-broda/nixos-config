{
  pkgs,
  lib,
  platformOpts,
  ...
}: let
  inherit (platformOpts) whenLinux;

  linuxSettings = whenLinux {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "media.ffmpeg.vaapi.enabled" = true;
  };
in {
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;

    profiles.default = {
      id = 0;
      isDefault = true;

      extensions = lib.mkIf (pkgs ? nur) {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          vimium
          ublock-origin
          onepassword-password-manager
          stylus
          refined-github
          multi-account-containers
          react-devtools
          firefox-color
          kagi-search
        ];
      };

      settings =
        {
          "browser.startup.homepage" = "about:blank";
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "browser.tabs.loadInBackground" = true;
          "browser.tabs.closeWindowWithLastTab" = false;
          "extensions.autoDisableScopes" = 0;
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.theme.toolbar-theme" = 0;
          "privacy.sanitize.sanitizeOnShutdown" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.sessions" = false;
          "privacy.clearOnShutdown.offlineApps" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "network.cookie.lifetimePolicy" = 0;
        }
        // linuxSettings;

      bookmarks = {
        force = true;
        settings = [
          {
            name = "nixOS search";
            url = "https://search.nixos.org/";
          }
          {
            name = "home-manager options";
            url = "https://nix-community.github.io/home-manager/options.html";
          }
        ];
      };
    };

    policies = {
      DisablePocket = true;
      SearchEngines = {
        Default = "Kagi";
        Add = [
          {
            Name = "Kagi";
            Alias = "@k";
            URLTemplate = "https://kagi.com/search?q={searchTerms}";
            IconURL = "https://kagi.com/favicon.ico";
          }
          {
            Name = "nix packages";
            Alias = "@nix";
            URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
          }
          {
            Name = "chatgpt";
            Alias = "@chat";
            URLTemplate = "https://chatgpt.com/?q={searchTerms}";
          }
          {
            Name = "npm";
            Alias = "@npm";
            URLTemplate = "https://www.npmjs.com/search?q={searchTerms}";
          }
          {
            Name = "phosphor icons";
            Alias = "@phosphor";
            URLTemplate = "https://phosphoricons.com/?q={searchTerms}";
          }
        ];
      };
    };
  };
}
