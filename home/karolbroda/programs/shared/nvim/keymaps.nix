{...}: {
  programs.nixvim.keymaps = [
    {
      mode = "i";
      key = "jk";
      action = "<ESC>";
      options = {
        desc = "exit insert mode with jk";
        noremap = true;
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>NvimTreeToggle<CR>";
      options = {
        desc = "toggle file explorer";
        noremap = true;
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>o";
      action = "<cmd>NvimTreeFocus<CR>";
      options = {
        desc = "focus file explorer";
        noremap = true;
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<leader>nh";
      action = ":nohl<CR>";
      options = {
        desc = "clear search highlights";
        noremap = true;
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options = {
        desc = "escape and clear hlsearch";
        noremap = true;
        silent = true;
      };
    }

    {
      mode = ["n" "x"];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        desc = "down";
        expr = true;
        silent = true;
      };
    }

    {
      mode = ["n" "x"];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        desc = "up";
        expr = true;
        silent = true;
      };
    }

    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "go to left window";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "go to lower window";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "go to upper window";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "go to right window";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options = {
        desc = "increase window height";
      };
    }

    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options = {
        desc = "decrease window height";
      };
    }

    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options = {
        desc = "decrease window width";
      };
    }

    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options = {
        desc = "increase window width";
      };
    }

    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>m .+1<cr>==";
      options = {
        desc = "move line down";
      };
    }

    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>m .-2<cr>==";
      options = {
        desc = "move line up";
      };
    }

    {
      mode = "i";
      key = "<A-j>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options = {
        desc = "move line down";
      };
    }

    {
      mode = "i";
      key = "<A-k>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options = {
        desc = "move line up";
      };
    }

    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<cr>gv=gv";
      options = {
        desc = "move line down";
      };
    }

    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<cr>gv=gv";
      options = {
        desc = "move line up";
      };
    }

    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options = {
        desc = "prev buffer";
      };
    }

    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options = {
        desc = "next buffer";
      };
    }

    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options = {
        desc = "prev buffer";
      };
    }

    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options = {
        desc = "next buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>bb";
      action = "<cmd>e #<cr>";
      options = {
        desc = "switch to other buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bdelete<cr>";
      options = {
        desc = "delete buffer";
      };
    }

    {
      mode = "n";
      key = "<leader>bD";
      action = "<cmd>:bd<cr>";
      options = {
        desc = "delete buffer and window";
      };
    }

    {
      mode = ["i" "n"];
      key = "<esc>";
      action = "<cmd>noh<cr><esc>";
      options = {
        desc = "escape and clear hlsearch";
      };
    }

    {
      mode = ["i" "x" "n" "s"];
      key = "<C-s>";
      action = "<cmd>w<cr><esc>";
      options = {
        desc = "save file";
      };
    }

    {
      mode = "n";
      key = "<leader>K";
      action = "<cmd>norm! K<cr>";
      options = {
        desc = "keywordprg";
      };
    }

    {
      mode = "v";
      key = "<";
      action = "<gv";
      options = {
        desc = "indent left";
      };
    }

    {
      mode = "v";
      key = ">";
      action = ">gv";
      options = {
        desc = "indent right";
      };
    }

    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>enew<cr>";
      options = {
        desc = "new file";
      };
    }

    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>lopen<cr>";
      options = {
        desc = "location list";
      };
    }

    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>copen<cr>";
      options = {
        desc = "quickfix list";
      };
    }

    {
      mode = "n";
      key = "[q";
      action = "vim.cmd.cprev";
      options = {
        desc = "previous quickfix";
      };
    }

    {
      mode = "n";
      key = "]q";
      action = "vim.cmd.cnext";
      options = {
        desc = "next quickfix";
      };
    }

    {
      mode = "n";
      key = "<leader>cd";
      action = "vim.diagnostic.open_float";
      options = {
        desc = "line diagnostics";
      };
    }

    {
      mode = "n";
      key = "]d";
      action = "vim.diagnostic.goto_next";
      options = {
        desc = "next diagnostic";
      };
    }

    {
      mode = "n";
      key = "[d";
      action = "vim.diagnostic.goto_prev";
      options = {
        desc = "prev diagnostic";
      };
    }

    {
      mode = "n";
      key = "]e";
      action = ''function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end'';
      options = {
        desc = "next error";
      };
    }

    {
      mode = "n";
      key = "[e";
      action = ''function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end'';
      options = {
        desc = "prev error";
      };
    }

    {
      mode = "n";
      key = "]w";
      action = ''function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end'';
      options = {
        desc = "next warning";
      };
    }

    {
      mode = "n";
      key = "[w";
      action = ''function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end'';
      options = {
        desc = "prev warning";
      };
    }

    {
      mode = "n";
      key = "<leader>ur";
      action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
      options = {
        desc = "redraw / clear hlsearch / diff update";
      };
    }

    {
      mode = ["n" "v"];
      key = "<leader>y";
      action = ''"+y'';
      options = {
        desc = "copy to system clipboard";
      };
    }

    {
      mode = "n";
      key = "<leader>Y";
      action = ''"+Y'';
      options = {
        desc = "copy line to system clipboard";
      };
    }

    {
      mode = "n";
      key = "<leader>+";
      action = "<C-a>";
      options = {
        desc = "increment number";
      };
    }

    {
      mode = "n";
      key = "<leader>-";
      action = "<C-x>";
      options = {
        desc = "decrement number";
      };
    }

    {
      mode = "n";
      key = "<leader>w";
      action = "<c-w>";
      options = {
        desc = "windows";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<leader>-";
      action = "<C-W>s";
      options = {
        desc = "split window below";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<leader>|";
      action = "<C-W>v";
      options = {
        desc = "split window right";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<leader>wd";
      action = "<C-W>c";
      options = {
        desc = "delete window";
        remap = true;
      };
    }

    {
      mode = "n";
      key = "<leader><tab>l";
      action = "<cmd>tablast<cr>";
      options = {
        desc = "last tab";
      };
    }

    {
      mode = "n";
      key = "<leader><tab>o";
      action = "<cmd>tabonly<cr>";
      options = {
        desc = "close other tabs";
      };
    }

    {
      mode = "n";
      key = "<leader><tab>f";
      action = "<cmd>tabfirst<cr>";
      options = {
        desc = "first tab";
      };
    }

    {
      mode = "n";
      key = "<leader><tab><tab>";
      action = "<cmd>tabnew<cr>";
      options = {
        desc = "new tab";
      };
    }

    {
      mode = "n";
      key = "<leader><tab>]";
      action = "<cmd>tabnext<cr>";
      options = {
        desc = "next tab";
      };
    }

    {
      mode = "n";
      key = "<leader><tab>d";
      action = "<cmd>tabclose<cr>";
      options = {
        desc = "close tab";
      };
    }

    {
      mode = "n";
      key = "<leader><tab>[";
      action = "<cmd>tabprevious<cr>";
      options = {
        desc = "previous tab";
      };
    }
  ];
}
