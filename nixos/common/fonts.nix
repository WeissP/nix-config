{
  pkgs,
  lib,
  myLib,
  myEnv,
  secrets,
  config,
  inputs,
  outputs,
  ...
}:
with myEnv;
{
  fonts = lib.mkMerge [
    {
      fontDir.enable = true;
      packages =
        with pkgs;
        let
          mkFont = callPackage myLib.mkFont { };
        in
        [
          mplus-outline-fonts.githubRelease
          (mkFont "florencesans-sc" "florencesans-sc.zip")
          (mkFont "monolisa" "monolisa.zip")
          route159
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-emoji
          stix-two
          liberation_ttf
          fira-code
          fira-code-symbols
          nerd-fonts.fira-code
          mplus-outline-fonts.githubRelease
          dina-font
          source-code-pro
          source-han-sans
          source-han-serif
          lato
          jetbrains-mono
          cascadia-code
          sarasa-gothic
          emacs-all-the-icons-fonts
          wqy_microhei
          wqy_zenhei
        ];
    }
    (ifLinux {
      fontconfig = {
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Noto Sans Mono CJK SC"
            "Sarasa Mono SC"
            "DejaVu Sans Mono"
          ];
          sansSerif = [
            "Noto Sans CJK SC"
            "Source Han Sans SC"
            "DejaVu Sans"
          ];
          serif = [
            "Noto Serif CJK SC"
            "Source Han Serif SC"
            "DejaVu Serif"
          ];
        };
      };
    })
  ];
}
