{
  lib,
  myEnv,
  secrets,
  ...
}:
with myEnv;
let
  relayCfg = rec {
    port = 22067;
    statusPort = 22070;
    id = "DCJGVXZ-24YYWZH-PKMUADC-ZNXQPSR-R5TNJAC-WIPWXPV-TMGXAIX-5CFKEAA";
    token = secrets.syncthing.relayToken;
    address = "relay://${secrets.nodes.Vultr.publicIp}:${toString port}?id=${id}&token=${token}";
  };
  localAddress = [
    "tcp://0.0.0.0:22000"
    "quic://0.0.0.0:22000"
  ];
  globalAddress = [
    "tcp://0.0.0.0:22000"
    "quic://0.0.0.0:22000"
    relayCfg.address
    "dynamic"
  ];
  devices = {
    "mini" = {
      id = "NXP4C4L-H3RUREP-TF3IJGV-75KL3EY-2JZVEOF-OBZX2KF-BQPO236-AHVF4AU";
      address = globalAddress;
    };
    "Desktop" = {
      id = "MCEQ2JV-HSSFYQ7-T7ON2HM-UBJWV7W-P5QT6HP-HKGGKVR-FHKBVWX-XGG2IQN";
      address = localAddress;
    };
    "iPhone" = {
      id = "TSQCB54-DQ2ZASG-4U32JBR-A267D5W-GR5IHYJ-KGOMAHA-P63BVR4-YGSI6AC";
      address = globalAddress;
    };
    "Mac-Air" = {
      id = "E46SRGL-J6RDKHH-2VF5O4X-6SMS2XY-CHFJUXB-DGLWXYW-ZZTMZAS-PAIZ5A4";
      address = globalAddress;
    };
    "iPad-mini" = {
      id = "SEGAQMH-FLWY4KU-DSDIHJ6-MZLFJEM-ROC4QGI-OXML6AB-QHKCC4X-INQILAG";
      address = globalAddress;
    };
    "Raspberrypi" = {
      id = "75A5Z5M-PTQ65XJ-4PHURBD-DCLT4TD-4HST4NK-5MVCW4A-QZA6VDR-3EW75QC";
      address = globalAddress;
    };
  };
  nodeInfo = secrets.nodes."${configSession}";
in
lib.mkMerge [
  (ifUsage "syncthing-relay-server" {
    networking.firewall.allowedTCPPorts = [
      22067
      22070
    ];
    services.syncthing = {
      relay = with relayCfg; {
        inherit port statusPort;
        enable = true;
        providedBy = "my private relay server";
        pools = [ ''""'' ];
        extraOptions = [ "--token=${token}" ];
      };
    };
  })
  (lib.optionalAttrs (arch == "linux" && !(builtins.elem "remote-server" usage)) {
    services.syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "${homeDir}"; # Default folder for new synced folders
      configDir = "${homeDir}/.config/syncthing"; # Folder for Syncthing's settings and keys
      overrideDevices = false;
      overrideFolders = false;
      settings = {
        devices = lib.attrsets.filterAttrs (n: v: configSession != n) devices;
        folders =
          let
            toDevices =
              if (configSession == "RaspberryPi") then
                [
                  "Desktop"
                  "mini"
                  "iPhone"
                  "Mac-Air"
                  "iPad-mini"
                ]
              else if (configSession == "Bozhous-Air") then
                [
                  "iPhone"
                  "iPad-mini"
                  "mini"
                ]
              else if (configSession == "mini") then
                [
                  "Desktop"
                  "Raspberrypi"
                  "iPhone"
                  "iPad-mini"
                  "Mac-Air"
                ]
              else
                [
                  "Raspberrypi"
                  "mini"
                  "Mac-Air"
                ];
            genPath =
              name:
              if (configSession == "RaspberryPi") then "${homeDir}/syncthing/${name}" else "${homeDir}/${name}";
          in
          lib.mkMerge [
            {
              "Documents" = {
                id = "ejsec-hhhop";
                path = genPath "Documents";
                devices = toDevices;
              };
              "nix-config" = {
                id = "hwjvk-bhxn6";
                path = genPath "nix-config";
                devices = toDevices;
              };
              "podcasts" = {
                id = "7gogk-utgtc";
                path = genPath "podcasts";
                devices = toDevices;
              };
              "projects" = {
                id = "eu6nz-2urtd";
                path = genPath "projects";
                devices = toDevices;
              };
              "finance" = {
                id = "ndnhp-9awzf";
                path = genPath "finance";
                devices = toDevices;
              };
              "dotconfig" = {
                id = "qf5fh-k32bj";
                path = genPath ".config";
                devices = toDevices;
              };
            }
          ];
      };
    };
  })
  (ifLocalServer {
    networking.firewall.allowedTCPPorts = [
      8384
      22000
    ];
    services.syncthing = {
      guiAddress = "${nodeInfo.localIp}:8384";
      settings.gui = {
        user = "${username}";
        password = nodeInfo.password.raw;
      };
    };
  })
]
