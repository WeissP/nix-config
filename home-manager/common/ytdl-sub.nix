{
  inputs,
  outputs,
  lib,
  myEnv,
  config,
  secrets,
  pkgs,
  ...
}:
with myEnv;
{
  imports = [
    outputs.homeManagerModules.ytdlSub
  ];

  services.my-ytdl-sub = {
    enable = true;
    instances =
      let
        workDir = "${homeDir}/Downloads/ytdl-sub";
        downloadDir = "/mnt/media/ssd1/ytdl-sub";
        throttle_protection = {
          sleep_per_download_s = {
            min = 30;
            max = 60;
          };
          sleep_per_subscription_s = {
            min = 9.0;
            max = 15;
          };
        };
        ytdl_options = {
          cookiefile = "${homeDir}/cookies.txt";
          cachedir = "${workDir}/ytdl-cache";
          extractor_args.youtube.lang = [
            "zh-CN"
            "zh-TW"
            "en"
          ];
          sleep_interval_requests = 2;
        };
        genConfiguration = logDir: {
          ffmpeg_path = lib.getExe pkgs.ffmpeg;
          ffprobe_path = "${pkgs.ffmpeg}/bin/ffprobe";
          persist_logs.logs_directory = "${workDir}/${logDir}/logs";
          working_directory = workDir;
        };
      in
      {
        "tv_show_recent" = {
          OnBootSec = "6min";
          OnUnitActiveSec = "300min";
          subscriptions = {
            "__preset__" = {
              overrides = {
                tv_show_directory = "${downloadDir}/tv-shows";
              };
            };

            "My Jellyfin TV Show" = {
              "= news" = {
                "老雷" = "https://www.youtube.com/@laolei";
                "老周" = "https://www.youtube.com/@laozhou77";
                "二爷" = "https://www.youtube.com/@Tankman2020";
                "王志安 | Filter Keywords" = {
                  "王志安" = "https://www.youtube.com/@wangzhian";
                  title_include_keywords = [ "王局拍案" ];
                };
              };
              "= history" = {
                "李天豪" = "https://www.youtube.com/@leecehao";
                "曹操说" = "https://www.youtube.com/@libertas1984";
                "左为" = "https://www.youtube.com/@zuowei";
                # "苏联兴亡史" = "https://www.youtube.com/playlist?list=PLT7am6WsbIg5C5vqpmsI4hu51wNwFZgrv";
                # "二战历史系列" = "https://www.youtube.com/playlist?list=PLT7am6WsbIg5cw24_B-INvrNBOUw3yIbC";
              };
            };
          };
          config = {
            configuration = genConfiguration "tv_show_recent";
            presets = {
              "My Jellyfin TV Show" = {
                inherit throttle_protection ytdl_options;
                preset = [
                  "Jellyfin TV Show by Date"
                  "best_video_quality"
                  "Only Recent Archive"
                ];
                embed_thumbnail = true;
                overrides = {
                  only_recent_date_range = "1weeks";
                  episode_file_name = "{episode_date_standardized} - {file_title}";
                };
              };
            };
          };
        };
      };
  };
}
