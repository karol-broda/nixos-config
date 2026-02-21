{pkgs, ...}: {
  programs.nixvim = {
    # claude-code-acp bridge on PATH (avante spawns it for the ACP protocol)
    extraPackages = [pkgs.claude-code-acp];

    plugins.avante = {
      enable = true;
      settings = {
        # use claude code via ACP — auth comes from your `claude /login` session
        provider = "claude-code";
        mode = "agentic";

        # override the default acp provider to use the nix-packaged bridge
        # instead of `npx -y @zed-industries/claude-code-acp`
        acp_providers = {
          "claude-code" = {
            command = "claude-code-acp";
            args = [];
            env.__raw = ''
              {
                NODE_NO_WARNINGS = "1",
                ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
                ACP_PERMISSION_MODE = "bypassPermissions",
                ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY") or "",
                CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN") or "",
              }
            '';
          };
        };

        behaviour = {
          auto_suggestions = false;
          auto_set_keymaps = false;
          auto_apply_diff_after_generation = true;
          minimize_diff = true;
          enable_token_counting = true;
          auto_focus_on_diff_view = false;
          auto_approve_tool_permissions = true;
          acp_follow_agent_locations = true;
        };

        windows = {
          position = "right";
          width = 35;
          sidebar_header = {
            enabled = true;
            align = "center";
            rounded = true;
          };
          ask = {
            floating = false;
            start_insert = true;
            border = "rounded";
          };
        };

        diff = {
          autojump = true;
        };

        hints = {
          enabled = true;
        };
      };
    };

    keymaps = [
      # sidebar
      {
        mode = "n";
        key = "<leader>aa";
        action = "<cmd>AvanteToggle<cr>";
        options.desc = "toggle avante sidebar";
      }
      {
        mode = "n";
        key = "<leader>ar";
        action = "<cmd>AvanteRefresh<cr>";
        options.desc = "refresh avante";
      }
      {
        mode = "n";
        key = "<leader>aR";
        action = "<cmd>AvanteClear<cr>";
        options.desc = "clear avante chat";
      }

      # ask / edit
      {
        mode = ["n" "v"];
        key = "<leader>ae";
        action = "<cmd>AvanteEdit<cr>";
        options.desc = "ai edit";
      }
      {
        mode = ["n" "v"];
        key = "<leader>ac";
        action = "<cmd>AvanteAsk<cr>";
        options.desc = "ai ask";
      }

      # quick actions
      {
        mode = "v";
        key = "<leader>af";
        action = "<cmd>AvanteFix<cr>";
        options.desc = "ai fix selection";
      }
      {
        mode = "v";
        key = "<leader>ax";
        action = "<cmd>AvanteExplain<cr>";
        options.desc = "ai explain selection";
      }
      {
        mode = "v";
        key = "<leader>at";
        action = "<cmd>AvanteTests<cr>";
        options.desc = "ai generate tests";
      }
      {
        mode = "v";
        key = "<leader>ad";
        action = "<cmd>AvanteDocs<cr>";
        options.desc = "ai add docs";
      }

      # diff navigation
      {
        mode = "n";
        key = "]a";
        action.__raw = "function() require('avante.diff').goto_next() end";
        options.desc = "next ai diff";
      }
      {
        mode = "n";
        key = "[a";
        action.__raw = "function() require('avante.diff').goto_prev() end";
        options.desc = "prev ai diff";
      }
    ];
  };
}
