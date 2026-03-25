_: let
  button = key: icon: label: action: shortcut: {
    type = "button";
    val = "${icon}  ${label}";
    on_press.__raw = action;
    opts = {
      keymap = ["n" key ":${shortcut}<CR>" {}];
      inherit shortcut;
      position = "center";
      cursor = 3;
      width = 50;
      align_shortcut = "right";
      hl_shortcut = "Keyword";
    };
  };
in {
  programs.nixvim.plugins.alpha = {
    enable = true;
    settings.layout = [
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = [
          "        ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          "
          "         ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       "
          "               ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     "
          "                ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    "
          "               ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   "
          "        ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  "
          "       ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   "
          "      ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  "
          "      ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ "
          "           ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     "
          "            ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     "
          ""
          "                   · neovim ·                   "
        ];
        opts = {
          position = "center";
          hl = "String";
        };
      }
      {
        type = "text";
        val.__raw = ''
          (function()
            local taglines = {
              "embrace the flow",
              "edit. think. flow.",
              "modal mastery",
              "keystrokes matter",
              "think in motions",
              "where text meets thought",
            }
            math.randomseed(os.time() + 1)
            return { "- " .. taglines[math.random(#taglines)] .. " -" }
          end)()
        '';
        opts = {
          position = "center";
          hl = "String";
        };
      }
      {
        type = "padding";
        val = 1;
      }
      {
        type = "text";
        val.__raw = ''
          (function()
            local quotes = {
              "\"when in doubt, use brute force\" - ken thompson",
              "\"premature optimization is the root of all evil\" - donald knuth",
              "\"make everything as simple as possible, but not simpler\" - albert einstein",
              "\"talk is cheap. show me the code\" - linus torvalds",
              "\"a language that doesn't affect the way you think about programming is not worth knowing\" - alan perlis",
            }
            math.randomseed(os.time())
            return { "  " .. quotes[math.random(#quotes)] }
          end)()
        '';
        opts = {
          position = "center";
          hl = "Comment";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          (button "ff" "" "find files"
            "function() require('telescope.builtin').find_files() end"
            "SPC f f")
          (button "fr" "" "recent files"
            "function() require('telescope.builtin').oldfiles() end"
            "SPC f r")
          (button "fg" "󰱼" "find text"
            "function() require('telescope.builtin').live_grep() end"
            "SPC f g")
          (button "ee" "" "file explorer"
            "function() vim.cmd('NvimTreeToggle') end"
            "SPC e")
          (button "fn" "" "new file"
            "function() vim.cmd('ene | startinsert') end"
            "SPC f n")
          (button "fc" "" "configuration"
            "function() require('telescope.builtin').find_files({cwd = '~/nix-config'}) end"
            "SPC f c")
          (button "qq" "" "quit"
            "function() vim.cmd('qa') end"
            "SPC q q")
        ];
      }
      {
        type = "padding";
        val = 1;
      }
    ];
  };
}
