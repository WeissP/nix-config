{

  inputs,
  outputs,
  myEnv,
  # location,
  lib,
  config,
  pkgs,
  secrets,
  myLib,
  ...
}:
with myEnv;
{
  home.file = {
    "${homeDir}/.ssh/id_rsa".text = secrets.ssh."163".private;
    "${secrets.ssh.uni.privateFilePath}".text = secrets.ssh.uni.private;
    "${secrets.ssh.uni.publicFilePath}".text = secrets.ssh.uni.public;
    "${secrets.ssh."163".privateFilePath}".text = secrets.ssh."163".private;
    "${secrets.ssh."163".publicFilePath}".text = secrets.ssh."163".public;
  };
  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "vultr" = {
          hostname = secrets.nodes.Vultr.publicIp;
          user = username;
        };
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };

      }
      // (lib.optionalAttrs (myEnv.location == "home" && myEnv.configSession != "homeServer") {
        "home-server" = {
          hostname = secrets.nodes.homeServer.localIp;
          user = username;
        };
      })
      // (lib.optionalAttrs (myEnv.location == "uni") {
        "home-server" = {
          hostname = secrets.nodes.homeServer.tailscale.ipv4;
          user = username;
        };
        "uni-cluster" = with secrets.nodes.uniCluster; {
          inherit user;
          hostname = localIp;
        };
      });
    };
    sftpman = {
      enable = true;
      mounts = {
        vultr = {
          authType = "publickey";
          host = secrets.nodes.Vultr.publicIp;
          mountPoint = "/";
          sshKey = secrets.ssh."163".privateFilePath;
          user = username;
          mountOptions = [
          ];
        };
      }
      // (lib.optionalAttrs (myEnv.location == "home" && myEnv.configSession != "homeServer") {
        home-server = {
          authType = "publickey";
          host = secrets.nodes.homeServer.localIp;
          mountPoint = "/";
          sshKey = secrets.ssh."163".privateFilePath;
          user = username;
          mountOptions = [
          ];
        };
      })
      // (lib.optionalAttrs (myEnv.location == "uni") {
        uni-cluster = {
          authType = "publickey";
          host = secrets.nodes.uniCluster.localIp;
          mountPoint = "/";
          sshKey = secrets.ssh.uni.privateFilePath;
          user = "bai";
          mountOptions = [
          ];
        };
      });
    };
  };
}
