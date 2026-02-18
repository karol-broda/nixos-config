{pkgs, ...}: {
  programs.bat = {
    enable = true;

    syntaxes.ferrule = {
      src = pkgs.fetchFromGitHub {
        owner = "karol-broda";
        repo = "ferrule";
        rev = "a264652aafc2330b13c465ca1364d0eca00ae692";
        hash = "sha256-KwOExiBZEK7ScjW7kT0ZofEC/PmAsw5sZNEy0no1UiA=";
      };
      file = "syntax/ferrule.sublime-syntax";
    };
  };
}
