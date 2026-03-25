{inputs, ...}: {
  _module.args = {
    username = "karolbroda";
    theme = import ../lib/theme.nix {inherit (inputs.nixpkgs) lib;};

    mkPkgsUnstable = system:
      import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

    mkPkgsOldWorking = system:
      import inputs.nixpkgs-old-working {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "libxml2-2.13.8"
          ];
        };
      };
  };
}
