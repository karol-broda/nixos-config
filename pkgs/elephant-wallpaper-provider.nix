{
  elephant-providers,
  wallpaper-source,
}:
elephant-providers.overrideAttrs {
  pname = "elephant-wallpaper-provider";

  preBuild = ''
    cp -r ${wallpaper-source} ./internal/providers/wallpaper
  '';

  buildPhase = ''
    runHook preBuild
    go build -buildmode=plugin -o wallpaper.so ./internal/providers/wallpaper
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/elephant/providers
    cp wallpaper.so $out/lib/elephant/providers/
    runHook postInstall
  '';
}
