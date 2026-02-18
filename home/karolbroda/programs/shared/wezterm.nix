{pkgs, ...}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  rebuildCmd =
    if isDarwin
    then ''nh darwin switch ~/nix-config''
    else ''nh os switch ~/nix-config'';
in {
  catppuccin.wezterm.enable = true;

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    extraConfig = ''
      local config = wezterm.config_builder()
      local act = wezterm.action

      dofile(catppuccin_plugin).apply_to_config(config, catppuccin_config)

      local colors = {
        lavender = "#babbf1",
        mauve = "#ca9ee6",
        text = "#c6d0f5",
        subtext0 = "#a5adce",
        surface0 = "#414559",
        surface1 = "#51576d",
        base = "#303446",
        mantle = "#292c3c",
        crust = "#232634",
      }

      config.font = wezterm.font_with_fallback({
        "MonaspiceNe Nerd Font",
        "Noto Color Emoji",
      })
      config.font_size = 11.5
      config.line_height = 1.2
      config.freetype_load_flags = "NO_HINTING"

      config.enable_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true
      config.tab_bar_at_bottom = true
      config.use_fancy_tab_bar = false
      config.show_new_tab_button_in_tab_bar = false
      config.tab_max_width = 40

      config.colors = {
        tab_bar = {
          background = colors.crust,
          active_tab = {
            bg_color = colors.lavender,
            fg_color = colors.crust,
          },
          inactive_tab = {
            bg_color = colors.mantle,
            fg_color = colors.subtext0,
          },
          inactive_tab_hover = {
            bg_color = colors.surface0,
            fg_color = colors.text,
          },
        },
      }
      config.command_palette_bg_color = colors.base
      config.command_palette_fg_color = colors.text
      config.command_palette_font_size = 13

      config.window_decorations = "NONE"
      config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
      config.window_background_opacity = 0.9
      config.adjust_window_size_when_changing_font_size = false

      config.audible_bell = "Disabled"
      config.check_for_updates = false
      config.default_cursor_style = "SteadyBar"
      config.cursor_blink_rate = 0

      config.hyperlink_rules = wezterm.default_hyperlink_rules()

      config.mouse_bindings = {
        {
          event = { Up = { streak = 1, button = "Left" } },
          mods = "NONE",
          action = act.CompleteSelection("ClipboardAndPrimarySelection"),
        },
        {
          event = { Up = { streak = 1, button = "Left" } },
          mods = "CTRL",
          action = act.OpenLinkAtMouseCursor,
        },
      }

      config.launch_menu = {
        { label = "  nix rebuild", args = { "bash", "-c", "${rebuildCmd}" } },
        { label = "  nix gc", args = { "bash", "-c", "nh clean all" } },
        { label = "󰊢  lazygit", args = { "lazygit" } },
        { label = "  btop", args = { "btop" } },
      }

      config.keys = {
        { key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("DefaultDomain") },
        { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = false }) },
        { key = "h", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
        { key = "l", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
        { key = "1", mods = "ALT", action = act.ActivateTab(0) },
        { key = "2", mods = "ALT", action = act.ActivateTab(1) },
        { key = "3", mods = "ALT", action = act.ActivateTab(2) },
        { key = "4", mods = "ALT", action = act.ActivateTab(3) },
        { key = "5", mods = "ALT", action = act.ActivateTab(4) },
        { key = "6", mods = "ALT", action = act.ActivateTab(5) },
        { key = "7", mods = "ALT", action = act.ActivateTab(6) },
        { key = "8", mods = "ALT", action = act.ActivateTab(7) },
        { key = "9", mods = "ALT", action = act.ActivateTab(8) },
        { key = "m", mods = "CTRL|SHIFT", action = act.ShowLauncher },
        { key = "w", mods = "ALT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
      }

      local function get_process(tab)
        local process = tab.active_pane.foreground_process_name
        if process ~= nil and process ~= "" then
          return string.gsub(process, "(.*[/\\])(.*)", "%2")
        end
        return nil
      end

      local function get_current_dir(tab)
        local cwd_uri = tab.active_pane.current_working_dir
        if cwd_uri ~= nil then
          local cwd = cwd_uri.file_path
          if cwd ~= nil then
            return string.gsub(cwd, "(.*[/\\])(.*)", "%2")
          end
        end
        return nil
      end

      wezterm.on("format-tab-title", function(tab)
        local process = get_process(tab)
        local dir = get_current_dir(tab)

        local title = process
        if title == nil or title == "zsh" or title == "bash" or title == "fish" then
          title = dir or "shell"
        end

        local index = tab.tab_index + 1
        return string.format(" %d: %s ", index, title)
      end)

      return config
    '';
  };
}
