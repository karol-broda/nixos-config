_: {
  programs.nixvim.opts = {
    # line numbers
    number = true;
    relativenumber = true;

    # indentation
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    smartindent = true;

    # search
    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg --vimgrep";

    # appearance
    cursorline = true;
    termguicolors = true;
    background = "dark";
    signcolumn = "yes";
    laststatus = 3;
    showmatch = true;
    cmdheight = 1;
    pumheight = 10;
    pumblend = 10;
    smoothscroll = true;

    # splits
    splitright = true;
    splitbelow = true;

    # no backup files, persistent undo instead
    swapfile = false;
    backup = false;
    writebackup = false;
    undofile = true;
    undolevels = 10000;

    # interaction
    mouse = "a";
    updatetime = 250;
    timeoutlen = 300;
    scrolloff = 8;
    sidescrolloff = 8;
    virtualedit = "block";
    confirm = true;

    # encoding
    encoding = "utf-8";
    fileencoding = "utf-8";

    # completion
    completeopt = "menu,menuone,noselect";

    # folding (treesitter-based)
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldlevel = 99;
    foldlevelstart = 99;
    fillchars = {
      eob = " ";
      fold = " ";
      foldopen = "▼";
      foldsep = " ";
      foldclose = "▶";
    };

    # whitespace rendering (only show tabs and trailing)
    list = true;
    listchars = {
      tab = "→ ";
      trail = "•";
      nbsp = "␣";
      extends = "⟩";
      precedes = "⟨";
    };

    # misc
    wrap = false;
    autoread = true;
    shortmess = "atOIcF";
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
  };
}
