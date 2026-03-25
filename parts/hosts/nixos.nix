{
  inputs,
  username,
  theme,
  mkPkgsUnstable,
  mkPkgsOldWorking,
  commonOverlays,
  sharedHomeModules,
  ...
}: let
  inherit (inputs.self.lib.personal) builders;
  system = "x86_64-linux";
  pkgs-hypr = {
    inherit (inputs.hyprnix.packages.${system}) hyprland xdg-desktop-portal-hyprland hyprlock hyprpaper;
  };
  elephant-wallpaper-provider = import ../../pkgs/elephant-wallpaper-provider.nix {
    inherit (inputs.elephant.packages.${system}) elephant-providers;
    wallpaper-source = ../../providers/wallpaper;
  };
in {
  flake.nixosConfigurations.nixos = builders.mkNixosHost {
    hostname = "nixos";
    inherit system;
    specialArgs = {
      inherit username pkgs-hypr;
      pkgs-unstable = mkPkgsUnstable system;
      pkgs-old-working = mkPkgsOldWorking system;
    };
    overlays =
      commonOverlays
      ++ [
        inputs.quickshell.overlays.default
      ];
    modules = [
      ../../modules
      ../../hosts/nixos/configuration.nix
      {
        nixpkgs.config.permittedInsecurePackages = [
          "ciscoPacketTracer8-8.2.2"
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
}
