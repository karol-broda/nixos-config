{
  inputs,
  username,
  mkPkgsUnstable,
  mkPkgsOldWorking,
  commonOverlays,
  sharedHomeModules,
  ...
}: let
  inherit (inputs.self.lib.personal) builders;
in {
  flake.nixosConfigurations.nixos = builders.mkNixosHost {
    hostname = "nixos";
    system = "x86_64-linux";
    specialArgs = {
      inherit username;
      pkgs-unstable = mkPkgsUnstable "x86_64-linux";
      pkgs-old-working = mkPkgsOldWorking "x86_64-linux";
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
      inherit username;
      pkgs-unstable = mkPkgsUnstable "x86_64-linux";
    };
  };
}
