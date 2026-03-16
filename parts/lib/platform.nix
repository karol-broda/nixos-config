{
  lib,
  system,
}: let
  isLinux = lib.hasSuffix "linux" system;
  isDarwin = lib.hasSuffix "darwin" system;
in {
  inherit isLinux isDarwin;

  whenLinux = attrs:
    if isLinux
    then attrs
    else {};
  whenDarwin = attrs:
    if isDarwin
    then attrs
    else {};
  always = attrs: attrs;

  mkSplitDefault = {
    linux,
    darwin,
  }:
    if isLinux
    then linux
    else darwin;

  assertLinux = condition: name: {
    assertion = condition -> isLinux;
    message = "${name} requires Linux but is enabled on ${system}";
  };

  assertDarwin = condition: name: {
    assertion = condition -> isDarwin;
    message = "${name} requires macOS (Darwin) but is enabled on ${system}";
  };
}
