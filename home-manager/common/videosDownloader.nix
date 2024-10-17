{
  pkgs,
  lib,
  myLib,
  myEnv,
  config,
  username,
  secrets,
  configSession,
  ...
}:
let
  # downloadDir = "/run/media/weiss/575b3fc0-13fc-4db2-bdd0-bbccb66f83b3/yt-dlp-downloads";
  downloadDir = "${myEnv.homeDir}/yt-dlp-downloads";
  cfgDir = "${myEnv.homeDir}/.config/yt-dlp-downloads";
  channelDownloadDir = "${downloadDir}/channels";
  channelVideosDownloadDir = "${downloadDir}/channels/videos";
  channelAudiosDownloadDir = "${downloadDir}/channels/audios";
  channelCfgDir = "${cfgDir}/channels";
  musicDownloadDir = "${downloadDir}/music";
  musicCfgDir = "${cfgDir}/music";
  ytDlp = pkgs.lts.yt-dlp;
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
      "${channelCfgDir}/channels_videos.txt" = {
        source = ./config_files/video_sources/channels_videos.txt;
      };
      "${channelCfgDir}/download_videos.sh" = {
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
          mkdir -p ${channelVideosDownloadDir}
          pushd ${channelVideosDownloadDir}
          yt-dlp --extractor-args youtubetab:skip=authcheck --cookies /home/weiss/cookies.txt --dateafter today-1weeks  --embed-thumbnail --embed-chapters --no-check-certificate --match-filter "duration > 600" -I 0-100 --break-per-input --break-on-existing --lazy-playlist --format "(bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp09.02][height>=4320][fps>30]/bestvideo[vcodec^=vp09.00][height>=4320][fps>30]/bestvideo[vcodec^=vp9][height>=4320][fps>30]/bestvideo[vcodec^=avc1][height>=4320][fps>30]/bestvideo[height>=4320][fps>30]/bestvideo[vcodec^=av01][height>=4320]/bestvideo[vcodec^=vp09.02][height>=4320]/bestvideo[vcodec^=vp09.00][height>=4320]/bestvideo[vcodec^=vp9][height>=4320]/bestvideo[vcodec^=avc1][height>=4320]/bestvideo[height>=4320]/bestvideo[vcodec^=av01][height>=2880][fps>30]/bestvideo[vcodec^=vp09.02][height>=2880][fps>30]/bestvideo[vcodec^=vp09.00][height>=2880][fps>30]/bestvideo[vcodec^=vp9][height>=2880][fps>30]/bestvideo[vcodec^=avc1][height>=2880][fps>30]/bestvideo[height>=2880][fps>30]/bestvideo[vcodec^=av01][height>=2880]/bestvideo[vcodec^=vp09.02][height>=2880]/bestvideo[vcodec^=vp09.00][height>=2880]/bestvideo[vcodec^=vp9][height>=2880]/bestvideo[vcodec^=avc1][height>=2880]/bestvideo[height>=2880]/bestvideo[vcodec^=av01][height>=2160][fps>30]/bestvideo[vcodec^=vp09.02][height>=2160][fps>30]/bestvideo[vcodec^=vp09.00][height>=2160][fps>30]/bestvideo[vcodec^=vp9][height>=2160][fps>30]/bestvideo[vcodec^=avc1][height>=2160][fps>30]/bestvideo[height>=2160][fps>30]/bestvideo[vcodec^=av01][height>=2160]/bestvideo[vcodec^=vp09.02][height>=2160]/bestvideo[vcodec^=vp09.00][height>=2160]/bestvideo[vcodec^=vp9][height>=2160]/bestvideo[vcodec^=avc1][height>=2160]/bestvideo[height>=2160]/bestvideo[vcodec^=av01][height>=1440][fps>30]/bestvideo[vcodec^=vp09.02][height>=1440][fps>30]/bestvideo[vcodec^=vp09.00][height>=1440][fps>30]/bestvideo[vcodec^=vp9][height>=1440][fps>30]/bestvideo[vcodec^=avc1][height>=1440][fps>30]/bestvideo[height>=1440][fps>30]/bestvideo[vcodec^=av01][height>=1440]/bestvideo[vcodec^=vp09.02][height>=1440]/bestvideo[vcodec^=vp09.00][height>=1440]/bestvideo[vcodec^=vp9][height>=1440]/bestvideo[vcodec^=avc1][height>=1440]/bestvideo[height>=1440]/bestvideo[vcodec^=av01][height>=1080][fps>30]/bestvideo[vcodec^=vp09.02][height>=1080][fps>30]/bestvideo[vcodec^=vp09.00][height>=1080][fps>30]/bestvideo[vcodec^=vp9][height>=1080][fps>30]/bestvideo[vcodec^=avc1][height>=1080][fps>30]/bestvideo[height>=1080][fps>30]/bestvideo[vcodec^=av01][height>=1080]/bestvideo[vcodec^=vp09.02][height>=1080]/bestvideo[vcodec^=vp09.00][height>=1080]/bestvideo[vcodec^=vp9][height>=1080]/bestvideo[vcodec^=avc1][height>=1080]/bestvideo[height>=1080]/bestvideo[vcodec^=av01][height>=720][fps>30]/bestvideo[vcodec^=vp09.02][height>=720][fps>30]/bestvideo[vcodec^=vp09.00][height>=720][fps>30]/bestvideo[vcodec^=vp9][height>=720][fps>30]/bestvideo[vcodec^=avc1][height>=720][fps>30]/bestvideo[height>=720][fps>30]/bestvideo[vcodec^=av01][height>=720]/bestvideo[vcodec^=vp09.02][height>=720]/bestvideo[vcodec^=vp09.00][height>=720]/bestvideo[vcodec^=vp9][height>=720]/bestvideo[vcodec^=avc1][height>=720]/bestvideo[height>=720]/bestvideo[vcodec^=av01][height>=480][fps>30]/bestvideo[vcodec^=vp09.02][height>=480][fps>30]/bestvideo[vcodec^=vp09.00][height>=480][fps>30]/bestvideo[vcodec^=vp9][height>=480][fps>30]/bestvideo[vcodec^=avc1][height>=480][fps>30]/bestvideo[height>=480][fps>30]/bestvideo[vcodec^=av01][height>=480]/bestvideo[vcodec^=vp09.02][height>=480]/bestvideo[vcodec^=vp09.00][height>=480]/bestvideo[vcodec^=vp9][height>=480]/bestvideo[vcodec^=avc1][height>=480]/bestvideo[height>=480]/bestvideo[vcodec^=av01][height>=360][fps>30]/bestvideo[vcodec^=vp09.02][height>=360][fps>30]/bestvideo[vcodec^=vp09.00][height>=360][fps>30]/bestvideo[vcodec^=vp9][height>=360][fps>30]/bestvideo[vcodec^=avc1][height>=360][fps>30]/bestvideo[height>=360][fps>30]/bestvideo[vcodec^=av01][height>=360]/bestvideo[vcodec^=vp09.02][height>=360]/bestvideo[vcodec^=vp09.00][height>=360]/bestvideo[vcodec^=vp9][height>=360]/bestvideo[vcodec^=avc1][height>=360]/bestvideo[height>=360]/bestvideo[vcodec^=avc1][height>=240][fps>30]/bestvideo[vcodec^=av01][height>=240][fps>30]/bestvideo[vcodec^=vp09.02][height>=240][fps>30]/bestvideo[vcodec^=vp09.00][height>=240][fps>30]/bestvideo[vcodec^=vp9][height>=240][fps>30]/bestvideo[height>=240][fps>30]/bestvideo[vcodec^=avc1][height>=240]/bestvideo[vcodec^=av01][height>=240]/bestvideo[vcodec^=vp09.02][height>=240]/bestvideo[vcodec^=vp09.00][height>=240]/bestvideo[vcodec^=vp9][height>=240]/bestvideo[height>=240]/bestvideo[vcodec^=avc1][height>=144][fps>30]/bestvideo[vcodec^=av01][height>=144][fps>30]/bestvideo[vcodec^=vp09.02][height>=144][fps>30]/bestvideo[vcodec^=vp09.00][height>=144][fps>30]/bestvideo[vcodec^=vp9][height>=144][fps>30]/bestvideo[height>=144][fps>30]/bestvideo[vcodec^=avc1][height>=144]/bestvideo[vcodec^=av01][height>=144]/bestvideo[vcodec^=vp09.02][height>=144]/bestvideo[vcodec^=vp09.00][height>=144]/bestvideo[vcodec^=vp9][height>=144]/bestvideo[height>=144]/bestvideo)+(bestaudio[acodec^=opus]/bestaudio)/best" --verbose --force-ipv4 --ignore-errors --no-continue --no-overwrites --download-archive archive.log --add-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --all-subs --embed-subs --check-formats --concurrent-fragments 3 --output "%(uploader)s - %(upload_date)s - %(title).20s [%(id)s].%(ext)s" --merge-output-format "mkv" --throttled-rate 100K --batch-file "${channelCfgDir}/channels_videos.txt" 2>&1 | tee output.log
        '';
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
          yt-dlp --extractor-args youtubetab:skip=authcheck --cookies /home/weiss/cookies.txt --dateafter today-1weeks -I 0-100 --match-filter "!is_live & !live" --break-per-input --break-on-existing --lazy-playlist --audio-format "mp3" --audio-quality 0 --verbose --force-ipv4 --sleep-requests 1 --sleep-interval 5 --max-sleep-interval 30 --ignore-errors --no-continue --no-overwrites --download-archive archive.log --add-metadata --parse-metadata "%(upload_date)s - %(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --embed-thumbnail --embed-chapters --extract-audio --check-formats --concurrent-fragments 3 --output "%(uploader)s - %(upload_date)s - %(title).20s [%(id)s].%(ext)s" --throttled-rate 100K --batch-file "${channelCfgDir}/channels_audios.txt" 2>&1 | tee output.log
        '';
      };
      "${musicCfgDir}/source.txt" = {
        source = ./config_files/video_sources/music_playlists.txt;
      };
      "${musicCfgDir}/download.sh" = {
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
          yt-dlp --audio-format "mp3" --audio-quality 0 --no-check-certificate --extractor-args youtubetab:skip=authcheck --cookies /home/weiss/cookies.txt --format "(bestaudio[acodec^=opus]/bestaudio)/best" --verbose --force-ipv4 --sleep-requests 1 --sleep-interval 5 --max-sleep-interval 30 --ignore-errors --no-continue --no-overwrites --download-archive archive.log --add-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --write-description --write-info-json --write-annotations --write-thumbnail --embed-thumbnail --extract-audio --check-formats --concurrent-fragments 3 --match-filter "!is_live & !live" --output "%(playlist)s - (%(uploader)s)/%(upload_date)s - %(title)s/%(upload_date)s - %(title)s [%(id)s].%(ext)s" --throttled-rate 100K --batch-file "${musicCfgDir}/source.txt" 2>&1 | tee output.log
        '';
      };
    };
  };

  systemd.user = {
    services."download-channels-videos" = {
      Unit.Description = "download channels videos";
      Service = {
        ExecStart = "${channelCfgDir}/download_videos.sh";
      };
    };
    timers."download-channels-videos" = {
      Unit.Description = "trigger download channels videos service";
      Timer = {
        OnCalendar = [
          "*-*-* 03:30:00 Europe/Berlin"
          "*-*-* 12:30:00 Europe/Berlin"
          "*-*-* 13:00:00 Europe/Berlin"
          "*-*-* 13:30:00 Europe/Berlin"
          "*-*-* 14:01:00 Europe/Berlin"
          "*-*-* 14:05:00 Europe/Berlin"
          "*-*-* 14:10:00 Europe/Berlin"
        ];
        Unit = "download-channels-videos.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
    services."download-channels-audios" = {
      Unit.Description = "download channels audios";
      Service = {
        ExecStart = "${channelCfgDir}/download_audios.sh";
      };
    };
    timers."download-channels-audios" = {
      Unit.Description = "trigger download channels audios service";
      Timer = {
        OnBootSec = "3min";
        OnUnitActiveSec = "10min";
        Unit = "download-channels-audios.service";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
    # services."download-music" = {
    #   Unit.Description = "download music";
    #   Service = {
    #     ExecStart = "${musicCfgDir}/download.sh";
    #   };
    # };
    # timers."download-music" = {
    #   Unit.Description = "trigger download youtube music service";
    #   Timer = {
    #     OnBootSec = "3min";
    #     OnUnitActiveSec = "120min";
    #     Unit = "download-music.service";
    #   };
    #   Install = {
    #     WantedBy = [ "timers.target" ];
    #   };
    # };
  };
}
