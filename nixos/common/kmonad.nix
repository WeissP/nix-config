{
  pkgs,
  lib,
  myEnv,
  secrets,
  config,
  inputs,
  outputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [ kmonad ];
  services.kmonad = {
    enable = true;
    keyboards = {
      numpad =
        let 
          device = "/dev/input/by-id/usb-MOSART_Semi._2.4G_Keyboard_Mouse-event-kbd";
        in
        {
          inherit device;
          config = ''
            (defcfg
                input (device-file "${device}")
                output (uinput-sink "numpad")
                fallthrough true
            )

            (defsrc
             nlck kp/  kp*  bspc
             kp7  kp8  kp9  kp-
             kp4  kp5  kp6  kp+
             kp1  kp2  kp3  kprt
             kp0  kp.
            )
            (deflayer main
             nlck /  *  caps
             7  8  9  -
             4  5  6  e
             1  2  3  l
             j    k
            )
          '';
        };
    };
  };
}
