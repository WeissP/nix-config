{
  pkgs,
  myEnv,
  configSession,
  lib,
  ...
}:

with myEnv;
let
  em = "Exec=GTK_IM_MODULE= QT_IM_MODULE= XMODIFIERS= emacs";
  posixAliases = {
    redshiftDual = "redshift -m randr:crtc=0 -l 51.5:10.5 -t 6500:3300 -b 1:0.9 & redshift -m randr:crtc=1 -l 51.5:10.5 -t 6500:3300  -b 1:1 &";
    pre_beg = "dunstctl set-paused true && xscreensaver-command -exit &";
    pre_end = "dunstctl set-paused false && xscreensaver -no-splash &";
  };
  generalAliases = {
    inherit em;
    emacs = em;
    deploy = "nix run github:serokell/deploy-rs -- -s";
    switch =
      if (arch == "linux") then
        "sudo nixos-rebuild switch --flake ${homeDir}/nix-config#${configSession}"
      else
        "darwin-rebuild switch --flake ${homeDir}/nix-config#${configSession}";
    suspend = "sudo systemctl suspend";
    ns = "nix-shell";
    ec = ''emacsclient --create-frame --alternate-editor="${em}"'';
    cg = "cargo";
    emdbg = "${em} --debug-init";
    pyav = "getAvInfo.py";
    vpnon = "nmcli connection up wgtuk-Full-Desk";
    vpnoff = "nmcli connection down wgtuk-Full-Desk";
    dc = "docker container ";
    ka = "killall -9 ";
    hibernate = "systemctl hibernate";
    hybrid-sleep = "systemctl hybrid-sleep";
    edit = "emacsclient -c";
    mnt = "bb ${homeDir}/scripts/mount.clj";
    sf = "sqlfluff fix --config ${homeDir}/.config/sqlfluff/.sqlfluff ";
    sl = "sqlfluff lint --config ${homeDir}/.config/sqlfluff/.sqlfluff ";
    sfp = "sf --dialect postgres ";
  };
in
{
  programs.bash = {
    shellAliases = posixAliases // generalAliases;
  };
  programs.zsh = {
    shellAliases = posixAliases // generalAliases;
  };
  programs.nushell = {
    shellAliases = generalAliases;
  };
}
