{ pkgs
, lib
, platformOpts
, ...
}:
let
  inherit (platformOpts) isLinux whenLinux;

  linuxSettings = whenLinux {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "media.ffmpeg.vaapi.enabled" = true;
  };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

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
            URLTemplate = "https://npmx.dev/search?q={searchTerms}";
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

  xdg.mimeApps = lib.mkIf isLinux {
    enable = true;

    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };
}
