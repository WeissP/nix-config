{
  pkgs,
  lib,
  myEnv,
  ...
}:
with myEnv;
let
  devices = {
    "Desktop" = {
      id = "UYMWRJ6-DDTD5W5-DDWCPN5-UGQQL7C-UJWZFCS-2Y5TDRE-4CFMNML-LIZIIAK";
    };
    "iPhone" = {
      id = "TSQCB54-DQ2ZASG-4U32JBR-A267D5W-GR5IHYJ-KGOMAHA-P63BVR4-YGSI6AC";
    };
    "Mac-Air" = {
      id = "E46SRGL-J6RDKHH-2VF5O4X-6SMS2XY-CHFJUXB-DGLWXYW-ZZTMZAS-PAIZ5A4";
    };
    "iPad-mini" = {
      id = "SEGAQMH-FLWY4KU-DSDIHJ6-MZLFJEM-ROC4QGI-OXML6AB-QHKCC4X-INQILAG";
    };
    "Raspberrypi" = {
      id = "ZEWY7Z3-RKRCGAN-IJA5YPS-2SV5UR2-PC5FEMY-ECF4EMO-GVRIZGK-2YTPOAA";
    };
  };
in
(ifLinux {
  services.syncthing = {
    enable = true;
    user = "${username}";
    dataDir = "${homeDir}"; # Default folder for new synced folders
    configDir = "${homeDir}/.config/syncthing"; # Folder for Syncthing's settings and keys
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = true; # overrides any folders added or deleted through the WebUI
    settings = {
      devices = lib.mkMerge [
        { }
        (ifLinuxPersonal {
          inherit (devices)
            Mac-Air
            iPad-mini
            Raspberrypi
            iPhone
            ;
        })
      ];
      folders = lib.mkMerge [
        { }
        (ifPersonal {
          "Documents" = {
            id = "ejsec-hhhop";
            path = "${homeDir}/Documents"; # Which folder to add to Syncthing
            devices = [ "Raspberrypi" ]; # Which devices to share the folder with
          };
          "nix-config" = {
            id = "hwjvk-bhxn6";
            path = "${homeDir}/nix-config"; # Which folder to add to Syncthing
            devices = [ "Raspberrypi" ]; # Which devices to share the folder with
          };
          "podcasts" = {
            id = "7gogk-utgtc";
            path = "${homeDir}/podcasts"; # Which folder to add to Syncthing
            devices = [ "Raspberrypi" ]; # Which devices to share the folder with
          };
          "projects" = {
            id = "eu6nz-2urtd";
            path = "${homeDir}/projects"; # Which folder to add to Syncthing
            devices = [ "Raspberrypi" ]; # Which devices to share the folder with
          };
          "finance" = {
            id = "ndnhp-9awzf";
            path = "${homeDir}/finance"; # Which folder to add to Syncthing
            devices = [ "Raspberrypi" ]; # Which devices to share the folder with
          };
          "dotconfig" = {
            id = "qf5fh-k32bj";
            path = "${homeDir}/.config"; # Which folder to add to Syncthing
            devices = [ "Raspberrypi" ]; # Which devices to share the folder with
          };
        })
      ];
    };
  };
}

)
