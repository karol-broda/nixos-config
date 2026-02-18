{...}: {
  programs.zed-editor.userSettings = {
    assistant = {
      enabled = true;
      version = "2";
      default_model = {
        provider = "anthropic";
        model = "claude-opus-4-5-20250514";
      };
    };
  };

  programs.zed-editor.userKeymaps = [
    {
      context = "Editor && vim_mode == normal";
      bindings = {
        "space a a" = "agent::Chat";
        "space a i" = "assistant::InlineAssist";
        "space a c" = "agent::NewThread";
      };
    }
    {
      context = "vim_mode == visual";
      bindings = {
        "space a i" = "assistant::InlineAssist";
      };
    }
  ];
}
