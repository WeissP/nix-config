{
  config,
  myEnv,
  myLib,
  lib,
  pkgs,
  ...
}:
(myEnv.ifLinux {
  home.file."${myEnv.homeDir}/.xscreensaver".text = ''
    timeout:	0:30:00
    lock:		False
    visualID:	default 
    installColormap:    True
    verbose:	False
    splash:		True
    splashDuration:	0:00:05
    demoCommand:	xscreensaver-settings
    nice:		10
    fade:		True
    unfade:		True
    fadeSeconds:	0:00:03
    ignoreUninstalledPrograms:False
    dpmsEnabled:	False
    dpmsQuickOff:	False
    dpmsStandby:	2:00:00
    dpmsSuspend:	2:00:00
    dpmsOff:	4:00:00
    grabDesktopImages:  True
    grabVideoFrames:    False
    chooseRandomImages: False
    imageDirectory:	

    mode:		one
    selected:	0

    textMode:	url
    textLiteral:	XScreenSaver
    textFile:	
    textProgram:	fortune
    textURL:	https://en.wikipedia.org/w/index.php?title=Special:NewPages&feed=rss
    dialogTheme:	default
    settingsGeom:	5,35 -1,-1

    programs: ${pkgs.additions.gluqlo}/bin/gluqlo
  '';
  services.xscreensaver = {
    enable = true;
  };
})
