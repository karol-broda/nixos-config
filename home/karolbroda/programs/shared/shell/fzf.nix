{...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
    defaultOptions = [
      "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796"
      "--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6"
      "--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
      "--color=selected-bg:#494d64"
      "--multi"
      "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
      "--preview-window=right:60%:wrap"
    ];
    fileWidgetCommand = "rg --files --hidden --glob '!.git/*'";
    changeDirWidgetCommand = "find . -type d -name '.git' -prune -o -type d -print | head -200";
  };
}
