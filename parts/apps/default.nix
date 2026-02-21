{
  perSystem = {pkgs, ...}: let
    prefetchUrlSha256 = pkgs.writeShellScriptBin "prefetch-url-sha256" ''
      if [ $# -ne 1 ]; then
        echo "usage: prefetch-url-sha256 <url>" >&2
        exit 1
      fi

      hash="$(${pkgs.nix}/bin/nix-prefetch-url "$1")"
      ${pkgs.nix}/bin/nix hash to-sri --type sha256 "$hash"
    '';
  in {
    apps = {
      prefetch-url-sha256 = {
        type = "app";
        program = "${prefetchUrlSha256}/bin/prefetch-url-sha256";
        meta.description = "Fetch a URL and print an SRI sha256 hash for Nix";
      };
    };
  };
}
