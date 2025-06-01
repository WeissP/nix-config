{ pkgs, ... }:
{
  stylix = {
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/danqing-light.yaml";
    autoEnable = false;
    fonts = { 
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif CJK SC";
      };

      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK SC";
      };

      monospace = {
        # No need for patched nerd fonts, kitty can pick up on them automatically,
        # and ideally every program should do that: https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
