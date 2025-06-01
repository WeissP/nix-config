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
    programs = {
      floorp = {
        enable = true;
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
    #     PassEnvironment = [
    #       "PATH"
    #       "GTK_IM_MODULE"
    #       "QT_IM_MODULE"
    #       "XMODIFIERS"
    #     ];
    #   };
    # };
  })
]
