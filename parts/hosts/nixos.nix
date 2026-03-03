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
  system = "x86_64-linux";
  pkgs-hypr = {
    inherit (inputs.hyprnix.packages.${system}) hyprland xdg-desktop-portal-hyprland hyprlock hyprpaper;
  };
  elephant-wallpaper-provider = inputs.elephant.packages.${system}.elephant-providers.overrideAttrs {
    pname = "elephant-wallpaper-provider";

    preBuild = ''
      cp -r ${../../providers/wallpaper} ./internal/providers/wallpaper
    '';

    buildPhase = ''
      runHook preBuild
      go build -buildmode=plugin -o wallpaper.so ./internal/providers/wallpaper
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/elephant/providers
      cp wallpaper.so $out/lib/elephant/providers/
      runHook postInstall
    '';
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
      inherit username pkgs-hypr elephant-wallpaper-provider;
      pkgs-unstable = mkPkgsUnstable system;
    };
  };
}
