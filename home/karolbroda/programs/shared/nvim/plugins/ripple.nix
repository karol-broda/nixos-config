{
  pkgs,
  inputs,
  ...
}: let
  ripple-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "ripple-nvim";
    version = "0.0.82";
    src = "${inputs.ripple}/packages/nvim-plugin";
  };

  tree-sitter-ripple = pkgs.stdenv.mkDerivation {
    pname = "tree-sitter-ripple";
    version = "0.2.208";
    src = "${inputs.ripple}/grammars/tree-sitter";

    buildPhase = ''
      runHook preBuild
      $CC -shared -fPIC -Os -I src src/parser.c src/scanner.c -o ripple.so
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/parser
      cp ripple.so $out/parser/ripple.so
      runHook postInstall
    '';
  };

  ripple-language-server = pkgs.buildNpmPackage {
    pname = "ripple-language-server";
    version = "0.2.208";
    src = ./ripple-lsp;
    npmDepsHash = "sha256-8UfjHSyygLOM9Gn5atr/ysUYIdJQ4ILX/5ThvT2psIE=";
    dontNpmBuild = true;
  };
in {
  programs.nixvim = {
    extraPlugins = [
      ripple-nvim
      tree-sitter-ripple
    ];

    extraPackages = [ripple-language-server];

    extraConfigLua = ''
      require("ripple").setup()
    '';
  };
}
