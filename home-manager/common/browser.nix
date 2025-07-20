{
  pkgs,
  lib,
  myLib,
  myEnv,
  ...
}:
let
  defaultBrowserName = "floorp";
  defaultBrowserPkg = pkgs.floorp;
  defaultApp = "${defaultBrowserName}.desktop";
in
with myEnv;
lib.mkMerge [
  {
    programs = {
      # floorp.enable = true;
    };
  }
  (ifLinux {
    home.packages = with pkgs; [ firefoxpwa ];
    stylix.targets.floorp.profileNames = [ "default" ];
    stylix.targets.floorp.enable = false;
    programs = {
      floorp = {
        enable = true;
        package = pkgs.pinnedUnstables."2025-04-20".floorp;
        nativeMessagingHosts = with pkgs; [
          passff-host
          firefoxpwa
        ];
      };
      # firefox.enable = true;
      # firefox.package = pkgs.firefox.override { nativeMessagingHosts = with pkgs; [ passff-host ]; };
      # firefox.package = pkgs.firefox;
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "default-web-browser" = [ "${defaultApp}" ];
        "text/html" = [ "${defaultApp}" ];
        "x-scheme-handler/http" = [ "${defaultApp}" ];
        "x-scheme-handler/https" = [ "${defaultApp}" ];
        "x-scheme-handler/about" = [ "${defaultApp}" ];
        "x-scheme-handler/unknown" = [ "${defaultApp}" ];
      };
    };
    # systemd.user.services.start_browser = myLib.service.startup {
    #   inherit (myEnv) username;
    #   binName = defaultBrowserName;
    #   service = {
    #     Environment = [
    #       "GTK_IM_MODULE=fcitx"
    #       "QT_IM_MODULE=fcitx"
    #       "XMODIFIERS=@im=fcitx"
    #     ];
    #   };
    # };
  })
  (ifLinuxDaily {
    home.packages = with pkgs; [
      firefoxpwa
      google-chrome
    ];
    stylix.targets.firefox.profileNames = [ "default" ];
    stylix.targets.firefox.enable = false;
    programs = {
      firefox = {
        enable = true;
        nativeMessagingHosts = with pkgs; [
          passff-host
          firefoxpwa
        ];
      };
    };
  })
]
