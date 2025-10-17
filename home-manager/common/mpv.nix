{
  inputs,
  outputs,
  lib,
  myEnv,
  config,
  pkgs,
  myLib,
  ...
}:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs; [
      additions.mpv-bookmarker
      additions.mpv-thumbfast
      mpvScripts.mpris
      mpvScripts.uosc
    ];
    config = {
      osc = "no";
      osd-bar = "no";
      border = "no";
      osd-on-seek = "no";
      save-position-on-quit = "yes";
      gpu-api = "opengl";
      # stop-screensaver = "yes";
    };
    scriptOpts = {
      uosc = lib.mkForce {
        # based on https://github.com/itsmeipg/mpv-config/blob/main/portable_config/script-opts/uosc.conf
        timeline_style = "line";
        timeline_line_width = 2;
        timeline_size = 30;
        timeline_persistency = "";
        timeline_border = 0;
        timeline_step = 5;
        timeline_cache = true;
        progress = "never";
        progress_size = 2;
        progress_line_width = 20;
        controls = "command:menu:script-binding uosc/menu?Menu,gap,<stream>command:high_quality:script-binding quality_menu/video_formats_toggle?Stream quality,<has_many_edition>editions,<has_many_video>video,<has_many_audio>audio,<has_chapter>command:auto_stories:script-binding uosc/chapters#chapters>0?Chapters,subtitles,space,<!image>speed:1,gap,command:replay:no-osd ab-loop?A-B loop,loop-file,<has_playlist>loop-playlist,<!has_playlist>toggle:read_more:autoload@uosc?Autoload,shuffle,gap,command:history:script-binding memo-history?History,prev,items,next,gap,toggle:move_up:ontop?Ontop,fullscreen";
        controls_size = 35;
        controls_margin = 8;
        controls_spacing = 2;
        controls_persistency = "";
        volume = "left";
        volume_size = 37;
        volume_border = 1;
        volume_step = 2;
        volume_persistency = "";
        speed_step = 0.05;
        speed_step_is_factor = false;
        speed_persistency = "";
        menu_item_height = 35;
        menu_min_width = 360;
        menu_padding = 4;
        menu_type_to_search = true;
        top_bar = "no-border";
        top_bar_size = 40;
        top_bar_controls = "right";
        top_bar_alt_title_place = "toggle";
        top_bar_flash_on = "";
        top_bar_persistency = "";
        window_border_size = 2;
        autoload = false;
        shuffle = false;
        scale = 1;
        scale_fullscreen = 1;
        font_scale = 1;
        text_border = 1.2;
        border_radius = 4;
        color = "";
        opacity = "timeline=0.775,chapters=0.675,slider=0.775,speed=0,menu=0.775,submenu=0.675,title=0,tooltip=0.775,curtain=0,idle_indicator=0.675,audio_indicator=0.675,buffering_indicator=0.675,playlist_position=0.3";
        refine = "text_width";
        animation_duration = 100;
        click_threshold = 0;
        click_command = "cycle pause; script-binding uosc/flash-pause-indicator";
        flash_duration = 1000;
        proximity_in = 40;
        proximity_out = 120;
        font_bold = false;
        destination_time = "total";
        time_precision = 0;
        buffered_time_threshold = 0;
        autohide = false;
        pause_indicator = "flash";
        stream_quality_options = "4320,2160,1440,1080,720,480,360,240,144";
        video_types = "3g2,3gp,asf,avi,f4v,flv,h264,h265,m2ts,m4v,mkv,mov,mp4,mp4v,mpeg,mpg,ogm,ogv,rm,rmvb,ts,vob,webm,wmv,y4m";
        audio_types = "aac,ac3,aiff,ape,au,cue,dsf,dts,flac,m4a,mid,midi,mka,mp3,mp4a,oga,ogg,opus,spx,tak,tta,wav,weba,wma,wv";
        image_types = "apng,avif,bmp,gif,j2k,jp2,jfif,jpeg,jpg,jxl,mj2,png,svg,tga,tif,tiff,webp";
        subtitle_types = "aqt,ass,gsub,idx,jss,lrc,mks,pgs,pjs,psb,rt,sbv,slt,smi,sub,sup,srt,ssa,ssf,ttxt,txt,usf,vt,vtt";
        playlist_types = "m3u,m3u8,pls,url,cue";
        load_types = "video,audio,image";
        show_hidden_files = false;
        use_trash = false;
        adjust_osd_margins = true;
        chapter_ranges = "openings:ffffff30,endings:ffffff30,intros:ffffff30,outros:ffffff30,ads:ffffc030";
        chapter_range_patterns = "openings:オープニング;endings:エンディング";
        languages = "slang,en";
        disable_elements = "window_border,pause_indicator";
      };
    };
    bindings =
      let
        forwards = {
          f = 3;
          g = 8;
          r = 50;
          v = 600;
        };
        backwards = {
          s = 2;
          a = 6;
          w = 45;
          x = 500;
        };
      in
      myLib.mergeAttrList [
        (builtins.mapAttrs (key: value: "seek ${toString value} exact") forwards)
        (builtins.mapAttrs (key: value: "seek -${toString value} exact") backwards)
        {
          t = "show-progress";
          d = "add volume -5";
          e = "add volume 5";
          q = "quit";
          B = "script_message bookmarker-menu";
          b = "script_message bookmarker-quick-save";
          j = "multiply speed 1.1";
          k = "multiply speed 0.9";
          BS = "set speed 1.0";
          i = "add audio-delay -0.100";
          l = "add audio-delay 0.100";
          LEFT = "add sub-delay -0.1";
          RIGHT = "add sub-delay +0.1";
          HOME = "show-progress";
          END = "show-progress";
        }
      ];
  };
}
