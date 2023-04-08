{ pkgs, ... }: {
  services.syncthing = {    
    enable = true;
    user = "weiss";
    dataDir = "/home/weiss/Documents";    # Default folder for new synced folders
    configDir = "/home/weiss/.config/syncthing";   # Folder for Syncthing's settings and keys
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    devices = {
      "13mini" = { id = "TSQCB54-DQ2ZASG-4U32JBR-A267D5W-GR5IHYJ-KGOMAHA-P63BVR4-YGSI6AC"; };
      "Mac-Air" = { id = "E46SRGL-J6RDKHH-2VF5O4X-6SMS2XY-CHFJUXB-DGLWXYW-ZZTMZAS-PAIZ5A4"; };
      "iPad-mini" = { id = "SEGAQMH-FLWY4KU-DSDIHJ6-MZLFJEM-ROC4QGI-OXML6AB-QHKCC4X-INQILAG"; };
      "Raspberrypi" = { id = "ZEWY7Z3-RKRCGAN-IJA5YPS-2SV5UR2-PC5FEMY-ECF4EMO-GVRIZGK-2YTPOAA"; };
    };
    folders = {
      "Documents" = {
        id = "ejsec-hhhop";
        path = "/home/weiss/Documents";    # Which folder to add to Syncthing
        devices = [ "Raspberrypi" ];      # Which devices to share the folder with
      };
      "Example" = {
        path = "/home/myusername/Example";
        devices = [ "device1" ];
        ignorePerms = false;     # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
      };
    };
  };
}

