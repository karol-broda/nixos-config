{inputs, ...}: {
  flake.overlays.customPkgs = _final: prev: let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit (prev) system;
      config.allowUnfree = true;
    };
  in {
    phosphorIcons = prev.callPackage ../pkgs/phosphor-icons.nix {};
    spacetimedb = pkgs-unstable.callPackage ../pkgs/spacetimedb.nix {};
  };
}
