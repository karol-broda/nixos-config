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
in {
  flake.darwinConfigurations.macbook = builders.mkDarwinHost {
    hostname = "macbook";
    system = "aarch64-darwin";
    specialArgs = {inherit username;};
    overlays = commonOverlays;
    modules = [
      ../../modules/shared
      ../../hosts/darwin
      inputs.nix-homebrew.darwinModules.nix-homebrew
      {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          user = username;
          autoMigrate = true;
          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
          };
          mutableTaps = true;
        };
      }
    ];
    homeModules = sharedHomeModules;
    homeUsers.${username} = import ../../home/karolbroda/darwin.nix;
    homeSpecialArgs = {
      inherit username theme;
      pkgs-unstable = mkPkgsUnstable "aarch64-darwin";
    };
  };
}
