{
  myEnv,
  lib,
  pkgs,
  ...
}:
let
  fingerprints = {
    desktop = {
      DisplayPort-0 = "00ffffffffffff0060a310201100000011220104b55021783b8cb5af4f43ab260e5054210800714081c081809500a9c0b300d1c0d100f57c70a0d0a02950302035001d4d3100001a000000fd0030a5fefe64010a202020202020000000fc004d464733344335510a20202020000000ff000a20202020202020202020202002c1020328f44990010203041f05403f23097f0783010000e200c0e305c000e6060501626200e30f00006a5e00a0a0a02950302035001d4d3100001a5b9d00a0a0a02950302035001d4d3100001ad4bc00a0a0a02950302035001d4d3100001a98e200a0a0a02950302035001d4d3100001a0000000000000000000000000000001b7012790000030164a2030104ff099f002f801f009f0528000200040043d000056f0d9f002f801f009f05280002000400eaf900056f0d9f002f801f009f05280002000400e62b01056f0d9f002f801f009f05280002000400905801056f0d9f002f801f009f052c00020004000000000000000000000000000000000000002790";
      DisplayPort-1 = "00ffffffffffff00410c0cc2ca5900001a1f0104a53c22783be445a554529e260d5054bfef00d1c0b30095008180814081c001010101565e00a0a0a029503020350055502100001ea073006aa0a029500820350055502100001a000000fc0050484c2032373545310a202020000000fd00304b72721e010a20202020202001b002031ef14b0103051404131f12021190230907078301000065030c001000023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e96005550210000188c0ad090204031200c405500555021000018f03c00d051a0355060883a0055502100001c0000000000000077";
      HDMI-A-0 = "00ffffffffffff00410c0cc2ca5900001a1f0103803c22782ae445a554529e260d5054bfef00d1c0b30095008180814081c001010101565e00a0a0a029503020350055502100001ea073006aa0a029500820350055502100001a000000fc0050484c2032373545310a202020000000fd00304b1e721e000a202020202020013c020327f14b101f051404130312021101230907078301000065030c001000681a00000101304b00023a801871382d40582c450055502100001e8c0ad08a20e02d10103e96005550210000188c0ad090204031200c405500555021000018f03c00d051a0355060883a0055502100001c00000000000000000000000000000000ad";
    };
    mini = {
      DP-4 = "00ffffffffffff001e6d415b385f0500021d010380301b78ea3135a5554ea1260c5054a54b00714f81809500b300a9c0810081c09040023a801871382d40582c4500e00e1100001e000000fd00384b1e530f010a202020202020000000fc00424b353530590a202020202020000000ff003930324e54414241433035360a011002031bf148900403011012131f230907078301000065030c001000023a801871382d40582c4500e00e1100001e000000000000000000000000000000000000011d007251d01e206e285500e00e1100001e8c0ad08a20e02d10103e9600e00e11000018000000000000000000000000000000000000000000000000000000008a";
      DP-5 = "00ffffffffffff001e6d595a0101010101180104a53c2278fa7b45a4554aa2270b5054210800714081c08100818095009040a9c0b300023a801871382d40582c450058542100001e000000fd00383d1e530f010a202020202020000000fc0032374d4236350a202020202020000000ff000a202020202020202020202020018a02031cf149900403010112011f13230907078301000065030c001000023a801871382d40582c4500fe221100001e011d8018711c1620582c2500fe221100001e011d007251d01e206e285500fe221100001e8c0ad08a20e02d10103e9600fe22110000180000000000000000000000000000000000000000000000000000008f";
      HDMI-1 = "00ffffffffffff00410c180990130000241d0103803c22782a2031a5544c9f260e5054bfef00d1c0b30095008180814081c001010101565e00a0a0a029503020350055502100001e000000ff00554b3031393336303035303038000000fd00304c1e721e000a202020202020000000fc0050484c203237324238510a202001ae020329f14b101f051404130312021101230907078301000067030c001000383c681a00000101303e00023a801871382d40582c450055502100001e8c0ad08a20e02d10103e96005550210000188c0ad090204031200c405500555021000018f03c00d051a0355060883a0055502100001c000000000000000000000000000042";
    };
  };
  fingerprint = fingerprints."${myEnv.configSession}";
in
{
  services.autorandr = {
    enable = true;
    matchEdid = true;
  };
  systemd.user.services.post-resume = {
    Unit = {
      Description = "Post-Resume Actions: restart autorandr";
      After = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    };
    Service = {
      Type = "oneshot";
      ExecStart =
        let
          exe = lib.getExe pkgs.autorandr;
        in
        ''
          ${exe} off
          ${exe} --match-edid default
        '';
    };
    Install = {
      WantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    };
  };
  # systemd.user.services.autorandr = {
  #   Unit.Description = "restart autorandr";
  #   Install.WantedBy = [ "autostart.target" ];
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = "systemctl restart autorandr.service";
  #   };
  # };
  # systemd.user.services."autorandr-hibernate" = {
  #   Unit = {
  #     Description = "Run autorandr before hibernate";
  #     Before = [ "hibernate.target" ];
  #   };
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart =
  #       let
  #         exe = lib.getExe pkgs.autorandr;
  #       in
  #       "$exe off && $exe --match-edid default";
  #   };
  #   Install.WantedBy = [ "hibernate.target" ];
  # };
  programs.autorandr = {
    enable = true;
    hooks = {
      preswitch = myEnv.ifXorg {
        stop_trayer = ''systemctl --user stop trayer'';
        stop_xmobar = ''${lib.getExe pkgs.killall} -9 xmobar'';
      };
      postswitch = myEnv.ifXorg {
        restart_xmonad = "/run/current-system/sw/bin/xmonad --restart";
        start_trayer = ''systemctl --user restart trayer'';
      };
    };
    profiles = {
      "default" = {
        inherit fingerprint;
        config =
          if myEnv.configSession == "desktop" then
            {
              DisplayPort-1 = {
                enable = true;
                mode = "3440x1440";
                position = "0x480";
                primary = true;
                rate = "60.00";
              };
              HDMI-A-0 = {
                enable = true;
                mode = "2560x1440";
                position = "3440x0";
                rate = "59.95";
                rotate = "right";
              };
            }
          else if myEnv.configSession == "mini" then
            {
              HDMI-1 = {
                enable = true;
                mode = "2560x1440";
                position = "1080x240";
                rate = "59.95";
                primary = true;
                crtc = 0;
              };
              DP-4 = {
                enable = true;
                mode = "1920x1080";
                position = "3640x600";
                crtc = 2;
                primary = false;
                rate = "60.00";
              };
              DP-5 = {
                enable = true;
                mode = "1920x1080";
                position = "0x0";
                crtc = 1;
                primary = false;
                rate = "60.00";
                rotate = "left";
              };
            }
          else
            { };
      };
    };
  };
}
