Config
  {
    font = "xft: Source Han Sans CN:weight=bold:pixelsize=17",
    additionalFonts = ["xft:FiraCode Nerd Font Mono:weight=bold:pixelsize=16", "xft: symbola:weight=bold:pixelsize=24"],
    bgColor = "#2e3440",
    fgColor = "#d0d0d0",
    position = TopSize L 450 28,
    -- border = TopB,
    -- borderWidth = 20,
    persistent = True,
    hideOnStart = False,
    allDesktops = False,
    lowerOnStart = True,
    sepChar = "%",
    alignSep = "}{",
    -- commands = [Run StdinReader],
    -- template = "f%StdinReader%"
    commands =
    [ Run XPropertyLog "_XMONAD_LOG_Vertical",
      Run Date "%a %e.%m.%Y <fc=#bd93f9> %H:%M </fc> " "date" 50,
      Run Weather
          "EDFM"
          [ "--template",
            "<tempC>°C <weather>",
            "-L",
            "0",
            "-H",
            "25",
            "--low",
            "lightblue",
            "--normal",
            "#f8f8f2",
            "--high",
            "red"
          ]
          36000
    ],
    template = "%_XMONAD_LOG_Vertical%  \
               \  <fc=#666666>|</fc>  \
               \  <fc=#98be65>%date%</fc>  \
               \  <fc=#666666>|</fc>  \
               \  <fc=#51afef>%EDFM%</fc>"
    -- commands = [Run XMonadLog],
    -- template = "%_XMONAD_LOG_Vertical%"
  }
