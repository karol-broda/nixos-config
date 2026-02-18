{pkgs, ...}: {
  programs.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;

    configType = "lua";
    sbarLuaPackage = pkgs.sbarlua;

    extraPackages = with pkgs; [jq];

    config = {
      source = ../sketchybar;
      recursive = true;
    };

    service = {
      enable = true;
      errorLogFile = "/tmp/sketchybar.err.log";
      outLogFile = "/tmp/sketchybar.out.log";
    };
  };

  services.jankyborders = {
    enable = true;
    package = pkgs.jankyborders;

    errorLogFile = "/tmp/jankyborders.err.log";
    outLogFile = "/tmp/jankyborders.out.log";

    settings = {
      style = "round";
      width = 6.0;
      hidpi = "on";
      active_color = "0xffcba6f7";
      inactive_color = "0xff45475a";
      blur_radius = 5.0;
    };
  };

  home.file.".config/assets/phosphor-icons".source = ../../assets/phosphor-icons;
}
