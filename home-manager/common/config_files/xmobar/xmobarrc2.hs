Config
  { font = "xft:FiraCode Nerd Font Mono:weight=bold:pixelsize=16",
    bgColor = "#2e3440",
    fgColor = "#d0d0d0",
    position = Static {xpos = 709, ypos = 1492, width = 2000, height = 24},
    persistent = True,
    hideOnStart = False,
    allDesktops = False,
    lowerOnStart = True,
    commands =
      [ Run
          Weather
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
          36000,
        Run Date "%a %e.%m.%Y %H:%M " "date" 50
      ],
    sepChar = "%",
    alignSep = "}{",
    template =
      "<fc=#98be65>%date%</fc>\
      \ <fc=#666666>|</fc>\
      \ <fc=#51afef>%EDFM%</fc>\
      \"
  }
