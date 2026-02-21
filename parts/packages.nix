{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    pkgsUnfree = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages =
      {
        phosphor-icons = pkgs.callPackage ../pkgs/phosphor-icons.nix {};
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        hytale-launcher = pkgsUnfree.callPackage ../pkgs/hytale-launcher.nix {};
        libfprint-2-tod1-fpc = pkgsUnfree.callPackage ../pkgs/libfprint-2-tod1-fpc.nix {};
      };
  };
}
