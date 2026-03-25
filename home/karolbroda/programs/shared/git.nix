{
  pkgs,
  lib,
  platformOpts,
  ...
}: let
  inherit (platformOpts) isDarwin;

  opSshSignPath =
    if isDarwin
    then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    else lib.getExe' pkgs._1password-gui "op-ssh-sign";

  agentSocket =
    if isDarwin
    then "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "~/.1password/agent.sock";
in {
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        hyperlinks = true;
        syntax-theme = "Catppuccin Frappe";
      };
    };

    git = {
      enable = true;
      ignores = [".direnv/" "_tmp/" ".trees/"];

      settings = {
        user = {
          name = "Karol Broda";
          email = "karol.broda@titanom.com";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEiUadbiB7ux9bAT1XzxhjvOR7FiepZt1rf9G4EWxIxa";
        };

        gpg.format = "ssh";
        "gpg \"ssh\"".program = opSshSignPath;
        commit.gpgsign = true;
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        identityAgent = agentSocket;
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
