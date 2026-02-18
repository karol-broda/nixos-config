{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      avante-nvim
      nui-nvim
      plenary-nvim
      dressing-nvim
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>aa";
        action = "<cmd>AvanteToggle<cr>";
        options.desc = "toggle ai assistant";
      }
      {
        mode = "n";
        key = "<leader>ai";
        action = "<cmd>AvanteAsk<cr>";
        options.desc = "ai ask";
      }
      {
        mode = "v";
        key = "<leader>ai";
        action = "<cmd>AvanteAsk<cr>";
        options.desc = "ai ask selection";
      }
      {
        mode = "n";
        key = "<leader>ar";
        action = "<cmd>AvanteRefresh<cr>";
        options.desc = "ai refresh";
      }
    ];
  };
}
