{
  pkgs,
  pkgs-old-working,
  username,
  ...
}: let
  hytale-pkg = pkgs.callPackage ../../pkgs/hytale-launcher.nix {};
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  personal = {
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      fingerprint.enable = true;
      spacenavd.enable = true;
    };

    desktop.hyprland.enable = true;

    gaming = {
      steam.enable = true;
      bottles.enable = true;
    };

    virtualisation = {
      docker.enable = true;
      libvirt.enable = true;
    };

    networking = {
      netbird.enable = true;
      avahi.enable = true;
    };

    programs = {
      wireshark.enable = true;
      onepassword.enable = true;
      packettracer.enable = true;
    };

    security.gnome-keyring.enable = true;
  };

  networking = {
    hostName = "nixos";

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

    firewall = {
      allowedTCPPorts = [
        7236
        7250
      ];
      allowedUDPPorts = [
        7236
        5353
      ];
    };
  };

  services = {
    resolved.enable = true;
    libinput.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    hardware.bolt.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  programs.nix-ld.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [
    {
      users = [username];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    pciutils
    usbutils
    cliphist
    xclip
    wl-clipboard
    playerctl
    pavucontrol
    kdePackages.dolphin
    libsecret
    libinput
    ncurses
    obs-studio
    vlc
    xh
    gping
    speedtest-go
    nil
    teams-for-linux
    libnotify
    man-db
    man-pages
    man-pages-posix
    glibcInfo
    amp-cli
    papirus-icon-theme
    adwaita-icon-theme
    age
    openssl
    unzip
    pkgs-old-working.modrinth-app
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
    gnome-network-displays
    wireguard-tools
    cbonsai
    freerdp
    gnome-connections
    anydesk
    hytale-pkg
  ];

  documentation = {
    dev.enable = true;
    doc.enable = true;
    man.enable = true;
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
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
  };

  system.stateVersion = "25.05";
}
