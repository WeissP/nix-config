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
    "homeServer" = {
      id = "OSQX7ZN-HITPCGZ-UIAMHHE-R5IP2WB-G32SNOZ-OOEQLZR-OJR5TIN-UP7ZGAI";
      addresses = globalAddress;
    };
    "mini" = {
      id = "E4ALHDZ-L257CGT-Q5LLJQ3-IR4VTAZ-FN4EM5N-GIC7CHH-CC5FUYR-HG7Z3QK";
      addresses = globalAddress;
    };
    "uni" = {
      id = "CMBJKCO-A3K2VTQ-P5DBXIV-2ZNWWWU-PVHXQBV-X26OVGE-YBR3L7E-EB2BXAC";
      addresses = globalAddress;
    };
    "desktop" = {
      id = "HH3DLDT-D5HGBS3-FD42RSD-6273W2T-K6VEN7Q-45WBP4C-VLKGQHH-EDA2HAH";
      addresses = localAddress;
    };
    "iPhone" = {
      id = "TSQCB54-DQ2ZASG-4U32JBR-A267D5W-GR5IHYJ-KGOMAHA-P63BVR4-YGSI6AC";
      addresses = globalAddress;
    };
    "Mac-Air" = {
      id = "E46SRGL-J6RDKHH-2VF5O4X-6SMS2XY-CHFJUXB-DGLWXYW-ZZTMZAS-PAIZ5A4";
      addresses = globalAddress;
    };
    "iPad-mini" = {
      id = "SEGAQMH-FLWY4KU-DSDIHJ6-MZLFJEM-ROC4QGI-OXML6AB-QHKCC4X-INQILAG";
      addresses = globalAddress;
    };
    "Raspberrypi" = {
      id = "75A5Z5M-PTQ65XJ-4PHURBD-DCLT4TD-4HST4NK-5MVCW4A-QZA6VDR-3EW75QC";
      addresses = globalAddress;
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
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = lib.attrsets.filterAttrs (n: v: configSession != n) devices;
        folders =
          let
            toDevices =
              if (configSession == "RaspberryPi") then
                [
                  "desktop"
                  "homeServer"
                  "iPhone"
                  "Mac-Air"
                  "iPad-mini"
                  "uni"
                ]
              else if (configSession == "Bozhous-Air") then
                [
                  "iPhone"
                  "iPad-mini"
                  "homeServer"
                  "uni"
                ]
              else if (configSession == "homeServer") then
                [
                  "desktop"
                  "Raspberrypi"
                  "iPhone"
                  "iPad-mini"
                  "Mac-Air"
                  "uni"
                ]
              else if (configSession == "uni" || configSession == "mini") then
                [
                  "iPhone"
                  "iPad-mini"
                  "Mac-Air"
                  "homeServer"
                ]
              else
                [
                  "homeServer"
                  "iPhone"
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
              "dotconfig" = {
                id = "qf5fh-k32bj";
                path = genPath ".config";
                devices = toDevices;
              };
              "projects" = {
                id = "eu6nz-2urtd";
                path = genPath "projects";
                devices = toDevices;
              };
            }
            (lib.optionalAttrs (builtins.elem "daily" usage || configSession == "homeServer") {
              "finance" = {
                id = "ndnhp-9awzf";
                path = genPath "finance";
                devices = lib.lists.intersectLists toDevices [
                  "homeServer"
                  "desktop"
                  "iPhone"
                ];
              };
              # "podcasts" = {
              #   id = "7gogk-utgtc";
              #   path = genPath "podcasts";
              #   devices = lib.lists.intersectLists toDevices [
              #     "homeServer"
              #     "desktop"
              #   ];
              # };
            })
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
