{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  versionCheckHook,
}: let
  librusty_v8 = let
    version = "145.0.0";
    shas = {
      x86_64-linux = "sha256-chV1PAx40UH3Ute5k3lLrgfhih39Rm3KqE+mTna6ysE=";
      aarch64-linux = "sha256-4IivYskhUSsMLZY97+g23UtUYh4p5jk7CzhMbMyqXyY=";
      x86_64-darwin = "sha256-1jUuC+z7saQfPYILNyRJanD4+zOOhXU2ac/LFoytwho=";
      aarch64-darwin = "sha256-yHa1eydVCrfYGgrZANbzgmmf25p7ui1VMas2A7BhG6k=";
    };
  in
    fetchurl {
      name = "librusty_v8-${version}";
      url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
      sha256 = shas.${stdenv.hostPlatform.system};
      meta = {
        inherit version;
        sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      };
    };
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "spacetimedb";
    version = "2.0.1";

    src = fetchFromGitHub {
      owner = "clockworklabs";
      repo = "spacetimedb";
      tag = "v${finalAttrs.version}";
      hash = "sha256-CVNL8AQRlOyj4sKwPwA4IjVb7zGCxywbPQP1z0QRA2Q=";
    };

    cargoHash = "sha256-v0QaccrTfIZy7csDYS0Hi+d4jbu0QSK36F1n5c6XadA=";

    nativeBuildInputs = [
      pkg-config
      perl
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      openssl
    ];

    cargoBuildFlags = ["-p spacetimedb-standalone -p spacetimedb-cli"];

    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    checkFlags =
      [
        "--skip=codegen"
        "--skip=publish"
      ]
      ++ lib.optionals stdenv.isDarwin [
        "--skip=cli_can_ping_spacetimedb_on_disk"
        "--skip=cli_can_publish_spacetimedb_on_disk"
        "--skip=cli_can_publish_no_conflict_does_not_delete_data"
        "--skip=cli_can_publish_no_conflict_with_delete_data_flag"
        "--skip=cli_can_publish_no_conflict_without_delete_data_flag"
        "--skip=cli_can_publish_with_automigration_change"
        "--skip=cli_cannot_publish_automigration_change_without_yes_break_clients"
        "--skip=cli_can_publish_automigration_change_with_on_conflict_and_yes_break_clients"
        "--skip=cli_cannot_publish_automigration_change_with_on_conflict_without_yes_break_clients"
        "--skip=cli_can_publish_automigration_change_with_delete_data_always_without_yes_break_clients"
        "--skip=cli_can_publish_automigration_change_with_delete_data_always_and_yes_break_clients"
        "--skip=cli_cannot_publish_breaking_change_without_flag"
        "--skip=cli_can_publish_breaking_change_with_delete_data_flag"
        "--skip=cli_can_publish_breaking_change_with_on_conflict_flag"
      ];

    doInstallCheck = true;

    env = {
      RUSTY_V8_ARCHIVE = librusty_v8;
      SPACETIMEDB_NIX_BUILD_GIT_COMMIT = finalAttrs.src.rev;
      # required to make jemalloc_tikv_sys build
      CFLAGS = "-O";
    };

    nativeInstallCheckInputs = [versionCheckHook];
    versionCheckProgram = "${placeholder "out"}/bin/spacetime";

    postInstall = ''
      mv $out/bin/spacetimedb-cli $out/bin/spacetime
    '';

    meta = {
      description = "Full-featured relational database system that lets you run your application logic inside the database";
      homepage = "https://github.com/clockworklabs/SpacetimeDB";
      license = lib.licenses.bsl11;
      mainProgram = "spacetime";
      maintainers = with lib.maintainers; [akotro];
    };
  })
