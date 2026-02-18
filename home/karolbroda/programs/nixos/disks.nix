{...}: {
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
    settings = {
      device_config = [
        {
          id_uuid = "*";
          options = ["uid=1000" "gid=100" "umask=022"];
        }
      ];
    };
  };
}
