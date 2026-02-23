{
  inputs,
  lib,
  ...
}: let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.lists) concatLists;
  inherit (lib.modules) mkDefault;
in {
  mkNixosHost = {
    hostname,
    system,
    modules ? [],
    specialArgs ? {},
    overlays ? [],
    homeUsers ? {},
    homeModules ? [],
    homeSpecialArgs ? null,
  }: let
    resolvedHomeSpecialArgs =
      if homeSpecialArgs != null
      then homeSpecialArgs
      else specialArgs;
  in
    lib.nixosSystem {
      specialArgs = recursiveUpdate {inherit inputs system;} specialArgs;
      modules = concatLists [
        [
          {
            nixpkgs.hostPlatform = mkDefault system;
            networking.hostName = mkDefault hostname;
            nixpkgs.overlays = overlays;
          }
        ]
        modules
        (lib.optionals (homeUsers != {}) [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = recursiveUpdate {inherit inputs;} resolvedHomeSpecialArgs;
              sharedModules = homeModules;
              users = homeUsers;
            };
          }
        ])
      ];
    };

  mkDarwinHost = {
    hostname,
    system,
    modules ? [],
    specialArgs ? {},
    overlays ? [],
    homeUsers ? {},
    homeModules ? [],
    homeSpecialArgs ? null,
  }: let
    resolvedHomeSpecialArgs =
      if homeSpecialArgs != null
      then homeSpecialArgs
      else specialArgs;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = recursiveUpdate {inherit inputs system;} specialArgs;
      modules = concatLists [
        [
          {
            nixpkgs.hostPlatform = mkDefault system;
            nixpkgs.overlays = overlays;
          }
        ]
        modules
        (lib.optionals (homeUsers != {}) [
          inputs.home-manager-darwin.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = recursiveUpdate {inherit inputs;} resolvedHomeSpecialArgs;
              sharedModules = homeModules;
              users = homeUsers;
            };
          }
        ])
      ];
    };
}
