{...}: {
  programs.hyprlock = {
    enable = true;

    settings = {
      "$base" = "rgb(303446)";
      "$surface0" = "rgb(414559)";
      "$text" = "rgb(c6d0f5)";
      "$textAlpha" = "c6d0f5";
      "$lavender" = "rgb(babbf1)";
      "$lavenderAlpha" = "babbf1";
      "$red" = "rgb(e78284)";
      "$yellow" = "rgb(e5c890)";

      "$font" = "Monaspace Argon";
      "$iconsPath" = "~/.config/quickshell/default/assets/phosphor-icons/bold";

      general = {
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          path = "~/Pictures/Wallpapers/angel.jpg";
          blur_passes = 0;
          color = "$base";
        }
      ];

      image = [
        {
          monitor = "";
          path = "$iconsPath/keyboard-bold.svg";
          size = 18;
          border_size = 0;
          rounding = 0;
          position = "30, -28";
          halign = "left";
          valign = "top";
        }
        {
          monitor = "";
          path = "$iconsPath/battery-full-bold.svg";
          size = 18;
          border_size = 0;
          rounding = 0;
          position = "30, -53";
          halign = "left";
          valign = "top";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$LAYOUT";
          color = "$text";
          font_size = 14;
          font_family = "$font";
          position = "55, -30";
          halign = "left";
          valign = "top";
        }
        {
          monitor = "";
          text = "cmd[update:30000] cat /sys/class/power_supply/BAT*/capacity | head -1 | xargs -I{} echo '{}%'";
          color = "$text";
          font_size = 14;
          font_family = "$font";
          position = "55, -55";
          halign = "left";
          valign = "top";
        }
        {
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = 90;
          font_family = "$font";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
          color = "$text";
          font_size = 25;
          font_family = "$font";
          position = "-30, -120";
          halign = "right";
          valign = "top";
        }
      ];
      "input-field" = [
        {
          monitor = "";
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "$lavender";
          inner_color = "$surface0";
          font_color = "$text";
          font_family = "$font";
          fade_on_empty = false;
          placeholder_text = "<span foreground=\"##$textAlpha\"><i>logged in as </i><span foreground=\"##$lavenderAlpha\">$USER</span></span>";
          hide_input = false;
          check_color = "$lavender";
          fail_color = "$red";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "$yellow";
          position = "0, 100";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
