{...}: {
  flake.overlays.customPkgs = _final: prev: {
    phosphorIcons = prev.callPackage ../pkgs/phosphor-icons.nix {};
  };
}
