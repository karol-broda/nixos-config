{
  programs.superfile = {
    enable = true;

    hotkeys = {
      confirm = ["enter"];
      quit = ["ctrl+c"];

      list_up = ["k"];
      list_down = ["j"];
      page_up = ["pgup"];
      page_down = ["pgdown"];

      create_new_file_panel = ["n"];
      close_file_panel = ["q"];
      next_file_panel = ["tab"];
      previous_file_panel = ["shift+tab"];
      toggle_file_preview_panel = ["f"];
      open_sort_options_menu = ["o"];
      toggle_reverse_sort = ["R"];

      focus_on_process_bar = ["ctrl+p"];
      focus_on_sidebar = ["ctrl+s"];
      focus_on_metadata = ["ctrl+d"];

      file_panel_item_create = ["a"];
      file_panel_item_rename = ["r"];

      copy_items = ["y"];
      cut_items = ["x"];
      paste_items = ["p"];
      delete_items = ["d"];

      extract_file = ["ctrl+e"];
      compress_file = ["ctrl+a"];

      open_file_with_editor = ["e"];
      open_current_directory_with_editor = ["E"];

      pinned_directory = ["P"];
      toggle_dot_file = ["."];
      change_panel_mode = ["m"];
      open_help_menu = ["?"];
      open_command_line = [":"];
      copy_path = ["Y"];
      copy_present_working_directory = ["c"];
      toggle_footer = ["ctrl+f"];

      confirm_typing = ["enter"];
      cancel_typing = ["esc"];

      parent_directory = ["-"];
      search_bar = ["/"];

      file_panel_select_mode_items_select_down = ["J"];
      file_panel_select_mode_items_select_up = ["K"];
      file_panel_select_all_items = ["A"];
    };

    settings = {
      theme = "catppuccin-frappe";
      editor = "nvim";
      dir_editor = "nvim";
      default_sort_type = 0;
      transparent_background = false;
      auto_check_update = true;
      cd_on_quit = true;
      default_open_file_preview = true;
      show_image_preview = true;
      show_panel_footer_info = true;
      default_directory = ".";
      file_size_use_si = false;
      sort_order_reversed = false;
      case_sensitive_sort = false;
      shell_close_on_success = false;
      debug = false;
      ignore_missing_fields = false;
      code_previewer = "bat";
      nerdfont = true;
      file_preview_width = 0;
      sidebar_width = 20;
      border_top = "─";
      border_bottom = "─";
      border_left = "│";
      border_right = "│";
      border_top_left = "╭";
      border_top_right = "╮";
      border_bottom_left = "╰";
      border_bottom_right = "╯";
      border_middle_left = "├";
      border_middle_right = "┤";
      metadata = true;
      enable_md5_checksum = true;
      zoxide_support = true;
    };
  };
}
