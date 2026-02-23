{
  pkgs,
  pkgs-old-working,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  personal = {
    boot = {
      enable = true;
      emulatedSystems = ["aarch64-linux"];
    };

    locale.enable = true;

    user = {
      enable = true;
      noPasswdSudo = true;
    };

    documentation.enable = true;

    nix = {
      enable = true;
      extraSubstituters = [
        "https://hyprland.cachix.org?priority=41"
        "https://wezterm.cachix.org?priority=42"
      ];
      extraTrustedPublicKeys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
      ];
    };

    fonts = {
      enable = true;
      extraPackages = with pkgs; [
        mplus-outline-fonts.githubRelease
        lato
        eb-garamond
        garamond-libre
        libre-baskerville
      ];
    };

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
      network = {
        enable = true;
        hostName = "nixos";
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
      netbird.enable = true;
      avahi.enable = true;
    };

    services = {
      desktop.enable = true;
      power.enable = true;
      thunderbolt = true;
    };

    programs = {
      wireshark.enable = true;
      onepassword.enable = true;
      packettracer.enable = true;
    };

    security.gnome-keyring.enable = true;

    packages = {
      enable = true;
      extraPackages = [
        pkgs-old-working.modrinth-app
        (pkgs.callPackage ../../pkgs/hytale-launcher.nix {})
      ];
    };
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "25.05";
}
