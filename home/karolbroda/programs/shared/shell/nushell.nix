{pkgs, ...}: {
  programs.nushell = {
    enable = true;
    package = pkgs.nushell;

    envFile.text = ''
      $env.EDITOR = "nvim"
      $env.DO_NOT_TRACK = "1"

      let local_bin = ($nu.home-path | path join ".local" "bin")
      if (($local_bin | path exists) == true) {
        let in_path = ($env.PATH | any {|p| $p == $local_bin })
        if ($in_path == false) {
          $env.PATH = ($env.PATH | append $local_bin)
        }
      }
    '';

    configFile.text = '''';

    environmentVariables = {
      PAGER = "less -R";
    };

    shellAliases = {
      pls = "sudo";
      ll = "eza -lhA";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      k = "kubectl";
      ls = "eza";
    };
  };
}
