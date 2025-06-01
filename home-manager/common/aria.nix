{
  myEnv,
  myLib,
  secrets,
  pkgs,
  lib,
  ...
}:
with myEnv;
let
  configDir = "${homeDir}/.config/aria2";
  downloadDir = "${homeDir}/Downloads/aria2";
  completedDir = "${homeDir}/Downloads/aria2/completed";
  videoDir = "/mnt/media/ssd1/videos/porn";
  logFile = "${configDir}/aria2.log";
  hooksLogFile = "${configDir}/aria2_hooks.log";
  sess = "${configDir}/aria2.sess";
  hooksDir = "${configDir}/hooks";
  onCompleteScript =
    let
      bins =
        with pkgs;
        myLib.mkNuBinPath [
          rsync
          gtrash
          additions.notify
        ];
      on_complete = builtins.path {
        name = "on_complete.nu";
        path = ./config_files/aria_hooks/on_complete.nu;
      };
    in
    pkgs.writers.writeNuBin "on-complete-final" ''
      def main [task_id: string, num_files: int, source_file: string] {
         with-env {
            Path:${bins} 
            DOWNLOAD: "${downloadDir}"
            COMPLETE: "${completedDir}"
            VIDEO_TARGET_DIR: "${videoDir}"
            LOG_FILE: "${hooksLogFile}"
         } {
            use ${scriptsDir}/logfile.nu
            logfile set-log-file ${hooksLogFile}
            logfile set-level info
            use ${on_complete}
            on_complete $task_id $num_files ($source_file | path expand)
         }
      }
    '';
  onCompleteScriptPath = "${onCompleteScript}/bin/on-complete-final";
in
{
  systemd.user.services.aria2 = myLib.service.startup {
    inherit (myEnv) username;
    binName = "aria2c";
  };
  home.file = {
    "${hooksDir}/aria_move.sh" = {
      source = ./config_files/aria_hooks/aria_move.sh;
      executable = true;
    };
    "${hooksDir}/on_complete.nu" = {
      source = ./config_files/aria_hooks/on_complete.nu;
      executable = true;
    };
    "${hooksDir}/move_videos.nu" = {
      source = ./config_files/aria_hooks/move_videos.nu;
      executable = true;
    };
  };
  programs.aria2 = {
    enable = true;
    settings = {
      dir = "${downloadDir}";
      rpc-secret =
        if builtins.hasAttr "password" secrets.nodes."${configSession}" then
          secrets.nodes."${configSession}".password.raw
        else
          "aria";
      input-file = sess;
      on-download-complete = onCompleteScriptPath;
      save-session = sess;
      save-session-interval = 60;
      max-concurrent-downloads = 15;
      continue = true;
      max-overall-download-limit = 0;
      max-download-limit = 0;
      quiet = true;
      allow-overwrite = true;
      allow-piece-length-change = true;
      always-resume = true;
      async-dns = false;
      auto-file-renaming = true;
      content-disposition-default-utf8 = true;
      disk-cache = "64M";
      file-allocation = "falloc";
      no-file-allocation-limit = "8M";
      console-log-level = "notice";
      log-level = "warn";
      log = "${logFile}";
      enable-rpc = true;
      rpc-allow-origin-all = true;
      rpc-listen-all = true;
      max-connection-per-server = 16;
      min-split-size = "8M";
      split = 32;
      user-agent = "Transmission/2.77";
      listen-port = "50101-50109";
      seed-ratio = 0.1;
      seed-time = 0;
      enable-dht = true;
      enable-dht6 = true;
      dht-listen-port = "50101-50109";
      dht-entry-point = "dht.transmissionbt.com:6881";
      dht-entry-point6 = "dht.transmissionbt.com:6881";
      dht-file-path = "${configDir}/dht.dat";
      dht-file-path6 = "${configDir}/dht6.dat";
      enable-peer-exchange = true;
      peer-id-prefix = "-TR2770-";
      peer-agent = "Transmission/2.77";
      bt-tracker = "udp://tracker.coppersurfer.tk:6969/announce,udp://tracker.leechers-paradise.org:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://9.rarbg.to:2710/announce,udp://exodus.desync.com:6969/announce,udp://tracker.openbittorrent.com:80/announce,udp://tracker.tiny-vps.com:6969/announce,udp://retracker.lanta-net.ru:2710/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.cyberia.is:6969/announce,udp://torrentclub.tech:6969/announce,udp://open.stealth.si:80/announce,udp://denis.stalker.upeer.me:6969/announce,udp://tracker.moeking.me:6969/announce,udp://open.demonii.si:1337/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://tracker3.itzmx.com:6961/announce,udp://explodie.org:6969/announce,udp://valakas.rollo.dnsabr.com:2710/announce,udp://tracker.nyaa.uk:6969/announce,udp://tracker.iamhansen.xyz:2000/announce,udp://tracker.filepit.to:6969/announce,udp://tracker-udp.gbitt.info:80/announce,udp://retracker.netbynet.ru:2710/announce,udp://retracker.akado-ural.ru:80/announce,udp://opentor.org:2710/announce,udp://tracker.yoshi210.com:6969/announce,udp://tracker.filemail.com:6969/announce,udp://tracker.ds.is:6969/announce,udp://newtoncity.org:6969/announce,udp://bt2.archive.org:6969/announce,udp://bt1.archive.org:6969/announce,https://tracker.fastdownload.xyz:443/announce,https://opentracker.xyz:443/announce,https://opentracker.co:443/announce,http://tracker.bt4g.com:2095/announce,http://opentracker.xyz:80/announce,http://open.trackerlist.xyz:80/announce,http://h4.trakx.nibba.trade:80/announce,udp://xxxtor.com:2710/announce,udp://tracker.uw0.xyz:6969/announce,udp://tracker.tvunderground.org.ru:3218/announce,udp://tracker.nextrp.ru:6969/announce,udp://tracker.msm8916.com:6969/announce,udp://tracker.lelux.fi:6969/announce,udp://retracker.sevstar.net:2710/announce,udp://npserver.intranet.pw:4201/announce,https://tracker.nanoha.org:443/announce,https://tracker.hama3.net:443/announce,http://www.proxmox.com:6969/announce,http://tracker.tvunderground.org.ru:3218/announce,http://tracker.opentrackr.org:1337/announce,http://tracker.bz:80/announce,http://torrentclub.tech:6969/announce,http://t.nyaatracker.com:80/announce,http://retracker.sevstar.net:2710/announce,http://open.acgtracker.com:1096/announce,http://explodie.org:6969/announce,udp://tracker4.itzmx.com:2710/announce,udp://tracker2.itzmx.com:6961/announce,udp://tracker.swateam.org.uk:2710/announce,udp://tr.bangumi.moe:6969/announce,udp://qg.lorzl.gq:2710/announce,udp://chihaya.toss.li:9696/announce,https://tracker.vectahosting.eu:2053/announce,https://tracker.lelux.fi:443/announce,https://tracker.gbitt.info:443/announce,https://opentracker.acgnx.se:443/announce,http://www.loushao.net:8080/announce,http://vps02.net.orel.ru:80/announce,http://tracker4.itzmx.com:2710/announce,http://tracker3.itzmx.com:6961/announce,http://tracker2.itzmx.com:6961/announce,http://tracker1.itzmx.com:8080/announce,http://tracker01.loveapp.com:6789/announce,http://tracker.yoshi210.com:6969/announce,http://tracker.torrentyorg.pl:80/announce,http://tracker.lelux.fi:80/announce,http://tracker.gbitt.info:80/announce,http://tracker.frozen-layer.net:6969/announce,http://sukebei.tracker.wf:8888/announce,http://pow7.com:80/announce,http://opentracker.acgnx.se:80/announce,http://open.acgnxtracker.com:80/announce,http://newtoncity.org:6969/announce,http://mail2.zelenaya.net:80/announce,http://bt-tracker.gamexp.ru:2710/announce,http://acg.rip:6699/announce";
    };
  };
}
