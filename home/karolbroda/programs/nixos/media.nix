_: {
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        autosens = 1;
        sensitivity = 100;
        gravity = 80;
        lower_cutoff_freq = 50;
        upper_cutoff_freq = 14000;
        sleep_timer = 0;
        channels = "auto";
      };

      input = {
        method = "pipewire";
        source = "auto";
      };

      output = {
        method = "ncurses";
        mono_opt = 0;
      };

      smoothing = {
        monstercat = 1;
        waves = 0;
        noise_reduction = 88;
        integral = 0;
      };
    };
  };
}
