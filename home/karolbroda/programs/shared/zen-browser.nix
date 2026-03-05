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
  programs.zen-browser = {
    enable = true;
    suppressXdgMigrationWarning = true;

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
        ];
      };

      userChrome = ''
        /* catppuccin frappe lavender */
        @media (prefers-color-scheme: dark) {
          :root {
            --zen-colors-primary: #414559 !important;
            --zen-primary-color: #babbf1 !important;
            --zen-colors-secondary: #414559 !important;
            --zen-colors-tertiary: #292c3c !important;
            --zen-colors-border: #babbf1 !important;
            --toolbarbutton-icon-fill: #babbf1 !important;
            --lwt-text-color: #c6d0f5 !important;
            --toolbar-field-color: #c6d0f5 !important;
            --tab-selected-textcolor: rgb(192, 198, 243) !important;
            --toolbar-field-focus-color: #c6d0f5 !important;
            --toolbar-color: #c6d0f5 !important;
            --newtab-text-primary-color: #c6d0f5 !important;
            --arrowpanel-color: #c6d0f5 !important;
            --arrowpanel-background: #303446 !important;
            --sidebar-text-color: #c6d0f5 !important;
            --lwt-sidebar-text-color: #c6d0f5 !important;
            --lwt-sidebar-background-color: #232634 !important;
            --toolbar-bgcolor: #414559 !important;
            --newtab-background-color: #303446 !important;
            --zen-themed-toolbar-bg: #292c3c !important;
            --zen-main-browser-background: #292c3c !important;
            --toolbox-bgcolor-inactive: #292c3c !important;
          }

          #permissions-granted-icon {
            color: #292c3c !important;
          }

          .sidebar-placesTree {
            background-color: #303446 !important;
          }

          #zen-workspaces-button {
            background-color: #303446 !important;
          }

          #TabsToolbar {
            background-color: #292c3c !important;
          }

          .urlbar-background {
            background-color: #303446 !important;
          }

          .content-shortcuts {
            background-color: #303446 !important;
            border-color: #babbf1 !important;
          }

          .urlbarView-url {
            color: #babbf1 !important;
          }

          #zenEditBookmarkPanelFaviconContainer {
            background: #232634 !important;
          }

          #zen-media-controls-toolbar {
            & #zen-media-progress-bar {
              &::-moz-range-track {
                background: #414559 !important;
              }
            }
          }

          toolbar .toolbarbutton-1 {
            &:not([disabled]) {
              &:is([open], [checked])
                > :is(
                  .toolbarbutton-icon,
                  .toolbarbutton-text,
                  .toolbarbutton-badge-stack
                ) {
                fill: #232634;
              }
            }
          }

          .identity-color-blue {
            --identity-tab-color: #8caaee !important;
            --identity-icon-color: #8caaee !important;
          }

          .identity-color-turquoise {
            --identity-tab-color: #81c8be !important;
            --identity-icon-color: #81c8be !important;
          }

          .identity-color-green {
            --identity-tab-color: #a6d189 !important;
            --identity-icon-color: #a6d189 !important;
          }

          .identity-color-yellow {
            --identity-tab-color: #e5c890 !important;
            --identity-icon-color: #e5c890 !important;
          }

          .identity-color-orange {
            --identity-tab-color: #ef9f76 !important;
            --identity-icon-color: #ef9f76 !important;
          }

          .identity-color-red {
            --identity-tab-color: #e78284 !important;
            --identity-icon-color: #e78284 !important;
          }

          .identity-color-pink {
            --identity-tab-color: #f4b8e4 !important;
            --identity-icon-color: #f4b8e4 !important;
          }

          .identity-color-purple {
            --identity-tab-color: #ca9ee6 !important;
            --identity-icon-color: #ca9ee6 !important;
          }

          hbox#titlebar {
            background-color: #292c3c !important;
          }

          #zen-appcontent-navbar-container {
            background-color: #292c3c !important;
          }

          /* prevent extension panels from overflowing the sidebar */
          #webextpanels-window .webextension-popup-browser,
          #webextpanels-window .webextension-popup-stack {
            max-width: 100% !important;
            width: 100% !important;
          }

          .webextension-popup-browser {
            max-width: 100% !important;
          }

          #zenSidebarBrowserBox .browserStack {
            overflow: hidden !important;
          }
        }
      '';

      userContent = ''
        /* catppuccin frappe lavender */
        @media (prefers-color-scheme: dark) {
          @-moz-document url-prefix("about:") {
            :root {
              --in-content-page-color: #c6d0f5 !important;
              --color-accent-primary: #babbf1 !important;
              --color-accent-primary-hover: rgb(208, 209, 246) !important;
              --color-accent-primary-active: rgb(200, 187, 241) !important;
              background-color: #303446 !important;
              --in-content-page-background: #303446 !important;
            }
          }

          @-moz-document url("about:newtab"), url("about:home") {
            :root {
              --newtab-background-color: #303446 !important;
              --newtab-background-color-secondary: #414559 !important;
              --newtab-element-hover-color: #414559 !important;
              --newtab-text-primary-color: #c6d0f5 !important;
              --newtab-wordmark-color: #c6d0f5 !important;
              --newtab-primary-action-background: #babbf1 !important;
            }

            .icon {
              color: #babbf1 !important;
            }

            .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title {
              color: #babbf1 !important;
            }

            .top-site-outer .search-topsite {
              background-color: #8caaee !important;
            }

            .compact-cards .card-outer .card-context .card-context-icon.icon-download {
              fill: #a6d189 !important;
            }
          }

          @-moz-document url-prefix("about:preferences") {
            :root {
              --zen-colors-tertiary: #292c3c !important;
              --in-content-text-color: #c6d0f5 !important;
              --link-color: #babbf1 !important;
              --link-color-hover: rgb(208, 209, 246) !important;
              --zen-colors-primary: #414559 !important;
              --in-content-box-background: #414559 !important;
              --zen-primary-color: #babbf1 !important;
            }

            groupbox, moz-card {
              background: #303446 !important;
            }

            button,
            groupbox menulist {
              background: #414559 !important;
              color: #c6d0f5 !important;
            }

            .main-content {
              background-color: #232634 !important;
            }
          }

          @-moz-document url-prefix("about:addons") {
            :root {
              --zen-dark-color-mix-base: #292c3c !important;
              --background-color-box: #303446 !important;
            }
          }

          @-moz-document url-prefix("about:protections") {
            :root {
              --zen-primary-color: #303446 !important;
              --social-color: #ca9ee6 !important;
              --coockie-color: #99d1db !important;
              --fingerprinter-color: #e5c890 !important;
              --cryptominer-color: #babbf1 !important;
              --tracker-color: #a6d189 !important;
              --in-content-primary-button-background-hover: rgb(92, 99, 124) !important;
              --in-content-primary-button-text-color-hover: #c6d0f5 !important;
              --in-content-primary-button-background: #51576d !important;
              --in-content-primary-button-text-color: #c6d0f5 !important;
            }

            .card {
              background-color: #414559 !important;
            }
          }
        }
      '';

      settings =
        {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.startup.homepage" = "about:home";
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "browser.tabs.loadInBackground" = true;
          "browser.tabs.closeWindowWithLastTab" = false;
          "zen.tab.close-window-with-last-tab" = false;
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
        Default = "Google";
        Add = [
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
