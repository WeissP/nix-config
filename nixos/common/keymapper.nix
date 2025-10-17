{
  pkgs,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [ keymapper ];
    etc."keymapper.conf".text = ''
      # [device = "MoErgo Glove80 Left Keyboard" class = ".scrcpy-wrapped"]
      # Y >> Z
      # Z >> Y

      [device = "RDMCTMZT Wireless 2.4G Dongle Consumer Control"]
      [device = "ZUOYA GMK26-1 Keyboard"]
      AudioVolumeUp >> Control{BracketRight}
      AudioVolumeDown >> Control{Slash}
      AudioVolumeMute >> Control{Digit0}

      [device = "MOSART Semi. 2.4G Keyboard Mouse" class = "steam_app_1810920"]
      [device = "RDMCTMZT Wireless 2.4G Dongle" class = "steam_app_1810920"]
      [device = "ZUOYA GMK26-1 Keyboard" class = "steam_app_1810920"]
      Numpad0 >> J 
      NumpadDecimal >> K 
      NumpadEnter >> L
      NumpadAdd >> E
      NumpadSubtract >> Escape
      Numpad1 >> 1
      Numpad2 >> 2
      Numpad3 >> 3
      Numpad4 >> 4
      Numpad5 >> 5
      Numpad6 >> 6
      Numpad7 >> 7
      Numpad8 >> 8
      Numpad9 >> 9
      Backspace >> CapsLock

      [device = "MOSART Semi. 2.4G Keyboard Mouse" class != "steam_app_1810920"]
      [device = "RDMCTMZT Wireless 2.4G Dongle" class != "steam_app_1810920"]
      [device = "ZUOYA GMK26-1 Keyboard" class != "steam_app_1810920"]
      Numpad0 >> $(playerctl play-pause) 
    '';
  };
  systemd.services = {
    keymapperd = {
      enable = true;
      description = "Keymapper Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.keymapper}/bin/keymapperd";
        Restart = "on-failure";
      };
    };
  };
  systemd.user.services.keymapper = {
    enable = true;
    description = "Keymapper config";
    after = [
      "graphical-session.target"
      "dbus.service"
    ];
    wantedBy = [ "graphical-session.target" ];
    path = with pkgs; [
      keymapper
      libnotify
      playerctl
      dbus
    ];
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.keymapper}/bin/keymapper";
      PassEnvironment = [
        "DISPLAY"
        "XAUTHORITY"
        "DBUS_SESSION_BUS_ADDRESS"
        "XDG_RUNTIME_DIR"
      ];
      Restart = "on-failure";
    };
  };
}
