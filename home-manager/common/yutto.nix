{

  inputs,
  outputs,
  myEnv,
  location,
  lib,
  config,
  pkgs,
  secrets,
  myLib,
  ...
}:
{
  home.packages = [ pkgs.yutto ];
  xdg.configFile."yutto/yutto.toml" = {
    source = (pkgs.formats.toml { }).generate "yutto" {
      basic = {
        inherit (secrets.bilibili) sessdata;
        dir = "/media/videos/bilibili";
        tmp_dir = "/tmp/yutto";
        vip_strict = false;
        login_strict = true;
        # download_interval = 60;
        subpath_template = "{title}/{pubdate} - {name}";
      };

      danmaku = {
        speed = 1.0;
        opacity = 0.65;
        display_region_ratio = 0.4;
        block_bottom = true;
        block_colorful = true;
        block_keyword_patterns = [
          "弹幕"
          "指挥"
          "表白"
          "早"
          "简单"
          "难"
          "当你看到"
          "剧透"
          "齐神"
          "有人"
          "没人"
          "休想"
          "承包"
          "不要忘记"
          "前"
          "第一"
          "课代表"
          "来世"
          "此生无悔"
          "kagari"
          "monster"
          "maya"
          "red"
          "blue"
          "rmb"
          "450"
          "bilibili"
          "fff"
          "结"
          "猜"
          "优酷"
          "优酷见"
          "新年快乐"
          "沙发"
          "新春"
          "来了"
          "来啦"
          "大门"
          "二刷"
          "三刷"
          "等于现在"
          "于现在"
          "品质生活方法论"
          "不喜欢.*可以"
          "小时候"
          "高能"
          "黑皮"
          "肤色"
          "黑人"
          "黑色"
          "皮肤"
          "黑狗"
          "正确"
          "错误"
          "元购"
          "黑"
          "颜色"
          "放假"
          "休假"
          "度假"
          "放.*血"
        ];
      };

      batch = {
        with_section = false;
      };
    };
  };
}
