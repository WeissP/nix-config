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
        downloadDir = "/media/ytdl-sub";
        throttle_protection = {
          sleep_per_download_s = {
            min = 60;
            max = 90;
          };
          sleep_per_subscription_s = {
            min = 9;
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
          sleep_interval_requests = 2.0;
        };
        genConfiguration = logDir: {
          ffmpeg_path = lib.getExe pkgs.ffmpeg;
          ffprobe_path = "${pkgs.ffmpeg}/bin/ffprobe";
          persist_logs.logs_directory = "${workDir}/${logDir}/logs";
          working_directory = workDir;
          file_name_max_bytes = 225;
        };
      in
      {
        "podcasts" = {
          OnBootSec = "6min";
          OnUnitActiveSec = "60min";
          subscriptions = {
            "__preset__" = {
              overrides = {
                audio_directory = "${downloadDir}/podcasts";
                filter_duration_min_s = 15 * 60;
                only_recent_date_range = "2weeks";
              };
            };
            "My Podcasts Recent | Filter Keywords" = {
              "= news" = {
                "LT視界" = "https://www.youtube.com/@ltshijie";
                "老雷" = "https://www.youtube.com/@laolei";
                "杰森視角" = "https://www.youtube.com/@jasonangle";
                "~FearNation 世界苦茶" = {
                  url = "https://www.youtube.com/@flipradio_fearnation";
                  cut_end_s = 30;
                  only_recent_date_range = "2months";
                  title_exclude_keywords = [ "LIVE" ];
                };
              };
            };
            "My Podcasts Archive" = {
              "= history" = {
                "曹操说" = "https://www.youtube.com/@libertas1984";
                "秦川雁塔" = "https://www.youtube.com/@qinchuanyanta";
                "李天豪" = "https://www.youtube.com/@leecehao";
                "苏联兴亡史" = "https://www.youtube.com/playlist?list=PLT7am6WsbIg5C5vqpmsI4hu51wNwFZgrv";
                "~左为" = {
                  url = "https://www.youtube.com/@zuowei";
                  cut_end_s = 20;
                };
                "~老梁" = {
                  url = "https://www.youtube.com/@laoliang1972";
                  cut_end_s = 10;
                };
              };
            };
          };
          config = {
            configuration = genConfiguration "subscribed_podcasts";
            presets = {
              "My Podcasts" = {
                inherit throttle_protection ytdl_options;

                preset = [
                  "Filter Duration"
                ];

                embed_thumbnail = true;

                output_options = {
                  output_directory = "{audio_directory}";
                  file_name = "{audio_full_path}";
                  thumbnail_name = "{thumbnail_path}";
                  maintain_download_archive = true;
                };

                format = "ba[ext=webm]/ba";

                file_convert = {
                  enable = true;
                  convert_to = "opus";
                  convert_with = "ffmpeg";
                  ffmpeg_post_process_args = ''-af areverse,atrim=start={cut_end_s},areverse,asetpts=PTS-STARTPTS,speechnorm=e=5:r=0.00005:l=1,loudnorm=I=-26:LRA=7:tp=-2'';
                };

                audio_extract = {
                  codec = "best";
                };

                chapters = {
                  embed_chapters = true;
                };

                music_tags = {
                  artist = "{channel}";
                  title = "{upload_date} - {title}";
                  date = "{upload_date_standardized}";
                  genre = "{podcast_genre}";
                  comments = "{description}";
                };

                download = [
                  {
                    url = "{url}";
                    include_sibling_metadata = false;
                  }
                ];

                overrides = {
                  podcast_genre_default = "Podcast";

                  # Indents to use default values
                  subscription_indent_1 = "{podcast_genre_default}";

                  podcast_genre = "{subscription_indent_1}";

                  # Subscription overrides
                  subscription_value = "";
                  url = "{subscription_value}";

                  # Path overrides
                  channel_dir = "{channel_sanitized}";
                  audio_file_dir = "{upload_date_standardized} - {%slice(title_sanitized, 0, 25)}";
                  audio_file_name = "{upload_date_standardized} - {title_sanitized}.{ext}";
                  audio_full_path = "{channel_dir}/{audio_file_dir}/{audio_file_name}";
                  thumbnail_path = "{channel_dir}/{audio_file_dir}/{upload_date_standardized} - {title_sanitized}.{thumbnail_ext}";
                  cut_end_s = 0;
                };
              };
              "My Podcasts Archive" = {
                preset = [
                  "My Podcasts"
                  "Only Recent Archive"
                  # "Chunk Downloads"
                ];
              };
              "My Podcasts Recent" = {
                preset = [
                  "My Podcasts"
                  "Only Recent"
                ];
              };
            };
          };
        };
        "tv_show_recent" = {
          OnBootSec = "6min";
          OnUnitActiveSec = "300min";
          subscriptions = {
            "__preset__" = {
              overrides = {
                chunk_max_downloads = 30;
                tv_show_directory = "${downloadDir}/tv-shows";
              };
            };

            "My Jellyfin TV Show" = {
              # "= news | Filter Keywords | Filter Duration" = {
              #   "老雷" = "https://www.youtube.com/@laolei";
              #   "老周" = "https://www.youtube.com/@laozhou77";
              #   "二爷" = "https://www.youtube.com/@Tankman2020";
              #   "~王志安" = {
              #     url = "https://www.youtube.com/@wangzhian";
              #     title_exclude_keywords = [ "新闻特写" ];
              #     filter_duration_min_s = 20 * 60;
              #   };
              # };
              # "= history" = {
              #   "李天豪" = "https://www.youtube.com/@leecehao";
              #   "曹操说" = "https://www.youtube.com/@libertas1984";
              #   "左为" = "https://www.youtube.com/@zuowei";
              #   "苏联兴亡史" = "https://www.youtube.com/playlist?list=PLT7am6WsbIg5C5vqpmsI4hu51wNwFZgrv";
              # };
              "= police" = {
                "细细的蓝线11" = "https://space.bilibili.com/387087511/upload/video";
              };
            };
          };
          config = {
            configuration = genConfiguration "tv_show";
            presets = {
              "My Jellyfin TV Show" = {
                inherit throttle_protection ytdl_options;
                preset = [
                  "Jellyfin TV Show by Date"
                  "best_video_quality"
                  "Chunk Downloads"
                  # "Only Recent Archive"
                ];
                embed_thumbnail = true;
                overrides = {
                  # only_recent_date_range = "1weeks";
                  episode_file_name = "{episode_date_standardized} - {file_title}";
                  overrides = {

                  };
                };
              };
            };
          };
        };
        "music" = {
          OnBootSec = "10min";
          OnUnitActiveSec = "600min";
          subscriptions = {
            "__preset__" = {
              overrides = {
                music_directory = "${downloadDir}/music";
              };
            };

            "My Misc Music" = {
              "= YoutubePlaylist" = {
                "youtube-music-favourite" =
                  "https://www.youtube.com/playlist?list=PL4Pdro5aClMGal3IfHzAbK6Lxyk4Kk9X_";
              };
              "= BilibiliPlaylist" = {
                "bilibili-music-favourite" = "https://space.bilibili.com/524658/favlist?fid=48003558&ftype=create";
              };
            };
            "My Release" = {
              "= folk" = {
                "Elle & Toni" = "https://www.youtube.com/@elleandtoni/releases";
              };
            };
          };
          config = {
            configuration = genConfiguration "music";
            presets = {
              "My Release" = {
                inherit throttle_protection ytdl_options;
                preset = [
                  "YouTube Releases"
                ];
                embed_thumbnail = true;
                overrides = {
                };
              };
              "My Misc Music" = {
                inherit throttle_protection ytdl_options;
                preset = [
                  "Single"
                ];
                embed_thumbnail = true;
                overrides = {
                  track_artist = "{channel}";
                  track_genre = "{subscription_name}";
                };
              };
            };
          };
        };
      };
  };
}
