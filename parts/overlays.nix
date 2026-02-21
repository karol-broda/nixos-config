{
  flake.overlays = {
    phosphor = final: prev: {
      phosphorIcons = prev.callPackage ../pkgs/phosphor-icons.nix {};
    };
  };
}
