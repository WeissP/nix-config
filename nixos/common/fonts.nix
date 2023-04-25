{ pkgs, lib, myLib, myEnv, secrets, config, inputs, outputs, ... }:
with myEnv;
let
  commonFonts = [
    "route159"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    {
      linux = pkgs.liberation_ttf;
      darwin = "liberation";
    }
    "fira-code"
    "fira-code-symbols"
    "dina-font"
    "source-code-pro"
    "source-han-sans"
    "source-han-serif"
    "lato"
    "jetbrains-mono"
    "cascadia-code"
    "sarasa-gothic"
  ];
in lib.mkMerge [
  (ifLinux {
    fonts = {
      fonts = with pkgs;
        [
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
          mplus-outline-fonts.githubRelease
          emacs-all-the-icons-fonts
          liberation_ttf
        ] ++ (map (font:
          if (builtins.typeOf font == "string") then
            (lib.attrsets.getAttrFromPath [ font ] pkgs)
          else
            font.linux) commonFonts);
      fontDir.enable = true;
      fontconfig = {
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace =
            [ "Noto Sans Mono CJK SC" "Sarasa Mono SC" "DejaVu Sans Mono" ];
          sansSerif = [ "Noto Sans CJK SC" "Source Han Sans SC" "DejaVu Sans" ];
          serif = [ "Noto Serif CJK SC" "Source Han Serif SC" "DejaVu Serif" ];
        };
      };
    };

  })
  (ifDarwin {
    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
        mplus-outline-fonts.githubRelease
        emacs-all-the-icons-fonts
        liberation_ttf
      ];
    };

    # system.activationScripts.fonts.text = ''
    #         # Set up fonts.
    #   echo "$systemConfig/Library/Fonts"
    # '';

    # homebrew = {
    #   enable = true;
    #   taps = [ "homebrew/cask-fonts" ];
    #   # casks = [ "font-liberation" ] map (font: "font-${font}") commonFonts;
    #   casks = map (font:
    #     if (builtins.typeOf font == "string") then
    #       "font-${font}"
    #     else
    #       "font-${font.darwin}") commonFonts;
    # };
  })
]

