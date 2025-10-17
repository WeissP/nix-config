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
  services.keyd = {
    enable = true;
    keyboards = {
      numpad = {
        ids = [ "062a:4101:88d72389" ];
        settings.main = {
          "kp0" = "j";
          "kpdot" = "k";
          "kpenter" = "l";
          "kpplus" = "e";
          "kp1" = "1";
          "kp2" = "2";
          "kp3" = "3";
          "kp4" = "4";
          "kp5" = "5";
          "kp6" = "6";
          "backspace" = "capslock";
        };
      };
    };
  };
}
