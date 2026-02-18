{
  pkgs,
  inputs,
  ...
}: let
  hytale-pkg = pkgs.callPackage ../../pkgs/hytale-launcher.nix {};
in {
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./disks.nix
    ./containerization.nix
    ./fingerprint.nix
    ./programs
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org?priority=40"
      "https://hyprland.cachix.org?priority=41"
      "https://wezterm.cachix.org?priority=42"
      "https://nix-community.cachix.org?priority=43"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [inputs.nur.overlays.default];

  programs.zsh.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    hosts = {
      "127.0.0.1" = ["localhost"];
      "::1" = ["ip6-loopback"];
    };

    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
  };
  services.resolved.enable = true;

  services.netbird.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  hardware.spacenavd.enable = true;

  services.libinput = {
    enable = true;
  };

  security.polkit.enable = true;

  services.dbus.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.wireshark = {
    enable = true;
  };

  gaming = {
    steam.enable = true;
    bottles.enable = true;
  };

  programs.nix-ld.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      7236
      7250
    ];
    allowedUDPPorts = [
      7236
      5353
    ];
  };

  services.greetd = {
    enable = true;
    restart = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd start-hyprland";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "null";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  users.users.karolbroda = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "wireshark"
    ];
    shell = pkgs.zsh;
  };

  # thunderbolt device authorization — needed for DP tunneling through TB docks
  services.hardware.bolt.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  security.sudo.extraRules = [
    {
      users = ["karolbroda"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    package = pkgs._1password-gui;
    polkitPolicyOwners = ["karolbroda"];
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    login.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
    hyprlock.enableGnomeKeyring = true;
    quickshell-lock = {};
  };

  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];
  programs.seahorse.enable = true;

  programs.ssh.startAgent = false;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    pciutils
    usbutils
    cliphist
    xclip
    wl-clipboard
    brightnessctl
    playerctl
    pavucontrol
    kdePackages.dolphin
    libsecret
    seahorse
    libinput
    libqalculate
    grim
    ddcutil
    lm_sensors
    ncurses
    obs-studio
    vlc
    xh
    gping
    speedtest-go
    nil
    teams-for-linux
    swappy
    libnotify
    bluetuith
    man-db
    man-pages
    man-pages-posix
    glibcInfo
    amp-cli
    rpi-imager
    papirus-icon-theme
    adwaita-icon-theme
    age
    netbird-ui
    openssl
    unzip
    modrinth-app
    lunar-client
    ferium
    prismlauncher
    zulu
    zulu8
    zulu17
    traceroute
    postgresql
    yaak
    dnsutils
    spacenavd
    freecad
    openscad
    kicad
    gnome-network-displays
    wireguard-tools
    cbonsai
    freerdp
    gnome-connections
    anydesk
    wireshark
    hytale-pkg
  ];

  documentation = {
    dev = {
      enable = true;
    };
    doc = {
      enable = true;
    };
    man = {
      enable = true;
    };
  };

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    font-awesome
    material-symbols
    inter
    mplus-outline-fonts.githubRelease
    lato
    eb-garamond
    garamond-libre
    libre-baskerville
  ];

  system.stateVersion = "25.05";
}
