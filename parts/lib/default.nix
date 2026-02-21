{inputs, ...}: let
  extendedLibrary = inputs.nixpkgs.lib.extend (
    final: _prev: {
      personal = {
        builders = import ./builders.nix {
          inherit inputs;
          lib = final;
        };
      };
    }
  );
in {
  flake.lib = extendedLibrary;
}
