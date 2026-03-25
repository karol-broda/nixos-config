_: let
  imageTypes = [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/avif"
    "image/heic"
    "image/heif"
    "image/bmp"
    "image/tiff"
    "image/svg+xml"
    "image/x-icon"
    "image/vnd.microsoft.icon"
    "image/x-portable-pixmap"
    "image/x-portable-graymap"
    "image/x-portable-bitmap"
    "image/x-portable-anymap"
    "image/x-tga"
    "image/x-pcx"
  ];

  swayimgDesktop = "swayimg.desktop";
  defaultApps = builtins.listToAttrs (
    map (mime: {
      name = mime;
      value = [swayimgDesktop];
    })
    imageTypes
  );
in {
  xdg = {
    mimeApps.defaultApplications = defaultApps;
    configFile."mimeapps.list".force = true;
  };

  programs.swayimg = {
    enable = true;

    settings = {
      general = {
        mode = "viewer";
        position = "parent";
        size = "parent";
        sigusr1 = "reload";
        sigusr2 = "next_file";
        app_id = "swayimg";
      };

      viewer = {
        window = "#00000000";
        transparency = "grid";
        scale = "optimal";
        fixed = true;
        antialiasing = true;
        slideshow = false;
        slideshow_time = 3;
        history = 1;
        preload = 1;
      };

      gallery = {
        size = 200;
        antialiasing = false;
        window = "#00000000";
        background = "#202020";
        select = "#404040";
        border = "#ffffff";
        shadow = "#000000a0";
      };

      list = {
        order = "alpha";
        loop = true;
        recursive = false;
        all = true;
      };

      font = {
        name = "monospace";
        size = 14;
        color = "#cccccc";
        shadow = "#000000a0";
      };

      info = {
        show = true;
        info_timeout = 5;
        status_timeout = 3;
      };

      keys = {
        q = "exit";
        Escape = "exit";
        Return = "mode";
        f = "fullscreen";
        Left = "prev_file";
        Right = "next_file";
        Up = "prev_frame";
        Down = "next_frame";
        Home = "first_file";
        End = "last_file";
        Space = "animation";
        s = "slideshow";
        r = "rotate_right";
        "Shift+r" = "rotate_left";
        m = "flip_vertical";
        "Shift+m" = "flip_horizontal";
        bracketleft = "step_left 10";
        bracketright = "step_right 10";
        equal = "zoom +10";
        minus = "zoom -10";
        "0" = "zoom 100";
        BackSpace = "zoom optimal";
        a = "antialiasing";
        i = "info";
        e = "exec echo '%' | wl-copy";
        Delete = "exec rm '%'; skip_file";
      };

      mouse = {
        ScrollUp = "zoom +10";
        ScrollDown = "zoom -10";
        "Ctrl+ScrollUp" = "prev_file";
        "Ctrl+ScrollDown" = "next_file";
        "Shift+ScrollUp" = "prev_frame";
        "Shift+ScrollDown" = "next_frame";
      };
    };
  };
}
