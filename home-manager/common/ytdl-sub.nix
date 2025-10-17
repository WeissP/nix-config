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
  home.packages = with pkgs; [
    ytdl-sub-with-plugins
    yt-dlp
  ];

  services.my-ytdl-sub = {
    enable = true;
    package = pkgs.ytdl-sub-with-plugins;
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
          break_on_existing = true;
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
        "story" = {
          OnBootSec = "10min";
          OnUnitActiveSec = "1200min";
          subscriptions = {
            "__preset__" = {
              overrides = {
                story_directory = "${downloadDir}/评书";
              };
            };
            "Story Recent" = {
              "= 单田芳" = {
                "乱世枭雄" = "https://www.youtube.com/playlist?list=PLN0jJvX5PtyJsyugAV_NJTXjzgwqcrDF9";
              };
              "= 张少佐" = {
                "福尔摩斯" = "https://www.youtube.com/playlist?list=PLRF3a2ox5FQ7aMIEykSLQaBL9kNl9OKb_";
              };
            };
          };
          config = {
            configuration = genConfiguration "评书";
            presets = {
              "story" = {
                inherit throttle_protection ytdl_options;

                embed_thumbnail = true;

                output_options = {
                  output_directory = "{story_directory}";
                  file_name = "{audio_full_path}";
                  thumbnail_name = "";
                  maintain_download_archive = true;
                };

                format = "ba[ext=webm]/ba";

                audio_extract = {
                  codec = "best";
                };

                chapters = {
                  embed_chapters = true;
                };

                music_tags = {
                  artist = "{story_teller}";
                  title = "{title}";
                  date = "{upload_date_standardized}";
                };

                download = [
                  {
                    url = "{url}";
                    include_sibling_metadata = false;
                  }
                ];

                overrides = {
                  subscription_value = "";
                  url = "{subscription_value}";

                  subscription_indent_1 = "unknown story teller";
                  story_teller = "{subscription_indent_1}";
                  story_name = "{subscription_name}";

                  audio_file_name = "{title_sanitized}.{ext}";
                  audio_full_path = "{story_teller}/{story_name}/{audio_file_name}";
                };
              };
              "Story Whole" = {
                preset = [
                  "story"
                  "Chunk Downloads"
                ];
              };
              "Story Recent" = {
                preset = [
                  "story"
                  "Only Recent Archive"
                ];
              };
            };
          };
        };

        "podcasts" = {
          OnBootSec = "6min";
          OnUnitActiveSec = "60min";
          subscriptions = {
            "__preset__" = {
              overrides = {
                audio_directory = "${downloadDir}/podcasts";
                filter_duration_min_s = 15 * 60;
                chunk_max_downloads = 100;
                only_recent_date_range = "2weeks";
              };
            };
            "My Podcasts Recent | Filter Keywords" = {
              "= news" = {
                "LT視界" = "https://www.youtube.com/@ltshijie/videos";
                "老雷" = "https://www.youtube.com/@laolei/videos";
                "杰森視角" = "https://www.youtube.com/@jasonangle/videos";
                "~FearNation 世界苦茶" = {
                  url = "https://www.youtube.com/@flipradio_fearnation/videos";
                  cut_end_s = 30;
                  only_recent_date_range = "2months";
                  title_exclude_keywords = [ "LIVE" ];
                };
              };
            };
            "My Podcasts Archive" = {
              "= history" = {
                "曹操说" = "https://www.youtube.com/@libertas1984/videos";
                "秦川雁塔" = "https://www.youtube.com/@qinchuanyanta/videos";
                "李天豪" = "https://www.youtube.com/@leecehao/videos";
                "苏联兴亡史" = "https://www.youtube.com/playlist?list=PLT7am6WsbIg5C5vqpmsI4hu51wNwFZgrv";
                "~左为" = {
                  url = "https://www.youtube.com/@zuowei/videos";
                  cut_end_s = 20;
                };
                "~老梁" = {
                  url = "https://www.youtube.com/@laoliang1972/videos";
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
                  ffmpeg_post_process_args = ''-af areverse,atrim=start={cut_end_s},areverse,asetpts=PTS-STARTPTS,dynaudnorm=gausssize=99:targetrms=0.1,loudnorm=I=-29:tp=-2:LRA=6'';
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
                  audio_file_name = "{upload_date_standardized} - {title_sanitized}.opus";
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
        # "tv_show_recent" = {
        #   OnBootSec = "6min";
        #   OnUnitActiveSec = "300min";
        #   subscriptions = {
        #     "__preset__" = {
        #       overrides = {
        #         chunk_max_downloads = 30;
        #         tv_show_directory = "${downloadDir}/tv-shows";
        #       };
        #     };

        #     "My Jellyfin TV Show Recent" = {
        #       "= news | Filter Keywords | Filter Duration" = {
        #         "老雷" = "https://www.youtube.com/@laolei/videos";
        #         "老周" = "https://www.youtube.com/@laozhou77/videos";
        #         "~王志安" = {
        #           url = "https://www.youtube.com/@wangzhian/videos";
        #           title_exclude_keywords = [ "新闻特写" ];
        #           filter_duration_min_s = 20 * 60;
        #         };
        #       };
        #     };
        #     "My Jellyfin TV Show Recent" = {
        #       "= history" = {
        #         "二爷" = "https://www.youtube.com/@Tankman2020/videos";
        #         "柴静" = "https://www.youtube.com/@chaijing2023/videos";
        #         "李天豪" = "https://www.youtube.com/@leecehao/videos";
        #         "曹操说" = "https://www.youtube.com/@libertas1984/videos";
        #         "左为" = "https://www.youtube.com/@zuowei/videos";
        #         "苏联兴亡史" = "https://www.youtube.com/playlist?list=PLT7am6WsbIg5C5vqpmsI4hu51wNwFZgrv";
        #       };
        #     };
        #     "My Jellyfin TV Show base" = {
        #       "= police" = {
        #         "细细的蓝线11" = "https://space.bilibili.com/387087511/upload/video";
        #       };
        #       "= driving" = {
        #         "勒夫防御性驾驶" = "https://space.bilibili.com/1239561852";
        #       };
        #     };
        #   };
        #   config = {
        #     configuration = genConfiguration "tv_show";
        #     presets = {
        #       "My Jellyfin TV Show base" = {
        #         inherit ytdl_options;
        #         preset = [
        #           "Jellyfin TV Show by Date"
        #           "best_video_quality"
        #         ];
        #         embed_thumbnail = true;
        #         overrides = {
        #           # only_recent_date_range = "1weeks";
        #           episode_file_name = "{episode_date_standardized} - {file_title}";
        #           overrides = {

        #           };
        #         };
        #       };
        #       "Bilibili streaming" = {
        #         preset = [
        #           "My Jellyfin TV Show base"
        #           "Only Recent"
        #         ];
        #         overrides = {
        #           only_recent_date_range = "1week";
        #         };
        #       };
        #       "My Jellyfin TV Show throttle" = {
        #         inherit throttle_protection;
        #         preset = [
        #           "My Jellyfin TV Show base"
        #         ];
        #       };
        #       "My Jellyfin TV Show Archive" = {
        #         preset = [
        #           "My Jellyfin TV Show throttle"
        #           "Chunk Downloads"
        #         ];
        #       };
        #       "My Jellyfin TV Show Recent" = {
        #         preset = [
        #           "My Jellyfin TV Show throttle"
        #           "Only Recent Archive"
        #         ];
        #         overrides = {
        #           only_recent_date_range = "2months";
        #         };
        #       };
        #     };
        #   };
        # };
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
