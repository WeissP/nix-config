Config
  { font = "FiraCode Nerd Font Mono bold 13"
  , additionalFonts = ["symbola 14", "Source Han Sans CN bold 13"]
  , bgColor = "#2e3440"
  , fgColor = "#d0d0d0"
  , position = OnScreen 1 (TopH 30)
  , persistent = True
  , hideOnStart = False
  , allDesktops = False
  , lowerOnStart = True
  , commands =
      [ Run DynNetwork ["-t", "<fn=2>\xf0aa</fn> <tx>kb  <fn=2>\xf0ab</fn> <rx>kb"] 20
      , Run Cpu ["-t", "<bar>", "-H", "50", "--high", "red"] 20
      , Run
          MultiCoreTemp
          [ "-t"
          , "<maxpc>°C"
          , "--High"
          , "80"
          , "--high"
          , "red"
          ]
          20
      , Run Memory ["-t", "<usedbar>(<used>M)"] 20
      , Run DiskU [("/", "USED:<used> FREE:<free>")] [] 60
      , Run Date "<fc=#bd93f9> %H:%M </fc>" "date" 50
      , Run XPropertyLog "_XMONAD_LOG_Hori"
      , Run XPropertyLog "_XMONAD_LOG_workspace"
      ]
  , sepChar = "%"
  , alignSep = "}{"
  , template =
      " <fc=#98be65>%date%</fc>\
      \ <fc=#666666>|</fc>\
      \ <fc=#ecbe7b>CPU %cpu%(%multicoretemp%)</fc> \
      \ <fc=#ecbe7b>MEM %memory%</fc>\
      \ <fc=#666666>|</fc>\
      \ <fc=#51afef>%disku%</fc>\
      \ <fc=#666666>|</fc>\
      \ <fc=#98be65>%dynnetwork%</fc>\
      \ }{\
      \ <fn=2>%_XMONAD_LOG_workspace% </fn> \
      \"
  }
