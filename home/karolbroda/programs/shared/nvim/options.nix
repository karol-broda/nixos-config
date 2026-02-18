{...}: {
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;

    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    autoindent = true;
    smartindent = true;

    wrap = false;

    ignorecase = true;
    smartcase = true;
    hlsearch = true;
    incsearch = true;

    cursorline = true;

    termguicolors = true;
    background = "dark";
    signcolumn = "yes";

    backspace = "indent,eol,start";

    clipboard = "unnamedplus";

    splitright = true;
    splitbelow = true;

    swapfile = false;
    backup = false;
    writebackup = false;

    completeopt = "menu,menuone,noselect";
    pumheight = 10;
    pumblend = 10;

    undofile = true;
    undolevels = 10000;
    undoreload = 10000;

    mouse = "a";

    updatetime = 250;

    timeoutlen = 300;

    scrolloff = 8;
    sidescrolloff = 8;

    encoding = "utf-8";
    fileencoding = "utf-8";

    cmdheight = 1;
    showcmd = true;

    laststatus = 3;

    showmatch = true;

    foldmethod = "expr";
    foldexpr = "nvim_treesitter#foldexpr()";
    foldenable = false;
    foldlevel = 99;
    foldlevelstart = 99;
    foldcolumn = "1";
    fillchars = {
      eob = " ";
      fold = " ";
      foldopen = "▼";
      foldsep = " ";
      foldclose = "▶";
    };

    list = true;
    listchars = {
      tab = "→ ";
      eol = "¬";
      nbsp = "␣";
      lead = "·";
      space = "·";
      trail = "•";
      extends = "⟩";
      precedes = "⟨";
    };

    winblend = 0;
    wildmenu = true;
    wildmode = "longest:full,full";
    wildoptions = "pum";

    conceallevel = 0;
    concealcursor = "";

    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";

    spell = false;
    spelllang = ["en_us"];

    autoread = true;

    confirm = true;

    hidden = true;

    shortmess = "atOIcF";

    directory = "/tmp//";
    backupdir = "/tmp//";
    undodir = "/tmp//";
  };
}
