{
  config,
  pkgs,
  lib,
  system,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types hasSuffix;
  cfg = config.personal.packages;
  isLinux = hasSuffix "linux" system;
  isDarwin = hasSuffix "darwin" system;
in {
  options.personal.packages = {
    enable = mkEnableOption "system package management with named categories";

    base = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        git
        curl
        wget
        unzip
      ];
      description = "essential system utilities, installed on every host";
    };

    dev = mkOption {
      type = types.listOf types.package;
      default = with pkgs;
        [
          nil
          age
          openssl
        ]
        ++ lib.optionals isLinux [
          ncurses
          postgresql
          yaak
        ];
      description = "development tools and language servers";
    };

    cli = mkOption {
      type = types.listOf types.package;
      default = with pkgs;
        [
          xh
        ]
        ++ lib.optionals isLinux [
          pciutils
          usbutils
          gping
          speedtest-go
          amp-cli
          cbonsai
        ];
      description = "command line utilities and system info tools";
    };

    desktop = mkOption {
      type = types.listOf types.package;
      default = lib.optionals isLinux (with pkgs; [
        cliphist
        xclip
        wl-clipboard
        playerctl
        pavucontrol
        kdePackages.dolphin
        libsecret
        libinput
        libnotify
        papirus-icon-theme
        adwaita-icon-theme
      ]);
      description = "desktop environment tools (clipboard, file manager, notifications, icons)";
    };

    media = mkOption {
      type = types.listOf types.package;
      default = lib.optionals isLinux (with pkgs; [
        obs-studio
        vlc
      ]);
      description = "media playback and recording";
    };

    networking = mkOption {
      type = types.listOf types.package;
      default = lib.optionals isLinux (with pkgs; [
        traceroute
        dnsutils
        wireguard-tools
        gnome-network-displays
      ]);
      description = "network diagnostic and management tools";
    };

    communication = mkOption {
      type = types.listOf types.package;
      default = lib.optionals isLinux (with pkgs; [
        teams-for-linux
      ]);
      description = "messaging and communication apps";
    };

    docs = mkOption {
      type = types.listOf types.package;
      default = lib.optionals isLinux (with pkgs; [
        man-db
        man-pages
        man-pages-posix
        glibcInfo
      ]);
      description = "man pages and system documentation packages";
    };

    gaming = mkOption {
      type = types.listOf types.package;
      default = with pkgs;
        [
          prismlauncher
        ]
        ++ lib.optionals isLinux [
          lunar-client
          ferium
          zulu
          zulu8
          zulu17
        ];
      description = "game launchers and java runtimes for minecraft";
    };

    remote = mkOption {
      type = types.listOf types.package;
      default = lib.optionals isLinux (with pkgs; [
        freerdp
        gnome-connections
        anydesk
      ]);
      description = "remote desktop and connection tools";
    };

    darwinTools = mkOption {
      type = types.listOf types.package;
      default = lib.optionals isDarwin (with pkgs; [
        desktoppr
        xcodes
      ]);
      description = "macos-specific system tools";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "additional packages not covered by any category";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      cfg.base
      ++ cfg.dev
      ++ cfg.cli
      ++ cfg.desktop
      ++ cfg.media
      ++ cfg.networking
      ++ cfg.communication
      ++ cfg.docs
      ++ cfg.gaming
      ++ cfg.remote
      ++ cfg.darwinTools
      ++ cfg.extraPackages;
  };
}
