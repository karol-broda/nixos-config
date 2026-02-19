{pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = ["ignoredups" "ignorespace"];
    historySize = 10000;
    historyFileSize = 10000;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    initExtra = ''
      export DO_NOT_TRACK=1
      export EDITOR="nvim"
    '';

    shellAliases = {
      pls = "sudo ";
      ll = "ls -lhA";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      k = "kubectl ";
      ls = "${pkgs.eza}/bin/eza";
      jq = "${pkgs.jq}/bin/jq -C";
      cat = "${pkgs.bat}/bin/bat --style=plain --paging=never --color=always";
    };
  };
}
