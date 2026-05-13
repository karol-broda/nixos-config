{
  inputs,
  nixosHostArgs,
  ...
}: let
  inherit (inputs.self.lib.personal) builders;
in {
  flake.nixosConfigurations.iso = builders.mkNixosHost (nixosHostArgs
    // {
      modules =
        nixosHostArgs.modules
        ++ [
          ../../hosts/iso/configuration.nix
        ];
    });
}
