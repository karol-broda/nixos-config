{inputs, ...}: {
  perSystem = {
    lib,
    system,
    ...
  }: let
    overlaid = import inputs.nixpkgs {
      inherit system;
      overlays = [inputs.self.overlays.customPkgs];
    };
    pkgsUnfree = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages =
      {
        phosphor-icons = overlaid.phosphorIcons;
      }
      // lib.optionalAttrs overlaid.stdenv.hostPlatform.isLinux {
        hytale-launcher = pkgsUnfree.callPackage ../pkgs/hytale-launcher {};
        libfprint-2-tod1-fpc = pkgsUnfree.callPackage ../pkgs/libfprint-2-tod1-fpc.nix {};
      };
  };
}
