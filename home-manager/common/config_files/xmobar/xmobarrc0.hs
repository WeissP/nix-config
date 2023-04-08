Config
  {
    font = "xft:FiraCode Nerd Font Mono:weight=bold:pixelsize=16",
    additionalFonts = ["xft: symbola:weight=bold:pixelsize=24", "xft:FiraCode Nerd Font Mono:weight=bold:pixelsize=16" ,"xft: Source Han Sans CN:weight=bold:pixelsize=17"],
    bgColor = "#2e3440",
    fgColor = "#d0d0d0",

    -- position = Static {xpos = 709, ypos = 1468, width = 1900, height = 24},
    persistent = True,
    hideOnStart = False,
    allDesktops = True,
    lowerOnStart = True,
    commands =
      [
        Run DynNetwork ["-t", "<fn=2>\xf0aa</fn> <tx>kb  <fn=2>\xf0ab</fn> <rx>kb"] 20,
        Run Cpu ["-t", "CPU:<bar>", "-H", "50", "--high", "red"] 20,
        Run Memory ["-t", "MEM:<usedbar>(<used>M)"] 20,
        Run DiskU [("/", "USED:<used> FREE:<free>")] [] 60,
        Run Date "<fc=#bd93f9> %H:%M </fc>" "date" 50
        -- Run XPropertyLog "_XMONAD_LOG_Hori"
      ],
    sepChar = "%",
    alignSep = "}{",
    template =
      " <fc=#98be65>%date%</fc>\
      \ <fc=#666666>|</fc>\
      \ <fc=#ecbe7b>%cpu%</fc> \
      \ <fc=#ecbe7b>%memory%</fc>\
      \ <fc=#666666>|</fc>\
      \ <fc=#51afef>%disku%</fc>\
      \ <fc=#666666>|</fc>\
      \ <fc=#98be65>%dynnetwork%</fc>\
      \ }{\
      \"
      -- \ <fn=3>%_XMONAD_LOG_Hori%</fn> \
  }
