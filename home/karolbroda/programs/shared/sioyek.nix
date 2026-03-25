_: {
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = ["sioyek.desktop"];
  };

  programs.sioyek = {
    enable = true;

    config = {
      background_color = "#303446";
      dark_mode_background_color = "#303446";
      custom_color_mode_empty_background_color = "#303446";

      text_highlight_color = "#e5c890";
      visual_mark_color = "#838ba7";
      search_highlight_color = "#e5c890";
      link_highlight_color = "#8caaee";
      synctex_highlight_color = "#a6d189";

      highlight_color_a = "#e5c890";
      highlight_color_b = "#a6d189";
      highlight_color_c = "#99d1db";
      highlight_color_d = "#ea999c";
      highlight_color_e = "#ca9ee6";
      highlight_color_f = "#e78284";
      highlight_color_g = "#e5c890";

      custom_background_color = "#303446";
      custom_text_color = "#c6d0f5";

      ui_text_color = "#c6d0f5";
      ui_background_color = "#414559";
      ui_selected_text_color = "#c6d0f5";
      ui_selected_background_color = "#626880";

      status_bar_color = "#414559";
      status_bar_text_color = "#c6d0f5";

      page_separator_color = "#414559";
      page_separator_width = "2";

      should_launch_new_window = "1";
      check_for_updates_on_startup = "0";
      should_load_tutorial_when_no_other_file = "0";
      startup_commands = "toggle_custom_color";

      touchpad_sensitivity = "1.0";
      vertical_move_amount = "1.0";
      horizontal_move_amount = "1.0";
      move_screen_ratio = "0.5";

      zoom_inc_factor = "1.2";
      wheel_zoom_on_cursor = "1";

      ruler_mode = "1";
      ruler_padding = "1.5";
      ruler_x_padding = "5.0";
      visual_mark_next_page_fraction = "0.75";
      visual_mark_next_page_threshold = "0.25";

      flat_toc = "0";
      collapsed_toc = "0";
      multiline_menus = "1";
      sort_bookmarks_by_location = "1";

      rerender_overview = "1";
      prerender_next_page_presentation = "1";
      super_fast_search = "1";

      create_table_of_contents_if_not_exists = "1";
      max_created_toc_size = "5000";
    };

    bindings = {
      move_up = "k";
      move_down = "j";
      move_left = "h";
      move_right = "l";

      screen_down = ["<space>" "J" "<pagedown>"];
      screen_up = ["<S-<space>>" "K" "<pageup>"];

      goto_beginning = ["gg" "<C-<home>>"];
      goto_end = ["G" "<end>"];
      next_chapter = "gc";
      prev_chapter = "gC";

      prev_state = ["<backspace>" "<C-o>"];
      next_state = ["<S-<backspace>>" "<C-i>"];

      search = ["/" "<C-f>"];
      next_item = "n";
      previous_item = "N";

      add_bookmark = "b";
      delete_bookmark = "db";
      goto_bookmark = "gb";
      goto_bookmark_g = "gB";

      add_highlight = "H";
      delete_highlight = "dh";
      goto_highlight = "gh";
      goto_highlight_g = "gH";
      goto_next_highlight = "]h";
      goto_prev_highlight = "[h";

      set_mark = "m";
      goto_mark = "'";

      toggle_dark_mode = "<f8>";
      toggle_presentation_mode = "<f5>";
      toggle_fullscreen = "<f11>";

      fit_to_page_width = "=";
      fit_to_page_width_smart = "<f10>";
      zoom_in = "+";
      zoom_out = "-";

      open_link = "f";
      keyboard_select = "v";
      keyboard_smart_jump = "F";

      open_document = "o";
      open_document_embedded = "<C-o>";
      open_prev_doc = "O";

      goto_toc = "t";

      portal = "p";
      delete_portal = "dp";
      goto_portal = ["gp" "<tab>"];

      copy = "<C-c>";

      quit = "q";
      command = ":";
      rotate_clockwise = "r";
      rotate_counterclockwise = "R";
      toggle_visual_scroll = "<f7>";
    };
  };
}
