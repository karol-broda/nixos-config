{...}: let
  map = mode: key: action: desc: {
    inherit mode key action;
    options = {
      desc = desc;
      silent = true;
    };
  };

  nmap = map "n";
  imap = map "i";
  vmap = map "v";
  xmap = map ["n" "x"];

  remap = mode: key: action: desc: {
    inherit mode key action;
    options = {
      desc = desc;
      silent = true;
      remap = true;
    };
  };

  expr = mode: key: action: desc: {
    inherit mode key action;
    options = {
      desc = desc;
      silent = true;
      expr = true;
    };
  };
in {
  programs.nixvim.keymaps = [
    # escape
    (imap "jk" "<ESC>" "exit insert mode")
    (map ["i" "n"] "<esc>" "<cmd>noh<cr><esc>" "clear hlsearch")

    # wrapped line movement
    (expr ["n" "x"] "j" "v:count == 0 ? 'gj' : 'j'" "down")
    (expr ["n" "x"] "k" "v:count == 0 ? 'gk' : 'k'" "up")

    # window navigation
    (remap "n" "<C-h>" "<C-w>h" "go to left window")
    (remap "n" "<C-j>" "<C-w>j" "go to lower window")
    (remap "n" "<C-k>" "<C-w>k" "go to upper window")
    (remap "n" "<C-l>" "<C-w>l" "go to right window")

    # window resize
    (nmap "<C-Up>" "<cmd>resize +2<cr>" "increase window height")
    (nmap "<C-Down>" "<cmd>resize -2<cr>" "decrease window height")
    (nmap "<C-Left>" "<cmd>vertical resize -2<cr>" "decrease window width")
    (nmap "<C-Right>" "<cmd>vertical resize +2<cr>" "increase window width")

    # move lines
    (nmap "<A-j>" "<cmd>m .+1<cr>==" "move line down")
    (nmap "<A-k>" "<cmd>m .-2<cr>==" "move line up")
    (imap "<A-j>" "<esc><cmd>m .+1<cr>==gi" "move line down")
    (imap "<A-k>" "<esc><cmd>m .-2<cr>==gi" "move line up")
    (vmap "<A-j>" ":m '>+1<cr>gv=gv" "move selection down")
    (vmap "<A-k>" ":m '<-2<cr>gv=gv" "move selection up")

    # buffers
    (nmap "<S-h>" "<cmd>bprevious<cr>" "prev buffer")
    (nmap "<S-l>" "<cmd>bnext<cr>" "next buffer")
    (nmap "[b" "<cmd>bprevious<cr>" "prev buffer")
    (nmap "]b" "<cmd>bnext<cr>" "next buffer")
    (nmap "<leader>bb" "<cmd>e #<cr>" "switch to other buffer")
    (nmap "<leader>bd" "<cmd>bdelete<cr>" "delete buffer")
    (nmap "<leader>bD" "<cmd>:bd<cr>" "delete buffer and window")

    # save
    (map ["i" "x" "n" "s"] "<C-s>" "<cmd>w<cr><esc>" "save file")

    # better indenting
    (vmap "<" "<gv" "indent left")
    (vmap ">" ">gv" "indent right")

    # file explorer
    (nmap "<leader>e" "<cmd>NvimTreeToggle<cr>" "toggle file explorer")
    (nmap "<leader>o" "<cmd>NvimTreeFocus<cr>" "focus file explorer")
    (nmap "-" "<cmd>Oil<cr>" "open parent directory (oil)")

    # file
    (nmap "<leader>fn" "<cmd>enew<cr>" "new file")

    # quickfix / location list
    (nmap "<leader>xl" "<cmd>lopen<cr>" "location list")
    (nmap "<leader>xq" "<cmd>copen<cr>" "quickfix list")
    (nmap "[q" "vim.cmd.cprev" "previous quickfix")
    (nmap "]q" "vim.cmd.cnext" "next quickfix")

    # diagnostics
    (nmap "]e" ''function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end'' "next error")
    (nmap "[e" ''function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end'' "prev error")
    (nmap "]w" ''function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end'' "next warning")
    (nmap "[w" ''function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end'' "prev warning")

    # misc
    (nmap "<leader>ur" "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>" "redraw / clear hlsearch")
    (nmap "<leader>K" "<cmd>norm! K<cr>" "keywordprg")

    # clipboard
    (map ["n" "v"] "<leader>y" ''"+y'' "yank to system clipboard")
    (nmap "<leader>Y" ''"+Y'' "yank line to system clipboard")

    # increment / decrement
    (nmap "<leader>+" "<C-a>" "increment number")
    (nmap "<leader>=" "<C-x>" "decrement number")

    # windows
    (remap "n" "<leader>w" "<c-w>" "windows")
    (remap "n" "<leader>-" "<C-W>s" "split below")
    (remap "n" "<leader>|" "<C-W>v" "split right")
    (remap "n" "<leader>wd" "<C-W>c" "close window")

    # tabs
    (nmap "<leader><tab>l" "<cmd>tablast<cr>" "last tab")
    (nmap "<leader><tab>o" "<cmd>tabonly<cr>" "close other tabs")
    (nmap "<leader><tab>f" "<cmd>tabfirst<cr>" "first tab")
    (nmap "<leader><tab><tab>" "<cmd>tabnew<cr>" "new tab")
    (nmap "<leader><tab>]" "<cmd>tabnext<cr>" "next tab")
    (nmap "<leader><tab>d" "<cmd>tabclose<cr>" "close tab")
    (nmap "<leader><tab>[" "<cmd>tabprevious<cr>" "prev tab")
  ];
}
