{
  stdenv,
  lib,
  dpkg,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "libfprint-2-tod1-fpc";
  version = "1.94.9+tod1-1build1";

  src = fetchurl {
    url = "https://security.ubuntu.com/ubuntu/pool/main/libf/libfprint/libfprint-2-tod1_1.94.9+tod1-1build1_amd64.deb";
    sha256 = "1fdw8cy2r6jad6jycxshj9xh7nhl9lwd7cp1y8hygm6zmcz35gph";
  };

  nativeBuildInputs = [dpkg];

  unpackPhase = ''
    dpkg-deb -x "$src" .
  '';

  installPhase = ''
    mkdir -p "$out/lib"
    if [ -d "./usr/lib" ]; then
      cp -r "./usr/lib/"* "$out/lib/"
    fi
    if [ -d "./lib" ]; then
      cp -r "./lib/"* "$out/lib/"
    fi
  '';

  driverPath = "/lib/x86_64-linux-gnu/libfprint-2/tod-1";

  meta = with lib; {
    description = "fpc fingerprint tod driver for libfprint-2";
    homepage = "https://github.com/NixOS/nixpkgs/issues/324624";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
