{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "phosphor-icons";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "phosphor-icons";
    repo = "web";
    rev = "v${version}";
    hash = "sha256-96ivFjm0cBhqDKNB50klM7D3fevt8X9Zzm82KkJKMtU=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 src/bold/Phosphor-Bold.ttf -t $out/share/fonts/truetype
    install -Dm644 src/fill/Phosphor-Fill.ttf -t $out/share/fonts/truetype
    install -Dm644 src/light/Phosphor-Light.ttf -t $out/share/fonts/truetype
    install -Dm644 src/regular/Phosphor.ttf -t $out/share/fonts/truetype
    install -Dm644 src/thin/Phosphor-Thin.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A flexible icon family for interfaces, diagrams, presentations";
    homepage = "https://phosphoricons.com";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [];
  };
}
