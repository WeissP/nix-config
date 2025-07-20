{
  pkgs,
  lib,
  myEnv,
  myLib,
  ...
}:
let
  downloadDir = "/media/yt-dlp-downloads";
  cfgDir = "${myEnv.homeDir}/.config/yt-dlp-downloads";
  channelAudiosDownloadDir = "${downloadDir}/channels/audios";
  channelCfgDir = "${cfgDir}/channels";
  musicDownloadDir = "${downloadDir}/music";
  musicCfgDir = "${cfgDir}/music";
  asmrDownloadDir = "${downloadDir}/asmr";
  asmrCfgDir = "${cfgDir}/asmr";
  logFile = ".output.log";
  archiveFile = "archive.log";
  ytDlp = pkgs.yt-dlp;
  checkYtDlpLog = (
    pkgs.additions.writeNuBinWithConfig "check-yt-dlp-log"
      {
        env.Path = with pkgs; myLib.mkNuBinPath [ additions.notify ];
      }
      ''
        export def main [yt_dlp_log_path: string] {
          if (open $yt_dlp_log_path --raw | str contains "Sign in to confirm you’re not a bot") {
             notify downloads "Your IP addresse might get blocked by YouTube" -t "Failed to download YouTube audios" -p 4
          }
        }
      ''
  );
  checkYtDlpLogPath = lib.getExe checkYtDlpLog;
in
{
  home = {
    packages = with pkgs.lts; [
      ytDlp
      ffmpeg
    ];
    file = {
      "${channelCfgDir}/channels_audios.txt" = {
        source = ./config_files/video_sources/channels_audios.txt;
      };
      "${channelCfgDir}/download_audios.sh" = {
        executable = true;
        text = ''
          #!${pkgs.stdenv.shell}
          set -e
          PATH=${
            lib.makeBinPath [
              pkgs.coreutils
              ytDlp
            ]
          }
          mkdir -p ${channelAudiosDownloadDir}
          pushd ${channelAudiosDownloadDir}
          yt-dlp --extractor-args youtubetab:skip=authcheck --dateafter today-4weeks --cookies /home/weiss/cookies.txt -I 0-100000 --match-filter "!is_live & !live" --break-per-input --break-on-existing --lazy-playlist --audio-format "mp3" --audio-quality 0 --verbose --force-ipv4 --sleep-requests 2 --sleep-interval 50 --max-sleep-interval 200 --ignore-errors --no-continue --no-overwrites --download-archive ${archiveFile} --add-metadata --parse-metadata "%(upload_date)s - %(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --embed-thumbnail --embed-chapters --extract-audio --check-formats --concurrent-fragments 3 --output "%(uploader)s - %(upload_date)s - %(title).20s [%(id)s].%(ext)s" --throttled-rate 100K --batch-file "${channelCfgDir}/channels_audios.txt" 2>&1 | tee ${logFile}
          ${checkYtDlpLogPath} ${logFile}
        '';
      };
      "${musicCfgDir}/source.txt" = {
        source = ./config_files/video_sources/music_playlists.txt;
      };
      "${musicCfgDir}/download_audios.sh" = {
        executable = true;
        text = ''
          #!${pkgs.stdenv.shell}
          set -e
          PATH=${
            lib.makeBinPath [
              pkgs.coreutils
              ytDlp
            ]
          }
          mkdir -p ${musicDownloadDir}
          pushd ${musicDownloadDir}
          yt-dlp --audio-format "mp3" --audio-quality 0 --no-check-certificate --extractor-args youtubetab:skip=authcheck --cookies /home/weiss/cookies.txt --format "(bestaudio[acodec^=opus]/bestaudio)/best" --verbose --force-ipv4 --sleep-requests 2 --sleep-interval 50 --max-sleep-interval 200 --ignore-errors --no-continue --no-overwrites --download-archive ${archiveFile} --add-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --write-description --write-info-json --write-annotations --write-thumbnail --embed-thumbnail --extract-audio --check-formats --concurrent-fragments 3 --match-filter "!is_live & !live" --output "%(playlist)s - (%(uploader)s)/%(upload_date)s - %(title)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s" --throttled-rate 100K --batch-file "${musicCfgDir}/source.txt" 2>&1 | tee ${logFile}
        '';
      };
      "${asmrCfgDir}/source.txt" = {
        source = ./config_files/video_sources/asmr.txt;
      };
      "${asmrCfgDir}/download_audios.sh" = {
        executable = true;
        text = ''
          #!${pkgs.stdenv.shell}
          set -e
          PATH=${
            lib.makeBinPath [
              pkgs.coreutils
              ytDlp
            ]
          }
          mkdir -p ${asmrDownloadDir}
          pushd ${asmrDownloadDir}
          yt-dlp --audio-format "mp3" --audio-quality 0 --no-check-certificate --extractor-args youtubetab:skip=authcheck --cookies /home/weiss/cookies.txt --break-per-input --break-on-existing --format "(bestaudio[acodec^=opus]/bestaudio)/best" --verbose --force-ipv4 --sleep-requests 2 --sleep-interval 50 --max-sleep-interval 200 --ignore-errors --no-continue --no-overwrites --download-archive ${archiveFile} --add-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --write-description --write-info-json --write-annotations --write-thumbnail --embed-thumbnail --extract-audio --check-formats --concurrent-fragments 3 --match-filter "!is_live & !live" --output "%(playlist)s - (%(uploader)s)/%(upload_date)s - %(title)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s" --throttled-rate 100K --batch-file "${asmrCfgDir}/source.txt" 2>&1 | tee ${logFile}
        '';
      };
    };
  };

  # systemd.user = {
  #   services."download-channels-audios" = {
  #     Unit.Description = "download channels audios";
  #     Service = {
  #       ExecStart = "${channelCfgDir}/download_audios.sh";
  #     };
  #   };
  #   timers."download-channels-audios" = {
  #     Unit.Description = "trigger download channels audios service";
  #     Timer = {
  #       OnBootSec = "3min";
  #       OnUnitActiveSec = "120min";
  #       Unit = "download-channels-audios.service";
  #     };
  #     Install = {
  #       WantedBy = [ "timers.target" ];
  #     };
  #   };
  #   timers."download-channels-audios-nightly" = {
  #     Unit.Description = "trigger download channels audios nightly at 21:30";
  #     Timer = {
  #       OnCalendar = "21:30";
  #       Unit = "download-channels-audios.service";
  #     };
  #     Install = {
  #       WantedBy = [ "timers.target" ];
  #     };
  #   };
  #   services."download-music" = {
  #     Unit.Description = "download music";
  #     Service = {
  #       ExecStart = "${musicCfgDir}/download_audios.sh";
  #     };
  #   };
  #   timers."download-music" = {
  #     Unit.Description = "trigger download youtube music service";
  #     Timer = {
  #       OnBootSec = "2min";
  #       OnUnitActiveSec = "240min";
  #       Unit = "download-music.service";
  #     };
  #     Install = {
  #       WantedBy = [ "timers.target" ];
  #     };
  #   };
  #   services."download-asmr" = {
  #     Unit.Description = "download asmr";
  #     Service = {
  #       ExecStart = "${asmrCfgDir}/download_audios.sh";
  #     };
  #   };
  #   timers."download-asmr" = {
  #     Unit.Description = "trigger download youtube asmr service";
  #     Timer = {
  #       OnBootSec = "15min";
  #       OnUnitActiveSec = "600min";
  #       Unit = "download-asmr.service";
  #     };
  #     Install = {
  #       WantedBy = [ "timers.target" ];
  #     };
  #   };
  # };
}
