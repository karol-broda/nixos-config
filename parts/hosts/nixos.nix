{
  inputs,
  username,
  theme,
  mkPkgsUnstable,
  commonOverlays,
  sharedHomeModules,
  ...
}: let
  inherit (inputs.self.lib.personal) builders;
  system = "x86_64-linux";
  pkgs-hypr = let
    pkgs = mkPkgsUnstable system;
  in {
    inherit (pkgs) hyprland xdg-desktop-portal-hyprland hyprlock hyprpaper;
  };
  elephant-wallpaper-provider = import ../../pkgs/elephant-wallpaper-provider.nix {
    inherit (inputs.elephant.packages.${system}) elephant-providers;
    wallpaper-source = ../../providers/wallpaper;
  };
  fixedLinuxFirmware = _final: prev: {
    linux-firmware = prev.linux-firmware.overrideAttrs {
      version = "20260916";
      src = prev.fetchFromGitLab {
        owner = "kernel-firmware";
        repo = "linux-firmware";
        tag = "20260916";
        hash = "sha256-VbDTRN/i+a1BrKnDtdDFxanp3BQujBhe9CyWay9GTXY=";
      };
    };
  };

  nixosHostArgs = {
    hostname = "nixos";
    inherit system;
    specialArgs = {
      inherit username pkgs-hypr;
      pkgs-unstable = mkPkgsUnstable system;
    };
    overlays =
      commonOverlays
      ++ [
        inputs.quickshell.overlays.default
        fixedLinuxFirmware
      ];
    modules = [
      ../../modules
      ../../hosts/nixos/configuration.nix
      {
        nixpkgs.config.permittedInsecurePackages = [
          "olm-3.2.16"
        ];
      }
    ];
    homeModules =
      sharedHomeModules
      ++ [
        inputs.plasma-manager.homeModules."plasma-manager"
        inputs.elephant.homeManagerModules.elephant
      ];
    homeUsers.${username} = import ../../home/karolbroda/nixos.nix;
    homeSpecialArgs = {
      inherit username theme pkgs-hypr elephant-wallpaper-provider;
      pkgs-unstable = mkPkgsUnstable system;
    };
  };
in {
  _module.args.nixosHostArgs = nixosHostArgs;

  flake.nixosConfigurations.nixos = builders.mkNixosHost nixosHostArgs;
}
