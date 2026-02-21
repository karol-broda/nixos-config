{inputs, ...}: {
  _module.args = {
    username = "karolbroda";

    mkPkgsUnstable = system:
      import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

    mkPkgsOldWorking = system:
      import inputs.nixpkgs-old-working {
        inherit system;
        config.allowUnfree = true;
      };
  };
}
