Config
  {
    font = "FiraCode Nerd Font Mono bold 13",
    additionalFonts = ["symbola 14", "Source Han Sans CN bold 12"],
    bgColor = "#2e3440",
    fgColor = "#d0d0d0",
    position = TopH 30,
    -- position = TopSize L 450 30,
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
    [ Run Date "%a %e.%m.%Y <fc=#bd93f9>%H:%M</fc>" "date" 50,
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
          18000
    ],
    template = " <fc=#98be65>%date%</fc>\
               \ <fc=#666666>|</fc>\
               \ <fc=#51afef>%EDFM%</fc>"
    -- commands = [Run XMonadLog],
    -- template = "%_XMONAD_LOG_Vertical%"
  }
